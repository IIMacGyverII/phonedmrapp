package com.android.internal.telephony;

import android.os.Handler;
import android.telephony.AnomalyReporter;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.TelephonyDisplayInfo;
import android.telephony.TelephonyManager;
import android.util.Pair;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.Set;
import java.util.UUID;
import javax.sip.InvalidArgumentException;

public class DisplayInfoController extends Handler {
    private static final String TAG = "DisplayInfoController";
    private static final Set<Pair<Integer, Integer>> VALID_DISPLAY_INFO_SET = Set.of(Pair.create(13, 1), Pair.create(13, 2), Pair.create(13, 3), Pair.create(13, 5), Pair.create(20, 5));
    private final LocalLog mLocalLog = new LocalLog(128);
    private final String mLogTag;
    protected NetworkTypeController mNetworkTypeController;
    protected final Phone mPhone;
    protected TelephonyDisplayInfo mTelephonyDisplayInfo;
    protected final RegistrantList mTelephonyDisplayInfoChangedRegistrants = new RegistrantList();

    public DisplayInfoController(Phone phone) {
        this.mPhone = phone;
        this.mLogTag = "DIC-" + phone.getPhoneId();
        NetworkTypeController networkTypeController = new NetworkTypeController(phone, this);
        this.mNetworkTypeController = networkTypeController;
        networkTypeController.sendMessage(0);
    }

    public TelephonyDisplayInfo getTelephonyDisplayInfo() {
        return this.mTelephonyDisplayInfo;
    }

    public void updateTelephonyDisplayInfo() {
        int i;
        NetworkRegistrationInfo networkRegistrationInfo = this.mPhone.getServiceState().getNetworkRegistrationInfo(2, 1);
        if (networkRegistrationInfo == null) {
            i = 0;
        } else {
            i = networkRegistrationInfo.getAccessNetworkTechnology();
        }
        TelephonyDisplayInfo telephonyDisplayInfo = new TelephonyDisplayInfo(i, this.mNetworkTypeController.getOverrideNetworkType());
        if (!telephonyDisplayInfo.equals(this.mTelephonyDisplayInfo)) {
            logl("TelephonyDisplayInfo changed from " + this.mTelephonyDisplayInfo + " to " + telephonyDisplayInfo);
            validateDisplayInfo(telephonyDisplayInfo);
            this.mTelephonyDisplayInfo = telephonyDisplayInfo;
            this.mTelephonyDisplayInfoChangedRegistrants.notifyRegistrants();
            this.mPhone.notifyDisplayInfoChanged(this.mTelephonyDisplayInfo);
        }
    }

    /* access modifiers changed from: protected */
    public void validateDisplayInfo(TelephonyDisplayInfo telephonyDisplayInfo) {
        try {
            if (telephonyDisplayInfo.getNetworkType() != 19) {
                if (telephonyDisplayInfo.getNetworkType() < 0) {
                    if (telephonyDisplayInfo.getNetworkType() > 20) {
                        throw new InvalidArgumentException("Invalid network type " + telephonyDisplayInfo.getNetworkType());
                    }
                }
                if (telephonyDisplayInfo.getOverrideNetworkType() == 0) {
                    return;
                }
                if (!VALID_DISPLAY_INFO_SET.contains(Pair.create(Integer.valueOf(telephonyDisplayInfo.getNetworkType()), Integer.valueOf(telephonyDisplayInfo.getOverrideNetworkType())))) {
                    throw new InvalidArgumentException("Invalid network type override " + TelephonyDisplayInfo.overrideNetworkTypeToString(telephonyDisplayInfo.getOverrideNetworkType()) + " for " + TelephonyManager.getNetworkTypeName(telephonyDisplayInfo.getNetworkType()));
                }
                return;
            }
            throw new InvalidArgumentException("LTE_CA is not a valid network type.");
        } catch (InvalidArgumentException e) {
            logel(e.getMessage());
            AnomalyReporter.reportAnomaly(UUID.fromString("3aa92a2c-94ed-46a0-a744-d6b1dfec2a55"), e.getMessage(), this.mPhone.getCarrierId());
        }
    }

    public void registerForTelephonyDisplayInfoChanged(Handler handler, int i, Object obj) {
        this.mTelephonyDisplayInfoChangedRegistrants.add(new Registrant(handler, i, obj));
    }

    public void unregisterForTelephonyDisplayInfoChanged(Handler handler) {
        this.mTelephonyDisplayInfoChangedRegistrants.remove(handler);
    }

    private void log(String str) {
        Rlog.d(this.mLogTag, str);
    }

    private void loge(String str) {
        Rlog.e(this.mLogTag, str);
    }

    /* access modifiers changed from: protected */
    public void logl(String str) {
        log(str);
        this.mLocalLog.log(str);
    }

    private void logel(String str) {
        loge(str);
        this.mLocalLog.log(str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter = new AndroidUtilIndentingPrintWriter(printWriter, "  ");
        androidUtilIndentingPrintWriter.println("DisplayInfoController:");
        androidUtilIndentingPrintWriter.println(" mPhone=" + this.mPhone.getPhoneName());
        androidUtilIndentingPrintWriter.println(" mTelephonyDisplayInfo=" + this.mTelephonyDisplayInfo.toString());
        androidUtilIndentingPrintWriter.flush();
        androidUtilIndentingPrintWriter.println("Local logs:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.println(" ***************************************");
        this.mNetworkTypeController.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.flush();
    }
}
