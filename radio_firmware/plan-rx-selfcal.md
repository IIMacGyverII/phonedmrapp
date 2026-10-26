# Receive self-calibration

Design only. No image, no bench key, and no SignalDeck change in this step. FW25 showed that an idle playback inside the module does not come out of the phone, so the equaliser is fitted on a real reception. The bench pass that proves it comes after this design is reviewed.

## What is fitted

The held-path front end already in the app: 41 taps, 20 symbols each side of the symbol being estimated, applied to the matched-filter output before the sync search. The fit is the same least squares as `tools/m17-research/heldpath_eq.py`. The path is linear once the module is holding its voice filter open, so the taps are a fixed vector, not a decision-feedback equaliser, and not a new polynomial.

## Where the known symbols come from

A frame the phone has already decoded is re-encoded with SignalDeck's own M17 encoder. The link setup is used only when its CRC is good. A stream frame is used only when its Golay decode is clean, so the 16-byte payload that was recovered is the payload that was sent. Those bytes go back through the stream-frame builder and become the 192 symbols that were on the air. A clean Golay decode can still be a mis-correction, so the frame is a target only when those re-encoded symbols disagree with the receiver's sliced symbols on at most 5 percent of the 192 (9 symbols). Fewer than 20 accepted frames does not produce a fit: 41 taps need the 3840 rows that 20 frames give. A damaged frame is not a target. The station can be anyone: the hotspot in the cage, a HackRF transmission, or another phone.

## How the audio is lined up

The sync position is the one the receiver already found for that frame. As each accepted frame is kept, the raw matched-filter samples are saved with 20 symbols of context on each side (232 samples). The live receiver drops audio it has already handed on, so the fitter cannot go back to the microphone buffer. The saved windows are discarded when the call ends without a fit. Gain and offset come from the known symbols, then one least-squares solve produces the 41 taps. The solve runs after the call ends, not on the audio thread.

## First lock

A phone that has never fitted taps starts from the shipped per-model table (`assets/m17/held_<profileId>.txt`, the Armor table for this phone). That table is what lets the sync search lock before any fit exists. A profile with no shipped table stays on the decision-feedback receiver until a held-path fit has been accepted. The decision-feedback receiver is the fallback on stock firmware too, because that firmware cannot hold the voice filter open. A recording made on the decision-feedback path is a different channel and is not stored as held-path taps.

## When a fit is kept

One clean call is not enough to replace the taps the receiver is using. The new vector is stored as pending. The second call is scored by running both tap sets on the same recording of that call. The pending set has to lock the sync search by itself, and it has to come out with at least as many clean frames as the taps already in use. A fit made on a strong call is eligible only when that second call is at least 6 dB weaker, or from another station, so one loud station does not become the phone's calibration. The accepted file records the frame count, the date, and the meter reading of both calls. Until a second call passes, the receiver does not change.

## Where it is stored

One file per device profile, `files/m17/held_<profileId>.txt`, in the app's own files, with the frame count, the date and the two meter readings in `held_<profileId>.note`. It overrides the asset of the same name. A reset deletes both files and the pending vector, and the receiver goes back to the asset, or to the decision-feedback receiver when there is no asset. The file stays across an update. It is not written into a codeplug export.

## What the user sees

The line the M17 page already shows for the calibration says which set is in use: the shipped table, a fit waiting for a second call, or a fit this phone has accepted, with the number of frames the fit used. Hearing a clean call is the whole procedure. Long-pressing that line resets to the shipped table. There is no separate calibrate button and no new screen.

## Left for the review

The host change is the fitter, the pending file, the second-call check, and that one line. The bench pass is the two transmissions above, on the held path, with the Armor's shipped taps as the "before".
