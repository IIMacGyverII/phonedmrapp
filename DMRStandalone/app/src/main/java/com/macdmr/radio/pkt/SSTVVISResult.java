/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio.pkt;

/**
 * Result from VIS detection containing the VIS code and sample offset
 */
public class SSTVVISResult {
    public final int visCode;
    public final int imageStartSample;  // Sample position where image data begins
    
    public SSTVVISResult(int visCode, int imageStartSample) {
        this.visCode = visCode;
        this.imageStartSample = imageStartSample;
    }
    
    public static SSTVVISResult notDetected() {
        return new SSTVVISResult(SSTVMode.MODE_UNKNOWN, 0);
    }
}
