/*
 * SignalDeck - Copyright (C) 2026 IIMacGyverII
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Free software under the GNU General Public License v3 or later, with the additional terms in COPYRIGHT
 * (keep this notice and the author credit, mark modified versions, no rights to the SignalDeck name or icon).
 */
package com.macdmr.radio;

/**
 * The app's legal notices (GPL "Appropriate Legal Notices"): copyright, license, the section 7 terms in plain words,
 * where the source is, and the third-party credits. One text for the phone's Mission Statement sheet and SignalDeck
 * Web; the full wording is in COPYRIGHT and LICENSE at the repository root.
 */
public final class About {
    private About() { }

    public static final String SOURCE = "https://github.com/IIMacGyverII/phonedmrapp";

    public static String legal() {
        return "SignalDeck " + BuildConfig.VERSION_NAME + "\n"
                + "Copyright (C) 2026 IIMacGyverII\n\n"
                + "Free software: you may use, study, share and change it under the GNU General Public License, version 3 or later. "
                + "It comes with NO WARRANTY.\n\n"
                + "Additional terms (GPL section 7): keep the copyright notice and this author credit; mark a modified version as modified "
                + "and do not present it as the original SignalDeck or as the author's work; the license gives no rights to the name "
                + "“SignalDeck” or its icon, so a modified version needs its own name and icon.\n\n"
                + "Source code, official signed builds and the full license (LICENSE, COPYRIGHT): " + SOURCE + "\n\n"
                + "Built with: robot36 SSTV by Ahmet Inan (GPL v3); Vosk speech recognition and models, JNA, AndroidX and HiddenApiBypass "
                + "(Apache 2.0); Orbitron, Rajdhani and Share Tech Mono fonts (SIL OFL 1.1); US exam question pools (NCVEC, public domain). "
                + "Data: map tiles © OpenStreetMap contributors (ODbL), Terrain Tiles on AWS Open Data, RadioID.net, BrandMeister, "
                + "hearham.com, NetLogger, CelesTrak and AMSAT, ARISS.";
    }
}
