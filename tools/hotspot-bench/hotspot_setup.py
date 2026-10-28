#!/usr/bin/env python3
"""Apply the cage-bench configuration to a WPSD hotspot (run on the hotspot: sudo python3 hotspot_setup.py).

Idempotent. Each file is backed up once per run as <file>.bak-bench-<timestamp> before it is changed. Keys are set
inside their own [section]; a key missing from its section is added at the end of that section; every other line,
comment and section is left as it is. WPSD's configuration page rewrites /etc/mmdvmhost when it saves, so run this
again after any save there.

Bench identity only: callsign N0CALL, DMR ID 1234567. RF only: every network link goes to 127.0.0.1, where the
bench relay (m17relay.py) stands in for the gateways.
"""
import os, re, shutil, subprocess, sys, time

FREQ = "467625000"

MMDVMHOST = {
    "General": {"Callsign": "N0CALL", "Id": "1234567", "Duplex": "0"},
    "Info": {"RXFrequency": FREQ, "TXFrequency": FREQ},
    # RXOffset -450: on this board -300 to -600 Hz gave 0.0 % M17 BER (0 gave 6.5 %). RFLevel 20: cage bench.
    "Modem": {"RXOffset": "-450", "TXOffset": "0", "RFLevel": "20"},
    # Modes this bench uses. FM must stay off: this modem NAKs SET_FM_PARAMS2 and MMDVMHost stops.
    "D-Star": {"Enable": "0"}, "System Fusion": {"Enable": "0"}, "P25": {"Enable": "0"}, "NXDN": {"Enable": "0"},
    "FM": {"Enable": "0"},
    "DMR": {"Enable": "1", "SelfOnly": "0", "ColorCode": "1"},
    "DMR Network": {"Enable": "1", "Type": "Gateway", "RemoteAddress": "127.0.0.1", "RemotePort": "62031",
                    "LocalAddress": "127.0.0.1", "LocalPort": "62032"},
    # CAN 7 = SignalDeck's bench M17 channel; a receiver silently drops another CAN.
    "M17": {"Enable": "1", "SelfOnly": "0", "CAN": "7"},
    "M17 Network": {"Enable": "1"},
    "POCSAG": {"Enable": "1", "Frequency": FREQ},
    "POCSAG Network": {"Enable": "1"},
    "D-Star Network": {"Enable": "0"}, "System Fusion Network": {"Enable": "0"}, "P25 Network": {"Enable": "0"},
    "NXDN Network": {"Enable": "0"}, "FM Network": {"Enable": "0"},
}

DAPNETGATEWAY = {
    "General": {"Callsign": "N0CALL"},
    # The relay stands in for the DAPNET core. 14343 is outside the ephemeral range (with 43434 the gateway can
    # connect to itself). The stand-in does not check the key.
    "DAPNET": {"Address": "127.0.0.1", "Port": "14343", "AuthKey": "benchkey"},
}


def apply(path, wanted, stamp):
    if not os.path.exists(path):
        print(f"{path}: missing, skipped")
        return False
    lines = open(path, encoding="utf-8", errors="replace").read().splitlines()
    out, section, seen, changed = [], None, {}, []

    def flush_missing(sec):
        for k, v in wanted.get(sec, {}).items():
            if k not in seen.get(sec, set()):
                out.append(f"{k}={v}")
                changed.append(f"[{sec}] +{k}={v}")

    for line in lines:
        m = re.match(r"^\[(.+)\]\s*$", line)
        if m:
            if section is not None:
                flush_missing(section)
            section = m.group(1)
            seen.setdefault(section, set())
            out.append(line)
            continue
        km = re.match(r"^([A-Za-z0-9_]+)=(.*)$", line)
        if section in wanted and km and km.group(1) in wanted[section]:
            k, v = km.group(1), wanted[section][km.group(1)]
            seen[section].add(k)
            if km.group(2) != v:
                changed.append(f"[{section}] {k}: {km.group(2)} -> {v}")
            out.append(f"{k}={v}")
            continue
        out.append(line)
    if section is not None:
        flush_missing(section)
    for sec in wanted:
        if sec not in seen:
            print(f"{path}: section [{sec}] not present, not added")
    if changed:
        shutil.copy2(path, f"{path}.bak-bench-{stamp}")
        open(path, "w", encoding="utf-8").write("\n".join(out) + "\n")
    print(f"{path}: {len(changed)} change(s)")
    for c in changed:
        print("   ", c)
    return bool(changed)


def sh(cmd):
    r = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return (r.stdout + r.stderr).strip()


def main():
    if os.geteuid() != 0:
        sys.exit("run with sudo")
    stamp = time.strftime("%Y%m%d-%H%M%S")
    sh("rpi-rw")                                   # WPSD mounts root read-only on some images; harmless otherwise
    apply("/etc/mmdvmhost", MMDVMHOST, stamp)
    apply("/etc/dapnetgateway", DAPNETGATEWAY, stamp)
    # The relay takes the gateways' UDP ports, so the real gateways stay stopped.
    for svc in ("dmrgateway", "m17gateway"):
        print(svc, "stop/disable:", sh(f"systemctl stop {svc}.timer {svc}; systemctl disable {svc}.timer {svc} 2>&1 | tail -1") or "ok")
    print("mmdvmhost restart:", sh("systemctl restart mmdvmhost") or "ok")
    print("dapnetgateway restart:", sh("systemctl restart dapnetgateway") or "ok")


if __name__ == "__main__":
    main()
