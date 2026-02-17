package com.android.internal.telephony.nano;

import android.telephony.gsm.SmsMessage;
import com.android.internal.telephony.cat.BerTlv;
import com.android.internal.telephony.protobuf.nano.CodedInputByteBufferNano;
import com.android.internal.telephony.protobuf.nano.CodedOutputByteBufferNano;
import com.android.internal.telephony.protobuf.nano.ExtendableMessageNano;
import com.android.internal.telephony.protobuf.nano.InternalNano;
import com.android.internal.telephony.protobuf.nano.InvalidProtocolBufferNanoException;
import com.android.internal.telephony.protobuf.nano.MessageNano;
import com.android.internal.telephony.protobuf.nano.WireFormatNano;
import com.android.internal.telephony.util.DnsPacket;
import com.android.internal.telephony.util.NetworkStackConstants;
import com.pri.prizeinterphone.InterPhoneService;
import java.io.IOException;

public interface TelephonyProto {

    public interface ImsServiceErrno {
        public static final int IMS_E_SMS_SEND_STATUS_ERROR = 2;
        public static final int IMS_E_SMS_SEND_STATUS_ERROR_FALLBACK = 4;
        public static final int IMS_E_SMS_SEND_STATUS_ERROR_RETRY = 3;
        public static final int IMS_E_SUCCESS = 1;
        public static final int IMS_E_UNKNOWN = 0;
    }

    public interface NrMode {
        public static final int NR_NONE = 1;
        public static final int NR_NSA = 2;
        public static final int NR_NSA_MMWAVE = 3;
        public static final int NR_SA = 4;
        public static final int NR_SA_MMWAVE = 5;
    }

    public interface PdpType {
        public static final int PDP_TYPE_IP = 1;
        public static final int PDP_TYPE_IPV4V6 = 3;
        public static final int PDP_TYPE_IPV6 = 2;
        public static final int PDP_TYPE_NON_IP = 5;
        public static final int PDP_TYPE_PPP = 4;
        public static final int PDP_TYPE_UNSTRUCTURED = 6;
        public static final int PDP_UNKNOWN = 0;
    }

    public interface RadioAccessTechnology {
        public static final int RAT_1XRTT = 6;
        public static final int RAT_EDGE = 2;
        public static final int RAT_EHRPD = 13;
        public static final int RAT_EVDO_0 = 7;
        public static final int RAT_EVDO_A = 8;
        public static final int RAT_EVDO_B = 12;
        public static final int RAT_GPRS = 1;
        public static final int RAT_GSM = 16;
        public static final int RAT_HSDPA = 9;
        public static final int RAT_HSPA = 11;
        public static final int RAT_HSPAP = 15;
        public static final int RAT_HSUPA = 10;
        public static final int RAT_IS95A = 4;
        public static final int RAT_IS95B = 5;
        public static final int RAT_IWLAN = 18;
        public static final int RAT_LTE = 14;
        public static final int RAT_LTE_CA = 19;
        public static final int RAT_NR = 20;
        public static final int RAT_TD_SCDMA = 17;
        public static final int RAT_UMTS = 3;
        public static final int RAT_UNKNOWN = 0;
        public static final int UNKNOWN = -1;
    }

    public interface RilErrno {
        public static final int RIL_E_ABORTED = 66;
        public static final int RIL_E_CANCELLED = 8;
        public static final int RIL_E_DEVICE_IN_USE = 65;
        public static final int RIL_E_DIAL_MODIFIED_TO_DIAL = 21;
        public static final int RIL_E_DIAL_MODIFIED_TO_SS = 20;
        public static final int RIL_E_DIAL_MODIFIED_TO_USSD = 19;
        public static final int RIL_E_EMPTY_RECORD = 56;
        public static final int RIL_E_ENCODING_ERR = 58;
        public static final int RIL_E_FDN_CHECK_FAILURE = 15;
        public static final int RIL_E_GENERIC_FAILURE = 3;
        public static final int RIL_E_ILLEGAL_SIM_OR_ME = 16;
        public static final int RIL_E_INTERNAL_ERR = 39;
        public static final int RIL_E_INVALID_ARGUMENTS = 45;
        public static final int RIL_E_INVALID_CALL_ID = 48;
        public static final int RIL_E_INVALID_MODEM_STATE = 47;
        public static final int RIL_E_INVALID_RESPONSE = 67;
        public static final int RIL_E_INVALID_SIM_STATE = 46;
        public static final int RIL_E_INVALID_SMSC_ADDRESS = 59;
        public static final int RIL_E_INVALID_SMS_FORMAT = 57;
        public static final int RIL_E_INVALID_STATE = 42;
        public static final int RIL_E_LCE_NOT_SUPPORTED = 36;
        public static final int RIL_E_LCE_NOT_SUPPORTED_NEW = 37;
        public static final int RIL_E_MISSING_RESOURCE = 17;
        public static final int RIL_E_MODEM_ERR = 41;
        public static final int RIL_E_MODE_NOT_SUPPORTED = 14;
        public static final int RIL_E_NETWORK_ERR = 50;
        public static final int RIL_E_NETWORK_NOT_READY = 61;
        public static final int RIL_E_NETWORK_REJECT = 54;
        public static final int RIL_E_NOT_PROVISIONED = 62;
        public static final int RIL_E_NO_MEMORY = 38;
        public static final int RIL_E_NO_NETWORK_FOUND = 64;
        public static final int RIL_E_NO_RESOURCES = 43;
        public static final int RIL_E_NO_SMS_TO_ACK = 49;
        public static final int RIL_E_NO_SUBSCRIPTION = 63;
        public static final int RIL_E_NO_SUCH_ELEMENT = 18;
        public static final int RIL_E_NO_SUCH_ENTRY = 60;
        public static final int RIL_E_OPERATION_NOT_ALLOWED = 55;
        public static final int RIL_E_OP_NOT_ALLOWED_BEFORE_REG_TO_NW = 10;
        public static final int RIL_E_OP_NOT_ALLOWED_DURING_VOICE_CALL = 9;
        public static final int RIL_E_PASSWORD_INCORRECT = 4;
        public static final int RIL_E_RADIO_NOT_AVAILABLE = 2;
        public static final int RIL_E_REQUEST_NOT_SUPPORTED = 7;
        public static final int RIL_E_REQUEST_RATE_LIMITED = 51;
        public static final int RIL_E_SIM_ABSENT = 12;
        public static final int RIL_E_SIM_BUSY = 52;
        public static final int RIL_E_SIM_ERR = 44;
        public static final int RIL_E_SIM_FULL = 53;
        public static final int RIL_E_SIM_PIN2 = 5;
        public static final int RIL_E_SIM_PUK2 = 6;
        public static final int RIL_E_SMS_SEND_FAIL_RETRY = 11;
        public static final int RIL_E_SS_MODIFIED_TO_DIAL = 25;
        public static final int RIL_E_SS_MODIFIED_TO_SS = 28;
        public static final int RIL_E_SS_MODIFIED_TO_USSD = 26;
        public static final int RIL_E_SUBSCRIPTION_NOT_AVAILABLE = 13;
        public static final int RIL_E_SUBSCRIPTION_NOT_SUPPORTED = 27;
        public static final int RIL_E_SUCCESS = 1;
        public static final int RIL_E_SYSTEM_ERR = 40;
        public static final int RIL_E_UNKNOWN = 0;
        public static final int RIL_E_USSD_MODIFIED_TO_DIAL = 22;
        public static final int RIL_E_USSD_MODIFIED_TO_SS = 23;
        public static final int RIL_E_USSD_MODIFIED_TO_USSD = 24;
    }

    public interface SimState {
        public static final int SIM_STATE_ABSENT = 1;
        public static final int SIM_STATE_LOADED = 2;
        public static final int SIM_STATE_UNKNOWN = 0;
    }

    public interface TimeInterval {
        public static final int TI_100_MILLIS = 4;
        public static final int TI_10_MILLIS = 1;
        public static final int TI_10_MINUTES = 14;
        public static final int TI_10_SEC = 10;
        public static final int TI_1_HOUR = 16;
        public static final int TI_1_MINUTE = 12;
        public static final int TI_1_SEC = 7;
        public static final int TI_200_MILLIS = 5;
        public static final int TI_20_MILLIS = 2;
        public static final int TI_2_HOURS = 17;
        public static final int TI_2_SEC = 8;
        public static final int TI_30_MINUTES = 15;
        public static final int TI_30_SEC = 11;
        public static final int TI_3_MINUTES = 13;
        public static final int TI_4_HOURS = 18;
        public static final int TI_500_MILLIS = 6;
        public static final int TI_50_MILLIS = 3;
        public static final int TI_5_SEC = 9;
        public static final int TI_MANY_HOURS = 19;
        public static final int TI_UNKNOWN = 0;
    }

    public static final class TelephonyLog extends ExtendableMessageNano<TelephonyLog> {
        private static volatile TelephonyLog[] _emptyArray;
        public BandwidthEstimatorStats bandwidthEstimatorStats;
        public TelephonyCallSession[] callSessions;
        public Time endTime;
        public TelephonyEvent[] events;
        public boolean eventsDropped;
        public String hardwareRevision;
        public TelephonyHistogram[] histograms;
        public ActiveSubscriptionInfo[] lastActiveSubscriptionInfo;
        public ModemPowerStats modemPowerStats;
        public SmsSession[] smsSessions;
        public Time startTime;

        public static TelephonyLog[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new TelephonyLog[0];
                    }
                }
            }
            return _emptyArray;
        }

        public TelephonyLog() {
            clear();
        }

        public TelephonyLog clear() {
            this.events = TelephonyEvent.emptyArray();
            this.callSessions = TelephonyCallSession.emptyArray();
            this.smsSessions = SmsSession.emptyArray();
            this.histograms = TelephonyHistogram.emptyArray();
            this.eventsDropped = false;
            this.startTime = null;
            this.endTime = null;
            this.modemPowerStats = null;
            this.hardwareRevision = "";
            this.lastActiveSubscriptionInfo = ActiveSubscriptionInfo.emptyArray();
            this.bandwidthEstimatorStats = null;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            TelephonyEvent[] telephonyEventArr = this.events;
            int i = 0;
            if (telephonyEventArr != null && telephonyEventArr.length > 0) {
                int i2 = 0;
                while (true) {
                    TelephonyEvent[] telephonyEventArr2 = this.events;
                    if (i2 >= telephonyEventArr2.length) {
                        break;
                    }
                    TelephonyEvent telephonyEvent = telephonyEventArr2[i2];
                    if (telephonyEvent != null) {
                        codedOutputByteBufferNano.writeMessage(1, telephonyEvent);
                    }
                    i2++;
                }
            }
            TelephonyCallSession[] telephonyCallSessionArr = this.callSessions;
            if (telephonyCallSessionArr != null && telephonyCallSessionArr.length > 0) {
                int i3 = 0;
                while (true) {
                    TelephonyCallSession[] telephonyCallSessionArr2 = this.callSessions;
                    if (i3 >= telephonyCallSessionArr2.length) {
                        break;
                    }
                    TelephonyCallSession telephonyCallSession = telephonyCallSessionArr2[i3];
                    if (telephonyCallSession != null) {
                        codedOutputByteBufferNano.writeMessage(2, telephonyCallSession);
                    }
                    i3++;
                }
            }
            SmsSession[] smsSessionArr = this.smsSessions;
            if (smsSessionArr != null && smsSessionArr.length > 0) {
                int i4 = 0;
                while (true) {
                    SmsSession[] smsSessionArr2 = this.smsSessions;
                    if (i4 >= smsSessionArr2.length) {
                        break;
                    }
                    SmsSession smsSession = smsSessionArr2[i4];
                    if (smsSession != null) {
                        codedOutputByteBufferNano.writeMessage(3, smsSession);
                    }
                    i4++;
                }
            }
            TelephonyHistogram[] telephonyHistogramArr = this.histograms;
            if (telephonyHistogramArr != null && telephonyHistogramArr.length > 0) {
                int i5 = 0;
                while (true) {
                    TelephonyHistogram[] telephonyHistogramArr2 = this.histograms;
                    if (i5 >= telephonyHistogramArr2.length) {
                        break;
                    }
                    TelephonyHistogram telephonyHistogram = telephonyHistogramArr2[i5];
                    if (telephonyHistogram != null) {
                        codedOutputByteBufferNano.writeMessage(4, telephonyHistogram);
                    }
                    i5++;
                }
            }
            boolean z = this.eventsDropped;
            if (z) {
                codedOutputByteBufferNano.writeBool(5, z);
            }
            Time time = this.startTime;
            if (time != null) {
                codedOutputByteBufferNano.writeMessage(6, time);
            }
            Time time2 = this.endTime;
            if (time2 != null) {
                codedOutputByteBufferNano.writeMessage(7, time2);
            }
            ModemPowerStats modemPowerStats2 = this.modemPowerStats;
            if (modemPowerStats2 != null) {
                codedOutputByteBufferNano.writeMessage(8, modemPowerStats2);
            }
            if (!this.hardwareRevision.equals("")) {
                codedOutputByteBufferNano.writeString(9, this.hardwareRevision);
            }
            ActiveSubscriptionInfo[] activeSubscriptionInfoArr = this.lastActiveSubscriptionInfo;
            if (activeSubscriptionInfoArr != null && activeSubscriptionInfoArr.length > 0) {
                while (true) {
                    ActiveSubscriptionInfo[] activeSubscriptionInfoArr2 = this.lastActiveSubscriptionInfo;
                    if (i >= activeSubscriptionInfoArr2.length) {
                        break;
                    }
                    ActiveSubscriptionInfo activeSubscriptionInfo = activeSubscriptionInfoArr2[i];
                    if (activeSubscriptionInfo != null) {
                        codedOutputByteBufferNano.writeMessage(10, activeSubscriptionInfo);
                    }
                    i++;
                }
            }
            BandwidthEstimatorStats bandwidthEstimatorStats2 = this.bandwidthEstimatorStats;
            if (bandwidthEstimatorStats2 != null) {
                codedOutputByteBufferNano.writeMessage(11, bandwidthEstimatorStats2);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            TelephonyEvent[] telephonyEventArr = this.events;
            int i = 0;
            if (telephonyEventArr != null && telephonyEventArr.length > 0) {
                int i2 = 0;
                while (true) {
                    TelephonyEvent[] telephonyEventArr2 = this.events;
                    if (i2 >= telephonyEventArr2.length) {
                        break;
                    }
                    TelephonyEvent telephonyEvent = telephonyEventArr2[i2];
                    if (telephonyEvent != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(1, telephonyEvent);
                    }
                    i2++;
                }
            }
            TelephonyCallSession[] telephonyCallSessionArr = this.callSessions;
            if (telephonyCallSessionArr != null && telephonyCallSessionArr.length > 0) {
                int i3 = 0;
                while (true) {
                    TelephonyCallSession[] telephonyCallSessionArr2 = this.callSessions;
                    if (i3 >= telephonyCallSessionArr2.length) {
                        break;
                    }
                    TelephonyCallSession telephonyCallSession = telephonyCallSessionArr2[i3];
                    if (telephonyCallSession != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(2, telephonyCallSession);
                    }
                    i3++;
                }
            }
            SmsSession[] smsSessionArr = this.smsSessions;
            if (smsSessionArr != null && smsSessionArr.length > 0) {
                int i4 = 0;
                while (true) {
                    SmsSession[] smsSessionArr2 = this.smsSessions;
                    if (i4 >= smsSessionArr2.length) {
                        break;
                    }
                    SmsSession smsSession = smsSessionArr2[i4];
                    if (smsSession != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(3, smsSession);
                    }
                    i4++;
                }
            }
            TelephonyHistogram[] telephonyHistogramArr = this.histograms;
            if (telephonyHistogramArr != null && telephonyHistogramArr.length > 0) {
                int i5 = 0;
                while (true) {
                    TelephonyHistogram[] telephonyHistogramArr2 = this.histograms;
                    if (i5 >= telephonyHistogramArr2.length) {
                        break;
                    }
                    TelephonyHistogram telephonyHistogram = telephonyHistogramArr2[i5];
                    if (telephonyHistogram != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(4, telephonyHistogram);
                    }
                    i5++;
                }
            }
            boolean z = this.eventsDropped;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(5, z);
            }
            Time time = this.startTime;
            if (time != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(6, time);
            }
            Time time2 = this.endTime;
            if (time2 != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(7, time2);
            }
            ModemPowerStats modemPowerStats2 = this.modemPowerStats;
            if (modemPowerStats2 != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(8, modemPowerStats2);
            }
            if (!this.hardwareRevision.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(9, this.hardwareRevision);
            }
            ActiveSubscriptionInfo[] activeSubscriptionInfoArr = this.lastActiveSubscriptionInfo;
            if (activeSubscriptionInfoArr != null && activeSubscriptionInfoArr.length > 0) {
                while (true) {
                    ActiveSubscriptionInfo[] activeSubscriptionInfoArr2 = this.lastActiveSubscriptionInfo;
                    if (i >= activeSubscriptionInfoArr2.length) {
                        break;
                    }
                    ActiveSubscriptionInfo activeSubscriptionInfo = activeSubscriptionInfoArr2[i];
                    if (activeSubscriptionInfo != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(10, activeSubscriptionInfo);
                    }
                    i++;
                }
            }
            BandwidthEstimatorStats bandwidthEstimatorStats2 = this.bandwidthEstimatorStats;
            return bandwidthEstimatorStats2 != null ? computeSerializedSize + CodedOutputByteBufferNano.computeMessageSize(11, bandwidthEstimatorStats2) : computeSerializedSize;
        }

        public TelephonyLog mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                switch (readTag) {
                    case 0:
                        return this;
                    case 10:
                        int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 10);
                        TelephonyEvent[] telephonyEventArr = this.events;
                        int length = telephonyEventArr == null ? 0 : telephonyEventArr.length;
                        int i = repeatedFieldArrayLength + length;
                        TelephonyEvent[] telephonyEventArr2 = new TelephonyEvent[i];
                        if (length != 0) {
                            System.arraycopy(telephonyEventArr, 0, telephonyEventArr2, 0, length);
                        }
                        while (length < i - 1) {
                            TelephonyEvent telephonyEvent = new TelephonyEvent();
                            telephonyEventArr2[length] = telephonyEvent;
                            codedInputByteBufferNano.readMessage(telephonyEvent);
                            codedInputByteBufferNano.readTag();
                            length++;
                        }
                        TelephonyEvent telephonyEvent2 = new TelephonyEvent();
                        telephonyEventArr2[length] = telephonyEvent2;
                        codedInputByteBufferNano.readMessage(telephonyEvent2);
                        this.events = telephonyEventArr2;
                        break;
                    case 18:
                        int repeatedFieldArrayLength2 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 18);
                        TelephonyCallSession[] telephonyCallSessionArr = this.callSessions;
                        int length2 = telephonyCallSessionArr == null ? 0 : telephonyCallSessionArr.length;
                        int i2 = repeatedFieldArrayLength2 + length2;
                        TelephonyCallSession[] telephonyCallSessionArr2 = new TelephonyCallSession[i2];
                        if (length2 != 0) {
                            System.arraycopy(telephonyCallSessionArr, 0, telephonyCallSessionArr2, 0, length2);
                        }
                        while (length2 < i2 - 1) {
                            TelephonyCallSession telephonyCallSession = new TelephonyCallSession();
                            telephonyCallSessionArr2[length2] = telephonyCallSession;
                            codedInputByteBufferNano.readMessage(telephonyCallSession);
                            codedInputByteBufferNano.readTag();
                            length2++;
                        }
                        TelephonyCallSession telephonyCallSession2 = new TelephonyCallSession();
                        telephonyCallSessionArr2[length2] = telephonyCallSession2;
                        codedInputByteBufferNano.readMessage(telephonyCallSession2);
                        this.callSessions = telephonyCallSessionArr2;
                        break;
                    case 26:
                        int repeatedFieldArrayLength3 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 26);
                        SmsSession[] smsSessionArr = this.smsSessions;
                        int length3 = smsSessionArr == null ? 0 : smsSessionArr.length;
                        int i3 = repeatedFieldArrayLength3 + length3;
                        SmsSession[] smsSessionArr2 = new SmsSession[i3];
                        if (length3 != 0) {
                            System.arraycopy(smsSessionArr, 0, smsSessionArr2, 0, length3);
                        }
                        while (length3 < i3 - 1) {
                            SmsSession smsSession = new SmsSession();
                            smsSessionArr2[length3] = smsSession;
                            codedInputByteBufferNano.readMessage(smsSession);
                            codedInputByteBufferNano.readTag();
                            length3++;
                        }
                        SmsSession smsSession2 = new SmsSession();
                        smsSessionArr2[length3] = smsSession2;
                        codedInputByteBufferNano.readMessage(smsSession2);
                        this.smsSessions = smsSessionArr2;
                        break;
                    case 34:
                        int repeatedFieldArrayLength4 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 34);
                        TelephonyHistogram[] telephonyHistogramArr = this.histograms;
                        int length4 = telephonyHistogramArr == null ? 0 : telephonyHistogramArr.length;
                        int i4 = repeatedFieldArrayLength4 + length4;
                        TelephonyHistogram[] telephonyHistogramArr2 = new TelephonyHistogram[i4];
                        if (length4 != 0) {
                            System.arraycopy(telephonyHistogramArr, 0, telephonyHistogramArr2, 0, length4);
                        }
                        while (length4 < i4 - 1) {
                            TelephonyHistogram telephonyHistogram = new TelephonyHistogram();
                            telephonyHistogramArr2[length4] = telephonyHistogram;
                            codedInputByteBufferNano.readMessage(telephonyHistogram);
                            codedInputByteBufferNano.readTag();
                            length4++;
                        }
                        TelephonyHistogram telephonyHistogram2 = new TelephonyHistogram();
                        telephonyHistogramArr2[length4] = telephonyHistogram2;
                        codedInputByteBufferNano.readMessage(telephonyHistogram2);
                        this.histograms = telephonyHistogramArr2;
                        break;
                    case 40:
                        this.eventsDropped = codedInputByteBufferNano.readBool();
                        break;
                    case 50:
                        if (this.startTime == null) {
                            this.startTime = new Time();
                        }
                        codedInputByteBufferNano.readMessage(this.startTime);
                        break;
                    case 58:
                        if (this.endTime == null) {
                            this.endTime = new Time();
                        }
                        codedInputByteBufferNano.readMessage(this.endTime);
                        break;
                    case 66:
                        if (this.modemPowerStats == null) {
                            this.modemPowerStats = new ModemPowerStats();
                        }
                        codedInputByteBufferNano.readMessage(this.modemPowerStats);
                        break;
                    case 74:
                        this.hardwareRevision = codedInputByteBufferNano.readString();
                        break;
                    case 82:
                        int repeatedFieldArrayLength5 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 82);
                        ActiveSubscriptionInfo[] activeSubscriptionInfoArr = this.lastActiveSubscriptionInfo;
                        int length5 = activeSubscriptionInfoArr == null ? 0 : activeSubscriptionInfoArr.length;
                        int i5 = repeatedFieldArrayLength5 + length5;
                        ActiveSubscriptionInfo[] activeSubscriptionInfoArr2 = new ActiveSubscriptionInfo[i5];
                        if (length5 != 0) {
                            System.arraycopy(activeSubscriptionInfoArr, 0, activeSubscriptionInfoArr2, 0, length5);
                        }
                        while (length5 < i5 - 1) {
                            ActiveSubscriptionInfo activeSubscriptionInfo = new ActiveSubscriptionInfo();
                            activeSubscriptionInfoArr2[length5] = activeSubscriptionInfo;
                            codedInputByteBufferNano.readMessage(activeSubscriptionInfo);
                            codedInputByteBufferNano.readTag();
                            length5++;
                        }
                        ActiveSubscriptionInfo activeSubscriptionInfo2 = new ActiveSubscriptionInfo();
                        activeSubscriptionInfoArr2[length5] = activeSubscriptionInfo2;
                        codedInputByteBufferNano.readMessage(activeSubscriptionInfo2);
                        this.lastActiveSubscriptionInfo = activeSubscriptionInfoArr2;
                        break;
                    case 90:
                        if (this.bandwidthEstimatorStats == null) {
                            this.bandwidthEstimatorStats = new BandwidthEstimatorStats();
                        }
                        codedInputByteBufferNano.readMessage(this.bandwidthEstimatorStats);
                        break;
                    default:
                        if (storeUnknownField(codedInputByteBufferNano, readTag)) {
                            break;
                        } else {
                            return this;
                        }
                }
            }
        }

        public static TelephonyLog parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (TelephonyLog) MessageNano.mergeFrom(new TelephonyLog(), bArr);
        }

        public static TelephonyLog parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new TelephonyLog().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class Time extends ExtendableMessageNano<Time> {
        private static volatile Time[] _emptyArray;
        public long elapsedTimestampMillis;
        public long systemTimestampMillis;

        public static Time[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new Time[0];
                    }
                }
            }
            return _emptyArray;
        }

        public Time() {
            clear();
        }

        public Time clear() {
            this.systemTimestampMillis = 0;
            this.elapsedTimestampMillis = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            long j = this.systemTimestampMillis;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(1, j);
            }
            long j2 = this.elapsedTimestampMillis;
            if (j2 != 0) {
                codedOutputByteBufferNano.writeInt64(2, j2);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            long j = this.systemTimestampMillis;
            if (j != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(1, j);
            }
            long j2 = this.elapsedTimestampMillis;
            return j2 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(2, j2) : computeSerializedSize;
        }

        public Time mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.systemTimestampMillis = codedInputByteBufferNano.readInt64();
                } else if (readTag == 16) {
                    this.elapsedTimestampMillis = codedInputByteBufferNano.readInt64();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static Time parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (Time) MessageNano.mergeFrom(new Time(), bArr);
        }

        public static Time parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new Time().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class TelephonyHistogram extends ExtendableMessageNano<TelephonyHistogram> {
        private static volatile TelephonyHistogram[] _emptyArray;
        public int avgTimeMillis;
        public int bucketCount;
        public int[] bucketCounters;
        public int[] bucketEndPoints;
        public int category;
        public int count;
        public int id;
        public int maxTimeMillis;
        public int minTimeMillis;

        public static TelephonyHistogram[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new TelephonyHistogram[0];
                    }
                }
            }
            return _emptyArray;
        }

        public TelephonyHistogram() {
            clear();
        }

        public TelephonyHistogram clear() {
            this.category = 0;
            this.id = 0;
            this.minTimeMillis = 0;
            this.maxTimeMillis = 0;
            this.avgTimeMillis = 0;
            this.count = 0;
            this.bucketCount = 0;
            int[] iArr = WireFormatNano.EMPTY_INT_ARRAY;
            this.bucketEndPoints = iArr;
            this.bucketCounters = iArr;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.category;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.id;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.minTimeMillis;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.maxTimeMillis;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
            }
            int i5 = this.avgTimeMillis;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i5);
            }
            int i6 = this.count;
            if (i6 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i6);
            }
            int i7 = this.bucketCount;
            if (i7 != 0) {
                codedOutputByteBufferNano.writeInt32(7, i7);
            }
            int[] iArr = this.bucketEndPoints;
            int i8 = 0;
            if (iArr != null && iArr.length > 0) {
                int i9 = 0;
                while (true) {
                    int[] iArr2 = this.bucketEndPoints;
                    if (i9 >= iArr2.length) {
                        break;
                    }
                    codedOutputByteBufferNano.writeInt32(8, iArr2[i9]);
                    i9++;
                }
            }
            int[] iArr3 = this.bucketCounters;
            if (iArr3 != null && iArr3.length > 0) {
                while (true) {
                    int[] iArr4 = this.bucketCounters;
                    if (i8 >= iArr4.length) {
                        break;
                    }
                    codedOutputByteBufferNano.writeInt32(9, iArr4[i8]);
                    i8++;
                }
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int[] iArr;
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.category;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            int i2 = this.id;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.minTimeMillis;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.maxTimeMillis;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
            }
            int i5 = this.avgTimeMillis;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i5);
            }
            int i6 = this.count;
            if (i6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i6);
            }
            int i7 = this.bucketCount;
            if (i7 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(7, i7);
            }
            int[] iArr2 = this.bucketEndPoints;
            int i8 = 0;
            if (iArr2 != null && iArr2.length > 0) {
                int i9 = 0;
                int i10 = 0;
                while (true) {
                    iArr = this.bucketEndPoints;
                    if (i9 >= iArr.length) {
                        break;
                    }
                    i10 += CodedOutputByteBufferNano.computeInt32SizeNoTag(iArr[i9]);
                    i9++;
                }
                computeSerializedSize = computeSerializedSize + i10 + (iArr.length * 1);
            }
            int[] iArr3 = this.bucketCounters;
            if (iArr3 == null || iArr3.length <= 0) {
                return computeSerializedSize;
            }
            int i11 = 0;
            while (true) {
                int[] iArr4 = this.bucketCounters;
                if (i8 >= iArr4.length) {
                    return computeSerializedSize + i11 + (iArr4.length * 1);
                }
                i11 += CodedOutputByteBufferNano.computeInt32SizeNoTag(iArr4[i8]);
                i8++;
            }
        }

        public TelephonyHistogram mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                switch (readTag) {
                    case 0:
                        return this;
                    case 8:
                        this.category = codedInputByteBufferNano.readInt32();
                        break;
                    case 16:
                        this.id = codedInputByteBufferNano.readInt32();
                        break;
                    case 24:
                        this.minTimeMillis = codedInputByteBufferNano.readInt32();
                        break;
                    case 32:
                        this.maxTimeMillis = codedInputByteBufferNano.readInt32();
                        break;
                    case 40:
                        this.avgTimeMillis = codedInputByteBufferNano.readInt32();
                        break;
                    case 48:
                        this.count = codedInputByteBufferNano.readInt32();
                        break;
                    case 56:
                        this.bucketCount = codedInputByteBufferNano.readInt32();
                        break;
                    case 64:
                        int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 64);
                        int[] iArr = this.bucketEndPoints;
                        int length = iArr == null ? 0 : iArr.length;
                        int i = repeatedFieldArrayLength + length;
                        int[] iArr2 = new int[i];
                        if (length != 0) {
                            System.arraycopy(iArr, 0, iArr2, 0, length);
                        }
                        while (length < i - 1) {
                            iArr2[length] = codedInputByteBufferNano.readInt32();
                            codedInputByteBufferNano.readTag();
                            length++;
                        }
                        iArr2[length] = codedInputByteBufferNano.readInt32();
                        this.bucketEndPoints = iArr2;
                        break;
                    case 66:
                        int pushLimit = codedInputByteBufferNano.pushLimit(codedInputByteBufferNano.readRawVarint32());
                        int position = codedInputByteBufferNano.getPosition();
                        int i2 = 0;
                        while (codedInputByteBufferNano.getBytesUntilLimit() > 0) {
                            codedInputByteBufferNano.readInt32();
                            i2++;
                        }
                        codedInputByteBufferNano.rewindToPosition(position);
                        int[] iArr3 = this.bucketEndPoints;
                        int length2 = iArr3 == null ? 0 : iArr3.length;
                        int i3 = i2 + length2;
                        int[] iArr4 = new int[i3];
                        if (length2 != 0) {
                            System.arraycopy(iArr3, 0, iArr4, 0, length2);
                        }
                        while (length2 < i3) {
                            iArr4[length2] = codedInputByteBufferNano.readInt32();
                            length2++;
                        }
                        this.bucketEndPoints = iArr4;
                        codedInputByteBufferNano.popLimit(pushLimit);
                        break;
                    case 72:
                        int repeatedFieldArrayLength2 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 72);
                        int[] iArr5 = this.bucketCounters;
                        int length3 = iArr5 == null ? 0 : iArr5.length;
                        int i4 = repeatedFieldArrayLength2 + length3;
                        int[] iArr6 = new int[i4];
                        if (length3 != 0) {
                            System.arraycopy(iArr5, 0, iArr6, 0, length3);
                        }
                        while (length3 < i4 - 1) {
                            iArr6[length3] = codedInputByteBufferNano.readInt32();
                            codedInputByteBufferNano.readTag();
                            length3++;
                        }
                        iArr6[length3] = codedInputByteBufferNano.readInt32();
                        this.bucketCounters = iArr6;
                        break;
                    case 74:
                        int pushLimit2 = codedInputByteBufferNano.pushLimit(codedInputByteBufferNano.readRawVarint32());
                        int position2 = codedInputByteBufferNano.getPosition();
                        int i5 = 0;
                        while (codedInputByteBufferNano.getBytesUntilLimit() > 0) {
                            codedInputByteBufferNano.readInt32();
                            i5++;
                        }
                        codedInputByteBufferNano.rewindToPosition(position2);
                        int[] iArr7 = this.bucketCounters;
                        int length4 = iArr7 == null ? 0 : iArr7.length;
                        int i6 = i5 + length4;
                        int[] iArr8 = new int[i6];
                        if (length4 != 0) {
                            System.arraycopy(iArr7, 0, iArr8, 0, length4);
                        }
                        while (length4 < i6) {
                            iArr8[length4] = codedInputByteBufferNano.readInt32();
                            length4++;
                        }
                        this.bucketCounters = iArr8;
                        codedInputByteBufferNano.popLimit(pushLimit2);
                        break;
                    default:
                        if (storeUnknownField(codedInputByteBufferNano, readTag)) {
                            break;
                        } else {
                            return this;
                        }
                }
            }
        }

        public static TelephonyHistogram parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (TelephonyHistogram) MessageNano.mergeFrom(new TelephonyHistogram(), bArr);
        }

        public static TelephonyHistogram parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new TelephonyHistogram().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class TelephonySettings extends ExtendableMessageNano<TelephonySettings> {
        private static volatile TelephonySettings[] _emptyArray;
        public boolean isAirplaneMode;
        public boolean isCellularDataEnabled;
        public boolean isDataRoamingEnabled;
        public boolean isEnhanced4GLteModeEnabled;
        public boolean isVtOverLteEnabled;
        public boolean isVtOverWifiEnabled;
        public boolean isWifiCallingEnabled;
        public boolean isWifiEnabled;
        public int preferredNetworkMode;
        public int wifiCallingMode;

        public interface RilNetworkMode {
            public static final int NETWORK_MODE_CDMA = 5;
            public static final int NETWORK_MODE_CDMA_NO_EVDO = 6;
            public static final int NETWORK_MODE_EVDO_NO_CDMA = 7;
            public static final int NETWORK_MODE_GLOBAL = 8;
            public static final int NETWORK_MODE_GSM_ONLY = 2;
            public static final int NETWORK_MODE_GSM_UMTS = 4;
            public static final int NETWORK_MODE_LTE_CDMA_EVDO = 9;
            public static final int NETWORK_MODE_LTE_CDMA_EVDO_GSM_WCDMA = 11;
            public static final int NETWORK_MODE_LTE_GSM_WCDMA = 10;
            public static final int NETWORK_MODE_LTE_ONLY = 12;
            public static final int NETWORK_MODE_LTE_TDSCDMA = 16;
            public static final int NETWORK_MODE_LTE_TDSCDMA_CDMA_EVDO_GSM_WCDMA = 23;
            public static final int NETWORK_MODE_LTE_TDSCDMA_GSM = 18;
            public static final int NETWORK_MODE_LTE_TDSCDMA_GSM_WCDMA = 21;
            public static final int NETWORK_MODE_LTE_TDSCDMA_WCDMA = 20;
            public static final int NETWORK_MODE_LTE_WCDMA = 13;
            public static final int NETWORK_MODE_TDSCDMA_CDMA_EVDO_GSM_WCDMA = 22;
            public static final int NETWORK_MODE_TDSCDMA_GSM = 17;
            public static final int NETWORK_MODE_TDSCDMA_GSM_WCDMA = 19;
            public static final int NETWORK_MODE_TDSCDMA_ONLY = 14;
            public static final int NETWORK_MODE_TDSCDMA_WCDMA = 15;
            public static final int NETWORK_MODE_UNKNOWN = 0;
            public static final int NETWORK_MODE_WCDMA_ONLY = 3;
            public static final int NETWORK_MODE_WCDMA_PREF = 1;
        }

        public interface WiFiCallingMode {
            public static final int WFC_MODE_CELLULAR_PREFERRED = 2;
            public static final int WFC_MODE_UNKNOWN = 0;
            public static final int WFC_MODE_WIFI_ONLY = 1;
            public static final int WFC_MODE_WIFI_PREFERRED = 3;
        }

        public static TelephonySettings[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new TelephonySettings[0];
                    }
                }
            }
            return _emptyArray;
        }

        public TelephonySettings() {
            clear();
        }

        public TelephonySettings clear() {
            this.isAirplaneMode = false;
            this.isCellularDataEnabled = false;
            this.isDataRoamingEnabled = false;
            this.preferredNetworkMode = 0;
            this.isEnhanced4GLteModeEnabled = false;
            this.isWifiEnabled = false;
            this.isWifiCallingEnabled = false;
            this.wifiCallingMode = 0;
            this.isVtOverLteEnabled = false;
            this.isVtOverWifiEnabled = false;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            boolean z = this.isAirplaneMode;
            if (z) {
                codedOutputByteBufferNano.writeBool(1, z);
            }
            boolean z2 = this.isCellularDataEnabled;
            if (z2) {
                codedOutputByteBufferNano.writeBool(2, z2);
            }
            boolean z3 = this.isDataRoamingEnabled;
            if (z3) {
                codedOutputByteBufferNano.writeBool(3, z3);
            }
            int i = this.preferredNetworkMode;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(4, i);
            }
            boolean z4 = this.isEnhanced4GLteModeEnabled;
            if (z4) {
                codedOutputByteBufferNano.writeBool(5, z4);
            }
            boolean z5 = this.isWifiEnabled;
            if (z5) {
                codedOutputByteBufferNano.writeBool(6, z5);
            }
            boolean z6 = this.isWifiCallingEnabled;
            if (z6) {
                codedOutputByteBufferNano.writeBool(7, z6);
            }
            int i2 = this.wifiCallingMode;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(8, i2);
            }
            boolean z7 = this.isVtOverLteEnabled;
            if (z7) {
                codedOutputByteBufferNano.writeBool(9, z7);
            }
            boolean z8 = this.isVtOverWifiEnabled;
            if (z8) {
                codedOutputByteBufferNano.writeBool(10, z8);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            boolean z = this.isAirplaneMode;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(1, z);
            }
            boolean z2 = this.isCellularDataEnabled;
            if (z2) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(2, z2);
            }
            boolean z3 = this.isDataRoamingEnabled;
            if (z3) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(3, z3);
            }
            int i = this.preferredNetworkMode;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i);
            }
            boolean z4 = this.isEnhanced4GLteModeEnabled;
            if (z4) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(5, z4);
            }
            boolean z5 = this.isWifiEnabled;
            if (z5) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(6, z5);
            }
            boolean z6 = this.isWifiCallingEnabled;
            if (z6) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(7, z6);
            }
            int i2 = this.wifiCallingMode;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(8, i2);
            }
            boolean z7 = this.isVtOverLteEnabled;
            if (z7) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(9, z7);
            }
            boolean z8 = this.isVtOverWifiEnabled;
            return z8 ? computeSerializedSize + CodedOutputByteBufferNano.computeBoolSize(10, z8) : computeSerializedSize;
        }

        public TelephonySettings mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                switch (readTag) {
                    case 0:
                        return this;
                    case 8:
                        this.isAirplaneMode = codedInputByteBufferNano.readBool();
                        break;
                    case 16:
                        this.isCellularDataEnabled = codedInputByteBufferNano.readBool();
                        break;
                    case 24:
                        this.isDataRoamingEnabled = codedInputByteBufferNano.readBool();
                        break;
                    case 32:
                        int readInt32 = codedInputByteBufferNano.readInt32();
                        switch (readInt32) {
                            case 0:
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                            case 6:
                            case 7:
                            case 8:
                            case 9:
                            case 10:
                            case 11:
                            case 12:
                            case 13:
                            case 14:
                            case 15:
                            case 16:
                            case 17:
                            case 18:
                            case 19:
                            case 20:
                            case 21:
                            case 22:
                            case 23:
                                this.preferredNetworkMode = readInt32;
                                break;
                        }
                    case 40:
                        this.isEnhanced4GLteModeEnabled = codedInputByteBufferNano.readBool();
                        break;
                    case 48:
                        this.isWifiEnabled = codedInputByteBufferNano.readBool();
                        break;
                    case 56:
                        this.isWifiCallingEnabled = codedInputByteBufferNano.readBool();
                        break;
                    case 64:
                        int readInt322 = codedInputByteBufferNano.readInt32();
                        if (readInt322 != 0 && readInt322 != 1 && readInt322 != 2 && readInt322 != 3) {
                            break;
                        } else {
                            this.wifiCallingMode = readInt322;
                            break;
                        }
                        break;
                    case 72:
                        this.isVtOverLteEnabled = codedInputByteBufferNano.readBool();
                        break;
                    case 80:
                        this.isVtOverWifiEnabled = codedInputByteBufferNano.readBool();
                        break;
                    default:
                        if (storeUnknownField(codedInputByteBufferNano, readTag)) {
                            break;
                        } else {
                            return this;
                        }
                }
            }
        }

        public static TelephonySettings parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (TelephonySettings) MessageNano.mergeFrom(new TelephonySettings(), bArr);
        }

        public static TelephonySettings parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new TelephonySettings().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class TelephonyServiceState extends ExtendableMessageNano<TelephonyServiceState> {
        private static volatile TelephonyServiceState[] _emptyArray;
        public int channelNumber;
        public TelephonyOperator dataOperator;
        public int dataRat;
        public int dataRoamingType;
        public NetworkRegistrationInfo[] networkRegistrationInfo;
        public int nrFrequencyRange;
        public int nrState;
        public TelephonyOperator voiceOperator;
        public int voiceRat;
        public int voiceRoamingType;

        public interface Domain {
            public static final int DOMAIN_CS = 1;
            public static final int DOMAIN_PS = 2;
            public static final int DOMAIN_UNKNOWN = 0;
        }

        public interface FrequencyRange {
            public static final int FREQUENCY_RANGE_HIGH = 3;
            public static final int FREQUENCY_RANGE_LOW = 1;
            public static final int FREQUENCY_RANGE_MID = 2;
            public static final int FREQUENCY_RANGE_MMWAVE = 4;
            public static final int FREQUENCY_RANGE_UNKNOWN = 0;
        }

        public interface NrState {
            public static final int NR_STATE_CONNECTED = 3;
            public static final int NR_STATE_NONE = 0;
            public static final int NR_STATE_NOT_RESTRICTED = 2;
            public static final int NR_STATE_RESTRICTED = 1;
        }

        public interface RoamingType {
            public static final int ROAMING_TYPE_DOMESTIC = 2;
            public static final int ROAMING_TYPE_INTERNATIONAL = 3;
            public static final int ROAMING_TYPE_NOT_ROAMING = 0;
            public static final int ROAMING_TYPE_UNKNOWN = 1;
            public static final int UNKNOWN = -1;
        }

        public interface Transport {
            public static final int TRANSPORT_UNKNOWN = 0;
            public static final int TRANSPORT_WLAN = 2;
            public static final int TRANSPORT_WWAN = 1;
        }

        public static final class TelephonyOperator extends ExtendableMessageNano<TelephonyOperator> {
            private static volatile TelephonyOperator[] _emptyArray;
            public String alphaLong;
            public String alphaShort;
            public String numeric;

            public static TelephonyOperator[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new TelephonyOperator[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public TelephonyOperator() {
                clear();
            }

            public TelephonyOperator clear() {
                this.alphaLong = "";
                this.alphaShort = "";
                this.numeric = "";
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                if (!this.alphaLong.equals("")) {
                    codedOutputByteBufferNano.writeString(1, this.alphaLong);
                }
                if (!this.alphaShort.equals("")) {
                    codedOutputByteBufferNano.writeString(2, this.alphaShort);
                }
                if (!this.numeric.equals("")) {
                    codedOutputByteBufferNano.writeString(3, this.numeric);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                if (!this.alphaLong.equals("")) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(1, this.alphaLong);
                }
                if (!this.alphaShort.equals("")) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(2, this.alphaShort);
                }
                return !this.numeric.equals("") ? computeSerializedSize + CodedOutputByteBufferNano.computeStringSize(3, this.numeric) : computeSerializedSize;
            }

            public TelephonyOperator mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    if (readTag == 0) {
                        return this;
                    }
                    if (readTag == 10) {
                        this.alphaLong = codedInputByteBufferNano.readString();
                    } else if (readTag == 18) {
                        this.alphaShort = codedInputByteBufferNano.readString();
                    } else if (readTag == 26) {
                        this.numeric = codedInputByteBufferNano.readString();
                    } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                        return this;
                    }
                }
            }

            public static TelephonyOperator parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (TelephonyOperator) MessageNano.mergeFrom(new TelephonyOperator(), bArr);
            }

            public static TelephonyOperator parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new TelephonyOperator().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static final class NetworkRegistrationInfo extends ExtendableMessageNano<NetworkRegistrationInfo> {
            private static volatile NetworkRegistrationInfo[] _emptyArray;
            public int domain;
            public int rat;
            public int transport;

            public static NetworkRegistrationInfo[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new NetworkRegistrationInfo[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public NetworkRegistrationInfo() {
                clear();
            }

            public NetworkRegistrationInfo clear() {
                this.domain = 0;
                this.transport = 0;
                this.rat = -1;
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                int i = this.domain;
                if (i != 0) {
                    codedOutputByteBufferNano.writeInt32(1, i);
                }
                int i2 = this.transport;
                if (i2 != 0) {
                    codedOutputByteBufferNano.writeInt32(2, i2);
                }
                int i3 = this.rat;
                if (i3 != -1) {
                    codedOutputByteBufferNano.writeInt32(3, i3);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                int i = this.domain;
                if (i != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                }
                int i2 = this.transport;
                if (i2 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
                }
                int i3 = this.rat;
                return i3 != -1 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(3, i3) : computeSerializedSize;
            }

            public NetworkRegistrationInfo mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    if (readTag == 0) {
                        return this;
                    }
                    if (readTag == 8) {
                        int readInt32 = codedInputByteBufferNano.readInt32();
                        if (readInt32 == 0 || readInt32 == 1 || readInt32 == 2) {
                            this.domain = readInt32;
                        }
                    } else if (readTag != 16) {
                        if (readTag == 24) {
                            int readInt322 = codedInputByteBufferNano.readInt32();
                            switch (readInt322) {
                                case -1:
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                case 11:
                                case 12:
                                case 13:
                                case 14:
                                case 15:
                                case 16:
                                case 17:
                                case 18:
                                case 19:
                                case 20:
                                    this.rat = readInt322;
                                    break;
                            }
                        } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                            return this;
                        }
                    } else {
                        int readInt323 = codedInputByteBufferNano.readInt32();
                        if (readInt323 == 0 || readInt323 == 1 || readInt323 == 2) {
                            this.transport = readInt323;
                        }
                    }
                }
            }

            public static NetworkRegistrationInfo parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (NetworkRegistrationInfo) MessageNano.mergeFrom(new NetworkRegistrationInfo(), bArr);
            }

            public static NetworkRegistrationInfo parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new NetworkRegistrationInfo().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static TelephonyServiceState[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new TelephonyServiceState[0];
                    }
                }
            }
            return _emptyArray;
        }

        public TelephonyServiceState() {
            clear();
        }

        public TelephonyServiceState clear() {
            this.voiceOperator = null;
            this.dataOperator = null;
            this.voiceRoamingType = -1;
            this.dataRoamingType = -1;
            this.voiceRat = -1;
            this.dataRat = -1;
            this.channelNumber = 0;
            this.nrFrequencyRange = 0;
            this.nrState = 0;
            this.networkRegistrationInfo = NetworkRegistrationInfo.emptyArray();
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            TelephonyOperator telephonyOperator = this.voiceOperator;
            if (telephonyOperator != null) {
                codedOutputByteBufferNano.writeMessage(1, telephonyOperator);
            }
            TelephonyOperator telephonyOperator2 = this.dataOperator;
            if (telephonyOperator2 != null) {
                codedOutputByteBufferNano.writeMessage(2, telephonyOperator2);
            }
            int i = this.voiceRoamingType;
            if (i != -1) {
                codedOutputByteBufferNano.writeInt32(3, i);
            }
            int i2 = this.dataRoamingType;
            if (i2 != -1) {
                codedOutputByteBufferNano.writeInt32(4, i2);
            }
            int i3 = this.voiceRat;
            if (i3 != -1) {
                codedOutputByteBufferNano.writeInt32(5, i3);
            }
            int i4 = this.dataRat;
            if (i4 != -1) {
                codedOutputByteBufferNano.writeInt32(6, i4);
            }
            int i5 = this.channelNumber;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(7, i5);
            }
            int i6 = this.nrFrequencyRange;
            if (i6 != 0) {
                codedOutputByteBufferNano.writeInt32(8, i6);
            }
            int i7 = this.nrState;
            if (i7 != 0) {
                codedOutputByteBufferNano.writeInt32(9, i7);
            }
            NetworkRegistrationInfo[] networkRegistrationInfoArr = this.networkRegistrationInfo;
            if (networkRegistrationInfoArr != null && networkRegistrationInfoArr.length > 0) {
                int i8 = 0;
                while (true) {
                    NetworkRegistrationInfo[] networkRegistrationInfoArr2 = this.networkRegistrationInfo;
                    if (i8 >= networkRegistrationInfoArr2.length) {
                        break;
                    }
                    NetworkRegistrationInfo networkRegistrationInfo2 = networkRegistrationInfoArr2[i8];
                    if (networkRegistrationInfo2 != null) {
                        codedOutputByteBufferNano.writeMessage(10, networkRegistrationInfo2);
                    }
                    i8++;
                }
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            TelephonyOperator telephonyOperator = this.voiceOperator;
            if (telephonyOperator != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(1, telephonyOperator);
            }
            TelephonyOperator telephonyOperator2 = this.dataOperator;
            if (telephonyOperator2 != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(2, telephonyOperator2);
            }
            int i = this.voiceRoamingType;
            if (i != -1) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i);
            }
            int i2 = this.dataRoamingType;
            if (i2 != -1) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i2);
            }
            int i3 = this.voiceRat;
            if (i3 != -1) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i3);
            }
            int i4 = this.dataRat;
            if (i4 != -1) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i4);
            }
            int i5 = this.channelNumber;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(7, i5);
            }
            int i6 = this.nrFrequencyRange;
            if (i6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(8, i6);
            }
            int i7 = this.nrState;
            if (i7 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(9, i7);
            }
            NetworkRegistrationInfo[] networkRegistrationInfoArr = this.networkRegistrationInfo;
            if (networkRegistrationInfoArr != null && networkRegistrationInfoArr.length > 0) {
                int i8 = 0;
                while (true) {
                    NetworkRegistrationInfo[] networkRegistrationInfoArr2 = this.networkRegistrationInfo;
                    if (i8 >= networkRegistrationInfoArr2.length) {
                        break;
                    }
                    NetworkRegistrationInfo networkRegistrationInfo2 = networkRegistrationInfoArr2[i8];
                    if (networkRegistrationInfo2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(10, networkRegistrationInfo2);
                    }
                    i8++;
                }
            }
            return computeSerializedSize;
        }

        public TelephonyServiceState mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                switch (readTag) {
                    case 0:
                        return this;
                    case 10:
                        if (this.voiceOperator == null) {
                            this.voiceOperator = new TelephonyOperator();
                        }
                        codedInputByteBufferNano.readMessage(this.voiceOperator);
                        break;
                    case 18:
                        if (this.dataOperator == null) {
                            this.dataOperator = new TelephonyOperator();
                        }
                        codedInputByteBufferNano.readMessage(this.dataOperator);
                        break;
                    case 24:
                        int readInt32 = codedInputByteBufferNano.readInt32();
                        if (readInt32 != -1 && readInt32 != 0 && readInt32 != 1 && readInt32 != 2 && readInt32 != 3) {
                            break;
                        } else {
                            this.voiceRoamingType = readInt32;
                            break;
                        }
                    case 32:
                        int readInt322 = codedInputByteBufferNano.readInt32();
                        if (readInt322 != -1 && readInt322 != 0 && readInt322 != 1 && readInt322 != 2 && readInt322 != 3) {
                            break;
                        } else {
                            this.dataRoamingType = readInt322;
                            break;
                        }
                    case 40:
                        int readInt323 = codedInputByteBufferNano.readInt32();
                        switch (readInt323) {
                            case -1:
                            case 0:
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                            case 6:
                            case 7:
                            case 8:
                            case 9:
                            case 10:
                            case 11:
                            case 12:
                            case 13:
                            case 14:
                            case 15:
                            case 16:
                            case 17:
                            case 18:
                            case 19:
                            case 20:
                                this.voiceRat = readInt323;
                                break;
                        }
                    case 48:
                        int readInt324 = codedInputByteBufferNano.readInt32();
                        switch (readInt324) {
                            case -1:
                            case 0:
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                            case 6:
                            case 7:
                            case 8:
                            case 9:
                            case 10:
                            case 11:
                            case 12:
                            case 13:
                            case 14:
                            case 15:
                            case 16:
                            case 17:
                            case 18:
                            case 19:
                            case 20:
                                this.dataRat = readInt324;
                                break;
                        }
                    case 56:
                        this.channelNumber = codedInputByteBufferNano.readInt32();
                        break;
                    case 64:
                        int readInt325 = codedInputByteBufferNano.readInt32();
                        if (readInt325 != 0 && readInt325 != 1 && readInt325 != 2 && readInt325 != 3 && readInt325 != 4) {
                            break;
                        } else {
                            this.nrFrequencyRange = readInt325;
                            break;
                        }
                    case 72:
                        int readInt326 = codedInputByteBufferNano.readInt32();
                        if (readInt326 != 0 && readInt326 != 1 && readInt326 != 2 && readInt326 != 3) {
                            break;
                        } else {
                            this.nrState = readInt326;
                            break;
                        }
                    case 82:
                        int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 82);
                        NetworkRegistrationInfo[] networkRegistrationInfoArr = this.networkRegistrationInfo;
                        int length = networkRegistrationInfoArr == null ? 0 : networkRegistrationInfoArr.length;
                        int i = repeatedFieldArrayLength + length;
                        NetworkRegistrationInfo[] networkRegistrationInfoArr2 = new NetworkRegistrationInfo[i];
                        if (length != 0) {
                            System.arraycopy(networkRegistrationInfoArr, 0, networkRegistrationInfoArr2, 0, length);
                        }
                        while (length < i - 1) {
                            NetworkRegistrationInfo networkRegistrationInfo2 = new NetworkRegistrationInfo();
                            networkRegistrationInfoArr2[length] = networkRegistrationInfo2;
                            codedInputByteBufferNano.readMessage(networkRegistrationInfo2);
                            codedInputByteBufferNano.readTag();
                            length++;
                        }
                        NetworkRegistrationInfo networkRegistrationInfo3 = new NetworkRegistrationInfo();
                        networkRegistrationInfoArr2[length] = networkRegistrationInfo3;
                        codedInputByteBufferNano.readMessage(networkRegistrationInfo3);
                        this.networkRegistrationInfo = networkRegistrationInfoArr2;
                        break;
                    default:
                        if (storeUnknownField(codedInputByteBufferNano, readTag)) {
                            break;
                        } else {
                            return this;
                        }
                }
            }
        }

        public static TelephonyServiceState parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (TelephonyServiceState) MessageNano.mergeFrom(new TelephonyServiceState(), bArr);
        }

        public static TelephonyServiceState parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new TelephonyServiceState().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class ImsReasonInfo extends ExtendableMessageNano<ImsReasonInfo> {
        private static volatile ImsReasonInfo[] _emptyArray;
        public int extraCode;
        public String extraMessage;
        public int reasonCode;

        public static ImsReasonInfo[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new ImsReasonInfo[0];
                    }
                }
            }
            return _emptyArray;
        }

        public ImsReasonInfo() {
            clear();
        }

        public ImsReasonInfo clear() {
            this.reasonCode = 0;
            this.extraCode = 0;
            this.extraMessage = "";
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.reasonCode;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.extraCode;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            if (!this.extraMessage.equals("")) {
                codedOutputByteBufferNano.writeString(3, this.extraMessage);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.reasonCode;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            int i2 = this.extraCode;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            return !this.extraMessage.equals("") ? computeSerializedSize + CodedOutputByteBufferNano.computeStringSize(3, this.extraMessage) : computeSerializedSize;
        }

        public ImsReasonInfo mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.reasonCode = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.extraCode = codedInputByteBufferNano.readInt32();
                } else if (readTag == 26) {
                    this.extraMessage = codedInputByteBufferNano.readString();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static ImsReasonInfo parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (ImsReasonInfo) MessageNano.mergeFrom(new ImsReasonInfo(), bArr);
        }

        public static ImsReasonInfo parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new ImsReasonInfo().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class ImsConnectionState extends ExtendableMessageNano<ImsConnectionState> {
        private static volatile ImsConnectionState[] _emptyArray;
        public ImsReasonInfo reasonInfo;
        public int state;

        public interface State {
            public static final int CONNECTED = 1;
            public static final int DISCONNECTED = 3;
            public static final int PROGRESSING = 2;
            public static final int RESUMED = 4;
            public static final int STATE_UNKNOWN = 0;
            public static final int SUSPENDED = 5;
        }

        public static ImsConnectionState[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new ImsConnectionState[0];
                    }
                }
            }
            return _emptyArray;
        }

        public ImsConnectionState() {
            clear();
        }

        public ImsConnectionState clear() {
            this.state = 0;
            this.reasonInfo = null;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.state;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            ImsReasonInfo imsReasonInfo = this.reasonInfo;
            if (imsReasonInfo != null) {
                codedOutputByteBufferNano.writeMessage(2, imsReasonInfo);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.state;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            ImsReasonInfo imsReasonInfo = this.reasonInfo;
            return imsReasonInfo != null ? computeSerializedSize + CodedOutputByteBufferNano.computeMessageSize(2, imsReasonInfo) : computeSerializedSize;
        }

        public ImsConnectionState mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    int readInt32 = codedInputByteBufferNano.readInt32();
                    if (readInt32 == 0 || readInt32 == 1 || readInt32 == 2 || readInt32 == 3 || readInt32 == 4 || readInt32 == 5) {
                        this.state = readInt32;
                    }
                } else if (readTag == 18) {
                    if (this.reasonInfo == null) {
                        this.reasonInfo = new ImsReasonInfo();
                    }
                    codedInputByteBufferNano.readMessage(this.reasonInfo);
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static ImsConnectionState parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (ImsConnectionState) MessageNano.mergeFrom(new ImsConnectionState(), bArr);
        }

        public static ImsConnectionState parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new ImsConnectionState().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class ImsCapabilities extends ExtendableMessageNano<ImsCapabilities> {
        private static volatile ImsCapabilities[] _emptyArray;
        public boolean utOverLte;
        public boolean utOverWifi;
        public boolean videoOverLte;
        public boolean videoOverWifi;
        public boolean voiceOverLte;
        public boolean voiceOverWifi;

        public static ImsCapabilities[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new ImsCapabilities[0];
                    }
                }
            }
            return _emptyArray;
        }

        public ImsCapabilities() {
            clear();
        }

        public ImsCapabilities clear() {
            this.voiceOverLte = false;
            this.voiceOverWifi = false;
            this.videoOverLte = false;
            this.videoOverWifi = false;
            this.utOverLte = false;
            this.utOverWifi = false;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            boolean z = this.voiceOverLte;
            if (z) {
                codedOutputByteBufferNano.writeBool(1, z);
            }
            boolean z2 = this.voiceOverWifi;
            if (z2) {
                codedOutputByteBufferNano.writeBool(2, z2);
            }
            boolean z3 = this.videoOverLte;
            if (z3) {
                codedOutputByteBufferNano.writeBool(3, z3);
            }
            boolean z4 = this.videoOverWifi;
            if (z4) {
                codedOutputByteBufferNano.writeBool(4, z4);
            }
            boolean z5 = this.utOverLte;
            if (z5) {
                codedOutputByteBufferNano.writeBool(5, z5);
            }
            boolean z6 = this.utOverWifi;
            if (z6) {
                codedOutputByteBufferNano.writeBool(6, z6);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            boolean z = this.voiceOverLte;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(1, z);
            }
            boolean z2 = this.voiceOverWifi;
            if (z2) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(2, z2);
            }
            boolean z3 = this.videoOverLte;
            if (z3) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(3, z3);
            }
            boolean z4 = this.videoOverWifi;
            if (z4) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(4, z4);
            }
            boolean z5 = this.utOverLte;
            if (z5) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(5, z5);
            }
            boolean z6 = this.utOverWifi;
            return z6 ? computeSerializedSize + CodedOutputByteBufferNano.computeBoolSize(6, z6) : computeSerializedSize;
        }

        public ImsCapabilities mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.voiceOverLte = codedInputByteBufferNano.readBool();
                } else if (readTag == 16) {
                    this.voiceOverWifi = codedInputByteBufferNano.readBool();
                } else if (readTag == 24) {
                    this.videoOverLte = codedInputByteBufferNano.readBool();
                } else if (readTag == 32) {
                    this.videoOverWifi = codedInputByteBufferNano.readBool();
                } else if (readTag == 40) {
                    this.utOverLte = codedInputByteBufferNano.readBool();
                } else if (readTag == 48) {
                    this.utOverWifi = codedInputByteBufferNano.readBool();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static ImsCapabilities parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (ImsCapabilities) MessageNano.mergeFrom(new ImsCapabilities(), bArr);
        }

        public static ImsCapabilities parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new ImsCapabilities().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class RilDataCall extends ExtendableMessageNano<RilDataCall> {
        private static volatile RilDataCall[] _emptyArray;
        public int apnTypeBitmask;
        public int cid;
        public String ifname;
        public int state;
        public int type;

        public interface State {
            public static final int CONNECTED = 1;
            public static final int DISCONNECTED = 2;
            public static final int UNKNOWN = 0;
        }

        public static RilDataCall[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new RilDataCall[0];
                    }
                }
            }
            return _emptyArray;
        }

        public RilDataCall() {
            clear();
        }

        public RilDataCall clear() {
            this.cid = 0;
            this.type = 0;
            this.ifname = "";
            this.state = 0;
            this.apnTypeBitmask = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.cid;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.type;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            if (!this.ifname.equals("")) {
                codedOutputByteBufferNano.writeString(3, this.ifname);
            }
            int i3 = this.state;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i3);
            }
            int i4 = this.apnTypeBitmask;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i4);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.cid;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            int i2 = this.type;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            if (!this.ifname.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(3, this.ifname);
            }
            int i3 = this.state;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i3);
            }
            int i4 = this.apnTypeBitmask;
            return i4 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(5, i4) : computeSerializedSize;
        }

        public RilDataCall mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag != 8) {
                    if (readTag == 16) {
                        int readInt32 = codedInputByteBufferNano.readInt32();
                        switch (readInt32) {
                            case 0:
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                            case 6:
                                this.type = readInt32;
                                break;
                        }
                    } else if (readTag == 26) {
                        this.ifname = codedInputByteBufferNano.readString();
                    } else if (readTag == 32) {
                        int readInt322 = codedInputByteBufferNano.readInt32();
                        if (readInt322 == 0 || readInt322 == 1 || readInt322 == 2) {
                            this.state = readInt322;
                        }
                    } else if (readTag == 40) {
                        this.apnTypeBitmask = codedInputByteBufferNano.readInt32();
                    } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                        return this;
                    }
                } else {
                    this.cid = codedInputByteBufferNano.readInt32();
                }
            }
        }

        public static RilDataCall parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (RilDataCall) MessageNano.mergeFrom(new RilDataCall(), bArr);
        }

        public static RilDataCall parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new RilDataCall().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class EmergencyNumberInfo extends ExtendableMessageNano<EmergencyNumberInfo> {
        private static volatile EmergencyNumberInfo[] _emptyArray;
        public String address;
        public String countryIso;
        public String mnc;
        public int numberSourcesBitmask;
        public int routing;
        public int serviceCategoriesBitmask;
        public String[] urns;

        public static EmergencyNumberInfo[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new EmergencyNumberInfo[0];
                    }
                }
            }
            return _emptyArray;
        }

        public EmergencyNumberInfo() {
            clear();
        }

        public EmergencyNumberInfo clear() {
            this.address = "";
            this.countryIso = "";
            this.mnc = "";
            this.serviceCategoriesBitmask = 0;
            this.urns = WireFormatNano.EMPTY_STRING_ARRAY;
            this.numberSourcesBitmask = 0;
            this.routing = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            if (!this.address.equals("")) {
                codedOutputByteBufferNano.writeString(1, this.address);
            }
            if (!this.countryIso.equals("")) {
                codedOutputByteBufferNano.writeString(2, this.countryIso);
            }
            if (!this.mnc.equals("")) {
                codedOutputByteBufferNano.writeString(3, this.mnc);
            }
            int i = this.serviceCategoriesBitmask;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(4, i);
            }
            String[] strArr = this.urns;
            if (strArr != null && strArr.length > 0) {
                int i2 = 0;
                while (true) {
                    String[] strArr2 = this.urns;
                    if (i2 >= strArr2.length) {
                        break;
                    }
                    String str = strArr2[i2];
                    if (str != null) {
                        codedOutputByteBufferNano.writeString(5, str);
                    }
                    i2++;
                }
            }
            int i3 = this.numberSourcesBitmask;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i3);
            }
            int i4 = this.routing;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(7, i4);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            if (!this.address.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(1, this.address);
            }
            if (!this.countryIso.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(2, this.countryIso);
            }
            if (!this.mnc.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(3, this.mnc);
            }
            int i = this.serviceCategoriesBitmask;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i);
            }
            String[] strArr = this.urns;
            if (strArr != null && strArr.length > 0) {
                int i2 = 0;
                int i3 = 0;
                int i4 = 0;
                while (true) {
                    String[] strArr2 = this.urns;
                    if (i2 >= strArr2.length) {
                        break;
                    }
                    String str = strArr2[i2];
                    if (str != null) {
                        i4++;
                        i3 += CodedOutputByteBufferNano.computeStringSizeNoTag(str);
                    }
                    i2++;
                }
                computeSerializedSize = computeSerializedSize + i3 + (i4 * 1);
            }
            int i5 = this.numberSourcesBitmask;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i5);
            }
            int i6 = this.routing;
            return i6 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(7, i6) : computeSerializedSize;
        }

        public EmergencyNumberInfo mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 10) {
                    this.address = codedInputByteBufferNano.readString();
                } else if (readTag == 18) {
                    this.countryIso = codedInputByteBufferNano.readString();
                } else if (readTag == 26) {
                    this.mnc = codedInputByteBufferNano.readString();
                } else if (readTag == 32) {
                    this.serviceCategoriesBitmask = codedInputByteBufferNano.readInt32();
                } else if (readTag == 42) {
                    int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 42);
                    String[] strArr = this.urns;
                    int length = strArr == null ? 0 : strArr.length;
                    int i = repeatedFieldArrayLength + length;
                    String[] strArr2 = new String[i];
                    if (length != 0) {
                        System.arraycopy(strArr, 0, strArr2, 0, length);
                    }
                    while (length < i - 1) {
                        strArr2[length] = codedInputByteBufferNano.readString();
                        codedInputByteBufferNano.readTag();
                        length++;
                    }
                    strArr2[length] = codedInputByteBufferNano.readString();
                    this.urns = strArr2;
                } else if (readTag == 48) {
                    this.numberSourcesBitmask = codedInputByteBufferNano.readInt32();
                } else if (readTag == 56) {
                    this.routing = codedInputByteBufferNano.readInt32();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static EmergencyNumberInfo parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (EmergencyNumberInfo) MessageNano.mergeFrom(new EmergencyNumberInfo(), bArr);
        }

        public static EmergencyNumberInfo parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new EmergencyNumberInfo().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class TelephonyEvent extends ExtendableMessageNano<TelephonyEvent> {
        private static volatile TelephonyEvent[] _emptyArray;
        public ActiveSubscriptionInfo activeSubscriptionInfo;
        public CarrierIdMatching carrierIdMatching;
        public CarrierKeyChange carrierKeyChange;
        public RilDataCall[] dataCalls;
        public int dataStallAction;
        public DataSwitch dataSwitch;
        public RilDeactivateDataCall deactivateDataCall;
        public int emergencyNumberDatabaseVersion;
        public int enabledModemBitmap;
        public int error;
        public ImsCapabilities imsCapabilities;
        public ImsConnectionState imsConnectionState;
        public ModemRestart modemRestart;
        public NetworkCapabilitiesInfo networkCapabilities;
        public int networkValidationState;
        public long nitzTimestampMillis;
        public OnDemandDataSwitch onDemandDataSwitch;
        public int phoneId;
        public int radioState;
        public TelephonyServiceState serviceState;
        public TelephonySettings settings;
        public RilSetupDataCall setupDataCall;
        public RilSetupDataCallResponse setupDataCallResponse;
        public int signalStrength;
        public int[] simState;
        public long timestampMillis;
        public int type;
        public EmergencyNumberInfo updatedEmergencyNumber;

        public interface ApnType {
            public static final int APN_TYPE_CBS = 8;
            public static final int APN_TYPE_DEFAULT = 1;
            public static final int APN_TYPE_DUN = 4;
            public static final int APN_TYPE_EMERGENCY = 10;
            public static final int APN_TYPE_FOTA = 6;
            public static final int APN_TYPE_HIPRI = 5;
            public static final int APN_TYPE_IA = 9;
            public static final int APN_TYPE_IMS = 7;
            public static final int APN_TYPE_MMS = 2;
            public static final int APN_TYPE_SUPL = 3;
            public static final int APN_TYPE_UNKNOWN = 0;
        }

        public interface EventState {
            public static final int EVENT_STATE_END = 2;
            public static final int EVENT_STATE_START = 1;
            public static final int EVENT_STATE_UNKNOWN = 0;
        }

        public interface NetworkValidationState {
            public static final int NETWORK_VALIDATION_STATE_AVAILABLE = 1;
            public static final int NETWORK_VALIDATION_STATE_FAILED = 2;
            public static final int NETWORK_VALIDATION_STATE_PASSED = 3;
            public static final int NETWORK_VALIDATION_STATE_UNKNOWN = 0;
        }

        public interface RadioState {
            public static final int RADIO_STATE_OFF = 1;
            public static final int RADIO_STATE_ON = 2;
            public static final int RADIO_STATE_UNAVAILABLE = 3;
            public static final int RADIO_STATE_UNKNOWN = 0;
        }

        public interface Type {
            public static final int ACTIVE_SUBSCRIPTION_INFO_CHANGED = 19;
            public static final int CARRIER_ID_MATCHING = 13;
            public static final int CARRIER_KEY_CHANGED = 14;
            public static final int DATA_CALL_DEACTIVATE = 8;
            public static final int DATA_CALL_DEACTIVATE_RESPONSE = 9;
            public static final int DATA_CALL_LIST_CHANGED = 7;
            public static final int DATA_CALL_SETUP = 5;
            public static final int DATA_CALL_SETUP_RESPONSE = 6;
            public static final int DATA_STALL_ACTION = 10;
            public static final int DATA_SWITCH = 15;
            public static final int EMERGENCY_NUMBER_REPORT = 21;
            public static final int ENABLED_MODEM_CHANGED = 20;
            public static final int IMS_CAPABILITIES_CHANGED = 4;
            public static final int IMS_CONNECTION_STATE_CHANGED = 3;
            public static final int MODEM_RESTART = 11;
            public static final int NETWORK_CAPABILITIES_CHANGED = 22;
            public static final int NETWORK_VALIDATE = 16;
            public static final int NITZ_TIME = 12;
            public static final int ON_DEMAND_DATA_SWITCH = 17;
            public static final int RADIO_STATE_CHANGED = 24;
            public static final int RIL_SERVICE_STATE_CHANGED = 2;
            public static final int SETTINGS_CHANGED = 1;
            public static final int SIGNAL_STRENGTH = 23;
            public static final int SIM_STATE_CHANGED = 18;
            public static final int UNKNOWN = 0;
        }

        public static final class DataSwitch extends ExtendableMessageNano<DataSwitch> {
            private static volatile DataSwitch[] _emptyArray;
            public int reason;
            public int state;

            public interface Reason {
                public static final int DATA_SWITCH_REASON_CBRS = 3;
                public static final int DATA_SWITCH_REASON_IN_CALL = 2;
                public static final int DATA_SWITCH_REASON_MANUAL = 1;
                public static final int DATA_SWITCH_REASON_UNKNOWN = 0;
            }

            public static DataSwitch[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new DataSwitch[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public DataSwitch() {
                clear();
            }

            public DataSwitch clear() {
                this.reason = 0;
                this.state = 0;
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                int i = this.reason;
                if (i != 0) {
                    codedOutputByteBufferNano.writeInt32(1, i);
                }
                int i2 = this.state;
                if (i2 != 0) {
                    codedOutputByteBufferNano.writeInt32(2, i2);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                int i = this.reason;
                if (i != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                }
                int i2 = this.state;
                return i2 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(2, i2) : computeSerializedSize;
            }

            public DataSwitch mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    if (readTag == 0) {
                        return this;
                    }
                    if (readTag == 8) {
                        int readInt32 = codedInputByteBufferNano.readInt32();
                        if (readInt32 == 0 || readInt32 == 1 || readInt32 == 2 || readInt32 == 3) {
                            this.reason = readInt32;
                        }
                    } else if (readTag == 16) {
                        int readInt322 = codedInputByteBufferNano.readInt32();
                        if (readInt322 == 0 || readInt322 == 1 || readInt322 == 2) {
                            this.state = readInt322;
                        }
                    } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                        return this;
                    }
                }
            }

            public static DataSwitch parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (DataSwitch) MessageNano.mergeFrom(new DataSwitch(), bArr);
            }

            public static DataSwitch parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new DataSwitch().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static final class OnDemandDataSwitch extends ExtendableMessageNano<OnDemandDataSwitch> {
            private static volatile OnDemandDataSwitch[] _emptyArray;
            public int apn;
            public int state;

            public static OnDemandDataSwitch[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new OnDemandDataSwitch[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public OnDemandDataSwitch() {
                clear();
            }

            public OnDemandDataSwitch clear() {
                this.apn = 0;
                this.state = 0;
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                int i = this.apn;
                if (i != 0) {
                    codedOutputByteBufferNano.writeInt32(1, i);
                }
                int i2 = this.state;
                if (i2 != 0) {
                    codedOutputByteBufferNano.writeInt32(2, i2);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                int i = this.apn;
                if (i != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                }
                int i2 = this.state;
                return i2 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(2, i2) : computeSerializedSize;
            }

            public OnDemandDataSwitch mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    if (readTag != 0) {
                        if (readTag == 8) {
                            int readInt32 = codedInputByteBufferNano.readInt32();
                            switch (readInt32) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                    this.apn = readInt32;
                                    break;
                            }
                        } else if (readTag == 16) {
                            int readInt322 = codedInputByteBufferNano.readInt32();
                            if (readInt322 == 0 || readInt322 == 1 || readInt322 == 2) {
                                this.state = readInt322;
                            }
                        } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                            return this;
                        }
                    } else {
                        return this;
                    }
                }
            }

            public static OnDemandDataSwitch parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (OnDemandDataSwitch) MessageNano.mergeFrom(new OnDemandDataSwitch(), bArr);
            }

            public static OnDemandDataSwitch parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new OnDemandDataSwitch().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static final class RilSetupDataCall extends ExtendableMessageNano<RilSetupDataCall> {
            private static volatile RilSetupDataCall[] _emptyArray;
            public String apn;
            public int dataProfile;
            public int rat;
            public int type;

            public interface RilDataProfile {
                public static final int RIL_DATA_PROFILE_CBS = 5;
                public static final int RIL_DATA_PROFILE_DEFAULT = 1;
                public static final int RIL_DATA_PROFILE_FOTA = 4;
                public static final int RIL_DATA_PROFILE_IMS = 3;
                public static final int RIL_DATA_PROFILE_INVALID = 7;
                public static final int RIL_DATA_PROFILE_OEM_BASE = 6;
                public static final int RIL_DATA_PROFILE_TETHERED = 2;
                public static final int RIL_DATA_UNKNOWN = 0;
            }

            public static RilSetupDataCall[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new RilSetupDataCall[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public RilSetupDataCall() {
                clear();
            }

            public RilSetupDataCall clear() {
                this.rat = -1;
                this.dataProfile = 0;
                this.apn = "";
                this.type = 0;
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                int i = this.rat;
                if (i != -1) {
                    codedOutputByteBufferNano.writeInt32(1, i);
                }
                int i2 = this.dataProfile;
                if (i2 != 0) {
                    codedOutputByteBufferNano.writeInt32(2, i2);
                }
                if (!this.apn.equals("")) {
                    codedOutputByteBufferNano.writeString(3, this.apn);
                }
                int i3 = this.type;
                if (i3 != 0) {
                    codedOutputByteBufferNano.writeInt32(4, i3);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                int i = this.rat;
                if (i != -1) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                }
                int i2 = this.dataProfile;
                if (i2 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
                }
                if (!this.apn.equals("")) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(3, this.apn);
                }
                int i3 = this.type;
                return i3 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(4, i3) : computeSerializedSize;
            }

            public RilSetupDataCall mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    if (readTag != 0) {
                        if (readTag != 8) {
                            if (readTag == 16) {
                                int readInt32 = codedInputByteBufferNano.readInt32();
                                switch (readInt32) {
                                    case 0:
                                    case 1:
                                    case 2:
                                    case 3:
                                    case 4:
                                    case 5:
                                    case 6:
                                    case 7:
                                        this.dataProfile = readInt32;
                                        break;
                                }
                            } else if (readTag != 26) {
                                if (readTag == 32) {
                                    int readInt322 = codedInputByteBufferNano.readInt32();
                                    switch (readInt322) {
                                        case 0:
                                        case 1:
                                        case 2:
                                        case 3:
                                        case 4:
                                        case 5:
                                        case 6:
                                            this.type = readInt322;
                                            break;
                                    }
                                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                                    return this;
                                }
                            } else {
                                this.apn = codedInputByteBufferNano.readString();
                            }
                        } else {
                            int readInt323 = codedInputByteBufferNano.readInt32();
                            switch (readInt323) {
                                case -1:
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                case 11:
                                case 12:
                                case 13:
                                case 14:
                                case 15:
                                case 16:
                                case 17:
                                case 18:
                                case 19:
                                case 20:
                                    this.rat = readInt323;
                                    break;
                            }
                        }
                    } else {
                        return this;
                    }
                }
            }

            public static RilSetupDataCall parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (RilSetupDataCall) MessageNano.mergeFrom(new RilSetupDataCall(), bArr);
            }

            public static RilSetupDataCall parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new RilSetupDataCall().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static final class RilSetupDataCallResponse extends ExtendableMessageNano<RilSetupDataCallResponse> {
            private static volatile RilSetupDataCallResponse[] _emptyArray;
            public RilDataCall call;
            public int status;
            public int suggestedRetryTimeMillis;

            public interface RilDataCallFailCause {
                public static final int PDP_FAIL_ACCESS_ATTEMPT_ALREADY_IN_PROGRESS = 2219;
                public static final int PDP_FAIL_ACCESS_BLOCK = 2087;
                public static final int PDP_FAIL_ACCESS_BLOCK_ALL = 2088;
                public static final int PDP_FAIL_ACCESS_CLASS_DSAC_REJECTION = 2108;
                public static final int PDP_FAIL_ACCESS_CONTROL_LIST_CHECK_FAILURE = 2128;
                public static final int PDP_FAIL_ACTIVATION_REJECTED_BCM_VIOLATION = 48;
                public static final int PDP_FAIL_ACTIVATION_REJECT_GGSN = 30;
                public static final int PDP_FAIL_ACTIVATION_REJECT_UNSPECIFIED = 31;
                public static final int PDP_FAIL_APN_DISABLED = 2045;
                public static final int PDP_FAIL_APN_DISALLOWED_ON_ROAMING = 2059;
                public static final int PDP_FAIL_APN_MISMATCH = 2054;
                public static final int PDP_FAIL_APN_PARAMETERS_CHANGED = 2060;
                public static final int PDP_FAIL_APN_PENDING_HANDOVER = 2041;
                public static final int PDP_FAIL_APN_TYPE_CONFLICT = 112;
                public static final int PDP_FAIL_AUTH_FAILURE_ON_EMERGENCY_CALL = 122;
                public static final int PDP_FAIL_BEARER_HANDLING_NOT_SUPPORTED = 60;
                public static final int PDP_FAIL_CALL_DISALLOWED_IN_ROAMING = 2068;
                public static final int PDP_FAIL_CALL_PREEMPT_BY_EMERGENCY_APN = 127;
                public static final int PDP_FAIL_CANNOT_ENCODE_OTA_MESSAGE = 2159;
                public static final int PDP_FAIL_CDMA_ALERT_STOP = 2077;
                public static final int PDP_FAIL_CDMA_INCOMING_CALL = 2076;
                public static final int PDP_FAIL_CDMA_INTERCEPT = 2073;
                public static final int PDP_FAIL_CDMA_LOCK = 2072;
                public static final int PDP_FAIL_CDMA_RELEASE_DUE_TO_SO_REJECTION = 2075;
                public static final int PDP_FAIL_CDMA_REORDER = 2074;
                public static final int PDP_FAIL_CDMA_RETRY_ORDER = 2086;
                public static final int PDP_FAIL_CHANNEL_ACQUISITION_FAILURE = 2078;
                public static final int PDP_FAIL_CLOSE_IN_PROGRESS = 2030;
                public static final int PDP_FAIL_COLLISION_WITH_NETWORK_INITIATED_REQUEST = 56;
                public static final int PDP_FAIL_COMPANION_IFACE_IN_USE = 118;
                public static final int PDP_FAIL_CONCURRENT_SERVICES_INCOMPATIBLE = 2083;
                public static final int PDP_FAIL_CONCURRENT_SERVICES_NOT_ALLOWED = 2091;
                public static final int PDP_FAIL_CONCURRENT_SERVICE_NOT_SUPPORTED_BY_BASE_STATION = 2080;
                public static final int PDP_FAIL_CONDITIONAL_IE_ERROR = 100;
                public static final int PDP_FAIL_CONGESTION = 2106;
                public static final int PDP_FAIL_CONNECTION_RELEASED = 2113;
                public static final int PDP_FAIL_CS_DOMAIN_NOT_AVAILABLE = 2181;
                public static final int PDP_FAIL_CS_FALLBACK_CALL_ESTABLISHMENT_NOT_ALLOWED = 2188;
                public static final int PDP_FAIL_DATA_PLAN_EXPIRED = 2198;
                public static final int PDP_FAIL_DATA_REGISTRATION_FAIL = -2;
                public static final int PDP_FAIL_DATA_ROAMING_SETTINGS_DISABLED = 2064;
                public static final int PDP_FAIL_DATA_SETTINGS_DISABLED = 2063;
                public static final int PDP_FAIL_DBM_OR_SMS_IN_PROGRESS = 2211;
                public static final int PDP_FAIL_DDS_SWITCHED = 2065;
                public static final int PDP_FAIL_DDS_SWITCH_IN_PROGRESS = 2067;
                public static final int PDP_FAIL_DRB_RELEASED_BY_RRC = 2112;
                public static final int PDP_FAIL_DS_EXPLICIT_DEACTIVATION = 2125;
                public static final int PDP_FAIL_DUAL_SWITCH = 2227;
                public static final int PDP_FAIL_DUN_CALL_DISALLOWED = 2056;
                public static final int PDP_FAIL_DUPLICATE_BEARER_ID = 2118;
                public static final int PDP_FAIL_EHRPD_TO_HRPD_FALLBACK = 2049;
                public static final int PDP_FAIL_EMBMS_NOT_ENABLED = 2193;
                public static final int PDP_FAIL_EMBMS_REGULAR_DEACTIVATION = 2195;
                public static final int PDP_FAIL_EMERGENCY_IFACE_ONLY = 116;
                public static final int PDP_FAIL_EMERGENCY_MODE = 2221;
                public static final int PDP_FAIL_EMM_ACCESS_BARRED = 115;
                public static final int PDP_FAIL_EMM_ACCESS_BARRED_INFINITE_RETRY = 121;
                public static final int PDP_FAIL_EMM_ATTACH_FAILED = 2115;
                public static final int PDP_FAIL_EMM_ATTACH_STARTED = 2116;
                public static final int PDP_FAIL_EMM_DETACHED = 2114;
                public static final int PDP_FAIL_EMM_T3417_EXPIRED = 2130;
                public static final int PDP_FAIL_EMM_T3417_EXT_EXPIRED = 2131;
                public static final int PDP_FAIL_EPS_SERVICES_AND_NON_EPS_SERVICES_NOT_ALLOWED = 2178;
                public static final int PDP_FAIL_EPS_SERVICES_NOT_ALLOWED_IN_PLMN = 2179;
                public static final int PDP_FAIL_ERROR_UNSPECIFIED = 65535;
                public static final int PDP_FAIL_ESM_BAD_OTA_MESSAGE = 2122;
                public static final int PDP_FAIL_ESM_BEARER_DEACTIVATED_TO_SYNC_WITH_NETWORK = 2120;
                public static final int PDP_FAIL_ESM_COLLISION_SCENARIOS = 2119;
                public static final int PDP_FAIL_ESM_CONTEXT_TRANSFERRED_DUE_TO_IRAT = 2124;
                public static final int PDP_FAIL_ESM_DOWNLOAD_SERVER_REJECTED_THE_CALL = 2123;
                public static final int PDP_FAIL_ESM_FAILURE = 2182;
                public static final int PDP_FAIL_ESM_INFO_NOT_RECEIVED = 53;
                public static final int PDP_FAIL_ESM_LOCAL_CAUSE_NONE = 2126;
                public static final int PDP_FAIL_ESM_NW_ACTIVATED_DED_BEARER_WITH_ID_OF_DEF_BEARER = 2121;
                public static final int PDP_FAIL_ESM_PROCEDURE_TIME_OUT = 2155;
                public static final int PDP_FAIL_ESM_UNKNOWN_EPS_BEARER_CONTEXT = 2111;
                public static final int PDP_FAIL_EVDO_CONNECTION_DENY_BY_BILLING_OR_AUTHENTICATION_FAILURE = 2201;
                public static final int PDP_FAIL_EVDO_CONNECTION_DENY_BY_GENERAL_OR_NETWORK_BUSY = 2200;
                public static final int PDP_FAIL_EVDO_HDR_CHANGED = 2202;
                public static final int PDP_FAIL_EVDO_HDR_CONNECTION_SETUP_TIMEOUT = 2206;
                public static final int PDP_FAIL_EVDO_HDR_EXITED = 2203;
                public static final int PDP_FAIL_EVDO_HDR_NO_SESSION = 2204;
                public static final int PDP_FAIL_EVDO_USING_GPS_FIX_INSTEAD_OF_HDR_CALL = 2205;
                public static final int PDP_FAIL_FADE = 2217;
                public static final int PDP_FAIL_FAILED_TO_ACQUIRE_COLOCATED_HDR = 2207;
                public static final int PDP_FAIL_FEATURE_NOT_SUPP = 40;
                public static final int PDP_FAIL_FILTER_SEMANTIC_ERROR = 44;
                public static final int PDP_FAIL_FILTER_SYTAX_ERROR = 45;
                public static final int PDP_FAIL_FORBIDDEN_APN_NAME = 2066;
                public static final int PDP_FAIL_GPRS_SERVICES_AND_NON_GPRS_SERVICES_NOT_ALLOWED = 2097;
                public static final int PDP_FAIL_GPRS_SERVICES_NOT_ALLOWED = 2098;
                public static final int PDP_FAIL_GPRS_SERVICES_NOT_ALLOWED_IN_THIS_PLMN = 2103;
                public static final int PDP_FAIL_HANDOFF_PREFERENCE_CHANGED = 2251;
                public static final int PDP_FAIL_HDR_ACCESS_FAILURE = 2213;
                public static final int PDP_FAIL_HDR_FADE = 2212;
                public static final int PDP_FAIL_HDR_NO_LOCK_GRANTED = 2210;
                public static final int PDP_FAIL_IFACE_AND_POL_FAMILY_MISMATCH = 120;
                public static final int PDP_FAIL_IFACE_MISMATCH = 117;
                public static final int PDP_FAIL_ILLEGAL_ME = 2096;
                public static final int PDP_FAIL_ILLEGAL_MS = 2095;
                public static final int PDP_FAIL_IMEI_NOT_ACCEPTED = 2177;
                public static final int PDP_FAIL_IMPLICITLY_DETACHED = 2100;
                public static final int PDP_FAIL_IMSI_UNKNOWN_IN_HOME_SUBSCRIBER_SERVER = 2176;
                public static final int PDP_FAIL_INCOMING_CALL_REJECTED = 2092;
                public static final int PDP_FAIL_INSUFFICIENT_RESOURCES = 26;
                public static final int PDP_FAIL_INTERFACE_IN_USE = 2058;
                public static final int PDP_FAIL_INTERNAL_CALL_PREEMPT_BY_HIGH_PRIO_APN = 114;
                public static final int PDP_FAIL_INTERNAL_EPC_NONEPC_TRANSITION = 2057;
                public static final int PDP_FAIL_INVALID_CONNECTION_ID = 2156;
                public static final int PDP_FAIL_INVALID_DNS_ADDR = 123;
                public static final int PDP_FAIL_INVALID_EMM_STATE = 2190;
                public static final int PDP_FAIL_INVALID_MANDATORY_INFO = 96;
                public static final int PDP_FAIL_INVALID_MODE = 2223;
                public static final int PDP_FAIL_INVALID_PCSCF_ADDR = 113;
                public static final int PDP_FAIL_INVALID_PCSCF_OR_DNS_ADDRESS = 124;
                public static final int PDP_FAIL_INVALID_PRIMARY_NSAPI = 2158;
                public static final int PDP_FAIL_INVALID_SIM_STATE = 2224;
                public static final int PDP_FAIL_INVALID_TRANSACTION_ID = 81;
                public static final int PDP_FAIL_IPV6_ADDRESS_TRANSFER_FAILED = 2047;
                public static final int PDP_FAIL_IPV6_PREFIX_UNAVAILABLE = 2250;
                public static final int PDP_FAIL_IP_ADDRESS_MISMATCH = 119;
                public static final int PDP_FAIL_IP_VERSION_MISMATCH = 2055;
                public static final int PDP_FAIL_IRAT_HANDOVER_FAILED = 2194;
                public static final int PDP_FAIL_IS707B_MAX_ACCESS_PROBES = 2089;
                public static final int PDP_FAIL_LIMITED_TO_IPV4 = 2234;
                public static final int PDP_FAIL_LIMITED_TO_IPV6 = 2235;
                public static final int PDP_FAIL_LLC_SNDCP = 25;
                public static final int PDP_FAIL_LOCAL_END = 2215;
                public static final int PDP_FAIL_LOCATION_AREA_NOT_ALLOWED = 2102;
                public static final int PDP_FAIL_LOWER_LAYER_REGISTRATION_FAILURE = 2197;
                public static final int PDP_FAIL_LOW_POWER_MODE_OR_POWERING_DOWN = 2044;
                public static final int PDP_FAIL_LTE_NAS_SERVICE_REQUEST_FAILED = 2117;
                public static final int PDP_FAIL_LTE_THROTTLING_NOT_REQUIRED = 2127;
                public static final int PDP_FAIL_MAC_FAILURE = 2183;
                public static final int PDP_FAIL_MAXIMIUM_NSAPIS_EXCEEDED = 2157;
                public static final int PDP_FAIL_MAXINUM_SIZE_OF_L2_MESSAGE_EXCEEDED = 2166;
                public static final int PDP_FAIL_MAX_ACCESS_PROBE = 2079;
                public static final int PDP_FAIL_MAX_ACTIVE_PDP_CONTEXT_REACHED = 65;
                public static final int PDP_FAIL_MAX_IPV4_CONNECTIONS = 2052;
                public static final int PDP_FAIL_MAX_IPV6_CONNECTIONS = 2053;
                public static final int PDP_FAIL_MAX_PPP_INACTIVITY_TIMER_EXPIRED = 2046;
                public static final int PDP_FAIL_MESSAGE_INCORRECT_SEMANTIC = 95;
                public static final int PDP_FAIL_MESSAGE_TYPE_UNSUPPORTED = 97;
                public static final int PDP_FAIL_MIP_CONFIG_FAILURE = 2050;
                public static final int PDP_FAIL_MIP_FA_ADMIN_PROHIBITED = 2001;
                public static final int PDP_FAIL_MIP_FA_DELIVERY_STYLE_NOT_SUPPORTED = 2012;
                public static final int PDP_FAIL_MIP_FA_ENCAPSULATION_UNAVAILABLE = 2008;
                public static final int PDP_FAIL_MIP_FA_HOME_AGENT_AUTHENTICATION_FAILURE = 2004;
                public static final int PDP_FAIL_MIP_FA_INSUFFICIENT_RESOURCES = 2002;
                public static final int PDP_FAIL_MIP_FA_MALFORMED_REPLY = 2007;
                public static final int PDP_FAIL_MIP_FA_MALFORMED_REQUEST = 2006;
                public static final int PDP_FAIL_MIP_FA_MISSING_CHALLENGE = 2017;
                public static final int PDP_FAIL_MIP_FA_MISSING_HOME_ADDRESS = 2015;
                public static final int PDP_FAIL_MIP_FA_MISSING_HOME_AGENT = 2014;
                public static final int PDP_FAIL_MIP_FA_MISSING_NAI = 2013;
                public static final int PDP_FAIL_MIP_FA_MOBILE_NODE_AUTHENTICATION_FAILURE = 2003;
                public static final int PDP_FAIL_MIP_FA_REASON_UNSPECIFIED = 2000;
                public static final int PDP_FAIL_MIP_FA_REQUESTED_LIFETIME_TOO_LONG = 2005;
                public static final int PDP_FAIL_MIP_FA_REVERSE_TUNNEL_IS_MANDATORY = 2011;
                public static final int PDP_FAIL_MIP_FA_REVERSE_TUNNEL_UNAVAILABLE = 2010;
                public static final int PDP_FAIL_MIP_FA_STALE_CHALLENGE = 2018;
                public static final int PDP_FAIL_MIP_FA_UNKNOWN_CHALLENGE = 2016;
                public static final int PDP_FAIL_MIP_FA_VJ_HEADER_COMPRESSION_UNAVAILABLE = 2009;
                public static final int PDP_FAIL_MIP_HA_ADMIN_PROHIBITED = 2020;
                public static final int PDP_FAIL_MIP_HA_ENCAPSULATION_UNAVAILABLE = 2029;
                public static final int PDP_FAIL_MIP_HA_FOREIGN_AGENT_AUTHENTICATION_FAILURE = 2023;
                public static final int PDP_FAIL_MIP_HA_INSUFFICIENT_RESOURCES = 2021;
                public static final int PDP_FAIL_MIP_HA_MALFORMED_REQUEST = 2025;
                public static final int PDP_FAIL_MIP_HA_MOBILE_NODE_AUTHENTICATION_FAILURE = 2022;
                public static final int PDP_FAIL_MIP_HA_REASON_UNSPECIFIED = 2019;
                public static final int PDP_FAIL_MIP_HA_REGISTRATION_ID_MISMATCH = 2024;
                public static final int PDP_FAIL_MIP_HA_REVERSE_TUNNEL_IS_MANDATORY = 2028;
                public static final int PDP_FAIL_MIP_HA_REVERSE_TUNNEL_UNAVAILABLE = 2027;
                public static final int PDP_FAIL_MIP_HA_UNKNOWN_HOME_AGENT_ADDRESS = 2026;
                public static final int PDP_FAIL_MISSING_UKNOWN_APN = 27;
                public static final int PDP_FAIL_MODEM_APP_PREEMPTED = 2032;
                public static final int PDP_FAIL_MODEM_RESTART = 2037;
                public static final int PDP_FAIL_MSC_TEMPORARILY_NOT_REACHABLE = 2180;
                public static final int PDP_FAIL_MSG_AND_PROTOCOL_STATE_UNCOMPATIBLE = 101;
                public static final int PDP_FAIL_MSG_TYPE_NONCOMPATIBLE_STATE = 98;
                public static final int PDP_FAIL_MS_IDENTITY_CANNOT_BE_DERIVED_BY_THE_NETWORK = 2099;
                public static final int PDP_FAIL_MULTIPLE_PDP_CALL_NOT_ALLOWED = 2192;
                public static final int PDP_FAIL_MULTI_CONN_TO_SAME_PDN_NOT_ALLOWED = 55;
                public static final int PDP_FAIL_NAS_LAYER_FAILURE = 2191;
                public static final int PDP_FAIL_NAS_REQUEST_REJECTED_BY_NETWORK = 2167;
                public static final int PDP_FAIL_NAS_SIGNALLING = 14;
                public static final int PDP_FAIL_NETWORK_FAILURE = 38;
                public static final int PDP_FAIL_NETWORK_INITIATED_DETACH_NO_AUTO_REATTACH = 2154;
                public static final int PDP_FAIL_NETWORK_INITIATED_DETACH_WITH_AUTO_REATTACH = 2153;
                public static final int PDP_FAIL_NETWORK_INITIATED_TERMINATION = 2031;
                public static final int PDP_FAIL_NONE = 1;
                public static final int PDP_FAIL_NON_IP_NOT_SUPPORTED = 2069;
                public static final int PDP_FAIL_NORMAL_RELEASE = 2218;
                public static final int PDP_FAIL_NO_CDMA_SERVICE = 2084;
                public static final int PDP_FAIL_NO_COLLOCATED_HDR = 2225;
                public static final int PDP_FAIL_NO_EPS_BEARER_CONTEXT_ACTIVATED = 2189;
                public static final int PDP_FAIL_NO_GPRS_CONTEXT = 2094;
                public static final int PDP_FAIL_NO_HYBRID_HDR_SERVICE = 2209;
                public static final int PDP_FAIL_NO_PDP_CONTEXT_ACTIVATED = 2107;
                public static final int PDP_FAIL_NO_RESPONSE_FROM_BASE_STATION = 2081;
                public static final int PDP_FAIL_NO_SERVICE = 2216;
                public static final int PDP_FAIL_NO_SERVICE_ON_GATEWAY = 2093;
                public static final int PDP_FAIL_NSAPI_IN_USE = 35;
                public static final int PDP_FAIL_NULL_APN_DISALLOWED = 2061;
                public static final int PDP_FAIL_ONLY_IPV4V6_ALLOWED = 57;
                public static final int PDP_FAIL_ONLY_IPV4_ALLOWED = 50;
                public static final int PDP_FAIL_ONLY_IPV6_ALLOWED = 51;
                public static final int PDP_FAIL_ONLY_NON_IP_ALLOWED = 58;
                public static final int PDP_FAIL_ONLY_SINGLE_BEARER_ALLOWED = 52;
                public static final int PDP_FAIL_OPERATOR_BARRED = 8;
                public static final int PDP_FAIL_OTASP_COMMIT_IN_PROGRESS = 2208;
                public static final int PDP_FAIL_PDN_CONN_DOES_NOT_EXIST = 54;
                public static final int PDP_FAIL_PDN_INACTIVITY_TIMER_EXPIRED = 2051;
                public static final int PDP_FAIL_PDN_IPV4_CALL_DISALLOWED = 2033;
                public static final int PDP_FAIL_PDN_IPV4_CALL_THROTTLED = 2034;
                public static final int PDP_FAIL_PDN_IPV6_CALL_DISALLOWED = 2035;
                public static final int PDP_FAIL_PDN_IPV6_CALL_THROTTLED = 2036;
                public static final int PDP_FAIL_PDN_NON_IP_CALL_DISALLOWED = 2071;
                public static final int PDP_FAIL_PDN_NON_IP_CALL_THROTTLED = 2070;
                public static final int PDP_FAIL_PDP_ACTIVATE_MAX_RETRY_FAILED = 2109;
                public static final int PDP_FAIL_PDP_DUPLICATE = 2104;
                public static final int PDP_FAIL_PDP_ESTABLISH_TIMEOUT_EXPIRED = 2161;
                public static final int PDP_FAIL_PDP_INACTIVE_TIMEOUT_EXPIRED = 2163;
                public static final int PDP_FAIL_PDP_LOWERLAYER_ERROR = 2164;
                public static final int PDP_FAIL_PDP_MODIFY_COLLISION = 2165;
                public static final int PDP_FAIL_PDP_MODIFY_TIMEOUT_EXPIRED = 2162;
                public static final int PDP_FAIL_PDP_PPP_NOT_SUPPORTED = 2038;
                public static final int PDP_FAIL_PDP_WITHOUT_ACTIVE_TFT = 46;
                public static final int PDP_FAIL_PHONE_IN_USE = 2222;
                public static final int PDP_FAIL_PHYSICAL_LINK_CLOSE_IN_PROGRESS = 2040;
                public static final int PDP_FAIL_PLMN_NOT_ALLOWED = 2101;
                public static final int PDP_FAIL_PPP_AUTH_FAILURE = 2229;
                public static final int PDP_FAIL_PPP_CHAP_FAILURE = 2232;
                public static final int PDP_FAIL_PPP_CLOSE_IN_PROGRESS = 2233;
                public static final int PDP_FAIL_PPP_OPTION_MISMATCH = 2230;
                public static final int PDP_FAIL_PPP_PAP_FAILURE = 2231;
                public static final int PDP_FAIL_PPP_TIMEOUT = 2228;
                public static final int PDP_FAIL_PREF_RADIO_TECH_CHANGED = -4;
                public static final int PDP_FAIL_PROFILE_BEARER_INCOMPATIBLE = 2042;
                public static final int PDP_FAIL_PROTOCOL_ERRORS = 111;
                public static final int PDP_FAIL_QOS_NOT_ACCEPTED = 37;
                public static final int PDP_FAIL_RADIO_ACCESS_BEARER_FAILURE = 2110;
                public static final int PDP_FAIL_RADIO_ACCESS_BEARER_SETUP_FAILURE = 2160;
                public static final int PDP_FAIL_RADIO_POWER_OFF = -5;
                public static final int PDP_FAIL_REDIRECTION_OR_HANDOFF_IN_PROGRESS = 2220;
                public static final int PDP_FAIL_REGULAR_DEACTIVATION = 36;
                public static final int PDP_FAIL_REJECTED_BY_BASE_STATION = 2082;
                public static final int PDP_FAIL_RRC_CONNECTION_ABORTED_AFTER_HANDOVER = 2173;
                public static final int PDP_FAIL_RRC_CONNECTION_ABORTED_AFTER_IRAT_CELL_CHANGE = 2174;
                public static final int PDP_FAIL_RRC_CONNECTION_ABORTED_DUE_TO_IRAT_CHANGE = 2171;
                public static final int PDP_FAIL_RRC_CONNECTION_ABORTED_DURING_IRAT_CELL_CHANGE = 2175;
                public static final int PDP_FAIL_RRC_CONNECTION_ABORT_REQUEST = 2151;
                public static final int PDP_FAIL_RRC_CONNECTION_ACCESS_BARRED = 2139;
                public static final int PDP_FAIL_RRC_CONNECTION_ACCESS_STRATUM_FAILURE = 2137;
                public static final int PDP_FAIL_RRC_CONNECTION_ANOTHER_PROCEDURE_IN_PROGRESS = 2138;
                public static final int PDP_FAIL_RRC_CONNECTION_CELL_NOT_CAMPED = 2144;
                public static final int PDP_FAIL_RRC_CONNECTION_CELL_RESELECTION = 2140;
                public static final int PDP_FAIL_RRC_CONNECTION_CONFIG_FAILURE = 2141;
                public static final int PDP_FAIL_RRC_CONNECTION_INVALID_REQUEST = 2168;
                public static final int PDP_FAIL_RRC_CONNECTION_LINK_FAILURE = 2143;
                public static final int PDP_FAIL_RRC_CONNECTION_NORMAL_RELEASE = 2147;
                public static final int PDP_FAIL_RRC_CONNECTION_OUT_OF_SERVICE_DURING_CELL_REGISTER = 2150;
                public static final int PDP_FAIL_RRC_CONNECTION_RADIO_LINK_FAILURE = 2148;
                public static final int PDP_FAIL_RRC_CONNECTION_REESTABLISHMENT_FAILURE = 2149;
                public static final int PDP_FAIL_RRC_CONNECTION_REJECT_BY_NETWORK = 2146;
                public static final int PDP_FAIL_RRC_CONNECTION_RELEASED_SECURITY_NOT_ACTIVE = 2172;
                public static final int PDP_FAIL_RRC_CONNECTION_RF_UNAVAILABLE = 2170;
                public static final int PDP_FAIL_RRC_CONNECTION_SYSTEM_INFORMATION_BLOCK_READ_ERROR = 2152;
                public static final int PDP_FAIL_RRC_CONNECTION_SYSTEM_INTERVAL_FAILURE = 2145;
                public static final int PDP_FAIL_RRC_CONNECTION_TIMER_EXPIRED = 2142;
                public static final int PDP_FAIL_RRC_CONNECTION_TRACKING_AREA_ID_CHANGED = 2169;
                public static final int PDP_FAIL_RRC_UPLINK_CONNECTION_RELEASE = 2134;
                public static final int PDP_FAIL_RRC_UPLINK_DATA_TRANSMISSION_FAILURE = 2132;
                public static final int PDP_FAIL_RRC_UPLINK_DELIVERY_FAILED_DUE_TO_HANDOVER = 2133;
                public static final int PDP_FAIL_RRC_UPLINK_ERROR_REQUEST_FROM_NAS = 2136;
                public static final int PDP_FAIL_RRC_UPLINK_RADIO_LINK_FAILURE = 2135;
                public static final int PDP_FAIL_RUIM_NOT_PRESENT = 2085;
                public static final int PDP_FAIL_SECURITY_MODE_REJECTED = 2186;
                public static final int PDP_FAIL_SERVICE_NOT_ALLOWED_ON_PLMN = 2129;
                public static final int PDP_FAIL_SERVICE_OPTION_NOT_SUBSCRIBED = 33;
                public static final int PDP_FAIL_SERVICE_OPTION_NOT_SUPPORTED = 32;
                public static final int PDP_FAIL_SERVICE_OPTION_OUT_OF_ORDER = 34;
                public static final int PDP_FAIL_SIGNAL_LOST = -3;
                public static final int PDP_FAIL_SIM_CARD_CHANGED = 2043;
                public static final int PDP_FAIL_SYNCHRONIZATION_FAILURE = 2184;
                public static final int PDP_FAIL_TEST_LOOPBACK_REGULAR_DEACTIVATION = 2196;
                public static final int PDP_FAIL_TETHERED_CALL_ACTIVE = -6;
                public static final int PDP_FAIL_TFT_SEMANTIC_ERROR = 41;
                public static final int PDP_FAIL_TFT_SYTAX_ERROR = 42;
                public static final int PDP_FAIL_THERMAL_EMERGENCY = 2090;
                public static final int PDP_FAIL_THERMAL_MITIGATION = 2062;
                public static final int PDP_FAIL_TRAT_SWAP_FAILED = 2048;
                public static final int PDP_FAIL_UE_INITIATED_DETACH_OR_DISCONNECT = 128;
                public static final int PDP_FAIL_UE_IS_ENTERING_POWERSAVE_MODE = 2226;
                public static final int PDP_FAIL_UE_RAT_CHANGE = 2105;
                public static final int PDP_FAIL_UE_SECURITY_CAPABILITIES_MISMATCH = 2185;
                public static final int PDP_FAIL_UMTS_HANDOVER_TO_IWLAN = 2199;
                public static final int PDP_FAIL_UMTS_REACTIVATION_REQ = 39;
                public static final int PDP_FAIL_UNACCEPTABLE_NON_EPS_AUTHENTICATION = 2187;
                public static final int PDP_FAIL_UNKNOWN = 0;
                public static final int PDP_FAIL_UNKNOWN_INFO_ELEMENT = 99;
                public static final int PDP_FAIL_UNKNOWN_PDP_ADDRESS_TYPE = 28;
                public static final int PDP_FAIL_UNKNOWN_PDP_CONTEXT = 43;
                public static final int PDP_FAIL_UNPREFERRED_RAT = 2039;
                public static final int PDP_FAIL_UNSUPPORTED_1X_PREV = 2214;
                public static final int PDP_FAIL_UNSUPPORTED_APN_IN_CURRENT_PLMN = 66;
                public static final int PDP_FAIL_UNSUPPORTED_QCI_VALUE = 59;
                public static final int PDP_FAIL_USER_AUTHENTICATION = 29;
                public static final int PDP_FAIL_VOICE_REGISTRATION_FAIL = -1;
                public static final int PDP_FAIL_VSNCP_ADMINISTRATIVELY_PROHIBITED = 2245;
                public static final int PDP_FAIL_VSNCP_APN_UNATHORIZED = 2238;
                public static final int PDP_FAIL_VSNCP_GEN_ERROR = 2237;
                public static final int PDP_FAIL_VSNCP_INSUFFICIENT_PARAMETERS = 2243;
                public static final int PDP_FAIL_VSNCP_NO_PDN_GATEWAY_ADDRESS = 2240;
                public static final int PDP_FAIL_VSNCP_PDN_EXISTS_FOR_THIS_APN = 2248;
                public static final int PDP_FAIL_VSNCP_PDN_GATEWAY_REJECT = 2242;
                public static final int PDP_FAIL_VSNCP_PDN_GATEWAY_UNREACHABLE = 2241;
                public static final int PDP_FAIL_VSNCP_PDN_ID_IN_USE = 2246;
                public static final int PDP_FAIL_VSNCP_PDN_LIMIT_EXCEEDED = 2239;
                public static final int PDP_FAIL_VSNCP_RECONNECT_NOT_ALLOWED = 2249;
                public static final int PDP_FAIL_VSNCP_RESOURCE_UNAVAILABLE = 2244;
                public static final int PDP_FAIL_VSNCP_SUBSCRIBER_LIMITATION = 2247;
                public static final int PDP_FAIL_VSNCP_TIMEOUT = 2236;
            }

            public static RilSetupDataCallResponse[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new RilSetupDataCallResponse[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public RilSetupDataCallResponse() {
                clear();
            }

            public RilSetupDataCallResponse clear() {
                this.status = 0;
                this.suggestedRetryTimeMillis = 0;
                this.call = null;
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                int i = this.status;
                if (i != 0) {
                    codedOutputByteBufferNano.writeInt32(1, i);
                }
                int i2 = this.suggestedRetryTimeMillis;
                if (i2 != 0) {
                    codedOutputByteBufferNano.writeInt32(2, i2);
                }
                RilDataCall rilDataCall = this.call;
                if (rilDataCall != null) {
                    codedOutputByteBufferNano.writeMessage(3, rilDataCall);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                int i = this.status;
                if (i != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                }
                int i2 = this.suggestedRetryTimeMillis;
                if (i2 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
                }
                RilDataCall rilDataCall = this.call;
                return rilDataCall != null ? computeSerializedSize + CodedOutputByteBufferNano.computeMessageSize(3, rilDataCall) : computeSerializedSize;
            }

            public RilSetupDataCallResponse mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    if (readTag == 0) {
                        return this;
                    }
                    if (readTag == 8) {
                        int readInt32 = codedInputByteBufferNano.readInt32();
                        if (!(readInt32 == 8 || readInt32 == 14 || readInt32 == 48 || readInt32 == 81 || readInt32 == 65535 || readInt32 == 65 || readInt32 == 66 || readInt32 == 127 || readInt32 == 128)) {
                            switch (readInt32) {
                                case -6:
                                case -5:
                                case -4:
                                case -3:
                                case -2:
                                case -1:
                                case 0:
                                case 1:
                                    break;
                                default:
                                    switch (readInt32) {
                                        case 25:
                                        case 26:
                                        case 27:
                                        case 28:
                                        case 29:
                                        case 30:
                                        case 31:
                                        case 32:
                                        case 33:
                                        case 34:
                                        case 35:
                                        case 36:
                                        case 37:
                                        case 38:
                                        case 39:
                                        case 40:
                                        case 41:
                                        case 42:
                                        case 43:
                                        case 44:
                                        case 45:
                                        case 46:
                                            break;
                                        default:
                                            switch (readInt32) {
                                                case 50:
                                                case 51:
                                                case 52:
                                                case 53:
                                                case 54:
                                                case 55:
                                                case 56:
                                                case 57:
                                                case 58:
                                                case 59:
                                                case 60:
                                                    break;
                                                default:
                                                    switch (readInt32) {
                                                        case 95:
                                                        case 96:
                                                        case 97:
                                                        case 98:
                                                        case 99:
                                                        case 100:
                                                        case 101:
                                                            break;
                                                        default:
                                                            switch (readInt32) {
                                                                case 111:
                                                                case 112:
                                                                case 113:
                                                                case 114:
                                                                case 115:
                                                                case 116:
                                                                case 117:
                                                                case 118:
                                                                case 119:
                                                                case 120:
                                                                case 121:
                                                                case 122:
                                                                case 123:
                                                                case 124:
                                                                    break;
                                                                default:
                                                                    switch (readInt32) {
                                                                        case 2000:
                                                                        case 2001:
                                                                        case 2002:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_FA_MOBILE_NODE_AUTHENTICATION_FAILURE /*2003*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_FA_HOME_AGENT_AUTHENTICATION_FAILURE /*2004*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_FA_REQUESTED_LIFETIME_TOO_LONG /*2005*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_FA_MALFORMED_REQUEST /*2006*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_FA_MALFORMED_REPLY /*2007*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_FA_ENCAPSULATION_UNAVAILABLE /*2008*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_FA_VJ_HEADER_COMPRESSION_UNAVAILABLE /*2009*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_FA_REVERSE_TUNNEL_UNAVAILABLE /*2010*/:
                                                                        case 2011:
                                                                        case 2012:
                                                                        case 2013:
                                                                        case 2014:
                                                                        case 2015:
                                                                        case 2016:
                                                                        case 2017:
                                                                        case 2018:
                                                                        case 2019:
                                                                        case 2020:
                                                                        case 2021:
                                                                        case 2022:
                                                                        case 2023:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_HA_REGISTRATION_ID_MISMATCH /*2024*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_HA_MALFORMED_REQUEST /*2025*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_HA_UNKNOWN_HOME_AGENT_ADDRESS /*2026*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_HA_REVERSE_TUNNEL_UNAVAILABLE /*2027*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_HA_REVERSE_TUNNEL_IS_MANDATORY /*2028*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_HA_ENCAPSULATION_UNAVAILABLE /*2029*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CLOSE_IN_PROGRESS /*2030*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NETWORK_INITIATED_TERMINATION /*2031*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MODEM_APP_PREEMPTED /*2032*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDN_IPV4_CALL_DISALLOWED /*2033*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDN_IPV4_CALL_THROTTLED /*2034*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDN_IPV6_CALL_DISALLOWED /*2035*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDN_IPV6_CALL_THROTTLED /*2036*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MODEM_RESTART /*2037*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDP_PPP_NOT_SUPPORTED /*2038*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_UNPREFERRED_RAT /*2039*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PHYSICAL_LINK_CLOSE_IN_PROGRESS /*2040*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_APN_PENDING_HANDOVER /*2041*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PROFILE_BEARER_INCOMPATIBLE /*2042*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_SIM_CARD_CHANGED /*2043*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_LOW_POWER_MODE_OR_POWERING_DOWN /*2044*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_APN_DISABLED /*2045*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MAX_PPP_INACTIVITY_TIMER_EXPIRED /*2046*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_IPV6_ADDRESS_TRANSFER_FAILED /*2047*/:
                                                                        case 2048:
                                                                        case RilDataCallFailCause.PDP_FAIL_EHRPD_TO_HRPD_FALLBACK /*2049*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MIP_CONFIG_FAILURE /*2050*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDN_INACTIVITY_TIMER_EXPIRED /*2051*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MAX_IPV4_CONNECTIONS /*2052*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MAX_IPV6_CONNECTIONS /*2053*/:
                                                                        case 2054:
                                                                        case RilDataCallFailCause.PDP_FAIL_IP_VERSION_MISMATCH /*2055*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_DUN_CALL_DISALLOWED /*2056*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_INTERNAL_EPC_NONEPC_TRANSITION /*2057*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_INTERFACE_IN_USE /*2058*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_APN_DISALLOWED_ON_ROAMING /*2059*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_APN_PARAMETERS_CHANGED /*2060*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NULL_APN_DISALLOWED /*2061*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_THERMAL_MITIGATION /*2062*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_DATA_SETTINGS_DISABLED /*2063*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_DATA_ROAMING_SETTINGS_DISABLED /*2064*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_DDS_SWITCHED /*2065*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_FORBIDDEN_APN_NAME /*2066*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_DDS_SWITCH_IN_PROGRESS /*2067*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CALL_DISALLOWED_IN_ROAMING /*2068*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NON_IP_NOT_SUPPORTED /*2069*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDN_NON_IP_CALL_THROTTLED /*2070*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDN_NON_IP_CALL_DISALLOWED /*2071*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CDMA_LOCK /*2072*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CDMA_INTERCEPT /*2073*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CDMA_REORDER /*2074*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CDMA_RELEASE_DUE_TO_SO_REJECTION /*2075*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CDMA_INCOMING_CALL /*2076*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CDMA_ALERT_STOP /*2077*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CHANNEL_ACQUISITION_FAILURE /*2078*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MAX_ACCESS_PROBE /*2079*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CONCURRENT_SERVICE_NOT_SUPPORTED_BY_BASE_STATION /*2080*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NO_RESPONSE_FROM_BASE_STATION /*2081*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_REJECTED_BY_BASE_STATION /*2082*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CONCURRENT_SERVICES_INCOMPATIBLE /*2083*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NO_CDMA_SERVICE /*2084*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RUIM_NOT_PRESENT /*2085*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CDMA_RETRY_ORDER /*2086*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ACCESS_BLOCK /*2087*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ACCESS_BLOCK_ALL /*2088*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_IS707B_MAX_ACCESS_PROBES /*2089*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_THERMAL_EMERGENCY /*2090*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CONCURRENT_SERVICES_NOT_ALLOWED /*2091*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_INCOMING_CALL_REJECTED /*2092*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NO_SERVICE_ON_GATEWAY /*2093*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NO_GPRS_CONTEXT /*2094*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ILLEGAL_MS /*2095*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ILLEGAL_ME /*2096*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_GPRS_SERVICES_AND_NON_GPRS_SERVICES_NOT_ALLOWED /*2097*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_GPRS_SERVICES_NOT_ALLOWED /*2098*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MS_IDENTITY_CANNOT_BE_DERIVED_BY_THE_NETWORK /*2099*/:
                                                                        case 2100:
                                                                        case 2101:
                                                                        case 2102:
                                                                        case RilDataCallFailCause.PDP_FAIL_GPRS_SERVICES_NOT_ALLOWED_IN_THIS_PLMN /*2103*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDP_DUPLICATE /*2104*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_UE_RAT_CHANGE /*2105*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CONGESTION /*2106*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NO_PDP_CONTEXT_ACTIVATED /*2107*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ACCESS_CLASS_DSAC_REJECTION /*2108*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDP_ACTIVATE_MAX_RETRY_FAILED /*2109*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RADIO_ACCESS_BEARER_FAILURE /*2110*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ESM_UNKNOWN_EPS_BEARER_CONTEXT /*2111*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_DRB_RELEASED_BY_RRC /*2112*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CONNECTION_RELEASED /*2113*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EMM_DETACHED /*2114*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EMM_ATTACH_FAILED /*2115*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EMM_ATTACH_STARTED /*2116*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_LTE_NAS_SERVICE_REQUEST_FAILED /*2117*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_DUPLICATE_BEARER_ID /*2118*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ESM_COLLISION_SCENARIOS /*2119*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ESM_BEARER_DEACTIVATED_TO_SYNC_WITH_NETWORK /*2120*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ESM_NW_ACTIVATED_DED_BEARER_WITH_ID_OF_DEF_BEARER /*2121*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ESM_BAD_OTA_MESSAGE /*2122*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ESM_DOWNLOAD_SERVER_REJECTED_THE_CALL /*2123*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ESM_CONTEXT_TRANSFERRED_DUE_TO_IRAT /*2124*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_DS_EXPLICIT_DEACTIVATION /*2125*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ESM_LOCAL_CAUSE_NONE /*2126*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_LTE_THROTTLING_NOT_REQUIRED /*2127*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ACCESS_CONTROL_LIST_CHECK_FAILURE /*2128*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_SERVICE_NOT_ALLOWED_ON_PLMN /*2129*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EMM_T3417_EXPIRED /*2130*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EMM_T3417_EXT_EXPIRED /*2131*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_UPLINK_DATA_TRANSMISSION_FAILURE /*2132*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_UPLINK_DELIVERY_FAILED_DUE_TO_HANDOVER /*2133*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_UPLINK_CONNECTION_RELEASE /*2134*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_UPLINK_RADIO_LINK_FAILURE /*2135*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_UPLINK_ERROR_REQUEST_FROM_NAS /*2136*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_ACCESS_STRATUM_FAILURE /*2137*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_ANOTHER_PROCEDURE_IN_PROGRESS /*2138*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_ACCESS_BARRED /*2139*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_CELL_RESELECTION /*2140*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_CONFIG_FAILURE /*2141*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_TIMER_EXPIRED /*2142*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_LINK_FAILURE /*2143*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_CELL_NOT_CAMPED /*2144*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_SYSTEM_INTERVAL_FAILURE /*2145*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_REJECT_BY_NETWORK /*2146*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_NORMAL_RELEASE /*2147*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_RADIO_LINK_FAILURE /*2148*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_REESTABLISHMENT_FAILURE /*2149*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_OUT_OF_SERVICE_DURING_CELL_REGISTER /*2150*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_ABORT_REQUEST /*2151*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_SYSTEM_INFORMATION_BLOCK_READ_ERROR /*2152*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NETWORK_INITIATED_DETACH_WITH_AUTO_REATTACH /*2153*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NETWORK_INITIATED_DETACH_NO_AUTO_REATTACH /*2154*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ESM_PROCEDURE_TIME_OUT /*2155*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_INVALID_CONNECTION_ID /*2156*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MAXIMIUM_NSAPIS_EXCEEDED /*2157*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_INVALID_PRIMARY_NSAPI /*2158*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CANNOT_ENCODE_OTA_MESSAGE /*2159*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RADIO_ACCESS_BEARER_SETUP_FAILURE /*2160*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDP_ESTABLISH_TIMEOUT_EXPIRED /*2161*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDP_MODIFY_TIMEOUT_EXPIRED /*2162*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDP_INACTIVE_TIMEOUT_EXPIRED /*2163*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDP_LOWERLAYER_ERROR /*2164*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PDP_MODIFY_COLLISION /*2165*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MAXINUM_SIZE_OF_L2_MESSAGE_EXCEEDED /*2166*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NAS_REQUEST_REJECTED_BY_NETWORK /*2167*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_INVALID_REQUEST /*2168*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_TRACKING_AREA_ID_CHANGED /*2169*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_RF_UNAVAILABLE /*2170*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_ABORTED_DUE_TO_IRAT_CHANGE /*2171*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_RELEASED_SECURITY_NOT_ACTIVE /*2172*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_ABORTED_AFTER_HANDOVER /*2173*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_ABORTED_AFTER_IRAT_CELL_CHANGE /*2174*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_RRC_CONNECTION_ABORTED_DURING_IRAT_CELL_CHANGE /*2175*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_IMSI_UNKNOWN_IN_HOME_SUBSCRIBER_SERVER /*2176*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_IMEI_NOT_ACCEPTED /*2177*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EPS_SERVICES_AND_NON_EPS_SERVICES_NOT_ALLOWED /*2178*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EPS_SERVICES_NOT_ALLOWED_IN_PLMN /*2179*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MSC_TEMPORARILY_NOT_REACHABLE /*2180*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CS_DOMAIN_NOT_AVAILABLE /*2181*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ESM_FAILURE /*2182*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MAC_FAILURE /*2183*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_SYNCHRONIZATION_FAILURE /*2184*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_UE_SECURITY_CAPABILITIES_MISMATCH /*2185*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_SECURITY_MODE_REJECTED /*2186*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_UNACCEPTABLE_NON_EPS_AUTHENTICATION /*2187*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_CS_FALLBACK_CALL_ESTABLISHMENT_NOT_ALLOWED /*2188*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NO_EPS_BEARER_CONTEXT_ACTIVATED /*2189*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_INVALID_EMM_STATE /*2190*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NAS_LAYER_FAILURE /*2191*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_MULTIPLE_PDP_CALL_NOT_ALLOWED /*2192*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EMBMS_NOT_ENABLED /*2193*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_IRAT_HANDOVER_FAILED /*2194*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EMBMS_REGULAR_DEACTIVATION /*2195*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_TEST_LOOPBACK_REGULAR_DEACTIVATION /*2196*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_LOWER_LAYER_REGISTRATION_FAILURE /*2197*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_DATA_PLAN_EXPIRED /*2198*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_UMTS_HANDOVER_TO_IWLAN /*2199*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EVDO_CONNECTION_DENY_BY_GENERAL_OR_NETWORK_BUSY /*2200*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EVDO_CONNECTION_DENY_BY_BILLING_OR_AUTHENTICATION_FAILURE /*2201*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EVDO_HDR_CHANGED /*2202*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EVDO_HDR_EXITED /*2203*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EVDO_HDR_NO_SESSION /*2204*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EVDO_USING_GPS_FIX_INSTEAD_OF_HDR_CALL /*2205*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EVDO_HDR_CONNECTION_SETUP_TIMEOUT /*2206*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_FAILED_TO_ACQUIRE_COLOCATED_HDR /*2207*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_OTASP_COMMIT_IN_PROGRESS /*2208*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NO_HYBRID_HDR_SERVICE /*2209*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_HDR_NO_LOCK_GRANTED /*2210*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_DBM_OR_SMS_IN_PROGRESS /*2211*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_HDR_FADE /*2212*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_HDR_ACCESS_FAILURE /*2213*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_UNSUPPORTED_1X_PREV /*2214*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_LOCAL_END /*2215*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NO_SERVICE /*2216*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_FADE /*2217*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NORMAL_RELEASE /*2218*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_ACCESS_ATTEMPT_ALREADY_IN_PROGRESS /*2219*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_REDIRECTION_OR_HANDOFF_IN_PROGRESS /*2220*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_EMERGENCY_MODE /*2221*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PHONE_IN_USE /*2222*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_INVALID_MODE /*2223*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_INVALID_SIM_STATE /*2224*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_NO_COLLOCATED_HDR /*2225*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_UE_IS_ENTERING_POWERSAVE_MODE /*2226*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_DUAL_SWITCH /*2227*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PPP_TIMEOUT /*2228*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PPP_AUTH_FAILURE /*2229*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PPP_OPTION_MISMATCH /*2230*/:
                                                                        case 2231:
                                                                        case RilDataCallFailCause.PDP_FAIL_PPP_CHAP_FAILURE /*2232*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_PPP_CLOSE_IN_PROGRESS /*2233*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_LIMITED_TO_IPV4 /*2234*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_LIMITED_TO_IPV6 /*2235*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_VSNCP_TIMEOUT /*2236*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_VSNCP_GEN_ERROR /*2237*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_VSNCP_APN_UNATHORIZED /*2238*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_VSNCP_PDN_LIMIT_EXCEEDED /*2239*/:
                                                                        case 2240:
                                                                        case 2241:
                                                                        case 2242:
                                                                        case RilDataCallFailCause.PDP_FAIL_VSNCP_INSUFFICIENT_PARAMETERS /*2243*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_VSNCP_RESOURCE_UNAVAILABLE /*2244*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_VSNCP_ADMINISTRATIVELY_PROHIBITED /*2245*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_VSNCP_PDN_ID_IN_USE /*2246*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_VSNCP_SUBSCRIBER_LIMITATION /*2247*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_VSNCP_PDN_EXISTS_FOR_THIS_APN /*2248*/:
                                                                        case RilDataCallFailCause.PDP_FAIL_VSNCP_RECONNECT_NOT_ALLOWED /*2249*/:
                                                                        case 2250:
                                                                        case 2251:
                                                                            break;
                                                                        default:
                                                                            continue;
                                                                            continue;
                                                                            continue;
                                                                            continue;
                                                                            continue;
                                                                    }
                                                            }
                                                    }
                                            }
                                    }
                            }
                        }
                        this.status = readInt32;
                    } else if (readTag == 16) {
                        this.suggestedRetryTimeMillis = codedInputByteBufferNano.readInt32();
                    } else if (readTag == 26) {
                        if (this.call == null) {
                            this.call = new RilDataCall();
                        }
                        codedInputByteBufferNano.readMessage(this.call);
                    } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                        return this;
                    }
                }
            }

            public static RilSetupDataCallResponse parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (RilSetupDataCallResponse) MessageNano.mergeFrom(new RilSetupDataCallResponse(), bArr);
            }

            public static RilSetupDataCallResponse parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new RilSetupDataCallResponse().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static final class CarrierKeyChange extends ExtendableMessageNano<CarrierKeyChange> {
            private static volatile CarrierKeyChange[] _emptyArray;
            public boolean isDownloadSuccessful;
            public int keyType;

            public interface KeyType {
                public static final int EPDG = 2;
                public static final int UNKNOWN = 0;
                public static final int WLAN = 1;
            }

            public static CarrierKeyChange[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new CarrierKeyChange[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public CarrierKeyChange() {
                clear();
            }

            public CarrierKeyChange clear() {
                this.keyType = 0;
                this.isDownloadSuccessful = false;
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                int i = this.keyType;
                if (i != 0) {
                    codedOutputByteBufferNano.writeInt32(1, i);
                }
                boolean z = this.isDownloadSuccessful;
                if (z) {
                    codedOutputByteBufferNano.writeBool(2, z);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                int i = this.keyType;
                if (i != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                }
                boolean z = this.isDownloadSuccessful;
                return z ? computeSerializedSize + CodedOutputByteBufferNano.computeBoolSize(2, z) : computeSerializedSize;
            }

            public CarrierKeyChange mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    if (readTag == 0) {
                        return this;
                    }
                    if (readTag == 8) {
                        int readInt32 = codedInputByteBufferNano.readInt32();
                        if (readInt32 == 0 || readInt32 == 1 || readInt32 == 2) {
                            this.keyType = readInt32;
                        }
                    } else if (readTag == 16) {
                        this.isDownloadSuccessful = codedInputByteBufferNano.readBool();
                    } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                        return this;
                    }
                }
            }

            public static CarrierKeyChange parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (CarrierKeyChange) MessageNano.mergeFrom(new CarrierKeyChange(), bArr);
            }

            public static CarrierKeyChange parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new CarrierKeyChange().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static final class RilDeactivateDataCall extends ExtendableMessageNano<RilDeactivateDataCall> {
            private static volatile RilDeactivateDataCall[] _emptyArray;
            public int cid;
            public int reason;

            public interface DeactivateReason {
                public static final int DEACTIVATE_REASON_HANDOVER = 4;
                public static final int DEACTIVATE_REASON_NONE = 1;
                public static final int DEACTIVATE_REASON_PDP_RESET = 3;
                public static final int DEACTIVATE_REASON_RADIO_OFF = 2;
                public static final int DEACTIVATE_REASON_UNKNOWN = 0;
            }

            public static RilDeactivateDataCall[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new RilDeactivateDataCall[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public RilDeactivateDataCall() {
                clear();
            }

            public RilDeactivateDataCall clear() {
                this.cid = 0;
                this.reason = 0;
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                int i = this.cid;
                if (i != 0) {
                    codedOutputByteBufferNano.writeInt32(1, i);
                }
                int i2 = this.reason;
                if (i2 != 0) {
                    codedOutputByteBufferNano.writeInt32(2, i2);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                int i = this.cid;
                if (i != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                }
                int i2 = this.reason;
                return i2 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(2, i2) : computeSerializedSize;
            }

            public RilDeactivateDataCall mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    if (readTag == 0) {
                        return this;
                    }
                    if (readTag == 8) {
                        this.cid = codedInputByteBufferNano.readInt32();
                    } else if (readTag == 16) {
                        int readInt32 = codedInputByteBufferNano.readInt32();
                        if (readInt32 == 0 || readInt32 == 1 || readInt32 == 2 || readInt32 == 3 || readInt32 == 4) {
                            this.reason = readInt32;
                        }
                    } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                        return this;
                    }
                }
            }

            public static RilDeactivateDataCall parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (RilDeactivateDataCall) MessageNano.mergeFrom(new RilDeactivateDataCall(), bArr);
            }

            public static RilDeactivateDataCall parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new RilDeactivateDataCall().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static final class ModemRestart extends ExtendableMessageNano<ModemRestart> {
            private static volatile ModemRestart[] _emptyArray;
            public String basebandVersion;
            public String reason;

            public static ModemRestart[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new ModemRestart[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public ModemRestart() {
                clear();
            }

            public ModemRestart clear() {
                this.basebandVersion = "";
                this.reason = "";
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                if (!this.basebandVersion.equals("")) {
                    codedOutputByteBufferNano.writeString(1, this.basebandVersion);
                }
                if (!this.reason.equals("")) {
                    codedOutputByteBufferNano.writeString(2, this.reason);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                if (!this.basebandVersion.equals("")) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(1, this.basebandVersion);
                }
                return !this.reason.equals("") ? computeSerializedSize + CodedOutputByteBufferNano.computeStringSize(2, this.reason) : computeSerializedSize;
            }

            public ModemRestart mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    if (readTag == 0) {
                        return this;
                    }
                    if (readTag == 10) {
                        this.basebandVersion = codedInputByteBufferNano.readString();
                    } else if (readTag == 18) {
                        this.reason = codedInputByteBufferNano.readString();
                    } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                        return this;
                    }
                }
            }

            public static ModemRestart parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (ModemRestart) MessageNano.mergeFrom(new ModemRestart(), bArr);
            }

            public static ModemRestart parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new ModemRestart().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static final class CarrierIdMatching extends ExtendableMessageNano<CarrierIdMatching> {
            private static volatile CarrierIdMatching[] _emptyArray;
            public int cidTableVersion;
            public CarrierIdMatchingResult result;

            public static CarrierIdMatching[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new CarrierIdMatching[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public CarrierIdMatching() {
                clear();
            }

            public CarrierIdMatching clear() {
                this.cidTableVersion = 0;
                this.result = null;
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                int i = this.cidTableVersion;
                if (i != 0) {
                    codedOutputByteBufferNano.writeInt32(1, i);
                }
                CarrierIdMatchingResult carrierIdMatchingResult = this.result;
                if (carrierIdMatchingResult != null) {
                    codedOutputByteBufferNano.writeMessage(2, carrierIdMatchingResult);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                int i = this.cidTableVersion;
                if (i != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                }
                CarrierIdMatchingResult carrierIdMatchingResult = this.result;
                return carrierIdMatchingResult != null ? computeSerializedSize + CodedOutputByteBufferNano.computeMessageSize(2, carrierIdMatchingResult) : computeSerializedSize;
            }

            public CarrierIdMatching mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    if (readTag == 0) {
                        return this;
                    }
                    if (readTag == 8) {
                        this.cidTableVersion = codedInputByteBufferNano.readInt32();
                    } else if (readTag == 18) {
                        if (this.result == null) {
                            this.result = new CarrierIdMatchingResult();
                        }
                        codedInputByteBufferNano.readMessage(this.result);
                    } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                        return this;
                    }
                }
            }

            public static CarrierIdMatching parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (CarrierIdMatching) MessageNano.mergeFrom(new CarrierIdMatching(), bArr);
            }

            public static CarrierIdMatching parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new CarrierIdMatching().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static final class CarrierIdMatchingResult extends ExtendableMessageNano<CarrierIdMatchingResult> {
            private static volatile CarrierIdMatchingResult[] _emptyArray;
            public int carrierId;
            public String gid1;
            public String gid2;
            public String iccidPrefix;
            public String imsiPrefix;
            public String mccmnc;
            public String pnn;
            public String preferApn;
            public String[] privilegeAccessRule;
            public String spn;
            public String unknownGid1;
            public String unknownMccmnc;

            public static CarrierIdMatchingResult[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new CarrierIdMatchingResult[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public CarrierIdMatchingResult() {
                clear();
            }

            public CarrierIdMatchingResult clear() {
                this.carrierId = 0;
                this.unknownGid1 = "";
                this.unknownMccmnc = "";
                this.mccmnc = "";
                this.gid1 = "";
                this.gid2 = "";
                this.spn = "";
                this.pnn = "";
                this.iccidPrefix = "";
                this.imsiPrefix = "";
                this.privilegeAccessRule = WireFormatNano.EMPTY_STRING_ARRAY;
                this.preferApn = "";
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                int i = this.carrierId;
                if (i != 0) {
                    codedOutputByteBufferNano.writeInt32(1, i);
                }
                if (!this.unknownGid1.equals("")) {
                    codedOutputByteBufferNano.writeString(2, this.unknownGid1);
                }
                if (!this.unknownMccmnc.equals("")) {
                    codedOutputByteBufferNano.writeString(3, this.unknownMccmnc);
                }
                if (!this.mccmnc.equals("")) {
                    codedOutputByteBufferNano.writeString(4, this.mccmnc);
                }
                if (!this.gid1.equals("")) {
                    codedOutputByteBufferNano.writeString(5, this.gid1);
                }
                if (!this.gid2.equals("")) {
                    codedOutputByteBufferNano.writeString(6, this.gid2);
                }
                if (!this.spn.equals("")) {
                    codedOutputByteBufferNano.writeString(7, this.spn);
                }
                if (!this.pnn.equals("")) {
                    codedOutputByteBufferNano.writeString(8, this.pnn);
                }
                if (!this.iccidPrefix.equals("")) {
                    codedOutputByteBufferNano.writeString(9, this.iccidPrefix);
                }
                if (!this.imsiPrefix.equals("")) {
                    codedOutputByteBufferNano.writeString(10, this.imsiPrefix);
                }
                String[] strArr = this.privilegeAccessRule;
                if (strArr != null && strArr.length > 0) {
                    int i2 = 0;
                    while (true) {
                        String[] strArr2 = this.privilegeAccessRule;
                        if (i2 >= strArr2.length) {
                            break;
                        }
                        String str = strArr2[i2];
                        if (str != null) {
                            codedOutputByteBufferNano.writeString(11, str);
                        }
                        i2++;
                    }
                }
                if (!this.preferApn.equals("")) {
                    codedOutputByteBufferNano.writeString(12, this.preferApn);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                int i = this.carrierId;
                if (i != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                }
                if (!this.unknownGid1.equals("")) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(2, this.unknownGid1);
                }
                if (!this.unknownMccmnc.equals("")) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(3, this.unknownMccmnc);
                }
                if (!this.mccmnc.equals("")) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(4, this.mccmnc);
                }
                if (!this.gid1.equals("")) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(5, this.gid1);
                }
                if (!this.gid2.equals("")) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(6, this.gid2);
                }
                if (!this.spn.equals("")) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(7, this.spn);
                }
                if (!this.pnn.equals("")) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(8, this.pnn);
                }
                if (!this.iccidPrefix.equals("")) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(9, this.iccidPrefix);
                }
                if (!this.imsiPrefix.equals("")) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(10, this.imsiPrefix);
                }
                String[] strArr = this.privilegeAccessRule;
                if (strArr != null && strArr.length > 0) {
                    int i2 = 0;
                    int i3 = 0;
                    int i4 = 0;
                    while (true) {
                        String[] strArr2 = this.privilegeAccessRule;
                        if (i2 >= strArr2.length) {
                            break;
                        }
                        String str = strArr2[i2];
                        if (str != null) {
                            i4++;
                            i3 += CodedOutputByteBufferNano.computeStringSizeNoTag(str);
                        }
                        i2++;
                    }
                    computeSerializedSize = computeSerializedSize + i3 + (i4 * 1);
                }
                return !this.preferApn.equals("") ? computeSerializedSize + CodedOutputByteBufferNano.computeStringSize(12, this.preferApn) : computeSerializedSize;
            }

            public CarrierIdMatchingResult mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    switch (readTag) {
                        case 0:
                            return this;
                        case 8:
                            this.carrierId = codedInputByteBufferNano.readInt32();
                            break;
                        case 18:
                            this.unknownGid1 = codedInputByteBufferNano.readString();
                            break;
                        case 26:
                            this.unknownMccmnc = codedInputByteBufferNano.readString();
                            break;
                        case 34:
                            this.mccmnc = codedInputByteBufferNano.readString();
                            break;
                        case 42:
                            this.gid1 = codedInputByteBufferNano.readString();
                            break;
                        case 50:
                            this.gid2 = codedInputByteBufferNano.readString();
                            break;
                        case 58:
                            this.spn = codedInputByteBufferNano.readString();
                            break;
                        case 66:
                            this.pnn = codedInputByteBufferNano.readString();
                            break;
                        case 74:
                            this.iccidPrefix = codedInputByteBufferNano.readString();
                            break;
                        case 82:
                            this.imsiPrefix = codedInputByteBufferNano.readString();
                            break;
                        case 90:
                            int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 90);
                            String[] strArr = this.privilegeAccessRule;
                            int length = strArr == null ? 0 : strArr.length;
                            int i = repeatedFieldArrayLength + length;
                            String[] strArr2 = new String[i];
                            if (length != 0) {
                                System.arraycopy(strArr, 0, strArr2, 0, length);
                            }
                            while (length < i - 1) {
                                strArr2[length] = codedInputByteBufferNano.readString();
                                codedInputByteBufferNano.readTag();
                                length++;
                            }
                            strArr2[length] = codedInputByteBufferNano.readString();
                            this.privilegeAccessRule = strArr2;
                            break;
                        case 98:
                            this.preferApn = codedInputByteBufferNano.readString();
                            break;
                        default:
                            if (storeUnknownField(codedInputByteBufferNano, readTag)) {
                                break;
                            } else {
                                return this;
                            }
                    }
                }
            }

            public static CarrierIdMatchingResult parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (CarrierIdMatchingResult) MessageNano.mergeFrom(new CarrierIdMatchingResult(), bArr);
            }

            public static CarrierIdMatchingResult parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new CarrierIdMatchingResult().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static final class NetworkCapabilitiesInfo extends ExtendableMessageNano<NetworkCapabilitiesInfo> {
            private static volatile NetworkCapabilitiesInfo[] _emptyArray;
            public boolean isNetworkUnmetered;

            public static NetworkCapabilitiesInfo[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new NetworkCapabilitiesInfo[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public NetworkCapabilitiesInfo() {
                clear();
            }

            public NetworkCapabilitiesInfo clear() {
                this.isNetworkUnmetered = false;
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                boolean z = this.isNetworkUnmetered;
                if (z) {
                    codedOutputByteBufferNano.writeBool(1, z);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                boolean z = this.isNetworkUnmetered;
                return z ? computeSerializedSize + CodedOutputByteBufferNano.computeBoolSize(1, z) : computeSerializedSize;
            }

            public NetworkCapabilitiesInfo mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    if (readTag == 0) {
                        return this;
                    }
                    if (readTag == 8) {
                        this.isNetworkUnmetered = codedInputByteBufferNano.readBool();
                    } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                        return this;
                    }
                }
            }

            public static NetworkCapabilitiesInfo parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (NetworkCapabilitiesInfo) MessageNano.mergeFrom(new NetworkCapabilitiesInfo(), bArr);
            }

            public static NetworkCapabilitiesInfo parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new NetworkCapabilitiesInfo().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static TelephonyEvent[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new TelephonyEvent[0];
                    }
                }
            }
            return _emptyArray;
        }

        public TelephonyEvent() {
            clear();
        }

        public TelephonyEvent clear() {
            this.timestampMillis = 0;
            this.phoneId = 0;
            this.type = 0;
            this.settings = null;
            this.serviceState = null;
            this.imsConnectionState = null;
            this.imsCapabilities = null;
            this.dataCalls = RilDataCall.emptyArray();
            this.error = 0;
            this.setupDataCall = null;
            this.setupDataCallResponse = null;
            this.deactivateDataCall = null;
            this.dataStallAction = 0;
            this.modemRestart = null;
            this.nitzTimestampMillis = 0;
            this.carrierIdMatching = null;
            this.carrierKeyChange = null;
            this.dataSwitch = null;
            this.networkValidationState = 0;
            this.onDemandDataSwitch = null;
            this.simState = WireFormatNano.EMPTY_INT_ARRAY;
            this.activeSubscriptionInfo = null;
            this.enabledModemBitmap = 0;
            this.updatedEmergencyNumber = null;
            this.networkCapabilities = null;
            this.signalStrength = 0;
            this.emergencyNumberDatabaseVersion = 0;
            this.radioState = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            long j = this.timestampMillis;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(1, j);
            }
            int i = this.phoneId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(2, i);
            }
            int i2 = this.type;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i2);
            }
            TelephonySettings telephonySettings = this.settings;
            if (telephonySettings != null) {
                codedOutputByteBufferNano.writeMessage(4, telephonySettings);
            }
            TelephonyServiceState telephonyServiceState = this.serviceState;
            if (telephonyServiceState != null) {
                codedOutputByteBufferNano.writeMessage(5, telephonyServiceState);
            }
            ImsConnectionState imsConnectionState2 = this.imsConnectionState;
            if (imsConnectionState2 != null) {
                codedOutputByteBufferNano.writeMessage(6, imsConnectionState2);
            }
            ImsCapabilities imsCapabilities2 = this.imsCapabilities;
            if (imsCapabilities2 != null) {
                codedOutputByteBufferNano.writeMessage(7, imsCapabilities2);
            }
            RilDataCall[] rilDataCallArr = this.dataCalls;
            int i3 = 0;
            if (rilDataCallArr != null && rilDataCallArr.length > 0) {
                int i4 = 0;
                while (true) {
                    RilDataCall[] rilDataCallArr2 = this.dataCalls;
                    if (i4 >= rilDataCallArr2.length) {
                        break;
                    }
                    RilDataCall rilDataCall = rilDataCallArr2[i4];
                    if (rilDataCall != null) {
                        codedOutputByteBufferNano.writeMessage(8, rilDataCall);
                    }
                    i4++;
                }
            }
            int i5 = this.error;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(9, i5);
            }
            RilSetupDataCall rilSetupDataCall = this.setupDataCall;
            if (rilSetupDataCall != null) {
                codedOutputByteBufferNano.writeMessage(10, rilSetupDataCall);
            }
            RilSetupDataCallResponse rilSetupDataCallResponse = this.setupDataCallResponse;
            if (rilSetupDataCallResponse != null) {
                codedOutputByteBufferNano.writeMessage(11, rilSetupDataCallResponse);
            }
            RilDeactivateDataCall rilDeactivateDataCall = this.deactivateDataCall;
            if (rilDeactivateDataCall != null) {
                codedOutputByteBufferNano.writeMessage(12, rilDeactivateDataCall);
            }
            int i6 = this.dataStallAction;
            if (i6 != 0) {
                codedOutputByteBufferNano.writeInt32(13, i6);
            }
            ModemRestart modemRestart2 = this.modemRestart;
            if (modemRestart2 != null) {
                codedOutputByteBufferNano.writeMessage(14, modemRestart2);
            }
            long j2 = this.nitzTimestampMillis;
            if (j2 != 0) {
                codedOutputByteBufferNano.writeInt64(15, j2);
            }
            CarrierIdMatching carrierIdMatching2 = this.carrierIdMatching;
            if (carrierIdMatching2 != null) {
                codedOutputByteBufferNano.writeMessage(16, carrierIdMatching2);
            }
            CarrierKeyChange carrierKeyChange2 = this.carrierKeyChange;
            if (carrierKeyChange2 != null) {
                codedOutputByteBufferNano.writeMessage(17, carrierKeyChange2);
            }
            DataSwitch dataSwitch2 = this.dataSwitch;
            if (dataSwitch2 != null) {
                codedOutputByteBufferNano.writeMessage(19, dataSwitch2);
            }
            int i7 = this.networkValidationState;
            if (i7 != 0) {
                codedOutputByteBufferNano.writeInt32(20, i7);
            }
            OnDemandDataSwitch onDemandDataSwitch2 = this.onDemandDataSwitch;
            if (onDemandDataSwitch2 != null) {
                codedOutputByteBufferNano.writeMessage(21, onDemandDataSwitch2);
            }
            int[] iArr = this.simState;
            if (iArr != null && iArr.length > 0) {
                while (true) {
                    int[] iArr2 = this.simState;
                    if (i3 >= iArr2.length) {
                        break;
                    }
                    codedOutputByteBufferNano.writeInt32(22, iArr2[i3]);
                    i3++;
                }
            }
            ActiveSubscriptionInfo activeSubscriptionInfo2 = this.activeSubscriptionInfo;
            if (activeSubscriptionInfo2 != null) {
                codedOutputByteBufferNano.writeMessage(23, activeSubscriptionInfo2);
            }
            int i8 = this.enabledModemBitmap;
            if (i8 != 0) {
                codedOutputByteBufferNano.writeInt32(24, i8);
            }
            EmergencyNumberInfo emergencyNumberInfo = this.updatedEmergencyNumber;
            if (emergencyNumberInfo != null) {
                codedOutputByteBufferNano.writeMessage(25, emergencyNumberInfo);
            }
            NetworkCapabilitiesInfo networkCapabilitiesInfo = this.networkCapabilities;
            if (networkCapabilitiesInfo != null) {
                codedOutputByteBufferNano.writeMessage(26, networkCapabilitiesInfo);
            }
            int i9 = this.signalStrength;
            if (i9 != 0) {
                codedOutputByteBufferNano.writeInt32(27, i9);
            }
            int i10 = this.emergencyNumberDatabaseVersion;
            if (i10 != 0) {
                codedOutputByteBufferNano.writeInt32(28, i10);
            }
            int i11 = this.radioState;
            if (i11 != 0) {
                codedOutputByteBufferNano.writeInt32(29, i11);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int[] iArr;
            int computeSerializedSize = super.computeSerializedSize();
            long j = this.timestampMillis;
            if (j != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(1, j);
            }
            int i = this.phoneId;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i);
            }
            int i2 = this.type;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i2);
            }
            TelephonySettings telephonySettings = this.settings;
            if (telephonySettings != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(4, telephonySettings);
            }
            TelephonyServiceState telephonyServiceState = this.serviceState;
            if (telephonyServiceState != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(5, telephonyServiceState);
            }
            ImsConnectionState imsConnectionState2 = this.imsConnectionState;
            if (imsConnectionState2 != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(6, imsConnectionState2);
            }
            ImsCapabilities imsCapabilities2 = this.imsCapabilities;
            if (imsCapabilities2 != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(7, imsCapabilities2);
            }
            RilDataCall[] rilDataCallArr = this.dataCalls;
            int i3 = 0;
            if (rilDataCallArr != null && rilDataCallArr.length > 0) {
                int i4 = 0;
                while (true) {
                    RilDataCall[] rilDataCallArr2 = this.dataCalls;
                    if (i4 >= rilDataCallArr2.length) {
                        break;
                    }
                    RilDataCall rilDataCall = rilDataCallArr2[i4];
                    if (rilDataCall != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(8, rilDataCall);
                    }
                    i4++;
                }
            }
            int i5 = this.error;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(9, i5);
            }
            RilSetupDataCall rilSetupDataCall = this.setupDataCall;
            if (rilSetupDataCall != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(10, rilSetupDataCall);
            }
            RilSetupDataCallResponse rilSetupDataCallResponse = this.setupDataCallResponse;
            if (rilSetupDataCallResponse != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(11, rilSetupDataCallResponse);
            }
            RilDeactivateDataCall rilDeactivateDataCall = this.deactivateDataCall;
            if (rilDeactivateDataCall != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(12, rilDeactivateDataCall);
            }
            int i6 = this.dataStallAction;
            if (i6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(13, i6);
            }
            ModemRestart modemRestart2 = this.modemRestart;
            if (modemRestart2 != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(14, modemRestart2);
            }
            long j2 = this.nitzTimestampMillis;
            if (j2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(15, j2);
            }
            CarrierIdMatching carrierIdMatching2 = this.carrierIdMatching;
            if (carrierIdMatching2 != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(16, carrierIdMatching2);
            }
            CarrierKeyChange carrierKeyChange2 = this.carrierKeyChange;
            if (carrierKeyChange2 != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(17, carrierKeyChange2);
            }
            DataSwitch dataSwitch2 = this.dataSwitch;
            if (dataSwitch2 != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(19, dataSwitch2);
            }
            int i7 = this.networkValidationState;
            if (i7 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(20, i7);
            }
            OnDemandDataSwitch onDemandDataSwitch2 = this.onDemandDataSwitch;
            if (onDemandDataSwitch2 != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(21, onDemandDataSwitch2);
            }
            int[] iArr2 = this.simState;
            if (iArr2 != null && iArr2.length > 0) {
                int i8 = 0;
                while (true) {
                    iArr = this.simState;
                    if (i3 >= iArr.length) {
                        break;
                    }
                    i8 += CodedOutputByteBufferNano.computeInt32SizeNoTag(iArr[i3]);
                    i3++;
                }
                computeSerializedSize = computeSerializedSize + i8 + (iArr.length * 2);
            }
            ActiveSubscriptionInfo activeSubscriptionInfo2 = this.activeSubscriptionInfo;
            if (activeSubscriptionInfo2 != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(23, activeSubscriptionInfo2);
            }
            int i9 = this.enabledModemBitmap;
            if (i9 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(24, i9);
            }
            EmergencyNumberInfo emergencyNumberInfo = this.updatedEmergencyNumber;
            if (emergencyNumberInfo != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(25, emergencyNumberInfo);
            }
            NetworkCapabilitiesInfo networkCapabilitiesInfo = this.networkCapabilities;
            if (networkCapabilitiesInfo != null) {
                computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(26, networkCapabilitiesInfo);
            }
            int i10 = this.signalStrength;
            if (i10 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(27, i10);
            }
            int i11 = this.emergencyNumberDatabaseVersion;
            if (i11 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(28, i11);
            }
            int i12 = this.radioState;
            return i12 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(29, i12) : computeSerializedSize;
        }

        public TelephonyEvent mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                switch (readTag) {
                    case 0:
                        return this;
                    case 8:
                        this.timestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 16:
                        this.phoneId = codedInputByteBufferNano.readInt32();
                        break;
                    case 24:
                        int readInt32 = codedInputByteBufferNano.readInt32();
                        switch (readInt32) {
                            case 0:
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                            case 6:
                            case 7:
                            case 8:
                            case 9:
                            case 10:
                            case 11:
                            case 12:
                            case 13:
                            case 14:
                            case 15:
                            case 16:
                            case 17:
                            case 18:
                            case 19:
                            case 20:
                            case 21:
                            case 22:
                            case 23:
                            case 24:
                                this.type = readInt32;
                                break;
                        }
                    case 34:
                        if (this.settings == null) {
                            this.settings = new TelephonySettings();
                        }
                        codedInputByteBufferNano.readMessage(this.settings);
                        break;
                    case 42:
                        if (this.serviceState == null) {
                            this.serviceState = new TelephonyServiceState();
                        }
                        codedInputByteBufferNano.readMessage(this.serviceState);
                        break;
                    case 50:
                        if (this.imsConnectionState == null) {
                            this.imsConnectionState = new ImsConnectionState();
                        }
                        codedInputByteBufferNano.readMessage(this.imsConnectionState);
                        break;
                    case 58:
                        if (this.imsCapabilities == null) {
                            this.imsCapabilities = new ImsCapabilities();
                        }
                        codedInputByteBufferNano.readMessage(this.imsCapabilities);
                        break;
                    case 66:
                        int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 66);
                        RilDataCall[] rilDataCallArr = this.dataCalls;
                        int length = rilDataCallArr == null ? 0 : rilDataCallArr.length;
                        int i = repeatedFieldArrayLength + length;
                        RilDataCall[] rilDataCallArr2 = new RilDataCall[i];
                        if (length != 0) {
                            System.arraycopy(rilDataCallArr, 0, rilDataCallArr2, 0, length);
                        }
                        while (length < i - 1) {
                            RilDataCall rilDataCall = new RilDataCall();
                            rilDataCallArr2[length] = rilDataCall;
                            codedInputByteBufferNano.readMessage(rilDataCall);
                            codedInputByteBufferNano.readTag();
                            length++;
                        }
                        RilDataCall rilDataCall2 = new RilDataCall();
                        rilDataCallArr2[length] = rilDataCall2;
                        codedInputByteBufferNano.readMessage(rilDataCall2);
                        this.dataCalls = rilDataCallArr2;
                        break;
                    case 72:
                        int readInt322 = codedInputByteBufferNano.readInt32();
                        switch (readInt322) {
                            case 0:
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                            case 6:
                            case 7:
                            case 8:
                            case 9:
                            case 10:
                            case 11:
                            case 12:
                            case 13:
                            case 14:
                            case 15:
                            case 16:
                            case 17:
                            case 18:
                            case 19:
                            case 20:
                            case 21:
                            case 22:
                            case 23:
                            case 24:
                            case 25:
                            case 26:
                            case 27:
                            case 28:
                                this.error = readInt322;
                                break;
                            default:
                                switch (readInt322) {
                                    case 36:
                                    case 37:
                                    case 38:
                                    case 39:
                                    case 40:
                                    case 41:
                                    case 42:
                                    case 43:
                                    case 44:
                                    case 45:
                                    case 46:
                                    case 47:
                                    case 48:
                                    case 49:
                                    case 50:
                                    case 51:
                                    case 52:
                                    case 53:
                                    case 54:
                                    case 55:
                                    case 56:
                                    case 57:
                                    case 58:
                                    case 59:
                                    case 60:
                                    case 61:
                                    case 62:
                                    case 63:
                                    case 64:
                                    case 65:
                                    case 66:
                                    case 67:
                                        break;
                                }
                                this.error = readInt322;
                                break;
                        }
                    case 82:
                        if (this.setupDataCall == null) {
                            this.setupDataCall = new RilSetupDataCall();
                        }
                        codedInputByteBufferNano.readMessage(this.setupDataCall);
                        break;
                    case 90:
                        if (this.setupDataCallResponse == null) {
                            this.setupDataCallResponse = new RilSetupDataCallResponse();
                        }
                        codedInputByteBufferNano.readMessage(this.setupDataCallResponse);
                        break;
                    case 98:
                        if (this.deactivateDataCall == null) {
                            this.deactivateDataCall = new RilDeactivateDataCall();
                        }
                        codedInputByteBufferNano.readMessage(this.deactivateDataCall);
                        break;
                    case 104:
                        this.dataStallAction = codedInputByteBufferNano.readInt32();
                        break;
                    case 114:
                        if (this.modemRestart == null) {
                            this.modemRestart = new ModemRestart();
                        }
                        codedInputByteBufferNano.readMessage(this.modemRestart);
                        break;
                    case 120:
                        this.nitzTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case InterPhoneService.MSG_UPDATE_FIRMWARE_2_CLT /*130*/:
                        if (this.carrierIdMatching == null) {
                            this.carrierIdMatching = new CarrierIdMatching();
                        }
                        codedInputByteBufferNano.readMessage(this.carrierIdMatching);
                        break;
                    case 138:
                        if (this.carrierKeyChange == null) {
                            this.carrierKeyChange = new CarrierKeyChange();
                        }
                        codedInputByteBufferNano.readMessage(this.carrierKeyChange);
                        break;
                    case 154:
                        if (this.dataSwitch == null) {
                            this.dataSwitch = new DataSwitch();
                        }
                        codedInputByteBufferNano.readMessage(this.dataSwitch);
                        break;
                    case SmsMessage.MAX_USER_DATA_SEPTETS:
                        int readInt323 = codedInputByteBufferNano.readInt32();
                        if (readInt323 != 0 && readInt323 != 1 && readInt323 != 2 && readInt323 != 3) {
                            break;
                        } else {
                            this.networkValidationState = readInt323;
                            break;
                        }
                    case 170:
                        if (this.onDemandDataSwitch == null) {
                            this.onDemandDataSwitch = new OnDemandDataSwitch();
                        }
                        codedInputByteBufferNano.readMessage(this.onDemandDataSwitch);
                        break;
                    case 176:
                        int repeatedFieldArrayLength2 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 176);
                        int[] iArr = new int[repeatedFieldArrayLength2];
                        int i2 = 0;
                        for (int i3 = 0; i3 < repeatedFieldArrayLength2; i3++) {
                            if (i3 != 0) {
                                codedInputByteBufferNano.readTag();
                            }
                            int readInt324 = codedInputByteBufferNano.readInt32();
                            if (readInt324 == 0 || readInt324 == 1 || readInt324 == 2) {
                                iArr[i2] = readInt324;
                                i2++;
                            }
                        }
                        if (i2 != 0) {
                            int[] iArr2 = this.simState;
                            int length2 = iArr2 == null ? 0 : iArr2.length;
                            if (length2 != 0 || i2 != repeatedFieldArrayLength2) {
                                int[] iArr3 = new int[(length2 + i2)];
                                if (length2 != 0) {
                                    System.arraycopy(iArr2, 0, iArr3, 0, length2);
                                }
                                System.arraycopy(iArr, 0, iArr3, length2, i2);
                                this.simState = iArr3;
                                break;
                            } else {
                                this.simState = iArr;
                                break;
                            }
                        } else {
                            break;
                        }
                    case 178:
                        int pushLimit = codedInputByteBufferNano.pushLimit(codedInputByteBufferNano.readRawVarint32());
                        int position = codedInputByteBufferNano.getPosition();
                        int i4 = 0;
                        while (codedInputByteBufferNano.getBytesUntilLimit() > 0) {
                            int readInt325 = codedInputByteBufferNano.readInt32();
                            if (readInt325 == 0 || readInt325 == 1 || readInt325 == 2) {
                                i4++;
                            }
                        }
                        if (i4 != 0) {
                            codedInputByteBufferNano.rewindToPosition(position);
                            int[] iArr4 = this.simState;
                            int length3 = iArr4 == null ? 0 : iArr4.length;
                            int[] iArr5 = new int[(i4 + length3)];
                            if (length3 != 0) {
                                System.arraycopy(iArr4, 0, iArr5, 0, length3);
                            }
                            while (codedInputByteBufferNano.getBytesUntilLimit() > 0) {
                                int readInt326 = codedInputByteBufferNano.readInt32();
                                if (readInt326 == 0 || readInt326 == 1 || readInt326 == 2) {
                                    iArr5[length3] = readInt326;
                                    length3++;
                                }
                            }
                            this.simState = iArr5;
                        }
                        codedInputByteBufferNano.popLimit(pushLimit);
                        break;
                    case 186:
                        if (this.activeSubscriptionInfo == null) {
                            this.activeSubscriptionInfo = new ActiveSubscriptionInfo();
                        }
                        codedInputByteBufferNano.readMessage(this.activeSubscriptionInfo);
                        break;
                    case DnsPacket.DnsRecord.NAME_COMPRESSION /*192*/:
                        this.enabledModemBitmap = codedInputByteBufferNano.readInt32();
                        break;
                    case 202:
                        if (this.updatedEmergencyNumber == null) {
                            this.updatedEmergencyNumber = new EmergencyNumberInfo();
                        }
                        codedInputByteBufferNano.readMessage(this.updatedEmergencyNumber);
                        break;
                    case 210:
                        if (this.networkCapabilities == null) {
                            this.networkCapabilities = new NetworkCapabilitiesInfo();
                        }
                        codedInputByteBufferNano.readMessage(this.networkCapabilities);
                        break;
                    case 216:
                        this.signalStrength = codedInputByteBufferNano.readInt32();
                        break;
                    case 224:
                        this.emergencyNumberDatabaseVersion = codedInputByteBufferNano.readInt32();
                        break;
                    case 232:
                        int readInt327 = codedInputByteBufferNano.readInt32();
                        if (readInt327 != 0 && readInt327 != 1 && readInt327 != 2 && readInt327 != 3) {
                            break;
                        } else {
                            this.radioState = readInt327;
                            break;
                        }
                    default:
                        if (storeUnknownField(codedInputByteBufferNano, readTag)) {
                            break;
                        } else {
                            return this;
                        }
                }
            }
        }

        public static TelephonyEvent parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (TelephonyEvent) MessageNano.mergeFrom(new TelephonyEvent(), bArr);
        }

        public static TelephonyEvent parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new TelephonyEvent().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class ActiveSubscriptionInfo extends ExtendableMessageNano<ActiveSubscriptionInfo> {
        private static volatile ActiveSubscriptionInfo[] _emptyArray;
        public int carrierId;
        public int isOpportunistic;
        public String simMccmnc;
        public int slotIndex;

        public static ActiveSubscriptionInfo[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new ActiveSubscriptionInfo[0];
                    }
                }
            }
            return _emptyArray;
        }

        public ActiveSubscriptionInfo() {
            clear();
        }

        public ActiveSubscriptionInfo clear() {
            this.slotIndex = 0;
            this.carrierId = 0;
            this.isOpportunistic = 0;
            this.simMccmnc = "";
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.slotIndex;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.carrierId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.isOpportunistic;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            if (!this.simMccmnc.equals("")) {
                codedOutputByteBufferNano.writeString(4, this.simMccmnc);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.slotIndex;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            int i2 = this.carrierId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.isOpportunistic;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            return !this.simMccmnc.equals("") ? computeSerializedSize + CodedOutputByteBufferNano.computeStringSize(4, this.simMccmnc) : computeSerializedSize;
        }

        public ActiveSubscriptionInfo mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.slotIndex = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.isOpportunistic = codedInputByteBufferNano.readInt32();
                } else if (readTag == 34) {
                    this.simMccmnc = codedInputByteBufferNano.readString();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static ActiveSubscriptionInfo parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (ActiveSubscriptionInfo) MessageNano.mergeFrom(new ActiveSubscriptionInfo(), bArr);
        }

        public static ActiveSubscriptionInfo parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new ActiveSubscriptionInfo().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class TelephonyCallSession extends ExtendableMessageNano<TelephonyCallSession> {
        private static volatile TelephonyCallSession[] _emptyArray;
        public Event[] events;
        public boolean eventsDropped;
        public int phoneId;
        public int startTimeMinutes;

        public static final class Event extends ExtendableMessageNano<Event> {
            private static volatile Event[] _emptyArray;
            public int audioCodec;
            public int callIndex;
            public CallQuality callQuality;
            public CallQualitySummary callQualitySummaryDl;
            public CallQualitySummary callQualitySummaryUl;
            public int callState;
            public RilCall[] calls;
            public RilDataCall[] dataCalls;
            public int delay;
            public int emergencyNumberDatabaseVersion;
            public int error;
            public ImsCapabilities imsCapabilities;
            public int imsCommand;
            public ImsConnectionState imsConnectionState;
            public EmergencyNumberInfo imsEmergencyNumberInfo;
            public boolean isImsEmergencyCall;
            public int mergedCallIndex;
            public long nitzTimestampMillis;
            public int phoneState;
            public ImsReasonInfo reasonInfo;
            public int rilRequest;
            public int rilRequestId;
            public TelephonyServiceState serviceState;
            public TelephonySettings settings;
            public int srcAccessTech;
            public int srvccState;
            public int targetAccessTech;
            public int type;

            public interface AudioCodec {
                public static final int AUDIO_CODEC_AMR = 1;
                public static final int AUDIO_CODEC_AMR_WB = 2;
                public static final int AUDIO_CODEC_EVRC = 4;
                public static final int AUDIO_CODEC_EVRC_B = 5;
                public static final int AUDIO_CODEC_EVRC_NW = 7;
                public static final int AUDIO_CODEC_EVRC_WB = 6;
                public static final int AUDIO_CODEC_EVS_FB = 20;
                public static final int AUDIO_CODEC_EVS_NB = 17;
                public static final int AUDIO_CODEC_EVS_SWB = 19;
                public static final int AUDIO_CODEC_EVS_WB = 18;
                public static final int AUDIO_CODEC_G711A = 13;
                public static final int AUDIO_CODEC_G711AB = 15;
                public static final int AUDIO_CODEC_G711U = 11;
                public static final int AUDIO_CODEC_G722 = 14;
                public static final int AUDIO_CODEC_G723 = 12;
                public static final int AUDIO_CODEC_G729 = 16;
                public static final int AUDIO_CODEC_GSM_EFR = 8;
                public static final int AUDIO_CODEC_GSM_FR = 9;
                public static final int AUDIO_CODEC_GSM_HR = 10;
                public static final int AUDIO_CODEC_QCELP13K = 3;
                public static final int AUDIO_CODEC_UNKNOWN = 0;
            }

            public interface CallState {
                public static final int CALL_ACTIVE = 2;
                public static final int CALL_ALERTING = 5;
                public static final int CALL_DIALING = 4;
                public static final int CALL_DISCONNECTED = 8;
                public static final int CALL_DISCONNECTING = 9;
                public static final int CALL_HOLDING = 3;
                public static final int CALL_IDLE = 1;
                public static final int CALL_INCOMING = 6;
                public static final int CALL_UNKNOWN = 0;
                public static final int CALL_WAITING = 7;
            }

            public interface ImsCommand {
                public static final int IMS_CMD_ACCEPT = 2;
                public static final int IMS_CMD_CONFERENCE_EXTEND = 9;
                public static final int IMS_CMD_HOLD = 5;
                public static final int IMS_CMD_INVITE_PARTICIPANT = 10;
                public static final int IMS_CMD_MERGE = 7;
                public static final int IMS_CMD_REJECT = 3;
                public static final int IMS_CMD_REMOVE_PARTICIPANT = 11;
                public static final int IMS_CMD_RESUME = 6;
                public static final int IMS_CMD_START = 1;
                public static final int IMS_CMD_TERMINATE = 4;
                public static final int IMS_CMD_UNKNOWN = 0;
                public static final int IMS_CMD_UPDATE = 8;
            }

            public interface PhoneState {
                public static final int STATE_IDLE = 1;
                public static final int STATE_OFFHOOK = 3;
                public static final int STATE_RINGING = 2;
                public static final int STATE_UNKNOWN = 0;
            }

            public interface RilRequest {
                public static final int RIL_REQUEST_ANSWER = 2;
                public static final int RIL_REQUEST_CDMA_FLASH = 6;
                public static final int RIL_REQUEST_CONFERENCE = 7;
                public static final int RIL_REQUEST_DIAL = 1;
                public static final int RIL_REQUEST_HANGUP = 3;
                public static final int RIL_REQUEST_SET_CALL_WAITING = 4;
                public static final int RIL_REQUEST_SWITCH_HOLDING_AND_ACTIVE = 5;
                public static final int RIL_REQUEST_UNKNOWN = 0;
            }

            public interface RilSrvccState {
                public static final int HANDOVER_CANCELED = 4;
                public static final int HANDOVER_COMPLETED = 2;
                public static final int HANDOVER_FAILED = 3;
                public static final int HANDOVER_STARTED = 1;
                public static final int HANDOVER_UNKNOWN = 0;
            }

            public interface Type {
                public static final int AUDIO_CODEC = 22;
                public static final int CALL_QUALITY_CHANGED = 23;
                public static final int DATA_CALL_LIST_CHANGED = 5;
                public static final int EVENT_UNKNOWN = 0;
                public static final int IMS_CALL_HANDOVER = 18;
                public static final int IMS_CALL_HANDOVER_FAILED = 19;
                public static final int IMS_CALL_RECEIVE = 15;
                public static final int IMS_CALL_STATE_CHANGED = 16;
                public static final int IMS_CALL_TERMINATED = 17;
                public static final int IMS_CAPABILITIES_CHANGED = 4;
                public static final int IMS_COMMAND = 11;
                public static final int IMS_COMMAND_COMPLETE = 14;
                public static final int IMS_COMMAND_FAILED = 13;
                public static final int IMS_COMMAND_RECEIVED = 12;
                public static final int IMS_CONNECTION_STATE_CHANGED = 3;
                public static final int NITZ_TIME = 21;
                public static final int PHONE_STATE_CHANGED = 20;
                public static final int RIL_CALL_LIST_CHANGED = 10;
                public static final int RIL_CALL_RING = 8;
                public static final int RIL_CALL_SRVCC = 9;
                public static final int RIL_REQUEST = 6;
                public static final int RIL_RESPONSE = 7;
                public static final int RIL_SERVICE_STATE_CHANGED = 2;
                public static final int SETTINGS_CHANGED = 1;
            }

            public static final class RilCall extends ExtendableMessageNano<RilCall> {
                private static volatile RilCall[] _emptyArray;
                public int callEndReason;
                public int emergencyNumberDatabaseVersion;
                public EmergencyNumberInfo emergencyNumberInfo;
                public int index;
                public boolean isEmergencyCall;
                public boolean isMultiparty;
                public int preciseDisconnectCause;
                public int state;
                public int type;

                public interface Type {
                    public static final int MO = 1;
                    public static final int MT = 2;
                    public static final int UNKNOWN = 0;
                }

                public static RilCall[] emptyArray() {
                    if (_emptyArray == null) {
                        synchronized (InternalNano.LAZY_INIT_LOCK) {
                            if (_emptyArray == null) {
                                _emptyArray = new RilCall[0];
                            }
                        }
                    }
                    return _emptyArray;
                }

                public RilCall() {
                    clear();
                }

                public RilCall clear() {
                    this.index = 0;
                    this.state = 0;
                    this.type = 0;
                    this.callEndReason = 0;
                    this.isMultiparty = false;
                    this.preciseDisconnectCause = 0;
                    this.isEmergencyCall = false;
                    this.emergencyNumberInfo = null;
                    this.emergencyNumberDatabaseVersion = 0;
                    this.unknownFieldData = null;
                    this.cachedSize = -1;
                    return this;
                }

                public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                    int i = this.index;
                    if (i != 0) {
                        codedOutputByteBufferNano.writeInt32(1, i);
                    }
                    int i2 = this.state;
                    if (i2 != 0) {
                        codedOutputByteBufferNano.writeInt32(2, i2);
                    }
                    int i3 = this.type;
                    if (i3 != 0) {
                        codedOutputByteBufferNano.writeInt32(3, i3);
                    }
                    int i4 = this.callEndReason;
                    if (i4 != 0) {
                        codedOutputByteBufferNano.writeInt32(4, i4);
                    }
                    boolean z = this.isMultiparty;
                    if (z) {
                        codedOutputByteBufferNano.writeBool(5, z);
                    }
                    int i5 = this.preciseDisconnectCause;
                    if (i5 != 0) {
                        codedOutputByteBufferNano.writeInt32(6, i5);
                    }
                    boolean z2 = this.isEmergencyCall;
                    if (z2) {
                        codedOutputByteBufferNano.writeBool(7, z2);
                    }
                    EmergencyNumberInfo emergencyNumberInfo2 = this.emergencyNumberInfo;
                    if (emergencyNumberInfo2 != null) {
                        codedOutputByteBufferNano.writeMessage(8, emergencyNumberInfo2);
                    }
                    int i6 = this.emergencyNumberDatabaseVersion;
                    if (i6 != 0) {
                        codedOutputByteBufferNano.writeInt32(9, i6);
                    }
                    super.writeTo(codedOutputByteBufferNano);
                }

                /* access modifiers changed from: protected */
                public int computeSerializedSize() {
                    int computeSerializedSize = super.computeSerializedSize();
                    int i = this.index;
                    if (i != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                    }
                    int i2 = this.state;
                    if (i2 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
                    }
                    int i3 = this.type;
                    if (i3 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
                    }
                    int i4 = this.callEndReason;
                    if (i4 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
                    }
                    boolean z = this.isMultiparty;
                    if (z) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(5, z);
                    }
                    int i5 = this.preciseDisconnectCause;
                    if (i5 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i5);
                    }
                    boolean z2 = this.isEmergencyCall;
                    if (z2) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(7, z2);
                    }
                    EmergencyNumberInfo emergencyNumberInfo2 = this.emergencyNumberInfo;
                    if (emergencyNumberInfo2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(8, emergencyNumberInfo2);
                    }
                    int i6 = this.emergencyNumberDatabaseVersion;
                    return i6 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(9, i6) : computeSerializedSize;
                }

                public RilCall mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                    while (true) {
                        int readTag = codedInputByteBufferNano.readTag();
                        if (readTag == 0) {
                            return this;
                        }
                        if (readTag != 8) {
                            if (readTag == 16) {
                                int readInt32 = codedInputByteBufferNano.readInt32();
                                switch (readInt32) {
                                    case 0:
                                    case 1:
                                    case 2:
                                    case 3:
                                    case 4:
                                    case 5:
                                    case 6:
                                    case 7:
                                    case 8:
                                    case 9:
                                        this.state = readInt32;
                                        break;
                                }
                            } else if (readTag == 24) {
                                int readInt322 = codedInputByteBufferNano.readInt32();
                                if (readInt322 == 0 || readInt322 == 1 || readInt322 == 2) {
                                    this.type = readInt322;
                                }
                            } else if (readTag == 32) {
                                this.callEndReason = codedInputByteBufferNano.readInt32();
                            } else if (readTag == 40) {
                                this.isMultiparty = codedInputByteBufferNano.readBool();
                            } else if (readTag == 48) {
                                this.preciseDisconnectCause = codedInputByteBufferNano.readInt32();
                            } else if (readTag == 56) {
                                this.isEmergencyCall = codedInputByteBufferNano.readBool();
                            } else if (readTag == 66) {
                                if (this.emergencyNumberInfo == null) {
                                    this.emergencyNumberInfo = new EmergencyNumberInfo();
                                }
                                codedInputByteBufferNano.readMessage(this.emergencyNumberInfo);
                            } else if (readTag == 72) {
                                this.emergencyNumberDatabaseVersion = codedInputByteBufferNano.readInt32();
                            } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                                return this;
                            }
                        } else {
                            this.index = codedInputByteBufferNano.readInt32();
                        }
                    }
                }

                public static RilCall parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                    return (RilCall) MessageNano.mergeFrom(new RilCall(), bArr);
                }

                public static RilCall parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                    return new RilCall().mergeFrom(codedInputByteBufferNano);
                }
            }

            public static final class SignalStrength extends ExtendableMessageNano<SignalStrength> {
                private static volatile SignalStrength[] _emptyArray;
                public int lteSnr;

                public static SignalStrength[] emptyArray() {
                    if (_emptyArray == null) {
                        synchronized (InternalNano.LAZY_INIT_LOCK) {
                            if (_emptyArray == null) {
                                _emptyArray = new SignalStrength[0];
                            }
                        }
                    }
                    return _emptyArray;
                }

                public SignalStrength() {
                    clear();
                }

                public SignalStrength clear() {
                    this.lteSnr = 0;
                    this.unknownFieldData = null;
                    this.cachedSize = -1;
                    return this;
                }

                public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                    int i = this.lteSnr;
                    if (i != 0) {
                        codedOutputByteBufferNano.writeInt32(1, i);
                    }
                    super.writeTo(codedOutputByteBufferNano);
                }

                /* access modifiers changed from: protected */
                public int computeSerializedSize() {
                    int computeSerializedSize = super.computeSerializedSize();
                    int i = this.lteSnr;
                    return i != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(1, i) : computeSerializedSize;
                }

                public SignalStrength mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                    while (true) {
                        int readTag = codedInputByteBufferNano.readTag();
                        if (readTag == 0) {
                            return this;
                        }
                        if (readTag == 8) {
                            this.lteSnr = codedInputByteBufferNano.readInt32();
                        } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                            return this;
                        }
                    }
                }

                public static SignalStrength parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                    return (SignalStrength) MessageNano.mergeFrom(new SignalStrength(), bArr);
                }

                public static SignalStrength parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                    return new SignalStrength().mergeFrom(codedInputByteBufferNano);
                }
            }

            public static final class CallQuality extends ExtendableMessageNano<CallQuality> {
                private static volatile CallQuality[] _emptyArray;
                public int averageRelativeJitterMillis;
                public int averageRoundTripTime;
                public int codecType;
                public int downlinkLevel;
                public int durationInSeconds;
                public long maxPlayoutDelayMillis;
                public int maxRelativeJitterMillis;
                public long minPlayoutDelayMillis;
                public int noDataFrames;
                public int rtpDroppedPackets;
                public int rtpDuplicatePackets;
                public boolean rtpInactivityDetected;
                public int rtpPacketsNotReceived;
                public int rtpPacketsReceived;
                public int rtpPacketsTransmitted;
                public int rtpPacketsTransmittedLost;
                public int rxRtpSidPackets;
                public boolean rxSilenceDetected;
                public boolean txSilenceDetected;
                public int uplinkLevel;
                public int voiceFrames;

                public interface CallQualityLevel {
                    public static final int BAD = 5;
                    public static final int EXCELLENT = 1;
                    public static final int FAIR = 3;
                    public static final int GOOD = 2;
                    public static final int NOT_AVAILABLE = 6;
                    public static final int POOR = 4;
                    public static final int UNDEFINED = 0;
                }

                public static CallQuality[] emptyArray() {
                    if (_emptyArray == null) {
                        synchronized (InternalNano.LAZY_INIT_LOCK) {
                            if (_emptyArray == null) {
                                _emptyArray = new CallQuality[0];
                            }
                        }
                    }
                    return _emptyArray;
                }

                public CallQuality() {
                    clear();
                }

                public CallQuality clear() {
                    this.downlinkLevel = 0;
                    this.uplinkLevel = 0;
                    this.durationInSeconds = 0;
                    this.rtpPacketsTransmitted = 0;
                    this.rtpPacketsReceived = 0;
                    this.rtpPacketsTransmittedLost = 0;
                    this.rtpPacketsNotReceived = 0;
                    this.averageRelativeJitterMillis = 0;
                    this.maxRelativeJitterMillis = 0;
                    this.averageRoundTripTime = 0;
                    this.codecType = 0;
                    this.rtpInactivityDetected = false;
                    this.rxSilenceDetected = false;
                    this.txSilenceDetected = false;
                    this.voiceFrames = 0;
                    this.noDataFrames = 0;
                    this.rtpDroppedPackets = 0;
                    this.minPlayoutDelayMillis = 0;
                    this.maxPlayoutDelayMillis = 0;
                    this.rxRtpSidPackets = 0;
                    this.rtpDuplicatePackets = 0;
                    this.unknownFieldData = null;
                    this.cachedSize = -1;
                    return this;
                }

                public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                    int i = this.downlinkLevel;
                    if (i != 0) {
                        codedOutputByteBufferNano.writeInt32(1, i);
                    }
                    int i2 = this.uplinkLevel;
                    if (i2 != 0) {
                        codedOutputByteBufferNano.writeInt32(2, i2);
                    }
                    int i3 = this.durationInSeconds;
                    if (i3 != 0) {
                        codedOutputByteBufferNano.writeInt32(3, i3);
                    }
                    int i4 = this.rtpPacketsTransmitted;
                    if (i4 != 0) {
                        codedOutputByteBufferNano.writeInt32(4, i4);
                    }
                    int i5 = this.rtpPacketsReceived;
                    if (i5 != 0) {
                        codedOutputByteBufferNano.writeInt32(5, i5);
                    }
                    int i6 = this.rtpPacketsTransmittedLost;
                    if (i6 != 0) {
                        codedOutputByteBufferNano.writeInt32(6, i6);
                    }
                    int i7 = this.rtpPacketsNotReceived;
                    if (i7 != 0) {
                        codedOutputByteBufferNano.writeInt32(7, i7);
                    }
                    int i8 = this.averageRelativeJitterMillis;
                    if (i8 != 0) {
                        codedOutputByteBufferNano.writeInt32(8, i8);
                    }
                    int i9 = this.maxRelativeJitterMillis;
                    if (i9 != 0) {
                        codedOutputByteBufferNano.writeInt32(9, i9);
                    }
                    int i10 = this.averageRoundTripTime;
                    if (i10 != 0) {
                        codedOutputByteBufferNano.writeInt32(10, i10);
                    }
                    int i11 = this.codecType;
                    if (i11 != 0) {
                        codedOutputByteBufferNano.writeInt32(11, i11);
                    }
                    boolean z = this.rtpInactivityDetected;
                    if (z) {
                        codedOutputByteBufferNano.writeBool(12, z);
                    }
                    boolean z2 = this.rxSilenceDetected;
                    if (z2) {
                        codedOutputByteBufferNano.writeBool(13, z2);
                    }
                    boolean z3 = this.txSilenceDetected;
                    if (z3) {
                        codedOutputByteBufferNano.writeBool(14, z3);
                    }
                    int i12 = this.voiceFrames;
                    if (i12 != 0) {
                        codedOutputByteBufferNano.writeInt32(15, i12);
                    }
                    int i13 = this.noDataFrames;
                    if (i13 != 0) {
                        codedOutputByteBufferNano.writeInt32(16, i13);
                    }
                    int i14 = this.rtpDroppedPackets;
                    if (i14 != 0) {
                        codedOutputByteBufferNano.writeInt32(17, i14);
                    }
                    long j = this.minPlayoutDelayMillis;
                    if (j != 0) {
                        codedOutputByteBufferNano.writeInt64(18, j);
                    }
                    long j2 = this.maxPlayoutDelayMillis;
                    if (j2 != 0) {
                        codedOutputByteBufferNano.writeInt64(19, j2);
                    }
                    int i15 = this.rxRtpSidPackets;
                    if (i15 != 0) {
                        codedOutputByteBufferNano.writeInt32(20, i15);
                    }
                    int i16 = this.rtpDuplicatePackets;
                    if (i16 != 0) {
                        codedOutputByteBufferNano.writeInt32(21, i16);
                    }
                    super.writeTo(codedOutputByteBufferNano);
                }

                /* access modifiers changed from: protected */
                public int computeSerializedSize() {
                    int computeSerializedSize = super.computeSerializedSize();
                    int i = this.downlinkLevel;
                    if (i != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                    }
                    int i2 = this.uplinkLevel;
                    if (i2 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
                    }
                    int i3 = this.durationInSeconds;
                    if (i3 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
                    }
                    int i4 = this.rtpPacketsTransmitted;
                    if (i4 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
                    }
                    int i5 = this.rtpPacketsReceived;
                    if (i5 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i5);
                    }
                    int i6 = this.rtpPacketsTransmittedLost;
                    if (i6 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i6);
                    }
                    int i7 = this.rtpPacketsNotReceived;
                    if (i7 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(7, i7);
                    }
                    int i8 = this.averageRelativeJitterMillis;
                    if (i8 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(8, i8);
                    }
                    int i9 = this.maxRelativeJitterMillis;
                    if (i9 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(9, i9);
                    }
                    int i10 = this.averageRoundTripTime;
                    if (i10 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(10, i10);
                    }
                    int i11 = this.codecType;
                    if (i11 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(11, i11);
                    }
                    boolean z = this.rtpInactivityDetected;
                    if (z) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(12, z);
                    }
                    boolean z2 = this.rxSilenceDetected;
                    if (z2) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(13, z2);
                    }
                    boolean z3 = this.txSilenceDetected;
                    if (z3) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(14, z3);
                    }
                    int i12 = this.voiceFrames;
                    if (i12 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(15, i12);
                    }
                    int i13 = this.noDataFrames;
                    if (i13 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(16, i13);
                    }
                    int i14 = this.rtpDroppedPackets;
                    if (i14 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(17, i14);
                    }
                    long j = this.minPlayoutDelayMillis;
                    if (j != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(18, j);
                    }
                    long j2 = this.maxPlayoutDelayMillis;
                    if (j2 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(19, j2);
                    }
                    int i15 = this.rxRtpSidPackets;
                    if (i15 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(20, i15);
                    }
                    int i16 = this.rtpDuplicatePackets;
                    return i16 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(21, i16) : computeSerializedSize;
                }

                public CallQuality mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                    while (true) {
                        int readTag = codedInputByteBufferNano.readTag();
                        switch (readTag) {
                            case 0:
                                return this;
                            case 8:
                                int readInt32 = codedInputByteBufferNano.readInt32();
                                switch (readInt32) {
                                    case 0:
                                    case 1:
                                    case 2:
                                    case 3:
                                    case 4:
                                    case 5:
                                    case 6:
                                        this.downlinkLevel = readInt32;
                                        break;
                                }
                            case 16:
                                int readInt322 = codedInputByteBufferNano.readInt32();
                                switch (readInt322) {
                                    case 0:
                                    case 1:
                                    case 2:
                                    case 3:
                                    case 4:
                                    case 5:
                                    case 6:
                                        this.uplinkLevel = readInt322;
                                        break;
                                }
                            case 24:
                                this.durationInSeconds = codedInputByteBufferNano.readInt32();
                                break;
                            case 32:
                                this.rtpPacketsTransmitted = codedInputByteBufferNano.readInt32();
                                break;
                            case 40:
                                this.rtpPacketsReceived = codedInputByteBufferNano.readInt32();
                                break;
                            case 48:
                                this.rtpPacketsTransmittedLost = codedInputByteBufferNano.readInt32();
                                break;
                            case 56:
                                this.rtpPacketsNotReceived = codedInputByteBufferNano.readInt32();
                                break;
                            case 64:
                                this.averageRelativeJitterMillis = codedInputByteBufferNano.readInt32();
                                break;
                            case 72:
                                this.maxRelativeJitterMillis = codedInputByteBufferNano.readInt32();
                                break;
                            case 80:
                                this.averageRoundTripTime = codedInputByteBufferNano.readInt32();
                                break;
                            case 88:
                                int readInt323 = codedInputByteBufferNano.readInt32();
                                switch (readInt323) {
                                    case 0:
                                    case 1:
                                    case 2:
                                    case 3:
                                    case 4:
                                    case 5:
                                    case 6:
                                    case 7:
                                    case 8:
                                    case 9:
                                    case 10:
                                    case 11:
                                    case 12:
                                    case 13:
                                    case 14:
                                    case 15:
                                    case 16:
                                    case 17:
                                    case 18:
                                    case 19:
                                    case 20:
                                        this.codecType = readInt323;
                                        break;
                                }
                            case 96:
                                this.rtpInactivityDetected = codedInputByteBufferNano.readBool();
                                break;
                            case 104:
                                this.rxSilenceDetected = codedInputByteBufferNano.readBool();
                                break;
                            case 112:
                                this.txSilenceDetected = codedInputByteBufferNano.readBool();
                                break;
                            case 120:
                                this.voiceFrames = codedInputByteBufferNano.readInt32();
                                break;
                            case 128:
                                this.noDataFrames = codedInputByteBufferNano.readInt32();
                                break;
                            case NetworkStackConstants.ICMPV6_NEIGHBOR_ADVERTISEMENT /*136*/:
                                this.rtpDroppedPackets = codedInputByteBufferNano.readInt32();
                                break;
                            case 144:
                                this.minPlayoutDelayMillis = codedInputByteBufferNano.readInt64();
                                break;
                            case 152:
                                this.maxPlayoutDelayMillis = codedInputByteBufferNano.readInt64();
                                break;
                            case SmsMessage.MAX_USER_DATA_SEPTETS:
                                this.rxRtpSidPackets = codedInputByteBufferNano.readInt32();
                                break;
                            case 168:
                                this.rtpDuplicatePackets = codedInputByteBufferNano.readInt32();
                                break;
                            default:
                                if (storeUnknownField(codedInputByteBufferNano, readTag)) {
                                    break;
                                } else {
                                    return this;
                                }
                        }
                    }
                }

                public static CallQuality parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                    return (CallQuality) MessageNano.mergeFrom(new CallQuality(), bArr);
                }

                public static CallQuality parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                    return new CallQuality().mergeFrom(codedInputByteBufferNano);
                }
            }

            public static final class CallQualitySummary extends ExtendableMessageNano<CallQualitySummary> {
                private static volatile CallQualitySummary[] _emptyArray;
                public SignalStrength bestSsWithBadQuality;
                public SignalStrength bestSsWithGoodQuality;
                public CallQuality snapshotOfBestSsWithBadQuality;
                public CallQuality snapshotOfBestSsWithGoodQuality;
                public CallQuality snapshotOfEnd;
                public CallQuality snapshotOfWorstSsWithBadQuality;
                public CallQuality snapshotOfWorstSsWithGoodQuality;
                public int totalBadQualityDurationInSeconds;
                public int totalDurationWithQualityInformationInSeconds;
                public int totalGoodQualityDurationInSeconds;
                public SignalStrength worstSsWithBadQuality;
                public SignalStrength worstSsWithGoodQuality;

                public static CallQualitySummary[] emptyArray() {
                    if (_emptyArray == null) {
                        synchronized (InternalNano.LAZY_INIT_LOCK) {
                            if (_emptyArray == null) {
                                _emptyArray = new CallQualitySummary[0];
                            }
                        }
                    }
                    return _emptyArray;
                }

                public CallQualitySummary() {
                    clear();
                }

                public CallQualitySummary clear() {
                    this.totalGoodQualityDurationInSeconds = 0;
                    this.totalBadQualityDurationInSeconds = 0;
                    this.totalDurationWithQualityInformationInSeconds = 0;
                    this.snapshotOfWorstSsWithGoodQuality = null;
                    this.snapshotOfBestSsWithGoodQuality = null;
                    this.snapshotOfWorstSsWithBadQuality = null;
                    this.snapshotOfBestSsWithBadQuality = null;
                    this.worstSsWithGoodQuality = null;
                    this.bestSsWithGoodQuality = null;
                    this.worstSsWithBadQuality = null;
                    this.bestSsWithBadQuality = null;
                    this.snapshotOfEnd = null;
                    this.unknownFieldData = null;
                    this.cachedSize = -1;
                    return this;
                }

                public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                    int i = this.totalGoodQualityDurationInSeconds;
                    if (i != 0) {
                        codedOutputByteBufferNano.writeInt32(1, i);
                    }
                    int i2 = this.totalBadQualityDurationInSeconds;
                    if (i2 != 0) {
                        codedOutputByteBufferNano.writeInt32(2, i2);
                    }
                    int i3 = this.totalDurationWithQualityInformationInSeconds;
                    if (i3 != 0) {
                        codedOutputByteBufferNano.writeInt32(3, i3);
                    }
                    CallQuality callQuality = this.snapshotOfWorstSsWithGoodQuality;
                    if (callQuality != null) {
                        codedOutputByteBufferNano.writeMessage(4, callQuality);
                    }
                    CallQuality callQuality2 = this.snapshotOfBestSsWithGoodQuality;
                    if (callQuality2 != null) {
                        codedOutputByteBufferNano.writeMessage(5, callQuality2);
                    }
                    CallQuality callQuality3 = this.snapshotOfWorstSsWithBadQuality;
                    if (callQuality3 != null) {
                        codedOutputByteBufferNano.writeMessage(6, callQuality3);
                    }
                    CallQuality callQuality4 = this.snapshotOfBestSsWithBadQuality;
                    if (callQuality4 != null) {
                        codedOutputByteBufferNano.writeMessage(7, callQuality4);
                    }
                    SignalStrength signalStrength = this.worstSsWithGoodQuality;
                    if (signalStrength != null) {
                        codedOutputByteBufferNano.writeMessage(8, signalStrength);
                    }
                    SignalStrength signalStrength2 = this.bestSsWithGoodQuality;
                    if (signalStrength2 != null) {
                        codedOutputByteBufferNano.writeMessage(9, signalStrength2);
                    }
                    SignalStrength signalStrength3 = this.worstSsWithBadQuality;
                    if (signalStrength3 != null) {
                        codedOutputByteBufferNano.writeMessage(10, signalStrength3);
                    }
                    SignalStrength signalStrength4 = this.bestSsWithBadQuality;
                    if (signalStrength4 != null) {
                        codedOutputByteBufferNano.writeMessage(11, signalStrength4);
                    }
                    CallQuality callQuality5 = this.snapshotOfEnd;
                    if (callQuality5 != null) {
                        codedOutputByteBufferNano.writeMessage(12, callQuality5);
                    }
                    super.writeTo(codedOutputByteBufferNano);
                }

                /* access modifiers changed from: protected */
                public int computeSerializedSize() {
                    int computeSerializedSize = super.computeSerializedSize();
                    int i = this.totalGoodQualityDurationInSeconds;
                    if (i != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                    }
                    int i2 = this.totalBadQualityDurationInSeconds;
                    if (i2 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
                    }
                    int i3 = this.totalDurationWithQualityInformationInSeconds;
                    if (i3 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
                    }
                    CallQuality callQuality = this.snapshotOfWorstSsWithGoodQuality;
                    if (callQuality != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(4, callQuality);
                    }
                    CallQuality callQuality2 = this.snapshotOfBestSsWithGoodQuality;
                    if (callQuality2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(5, callQuality2);
                    }
                    CallQuality callQuality3 = this.snapshotOfWorstSsWithBadQuality;
                    if (callQuality3 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(6, callQuality3);
                    }
                    CallQuality callQuality4 = this.snapshotOfBestSsWithBadQuality;
                    if (callQuality4 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(7, callQuality4);
                    }
                    SignalStrength signalStrength = this.worstSsWithGoodQuality;
                    if (signalStrength != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(8, signalStrength);
                    }
                    SignalStrength signalStrength2 = this.bestSsWithGoodQuality;
                    if (signalStrength2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(9, signalStrength2);
                    }
                    SignalStrength signalStrength3 = this.worstSsWithBadQuality;
                    if (signalStrength3 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(10, signalStrength3);
                    }
                    SignalStrength signalStrength4 = this.bestSsWithBadQuality;
                    if (signalStrength4 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(11, signalStrength4);
                    }
                    CallQuality callQuality5 = this.snapshotOfEnd;
                    return callQuality5 != null ? computeSerializedSize + CodedOutputByteBufferNano.computeMessageSize(12, callQuality5) : computeSerializedSize;
                }

                public CallQualitySummary mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                    while (true) {
                        int readTag = codedInputByteBufferNano.readTag();
                        switch (readTag) {
                            case 0:
                                return this;
                            case 8:
                                this.totalGoodQualityDurationInSeconds = codedInputByteBufferNano.readInt32();
                                break;
                            case 16:
                                this.totalBadQualityDurationInSeconds = codedInputByteBufferNano.readInt32();
                                break;
                            case 24:
                                this.totalDurationWithQualityInformationInSeconds = codedInputByteBufferNano.readInt32();
                                break;
                            case 34:
                                if (this.snapshotOfWorstSsWithGoodQuality == null) {
                                    this.snapshotOfWorstSsWithGoodQuality = new CallQuality();
                                }
                                codedInputByteBufferNano.readMessage(this.snapshotOfWorstSsWithGoodQuality);
                                break;
                            case 42:
                                if (this.snapshotOfBestSsWithGoodQuality == null) {
                                    this.snapshotOfBestSsWithGoodQuality = new CallQuality();
                                }
                                codedInputByteBufferNano.readMessage(this.snapshotOfBestSsWithGoodQuality);
                                break;
                            case 50:
                                if (this.snapshotOfWorstSsWithBadQuality == null) {
                                    this.snapshotOfWorstSsWithBadQuality = new CallQuality();
                                }
                                codedInputByteBufferNano.readMessage(this.snapshotOfWorstSsWithBadQuality);
                                break;
                            case 58:
                                if (this.snapshotOfBestSsWithBadQuality == null) {
                                    this.snapshotOfBestSsWithBadQuality = new CallQuality();
                                }
                                codedInputByteBufferNano.readMessage(this.snapshotOfBestSsWithBadQuality);
                                break;
                            case 66:
                                if (this.worstSsWithGoodQuality == null) {
                                    this.worstSsWithGoodQuality = new SignalStrength();
                                }
                                codedInputByteBufferNano.readMessage(this.worstSsWithGoodQuality);
                                break;
                            case 74:
                                if (this.bestSsWithGoodQuality == null) {
                                    this.bestSsWithGoodQuality = new SignalStrength();
                                }
                                codedInputByteBufferNano.readMessage(this.bestSsWithGoodQuality);
                                break;
                            case 82:
                                if (this.worstSsWithBadQuality == null) {
                                    this.worstSsWithBadQuality = new SignalStrength();
                                }
                                codedInputByteBufferNano.readMessage(this.worstSsWithBadQuality);
                                break;
                            case 90:
                                if (this.bestSsWithBadQuality == null) {
                                    this.bestSsWithBadQuality = new SignalStrength();
                                }
                                codedInputByteBufferNano.readMessage(this.bestSsWithBadQuality);
                                break;
                            case 98:
                                if (this.snapshotOfEnd == null) {
                                    this.snapshotOfEnd = new CallQuality();
                                }
                                codedInputByteBufferNano.readMessage(this.snapshotOfEnd);
                                break;
                            default:
                                if (storeUnknownField(codedInputByteBufferNano, readTag)) {
                                    break;
                                } else {
                                    return this;
                                }
                        }
                    }
                }

                public static CallQualitySummary parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                    return (CallQualitySummary) MessageNano.mergeFrom(new CallQualitySummary(), bArr);
                }

                public static CallQualitySummary parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                    return new CallQualitySummary().mergeFrom(codedInputByteBufferNano);
                }
            }

            public static Event[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new Event[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public Event() {
                clear();
            }

            public Event clear() {
                this.type = 0;
                this.delay = 0;
                this.settings = null;
                this.serviceState = null;
                this.imsConnectionState = null;
                this.imsCapabilities = null;
                this.dataCalls = RilDataCall.emptyArray();
                this.phoneState = 0;
                this.callState = 0;
                this.callIndex = 0;
                this.mergedCallIndex = 0;
                this.calls = RilCall.emptyArray();
                this.error = 0;
                this.rilRequest = 0;
                this.rilRequestId = 0;
                this.srvccState = 0;
                this.imsCommand = 0;
                this.reasonInfo = null;
                this.srcAccessTech = -1;
                this.targetAccessTech = -1;
                this.nitzTimestampMillis = 0;
                this.audioCodec = 0;
                this.callQuality = null;
                this.callQualitySummaryDl = null;
                this.callQualitySummaryUl = null;
                this.isImsEmergencyCall = false;
                this.imsEmergencyNumberInfo = null;
                this.emergencyNumberDatabaseVersion = 0;
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                int i = this.type;
                if (i != 0) {
                    codedOutputByteBufferNano.writeInt32(1, i);
                }
                int i2 = this.delay;
                if (i2 != 0) {
                    codedOutputByteBufferNano.writeInt32(2, i2);
                }
                TelephonySettings telephonySettings = this.settings;
                if (telephonySettings != null) {
                    codedOutputByteBufferNano.writeMessage(3, telephonySettings);
                }
                TelephonyServiceState telephonyServiceState = this.serviceState;
                if (telephonyServiceState != null) {
                    codedOutputByteBufferNano.writeMessage(4, telephonyServiceState);
                }
                ImsConnectionState imsConnectionState2 = this.imsConnectionState;
                if (imsConnectionState2 != null) {
                    codedOutputByteBufferNano.writeMessage(5, imsConnectionState2);
                }
                ImsCapabilities imsCapabilities2 = this.imsCapabilities;
                if (imsCapabilities2 != null) {
                    codedOutputByteBufferNano.writeMessage(6, imsCapabilities2);
                }
                RilDataCall[] rilDataCallArr = this.dataCalls;
                int i3 = 0;
                if (rilDataCallArr != null && rilDataCallArr.length > 0) {
                    int i4 = 0;
                    while (true) {
                        RilDataCall[] rilDataCallArr2 = this.dataCalls;
                        if (i4 >= rilDataCallArr2.length) {
                            break;
                        }
                        RilDataCall rilDataCall = rilDataCallArr2[i4];
                        if (rilDataCall != null) {
                            codedOutputByteBufferNano.writeMessage(7, rilDataCall);
                        }
                        i4++;
                    }
                }
                int i5 = this.phoneState;
                if (i5 != 0) {
                    codedOutputByteBufferNano.writeInt32(8, i5);
                }
                int i6 = this.callState;
                if (i6 != 0) {
                    codedOutputByteBufferNano.writeInt32(9, i6);
                }
                int i7 = this.callIndex;
                if (i7 != 0) {
                    codedOutputByteBufferNano.writeInt32(10, i7);
                }
                int i8 = this.mergedCallIndex;
                if (i8 != 0) {
                    codedOutputByteBufferNano.writeInt32(11, i8);
                }
                RilCall[] rilCallArr = this.calls;
                if (rilCallArr != null && rilCallArr.length > 0) {
                    while (true) {
                        RilCall[] rilCallArr2 = this.calls;
                        if (i3 >= rilCallArr2.length) {
                            break;
                        }
                        RilCall rilCall = rilCallArr2[i3];
                        if (rilCall != null) {
                            codedOutputByteBufferNano.writeMessage(12, rilCall);
                        }
                        i3++;
                    }
                }
                int i9 = this.error;
                if (i9 != 0) {
                    codedOutputByteBufferNano.writeInt32(13, i9);
                }
                int i10 = this.rilRequest;
                if (i10 != 0) {
                    codedOutputByteBufferNano.writeInt32(14, i10);
                }
                int i11 = this.rilRequestId;
                if (i11 != 0) {
                    codedOutputByteBufferNano.writeInt32(15, i11);
                }
                int i12 = this.srvccState;
                if (i12 != 0) {
                    codedOutputByteBufferNano.writeInt32(16, i12);
                }
                int i13 = this.imsCommand;
                if (i13 != 0) {
                    codedOutputByteBufferNano.writeInt32(17, i13);
                }
                ImsReasonInfo imsReasonInfo = this.reasonInfo;
                if (imsReasonInfo != null) {
                    codedOutputByteBufferNano.writeMessage(18, imsReasonInfo);
                }
                int i14 = this.srcAccessTech;
                if (i14 != -1) {
                    codedOutputByteBufferNano.writeInt32(19, i14);
                }
                int i15 = this.targetAccessTech;
                if (i15 != -1) {
                    codedOutputByteBufferNano.writeInt32(20, i15);
                }
                long j = this.nitzTimestampMillis;
                if (j != 0) {
                    codedOutputByteBufferNano.writeInt64(21, j);
                }
                int i16 = this.audioCodec;
                if (i16 != 0) {
                    codedOutputByteBufferNano.writeInt32(22, i16);
                }
                CallQuality callQuality2 = this.callQuality;
                if (callQuality2 != null) {
                    codedOutputByteBufferNano.writeMessage(23, callQuality2);
                }
                CallQualitySummary callQualitySummary = this.callQualitySummaryDl;
                if (callQualitySummary != null) {
                    codedOutputByteBufferNano.writeMessage(24, callQualitySummary);
                }
                CallQualitySummary callQualitySummary2 = this.callQualitySummaryUl;
                if (callQualitySummary2 != null) {
                    codedOutputByteBufferNano.writeMessage(25, callQualitySummary2);
                }
                boolean z = this.isImsEmergencyCall;
                if (z) {
                    codedOutputByteBufferNano.writeBool(26, z);
                }
                EmergencyNumberInfo emergencyNumberInfo = this.imsEmergencyNumberInfo;
                if (emergencyNumberInfo != null) {
                    codedOutputByteBufferNano.writeMessage(27, emergencyNumberInfo);
                }
                int i17 = this.emergencyNumberDatabaseVersion;
                if (i17 != 0) {
                    codedOutputByteBufferNano.writeInt32(28, i17);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                int i = this.type;
                if (i != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                }
                int i2 = this.delay;
                if (i2 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
                }
                TelephonySettings telephonySettings = this.settings;
                if (telephonySettings != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(3, telephonySettings);
                }
                TelephonyServiceState telephonyServiceState = this.serviceState;
                if (telephonyServiceState != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(4, telephonyServiceState);
                }
                ImsConnectionState imsConnectionState2 = this.imsConnectionState;
                if (imsConnectionState2 != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(5, imsConnectionState2);
                }
                ImsCapabilities imsCapabilities2 = this.imsCapabilities;
                if (imsCapabilities2 != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(6, imsCapabilities2);
                }
                RilDataCall[] rilDataCallArr = this.dataCalls;
                int i3 = 0;
                if (rilDataCallArr != null && rilDataCallArr.length > 0) {
                    int i4 = 0;
                    while (true) {
                        RilDataCall[] rilDataCallArr2 = this.dataCalls;
                        if (i4 >= rilDataCallArr2.length) {
                            break;
                        }
                        RilDataCall rilDataCall = rilDataCallArr2[i4];
                        if (rilDataCall != null) {
                            computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(7, rilDataCall);
                        }
                        i4++;
                    }
                }
                int i5 = this.phoneState;
                if (i5 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(8, i5);
                }
                int i6 = this.callState;
                if (i6 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(9, i6);
                }
                int i7 = this.callIndex;
                if (i7 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(10, i7);
                }
                int i8 = this.mergedCallIndex;
                if (i8 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(11, i8);
                }
                RilCall[] rilCallArr = this.calls;
                if (rilCallArr != null && rilCallArr.length > 0) {
                    while (true) {
                        RilCall[] rilCallArr2 = this.calls;
                        if (i3 >= rilCallArr2.length) {
                            break;
                        }
                        RilCall rilCall = rilCallArr2[i3];
                        if (rilCall != null) {
                            computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(12, rilCall);
                        }
                        i3++;
                    }
                }
                int i9 = this.error;
                if (i9 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(13, i9);
                }
                int i10 = this.rilRequest;
                if (i10 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(14, i10);
                }
                int i11 = this.rilRequestId;
                if (i11 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(15, i11);
                }
                int i12 = this.srvccState;
                if (i12 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(16, i12);
                }
                int i13 = this.imsCommand;
                if (i13 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(17, i13);
                }
                ImsReasonInfo imsReasonInfo = this.reasonInfo;
                if (imsReasonInfo != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(18, imsReasonInfo);
                }
                int i14 = this.srcAccessTech;
                if (i14 != -1) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(19, i14);
                }
                int i15 = this.targetAccessTech;
                if (i15 != -1) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(20, i15);
                }
                long j = this.nitzTimestampMillis;
                if (j != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(21, j);
                }
                int i16 = this.audioCodec;
                if (i16 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(22, i16);
                }
                CallQuality callQuality2 = this.callQuality;
                if (callQuality2 != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(23, callQuality2);
                }
                CallQualitySummary callQualitySummary = this.callQualitySummaryDl;
                if (callQualitySummary != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(24, callQualitySummary);
                }
                CallQualitySummary callQualitySummary2 = this.callQualitySummaryUl;
                if (callQualitySummary2 != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(25, callQualitySummary2);
                }
                boolean z = this.isImsEmergencyCall;
                if (z) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(26, z);
                }
                EmergencyNumberInfo emergencyNumberInfo = this.imsEmergencyNumberInfo;
                if (emergencyNumberInfo != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(27, emergencyNumberInfo);
                }
                int i17 = this.emergencyNumberDatabaseVersion;
                return i17 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(28, i17) : computeSerializedSize;
            }

            public Event mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    switch (readTag) {
                        case 0:
                            return this;
                        case 8:
                            int readInt32 = codedInputByteBufferNano.readInt32();
                            switch (readInt32) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                case 11:
                                case 12:
                                case 13:
                                case 14:
                                case 15:
                                case 16:
                                case 17:
                                case 18:
                                case 19:
                                case 20:
                                case 21:
                                case 22:
                                case 23:
                                    this.type = readInt32;
                                    break;
                            }
                        case 16:
                            int readInt322 = codedInputByteBufferNano.readInt32();
                            switch (readInt322) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                case 11:
                                case 12:
                                case 13:
                                case 14:
                                case 15:
                                case 16:
                                case 17:
                                case 18:
                                case 19:
                                    this.delay = readInt322;
                                    break;
                            }
                        case 26:
                            if (this.settings == null) {
                                this.settings = new TelephonySettings();
                            }
                            codedInputByteBufferNano.readMessage(this.settings);
                            break;
                        case 34:
                            if (this.serviceState == null) {
                                this.serviceState = new TelephonyServiceState();
                            }
                            codedInputByteBufferNano.readMessage(this.serviceState);
                            break;
                        case 42:
                            if (this.imsConnectionState == null) {
                                this.imsConnectionState = new ImsConnectionState();
                            }
                            codedInputByteBufferNano.readMessage(this.imsConnectionState);
                            break;
                        case 50:
                            if (this.imsCapabilities == null) {
                                this.imsCapabilities = new ImsCapabilities();
                            }
                            codedInputByteBufferNano.readMessage(this.imsCapabilities);
                            break;
                        case 58:
                            int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 58);
                            RilDataCall[] rilDataCallArr = this.dataCalls;
                            int length = rilDataCallArr == null ? 0 : rilDataCallArr.length;
                            int i = repeatedFieldArrayLength + length;
                            RilDataCall[] rilDataCallArr2 = new RilDataCall[i];
                            if (length != 0) {
                                System.arraycopy(rilDataCallArr, 0, rilDataCallArr2, 0, length);
                            }
                            while (length < i - 1) {
                                RilDataCall rilDataCall = new RilDataCall();
                                rilDataCallArr2[length] = rilDataCall;
                                codedInputByteBufferNano.readMessage(rilDataCall);
                                codedInputByteBufferNano.readTag();
                                length++;
                            }
                            RilDataCall rilDataCall2 = new RilDataCall();
                            rilDataCallArr2[length] = rilDataCall2;
                            codedInputByteBufferNano.readMessage(rilDataCall2);
                            this.dataCalls = rilDataCallArr2;
                            break;
                        case 64:
                            int readInt323 = codedInputByteBufferNano.readInt32();
                            if (readInt323 != 0 && readInt323 != 1 && readInt323 != 2 && readInt323 != 3) {
                                break;
                            } else {
                                this.phoneState = readInt323;
                                break;
                            }
                        case 72:
                            int readInt324 = codedInputByteBufferNano.readInt32();
                            switch (readInt324) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                    this.callState = readInt324;
                                    break;
                            }
                        case 80:
                            this.callIndex = codedInputByteBufferNano.readInt32();
                            break;
                        case 88:
                            this.mergedCallIndex = codedInputByteBufferNano.readInt32();
                            break;
                        case 98:
                            int repeatedFieldArrayLength2 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 98);
                            RilCall[] rilCallArr = this.calls;
                            int length2 = rilCallArr == null ? 0 : rilCallArr.length;
                            int i2 = repeatedFieldArrayLength2 + length2;
                            RilCall[] rilCallArr2 = new RilCall[i2];
                            if (length2 != 0) {
                                System.arraycopy(rilCallArr, 0, rilCallArr2, 0, length2);
                            }
                            while (length2 < i2 - 1) {
                                RilCall rilCall = new RilCall();
                                rilCallArr2[length2] = rilCall;
                                codedInputByteBufferNano.readMessage(rilCall);
                                codedInputByteBufferNano.readTag();
                                length2++;
                            }
                            RilCall rilCall2 = new RilCall();
                            rilCallArr2[length2] = rilCall2;
                            codedInputByteBufferNano.readMessage(rilCall2);
                            this.calls = rilCallArr2;
                            break;
                        case 104:
                            int readInt325 = codedInputByteBufferNano.readInt32();
                            switch (readInt325) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                case 11:
                                case 12:
                                case 13:
                                case 14:
                                case 15:
                                case 16:
                                case 17:
                                case 18:
                                case 19:
                                case 20:
                                case 21:
                                case 22:
                                case 23:
                                case 24:
                                case 25:
                                case 26:
                                case 27:
                                case 28:
                                    this.error = readInt325;
                                    break;
                                default:
                                    switch (readInt325) {
                                        case 36:
                                        case 37:
                                        case 38:
                                        case 39:
                                        case 40:
                                        case 41:
                                        case 42:
                                        case 43:
                                        case 44:
                                        case 45:
                                        case 46:
                                        case 47:
                                        case 48:
                                        case 49:
                                        case 50:
                                        case 51:
                                        case 52:
                                        case 53:
                                        case 54:
                                        case 55:
                                        case 56:
                                        case 57:
                                        case 58:
                                        case 59:
                                        case 60:
                                        case 61:
                                        case 62:
                                        case 63:
                                        case 64:
                                        case 65:
                                        case 66:
                                        case 67:
                                            break;
                                    }
                                    this.error = readInt325;
                                    break;
                            }
                        case 112:
                            int readInt326 = codedInputByteBufferNano.readInt32();
                            switch (readInt326) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                    this.rilRequest = readInt326;
                                    break;
                            }
                        case 120:
                            this.rilRequestId = codedInputByteBufferNano.readInt32();
                            break;
                        case 128:
                            int readInt327 = codedInputByteBufferNano.readInt32();
                            if (readInt327 != 0 && readInt327 != 1 && readInt327 != 2 && readInt327 != 3 && readInt327 != 4) {
                                break;
                            } else {
                                this.srvccState = readInt327;
                                break;
                            }
                        case NetworkStackConstants.ICMPV6_NEIGHBOR_ADVERTISEMENT /*136*/:
                            int readInt328 = codedInputByteBufferNano.readInt32();
                            switch (readInt328) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                case 11:
                                    this.imsCommand = readInt328;
                                    break;
                            }
                        case 146:
                            if (this.reasonInfo == null) {
                                this.reasonInfo = new ImsReasonInfo();
                            }
                            codedInputByteBufferNano.readMessage(this.reasonInfo);
                            break;
                        case 152:
                            int readInt329 = codedInputByteBufferNano.readInt32();
                            switch (readInt329) {
                                case -1:
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                case 11:
                                case 12:
                                case 13:
                                case 14:
                                case 15:
                                case 16:
                                case 17:
                                case 18:
                                case 19:
                                case 20:
                                    this.srcAccessTech = readInt329;
                                    break;
                            }
                        case SmsMessage.MAX_USER_DATA_SEPTETS:
                            int readInt3210 = codedInputByteBufferNano.readInt32();
                            switch (readInt3210) {
                                case -1:
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                case 11:
                                case 12:
                                case 13:
                                case 14:
                                case 15:
                                case 16:
                                case 17:
                                case 18:
                                case 19:
                                case 20:
                                    this.targetAccessTech = readInt3210;
                                    break;
                            }
                        case 168:
                            this.nitzTimestampMillis = codedInputByteBufferNano.readInt64();
                            break;
                        case 176:
                            int readInt3211 = codedInputByteBufferNano.readInt32();
                            switch (readInt3211) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                case 11:
                                case 12:
                                case 13:
                                case 14:
                                case 15:
                                case 16:
                                case 17:
                                case 18:
                                case 19:
                                case 20:
                                    this.audioCodec = readInt3211;
                                    break;
                            }
                        case 186:
                            if (this.callQuality == null) {
                                this.callQuality = new CallQuality();
                            }
                            codedInputByteBufferNano.readMessage(this.callQuality);
                            break;
                        case 194:
                            if (this.callQualitySummaryDl == null) {
                                this.callQualitySummaryDl = new CallQualitySummary();
                            }
                            codedInputByteBufferNano.readMessage(this.callQualitySummaryDl);
                            break;
                        case 202:
                            if (this.callQualitySummaryUl == null) {
                                this.callQualitySummaryUl = new CallQualitySummary();
                            }
                            codedInputByteBufferNano.readMessage(this.callQualitySummaryUl);
                            break;
                        case BerTlv.BER_PROACTIVE_COMMAND_TAG:
                            this.isImsEmergencyCall = codedInputByteBufferNano.readBool();
                            break;
                        case 218:
                            if (this.imsEmergencyNumberInfo == null) {
                                this.imsEmergencyNumberInfo = new EmergencyNumberInfo();
                            }
                            codedInputByteBufferNano.readMessage(this.imsEmergencyNumberInfo);
                            break;
                        case 224:
                            this.emergencyNumberDatabaseVersion = codedInputByteBufferNano.readInt32();
                            break;
                        default:
                            if (storeUnknownField(codedInputByteBufferNano, readTag)) {
                                break;
                            } else {
                                return this;
                            }
                    }
                }
            }

            public static Event parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (Event) MessageNano.mergeFrom(new Event(), bArr);
            }

            public static Event parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new Event().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static TelephonyCallSession[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new TelephonyCallSession[0];
                    }
                }
            }
            return _emptyArray;
        }

        public TelephonyCallSession() {
            clear();
        }

        public TelephonyCallSession clear() {
            this.startTimeMinutes = 0;
            this.phoneId = 0;
            this.events = Event.emptyArray();
            this.eventsDropped = false;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.startTimeMinutes;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.phoneId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            Event[] eventArr = this.events;
            if (eventArr != null && eventArr.length > 0) {
                int i3 = 0;
                while (true) {
                    Event[] eventArr2 = this.events;
                    if (i3 >= eventArr2.length) {
                        break;
                    }
                    Event event = eventArr2[i3];
                    if (event != null) {
                        codedOutputByteBufferNano.writeMessage(3, event);
                    }
                    i3++;
                }
            }
            boolean z = this.eventsDropped;
            if (z) {
                codedOutputByteBufferNano.writeBool(4, z);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.startTimeMinutes;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            int i2 = this.phoneId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            Event[] eventArr = this.events;
            if (eventArr != null && eventArr.length > 0) {
                int i3 = 0;
                while (true) {
                    Event[] eventArr2 = this.events;
                    if (i3 >= eventArr2.length) {
                        break;
                    }
                    Event event = eventArr2[i3];
                    if (event != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(3, event);
                    }
                    i3++;
                }
            }
            boolean z = this.eventsDropped;
            return z ? computeSerializedSize + CodedOutputByteBufferNano.computeBoolSize(4, z) : computeSerializedSize;
        }

        public TelephonyCallSession mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.startTimeMinutes = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.phoneId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 26) {
                    int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 26);
                    Event[] eventArr = this.events;
                    int length = eventArr == null ? 0 : eventArr.length;
                    int i = repeatedFieldArrayLength + length;
                    Event[] eventArr2 = new Event[i];
                    if (length != 0) {
                        System.arraycopy(eventArr, 0, eventArr2, 0, length);
                    }
                    while (length < i - 1) {
                        Event event = new Event();
                        eventArr2[length] = event;
                        codedInputByteBufferNano.readMessage(event);
                        codedInputByteBufferNano.readTag();
                        length++;
                    }
                    Event event2 = new Event();
                    eventArr2[length] = event2;
                    codedInputByteBufferNano.readMessage(event2);
                    this.events = eventArr2;
                } else if (readTag == 32) {
                    this.eventsDropped = codedInputByteBufferNano.readBool();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static TelephonyCallSession parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (TelephonyCallSession) MessageNano.mergeFrom(new TelephonyCallSession(), bArr);
        }

        public static TelephonyCallSession parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new TelephonyCallSession().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class SmsSession extends ExtendableMessageNano<SmsSession> {
        private static volatile SmsSession[] _emptyArray;
        public Event[] events;
        public boolean eventsDropped;
        public int phoneId;
        public int startTimeMinutes;

        public static final class Event extends ExtendableMessageNano<Event> {
            private static volatile Event[] _emptyArray;
            public boolean blocked;
            public CBMessage cellBroadcastMessage;
            public RilDataCall[] dataCalls;
            public int delay;
            public int error;
            public int errorCode;
            public int format;
            public ImsCapabilities imsCapabilities;
            public ImsConnectionState imsConnectionState;
            public int imsError;
            public IncompleteSms incompleteSms;
            public long messageId;
            public int rilRequestId;
            public TelephonyServiceState serviceState;
            public TelephonySettings settings;
            public int smsType;
            public int tech;
            public int type;

            public interface CBMessageType {
                public static final int CMAS = 2;
                public static final int ETWS = 1;
                public static final int OTHER = 3;
                public static final int TYPE_UNKNOWN = 0;
            }

            public interface CBPriority {
                public static final int EMERGENCY = 4;
                public static final int INTERACTIVE = 2;
                public static final int NORMAL = 1;
                public static final int PRIORITY_UNKNOWN = 0;
                public static final int URGENT = 3;
            }

            public interface Format {
                public static final int SMS_FORMAT_3GPP = 1;
                public static final int SMS_FORMAT_3GPP2 = 2;
                public static final int SMS_FORMAT_UNKNOWN = 0;
            }

            public interface SmsType {
                public static final int SMS_TYPE_NORMAL = 0;
                public static final int SMS_TYPE_SMS_PP = 1;
                public static final int SMS_TYPE_VOICEMAIL_INDICATION = 2;
                public static final int SMS_TYPE_WAP_PUSH = 4;
                public static final int SMS_TYPE_ZERO = 3;
            }

            public interface Tech {
                public static final int SMS_CDMA = 2;
                public static final int SMS_GSM = 1;
                public static final int SMS_IMS = 3;
                public static final int SMS_UNKNOWN = 0;
            }

            public interface Type {
                public static final int CB_SMS_RECEIVED = 9;
                public static final int DATA_CALL_LIST_CHANGED = 5;
                public static final int EVENT_UNKNOWN = 0;
                public static final int IMS_CAPABILITIES_CHANGED = 4;
                public static final int IMS_CONNECTION_STATE_CHANGED = 3;
                public static final int INCOMPLETE_SMS_RECEIVED = 10;
                public static final int RIL_SERVICE_STATE_CHANGED = 2;
                public static final int SETTINGS_CHANGED = 1;
                public static final int SMS_RECEIVED = 8;
                public static final int SMS_SEND = 6;
                public static final int SMS_SEND_RESULT = 7;
            }

            public static final class CBMessage extends ExtendableMessageNano<CBMessage> {
                private static volatile CBMessage[] _emptyArray;
                public long deliveredTimestampMillis;
                public int msgFormat;
                public int msgPriority;
                public int msgType;
                public int serialNumber;
                public int serviceCategory;

                public static CBMessage[] emptyArray() {
                    if (_emptyArray == null) {
                        synchronized (InternalNano.LAZY_INIT_LOCK) {
                            if (_emptyArray == null) {
                                _emptyArray = new CBMessage[0];
                            }
                        }
                    }
                    return _emptyArray;
                }

                public CBMessage() {
                    clear();
                }

                public CBMessage clear() {
                    this.msgFormat = 0;
                    this.msgPriority = 0;
                    this.msgType = 0;
                    this.serviceCategory = 0;
                    this.serialNumber = 0;
                    this.deliveredTimestampMillis = 0;
                    this.unknownFieldData = null;
                    this.cachedSize = -1;
                    return this;
                }

                public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                    int i = this.msgFormat;
                    if (i != 0) {
                        codedOutputByteBufferNano.writeInt32(1, i);
                    }
                    int i2 = this.msgPriority;
                    if (i2 != 0) {
                        codedOutputByteBufferNano.writeInt32(2, i2);
                    }
                    int i3 = this.msgType;
                    if (i3 != 0) {
                        codedOutputByteBufferNano.writeInt32(3, i3);
                    }
                    int i4 = this.serviceCategory;
                    if (i4 != 0) {
                        codedOutputByteBufferNano.writeInt32(4, i4);
                    }
                    int i5 = this.serialNumber;
                    if (i5 != 0) {
                        codedOutputByteBufferNano.writeInt32(5, i5);
                    }
                    long j = this.deliveredTimestampMillis;
                    if (j != 0) {
                        codedOutputByteBufferNano.writeInt64(6, j);
                    }
                    super.writeTo(codedOutputByteBufferNano);
                }

                /* access modifiers changed from: protected */
                public int computeSerializedSize() {
                    int computeSerializedSize = super.computeSerializedSize();
                    int i = this.msgFormat;
                    if (i != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                    }
                    int i2 = this.msgPriority;
                    if (i2 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
                    }
                    int i3 = this.msgType;
                    if (i3 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
                    }
                    int i4 = this.serviceCategory;
                    if (i4 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
                    }
                    int i5 = this.serialNumber;
                    if (i5 != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i5);
                    }
                    long j = this.deliveredTimestampMillis;
                    return j != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(6, j) : computeSerializedSize;
                }

                public CBMessage mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                    while (true) {
                        int readTag = codedInputByteBufferNano.readTag();
                        if (readTag == 0) {
                            return this;
                        }
                        if (readTag == 8) {
                            int readInt32 = codedInputByteBufferNano.readInt32();
                            if (readInt32 == 0 || readInt32 == 1 || readInt32 == 2) {
                                this.msgFormat = readInt32;
                            }
                        } else if (readTag == 16) {
                            int readInt322 = codedInputByteBufferNano.readInt32();
                            if (readInt322 == 0 || readInt322 == 1 || readInt322 == 2 || readInt322 == 3 || readInt322 == 4) {
                                this.msgPriority = readInt322;
                            }
                        } else if (readTag == 24) {
                            int readInt323 = codedInputByteBufferNano.readInt32();
                            if (readInt323 == 0 || readInt323 == 1 || readInt323 == 2 || readInt323 == 3) {
                                this.msgType = readInt323;
                            }
                        } else if (readTag == 32) {
                            this.serviceCategory = codedInputByteBufferNano.readInt32();
                        } else if (readTag == 40) {
                            this.serialNumber = codedInputByteBufferNano.readInt32();
                        } else if (readTag == 48) {
                            this.deliveredTimestampMillis = codedInputByteBufferNano.readInt64();
                        } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                            return this;
                        }
                    }
                }

                public static CBMessage parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                    return (CBMessage) MessageNano.mergeFrom(new CBMessage(), bArr);
                }

                public static CBMessage parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                    return new CBMessage().mergeFrom(codedInputByteBufferNano);
                }
            }

            public static final class IncompleteSms extends ExtendableMessageNano<IncompleteSms> {
                private static volatile IncompleteSms[] _emptyArray;
                public int receivedParts;
                public int totalParts;

                public static IncompleteSms[] emptyArray() {
                    if (_emptyArray == null) {
                        synchronized (InternalNano.LAZY_INIT_LOCK) {
                            if (_emptyArray == null) {
                                _emptyArray = new IncompleteSms[0];
                            }
                        }
                    }
                    return _emptyArray;
                }

                public IncompleteSms() {
                    clear();
                }

                public IncompleteSms clear() {
                    this.receivedParts = 0;
                    this.totalParts = 0;
                    this.unknownFieldData = null;
                    this.cachedSize = -1;
                    return this;
                }

                public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                    int i = this.receivedParts;
                    if (i != 0) {
                        codedOutputByteBufferNano.writeInt32(1, i);
                    }
                    int i2 = this.totalParts;
                    if (i2 != 0) {
                        codedOutputByteBufferNano.writeInt32(2, i2);
                    }
                    super.writeTo(codedOutputByteBufferNano);
                }

                /* access modifiers changed from: protected */
                public int computeSerializedSize() {
                    int computeSerializedSize = super.computeSerializedSize();
                    int i = this.receivedParts;
                    if (i != 0) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                    }
                    int i2 = this.totalParts;
                    return i2 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(2, i2) : computeSerializedSize;
                }

                public IncompleteSms mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                    while (true) {
                        int readTag = codedInputByteBufferNano.readTag();
                        if (readTag == 0) {
                            return this;
                        }
                        if (readTag == 8) {
                            this.receivedParts = codedInputByteBufferNano.readInt32();
                        } else if (readTag == 16) {
                            this.totalParts = codedInputByteBufferNano.readInt32();
                        } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                            return this;
                        }
                    }
                }

                public static IncompleteSms parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                    return (IncompleteSms) MessageNano.mergeFrom(new IncompleteSms(), bArr);
                }

                public static IncompleteSms parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                    return new IncompleteSms().mergeFrom(codedInputByteBufferNano);
                }
            }

            public static Event[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new Event[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public Event() {
                clear();
            }

            public Event clear() {
                this.type = 0;
                this.delay = 0;
                this.settings = null;
                this.serviceState = null;
                this.imsConnectionState = null;
                this.imsCapabilities = null;
                this.dataCalls = RilDataCall.emptyArray();
                this.format = 0;
                this.tech = 0;
                this.errorCode = 0;
                this.error = 0;
                this.rilRequestId = 0;
                this.cellBroadcastMessage = null;
                this.imsError = 0;
                this.incompleteSms = null;
                this.smsType = 0;
                this.blocked = false;
                this.messageId = 0;
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                int i = this.type;
                if (i != 0) {
                    codedOutputByteBufferNano.writeInt32(1, i);
                }
                int i2 = this.delay;
                if (i2 != 0) {
                    codedOutputByteBufferNano.writeInt32(2, i2);
                }
                TelephonySettings telephonySettings = this.settings;
                if (telephonySettings != null) {
                    codedOutputByteBufferNano.writeMessage(3, telephonySettings);
                }
                TelephonyServiceState telephonyServiceState = this.serviceState;
                if (telephonyServiceState != null) {
                    codedOutputByteBufferNano.writeMessage(4, telephonyServiceState);
                }
                ImsConnectionState imsConnectionState2 = this.imsConnectionState;
                if (imsConnectionState2 != null) {
                    codedOutputByteBufferNano.writeMessage(5, imsConnectionState2);
                }
                ImsCapabilities imsCapabilities2 = this.imsCapabilities;
                if (imsCapabilities2 != null) {
                    codedOutputByteBufferNano.writeMessage(6, imsCapabilities2);
                }
                RilDataCall[] rilDataCallArr = this.dataCalls;
                if (rilDataCallArr != null && rilDataCallArr.length > 0) {
                    int i3 = 0;
                    while (true) {
                        RilDataCall[] rilDataCallArr2 = this.dataCalls;
                        if (i3 >= rilDataCallArr2.length) {
                            break;
                        }
                        RilDataCall rilDataCall = rilDataCallArr2[i3];
                        if (rilDataCall != null) {
                            codedOutputByteBufferNano.writeMessage(7, rilDataCall);
                        }
                        i3++;
                    }
                }
                int i4 = this.format;
                if (i4 != 0) {
                    codedOutputByteBufferNano.writeInt32(8, i4);
                }
                int i5 = this.tech;
                if (i5 != 0) {
                    codedOutputByteBufferNano.writeInt32(9, i5);
                }
                int i6 = this.errorCode;
                if (i6 != 0) {
                    codedOutputByteBufferNano.writeInt32(10, i6);
                }
                int i7 = this.error;
                if (i7 != 0) {
                    codedOutputByteBufferNano.writeInt32(11, i7);
                }
                int i8 = this.rilRequestId;
                if (i8 != 0) {
                    codedOutputByteBufferNano.writeInt32(12, i8);
                }
                CBMessage cBMessage = this.cellBroadcastMessage;
                if (cBMessage != null) {
                    codedOutputByteBufferNano.writeMessage(13, cBMessage);
                }
                int i9 = this.imsError;
                if (i9 != 0) {
                    codedOutputByteBufferNano.writeInt32(14, i9);
                }
                IncompleteSms incompleteSms2 = this.incompleteSms;
                if (incompleteSms2 != null) {
                    codedOutputByteBufferNano.writeMessage(15, incompleteSms2);
                }
                int i10 = this.smsType;
                if (i10 != 0) {
                    codedOutputByteBufferNano.writeInt32(16, i10);
                }
                boolean z = this.blocked;
                if (z) {
                    codedOutputByteBufferNano.writeBool(17, z);
                }
                long j = this.messageId;
                if (j != 0) {
                    codedOutputByteBufferNano.writeInt64(18, j);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                int i = this.type;
                if (i != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                }
                int i2 = this.delay;
                if (i2 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
                }
                TelephonySettings telephonySettings = this.settings;
                if (telephonySettings != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(3, telephonySettings);
                }
                TelephonyServiceState telephonyServiceState = this.serviceState;
                if (telephonyServiceState != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(4, telephonyServiceState);
                }
                ImsConnectionState imsConnectionState2 = this.imsConnectionState;
                if (imsConnectionState2 != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(5, imsConnectionState2);
                }
                ImsCapabilities imsCapabilities2 = this.imsCapabilities;
                if (imsCapabilities2 != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(6, imsCapabilities2);
                }
                RilDataCall[] rilDataCallArr = this.dataCalls;
                if (rilDataCallArr != null && rilDataCallArr.length > 0) {
                    int i3 = 0;
                    while (true) {
                        RilDataCall[] rilDataCallArr2 = this.dataCalls;
                        if (i3 >= rilDataCallArr2.length) {
                            break;
                        }
                        RilDataCall rilDataCall = rilDataCallArr2[i3];
                        if (rilDataCall != null) {
                            computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(7, rilDataCall);
                        }
                        i3++;
                    }
                }
                int i4 = this.format;
                if (i4 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(8, i4);
                }
                int i5 = this.tech;
                if (i5 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(9, i5);
                }
                int i6 = this.errorCode;
                if (i6 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(10, i6);
                }
                int i7 = this.error;
                if (i7 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(11, i7);
                }
                int i8 = this.rilRequestId;
                if (i8 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(12, i8);
                }
                CBMessage cBMessage = this.cellBroadcastMessage;
                if (cBMessage != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(13, cBMessage);
                }
                int i9 = this.imsError;
                if (i9 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(14, i9);
                }
                IncompleteSms incompleteSms2 = this.incompleteSms;
                if (incompleteSms2 != null) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(15, incompleteSms2);
                }
                int i10 = this.smsType;
                if (i10 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(16, i10);
                }
                boolean z = this.blocked;
                if (z) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(17, z);
                }
                long j = this.messageId;
                return j != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(18, j) : computeSerializedSize;
            }

            public Event mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    switch (readTag) {
                        case 0:
                            return this;
                        case 8:
                            int readInt32 = codedInputByteBufferNano.readInt32();
                            switch (readInt32) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                    this.type = readInt32;
                                    break;
                            }
                        case 16:
                            int readInt322 = codedInputByteBufferNano.readInt32();
                            switch (readInt322) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                case 11:
                                case 12:
                                case 13:
                                case 14:
                                case 15:
                                case 16:
                                case 17:
                                case 18:
                                case 19:
                                    this.delay = readInt322;
                                    break;
                            }
                        case 26:
                            if (this.settings == null) {
                                this.settings = new TelephonySettings();
                            }
                            codedInputByteBufferNano.readMessage(this.settings);
                            break;
                        case 34:
                            if (this.serviceState == null) {
                                this.serviceState = new TelephonyServiceState();
                            }
                            codedInputByteBufferNano.readMessage(this.serviceState);
                            break;
                        case 42:
                            if (this.imsConnectionState == null) {
                                this.imsConnectionState = new ImsConnectionState();
                            }
                            codedInputByteBufferNano.readMessage(this.imsConnectionState);
                            break;
                        case 50:
                            if (this.imsCapabilities == null) {
                                this.imsCapabilities = new ImsCapabilities();
                            }
                            codedInputByteBufferNano.readMessage(this.imsCapabilities);
                            break;
                        case 58:
                            int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 58);
                            RilDataCall[] rilDataCallArr = this.dataCalls;
                            int length = rilDataCallArr == null ? 0 : rilDataCallArr.length;
                            int i = repeatedFieldArrayLength + length;
                            RilDataCall[] rilDataCallArr2 = new RilDataCall[i];
                            if (length != 0) {
                                System.arraycopy(rilDataCallArr, 0, rilDataCallArr2, 0, length);
                            }
                            while (length < i - 1) {
                                RilDataCall rilDataCall = new RilDataCall();
                                rilDataCallArr2[length] = rilDataCall;
                                codedInputByteBufferNano.readMessage(rilDataCall);
                                codedInputByteBufferNano.readTag();
                                length++;
                            }
                            RilDataCall rilDataCall2 = new RilDataCall();
                            rilDataCallArr2[length] = rilDataCall2;
                            codedInputByteBufferNano.readMessage(rilDataCall2);
                            this.dataCalls = rilDataCallArr2;
                            break;
                        case 64:
                            int readInt323 = codedInputByteBufferNano.readInt32();
                            if (readInt323 != 0 && readInt323 != 1 && readInt323 != 2) {
                                break;
                            } else {
                                this.format = readInt323;
                                break;
                            }
                        case 72:
                            int readInt324 = codedInputByteBufferNano.readInt32();
                            if (readInt324 != 0 && readInt324 != 1 && readInt324 != 2 && readInt324 != 3) {
                                break;
                            } else {
                                this.tech = readInt324;
                                break;
                            }
                        case 80:
                            this.errorCode = codedInputByteBufferNano.readInt32();
                            break;
                        case 88:
                            int readInt325 = codedInputByteBufferNano.readInt32();
                            switch (readInt325) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                case 11:
                                case 12:
                                case 13:
                                case 14:
                                case 15:
                                case 16:
                                case 17:
                                case 18:
                                case 19:
                                case 20:
                                case 21:
                                case 22:
                                case 23:
                                case 24:
                                case 25:
                                case 26:
                                case 27:
                                case 28:
                                    this.error = readInt325;
                                    break;
                                default:
                                    switch (readInt325) {
                                        case 36:
                                        case 37:
                                        case 38:
                                        case 39:
                                        case 40:
                                        case 41:
                                        case 42:
                                        case 43:
                                        case 44:
                                        case 45:
                                        case 46:
                                        case 47:
                                        case 48:
                                        case 49:
                                        case 50:
                                        case 51:
                                        case 52:
                                        case 53:
                                        case 54:
                                        case 55:
                                        case 56:
                                        case 57:
                                        case 58:
                                        case 59:
                                        case 60:
                                        case 61:
                                        case 62:
                                        case 63:
                                        case 64:
                                        case 65:
                                        case 66:
                                        case 67:
                                            break;
                                    }
                                    this.error = readInt325;
                                    break;
                            }
                        case 96:
                            this.rilRequestId = codedInputByteBufferNano.readInt32();
                            break;
                        case 106:
                            if (this.cellBroadcastMessage == null) {
                                this.cellBroadcastMessage = new CBMessage();
                            }
                            codedInputByteBufferNano.readMessage(this.cellBroadcastMessage);
                            break;
                        case 112:
                            int readInt326 = codedInputByteBufferNano.readInt32();
                            if (readInt326 != 0 && readInt326 != 1 && readInt326 != 2 && readInt326 != 3 && readInt326 != 4) {
                                break;
                            } else {
                                this.imsError = readInt326;
                                break;
                            }
                        case 122:
                            if (this.incompleteSms == null) {
                                this.incompleteSms = new IncompleteSms();
                            }
                            codedInputByteBufferNano.readMessage(this.incompleteSms);
                            break;
                        case 128:
                            int readInt327 = codedInputByteBufferNano.readInt32();
                            if (readInt327 != 0 && readInt327 != 1 && readInt327 != 2 && readInt327 != 3 && readInt327 != 4) {
                                break;
                            } else {
                                this.smsType = readInt327;
                                break;
                            }
                        case NetworkStackConstants.ICMPV6_NEIGHBOR_ADVERTISEMENT /*136*/:
                            this.blocked = codedInputByteBufferNano.readBool();
                            break;
                        case 144:
                            this.messageId = codedInputByteBufferNano.readInt64();
                            break;
                        default:
                            if (storeUnknownField(codedInputByteBufferNano, readTag)) {
                                break;
                            } else {
                                return this;
                            }
                    }
                }
            }

            public static Event parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (Event) MessageNano.mergeFrom(new Event(), bArr);
            }

            public static Event parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new Event().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static SmsSession[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new SmsSession[0];
                    }
                }
            }
            return _emptyArray;
        }

        public SmsSession() {
            clear();
        }

        public SmsSession clear() {
            this.startTimeMinutes = 0;
            this.phoneId = 0;
            this.events = Event.emptyArray();
            this.eventsDropped = false;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.startTimeMinutes;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.phoneId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            Event[] eventArr = this.events;
            if (eventArr != null && eventArr.length > 0) {
                int i3 = 0;
                while (true) {
                    Event[] eventArr2 = this.events;
                    if (i3 >= eventArr2.length) {
                        break;
                    }
                    Event event = eventArr2[i3];
                    if (event != null) {
                        codedOutputByteBufferNano.writeMessage(3, event);
                    }
                    i3++;
                }
            }
            boolean z = this.eventsDropped;
            if (z) {
                codedOutputByteBufferNano.writeBool(4, z);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.startTimeMinutes;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            int i2 = this.phoneId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            Event[] eventArr = this.events;
            if (eventArr != null && eventArr.length > 0) {
                int i3 = 0;
                while (true) {
                    Event[] eventArr2 = this.events;
                    if (i3 >= eventArr2.length) {
                        break;
                    }
                    Event event = eventArr2[i3];
                    if (event != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(3, event);
                    }
                    i3++;
                }
            }
            boolean z = this.eventsDropped;
            return z ? computeSerializedSize + CodedOutputByteBufferNano.computeBoolSize(4, z) : computeSerializedSize;
        }

        public SmsSession mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.startTimeMinutes = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.phoneId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 26) {
                    int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 26);
                    Event[] eventArr = this.events;
                    int length = eventArr == null ? 0 : eventArr.length;
                    int i = repeatedFieldArrayLength + length;
                    Event[] eventArr2 = new Event[i];
                    if (length != 0) {
                        System.arraycopy(eventArr, 0, eventArr2, 0, length);
                    }
                    while (length < i - 1) {
                        Event event = new Event();
                        eventArr2[length] = event;
                        codedInputByteBufferNano.readMessage(event);
                        codedInputByteBufferNano.readTag();
                        length++;
                    }
                    Event event2 = new Event();
                    eventArr2[length] = event2;
                    codedInputByteBufferNano.readMessage(event2);
                    this.events = eventArr2;
                } else if (readTag == 32) {
                    this.eventsDropped = codedInputByteBufferNano.readBool();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static SmsSession parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (SmsSession) MessageNano.mergeFrom(new SmsSession(), bArr);
        }

        public static SmsSession parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new SmsSession().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class ModemPowerStats extends ExtendableMessageNano<ModemPowerStats> {
        private static volatile ModemPowerStats[] _emptyArray;
        public long cellularKernelActiveTimeMs;
        public double energyConsumedMah;
        public long idleTimeMs;
        public long loggingDurationMs;
        public double monitoredRailEnergyConsumedMah;
        public long numBytesRx;
        public long numBytesTx;
        public long numPacketsRx;
        public long numPacketsTx;
        public long rxTimeMs;
        public long sleepTimeMs;
        public long[] timeInRatMs;
        public long[] timeInRxSignalStrengthLevelMs;
        public long timeInVeryPoorRxSignalLevelMs;
        public long[] txTimeMs;

        public static ModemPowerStats[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new ModemPowerStats[0];
                    }
                }
            }
            return _emptyArray;
        }

        public ModemPowerStats() {
            clear();
        }

        public ModemPowerStats clear() {
            this.loggingDurationMs = 0;
            this.energyConsumedMah = 0.0d;
            this.numPacketsTx = 0;
            this.cellularKernelActiveTimeMs = 0;
            this.timeInVeryPoorRxSignalLevelMs = 0;
            this.sleepTimeMs = 0;
            this.idleTimeMs = 0;
            this.rxTimeMs = 0;
            long[] jArr = WireFormatNano.EMPTY_LONG_ARRAY;
            this.txTimeMs = jArr;
            this.numBytesTx = 0;
            this.numPacketsRx = 0;
            this.numBytesRx = 0;
            this.timeInRatMs = jArr;
            this.timeInRxSignalStrengthLevelMs = jArr;
            this.monitoredRailEnergyConsumedMah = 0.0d;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            long j = this.loggingDurationMs;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(1, j);
            }
            if (Double.doubleToLongBits(this.energyConsumedMah) != Double.doubleToLongBits(0.0d)) {
                codedOutputByteBufferNano.writeDouble(2, this.energyConsumedMah);
            }
            long j2 = this.numPacketsTx;
            if (j2 != 0) {
                codedOutputByteBufferNano.writeInt64(3, j2);
            }
            long j3 = this.cellularKernelActiveTimeMs;
            if (j3 != 0) {
                codedOutputByteBufferNano.writeInt64(4, j3);
            }
            long j4 = this.timeInVeryPoorRxSignalLevelMs;
            if (j4 != 0) {
                codedOutputByteBufferNano.writeInt64(5, j4);
            }
            long j5 = this.sleepTimeMs;
            if (j5 != 0) {
                codedOutputByteBufferNano.writeInt64(6, j5);
            }
            long j6 = this.idleTimeMs;
            if (j6 != 0) {
                codedOutputByteBufferNano.writeInt64(7, j6);
            }
            long j7 = this.rxTimeMs;
            if (j7 != 0) {
                codedOutputByteBufferNano.writeInt64(8, j7);
            }
            long[] jArr = this.txTimeMs;
            int i = 0;
            if (jArr != null && jArr.length > 0) {
                int i2 = 0;
                while (true) {
                    long[] jArr2 = this.txTimeMs;
                    if (i2 >= jArr2.length) {
                        break;
                    }
                    codedOutputByteBufferNano.writeInt64(9, jArr2[i2]);
                    i2++;
                }
            }
            long j8 = this.numBytesTx;
            if (j8 != 0) {
                codedOutputByteBufferNano.writeInt64(10, j8);
            }
            long j9 = this.numPacketsRx;
            if (j9 != 0) {
                codedOutputByteBufferNano.writeInt64(11, j9);
            }
            long j10 = this.numBytesRx;
            if (j10 != 0) {
                codedOutputByteBufferNano.writeInt64(12, j10);
            }
            long[] jArr3 = this.timeInRatMs;
            if (jArr3 != null && jArr3.length > 0) {
                int i3 = 0;
                while (true) {
                    long[] jArr4 = this.timeInRatMs;
                    if (i3 >= jArr4.length) {
                        break;
                    }
                    codedOutputByteBufferNano.writeInt64(13, jArr4[i3]);
                    i3++;
                }
            }
            long[] jArr5 = this.timeInRxSignalStrengthLevelMs;
            if (jArr5 != null && jArr5.length > 0) {
                while (true) {
                    long[] jArr6 = this.timeInRxSignalStrengthLevelMs;
                    if (i >= jArr6.length) {
                        break;
                    }
                    codedOutputByteBufferNano.writeInt64(14, jArr6[i]);
                    i++;
                }
            }
            if (Double.doubleToLongBits(this.monitoredRailEnergyConsumedMah) != Double.doubleToLongBits(0.0d)) {
                codedOutputByteBufferNano.writeDouble(15, this.monitoredRailEnergyConsumedMah);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            long[] jArr;
            long[] jArr2;
            long[] jArr3;
            int computeSerializedSize = super.computeSerializedSize();
            long j = this.loggingDurationMs;
            if (j != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(1, j);
            }
            if (Double.doubleToLongBits(this.energyConsumedMah) != Double.doubleToLongBits(0.0d)) {
                computeSerializedSize += CodedOutputByteBufferNano.computeDoubleSize(2, this.energyConsumedMah);
            }
            long j2 = this.numPacketsTx;
            if (j2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(3, j2);
            }
            long j3 = this.cellularKernelActiveTimeMs;
            if (j3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(4, j3);
            }
            long j4 = this.timeInVeryPoorRxSignalLevelMs;
            if (j4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(5, j4);
            }
            long j5 = this.sleepTimeMs;
            if (j5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(6, j5);
            }
            long j6 = this.idleTimeMs;
            if (j6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(7, j6);
            }
            long j7 = this.rxTimeMs;
            if (j7 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(8, j7);
            }
            long[] jArr4 = this.txTimeMs;
            int i = 0;
            if (jArr4 != null && jArr4.length > 0) {
                int i2 = 0;
                int i3 = 0;
                while (true) {
                    jArr3 = this.txTimeMs;
                    if (i2 >= jArr3.length) {
                        break;
                    }
                    i3 += CodedOutputByteBufferNano.computeInt64SizeNoTag(jArr3[i2]);
                    i2++;
                }
                computeSerializedSize = computeSerializedSize + i3 + (jArr3.length * 1);
            }
            long j8 = this.numBytesTx;
            if (j8 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(10, j8);
            }
            long j9 = this.numPacketsRx;
            if (j9 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(11, j9);
            }
            long j10 = this.numBytesRx;
            if (j10 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(12, j10);
            }
            long[] jArr5 = this.timeInRatMs;
            if (jArr5 != null && jArr5.length > 0) {
                int i4 = 0;
                int i5 = 0;
                while (true) {
                    jArr2 = this.timeInRatMs;
                    if (i4 >= jArr2.length) {
                        break;
                    }
                    i5 += CodedOutputByteBufferNano.computeInt64SizeNoTag(jArr2[i4]);
                    i4++;
                }
                computeSerializedSize = computeSerializedSize + i5 + (jArr2.length * 1);
            }
            long[] jArr6 = this.timeInRxSignalStrengthLevelMs;
            if (jArr6 != null && jArr6.length > 0) {
                int i6 = 0;
                while (true) {
                    jArr = this.timeInRxSignalStrengthLevelMs;
                    if (i >= jArr.length) {
                        break;
                    }
                    i6 += CodedOutputByteBufferNano.computeInt64SizeNoTag(jArr[i]);
                    i++;
                }
                computeSerializedSize = computeSerializedSize + i6 + (jArr.length * 1);
            }
            return Double.doubleToLongBits(this.monitoredRailEnergyConsumedMah) != Double.doubleToLongBits(0.0d) ? computeSerializedSize + CodedOutputByteBufferNano.computeDoubleSize(15, this.monitoredRailEnergyConsumedMah) : computeSerializedSize;
        }

        public ModemPowerStats mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                switch (readTag) {
                    case 0:
                        return this;
                    case 8:
                        this.loggingDurationMs = codedInputByteBufferNano.readInt64();
                        break;
                    case 17:
                        this.energyConsumedMah = codedInputByteBufferNano.readDouble();
                        break;
                    case 24:
                        this.numPacketsTx = codedInputByteBufferNano.readInt64();
                        break;
                    case 32:
                        this.cellularKernelActiveTimeMs = codedInputByteBufferNano.readInt64();
                        break;
                    case 40:
                        this.timeInVeryPoorRxSignalLevelMs = codedInputByteBufferNano.readInt64();
                        break;
                    case 48:
                        this.sleepTimeMs = codedInputByteBufferNano.readInt64();
                        break;
                    case 56:
                        this.idleTimeMs = codedInputByteBufferNano.readInt64();
                        break;
                    case 64:
                        this.rxTimeMs = codedInputByteBufferNano.readInt64();
                        break;
                    case 72:
                        int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 72);
                        long[] jArr = this.txTimeMs;
                        int length = jArr == null ? 0 : jArr.length;
                        int i = repeatedFieldArrayLength + length;
                        long[] jArr2 = new long[i];
                        if (length != 0) {
                            System.arraycopy(jArr, 0, jArr2, 0, length);
                        }
                        while (length < i - 1) {
                            jArr2[length] = codedInputByteBufferNano.readInt64();
                            codedInputByteBufferNano.readTag();
                            length++;
                        }
                        jArr2[length] = codedInputByteBufferNano.readInt64();
                        this.txTimeMs = jArr2;
                        break;
                    case 74:
                        int pushLimit = codedInputByteBufferNano.pushLimit(codedInputByteBufferNano.readRawVarint32());
                        int position = codedInputByteBufferNano.getPosition();
                        int i2 = 0;
                        while (codedInputByteBufferNano.getBytesUntilLimit() > 0) {
                            codedInputByteBufferNano.readInt64();
                            i2++;
                        }
                        codedInputByteBufferNano.rewindToPosition(position);
                        long[] jArr3 = this.txTimeMs;
                        int length2 = jArr3 == null ? 0 : jArr3.length;
                        int i3 = i2 + length2;
                        long[] jArr4 = new long[i3];
                        if (length2 != 0) {
                            System.arraycopy(jArr3, 0, jArr4, 0, length2);
                        }
                        while (length2 < i3) {
                            jArr4[length2] = codedInputByteBufferNano.readInt64();
                            length2++;
                        }
                        this.txTimeMs = jArr4;
                        codedInputByteBufferNano.popLimit(pushLimit);
                        break;
                    case 80:
                        this.numBytesTx = codedInputByteBufferNano.readInt64();
                        break;
                    case 88:
                        this.numPacketsRx = codedInputByteBufferNano.readInt64();
                        break;
                    case 96:
                        this.numBytesRx = codedInputByteBufferNano.readInt64();
                        break;
                    case 104:
                        int repeatedFieldArrayLength2 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 104);
                        long[] jArr5 = this.timeInRatMs;
                        int length3 = jArr5 == null ? 0 : jArr5.length;
                        int i4 = repeatedFieldArrayLength2 + length3;
                        long[] jArr6 = new long[i4];
                        if (length3 != 0) {
                            System.arraycopy(jArr5, 0, jArr6, 0, length3);
                        }
                        while (length3 < i4 - 1) {
                            jArr6[length3] = codedInputByteBufferNano.readInt64();
                            codedInputByteBufferNano.readTag();
                            length3++;
                        }
                        jArr6[length3] = codedInputByteBufferNano.readInt64();
                        this.timeInRatMs = jArr6;
                        break;
                    case 106:
                        int pushLimit2 = codedInputByteBufferNano.pushLimit(codedInputByteBufferNano.readRawVarint32());
                        int position2 = codedInputByteBufferNano.getPosition();
                        int i5 = 0;
                        while (codedInputByteBufferNano.getBytesUntilLimit() > 0) {
                            codedInputByteBufferNano.readInt64();
                            i5++;
                        }
                        codedInputByteBufferNano.rewindToPosition(position2);
                        long[] jArr7 = this.timeInRatMs;
                        int length4 = jArr7 == null ? 0 : jArr7.length;
                        int i6 = i5 + length4;
                        long[] jArr8 = new long[i6];
                        if (length4 != 0) {
                            System.arraycopy(jArr7, 0, jArr8, 0, length4);
                        }
                        while (length4 < i6) {
                            jArr8[length4] = codedInputByteBufferNano.readInt64();
                            length4++;
                        }
                        this.timeInRatMs = jArr8;
                        codedInputByteBufferNano.popLimit(pushLimit2);
                        break;
                    case 112:
                        int repeatedFieldArrayLength3 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 112);
                        long[] jArr9 = this.timeInRxSignalStrengthLevelMs;
                        int length5 = jArr9 == null ? 0 : jArr9.length;
                        int i7 = repeatedFieldArrayLength3 + length5;
                        long[] jArr10 = new long[i7];
                        if (length5 != 0) {
                            System.arraycopy(jArr9, 0, jArr10, 0, length5);
                        }
                        while (length5 < i7 - 1) {
                            jArr10[length5] = codedInputByteBufferNano.readInt64();
                            codedInputByteBufferNano.readTag();
                            length5++;
                        }
                        jArr10[length5] = codedInputByteBufferNano.readInt64();
                        this.timeInRxSignalStrengthLevelMs = jArr10;
                        break;
                    case 114:
                        int pushLimit3 = codedInputByteBufferNano.pushLimit(codedInputByteBufferNano.readRawVarint32());
                        int position3 = codedInputByteBufferNano.getPosition();
                        int i8 = 0;
                        while (codedInputByteBufferNano.getBytesUntilLimit() > 0) {
                            codedInputByteBufferNano.readInt64();
                            i8++;
                        }
                        codedInputByteBufferNano.rewindToPosition(position3);
                        long[] jArr11 = this.timeInRxSignalStrengthLevelMs;
                        int length6 = jArr11 == null ? 0 : jArr11.length;
                        int i9 = i8 + length6;
                        long[] jArr12 = new long[i9];
                        if (length6 != 0) {
                            System.arraycopy(jArr11, 0, jArr12, 0, length6);
                        }
                        while (length6 < i9) {
                            jArr12[length6] = codedInputByteBufferNano.readInt64();
                            length6++;
                        }
                        this.timeInRxSignalStrengthLevelMs = jArr12;
                        codedInputByteBufferNano.popLimit(pushLimit3);
                        break;
                    case 121:
                        this.monitoredRailEnergyConsumedMah = codedInputByteBufferNano.readDouble();
                        break;
                    default:
                        if (storeUnknownField(codedInputByteBufferNano, readTag)) {
                            break;
                        } else {
                            return this;
                        }
                }
            }
        }

        public static ModemPowerStats parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (ModemPowerStats) MessageNano.mergeFrom(new ModemPowerStats(), bArr);
        }

        public static ModemPowerStats parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new ModemPowerStats().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class BandwidthEstimatorStats extends ExtendableMessageNano<BandwidthEstimatorStats> {
        private static volatile BandwidthEstimatorStats[] _emptyArray;
        public PerRat[] perRatRx;
        public PerRat[] perRatTx;

        public static final class PerLevel extends ExtendableMessageNano<PerLevel> {
            private static volatile PerLevel[] _emptyArray;
            public int avgBwKbps;
            public int bwEstErrorPercent;
            public int count;
            public int signalLevel;
            public int staticBwErrorPercent;

            public static PerLevel[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new PerLevel[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public PerLevel() {
                clear();
            }

            public PerLevel clear() {
                this.signalLevel = 0;
                this.count = 0;
                this.avgBwKbps = 0;
                this.staticBwErrorPercent = 0;
                this.bwEstErrorPercent = 0;
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                int i = this.signalLevel;
                if (i != 0) {
                    codedOutputByteBufferNano.writeUInt32(1, i);
                }
                int i2 = this.count;
                if (i2 != 0) {
                    codedOutputByteBufferNano.writeUInt32(2, i2);
                }
                int i3 = this.avgBwKbps;
                if (i3 != 0) {
                    codedOutputByteBufferNano.writeUInt32(3, i3);
                }
                int i4 = this.staticBwErrorPercent;
                if (i4 != 0) {
                    codedOutputByteBufferNano.writeUInt32(4, i4);
                }
                int i5 = this.bwEstErrorPercent;
                if (i5 != 0) {
                    codedOutputByteBufferNano.writeUInt32(5, i5);
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                int i = this.signalLevel;
                if (i != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeUInt32Size(1, i);
                }
                int i2 = this.count;
                if (i2 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeUInt32Size(2, i2);
                }
                int i3 = this.avgBwKbps;
                if (i3 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeUInt32Size(3, i3);
                }
                int i4 = this.staticBwErrorPercent;
                if (i4 != 0) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeUInt32Size(4, i4);
                }
                int i5 = this.bwEstErrorPercent;
                return i5 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeUInt32Size(5, i5) : computeSerializedSize;
            }

            public PerLevel mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    if (readTag == 0) {
                        return this;
                    }
                    if (readTag == 8) {
                        this.signalLevel = codedInputByteBufferNano.readUInt32();
                    } else if (readTag == 16) {
                        this.count = codedInputByteBufferNano.readUInt32();
                    } else if (readTag == 24) {
                        this.avgBwKbps = codedInputByteBufferNano.readUInt32();
                    } else if (readTag == 32) {
                        this.staticBwErrorPercent = codedInputByteBufferNano.readUInt32();
                    } else if (readTag == 40) {
                        this.bwEstErrorPercent = codedInputByteBufferNano.readUInt32();
                    } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                        return this;
                    }
                }
            }

            public static PerLevel parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (PerLevel) MessageNano.mergeFrom(new PerLevel(), bArr);
            }

            public static PerLevel parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new PerLevel().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static final class PerRat extends ExtendableMessageNano<PerRat> {
            private static volatile PerRat[] _emptyArray;
            public int nrMode;
            public PerLevel[] perLevel;
            public int rat;

            public static PerRat[] emptyArray() {
                if (_emptyArray == null) {
                    synchronized (InternalNano.LAZY_INIT_LOCK) {
                        if (_emptyArray == null) {
                            _emptyArray = new PerRat[0];
                        }
                    }
                }
                return _emptyArray;
            }

            public PerRat() {
                clear();
            }

            public PerRat clear() {
                this.rat = -1;
                this.nrMode = 1;
                this.perLevel = PerLevel.emptyArray();
                this.unknownFieldData = null;
                this.cachedSize = -1;
                return this;
            }

            public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
                int i = this.rat;
                if (i != -1) {
                    codedOutputByteBufferNano.writeInt32(1, i);
                }
                int i2 = this.nrMode;
                if (i2 != 1) {
                    codedOutputByteBufferNano.writeInt32(2, i2);
                }
                PerLevel[] perLevelArr = this.perLevel;
                if (perLevelArr != null && perLevelArr.length > 0) {
                    int i3 = 0;
                    while (true) {
                        PerLevel[] perLevelArr2 = this.perLevel;
                        if (i3 >= perLevelArr2.length) {
                            break;
                        }
                        PerLevel perLevel2 = perLevelArr2[i3];
                        if (perLevel2 != null) {
                            codedOutputByteBufferNano.writeMessage(3, perLevel2);
                        }
                        i3++;
                    }
                }
                super.writeTo(codedOutputByteBufferNano);
            }

            /* access modifiers changed from: protected */
            public int computeSerializedSize() {
                int computeSerializedSize = super.computeSerializedSize();
                int i = this.rat;
                if (i != -1) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
                }
                int i2 = this.nrMode;
                if (i2 != 1) {
                    computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
                }
                PerLevel[] perLevelArr = this.perLevel;
                if (perLevelArr != null && perLevelArr.length > 0) {
                    int i3 = 0;
                    while (true) {
                        PerLevel[] perLevelArr2 = this.perLevel;
                        if (i3 >= perLevelArr2.length) {
                            break;
                        }
                        PerLevel perLevel2 = perLevelArr2[i3];
                        if (perLevel2 != null) {
                            computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(3, perLevel2);
                        }
                        i3++;
                    }
                }
                return computeSerializedSize;
            }

            public PerRat mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                while (true) {
                    int readTag = codedInputByteBufferNano.readTag();
                    if (readTag != 0) {
                        if (readTag == 8) {
                            int readInt32 = codedInputByteBufferNano.readInt32();
                            switch (readInt32) {
                                case -1:
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                case 9:
                                case 10:
                                case 11:
                                case 12:
                                case 13:
                                case 14:
                                case 15:
                                case 16:
                                case 17:
                                case 18:
                                case 19:
                                case 20:
                                    this.rat = readInt32;
                                    break;
                            }
                        } else if (readTag == 16) {
                            int readInt322 = codedInputByteBufferNano.readInt32();
                            if (readInt322 == 1 || readInt322 == 2 || readInt322 == 3 || readInt322 == 4 || readInt322 == 5) {
                                this.nrMode = readInt322;
                            }
                        } else if (readTag == 26) {
                            int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 26);
                            PerLevel[] perLevelArr = this.perLevel;
                            int length = perLevelArr == null ? 0 : perLevelArr.length;
                            int i = repeatedFieldArrayLength + length;
                            PerLevel[] perLevelArr2 = new PerLevel[i];
                            if (length != 0) {
                                System.arraycopy(perLevelArr, 0, perLevelArr2, 0, length);
                            }
                            while (length < i - 1) {
                                PerLevel perLevel2 = new PerLevel();
                                perLevelArr2[length] = perLevel2;
                                codedInputByteBufferNano.readMessage(perLevel2);
                                codedInputByteBufferNano.readTag();
                                length++;
                            }
                            PerLevel perLevel3 = new PerLevel();
                            perLevelArr2[length] = perLevel3;
                            codedInputByteBufferNano.readMessage(perLevel3);
                            this.perLevel = perLevelArr2;
                        } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                            return this;
                        }
                    } else {
                        return this;
                    }
                }
            }

            public static PerRat parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
                return (PerRat) MessageNano.mergeFrom(new PerRat(), bArr);
            }

            public static PerRat parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
                return new PerRat().mergeFrom(codedInputByteBufferNano);
            }
        }

        public static BandwidthEstimatorStats[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new BandwidthEstimatorStats[0];
                    }
                }
            }
            return _emptyArray;
        }

        public BandwidthEstimatorStats() {
            clear();
        }

        public BandwidthEstimatorStats clear() {
            this.perRatTx = PerRat.emptyArray();
            this.perRatRx = PerRat.emptyArray();
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            PerRat[] perRatArr = this.perRatTx;
            int i = 0;
            if (perRatArr != null && perRatArr.length > 0) {
                int i2 = 0;
                while (true) {
                    PerRat[] perRatArr2 = this.perRatTx;
                    if (i2 >= perRatArr2.length) {
                        break;
                    }
                    PerRat perRat = perRatArr2[i2];
                    if (perRat != null) {
                        codedOutputByteBufferNano.writeMessage(1, perRat);
                    }
                    i2++;
                }
            }
            PerRat[] perRatArr3 = this.perRatRx;
            if (perRatArr3 != null && perRatArr3.length > 0) {
                while (true) {
                    PerRat[] perRatArr4 = this.perRatRx;
                    if (i >= perRatArr4.length) {
                        break;
                    }
                    PerRat perRat2 = perRatArr4[i];
                    if (perRat2 != null) {
                        codedOutputByteBufferNano.writeMessage(2, perRat2);
                    }
                    i++;
                }
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            PerRat[] perRatArr = this.perRatTx;
            int i = 0;
            if (perRatArr != null && perRatArr.length > 0) {
                int i2 = 0;
                while (true) {
                    PerRat[] perRatArr2 = this.perRatTx;
                    if (i2 >= perRatArr2.length) {
                        break;
                    }
                    PerRat perRat = perRatArr2[i2];
                    if (perRat != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(1, perRat);
                    }
                    i2++;
                }
            }
            PerRat[] perRatArr3 = this.perRatRx;
            if (perRatArr3 != null && perRatArr3.length > 0) {
                while (true) {
                    PerRat[] perRatArr4 = this.perRatRx;
                    if (i >= perRatArr4.length) {
                        break;
                    }
                    PerRat perRat2 = perRatArr4[i];
                    if (perRat2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(2, perRat2);
                    }
                    i++;
                }
            }
            return computeSerializedSize;
        }

        public BandwidthEstimatorStats mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 10) {
                    int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 10);
                    PerRat[] perRatArr = this.perRatTx;
                    int length = perRatArr == null ? 0 : perRatArr.length;
                    int i = repeatedFieldArrayLength + length;
                    PerRat[] perRatArr2 = new PerRat[i];
                    if (length != 0) {
                        System.arraycopy(perRatArr, 0, perRatArr2, 0, length);
                    }
                    while (length < i - 1) {
                        PerRat perRat = new PerRat();
                        perRatArr2[length] = perRat;
                        codedInputByteBufferNano.readMessage(perRat);
                        codedInputByteBufferNano.readTag();
                        length++;
                    }
                    PerRat perRat2 = new PerRat();
                    perRatArr2[length] = perRat2;
                    codedInputByteBufferNano.readMessage(perRat2);
                    this.perRatTx = perRatArr2;
                } else if (readTag == 18) {
                    int repeatedFieldArrayLength2 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 18);
                    PerRat[] perRatArr3 = this.perRatRx;
                    int length2 = perRatArr3 == null ? 0 : perRatArr3.length;
                    int i2 = repeatedFieldArrayLength2 + length2;
                    PerRat[] perRatArr4 = new PerRat[i2];
                    if (length2 != 0) {
                        System.arraycopy(perRatArr3, 0, perRatArr4, 0, length2);
                    }
                    while (length2 < i2 - 1) {
                        PerRat perRat3 = new PerRat();
                        perRatArr4[length2] = perRat3;
                        codedInputByteBufferNano.readMessage(perRat3);
                        codedInputByteBufferNano.readTag();
                        length2++;
                    }
                    PerRat perRat4 = new PerRat();
                    perRatArr4[length2] = perRat4;
                    codedInputByteBufferNano.readMessage(perRat4);
                    this.perRatRx = perRatArr4;
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static BandwidthEstimatorStats parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (BandwidthEstimatorStats) MessageNano.mergeFrom(new BandwidthEstimatorStats(), bArr);
        }

        public static BandwidthEstimatorStats parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new BandwidthEstimatorStats().mergeFrom(codedInputByteBufferNano);
        }
    }
}
