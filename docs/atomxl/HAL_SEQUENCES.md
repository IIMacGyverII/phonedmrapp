# Agold radio HAL: start, stop and audio sequences (Unihertz Atom XL)

Reference for SignalDeck's Agold path and for the next phone that uses the same HAL. Disassembled 2026-10-29 from the
bench Atom XL's `/vendor/bin/hw/vendor.mediatek.hardware.aguiextmodule@1.0-service` (42 464 bytes, AArch64) with the
NDK's `llvm-objdump`. Addresses are in that binary.

## The bridge driver's sysfs (`/sys/bus/platform/drivers/mcu/`)

The HAL writes attributes through a helper at `0x5748` (index, value) that formats `/sys/bus/platform/drivers/mcu/%s`.
Its name table at `0xa600` (relocations):

| Index | Attribute | Read back as |
|---|---|---|
| 0 | `mcu_power` | `power on = 0/1` |
| 1 | `handle_ptt` | `1` idle |
| 2 | `rstmcu` | `mode = 0/1` (0 = out of reset) |
| 3 | `usb_path` | `usb mode = 0/1` (1 = host mode for the bridge) |

The driver also has `call_in` (read-only) and a character device `/dev/stmcu`. Each read of `/dev/stmcu` returns the
driver's `call_in_flag`: **0 = reception started, 1 = reception ended**. The flag is set by the GPIO interrupt
`mcu-eint` (IRQ 20, edge-triggered; kernel log `mcu_eint_func data:0/1`).

## start_mcu (`0x66c0`)

1. `property_set("vendor.agui.extmodule.open", "1")`, `property_set("vendor.agui.extmodule.start", "0")`.
2. If the state is 2 (off):
   1. `usb_path` 1, `mcu_power` 1, `rstmcu` 0.
   2. Sleep 0.2 s. The state becomes 1.
3. While `/dev/ttyACM0` does not exist:
   1. `mcu_power` 0, `usb_path` 0, then sleep 0.5 s.
   2. `usb_path` 1, `mcu_power` 1, `rstmcu` 0, then sleep 0.2 s.
4. Sleep 50 ms, then check `/dev/snd/pcmC1D0p`. Sleep 50 ms, then check `/dev/snd/pcmC1D0c`.

## stop_mcu (`0x6828`)

1. Close the `/dev/stmcu` fd and the `/dev/ttyACM0` fd.
2. If the state is 1 (on):
   1. `mcu_power` 0, `usb_path` 0. The state becomes 2. Sleep 0.2 s.
   2. **On-pulse:** `usb_path` 1, `mcu_power` 1, `rstmcu` 0. Sleep 0.2 s.
   3. `mcu_power` 0, `usb_path` 0.
3. `property_set("vendor.agui.extmodule.open", "0")`.

SignalDeck's power-off (`AgoldUsb.POWER_OFF` / `RESET`) had no on-pulse as of 2026-10-29.

## PCM (`0x73f0`, called from `0x7a3c` playback and `0x7b40` capture)

The function opens `pcm_open(card 1, device 0, flags, &config)` with tinyalsa, after `pcm_params_get` checks.

- Playback: flags 0 (`PCM_OUT`), `/dev/snd/pcmC1D0p`.
- Capture: flags `0x10000000` (`PCM_IN`), `/dev/snd/pcmC1D0c`.
- Both use channels 2, rate 32000, 16 bits, **period 1280 frames, period count 4**.
- Once (a flag at `0xd344`), before the first open, it runs `system("echo 1 > /dev/ttyTTCMD")` ("audio codec power on").
  At close (`0x7ae0`, `0x7bc0`) it runs `echo 2 > /dev/ttyTTCMD` ("audio codec power off").

SignalDeck uses the same period settings since PR 92. Before that it used 1024 x 16, and the capture died for good after
its first drop-out. It does not use `ttyTTCMD`.

The stock app does not open ALSA itself. It calls the HAL's `readPcmDevice` (`IAguiExtModule`) and plays the result with
an `AudioTrack` at 32 kHz.

## The stuck reception line (reproduced 2026-10-29 12:53)

1. Kill SignalDeck while a reception holds the line (`force-stop` or a reinstall at the 4th second of a 12 s carrier).
2. Let it take the radio again.

From then on `mcu-eint` never fires: a full carrier gives 0 interrupts in `/proc/interrupts`, and only a phone reboot
clears it. The end-of-reception edge is never read after the kill. The last edges are the restart's power-up toggles
(`data:0` then `data:1`).

These did not stick it: three plain app restarts, and a bridge power-cycle (`restartmodule`) in the middle of a
reception. The power-cycle only confused SignalDeck: the next reception's start edge fell inside its 2 s "power-up
toggles" window and was ignored.
