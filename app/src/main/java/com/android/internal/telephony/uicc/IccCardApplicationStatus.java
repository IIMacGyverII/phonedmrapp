package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.SystemProperties;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.telephony.Rlog;

public class IccCardApplicationStatus {
    public String aid;
    public String app_label;
    public AppState app_state;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public AppType app_type;
    public PersoSubState perso_substate;
    public IccCardStatus.PinState pin1;
    public boolean pin1_replaced;
    public IccCardStatus.PinState pin2;

    @UnsupportedAppUsage(implicitMember = "values()[Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;")
    public enum AppType {
        APPTYPE_UNKNOWN,
        APPTYPE_SIM,
        APPTYPE_USIM,
        APPTYPE_RUIM,
        APPTYPE_CSIM,
        APPTYPE_ISIM
    }

    @UnsupportedAppUsage(implicitMember = "values()[Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;")
    public enum AppState {
        APPSTATE_UNKNOWN,
        APPSTATE_DETECTED,
        APPSTATE_PIN,
        APPSTATE_PUK,
        APPSTATE_SUBSCRIPTION_PERSO,
        APPSTATE_READY;

        /* access modifiers changed from: package-private */
        public boolean isPinRequired() {
            return this == APPSTATE_PIN;
        }

        /* access modifiers changed from: package-private */
        public boolean isPukRequired() {
            return this == APPSTATE_PUK;
        }

        /* access modifiers changed from: package-private */
        public boolean isSubscriptionPersoEnabled() {
            return this == APPSTATE_SUBSCRIPTION_PERSO;
        }

        /* access modifiers changed from: package-private */
        public boolean isAppReady() {
            return this == APPSTATE_READY;
        }

        /* access modifiers changed from: package-private */
        public boolean isAppNotReady() {
            return this == APPSTATE_UNKNOWN || this == APPSTATE_DETECTED;
        }
    }

    @UnsupportedAppUsage(implicitMember = "values()[Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;")
    public enum PersoSubState {
        PERSOSUBSTATE_UNKNOWN,
        PERSOSUBSTATE_IN_PROGRESS,
        PERSOSUBSTATE_READY,
        PERSOSUBSTATE_SIM_NETWORK,
        PERSOSUBSTATE_SIM_NETWORK_SUBSET,
        PERSOSUBSTATE_SIM_CORPORATE,
        PERSOSUBSTATE_SIM_SERVICE_PROVIDER,
        PERSOSUBSTATE_SIM_SIM,
        PERSOSUBSTATE_SIM_NETWORK_PUK,
        PERSOSUBSTATE_SIM_NETWORK_SUBSET_PUK,
        PERSOSUBSTATE_SIM_CORPORATE_PUK,
        PERSOSUBSTATE_SIM_SERVICE_PROVIDER_PUK,
        PERSOSUBSTATE_SIM_SIM_PUK,
        PERSOSUBSTATE_RUIM_NETWORK1,
        PERSOSUBSTATE_RUIM_NETWORK2,
        PERSOSUBSTATE_RUIM_HRPD,
        PERSOSUBSTATE_RUIM_CORPORATE,
        PERSOSUBSTATE_RUIM_SERVICE_PROVIDER,
        PERSOSUBSTATE_RUIM_RUIM,
        PERSOSUBSTATE_RUIM_NETWORK1_PUK,
        PERSOSUBSTATE_RUIM_NETWORK2_PUK,
        PERSOSUBSTATE_RUIM_HRPD_PUK,
        PERSOSUBSTATE_RUIM_CORPORATE_PUK,
        PERSOSUBSTATE_RUIM_SERVICE_PROVIDER_PUK,
        PERSOSUBSTATE_RUIM_RUIM_PUK,
        PERSOSUBSTATE_SIM_SPN,
        PERSOSUBSTATE_SIM_SPN_PUK,
        PERSOSUBSTATE_SIM_SP_EHPLMN,
        PERSOSUBSTATE_SIM_SP_EHPLMN_PUK,
        PERSOSUBSTATE_SIM_ICCID,
        PERSOSUBSTATE_SIM_ICCID_PUK,
        PERSOSUBSTATE_SIM_IMPI,
        PERSOSUBSTATE_SIM_IMPI_PUK,
        PERSOSUBSTATE_SIM_NS_SP,
        PERSOSUBSTATE_SIM_NS_SP_PUK,
        PERSOSUBSTATE_SIM_SIM_C,
        PERSOSUBSTATE_SIM_SIM_C_PUK;

        /* access modifiers changed from: package-private */
        public boolean isPersoSubStateUnknown() {
            return this == PERSOSUBSTATE_UNKNOWN;
        }

        public static boolean isPersoLocked(PersoSubState persoSubState) {
            int i = AnonymousClass1.$SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState[persoSubState.ordinal()];
            return (i == 1 || i == 2 || i == 3) ? false : true;
        }
    }

    /* renamed from: com.android.internal.telephony.uicc.IccCardApplicationStatus$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState;

        /* JADX WARNING: Can't wrap try/catch for region: R(6:0|1|2|3|4|(3:5|6|8)) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        static {
            /*
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState[] r0 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState = r0
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_UNKNOWN     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_IN_PROGRESS     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$PersoSubState     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.PERSOSUBSTATE_READY     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.IccCardApplicationStatus.AnonymousClass1.<clinit>():void");
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public AppType AppTypeFromRILInt(int i) {
        if (i == 0) {
            return AppType.APPTYPE_UNKNOWN;
        }
        if (i == 1) {
            return AppType.APPTYPE_SIM;
        }
        if (i == 2) {
            return AppType.APPTYPE_USIM;
        }
        if (i == 3) {
            return AppType.APPTYPE_RUIM;
        }
        if (i == 4) {
            return AppType.APPTYPE_CSIM;
        }
        if (i == 5) {
            return AppType.APPTYPE_ISIM;
        }
        AppType appType = AppType.APPTYPE_UNKNOWN;
        loge("AppTypeFromRILInt: bad RIL_AppType: " + i + " use APPTYPE_UNKNOWN");
        return appType;
    }

    public AppState AppStateFromRILInt(int i) {
        if (i == 0) {
            return AppState.APPSTATE_UNKNOWN;
        }
        if (i == 1) {
            return AppState.APPSTATE_DETECTED;
        }
        if (i == 2) {
            return AppState.APPSTATE_PIN;
        }
        if (i == 3) {
            return AppState.APPSTATE_PUK;
        }
        if (i == 4) {
            return AppState.APPSTATE_SUBSCRIPTION_PERSO;
        }
        if (i == 5) {
            return AppState.APPSTATE_READY;
        }
        AppState appState = AppState.APPSTATE_UNKNOWN;
        loge("AppStateFromRILInt: bad state: " + i + " use APPSTATE_UNKNOWN");
        return appState;
    }

    public PersoSubState PersoSubstateFromRILInt(int i) {
        PersoSubState persoSubState;
        switch (i) {
            case 0:
                return PersoSubState.PERSOSUBSTATE_UNKNOWN;
            case 1:
                return PersoSubState.PERSOSUBSTATE_IN_PROGRESS;
            case 2:
                return PersoSubState.PERSOSUBSTATE_READY;
            case 3:
                return PersoSubState.PERSOSUBSTATE_SIM_NETWORK;
            case 4:
                return PersoSubState.PERSOSUBSTATE_SIM_NETWORK_SUBSET;
            case 5:
                return PersoSubState.PERSOSUBSTATE_SIM_CORPORATE;
            case 6:
                return PersoSubState.PERSOSUBSTATE_SIM_SERVICE_PROVIDER;
            case 7:
                return PersoSubState.PERSOSUBSTATE_SIM_SIM;
            case 8:
                return PersoSubState.PERSOSUBSTATE_SIM_NETWORK_PUK;
            case 9:
                return PersoSubState.PERSOSUBSTATE_SIM_NETWORK_SUBSET_PUK;
            case 10:
                return PersoSubState.PERSOSUBSTATE_SIM_CORPORATE_PUK;
            case 11:
                return PersoSubState.PERSOSUBSTATE_SIM_SERVICE_PROVIDER_PUK;
            case 12:
                return PersoSubState.PERSOSUBSTATE_SIM_SIM_PUK;
            case 13:
                return PersoSubState.PERSOSUBSTATE_RUIM_NETWORK1;
            case 14:
                return PersoSubState.PERSOSUBSTATE_RUIM_NETWORK2;
            case 15:
                return PersoSubState.PERSOSUBSTATE_RUIM_HRPD;
            case 16:
                return PersoSubState.PERSOSUBSTATE_RUIM_CORPORATE;
            case 17:
                return PersoSubState.PERSOSUBSTATE_RUIM_SERVICE_PROVIDER;
            case 18:
                return PersoSubState.PERSOSUBSTATE_RUIM_RUIM;
            case 19:
                return PersoSubState.PERSOSUBSTATE_RUIM_NETWORK1_PUK;
            case 20:
                return PersoSubState.PERSOSUBSTATE_RUIM_NETWORK2_PUK;
            case 21:
                return PersoSubState.PERSOSUBSTATE_RUIM_HRPD_PUK;
            case 22:
                return PersoSubState.PERSOSUBSTATE_RUIM_CORPORATE_PUK;
            case 23:
                return PersoSubState.PERSOSUBSTATE_RUIM_SERVICE_PROVIDER_PUK;
            case 24:
                return PersoSubState.PERSOSUBSTATE_RUIM_RUIM_PUK;
            case 25:
                return PersoSubState.PERSOSUBSTATE_SIM_SPN;
            case 26:
                return PersoSubState.PERSOSUBSTATE_SIM_SPN_PUK;
            case 27:
                return PersoSubState.PERSOSUBSTATE_SIM_SP_EHPLMN;
            case 28:
                return PersoSubState.PERSOSUBSTATE_SIM_SP_EHPLMN_PUK;
            case 29:
                return PersoSubState.PERSOSUBSTATE_SIM_ICCID;
            case 30:
                return PersoSubState.PERSOSUBSTATE_SIM_ICCID_PUK;
            case 31:
                return PersoSubState.PERSOSUBSTATE_SIM_IMPI;
            case 32:
                return PersoSubState.PERSOSUBSTATE_SIM_IMPI_PUK;
            case 33:
                return PersoSubState.PERSOSUBSTATE_SIM_NS_SP;
            case 34:
                return PersoSubState.PERSOSUBSTATE_SIM_NS_SP_PUK;
            default:
                if (SystemProperties.get("ro.vendor.mtk_telephony_add_on_policy", "0").equals("0")) {
                    try {
                        persoSubState = (PersoSubState) Class.forName("com.mediatek.internal.telephony.uicc.MtkIccUtilsEx").getMethod("PersoSubstateFromRILInt", new Class[]{Integer.TYPE}).invoke((Object) null, new Object[]{Integer.valueOf(i)});
                    } catch (Exception e) {
                        PersoSubState persoSubState2 = PersoSubState.PERSOSUBSTATE_UNKNOWN;
                        loge("No MtkIccUtilsEx! Used AOSP for instead! e: " + e);
                        persoSubState = persoSubState2;
                    }
                } else {
                    persoSubState = PersoSubState.PERSOSUBSTATE_UNKNOWN;
                }
                loge("PersoSubstateFromRILInt: bad substate: " + i + " use PERSOSUBSTATE_UNKNOWN");
                return persoSubState;
        }
    }

    public IccCardStatus.PinState PinStateFromRILInt(int i) {
        if (i == 0) {
            return IccCardStatus.PinState.PINSTATE_UNKNOWN;
        }
        if (i == 1) {
            return IccCardStatus.PinState.PINSTATE_ENABLED_NOT_VERIFIED;
        }
        if (i == 2) {
            return IccCardStatus.PinState.PINSTATE_ENABLED_VERIFIED;
        }
        if (i == 3) {
            return IccCardStatus.PinState.PINSTATE_DISABLED;
        }
        if (i == 4) {
            return IccCardStatus.PinState.PINSTATE_ENABLED_BLOCKED;
        }
        if (i == 5) {
            return IccCardStatus.PinState.PINSTATE_ENABLED_PERM_BLOCKED;
        }
        IccCardStatus.PinState pinState = IccCardStatus.PinState.PINSTATE_UNKNOWN;
        loge("PinStateFromRILInt: bad pin state: " + i + " use PINSTATE_UNKNOWN");
        return pinState;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append(this.app_type);
        sb.append(",");
        sb.append(this.app_state);
        if (this.app_state == AppState.APPSTATE_SUBSCRIPTION_PERSO) {
            sb.append(",");
            sb.append(this.perso_substate);
        }
        AppType appType = this.app_type;
        if (appType == AppType.APPTYPE_CSIM || appType == AppType.APPTYPE_USIM || appType == AppType.APPTYPE_ISIM) {
            sb.append(",pin1=");
            sb.append(this.pin1);
            sb.append(",pin2=");
            sb.append(this.pin2);
        }
        sb.append("}");
        return sb.toString();
    }

    private void loge(String str) {
        Rlog.e("IccCardApplicationStatus", str);
    }
}
