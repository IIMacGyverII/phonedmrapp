package com.pri.prizeinterphone.protocol;

import androidx.annotation.NonNull;
import androidx.core.os.EnvironmentCompat;
import java.util.Arrays;
import kotlin.UByte;
import kotlin.UShort;
/* loaded from: classes4.dex */
public final class Packet {
    public static final int HEADER_LEN = 8;
    public byte[] body;
    public short ckSum;
    public byte cmd;
    public short len;
    public byte rw;
    public byte sr;
    public byte head = 104;
    public final byte tail = 16;

    public static String cmd2Str(int i) {
        if (i != -86) {
            switch (i) {
                case 34:
                    return "SET_DIGITAL_INFO_CMD";
                case 35:
                    return "SET_ANALOG_INFO_CMD";
                case 36:
                    return "QUERY_DIGITAL_INFO_CMD";
                case 37:
                    return "QUERY_ANALOG_INFO_CMD";
                case 38:
                    return "SET_LAUNCH_INFO_CMD";
                case 39:
                    return "QUERY_INIT_STATUS_CMD";
                case 40:
                    return "SET_ENHANCE_FUNCTION_CMD";
                case 41:
                    return "SET_ENCRYPT_FUNCTION_CMD";
                case 42:
                    return "SET_GAIN_MIC_CMD";
                case 43:
                    return "QUERY_DIGITAL_AUDIO_RECEIVE_INFO";
                case 44:
                    return "SEND_SMS_CMD";
                case 45:
                    return "RECEIVE_SMS_CMD";
                case 46:
                    return "SET_VOL_CMD";
                case 47:
                    return "SET_LISTEN_CMD";
                case 48:
                    return "SET_SQUELCH_CMD";
                case 49:
                    return "SET_POWER_SAVE_MODE_CMD";
                case 50:
                    return "QUERY_SIGNAL_STRENGTH_CMD";
                case 51:
                    return "SET_OFFLINE_MODE_CMD";
                case 52:
                    return "QUERY_VERSION_CMD";
                case 53:
                    return "INTERRUPT_TRANSMIT_CMD";
                case 54:
                    return "MODULE_PRINT_STATUS_INFO_CMD";
                case 55:
                    return "SET_POLITE_POLICY_CMD";
                case 56:
                    return "SET_MIX_CHECK_INFO_CMD";
                case 57:
                    return "QUERY_MIX_CHECK_INFO_CMD";
                case 58:
                    return "SET_SMS_PROTOCOL_TYPE_CMD";
                case 59:
                    return "SET_TOTO_CMD";
                case 60:
                    return "SET_SPK_EN_CMD";
                default:
                    return EnvironmentCompat.MEDIA_UNKNOWN;
            }
        }
        return "MODULE_INIT_CMD";
    }

    public Packet(byte b) {
        this.cmd = b;
    }

    public byte getHead() {
        return this.head;
    }

    public void setHead(byte b) {
        this.head = b;
    }

    public byte getCmd() {
        return this.cmd;
    }

    public void setCmd(byte b) {
        this.cmd = b;
    }

    public int getBodyLength() {
        byte[] bArr = this.body;
        if (bArr == null) {
            return 0;
        }
        return bArr.length;
    }

    @NonNull
    public String toString() {
        return "Packet{head=" + Integer.toHexString(this.head & UByte.MAX_VALUE) + ", cmd=" + Integer.toHexString(this.cmd & UByte.MAX_VALUE) + "(" + cmd2Str(this.cmd) + "), rw=" + Integer.toHexString(this.rw & UByte.MAX_VALUE) + ", sr=" + Integer.toHexString(this.sr & UByte.MAX_VALUE) + ", ckSum=" + Integer.toHexString(this.ckSum & UShort.MAX_VALUE) + ", len=" + ((int) this.len) + ", body=" + Arrays.toString(this.body) + ", tail=" + Integer.toHexString(16) + '}';
    }
}
