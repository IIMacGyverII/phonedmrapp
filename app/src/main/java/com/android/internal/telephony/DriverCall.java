package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.telephony.PhoneNumberUtils;
import com.android.telephony.Rlog;

public class DriverCall implements Comparable<DriverCall> {
    public static final int AUDIO_QUALITY_AMR = 1;
    public static final int AUDIO_QUALITY_AMR_WB = 2;
    public static final int AUDIO_QUALITY_EVRC = 6;
    public static final int AUDIO_QUALITY_EVRC_B = 7;
    public static final int AUDIO_QUALITY_EVRC_NW = 9;
    public static final int AUDIO_QUALITY_EVRC_WB = 8;
    public static final int AUDIO_QUALITY_GSM_EFR = 3;
    public static final int AUDIO_QUALITY_GSM_FR = 4;
    public static final int AUDIO_QUALITY_GSM_HR = 5;
    public static final int AUDIO_QUALITY_UNSPECIFIED = 0;
    static final String LOG_TAG = "DriverCall";
    public int TOA;
    public int als;
    public int audioQuality = 0;
    public String forwardedNumber;
    @UnsupportedAppUsage
    public int index;
    @UnsupportedAppUsage
    public boolean isMT;
    public boolean isMpty;
    @UnsupportedAppUsage
    public boolean isVoice;
    public boolean isVoicePrivacy;
    @UnsupportedAppUsage
    public String name;
    public int namePresentation;
    @UnsupportedAppUsage
    public String number;
    @UnsupportedAppUsage
    public int numberPresentation;
    @UnsupportedAppUsage
    public State state;
    public UUSInfo uusInfo;

    @UnsupportedAppUsage(implicitMember = "values()[Lcom/android/internal/telephony/DriverCall$State;")
    public enum State {
        ACTIVE,
        HOLDING,
        DIALING,
        ALERTING,
        INCOMING,
        WAITING
    }

    static DriverCall fromCLCCLine(String str) {
        DriverCall driverCall = new DriverCall();
        ATResponseParser aTResponseParser = new ATResponseParser(str);
        try {
            driverCall.index = aTResponseParser.nextInt();
            driverCall.isMT = aTResponseParser.nextBoolean();
            driverCall.state = stateFromCLCC(aTResponseParser.nextInt());
            driverCall.isVoice = aTResponseParser.nextInt() == 0;
            driverCall.isMpty = aTResponseParser.nextBoolean();
            driverCall.numberPresentation = 1;
            if (aTResponseParser.hasMore()) {
                String extractNetworkPortionAlt = PhoneNumberUtils.extractNetworkPortionAlt(aTResponseParser.nextString());
                driverCall.number = extractNetworkPortionAlt;
                if (extractNetworkPortionAlt.length() == 0) {
                    driverCall.number = null;
                }
                int nextInt = aTResponseParser.nextInt();
                driverCall.TOA = nextInt;
                driverCall.number = PhoneNumberUtils.stringFromStringAndTOA(driverCall.number, nextInt);
            }
            return driverCall;
        } catch (ATParseEx unused) {
            Rlog.e(LOG_TAG, "Invalid CLCC line: '" + str + "'");
            return null;
        }
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("id=");
        sb.append(this.index);
        sb.append(",");
        sb.append(this.state);
        sb.append(",toa=");
        sb.append(this.TOA);
        sb.append(",");
        sb.append(this.isMpty ? "conf" : "norm");
        sb.append(",");
        sb.append(this.isMT ? "mt" : "mo");
        sb.append(",");
        sb.append(this.als);
        sb.append(",");
        sb.append(this.isVoice ? "voc" : "nonvoc");
        sb.append(",");
        sb.append(this.isVoicePrivacy ? "evp" : "noevp");
        sb.append(",,cli=");
        sb.append(this.numberPresentation);
        sb.append(",,");
        sb.append(this.namePresentation);
        sb.append(",audioQuality=");
        sb.append(this.audioQuality);
        return sb.toString();
    }

    public static State stateFromCLCC(int i) throws ATParseEx {
        if (i == 0) {
            return State.ACTIVE;
        }
        if (i == 1) {
            return State.HOLDING;
        }
        if (i == 2) {
            return State.DIALING;
        }
        if (i == 3) {
            return State.ALERTING;
        }
        if (i == 4) {
            return State.INCOMING;
        }
        if (i == 5) {
            return State.WAITING;
        }
        throw new ATParseEx("illegal call state " + i);
    }

    public static int presentationFromCLIP(int i) throws ATParseEx {
        if (i == 0) {
            return 1;
        }
        if (i == 1) {
            return 2;
        }
        if (i == 2) {
            return 3;
        }
        if (i == 3) {
            return 4;
        }
        throw new ATParseEx("illegal presentation " + i);
    }

    public int compareTo(DriverCall driverCall) {
        int i = this.index;
        int i2 = driverCall.index;
        if (i < i2) {
            return -1;
        }
        return i == i2 ? 0 : 1;
    }
}
