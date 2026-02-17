package com.android.internal.telephony.nano;

import android.telephony.gsm.SmsMessage;
import com.android.internal.telephony.CallFailCause;
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
import java.io.IOException;

public interface PersistAtomsProto {

    public static final class PersistAtoms extends ExtendableMessageNano<PersistAtoms> {
        private static volatile PersistAtoms[] _emptyArray;
        public String buildFingerprint;
        public CarrierIdMismatch[] carrierIdMismatch;
        public int carrierIdTableVersion;
        public CellularDataServiceSwitch[] cellularDataServiceSwitch;
        public long cellularDataServiceSwitchPullTimestampMillis;
        public CellularServiceState[] cellularServiceState;
        public long cellularServiceStatePullTimestampMillis;
        public DataCallSession[] dataCallSession;
        public long dataCallSessionPullTimestampMillis;
        public GbaEvent[] gbaEvent;
        public long gbaEventPullTimestampMillis;
        public ImsDedicatedBearerEvent[] imsDedicatedBearerEvent;
        public long imsDedicatedBearerEventPullTimestampMillis;
        public ImsDedicatedBearerListenerEvent[] imsDedicatedBearerListenerEvent;
        public long imsDedicatedBearerListenerEventPullTimestampMillis;
        public ImsRegistrationFeatureTagStats[] imsRegistrationFeatureTagStats;
        public long imsRegistrationFeatureTagStatsPullTimestampMillis;
        public ImsRegistrationServiceDescStats[] imsRegistrationServiceDescStats;
        public long imsRegistrationServiceDescStatsPullTimestampMillis;
        public ImsRegistrationStats[] imsRegistrationStats;
        public long imsRegistrationStatsPullTimestampMillis;
        public ImsRegistrationTermination[] imsRegistrationTermination;
        public long imsRegistrationTerminationPullTimestampMillis;
        public IncomingSms[] incomingSms;
        public long incomingSmsPullTimestampMillis;
        public NetworkRequests[] networkRequests;
        public long networkRequestsPullTimestampMillis;
        public NetworkRequestsV2[] networkRequestsV2;
        public long networkRequestsV2PullTimestampMillis;
        public OutgoingSms[] outgoingSms;
        public long outgoingSmsPullTimestampMillis;
        public PresenceNotifyEvent[] presenceNotifyEvent;
        public long presenceNotifyEventPullTimestampMillis;
        public RcsAcsProvisioningStats[] rcsAcsProvisioningStats;
        public long rcsAcsProvisioningStatsPullTimestampMillis;
        public RcsClientProvisioningStats[] rcsClientProvisioningStats;
        public long rcsClientProvisioningStatsPullTimestampMillis;
        public SipDelegateStats[] sipDelegateStats;
        public long sipDelegateStatsPullTimestampMillis;
        public SipMessageResponse[] sipMessageResponse;
        public long sipMessageResponsePullTimestampMillis;
        public SipTransportFeatureTagStats[] sipTransportFeatureTagStats;
        public long sipTransportFeatureTagStatsPullTimestampMillis;
        public SipTransportSession[] sipTransportSession;
        public long sipTransportSessionPullTimestampMillis;
        public UceEventStats[] uceEventStats;
        public long uceEventStatsPullTimestampMillis;
        public VoiceCallRatUsage[] voiceCallRatUsage;
        public long voiceCallRatUsagePullTimestampMillis;
        public VoiceCallSession[] voiceCallSession;
        public long voiceCallSessionPullTimestampMillis;

        public static PersistAtoms[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new PersistAtoms[0];
                    }
                }
            }
            return _emptyArray;
        }

        public PersistAtoms() {
            clear();
        }

        public PersistAtoms clear() {
            this.voiceCallRatUsage = VoiceCallRatUsage.emptyArray();
            this.voiceCallRatUsagePullTimestampMillis = 0;
            this.voiceCallSession = VoiceCallSession.emptyArray();
            this.voiceCallSessionPullTimestampMillis = 0;
            this.incomingSms = IncomingSms.emptyArray();
            this.incomingSmsPullTimestampMillis = 0;
            this.outgoingSms = OutgoingSms.emptyArray();
            this.outgoingSmsPullTimestampMillis = 0;
            this.carrierIdMismatch = CarrierIdMismatch.emptyArray();
            this.carrierIdTableVersion = 0;
            this.dataCallSession = DataCallSession.emptyArray();
            this.dataCallSessionPullTimestampMillis = 0;
            this.cellularServiceState = CellularServiceState.emptyArray();
            this.cellularServiceStatePullTimestampMillis = 0;
            this.cellularDataServiceSwitch = CellularDataServiceSwitch.emptyArray();
            this.cellularDataServiceSwitchPullTimestampMillis = 0;
            this.imsRegistrationTermination = ImsRegistrationTermination.emptyArray();
            this.imsRegistrationTerminationPullTimestampMillis = 0;
            this.imsRegistrationStats = ImsRegistrationStats.emptyArray();
            this.imsRegistrationStatsPullTimestampMillis = 0;
            this.buildFingerprint = "";
            this.networkRequests = NetworkRequests.emptyArray();
            this.networkRequestsPullTimestampMillis = 0;
            this.imsRegistrationFeatureTagStats = ImsRegistrationFeatureTagStats.emptyArray();
            this.imsRegistrationFeatureTagStatsPullTimestampMillis = 0;
            this.rcsClientProvisioningStats = RcsClientProvisioningStats.emptyArray();
            this.rcsClientProvisioningStatsPullTimestampMillis = 0;
            this.rcsAcsProvisioningStats = RcsAcsProvisioningStats.emptyArray();
            this.rcsAcsProvisioningStatsPullTimestampMillis = 0;
            this.sipDelegateStats = SipDelegateStats.emptyArray();
            this.sipDelegateStatsPullTimestampMillis = 0;
            this.sipTransportFeatureTagStats = SipTransportFeatureTagStats.emptyArray();
            this.sipTransportFeatureTagStatsPullTimestampMillis = 0;
            this.sipMessageResponse = SipMessageResponse.emptyArray();
            this.sipMessageResponsePullTimestampMillis = 0;
            this.sipTransportSession = SipTransportSession.emptyArray();
            this.sipTransportSessionPullTimestampMillis = 0;
            this.imsDedicatedBearerListenerEvent = ImsDedicatedBearerListenerEvent.emptyArray();
            this.imsDedicatedBearerListenerEventPullTimestampMillis = 0;
            this.imsDedicatedBearerEvent = ImsDedicatedBearerEvent.emptyArray();
            this.imsDedicatedBearerEventPullTimestampMillis = 0;
            this.imsRegistrationServiceDescStats = ImsRegistrationServiceDescStats.emptyArray();
            this.imsRegistrationServiceDescStatsPullTimestampMillis = 0;
            this.uceEventStats = UceEventStats.emptyArray();
            this.uceEventStatsPullTimestampMillis = 0;
            this.presenceNotifyEvent = PresenceNotifyEvent.emptyArray();
            this.presenceNotifyEventPullTimestampMillis = 0;
            this.gbaEvent = GbaEvent.emptyArray();
            this.gbaEventPullTimestampMillis = 0;
            this.networkRequestsV2 = NetworkRequestsV2.emptyArray();
            this.networkRequestsV2PullTimestampMillis = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            VoiceCallRatUsage[] voiceCallRatUsageArr = this.voiceCallRatUsage;
            int i = 0;
            if (voiceCallRatUsageArr != null && voiceCallRatUsageArr.length > 0) {
                int i2 = 0;
                while (true) {
                    VoiceCallRatUsage[] voiceCallRatUsageArr2 = this.voiceCallRatUsage;
                    if (i2 >= voiceCallRatUsageArr2.length) {
                        break;
                    }
                    VoiceCallRatUsage voiceCallRatUsage2 = voiceCallRatUsageArr2[i2];
                    if (voiceCallRatUsage2 != null) {
                        codedOutputByteBufferNano.writeMessage(1, voiceCallRatUsage2);
                    }
                    i2++;
                }
            }
            long j = this.voiceCallRatUsagePullTimestampMillis;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(2, j);
            }
            VoiceCallSession[] voiceCallSessionArr = this.voiceCallSession;
            if (voiceCallSessionArr != null && voiceCallSessionArr.length > 0) {
                int i3 = 0;
                while (true) {
                    VoiceCallSession[] voiceCallSessionArr2 = this.voiceCallSession;
                    if (i3 >= voiceCallSessionArr2.length) {
                        break;
                    }
                    VoiceCallSession voiceCallSession2 = voiceCallSessionArr2[i3];
                    if (voiceCallSession2 != null) {
                        codedOutputByteBufferNano.writeMessage(3, voiceCallSession2);
                    }
                    i3++;
                }
            }
            long j2 = this.voiceCallSessionPullTimestampMillis;
            if (j2 != 0) {
                codedOutputByteBufferNano.writeInt64(4, j2);
            }
            IncomingSms[] incomingSmsArr = this.incomingSms;
            if (incomingSmsArr != null && incomingSmsArr.length > 0) {
                int i4 = 0;
                while (true) {
                    IncomingSms[] incomingSmsArr2 = this.incomingSms;
                    if (i4 >= incomingSmsArr2.length) {
                        break;
                    }
                    IncomingSms incomingSms2 = incomingSmsArr2[i4];
                    if (incomingSms2 != null) {
                        codedOutputByteBufferNano.writeMessage(5, incomingSms2);
                    }
                    i4++;
                }
            }
            long j3 = this.incomingSmsPullTimestampMillis;
            if (j3 != 0) {
                codedOutputByteBufferNano.writeInt64(6, j3);
            }
            OutgoingSms[] outgoingSmsArr = this.outgoingSms;
            if (outgoingSmsArr != null && outgoingSmsArr.length > 0) {
                int i5 = 0;
                while (true) {
                    OutgoingSms[] outgoingSmsArr2 = this.outgoingSms;
                    if (i5 >= outgoingSmsArr2.length) {
                        break;
                    }
                    OutgoingSms outgoingSms2 = outgoingSmsArr2[i5];
                    if (outgoingSms2 != null) {
                        codedOutputByteBufferNano.writeMessage(7, outgoingSms2);
                    }
                    i5++;
                }
            }
            long j4 = this.outgoingSmsPullTimestampMillis;
            if (j4 != 0) {
                codedOutputByteBufferNano.writeInt64(8, j4);
            }
            CarrierIdMismatch[] carrierIdMismatchArr = this.carrierIdMismatch;
            if (carrierIdMismatchArr != null && carrierIdMismatchArr.length > 0) {
                int i6 = 0;
                while (true) {
                    CarrierIdMismatch[] carrierIdMismatchArr2 = this.carrierIdMismatch;
                    if (i6 >= carrierIdMismatchArr2.length) {
                        break;
                    }
                    CarrierIdMismatch carrierIdMismatch2 = carrierIdMismatchArr2[i6];
                    if (carrierIdMismatch2 != null) {
                        codedOutputByteBufferNano.writeMessage(9, carrierIdMismatch2);
                    }
                    i6++;
                }
            }
            int i7 = this.carrierIdTableVersion;
            if (i7 != 0) {
                codedOutputByteBufferNano.writeInt32(10, i7);
            }
            DataCallSession[] dataCallSessionArr = this.dataCallSession;
            if (dataCallSessionArr != null && dataCallSessionArr.length > 0) {
                int i8 = 0;
                while (true) {
                    DataCallSession[] dataCallSessionArr2 = this.dataCallSession;
                    if (i8 >= dataCallSessionArr2.length) {
                        break;
                    }
                    DataCallSession dataCallSession2 = dataCallSessionArr2[i8];
                    if (dataCallSession2 != null) {
                        codedOutputByteBufferNano.writeMessage(11, dataCallSession2);
                    }
                    i8++;
                }
            }
            long j5 = this.dataCallSessionPullTimestampMillis;
            if (j5 != 0) {
                codedOutputByteBufferNano.writeInt64(12, j5);
            }
            CellularServiceState[] cellularServiceStateArr = this.cellularServiceState;
            if (cellularServiceStateArr != null && cellularServiceStateArr.length > 0) {
                int i9 = 0;
                while (true) {
                    CellularServiceState[] cellularServiceStateArr2 = this.cellularServiceState;
                    if (i9 >= cellularServiceStateArr2.length) {
                        break;
                    }
                    CellularServiceState cellularServiceState2 = cellularServiceStateArr2[i9];
                    if (cellularServiceState2 != null) {
                        codedOutputByteBufferNano.writeMessage(13, cellularServiceState2);
                    }
                    i9++;
                }
            }
            long j6 = this.cellularServiceStatePullTimestampMillis;
            if (j6 != 0) {
                codedOutputByteBufferNano.writeInt64(14, j6);
            }
            CellularDataServiceSwitch[] cellularDataServiceSwitchArr = this.cellularDataServiceSwitch;
            if (cellularDataServiceSwitchArr != null && cellularDataServiceSwitchArr.length > 0) {
                int i10 = 0;
                while (true) {
                    CellularDataServiceSwitch[] cellularDataServiceSwitchArr2 = this.cellularDataServiceSwitch;
                    if (i10 >= cellularDataServiceSwitchArr2.length) {
                        break;
                    }
                    CellularDataServiceSwitch cellularDataServiceSwitch2 = cellularDataServiceSwitchArr2[i10];
                    if (cellularDataServiceSwitch2 != null) {
                        codedOutputByteBufferNano.writeMessage(15, cellularDataServiceSwitch2);
                    }
                    i10++;
                }
            }
            long j7 = this.cellularDataServiceSwitchPullTimestampMillis;
            if (j7 != 0) {
                codedOutputByteBufferNano.writeInt64(16, j7);
            }
            ImsRegistrationTermination[] imsRegistrationTerminationArr = this.imsRegistrationTermination;
            if (imsRegistrationTerminationArr != null && imsRegistrationTerminationArr.length > 0) {
                int i11 = 0;
                while (true) {
                    ImsRegistrationTermination[] imsRegistrationTerminationArr2 = this.imsRegistrationTermination;
                    if (i11 >= imsRegistrationTerminationArr2.length) {
                        break;
                    }
                    ImsRegistrationTermination imsRegistrationTermination2 = imsRegistrationTerminationArr2[i11];
                    if (imsRegistrationTermination2 != null) {
                        codedOutputByteBufferNano.writeMessage(17, imsRegistrationTermination2);
                    }
                    i11++;
                }
            }
            long j8 = this.imsRegistrationTerminationPullTimestampMillis;
            if (j8 != 0) {
                codedOutputByteBufferNano.writeInt64(18, j8);
            }
            ImsRegistrationStats[] imsRegistrationStatsArr = this.imsRegistrationStats;
            if (imsRegistrationStatsArr != null && imsRegistrationStatsArr.length > 0) {
                int i12 = 0;
                while (true) {
                    ImsRegistrationStats[] imsRegistrationStatsArr2 = this.imsRegistrationStats;
                    if (i12 >= imsRegistrationStatsArr2.length) {
                        break;
                    }
                    ImsRegistrationStats imsRegistrationStats2 = imsRegistrationStatsArr2[i12];
                    if (imsRegistrationStats2 != null) {
                        codedOutputByteBufferNano.writeMessage(19, imsRegistrationStats2);
                    }
                    i12++;
                }
            }
            long j9 = this.imsRegistrationStatsPullTimestampMillis;
            if (j9 != 0) {
                codedOutputByteBufferNano.writeInt64(20, j9);
            }
            if (!this.buildFingerprint.equals("")) {
                codedOutputByteBufferNano.writeString(21, this.buildFingerprint);
            }
            NetworkRequests[] networkRequestsArr = this.networkRequests;
            if (networkRequestsArr != null && networkRequestsArr.length > 0) {
                int i13 = 0;
                while (true) {
                    NetworkRequests[] networkRequestsArr2 = this.networkRequests;
                    if (i13 >= networkRequestsArr2.length) {
                        break;
                    }
                    NetworkRequests networkRequests2 = networkRequestsArr2[i13];
                    if (networkRequests2 != null) {
                        codedOutputByteBufferNano.writeMessage(22, networkRequests2);
                    }
                    i13++;
                }
            }
            long j10 = this.networkRequestsPullTimestampMillis;
            if (j10 != 0) {
                codedOutputByteBufferNano.writeInt64(23, j10);
            }
            ImsRegistrationFeatureTagStats[] imsRegistrationFeatureTagStatsArr = this.imsRegistrationFeatureTagStats;
            if (imsRegistrationFeatureTagStatsArr != null && imsRegistrationFeatureTagStatsArr.length > 0) {
                int i14 = 0;
                while (true) {
                    ImsRegistrationFeatureTagStats[] imsRegistrationFeatureTagStatsArr2 = this.imsRegistrationFeatureTagStats;
                    if (i14 >= imsRegistrationFeatureTagStatsArr2.length) {
                        break;
                    }
                    ImsRegistrationFeatureTagStats imsRegistrationFeatureTagStats2 = imsRegistrationFeatureTagStatsArr2[i14];
                    if (imsRegistrationFeatureTagStats2 != null) {
                        codedOutputByteBufferNano.writeMessage(24, imsRegistrationFeatureTagStats2);
                    }
                    i14++;
                }
            }
            long j11 = this.imsRegistrationFeatureTagStatsPullTimestampMillis;
            if (j11 != 0) {
                codedOutputByteBufferNano.writeInt64(25, j11);
            }
            RcsClientProvisioningStats[] rcsClientProvisioningStatsArr = this.rcsClientProvisioningStats;
            if (rcsClientProvisioningStatsArr != null && rcsClientProvisioningStatsArr.length > 0) {
                int i15 = 0;
                while (true) {
                    RcsClientProvisioningStats[] rcsClientProvisioningStatsArr2 = this.rcsClientProvisioningStats;
                    if (i15 >= rcsClientProvisioningStatsArr2.length) {
                        break;
                    }
                    RcsClientProvisioningStats rcsClientProvisioningStats2 = rcsClientProvisioningStatsArr2[i15];
                    if (rcsClientProvisioningStats2 != null) {
                        codedOutputByteBufferNano.writeMessage(26, rcsClientProvisioningStats2);
                    }
                    i15++;
                }
            }
            long j12 = this.rcsClientProvisioningStatsPullTimestampMillis;
            if (j12 != 0) {
                codedOutputByteBufferNano.writeInt64(27, j12);
            }
            RcsAcsProvisioningStats[] rcsAcsProvisioningStatsArr = this.rcsAcsProvisioningStats;
            if (rcsAcsProvisioningStatsArr != null && rcsAcsProvisioningStatsArr.length > 0) {
                int i16 = 0;
                while (true) {
                    RcsAcsProvisioningStats[] rcsAcsProvisioningStatsArr2 = this.rcsAcsProvisioningStats;
                    if (i16 >= rcsAcsProvisioningStatsArr2.length) {
                        break;
                    }
                    RcsAcsProvisioningStats rcsAcsProvisioningStats2 = rcsAcsProvisioningStatsArr2[i16];
                    if (rcsAcsProvisioningStats2 != null) {
                        codedOutputByteBufferNano.writeMessage(28, rcsAcsProvisioningStats2);
                    }
                    i16++;
                }
            }
            long j13 = this.rcsAcsProvisioningStatsPullTimestampMillis;
            if (j13 != 0) {
                codedOutputByteBufferNano.writeInt64(29, j13);
            }
            SipDelegateStats[] sipDelegateStatsArr = this.sipDelegateStats;
            if (sipDelegateStatsArr != null && sipDelegateStatsArr.length > 0) {
                int i17 = 0;
                while (true) {
                    SipDelegateStats[] sipDelegateStatsArr2 = this.sipDelegateStats;
                    if (i17 >= sipDelegateStatsArr2.length) {
                        break;
                    }
                    SipDelegateStats sipDelegateStats2 = sipDelegateStatsArr2[i17];
                    if (sipDelegateStats2 != null) {
                        codedOutputByteBufferNano.writeMessage(30, sipDelegateStats2);
                    }
                    i17++;
                }
            }
            long j14 = this.sipDelegateStatsPullTimestampMillis;
            if (j14 != 0) {
                codedOutputByteBufferNano.writeInt64(31, j14);
            }
            SipTransportFeatureTagStats[] sipTransportFeatureTagStatsArr = this.sipTransportFeatureTagStats;
            if (sipTransportFeatureTagStatsArr != null && sipTransportFeatureTagStatsArr.length > 0) {
                int i18 = 0;
                while (true) {
                    SipTransportFeatureTagStats[] sipTransportFeatureTagStatsArr2 = this.sipTransportFeatureTagStats;
                    if (i18 >= sipTransportFeatureTagStatsArr2.length) {
                        break;
                    }
                    SipTransportFeatureTagStats sipTransportFeatureTagStats2 = sipTransportFeatureTagStatsArr2[i18];
                    if (sipTransportFeatureTagStats2 != null) {
                        codedOutputByteBufferNano.writeMessage(32, sipTransportFeatureTagStats2);
                    }
                    i18++;
                }
            }
            long j15 = this.sipTransportFeatureTagStatsPullTimestampMillis;
            if (j15 != 0) {
                codedOutputByteBufferNano.writeInt64(33, j15);
            }
            SipMessageResponse[] sipMessageResponseArr = this.sipMessageResponse;
            if (sipMessageResponseArr != null && sipMessageResponseArr.length > 0) {
                int i19 = 0;
                while (true) {
                    SipMessageResponse[] sipMessageResponseArr2 = this.sipMessageResponse;
                    if (i19 >= sipMessageResponseArr2.length) {
                        break;
                    }
                    SipMessageResponse sipMessageResponse2 = sipMessageResponseArr2[i19];
                    if (sipMessageResponse2 != null) {
                        codedOutputByteBufferNano.writeMessage(34, sipMessageResponse2);
                    }
                    i19++;
                }
            }
            long j16 = this.sipMessageResponsePullTimestampMillis;
            if (j16 != 0) {
                codedOutputByteBufferNano.writeInt64(35, j16);
            }
            SipTransportSession[] sipTransportSessionArr = this.sipTransportSession;
            if (sipTransportSessionArr != null && sipTransportSessionArr.length > 0) {
                int i20 = 0;
                while (true) {
                    SipTransportSession[] sipTransportSessionArr2 = this.sipTransportSession;
                    if (i20 >= sipTransportSessionArr2.length) {
                        break;
                    }
                    SipTransportSession sipTransportSession2 = sipTransportSessionArr2[i20];
                    if (sipTransportSession2 != null) {
                        codedOutputByteBufferNano.writeMessage(36, sipTransportSession2);
                    }
                    i20++;
                }
            }
            long j17 = this.sipTransportSessionPullTimestampMillis;
            if (j17 != 0) {
                codedOutputByteBufferNano.writeInt64(37, j17);
            }
            ImsDedicatedBearerListenerEvent[] imsDedicatedBearerListenerEventArr = this.imsDedicatedBearerListenerEvent;
            if (imsDedicatedBearerListenerEventArr != null && imsDedicatedBearerListenerEventArr.length > 0) {
                int i21 = 0;
                while (true) {
                    ImsDedicatedBearerListenerEvent[] imsDedicatedBearerListenerEventArr2 = this.imsDedicatedBearerListenerEvent;
                    if (i21 >= imsDedicatedBearerListenerEventArr2.length) {
                        break;
                    }
                    ImsDedicatedBearerListenerEvent imsDedicatedBearerListenerEvent2 = imsDedicatedBearerListenerEventArr2[i21];
                    if (imsDedicatedBearerListenerEvent2 != null) {
                        codedOutputByteBufferNano.writeMessage(38, imsDedicatedBearerListenerEvent2);
                    }
                    i21++;
                }
            }
            long j18 = this.imsDedicatedBearerListenerEventPullTimestampMillis;
            if (j18 != 0) {
                codedOutputByteBufferNano.writeInt64(39, j18);
            }
            ImsDedicatedBearerEvent[] imsDedicatedBearerEventArr = this.imsDedicatedBearerEvent;
            if (imsDedicatedBearerEventArr != null && imsDedicatedBearerEventArr.length > 0) {
                int i22 = 0;
                while (true) {
                    ImsDedicatedBearerEvent[] imsDedicatedBearerEventArr2 = this.imsDedicatedBearerEvent;
                    if (i22 >= imsDedicatedBearerEventArr2.length) {
                        break;
                    }
                    ImsDedicatedBearerEvent imsDedicatedBearerEvent2 = imsDedicatedBearerEventArr2[i22];
                    if (imsDedicatedBearerEvent2 != null) {
                        codedOutputByteBufferNano.writeMessage(40, imsDedicatedBearerEvent2);
                    }
                    i22++;
                }
            }
            long j19 = this.imsDedicatedBearerEventPullTimestampMillis;
            if (j19 != 0) {
                codedOutputByteBufferNano.writeInt64(41, j19);
            }
            ImsRegistrationServiceDescStats[] imsRegistrationServiceDescStatsArr = this.imsRegistrationServiceDescStats;
            if (imsRegistrationServiceDescStatsArr != null && imsRegistrationServiceDescStatsArr.length > 0) {
                int i23 = 0;
                while (true) {
                    ImsRegistrationServiceDescStats[] imsRegistrationServiceDescStatsArr2 = this.imsRegistrationServiceDescStats;
                    if (i23 >= imsRegistrationServiceDescStatsArr2.length) {
                        break;
                    }
                    ImsRegistrationServiceDescStats imsRegistrationServiceDescStats2 = imsRegistrationServiceDescStatsArr2[i23];
                    if (imsRegistrationServiceDescStats2 != null) {
                        codedOutputByteBufferNano.writeMessage(42, imsRegistrationServiceDescStats2);
                    }
                    i23++;
                }
            }
            long j20 = this.imsRegistrationServiceDescStatsPullTimestampMillis;
            if (j20 != 0) {
                codedOutputByteBufferNano.writeInt64(43, j20);
            }
            UceEventStats[] uceEventStatsArr = this.uceEventStats;
            if (uceEventStatsArr != null && uceEventStatsArr.length > 0) {
                int i24 = 0;
                while (true) {
                    UceEventStats[] uceEventStatsArr2 = this.uceEventStats;
                    if (i24 >= uceEventStatsArr2.length) {
                        break;
                    }
                    UceEventStats uceEventStats2 = uceEventStatsArr2[i24];
                    if (uceEventStats2 != null) {
                        codedOutputByteBufferNano.writeMessage(44, uceEventStats2);
                    }
                    i24++;
                }
            }
            long j21 = this.uceEventStatsPullTimestampMillis;
            if (j21 != 0) {
                codedOutputByteBufferNano.writeInt64(45, j21);
            }
            PresenceNotifyEvent[] presenceNotifyEventArr = this.presenceNotifyEvent;
            if (presenceNotifyEventArr != null && presenceNotifyEventArr.length > 0) {
                int i25 = 0;
                while (true) {
                    PresenceNotifyEvent[] presenceNotifyEventArr2 = this.presenceNotifyEvent;
                    if (i25 >= presenceNotifyEventArr2.length) {
                        break;
                    }
                    PresenceNotifyEvent presenceNotifyEvent2 = presenceNotifyEventArr2[i25];
                    if (presenceNotifyEvent2 != null) {
                        codedOutputByteBufferNano.writeMessage(46, presenceNotifyEvent2);
                    }
                    i25++;
                }
            }
            long j22 = this.presenceNotifyEventPullTimestampMillis;
            if (j22 != 0) {
                codedOutputByteBufferNano.writeInt64(47, j22);
            }
            GbaEvent[] gbaEventArr = this.gbaEvent;
            if (gbaEventArr != null && gbaEventArr.length > 0) {
                int i26 = 0;
                while (true) {
                    GbaEvent[] gbaEventArr2 = this.gbaEvent;
                    if (i26 >= gbaEventArr2.length) {
                        break;
                    }
                    GbaEvent gbaEvent2 = gbaEventArr2[i26];
                    if (gbaEvent2 != null) {
                        codedOutputByteBufferNano.writeMessage(48, gbaEvent2);
                    }
                    i26++;
                }
            }
            long j23 = this.gbaEventPullTimestampMillis;
            if (j23 != 0) {
                codedOutputByteBufferNano.writeInt64(49, j23);
            }
            NetworkRequestsV2[] networkRequestsV2Arr = this.networkRequestsV2;
            if (networkRequestsV2Arr != null && networkRequestsV2Arr.length > 0) {
                while (true) {
                    NetworkRequestsV2[] networkRequestsV2Arr2 = this.networkRequestsV2;
                    if (i >= networkRequestsV2Arr2.length) {
                        break;
                    }
                    NetworkRequestsV2 networkRequestsV22 = networkRequestsV2Arr2[i];
                    if (networkRequestsV22 != null) {
                        codedOutputByteBufferNano.writeMessage(50, networkRequestsV22);
                    }
                    i++;
                }
            }
            long j24 = this.networkRequestsV2PullTimestampMillis;
            if (j24 != 0) {
                codedOutputByteBufferNano.writeInt64(51, j24);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            VoiceCallRatUsage[] voiceCallRatUsageArr = this.voiceCallRatUsage;
            int i = 0;
            if (voiceCallRatUsageArr != null && voiceCallRatUsageArr.length > 0) {
                int i2 = 0;
                while (true) {
                    VoiceCallRatUsage[] voiceCallRatUsageArr2 = this.voiceCallRatUsage;
                    if (i2 >= voiceCallRatUsageArr2.length) {
                        break;
                    }
                    VoiceCallRatUsage voiceCallRatUsage2 = voiceCallRatUsageArr2[i2];
                    if (voiceCallRatUsage2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(1, voiceCallRatUsage2);
                    }
                    i2++;
                }
            }
            long j = this.voiceCallRatUsagePullTimestampMillis;
            if (j != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(2, j);
            }
            VoiceCallSession[] voiceCallSessionArr = this.voiceCallSession;
            if (voiceCallSessionArr != null && voiceCallSessionArr.length > 0) {
                int i3 = 0;
                while (true) {
                    VoiceCallSession[] voiceCallSessionArr2 = this.voiceCallSession;
                    if (i3 >= voiceCallSessionArr2.length) {
                        break;
                    }
                    VoiceCallSession voiceCallSession2 = voiceCallSessionArr2[i3];
                    if (voiceCallSession2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(3, voiceCallSession2);
                    }
                    i3++;
                }
            }
            long j2 = this.voiceCallSessionPullTimestampMillis;
            if (j2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(4, j2);
            }
            IncomingSms[] incomingSmsArr = this.incomingSms;
            if (incomingSmsArr != null && incomingSmsArr.length > 0) {
                int i4 = 0;
                while (true) {
                    IncomingSms[] incomingSmsArr2 = this.incomingSms;
                    if (i4 >= incomingSmsArr2.length) {
                        break;
                    }
                    IncomingSms incomingSms2 = incomingSmsArr2[i4];
                    if (incomingSms2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(5, incomingSms2);
                    }
                    i4++;
                }
            }
            long j3 = this.incomingSmsPullTimestampMillis;
            if (j3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(6, j3);
            }
            OutgoingSms[] outgoingSmsArr = this.outgoingSms;
            if (outgoingSmsArr != null && outgoingSmsArr.length > 0) {
                int i5 = 0;
                while (true) {
                    OutgoingSms[] outgoingSmsArr2 = this.outgoingSms;
                    if (i5 >= outgoingSmsArr2.length) {
                        break;
                    }
                    OutgoingSms outgoingSms2 = outgoingSmsArr2[i5];
                    if (outgoingSms2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(7, outgoingSms2);
                    }
                    i5++;
                }
            }
            long j4 = this.outgoingSmsPullTimestampMillis;
            if (j4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(8, j4);
            }
            CarrierIdMismatch[] carrierIdMismatchArr = this.carrierIdMismatch;
            if (carrierIdMismatchArr != null && carrierIdMismatchArr.length > 0) {
                int i6 = 0;
                while (true) {
                    CarrierIdMismatch[] carrierIdMismatchArr2 = this.carrierIdMismatch;
                    if (i6 >= carrierIdMismatchArr2.length) {
                        break;
                    }
                    CarrierIdMismatch carrierIdMismatch2 = carrierIdMismatchArr2[i6];
                    if (carrierIdMismatch2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(9, carrierIdMismatch2);
                    }
                    i6++;
                }
            }
            int i7 = this.carrierIdTableVersion;
            if (i7 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(10, i7);
            }
            DataCallSession[] dataCallSessionArr = this.dataCallSession;
            if (dataCallSessionArr != null && dataCallSessionArr.length > 0) {
                int i8 = 0;
                while (true) {
                    DataCallSession[] dataCallSessionArr2 = this.dataCallSession;
                    if (i8 >= dataCallSessionArr2.length) {
                        break;
                    }
                    DataCallSession dataCallSession2 = dataCallSessionArr2[i8];
                    if (dataCallSession2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(11, dataCallSession2);
                    }
                    i8++;
                }
            }
            long j5 = this.dataCallSessionPullTimestampMillis;
            if (j5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(12, j5);
            }
            CellularServiceState[] cellularServiceStateArr = this.cellularServiceState;
            if (cellularServiceStateArr != null && cellularServiceStateArr.length > 0) {
                int i9 = 0;
                while (true) {
                    CellularServiceState[] cellularServiceStateArr2 = this.cellularServiceState;
                    if (i9 >= cellularServiceStateArr2.length) {
                        break;
                    }
                    CellularServiceState cellularServiceState2 = cellularServiceStateArr2[i9];
                    if (cellularServiceState2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(13, cellularServiceState2);
                    }
                    i9++;
                }
            }
            long j6 = this.cellularServiceStatePullTimestampMillis;
            if (j6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(14, j6);
            }
            CellularDataServiceSwitch[] cellularDataServiceSwitchArr = this.cellularDataServiceSwitch;
            if (cellularDataServiceSwitchArr != null && cellularDataServiceSwitchArr.length > 0) {
                int i10 = 0;
                while (true) {
                    CellularDataServiceSwitch[] cellularDataServiceSwitchArr2 = this.cellularDataServiceSwitch;
                    if (i10 >= cellularDataServiceSwitchArr2.length) {
                        break;
                    }
                    CellularDataServiceSwitch cellularDataServiceSwitch2 = cellularDataServiceSwitchArr2[i10];
                    if (cellularDataServiceSwitch2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(15, cellularDataServiceSwitch2);
                    }
                    i10++;
                }
            }
            long j7 = this.cellularDataServiceSwitchPullTimestampMillis;
            if (j7 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(16, j7);
            }
            ImsRegistrationTermination[] imsRegistrationTerminationArr = this.imsRegistrationTermination;
            if (imsRegistrationTerminationArr != null && imsRegistrationTerminationArr.length > 0) {
                int i11 = 0;
                while (true) {
                    ImsRegistrationTermination[] imsRegistrationTerminationArr2 = this.imsRegistrationTermination;
                    if (i11 >= imsRegistrationTerminationArr2.length) {
                        break;
                    }
                    ImsRegistrationTermination imsRegistrationTermination2 = imsRegistrationTerminationArr2[i11];
                    if (imsRegistrationTermination2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(17, imsRegistrationTermination2);
                    }
                    i11++;
                }
            }
            long j8 = this.imsRegistrationTerminationPullTimestampMillis;
            if (j8 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(18, j8);
            }
            ImsRegistrationStats[] imsRegistrationStatsArr = this.imsRegistrationStats;
            if (imsRegistrationStatsArr != null && imsRegistrationStatsArr.length > 0) {
                int i12 = 0;
                while (true) {
                    ImsRegistrationStats[] imsRegistrationStatsArr2 = this.imsRegistrationStats;
                    if (i12 >= imsRegistrationStatsArr2.length) {
                        break;
                    }
                    ImsRegistrationStats imsRegistrationStats2 = imsRegistrationStatsArr2[i12];
                    if (imsRegistrationStats2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(19, imsRegistrationStats2);
                    }
                    i12++;
                }
            }
            long j9 = this.imsRegistrationStatsPullTimestampMillis;
            if (j9 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(20, j9);
            }
            if (!this.buildFingerprint.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(21, this.buildFingerprint);
            }
            NetworkRequests[] networkRequestsArr = this.networkRequests;
            if (networkRequestsArr != null && networkRequestsArr.length > 0) {
                int i13 = 0;
                while (true) {
                    NetworkRequests[] networkRequestsArr2 = this.networkRequests;
                    if (i13 >= networkRequestsArr2.length) {
                        break;
                    }
                    NetworkRequests networkRequests2 = networkRequestsArr2[i13];
                    if (networkRequests2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(22, networkRequests2);
                    }
                    i13++;
                }
            }
            long j10 = this.networkRequestsPullTimestampMillis;
            if (j10 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(23, j10);
            }
            ImsRegistrationFeatureTagStats[] imsRegistrationFeatureTagStatsArr = this.imsRegistrationFeatureTagStats;
            if (imsRegistrationFeatureTagStatsArr != null && imsRegistrationFeatureTagStatsArr.length > 0) {
                int i14 = 0;
                while (true) {
                    ImsRegistrationFeatureTagStats[] imsRegistrationFeatureTagStatsArr2 = this.imsRegistrationFeatureTagStats;
                    if (i14 >= imsRegistrationFeatureTagStatsArr2.length) {
                        break;
                    }
                    ImsRegistrationFeatureTagStats imsRegistrationFeatureTagStats2 = imsRegistrationFeatureTagStatsArr2[i14];
                    if (imsRegistrationFeatureTagStats2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(24, imsRegistrationFeatureTagStats2);
                    }
                    i14++;
                }
            }
            long j11 = this.imsRegistrationFeatureTagStatsPullTimestampMillis;
            if (j11 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(25, j11);
            }
            RcsClientProvisioningStats[] rcsClientProvisioningStatsArr = this.rcsClientProvisioningStats;
            if (rcsClientProvisioningStatsArr != null && rcsClientProvisioningStatsArr.length > 0) {
                int i15 = 0;
                while (true) {
                    RcsClientProvisioningStats[] rcsClientProvisioningStatsArr2 = this.rcsClientProvisioningStats;
                    if (i15 >= rcsClientProvisioningStatsArr2.length) {
                        break;
                    }
                    RcsClientProvisioningStats rcsClientProvisioningStats2 = rcsClientProvisioningStatsArr2[i15];
                    if (rcsClientProvisioningStats2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(26, rcsClientProvisioningStats2);
                    }
                    i15++;
                }
            }
            long j12 = this.rcsClientProvisioningStatsPullTimestampMillis;
            if (j12 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(27, j12);
            }
            RcsAcsProvisioningStats[] rcsAcsProvisioningStatsArr = this.rcsAcsProvisioningStats;
            if (rcsAcsProvisioningStatsArr != null && rcsAcsProvisioningStatsArr.length > 0) {
                int i16 = 0;
                while (true) {
                    RcsAcsProvisioningStats[] rcsAcsProvisioningStatsArr2 = this.rcsAcsProvisioningStats;
                    if (i16 >= rcsAcsProvisioningStatsArr2.length) {
                        break;
                    }
                    RcsAcsProvisioningStats rcsAcsProvisioningStats2 = rcsAcsProvisioningStatsArr2[i16];
                    if (rcsAcsProvisioningStats2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(28, rcsAcsProvisioningStats2);
                    }
                    i16++;
                }
            }
            long j13 = this.rcsAcsProvisioningStatsPullTimestampMillis;
            if (j13 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(29, j13);
            }
            SipDelegateStats[] sipDelegateStatsArr = this.sipDelegateStats;
            if (sipDelegateStatsArr != null && sipDelegateStatsArr.length > 0) {
                int i17 = 0;
                while (true) {
                    SipDelegateStats[] sipDelegateStatsArr2 = this.sipDelegateStats;
                    if (i17 >= sipDelegateStatsArr2.length) {
                        break;
                    }
                    SipDelegateStats sipDelegateStats2 = sipDelegateStatsArr2[i17];
                    if (sipDelegateStats2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(30, sipDelegateStats2);
                    }
                    i17++;
                }
            }
            long j14 = this.sipDelegateStatsPullTimestampMillis;
            if (j14 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(31, j14);
            }
            SipTransportFeatureTagStats[] sipTransportFeatureTagStatsArr = this.sipTransportFeatureTagStats;
            if (sipTransportFeatureTagStatsArr != null && sipTransportFeatureTagStatsArr.length > 0) {
                int i18 = 0;
                while (true) {
                    SipTransportFeatureTagStats[] sipTransportFeatureTagStatsArr2 = this.sipTransportFeatureTagStats;
                    if (i18 >= sipTransportFeatureTagStatsArr2.length) {
                        break;
                    }
                    SipTransportFeatureTagStats sipTransportFeatureTagStats2 = sipTransportFeatureTagStatsArr2[i18];
                    if (sipTransportFeatureTagStats2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(32, sipTransportFeatureTagStats2);
                    }
                    i18++;
                }
            }
            long j15 = this.sipTransportFeatureTagStatsPullTimestampMillis;
            if (j15 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(33, j15);
            }
            SipMessageResponse[] sipMessageResponseArr = this.sipMessageResponse;
            if (sipMessageResponseArr != null && sipMessageResponseArr.length > 0) {
                int i19 = 0;
                while (true) {
                    SipMessageResponse[] sipMessageResponseArr2 = this.sipMessageResponse;
                    if (i19 >= sipMessageResponseArr2.length) {
                        break;
                    }
                    SipMessageResponse sipMessageResponse2 = sipMessageResponseArr2[i19];
                    if (sipMessageResponse2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(34, sipMessageResponse2);
                    }
                    i19++;
                }
            }
            long j16 = this.sipMessageResponsePullTimestampMillis;
            if (j16 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(35, j16);
            }
            SipTransportSession[] sipTransportSessionArr = this.sipTransportSession;
            if (sipTransportSessionArr != null && sipTransportSessionArr.length > 0) {
                int i20 = 0;
                while (true) {
                    SipTransportSession[] sipTransportSessionArr2 = this.sipTransportSession;
                    if (i20 >= sipTransportSessionArr2.length) {
                        break;
                    }
                    SipTransportSession sipTransportSession2 = sipTransportSessionArr2[i20];
                    if (sipTransportSession2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(36, sipTransportSession2);
                    }
                    i20++;
                }
            }
            long j17 = this.sipTransportSessionPullTimestampMillis;
            if (j17 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(37, j17);
            }
            ImsDedicatedBearerListenerEvent[] imsDedicatedBearerListenerEventArr = this.imsDedicatedBearerListenerEvent;
            if (imsDedicatedBearerListenerEventArr != null && imsDedicatedBearerListenerEventArr.length > 0) {
                int i21 = 0;
                while (true) {
                    ImsDedicatedBearerListenerEvent[] imsDedicatedBearerListenerEventArr2 = this.imsDedicatedBearerListenerEvent;
                    if (i21 >= imsDedicatedBearerListenerEventArr2.length) {
                        break;
                    }
                    ImsDedicatedBearerListenerEvent imsDedicatedBearerListenerEvent2 = imsDedicatedBearerListenerEventArr2[i21];
                    if (imsDedicatedBearerListenerEvent2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(38, imsDedicatedBearerListenerEvent2);
                    }
                    i21++;
                }
            }
            long j18 = this.imsDedicatedBearerListenerEventPullTimestampMillis;
            if (j18 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(39, j18);
            }
            ImsDedicatedBearerEvent[] imsDedicatedBearerEventArr = this.imsDedicatedBearerEvent;
            if (imsDedicatedBearerEventArr != null && imsDedicatedBearerEventArr.length > 0) {
                int i22 = 0;
                while (true) {
                    ImsDedicatedBearerEvent[] imsDedicatedBearerEventArr2 = this.imsDedicatedBearerEvent;
                    if (i22 >= imsDedicatedBearerEventArr2.length) {
                        break;
                    }
                    ImsDedicatedBearerEvent imsDedicatedBearerEvent2 = imsDedicatedBearerEventArr2[i22];
                    if (imsDedicatedBearerEvent2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(40, imsDedicatedBearerEvent2);
                    }
                    i22++;
                }
            }
            long j19 = this.imsDedicatedBearerEventPullTimestampMillis;
            if (j19 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(41, j19);
            }
            ImsRegistrationServiceDescStats[] imsRegistrationServiceDescStatsArr = this.imsRegistrationServiceDescStats;
            if (imsRegistrationServiceDescStatsArr != null && imsRegistrationServiceDescStatsArr.length > 0) {
                int i23 = 0;
                while (true) {
                    ImsRegistrationServiceDescStats[] imsRegistrationServiceDescStatsArr2 = this.imsRegistrationServiceDescStats;
                    if (i23 >= imsRegistrationServiceDescStatsArr2.length) {
                        break;
                    }
                    ImsRegistrationServiceDescStats imsRegistrationServiceDescStats2 = imsRegistrationServiceDescStatsArr2[i23];
                    if (imsRegistrationServiceDescStats2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(42, imsRegistrationServiceDescStats2);
                    }
                    i23++;
                }
            }
            long j20 = this.imsRegistrationServiceDescStatsPullTimestampMillis;
            if (j20 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(43, j20);
            }
            UceEventStats[] uceEventStatsArr = this.uceEventStats;
            if (uceEventStatsArr != null && uceEventStatsArr.length > 0) {
                int i24 = 0;
                while (true) {
                    UceEventStats[] uceEventStatsArr2 = this.uceEventStats;
                    if (i24 >= uceEventStatsArr2.length) {
                        break;
                    }
                    UceEventStats uceEventStats2 = uceEventStatsArr2[i24];
                    if (uceEventStats2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(44, uceEventStats2);
                    }
                    i24++;
                }
            }
            long j21 = this.uceEventStatsPullTimestampMillis;
            if (j21 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(45, j21);
            }
            PresenceNotifyEvent[] presenceNotifyEventArr = this.presenceNotifyEvent;
            if (presenceNotifyEventArr != null && presenceNotifyEventArr.length > 0) {
                int i25 = 0;
                while (true) {
                    PresenceNotifyEvent[] presenceNotifyEventArr2 = this.presenceNotifyEvent;
                    if (i25 >= presenceNotifyEventArr2.length) {
                        break;
                    }
                    PresenceNotifyEvent presenceNotifyEvent2 = presenceNotifyEventArr2[i25];
                    if (presenceNotifyEvent2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(46, presenceNotifyEvent2);
                    }
                    i25++;
                }
            }
            long j22 = this.presenceNotifyEventPullTimestampMillis;
            if (j22 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(47, j22);
            }
            GbaEvent[] gbaEventArr = this.gbaEvent;
            if (gbaEventArr != null && gbaEventArr.length > 0) {
                int i26 = 0;
                while (true) {
                    GbaEvent[] gbaEventArr2 = this.gbaEvent;
                    if (i26 >= gbaEventArr2.length) {
                        break;
                    }
                    GbaEvent gbaEvent2 = gbaEventArr2[i26];
                    if (gbaEvent2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(48, gbaEvent2);
                    }
                    i26++;
                }
            }
            long j23 = this.gbaEventPullTimestampMillis;
            if (j23 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(49, j23);
            }
            NetworkRequestsV2[] networkRequestsV2Arr = this.networkRequestsV2;
            if (networkRequestsV2Arr != null && networkRequestsV2Arr.length > 0) {
                while (true) {
                    NetworkRequestsV2[] networkRequestsV2Arr2 = this.networkRequestsV2;
                    if (i >= networkRequestsV2Arr2.length) {
                        break;
                    }
                    NetworkRequestsV2 networkRequestsV22 = networkRequestsV2Arr2[i];
                    if (networkRequestsV22 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(50, networkRequestsV22);
                    }
                    i++;
                }
            }
            long j24 = this.networkRequestsV2PullTimestampMillis;
            return j24 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(51, j24) : computeSerializedSize;
        }

        public PersistAtoms mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                switch (readTag) {
                    case 0:
                        return this;
                    case 10:
                        int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 10);
                        VoiceCallRatUsage[] voiceCallRatUsageArr = this.voiceCallRatUsage;
                        int length = voiceCallRatUsageArr == null ? 0 : voiceCallRatUsageArr.length;
                        int i = repeatedFieldArrayLength + length;
                        VoiceCallRatUsage[] voiceCallRatUsageArr2 = new VoiceCallRatUsage[i];
                        if (length != 0) {
                            System.arraycopy(voiceCallRatUsageArr, 0, voiceCallRatUsageArr2, 0, length);
                        }
                        while (length < i - 1) {
                            VoiceCallRatUsage voiceCallRatUsage2 = new VoiceCallRatUsage();
                            voiceCallRatUsageArr2[length] = voiceCallRatUsage2;
                            codedInputByteBufferNano.readMessage(voiceCallRatUsage2);
                            codedInputByteBufferNano.readTag();
                            length++;
                        }
                        VoiceCallRatUsage voiceCallRatUsage3 = new VoiceCallRatUsage();
                        voiceCallRatUsageArr2[length] = voiceCallRatUsage3;
                        codedInputByteBufferNano.readMessage(voiceCallRatUsage3);
                        this.voiceCallRatUsage = voiceCallRatUsageArr2;
                        break;
                    case 16:
                        this.voiceCallRatUsagePullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 26:
                        int repeatedFieldArrayLength2 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 26);
                        VoiceCallSession[] voiceCallSessionArr = this.voiceCallSession;
                        int length2 = voiceCallSessionArr == null ? 0 : voiceCallSessionArr.length;
                        int i2 = repeatedFieldArrayLength2 + length2;
                        VoiceCallSession[] voiceCallSessionArr2 = new VoiceCallSession[i2];
                        if (length2 != 0) {
                            System.arraycopy(voiceCallSessionArr, 0, voiceCallSessionArr2, 0, length2);
                        }
                        while (length2 < i2 - 1) {
                            VoiceCallSession voiceCallSession2 = new VoiceCallSession();
                            voiceCallSessionArr2[length2] = voiceCallSession2;
                            codedInputByteBufferNano.readMessage(voiceCallSession2);
                            codedInputByteBufferNano.readTag();
                            length2++;
                        }
                        VoiceCallSession voiceCallSession3 = new VoiceCallSession();
                        voiceCallSessionArr2[length2] = voiceCallSession3;
                        codedInputByteBufferNano.readMessage(voiceCallSession3);
                        this.voiceCallSession = voiceCallSessionArr2;
                        break;
                    case 32:
                        this.voiceCallSessionPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 42:
                        int repeatedFieldArrayLength3 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 42);
                        IncomingSms[] incomingSmsArr = this.incomingSms;
                        int length3 = incomingSmsArr == null ? 0 : incomingSmsArr.length;
                        int i3 = repeatedFieldArrayLength3 + length3;
                        IncomingSms[] incomingSmsArr2 = new IncomingSms[i3];
                        if (length3 != 0) {
                            System.arraycopy(incomingSmsArr, 0, incomingSmsArr2, 0, length3);
                        }
                        while (length3 < i3 - 1) {
                            IncomingSms incomingSms2 = new IncomingSms();
                            incomingSmsArr2[length3] = incomingSms2;
                            codedInputByteBufferNano.readMessage(incomingSms2);
                            codedInputByteBufferNano.readTag();
                            length3++;
                        }
                        IncomingSms incomingSms3 = new IncomingSms();
                        incomingSmsArr2[length3] = incomingSms3;
                        codedInputByteBufferNano.readMessage(incomingSms3);
                        this.incomingSms = incomingSmsArr2;
                        break;
                    case 48:
                        this.incomingSmsPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 58:
                        int repeatedFieldArrayLength4 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 58);
                        OutgoingSms[] outgoingSmsArr = this.outgoingSms;
                        int length4 = outgoingSmsArr == null ? 0 : outgoingSmsArr.length;
                        int i4 = repeatedFieldArrayLength4 + length4;
                        OutgoingSms[] outgoingSmsArr2 = new OutgoingSms[i4];
                        if (length4 != 0) {
                            System.arraycopy(outgoingSmsArr, 0, outgoingSmsArr2, 0, length4);
                        }
                        while (length4 < i4 - 1) {
                            OutgoingSms outgoingSms2 = new OutgoingSms();
                            outgoingSmsArr2[length4] = outgoingSms2;
                            codedInputByteBufferNano.readMessage(outgoingSms2);
                            codedInputByteBufferNano.readTag();
                            length4++;
                        }
                        OutgoingSms outgoingSms3 = new OutgoingSms();
                        outgoingSmsArr2[length4] = outgoingSms3;
                        codedInputByteBufferNano.readMessage(outgoingSms3);
                        this.outgoingSms = outgoingSmsArr2;
                        break;
                    case 64:
                        this.outgoingSmsPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 74:
                        int repeatedFieldArrayLength5 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 74);
                        CarrierIdMismatch[] carrierIdMismatchArr = this.carrierIdMismatch;
                        int length5 = carrierIdMismatchArr == null ? 0 : carrierIdMismatchArr.length;
                        int i5 = repeatedFieldArrayLength5 + length5;
                        CarrierIdMismatch[] carrierIdMismatchArr2 = new CarrierIdMismatch[i5];
                        if (length5 != 0) {
                            System.arraycopy(carrierIdMismatchArr, 0, carrierIdMismatchArr2, 0, length5);
                        }
                        while (length5 < i5 - 1) {
                            CarrierIdMismatch carrierIdMismatch2 = new CarrierIdMismatch();
                            carrierIdMismatchArr2[length5] = carrierIdMismatch2;
                            codedInputByteBufferNano.readMessage(carrierIdMismatch2);
                            codedInputByteBufferNano.readTag();
                            length5++;
                        }
                        CarrierIdMismatch carrierIdMismatch3 = new CarrierIdMismatch();
                        carrierIdMismatchArr2[length5] = carrierIdMismatch3;
                        codedInputByteBufferNano.readMessage(carrierIdMismatch3);
                        this.carrierIdMismatch = carrierIdMismatchArr2;
                        break;
                    case 80:
                        this.carrierIdTableVersion = codedInputByteBufferNano.readInt32();
                        break;
                    case 90:
                        int repeatedFieldArrayLength6 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 90);
                        DataCallSession[] dataCallSessionArr = this.dataCallSession;
                        int length6 = dataCallSessionArr == null ? 0 : dataCallSessionArr.length;
                        int i6 = repeatedFieldArrayLength6 + length6;
                        DataCallSession[] dataCallSessionArr2 = new DataCallSession[i6];
                        if (length6 != 0) {
                            System.arraycopy(dataCallSessionArr, 0, dataCallSessionArr2, 0, length6);
                        }
                        while (length6 < i6 - 1) {
                            DataCallSession dataCallSession2 = new DataCallSession();
                            dataCallSessionArr2[length6] = dataCallSession2;
                            codedInputByteBufferNano.readMessage(dataCallSession2);
                            codedInputByteBufferNano.readTag();
                            length6++;
                        }
                        DataCallSession dataCallSession3 = new DataCallSession();
                        dataCallSessionArr2[length6] = dataCallSession3;
                        codedInputByteBufferNano.readMessage(dataCallSession3);
                        this.dataCallSession = dataCallSessionArr2;
                        break;
                    case 96:
                        this.dataCallSessionPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 106:
                        int repeatedFieldArrayLength7 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 106);
                        CellularServiceState[] cellularServiceStateArr = this.cellularServiceState;
                        int length7 = cellularServiceStateArr == null ? 0 : cellularServiceStateArr.length;
                        int i7 = repeatedFieldArrayLength7 + length7;
                        CellularServiceState[] cellularServiceStateArr2 = new CellularServiceState[i7];
                        if (length7 != 0) {
                            System.arraycopy(cellularServiceStateArr, 0, cellularServiceStateArr2, 0, length7);
                        }
                        while (length7 < i7 - 1) {
                            CellularServiceState cellularServiceState2 = new CellularServiceState();
                            cellularServiceStateArr2[length7] = cellularServiceState2;
                            codedInputByteBufferNano.readMessage(cellularServiceState2);
                            codedInputByteBufferNano.readTag();
                            length7++;
                        }
                        CellularServiceState cellularServiceState3 = new CellularServiceState();
                        cellularServiceStateArr2[length7] = cellularServiceState3;
                        codedInputByteBufferNano.readMessage(cellularServiceState3);
                        this.cellularServiceState = cellularServiceStateArr2;
                        break;
                    case 112:
                        this.cellularServiceStatePullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 122:
                        int repeatedFieldArrayLength8 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 122);
                        CellularDataServiceSwitch[] cellularDataServiceSwitchArr = this.cellularDataServiceSwitch;
                        int length8 = cellularDataServiceSwitchArr == null ? 0 : cellularDataServiceSwitchArr.length;
                        int i8 = repeatedFieldArrayLength8 + length8;
                        CellularDataServiceSwitch[] cellularDataServiceSwitchArr2 = new CellularDataServiceSwitch[i8];
                        if (length8 != 0) {
                            System.arraycopy(cellularDataServiceSwitchArr, 0, cellularDataServiceSwitchArr2, 0, length8);
                        }
                        while (length8 < i8 - 1) {
                            CellularDataServiceSwitch cellularDataServiceSwitch2 = new CellularDataServiceSwitch();
                            cellularDataServiceSwitchArr2[length8] = cellularDataServiceSwitch2;
                            codedInputByteBufferNano.readMessage(cellularDataServiceSwitch2);
                            codedInputByteBufferNano.readTag();
                            length8++;
                        }
                        CellularDataServiceSwitch cellularDataServiceSwitch3 = new CellularDataServiceSwitch();
                        cellularDataServiceSwitchArr2[length8] = cellularDataServiceSwitch3;
                        codedInputByteBufferNano.readMessage(cellularDataServiceSwitch3);
                        this.cellularDataServiceSwitch = cellularDataServiceSwitchArr2;
                        break;
                    case 128:
                        this.cellularDataServiceSwitchPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 138:
                        int repeatedFieldArrayLength9 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 138);
                        ImsRegistrationTermination[] imsRegistrationTerminationArr = this.imsRegistrationTermination;
                        int length9 = imsRegistrationTerminationArr == null ? 0 : imsRegistrationTerminationArr.length;
                        int i9 = repeatedFieldArrayLength9 + length9;
                        ImsRegistrationTermination[] imsRegistrationTerminationArr2 = new ImsRegistrationTermination[i9];
                        if (length9 != 0) {
                            System.arraycopy(imsRegistrationTerminationArr, 0, imsRegistrationTerminationArr2, 0, length9);
                        }
                        while (length9 < i9 - 1) {
                            ImsRegistrationTermination imsRegistrationTermination2 = new ImsRegistrationTermination();
                            imsRegistrationTerminationArr2[length9] = imsRegistrationTermination2;
                            codedInputByteBufferNano.readMessage(imsRegistrationTermination2);
                            codedInputByteBufferNano.readTag();
                            length9++;
                        }
                        ImsRegistrationTermination imsRegistrationTermination3 = new ImsRegistrationTermination();
                        imsRegistrationTerminationArr2[length9] = imsRegistrationTermination3;
                        codedInputByteBufferNano.readMessage(imsRegistrationTermination3);
                        this.imsRegistrationTermination = imsRegistrationTerminationArr2;
                        break;
                    case 144:
                        this.imsRegistrationTerminationPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 154:
                        int repeatedFieldArrayLength10 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 154);
                        ImsRegistrationStats[] imsRegistrationStatsArr = this.imsRegistrationStats;
                        int length10 = imsRegistrationStatsArr == null ? 0 : imsRegistrationStatsArr.length;
                        int i10 = repeatedFieldArrayLength10 + length10;
                        ImsRegistrationStats[] imsRegistrationStatsArr2 = new ImsRegistrationStats[i10];
                        if (length10 != 0) {
                            System.arraycopy(imsRegistrationStatsArr, 0, imsRegistrationStatsArr2, 0, length10);
                        }
                        while (length10 < i10 - 1) {
                            ImsRegistrationStats imsRegistrationStats2 = new ImsRegistrationStats();
                            imsRegistrationStatsArr2[length10] = imsRegistrationStats2;
                            codedInputByteBufferNano.readMessage(imsRegistrationStats2);
                            codedInputByteBufferNano.readTag();
                            length10++;
                        }
                        ImsRegistrationStats imsRegistrationStats3 = new ImsRegistrationStats();
                        imsRegistrationStatsArr2[length10] = imsRegistrationStats3;
                        codedInputByteBufferNano.readMessage(imsRegistrationStats3);
                        this.imsRegistrationStats = imsRegistrationStatsArr2;
                        break;
                    case SmsMessage.MAX_USER_DATA_SEPTETS:
                        this.imsRegistrationStatsPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 170:
                        this.buildFingerprint = codedInputByteBufferNano.readString();
                        break;
                    case 178:
                        int repeatedFieldArrayLength11 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 178);
                        NetworkRequests[] networkRequestsArr = this.networkRequests;
                        int length11 = networkRequestsArr == null ? 0 : networkRequestsArr.length;
                        int i11 = repeatedFieldArrayLength11 + length11;
                        NetworkRequests[] networkRequestsArr2 = new NetworkRequests[i11];
                        if (length11 != 0) {
                            System.arraycopy(networkRequestsArr, 0, networkRequestsArr2, 0, length11);
                        }
                        while (length11 < i11 - 1) {
                            NetworkRequests networkRequests2 = new NetworkRequests();
                            networkRequestsArr2[length11] = networkRequests2;
                            codedInputByteBufferNano.readMessage(networkRequests2);
                            codedInputByteBufferNano.readTag();
                            length11++;
                        }
                        NetworkRequests networkRequests3 = new NetworkRequests();
                        networkRequestsArr2[length11] = networkRequests3;
                        codedInputByteBufferNano.readMessage(networkRequests3);
                        this.networkRequests = networkRequestsArr2;
                        break;
                    case 184:
                        this.networkRequestsPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 194:
                        int repeatedFieldArrayLength12 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 194);
                        ImsRegistrationFeatureTagStats[] imsRegistrationFeatureTagStatsArr = this.imsRegistrationFeatureTagStats;
                        int length12 = imsRegistrationFeatureTagStatsArr == null ? 0 : imsRegistrationFeatureTagStatsArr.length;
                        int i12 = repeatedFieldArrayLength12 + length12;
                        ImsRegistrationFeatureTagStats[] imsRegistrationFeatureTagStatsArr2 = new ImsRegistrationFeatureTagStats[i12];
                        if (length12 != 0) {
                            System.arraycopy(imsRegistrationFeatureTagStatsArr, 0, imsRegistrationFeatureTagStatsArr2, 0, length12);
                        }
                        while (length12 < i12 - 1) {
                            ImsRegistrationFeatureTagStats imsRegistrationFeatureTagStats2 = new ImsRegistrationFeatureTagStats();
                            imsRegistrationFeatureTagStatsArr2[length12] = imsRegistrationFeatureTagStats2;
                            codedInputByteBufferNano.readMessage(imsRegistrationFeatureTagStats2);
                            codedInputByteBufferNano.readTag();
                            length12++;
                        }
                        ImsRegistrationFeatureTagStats imsRegistrationFeatureTagStats3 = new ImsRegistrationFeatureTagStats();
                        imsRegistrationFeatureTagStatsArr2[length12] = imsRegistrationFeatureTagStats3;
                        codedInputByteBufferNano.readMessage(imsRegistrationFeatureTagStats3);
                        this.imsRegistrationFeatureTagStats = imsRegistrationFeatureTagStatsArr2;
                        break;
                    case 200:
                        this.imsRegistrationFeatureTagStatsPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 210:
                        int repeatedFieldArrayLength13 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 210);
                        RcsClientProvisioningStats[] rcsClientProvisioningStatsArr = this.rcsClientProvisioningStats;
                        int length13 = rcsClientProvisioningStatsArr == null ? 0 : rcsClientProvisioningStatsArr.length;
                        int i13 = repeatedFieldArrayLength13 + length13;
                        RcsClientProvisioningStats[] rcsClientProvisioningStatsArr2 = new RcsClientProvisioningStats[i13];
                        if (length13 != 0) {
                            System.arraycopy(rcsClientProvisioningStatsArr, 0, rcsClientProvisioningStatsArr2, 0, length13);
                        }
                        while (length13 < i13 - 1) {
                            RcsClientProvisioningStats rcsClientProvisioningStats2 = new RcsClientProvisioningStats();
                            rcsClientProvisioningStatsArr2[length13] = rcsClientProvisioningStats2;
                            codedInputByteBufferNano.readMessage(rcsClientProvisioningStats2);
                            codedInputByteBufferNano.readTag();
                            length13++;
                        }
                        RcsClientProvisioningStats rcsClientProvisioningStats3 = new RcsClientProvisioningStats();
                        rcsClientProvisioningStatsArr2[length13] = rcsClientProvisioningStats3;
                        codedInputByteBufferNano.readMessage(rcsClientProvisioningStats3);
                        this.rcsClientProvisioningStats = rcsClientProvisioningStatsArr2;
                        break;
                    case 216:
                        this.rcsClientProvisioningStatsPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 226:
                        int repeatedFieldArrayLength14 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 226);
                        RcsAcsProvisioningStats[] rcsAcsProvisioningStatsArr = this.rcsAcsProvisioningStats;
                        int length14 = rcsAcsProvisioningStatsArr == null ? 0 : rcsAcsProvisioningStatsArr.length;
                        int i14 = repeatedFieldArrayLength14 + length14;
                        RcsAcsProvisioningStats[] rcsAcsProvisioningStatsArr2 = new RcsAcsProvisioningStats[i14];
                        if (length14 != 0) {
                            System.arraycopy(rcsAcsProvisioningStatsArr, 0, rcsAcsProvisioningStatsArr2, 0, length14);
                        }
                        while (length14 < i14 - 1) {
                            RcsAcsProvisioningStats rcsAcsProvisioningStats2 = new RcsAcsProvisioningStats();
                            rcsAcsProvisioningStatsArr2[length14] = rcsAcsProvisioningStats2;
                            codedInputByteBufferNano.readMessage(rcsAcsProvisioningStats2);
                            codedInputByteBufferNano.readTag();
                            length14++;
                        }
                        RcsAcsProvisioningStats rcsAcsProvisioningStats3 = new RcsAcsProvisioningStats();
                        rcsAcsProvisioningStatsArr2[length14] = rcsAcsProvisioningStats3;
                        codedInputByteBufferNano.readMessage(rcsAcsProvisioningStats3);
                        this.rcsAcsProvisioningStats = rcsAcsProvisioningStatsArr2;
                        break;
                    case 232:
                        this.rcsAcsProvisioningStatsPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 242:
                        int repeatedFieldArrayLength15 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 242);
                        SipDelegateStats[] sipDelegateStatsArr = this.sipDelegateStats;
                        int length15 = sipDelegateStatsArr == null ? 0 : sipDelegateStatsArr.length;
                        int i15 = repeatedFieldArrayLength15 + length15;
                        SipDelegateStats[] sipDelegateStatsArr2 = new SipDelegateStats[i15];
                        if (length15 != 0) {
                            System.arraycopy(sipDelegateStatsArr, 0, sipDelegateStatsArr2, 0, length15);
                        }
                        while (length15 < i15 - 1) {
                            SipDelegateStats sipDelegateStats2 = new SipDelegateStats();
                            sipDelegateStatsArr2[length15] = sipDelegateStats2;
                            codedInputByteBufferNano.readMessage(sipDelegateStats2);
                            codedInputByteBufferNano.readTag();
                            length15++;
                        }
                        SipDelegateStats sipDelegateStats3 = new SipDelegateStats();
                        sipDelegateStatsArr2[length15] = sipDelegateStats3;
                        codedInputByteBufferNano.readMessage(sipDelegateStats3);
                        this.sipDelegateStats = sipDelegateStatsArr2;
                        break;
                    case 248:
                        this.sipDelegateStatsPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case CallFailCause.RADIO_RELEASE_NORMAL:
                        int repeatedFieldArrayLength16 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, CallFailCause.RADIO_RELEASE_NORMAL);
                        SipTransportFeatureTagStats[] sipTransportFeatureTagStatsArr = this.sipTransportFeatureTagStats;
                        int length16 = sipTransportFeatureTagStatsArr == null ? 0 : sipTransportFeatureTagStatsArr.length;
                        int i16 = repeatedFieldArrayLength16 + length16;
                        SipTransportFeatureTagStats[] sipTransportFeatureTagStatsArr2 = new SipTransportFeatureTagStats[i16];
                        if (length16 != 0) {
                            System.arraycopy(sipTransportFeatureTagStatsArr, 0, sipTransportFeatureTagStatsArr2, 0, length16);
                        }
                        while (length16 < i16 - 1) {
                            SipTransportFeatureTagStats sipTransportFeatureTagStats2 = new SipTransportFeatureTagStats();
                            sipTransportFeatureTagStatsArr2[length16] = sipTransportFeatureTagStats2;
                            codedInputByteBufferNano.readMessage(sipTransportFeatureTagStats2);
                            codedInputByteBufferNano.readTag();
                            length16++;
                        }
                        SipTransportFeatureTagStats sipTransportFeatureTagStats3 = new SipTransportFeatureTagStats();
                        sipTransportFeatureTagStatsArr2[length16] = sipTransportFeatureTagStats3;
                        codedInputByteBufferNano.readMessage(sipTransportFeatureTagStats3);
                        this.sipTransportFeatureTagStats = sipTransportFeatureTagStatsArr2;
                        break;
                    case 264:
                        this.sipTransportFeatureTagStatsPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 274:
                        int repeatedFieldArrayLength17 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 274);
                        SipMessageResponse[] sipMessageResponseArr = this.sipMessageResponse;
                        int length17 = sipMessageResponseArr == null ? 0 : sipMessageResponseArr.length;
                        int i17 = repeatedFieldArrayLength17 + length17;
                        SipMessageResponse[] sipMessageResponseArr2 = new SipMessageResponse[i17];
                        if (length17 != 0) {
                            System.arraycopy(sipMessageResponseArr, 0, sipMessageResponseArr2, 0, length17);
                        }
                        while (length17 < i17 - 1) {
                            SipMessageResponse sipMessageResponse2 = new SipMessageResponse();
                            sipMessageResponseArr2[length17] = sipMessageResponse2;
                            codedInputByteBufferNano.readMessage(sipMessageResponse2);
                            codedInputByteBufferNano.readTag();
                            length17++;
                        }
                        SipMessageResponse sipMessageResponse3 = new SipMessageResponse();
                        sipMessageResponseArr2[length17] = sipMessageResponse3;
                        codedInputByteBufferNano.readMessage(sipMessageResponse3);
                        this.sipMessageResponse = sipMessageResponseArr2;
                        break;
                    case 280:
                        this.sipMessageResponsePullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 290:
                        int repeatedFieldArrayLength18 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 290);
                        SipTransportSession[] sipTransportSessionArr = this.sipTransportSession;
                        int length18 = sipTransportSessionArr == null ? 0 : sipTransportSessionArr.length;
                        int i18 = repeatedFieldArrayLength18 + length18;
                        SipTransportSession[] sipTransportSessionArr2 = new SipTransportSession[i18];
                        if (length18 != 0) {
                            System.arraycopy(sipTransportSessionArr, 0, sipTransportSessionArr2, 0, length18);
                        }
                        while (length18 < i18 - 1) {
                            SipTransportSession sipTransportSession2 = new SipTransportSession();
                            sipTransportSessionArr2[length18] = sipTransportSession2;
                            codedInputByteBufferNano.readMessage(sipTransportSession2);
                            codedInputByteBufferNano.readTag();
                            length18++;
                        }
                        SipTransportSession sipTransportSession3 = new SipTransportSession();
                        sipTransportSessionArr2[length18] = sipTransportSession3;
                        codedInputByteBufferNano.readMessage(sipTransportSession3);
                        this.sipTransportSession = sipTransportSessionArr2;
                        break;
                    case 296:
                        this.sipTransportSessionPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 306:
                        int repeatedFieldArrayLength19 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 306);
                        ImsDedicatedBearerListenerEvent[] imsDedicatedBearerListenerEventArr = this.imsDedicatedBearerListenerEvent;
                        int length19 = imsDedicatedBearerListenerEventArr == null ? 0 : imsDedicatedBearerListenerEventArr.length;
                        int i19 = repeatedFieldArrayLength19 + length19;
                        ImsDedicatedBearerListenerEvent[] imsDedicatedBearerListenerEventArr2 = new ImsDedicatedBearerListenerEvent[i19];
                        if (length19 != 0) {
                            System.arraycopy(imsDedicatedBearerListenerEventArr, 0, imsDedicatedBearerListenerEventArr2, 0, length19);
                        }
                        while (length19 < i19 - 1) {
                            ImsDedicatedBearerListenerEvent imsDedicatedBearerListenerEvent2 = new ImsDedicatedBearerListenerEvent();
                            imsDedicatedBearerListenerEventArr2[length19] = imsDedicatedBearerListenerEvent2;
                            codedInputByteBufferNano.readMessage(imsDedicatedBearerListenerEvent2);
                            codedInputByteBufferNano.readTag();
                            length19++;
                        }
                        ImsDedicatedBearerListenerEvent imsDedicatedBearerListenerEvent3 = new ImsDedicatedBearerListenerEvent();
                        imsDedicatedBearerListenerEventArr2[length19] = imsDedicatedBearerListenerEvent3;
                        codedInputByteBufferNano.readMessage(imsDedicatedBearerListenerEvent3);
                        this.imsDedicatedBearerListenerEvent = imsDedicatedBearerListenerEventArr2;
                        break;
                    case 312:
                        this.imsDedicatedBearerListenerEventPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 322:
                        int repeatedFieldArrayLength20 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 322);
                        ImsDedicatedBearerEvent[] imsDedicatedBearerEventArr = this.imsDedicatedBearerEvent;
                        int length20 = imsDedicatedBearerEventArr == null ? 0 : imsDedicatedBearerEventArr.length;
                        int i20 = repeatedFieldArrayLength20 + length20;
                        ImsDedicatedBearerEvent[] imsDedicatedBearerEventArr2 = new ImsDedicatedBearerEvent[i20];
                        if (length20 != 0) {
                            System.arraycopy(imsDedicatedBearerEventArr, 0, imsDedicatedBearerEventArr2, 0, length20);
                        }
                        while (length20 < i20 - 1) {
                            ImsDedicatedBearerEvent imsDedicatedBearerEvent2 = new ImsDedicatedBearerEvent();
                            imsDedicatedBearerEventArr2[length20] = imsDedicatedBearerEvent2;
                            codedInputByteBufferNano.readMessage(imsDedicatedBearerEvent2);
                            codedInputByteBufferNano.readTag();
                            length20++;
                        }
                        ImsDedicatedBearerEvent imsDedicatedBearerEvent3 = new ImsDedicatedBearerEvent();
                        imsDedicatedBearerEventArr2[length20] = imsDedicatedBearerEvent3;
                        codedInputByteBufferNano.readMessage(imsDedicatedBearerEvent3);
                        this.imsDedicatedBearerEvent = imsDedicatedBearerEventArr2;
                        break;
                    case 328:
                        this.imsDedicatedBearerEventPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 338:
                        int repeatedFieldArrayLength21 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 338);
                        ImsRegistrationServiceDescStats[] imsRegistrationServiceDescStatsArr = this.imsRegistrationServiceDescStats;
                        int length21 = imsRegistrationServiceDescStatsArr == null ? 0 : imsRegistrationServiceDescStatsArr.length;
                        int i21 = repeatedFieldArrayLength21 + length21;
                        ImsRegistrationServiceDescStats[] imsRegistrationServiceDescStatsArr2 = new ImsRegistrationServiceDescStats[i21];
                        if (length21 != 0) {
                            System.arraycopy(imsRegistrationServiceDescStatsArr, 0, imsRegistrationServiceDescStatsArr2, 0, length21);
                        }
                        while (length21 < i21 - 1) {
                            ImsRegistrationServiceDescStats imsRegistrationServiceDescStats2 = new ImsRegistrationServiceDescStats();
                            imsRegistrationServiceDescStatsArr2[length21] = imsRegistrationServiceDescStats2;
                            codedInputByteBufferNano.readMessage(imsRegistrationServiceDescStats2);
                            codedInputByteBufferNano.readTag();
                            length21++;
                        }
                        ImsRegistrationServiceDescStats imsRegistrationServiceDescStats3 = new ImsRegistrationServiceDescStats();
                        imsRegistrationServiceDescStatsArr2[length21] = imsRegistrationServiceDescStats3;
                        codedInputByteBufferNano.readMessage(imsRegistrationServiceDescStats3);
                        this.imsRegistrationServiceDescStats = imsRegistrationServiceDescStatsArr2;
                        break;
                    case 344:
                        this.imsRegistrationServiceDescStatsPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 354:
                        int repeatedFieldArrayLength22 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 354);
                        UceEventStats[] uceEventStatsArr = this.uceEventStats;
                        int length22 = uceEventStatsArr == null ? 0 : uceEventStatsArr.length;
                        int i22 = repeatedFieldArrayLength22 + length22;
                        UceEventStats[] uceEventStatsArr2 = new UceEventStats[i22];
                        if (length22 != 0) {
                            System.arraycopy(uceEventStatsArr, 0, uceEventStatsArr2, 0, length22);
                        }
                        while (length22 < i22 - 1) {
                            UceEventStats uceEventStats2 = new UceEventStats();
                            uceEventStatsArr2[length22] = uceEventStats2;
                            codedInputByteBufferNano.readMessage(uceEventStats2);
                            codedInputByteBufferNano.readTag();
                            length22++;
                        }
                        UceEventStats uceEventStats3 = new UceEventStats();
                        uceEventStatsArr2[length22] = uceEventStats3;
                        codedInputByteBufferNano.readMessage(uceEventStats3);
                        this.uceEventStats = uceEventStatsArr2;
                        break;
                    case 360:
                        this.uceEventStatsPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 370:
                        int repeatedFieldArrayLength23 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 370);
                        PresenceNotifyEvent[] presenceNotifyEventArr = this.presenceNotifyEvent;
                        int length23 = presenceNotifyEventArr == null ? 0 : presenceNotifyEventArr.length;
                        int i23 = repeatedFieldArrayLength23 + length23;
                        PresenceNotifyEvent[] presenceNotifyEventArr2 = new PresenceNotifyEvent[i23];
                        if (length23 != 0) {
                            System.arraycopy(presenceNotifyEventArr, 0, presenceNotifyEventArr2, 0, length23);
                        }
                        while (length23 < i23 - 1) {
                            PresenceNotifyEvent presenceNotifyEvent2 = new PresenceNotifyEvent();
                            presenceNotifyEventArr2[length23] = presenceNotifyEvent2;
                            codedInputByteBufferNano.readMessage(presenceNotifyEvent2);
                            codedInputByteBufferNano.readTag();
                            length23++;
                        }
                        PresenceNotifyEvent presenceNotifyEvent3 = new PresenceNotifyEvent();
                        presenceNotifyEventArr2[length23] = presenceNotifyEvent3;
                        codedInputByteBufferNano.readMessage(presenceNotifyEvent3);
                        this.presenceNotifyEvent = presenceNotifyEventArr2;
                        break;
                    case 376:
                        this.presenceNotifyEventPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 386:
                        int repeatedFieldArrayLength24 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 386);
                        GbaEvent[] gbaEventArr = this.gbaEvent;
                        int length24 = gbaEventArr == null ? 0 : gbaEventArr.length;
                        int i24 = repeatedFieldArrayLength24 + length24;
                        GbaEvent[] gbaEventArr2 = new GbaEvent[i24];
                        if (length24 != 0) {
                            System.arraycopy(gbaEventArr, 0, gbaEventArr2, 0, length24);
                        }
                        while (length24 < i24 - 1) {
                            GbaEvent gbaEvent2 = new GbaEvent();
                            gbaEventArr2[length24] = gbaEvent2;
                            codedInputByteBufferNano.readMessage(gbaEvent2);
                            codedInputByteBufferNano.readTag();
                            length24++;
                        }
                        GbaEvent gbaEvent3 = new GbaEvent();
                        gbaEventArr2[length24] = gbaEvent3;
                        codedInputByteBufferNano.readMessage(gbaEvent3);
                        this.gbaEvent = gbaEventArr2;
                        break;
                    case 392:
                        this.gbaEventPullTimestampMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 402:
                        int repeatedFieldArrayLength25 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 402);
                        NetworkRequestsV2[] networkRequestsV2Arr = this.networkRequestsV2;
                        int length25 = networkRequestsV2Arr == null ? 0 : networkRequestsV2Arr.length;
                        int i25 = repeatedFieldArrayLength25 + length25;
                        NetworkRequestsV2[] networkRequestsV2Arr2 = new NetworkRequestsV2[i25];
                        if (length25 != 0) {
                            System.arraycopy(networkRequestsV2Arr, 0, networkRequestsV2Arr2, 0, length25);
                        }
                        while (length25 < i25 - 1) {
                            NetworkRequestsV2 networkRequestsV22 = new NetworkRequestsV2();
                            networkRequestsV2Arr2[length25] = networkRequestsV22;
                            codedInputByteBufferNano.readMessage(networkRequestsV22);
                            codedInputByteBufferNano.readTag();
                            length25++;
                        }
                        NetworkRequestsV2 networkRequestsV23 = new NetworkRequestsV2();
                        networkRequestsV2Arr2[length25] = networkRequestsV23;
                        codedInputByteBufferNano.readMessage(networkRequestsV23);
                        this.networkRequestsV2 = networkRequestsV2Arr2;
                        break;
                    case 408:
                        this.networkRequestsV2PullTimestampMillis = codedInputByteBufferNano.readInt64();
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

        public static PersistAtoms parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (PersistAtoms) MessageNano.mergeFrom(new PersistAtoms(), bArr);
        }

        public static PersistAtoms parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new PersistAtoms().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class VoiceCallSession extends ExtendableMessageNano<VoiceCallSession> {
        private static volatile VoiceCallSession[] _emptyArray;
        public int bandAtEnd;
        public int bearerAtEnd;
        public int bearerAtStart;
        public int callDuration;
        public int carrierId;
        public long codecBitmask;
        public int concurrentCallCountAtEnd;
        public int concurrentCallCountAtStart;
        public int direction;
        public int disconnectExtraCode;
        public String disconnectExtraMessage;
        public int disconnectReasonCode;
        public boolean isEmergency;
        public boolean isEsim;
        public boolean isMultiSim;
        public boolean isMultiparty;
        public boolean isRoaming;
        public int mainCodecQuality;
        public int ratAtConnected;
        public int ratAtEnd;
        public int ratAtStart;
        public long ratSwitchCount;
        public boolean rttEnabled;
        public long setupBeginMillis;
        public int setupDuration;
        public int setupDurationMillis;
        public boolean setupFailed;
        public int signalStrengthAtEnd;
        public int simSlotIndex;
        public long srvccCancellationCount;
        public boolean srvccCompleted;
        public long srvccFailureCount;
        public boolean videoEnabled;

        public static VoiceCallSession[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new VoiceCallSession[0];
                    }
                }
            }
            return _emptyArray;
        }

        public VoiceCallSession() {
            clear();
        }

        public VoiceCallSession clear() {
            this.bearerAtStart = 0;
            this.bearerAtEnd = 0;
            this.direction = 0;
            this.setupDuration = 0;
            this.setupFailed = false;
            this.disconnectReasonCode = 0;
            this.disconnectExtraCode = 0;
            this.disconnectExtraMessage = "";
            this.ratAtStart = 0;
            this.ratAtEnd = 0;
            this.ratSwitchCount = 0;
            this.codecBitmask = 0;
            this.concurrentCallCountAtStart = 0;
            this.concurrentCallCountAtEnd = 0;
            this.simSlotIndex = 0;
            this.isMultiSim = false;
            this.isEsim = false;
            this.carrierId = 0;
            this.srvccCompleted = false;
            this.srvccFailureCount = 0;
            this.srvccCancellationCount = 0;
            this.rttEnabled = false;
            this.isEmergency = false;
            this.isRoaming = false;
            this.signalStrengthAtEnd = 0;
            this.bandAtEnd = 0;
            this.setupDurationMillis = 0;
            this.mainCodecQuality = 0;
            this.videoEnabled = false;
            this.ratAtConnected = 0;
            this.isMultiparty = false;
            this.callDuration = 0;
            this.setupBeginMillis = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.bearerAtStart;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.bearerAtEnd;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.direction;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.setupDuration;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
            }
            boolean z = this.setupFailed;
            if (z) {
                codedOutputByteBufferNano.writeBool(5, z);
            }
            int i5 = this.disconnectReasonCode;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i5);
            }
            int i6 = this.disconnectExtraCode;
            if (i6 != 0) {
                codedOutputByteBufferNano.writeInt32(7, i6);
            }
            if (!this.disconnectExtraMessage.equals("")) {
                codedOutputByteBufferNano.writeString(8, this.disconnectExtraMessage);
            }
            int i7 = this.ratAtStart;
            if (i7 != 0) {
                codedOutputByteBufferNano.writeInt32(9, i7);
            }
            int i8 = this.ratAtEnd;
            if (i8 != 0) {
                codedOutputByteBufferNano.writeInt32(10, i8);
            }
            long j = this.ratSwitchCount;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(11, j);
            }
            long j2 = this.codecBitmask;
            if (j2 != 0) {
                codedOutputByteBufferNano.writeInt64(12, j2);
            }
            int i9 = this.concurrentCallCountAtStart;
            if (i9 != 0) {
                codedOutputByteBufferNano.writeInt32(13, i9);
            }
            int i10 = this.concurrentCallCountAtEnd;
            if (i10 != 0) {
                codedOutputByteBufferNano.writeInt32(14, i10);
            }
            int i11 = this.simSlotIndex;
            if (i11 != 0) {
                codedOutputByteBufferNano.writeInt32(15, i11);
            }
            boolean z2 = this.isMultiSim;
            if (z2) {
                codedOutputByteBufferNano.writeBool(16, z2);
            }
            boolean z3 = this.isEsim;
            if (z3) {
                codedOutputByteBufferNano.writeBool(17, z3);
            }
            int i12 = this.carrierId;
            if (i12 != 0) {
                codedOutputByteBufferNano.writeInt32(18, i12);
            }
            boolean z4 = this.srvccCompleted;
            if (z4) {
                codedOutputByteBufferNano.writeBool(19, z4);
            }
            long j3 = this.srvccFailureCount;
            if (j3 != 0) {
                codedOutputByteBufferNano.writeInt64(20, j3);
            }
            long j4 = this.srvccCancellationCount;
            if (j4 != 0) {
                codedOutputByteBufferNano.writeInt64(21, j4);
            }
            boolean z5 = this.rttEnabled;
            if (z5) {
                codedOutputByteBufferNano.writeBool(22, z5);
            }
            boolean z6 = this.isEmergency;
            if (z6) {
                codedOutputByteBufferNano.writeBool(23, z6);
            }
            boolean z7 = this.isRoaming;
            if (z7) {
                codedOutputByteBufferNano.writeBool(24, z7);
            }
            int i13 = this.signalStrengthAtEnd;
            if (i13 != 0) {
                codedOutputByteBufferNano.writeInt32(25, i13);
            }
            int i14 = this.bandAtEnd;
            if (i14 != 0) {
                codedOutputByteBufferNano.writeInt32(26, i14);
            }
            int i15 = this.setupDurationMillis;
            if (i15 != 0) {
                codedOutputByteBufferNano.writeInt32(27, i15);
            }
            int i16 = this.mainCodecQuality;
            if (i16 != 0) {
                codedOutputByteBufferNano.writeInt32(28, i16);
            }
            boolean z8 = this.videoEnabled;
            if (z8) {
                codedOutputByteBufferNano.writeBool(29, z8);
            }
            int i17 = this.ratAtConnected;
            if (i17 != 0) {
                codedOutputByteBufferNano.writeInt32(30, i17);
            }
            boolean z9 = this.isMultiparty;
            if (z9) {
                codedOutputByteBufferNano.writeBool(31, z9);
            }
            int i18 = this.callDuration;
            if (i18 != 0) {
                codedOutputByteBufferNano.writeInt32(32, i18);
            }
            long j5 = this.setupBeginMillis;
            if (j5 != 0) {
                codedOutputByteBufferNano.writeInt64(10001, j5);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.bearerAtStart;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            int i2 = this.bearerAtEnd;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.direction;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.setupDuration;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
            }
            boolean z = this.setupFailed;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(5, z);
            }
            int i5 = this.disconnectReasonCode;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i5);
            }
            int i6 = this.disconnectExtraCode;
            if (i6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(7, i6);
            }
            if (!this.disconnectExtraMessage.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(8, this.disconnectExtraMessage);
            }
            int i7 = this.ratAtStart;
            if (i7 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(9, i7);
            }
            int i8 = this.ratAtEnd;
            if (i8 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(10, i8);
            }
            long j = this.ratSwitchCount;
            if (j != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(11, j);
            }
            long j2 = this.codecBitmask;
            if (j2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(12, j2);
            }
            int i9 = this.concurrentCallCountAtStart;
            if (i9 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(13, i9);
            }
            int i10 = this.concurrentCallCountAtEnd;
            if (i10 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(14, i10);
            }
            int i11 = this.simSlotIndex;
            if (i11 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(15, i11);
            }
            boolean z2 = this.isMultiSim;
            if (z2) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(16, z2);
            }
            boolean z3 = this.isEsim;
            if (z3) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(17, z3);
            }
            int i12 = this.carrierId;
            if (i12 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(18, i12);
            }
            boolean z4 = this.srvccCompleted;
            if (z4) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(19, z4);
            }
            long j3 = this.srvccFailureCount;
            if (j3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(20, j3);
            }
            long j4 = this.srvccCancellationCount;
            if (j4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(21, j4);
            }
            boolean z5 = this.rttEnabled;
            if (z5) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(22, z5);
            }
            boolean z6 = this.isEmergency;
            if (z6) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(23, z6);
            }
            boolean z7 = this.isRoaming;
            if (z7) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(24, z7);
            }
            int i13 = this.signalStrengthAtEnd;
            if (i13 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(25, i13);
            }
            int i14 = this.bandAtEnd;
            if (i14 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(26, i14);
            }
            int i15 = this.setupDurationMillis;
            if (i15 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(27, i15);
            }
            int i16 = this.mainCodecQuality;
            if (i16 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(28, i16);
            }
            boolean z8 = this.videoEnabled;
            if (z8) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(29, z8);
            }
            int i17 = this.ratAtConnected;
            if (i17 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(30, i17);
            }
            boolean z9 = this.isMultiparty;
            if (z9) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(31, z9);
            }
            int i18 = this.callDuration;
            if (i18 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(32, i18);
            }
            long j5 = this.setupBeginMillis;
            return j5 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(10001, j5) : computeSerializedSize;
        }

        public VoiceCallSession mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                switch (readTag) {
                    case 0:
                        return this;
                    case 8:
                        this.bearerAtStart = codedInputByteBufferNano.readInt32();
                        break;
                    case 16:
                        this.bearerAtEnd = codedInputByteBufferNano.readInt32();
                        break;
                    case 24:
                        this.direction = codedInputByteBufferNano.readInt32();
                        break;
                    case 32:
                        this.setupDuration = codedInputByteBufferNano.readInt32();
                        break;
                    case 40:
                        this.setupFailed = codedInputByteBufferNano.readBool();
                        break;
                    case 48:
                        this.disconnectReasonCode = codedInputByteBufferNano.readInt32();
                        break;
                    case 56:
                        this.disconnectExtraCode = codedInputByteBufferNano.readInt32();
                        break;
                    case 66:
                        this.disconnectExtraMessage = codedInputByteBufferNano.readString();
                        break;
                    case 72:
                        this.ratAtStart = codedInputByteBufferNano.readInt32();
                        break;
                    case 80:
                        this.ratAtEnd = codedInputByteBufferNano.readInt32();
                        break;
                    case 88:
                        this.ratSwitchCount = codedInputByteBufferNano.readInt64();
                        break;
                    case 96:
                        this.codecBitmask = codedInputByteBufferNano.readInt64();
                        break;
                    case 104:
                        this.concurrentCallCountAtStart = codedInputByteBufferNano.readInt32();
                        break;
                    case 112:
                        this.concurrentCallCountAtEnd = codedInputByteBufferNano.readInt32();
                        break;
                    case 120:
                        this.simSlotIndex = codedInputByteBufferNano.readInt32();
                        break;
                    case 128:
                        this.isMultiSim = codedInputByteBufferNano.readBool();
                        break;
                    case NetworkStackConstants.ICMPV6_NEIGHBOR_ADVERTISEMENT /*136*/:
                        this.isEsim = codedInputByteBufferNano.readBool();
                        break;
                    case 144:
                        this.carrierId = codedInputByteBufferNano.readInt32();
                        break;
                    case 152:
                        this.srvccCompleted = codedInputByteBufferNano.readBool();
                        break;
                    case SmsMessage.MAX_USER_DATA_SEPTETS:
                        this.srvccFailureCount = codedInputByteBufferNano.readInt64();
                        break;
                    case 168:
                        this.srvccCancellationCount = codedInputByteBufferNano.readInt64();
                        break;
                    case 176:
                        this.rttEnabled = codedInputByteBufferNano.readBool();
                        break;
                    case 184:
                        this.isEmergency = codedInputByteBufferNano.readBool();
                        break;
                    case DnsPacket.DnsRecord.NAME_COMPRESSION /*192*/:
                        this.isRoaming = codedInputByteBufferNano.readBool();
                        break;
                    case 200:
                        this.signalStrengthAtEnd = codedInputByteBufferNano.readInt32();
                        break;
                    case BerTlv.BER_PROACTIVE_COMMAND_TAG:
                        this.bandAtEnd = codedInputByteBufferNano.readInt32();
                        break;
                    case 216:
                        this.setupDurationMillis = codedInputByteBufferNano.readInt32();
                        break;
                    case 224:
                        this.mainCodecQuality = codedInputByteBufferNano.readInt32();
                        break;
                    case 232:
                        this.videoEnabled = codedInputByteBufferNano.readBool();
                        break;
                    case 240:
                        this.ratAtConnected = codedInputByteBufferNano.readInt32();
                        break;
                    case 248:
                        this.isMultiparty = codedInputByteBufferNano.readBool();
                        break;
                    case 256:
                        this.callDuration = codedInputByteBufferNano.readInt32();
                        break;
                    case 80008:
                        this.setupBeginMillis = codedInputByteBufferNano.readInt64();
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

        public static VoiceCallSession parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (VoiceCallSession) MessageNano.mergeFrom(new VoiceCallSession(), bArr);
        }

        public static VoiceCallSession parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new VoiceCallSession().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class VoiceCallRatUsage extends ExtendableMessageNano<VoiceCallRatUsage> {
        private static volatile VoiceCallRatUsage[] _emptyArray;
        public long callCount;
        public int carrierId;
        public int rat;
        public long totalDurationMillis;

        public static VoiceCallRatUsage[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new VoiceCallRatUsage[0];
                    }
                }
            }
            return _emptyArray;
        }

        public VoiceCallRatUsage() {
            clear();
        }

        public VoiceCallRatUsage clear() {
            this.carrierId = 0;
            this.rat = 0;
            this.totalDurationMillis = 0;
            this.callCount = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.rat;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            long j = this.totalDurationMillis;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(3, j);
            }
            long j2 = this.callCount;
            if (j2 != 0) {
                codedOutputByteBufferNano.writeInt64(4, j2);
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
            int i2 = this.rat;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            long j = this.totalDurationMillis;
            if (j != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(3, j);
            }
            long j2 = this.callCount;
            return j2 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(4, j2) : computeSerializedSize;
        }

        public VoiceCallRatUsage mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.rat = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.totalDurationMillis = codedInputByteBufferNano.readInt64();
                } else if (readTag == 32) {
                    this.callCount = codedInputByteBufferNano.readInt64();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static VoiceCallRatUsage parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (VoiceCallRatUsage) MessageNano.mergeFrom(new VoiceCallRatUsage(), bArr);
        }

        public static VoiceCallRatUsage parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new VoiceCallRatUsage().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class IncomingSms extends ExtendableMessageNano<IncomingSms> {
        private static volatile IncomingSms[] _emptyArray;
        public boolean blocked;
        public int carrierId;
        public int error;
        public boolean isEsim;
        public boolean isMultiSim;
        public boolean isRoaming;
        public long messageId;
        public int rat;
        public int receivedParts;
        public int simSlotIndex;
        public int smsFormat;
        public int smsTech;
        public int smsType;
        public int totalParts;

        public static IncomingSms[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new IncomingSms[0];
                    }
                }
            }
            return _emptyArray;
        }

        public IncomingSms() {
            clear();
        }

        public IncomingSms clear() {
            this.smsFormat = 0;
            this.smsTech = 0;
            this.rat = 0;
            this.smsType = 0;
            this.totalParts = 0;
            this.receivedParts = 0;
            this.blocked = false;
            this.error = 0;
            this.isRoaming = false;
            this.simSlotIndex = 0;
            this.isMultiSim = false;
            this.isEsim = false;
            this.carrierId = 0;
            this.messageId = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.smsFormat;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.smsTech;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.rat;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.smsType;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
            }
            int i5 = this.totalParts;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i5);
            }
            int i6 = this.receivedParts;
            if (i6 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i6);
            }
            boolean z = this.blocked;
            if (z) {
                codedOutputByteBufferNano.writeBool(7, z);
            }
            int i7 = this.error;
            if (i7 != 0) {
                codedOutputByteBufferNano.writeInt32(8, i7);
            }
            boolean z2 = this.isRoaming;
            if (z2) {
                codedOutputByteBufferNano.writeBool(9, z2);
            }
            int i8 = this.simSlotIndex;
            if (i8 != 0) {
                codedOutputByteBufferNano.writeInt32(10, i8);
            }
            boolean z3 = this.isMultiSim;
            if (z3) {
                codedOutputByteBufferNano.writeBool(11, z3);
            }
            boolean z4 = this.isEsim;
            if (z4) {
                codedOutputByteBufferNano.writeBool(12, z4);
            }
            int i9 = this.carrierId;
            if (i9 != 0) {
                codedOutputByteBufferNano.writeInt32(13, i9);
            }
            long j = this.messageId;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(14, j);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.smsFormat;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            int i2 = this.smsTech;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.rat;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.smsType;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
            }
            int i5 = this.totalParts;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i5);
            }
            int i6 = this.receivedParts;
            if (i6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i6);
            }
            boolean z = this.blocked;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(7, z);
            }
            int i7 = this.error;
            if (i7 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(8, i7);
            }
            boolean z2 = this.isRoaming;
            if (z2) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(9, z2);
            }
            int i8 = this.simSlotIndex;
            if (i8 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(10, i8);
            }
            boolean z3 = this.isMultiSim;
            if (z3) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(11, z3);
            }
            boolean z4 = this.isEsim;
            if (z4) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(12, z4);
            }
            int i9 = this.carrierId;
            if (i9 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(13, i9);
            }
            long j = this.messageId;
            return j != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(14, j) : computeSerializedSize;
        }

        public IncomingSms mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                switch (readTag) {
                    case 0:
                        return this;
                    case 8:
                        this.smsFormat = codedInputByteBufferNano.readInt32();
                        break;
                    case 16:
                        this.smsTech = codedInputByteBufferNano.readInt32();
                        break;
                    case 24:
                        this.rat = codedInputByteBufferNano.readInt32();
                        break;
                    case 32:
                        this.smsType = codedInputByteBufferNano.readInt32();
                        break;
                    case 40:
                        this.totalParts = codedInputByteBufferNano.readInt32();
                        break;
                    case 48:
                        this.receivedParts = codedInputByteBufferNano.readInt32();
                        break;
                    case 56:
                        this.blocked = codedInputByteBufferNano.readBool();
                        break;
                    case 64:
                        this.error = codedInputByteBufferNano.readInt32();
                        break;
                    case 72:
                        this.isRoaming = codedInputByteBufferNano.readBool();
                        break;
                    case 80:
                        this.simSlotIndex = codedInputByteBufferNano.readInt32();
                        break;
                    case 88:
                        this.isMultiSim = codedInputByteBufferNano.readBool();
                        break;
                    case 96:
                        this.isEsim = codedInputByteBufferNano.readBool();
                        break;
                    case 104:
                        this.carrierId = codedInputByteBufferNano.readInt32();
                        break;
                    case 112:
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

        public static IncomingSms parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (IncomingSms) MessageNano.mergeFrom(new IncomingSms(), bArr);
        }

        public static IncomingSms parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new IncomingSms().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class OutgoingSms extends ExtendableMessageNano<OutgoingSms> {
        private static volatile OutgoingSms[] _emptyArray;
        public int carrierId;
        public int errorCode;
        public long intervalMillis;
        public boolean isEsim;
        public boolean isFromDefaultApp;
        public boolean isMultiSim;
        public boolean isRoaming;
        public long messageId;
        public int rat;
        public int retryId;
        public int sendResult;
        public int simSlotIndex;
        public int smsFormat;
        public int smsTech;

        public static OutgoingSms[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new OutgoingSms[0];
                    }
                }
            }
            return _emptyArray;
        }

        public OutgoingSms() {
            clear();
        }

        public OutgoingSms clear() {
            this.smsFormat = 0;
            this.smsTech = 0;
            this.rat = 0;
            this.sendResult = 0;
            this.errorCode = 0;
            this.isRoaming = false;
            this.isFromDefaultApp = false;
            this.simSlotIndex = 0;
            this.isMultiSim = false;
            this.isEsim = false;
            this.carrierId = 0;
            this.messageId = 0;
            this.retryId = 0;
            this.intervalMillis = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.smsFormat;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.smsTech;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.rat;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.sendResult;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
            }
            int i5 = this.errorCode;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i5);
            }
            boolean z = this.isRoaming;
            if (z) {
                codedOutputByteBufferNano.writeBool(6, z);
            }
            boolean z2 = this.isFromDefaultApp;
            if (z2) {
                codedOutputByteBufferNano.writeBool(7, z2);
            }
            int i6 = this.simSlotIndex;
            if (i6 != 0) {
                codedOutputByteBufferNano.writeInt32(8, i6);
            }
            boolean z3 = this.isMultiSim;
            if (z3) {
                codedOutputByteBufferNano.writeBool(9, z3);
            }
            boolean z4 = this.isEsim;
            if (z4) {
                codedOutputByteBufferNano.writeBool(10, z4);
            }
            int i7 = this.carrierId;
            if (i7 != 0) {
                codedOutputByteBufferNano.writeInt32(11, i7);
            }
            long j = this.messageId;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(12, j);
            }
            int i8 = this.retryId;
            if (i8 != 0) {
                codedOutputByteBufferNano.writeInt32(13, i8);
            }
            long j2 = this.intervalMillis;
            if (j2 != 0) {
                codedOutputByteBufferNano.writeInt64(14, j2);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.smsFormat;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            int i2 = this.smsTech;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.rat;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.sendResult;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
            }
            int i5 = this.errorCode;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i5);
            }
            boolean z = this.isRoaming;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(6, z);
            }
            boolean z2 = this.isFromDefaultApp;
            if (z2) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(7, z2);
            }
            int i6 = this.simSlotIndex;
            if (i6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(8, i6);
            }
            boolean z3 = this.isMultiSim;
            if (z3) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(9, z3);
            }
            boolean z4 = this.isEsim;
            if (z4) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(10, z4);
            }
            int i7 = this.carrierId;
            if (i7 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(11, i7);
            }
            long j = this.messageId;
            if (j != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(12, j);
            }
            int i8 = this.retryId;
            if (i8 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(13, i8);
            }
            long j2 = this.intervalMillis;
            return j2 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(14, j2) : computeSerializedSize;
        }

        public OutgoingSms mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                switch (readTag) {
                    case 0:
                        return this;
                    case 8:
                        this.smsFormat = codedInputByteBufferNano.readInt32();
                        break;
                    case 16:
                        this.smsTech = codedInputByteBufferNano.readInt32();
                        break;
                    case 24:
                        this.rat = codedInputByteBufferNano.readInt32();
                        break;
                    case 32:
                        this.sendResult = codedInputByteBufferNano.readInt32();
                        break;
                    case 40:
                        this.errorCode = codedInputByteBufferNano.readInt32();
                        break;
                    case 48:
                        this.isRoaming = codedInputByteBufferNano.readBool();
                        break;
                    case 56:
                        this.isFromDefaultApp = codedInputByteBufferNano.readBool();
                        break;
                    case 64:
                        this.simSlotIndex = codedInputByteBufferNano.readInt32();
                        break;
                    case 72:
                        this.isMultiSim = codedInputByteBufferNano.readBool();
                        break;
                    case 80:
                        this.isEsim = codedInputByteBufferNano.readBool();
                        break;
                    case 88:
                        this.carrierId = codedInputByteBufferNano.readInt32();
                        break;
                    case 96:
                        this.messageId = codedInputByteBufferNano.readInt64();
                        break;
                    case 104:
                        this.retryId = codedInputByteBufferNano.readInt32();
                        break;
                    case 112:
                        this.intervalMillis = codedInputByteBufferNano.readInt64();
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

        public static OutgoingSms parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (OutgoingSms) MessageNano.mergeFrom(new OutgoingSms(), bArr);
        }

        public static OutgoingSms parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new OutgoingSms().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class CarrierIdMismatch extends ExtendableMessageNano<CarrierIdMismatch> {
        private static volatile CarrierIdMismatch[] _emptyArray;
        public String gid1;
        public String mccMnc;
        public String pnn;
        public String spn;

        public static CarrierIdMismatch[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new CarrierIdMismatch[0];
                    }
                }
            }
            return _emptyArray;
        }

        public CarrierIdMismatch() {
            clear();
        }

        public CarrierIdMismatch clear() {
            this.mccMnc = "";
            this.gid1 = "";
            this.spn = "";
            this.pnn = "";
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            if (!this.mccMnc.equals("")) {
                codedOutputByteBufferNano.writeString(1, this.mccMnc);
            }
            if (!this.gid1.equals("")) {
                codedOutputByteBufferNano.writeString(2, this.gid1);
            }
            if (!this.spn.equals("")) {
                codedOutputByteBufferNano.writeString(3, this.spn);
            }
            if (!this.pnn.equals("")) {
                codedOutputByteBufferNano.writeString(4, this.pnn);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            if (!this.mccMnc.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(1, this.mccMnc);
            }
            if (!this.gid1.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(2, this.gid1);
            }
            if (!this.spn.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(3, this.spn);
            }
            return !this.pnn.equals("") ? computeSerializedSize + CodedOutputByteBufferNano.computeStringSize(4, this.pnn) : computeSerializedSize;
        }

        public CarrierIdMismatch mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 10) {
                    this.mccMnc = codedInputByteBufferNano.readString();
                } else if (readTag == 18) {
                    this.gid1 = codedInputByteBufferNano.readString();
                } else if (readTag == 26) {
                    this.spn = codedInputByteBufferNano.readString();
                } else if (readTag == 34) {
                    this.pnn = codedInputByteBufferNano.readString();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static CarrierIdMismatch parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (CarrierIdMismatch) MessageNano.mergeFrom(new CarrierIdMismatch(), bArr);
        }

        public static CarrierIdMismatch parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new CarrierIdMismatch().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class DataCallSession extends ExtendableMessageNano<DataCallSession> {
        private static volatile DataCallSession[] _emptyArray;
        public int apnTypeBitmask;
        public int bandAtEnd;
        public int carrierId;
        public int deactivateReason;
        public int dimension;
        public long durationMinutes;
        public int failureCause;
        public int[] handoverFailureCauses;
        public int ipType;
        public boolean isEsim;
        public boolean isMultiSim;
        public boolean isOpportunistic;
        public boolean isRoaming;
        public boolean ongoing;
        public boolean oosAtEnd;
        public int ratAtEnd;
        public long ratSwitchCount;
        public boolean setupFailed;
        public int suggestedRetryMillis;

        public static DataCallSession[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new DataCallSession[0];
                    }
                }
            }
            return _emptyArray;
        }

        public DataCallSession() {
            clear();
        }

        public DataCallSession clear() {
            this.dimension = 0;
            this.isMultiSim = false;
            this.isEsim = false;
            this.apnTypeBitmask = 0;
            this.carrierId = 0;
            this.isRoaming = false;
            this.ratAtEnd = 0;
            this.oosAtEnd = false;
            this.ratSwitchCount = 0;
            this.isOpportunistic = false;
            this.ipType = 0;
            this.setupFailed = false;
            this.failureCause = 0;
            this.suggestedRetryMillis = 0;
            this.deactivateReason = 0;
            this.durationMinutes = 0;
            this.ongoing = false;
            this.bandAtEnd = 0;
            this.handoverFailureCauses = WireFormatNano.EMPTY_INT_ARRAY;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.dimension;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            boolean z = this.isMultiSim;
            if (z) {
                codedOutputByteBufferNano.writeBool(2, z);
            }
            boolean z2 = this.isEsim;
            if (z2) {
                codedOutputByteBufferNano.writeBool(3, z2);
            }
            int i2 = this.apnTypeBitmask;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i2);
            }
            int i3 = this.carrierId;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i3);
            }
            boolean z3 = this.isRoaming;
            if (z3) {
                codedOutputByteBufferNano.writeBool(7, z3);
            }
            int i4 = this.ratAtEnd;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(8, i4);
            }
            boolean z4 = this.oosAtEnd;
            if (z4) {
                codedOutputByteBufferNano.writeBool(9, z4);
            }
            long j = this.ratSwitchCount;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(10, j);
            }
            boolean z5 = this.isOpportunistic;
            if (z5) {
                codedOutputByteBufferNano.writeBool(11, z5);
            }
            int i5 = this.ipType;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(12, i5);
            }
            boolean z6 = this.setupFailed;
            if (z6) {
                codedOutputByteBufferNano.writeBool(13, z6);
            }
            int i6 = this.failureCause;
            if (i6 != 0) {
                codedOutputByteBufferNano.writeInt32(14, i6);
            }
            int i7 = this.suggestedRetryMillis;
            if (i7 != 0) {
                codedOutputByteBufferNano.writeInt32(15, i7);
            }
            int i8 = this.deactivateReason;
            if (i8 != 0) {
                codedOutputByteBufferNano.writeInt32(16, i8);
            }
            long j2 = this.durationMinutes;
            if (j2 != 0) {
                codedOutputByteBufferNano.writeInt64(17, j2);
            }
            boolean z7 = this.ongoing;
            if (z7) {
                codedOutputByteBufferNano.writeBool(18, z7);
            }
            int i9 = this.bandAtEnd;
            if (i9 != 0) {
                codedOutputByteBufferNano.writeInt32(19, i9);
            }
            int[] iArr = this.handoverFailureCauses;
            if (iArr != null && iArr.length > 0) {
                int i10 = 0;
                while (true) {
                    int[] iArr2 = this.handoverFailureCauses;
                    if (i10 >= iArr2.length) {
                        break;
                    }
                    codedOutputByteBufferNano.writeInt32(20, iArr2[i10]);
                    i10++;
                }
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.dimension;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            boolean z = this.isMultiSim;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(2, z);
            }
            boolean z2 = this.isEsim;
            if (z2) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(3, z2);
            }
            int i2 = this.apnTypeBitmask;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i2);
            }
            int i3 = this.carrierId;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i3);
            }
            boolean z3 = this.isRoaming;
            if (z3) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(7, z3);
            }
            int i4 = this.ratAtEnd;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(8, i4);
            }
            boolean z4 = this.oosAtEnd;
            if (z4) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(9, z4);
            }
            long j = this.ratSwitchCount;
            if (j != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(10, j);
            }
            boolean z5 = this.isOpportunistic;
            if (z5) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(11, z5);
            }
            int i5 = this.ipType;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(12, i5);
            }
            boolean z6 = this.setupFailed;
            if (z6) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(13, z6);
            }
            int i6 = this.failureCause;
            if (i6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(14, i6);
            }
            int i7 = this.suggestedRetryMillis;
            if (i7 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(15, i7);
            }
            int i8 = this.deactivateReason;
            if (i8 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(16, i8);
            }
            long j2 = this.durationMinutes;
            if (j2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(17, j2);
            }
            boolean z7 = this.ongoing;
            if (z7) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(18, z7);
            }
            int i9 = this.bandAtEnd;
            if (i9 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(19, i9);
            }
            int[] iArr = this.handoverFailureCauses;
            if (iArr == null || iArr.length <= 0) {
                return computeSerializedSize;
            }
            int i10 = 0;
            int i11 = 0;
            while (true) {
                int[] iArr2 = this.handoverFailureCauses;
                if (i10 >= iArr2.length) {
                    return computeSerializedSize + i11 + (iArr2.length * 2);
                }
                i11 += CodedOutputByteBufferNano.computeInt32SizeNoTag(iArr2[i10]);
                i10++;
            }
        }

        public DataCallSession mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                switch (readTag) {
                    case 0:
                        return this;
                    case 8:
                        this.dimension = codedInputByteBufferNano.readInt32();
                        break;
                    case 16:
                        this.isMultiSim = codedInputByteBufferNano.readBool();
                        break;
                    case 24:
                        this.isEsim = codedInputByteBufferNano.readBool();
                        break;
                    case 40:
                        this.apnTypeBitmask = codedInputByteBufferNano.readInt32();
                        break;
                    case 48:
                        this.carrierId = codedInputByteBufferNano.readInt32();
                        break;
                    case 56:
                        this.isRoaming = codedInputByteBufferNano.readBool();
                        break;
                    case 64:
                        this.ratAtEnd = codedInputByteBufferNano.readInt32();
                        break;
                    case 72:
                        this.oosAtEnd = codedInputByteBufferNano.readBool();
                        break;
                    case 80:
                        this.ratSwitchCount = codedInputByteBufferNano.readInt64();
                        break;
                    case 88:
                        this.isOpportunistic = codedInputByteBufferNano.readBool();
                        break;
                    case 96:
                        this.ipType = codedInputByteBufferNano.readInt32();
                        break;
                    case 104:
                        this.setupFailed = codedInputByteBufferNano.readBool();
                        break;
                    case 112:
                        this.failureCause = codedInputByteBufferNano.readInt32();
                        break;
                    case 120:
                        this.suggestedRetryMillis = codedInputByteBufferNano.readInt32();
                        break;
                    case 128:
                        this.deactivateReason = codedInputByteBufferNano.readInt32();
                        break;
                    case NetworkStackConstants.ICMPV6_NEIGHBOR_ADVERTISEMENT /*136*/:
                        this.durationMinutes = codedInputByteBufferNano.readInt64();
                        break;
                    case 144:
                        this.ongoing = codedInputByteBufferNano.readBool();
                        break;
                    case 152:
                        this.bandAtEnd = codedInputByteBufferNano.readInt32();
                        break;
                    case SmsMessage.MAX_USER_DATA_SEPTETS:
                        int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, SmsMessage.MAX_USER_DATA_SEPTETS);
                        int[] iArr = this.handoverFailureCauses;
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
                        this.handoverFailureCauses = iArr2;
                        break;
                    case 162:
                        int pushLimit = codedInputByteBufferNano.pushLimit(codedInputByteBufferNano.readRawVarint32());
                        int position = codedInputByteBufferNano.getPosition();
                        int i2 = 0;
                        while (codedInputByteBufferNano.getBytesUntilLimit() > 0) {
                            codedInputByteBufferNano.readInt32();
                            i2++;
                        }
                        codedInputByteBufferNano.rewindToPosition(position);
                        int[] iArr3 = this.handoverFailureCauses;
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
                        this.handoverFailureCauses = iArr4;
                        codedInputByteBufferNano.popLimit(pushLimit);
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

        public static DataCallSession parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (DataCallSession) MessageNano.mergeFrom(new DataCallSession(), bArr);
        }

        public static DataCallSession parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new DataCallSession().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class CellularServiceState extends ExtendableMessageNano<CellularServiceState> {
        private static volatile CellularServiceState[] _emptyArray;
        public int carrierId;
        public int dataRat;
        public int dataRoamingType;
        public boolean isEmergencyOnly;
        public boolean isEndc;
        public boolean isMultiSim;
        public long lastUsedMillis;
        public int simSlotIndex;
        public long totalTimeMillis;
        public int voiceRat;
        public int voiceRoamingType;

        public static CellularServiceState[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new CellularServiceState[0];
                    }
                }
            }
            return _emptyArray;
        }

        public CellularServiceState() {
            clear();
        }

        public CellularServiceState clear() {
            this.voiceRat = 0;
            this.dataRat = 0;
            this.voiceRoamingType = 0;
            this.dataRoamingType = 0;
            this.isEndc = false;
            this.simSlotIndex = 0;
            this.isMultiSim = false;
            this.carrierId = 0;
            this.totalTimeMillis = 0;
            this.isEmergencyOnly = false;
            this.lastUsedMillis = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.voiceRat;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.dataRat;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.voiceRoamingType;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.dataRoamingType;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
            }
            boolean z = this.isEndc;
            if (z) {
                codedOutputByteBufferNano.writeBool(5, z);
            }
            int i5 = this.simSlotIndex;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i5);
            }
            boolean z2 = this.isMultiSim;
            if (z2) {
                codedOutputByteBufferNano.writeBool(7, z2);
            }
            int i6 = this.carrierId;
            if (i6 != 0) {
                codedOutputByteBufferNano.writeInt32(8, i6);
            }
            long j = this.totalTimeMillis;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(9, j);
            }
            boolean z3 = this.isEmergencyOnly;
            if (z3) {
                codedOutputByteBufferNano.writeBool(10, z3);
            }
            long j2 = this.lastUsedMillis;
            if (j2 != 0) {
                codedOutputByteBufferNano.writeInt64(10001, j2);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.voiceRat;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            int i2 = this.dataRat;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.voiceRoamingType;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.dataRoamingType;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
            }
            boolean z = this.isEndc;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(5, z);
            }
            int i5 = this.simSlotIndex;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i5);
            }
            boolean z2 = this.isMultiSim;
            if (z2) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(7, z2);
            }
            int i6 = this.carrierId;
            if (i6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(8, i6);
            }
            long j = this.totalTimeMillis;
            if (j != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(9, j);
            }
            boolean z3 = this.isEmergencyOnly;
            if (z3) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(10, z3);
            }
            long j2 = this.lastUsedMillis;
            return j2 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(10001, j2) : computeSerializedSize;
        }

        public CellularServiceState mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                switch (readTag) {
                    case 0:
                        return this;
                    case 8:
                        this.voiceRat = codedInputByteBufferNano.readInt32();
                        break;
                    case 16:
                        this.dataRat = codedInputByteBufferNano.readInt32();
                        break;
                    case 24:
                        this.voiceRoamingType = codedInputByteBufferNano.readInt32();
                        break;
                    case 32:
                        this.dataRoamingType = codedInputByteBufferNano.readInt32();
                        break;
                    case 40:
                        this.isEndc = codedInputByteBufferNano.readBool();
                        break;
                    case 48:
                        this.simSlotIndex = codedInputByteBufferNano.readInt32();
                        break;
                    case 56:
                        this.isMultiSim = codedInputByteBufferNano.readBool();
                        break;
                    case 64:
                        this.carrierId = codedInputByteBufferNano.readInt32();
                        break;
                    case 72:
                        this.totalTimeMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 80:
                        this.isEmergencyOnly = codedInputByteBufferNano.readBool();
                        break;
                    case 80008:
                        this.lastUsedMillis = codedInputByteBufferNano.readInt64();
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

        public static CellularServiceState parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (CellularServiceState) MessageNano.mergeFrom(new CellularServiceState(), bArr);
        }

        public static CellularServiceState parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new CellularServiceState().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class CellularDataServiceSwitch extends ExtendableMessageNano<CellularDataServiceSwitch> {
        private static volatile CellularDataServiceSwitch[] _emptyArray;
        public int carrierId;
        public boolean isMultiSim;
        public long lastUsedMillis;
        public int ratFrom;
        public int ratTo;
        public int simSlotIndex;
        public int switchCount;

        public static CellularDataServiceSwitch[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new CellularDataServiceSwitch[0];
                    }
                }
            }
            return _emptyArray;
        }

        public CellularDataServiceSwitch() {
            clear();
        }

        public CellularDataServiceSwitch clear() {
            this.ratFrom = 0;
            this.ratTo = 0;
            this.simSlotIndex = 0;
            this.isMultiSim = false;
            this.carrierId = 0;
            this.switchCount = 0;
            this.lastUsedMillis = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.ratFrom;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.ratTo;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.simSlotIndex;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            boolean z = this.isMultiSim;
            if (z) {
                codedOutputByteBufferNano.writeBool(4, z);
            }
            int i4 = this.carrierId;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i4);
            }
            int i5 = this.switchCount;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i5);
            }
            long j = this.lastUsedMillis;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(10001, j);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.ratFrom;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            int i2 = this.ratTo;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.simSlotIndex;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            boolean z = this.isMultiSim;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(4, z);
            }
            int i4 = this.carrierId;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i4);
            }
            int i5 = this.switchCount;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i5);
            }
            long j = this.lastUsedMillis;
            return j != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(10001, j) : computeSerializedSize;
        }

        public CellularDataServiceSwitch mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.ratFrom = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.ratTo = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.simSlotIndex = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    this.isMultiSim = codedInputByteBufferNano.readBool();
                } else if (readTag == 40) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 48) {
                    this.switchCount = codedInputByteBufferNano.readInt32();
                } else if (readTag == 80008) {
                    this.lastUsedMillis = codedInputByteBufferNano.readInt64();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static CellularDataServiceSwitch parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (CellularDataServiceSwitch) MessageNano.mergeFrom(new CellularDataServiceSwitch(), bArr);
        }

        public static CellularDataServiceSwitch parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new CellularDataServiceSwitch().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class ImsRegistrationTermination extends ExtendableMessageNano<ImsRegistrationTermination> {
        private static volatile ImsRegistrationTermination[] _emptyArray;
        public int carrierId;
        public int count;
        public int extraCode;
        public String extraMessage;
        public boolean isMultiSim;
        public long lastUsedMillis;
        public int ratAtEnd;
        public int reasonCode;
        public boolean setupFailed;

        public static ImsRegistrationTermination[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new ImsRegistrationTermination[0];
                    }
                }
            }
            return _emptyArray;
        }

        public ImsRegistrationTermination() {
            clear();
        }

        public ImsRegistrationTermination clear() {
            this.carrierId = 0;
            this.isMultiSim = false;
            this.ratAtEnd = 0;
            this.setupFailed = false;
            this.reasonCode = 0;
            this.extraCode = 0;
            this.extraMessage = "";
            this.count = 0;
            this.lastUsedMillis = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            boolean z = this.isMultiSim;
            if (z) {
                codedOutputByteBufferNano.writeBool(2, z);
            }
            int i2 = this.ratAtEnd;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i2);
            }
            boolean z2 = this.setupFailed;
            if (z2) {
                codedOutputByteBufferNano.writeBool(4, z2);
            }
            int i3 = this.reasonCode;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i3);
            }
            int i4 = this.extraCode;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i4);
            }
            if (!this.extraMessage.equals("")) {
                codedOutputByteBufferNano.writeString(7, this.extraMessage);
            }
            int i5 = this.count;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(8, i5);
            }
            long j = this.lastUsedMillis;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(10001, j);
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
            boolean z = this.isMultiSim;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(2, z);
            }
            int i2 = this.ratAtEnd;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i2);
            }
            boolean z2 = this.setupFailed;
            if (z2) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(4, z2);
            }
            int i3 = this.reasonCode;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i3);
            }
            int i4 = this.extraCode;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i4);
            }
            if (!this.extraMessage.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(7, this.extraMessage);
            }
            int i5 = this.count;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(8, i5);
            }
            long j = this.lastUsedMillis;
            return j != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(10001, j) : computeSerializedSize;
        }

        public ImsRegistrationTermination mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.isMultiSim = codedInputByteBufferNano.readBool();
                } else if (readTag == 24) {
                    this.ratAtEnd = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    this.setupFailed = codedInputByteBufferNano.readBool();
                } else if (readTag == 40) {
                    this.reasonCode = codedInputByteBufferNano.readInt32();
                } else if (readTag == 48) {
                    this.extraCode = codedInputByteBufferNano.readInt32();
                } else if (readTag == 58) {
                    this.extraMessage = codedInputByteBufferNano.readString();
                } else if (readTag == 64) {
                    this.count = codedInputByteBufferNano.readInt32();
                } else if (readTag == 80008) {
                    this.lastUsedMillis = codedInputByteBufferNano.readInt64();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static ImsRegistrationTermination parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (ImsRegistrationTermination) MessageNano.mergeFrom(new ImsRegistrationTermination(), bArr);
        }

        public static ImsRegistrationTermination parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new ImsRegistrationTermination().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class ImsRegistrationStats extends ExtendableMessageNano<ImsRegistrationStats> {
        private static volatile ImsRegistrationStats[] _emptyArray;
        public int carrierId;
        public long lastUsedMillis;
        public int rat;
        public long registeredMillis;
        public int simSlotIndex;
        public long smsAvailableMillis;
        public long smsCapableMillis;
        public long utAvailableMillis;
        public long utCapableMillis;
        public long videoAvailableMillis;
        public long videoCapableMillis;
        public long voiceAvailableMillis;
        public long voiceCapableMillis;

        public static ImsRegistrationStats[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new ImsRegistrationStats[0];
                    }
                }
            }
            return _emptyArray;
        }

        public ImsRegistrationStats() {
            clear();
        }

        public ImsRegistrationStats clear() {
            this.carrierId = 0;
            this.simSlotIndex = 0;
            this.rat = 0;
            this.registeredMillis = 0;
            this.voiceCapableMillis = 0;
            this.voiceAvailableMillis = 0;
            this.smsCapableMillis = 0;
            this.smsAvailableMillis = 0;
            this.videoCapableMillis = 0;
            this.videoAvailableMillis = 0;
            this.utCapableMillis = 0;
            this.utAvailableMillis = 0;
            this.lastUsedMillis = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.simSlotIndex;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.rat;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            long j = this.registeredMillis;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(4, j);
            }
            long j2 = this.voiceCapableMillis;
            if (j2 != 0) {
                codedOutputByteBufferNano.writeInt64(5, j2);
            }
            long j3 = this.voiceAvailableMillis;
            if (j3 != 0) {
                codedOutputByteBufferNano.writeInt64(6, j3);
            }
            long j4 = this.smsCapableMillis;
            if (j4 != 0) {
                codedOutputByteBufferNano.writeInt64(7, j4);
            }
            long j5 = this.smsAvailableMillis;
            if (j5 != 0) {
                codedOutputByteBufferNano.writeInt64(8, j5);
            }
            long j6 = this.videoCapableMillis;
            if (j6 != 0) {
                codedOutputByteBufferNano.writeInt64(9, j6);
            }
            long j7 = this.videoAvailableMillis;
            if (j7 != 0) {
                codedOutputByteBufferNano.writeInt64(10, j7);
            }
            long j8 = this.utCapableMillis;
            if (j8 != 0) {
                codedOutputByteBufferNano.writeInt64(11, j8);
            }
            long j9 = this.utAvailableMillis;
            if (j9 != 0) {
                codedOutputByteBufferNano.writeInt64(12, j9);
            }
            long j10 = this.lastUsedMillis;
            if (j10 != 0) {
                codedOutputByteBufferNano.writeInt64(10001, j10);
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
            int i2 = this.simSlotIndex;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.rat;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            long j = this.registeredMillis;
            if (j != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(4, j);
            }
            long j2 = this.voiceCapableMillis;
            if (j2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(5, j2);
            }
            long j3 = this.voiceAvailableMillis;
            if (j3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(6, j3);
            }
            long j4 = this.smsCapableMillis;
            if (j4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(7, j4);
            }
            long j5 = this.smsAvailableMillis;
            if (j5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(8, j5);
            }
            long j6 = this.videoCapableMillis;
            if (j6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(9, j6);
            }
            long j7 = this.videoAvailableMillis;
            if (j7 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(10, j7);
            }
            long j8 = this.utCapableMillis;
            if (j8 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(11, j8);
            }
            long j9 = this.utAvailableMillis;
            if (j9 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt64Size(12, j9);
            }
            long j10 = this.lastUsedMillis;
            return j10 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(10001, j10) : computeSerializedSize;
        }

        public ImsRegistrationStats mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                switch (readTag) {
                    case 0:
                        return this;
                    case 8:
                        this.carrierId = codedInputByteBufferNano.readInt32();
                        break;
                    case 16:
                        this.simSlotIndex = codedInputByteBufferNano.readInt32();
                        break;
                    case 24:
                        this.rat = codedInputByteBufferNano.readInt32();
                        break;
                    case 32:
                        this.registeredMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 40:
                        this.voiceCapableMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 48:
                        this.voiceAvailableMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 56:
                        this.smsCapableMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 64:
                        this.smsAvailableMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 72:
                        this.videoCapableMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 80:
                        this.videoAvailableMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 88:
                        this.utCapableMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 96:
                        this.utAvailableMillis = codedInputByteBufferNano.readInt64();
                        break;
                    case 80008:
                        this.lastUsedMillis = codedInputByteBufferNano.readInt64();
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

        public static ImsRegistrationStats parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (ImsRegistrationStats) MessageNano.mergeFrom(new ImsRegistrationStats(), bArr);
        }

        public static ImsRegistrationStats parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new ImsRegistrationStats().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class NetworkRequests extends ExtendableMessageNano<NetworkRequests> {
        private static volatile NetworkRequests[] _emptyArray;
        public int carrierId;
        public int enterpriseReleaseCount;
        public int enterpriseRequestCount;

        public static NetworkRequests[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new NetworkRequests[0];
                    }
                }
            }
            return _emptyArray;
        }

        public NetworkRequests() {
            clear();
        }

        public NetworkRequests clear() {
            this.carrierId = 0;
            this.enterpriseRequestCount = 0;
            this.enterpriseReleaseCount = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.enterpriseRequestCount;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.enterpriseReleaseCount;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
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
            int i2 = this.enterpriseRequestCount;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.enterpriseReleaseCount;
            return i3 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(3, i3) : computeSerializedSize;
        }

        public NetworkRequests mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.enterpriseRequestCount = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.enterpriseReleaseCount = codedInputByteBufferNano.readInt32();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static NetworkRequests parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (NetworkRequests) MessageNano.mergeFrom(new NetworkRequests(), bArr);
        }

        public static NetworkRequests parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new NetworkRequests().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class NetworkRequestsV2 extends ExtendableMessageNano<NetworkRequestsV2> {
        private static volatile NetworkRequestsV2[] _emptyArray;
        public int capability;
        public int carrierId;
        public int requestCount;

        public interface NetworkCapability {
            public static final int CBS = 3;
            public static final int ENTERPRISE = 4;
            public static final int PRIORITIZE_BANDWIDTH = 2;
            public static final int PRIORITIZE_LATENCY = 1;
            public static final int UNKNOWN = 0;
        }

        public static NetworkRequestsV2[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new NetworkRequestsV2[0];
                    }
                }
            }
            return _emptyArray;
        }

        public NetworkRequestsV2() {
            clear();
        }

        public NetworkRequestsV2 clear() {
            this.carrierId = 0;
            this.capability = 0;
            this.requestCount = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.capability;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.requestCount;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
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
            int i2 = this.capability;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.requestCount;
            return i3 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(3, i3) : computeSerializedSize;
        }

        public NetworkRequestsV2 mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    int readInt32 = codedInputByteBufferNano.readInt32();
                    if (readInt32 == 0 || readInt32 == 1 || readInt32 == 2 || readInt32 == 3 || readInt32 == 4) {
                        this.capability = readInt32;
                    }
                } else if (readTag == 24) {
                    this.requestCount = codedInputByteBufferNano.readInt32();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static NetworkRequestsV2 parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (NetworkRequestsV2) MessageNano.mergeFrom(new NetworkRequestsV2(), bArr);
        }

        public static NetworkRequestsV2 parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new NetworkRequestsV2().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class ImsRegistrationFeatureTagStats extends ExtendableMessageNano<ImsRegistrationFeatureTagStats> {
        private static volatile ImsRegistrationFeatureTagStats[] _emptyArray;
        public int carrierId;
        public int featureTagName;
        public long registeredMillis;
        public int registrationTech;
        public int slotId;

        public static ImsRegistrationFeatureTagStats[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new ImsRegistrationFeatureTagStats[0];
                    }
                }
            }
            return _emptyArray;
        }

        public ImsRegistrationFeatureTagStats() {
            clear();
        }

        public ImsRegistrationFeatureTagStats clear() {
            this.carrierId = 0;
            this.slotId = 0;
            this.featureTagName = 0;
            this.registrationTech = 0;
            this.registeredMillis = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.slotId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.featureTagName;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.registrationTech;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
            }
            long j = this.registeredMillis;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(5, j);
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
            int i2 = this.slotId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.featureTagName;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.registrationTech;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
            }
            long j = this.registeredMillis;
            return j != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(5, j) : computeSerializedSize;
        }

        public ImsRegistrationFeatureTagStats mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.featureTagName = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    this.registrationTech = codedInputByteBufferNano.readInt32();
                } else if (readTag == 40) {
                    this.registeredMillis = codedInputByteBufferNano.readInt64();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static ImsRegistrationFeatureTagStats parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (ImsRegistrationFeatureTagStats) MessageNano.mergeFrom(new ImsRegistrationFeatureTagStats(), bArr);
        }

        public static ImsRegistrationFeatureTagStats parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new ImsRegistrationFeatureTagStats().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class RcsClientProvisioningStats extends ExtendableMessageNano<RcsClientProvisioningStats> {
        private static volatile RcsClientProvisioningStats[] _emptyArray;
        public int carrierId;
        public int count;
        public int event;
        public int slotId;

        public static RcsClientProvisioningStats[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new RcsClientProvisioningStats[0];
                    }
                }
            }
            return _emptyArray;
        }

        public RcsClientProvisioningStats() {
            clear();
        }

        public RcsClientProvisioningStats clear() {
            this.carrierId = 0;
            this.slotId = 0;
            this.event = 0;
            this.count = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.slotId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.event;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.count;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
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
            int i2 = this.slotId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.event;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.count;
            return i4 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(4, i4) : computeSerializedSize;
        }

        public RcsClientProvisioningStats mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.event = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    this.count = codedInputByteBufferNano.readInt32();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static RcsClientProvisioningStats parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (RcsClientProvisioningStats) MessageNano.mergeFrom(new RcsClientProvisioningStats(), bArr);
        }

        public static RcsClientProvisioningStats parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new RcsClientProvisioningStats().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class RcsAcsProvisioningStats extends ExtendableMessageNano<RcsAcsProvisioningStats> {
        private static volatile RcsAcsProvisioningStats[] _emptyArray;
        public int carrierId;
        public int count;
        public boolean isSingleRegistrationEnabled;
        public int responseCode;
        public int responseType;
        public int slotId;
        public long stateTimerMillis;

        public static RcsAcsProvisioningStats[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new RcsAcsProvisioningStats[0];
                    }
                }
            }
            return _emptyArray;
        }

        public RcsAcsProvisioningStats() {
            clear();
        }

        public RcsAcsProvisioningStats clear() {
            this.carrierId = 0;
            this.slotId = 0;
            this.responseCode = 0;
            this.responseType = 0;
            this.isSingleRegistrationEnabled = false;
            this.count = 0;
            this.stateTimerMillis = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.slotId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.responseCode;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.responseType;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
            }
            boolean z = this.isSingleRegistrationEnabled;
            if (z) {
                codedOutputByteBufferNano.writeBool(5, z);
            }
            int i5 = this.count;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i5);
            }
            long j = this.stateTimerMillis;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(7, j);
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
            int i2 = this.slotId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.responseCode;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.responseType;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
            }
            boolean z = this.isSingleRegistrationEnabled;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(5, z);
            }
            int i5 = this.count;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i5);
            }
            long j = this.stateTimerMillis;
            return j != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(7, j) : computeSerializedSize;
        }

        public RcsAcsProvisioningStats mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.responseCode = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    this.responseType = codedInputByteBufferNano.readInt32();
                } else if (readTag == 40) {
                    this.isSingleRegistrationEnabled = codedInputByteBufferNano.readBool();
                } else if (readTag == 48) {
                    this.count = codedInputByteBufferNano.readInt32();
                } else if (readTag == 56) {
                    this.stateTimerMillis = codedInputByteBufferNano.readInt64();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static RcsAcsProvisioningStats parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (RcsAcsProvisioningStats) MessageNano.mergeFrom(new RcsAcsProvisioningStats(), bArr);
        }

        public static RcsAcsProvisioningStats parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new RcsAcsProvisioningStats().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class SipDelegateStats extends ExtendableMessageNano<SipDelegateStats> {
        private static volatile SipDelegateStats[] _emptyArray;
        public int carrierId;
        public int destroyReason;
        public int dimension;
        public int slotId;
        public long uptimeMillis;

        public static SipDelegateStats[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new SipDelegateStats[0];
                    }
                }
            }
            return _emptyArray;
        }

        public SipDelegateStats() {
            clear();
        }

        public SipDelegateStats clear() {
            this.dimension = 0;
            this.carrierId = 0;
            this.slotId = 0;
            this.destroyReason = 0;
            this.uptimeMillis = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.dimension;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.carrierId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.slotId;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.destroyReason;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
            }
            long j = this.uptimeMillis;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(5, j);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.dimension;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            int i2 = this.carrierId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.slotId;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.destroyReason;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
            }
            long j = this.uptimeMillis;
            return j != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(5, j) : computeSerializedSize;
        }

        public SipDelegateStats mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.dimension = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    this.destroyReason = codedInputByteBufferNano.readInt32();
                } else if (readTag == 40) {
                    this.uptimeMillis = codedInputByteBufferNano.readInt64();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static SipDelegateStats parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (SipDelegateStats) MessageNano.mergeFrom(new SipDelegateStats(), bArr);
        }

        public static SipDelegateStats parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new SipDelegateStats().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class SipTransportFeatureTagStats extends ExtendableMessageNano<SipTransportFeatureTagStats> {
        private static volatile SipTransportFeatureTagStats[] _emptyArray;
        public long associatedMillis;
        public int carrierId;
        public int featureTagName;
        public int sipTransportDeniedReason;
        public int sipTransportDeregisteredReason;
        public int slotId;

        public static SipTransportFeatureTagStats[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new SipTransportFeatureTagStats[0];
                    }
                }
            }
            return _emptyArray;
        }

        public SipTransportFeatureTagStats() {
            clear();
        }

        public SipTransportFeatureTagStats clear() {
            this.carrierId = 0;
            this.slotId = 0;
            this.featureTagName = 0;
            this.sipTransportDeniedReason = 0;
            this.sipTransportDeregisteredReason = 0;
            this.associatedMillis = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.slotId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.featureTagName;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.sipTransportDeniedReason;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
            }
            int i5 = this.sipTransportDeregisteredReason;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i5);
            }
            long j = this.associatedMillis;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(6, j);
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
            int i2 = this.slotId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.featureTagName;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.sipTransportDeniedReason;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
            }
            int i5 = this.sipTransportDeregisteredReason;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i5);
            }
            long j = this.associatedMillis;
            return j != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(6, j) : computeSerializedSize;
        }

        public SipTransportFeatureTagStats mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.featureTagName = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    this.sipTransportDeniedReason = codedInputByteBufferNano.readInt32();
                } else if (readTag == 40) {
                    this.sipTransportDeregisteredReason = codedInputByteBufferNano.readInt32();
                } else if (readTag == 48) {
                    this.associatedMillis = codedInputByteBufferNano.readInt64();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static SipTransportFeatureTagStats parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (SipTransportFeatureTagStats) MessageNano.mergeFrom(new SipTransportFeatureTagStats(), bArr);
        }

        public static SipTransportFeatureTagStats parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new SipTransportFeatureTagStats().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class SipMessageResponse extends ExtendableMessageNano<SipMessageResponse> {
        private static volatile SipMessageResponse[] _emptyArray;
        public int carrierId;
        public int count;
        public int messageError;
        public int sipMessageDirection;
        public int sipMessageMethod;
        public int sipMessageResponse;
        public int slotId;

        public static SipMessageResponse[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new SipMessageResponse[0];
                    }
                }
            }
            return _emptyArray;
        }

        public SipMessageResponse() {
            clear();
        }

        public SipMessageResponse clear() {
            this.carrierId = 0;
            this.slotId = 0;
            this.sipMessageMethod = 0;
            this.sipMessageResponse = 0;
            this.sipMessageDirection = 0;
            this.messageError = 0;
            this.count = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.slotId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.sipMessageMethod;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.sipMessageResponse;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
            }
            int i5 = this.sipMessageDirection;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i5);
            }
            int i6 = this.messageError;
            if (i6 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i6);
            }
            int i7 = this.count;
            if (i7 != 0) {
                codedOutputByteBufferNano.writeInt32(7, i7);
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
            int i2 = this.slotId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.sipMessageMethod;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.sipMessageResponse;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
            }
            int i5 = this.sipMessageDirection;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i5);
            }
            int i6 = this.messageError;
            if (i6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i6);
            }
            int i7 = this.count;
            return i7 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(7, i7) : computeSerializedSize;
        }

        public SipMessageResponse mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.sipMessageMethod = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    this.sipMessageResponse = codedInputByteBufferNano.readInt32();
                } else if (readTag == 40) {
                    this.sipMessageDirection = codedInputByteBufferNano.readInt32();
                } else if (readTag == 48) {
                    this.messageError = codedInputByteBufferNano.readInt32();
                } else if (readTag == 56) {
                    this.count = codedInputByteBufferNano.readInt32();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static SipMessageResponse parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (SipMessageResponse) MessageNano.mergeFrom(new SipMessageResponse(), bArr);
        }

        public static SipMessageResponse parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new SipMessageResponse().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class SipTransportSession extends ExtendableMessageNano<SipTransportSession> {
        private static volatile SipTransportSession[] _emptyArray;
        public int carrierId;
        public int endedGracefullyCount;
        public boolean isEndedGracefully;
        public int sessionCount;
        public int sessionMethod;
        public int sipMessageDirection;
        public int sipResponse;
        public int slotId;

        public static SipTransportSession[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new SipTransportSession[0];
                    }
                }
            }
            return _emptyArray;
        }

        public SipTransportSession() {
            clear();
        }

        public SipTransportSession clear() {
            this.carrierId = 0;
            this.slotId = 0;
            this.sessionMethod = 0;
            this.sipMessageDirection = 0;
            this.sipResponse = 0;
            this.sessionCount = 0;
            this.endedGracefullyCount = 0;
            this.isEndedGracefully = false;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.slotId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.sessionMethod;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.sipMessageDirection;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
            }
            int i5 = this.sipResponse;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i5);
            }
            int i6 = this.sessionCount;
            if (i6 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i6);
            }
            int i7 = this.endedGracefullyCount;
            if (i7 != 0) {
                codedOutputByteBufferNano.writeInt32(7, i7);
            }
            boolean z = this.isEndedGracefully;
            if (z) {
                codedOutputByteBufferNano.writeBool(10001, z);
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
            int i2 = this.slotId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.sessionMethod;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.sipMessageDirection;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
            }
            int i5 = this.sipResponse;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i5);
            }
            int i6 = this.sessionCount;
            if (i6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i6);
            }
            int i7 = this.endedGracefullyCount;
            if (i7 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(7, i7);
            }
            boolean z = this.isEndedGracefully;
            return z ? computeSerializedSize + CodedOutputByteBufferNano.computeBoolSize(10001, z) : computeSerializedSize;
        }

        public SipTransportSession mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.sessionMethod = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    this.sipMessageDirection = codedInputByteBufferNano.readInt32();
                } else if (readTag == 40) {
                    this.sipResponse = codedInputByteBufferNano.readInt32();
                } else if (readTag == 48) {
                    this.sessionCount = codedInputByteBufferNano.readInt32();
                } else if (readTag == 56) {
                    this.endedGracefullyCount = codedInputByteBufferNano.readInt32();
                } else if (readTag == 80008) {
                    this.isEndedGracefully = codedInputByteBufferNano.readBool();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static SipTransportSession parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (SipTransportSession) MessageNano.mergeFrom(new SipTransportSession(), bArr);
        }

        public static SipTransportSession parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new SipTransportSession().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class ImsDedicatedBearerListenerEvent extends ExtendableMessageNano<ImsDedicatedBearerListenerEvent> {
        private static volatile ImsDedicatedBearerListenerEvent[] _emptyArray;
        public int carrierId;
        public boolean dedicatedBearerEstablished;
        public int eventCount;
        public int qci;
        public int ratAtEnd;
        public int slotId;

        public static ImsDedicatedBearerListenerEvent[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new ImsDedicatedBearerListenerEvent[0];
                    }
                }
            }
            return _emptyArray;
        }

        public ImsDedicatedBearerListenerEvent() {
            clear();
        }

        public ImsDedicatedBearerListenerEvent clear() {
            this.carrierId = 0;
            this.slotId = 0;
            this.ratAtEnd = 0;
            this.qci = 0;
            this.dedicatedBearerEstablished = false;
            this.eventCount = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.slotId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.ratAtEnd;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.qci;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
            }
            boolean z = this.dedicatedBearerEstablished;
            if (z) {
                codedOutputByteBufferNano.writeBool(5, z);
            }
            int i5 = this.eventCount;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i5);
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
            int i2 = this.slotId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.ratAtEnd;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.qci;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
            }
            boolean z = this.dedicatedBearerEstablished;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(5, z);
            }
            int i5 = this.eventCount;
            return i5 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(6, i5) : computeSerializedSize;
        }

        public ImsDedicatedBearerListenerEvent mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.ratAtEnd = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    this.qci = codedInputByteBufferNano.readInt32();
                } else if (readTag == 40) {
                    this.dedicatedBearerEstablished = codedInputByteBufferNano.readBool();
                } else if (readTag == 48) {
                    this.eventCount = codedInputByteBufferNano.readInt32();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static ImsDedicatedBearerListenerEvent parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (ImsDedicatedBearerListenerEvent) MessageNano.mergeFrom(new ImsDedicatedBearerListenerEvent(), bArr);
        }

        public static ImsDedicatedBearerListenerEvent parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new ImsDedicatedBearerListenerEvent().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class ImsDedicatedBearerEvent extends ExtendableMessageNano<ImsDedicatedBearerEvent> {
        private static volatile ImsDedicatedBearerEvent[] _emptyArray;
        public int bearerState;
        public int carrierId;
        public int count;
        public boolean hasListeners;
        public boolean localConnectionInfoReceived;
        public int qci;
        public int ratAtEnd;
        public boolean remoteConnectionInfoReceived;
        public int slotId;

        public static ImsDedicatedBearerEvent[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new ImsDedicatedBearerEvent[0];
                    }
                }
            }
            return _emptyArray;
        }

        public ImsDedicatedBearerEvent() {
            clear();
        }

        public ImsDedicatedBearerEvent clear() {
            this.carrierId = 0;
            this.slotId = 0;
            this.ratAtEnd = 0;
            this.qci = 0;
            this.bearerState = 0;
            this.localConnectionInfoReceived = false;
            this.remoteConnectionInfoReceived = false;
            this.hasListeners = false;
            this.count = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.slotId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.ratAtEnd;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            int i4 = this.qci;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i4);
            }
            int i5 = this.bearerState;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i5);
            }
            boolean z = this.localConnectionInfoReceived;
            if (z) {
                codedOutputByteBufferNano.writeBool(6, z);
            }
            boolean z2 = this.remoteConnectionInfoReceived;
            if (z2) {
                codedOutputByteBufferNano.writeBool(7, z2);
            }
            boolean z3 = this.hasListeners;
            if (z3) {
                codedOutputByteBufferNano.writeBool(8, z3);
            }
            int i6 = this.count;
            if (i6 != 0) {
                codedOutputByteBufferNano.writeInt32(9, i6);
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
            int i2 = this.slotId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.ratAtEnd;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            int i4 = this.qci;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i4);
            }
            int i5 = this.bearerState;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i5);
            }
            boolean z = this.localConnectionInfoReceived;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(6, z);
            }
            boolean z2 = this.remoteConnectionInfoReceived;
            if (z2) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(7, z2);
            }
            boolean z3 = this.hasListeners;
            if (z3) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(8, z3);
            }
            int i6 = this.count;
            return i6 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(9, i6) : computeSerializedSize;
        }

        public ImsDedicatedBearerEvent mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.ratAtEnd = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    this.qci = codedInputByteBufferNano.readInt32();
                } else if (readTag == 40) {
                    this.bearerState = codedInputByteBufferNano.readInt32();
                } else if (readTag == 48) {
                    this.localConnectionInfoReceived = codedInputByteBufferNano.readBool();
                } else if (readTag == 56) {
                    this.remoteConnectionInfoReceived = codedInputByteBufferNano.readBool();
                } else if (readTag == 64) {
                    this.hasListeners = codedInputByteBufferNano.readBool();
                } else if (readTag == 72) {
                    this.count = codedInputByteBufferNano.readInt32();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static ImsDedicatedBearerEvent parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (ImsDedicatedBearerEvent) MessageNano.mergeFrom(new ImsDedicatedBearerEvent(), bArr);
        }

        public static ImsDedicatedBearerEvent parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new ImsDedicatedBearerEvent().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class ImsRegistrationServiceDescStats extends ExtendableMessageNano<ImsRegistrationServiceDescStats> {
        private static volatile ImsRegistrationServiceDescStats[] _emptyArray;
        public int carrierId;
        public long publishedMillis;
        public int registrationTech;
        public int serviceIdName;
        public float serviceIdVersion;
        public int slotId;

        public static ImsRegistrationServiceDescStats[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new ImsRegistrationServiceDescStats[0];
                    }
                }
            }
            return _emptyArray;
        }

        public ImsRegistrationServiceDescStats() {
            clear();
        }

        public ImsRegistrationServiceDescStats clear() {
            this.carrierId = 0;
            this.slotId = 0;
            this.serviceIdName = 0;
            this.serviceIdVersion = 0.0f;
            this.registrationTech = 0;
            this.publishedMillis = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.slotId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.serviceIdName;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            if (Float.floatToIntBits(this.serviceIdVersion) != Float.floatToIntBits(0.0f)) {
                codedOutputByteBufferNano.writeFloat(4, this.serviceIdVersion);
            }
            int i4 = this.registrationTech;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i4);
            }
            long j = this.publishedMillis;
            if (j != 0) {
                codedOutputByteBufferNano.writeInt64(6, j);
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
            int i2 = this.slotId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.serviceIdName;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            if (Float.floatToIntBits(this.serviceIdVersion) != Float.floatToIntBits(0.0f)) {
                computeSerializedSize += CodedOutputByteBufferNano.computeFloatSize(4, this.serviceIdVersion);
            }
            int i4 = this.registrationTech;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i4);
            }
            long j = this.publishedMillis;
            return j != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt64Size(6, j) : computeSerializedSize;
        }

        public ImsRegistrationServiceDescStats mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.serviceIdName = codedInputByteBufferNano.readInt32();
                } else if (readTag == 37) {
                    this.serviceIdVersion = codedInputByteBufferNano.readFloat();
                } else if (readTag == 40) {
                    this.registrationTech = codedInputByteBufferNano.readInt32();
                } else if (readTag == 48) {
                    this.publishedMillis = codedInputByteBufferNano.readInt64();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static ImsRegistrationServiceDescStats parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (ImsRegistrationServiceDescStats) MessageNano.mergeFrom(new ImsRegistrationServiceDescStats(), bArr);
        }

        public static ImsRegistrationServiceDescStats parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new ImsRegistrationServiceDescStats().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class UceEventStats extends ExtendableMessageNano<UceEventStats> {
        private static volatile UceEventStats[] _emptyArray;
        public int carrierId;
        public int commandCode;
        public int count;
        public int networkResponse;
        public int slotId;
        public boolean successful;
        public int type;

        public static UceEventStats[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new UceEventStats[0];
                    }
                }
            }
            return _emptyArray;
        }

        public UceEventStats() {
            clear();
        }

        public UceEventStats clear() {
            this.carrierId = 0;
            this.slotId = 0;
            this.type = 0;
            this.successful = false;
            this.commandCode = 0;
            this.networkResponse = 0;
            this.count = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.slotId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.type;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            boolean z = this.successful;
            if (z) {
                codedOutputByteBufferNano.writeBool(4, z);
            }
            int i4 = this.commandCode;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i4);
            }
            int i5 = this.networkResponse;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i5);
            }
            int i6 = this.count;
            if (i6 != 0) {
                codedOutputByteBufferNano.writeInt32(7, i6);
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
            int i2 = this.slotId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.type;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            boolean z = this.successful;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(4, z);
            }
            int i4 = this.commandCode;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i4);
            }
            int i5 = this.networkResponse;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i5);
            }
            int i6 = this.count;
            return i6 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(7, i6) : computeSerializedSize;
        }

        public UceEventStats mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.type = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    this.successful = codedInputByteBufferNano.readBool();
                } else if (readTag == 40) {
                    this.commandCode = codedInputByteBufferNano.readInt32();
                } else if (readTag == 48) {
                    this.networkResponse = codedInputByteBufferNano.readInt32();
                } else if (readTag == 56) {
                    this.count = codedInputByteBufferNano.readInt32();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static UceEventStats parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (UceEventStats) MessageNano.mergeFrom(new UceEventStats(), bArr);
        }

        public static UceEventStats parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new UceEventStats().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class PresenceNotifyEvent extends ExtendableMessageNano<PresenceNotifyEvent> {
        private static volatile PresenceNotifyEvent[] _emptyArray;
        public int carrierId;
        public boolean contentBodyReceived;
        public int count;
        public int mmtelCapsCount;
        public int noCapsCount;
        public int rcsCapsCount;
        public int reason;
        public int slotId;

        public static PresenceNotifyEvent[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new PresenceNotifyEvent[0];
                    }
                }
            }
            return _emptyArray;
        }

        public PresenceNotifyEvent() {
            clear();
        }

        public PresenceNotifyEvent clear() {
            this.carrierId = 0;
            this.slotId = 0;
            this.reason = 0;
            this.contentBodyReceived = false;
            this.rcsCapsCount = 0;
            this.mmtelCapsCount = 0;
            this.noCapsCount = 0;
            this.count = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.slotId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            int i3 = this.reason;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(3, i3);
            }
            boolean z = this.contentBodyReceived;
            if (z) {
                codedOutputByteBufferNano.writeBool(4, z);
            }
            int i4 = this.rcsCapsCount;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i4);
            }
            int i5 = this.mmtelCapsCount;
            if (i5 != 0) {
                codedOutputByteBufferNano.writeInt32(6, i5);
            }
            int i6 = this.noCapsCount;
            if (i6 != 0) {
                codedOutputByteBufferNano.writeInt32(7, i6);
            }
            int i7 = this.count;
            if (i7 != 0) {
                codedOutputByteBufferNano.writeInt32(8, i7);
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
            int i2 = this.slotId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            int i3 = this.reason;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i3);
            }
            boolean z = this.contentBodyReceived;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(4, z);
            }
            int i4 = this.rcsCapsCount;
            if (i4 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(5, i4);
            }
            int i5 = this.mmtelCapsCount;
            if (i5 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(6, i5);
            }
            int i6 = this.noCapsCount;
            if (i6 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(7, i6);
            }
            int i7 = this.count;
            return i7 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(8, i7) : computeSerializedSize;
        }

        public PresenceNotifyEvent mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.reason = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    this.contentBodyReceived = codedInputByteBufferNano.readBool();
                } else if (readTag == 40) {
                    this.rcsCapsCount = codedInputByteBufferNano.readInt32();
                } else if (readTag == 48) {
                    this.mmtelCapsCount = codedInputByteBufferNano.readInt32();
                } else if (readTag == 56) {
                    this.noCapsCount = codedInputByteBufferNano.readInt32();
                } else if (readTag == 64) {
                    this.count = codedInputByteBufferNano.readInt32();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static PresenceNotifyEvent parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (PresenceNotifyEvent) MessageNano.mergeFrom(new PresenceNotifyEvent(), bArr);
        }

        public static PresenceNotifyEvent parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new PresenceNotifyEvent().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class GbaEvent extends ExtendableMessageNano<GbaEvent> {
        private static volatile GbaEvent[] _emptyArray;
        public int carrierId;
        public int count;
        public int failedReason;
        public int slotId;
        public boolean successful;

        public static GbaEvent[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new GbaEvent[0];
                    }
                }
            }
            return _emptyArray;
        }

        public GbaEvent() {
            clear();
        }

        public GbaEvent clear() {
            this.carrierId = 0;
            this.slotId = 0;
            this.successful = false;
            this.failedReason = 0;
            this.count = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.carrierId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            int i2 = this.slotId;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            boolean z = this.successful;
            if (z) {
                codedOutputByteBufferNano.writeBool(3, z);
            }
            int i3 = this.failedReason;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i3);
            }
            int i4 = this.count;
            if (i4 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i4);
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
            int i2 = this.slotId;
            if (i2 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(2, i2);
            }
            boolean z = this.successful;
            if (z) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBoolSize(3, z);
            }
            int i3 = this.failedReason;
            if (i3 != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i3);
            }
            int i4 = this.count;
            return i4 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(5, i4) : computeSerializedSize;
        }

        public GbaEvent mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.carrierId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 16) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 24) {
                    this.successful = codedInputByteBufferNano.readBool();
                } else if (readTag == 32) {
                    this.failedReason = codedInputByteBufferNano.readInt32();
                } else if (readTag == 40) {
                    this.count = codedInputByteBufferNano.readInt32();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static GbaEvent parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (GbaEvent) MessageNano.mergeFrom(new GbaEvent(), bArr);
        }

        public static GbaEvent parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new GbaEvent().mergeFrom(codedInputByteBufferNano);
        }
    }
}
