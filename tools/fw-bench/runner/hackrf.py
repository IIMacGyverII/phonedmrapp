"""The HackRF: timed receive captures and transmissions, with the guards the Armor bench learned.

- A capture is started with `-n` and watched until the process is really running; a stalled or stuck
  `hackrf_transfer` is killed (a killed receive hangs in the USB driver and leaves transmit silently dead: the
  runner refuses to start while one is running).
- The first transmission after a pause is often silent: `dummy()` sends 0.4 s first.
- Never transmit while the HackRF hangs on the outdoor antenna (the runner cannot know; the operator does).
"""
import subprocess
import time
from pathlib import Path

import numpy as np


def running():
    r = subprocess.run(["tasklist", "/FI", "IMAGENAME eq hackrf_transfer.exe", "/NH"], capture_output=True, text=True)
    return "hackrf_transfer" in r.stdout.lower()


def kill():
    subprocess.run(["taskkill", "/F", "/IM", "hackrf_transfer.exe"], capture_output=True)
    time.sleep(1)
    return running()


class Capture:
    """A receive capture of `seconds` at the capture frequency; `wait()` returns the IQ path."""
    def __init__(self, cfg, name, seconds, lna, vga):
        if running():
            raise RuntimeError("hackrf_transfer already running; not starting a second one (power-cycle the HackRF if it is stuck)")
        self.cfg = cfg; self.seconds = seconds
        self.path = cfg.cap(name + ".iq")
        if self.path.exists():
            self.path.unlink()
        self.n = int(cfg.fs_iq * seconds)
        self.log = open(str(self.path) + ".hackrf.log", "w", encoding="utf-8")
        self.proc = subprocess.Popen([cfg.hackrf, "-r", str(self.path), "-f", str(cfg.capture_hz), "-s", str(cfg.fs_iq),
                                      "-l", str(lna), "-g", str(vga), "-n", str(self.n)], stdout=self.log, stderr=subprocess.STDOUT)
        t0 = time.time()
        while time.time() - t0 < 4:
            if self.proc.poll() is not None:
                self.log.close()
                raise RuntimeError("hackrf exited early: " + Path(str(self.path) + ".hackrf.log").read_text(encoding="utf-8", errors="replace")[-300:])
            if running():
                self.t0 = time.time()
                return
            time.sleep(0.05)
        self.proc.kill(); self.log.close()
        raise RuntimeError("hackrf did not start")

    def wait(self):
        try:
            self.proc.wait(timeout=self.seconds + 30)
        except subprocess.TimeoutExpired:
            self.proc.kill(); kill()
            self.log.close()
            raise RuntimeError("hackrf capture stalled")
        self.log.close()
        if running():
            kill()
        if not self.path.exists() or self.path.stat().st_size < self.n * 2 * 0.9:
            raise RuntimeError("capture short: %d bytes" % (self.path.stat().st_size if self.path.exists() else 0))
        return self.path


def fm_iq(fs, seconds, dev_hz, tone=None, f0=None, f1=None):
    """8-bit IQ of an FM carrier with a tone or a linear sweep, deviation dev_hz."""
    n = int(fs * seconds)
    t = np.arange(n) / fs
    if tone is not None:
        audio = np.sin(2 * np.pi * tone * t)
    elif f0 is not None:
        f = f0 + (f1 - f0) * (t / max(seconds, 1e-6))
        audio = np.sin(2 * np.pi * np.cumsum(f) / fs)
    else:
        audio = np.zeros(n)
    phase = 2 * np.pi * dev_hz * np.cumsum(audio) / fs
    z = np.exp(1j * phase)
    iq = np.empty(2 * n, np.int8)
    iq[0::2] = np.clip(np.round(z.real * 110), -127, 127).astype(np.int8)
    iq[1::2] = np.clip(np.round(z.imag * 110), -127, 127).astype(np.int8)
    return iq.tobytes(), n


def transmit(cfg, path, nsamp, fs, vga, seconds):
    """Transmit a cs8 file at the bench frequency and wait for it to finish; refuses while another process runs."""
    if running():
        raise RuntimeError("hackrf_transfer already running")
    log = open(str(path) + ".log", "w", encoding="utf-8")
    proc = subprocess.Popen([cfg.hackrf, "-t", str(path), "-f", str(cfg.freq_hz), "-s", str(fs), "-a", "0", "-x", str(vga), "-n", str(nsamp)],
                            stdout=log, stderr=subprocess.STDOUT)
    t0 = time.time()
    while time.time() - t0 < 3:
        if proc.poll() is not None:
            log.close()
            raise RuntimeError("hackrf tx exited early: " + Path(str(path) + ".log").read_text(encoding="utf-8", errors="replace")[-300:])
        if running():
            break
        time.sleep(0.05)
    else:
        proc.kill(); log.close()
        raise RuntimeError("hackrf tx did not start")
    try:
        proc.wait(timeout=seconds + 20)
    except subprocess.TimeoutExpired:
        proc.kill(); log.close(); kill()
        raise RuntimeError("hackrf tx stalled")
    log.close()
    if running():
        kill()
        raise RuntimeError("hackrf tx still running after its samples")


def dummy(cfg, fs=2_000_000, vga=0):
    """The first transmission after a pause is often silent: a 0.4 s 1 kHz burst first."""
    blob, n = fm_iq(fs, 0.4, 2500.0, tone=1000.0)
    p = cfg.cap("dummy.cs8"); p.write_bytes(blob)
    transmit(cfg, p, n, fs, vga, 0.4)
    time.sleep(0.3)
