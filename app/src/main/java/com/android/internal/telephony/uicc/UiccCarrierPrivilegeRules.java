package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.os.AsyncResult;
import android.os.Binder;
import android.os.Handler;
import android.os.Message;
import android.telephony.UiccAccessRule;
import android.text.TextUtils;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.LocalLog;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.atomic.AtomicInteger;

public class UiccCarrierPrivilegeRules extends Handler {
    private static final int ARAD = 0;
    private static final String ARAD_AID = "A00000015144414300";
    private static final int ARAM = 1;
    private static final String ARAM_AID = "A00000015141434C00";
    private static final String CARRIER_PRIVILEGE_AID = "FFFFFFFFFFFF";
    private static final int CLA = 128;
    private static final int COMMAND = 202;
    private static final String DATA = "";
    private static final boolean DBG = false;
    private static final int EVENT_CLOSE_LOGICAL_CHANNEL_DONE = 3;
    protected static final int EVENT_OPEN_LOGICAL_CHANNEL_DONE = 1;
    private static final int EVENT_PKCS15_READ_DONE = 4;
    private static final int EVENT_TRANSMIT_LOGICAL_CHANNEL_DONE = 2;
    private static final String LOG_TAG = "UiccCarrierPrivilegeRules";
    private static final int MAX_RETRY = 2;
    private static final int P1 = 255;
    private static final int P2 = 64;
    private static final int P2_EXTENDED_DATA = 96;
    private static final int P3 = 0;
    private static final int RETRY_INTERVAL_MS = 5000;
    protected static final int STATE_ERROR = 2;
    private static final int STATE_LOADED = 1;
    private static final int STATE_LOADING = 0;
    private static final int STATUS_CODE_APPLET_SELECT_FAILED = 27033;
    private static final int STATUS_CODE_CONDITION_NOT_SATISFIED = 27013;
    private static final String TAG_AID_REF_DO = "4F";
    private static final String TAG_ALL_REF_AR_DO = "FF40";
    private static final String TAG_AR_DO = "E3";
    private static final String TAG_DEVICE_APP_ID_REF_DO = "C1";
    private static final String TAG_PERM_AR_DO = "DB";
    private static final String TAG_PKG_REF_DO = "CA";
    private static final String TAG_REF_AR_DO = "E2";
    private static final String TAG_REF_DO = "E1";
    /* access modifiers changed from: private */
    public int mAIDInUse;
    private List<UiccAccessRule> mAccessRules;
    private int mChannelId;
    private boolean mCheckedRules = false;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private Message mLoadedCallback;
    private int mRetryCount;
    private final Runnable mRetryRunnable = new Runnable() {
        public void run() {
            UiccCarrierPrivilegeRules uiccCarrierPrivilegeRules = UiccCarrierPrivilegeRules.this;
            uiccCarrierPrivilegeRules.openChannel(uiccCarrierPrivilegeRules.mAIDInUse);
        }
    };
    private String mRules;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private AtomicInteger mState;
    private LocalLog mStatusMessage = new LocalLog(64);
    private UiccPkcs15 mUiccPkcs15;
    private UiccProfile mUiccProfile;

    private String getStateString(int i) {
        return i != 0 ? i != 1 ? i != 2 ? "UNKNOWN" : "STATE_ERROR" : "STATE_LOADED" : "STATE_LOADING";
    }

    protected static void log(String str) {
    }

    public static class TLV {
        private static final int SINGLE_BYTE_MAX_LENGTH = 128;
        /* access modifiers changed from: private */
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public Integer length;
        /* access modifiers changed from: private */
        public String lengthBytes;
        private String tag;
        /* access modifiers changed from: private */
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public String value;

        public TLV(String str) {
            this.tag = str;
        }

        public String getValue() {
            String str = this.value;
            return str == null ? "" : str;
        }

        public String parseLength(String str) {
            int length2 = this.tag.length();
            int i = length2 + 2;
            int parseInt = Integer.parseInt(str.substring(length2, i), 16);
            if (parseInt < 128) {
                this.length = Integer.valueOf(parseInt * 2);
                this.lengthBytes = str.substring(length2, i);
            } else {
                int i2 = ((parseInt - 128) * 2) + i;
                this.length = Integer.valueOf(Integer.parseInt(str.substring(i, i2), 16) * 2);
                this.lengthBytes = str.substring(length2, i2);
            }
            UiccCarrierPrivilegeRules.log("TLV parseLength length=" + this.length + "lenghtBytes: " + this.lengthBytes);
            return this.lengthBytes;
        }

        public String parse(String str, boolean z) {
            UiccCarrierPrivilegeRules.log("Parse TLV: " + this.tag);
            if (str.startsWith(this.tag)) {
                int length2 = this.tag.length();
                if (length2 + 2 <= str.length()) {
                    parseLength(str);
                    int length3 = length2 + this.lengthBytes.length();
                    UiccCarrierPrivilegeRules.log("index=" + length3 + " length=" + this.length + "data.length=" + str.length());
                    int length4 = str.length() - (this.length.intValue() + length3);
                    if (length4 < 0) {
                        throw new IllegalArgumentException("Not enough data.");
                    } else if (!z || length4 == 0) {
                        this.value = str.substring(length3, this.length.intValue() + length3);
                        UiccCarrierPrivilegeRules.log("Got TLV: " + this.tag + "," + this.length + "," + this.value);
                        return str.substring(length3 + this.length.intValue());
                    } else {
                        throw new IllegalArgumentException("Did not consume all.");
                    }
                } else {
                    throw new IllegalArgumentException("No length.");
                }
            } else {
                throw new IllegalArgumentException("Tags don't match.");
            }
        }
    }

    /* access modifiers changed from: private */
    public void openChannel(int i) {
        this.mUiccProfile.iccOpenLogicalChannel(i == 0 ? ARAD_AID : ARAM_AID, 0, obtainMessage(1, 0, i, (Object) null));
    }

    public UiccCarrierPrivilegeRules(UiccProfile uiccProfile, Message message) {
        log("Creating UiccCarrierPrivilegeRules");
        this.mUiccProfile = uiccProfile;
        this.mState = new AtomicInteger(0);
        this.mStatusMessage.log("Not loaded.");
        this.mLoadedCallback = message;
        this.mRules = "";
        this.mAccessRules = new ArrayList();
        this.mAIDInUse = 0;
        openChannel(0);
    }

    @VisibleForTesting
    public UiccCarrierPrivilegeRules(List<UiccAccessRule> list) {
        this.mAccessRules = list;
        this.mState = new AtomicInteger(1);
        this.mRules = "";
        this.mStatusMessage.log("Loaded from test rules.");
    }

    public boolean areCarrierPriviligeRulesLoaded() {
        return this.mState.get() != 0;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:2:0x0008, code lost:
        r1 = r1.mAccessRules;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean hasCarrierPrivilegeRules() {
        /*
            r1 = this;
            java.util.concurrent.atomic.AtomicInteger r0 = r1.mState
            int r0 = r0.get()
            if (r0 == 0) goto L_0x0014
            java.util.List<android.telephony.UiccAccessRule> r1 = r1.mAccessRules
            if (r1 == 0) goto L_0x0014
            int r1 = r1.size()
            if (r1 <= 0) goto L_0x0014
            r1 = 1
            goto L_0x0015
        L_0x0014:
            r1 = 0
        L_0x0015:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccCarrierPrivilegeRules.hasCarrierPrivilegeRules():boolean");
    }

    public List<String> getPackageNames() {
        ArrayList arrayList = new ArrayList();
        List<UiccAccessRule> list = this.mAccessRules;
        if (list != null) {
            for (UiccAccessRule next : list) {
                if (!TextUtils.isEmpty(next.getPackageName())) {
                    arrayList.add(next.getPackageName());
                }
            }
        }
        return arrayList;
    }

    public List<UiccAccessRule> getAccessRules() {
        List<UiccAccessRule> list = this.mAccessRules;
        if (list == null) {
            return Collections.emptyList();
        }
        return Collections.unmodifiableList(list);
    }

    public int getCarrierPrivilegeStatus(Signature signature, String str) {
        int i = this.mState.get();
        if (i == 0) {
            return -1;
        }
        if (i == 2) {
            return -2;
        }
        for (UiccAccessRule carrierPrivilegeStatus : this.mAccessRules) {
            int carrierPrivilegeStatus2 = carrierPrivilegeStatus.getCarrierPrivilegeStatus(signature, str);
            if (carrierPrivilegeStatus2 != 0) {
                return carrierPrivilegeStatus2;
            }
        }
        return 0;
    }

    public int getCarrierPrivilegeStatus(PackageManager packageManager, String str) {
        try {
            if (hasCarrierPrivilegeRules()) {
                return getCarrierPrivilegeStatus(packageManager.getPackageInfo(str, 671121408));
            }
            int i = this.mState.get();
            if (i == 0) {
                return -1;
            }
            if (i == 2) {
                return -2;
            }
            return 0;
        } catch (PackageManager.NameNotFoundException unused) {
            log("Package " + str + " not found for carrier privilege status check");
            return 0;
        }
    }

    public int getCarrierPrivilegeStatus(PackageInfo packageInfo) {
        int i = this.mState.get();
        if (i == 0) {
            return -1;
        }
        if (i == 2) {
            return -2;
        }
        for (UiccAccessRule carrierPrivilegeStatus : this.mAccessRules) {
            int carrierPrivilegeStatus2 = carrierPrivilegeStatus.getCarrierPrivilegeStatus(packageInfo);
            if (carrierPrivilegeStatus2 != 0) {
                return carrierPrivilegeStatus2;
            }
        }
        return 0;
    }

    public int getCarrierPrivilegeStatusForCurrentTransaction(PackageManager packageManager) {
        return getCarrierPrivilegeStatusForUid(packageManager, Binder.getCallingUid());
    }

    public int getCarrierPrivilegeStatusForUid(PackageManager packageManager, int i) {
        String[] packagesForUid = packageManager.getPackagesForUid(i);
        if (packagesForUid != null) {
            for (String carrierPrivilegeStatus : packagesForUid) {
                int carrierPrivilegeStatus2 = getCarrierPrivilegeStatus(packageManager, carrierPrivilegeStatus);
                if (carrierPrivilegeStatus2 != 0) {
                    return carrierPrivilegeStatus2;
                }
            }
        }
        return 0;
    }

    public static boolean shouldRetry(AsyncResult asyncResult, int i) {
        int i2;
        Throwable th = asyncResult.exception;
        if (!(th instanceof CommandException) || i >= 2) {
            return false;
        }
        CommandException.Error commandError = ((CommandException) th).getCommandError();
        Object obj = asyncResult.result;
        int[] iArr = (int[]) obj;
        if (obj == null || iArr.length != 3) {
            i2 = 0;
        } else {
            i2 = Integer.parseInt(IccUtils.bytesToHexString(new byte[]{(byte) iArr[1], (byte) iArr[2]}), 16);
            log("status code: " + String.valueOf(i2));
        }
        if (commandError == CommandException.Error.MISSING_RESOURCE || ((commandError == CommandException.Error.NO_SUCH_ELEMENT && i2 == STATUS_CODE_CONDITION_NOT_SATISFIED) || (commandError == CommandException.Error.INTERNAL_ERR && i2 == STATUS_CODE_APPLET_SELECT_FAILED))) {
            return true;
        }
        return false;
    }

    public void handleMessage(Message message) {
        Object obj;
        String str;
        Object obj2;
        byte[] bArr;
        Message message2 = message;
        this.mAIDInUse = message2.arg2;
        int i = message2.what;
        if (i == 1) {
            log("EVENT_OPEN_LOGICAL_CHANNEL_DONE");
            AsyncResult asyncResult = (AsyncResult) message2.obj;
            if (asyncResult.exception == null && (obj = asyncResult.result) != null) {
                int i2 = ((int[]) obj)[0];
                this.mChannelId = i2;
                this.mUiccProfile.iccTransmitApduLogicalChannel(i2, 128, COMMAND, 255, 64, 0, "", obtainMessage(2, i2, this.mAIDInUse));
            } else if (shouldRetry(asyncResult, this.mRetryCount)) {
                log("should retry");
                this.mRetryCount++;
                removeCallbacks(this.mRetryRunnable);
                postDelayed(this.mRetryRunnable, 5000);
            } else {
                if (this.mAIDInUse == 0) {
                    this.mRules = "";
                    openChannel(1);
                }
                if (this.mAIDInUse != 1) {
                    return;
                }
                if (this.mCheckedRules) {
                    updateState(1, "Success!");
                    return;
                }
                log("No ARA, try ARF next.");
                Throwable th = asyncResult.exception;
                if ((th instanceof CommandException) && ((CommandException) th).getCommandError() != CommandException.Error.NO_SUCH_ELEMENT) {
                    updateStatusMessage("No ARA due to " + ((CommandException) asyncResult.exception).getCommandError());
                }
                this.mUiccPkcs15 = new UiccPkcs15(this.mUiccProfile, obtainMessage(4));
            }
        } else if (i == 2) {
            log("EVENT_TRANSMIT_LOGICAL_CHANNEL_DONE");
            AsyncResult asyncResult2 = (AsyncResult) message2.obj;
            if (asyncResult2.exception != null || (obj2 = asyncResult2.result) == null) {
                StringBuilder sb = new StringBuilder();
                sb.append("Error reading value from SIM via ");
                sb.append(this.mAIDInUse == 0 ? "ARAD" : "ARAM");
                sb.append(" due to ");
                String sb2 = sb.toString();
                Throwable th2 = asyncResult2.exception;
                if (th2 instanceof CommandException) {
                    str = sb2 + "error code : " + ((CommandException) th2).getCommandError();
                } else {
                    str = sb2 + "unknown exception : " + asyncResult2.exception.getMessage();
                }
                if (this.mAIDInUse == 0) {
                    updateStatusMessage(str);
                } else {
                    updateState(2, str);
                }
            } else {
                IccIoResult iccIoResult = (IccIoResult) obj2;
                if (iccIoResult.sw1 == 144 && iccIoResult.sw2 == 0 && (bArr = iccIoResult.payload) != null && bArr.length > 0) {
                    try {
                        this.mRules += IccUtils.bytesToHexString(iccIoResult.payload).toUpperCase(Locale.US);
                        if (isDataComplete()) {
                            this.mAccessRules.addAll(parseRules(this.mRules));
                            if (this.mAIDInUse == 0) {
                                this.mCheckedRules = true;
                            } else {
                                updateState(1, "Success!");
                            }
                        } else {
                            UiccProfile uiccProfile = this.mUiccProfile;
                            int i3 = this.mChannelId;
                            uiccProfile.iccTransmitApduLogicalChannel(i3, 128, COMMAND, 255, 96, 0, "", obtainMessage(2, i3, this.mAIDInUse));
                            return;
                        }
                    } catch (IllegalArgumentException | IndexOutOfBoundsException e) {
                        if (this.mAIDInUse == 1) {
                            updateState(2, "Error parsing rules: " + e);
                        }
                    }
                } else if (this.mAIDInUse == 1) {
                    updateState(2, "Invalid response: payload=" + iccIoResult.payload + " sw1=" + iccIoResult.sw1 + " sw2=" + iccIoResult.sw2);
                }
            }
            this.mUiccProfile.iccCloseLogicalChannel(this.mChannelId, obtainMessage(3, 0, this.mAIDInUse));
            this.mChannelId = -1;
        } else if (i == 3) {
            log("EVENT_CLOSE_LOGICAL_CHANNEL_DONE");
            if (this.mAIDInUse == 0) {
                this.mRules = "";
                openChannel(1);
            }
        } else if (i != 4) {
            Rlog.e(LOG_TAG, "Unknown event " + message2.what);
        } else {
            log("EVENT_PKCS15_READ_DONE");
            UiccPkcs15 uiccPkcs15 = this.mUiccPkcs15;
            if (uiccPkcs15 == null || uiccPkcs15.getRules() == null) {
                updateState(2, "No ARA or ARF.");
                return;
            }
            for (String hexStringToBytes : this.mUiccPkcs15.getRules()) {
                this.mAccessRules.add(new UiccAccessRule(IccUtils.hexStringToBytes(hexStringToBytes), "", 0));
            }
            updateState(1, "Success!");
        }
    }

    private boolean isDataComplete() {
        log("isDataComplete mRules:" + this.mRules);
        if (this.mRules.startsWith(TAG_ALL_REF_AR_DO)) {
            TLV tlv = new TLV(TAG_ALL_REF_AR_DO);
            String parseLength = tlv.parseLength(this.mRules);
            log("isDataComplete lengthBytes: " + parseLength);
            if (this.mRules.length() == 4 + parseLength.length() + tlv.length.intValue()) {
                log("isDataComplete yes");
                return true;
            }
            log("isDataComplete no");
            return false;
        }
        throw new IllegalArgumentException("Tags don't match.");
    }

    private static List<UiccAccessRule> parseRules(String str) {
        log("Got rules: " + str);
        TLV tlv = new TLV(TAG_ALL_REF_AR_DO);
        tlv.parse(str, true);
        String r4 = tlv.value;
        ArrayList arrayList = new ArrayList();
        while (!r4.isEmpty()) {
            TLV tlv2 = new TLV(TAG_REF_AR_DO);
            r4 = tlv2.parse(r4, false);
            UiccAccessRule parseRefArdo = parseRefArdo(tlv2.value);
            if (parseRefArdo != null) {
                arrayList.add(parseRefArdo);
            } else {
                Rlog.e(LOG_TAG, "Skip unrecognized rule." + tlv2.value);
            }
        }
        return arrayList;
    }

    private static UiccAccessRule parseRefArdo(String str) {
        String str2;
        String str3;
        String str4;
        log("Got rule: " + str);
        String str5 = null;
        String str6 = null;
        while (!str.isEmpty()) {
            if (str.startsWith(TAG_REF_DO)) {
                TLV tlv = new TLV(TAG_REF_DO);
                str = tlv.parse(str, false);
                TLV tlv2 = new TLV(TAG_DEVICE_APP_ID_REF_DO);
                if (tlv.value.startsWith(TAG_AID_REF_DO)) {
                    TLV tlv3 = new TLV(TAG_AID_REF_DO);
                    String parse = tlv3.parse(tlv.value, false);
                    if (!tlv3.lengthBytes.equals("06") || !tlv3.value.equals(CARRIER_PRIVILEGE_AID) || parse.isEmpty() || !parse.startsWith(TAG_DEVICE_APP_ID_REF_DO)) {
                        return null;
                    }
                    str3 = tlv2.parse(parse, false);
                    str2 = tlv2.value;
                } else if (!tlv.value.startsWith(TAG_DEVICE_APP_ID_REF_DO)) {
                    return null;
                } else {
                    str3 = tlv2.parse(tlv.value, false);
                    str2 = tlv2.value;
                }
                if (str3.isEmpty()) {
                    str4 = null;
                } else if (!str3.startsWith(TAG_PKG_REF_DO)) {
                    return null;
                } else {
                    TLV tlv4 = new TLV(TAG_PKG_REF_DO);
                    tlv4.parse(str3, true);
                    str4 = new String(IccUtils.hexStringToBytes(tlv4.value));
                }
                String str7 = str2;
                str6 = str4;
                str5 = str7;
            } else if (str.startsWith(TAG_AR_DO)) {
                TLV tlv5 = new TLV(TAG_AR_DO);
                str = tlv5.parse(str, false);
                String r3 = tlv5.value;
                while (!r3.isEmpty() && !r3.startsWith(TAG_PERM_AR_DO)) {
                    r3 = new TLV(r3.substring(0, 2)).parse(r3, false);
                }
                if (r3.isEmpty()) {
                    return null;
                }
                new TLV(TAG_PERM_AR_DO).parse(r3, true);
            } else {
                throw new RuntimeException("Invalid Rule type");
            }
        }
        return new UiccAccessRule(IccUtils.hexStringToBytes(str5), str6, 0);
    }

    /* access modifiers changed from: protected */
    public void updateState(int i, String str) {
        this.mState.set(i);
        Message message = this.mLoadedCallback;
        if (message != null) {
            message.sendToTarget();
        }
        updateStatusMessage(str);
    }

    private void updateStatusMessage(String str) {
        this.mStatusMessage.log(str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("UiccCarrierPrivilegeRules: " + this);
        printWriter.println(" mState=" + getStateString(this.mState.get()));
        printWriter.println(" mStatusMessage=");
        this.mStatusMessage.dump(fileDescriptor, printWriter, strArr);
        if (this.mAccessRules != null) {
            printWriter.println(" mAccessRules: ");
            for (UiccAccessRule uiccAccessRule : this.mAccessRules) {
                printWriter.println("  rule='" + uiccAccessRule + "'");
            }
        } else {
            printWriter.println(" mAccessRules: null");
        }
        if (this.mUiccPkcs15 != null) {
            printWriter.println(" mUiccPkcs15: " + this.mUiccPkcs15);
            this.mUiccPkcs15.dump(fileDescriptor, printWriter, strArr);
        } else {
            printWriter.println(" mUiccPkcs15: null");
        }
        printWriter.flush();
    }
}
