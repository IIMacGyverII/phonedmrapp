package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import com.android.internal.telephony.CallFailCause;
import com.android.internal.telephony.util.NetworkStackConstants;
import com.android.internal.telephony.util.TelephonyUtils;
import com.pri.prizeinterphone.InterPhoneService;

public class IccIoResult {
    private static final String UNKNOWN_ERROR = "unknown";
    @UnsupportedAppUsage
    public byte[] payload;
    @UnsupportedAppUsage
    public int sw1;
    @UnsupportedAppUsage
    public int sw2;

    private String getErrorString() {
        int i = this.sw1;
        if (i == 152) {
            int i2 = this.sw2;
            if (i2 == 2) {
                return "no CHV initialized";
            }
            if (i2 == 4) {
                return "access condition not fulfilled/unsuccessful CHV verification, at least one attempt left/unsuccessful UNBLOCK CHV verification, at least one attempt left/authentication failed";
            }
            if (i2 == 8) {
                return "in contradiction with CHV status";
            }
            if (i2 == 16) {
                return "in contradiction with invalidation status";
            }
            if (i2 == 64) {
                return "unsuccessful CHV verification, no attempt left/unsuccessful UNBLOCK CHV verification, no attempt left/CHV blocked/UNBLOCK CHV blocked";
            }
            if (i2 == 80) {
                return "increase cannot be performed, Max value reached";
            }
            if (i2 == 98) {
                return "authentication error, application specific";
            }
            switch (i2) {
                case 100:
                    return "authentication error, security context not supported";
                case 101:
                    return "key freshness failure";
                case 102:
                    return "authentication error, no memory space available";
                case 103:
                    return "authentication error, no memory space available in EF_MUK";
                default:
                    return "unknown";
            }
        } else if (i == 158 || i == 159) {
            return null;
        } else {
            switch (i) {
                case 97:
                    return this.sw2 + " more response bytes available";
                case 98:
                    int i3 = this.sw2;
                    if (i3 == 0) {
                        return "no information given, state of non volatile memory unchanged";
                    }
                    switch (i3) {
                        case 129:
                            return "part of returned data may be corrupted";
                        case InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT /*130*/:
                            return "end of file/record reached before reading Le bytes";
                        case InterPhoneService.MSG_UPDATE_ACTIVITY_DESTROY_2_SVC /*131*/:
                            return "selected file invalidated";
                        case 132:
                            return "selected file in termination state";
                        default:
                            switch (i3) {
                                case CallFailCause.FDN_BLOCKED:
                                    return "more data available";
                                case 242:
                                    return "more data available and proactive command pending";
                                case CallFailCause.IMEI_NOT_ACCEPTED:
                                    return "response data available";
                                default:
                                    return "unknown";
                            }
                    }
                case 99:
                    int i4 = this.sw2;
                    if ((i4 >> 4) == 12) {
                        int i5 = i4 & 15;
                        return "command successful but after using an internal update retry routine " + i5 + " times, or verification failed, " + i5 + " retries remaining";
                    } else if (i4 == 241) {
                        return "more data expected";
                    } else {
                        if (i4 != 242) {
                            return "unknown";
                        }
                        return "more data expected and proactive command pending";
                    }
                case 100:
                    if (this.sw2 != 0) {
                        return "unknown";
                    }
                    return "no information given, state of non-volatile memory unchanged";
                case 101:
                    int i6 = this.sw2;
                    if (i6 == 0) {
                        return "no information given, state of non-volatile memory changed";
                    }
                    if (i6 != 129) {
                        return "unknown";
                    }
                    return "memory problem";
                default:
                    switch (i) {
                        case 103:
                            if (this.sw2 != 0) {
                                return "the interpretation of this status word is command dependent";
                            }
                            return "incorrect parameter P3";
                        case 104:
                            int i7 = this.sw2;
                            if (i7 == 0) {
                                return "no information given";
                            }
                            if (i7 == 129) {
                                return "logical channel not supported";
                            }
                            if (i7 != 130) {
                                return "unknown";
                            }
                            return "secure messaging not supported";
                        case 105:
                            int i8 = this.sw2;
                            if (i8 == 0) {
                                return "no information given";
                            }
                            if (i8 == 137) {
                                return "command not allowed - secure channel - security not satisfied";
                            }
                            switch (i8) {
                                case 129:
                                    return "command incompatible with file structure";
                                case InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT /*130*/:
                                    return "security status not satisfied";
                                case InterPhoneService.MSG_UPDATE_ACTIVITY_DESTROY_2_SVC /*131*/:
                                    return "authentication/PIN method blocked";
                                case 132:
                                    return "referenced data invalidated";
                                case NetworkStackConstants.ICMPV6_ROUTER_SOLICITATION /*133*/:
                                    return "conditions of use not satisfied";
                                case 134:
                                    return "command not allowed (no EF selected)";
                                default:
                                    return "unknown";
                            }
                        case 106:
                            switch (this.sw2) {
                                case 128:
                                    return "incorrect parameters in the data field";
                                case 129:
                                    return "function not supported";
                                case InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT /*130*/:
                                    return "file not found";
                                case InterPhoneService.MSG_UPDATE_ACTIVITY_DESTROY_2_SVC /*131*/:
                                    return "record not found";
                                case 132:
                                    return "not enough memory space";
                                case 134:
                                    return "incorrect parameters P1 to P2";
                                case NetworkStackConstants.ICMPV6_NEIGHBOR_SOLICITATION /*135*/:
                                    return "lc inconsistent with P1 to P2";
                                case NetworkStackConstants.ICMPV6_NEIGHBOR_ADVERTISEMENT /*136*/:
                                    return "referenced data not found";
                                default:
                                    return "unknown";
                            }
                        case 107:
                            return "incorrect parameter P1 or P2";
                        case 108:
                            return "wrong length, retry with " + this.sw2;
                        case 109:
                            return "unknown instruction code given in the command";
                        case 110:
                            return "wrong instruction class given in the command";
                        case 111:
                            if (this.sw2 != 0) {
                                return "the interpretation of this status word is command dependent";
                            }
                            return "technical problem with no diagnostic given";
                        default:
                            switch (i) {
                                case 144:
                                case 145:
                                    return null;
                                case 146:
                                    int i9 = this.sw2;
                                    if ((i9 >> 4) == 0) {
                                        return "command successful but after using an internal update retry routine";
                                    }
                                    if (i9 != 64) {
                                        return "unknown";
                                    }
                                    return "memory problem";
                                case 147:
                                    if (this.sw2 != 0) {
                                        return "unknown";
                                    }
                                    return "SIM Application Toolkit is busy. Command cannot be executed at present, further normal commands are allowed";
                                case 148:
                                    int i10 = this.sw2;
                                    if (i10 == 0) {
                                        return "no EF selected";
                                    }
                                    if (i10 == 2) {
                                        return "out f range (invalid address)";
                                    }
                                    if (i10 == 4) {
                                        return "file ID not found/pattern not found";
                                    }
                                    if (i10 != 8) {
                                        return "unknown";
                                    }
                                    return "file is inconsistent with the command";
                                default:
                                    return "unknown";
                            }
                    }
            }
        }
    }

    @UnsupportedAppUsage
    public IccIoResult(int i, int i2, byte[] bArr) {
        this.sw1 = i;
        this.sw2 = i2;
        this.payload = bArr;
    }

    @UnsupportedAppUsage
    public IccIoResult(int i, int i2, String str) {
        this(i, i2, IccUtils.hexStringToBytes(str));
    }

    public String toString() {
        String str;
        StringBuilder sb = new StringBuilder();
        sb.append("IccIoResult sw1:0x");
        sb.append(Integer.toHexString(this.sw1));
        sb.append(" sw2:0x");
        sb.append(Integer.toHexString(this.sw2));
        sb.append(" Payload: ");
        sb.append(TelephonyUtils.IS_DEBUGGABLE ? IccUtils.bytesToHexString(this.payload) : "*******");
        if (!success()) {
            str = " Error: " + getErrorString();
        } else {
            str = "";
        }
        sb.append(str);
        return sb.toString();
    }

    @UnsupportedAppUsage
    public boolean success() {
        int i = this.sw1;
        return i == 144 || i == 145 || i == 158 || i == 159;
    }

    public IccException getException() {
        if (success()) {
            return null;
        }
        if (this.sw1 != 148) {
            return new IccException("sw1:" + this.sw1 + " sw2:" + this.sw2);
        } else if (this.sw2 == 8) {
            return new IccFileTypeMismatch();
        } else {
            return new IccFileNotFound();
        }
    }
}
