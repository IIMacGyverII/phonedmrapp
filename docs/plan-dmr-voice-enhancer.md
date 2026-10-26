# Plan: neural voice enhancer for DMR (and narrow FM) receive

Owner direction 2026-10-26: low priority, worth exploring. Prompted by the M17 Project's Codec 2 neural enhancer
post (a FARGAN synthesizer fed the Codec 2 frame parameters at the receiver; same bitstream on the air, better
speech on the listener's side only). This plan is the DMR counterpart. Nothing here starts before the hotspot
rows, the receive-RAM stream and the promiscuous checks are done.

## 1. What is different about DMR on this radio

- The HR-C7000 decodes AMBE+2 in hardware. The phone never sees the vocoder bits, only 8 kHz PCM from the tiny
  service. A parameter-fed synthesizer (the M17 approach) is therefore not available unless a later firmware step
  taps the chip's receive burst buffer, which is its own research item and not assumed here.
- So the DMR enhancer is **PCM to PCM**: a small network takes the decoded 8 kHz audio and outputs cleaner,
  optionally wider (16 kHz) speech. Vocoded speech is a regular synthetic signal, so its artefacts are learnable.
- The same model, trained on the analog path too, would help narrow FM voice. The data for that is free once the
  bench loop exists (same loop, analog channel).
- **No software AMBE.** mbelib is not used anywhere in this plan (patent questions, and it is not needed). The
  training pairs come from the radios' own hardware vocoders.
- M17 is a separate item: integrate the M17 Project's enhancer when it ships (see `explore-later` notes); if we
  ever train our own for Codec 2, the Opus FARGAN training code (BSD) and the free Codec 2 encoder make that a
  pure PC job with no radio in the loop.

## 2. Compute: what GPU we need

**None to buy.** Three cards are available (owner, 2026-10-26), in the order to use them:

1. **NVIDIA RTX PRO 6000 Blackwell (96 GB), in a separate Windows box.** The training machine. CUDA on Windows
   is a first-class PyTorch target, so it stays on Windows (owner prefers it; Ubuntu not needed). Every training
   script and the Opus/FARGAN tooling run as written, no stack risk; 96 GB lets us train the wide (16 kHz) and adversarial
   variants with large batches and keep several experiments resident. Models in scope (FARGAN-class synthesizers,
   DeepFilterNet-class enhancers, 1–10 M parameters, tens of hours of speech) train on it in hours.
2. **RTX 4090 laptop (16 GB, CUDA), boots Ubuntu.** Enough for every model in this plan on its own, and the
   natural place for any Linux-only tooling; the fallback or a second
   experiment lane while the big card runs the main one.
3. **Radeon RX 7900 XTX (24 GB) in this bench PC.** Usable through AMD's official PyTorch-on-Windows wheels
   (ROCm 7.2 line, gfx1100), but the ROCm Windows stack is younger than CUDA and some scripts assume CUDA-only
   ops. Keep it for data preparation, evaluation and inference export, not for the training runs.

Where the data and the runs live: data collection happens on this bench PC (it owns the radios and adb); the
dataset is synced to the training machine (tens of GB at most); checkpoints and the exported C weights come back
here for the phone build. If the Blackwell card is in another machine, training runs over SSH like the cage box.

Phone inference is not GPU work: the Armor's CPU runs models of this size in real time (the Opus/FARGAN C
inference path is written for exactly that; DeepFilterNet runs on phones).

## 3. Phases

### Phase 0: compute check (host only, one hour)
1. On the RTX PRO 6000 machine: a current PyTorch CUDA build; confirm the device name and memory.
2. Train a toy 1-D conv + GRU model on random data for 100 steps; record step time at batch 32 × 1 s of 16 kHz
   audio. Anything under ~100 ms a step is fine (it will be far under on this card).
3. Confirm the path for moving the dataset there and the checkpoints back (SSH/rsync or a shared folder).
4. Write the numbers and the PyTorch version at the bottom of this file.

### Phase 1: data collection (bench, automated, needs the second phone)
Pairs of (clean speech, what the radio's receiver delivers). Two radios in the cage, both on SignalDeck.
1. Corpus: real recorded speech, not synthesized. Free, licensed corpora with many real speakers: LibriSpeech
   (~1000 h, ~2400 speakers, CC BY 4.0), VCTK (110 speakers, several accents, CC BY 4.0), Common Voice (CC0, many
   accents and microphones). We only pass 10–20 h of it through the radios (the bench runs at real time), chosen
   to spread speakers, sexes and accents. No text-to-speech for the training set: TTS output is too clean and too
   regular in prosody and would teach the model a few synthetic voices instead of real speech; at most it is an
   augmentation later. No owner recordings, nothing identifiable. Pre-process to 8 kHz for the transmit side; keep
   the 16 kHz original as the wide target.
2. Transmit: radio A injects the clean 8 kHz clip into its transmit path on a DMR simplex channel at low power
   (the inject path SignalDeck already has for test tones and SSTV), led by a sync chirp and a silence gap.
3. Receive: radio B records the decoded PCM (the REC path). Alignment by cross-correlating the chirp; trim; store
   the pair with the clip id. Reject pairs whose chirp is not found or whose length is off.
4. Repeat on an analog narrow-FM channel for the FM set (same clips, same loop).
5. Runs at real time, so 10–20 h of material is 10–20 h of bench. Batches of 25 s keys with the cool-down
   guard between them (the heat rules from the FW19 bench apply: stop at 60 °C AP / 45 °C battery, low power).
   Overnight runs, the cage closed, the HackRF untouched.
6. Data lives outside the repos (`D:\datasets\dmr-enhancer\`), with a manifest (clip id, mode, power, phone
   ids by profile, date). Only the scripts and the manifest format go into `tools/dmr-enhancer/`.
7. Also collect a small set of pairs with the HackRF adding a controlled weak signal (−100 … −110 dBm) so the
   model sees bit-error artefacts, not only clean vocoding.

### Phase 2: model (host)
1. Start small: a causal enhancer in the DeepFilterNet family (STFT-domain masking plus a deep filter,
   ~2 M parameters), 8 kHz in, 8 kHz out. Loss: multi-resolution STFT + spectral convergence. Metric: DNSMOS or
   ViSQOL against the clean reference, plus our own listening test.
2. Second step: a 16 kHz output head (bandwidth extension) trained against the 16 kHz originals. Keep the 8 kHz
   model if the wide one does not clearly win in listening.
3. Third step, optional: adversarial fine-tuning (the FARGAN recipe's last stage) for a less metallic output.
4. Train one model for DMR and one for FM, then try a single model with a mode input; keep whichever listens
   better.
5. Hold out speakers, not clips, for validation. Report numbers per mode in `docs/`.

### Phase 3: phone inference (SignalDeck)
1. Export to a C inference path: either the Opus `nnet` style (weights compiled in, no runtime dependency) or
   ONNX Runtime Mobile / TFLite. Prefer the compiled-in path for size and licence simplicity.
2. Build it in the existing NDK project beside Codec 2; a JNI call per 20 ms block. Budget: under 5 ms CPU per
   20 ms block on the Armor's big core, measured with the release build.
3. Insert after the receive PCM, before playback and the recorder; captions and the decoders keep the raw path.
4. UI: one toggle (Settings → Audio: Enhanced voice, off by default), with the in-app help section and the
   changelog row. Analog FM gets the same toggle if the FM model passes.

### Phase 4: evaluation
1. Blind A/B listening with the owner on recorded calls (raw vs enhanced, randomised order).
2. Objective scores on the held-out speakers.
3. Latency and battery: a 10-minute receive with the toggle on and off, CPU and temperature logged.
4. Ship only if the listening test prefers it and the budget holds.

## 4. How general the result is (owner question, 2026-10-26)

What the model learns is a stack of three things, and they travel differently:

1. **The vocoder.** AMBE+2 is the same codec in every DMR radio, so its artefacts are the same in kind everywhere.
   Encoders differ a little between implementations (the HR-C7000 in our radios, DVSI chips in Motorola, Hytera,
   Anytone and the hotspots' far ends), and on a repeater or network call the bits were made by the far radio's
   encoder, not ours. Expect this part to transfer well, with a small loss on encoders it never saw.
2. **The receiving phone's audio path.** The ES8311 converter, the tiny service and the module's filters are in
   every training pair. This part is specific to the phone model. Inside SignalDeck that is acceptable, because the
   model runs on the same family it was trained on; other models (Xplore 1, Atom XL, Armor 3WT) get their own data
   run with the same loop, or a table of models like the M17 equaliser taps.
3. **Everything the far end adds:** the speaker's microphone, room and background noise, and bit errors on the
   air. The corpus is clean read speech, so this is the part the plan must add on purpose.

So the software is general (PCM in, PCM out, any DMR audio source), the vocoder knowledge mostly carries, and the
audio-path knowledge is per phone model. To make the model as universal as the data allows:

- **Augment the transmit side:** mix noise and room responses into the clean clip before it is injected, at random
  levels, so the model sees vocoded noisy speech. Decide the target explicitly: the un-vocoded noisy clip (the model
  removes vocoder artefacts only) is the safe default; the clean clip (the model also denoises) is a second
  experiment, judged by listening.
- **Augment the receive side:** random gain, mild EQ tilt and resampling jitter on the recorded pair, so the model
  does not lock onto one converter's exact response. This is what lets one model serve nearby phone models.
- **Weak-signal pairs** (phase 1 step 7) cover bit-error artefacts.
- **A second encoder in the data** is the one thing only hardware can give. The second phone is the same family,
  so it adds a second receive path but not a second encoder. If a borrowed DVSI-based radio (any DMR handheld) is
  ever on the bench, a few hours of pairs from it is the cheapest way to widen the encoder coverage.
- **Judge on real traffic, never train on it:** the final listening test uses a few minutes of on-air DMR from
  other radios and from a repeater, through the phone, raw against enhanced. That is the generality test. Recorded
  on-air traffic stays out of the training set (consent and privacy).

## 5. Risks and limits
- The model learns this radio family's vocoder and audio path (ES8311, the FM audio filters). That is intended;
  other phone models get their own data runs later, the same loop.
- Speaker and language coverage of the corpus limit generalisation; use a varied corpus and hold out speakers.
- Bit errors at weak signal produce artefacts the clean-vocoded set does not cover; phase 1 step 7 addresses it.
- Training on the CUDA cards removes the ROCm risk; the 7900 XTX stays on preparation and evaluation.
- No training on the owner's voice or on recorded on-air traffic (consent and privacy); corpus only.

## 6. Order and ownership
Host work is Claude's; the bench loop runs under a phone lease like any other bench task. Starts after the
hotspot rows (item 5), the receive-RAM stream (R-C) and the promiscuous checks (item 10). Phase 0 can be done
any idle hour since it touches nothing on the bench.

## Phase 0 results
(not run yet)
