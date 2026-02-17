package com.android.internal.telephony.metrics;

import android.os.SystemClock;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.ServiceState;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.ServiceStateTracker;
import com.android.internal.telephony.imsphone.ImsPhone;
import com.android.internal.telephony.nano.PersistAtomsProto;
import com.android.telephony.Rlog;
import java.util.concurrent.atomic.AtomicReference;

public class ServiceStateStats {
    private static final String TAG = "ServiceStateStats";
    private final AtomicReference<TimestampedServiceState> mLastState = new AtomicReference<>(new TimestampedServiceState((PersistAtomsProto.CellularServiceState) null, 0));
    private final Phone mPhone;
    private final PersistAtomsStorage mStorage;

    public ServiceStateStats(Phone phone) {
        this.mPhone = phone;
        this.mStorage = PhoneFactory.getMetricsCollector().getAtomsStorage();
    }

    public void conclude() {
        long timeMillis = getTimeMillis();
        addServiceState(this.mLastState.getAndUpdate(new ServiceStateStats$$ExternalSyntheticLambda1(timeMillis)), timeMillis);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ TimestampedServiceState lambda$conclude$0(long j, TimestampedServiceState timestampedServiceState) {
        return new TimestampedServiceState(timestampedServiceState.mServiceState, j);
    }

    public void onImsVoiceRegistrationChanged() {
        long timeMillis = getTimeMillis();
        addServiceState(this.mLastState.getAndUpdate(new ServiceStateStats$$ExternalSyntheticLambda0(this, timeMillis)), timeMillis);
    }

    /* access modifiers changed from: private */
    public /* synthetic */ TimestampedServiceState lambda$onImsVoiceRegistrationChanged$1(long j, TimestampedServiceState timestampedServiceState) {
        if (timestampedServiceState.mServiceState == null) {
            return new TimestampedServiceState((PersistAtomsProto.CellularServiceState) null, j);
        }
        PersistAtomsProto.CellularServiceState copyOf = copyOf(timestampedServiceState.mServiceState);
        Phone phone = this.mPhone;
        copyOf.voiceRat = getVoiceRat(phone, getServiceStateForPhone(phone));
        return new TimestampedServiceState(copyOf, j);
    }

    public void onServiceStateChanged(ServiceState serviceState) {
        long timeMillis = getTimeMillis();
        if (isModemOff(serviceState)) {
            addServiceState(this.mLastState.getAndSet(new TimestampedServiceState((PersistAtomsProto.CellularServiceState) null, timeMillis)), timeMillis);
            return;
        }
        PersistAtomsProto.CellularServiceState cellularServiceState = new PersistAtomsProto.CellularServiceState();
        cellularServiceState.voiceRat = getVoiceRat(this.mPhone, serviceState);
        cellularServiceState.dataRat = getDataRat(serviceState);
        cellularServiceState.voiceRoamingType = serviceState.getVoiceRoamingType();
        cellularServiceState.dataRoamingType = serviceState.getDataRoamingType();
        cellularServiceState.isEndc = isEndc(serviceState);
        cellularServiceState.simSlotIndex = this.mPhone.getPhoneId();
        cellularServiceState.isMultiSim = SimSlotState.isMultiSim();
        cellularServiceState.carrierId = this.mPhone.getCarrierId();
        cellularServiceState.isEmergencyOnly = isEmergencyOnly(serviceState);
        TimestampedServiceState andSet = this.mLastState.getAndSet(new TimestampedServiceState(cellularServiceState, timeMillis));
        addServiceStateAndSwitch(andSet, timeMillis, getDataServiceSwitch(andSet.mServiceState, cellularServiceState));
    }

    private void addServiceState(TimestampedServiceState timestampedServiceState, long j) {
        addServiceStateAndSwitch(timestampedServiceState, j, (PersistAtomsProto.CellularDataServiceSwitch) null);
    }

    private void addServiceStateAndSwitch(TimestampedServiceState timestampedServiceState, long j, PersistAtomsProto.CellularDataServiceSwitch cellularDataServiceSwitch) {
        if (timestampedServiceState.mServiceState != null) {
            if (j >= timestampedServiceState.mTimestamp) {
                PersistAtomsProto.CellularServiceState copyOf = copyOf(timestampedServiceState.mServiceState);
                copyOf.totalTimeMillis = j - timestampedServiceState.mTimestamp;
                this.mStorage.addCellularServiceStateAndCellularDataServiceSwitch(copyOf, cellularDataServiceSwitch);
                return;
            }
            Rlog.e(TAG, "addServiceState: durationMillis<0");
        }
    }

    private PersistAtomsProto.CellularDataServiceSwitch getDataServiceSwitch(PersistAtomsProto.CellularServiceState cellularServiceState, PersistAtomsProto.CellularServiceState cellularServiceState2) {
        if (cellularServiceState == null || cellularServiceState.isMultiSim != cellularServiceState2.isMultiSim || cellularServiceState.carrierId != cellularServiceState2.carrierId || cellularServiceState.dataRat == cellularServiceState2.dataRat) {
            return null;
        }
        PersistAtomsProto.CellularDataServiceSwitch cellularDataServiceSwitch = new PersistAtomsProto.CellularDataServiceSwitch();
        cellularDataServiceSwitch.ratFrom = cellularServiceState.dataRat;
        cellularDataServiceSwitch.ratTo = cellularServiceState2.dataRat;
        cellularDataServiceSwitch.isMultiSim = cellularServiceState2.isMultiSim;
        cellularDataServiceSwitch.simSlotIndex = cellularServiceState2.simSlotIndex;
        cellularDataServiceSwitch.carrierId = cellularServiceState2.carrierId;
        cellularDataServiceSwitch.switchCount = 1;
        return cellularDataServiceSwitch;
    }

    private static ServiceState getServiceStateForPhone(Phone phone) {
        ServiceStateTracker serviceStateTracker = phone.getServiceStateTracker();
        if (serviceStateTracker != null) {
            return serviceStateTracker.getServiceState();
        }
        return null;
    }

    static int getBand(Phone phone) {
        return getBand(getServiceStateForPhone(phone));
    }

    /* JADX WARNING: Removed duplicated region for block: B:25:0x0058  */
    /* JADX WARNING: Removed duplicated region for block: B:27:0x0077 A[RETURN] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    static int getBand(android.telephony.ServiceState r5) {
        /*
            r0 = 0
            if (r5 != 0) goto L_0x000b
            java.lang.String r5 = TAG
            java.lang.String r1 = "getBand: serviceState=null"
            com.android.telephony.Rlog.w(r5, r1)
            return r0
        L_0x000b:
            int r1 = r5.getChannelNumber()
            int r5 = getRat(r5)
            r2 = 1
            if (r5 == r2) goto L_0x0051
            r2 = 2
            if (r5 == r2) goto L_0x0051
            r2 = 3
            if (r5 == r2) goto L_0x004c
            r2 = 13
            if (r5 == r2) goto L_0x0047
            r2 = 19
            if (r5 == r2) goto L_0x0047
            r2 = 15
            if (r5 == r2) goto L_0x004c
            r2 = 16
            if (r5 == r2) goto L_0x0051
            switch(r5) {
                case 8: goto L_0x004c;
                case 9: goto L_0x004c;
                case 10: goto L_0x004c;
                default: goto L_0x002f;
            }
        L_0x002f:
            java.lang.String r2 = TAG
            java.lang.StringBuilder r3 = new java.lang.StringBuilder
            r3.<init>()
            java.lang.String r4 = "getBand: unknown WWAN RAT "
            r3.append(r4)
            r3.append(r5)
            java.lang.String r3 = r3.toString()
            com.android.telephony.Rlog.w(r2, r3)
            r2 = r0
            goto L_0x0055
        L_0x0047:
            int r2 = android.telephony.AccessNetworkUtils.getOperatingBandForEarfcn(r1)
            goto L_0x0055
        L_0x004c:
            int r2 = android.telephony.AccessNetworkUtils.getOperatingBandForUarfcn(r1)
            goto L_0x0055
        L_0x0051:
            int r2 = android.telephony.AccessNetworkUtils.getOperatingBandForArfcn(r1)
        L_0x0055:
            r3 = -1
            if (r2 != r3) goto L_0x0077
            java.lang.String r2 = TAG
            java.lang.StringBuilder r3 = new java.lang.StringBuilder
            r3.<init>()
            java.lang.String r4 = "getBand: band invalid for rat="
            r3.append(r4)
            r3.append(r5)
            java.lang.String r5 = " ch="
            r3.append(r5)
            r3.append(r1)
            java.lang.String r5 = r3.toString()
            com.android.telephony.Rlog.w(r2, r5)
            return r0
        L_0x0077:
            return r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.metrics.ServiceStateStats.getBand(android.telephony.ServiceState):int");
    }

    private static PersistAtomsProto.CellularServiceState copyOf(PersistAtomsProto.CellularServiceState cellularServiceState) {
        PersistAtomsProto.CellularServiceState cellularServiceState2 = new PersistAtomsProto.CellularServiceState();
        cellularServiceState2.voiceRat = cellularServiceState.voiceRat;
        cellularServiceState2.dataRat = cellularServiceState.dataRat;
        cellularServiceState2.voiceRoamingType = cellularServiceState.voiceRoamingType;
        cellularServiceState2.dataRoamingType = cellularServiceState.dataRoamingType;
        cellularServiceState2.isEndc = cellularServiceState.isEndc;
        cellularServiceState2.simSlotIndex = cellularServiceState.simSlotIndex;
        cellularServiceState2.isMultiSim = cellularServiceState.isMultiSim;
        cellularServiceState2.carrierId = cellularServiceState.carrierId;
        cellularServiceState2.totalTimeMillis = cellularServiceState.totalTimeMillis;
        cellularServiceState2.isEmergencyOnly = cellularServiceState.isEmergencyOnly;
        return cellularServiceState2;
    }

    private static boolean isModemOff(ServiceState serviceState) {
        return serviceState.getVoiceRegState() == 3;
    }

    static int getVoiceRat(Phone phone, ServiceState serviceState) {
        int imsVoiceRadioTech;
        if (serviceState == null) {
            return 0;
        }
        ImsPhone imsPhone = (ImsPhone) phone.getImsPhone();
        boolean z = true;
        if (imsPhone == null || (imsVoiceRadioTech = imsPhone.getImsStats().getImsVoiceRadioTech()) == 0) {
            NetworkRegistrationInfo networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(1, 1);
            if (networkRegistrationInfo == null || !networkRegistrationInfo.isInService()) {
                return 0;
            }
            return networkRegistrationInfo.getAccessNetworkTechnology();
        }
        if (imsVoiceRadioTech != 18 && getDataRat(serviceState) == 0) {
            z = false;
        }
        if (z) {
            return imsVoiceRadioTech;
        }
        return 0;
    }

    private static int getRat(ServiceState serviceState) {
        int dataRat = getDataRat(serviceState);
        return dataRat == 0 ? serviceState.getVoiceNetworkType() : dataRat;
    }

    static int getDataRat(ServiceState serviceState) {
        NetworkRegistrationInfo networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(2, 1);
        if (networkRegistrationInfo == null || !networkRegistrationInfo.isInService()) {
            return 0;
        }
        return networkRegistrationInfo.getAccessNetworkTechnology();
    }

    private static boolean isEmergencyOnly(ServiceState serviceState) {
        NetworkRegistrationInfo networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(1, 1);
        if (networkRegistrationInfo == null || networkRegistrationInfo.isInService() || !networkRegistrationInfo.isEmergencyEnabled()) {
            return false;
        }
        return true;
    }

    private static boolean isEndc(ServiceState serviceState) {
        if (getDataRat(serviceState) != 13) {
            return false;
        }
        int nrState = serviceState.getNrState();
        if (nrState == 3 || nrState == 2) {
            return true;
        }
        return false;
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting
    public long getTimeMillis() {
        return SystemClock.elapsedRealtime();
    }

    private static final class TimestampedServiceState {
        /* access modifiers changed from: private */
        public final PersistAtomsProto.CellularServiceState mServiceState;
        /* access modifiers changed from: private */
        public final long mTimestamp;

        TimestampedServiceState(PersistAtomsProto.CellularServiceState cellularServiceState, long j) {
            this.mServiceState = cellularServiceState;
            this.mTimestamp = j;
        }
    }
}
