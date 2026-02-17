package com.android.internal.telephony;

import android.annotation.RequiresPermission;
import android.app.AppOpsManager;
import android.app.PendingIntent;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.ContentResolver;
import android.content.Context;
import android.net.Uri;
import android.os.AsyncResult;
import android.os.Binder;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.telephony.SmsManager;
import android.telephony.SmsMessage;
import android.telephony.emergency.EmergencyNumber;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.cdma.CdmaSmsBroadcastConfigInfo;
import com.android.internal.telephony.gsm.SmsBroadcastConfigInfo;
import com.android.internal.telephony.uicc.IccConstants;
import com.android.internal.telephony.uicc.IccFileHandler;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.UiccController;
import com.android.internal.telephony.uicc.UiccProfile;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

public class IccSmsInterfaceManager {
    static final boolean DBG = true;
    private static final int EVENT_GET_SMSC_DONE = 5;
    private static final int EVENT_LOAD_DONE = 1;
    protected static final int EVENT_SET_BROADCAST_ACTIVATION_DONE = 3;
    protected static final int EVENT_SET_BROADCAST_CONFIG_DONE = 4;
    private static final int EVENT_SET_SMSC_DONE = 6;
    private static final int EVENT_UPDATE_DONE = 2;
    static final String LOG_TAG = "IccSmsInterfaceManager";
    private static final int SMS_CB_CODE_SCHEME_MAX = 255;
    private static final int SMS_CB_CODE_SCHEME_MIN = 0;
    public static final int SMS_MESSAGE_PERIOD_NOT_SPECIFIED = -1;
    public static final int SMS_MESSAGE_PRIORITY_NOT_SPECIFIED = -1;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final AppOpsManager mAppOps;
    private CdmaBroadcastRangeManager mCdmaBroadcastRangeManager;
    private final LocalLog mCellBroadcastLocalLog;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private CellBroadcastRangeManager mCellBroadcastRangeManager;
    @UnsupportedAppUsage
    protected final Context mContext;
    @VisibleForTesting
    public SmsDispatchersController mDispatchersController;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected Handler mHandler;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected Phone mPhone;
    private SmsPermissions mSmsPermissions;

    public static final class Request {
        public Object mResult = null;
        public AtomicBoolean mStatus = new AtomicBoolean(false);
    }

    /* JADX WARNING: Illegal instructions before constructor call */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    protected IccSmsInterfaceManager(com.android.internal.telephony.Phone r8) {
        /*
            r7 = this;
            android.content.Context r2 = r8.getContext()
            android.content.Context r0 = r8.getContext()
            java.lang.String r1 = "appops"
            java.lang.Object r0 = r0.getSystemService(r1)
            r3 = r0
            android.app.AppOpsManager r3 = (android.app.AppOpsManager) r3
            com.android.internal.telephony.TelephonyComponentFactory r0 = com.android.internal.telephony.TelephonyComponentFactory.getInstance()
            java.lang.Class<com.android.internal.telephony.TelephonyComponentFactory> r4 = com.android.internal.telephony.TelephonyComponentFactory.class
            java.lang.String r4 = r4.getName()
            com.android.internal.telephony.TelephonyComponentFactory r0 = r0.inject(r4)
            com.android.internal.telephony.SmsStorageMonitor r4 = r8.mSmsStorageMonitor
            com.android.internal.telephony.SmsUsageMonitor r5 = r8.mSmsUsageMonitor
            com.android.internal.telephony.SmsDispatchersController r4 = r0.makeSmsDispatchersController(r8, r4, r5)
            com.android.internal.telephony.SmsPermissions r5 = new com.android.internal.telephony.SmsPermissions
            android.content.Context r0 = r8.getContext()
            android.content.Context r6 = r8.getContext()
            java.lang.Object r1 = r6.getSystemService(r1)
            android.app.AppOpsManager r1 = (android.app.AppOpsManager) r1
            r5.<init>(r8, r0, r1)
            r0 = r7
            r1 = r8
            r0.<init>(r1, r2, r3, r4, r5)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.IccSmsInterfaceManager.<init>(com.android.internal.telephony.Phone):void");
    }

    @VisibleForTesting
    public IccSmsInterfaceManager(Phone phone, Context context, AppOpsManager appOpsManager, SmsDispatchersController smsDispatchersController, SmsPermissions smsPermissions) {
        this.mCellBroadcastRangeManager = new CellBroadcastRangeManager();
        this.mCdmaBroadcastRangeManager = new CdmaBroadcastRangeManager();
        this.mCellBroadcastLocalLog = new LocalLog(64);
        this.mHandler = new Handler() {
            public void handleMessage(Message message) {
                AsyncResult asyncResult = (AsyncResult) message.obj;
                Request request = (Request) asyncResult.userObj;
                Object obj = null;
                switch (message.what) {
                    case 1:
                        if (asyncResult.exception == null) {
                            obj = IccSmsInterfaceManager.this.buildValidRawData((ArrayList) asyncResult.result);
                            IccSmsInterfaceManager.this.markMessagesAsRead((ArrayList) asyncResult.result);
                        } else if (Rlog.isLoggable("SMS", 3)) {
                            IccSmsInterfaceManager.this.loge("Cannot load Sms records");
                        }
                        notifyPending(request, obj);
                        return;
                    case 2:
                    case 3:
                    case 4:
                    case 6:
                        notifyPending(request, Boolean.valueOf(asyncResult.exception == null));
                        return;
                    case 5:
                        if (asyncResult.exception == null) {
                            obj = (String) asyncResult.result;
                        } else {
                            IccSmsInterfaceManager.this.loge("Cannot read SMSC");
                        }
                        notifyPending(request, obj);
                        return;
                    default:
                        return;
                }
            }

            private void notifyPending(Request request, Object obj) {
                if (request != null) {
                    synchronized (request) {
                        request.mResult = obj;
                        request.mStatus.set(true);
                        request.notifyAll();
                    }
                }
            }
        };
        this.mPhone = phone;
        this.mContext = context;
        this.mAppOps = appOpsManager;
        this.mDispatchersController = smsDispatchersController;
        this.mSmsPermissions = smsPermissions;
    }

    private void enforceNotOnHandlerThread(String str) {
        if (Looper.myLooper() == this.mHandler.getLooper()) {
            throw new RuntimeException("This method " + str + " will deadlock if called from the handler's thread.");
        }
    }

    /* access modifiers changed from: protected */
    public void markMessagesAsRead(ArrayList<byte[]> arrayList) {
        if (arrayList != null) {
            IccFileHandler iccFileHandler = this.mPhone.getIccFileHandler();
            if (iccFileHandler != null) {
                int size = arrayList.size();
                for (int i = 0; i < size; i++) {
                    byte[] bArr = arrayList.get(i);
                    if ((bArr[0] & 7) == 3) {
                        int length = bArr.length - 1;
                        byte[] bArr2 = new byte[length];
                        System.arraycopy(bArr, 1, bArr2, 0, length);
                        int i2 = i + 1;
                        iccFileHandler.updateEFLinearFixed(IccConstants.EF_SMS, i2, makeSmsRecordData(1, bArr2), (String) null, (Message) null);
                        if (Rlog.isLoggable("SMS", 3)) {
                            log("SMS " + i2 + " marked as read");
                        }
                    }
                }
            } else if (Rlog.isLoggable("SMS", 3)) {
                loge("markMessagesAsRead - aborting, no icc card present.");
            }
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void enforceReceiveAndSend(String str) {
        this.mContext.enforceCallingOrSelfPermission("android.permission.RECEIVE_SMS", str);
        this.mContext.enforceCallingOrSelfPermission("android.permission.SEND_SMS", str);
    }

    private void enforceAccessMessageOnICC(String str) {
        this.mContext.enforceCallingOrSelfPermission("android.permission.ACCESS_MESSAGES_ON_ICC", str);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean updateMessageOnIccEf(String str, int i, int i2, byte[] bArr) {
        log("updateMessageOnIccEf: index=" + i + " status=" + i2 + " ==> (" + Arrays.toString(bArr) + ")");
        enforceReceiveAndSend("Updating message on Icc");
        enforceAccessMessageOnICC("Updating message on Icc");
        enforceNotOnHandlerThread("updateMessageOnIccEf");
        if (this.mAppOps.noteOp("android:write_icc_sms", Binder.getCallingUid(), str) != 0) {
            return false;
        }
        Request request = new Request();
        synchronized (request) {
            Message obtainMessage = this.mHandler.obtainMessage(2, request);
            if ((i2 & 1) != 0) {
                IccFileHandler iccFileHandler = this.mPhone.getIccFileHandler();
                if (iccFileHandler == null) {
                    obtainMessage.recycle();
                    return false;
                }
                iccFileHandler.updateEFLinearFixed(IccConstants.EF_SMS, i, makeSmsRecordData(i2, bArr), (String) null, obtainMessage);
            } else if (1 == this.mPhone.getPhoneType()) {
                this.mPhone.mCi.deleteSmsOnSim(i, obtainMessage);
            } else {
                this.mPhone.mCi.deleteSmsOnRuim(i, obtainMessage);
            }
            waitForResult(request);
            return ((Boolean) request.mResult).booleanValue();
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean copyMessageToIccEf(String str, int i, byte[] bArr, byte[] bArr2) {
        log("copyMessageToIccEf: status=" + i + " ==> pdu=(" + Arrays.toString(bArr) + "), smsc=(" + Arrays.toString(bArr2) + ")");
        enforceReceiveAndSend("Copying message to Icc");
        enforceNotOnHandlerThread("copyMessageToIccEf");
        if (this.mAppOps.noteOp("android:write_icc_sms", Binder.getCallingUid(), str) != 0) {
            return false;
        }
        Request request = new Request();
        synchronized (request) {
            Message obtainMessage = this.mHandler.obtainMessage(2, request);
            if (1 == this.mPhone.getPhoneType()) {
                this.mPhone.mCi.writeSmsToSim(i, IccUtils.bytesToHexString(bArr2), IccUtils.bytesToHexString(bArr), obtainMessage);
            } else {
                this.mPhone.mCi.writeSmsToRuim(i, bArr, obtainMessage);
            }
            waitForResult(request);
        }
        return ((Boolean) request.mResult).booleanValue();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public List<SmsRawData> getAllMessagesFromIccEf(String str) {
        log("getAllMessagesFromEF");
        this.mContext.enforceCallingOrSelfPermission("android.permission.RECEIVE_SMS", "Reading messages from Icc");
        enforceAccessMessageOnICC("Reading messages from Icc");
        enforceNotOnHandlerThread("getAllMessagesFromIccEf");
        if (this.mAppOps.noteOp("android:read_icc_sms", Binder.getCallingUid(), str) != 0) {
            return new ArrayList();
        }
        Request request = new Request();
        synchronized (request) {
            IccFileHandler iccFileHandler = this.mPhone.getIccFileHandler();
            if (iccFileHandler == null) {
                loge("Cannot load Sms records. No icc card?");
                return null;
            }
            iccFileHandler.loadEFLinearFixedAll(IccConstants.EF_SMS, this.mHandler.obtainMessage(1, request));
            waitForResult(request);
            return (List) request.mResult;
        }
    }

    public void sendDataWithSelfPermissions(String str, String str2, String str3, String str4, int i, byte[] bArr, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z) {
        String str5 = str;
        String str6 = str2;
        if (!this.mSmsPermissions.checkCallingOrSelfCanSendSms(str, str2, "Sending SMS message")) {
            returnUnspecifiedFailure(pendingIntent);
            return;
        }
        sendDataInternal(str, str3, str4, i, bArr, pendingIntent, pendingIntent2, z);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @Deprecated
    public void sendData(String str, String str2, String str3, int i, byte[] bArr, PendingIntent pendingIntent, PendingIntent pendingIntent2) {
        sendData(str, (String) null, str2, str3, i, bArr, pendingIntent, pendingIntent2);
    }

    public void sendData(String str, String str2, String str3, String str4, int i, byte[] bArr, PendingIntent pendingIntent, PendingIntent pendingIntent2) {
        String str5 = str;
        String str6 = str2;
        if (!this.mSmsPermissions.checkCallingCanSendSms(str, str2, "Sending SMS message")) {
            returnUnspecifiedFailure(pendingIntent);
            return;
        }
        sendDataInternal(str, str3, str4, i, bArr, pendingIntent, pendingIntent2, false);
    }

    /* access modifiers changed from: protected */
    public void sendDataInternal(String str, String str2, String str3, int i, byte[] bArr, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z) {
        String str4 = str2;
        if (Rlog.isLoggable("SMS", 2)) {
            log("sendData: destAddr=" + str2 + " scAddr=" + str3 + " destPort=" + i + " data='" + HexDump.toHexString(bArr) + "' sentIntent=" + pendingIntent + " deliveryIntent=" + pendingIntent2 + " isForVVM=" + z);
        } else {
            String str5 = str3;
            int i2 = i;
            PendingIntent pendingIntent3 = pendingIntent;
            PendingIntent pendingIntent4 = pendingIntent2;
            boolean z2 = z;
        }
        this.mDispatchersController.sendData(str, filterDestAddress(str2), str3, i, bArr, pendingIntent, pendingIntent2, z);
    }

    public void sendText(String str, String str2, String str3, String str4, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z, long j) {
        sendTextInternal(str, str2, str3, str4, pendingIntent, pendingIntent2, z, -1, false, -1, false, j);
    }

    public void sendTextWithSelfPermissions(String str, String str2, String str3, String str4, String str5, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z, boolean z2) {
        String str6 = str;
        if (!this.mSmsPermissions.checkCallingOrSelfCanSendSms(str, str2, "Sending SMS message")) {
            returnUnspecifiedFailure(pendingIntent);
            return;
        }
        sendTextInternal(str, str3, str4, str5, pendingIntent, pendingIntent2, z, -1, false, -1, z2, 0);
    }

    /* access modifiers changed from: protected */
    public void sendTextInternal(String str, String str2, String str3, String str4, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z, int i, boolean z2, int i2, boolean z3, long j) {
        String str5 = str2;
        if (Rlog.isLoggable("SMS", 2)) {
            log("sendText: destAddr=" + str5 + " scAddr=" + str3 + " text='" + str4 + "' sentIntent=" + pendingIntent + " deliveryIntent=" + pendingIntent2 + " priority=" + i + " expectMore=" + z2 + " validityPeriod=" + i2 + " isForVVM=" + z3 + " " + SmsController.formatCrossStackMessageId(j));
        } else {
            String str6 = str3;
            String str7 = str4;
            PendingIntent pendingIntent3 = pendingIntent;
            PendingIntent pendingIntent4 = pendingIntent2;
            int i3 = i;
            boolean z4 = z2;
            int i4 = i2;
            boolean z5 = z3;
        }
        notifyIfOutgoingEmergencySms(str5);
        this.mDispatchersController.sendText(filterDestAddress(str5), str3, str4, pendingIntent, pendingIntent2, (Uri) null, str, z, i, z2, i2, z3, j);
    }

    public void sendTextWithOptions(String str, String str2, String str3, String str4, String str5, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z, int i, boolean z2, int i2) {
        String str6 = str;
        if (!this.mSmsPermissions.checkCallingCanSendText(z, str, str2, "Sending SMS message")) {
            returnUnspecifiedFailure(pendingIntent);
            return;
        }
        sendTextInternal(str, str3, str4, str5, pendingIntent, pendingIntent2, z, i, z2, i2, false, 0);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void injectSmsPdu(byte[] bArr, String str, PendingIntent pendingIntent) {
        if (this.mContext.checkCallingOrSelfPermission("android.permission.MODIFY_PHONE_STATE") != 0) {
            this.mSmsPermissions.enforceCallerIsImsAppOrCarrierApp("injectSmsPdu");
        }
        if (Rlog.isLoggable("SMS", 2)) {
            log("pdu: " + bArr + "\n format=" + str + "\n receivedIntent=" + pendingIntent);
        }
        this.mDispatchersController.injectSmsPdu(bArr, str, false, new IccSmsInterfaceManager$$ExternalSyntheticLambda0(this, pendingIntent));
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$injectSmsPdu$0(PendingIntent pendingIntent, int i) {
        if (pendingIntent != null) {
            try {
                pendingIntent.send(i);
            } catch (PendingIntent.CanceledException unused) {
                loge("receivedIntent cancelled.");
            }
        }
    }

    public void sendMultipartText(String str, String str2, String str3, String str4, List<String> list, List<PendingIntent> list2, List<PendingIntent> list3, boolean z, long j) {
        sendMultipartTextWithOptions(str, str2, str3, str4, list, list2, list3, z, -1, false, -1, j);
    }

    public void sendMultipartTextWithOptions(String str, String str2, String str3, String str4, List<String> list, List<PendingIntent> list2, List<PendingIntent> list3, boolean z, int i, boolean z2, int i2, long j) {
        String str5;
        String str6 = str3;
        List<String> list4 = list;
        List<PendingIntent> list5 = list2;
        List<PendingIntent> list6 = list3;
        if (!this.mSmsPermissions.checkCallingCanSendText(z, str, str2, "Sending SMS message")) {
            returnUnspecifiedFailure(list5);
            return;
        }
        int i3 = 0;
        if (Rlog.isLoggable("SMS", 2)) {
            int i4 = 0;
            for (String str7 : list) {
                log("sendMultipartTextWithOptions: destAddr=" + str6 + ", srAddr=" + str4 + ", part[" + i4 + "]=" + str7 + " " + SmsController.formatCrossStackMessageId(j));
                i4++;
            }
        }
        String str8 = str4;
        notifyIfOutgoingEmergencySms(str6);
        String filterDestAddress = filterDestAddress(str6);
        if (list.size() <= 1 || list.size() >= 10 || SmsMessage.hasEmsSupport()) {
            this.mDispatchersController.sendMultipartText(filterDestAddress, str4, (ArrayList) list4, (ArrayList) list5, (ArrayList) list6, (Uri) null, str, z, i, z2, i2, j);
            return;
        }
        while (i3 < list.size()) {
            String str9 = list4.get(i3);
            if (SmsMessage.shouldAppendPageNumberAsPrefix()) {
                str5 = String.valueOf(i3 + 1) + '/' + list.size() + ' ' + str9;
            } else {
                str5 = str9.concat(' ' + String.valueOf(i3 + 1) + '/' + list.size());
            }
            String str10 = str5;
            PendingIntent pendingIntent = null;
            PendingIntent pendingIntent2 = (list5 == null || list2.size() <= i3) ? null : list5.get(i3);
            if (list6 != null && list3.size() > i3) {
                pendingIntent = list6.get(i3);
            }
            this.mDispatchersController.sendText(filterDestAddress, str4, str10, pendingIntent2, pendingIntent, (Uri) null, str, z, i, z2, i2, false, j);
            i3++;
            String str11 = str;
            String str12 = str4;
            boolean z3 = z;
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getPremiumSmsPermission(String str) {
        return this.mDispatchersController.getPremiumSmsPermission(str);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void setPremiumSmsPermission(String str, int i) {
        this.mDispatchersController.setPremiumSmsPermission(str, i);
    }

    /* access modifiers changed from: protected */
    public ArrayList<SmsRawData> buildValidRawData(ArrayList<byte[]> arrayList) {
        int size = arrayList.size();
        ArrayList<SmsRawData> arrayList2 = new ArrayList<>(size);
        for (int i = 0; i < size; i++) {
            if ((arrayList.get(i)[0] & 1) == 0) {
                arrayList2.add((Object) null);
            } else {
                arrayList2.add(new SmsRawData(arrayList.get(i)));
            }
        }
        return arrayList2;
    }

    /* access modifiers changed from: protected */
    public byte[] makeSmsRecordData(int i, byte[] bArr) {
        byte[] bArr2 = 1 == this.mPhone.getPhoneType() ? new byte[176] : new byte[255];
        bArr2[0] = (byte) (i & 7);
        System.arraycopy(bArr, 0, bArr2, 1, bArr.length);
        for (int length = bArr.length + 1; length < bArr2.length; length++) {
            bArr2[length] = -1;
        }
        return bArr2;
    }

    public String getSmscAddressFromIccEf(String str) {
        if (!this.mSmsPermissions.checkCallingOrSelfCanGetSmscAddress(str, "getSmscAddressFromIccEf")) {
            return null;
        }
        enforceNotOnHandlerThread("getSmscAddressFromIccEf");
        Request request = new Request();
        synchronized (request) {
            this.mPhone.mCi.getSmscAddress(this.mHandler.obtainMessage(5, request));
            waitForResult(request);
        }
        return (String) request.mResult;
    }

    public boolean setSmscAddressOnIccEf(String str, String str2) {
        if (!this.mSmsPermissions.checkCallingOrSelfCanSetSmscAddress(str, "setSmscAddressOnIccEf")) {
            return false;
        }
        enforceNotOnHandlerThread("setSmscAddressOnIccEf");
        Request request = new Request();
        synchronized (request) {
            this.mPhone.mCi.setSmscAddress(str2, this.mHandler.obtainMessage(6, request));
            waitForResult(request);
        }
        return ((Boolean) request.mResult).booleanValue();
    }

    public boolean enableCellBroadcast(int i, int i2) {
        return enableCellBroadcastRange(i, i, i2);
    }

    public boolean disableCellBroadcast(int i, int i2) {
        return disableCellBroadcastRange(i, i, i2);
    }

    public boolean enableCellBroadcastRange(int i, int i2, int i3) {
        Context context = this.mContext;
        context.enforceCallingPermission("android.permission.RECEIVE_EMERGENCY_BROADCAST", "enabling cell broadcast range [" + i + "-" + i2 + "]. ranType=" + i3);
        if (i3 == 1) {
            return enableGsmBroadcastRange(i, i2);
        }
        if (i3 == 2) {
            return enableCdmaBroadcastRange(i, i2);
        }
        throw new IllegalArgumentException("Not a supported RAN Type");
    }

    public boolean disableCellBroadcastRange(int i, int i2, int i3) {
        Context context = this.mContext;
        context.enforceCallingPermission("android.permission.RECEIVE_EMERGENCY_BROADCAST", "disabling cell broadcast range [" + i + "-" + i2 + "]. ranType=" + i3);
        if (i3 == 1) {
            return disableGsmBroadcastRange(i, i2);
        }
        if (i3 == 2) {
            return disableCdmaBroadcastRange(i, i2);
        }
        throw new IllegalArgumentException("Not a supported RAN Type");
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public synchronized boolean enableGsmBroadcastRange(int i, int i2) {
        this.mContext.enforceCallingPermission("android.permission.RECEIVE_EMERGENCY_BROADCAST", "Enabling cell broadcast SMS");
        boolean z = false;
        if (!this.mCellBroadcastRangeManager.enableRange(i, i2, this.mContext.getPackageManager().getNameForUid(Binder.getCallingUid()))) {
            String str = "Failed to add GSM cell broadcast channels range " + i + " to " + i2;
            log(str);
            this.mCellBroadcastLocalLog.log(str);
            return false;
        }
        String str2 = "Added GSM cell broadcast channels range " + i + " to " + i2;
        log(str2);
        this.mCellBroadcastLocalLog.log(str2);
        if (!this.mCellBroadcastRangeManager.isEmpty()) {
            z = true;
        }
        setCellBroadcastActivation(z);
        return true;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public synchronized boolean disableGsmBroadcastRange(int i, int i2) {
        this.mContext.enforceCallingPermission("android.permission.RECEIVE_EMERGENCY_BROADCAST", "Disabling cell broadcast SMS");
        boolean z = false;
        if (!this.mCellBroadcastRangeManager.disableRange(i, i2, this.mContext.getPackageManager().getNameForUid(Binder.getCallingUid()))) {
            String str = "Failed to remove GSM cell broadcast channels range " + i + " to " + i2;
            log(str);
            this.mCellBroadcastLocalLog.log(str);
            return false;
        }
        String str2 = "Removed GSM cell broadcast channels range " + i + " to " + i2;
        log(str2);
        this.mCellBroadcastLocalLog.log(str2);
        if (!this.mCellBroadcastRangeManager.isEmpty()) {
            z = true;
        }
        setCellBroadcastActivation(z);
        return true;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public synchronized boolean enableCdmaBroadcastRange(int i, int i2) {
        this.mContext.enforceCallingPermission("android.permission.RECEIVE_EMERGENCY_BROADCAST", "Enabling cdma broadcast SMS");
        boolean z = false;
        if (!this.mCdmaBroadcastRangeManager.enableRange(i, i2, this.mContext.getPackageManager().getNameForUid(Binder.getCallingUid()))) {
            String str = "Failed to add cdma broadcast channels range " + i + " to " + i2;
            log(str);
            this.mCellBroadcastLocalLog.log(str);
            return false;
        }
        String str2 = "Added cdma broadcast channels range " + i + " to " + i2;
        log(str2);
        this.mCellBroadcastLocalLog.log(str2);
        if (!this.mCdmaBroadcastRangeManager.isEmpty()) {
            z = true;
        }
        setCdmaBroadcastActivation(z);
        return true;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public synchronized boolean disableCdmaBroadcastRange(int i, int i2) {
        this.mContext.enforceCallingPermission("android.permission.RECEIVE_EMERGENCY_BROADCAST", "Disabling cell broadcast SMS");
        boolean z = false;
        if (!this.mCdmaBroadcastRangeManager.disableRange(i, i2, this.mContext.getPackageManager().getNameForUid(Binder.getCallingUid()))) {
            String str = "Failed to remove cdma broadcast channels range " + i + " to " + i2;
            log(str);
            this.mCellBroadcastLocalLog.log(str);
            return false;
        }
        String str2 = "Removed cdma broadcast channels range " + i + " to " + i2;
        log(str2);
        this.mCellBroadcastLocalLog.log(str2);
        if (!this.mCdmaBroadcastRangeManager.isEmpty()) {
            z = true;
        }
        setCdmaBroadcastActivation(z);
        return true;
    }

    @RequiresPermission("android.permission.MODIFY_CELL_BROADCASTS")
    public void resetAllCellBroadcastRanges() {
        this.mContext.enforceCallingPermission("android.permission.MODIFY_CELL_BROADCASTS", "resetAllCellBroadcastRanges");
        this.mCdmaBroadcastRangeManager.clearRanges();
        this.mCellBroadcastRangeManager.clearRanges();
        log("Cell broadcast ranges reset.");
    }

    class CellBroadcastRangeManager extends IntRangeManager {
        private ArrayList<SmsBroadcastConfigInfo> mConfigList = new ArrayList<>();

        CellBroadcastRangeManager() {
        }

        /* access modifiers changed from: protected */
        public void startUpdate() {
            this.mConfigList.clear();
        }

        /* access modifiers changed from: protected */
        public void addRange(int i, int i2, boolean z) {
            this.mConfigList.add(new SmsBroadcastConfigInfo(i, i2, 0, 255, z));
        }

        /* access modifiers changed from: protected */
        public boolean finishUpdate() {
            if (this.mConfigList.isEmpty()) {
                return true;
            }
            ArrayList<SmsBroadcastConfigInfo> arrayList = this.mConfigList;
            return IccSmsInterfaceManager.this.setCellBroadcastConfig((SmsBroadcastConfigInfo[]) arrayList.toArray(new SmsBroadcastConfigInfo[arrayList.size()]));
        }
    }

    class CdmaBroadcastRangeManager extends IntRangeManager {
        private ArrayList<CdmaSmsBroadcastConfigInfo> mConfigList = new ArrayList<>();

        CdmaBroadcastRangeManager() {
        }

        /* access modifiers changed from: protected */
        public void startUpdate() {
            this.mConfigList.clear();
        }

        /* access modifiers changed from: protected */
        public void addRange(int i, int i2, boolean z) {
            this.mConfigList.add(new CdmaSmsBroadcastConfigInfo(i, i2, 1, z));
        }

        /* access modifiers changed from: protected */
        public boolean finishUpdate() {
            if (this.mConfigList.isEmpty()) {
                return true;
            }
            ArrayList<CdmaSmsBroadcastConfigInfo> arrayList = this.mConfigList;
            return IccSmsInterfaceManager.this.setCdmaBroadcastConfig((CdmaSmsBroadcastConfigInfo[]) arrayList.toArray(new CdmaSmsBroadcastConfigInfo[arrayList.size()]));
        }
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean setCellBroadcastConfig(SmsBroadcastConfigInfo[] smsBroadcastConfigInfoArr) {
        log("Calling setGsmBroadcastConfig with " + smsBroadcastConfigInfoArr.length + " configurations");
        enforceNotOnHandlerThread("setCellBroadcastConfig");
        Request request = new Request();
        synchronized (request) {
            this.mPhone.mCi.setGsmBroadcastConfig(smsBroadcastConfigInfoArr, this.mHandler.obtainMessage(4, request));
            waitForResult(request);
        }
        return ((Boolean) request.mResult).booleanValue();
    }

    /* access modifiers changed from: protected */
    public boolean setCellBroadcastActivation(boolean z) {
        log("Calling setCellBroadcastActivation(" + z + ')');
        enforceNotOnHandlerThread("setCellBroadcastConfig");
        Request request = new Request();
        synchronized (request) {
            this.mPhone.mCi.setGsmBroadcastActivation(z, this.mHandler.obtainMessage(3, request));
            waitForResult(request);
        }
        return ((Boolean) request.mResult).booleanValue();
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean setCdmaBroadcastConfig(CdmaSmsBroadcastConfigInfo[] cdmaSmsBroadcastConfigInfoArr) {
        log("Calling setCdmaBroadcastConfig with " + cdmaSmsBroadcastConfigInfoArr.length + " configurations");
        enforceNotOnHandlerThread("setCdmaBroadcastConfig");
        Request request = new Request();
        synchronized (request) {
            this.mPhone.mCi.setCdmaBroadcastConfig(cdmaSmsBroadcastConfigInfoArr, this.mHandler.obtainMessage(4, request));
            waitForResult(request);
        }
        return ((Boolean) request.mResult).booleanValue();
    }

    private boolean setCdmaBroadcastActivation(boolean z) {
        log("Calling setCdmaBroadcastActivation(" + z + ")");
        enforceNotOnHandlerThread("setCdmaBroadcastActivation");
        Request request = new Request();
        synchronized (request) {
            this.mPhone.mCi.setCdmaBroadcastActivation(z, this.mHandler.obtainMessage(3, request));
            waitForResult(request);
        }
        return ((Boolean) request.mResult).booleanValue();
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage
    public void log(String str) {
        Rlog.d(LOG_TAG, str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str) {
        Rlog.e(LOG_TAG, str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str, Throwable th) {
        Rlog.e(LOG_TAG, str, th);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isImsSmsSupported() {
        return this.mDispatchersController.isIms();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getImsSmsFormat() {
        return this.mDispatchersController.getImsSmsFormat();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @Deprecated
    public void sendStoredText(String str, Uri uri, String str2, PendingIntent pendingIntent, PendingIntent pendingIntent2) {
        sendStoredText(str, (String) null, uri, str2, pendingIntent, pendingIntent2);
    }

    public void sendStoredText(String str, String str2, Uri uri, String str3, PendingIntent pendingIntent, PendingIntent pendingIntent2) {
        Uri uri2 = uri;
        PendingIntent pendingIntent3 = pendingIntent;
        if (!this.mSmsPermissions.checkCallingCanSendSms(str, str2, "Sending SMS message")) {
            returnUnspecifiedFailure(pendingIntent3);
            return;
        }
        if (Rlog.isLoggable("SMS", 2)) {
            log("sendStoredText: scAddr=" + str3 + " messageUri=" + uri2 + " sentIntent=" + pendingIntent3 + " deliveryIntent=" + pendingIntent2);
        } else {
            String str4 = str3;
            PendingIntent pendingIntent4 = pendingIntent2;
        }
        ContentResolver contentResolver = this.mContext.getContentResolver();
        if (!isFailedOrDraft(contentResolver, uri2)) {
            loge("sendStoredText: not FAILED or DRAFT message");
            returnUnspecifiedFailure(pendingIntent3);
            return;
        }
        String[] loadTextAndAddress = loadTextAndAddress(contentResolver, uri2);
        if (loadTextAndAddress == null) {
            loge("sendStoredText: can not load text");
            returnUnspecifiedFailure(pendingIntent3);
            return;
        }
        notifyIfOutgoingEmergencySms(loadTextAndAddress[1]);
        String filterDestAddress = filterDestAddress(loadTextAndAddress[1]);
        loadTextAndAddress[1] = filterDestAddress;
        this.mDispatchersController.sendText(filterDestAddress, str3, loadTextAndAddress[0], pendingIntent, pendingIntent2, uri, str, true, -1, false, -1, false, 0);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    @Deprecated
    public void sendStoredMultipartText(String str, Uri uri, String str2, List<PendingIntent> list, List<PendingIntent> list2) {
        sendStoredMultipartText(str, (String) null, uri, str2, list, list2);
    }

    public void sendStoredMultipartText(String str, String str2, Uri uri, String str3, List<PendingIntent> list, List<PendingIntent> list2) {
        String str4;
        Uri uri2 = uri;
        List<PendingIntent> list3 = list;
        List<PendingIntent> list4 = list2;
        if (!this.mSmsPermissions.checkCallingCanSendSms(str, str2, "Sending SMS message")) {
            returnUnspecifiedFailure(list3);
            return;
        }
        ContentResolver contentResolver = this.mContext.getContentResolver();
        if (!isFailedOrDraft(contentResolver, uri2)) {
            loge("sendStoredMultipartText: not FAILED or DRAFT message");
            returnUnspecifiedFailure(list3);
            return;
        }
        String[] loadTextAndAddress = loadTextAndAddress(contentResolver, uri2);
        if (loadTextAndAddress == null) {
            loge("sendStoredMultipartText: can not load text");
            returnUnspecifiedFailure(list3);
            return;
        }
        ArrayList<String> divideMessage = SmsManager.getDefault().divideMessage(loadTextAndAddress[0]);
        if (divideMessage != null) {
            char c = 1;
            if (divideMessage.size() >= 1) {
                notifyIfOutgoingEmergencySms(loadTextAndAddress[1]);
                loadTextAndAddress[1] = filterDestAddress(loadTextAndAddress[1]);
                if (divideMessage.size() <= 1 || divideMessage.size() >= 10 || SmsMessage.hasEmsSupport()) {
                    this.mDispatchersController.sendMultipartText(loadTextAndAddress[1], str3, divideMessage, (ArrayList) list, (ArrayList) list2, uri, str, true, -1, false, -1, 0);
                    return;
                }
                int i = 0;
                while (i < divideMessage.size()) {
                    String str5 = divideMessage.get(i);
                    if (SmsMessage.shouldAppendPageNumberAsPrefix()) {
                        str4 = String.valueOf(i + 1) + '/' + divideMessage.size() + ' ' + str5;
                    } else {
                        str4 = str5.concat(' ' + String.valueOf(i + 1) + '/' + divideMessage.size());
                    }
                    String str6 = str4;
                    PendingIntent pendingIntent = null;
                    PendingIntent pendingIntent2 = (list3 == null || list.size() <= i) ? null : list3.get(i);
                    if (list4 != null && list2.size() > i) {
                        pendingIntent = list4.get(i);
                    }
                    this.mDispatchersController.sendText(loadTextAndAddress[c], str3, str6, pendingIntent2, pendingIntent, uri, str, true, -1, false, -1, false, 0);
                    i++;
                    String str7 = str;
                    Uri uri3 = uri;
                    list3 = list;
                    list4 = list2;
                    c = c;
                    divideMessage = divideMessage;
                }
                return;
            }
        }
        loge("sendStoredMultipartText: can not divide text");
        returnUnspecifiedFailure(list3);
    }

    public int getSmsCapacityOnIcc(String str, String str2) {
        boolean checkCallingOrSelfReadPhoneState = TelephonyPermissions.checkCallingOrSelfReadPhoneState(this.mContext, this.mPhone.getSubId(), str, str2, "getSmsCapacityOnIcc");
        int i = 0;
        if (!checkCallingOrSelfReadPhoneState) {
            return 0;
        }
        if (this.mPhone.getIccRecordsLoaded()) {
            UiccProfile uiccProfileForPhone = UiccController.getInstance().getUiccProfileForPhone(this.mPhone.getPhoneId());
            if (uiccProfileForPhone != null) {
                i = uiccProfileForPhone.getIccRecords().getSmsCapacityOnIcc();
            } else {
                loge("uiccProfile is null");
            }
        } else {
            loge("getSmsCapacityOnIcc - aborting, no icc card present.");
        }
        log("getSmsCapacityOnIcc().numberOnIcc = " + i);
        return i;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:14:0x0030, code lost:
        if (r3 != null) goto L_0x003d;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:20:0x003b, code lost:
        if (r3 == null) goto L_0x0040;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:21:0x003d, code lost:
        r3.close();
     */
    /* JADX WARNING: Code restructure failed: missing block: B:22:0x0040, code lost:
        android.os.Binder.restoreCallingIdentity(r0);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:23:0x0043, code lost:
        return false;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private boolean isFailedOrDraft(android.content.ContentResolver r12, android.net.Uri r13) {
        /*
            r11 = this;
            long r0 = android.os.Binder.clearCallingIdentity()
            r2 = 0
            r3 = 0
            java.lang.String r4 = "type"
            java.lang.String[] r7 = new java.lang.String[]{r4}     // Catch:{ SQLiteException -> 0x0035 }
            r8 = 0
            r9 = 0
            r10 = 0
            r5 = r12
            r6 = r13
            android.database.Cursor r3 = r5.query(r6, r7, r8, r9, r10)     // Catch:{ SQLiteException -> 0x0035 }
            if (r3 == 0) goto L_0x0030
            boolean r12 = r3.moveToFirst()     // Catch:{ SQLiteException -> 0x0035 }
            if (r12 == 0) goto L_0x0030
            int r11 = r3.getInt(r2)     // Catch:{ SQLiteException -> 0x0035 }
            r12 = 3
            if (r11 == r12) goto L_0x0028
            r12 = 5
            if (r11 != r12) goto L_0x0029
        L_0x0028:
            r2 = 1
        L_0x0029:
            r3.close()
            android.os.Binder.restoreCallingIdentity(r0)
            return r2
        L_0x0030:
            if (r3 == 0) goto L_0x0040
            goto L_0x003d
        L_0x0033:
            r11 = move-exception
            goto L_0x0044
        L_0x0035:
            r12 = move-exception
            java.lang.String r13 = "isFailedOrDraft: query message type failed"
            r11.loge(r13, r12)     // Catch:{ all -> 0x0033 }
            if (r3 == 0) goto L_0x0040
        L_0x003d:
            r3.close()
        L_0x0040:
            android.os.Binder.restoreCallingIdentity(r0)
            return r2
        L_0x0044:
            if (r3 == 0) goto L_0x0049
            r3.close()
        L_0x0049:
            android.os.Binder.restoreCallingIdentity(r0)
            throw r11
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.IccSmsInterfaceManager.isFailedOrDraft(android.content.ContentResolver, android.net.Uri):boolean");
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x0038, code lost:
        if (r12 != null) goto L_0x0046;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:18:0x0044, code lost:
        if (r12 != null) goto L_0x0046;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:19:0x0046, code lost:
        r12.close();
     */
    /* JADX WARNING: Code restructure failed: missing block: B:20:0x0049, code lost:
        android.os.Binder.restoreCallingIdentity(r0);
     */
    /* JADX WARNING: Code restructure failed: missing block: B:21:0x004c, code lost:
        return null;
     */
    /* JADX WARNING: Removed duplicated region for block: B:25:0x0051  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private java.lang.String[] loadTextAndAddress(android.content.ContentResolver r12, android.net.Uri r13) {
        /*
            r11 = this;
            long r0 = android.os.Binder.clearCallingIdentity()
            r2 = 0
            java.lang.String r3 = "body"
            java.lang.String r4 = "address"
            java.lang.String[] r7 = new java.lang.String[]{r3, r4}     // Catch:{ SQLiteException -> 0x003d, all -> 0x003b }
            r8 = 0
            r9 = 0
            r10 = 0
            r5 = r12
            r6 = r13
            android.database.Cursor r12 = r5.query(r6, r7, r8, r9, r10)     // Catch:{ SQLiteException -> 0x003d, all -> 0x003b }
            if (r12 == 0) goto L_0x0038
            boolean r13 = r12.moveToFirst()     // Catch:{ SQLiteException -> 0x0036 }
            if (r13 == 0) goto L_0x0038
            r13 = 2
            java.lang.String[] r13 = new java.lang.String[r13]     // Catch:{ SQLiteException -> 0x0036 }
            r3 = 0
            java.lang.String r4 = r12.getString(r3)     // Catch:{ SQLiteException -> 0x0036 }
            r13[r3] = r4     // Catch:{ SQLiteException -> 0x0036 }
            r3 = 1
            java.lang.String r4 = r12.getString(r3)     // Catch:{ SQLiteException -> 0x0036 }
            r13[r3] = r4     // Catch:{ SQLiteException -> 0x0036 }
            r12.close()
            android.os.Binder.restoreCallingIdentity(r0)
            return r13
        L_0x0036:
            r13 = move-exception
            goto L_0x003f
        L_0x0038:
            if (r12 == 0) goto L_0x0049
            goto L_0x0046
        L_0x003b:
            r11 = move-exception
            goto L_0x004f
        L_0x003d:
            r13 = move-exception
            r12 = r2
        L_0x003f:
            java.lang.String r3 = "loadText: query message text failed"
            r11.loge(r3, r13)     // Catch:{ all -> 0x004d }
            if (r12 == 0) goto L_0x0049
        L_0x0046:
            r12.close()
        L_0x0049:
            android.os.Binder.restoreCallingIdentity(r0)
            return r2
        L_0x004d:
            r11 = move-exception
            r2 = r12
        L_0x004f:
            if (r2 == 0) goto L_0x0054
            r2.close()
        L_0x0054:
            android.os.Binder.restoreCallingIdentity(r0)
            throw r11
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.IccSmsInterfaceManager.loadTextAndAddress(android.content.ContentResolver, android.net.Uri):java.lang.String[]");
    }

    private void notifyIfOutgoingEmergencySms(String str) {
        EmergencyNumber emergencyNumber = this.mPhone.getEmergencyNumberTracker().getEmergencyNumber(str);
        if (emergencyNumber != null) {
            this.mPhone.notifyOutgoingEmergencySms(emergencyNumber);
        }
    }

    private void returnUnspecifiedFailure(PendingIntent pendingIntent) {
        if (pendingIntent != null) {
            try {
                pendingIntent.send(1);
            } catch (PendingIntent.CanceledException unused) {
            }
        }
    }

    private void returnUnspecifiedFailure(List<PendingIntent> list) {
        if (list != null) {
            for (PendingIntent returnUnspecifiedFailure : list) {
                returnUnspecifiedFailure(returnUnspecifiedFailure);
            }
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private String filterDestAddress(String str) {
        String filterDestAddr = SmsNumberUtils.filterDestAddr(this.mContext, this.mPhone.getSubId(), str);
        return filterDestAddr != null ? filterDestAddr : str;
    }

    /* access modifiers changed from: protected */
    public void waitForResult(Request request) {
        synchronized (request) {
            while (!request.mStatus.get()) {
                try {
                    request.wait();
                } catch (InterruptedException unused) {
                    log("Interrupted while waiting for result");
                }
            }
        }
    }

    public InboundSmsHandler getInboundSmsHandler(boolean z) {
        return this.mDispatchersController.getInboundSmsHandler(z);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("Enabled GSM channels: " + this.mCellBroadcastRangeManager);
        printWriter.println("Enabled CDMA channels: " + this.mCdmaBroadcastRangeManager);
        printWriter.println("CellBroadcast log:");
        this.mCellBroadcastLocalLog.dump(fileDescriptor, printWriter, strArr);
        printWriter.println("SMS dispatcher controller log:");
        this.mDispatchersController.dump(fileDescriptor, printWriter, strArr);
        printWriter.flush();
    }
}
