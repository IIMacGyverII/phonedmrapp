package com.android.internal.telephony.metrics;

import android.content.Context;
import android.net.NetworkCapabilities;
import android.os.BatteryStatsManager;
import android.os.Build;
import android.os.SystemClock;
import android.os.SystemProperties;
import android.telephony.CallQuality;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.ServiceState;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyHistogram;
import android.telephony.TelephonyManager;
import android.telephony.data.DataCallResponse;
import android.telephony.emergency.EmergencyNumber;
import android.telephony.ims.ImsCallProfile;
import android.telephony.ims.ImsCallSession;
import android.telephony.ims.ImsReasonInfo;
import android.telephony.ims.feature.MmTelFeature;
import android.text.TextUtils;
import android.util.ArrayMap;
import android.util.Base64;
import android.util.SparseArray;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.CarrierResolver;
import com.android.internal.telephony.GsmCdmaConnection;
import com.android.internal.telephony.IndentingPrintWriter;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.RIL;
import com.android.internal.telephony.SmsController;
import com.android.internal.telephony.SmsResponse;
import com.android.internal.telephony.UUSInfo;
import com.android.internal.telephony.data.LinkBandwidthEstimator;
import com.android.internal.telephony.emergency.EmergencyNumberTracker;
import com.android.internal.telephony.nano.TelephonyProto;
import com.android.internal.telephony.protobuf.nano.MessageNano;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import com.mediatek.boostfwk.identify.launch.LaunchConfig;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Deque;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

public class TelephonyMetrics {
    private static final boolean DBG = true;
    private static final int MAX_COMPLETED_CALL_SESSIONS = 50;
    private static final int MAX_COMPLETED_SMS_SESSIONS = 500;
    private static final int MAX_TELEPHONY_EVENTS = 1000;
    private static final int SESSION_START_PRECISION_MINUTES = 5;
    private static final String TAG = "TelephonyMetrics";
    private static final boolean VDBG = false;
    private static TelephonyMetrics sInstance;
    private final List<Map<String, BwEstimationStats>> mBwEstStatsMapList = new ArrayList(Arrays.asList(new ArrayMap[]{new ArrayMap(), new ArrayMap()}));
    private final Deque<TelephonyProto.TelephonyCallSession> mCompletedCallSessions = new ArrayDeque();
    private final Deque<TelephonyProto.SmsSession> mCompletedSmsSessions = new ArrayDeque();
    private Context mContext;
    private final SparseArray<InProgressCallSession> mInProgressCallSessions = new SparseArray<>();
    private final SparseArray<InProgressSmsSession> mInProgressSmsSessions = new SparseArray<>();
    private final SparseArray<TelephonyProto.ActiveSubscriptionInfo> mLastActiveSubscriptionInfos = new SparseArray<>();
    private final SparseArray<TelephonyProto.TelephonyEvent.CarrierIdMatching> mLastCarrierId = new SparseArray<>();
    private int mLastEnabledModemBitmap = ((1 << TelephonyManager.getDefault().getPhoneCount()) - 1);
    private final SparseArray<TelephonyProto.ImsCapabilities> mLastImsCapabilities = new SparseArray<>();
    private final SparseArray<TelephonyProto.ImsConnectionState> mLastImsConnectionState = new SparseArray<>();
    private final SparseArray<TelephonyProto.TelephonyEvent.NetworkCapabilitiesInfo> mLastNetworkCapabilitiesInfos = new SparseArray<>();
    private final SparseArray<Integer> mLastRadioState = new SparseArray<>();
    private final SparseArray<SparseArray<TelephonyProto.RilDataCall>> mLastRilDataCallEvents = new SparseArray<>();
    private final SparseArray<TelephonyProto.TelephonyServiceState> mLastServiceState = new SparseArray<>();
    private final SparseArray<TelephonyProto.TelephonySettings> mLastSettings = new SparseArray<>();
    private final SparseArray<Integer> mLastSimState = new SparseArray<>();
    private long mStartElapsedTimeMs = SystemClock.elapsedRealtime();
    private long mStartSystemTimeMs = System.currentTimeMillis();
    private final Deque<TelephonyProto.TelephonyEvent> mTelephonyEvents = new ArrayDeque();
    private boolean mTelephonyEventsDropped = false;

    private static int callQualityLevelToProtoEnum(int i) {
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
        if (i == 4) {
            return 5;
        }
        return i == 5 ? 6 : 0;
    }

    private int convertGsmCdmaCodec(int i) {
        switch (i) {
            case 1:
                return 1;
            case 2:
                return 2;
            case 3:
                return 8;
            case 4:
                return 9;
            case 5:
                return 10;
            case 6:
                return 4;
            case 7:
                return 5;
            case 8:
                return 6;
            case 9:
                return 7;
            default:
                return 0;
        }
    }

    private static int convertImsCodec(int i) {
        switch (i) {
            case 1:
                return 1;
            case 2:
                return 2;
            case 3:
                return 3;
            case 4:
                return 4;
            case 5:
                return 5;
            case 6:
                return 6;
            case 7:
                return 7;
            case 8:
                return 8;
            case 9:
                return 9;
            case 10:
                return 10;
            case 11:
                return 11;
            case 12:
                return 12;
            case 13:
                return 13;
            case 14:
                return 14;
            case 15:
                return 15;
            case 16:
                return 16;
            case 17:
                return 17;
            case 18:
                return 18;
            case 19:
                return 19;
            case 20:
                return 20;
            default:
                return 0;
        }
    }

    private static int convertRadioState(int i) {
        if (i == 0) {
            return 1;
        }
        if (i != 1) {
            return i != 2 ? 0 : 3;
        }
        return 2;
    }

    private int getSmsTech(int i, boolean z) {
        if (i == 1) {
            return 3;
        }
        if (i == 0) {
            return z ? 2 : 1;
        }
        return 0;
    }

    private void logv(String str) {
    }

    private static int mapSimStateToProto(int i) {
        if (i != 1) {
            return i != 10 ? 0 : 2;
        }
        return 1;
    }

    static int toPrivacyFuzzedTimeInterval(long j, long j2) {
        long j3 = j2 - j;
        if (j3 < 0) {
            return 0;
        }
        if (j3 <= 10) {
            return 1;
        }
        if (j3 <= 20) {
            return 2;
        }
        if (j3 <= 50) {
            return 3;
        }
        if (j3 <= 100) {
            return 4;
        }
        if (j3 <= 200) {
            return 5;
        }
        if (j3 <= 500) {
            return 6;
        }
        if (j3 <= 1000) {
            return 7;
        }
        if (j3 <= LaunchConfig.ACTIVITY_CONSIDERED_RESUME) {
            return 8;
        }
        if (j3 <= 5000) {
            return 9;
        }
        if (j3 <= 10000) {
            return 10;
        }
        if (j3 <= 30000) {
            return 11;
        }
        if (j3 <= 60000) {
            return 12;
        }
        if (j3 <= 180000) {
            return 13;
        }
        if (j3 <= 600000) {
            return 14;
        }
        if (j3 <= 1800000) {
            return 15;
        }
        if (j3 <= 3600000) {
            return 16;
        }
        if (j3 <= 7200000) {
            return 17;
        }
        return j3 <= 14400000 ? 18 : 19;
    }

    public void writeOnImsCallHeld(int i, ImsCallSession imsCallSession) {
    }

    public void writeOnImsCallHoldFailed(int i, ImsCallSession imsCallSession, ImsReasonInfo imsReasonInfo) {
    }

    public void writeOnImsCallHoldReceived(int i, ImsCallSession imsCallSession) {
    }

    public void writeOnImsCallInitiating(int i, ImsCallSession imsCallSession) {
    }

    public void writeOnImsCallProgressing(int i, ImsCallSession imsCallSession) {
    }

    public void writeOnImsCallResumeFailed(int i, ImsCallSession imsCallSession, ImsReasonInfo imsReasonInfo) {
    }

    public void writeOnImsCallResumeReceived(int i, ImsCallSession imsCallSession) {
    }

    public void writeOnImsCallResumed(int i, ImsCallSession imsCallSession) {
    }

    public void writeOnImsCallStartFailed(int i, ImsCallSession imsCallSession, ImsReasonInfo imsReasonInfo) {
    }

    public void writeOnImsCallStarted(int i, ImsCallSession imsCallSession) {
    }

    public void writeOnRilTimeoutResponse(int i, int i2, int i3) {
    }

    public static synchronized TelephonyMetrics getInstance() {
        TelephonyMetrics telephonyMetrics;
        synchronized (TelephonyMetrics.class) {
            if (sInstance == null) {
                sInstance = new TelephonyMetrics();
            }
            telephonyMetrics = sInstance;
        }
        return telephonyMetrics;
    }

    public void setContext(Context context) {
        this.mContext = context;
    }

    /* JADX WARNING: Removed duplicated region for block: B:29:0x0050  */
    /* JADX WARNING: Removed duplicated region for block: B:36:0x008c  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void dump(java.io.FileDescriptor r7, java.io.PrintWriter r8, java.lang.String[] r9) {
        /*
            r6 = this;
            monitor-enter(r6)
            if (r9 == 0) goto L_0x0093
            int r7 = r9.length     // Catch:{ all -> 0x0090 }
            if (r7 <= 0) goto L_0x0093
            int r7 = r9.length     // Catch:{ all -> 0x0090 }
            r0 = 0
            r1 = 1
            if (r7 <= r1) goto L_0x0017
            java.lang.String r7 = "--keep"
            r2 = r9[r1]     // Catch:{ all -> 0x0090 }
            boolean r7 = r7.equals(r2)     // Catch:{ all -> 0x0090 }
            if (r7 == 0) goto L_0x0017
            r7 = r0
            goto L_0x0018
        L_0x0017:
            r7 = r1
        L_0x0018:
            r9 = r9[r0]     // Catch:{ all -> 0x0090 }
            r2 = -1
            int r3 = r9.hashCode()     // Catch:{ all -> 0x0090 }
            r4 = -1953159389(0xffffffff8b952723, float:-5.74516E-32)
            r5 = 2
            if (r3 == r4) goto L_0x0044
            r0 = 513805138(0x1ea00b52, float:1.6945341E-20)
            if (r3 == r0) goto L_0x003a
            r0 = 950313125(0x38a4a0a5, float:7.850052E-5)
            if (r3 == r0) goto L_0x0030
            goto L_0x004d
        L_0x0030:
            java.lang.String r0 = "--metricsproto"
            boolean r9 = r9.equals(r0)     // Catch:{ all -> 0x0090 }
            if (r9 == 0) goto L_0x004d
            r0 = r1
            goto L_0x004e
        L_0x003a:
            java.lang.String r0 = "--metricsprototext"
            boolean r9 = r9.equals(r0)     // Catch:{ all -> 0x0090 }
            if (r9 == 0) goto L_0x004d
            r0 = r5
            goto L_0x004e
        L_0x0044:
            java.lang.String r3 = "--metrics"
            boolean r9 = r9.equals(r3)     // Catch:{ all -> 0x0090 }
            if (r9 == 0) goto L_0x004d
            goto L_0x004e
        L_0x004d:
            r0 = r2
        L_0x004e:
            if (r0 == 0) goto L_0x008c
            if (r0 == r1) goto L_0x0070
            if (r0 == r5) goto L_0x0055
            goto L_0x0093
        L_0x0055:
            com.android.internal.telephony.nano.TelephonyProto$TelephonyLog r7 = r6.buildProto()     // Catch:{ all -> 0x0090 }
            java.lang.String r7 = r7.toString()     // Catch:{ all -> 0x0090 }
            r8.println(r7)     // Catch:{ all -> 0x0090 }
            com.android.internal.telephony.metrics.RcsStats r7 = com.android.internal.telephony.metrics.RcsStats.getInstance()     // Catch:{ all -> 0x0090 }
            com.android.internal.telephony.nano.PersistAtomsProto$PersistAtoms r7 = r7.buildProto()     // Catch:{ all -> 0x0090 }
            java.lang.String r7 = r7.toString()     // Catch:{ all -> 0x0090 }
            r8.println(r7)     // Catch:{ all -> 0x0090 }
            goto L_0x0093
        L_0x0070:
            com.android.internal.telephony.nano.TelephonyProto$TelephonyLog r9 = r6.buildProto()     // Catch:{ all -> 0x0090 }
            java.lang.String r9 = convertProtoToBase64String(r9)     // Catch:{ all -> 0x0090 }
            r8.println(r9)     // Catch:{ all -> 0x0090 }
            com.android.internal.telephony.metrics.RcsStats r9 = com.android.internal.telephony.metrics.RcsStats.getInstance()     // Catch:{ all -> 0x0090 }
            java.lang.String r9 = r9.buildLog()     // Catch:{ all -> 0x0090 }
            r8.println(r9)     // Catch:{ all -> 0x0090 }
            if (r7 == 0) goto L_0x0093
            r6.reset()     // Catch:{ all -> 0x0090 }
            goto L_0x0093
        L_0x008c:
            r6.printAllMetrics(r8)     // Catch:{ all -> 0x0090 }
            goto L_0x0093
        L_0x0090:
            r7 = move-exception
            monitor-exit(r6)
            throw r7
        L_0x0093:
            monitor-exit(r6)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.TelephonyMetrics.dump(java.io.FileDescriptor, java.io.PrintWriter, java.lang.String[]):void");
    }

    private static String telephonyEventToString(int i) {
        if (i == 21) {
            return "EMERGENCY_NUMBER_REPORT";
        }
        if (i == 22) {
            return "NETWORK_CAPABILITIES_CHANGED";
        }
        switch (i) {
            case 0:
                return "UNKNOWN";
            case 1:
                return "SETTINGS_CHANGED";
            case 2:
                return "RIL_SERVICE_STATE_CHANGED";
            case 3:
                return "IMS_CONNECTION_STATE_CHANGED";
            case 4:
                return "IMS_CAPABILITIES_CHANGED";
            case 5:
                return "DATA_CALL_SETUP";
            case 6:
                return "DATA_CALL_SETUP_RESPONSE";
            case 7:
                return "DATA_CALL_LIST_CHANGED";
            case 8:
                return "DATA_CALL_DEACTIVATE";
            case 9:
                return "DATA_CALL_DEACTIVATE_RESPONSE";
            case 10:
                return "DATA_STALL_ACTION";
            case 11:
                return "MODEM_RESTART";
            case 12:
                return "NITZ_TIME";
            case 13:
                return "CARRIER_ID_MATCHING";
            default:
                return Integer.toString(i);
        }
    }

    private static String callSessionEventToString(int i) {
        switch (i) {
            case 0:
                return "EVENT_UNKNOWN";
            case 1:
                return "SETTINGS_CHANGED";
            case 2:
                return "RIL_SERVICE_STATE_CHANGED";
            case 3:
                return "IMS_CONNECTION_STATE_CHANGED";
            case 4:
                return "IMS_CAPABILITIES_CHANGED";
            case 5:
                return "DATA_CALL_LIST_CHANGED";
            case 6:
                return "RIL_REQUEST";
            case 7:
                return "RIL_RESPONSE";
            case 8:
                return "RIL_CALL_RING";
            case 9:
                return "RIL_CALL_SRVCC";
            case 10:
                return "RIL_CALL_LIST_CHANGED";
            case 11:
                return "IMS_COMMAND";
            case 12:
                return "IMS_COMMAND_RECEIVED";
            case 13:
                return "IMS_COMMAND_FAILED";
            case 14:
                return "IMS_COMMAND_COMPLETE";
            case 15:
                return "IMS_CALL_RECEIVE";
            case 16:
                return "IMS_CALL_STATE_CHANGED";
            case 17:
                return "IMS_CALL_TERMINATED";
            case 18:
                return "IMS_CALL_HANDOVER";
            case 19:
                return "IMS_CALL_HANDOVER_FAILED";
            case 20:
                return "PHONE_STATE_CHANGED";
            case 21:
                return "NITZ_TIME";
            case 22:
                return "AUDIO_CODEC";
            default:
                return Integer.toString(i);
        }
    }

    private static String smsSessionEventToString(int i) {
        switch (i) {
            case 0:
                return "EVENT_UNKNOWN";
            case 1:
                return "SETTINGS_CHANGED";
            case 2:
                return "RIL_SERVICE_STATE_CHANGED";
            case 3:
                return "IMS_CONNECTION_STATE_CHANGED";
            case 4:
                return "IMS_CAPABILITIES_CHANGED";
            case 5:
                return "DATA_CALL_LIST_CHANGED";
            case 6:
                return "SMS_SEND";
            case 7:
                return "SMS_SEND_RESULT";
            case 8:
                return "SMS_RECEIVED";
            case 10:
                return "INCOMPLETE_SMS_RECEIVED";
            default:
                return Integer.toString(i);
        }
    }

    private synchronized void printAllMetrics(PrintWriter printWriter) {
        BatteryStatsManager batteryStatsManager;
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        indentingPrintWriter.println("Telephony metrics proto:");
        indentingPrintWriter.println("------------------------------------------");
        indentingPrintWriter.println("Telephony events:");
        indentingPrintWriter.increaseIndent();
        Iterator<TelephonyProto.TelephonyEvent> it = this.mTelephonyEvents.iterator();
        while (true) {
            if (!it.hasNext()) {
                break;
            }
            TelephonyProto.TelephonyEvent next = it.next();
            indentingPrintWriter.print(next.timestampMillis);
            indentingPrintWriter.print(" [");
            indentingPrintWriter.print(next.phoneId);
            indentingPrintWriter.print("] ");
            indentingPrintWriter.print("T=");
            int i = next.type;
            if (i == 2) {
                indentingPrintWriter.print(telephonyEventToString(next.type) + "(Data RAT " + next.serviceState.dataRat + " Voice RAT " + next.serviceState.voiceRat + " Channel Number " + next.serviceState.channelNumber + " NR Frequency Range " + next.serviceState.nrFrequencyRange + " NR State " + next.serviceState.nrState + ")");
                for (int i2 = 0; i2 < next.serviceState.networkRegistrationInfo.length; i2++) {
                    indentingPrintWriter.print("reg info: domain=" + next.serviceState.networkRegistrationInfo[i2].domain + ", rat=" + next.serviceState.networkRegistrationInfo[i2].rat);
                }
            } else {
                indentingPrintWriter.print(telephonyEventToString(i));
            }
            indentingPrintWriter.println("");
        }
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("Call sessions:");
        indentingPrintWriter.increaseIndent();
        for (TelephonyProto.TelephonyCallSession next2 : this.mCompletedCallSessions) {
            indentingPrintWriter.print("Start time in minutes: " + next2.startTimeMinutes);
            indentingPrintWriter.print(", phone: " + next2.phoneId);
            if (next2.eventsDropped) {
                indentingPrintWriter.println(", events dropped: " + next2.eventsDropped);
            } else {
                indentingPrintWriter.println("");
            }
            indentingPrintWriter.println("Events: ");
            indentingPrintWriter.increaseIndent();
            for (TelephonyProto.TelephonyCallSession.Event event : next2.events) {
                indentingPrintWriter.print(event.delay);
                indentingPrintWriter.print(" T=");
                int i3 = event.type;
                if (i3 == 2) {
                    indentingPrintWriter.println(callSessionEventToString(event.type) + "(Data RAT " + event.serviceState.dataRat + " Voice RAT " + event.serviceState.voiceRat + " Channel Number " + event.serviceState.channelNumber + " NR Frequency Range " + event.serviceState.nrFrequencyRange + " NR State " + event.serviceState.nrState + ")");
                } else if (i3 == 10) {
                    indentingPrintWriter.println(callSessionEventToString(i3));
                    indentingPrintWriter.increaseIndent();
                    for (TelephonyProto.TelephonyCallSession.Event.RilCall rilCall : event.calls) {
                        indentingPrintWriter.println(rilCall.index + ". Type = " + rilCall.type + " State = " + rilCall.state + " End Reason " + rilCall.callEndReason + " Precise Disconnect Cause " + rilCall.preciseDisconnectCause + " isMultiparty = " + rilCall.isMultiparty);
                    }
                    indentingPrintWriter.decreaseIndent();
                } else if (i3 == 22) {
                    indentingPrintWriter.println(callSessionEventToString(event.type) + "(" + event.audioCodec + ")");
                } else {
                    indentingPrintWriter.println(callSessionEventToString(i3));
                }
            }
            indentingPrintWriter.decreaseIndent();
        }
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("Sms sessions:");
        indentingPrintWriter.increaseIndent();
        int i4 = 0;
        for (TelephonyProto.SmsSession next3 : this.mCompletedSmsSessions) {
            i4++;
            indentingPrintWriter.print("[" + i4 + "] Start time in minutes: " + next3.startTimeMinutes);
            StringBuilder sb = new StringBuilder();
            sb.append(", phone: ");
            sb.append(next3.phoneId);
            indentingPrintWriter.print(sb.toString());
            if (next3.eventsDropped) {
                indentingPrintWriter.println(", events dropped: " + next3.eventsDropped);
            } else {
                indentingPrintWriter.println("");
            }
            indentingPrintWriter.println("Events: ");
            indentingPrintWriter.increaseIndent();
            for (TelephonyProto.SmsSession.Event event2 : next3.events) {
                indentingPrintWriter.print(event2.delay);
                indentingPrintWriter.print(" T=");
                int i5 = event2.type;
                if (i5 == 2) {
                    indentingPrintWriter.println(smsSessionEventToString(event2.type) + "(Data RAT " + event2.serviceState.dataRat + " Voice RAT " + event2.serviceState.voiceRat + " Channel Number " + event2.serviceState.channelNumber + " NR Frequency Range " + event2.serviceState.nrFrequencyRange + " NR State " + event2.serviceState.nrState + ")");
                } else if (i5 == 8) {
                    indentingPrintWriter.println(smsSessionEventToString(i5));
                    indentingPrintWriter.increaseIndent();
                    int i6 = event2.smsType;
                    if (i6 == 1) {
                        indentingPrintWriter.println("Type: SMS-PP");
                    } else if (i6 == 2) {
                        indentingPrintWriter.println("Type: Voicemail indication");
                    } else if (i6 == 3) {
                        indentingPrintWriter.println("Type: zero");
                    } else if (i6 == 4) {
                        indentingPrintWriter.println("Type: WAP PUSH");
                    }
                    if (event2.errorCode != 0) {
                        indentingPrintWriter.println("E=" + event2.errorCode);
                    }
                    indentingPrintWriter.decreaseIndent();
                } else {
                    if (i5 != 6) {
                        if (i5 != 7) {
                            if (i5 == 10) {
                                indentingPrintWriter.println(smsSessionEventToString(i5));
                                indentingPrintWriter.increaseIndent();
                                indentingPrintWriter.println("Received: " + event2.incompleteSms.receivedParts + "/" + event2.incompleteSms.totalParts);
                                indentingPrintWriter.decreaseIndent();
                            }
                        }
                    }
                    indentingPrintWriter.println(smsSessionEventToString(i5));
                    indentingPrintWriter.increaseIndent();
                    indentingPrintWriter.println("ReqId=" + event2.rilRequestId);
                    indentingPrintWriter.println("E=" + event2.errorCode);
                    indentingPrintWriter.println("RilE=" + event2.error);
                    indentingPrintWriter.println("ImsE=" + event2.imsError);
                    indentingPrintWriter.decreaseIndent();
                }
            }
            indentingPrintWriter.decreaseIndent();
        }
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("Modem power stats:");
        indentingPrintWriter.increaseIndent();
        Context context = this.mContext;
        if (context == null) {
            batteryStatsManager = null;
        } else {
            batteryStatsManager = (BatteryStatsManager) context.getSystemService("batterystats");
        }
        TelephonyProto.ModemPowerStats buildProto = new ModemPowerMetrics(batteryStatsManager).buildProto();
        indentingPrintWriter.println("Power log duration (battery time) (ms): " + buildProto.loggingDurationMs);
        indentingPrintWriter.println("Energy consumed by modem (mAh): " + buildProto.energyConsumedMah);
        indentingPrintWriter.println("Number of packets sent (tx): " + buildProto.numPacketsTx);
        indentingPrintWriter.println("Number of bytes sent (tx): " + buildProto.numBytesTx);
        indentingPrintWriter.println("Number of packets received (rx): " + buildProto.numPacketsRx);
        indentingPrintWriter.println("Number of bytes received (rx): " + buildProto.numBytesRx);
        indentingPrintWriter.println("Amount of time kernel is active because of cellular data (ms): " + buildProto.cellularKernelActiveTimeMs);
        indentingPrintWriter.println("Amount of time spent in very poor rx signal level (ms): " + buildProto.timeInVeryPoorRxSignalLevelMs);
        indentingPrintWriter.println("Amount of time modem is in sleep (ms): " + buildProto.sleepTimeMs);
        indentingPrintWriter.println("Amount of time modem is in idle (ms): " + buildProto.idleTimeMs);
        indentingPrintWriter.println("Amount of time modem is in rx (ms): " + buildProto.rxTimeMs);
        indentingPrintWriter.println("Amount of time modem is in tx (ms): " + Arrays.toString(buildProto.txTimeMs));
        indentingPrintWriter.println("Amount of time phone spent in various Radio Access Technologies (ms): " + Arrays.toString(buildProto.timeInRatMs));
        indentingPrintWriter.println("Amount of time phone spent in various cellular rx signal strength levels (ms): " + Arrays.toString(buildProto.timeInRxSignalStrengthLevelMs));
        indentingPrintWriter.println("Energy consumed across measured modem rails (mAh): " + new DecimalFormat("#.##").format(buildProto.monitoredRailEnergyConsumedMah));
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("Hardware Version: " + SystemProperties.get("ro.boot.revision", ""));
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("LinkBandwidthEstimator stats:");
        indentingPrintWriter.increaseIndent();
        indentingPrintWriter.println("Tx");
        for (BwEstimationStats bwEstimationStats : this.mBwEstStatsMapList.get(0).values()) {
            indentingPrintWriter.println(bwEstimationStats.toString());
        }
        indentingPrintWriter.println("Rx");
        for (BwEstimationStats bwEstimationStats2 : this.mBwEstStatsMapList.get(1).values()) {
            indentingPrintWriter.println(bwEstimationStats2.toString());
        }
        RcsStats.getInstance().printAllMetrics(printWriter);
    }

    private static String convertProtoToBase64String(TelephonyProto.TelephonyLog telephonyLog) {
        return Base64.encodeToString(MessageNano.toByteArray(telephonyLog), 0);
    }

    private synchronized void reset() {
        this.mTelephonyEvents.clear();
        this.mCompletedCallSessions.clear();
        this.mCompletedSmsSessions.clear();
        this.mBwEstStatsMapList.get(0).clear();
        this.mBwEstStatsMapList.get(1).clear();
        this.mTelephonyEventsDropped = false;
        this.mStartSystemTimeMs = System.currentTimeMillis();
        long elapsedRealtime = SystemClock.elapsedRealtime();
        this.mStartElapsedTimeMs = elapsedRealtime;
        addTelephonyEvent(new TelephonyEventBuilder(elapsedRealtime, -1).setSimStateChange(this.mLastSimState).build());
        addTelephonyEvent(new TelephonyEventBuilder(this.mStartElapsedTimeMs, -1).setEnabledModemBitmap(this.mLastEnabledModemBitmap).build());
        for (int i = 0; i < this.mLastActiveSubscriptionInfos.size(); i++) {
            int keyAt = this.mLastActiveSubscriptionInfos.keyAt(i);
            addTelephonyEvent(new TelephonyEventBuilder(this.mStartElapsedTimeMs, keyAt).setActiveSubscriptionInfoChange(this.mLastActiveSubscriptionInfos.get(keyAt)).build());
        }
        for (int i2 = 0; i2 < this.mLastServiceState.size(); i2++) {
            int keyAt2 = this.mLastServiceState.keyAt(i2);
            addTelephonyEvent(new TelephonyEventBuilder(this.mStartElapsedTimeMs, keyAt2).setServiceState(this.mLastServiceState.get(keyAt2)).build());
        }
        for (int i3 = 0; i3 < this.mLastImsCapabilities.size(); i3++) {
            int keyAt3 = this.mLastImsCapabilities.keyAt(i3);
            addTelephonyEvent(new TelephonyEventBuilder(this.mStartElapsedTimeMs, keyAt3).setImsCapabilities(this.mLastImsCapabilities.get(keyAt3)).build());
        }
        for (int i4 = 0; i4 < this.mLastImsConnectionState.size(); i4++) {
            int keyAt4 = this.mLastImsConnectionState.keyAt(i4);
            addTelephonyEvent(new TelephonyEventBuilder(this.mStartElapsedTimeMs, keyAt4).setImsConnectionState(this.mLastImsConnectionState.get(keyAt4)).build());
        }
        for (int i5 = 0; i5 < this.mLastCarrierId.size(); i5++) {
            int keyAt5 = this.mLastCarrierId.keyAt(i5);
            addTelephonyEvent(new TelephonyEventBuilder(this.mStartElapsedTimeMs, keyAt5).setCarrierIdMatching(this.mLastCarrierId.get(keyAt5)).build());
        }
        for (int i6 = 0; i6 < this.mLastNetworkCapabilitiesInfos.size(); i6++) {
            int keyAt6 = this.mLastNetworkCapabilitiesInfos.keyAt(i6);
            addTelephonyEvent(new TelephonyEventBuilder(this.mStartElapsedTimeMs, keyAt6).setNetworkCapabilities(this.mLastNetworkCapabilitiesInfos.get(keyAt6)).build());
        }
        for (int i7 = 0; i7 < this.mLastRilDataCallEvents.size(); i7++) {
            int keyAt7 = this.mLastRilDataCallEvents.keyAt(i7);
            for (int i8 = 0; i8 < this.mLastRilDataCallEvents.get(keyAt7).size(); i8++) {
                addTelephonyEvent(new TelephonyEventBuilder(this.mStartElapsedTimeMs, keyAt7).setDataCalls(new TelephonyProto.RilDataCall[]{(TelephonyProto.RilDataCall) this.mLastRilDataCallEvents.get(keyAt7).get(this.mLastRilDataCallEvents.get(keyAt7).keyAt(i8))}).build());
            }
        }
        for (int i9 = 0; i9 < this.mLastRadioState.size(); i9++) {
            int keyAt8 = this.mLastRadioState.keyAt(i9);
            addTelephonyEvent(new TelephonyEventBuilder(this.mStartElapsedTimeMs, keyAt8).setRadioState(this.mLastRadioState.get(keyAt8).intValue()).build());
        }
        RcsStats.getInstance().reset();
    }

    private synchronized TelephonyProto.TelephonyLog buildProto() {
        TelephonyProto.TelephonyLog telephonyLog;
        BatteryStatsManager batteryStatsManager;
        telephonyLog = new TelephonyProto.TelephonyLog();
        TelephonyProto.TelephonyEvent[] telephonyEventArr = new TelephonyProto.TelephonyEvent[this.mTelephonyEvents.size()];
        telephonyLog.events = telephonyEventArr;
        this.mTelephonyEvents.toArray(telephonyEventArr);
        telephonyLog.eventsDropped = this.mTelephonyEventsDropped;
        TelephonyProto.TelephonyCallSession[] telephonyCallSessionArr = new TelephonyProto.TelephonyCallSession[this.mCompletedCallSessions.size()];
        telephonyLog.callSessions = telephonyCallSessionArr;
        this.mCompletedCallSessions.toArray(telephonyCallSessionArr);
        TelephonyProto.SmsSession[] smsSessionArr = new TelephonyProto.SmsSession[this.mCompletedSmsSessions.size()];
        telephonyLog.smsSessions = smsSessionArr;
        this.mCompletedSmsSessions.toArray(smsSessionArr);
        List<TelephonyHistogram> telephonyRILTimingHistograms = RIL.getTelephonyRILTimingHistograms();
        telephonyLog.histograms = new TelephonyProto.TelephonyHistogram[telephonyRILTimingHistograms.size()];
        for (int i = 0; i < telephonyRILTimingHistograms.size(); i++) {
            telephonyLog.histograms[i] = new TelephonyProto.TelephonyHistogram();
            TelephonyHistogram telephonyHistogram = telephonyRILTimingHistograms.get(i);
            TelephonyProto.TelephonyHistogram telephonyHistogram2 = telephonyLog.histograms[i];
            telephonyHistogram2.category = telephonyHistogram.getCategory();
            telephonyHistogram2.id = telephonyHistogram.getId();
            telephonyHistogram2.minTimeMillis = telephonyHistogram.getMinTime();
            telephonyHistogram2.maxTimeMillis = telephonyHistogram.getMaxTime();
            telephonyHistogram2.avgTimeMillis = telephonyHistogram.getAverageTime();
            telephonyHistogram2.count = telephonyHistogram.getSampleCount();
            telephonyHistogram2.bucketCount = telephonyHistogram.getBucketCount();
            telephonyHistogram2.bucketEndPoints = telephonyHistogram.getBucketEndPoints();
            telephonyHistogram2.bucketCounters = telephonyHistogram.getBucketCounters();
        }
        Context context = this.mContext;
        if (context == null) {
            batteryStatsManager = null;
        } else {
            batteryStatsManager = (BatteryStatsManager) context.getSystemService("batterystats");
        }
        telephonyLog.modemPowerStats = new ModemPowerMetrics(batteryStatsManager).buildProto();
        telephonyLog.hardwareRevision = SystemProperties.get("ro.boot.revision", "");
        TelephonyProto.Time time = new TelephonyProto.Time();
        telephonyLog.startTime = time;
        time.systemTimestampMillis = this.mStartSystemTimeMs;
        time.elapsedTimestampMillis = this.mStartElapsedTimeMs;
        TelephonyProto.Time time2 = new TelephonyProto.Time();
        telephonyLog.endTime = time2;
        time2.systemTimestampMillis = System.currentTimeMillis();
        telephonyLog.endTime.elapsedTimestampMillis = SystemClock.elapsedRealtime();
        int phoneCount = TelephonyManager.getDefault().getPhoneCount();
        TelephonyProto.ActiveSubscriptionInfo[] activeSubscriptionInfoArr = new TelephonyProto.ActiveSubscriptionInfo[phoneCount];
        for (int i2 = 0; i2 < this.mLastActiveSubscriptionInfos.size(); i2++) {
            int keyAt = this.mLastActiveSubscriptionInfos.keyAt(i2);
            activeSubscriptionInfoArr[keyAt] = this.mLastActiveSubscriptionInfos.get(keyAt);
        }
        for (int i3 = 0; i3 < phoneCount; i3++) {
            if (activeSubscriptionInfoArr[i3] == null) {
                activeSubscriptionInfoArr[i3] = makeInvalidSubscriptionInfo(i3);
            }
        }
        telephonyLog.lastActiveSubscriptionInfo = activeSubscriptionInfoArr;
        telephonyLog.bandwidthEstimatorStats = buildBandwidthEstimatorStats();
        return telephonyLog;
    }

    public void updateSimState(int i, int i2) {
        int mapSimStateToProto = mapSimStateToProto(i2);
        Integer num = this.mLastSimState.get(i);
        if (num == null || !num.equals(Integer.valueOf(mapSimStateToProto))) {
            this.mLastSimState.put(i, Integer.valueOf(mapSimStateToProto));
            addTelephonyEvent(new TelephonyEventBuilder(i).setSimStateChange(this.mLastSimState).build());
        }
    }

    public synchronized void updateActiveSubscriptionInfoList(List<SubscriptionInfo> list) {
        ArrayList<Integer> arrayList = new ArrayList<>();
        for (int i = 0; i < this.mLastActiveSubscriptionInfos.size(); i++) {
            arrayList.add(Integer.valueOf(this.mLastActiveSubscriptionInfos.keyAt(i)));
        }
        for (SubscriptionInfo next : list) {
            int simSlotIndex = next.getSimSlotIndex();
            arrayList.removeIf(new TelephonyMetrics$$ExternalSyntheticLambda0(simSlotIndex));
            TelephonyProto.ActiveSubscriptionInfo activeSubscriptionInfo = new TelephonyProto.ActiveSubscriptionInfo();
            activeSubscriptionInfo.slotIndex = simSlotIndex;
            activeSubscriptionInfo.isOpportunistic = next.isOpportunistic() ? 1 : 0;
            activeSubscriptionInfo.carrierId = next.getCarrierId();
            if (!(next.getMccString() == null || next.getMncString() == null)) {
                activeSubscriptionInfo.simMccmnc = next.getMccString() + next.getMncString();
            }
            if (!MessageNano.messageNanoEquals(this.mLastActiveSubscriptionInfos.get(simSlotIndex), activeSubscriptionInfo)) {
                addTelephonyEvent(new TelephonyEventBuilder(simSlotIndex).setActiveSubscriptionInfoChange(activeSubscriptionInfo).build());
                this.mLastActiveSubscriptionInfos.put(simSlotIndex, activeSubscriptionInfo);
            }
        }
        for (Integer intValue : arrayList) {
            int intValue2 = intValue.intValue();
            this.mLastActiveSubscriptionInfos.remove(intValue2);
            addTelephonyEvent(new TelephonyEventBuilder(intValue2).setActiveSubscriptionInfoChange(makeInvalidSubscriptionInfo(intValue2)).build());
        }
    }

    public void updateEnabledModemBitmap(int i) {
        if (this.mLastEnabledModemBitmap != i) {
            this.mLastEnabledModemBitmap = i;
            addTelephonyEvent(new TelephonyEventBuilder().setEnabledModemBitmap(this.mLastEnabledModemBitmap).build());
        }
    }

    private static TelephonyProto.ActiveSubscriptionInfo makeInvalidSubscriptionInfo(int i) {
        TelephonyProto.ActiveSubscriptionInfo activeSubscriptionInfo = new TelephonyProto.ActiveSubscriptionInfo();
        activeSubscriptionInfo.slotIndex = i;
        activeSubscriptionInfo.carrierId = -1;
        activeSubscriptionInfo.isOpportunistic = -1;
        return activeSubscriptionInfo;
    }

    static int roundSessionStart(long j) {
        return (int) ((j / 300000) * 5);
    }

    public void writeCarrierKeyEvent(int i, int i2, boolean z) {
        TelephonyProto.TelephonyEvent.CarrierKeyChange carrierKeyChange = new TelephonyProto.TelephonyEvent.CarrierKeyChange();
        carrierKeyChange.keyType = i2;
        carrierKeyChange.isDownloadSuccessful = z;
        addTelephonyEvent(new TelephonyEventBuilder(i).setCarrierKeyChange(carrierKeyChange).build());
    }

    private TelephonyProto.TelephonyServiceState toServiceStateProto(ServiceState serviceState) {
        TelephonyProto.TelephonyServiceState telephonyServiceState = new TelephonyProto.TelephonyServiceState();
        telephonyServiceState.voiceRoamingType = serviceState.getVoiceRoamingType();
        telephonyServiceState.dataRoamingType = serviceState.getDataRoamingType();
        telephonyServiceState.voiceOperator = new TelephonyProto.TelephonyServiceState.TelephonyOperator();
        telephonyServiceState.dataOperator = new TelephonyProto.TelephonyServiceState.TelephonyOperator();
        if (serviceState.getOperatorAlphaLong() != null) {
            telephonyServiceState.voiceOperator.alphaLong = serviceState.getOperatorAlphaLong();
            telephonyServiceState.dataOperator.alphaLong = serviceState.getOperatorAlphaLong();
        }
        if (serviceState.getOperatorAlphaShort() != null) {
            telephonyServiceState.voiceOperator.alphaShort = serviceState.getOperatorAlphaShort();
            telephonyServiceState.dataOperator.alphaShort = serviceState.getOperatorAlphaShort();
        }
        if (serviceState.getOperatorNumeric() != null) {
            telephonyServiceState.voiceOperator.numeric = serviceState.getOperatorNumeric();
            telephonyServiceState.dataOperator.numeric = serviceState.getOperatorNumeric();
        }
        ArrayList arrayList = new ArrayList();
        NetworkRegistrationInfo networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(2, 1);
        if (networkRegistrationInfo != null) {
            TelephonyProto.TelephonyServiceState.NetworkRegistrationInfo networkRegistrationInfo2 = new TelephonyProto.TelephonyServiceState.NetworkRegistrationInfo();
            networkRegistrationInfo2.domain = 2;
            networkRegistrationInfo2.transport = 1;
            networkRegistrationInfo2.rat = ServiceState.networkTypeToRilRadioTechnology(networkRegistrationInfo.getAccessNetworkTechnology());
            arrayList.add(networkRegistrationInfo2);
            TelephonyProto.TelephonyServiceState.NetworkRegistrationInfo[] networkRegistrationInfoArr = new TelephonyProto.TelephonyServiceState.NetworkRegistrationInfo[arrayList.size()];
            telephonyServiceState.networkRegistrationInfo = networkRegistrationInfoArr;
            arrayList.toArray(networkRegistrationInfoArr);
        }
        telephonyServiceState.voiceRat = serviceState.getRilVoiceRadioTechnology();
        telephonyServiceState.dataRat = serviceState.getRilDataRadioTechnology();
        telephonyServiceState.channelNumber = serviceState.getChannelNumber();
        telephonyServiceState.nrFrequencyRange = serviceState.getNrFrequencyRange();
        telephonyServiceState.nrState = serviceState.getNrState();
        return telephonyServiceState;
    }

    private synchronized void annotateInProgressCallSession(long j, int i, CallSessionEventBuilder callSessionEventBuilder) {
        InProgressCallSession inProgressCallSession = this.mInProgressCallSessions.get(i);
        if (inProgressCallSession != null) {
            inProgressCallSession.addEvent(j, callSessionEventBuilder);
        }
    }

    private synchronized void annotateInProgressSmsSession(long j, int i, SmsSessionEventBuilder smsSessionEventBuilder) {
        InProgressSmsSession inProgressSmsSession = this.mInProgressSmsSessions.get(i);
        if (inProgressSmsSession != null) {
            inProgressSmsSession.addEvent(j, smsSessionEventBuilder);
        }
    }

    private synchronized InProgressCallSession startNewCallSessionIfNeeded(int i) {
        InProgressCallSession inProgressCallSession;
        inProgressCallSession = this.mInProgressCallSessions.get(i);
        if (inProgressCallSession == null) {
            logv("Starting a new call session on phone " + i);
            inProgressCallSession = new InProgressCallSession(i);
            this.mInProgressCallSessions.append(i, inProgressCallSession);
            TelephonyProto.TelephonyServiceState telephonyServiceState = this.mLastServiceState.get(i);
            if (telephonyServiceState != null) {
                inProgressCallSession.addEvent(inProgressCallSession.startElapsedTimeMs, new CallSessionEventBuilder(2).setServiceState(telephonyServiceState));
            }
            TelephonyProto.ImsCapabilities imsCapabilities = this.mLastImsCapabilities.get(i);
            if (imsCapabilities != null) {
                inProgressCallSession.addEvent(inProgressCallSession.startElapsedTimeMs, new CallSessionEventBuilder(4).setImsCapabilities(imsCapabilities));
            }
            TelephonyProto.ImsConnectionState imsConnectionState = this.mLastImsConnectionState.get(i);
            if (imsConnectionState != null) {
                inProgressCallSession.addEvent(inProgressCallSession.startElapsedTimeMs, new CallSessionEventBuilder(3).setImsConnectionState(imsConnectionState));
            }
        }
        return inProgressCallSession;
    }

    private synchronized InProgressSmsSession startNewSmsSessionIfNeeded(int i) {
        InProgressSmsSession inProgressSmsSession;
        inProgressSmsSession = this.mInProgressSmsSessions.get(i);
        if (inProgressSmsSession == null) {
            logv("Starting a new sms session on phone " + i);
            inProgressSmsSession = startNewSmsSession(i);
            this.mInProgressSmsSessions.append(i, inProgressSmsSession);
        }
        return inProgressSmsSession;
    }

    private InProgressSmsSession startNewSmsSession(int i) {
        InProgressSmsSession inProgressSmsSession = new InProgressSmsSession(i);
        TelephonyProto.TelephonyServiceState telephonyServiceState = this.mLastServiceState.get(i);
        if (telephonyServiceState != null) {
            inProgressSmsSession.addEvent(inProgressSmsSession.startElapsedTimeMs, new SmsSessionEventBuilder(2).setServiceState(telephonyServiceState));
        }
        TelephonyProto.ImsCapabilities imsCapabilities = this.mLastImsCapabilities.get(i);
        if (imsCapabilities != null) {
            inProgressSmsSession.addEvent(inProgressSmsSession.startElapsedTimeMs, new SmsSessionEventBuilder(4).setImsCapabilities(imsCapabilities));
        }
        TelephonyProto.ImsConnectionState imsConnectionState = this.mLastImsConnectionState.get(i);
        if (imsConnectionState != null) {
            inProgressSmsSession.addEvent(inProgressSmsSession.startElapsedTimeMs, new SmsSessionEventBuilder(3).setImsConnectionState(imsConnectionState));
        }
        return inProgressSmsSession;
    }

    private synchronized void finishCallSession(InProgressCallSession inProgressCallSession) {
        TelephonyProto.TelephonyCallSession telephonyCallSession = new TelephonyProto.TelephonyCallSession();
        TelephonyProto.TelephonyCallSession.Event[] eventArr = new TelephonyProto.TelephonyCallSession.Event[inProgressCallSession.events.size()];
        telephonyCallSession.events = eventArr;
        inProgressCallSession.events.toArray(eventArr);
        telephonyCallSession.startTimeMinutes = inProgressCallSession.startSystemTimeMin;
        telephonyCallSession.phoneId = inProgressCallSession.phoneId;
        telephonyCallSession.eventsDropped = inProgressCallSession.isEventsDropped();
        if (this.mCompletedCallSessions.size() >= 50) {
            this.mCompletedCallSessions.removeFirst();
        }
        this.mCompletedCallSessions.add(telephonyCallSession);
        this.mInProgressCallSessions.remove(inProgressCallSession.phoneId);
        logv("Call session finished");
    }

    private synchronized void finishSmsSessionIfNeeded(InProgressSmsSession inProgressSmsSession) {
        if (inProgressSmsSession.getNumExpectedResponses() == 0) {
            finishSmsSession(inProgressSmsSession);
            this.mInProgressSmsSessions.remove(inProgressSmsSession.phoneId);
            logv("SMS session finished");
        }
    }

    private synchronized TelephonyProto.SmsSession finishSmsSession(InProgressSmsSession inProgressSmsSession) {
        TelephonyProto.SmsSession smsSession;
        smsSession = new TelephonyProto.SmsSession();
        TelephonyProto.SmsSession.Event[] eventArr = new TelephonyProto.SmsSession.Event[inProgressSmsSession.events.size()];
        smsSession.events = eventArr;
        inProgressSmsSession.events.toArray(eventArr);
        smsSession.startTimeMinutes = inProgressSmsSession.startSystemTimeMin;
        smsSession.phoneId = inProgressSmsSession.phoneId;
        smsSession.eventsDropped = inProgressSmsSession.isEventsDropped();
        if (this.mCompletedSmsSessions.size() >= 500) {
            this.mCompletedSmsSessions.removeFirst();
        }
        this.mCompletedSmsSessions.add(smsSession);
        return smsSession;
    }

    private synchronized void addTelephonyEvent(TelephonyProto.TelephonyEvent telephonyEvent) {
        if (this.mTelephonyEvents.size() >= 1000) {
            this.mTelephonyEvents.removeFirst();
            this.mTelephonyEventsDropped = true;
        }
        this.mTelephonyEvents.add(telephonyEvent);
    }

    public synchronized void writeServiceStateChanged(int i, ServiceState serviceState) {
        TelephonyProto.TelephonyEvent build = new TelephonyEventBuilder(i).setServiceState(toServiceStateProto(serviceState)).build();
        if (this.mLastServiceState.get(i) == null || !Arrays.equals(MessageNano.toByteArray(this.mLastServiceState.get(i)), MessageNano.toByteArray(build.serviceState))) {
            this.mLastServiceState.put(i, build.serviceState);
            addTelephonyEvent(build);
            annotateInProgressCallSession(build.timestampMillis, i, new CallSessionEventBuilder(2).setServiceState(build.serviceState));
            annotateInProgressSmsSession(build.timestampMillis, i, new SmsSessionEventBuilder(2).setServiceState(build.serviceState));
        }
    }

    public void writeDataStallEvent(int i, int i2) {
        addTelephonyEvent(new TelephonyEventBuilder(i).setDataStallRecoveryAction(i2).build());
    }

    public void writeSignalStrengthEvent(int i, int i2) {
        addTelephonyEvent(new TelephonyEventBuilder(i).setSignalStrength(i2).build());
    }

    private TelephonyProto.TelephonySettings cloneCurrentTelephonySettings(int i) {
        TelephonyProto.TelephonySettings telephonySettings = new TelephonyProto.TelephonySettings();
        TelephonyProto.TelephonySettings telephonySettings2 = this.mLastSettings.get(i);
        if (telephonySettings2 != null) {
            telephonySettings.preferredNetworkMode = telephonySettings2.preferredNetworkMode;
            telephonySettings.isEnhanced4GLteModeEnabled = telephonySettings2.isEnhanced4GLteModeEnabled;
            telephonySettings.isVtOverLteEnabled = telephonySettings2.isVtOverLteEnabled;
            telephonySettings.isWifiCallingEnabled = telephonySettings2.isWifiCallingEnabled;
            telephonySettings.isVtOverWifiEnabled = telephonySettings2.isVtOverWifiEnabled;
        }
        return telephonySettings;
    }

    public synchronized void writeImsSetFeatureValue(int i, int i2, int i3, int i4) {
        TelephonyProto.TelephonySettings cloneCurrentTelephonySettings = cloneCurrentTelephonySettings(i);
        boolean z = false;
        if (i3 == 0) {
            if (i2 == 1) {
                if (i4 != 0) {
                    z = true;
                }
                cloneCurrentTelephonySettings.isEnhanced4GLteModeEnabled = z;
            } else if (i2 == 2) {
                if (i4 != 0) {
                    z = true;
                }
                cloneCurrentTelephonySettings.isVtOverLteEnabled = z;
            }
        } else if (i3 == 1) {
            if (i2 == 1) {
                if (i4 != 0) {
                    z = true;
                }
                cloneCurrentTelephonySettings.isWifiCallingEnabled = z;
            } else if (i2 == 2) {
                if (i4 != 0) {
                    z = true;
                }
                cloneCurrentTelephonySettings.isVtOverWifiEnabled = z;
            }
        }
        if (this.mLastSettings.get(i) == null || !Arrays.equals(MessageNano.toByteArray(this.mLastSettings.get(i)), MessageNano.toByteArray(cloneCurrentTelephonySettings))) {
            this.mLastSettings.put(i, cloneCurrentTelephonySettings);
            TelephonyProto.TelephonyEvent build = new TelephonyEventBuilder(i).setSettings(cloneCurrentTelephonySettings).build();
            addTelephonyEvent(build);
            annotateInProgressCallSession(build.timestampMillis, i, new CallSessionEventBuilder(1).setSettings(cloneCurrentTelephonySettings));
            annotateInProgressSmsSession(build.timestampMillis, i, new SmsSessionEventBuilder(1).setSettings(cloneCurrentTelephonySettings));
        }
    }

    public synchronized void writeSetPreferredNetworkType(int i, int i2) {
        TelephonyProto.TelephonySettings cloneCurrentTelephonySettings = cloneCurrentTelephonySettings(i);
        cloneCurrentTelephonySettings.preferredNetworkMode = i2 + 1;
        if (this.mLastSettings.get(i) == null || !Arrays.equals(MessageNano.toByteArray(this.mLastSettings.get(i)), MessageNano.toByteArray(cloneCurrentTelephonySettings))) {
            this.mLastSettings.put(i, cloneCurrentTelephonySettings);
            addTelephonyEvent(new TelephonyEventBuilder(i).setSettings(cloneCurrentTelephonySettings).build());
        }
    }

    public synchronized void writeOnImsConnectionState(int i, int i2, ImsReasonInfo imsReasonInfo) {
        TelephonyProto.ImsConnectionState imsConnectionState = new TelephonyProto.ImsConnectionState();
        imsConnectionState.state = i2;
        if (imsReasonInfo != null) {
            TelephonyProto.ImsReasonInfo imsReasonInfo2 = new TelephonyProto.ImsReasonInfo();
            imsReasonInfo2.reasonCode = imsReasonInfo.getCode();
            imsReasonInfo2.extraCode = imsReasonInfo.getExtraCode();
            String extraMessage = imsReasonInfo.getExtraMessage();
            if (extraMessage != null) {
                imsReasonInfo2.extraMessage = extraMessage;
            }
            imsConnectionState.reasonInfo = imsReasonInfo2;
        }
        if (this.mLastImsConnectionState.get(i) == null || !Arrays.equals(MessageNano.toByteArray(this.mLastImsConnectionState.get(i)), MessageNano.toByteArray(imsConnectionState))) {
            this.mLastImsConnectionState.put(i, imsConnectionState);
            TelephonyProto.TelephonyEvent build = new TelephonyEventBuilder(i).setImsConnectionState(imsConnectionState).build();
            addTelephonyEvent(build);
            annotateInProgressCallSession(build.timestampMillis, i, new CallSessionEventBuilder(3).setImsConnectionState(build.imsConnectionState));
            annotateInProgressSmsSession(build.timestampMillis, i, new SmsSessionEventBuilder(3).setImsConnectionState(build.imsConnectionState));
        }
    }

    public synchronized void writeOnImsCapabilities(int i, int i2, MmTelFeature.MmTelCapabilities mmTelCapabilities) {
        TelephonyProto.ImsCapabilities imsCapabilities = new TelephonyProto.ImsCapabilities();
        if (i2 == 0) {
            imsCapabilities.voiceOverLte = mmTelCapabilities.isCapable(1);
            imsCapabilities.videoOverLte = mmTelCapabilities.isCapable(2);
            imsCapabilities.utOverLte = mmTelCapabilities.isCapable(4);
        } else if (i2 == 1) {
            imsCapabilities.voiceOverWifi = mmTelCapabilities.isCapable(1);
            imsCapabilities.videoOverWifi = mmTelCapabilities.isCapable(2);
            imsCapabilities.utOverWifi = mmTelCapabilities.isCapable(4);
        }
        TelephonyProto.TelephonyEvent build = new TelephonyEventBuilder(i).setImsCapabilities(imsCapabilities).build();
        if (this.mLastImsCapabilities.get(i) == null || !Arrays.equals(MessageNano.toByteArray(this.mLastImsCapabilities.get(i)), MessageNano.toByteArray(imsCapabilities))) {
            this.mLastImsCapabilities.put(i, imsCapabilities);
            addTelephonyEvent(build);
            annotateInProgressCallSession(build.timestampMillis, i, new CallSessionEventBuilder(4).setImsCapabilities(build.imsCapabilities));
            annotateInProgressSmsSession(build.timestampMillis, i, new SmsSessionEventBuilder(4).setImsCapabilities(build.imsCapabilities));
        }
    }

    private int toPdpType(String str) {
        str.hashCode();
        char c = 65535;
        switch (str.hashCode()) {
            case -2128542875:
                if (str.equals("IPV4V6")) {
                    c = 0;
                    break;
                }
                break;
            case -1986566073:
                if (str.equals("NON-IP")) {
                    c = 1;
                    break;
                }
                break;
            case 2343:
                if (str.equals("IP")) {
                    c = 2;
                    break;
                }
                break;
            case 79440:
                if (str.equals("PPP")) {
                    c = 3;
                    break;
                }
                break;
            case 2254343:
                if (str.equals("IPV6")) {
                    c = 4;
                    break;
                }
                break;
            case 329043114:
                if (str.equals("UNSTRUCTURED")) {
                    c = 5;
                    break;
                }
                break;
        }
        switch (c) {
            case 0:
                return 3;
            case 1:
                return 5;
            case 2:
                return 1;
            case 3:
                return 4;
            case 4:
                return 2;
            case 5:
                return 6;
            default:
                Rlog.e(TAG, "Unknown type: " + str);
                return 0;
        }
    }

    public void writeSetupDataCall(int i, int i2, int i3, String str, int i4) {
        TelephonyProto.TelephonyEvent.RilSetupDataCall rilSetupDataCall = new TelephonyProto.TelephonyEvent.RilSetupDataCall();
        rilSetupDataCall.rat = i2;
        rilSetupDataCall.dataProfile = i3 + 1;
        if (str != null) {
            rilSetupDataCall.apn = str;
        }
        rilSetupDataCall.type = i4 + 1;
        addTelephonyEvent(new TelephonyEventBuilder(i).setSetupDataCall(rilSetupDataCall).build());
    }

    public void writeRilDeactivateDataCall(int i, int i2, int i3, int i4) {
        TelephonyProto.TelephonyEvent.RilDeactivateDataCall rilDeactivateDataCall = new TelephonyProto.TelephonyEvent.RilDeactivateDataCall();
        rilDeactivateDataCall.cid = i3;
        if (i4 == 1) {
            rilDeactivateDataCall.reason = 1;
        } else if (i4 == 2) {
            rilDeactivateDataCall.reason = 2;
        } else if (i4 != 3) {
            rilDeactivateDataCall.reason = 0;
        } else {
            rilDeactivateDataCall.reason = 4;
        }
        addTelephonyEvent(new TelephonyEventBuilder(i).setDeactivateDataCall(rilDeactivateDataCall).build());
    }

    public void writeRilDataCallEvent(int i, int i2, int i3, int i4) {
        SparseArray sparseArray;
        TelephonyProto.RilDataCall rilDataCall = new TelephonyProto.RilDataCall();
        TelephonyProto.RilDataCall[] rilDataCallArr = {rilDataCall};
        rilDataCall.cid = i2;
        rilDataCall.apnTypeBitmask = i3;
        rilDataCall.state = i4;
        if (this.mLastRilDataCallEvents.get(i) == null) {
            sparseArray = new SparseArray();
        } else if (this.mLastRilDataCallEvents.get(i).get(i2) == null || !Arrays.equals(MessageNano.toByteArray((MessageNano) this.mLastRilDataCallEvents.get(i).get(i2)), MessageNano.toByteArray(rilDataCallArr[0]))) {
            sparseArray = this.mLastRilDataCallEvents.get(i);
        } else {
            return;
        }
        sparseArray.put(i2, rilDataCallArr[0]);
        this.mLastRilDataCallEvents.put(i, sparseArray);
        addTelephonyEvent(new TelephonyEventBuilder(i).setDataCalls(rilDataCallArr).build());
    }

    public void writeRilCallList(int i, ArrayList<GsmCdmaConnection> arrayList, String str) {
        logv("Logging CallList Changed Connections Size = " + arrayList.size());
        InProgressCallSession startNewCallSessionIfNeeded = startNewCallSessionIfNeeded(i);
        if (startNewCallSessionIfNeeded == null) {
            Rlog.e(TAG, "writeRilCallList: Call session is missing");
            return;
        }
        TelephonyProto.TelephonyCallSession.Event.RilCall[] convertConnectionsToRilCalls = convertConnectionsToRilCalls(arrayList, str);
        startNewCallSessionIfNeeded.addEvent(new CallSessionEventBuilder(10).setRilCalls(convertConnectionsToRilCalls));
        logv("Logged Call list changed");
        if (startNewCallSessionIfNeeded.isPhoneIdle() && disconnectReasonsKnown(convertConnectionsToRilCalls)) {
            finishCallSession(startNewCallSessionIfNeeded);
        }
    }

    private boolean disconnectReasonsKnown(TelephonyProto.TelephonyCallSession.Event.RilCall[] rilCallArr) {
        for (TelephonyProto.TelephonyCallSession.Event.RilCall rilCall : rilCallArr) {
            if (rilCall.callEndReason == 0) {
                return false;
            }
        }
        return true;
    }

    private TelephonyProto.TelephonyCallSession.Event.RilCall[] convertConnectionsToRilCalls(ArrayList<GsmCdmaConnection> arrayList, String str) {
        TelephonyProto.TelephonyCallSession.Event.RilCall[] rilCallArr = new TelephonyProto.TelephonyCallSession.Event.RilCall[arrayList.size()];
        for (int i = 0; i < arrayList.size(); i++) {
            TelephonyProto.TelephonyCallSession.Event.RilCall rilCall = new TelephonyProto.TelephonyCallSession.Event.RilCall();
            rilCallArr[i] = rilCall;
            rilCall.index = i;
            convertConnectionToRilCall(arrayList.get(i), rilCallArr[i], str);
        }
        return rilCallArr;
    }

    private TelephonyProto.EmergencyNumberInfo convertEmergencyNumberToEmergencyNumberInfo(EmergencyNumber emergencyNumber) {
        TelephonyProto.EmergencyNumberInfo emergencyNumberInfo = new TelephonyProto.EmergencyNumberInfo();
        emergencyNumberInfo.address = emergencyNumber.getNumber();
        emergencyNumberInfo.countryIso = emergencyNumber.getCountryIso();
        emergencyNumberInfo.mnc = emergencyNumber.getMnc();
        emergencyNumberInfo.serviceCategoriesBitmask = emergencyNumber.getEmergencyServiceCategoryBitmask();
        emergencyNumberInfo.urns = (String[]) emergencyNumber.getEmergencyUrns().stream().toArray(new TelephonyMetrics$$ExternalSyntheticLambda1());
        emergencyNumberInfo.numberSourcesBitmask = emergencyNumber.getEmergencyNumberSourceBitmask();
        emergencyNumberInfo.routing = emergencyNumber.getEmergencyCallRouting();
        return emergencyNumberInfo;
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ String[] lambda$convertEmergencyNumberToEmergencyNumberInfo$1(int i) {
        return new String[i];
    }

    private void convertConnectionToRilCall(GsmCdmaConnection gsmCdmaConnection, TelephonyProto.TelephonyCallSession.Event.RilCall rilCall, String str) {
        if (gsmCdmaConnection.isIncoming()) {
            rilCall.type = 2;
        } else {
            rilCall.type = 1;
        }
        switch (AnonymousClass1.$SwitchMap$com$android$internal$telephony$Call$State[gsmCdmaConnection.getState().ordinal()]) {
            case 1:
                rilCall.state = 1;
                break;
            case 2:
                rilCall.state = 2;
                break;
            case 3:
                rilCall.state = 3;
                break;
            case 4:
                rilCall.state = 4;
                break;
            case 5:
                rilCall.state = 5;
                break;
            case 6:
                rilCall.state = 6;
                break;
            case 7:
                rilCall.state = 7;
                break;
            case 8:
                rilCall.state = 8;
                break;
            case 9:
                rilCall.state = 9;
                break;
            default:
                rilCall.state = 0;
                break;
        }
        rilCall.callEndReason = gsmCdmaConnection.getDisconnectCause();
        rilCall.isMultiparty = gsmCdmaConnection.isMultiparty();
        rilCall.preciseDisconnectCause = gsmCdmaConnection.getPreciseDisconnectCause();
        if (gsmCdmaConnection.getDisconnectCause() != 0 && gsmCdmaConnection.isEmergencyCall() && gsmCdmaConnection.getEmergencyNumberInfo() != null && ThreadLocalRandom.current().nextDouble(0.0d, 100.0d) < getSamplePercentageForEmergencyCall(str)) {
            rilCall.isEmergencyCall = gsmCdmaConnection.isEmergencyCall();
            rilCall.emergencyNumberInfo = convertEmergencyNumberToEmergencyNumberInfo(gsmCdmaConnection.getEmergencyNumberInfo());
            EmergencyNumberTracker emergencyNumberTracker = gsmCdmaConnection.getEmergencyNumberTracker();
            rilCall.emergencyNumberDatabaseVersion = emergencyNumberTracker != null ? emergencyNumberTracker.getEmergencyNumberDbVersion() : -1;
        }
    }

    public void writeRilDial(int i, GsmCdmaConnection gsmCdmaConnection, int i2, UUSInfo uUSInfo) {
        InProgressCallSession startNewCallSessionIfNeeded = startNewCallSessionIfNeeded(i);
        logv("Logging Dial Connection = " + gsmCdmaConnection);
        if (startNewCallSessionIfNeeded == null) {
            Rlog.e(TAG, "writeRilDial: Call session is missing");
            return;
        }
        TelephonyProto.TelephonyCallSession.Event.RilCall rilCall = new TelephonyProto.TelephonyCallSession.Event.RilCall();
        rilCall.index = -1;
        convertConnectionToRilCall(gsmCdmaConnection, rilCall, "");
        startNewCallSessionIfNeeded.addEvent(startNewCallSessionIfNeeded.startElapsedTimeMs, new CallSessionEventBuilder(6).setRilRequest(1).setRilCalls(new TelephonyProto.TelephonyCallSession.Event.RilCall[]{rilCall}));
        logv("Logged Dial event");
    }

    public void writeRilCallRing(int i, char[] cArr) {
        InProgressCallSession startNewCallSessionIfNeeded = startNewCallSessionIfNeeded(i);
        startNewCallSessionIfNeeded.addEvent(startNewCallSessionIfNeeded.startElapsedTimeMs, new CallSessionEventBuilder(8));
    }

    public void writeRilHangup(int i, GsmCdmaConnection gsmCdmaConnection, int i2, String str) {
        InProgressCallSession inProgressCallSession = this.mInProgressCallSessions.get(i);
        if (inProgressCallSession == null) {
            Rlog.e(TAG, "writeRilHangup: Call session is missing");
            return;
        }
        TelephonyProto.TelephonyCallSession.Event.RilCall rilCall = new TelephonyProto.TelephonyCallSession.Event.RilCall();
        rilCall.index = i2;
        convertConnectionToRilCall(gsmCdmaConnection, rilCall, str);
        inProgressCallSession.addEvent(new CallSessionEventBuilder(6).setRilRequest(3).setRilCalls(new TelephonyProto.TelephonyCallSession.Event.RilCall[]{rilCall}));
        logv("Logged Hangup event");
    }

    public void writeRilAnswer(int i, int i2) {
        InProgressCallSession inProgressCallSession = this.mInProgressCallSessions.get(i);
        if (inProgressCallSession == null) {
            Rlog.e(TAG, "writeRilAnswer: Call session is missing");
        } else {
            inProgressCallSession.addEvent(new CallSessionEventBuilder(6).setRilRequest(2).setRilRequestId(i2));
        }
    }

    public void writeRilSrvcc(int i, int i2) {
        InProgressCallSession inProgressCallSession = this.mInProgressCallSessions.get(i);
        if (inProgressCallSession == null) {
            Rlog.e(TAG, "writeRilSrvcc: Call session is missing");
        } else {
            inProgressCallSession.addEvent(new CallSessionEventBuilder(9).setSrvccState(i2 + 1));
        }
    }

    private int toCallSessionRilRequest(int i) {
        if (i == 10) {
            return 1;
        }
        if (i == 36) {
            return 4;
        }
        if (i == 40) {
            return 2;
        }
        if (i == 84) {
            return 6;
        }
        switch (i) {
            case 12:
            case 13:
            case 14:
                return 3;
            case 15:
                return 5;
            case 16:
                return 7;
            default:
                String str = TAG;
                Rlog.e(str, "Unknown RIL request: " + i);
                return 0;
        }
    }

    private void writeOnSetupDataCallResponse(int i, int i2, int i3, int i4, DataCallResponse dataCallResponse) {
        int i5;
        TelephonyProto.TelephonyEvent.RilSetupDataCallResponse rilSetupDataCallResponse = new TelephonyProto.TelephonyEvent.RilSetupDataCallResponse();
        TelephonyProto.RilDataCall rilDataCall = new TelephonyProto.RilDataCall();
        if (dataCallResponse != null) {
            if (dataCallResponse.getCause() == 0) {
                i5 = 1;
            } else {
                i5 = dataCallResponse.getCause();
            }
            rilSetupDataCallResponse.status = i5;
            rilSetupDataCallResponse.suggestedRetryTimeMillis = dataCallResponse.getSuggestedRetryTime();
            rilDataCall.cid = dataCallResponse.getId();
            rilDataCall.type = dataCallResponse.getProtocolType() + 1;
            if (!TextUtils.isEmpty(dataCallResponse.getInterfaceName())) {
                rilDataCall.ifname = dataCallResponse.getInterfaceName();
            }
        }
        rilSetupDataCallResponse.call = rilDataCall;
        addTelephonyEvent(new TelephonyEventBuilder(i).setSetupDataCallResponse(rilSetupDataCallResponse).build());
    }

    private void writeOnCallSolicitedResponse(int i, int i2, int i3, int i4) {
        InProgressCallSession inProgressCallSession = this.mInProgressCallSessions.get(i);
        if (inProgressCallSession == null) {
            Rlog.e(TAG, "writeOnCallSolicitedResponse: Call session is missing");
        } else {
            inProgressCallSession.addEvent(new CallSessionEventBuilder(7).setRilRequest(toCallSessionRilRequest(i4)).setRilRequestId(i2).setRilError(i3 + 1));
        }
    }

    private synchronized void writeOnSmsSolicitedResponse(int i, int i2, int i3, SmsResponse smsResponse) {
        InProgressSmsSession inProgressSmsSession = this.mInProgressSmsSessions.get(i);
        if (inProgressSmsSession == null) {
            Rlog.e(TAG, "SMS session is missing");
        } else {
            int i4 = -1;
            long j = 0;
            if (smsResponse != null) {
                i4 = smsResponse.mErrorCode;
                j = smsResponse.mMessageId;
            }
            inProgressSmsSession.addEvent(new SmsSessionEventBuilder(7).setErrorCode(i4).setRilErrno(i3 + 1).setRilRequestId(i2).setMessageId(j));
            inProgressSmsSession.decreaseExpectedResponse();
            finishSmsSessionIfNeeded(inProgressSmsSession);
        }
    }

    public synchronized void writeOnImsServiceSmsSolicitedResponse(int i, int i2, int i3, long j) {
        InProgressSmsSession inProgressSmsSession = this.mInProgressSmsSessions.get(i);
        if (inProgressSmsSession == null) {
            Rlog.e(TAG, "SMS session is missing");
        } else {
            inProgressSmsSession.addEvent(new SmsSessionEventBuilder(7).setImsServiceErrno(i2).setErrorCode(i3).setMessageId(j));
            inProgressSmsSession.decreaseExpectedResponse();
            finishSmsSessionIfNeeded(inProgressSmsSession);
        }
    }

    private void writeOnDeactivateDataCallResponse(int i, int i2) {
        addTelephonyEvent(new TelephonyEventBuilder(i).setDeactivateDataCallResponse(i2 + 1).build());
    }

    public void writeOnRilSolicitedResponse(int i, int i2, int i3, int i4, Object obj) {
        if (i4 != 10) {
            if (!(i4 == 87 || i4 == 113)) {
                if (i4 != 40) {
                    if (i4 != 41) {
                        switch (i4) {
                            case 12:
                            case 13:
                            case 14:
                                break;
                            default:
                                switch (i4) {
                                    case 25:
                                    case 26:
                                        break;
                                    case 27:
                                        writeOnSetupDataCallResponse(i, i2, i3, i4, (DataCallResponse) obj);
                                        return;
                                    default:
                                        return;
                                }
                        }
                    } else {
                        writeOnDeactivateDataCallResponse(i, i3);
                        return;
                    }
                }
            }
            writeOnSmsSolicitedResponse(i, i2, i3, (SmsResponse) obj);
            return;
        }
        writeOnCallSolicitedResponse(i, i2, i3, i4);
    }

    public void writeNetworkValidate(int i) {
        addTelephonyEvent(new TelephonyEventBuilder().setNetworkValidate(i).build());
    }

    public void writeDataSwitch(int i, TelephonyProto.TelephonyEvent.DataSwitch dataSwitch) {
        addTelephonyEvent(new TelephonyEventBuilder(SubscriptionManager.getPhoneId(i)).setDataSwitch(dataSwitch).build());
    }

    public void writeOnDemandDataSwitch(TelephonyProto.TelephonyEvent.OnDemandDataSwitch onDemandDataSwitch) {
        addTelephonyEvent(new TelephonyEventBuilder().setOnDemandDataSwitch(onDemandDataSwitch).build());
    }

    /* renamed from: com.android.internal.telephony.metrics.TelephonyMetrics$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$Call$State;
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$PhoneConstants$State;

        /* JADX WARNING: Can't wrap try/catch for region: R(27:0|(2:1|2)|3|(2:5|6)|7|9|10|11|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|32) */
        /* JADX WARNING: Can't wrap try/catch for region: R(28:0|1|2|3|(2:5|6)|7|9|10|11|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|32) */
        /* JADX WARNING: Code restructure failed: missing block: B:33:?, code lost:
            return;
         */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:15:0x0039 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:17:0x0043 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:19:0x004d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:21:0x0058 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:23:0x0063 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:25:0x006e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:27:0x0079 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:29:0x0085 */
        static {
            /*
                com.android.internal.telephony.PhoneConstants$State[] r0 = com.android.internal.telephony.PhoneConstants.State.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$PhoneConstants$State = r0
                r1 = 1
                com.android.internal.telephony.PhoneConstants$State r2 = com.android.internal.telephony.PhoneConstants.State.IDLE     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r2 = r2.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r0[r2] = r1     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                r0 = 2
                int[] r2 = $SwitchMap$com$android$internal$telephony$PhoneConstants$State     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.PhoneConstants$State r3 = com.android.internal.telephony.PhoneConstants.State.RINGING     // Catch:{ NoSuchFieldError -> 0x001d }
                int r3 = r3.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2[r3] = r0     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                r2 = 3
                int[] r3 = $SwitchMap$com$android$internal$telephony$PhoneConstants$State     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.PhoneConstants$State r4 = com.android.internal.telephony.PhoneConstants.State.OFFHOOK     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r3[r4] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                com.android.internal.telephony.Call$State[] r3 = com.android.internal.telephony.Call.State.values()
                int r3 = r3.length
                int[] r3 = new int[r3]
                $SwitchMap$com$android$internal$telephony$Call$State = r3
                com.android.internal.telephony.Call$State r4 = com.android.internal.telephony.Call.State.IDLE     // Catch:{ NoSuchFieldError -> 0x0039 }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x0039 }
                r3[r4] = r1     // Catch:{ NoSuchFieldError -> 0x0039 }
            L_0x0039:
                int[] r1 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x0043 }
                com.android.internal.telephony.Call$State r3 = com.android.internal.telephony.Call.State.ACTIVE     // Catch:{ NoSuchFieldError -> 0x0043 }
                int r3 = r3.ordinal()     // Catch:{ NoSuchFieldError -> 0x0043 }
                r1[r3] = r0     // Catch:{ NoSuchFieldError -> 0x0043 }
            L_0x0043:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x004d }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.HOLDING     // Catch:{ NoSuchFieldError -> 0x004d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x004d }
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x004d }
            L_0x004d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x0058 }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.DIALING     // Catch:{ NoSuchFieldError -> 0x0058 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0058 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0058 }
            L_0x0058:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x0063 }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.ALERTING     // Catch:{ NoSuchFieldError -> 0x0063 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0063 }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0063 }
            L_0x0063:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x006e }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.INCOMING     // Catch:{ NoSuchFieldError -> 0x006e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x006e }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x006e }
            L_0x006e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x0079 }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.WAITING     // Catch:{ NoSuchFieldError -> 0x0079 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0079 }
                r2 = 7
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0079 }
            L_0x0079:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x0085 }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.DISCONNECTED     // Catch:{ NoSuchFieldError -> 0x0085 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0085 }
                r2 = 8
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0085 }
            L_0x0085:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x0091 }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.DISCONNECTING     // Catch:{ NoSuchFieldError -> 0x0091 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0091 }
                r2 = 9
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0091 }
            L_0x0091:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.TelephonyMetrics.AnonymousClass1.<clinit>():void");
        }
    }

    public void writePhoneState(int i, PhoneConstants.State state) {
        int i2 = AnonymousClass1.$SwitchMap$com$android$internal$telephony$PhoneConstants$State[state.ordinal()];
        int i3 = 3;
        if (i2 == 1) {
            i3 = 1;
        } else if (i2 == 2) {
            i3 = 2;
        } else if (i2 != 3) {
            i3 = 0;
        }
        InProgressCallSession inProgressCallSession = this.mInProgressCallSessions.get(i);
        if (inProgressCallSession == null) {
            Rlog.e(TAG, "writePhoneState: Call session is missing");
            return;
        }
        inProgressCallSession.setLastKnownPhoneState(i3);
        if (i3 == 1 && !inProgressCallSession.containsCsCalls()) {
            finishCallSession(inProgressCallSession);
        }
        inProgressCallSession.addEvent(new CallSessionEventBuilder(20).setPhoneState(i3));
    }

    private int getCallId(ImsCallSession imsCallSession) {
        if (imsCallSession == null) {
            return -1;
        }
        try {
            return Integer.parseInt(imsCallSession.getCallId());
        } catch (NumberFormatException unused) {
            return -1;
        }
    }

    public void writeImsCallState(int i, ImsCallSession imsCallSession, Call.State state) {
        int i2;
        switch (AnonymousClass1.$SwitchMap$com$android$internal$telephony$Call$State[state.ordinal()]) {
            case 1:
                i2 = 1;
                break;
            case 2:
                i2 = 2;
                break;
            case 3:
                i2 = 3;
                break;
            case 4:
                i2 = 4;
                break;
            case 5:
                i2 = 5;
                break;
            case 6:
                i2 = 6;
                break;
            case 7:
                i2 = 7;
                break;
            case 8:
                i2 = 8;
                break;
            case 9:
                i2 = 9;
                break;
            default:
                i2 = 0;
                break;
        }
        InProgressCallSession inProgressCallSession = this.mInProgressCallSessions.get(i);
        if (inProgressCallSession == null) {
            Rlog.e(TAG, "Call session is missing");
        } else {
            inProgressCallSession.addEvent(new CallSessionEventBuilder(16).setCallIndex(getCallId(imsCallSession)).setCallState(i2));
        }
    }

    public void writeOnImsCallStart(int i, ImsCallSession imsCallSession) {
        startNewCallSessionIfNeeded(i).addEvent(new CallSessionEventBuilder(11).setCallIndex(getCallId(imsCallSession)).setImsCommand(1));
    }

    public void writeOnImsCallReceive(int i, ImsCallSession imsCallSession) {
        startNewCallSessionIfNeeded(i).addEvent(new CallSessionEventBuilder(15).setCallIndex(getCallId(imsCallSession)));
    }

    public void writeOnImsCommand(int i, ImsCallSession imsCallSession, int i2) {
        InProgressCallSession inProgressCallSession = this.mInProgressCallSessions.get(i);
        if (inProgressCallSession == null) {
            Rlog.e(TAG, "Call session is missing");
        } else {
            inProgressCallSession.addEvent(new CallSessionEventBuilder(11).setCallIndex(getCallId(imsCallSession)).setImsCommand(i2));
        }
    }

    private TelephonyProto.ImsReasonInfo toImsReasonInfoProto(ImsReasonInfo imsReasonInfo) {
        TelephonyProto.ImsReasonInfo imsReasonInfo2 = new TelephonyProto.ImsReasonInfo();
        if (imsReasonInfo != null) {
            imsReasonInfo2.reasonCode = imsReasonInfo.getCode();
            imsReasonInfo2.extraCode = imsReasonInfo.getExtraCode();
            String extraMessage = imsReasonInfo.getExtraMessage();
            if (extraMessage != null) {
                imsReasonInfo2.extraMessage = extraMessage;
            }
        }
        return imsReasonInfo2;
    }

    public static TelephonyProto.TelephonyCallSession.Event.CallQuality toCallQualityProto(CallQuality callQuality) {
        TelephonyProto.TelephonyCallSession.Event.CallQuality callQuality2 = new TelephonyProto.TelephonyCallSession.Event.CallQuality();
        if (callQuality != null) {
            callQuality2.downlinkLevel = callQualityLevelToProtoEnum(callQuality.getDownlinkCallQualityLevel());
            callQuality2.uplinkLevel = callQualityLevelToProtoEnum(callQuality.getUplinkCallQualityLevel());
            callQuality2.durationInSeconds = callQuality.getCallDuration() / 1000;
            callQuality2.rtpPacketsTransmitted = callQuality.getNumRtpPacketsTransmitted();
            callQuality2.rtpPacketsReceived = callQuality.getNumRtpPacketsReceived();
            callQuality2.rtpPacketsTransmittedLost = callQuality.getNumRtpPacketsTransmittedLost();
            callQuality2.rtpPacketsNotReceived = callQuality.getNumRtpPacketsNotReceived();
            callQuality2.averageRelativeJitterMillis = callQuality.getAverageRelativeJitter();
            callQuality2.maxRelativeJitterMillis = callQuality.getMaxRelativeJitter();
            callQuality2.codecType = convertImsCodec(callQuality.getCodecType());
            callQuality2.rtpInactivityDetected = callQuality.isRtpInactivityDetected();
            callQuality2.rxSilenceDetected = callQuality.isIncomingSilenceDetectedAtCallSetup();
            callQuality2.txSilenceDetected = callQuality.isOutgoingSilenceDetectedAtCallSetup();
            callQuality2.voiceFrames = callQuality.getNumVoiceFrames();
            callQuality2.noDataFrames = callQuality.getNumNoDataFrames();
            callQuality2.rtpDroppedPackets = callQuality.getNumDroppedRtpPackets();
            callQuality2.minPlayoutDelayMillis = callQuality.getMinPlayoutDelayMillis();
            callQuality2.maxPlayoutDelayMillis = callQuality.getMaxPlayoutDelayMillis();
            callQuality2.rxRtpSidPackets = callQuality.getNumRtpSidPacketsReceived();
            callQuality2.rtpDuplicatePackets = callQuality.getNumRtpDuplicatePackets();
        }
        return callQuality2;
    }

    public void writeOnImsCallTerminated(int i, ImsCallSession imsCallSession, ImsReasonInfo imsReasonInfo, CallQualityMetrics callQualityMetrics, EmergencyNumber emergencyNumber, String str, int i2) {
        InProgressCallSession inProgressCallSession = this.mInProgressCallSessions.get(i);
        if (inProgressCallSession == null) {
            Rlog.e(TAG, "Call session is missing");
            return;
        }
        CallSessionEventBuilder callSessionEventBuilder = new CallSessionEventBuilder(17);
        callSessionEventBuilder.setCallIndex(getCallId(imsCallSession));
        callSessionEventBuilder.setImsReasonInfo(toImsReasonInfoProto(imsReasonInfo));
        if (callQualityMetrics != null) {
            callSessionEventBuilder.setCallQualitySummaryDl(callQualityMetrics.getCallQualitySummaryDl()).setCallQualitySummaryUl(callQualityMetrics.getCallQualitySummaryUl());
        }
        if (emergencyNumber != null && ThreadLocalRandom.current().nextDouble(0.0d, 100.0d) < getSamplePercentageForEmergencyCall(str)) {
            callSessionEventBuilder.setIsImsEmergencyCall(true);
            callSessionEventBuilder.setImsEmergencyNumberInfo(convertEmergencyNumberToEmergencyNumberInfo(emergencyNumber));
            callSessionEventBuilder.setEmergencyNumberDatabaseVersion(i2);
        }
        inProgressCallSession.addEvent(callSessionEventBuilder);
    }

    public void writeOnImsCallHandoverEvent(int i, int i2, ImsCallSession imsCallSession, int i3, int i4, ImsReasonInfo imsReasonInfo) {
        InProgressCallSession inProgressCallSession = this.mInProgressCallSessions.get(i);
        if (inProgressCallSession == null) {
            Rlog.e(TAG, "Call session is missing");
        } else {
            inProgressCallSession.addEvent(new CallSessionEventBuilder(i2).setCallIndex(getCallId(imsCallSession)).setSrcAccessTech(i3).setTargetAccessTech(i4).setImsReasonInfo(toImsReasonInfoProto(imsReasonInfo)));
        }
    }

    public synchronized void writeRilSendSms(int i, int i2, int i3, int i4, long j) {
        InProgressSmsSession startNewSmsSessionIfNeeded = startNewSmsSessionIfNeeded(i);
        startNewSmsSessionIfNeeded.addEvent(new SmsSessionEventBuilder(6).setTech(i3).setRilRequestId(i2).setFormat(i4).setMessageId(j));
        startNewSmsSessionIfNeeded.increaseExpectedResponse();
    }

    public synchronized void writeImsServiceSendSms(int i, String str, int i2, long j) {
        InProgressSmsSession startNewSmsSessionIfNeeded = startNewSmsSessionIfNeeded(i);
        startNewSmsSessionIfNeeded.addEvent(new SmsSessionEventBuilder(6).setTech(3).setImsServiceErrno(i2).setFormat(convertSmsFormat(str)).setMessageId(j));
        startNewSmsSessionIfNeeded.increaseExpectedResponse();
    }

    public synchronized void writeNewCBSms(int i, int i2, int i3, boolean z, boolean z2, int i4, int i5, long j) {
        InProgressSmsSession startNewSmsSessionIfNeeded = startNewSmsSessionIfNeeded(i);
        int i6 = z ? 2 : z2 ? 1 : 3;
        TelephonyProto.SmsSession.Event.CBMessage cBMessage = new TelephonyProto.SmsSession.Event.CBMessage();
        cBMessage.msgFormat = i2;
        cBMessage.msgPriority = i3 + 1;
        cBMessage.msgType = i6;
        cBMessage.serviceCategory = i4;
        cBMessage.serialNumber = i5;
        cBMessage.deliveredTimestampMillis = j;
        startNewSmsSessionIfNeeded.addEvent(new SmsSessionEventBuilder(9).setCellBroadcastMessage(cBMessage));
        finishSmsSessionIfNeeded(startNewSmsSessionIfNeeded);
    }

    public void writeDroppedIncomingMultipartSms(int i, String str, int i2, int i3) {
        logv("Logged dropped multipart SMS: received " + i2 + " out of " + i3);
        TelephonyProto.SmsSession.Event.IncompleteSms incompleteSms = new TelephonyProto.SmsSession.Event.IncompleteSms();
        incompleteSms.receivedParts = i2;
        incompleteSms.totalParts = i3;
        InProgressSmsSession startNewSmsSession = startNewSmsSession(i);
        startNewSmsSession.addEvent(new SmsSessionEventBuilder(10).setFormat(convertSmsFormat(str)).setIncompleteSms(incompleteSms));
        finishSmsSession(startNewSmsSession);
    }

    private void writeIncomingSmsWithType(int i, int i2, String str, boolean z) {
        InProgressSmsSession startNewSmsSession = startNewSmsSession(i);
        startNewSmsSession.addEvent(new SmsSessionEventBuilder(8).setFormat(convertSmsFormat(str)).setSmsType(i2).setErrorCode(z ^ true ? 1 : 0));
        finishSmsSession(startNewSmsSession);
    }

    public void writeIncomingSMSPP(int i, String str, boolean z) {
        logv("Logged SMS-PP session. Result = " + z);
        writeIncomingSmsWithType(i, 1, str, z);
    }

    public void writeIncomingVoiceMailSms(int i, String str) {
        logv("Logged VoiceMail message.");
        writeIncomingSmsWithType(i, 2, str, true);
    }

    public void writeIncomingSmsTypeZero(int i, String str) {
        logv("Logged Type-0 SMS message.");
        writeIncomingSmsWithType(i, 3, str, true);
    }

    private void writeIncomingSmsSessionWithType(int i, int i2, int i3, String str, long[] jArr, boolean z, boolean z2, long j) {
        int i4 = i2;
        int i5 = i3;
        long[] jArr2 = jArr;
        boolean z3 = z;
        logv("Logged SMS session consisting of " + jArr2.length + " parts, source = " + i5 + " blocked = " + z3 + " type = " + i4 + " " + SmsController.formatCrossStackMessageId(j));
        int convertSmsFormat = convertSmsFormat(str);
        boolean z4 = true;
        boolean z5 = z2 ^ true;
        int i6 = 0;
        if (convertSmsFormat != 2) {
            z4 = false;
        }
        int smsTech = getSmsTech(i5, z4);
        InProgressSmsSession startNewSmsSession = startNewSmsSession(i);
        long elapsedRealtime = SystemClock.elapsedRealtime();
        while (i6 < jArr2.length) {
            startNewSmsSession.addEvent((i6 > 0 ? jArr2[i6] - jArr2[i6 - 1] : 0) + elapsedRealtime, new SmsSessionEventBuilder(8).setFormat(convertSmsFormat).setTech(smsTech).setErrorCode(z5 ? 1 : 0).setSmsType(i4).setBlocked(z3).setMessageId(j));
            i6++;
        }
        finishSmsSession(startNewSmsSession);
    }

    public void writeIncomingWapPush(int i, int i2, String str, long[] jArr, boolean z, long j) {
        writeIncomingSmsSessionWithType(i, 4, i2, str, jArr, false, z, j);
    }

    public void writeIncomingSmsSession(int i, int i2, String str, long[] jArr, boolean z, long j) {
        writeIncomingSmsSessionWithType(i, 0, i2, str, jArr, z, true, j);
    }

    public void writeIncomingSmsError(int i, boolean z, int i2, int i3) {
        logv("Incoming SMS error = " + i3);
        int i4 = 1;
        if (i3 != 1) {
            int i5 = i3 != 3 ? i3 != 4 ? 1 : 24 : 13;
            InProgressSmsSession startNewSmsSession = startNewSmsSession(i);
            SmsSessionEventBuilder smsSessionEventBuilder = new SmsSessionEventBuilder(8);
            if (z) {
                i4 = 2;
            }
            startNewSmsSession.addEvent(smsSessionEventBuilder.setFormat(i4).setTech(getSmsTech(i2, z)).setErrorCode(i5));
            finishSmsSession(startNewSmsSession);
        }
    }

    public void writeNITZEvent(int i, long j) {
        TelephonyProto.TelephonyEvent build = new TelephonyEventBuilder(i).setNITZ(j).build();
        addTelephonyEvent(build);
        annotateInProgressCallSession(build.timestampMillis, i, new CallSessionEventBuilder(21).setNITZ(j));
    }

    public void writeModemRestartEvent(int i, String str) {
        TelephonyProto.TelephonyEvent.ModemRestart modemRestart = new TelephonyProto.TelephonyEvent.ModemRestart();
        String radioVersion = Build.getRadioVersion();
        if (radioVersion != null) {
            modemRestart.basebandVersion = radioVersion;
        }
        if (str != null) {
            modemRestart.reason = str;
        }
        addTelephonyEvent(new TelephonyEventBuilder(i).setModemRestart(modemRestart).build());
    }

    public void writeCarrierIdMatchingEvent(int i, int i2, int i3, String str, String str2, CarrierResolver.CarrierMatchingRule carrierMatchingRule) {
        TelephonyProto.TelephonyEvent.CarrierIdMatching carrierIdMatching = new TelephonyProto.TelephonyEvent.CarrierIdMatching();
        TelephonyProto.TelephonyEvent.CarrierIdMatchingResult carrierIdMatchingResult = new TelephonyProto.TelephonyEvent.CarrierIdMatchingResult();
        if (i3 != -1) {
            carrierIdMatchingResult.carrierId = i3;
            if (str2 != null) {
                carrierIdMatchingResult.unknownMccmnc = str;
                carrierIdMatchingResult.unknownGid1 = str2;
            }
        } else if (str != null) {
            carrierIdMatchingResult.unknownMccmnc = str;
        }
        carrierIdMatchingResult.mccmnc = TelephonyUtils.emptyIfNull(carrierMatchingRule.mccMnc);
        carrierIdMatchingResult.spn = TelephonyUtils.emptyIfNull(carrierMatchingRule.spn);
        carrierIdMatchingResult.pnn = TelephonyUtils.emptyIfNull(carrierMatchingRule.plmn);
        carrierIdMatchingResult.gid1 = TelephonyUtils.emptyIfNull(carrierMatchingRule.gid1);
        carrierIdMatchingResult.gid2 = TelephonyUtils.emptyIfNull(carrierMatchingRule.gid2);
        carrierIdMatchingResult.imsiPrefix = TelephonyUtils.emptyIfNull(carrierMatchingRule.imsiPrefixPattern);
        carrierIdMatchingResult.iccidPrefix = TelephonyUtils.emptyIfNull(carrierMatchingRule.iccidPrefix);
        carrierIdMatchingResult.preferApn = TelephonyUtils.emptyIfNull(carrierMatchingRule.apn);
        List<String> list = carrierMatchingRule.privilegeAccessRule;
        if (list != null) {
            carrierIdMatchingResult.privilegeAccessRule = (String[]) list.stream().toArray(new TelephonyMetrics$$ExternalSyntheticLambda2());
        }
        carrierIdMatching.cidTableVersion = i2;
        carrierIdMatching.result = carrierIdMatchingResult;
        TelephonyProto.TelephonyEvent build = new TelephonyEventBuilder(i).setCarrierIdMatching(carrierIdMatching).build();
        this.mLastCarrierId.put(i, carrierIdMatching);
        addTelephonyEvent(build);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ String[] lambda$writeCarrierIdMatchingEvent$2(int i) {
        return new String[i];
    }

    public void writeEmergencyNumberUpdateEvent(int i, EmergencyNumber emergencyNumber, int i2) {
        if (emergencyNumber != null) {
            addTelephonyEvent(new TelephonyEventBuilder(i).setUpdatedEmergencyNumber(convertEmergencyNumberToEmergencyNumberInfo(emergencyNumber), i2).build());
        }
    }

    public void writeNetworkCapabilitiesChangedEvent(int i, NetworkCapabilities networkCapabilities) {
        TelephonyProto.TelephonyEvent.NetworkCapabilitiesInfo networkCapabilitiesInfo = new TelephonyProto.TelephonyEvent.NetworkCapabilitiesInfo();
        networkCapabilitiesInfo.isNetworkUnmetered = networkCapabilities.hasCapability(25);
        TelephonyProto.TelephonyEvent build = new TelephonyEventBuilder(i).setNetworkCapabilities(networkCapabilitiesInfo).build();
        this.mLastNetworkCapabilitiesInfos.put(i, networkCapabilitiesInfo);
        addTelephonyEvent(build);
    }

    public void writeRadioState(int i, int i2) {
        int convertRadioState = convertRadioState(i2);
        TelephonyProto.TelephonyEvent build = new TelephonyEventBuilder(i).setRadioState(convertRadioState).build();
        this.mLastRadioState.put(i, Integer.valueOf(convertRadioState));
        addTelephonyEvent(build);
    }

    private int convertSmsFormat(String str) {
        str.hashCode();
        if (!str.equals("3gpp")) {
            return !str.equals("3gpp2") ? 0 : 2;
        }
        return 1;
    }

    public void writeAudioCodecIms(int i, ImsCallSession imsCallSession) {
        InProgressCallSession inProgressCallSession = this.mInProgressCallSessions.get(i);
        if (inProgressCallSession == null) {
            Rlog.e(TAG, "Call session is missing");
            return;
        }
        ImsCallProfile localCallProfile = imsCallSession.getLocalCallProfile();
        if (localCallProfile != null) {
            int convertImsCodec = convertImsCodec(localCallProfile.mMediaProfile.mAudioQuality);
            inProgressCallSession.addEvent(new CallSessionEventBuilder(22).setCallIndex(getCallId(imsCallSession)).setAudioCodec(convertImsCodec));
            logv("Logged Audio Codec event. Value: " + convertImsCodec);
        }
    }

    public void writeAudioCodecGsmCdma(int i, int i2) {
        InProgressCallSession inProgressCallSession = this.mInProgressCallSessions.get(i);
        if (inProgressCallSession == null) {
            Rlog.e(TAG, "Call session is missing");
            return;
        }
        int convertGsmCdmaCodec = convertGsmCdmaCodec(i2);
        inProgressCallSession.addEvent(new CallSessionEventBuilder(22).setAudioCodec(convertGsmCdmaCodec));
        logv("Logged Audio Codec event. Value: " + convertGsmCdmaCodec);
    }

    private double getSamplePercentageForEmergencyCall(String str) {
        if ("cn,in".contains(str)) {
            return 1.0d;
        }
        if ("us,id,br,pk,ng,bd,ru,mx,jp,et,ph,eg,vn,cd,tr,ir,de".contains(str)) {
            return 5.0d;
        }
        if ("th,gb,fr,tz,it,za,mm,ke,kr,co,es,ug,ar,ua,dz,sd,iq".contains(str)) {
            return 15.0d;
        }
        if ("pl,ca,af,ma,sa,pe,uz,ve,my,ao,mz,gh,np,ye,mg,kp,cm".contains(str)) {
            return 25.0d;
        }
        if ("au,tw,ne,lk,bf,mw,ml,ro,kz,sy,cl,zm,gt,zw,nl,ec,sn".contains(str)) {
            return 35.0d;
        }
        return "kh,td,so,gn,ss,rw,bj,tn,bi,be,cu,bo,ht,gr,do,cz,pt".contains(str) ? 45.0d : 50.0d;
    }

    public synchronized void writeBandwidthStats(int i, int i2, int i3, int i4, int i5, int i6, int i7) {
        BwEstimationStats lookupEstimationStats = lookupEstimationStats(i, i2, i3);
        long[] jArr = lookupEstimationStats.mBwEstErrorAcc;
        jArr[i4] = jArr[i4] + ((long) Math.abs(i5));
        long[] jArr2 = lookupEstimationStats.mStaticBwErrorAcc;
        jArr2[i4] = jArr2[i4] + ((long) Math.abs(i6));
        long[] jArr3 = lookupEstimationStats.mBwAccKbps;
        jArr3[i4] = jArr3[i4] + ((long) i7);
        int[] iArr = lookupEstimationStats.mCount;
        iArr[i4] = iArr[i4] + 1;
    }

    private BwEstimationStats lookupEstimationStats(int i, int i2, int i3) {
        String dataRatName = LinkBandwidthEstimator.getDataRatName(i2, i3);
        BwEstimationStats bwEstimationStats = (BwEstimationStats) this.mBwEstStatsMapList.get(i).get(dataRatName);
        if (bwEstimationStats != null) {
            return bwEstimationStats;
        }
        BwEstimationStats bwEstimationStats2 = new BwEstimationStats(i2, i3);
        this.mBwEstStatsMapList.get(i).put(dataRatName, bwEstimationStats2);
        return bwEstimationStats2;
    }

    private TelephonyProto.BandwidthEstimatorStats buildBandwidthEstimatorStats() {
        TelephonyProto.BandwidthEstimatorStats bandwidthEstimatorStats = new TelephonyProto.BandwidthEstimatorStats();
        bandwidthEstimatorStats.perRatTx = (TelephonyProto.BandwidthEstimatorStats.PerRat[]) writeBandwidthEstimatorStatsRatList(this.mBwEstStatsMapList.get(0)).toArray(new TelephonyProto.BandwidthEstimatorStats.PerRat[0]);
        bandwidthEstimatorStats.perRatRx = (TelephonyProto.BandwidthEstimatorStats.PerRat[]) writeBandwidthEstimatorStatsRatList(this.mBwEstStatsMapList.get(1)).toArray(new TelephonyProto.BandwidthEstimatorStats.PerRat[0]);
        return bandwidthEstimatorStats;
    }

    private List<TelephonyProto.BandwidthEstimatorStats.PerRat> writeBandwidthEstimatorStatsRatList(Map<String, BwEstimationStats> map) {
        ArrayList arrayList = new ArrayList();
        for (BwEstimationStats r0 : map.values()) {
            arrayList.add(r0.writeBandwidthStats());
        }
        return arrayList;
    }

    private static class BwEstimationStats {
        final long[] mBwAccKbps = new long[5];
        final long[] mBwEstErrorAcc = new long[5];
        final int[] mCount = new int[5];
        final int mNrMode;
        final int mRadioTechnology;
        final long[] mStaticBwErrorAcc = new long[5];

        BwEstimationStats(int i, int i2) {
            this.mRadioTechnology = i;
            this.mNrMode = i2;
        }

        public String toString() {
            return LinkBandwidthEstimator.getDataRatName(this.mRadioTechnology, this.mNrMode) + "\n Count\n" + printValues(this.mCount) + "\n AvgKbps\n" + printAvgValues(this.mBwAccKbps, this.mCount) + "\n BwEst Error\n" + printAvgValues(this.mBwEstErrorAcc, this.mCount) + "\n StaticBw Error\n" + printAvgValues(this.mStaticBwErrorAcc, this.mCount);
        }

        private String printValues(int[] iArr) {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < 5; i++) {
                sb.append(" " + iArr[i]);
            }
            return sb.toString();
        }

        private String printAvgValues(long[] jArr, int[] iArr) {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < 5; i++) {
                int calculateAvg = calculateAvg(jArr[i], iArr[i]);
                sb.append(" " + calculateAvg);
            }
            return sb.toString();
        }

        /* access modifiers changed from: private */
        public TelephonyProto.BandwidthEstimatorStats.PerRat writeBandwidthStats() {
            TelephonyProto.BandwidthEstimatorStats.PerRat perRat = new TelephonyProto.BandwidthEstimatorStats.PerRat();
            ArrayList arrayList = new ArrayList();
            for (int i = 0; i < 5; i++) {
                TelephonyProto.BandwidthEstimatorStats.PerLevel writeBandwidthStatsPerLevel = writeBandwidthStatsPerLevel(i);
                if (writeBandwidthStatsPerLevel != null) {
                    arrayList.add(writeBandwidthStatsPerLevel);
                }
            }
            perRat.rat = this.mRadioTechnology;
            perRat.perLevel = (TelephonyProto.BandwidthEstimatorStats.PerLevel[]) arrayList.toArray(new TelephonyProto.BandwidthEstimatorStats.PerLevel[0]);
            perRat.nrMode = this.mNrMode;
            return perRat;
        }

        private TelephonyProto.BandwidthEstimatorStats.PerLevel writeBandwidthStatsPerLevel(int i) {
            int i2 = this.mCount[i];
            if (i2 <= 0) {
                return null;
            }
            TelephonyProto.BandwidthEstimatorStats.PerLevel perLevel = new TelephonyProto.BandwidthEstimatorStats.PerLevel();
            perLevel.signalLevel = i;
            perLevel.count = i2;
            perLevel.avgBwKbps = calculateAvg(this.mBwAccKbps[i], i2);
            perLevel.staticBwErrorPercent = calculateAvg(this.mStaticBwErrorAcc[i], i2);
            perLevel.bwEstErrorPercent = calculateAvg(this.mBwEstErrorAcc[i], i2);
            return perLevel;
        }

        private int calculateAvg(long j, int i) {
            if (i > 0) {
                return (int) (j / ((long) i));
            }
            return 0;
        }
    }
}
