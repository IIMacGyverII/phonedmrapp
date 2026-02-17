package com.android.internal.telephony;

import android.content.Context;
import android.telephony.BarringInfo;
import android.telephony.CallQuality;
import android.telephony.CellIdentity;
import android.telephony.CellInfo;
import android.telephony.LinkCapacityEstimate;
import android.telephony.PhoneCapability;
import android.telephony.PhysicalChannelConfig;
import android.telephony.PreciseDataConnectionState;
import android.telephony.ServiceState;
import android.telephony.TelephonyDisplayInfo;
import android.telephony.TelephonyRegistryManager;
import android.telephony.emergency.EmergencyNumber;
import android.telephony.ims.ImsReasonInfo;
import com.android.internal.telephony.Call;
import com.android.telephony.Rlog;
import java.util.List;

public class DefaultPhoneNotifier implements PhoneNotifier {
    private static final boolean DBG = false;
    private static final String LOG_TAG = "DefaultPhoneNotifier";
    protected TelephonyRegistryManager mTelephonyRegistryMgr;

    public DefaultPhoneNotifier(Context context) {
        this.mTelephonyRegistryMgr = (TelephonyRegistryManager) context.getSystemService("telephony_registry");
    }

    public void notifyPhoneState(Phone phone) {
        Call ringingCall = phone.getRingingCall();
        this.mTelephonyRegistryMgr.notifyCallStateChanged(phone.getPhoneId(), phone.getSubId(), PhoneConstantConversions.convertCallState(phone.getState()), (ringingCall == null || ringingCall.getEarliestConnection() == null) ? "" : ringingCall.getEarliestConnection().getAddress());
    }

    public void notifyServiceState(Phone phone) {
        notifyServiceStateForSubId(phone, phone.getServiceState(), phone.getSubId());
    }

    public void notifyServiceStateForSubId(Phone phone, ServiceState serviceState, int i) {
        int phoneId = phone.getPhoneId();
        Rlog.d(LOG_TAG, "notifyServiceStateForSubId: mRegistryMgr=" + this.mTelephonyRegistryMgr + " ss=" + serviceState + " sender=" + phone + " phondId=" + phoneId + " subId=" + i);
        if (serviceState == null) {
            serviceState = new ServiceState();
            serviceState.setStateOutOfService();
        }
        this.mTelephonyRegistryMgr.notifyServiceStateChanged(phoneId, i, serviceState);
    }

    public void notifySignalStrength(Phone phone) {
        this.mTelephonyRegistryMgr.notifySignalStrengthChanged(phone.getPhoneId(), phone.getSubId(), phone.getSignalStrength());
    }

    public void notifyMessageWaitingChanged(Phone phone) {
        this.mTelephonyRegistryMgr.notifyMessageWaitingChanged(phone.getPhoneId(), phone.getSubId(), phone.getMessageWaitingIndicator());
    }

    public void notifyCallForwardingChanged(Phone phone) {
        int subId = phone.getSubId();
        Rlog.d(LOG_TAG, "notifyCallForwardingChanged: subId=" + subId + ", isCFActive=" + phone.getCallForwardingIndicator());
        this.mTelephonyRegistryMgr.notifyCallForwardingChanged(subId, phone.getCallForwardingIndicator());
    }

    public void notifyDataActivity(Phone phone) {
        this.mTelephonyRegistryMgr.notifyDataActivityChanged(phone.getSubId(), phone.getDataActivityState());
    }

    public void notifyDataConnection(Phone phone, PreciseDataConnectionState preciseDataConnectionState) {
        this.mTelephonyRegistryMgr.notifyDataConnectionForSubscriber(phone.getPhoneId(), phone.getSubId(), preciseDataConnectionState);
    }

    public void notifyCellLocation(Phone phone, CellIdentity cellIdentity) {
        this.mTelephonyRegistryMgr.notifyCellLocation(phone.getSubId(), cellIdentity);
    }

    public void notifyCellInfo(Phone phone, List<CellInfo> list) {
        this.mTelephonyRegistryMgr.notifyCellInfoChanged(phone.getSubId(), list);
    }

    public void notifyPreciseCallState(Phone phone) {
        Call ringingCall = phone.getRingingCall();
        Call foregroundCall = phone.getForegroundCall();
        Call backgroundCall = phone.getBackgroundCall();
        if (ringingCall != null && foregroundCall != null && backgroundCall != null) {
            this.mTelephonyRegistryMgr.notifyPreciseCallState(phone.getPhoneId(), phone.getSubId(), convertPreciseCallState(ringingCall.getState()), convertPreciseCallState(foregroundCall.getState()), convertPreciseCallState(backgroundCall.getState()));
        }
    }

    public void notifyDisconnectCause(Phone phone, int i, int i2) {
        this.mTelephonyRegistryMgr.notifyDisconnectCause(phone.getPhoneId(), phone.getSubId(), i, i2);
    }

    public void notifyImsDisconnectCause(Phone phone, ImsReasonInfo imsReasonInfo) {
        this.mTelephonyRegistryMgr.notifyImsDisconnectCause(phone.getSubId(), imsReasonInfo);
    }

    public void notifySrvccStateChanged(Phone phone, int i) {
        this.mTelephonyRegistryMgr.notifySrvccStateChanged(phone.getSubId(), i);
    }

    public void notifyDataActivationStateChanged(Phone phone, int i) {
        this.mTelephonyRegistryMgr.notifyDataActivationStateChanged(phone.getPhoneId(), phone.getSubId(), i);
    }

    public void notifyVoiceActivationStateChanged(Phone phone, int i) {
        this.mTelephonyRegistryMgr.notifyVoiceActivationStateChanged(phone.getPhoneId(), phone.getSubId(), i);
    }

    public void notifyUserMobileDataStateChanged(Phone phone, boolean z) {
        this.mTelephonyRegistryMgr.notifyUserMobileDataStateChanged(phone.getPhoneId(), phone.getSubId(), z);
    }

    public void notifyDisplayInfoChanged(Phone phone, TelephonyDisplayInfo telephonyDisplayInfo) {
        this.mTelephonyRegistryMgr.notifyDisplayInfoChanged(phone.getPhoneId(), phone.getSubId(), telephonyDisplayInfo);
    }

    public void notifyPhoneCapabilityChanged(PhoneCapability phoneCapability) {
        this.mTelephonyRegistryMgr.notifyPhoneCapabilityChanged(phoneCapability);
    }

    public void notifyRadioPowerStateChanged(Phone phone, int i) {
        this.mTelephonyRegistryMgr.notifyRadioPowerStateChanged(phone.getPhoneId(), phone.getSubId(), i);
    }

    public void notifyEmergencyNumberList(Phone phone) {
        this.mTelephonyRegistryMgr.notifyEmergencyNumberList(phone.getPhoneId(), phone.getSubId());
    }

    public void notifyOutgoingEmergencySms(Phone phone, EmergencyNumber emergencyNumber) {
        this.mTelephonyRegistryMgr.notifyOutgoingEmergencySms(phone.getPhoneId(), phone.getSubId(), emergencyNumber);
    }

    public void notifyCallQualityChanged(Phone phone, CallQuality callQuality, int i) {
        this.mTelephonyRegistryMgr.notifyCallQualityChanged(phone.getPhoneId(), phone.getSubId(), callQuality, i);
    }

    public void notifyRegistrationFailed(Phone phone, CellIdentity cellIdentity, String str, int i, int i2, int i3) {
        this.mTelephonyRegistryMgr.notifyRegistrationFailed(phone.getPhoneId(), phone.getSubId(), cellIdentity, str, i, i2, i3);
    }

    public void notifyBarringInfoChanged(Phone phone, BarringInfo barringInfo) {
        this.mTelephonyRegistryMgr.notifyBarringInfoChanged(phone.getPhoneId(), phone.getSubId(), barringInfo);
    }

    public void notifyPhysicalChannelConfig(Phone phone, List<PhysicalChannelConfig> list) {
        this.mTelephonyRegistryMgr.notifyPhysicalChannelConfigForSubscriber(phone.getPhoneId(), phone.getSubId(), list);
    }

    public void notifyDataEnabled(Phone phone, boolean z, int i) {
        this.mTelephonyRegistryMgr.notifyDataEnabled(phone.getPhoneId(), phone.getSubId(), z, i);
    }

    public void notifyAllowedNetworkTypesChanged(Phone phone, int i, long j) {
        this.mTelephonyRegistryMgr.notifyAllowedNetworkTypesChanged(phone.getPhoneId(), phone.getSubId(), i, j);
    }

    public void notifyLinkCapacityEstimateChanged(Phone phone, List<LinkCapacityEstimate> list) {
        this.mTelephonyRegistryMgr.notifyLinkCapacityEstimateChanged(phone.getPhoneId(), phone.getSubId(), list);
    }

    /* renamed from: com.android.internal.telephony.DefaultPhoneNotifier$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$Call$State;

        /* JADX WARNING: Can't wrap try/catch for region: R(18:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|18) */
        /* JADX WARNING: Code restructure failed: missing block: B:19:?, code lost:
            return;
         */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:13:0x0049 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:15:0x0054 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:9:0x0033 */
        static {
            /*
                com.android.internal.telephony.Call$State[] r0 = com.android.internal.telephony.Call.State.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$Call$State = r0
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.ACTIVE     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.HOLDING     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.DIALING     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.ALERTING     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.INCOMING     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.WAITING     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.DISCONNECTED     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r2 = 7
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                int[] r0 = $SwitchMap$com$android$internal$telephony$Call$State     // Catch:{ NoSuchFieldError -> 0x0060 }
                com.android.internal.telephony.Call$State r1 = com.android.internal.telephony.Call.State.DISCONNECTING     // Catch:{ NoSuchFieldError -> 0x0060 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0060 }
                r2 = 8
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0060 }
            L_0x0060:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.DefaultPhoneNotifier.AnonymousClass1.<clinit>():void");
        }
    }

    public static int convertPreciseCallState(Call.State state) {
        switch (AnonymousClass1.$SwitchMap$com$android$internal$telephony$Call$State[state.ordinal()]) {
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
            default:
                return 0;
        }
    }

    private void log(String str) {
        Rlog.d(LOG_TAG, str);
    }
}
