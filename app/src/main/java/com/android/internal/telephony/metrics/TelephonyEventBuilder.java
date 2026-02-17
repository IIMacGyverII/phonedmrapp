package com.android.internal.telephony.metrics;

import android.os.SystemClock;
import android.telephony.TelephonyManager;
import android.util.SparseArray;
import com.android.internal.telephony.nano.TelephonyProto;
import java.util.Arrays;

public class TelephonyEventBuilder {
    private final TelephonyProto.TelephonyEvent mEvent;

    public TelephonyProto.TelephonyEvent build() {
        return this.mEvent;
    }

    public TelephonyEventBuilder() {
        this(-1);
    }

    public TelephonyEventBuilder(int i) {
        this(SystemClock.elapsedRealtime(), i);
    }

    public TelephonyEventBuilder(long j, int i) {
        TelephonyProto.TelephonyEvent telephonyEvent = new TelephonyProto.TelephonyEvent();
        this.mEvent = telephonyEvent;
        telephonyEvent.timestampMillis = j;
        telephonyEvent.phoneId = i;
    }

    public TelephonyEventBuilder setSettings(TelephonyProto.TelephonySettings telephonySettings) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 1;
        telephonyEvent.settings = telephonySettings;
        return this;
    }

    public TelephonyEventBuilder setServiceState(TelephonyProto.TelephonyServiceState telephonyServiceState) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 2;
        telephonyEvent.serviceState = telephonyServiceState;
        return this;
    }

    public TelephonyEventBuilder setImsConnectionState(TelephonyProto.ImsConnectionState imsConnectionState) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 3;
        telephonyEvent.imsConnectionState = imsConnectionState;
        return this;
    }

    public TelephonyEventBuilder setImsCapabilities(TelephonyProto.ImsCapabilities imsCapabilities) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 4;
        telephonyEvent.imsCapabilities = imsCapabilities;
        return this;
    }

    public TelephonyEventBuilder setDataStallRecoveryAction(int i) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 10;
        telephonyEvent.dataStallAction = i;
        return this;
    }

    public TelephonyEventBuilder setSignalStrength(int i) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 23;
        telephonyEvent.signalStrength = i;
        return this;
    }

    public TelephonyEventBuilder setSetupDataCall(TelephonyProto.TelephonyEvent.RilSetupDataCall rilSetupDataCall) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 5;
        telephonyEvent.setupDataCall = rilSetupDataCall;
        return this;
    }

    public TelephonyEventBuilder setSetupDataCallResponse(TelephonyProto.TelephonyEvent.RilSetupDataCallResponse rilSetupDataCallResponse) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 6;
        telephonyEvent.setupDataCallResponse = rilSetupDataCallResponse;
        return this;
    }

    public TelephonyEventBuilder setDeactivateDataCall(TelephonyProto.TelephonyEvent.RilDeactivateDataCall rilDeactivateDataCall) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 8;
        telephonyEvent.deactivateDataCall = rilDeactivateDataCall;
        return this;
    }

    public TelephonyEventBuilder setDeactivateDataCallResponse(int i) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 9;
        telephonyEvent.error = i;
        return this;
    }

    public TelephonyEventBuilder setDataCalls(TelephonyProto.RilDataCall[] rilDataCallArr) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 7;
        telephonyEvent.dataCalls = rilDataCallArr;
        return this;
    }

    public TelephonyEventBuilder setNITZ(long j) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 12;
        telephonyEvent.nitzTimestampMillis = j;
        return this;
    }

    public TelephonyEventBuilder setModemRestart(TelephonyProto.TelephonyEvent.ModemRestart modemRestart) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 11;
        telephonyEvent.modemRestart = modemRestart;
        return this;
    }

    public TelephonyEventBuilder setCarrierIdMatching(TelephonyProto.TelephonyEvent.CarrierIdMatching carrierIdMatching) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 13;
        telephonyEvent.carrierIdMatching = carrierIdMatching;
        return this;
    }

    public TelephonyEventBuilder setUpdatedEmergencyNumber(TelephonyProto.EmergencyNumberInfo emergencyNumberInfo, int i) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 21;
        telephonyEvent.updatedEmergencyNumber = emergencyNumberInfo;
        telephonyEvent.emergencyNumberDatabaseVersion = i;
        return this;
    }

    public TelephonyEventBuilder setCarrierKeyChange(TelephonyProto.TelephonyEvent.CarrierKeyChange carrierKeyChange) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 14;
        telephonyEvent.carrierKeyChange = carrierKeyChange;
        return this;
    }

    public TelephonyEventBuilder setSimStateChange(SparseArray<Integer> sparseArray) {
        int phoneCount = TelephonyManager.getDefault().getPhoneCount();
        int[] iArr = new int[phoneCount];
        this.mEvent.simState = iArr;
        Arrays.fill(iArr, 0);
        this.mEvent.type = 18;
        for (int i = 0; i < sparseArray.size(); i++) {
            int keyAt = sparseArray.keyAt(i);
            if (keyAt >= 0 && keyAt < phoneCount) {
                this.mEvent.simState[keyAt] = sparseArray.get(keyAt).intValue();
            }
        }
        return this;
    }

    public TelephonyEventBuilder setActiveSubscriptionInfoChange(TelephonyProto.ActiveSubscriptionInfo activeSubscriptionInfo) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 19;
        telephonyEvent.activeSubscriptionInfo = activeSubscriptionInfo;
        return this;
    }

    public TelephonyEventBuilder setEnabledModemBitmap(int i) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 20;
        telephonyEvent.enabledModemBitmap = i;
        return this;
    }

    public TelephonyEventBuilder setDataSwitch(TelephonyProto.TelephonyEvent.DataSwitch dataSwitch) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 15;
        telephonyEvent.dataSwitch = dataSwitch;
        return this;
    }

    public TelephonyEventBuilder setNetworkValidate(int i) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 16;
        telephonyEvent.networkValidationState = i;
        return this;
    }

    public TelephonyEventBuilder setOnDemandDataSwitch(TelephonyProto.TelephonyEvent.OnDemandDataSwitch onDemandDataSwitch) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 17;
        telephonyEvent.onDemandDataSwitch = onDemandDataSwitch;
        return this;
    }

    public TelephonyEventBuilder setNetworkCapabilities(TelephonyProto.TelephonyEvent.NetworkCapabilitiesInfo networkCapabilitiesInfo) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 22;
        telephonyEvent.networkCapabilities = networkCapabilitiesInfo;
        return this;
    }

    public TelephonyEventBuilder setRadioState(int i) {
        TelephonyProto.TelephonyEvent telephonyEvent = this.mEvent;
        telephonyEvent.type = 24;
        telephonyEvent.radioState = i;
        return this;
    }
}
