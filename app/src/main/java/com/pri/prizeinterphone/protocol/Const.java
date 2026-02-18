package com.pri.prizeinterphone.protocol;

import androidx.core.os.EnvironmentCompat;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
/* loaded from: classes4.dex */
public class Const {

    @Retention(RetentionPolicy.CLASS)
    /* loaded from: classes4.dex */
    public @interface AnalogCmdType {
    }

    /* loaded from: classes4.dex */
    public interface CallBackCode {
        public static final byte CHANNEL_BUSY = 7;
        public static final byte DA_CHECK_ANALOG_FINISH = 13;
        public static final byte DA_CHECK_ANALOG_START = 12;
        public static final byte DA_CHECK_DIGITAL_FINISH = 11;
        public static final byte DA_CHECK_DIGITAL_START = 10;
        public static final byte RECEIVE_FINISH = 2;
        public static final byte RECEIVE_MSG = 5;
        public static final byte RECEIVE_START = 1;
        public static final byte RELAY_TIMEOUT = 6;
        public static final byte SEND_FINISH = 4;
        public static final byte SEND_MSG_FAIL = 9;
        public static final byte SEND_MSG_SUCCESS = 8;
        public static final byte SEND_START = 3;
    }

    /* loaded from: classes4.dex */
    public interface Command {
        public static final byte INTERRUPT_TRANSMIT_CMD = 53;
        public static final byte MODULE_INIT_CMD = -86;
        public static final byte MODULE_PRINT_STATUS_INFO_CMD = 54;
        public static final byte QUERY_ANALOG_INFO_CMD = 37;
        public static final byte QUERY_DIGITAL_AUDIO_RECEIVE_INFO = 43;
        public static final byte QUERY_DIGITAL_INFO_CMD = 36;
        public static final byte QUERY_INIT_STATUS_CMD = 39;
        public static final byte QUERY_MIX_CHECK_INFO_CMD = 57;
        public static final byte QUERY_SIGNAL_STRENGTH_CMD = 50;
        public static final byte QUERY_VERSION_CMD = 52;
        public static final byte RECEIVE_SMS_CMD = 45;
        public static final byte SEND_SMS_CMD = 44;
        public static final byte SET_ANALOG_INFO_CMD = 35;
        public static final byte SET_DIGITAL_INFO_CMD = 34;
        public static final byte SET_ENCRYPT_FUNCTION_CMD = 41;
        public static final byte SET_ENHANCE_FUNCTION_CMD = 40;
        public static final byte SET_GAIN_MIC_CMD = 42;
        public static final byte SET_LAUNCH_INFO_CMD = 38;
        public static final byte SET_LISTEN_CMD = 47;
        public static final byte SET_MIX_CHECK_INFO_CMD = 56;
        public static final byte SET_OFFLINE_MODE_CMD = 51;
        public static final byte SET_POLITE_POLICY_CMD = 55;
        public static final byte SET_POWER_SAVE_MODE_CMD = 49;
        public static final byte SET_SMS_PROTOCOL_TYPE_CMD = 58;
        public static final byte SET_SPK_EN_CMD = 60;
        public static final byte SET_SQUELCH_CMD = 48;
        public static final byte SET_TOTO_CMD = 59;
        public static final byte SET_VOL_CMD = 46;
        public static final byte TEST_BIT_ERROR_RATE = 63;
    }

    @Retention(RetentionPolicy.CLASS)
    /* loaded from: classes4.dex */
    public @interface DigitalCmdType {
    }

    @Retention(RetentionPolicy.CLASS)
    /* loaded from: classes4.dex */
    public @interface ModuleStatus {
        public static final byte CHANNEL_BUSY = 7;
        public static final byte MIX_CHECK_ANALOG_RECEIVE_START = 12;
        public static final byte MIX_CHECK_ANALOG_RECEIVE_STOP = 13;
        public static final byte MIX_CHECK_DIGITAL_RECEIVE_START = 10;
        public static final byte MIX_CHECK_DIGITAL_RECEIVE_STOP = 11;
        public static final byte RECEIVE_START = 1;
        public static final byte RECEIVE_STOP = 2;
        public static final byte RELAY_ACTIVITY_TIME_OUT = 6;
        public static final byte SEND_START = 3;
        public static final byte SEND_STOP = 4;
        public static final byte SMS_RECEIVED = 5;
        public static final byte SMS_SENT_FAIL = 9;
        public static final byte SMS_SENT_SUCCESS = 8;
    }

    /* loaded from: classes4.dex */
    public interface RWMode {
        public static final byte READ_MODE = 0;
        public static final byte WRITE_MODE = 1;
    }

    /* loaded from: classes4.dex */
    public interface SRFlag {
        public static final byte RESULT_CK_SUM_ERROR = 2;
        public static final byte RESULT_FAIL = 1;
        public static final byte RESULT_SUCCESS = 0;
        public static final byte SET = 1;
    }

    public static String moduleStatus2Str(byte b) {
        switch (b) {
            case 1:
                return "RECEIVE_START";
            case 2:
                return "RECEIVE_STOP";
            case 3:
                return "SEND_START";
            case 4:
                return "SEND_STOP";
            case 5:
                return "SMS_RECEIVED";
            case 6:
                return "RELAY_ACTIVITY_TIME_OUT";
            case 7:
                return "CHANNEL_BUSY";
            case 8:
                return "SMS_SENT_SUCCESS";
            case 9:
                return "SMS_SENT_FAIL";
            case 10:
                return "MIX_CHECK_DIGITAL_RECEIVE_START";
            case 11:
                return "MIX_CHECK_DIGITAL_RECEIVE_STOP";
            case 12:
                return "MIX_CHECK_ANALOG_RECEIVE_START";
            case 13:
                return "MIX_CHECK_ANALOG_RECEIVE_STOP";
            default:
                return EnvironmentCompat.MEDIA_UNKNOWN;
        }
    }

    public static String sRFlag2Str(byte b) {
        return b != 0 ? b != 1 ? b != 2 ? EnvironmentCompat.MEDIA_UNKNOWN : "RESULT_CK_SUM_ERROR" : "SET or RESULT_FAIL" : "RESULT_SUCCESS";
    }
}
