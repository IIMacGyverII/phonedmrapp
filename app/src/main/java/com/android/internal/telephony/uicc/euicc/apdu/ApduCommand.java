package com.android.internal.telephony.uicc.euicc.apdu;

class ApduCommand {
    public final int channel;
    public final int cla;
    public final String cmdHex;
    public final int ins;
    public final int p1;
    public final int p2;
    public final int p3;

    ApduCommand(int i, int i2, int i3, int i4, int i5, int i6, String str) {
        this.channel = i;
        this.cla = i2;
        this.ins = i3;
        this.p1 = i4;
        this.p2 = i5;
        this.p3 = i6;
        this.cmdHex = str;
    }

    public String toString() {
        return "ApduCommand(channel=" + this.channel + ", cla=" + this.cla + ", ins=" + this.ins + ", p1=" + this.p1 + ", p2=" + this.p2 + ", p3=" + this.p3 + ", cmd=" + this.cmdHex + ")";
    }
}
