package com.android.internal.telephony.cdnr;

import android.content.Context;
import android.content.res.Configuration;
import android.os.PersistableBundle;
import android.telephony.CarrierConfigManager;
import android.telephony.ServiceState;
import android.telephony.SubscriptionManager;
import android.text.TextUtils;
import android.util.SparseArray;
import com.android.internal.telephony.GsmCdmaPhone;
import com.android.internal.telephony.IndentingPrintWriter;
import com.android.internal.telephony.LocalLog;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.cdnr.CarrierDisplayNameData;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.internal.telephony.uicc.RuimRecords;
import com.android.internal.telephony.uicc.SIMRecords;
import com.android.telephony.Rlog;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Objects;

public class CarrierDisplayNameResolver {
    private static final boolean DBG = true;
    private static final CarrierDisplayNameConditionRule DEFAULT_CARRIER_DISPLAY_NAME_RULE = new CarrierDisplayNameConditionRule(0);
    private static final int DEFAULT_CARRIER_NAME_DISPLAY_CONDITION_BITMASK = 0;
    private static final List<Integer> EF_SOURCE_PRIORITY = Arrays.asList(new Integer[]{2, 1, 10, 3, 4, 5, 6, 7, 8, 9});
    private static final String TAG = "CDNR";
    private final CarrierConfigManager mCCManager;
    private CarrierDisplayNameData mCarrierDisplayNameData;
    private final Context mContext;
    private final SparseArray<EfData> mEf = new SparseArray<>();
    private final LocalLog mLocalLog = new LocalLog(32);
    private final GsmCdmaPhone mPhone;

    public CarrierDisplayNameResolver(GsmCdmaPhone gsmCdmaPhone) {
        Context context = gsmCdmaPhone.getContext();
        this.mContext = context;
        this.mPhone = gsmCdmaPhone;
        this.mCCManager = (CarrierConfigManager) context.getSystemService("carrier_config");
    }

    public void updateEfFromRuim(RuimRecords ruimRecords) {
        int sourcePriority = getSourcePriority(6);
        if (ruimRecords == null) {
            this.mEf.remove(sourcePriority);
        } else {
            this.mEf.put(sourcePriority, new RuimEfData(ruimRecords));
        }
    }

    public void updateEfFromUsim(SIMRecords sIMRecords) {
        int sourcePriority = getSourcePriority(3);
        if (sIMRecords == null) {
            this.mEf.remove(sourcePriority);
        } else {
            this.mEf.put(sourcePriority, new UsimEfData(sIMRecords));
        }
    }

    public void updateEfFromCarrierConfig(PersistableBundle persistableBundle) {
        int sourcePriority = getSourcePriority(1);
        if (persistableBundle == null) {
            this.mEf.remove(sourcePriority);
        } else {
            this.mEf.put(sourcePriority, new CarrierConfigEfData(persistableBundle));
        }
    }

    public void updateEfForEri(String str) {
        PersistableBundle carrierConfig = getCarrierConfig();
        int sourcePriority = getSourcePriority(10);
        if (TextUtils.isEmpty(str) || ((!this.mPhone.isPhoneTypeCdma() && !this.mPhone.isPhoneTypeCdmaLte()) || !carrierConfig.getBoolean("allow_cdma_eri_bool"))) {
            this.mEf.remove(sourcePriority);
        } else {
            this.mEf.put(sourcePriority, new EriEfData(str));
        }
    }

    public void updateEfForBrandOverride(String str) {
        int sourcePriority = getSourcePriority(2);
        if (TextUtils.isEmpty(str)) {
            this.mEf.remove(sourcePriority);
        } else {
            this.mEf.put(sourcePriority, new BrandOverrideEfData(str, getServiceState().getOperatorNumeric()));
        }
    }

    public CarrierDisplayNameData getCarrierDisplayNameData() {
        resolveCarrierDisplayName();
        return this.mCarrierDisplayNameData;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < this.mEf.size(); i++) {
            EfData valueAt = this.mEf.valueAt(i);
            sb.append("{spnDisplayCondition = " + valueAt.getServiceProviderNameDisplayCondition(isRoaming()) + ", spn = " + valueAt.getServiceProviderName() + ", spdiList = " + valueAt.getServiceProviderDisplayInformation() + ", pnnList = " + valueAt.getPlmnNetworkNameList() + ", oplList = " + valueAt.getOperatorPlmnList() + ", ehplmn = " + valueAt.getEhplmnList() + "}, ");
        }
        sb.append(", roamingFromSS = " + getServiceState().getRoaming());
        sb.append(", registeredPLMN = " + getServiceState().getOperatorNumeric());
        return sb.toString();
    }

    public void dump(IndentingPrintWriter indentingPrintWriter) {
        indentingPrintWriter.println("CDNR:");
        indentingPrintWriter.increaseIndent();
        indentingPrintWriter.println("fields = " + toString());
        indentingPrintWriter.println("carrierDisplayNameData = " + this.mCarrierDisplayNameData);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("CDNR local log:");
        indentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(indentingPrintWriter);
        indentingPrintWriter.decreaseIndent();
    }

    private PersistableBundle getCarrierConfig() {
        PersistableBundle configForSubId = this.mCCManager.getConfigForSubId(this.mPhone.getSubId());
        return configForSubId == null ? CarrierConfigManager.getDefaultConfig() : configForSubId;
    }

    private CarrierDisplayNameConditionRule getDisplayRule() {
        boolean isRoaming = isRoaming();
        for (int i = 0; i < this.mEf.size(); i++) {
            if (this.mEf.valueAt(i).getServiceProviderNameDisplayCondition(isRoaming) != -1) {
                return new CarrierDisplayNameConditionRule(this.mEf.valueAt(i).getServiceProviderNameDisplayCondition(isRoaming));
            }
        }
        return DEFAULT_CARRIER_DISPLAY_NAME_RULE;
    }

    private List<String> getEfSpdi() {
        for (int i = 0; i < this.mEf.size(); i++) {
            if (this.mEf.valueAt(i).getServiceProviderDisplayInformation() != null) {
                return this.mEf.valueAt(i).getServiceProviderDisplayInformation();
            }
        }
        return Collections.EMPTY_LIST;
    }

    private String getEfSpn() {
        for (int i = 0; i < this.mEf.size(); i++) {
            if (!TextUtils.isEmpty(this.mEf.valueAt(i).getServiceProviderName())) {
                return this.mEf.valueAt(i).getServiceProviderName();
            }
        }
        return "";
    }

    private List<IccRecords.OperatorPlmnInfo> getEfOpl() {
        for (int i = 0; i < this.mEf.size(); i++) {
            if (this.mEf.valueAt(i).getOperatorPlmnList() != null) {
                return this.mEf.valueAt(i).getOperatorPlmnList();
            }
        }
        return Collections.EMPTY_LIST;
    }

    private List<IccRecords.PlmnNetworkName> getEfPnn() {
        for (int i = 0; i < this.mEf.size(); i++) {
            if (this.mEf.valueAt(i).getPlmnNetworkNameList() != null) {
                return this.mEf.valueAt(i).getPlmnNetworkNameList();
            }
        }
        return Collections.EMPTY_LIST;
    }

    private boolean isRoaming() {
        return getServiceState().getRoaming() && !getEfSpdi().contains(getServiceState().getOperatorNumeric());
    }

    private CarrierDisplayNameData getCarrierDisplayNameFromEf() {
        String str;
        CarrierDisplayNameConditionRule displayRule = getDisplayRule();
        String operatorAlpha = getServiceState().getOperatorAlpha();
        String operatorNumeric = getServiceState().getOperatorNumeric();
        String efSpn = getEfSpn();
        List<IccRecords.OperatorPlmnInfo> efOpl = getEfOpl();
        List<IccRecords.PlmnNetworkName> efPnn = getEfPnn();
        boolean z = false;
        if (isRoaming()) {
            str = operatorAlpha;
        } else {
            str = efOpl.isEmpty() ? efPnn.isEmpty() ? "" : getPlmnNetworkName(efPnn.get(0)) : null;
        }
        if (TextUtils.isEmpty(str)) {
            if (TextUtils.isEmpty(operatorAlpha)) {
                operatorAlpha = operatorNumeric;
            }
            str = operatorAlpha;
        }
        boolean shouldShowSpn = displayRule.shouldShowSpn(efSpn);
        if (TextUtils.isEmpty(efSpn) || displayRule.shouldShowPlmn(str)) {
            z = true;
        }
        return new CarrierDisplayNameData.Builder().setSpn(efSpn).setShowSpn(shouldShowSpn).setPlmn(str).setShowPlmn(z).build();
    }

    private CarrierDisplayNameData getCarrierDisplayNameFromWifiCallingOverride(CarrierDisplayNameData carrierDisplayNameData) {
        PersistableBundle carrierConfig = getCarrierConfig();
        boolean z = carrierConfig.getBoolean("wfc_spn_use_root_locale");
        Context context = this.mContext;
        if (z) {
            Configuration configuration = context.getResources().getConfiguration();
            configuration.setLocale(Locale.ROOT);
            context = this.mContext.createConfigurationContext(configuration);
        }
        WfcCarrierNameFormatter wfcCarrierNameFormatter = new WfcCarrierNameFormatter(carrierConfig, context.getResources().getStringArray(17236216), getServiceState().getState() == 3);
        String formatVoiceName = wfcCarrierNameFormatter.formatVoiceName(carrierDisplayNameData.getSpn());
        String formatDataName = wfcCarrierNameFormatter.formatDataName(carrierDisplayNameData.getSpn());
        List<IccRecords.PlmnNetworkName> efPnn = getEfPnn();
        String plmnNetworkName = efPnn.isEmpty() ? "" : getPlmnNetworkName(efPnn.get(0));
        if (TextUtils.isEmpty(plmnNetworkName)) {
            plmnNetworkName = carrierDisplayNameData.getPlmn();
        }
        String formatVoiceName2 = wfcCarrierNameFormatter.formatVoiceName(plmnNetworkName);
        if (TextUtils.isEmpty(formatVoiceName) || TextUtils.isEmpty(formatDataName)) {
            return !TextUtils.isEmpty(formatVoiceName2) ? new CarrierDisplayNameData.Builder().setPlmn(formatVoiceName2).setShowPlmn(true).build() : carrierDisplayNameData;
        }
        return new CarrierDisplayNameData.Builder().setSpn(formatVoiceName).setDataSpn(formatDataName).setShowSpn(true).build();
    }

    private CarrierDisplayNameData getCarrierDisplayNameFromCrossSimCallingOverride(CarrierDisplayNameData carrierDisplayNameData) {
        PersistableBundle carrierConfig = getCarrierConfig();
        int i = carrierConfig.getInt("cross_sim_spn_format_int");
        String[] stringArray = SubscriptionManager.getResourcesForSubId(this.mPhone.getContext(), this.mPhone.getSubId(), carrierConfig.getBoolean("wfc_spn_use_root_locale")).getStringArray(17236166);
        if (i < 0 || i >= stringArray.length) {
            Rlog.e(TAG, "updateSpnDisplay: KEY_CROSS_SIM_SPN_FORMAT_INT out of bounds: " + i);
            i = 0;
        }
        String str = stringArray[i];
        List<IccRecords.PlmnNetworkName> efPnn = getEfPnn();
        String plmnNetworkName = efPnn.isEmpty() ? "" : getPlmnNetworkName(efPnn.get(0));
        String spn = carrierDisplayNameData.getSpn();
        String plmn = TextUtils.isEmpty(plmnNetworkName) ? carrierDisplayNameData.getPlmn() : plmnNetworkName;
        String format = String.format(str, new Object[]{spn});
        String format2 = String.format(str, new Object[]{plmnNetworkName});
        if (TextUtils.isEmpty(spn) || TextUtils.isEmpty(format)) {
            return (TextUtils.isEmpty(plmn) || TextUtils.isEmpty(format2)) ? carrierDisplayNameData : new CarrierDisplayNameData.Builder().setPlmn(format2).setShowPlmn(true).build();
        }
        return new CarrierDisplayNameData.Builder().setSpn(format).setDataSpn(format).setShowSpn(true).build();
    }

    private CarrierDisplayNameData getOutOfServiceDisplayName(CarrierDisplayNameData carrierDisplayNameData) {
        String str;
        boolean z = false;
        boolean z2 = this.mPhone.getUiccCardApplication() != null && this.mPhone.getUiccCardApplication().getState() == IccCardApplicationStatus.AppState.APPSTATE_READY;
        if (this.mPhone.getServiceStateTracker().shouldForceDisplayNoService() && !z2) {
            z = true;
        }
        if (getServiceState().getState() == 3 && !z && !Phone.isEmergencyCallOnly()) {
            str = null;
        } else if (z || !Phone.isEmergencyCallOnly()) {
            str = this.mContext.getResources().getString(17040617);
        } else {
            str = this.mContext.getResources().getString(17040208);
        }
        return new CarrierDisplayNameData.Builder().setSpn(carrierDisplayNameData.getSpn()).setDataSpn(carrierDisplayNameData.getDataSpn()).setShowSpn(carrierDisplayNameData.shouldShowSpn()).setPlmn(str).setShowPlmn(true).build();
    }

    private void resolveCarrierDisplayName() {
        CarrierDisplayNameData carrierDisplayNameFromEf = getCarrierDisplayNameFromEf();
        Rlog.d(TAG, "CarrierName from EF: " + carrierDisplayNameFromEf);
        if (this.mPhone.getImsPhone() != null && this.mPhone.getImsPhone().getImsRegistrationTech() == 2) {
            carrierDisplayNameFromEf = getCarrierDisplayNameFromCrossSimCallingOverride(carrierDisplayNameFromEf);
            Rlog.d(TAG, "CarrierName override by Cross-SIM Calling " + carrierDisplayNameFromEf);
        } else if (this.mPhone.getServiceStateTracker().getCombinedRegState(getServiceState()) != 0) {
            carrierDisplayNameFromEf = getOutOfServiceDisplayName(carrierDisplayNameFromEf);
            Rlog.d(TAG, "Out of service carrierName " + carrierDisplayNameFromEf);
        } else if (this.mPhone.isWifiCallingEnabled()) {
            carrierDisplayNameFromEf = getCarrierDisplayNameFromWifiCallingOverride(carrierDisplayNameFromEf);
            Rlog.d(TAG, "CarrierName override by wifi-calling " + carrierDisplayNameFromEf);
        } else if (getServiceState().getState() == 3) {
            carrierDisplayNameFromEf = getOutOfServiceDisplayName(carrierDisplayNameFromEf);
            Rlog.d(TAG, "Out of service carrierName (APM) " + carrierDisplayNameFromEf);
        }
        if (!Objects.equals(this.mCarrierDisplayNameData, carrierDisplayNameFromEf)) {
            this.mLocalLog.log(String.format("ResolveCarrierDisplayName: %s", new Object[]{carrierDisplayNameFromEf.toString()}));
        }
        this.mCarrierDisplayNameData = carrierDisplayNameFromEf;
    }

    private static String getPlmnNetworkName(IccRecords.PlmnNetworkName plmnNetworkName) {
        if (plmnNetworkName == null) {
            return "";
        }
        if (!TextUtils.isEmpty(plmnNetworkName.fullName)) {
            return plmnNetworkName.fullName;
        }
        if (!TextUtils.isEmpty(plmnNetworkName.shortName)) {
            return plmnNetworkName.shortName;
        }
        return "";
    }

    private static int getSourcePriority(int i) {
        int indexOf = EF_SOURCE_PRIORITY.indexOf(Integer.valueOf(i));
        if (indexOf == -1) {
            return Integer.MAX_VALUE;
        }
        return indexOf;
    }

    private static final class CarrierDisplayNameConditionRule {
        private int mDisplayConditionBitmask;

        CarrierDisplayNameConditionRule(int i) {
            this.mDisplayConditionBitmask = i;
        }

        /* access modifiers changed from: package-private */
        public boolean shouldShowSpn(String str) {
            Boolean valueOf = Boolean.valueOf((this.mDisplayConditionBitmask & 2) == 2);
            if (TextUtils.isEmpty(str) || !valueOf.booleanValue()) {
                return false;
            }
            return true;
        }

        /* access modifiers changed from: package-private */
        public boolean shouldShowPlmn(String str) {
            Boolean valueOf = Boolean.valueOf((this.mDisplayConditionBitmask & 1) == 1);
            if (TextUtils.isEmpty(str) || !valueOf.booleanValue()) {
                return false;
            }
            return true;
        }

        public String toString() {
            return String.format("{ SPN_bit = %d, PLMN_bit = %d }", new Object[]{Integer.valueOf(2 & this.mDisplayConditionBitmask), Integer.valueOf(this.mDisplayConditionBitmask & 1)});
        }
    }

    private ServiceState getServiceState() {
        return this.mPhone.getServiceStateTracker().getServiceState();
    }

    private static final class WfcCarrierNameFormatter {
        final String mDataFormat;
        final String mVoiceFormat;

        WfcCarrierNameFormatter(PersistableBundle persistableBundle, String[] strArr, boolean z) {
            int i = persistableBundle.getInt("wfc_spn_format_idx_int");
            int i2 = persistableBundle.getInt("wfc_data_spn_format_idx_int");
            int i3 = persistableBundle.getInt("wfc_flight_mode_spn_format_idx_int");
            if (i < 0 || i >= strArr.length) {
                Rlog.e(CarrierDisplayNameResolver.TAG, "updateSpnDisplay: KEY_WFC_SPN_FORMAT_IDX_INT out of bounds: " + i);
                i = 0;
            }
            if (i2 < 0 || i2 >= strArr.length) {
                Rlog.e(CarrierDisplayNameResolver.TAG, "updateSpnDisplay: KEY_WFC_DATA_SPN_FORMAT_IDX_INT out of bounds: " + i2);
                i2 = 0;
            }
            i = z ? (i3 < 0 || i3 >= strArr.length) ? i : i3 : i;
            String str = "";
            this.mVoiceFormat = i != -1 ? strArr[i] : str;
            this.mDataFormat = i2 != -1 ? strArr[i2] : str;
        }

        public String formatVoiceName(String str) {
            if (TextUtils.isEmpty(str)) {
                return str;
            }
            return String.format(this.mVoiceFormat, new Object[]{str.trim()});
        }

        public String formatDataName(String str) {
            if (TextUtils.isEmpty(str)) {
                return str;
            }
            return String.format(this.mDataFormat, new Object[]{str.trim()});
        }
    }
}
