# Bench results: DMR003.FW26.V022

| When | Test | Verdict | Key numbers | Armor reference |
|---|---|---|---|---|
| 2026-10-26T00:57:56 | boot | PASS silent | peak_dB 0.048, above10_s 0.0, clip 0.0, tag_after DMR003.FW26.V022 | peak under 0.1 dB, no run at or over 10 dB (FW14 onward) |
| 2026-10-26T00:58:26 | tone | PASS | carrier_s 10.549, clip 0.0, p99_Hz 2538.9, line1k_Hz 2445.8, slice_max_Hz 4031.7 | 10 s 1 kHz low power: carrier 10.8 s, body p99 about 2.8 kHz, 1 kHz line, no slice at 5 kHz |
| 2026-10-26T00:59:59 | stream | PASS 1125/1125 | frames 1125, good 1125, carrier_s 45.41, p99_Hz 2903.1, clip 0.0, end_bit True | 1125 of 1125 payload-exact, end bit, EOT, carrier 45.3 s, p99 about 2.9-3.0 kHz, clip 0 (FW20+) |
| 2026-10-26T01:06:51 | heat | PASS no stop | key_s 30, power 0, AP_before_C 47.467, AP_peak_C 48.493, AP_after_C 48.006, bat_before_C 39.5, bat_after_C 39.7 | 30 s low power: mtktsAP about +1 C, battery about +0.2 C; 45 s low power a small rise; no stop (battery 45 C, AP or modem-PA 60 C, +2 C in 10 s). The +11.3 C figure is the separate 120 s high-power key |
| 2026-10-26T01:10:54 | heat | PASS no stop | key_s 45, power 0, AP_before_C 47.871, AP_peak_C 49.047, AP_after_C 48.285, bat_before_C 39.7, bat_after_C 40.0 | 30 s low power: mtktsAP about +1 C, battery about +0.2 C; 45 s low power a small rise; no stop (battery 45 C, AP or modem-PA 60 C, +2 C in 10 s). The +11.3 C figure is the separate 120 s high-power key |
| 2026-10-26T01:11:30 | receive | PASS line | clip_dBFS -19.1, line_rel 1.49, samples 80000 | idle 0x32 about -108 dBm; a HackRF 1 kHz FM tone opens the squelch and shows a 1 kHz line in the clip |
| 2026-10-26T01:12:22 | boot | PASS silent | peak_dB 0.07, above10_s 0.0, clip 0.0, tag_after DMR003.FW26.V022 | peak under 0.1 dB, no run at or over 10 dB (FW14 onward) |
| 2026-10-26T01:12:45 | tone | PASS | carrier_s 10.529, clip 0.0, p99_Hz 2550.9, line1k_Hz 1956.1, slice_max_Hz 4044.1 | 10 s 1 kHz low power: carrier 10.8 s, body p99 about 2.8 kHz, 1 kHz line, no slice at 5 kHz |
| 2026-10-26T01:13:56 | stream | PASS 1125/1125 | frames 1125, good 1125, carrier_s 45.41, p99_Hz 2908.4, clip 0.0, end_bit True | 1125 of 1125 payload-exact, end bit, EOT, carrier 45.3 s, p99 about 2.9-3.0 kHz, clip 0 (FW20+) |
| 2026-10-26T01:14:19 | receive | PASS line | clip_dBFS -19.1, line_rel 1.49, samples 80000 | idle 0x32 about -108 dBm; a HackRF 1 kHz FM tone opens the squelch and shows a 1 kHz line in the clip |
| 2026-10-26T01:19:19 | heat | PASS no stop | key_s 45, power 0, AP_before_C 49.119, AP_peak_C 49.119, AP_after_C 48.215, bat_before_C 40.2, bat_after_C 40.2 | 30 s low power: mtktsAP about +1 C, battery about +0.2 C; 45 s low power a small rise; no stop (battery 45 C, AP or modem-PA 60 C, +2 C in 10 s). The +11.3 C figure is the separate 120 s high-power key |
