package com.android.internal.telephony;

import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.os.UserManager;
import android.telephony.ServiceState;
import android.telephony.SmsMessage;
import androidx.core.os.EnvironmentCompat;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.SMSDispatcher;
import com.android.internal.telephony.cdma.CdmaInboundSmsHandler;
import com.android.internal.telephony.cdma.CdmaSMSDispatcher;
import com.android.internal.telephony.cdma.SmsMessage;
import com.android.internal.telephony.gsm.GsmInboundSmsHandler;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;

public class SmsDispatchersController extends Handler {
    private static final int EVENT_IMS_STATE_CHANGED = 12;
    private static final int EVENT_IMS_STATE_DONE = 13;
    private static final int EVENT_PARTIAL_SEGMENT_TIMER_EXPIRY = 15;
    private static final int EVENT_RADIO_ON = 11;
    private static final int EVENT_SERVICE_STATE_CHANGED = 14;
    protected static final int EVENT_SMS_HANDLER_EXITING_WAITING_STATE = 17;
    private static final int EVENT_USER_UNLOCKED = 16;
    private static final long INVALID_TIME = -1;
    private static final long PARTIAL_SEGMENT_WAIT_DURATION = 86400000;
    private static final String TAG = "SmsDispatchersController";
    private static final boolean VDBG = false;
    private final BroadcastReceiver mBroadcastReceiver;
    protected SMSDispatcher mCdmaDispatcher;
    protected CdmaInboundSmsHandler mCdmaInboundSmsHandler;
    protected final CommandsInterface mCi;
    protected final Context mContext;
    private long mCurrentWaitElapsedDuration = 0;
    private long mCurrentWaitStartTime = -1;
    private HashMap<Integer, SMSDispatcher.SmsTracker> mDeliveryPendingMapFor3GPP = new HashMap<>();
    private HashMap<Integer, SMSDispatcher.SmsTracker> mDeliveryPendingMapFor3GPP2 = new HashMap<>();
    protected SMSDispatcher mGsmDispatcher;
    protected GsmInboundSmsHandler mGsmInboundSmsHandler;
    private boolean mIms = false;
    protected ImsSmsDispatcher mImsSmsDispatcher;
    private String mImsSmsFormat = EnvironmentCompat.MEDIA_UNKNOWN;
    private long mLastInServiceTime = -1;
    protected Phone mPhone;
    private final SmsUsageMonitor mUsageMonitor;

    public interface SmsInjectionCallback {
        void onSmsInjectedResult(int i);
    }

    public void putDeliveryPendingTracker(SMSDispatcher.SmsTracker smsTracker) {
        if (isCdmaFormat(smsTracker.mFormat)) {
            this.mDeliveryPendingMapFor3GPP2.put(Integer.valueOf(smsTracker.mMessageRef), smsTracker);
        } else {
            this.mDeliveryPendingMapFor3GPP.put(Integer.valueOf(smsTracker.mMessageRef), smsTracker);
        }
    }

    public SmsDispatchersController(Phone phone, SmsStorageMonitor smsStorageMonitor, SmsUsageMonitor smsUsageMonitor) {
        AnonymousClass1 r0 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                Rlog.d(SmsDispatchersController.TAG, "Received broadcast " + intent.getAction());
                if ("android.intent.action.USER_UNLOCKED".equals(intent.getAction())) {
                    SmsDispatchersController smsDispatchersController = SmsDispatchersController.this;
                    smsDispatchersController.sendMessage(smsDispatchersController.obtainMessage(16));
                }
            }
        };
        this.mBroadcastReceiver = r0;
        Rlog.d(TAG, "SmsDispatchersController created");
        Context context = phone.getContext();
        this.mContext = context;
        this.mUsageMonitor = smsUsageMonitor;
        CommandsInterface commandsInterface = phone.mCi;
        this.mCi = commandsInterface;
        this.mPhone = phone;
        TelephonyComponentFactory inject = TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName());
        this.mImsSmsDispatcher = inject.makeImsSmsDispatcher(phone, this);
        this.mCdmaDispatcher = inject.makeCdmaSMSDispatcher(phone, this);
        this.mGsmInboundSmsHandler = TelephonyComponentFactory.getInstance().inject(GsmInboundSmsHandler.class.getName()).makeGsmInboundSmsHandler(phone.getContext(), smsStorageMonitor, phone);
        this.mCdmaInboundSmsHandler = CdmaInboundSmsHandler.makeInboundSmsHandler(phone.getContext(), smsStorageMonitor, phone, (CdmaSMSDispatcher) this.mCdmaDispatcher);
        this.mGsmDispatcher = inject.makeGsmSMSDispatcher(phone, this, this.mGsmInboundSmsHandler);
        inject.makeSmsBroadcastUndelivered(phone.getContext(), this.mGsmInboundSmsHandler, this.mCdmaInboundSmsHandler);
        InboundSmsHandler.registerNewMessageNotificationActionHandler(phone.getContext());
        commandsInterface.registerForOn(this, 11, (Object) null);
        commandsInterface.registerForImsNetworkStateChanged(this, 12, (Object) null);
        if (((UserManager) context.getSystemService("user")).isUserUnlocked()) {
            this.mPhone.registerForServiceStateChanged(this, 14, (Object) null);
            resetPartialSegmentWaitTimer();
            return;
        }
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.intent.action.USER_UNLOCKED");
        context.registerReceiver(r0, intentFilter);
    }

    public void dispose() {
        this.mCi.unregisterForOn(this);
        this.mCi.unregisterForImsNetworkStateChanged(this);
        this.mPhone.unregisterForServiceStateChanged(this);
        this.mGsmDispatcher.dispose();
        this.mCdmaDispatcher.dispose();
        this.mGsmInboundSmsHandler.dispose();
        this.mCdmaInboundSmsHandler.dispose();
    }

    public void handleMessage(Message message) {
        switch (message.what) {
            case 11:
            case 12:
                this.mCi.getImsRegistrationState(obtainMessage(13));
                return;
            case 13:
                AsyncResult asyncResult = (AsyncResult) message.obj;
                if (asyncResult.exception == null) {
                    updateImsInfo(asyncResult);
                    return;
                }
                Rlog.e(TAG, "IMS State query failed with exp " + asyncResult.exception);
                return;
            case 14:
            case 17:
                reevaluateTimerStatus();
                return;
            case 15:
                handlePartialSegmentTimerExpiry(((Long) message.obj).longValue());
                return;
            case 16:
                this.mPhone.registerForServiceStateChanged(this, 14, (Object) null);
                resetPartialSegmentWaitTimer();
                return;
            default:
                if (isCdmaMo()) {
                    this.mCdmaDispatcher.handleMessage(message);
                    return;
                } else {
                    this.mGsmDispatcher.handleMessage(message);
                    return;
                }
        }
    }

    private void reevaluateTimerStatus() {
        long currentTimeMillis = System.currentTimeMillis();
        removeMessages(15);
        long j = this.mLastInServiceTime;
        if (j != -1) {
            this.mCurrentWaitElapsedDuration += currentTimeMillis - j;
        }
        if (this.mCurrentWaitElapsedDuration > PARTIAL_SEGMENT_WAIT_DURATION) {
            handlePartialSegmentTimerExpiry(this.mCurrentWaitStartTime);
        } else if (isInService()) {
            handleInService(currentTimeMillis);
        } else {
            handleOutOfService(currentTimeMillis);
        }
    }

    private void handleInService(long j) {
        if (this.mCurrentWaitStartTime == -1) {
            this.mCurrentWaitStartTime = j;
        }
        sendMessageDelayed(obtainMessage(15, Long.valueOf(this.mCurrentWaitStartTime)), PARTIAL_SEGMENT_WAIT_DURATION - this.mCurrentWaitElapsedDuration);
        this.mLastInServiceTime = j;
    }

    private void handleOutOfService(long j) {
        this.mLastInServiceTime = -1;
    }

    private void handlePartialSegmentTimerExpiry(long j) {
        if (this.mGsmInboundSmsHandler.getCurrentState().getName().equals("WaitingState") || this.mCdmaInboundSmsHandler.getCurrentState().getName().equals("WaitingState")) {
            logd("handlePartialSegmentTimerExpiry: ignoring timer expiry as InboundSmsHandler is in WaitingState");
            return;
        }
        SmsBroadcastUndelivered.scanRawTable(this.mContext, j);
        resetPartialSegmentWaitTimer();
    }

    private void resetPartialSegmentWaitTimer() {
        long currentTimeMillis = System.currentTimeMillis();
        removeMessages(15);
        if (isInService()) {
            this.mCurrentWaitStartTime = currentTimeMillis;
            this.mLastInServiceTime = currentTimeMillis;
            sendMessageDelayed(obtainMessage(15, Long.valueOf(currentTimeMillis)), PARTIAL_SEGMENT_WAIT_DURATION);
        } else {
            this.mCurrentWaitStartTime = -1;
            this.mLastInServiceTime = -1;
        }
        this.mCurrentWaitElapsedDuration = 0;
    }

    private boolean isInService() {
        ServiceState serviceState = this.mPhone.getServiceState();
        return serviceState != null && serviceState.getState() == 0;
    }

    private void setImsSmsFormat(int i) {
        if (i == 1) {
            this.mImsSmsFormat = "3gpp";
        } else if (i != 2) {
            this.mImsSmsFormat = EnvironmentCompat.MEDIA_UNKNOWN;
        } else {
            this.mImsSmsFormat = "3gpp2";
        }
    }

    private void updateImsInfo(AsyncResult asyncResult) {
        int[] iArr = (int[]) asyncResult.result;
        boolean z = true;
        setImsSmsFormat(iArr[1]);
        if (iArr[0] != 1 || EnvironmentCompat.MEDIA_UNKNOWN.equals(this.mImsSmsFormat)) {
            z = false;
        }
        this.mIms = z;
        Rlog.d(TAG, "IMS registration state: " + this.mIms + " format: " + this.mImsSmsFormat);
    }

    @VisibleForTesting
    public void injectSmsPdu(byte[] bArr, String str, boolean z, SmsInjectionCallback smsInjectionCallback) {
        injectSmsPdu(SmsMessage.createFromPdu(bArr, str), str, smsInjectionCallback, false, z);
    }

    @VisibleForTesting
    public void injectSmsPdu(SmsMessage smsMessage, String str, SmsInjectionCallback smsInjectionCallback, boolean z, boolean z2) {
        Rlog.d(TAG, "SmsDispatchersController:injectSmsPdu");
        if (smsMessage == null) {
            try {
                Rlog.e(TAG, "injectSmsPdu: createFromPdu returned null");
                smsInjectionCallback.onSmsInjectedResult(2);
            } catch (Exception e) {
                Rlog.e(TAG, "injectSmsPdu failed: ", e);
                smsInjectionCallback.onSmsInjectedResult(2);
            }
        } else if (z || smsMessage.getMessageClass() == SmsMessage.MessageClass.CLASS_1) {
            AsyncResult asyncResult = new AsyncResult(smsInjectionCallback, smsMessage, (Throwable) null);
            int i = 1;
            if (str.equals("3gpp")) {
                Rlog.i(TAG, "SmsDispatchersController:injectSmsText Sending msg=" + smsMessage + ", format=" + str + "to mGsmInboundSmsHandler");
                GsmInboundSmsHandler gsmInboundSmsHandler = this.mGsmInboundSmsHandler;
                if (!z2) {
                    i = 0;
                }
                gsmInboundSmsHandler.sendMessage(7, i, 0, asyncResult);
            } else if (str.equals("3gpp2")) {
                Rlog.i(TAG, "SmsDispatchersController:injectSmsText Sending msg=" + smsMessage + ", format=" + str + "to mCdmaInboundSmsHandler");
                CdmaInboundSmsHandler cdmaInboundSmsHandler = this.mCdmaInboundSmsHandler;
                if (!z2) {
                    i = 0;
                }
                cdmaInboundSmsHandler.sendMessage(7, i, 0, asyncResult);
            } else {
                Rlog.e(TAG, "Invalid pdu format: " + str);
                smsInjectionCallback.onSmsInjectedResult(2);
            }
        } else {
            Rlog.e(TAG, "injectSmsPdu: not class 1");
            smsInjectionCallback.onSmsInjectedResult(2);
        }
    }

    public void sendRetrySms(SMSDispatcher.SmsTracker smsTracker) {
        String str;
        SMSDispatcher sMSDispatcher;
        SmsMessage.SubmitPdu submitPdu;
        Integer num;
        Integer num2;
        SmsMessage.SubmitPdu submitPdu2;
        SMSDispatcher.SmsTracker smsTracker2 = smsTracker;
        String str2 = smsTracker2.mFormat;
        boolean z = !smsTracker2.mUsesImsServiceForIms && this.mImsSmsDispatcher.isAvailable();
        if (z) {
            str = this.mImsSmsDispatcher.getFormat();
        } else if (2 == this.mPhone.getPhoneType()) {
            str = this.mCdmaDispatcher.getFormat();
        } else {
            str = this.mGsmDispatcher.getFormat();
        }
        Rlog.d(TAG, "old format(" + str2 + ") ==> new format (" + str + ")");
        if (!str2.equals(str)) {
            HashMap<String, Object> data = smsTracker.getData();
            if (!data.containsKey("scAddr") || !data.containsKey("destAddr") || (!data.containsKey("text") && (!data.containsKey("data") || !data.containsKey("destPort")))) {
                Rlog.e(TAG, "sendRetrySms failed to re-encode per missing fields!");
                smsTracker2.onFailed(this.mContext, 30, -1);
                return;
            }
            String str3 = (String) data.get("scAddr");
            String str4 = (String) data.get("destAddr");
            if (str4 == null) {
                Rlog.e(TAG, "sendRetrySms failed due to null destAddr");
                smsTracker2.onFailed(this.mContext, 30, -1);
                return;
            }
            if (data.containsKey("text")) {
                String str5 = (String) data.get("text");
                StringBuilder sb = new StringBuilder();
                sb.append("sms failed was text with length: ");
                if (str5 == null) {
                    num2 = null;
                } else {
                    num2 = Integer.valueOf(str5.length());
                }
                sb.append(num2);
                Rlog.d(TAG, sb.toString());
                if (isCdmaFormat(str)) {
                    submitPdu2 = com.android.internal.telephony.cdma.SmsMessage.getSubmitPdu(str3, str4, str5, smsTracker2.mDeliveryIntent != null, (SmsHeader) null);
                } else {
                    submitPdu2 = com.android.internal.telephony.gsm.SmsMessage.getSubmitPdu(str3, str4, str5, smsTracker2.mDeliveryIntent != null, (byte[]) null);
                }
                submitPdu = submitPdu2;
            } else if (data.containsKey("data")) {
                byte[] bArr = (byte[]) data.get("data");
                Integer num3 = (Integer) data.get("destPort");
                StringBuilder sb2 = new StringBuilder();
                sb2.append("sms failed was data with length: ");
                if (bArr == null) {
                    num = null;
                } else {
                    num = Integer.valueOf(bArr.length);
                }
                sb2.append(num);
                Rlog.d(TAG, sb2.toString());
                if (isCdmaFormat(str)) {
                    submitPdu = com.android.internal.telephony.cdma.SmsMessage.getSubmitPdu(str3, str4, num3.intValue(), bArr, smsTracker2.mDeliveryIntent != null);
                } else {
                    submitPdu = com.android.internal.telephony.gsm.SmsMessage.getSubmitPdu(str3, str4, num3.intValue(), bArr, smsTracker2.mDeliveryIntent != null);
                }
            } else {
                submitPdu = null;
            }
            if (submitPdu == null) {
                Rlog.e(TAG, String.format("sendRetrySms failed to encode message.scAddr: %s, destPort: %s", new Object[]{str3, data.get("destPort")}));
                smsTracker2.onFailed(this.mContext, 30, -1);
                return;
            }
            data.put("smsc", submitPdu.encodedScAddress);
            data.put("pdu", submitPdu.encodedMessage);
            smsTracker2.mFormat = str;
        }
        if (z) {
            sMSDispatcher = this.mImsSmsDispatcher;
        } else {
            sMSDispatcher = isCdmaFormat(str) ? this.mCdmaDispatcher : this.mGsmDispatcher;
        }
        sMSDispatcher.sendSms(smsTracker2);
    }

    public boolean isIms() {
        if (this.mImsSmsDispatcher.isAvailable()) {
            return true;
        }
        return this.mIms;
    }

    public String getImsSmsFormat() {
        return this.mImsSmsDispatcher.isAvailable() ? this.mImsSmsDispatcher.getFormat() : this.mImsSmsFormat;
    }

    /* access modifiers changed from: protected */
    public boolean isCdmaMo() {
        if (!isIms()) {
            return 2 == this.mPhone.getPhoneType();
        }
        return isCdmaFormat(getImsSmsFormat());
    }

    public boolean isCdmaFormat(String str) {
        return this.mCdmaDispatcher.getFormat().equals(str);
    }

    /* access modifiers changed from: protected */
    public void sendData(String str, String str2, String str3, int i, byte[] bArr, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z) {
        if (this.mImsSmsDispatcher.isAvailable()) {
            this.mImsSmsDispatcher.sendData(str, str2, str3, i, bArr, pendingIntent, pendingIntent2, z);
        } else if (isCdmaMo()) {
            this.mCdmaDispatcher.sendData(str, str2, str3, i, bArr, pendingIntent, pendingIntent2, z);
        } else {
            this.mGsmDispatcher.sendData(str, str2, str3, i, bArr, pendingIntent, pendingIntent2, z);
        }
    }

    public void sendText(String str, String str2, String str3, PendingIntent pendingIntent, PendingIntent pendingIntent2, Uri uri, String str4, boolean z, int i, boolean z2, int i2, boolean z3, long j) {
        if (this.mImsSmsDispatcher.isAvailable()) {
            String str5 = str;
        } else if (!this.mImsSmsDispatcher.isEmergencySmsSupport(str)) {
            if (isCdmaMo()) {
                this.mCdmaDispatcher.sendText(str, str2, str3, pendingIntent, pendingIntent2, uri, str4, z, i, z2, i2, z3, j);
                return;
            } else {
                this.mGsmDispatcher.sendText(str, str2, str3, pendingIntent, pendingIntent2, uri, str4, z, i, z2, i2, z3, j);
                return;
            }
        }
        this.mImsSmsDispatcher.sendText(str, str2, str3, pendingIntent, pendingIntent2, uri, str4, z, i, false, i2, z3, j);
    }

    /* access modifiers changed from: protected */
    public void sendMultipartText(String str, String str2, ArrayList<String> arrayList, ArrayList<PendingIntent> arrayList2, ArrayList<PendingIntent> arrayList3, Uri uri, String str3, boolean z, int i, boolean z2, int i2, long j) {
        if (this.mImsSmsDispatcher.isAvailable()) {
            this.mImsSmsDispatcher.sendMultipartText(str, str2, arrayList, arrayList2, arrayList3, uri, str3, z, i, false, i2, j);
        } else if (isCdmaMo()) {
            this.mCdmaDispatcher.sendMultipartText(str, str2, arrayList, arrayList2, arrayList3, uri, str3, z, i, z2, i2, j);
        } else {
            this.mGsmDispatcher.sendMultipartText(str, str2, arrayList, arrayList2, arrayList3, uri, str3, z, i, z2, i2, j);
        }
    }

    public int getPremiumSmsPermission(String str) {
        return this.mUsageMonitor.getPremiumSmsPermission(str);
    }

    public void setPremiumSmsPermission(String str, int i) {
        this.mUsageMonitor.setPremiumSmsPermission(str, i);
    }

    public SmsUsageMonitor getUsageMonitor() {
        return this.mUsageMonitor;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:6:0x001f, code lost:
        r4 = r7.mDeliveryPendingMapFor3GPP.get(java.lang.Integer.valueOf(r3));
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void handleSmsStatusReport(java.lang.String r8, byte[] r9) {
        /*
            r7 = this;
            boolean r0 = r7.isCdmaFormat(r8)
            r1 = 64
            r2 = 0
            if (r0 == 0) goto L_0x0060
            com.android.internal.telephony.cdma.SmsMessage r0 = com.android.internal.telephony.cdma.SmsMessage.createFromPdu(r9)
            if (r0 == 0) goto L_0x0092
            int r3 = r0.mMessageRef
            java.util.HashMap<java.lang.Integer, com.android.internal.telephony.SMSDispatcher$SmsTracker> r4 = r7.mDeliveryPendingMapFor3GPP2
            java.lang.Integer r5 = java.lang.Integer.valueOf(r3)
            java.lang.Object r4 = r4.get(r5)
            com.android.internal.telephony.SMSDispatcher$SmsTracker r4 = (com.android.internal.telephony.SMSDispatcher.SmsTracker) r4
            if (r4 != 0) goto L_0x002f
            java.util.HashMap<java.lang.Integer, com.android.internal.telephony.SMSDispatcher$SmsTracker> r4 = r7.mDeliveryPendingMapFor3GPP
            java.lang.Integer r5 = java.lang.Integer.valueOf(r3)
            java.lang.Object r4 = r4.get(r5)
            com.android.internal.telephony.SMSDispatcher$SmsTracker r4 = (com.android.internal.telephony.SMSDispatcher.SmsTracker) r4
            if (r4 == 0) goto L_0x002f
            r5 = 1
            goto L_0x0030
        L_0x002f:
            r5 = r2
        L_0x0030:
            if (r4 == 0) goto L_0x0092
            int r0 = r0.getStatus()
            int r0 = r0 >> 24
            r0 = r0 & 3
            r6 = 2
            if (r0 == r6) goto L_0x005a
            android.content.Context r6 = r7.mContext
            if (r0 != 0) goto L_0x0042
            r1 = r2
        L_0x0042:
            r4.updateSentMessageStatus(r6, r1)
            if (r5 == 0) goto L_0x0051
            java.util.HashMap<java.lang.Integer, com.android.internal.telephony.SMSDispatcher$SmsTracker> r0 = r7.mDeliveryPendingMapFor3GPP
            java.lang.Integer r1 = java.lang.Integer.valueOf(r3)
            r0.remove(r1)
            goto L_0x005a
        L_0x0051:
            java.util.HashMap<java.lang.Integer, com.android.internal.telephony.SMSDispatcher$SmsTracker> r0 = r7.mDeliveryPendingMapFor3GPP2
            java.lang.Integer r1 = java.lang.Integer.valueOf(r3)
            r0.remove(r1)
        L_0x005a:
            boolean r7 = r7.triggerDeliveryIntent(r4, r8, r9)
            r2 = r7
            goto L_0x0092
        L_0x0060:
            com.android.internal.telephony.gsm.SmsMessage r0 = com.android.internal.telephony.gsm.SmsMessage.createFromPdu(r9)
            if (r0 == 0) goto L_0x0092
            int r3 = r0.mMessageRef
            java.util.HashMap<java.lang.Integer, com.android.internal.telephony.SMSDispatcher$SmsTracker> r4 = r7.mDeliveryPendingMapFor3GPP
            java.lang.Integer r5 = java.lang.Integer.valueOf(r3)
            java.lang.Object r4 = r4.get(r5)
            com.android.internal.telephony.SMSDispatcher$SmsTracker r4 = (com.android.internal.telephony.SMSDispatcher.SmsTracker) r4
            if (r4 == 0) goto L_0x0092
            int r0 = r0.getStatus()
            if (r0 >= r1) goto L_0x0080
            r1 = 32
            if (r0 >= r1) goto L_0x008e
        L_0x0080:
            android.content.Context r1 = r7.mContext
            r4.updateSentMessageStatus(r1, r0)
            java.util.HashMap<java.lang.Integer, com.android.internal.telephony.SMSDispatcher$SmsTracker> r0 = r7.mDeliveryPendingMapFor3GPP
            java.lang.Integer r1 = java.lang.Integer.valueOf(r3)
            r0.remove(r1)
        L_0x008e:
            boolean r2 = r7.triggerDeliveryIntent(r4, r8, r9)
        L_0x0092:
            if (r2 != 0) goto L_0x009b
            java.lang.String r7 = "SmsDispatchersController"
            java.lang.String r8 = "handleSmsStatusReport: can not handle the status report!"
            com.android.telephony.Rlog.e(r7, r8)
        L_0x009b:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SmsDispatchersController.handleSmsStatusReport(java.lang.String, byte[]):void");
    }

    private boolean triggerDeliveryIntent(SMSDispatcher.SmsTracker smsTracker, String str, byte[] bArr) {
        PendingIntent pendingIntent = smsTracker.mDeliveryIntent;
        Intent intent = new Intent();
        intent.putExtra("pdu", bArr);
        intent.putExtra("format", str);
        try {
            pendingIntent.send(this.mContext, -1, intent);
            return true;
        } catch (PendingIntent.CanceledException unused) {
            return false;
        }
    }

    public InboundSmsHandler getInboundSmsHandler(boolean z) {
        if (z) {
            return this.mCdmaInboundSmsHandler;
        }
        return this.mGsmInboundSmsHandler;
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        this.mGsmInboundSmsHandler.dump(fileDescriptor, printWriter, strArr);
        this.mCdmaInboundSmsHandler.dump(fileDescriptor, printWriter, strArr);
        this.mGsmDispatcher.dump(fileDescriptor, printWriter, strArr);
        this.mCdmaDispatcher.dump(fileDescriptor, printWriter, strArr);
        this.mImsSmsDispatcher.dump(fileDescriptor, printWriter, strArr);
    }

    private void logd(String str) {
        Rlog.d(TAG, str);
    }
}
