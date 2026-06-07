# OpenGD77 CPS — PriInterPhone fork v2.0.25

**Date:** June 7, 2026

**Build:** `OpenGD77CPS-Mac_Build_20260607_175140.zip`

## F8/Studio post-import health section — full F7 parity

After Path B import, the F8 and Studio HTML report **Loaded codeplug health** section now lists every warning category from the full F7 report (compact, up to 8 items each):

- Duplicate contact names
- Empty zones
- Empty TG/Rx lists and invalid TG refs
- Empty scan lists and invalid scan refs
- TG list and scan list metric cards in the summary row

Post-import scroll-to-first-warning still uses the same priority order as F7.

`FORK_VERSION` = **2.0.25**