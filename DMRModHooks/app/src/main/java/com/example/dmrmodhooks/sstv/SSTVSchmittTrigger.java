/*
 * Derived from robot36 (https://github.com/xdsopl/robot36), Copyright (C) Ahmet Inan <xdsopl@gmail.com>,
 * licensed under the GNU General Public License v3.0 (see LICENSE at the repository root).
 * Ported to Java for DMRModHooks; the port and its modifications are likewise GPL-3.0-or-later.
 */
package com.example.dmrmodhooks.sstv;

/**
 * Schmitt trigger with hysteresis for noise-immune sync pulse detection
 * Based on robot36-2 implementation by Ahmet Inan
 */
public class SSTVSchmittTrigger {
    private final float lowThreshold;
    private final float highThreshold;
    private boolean previousState;

    public SSTVSchmittTrigger(float lowThreshold, float highThreshold) {
        this.lowThreshold = lowThreshold;
        this.highThreshold = highThreshold;
        this.previousState = false;
    }

    /**
     * Process input value and return latched state
     * - If currently high and input drops below low threshold → go low
     * - If currently low and input rises above high threshold → go high
     * - Otherwise maintain current state (hysteresis)
     */
    public boolean latch(float input) {
        if (previousState) {
            if (input < lowThreshold) {
                previousState = false;
            }
        } else {
            if (input > highThreshold) {
                previousState = true;
            }
        }
        return previousState;
    }
}
