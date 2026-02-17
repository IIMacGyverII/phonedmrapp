package com.android.internal.telephony;

import android.app.AlertDialog;
import android.app.PendingIntent;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.database.ContentObserver;
import android.net.Uri;
import android.os.AsyncResult;
import android.os.AsyncTask;
import android.os.Binder;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.SystemClock;
import android.os.UserHandle;
import android.provider.Settings;
import android.provider.Telephony;
import android.service.carrier.CarrierMessagingServiceWrapper;
import android.telephony.AnomalyReporter;
import android.telephony.CarrierConfigManager;
import android.telephony.PhoneNumberUtils;
import android.telephony.TelephonyManager;
import android.text.Html;
import android.text.Spanned;
import android.text.TextUtils;
import android.util.EventLog;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.TextView;
import androidx.core.app.NotificationCompat;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.GsmAlphabet;
import com.android.internal.telephony.SmsHeader;
import com.android.internal.telephony.SmsMessageBase;
import com.android.internal.telephony.cdma.SmsMessage;
import com.android.internal.telephony.cdma.sms.UserData;
import com.android.internal.telephony.gsm.SmsMessage;
import com.android.internal.telephony.metrics.SmsStats;
import com.android.internal.telephony.nano.TelephonyProto;
import com.android.telephony.Rlog;
import com.mediatek.boostfwk.identify.launch.LaunchConfig;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

public abstract class SMSDispatcher extends Handler {
    static final boolean DBG = false;
    protected static final int EVENT_CONFIRM_SEND_TO_POSSIBLE_PREMIUM_SHORT_CODE = 8;
    protected static final int EVENT_CONFIRM_SEND_TO_PREMIUM_SHORT_CODE = 9;
    protected static final int EVENT_GET_IMS_SERVICE = 16;
    protected static final int EVENT_ICC_CHANGED = 15;
    protected static final int EVENT_NEW_ICC_SMS = 14;
    protected static final int EVENT_NEW_SMS_STATUS_REPORT = 10;
    static final int EVENT_SENDING_NOT_ALLOWED = 7;
    static final int EVENT_SEND_CONFIRMED_SMS = 5;
    protected static final int EVENT_SEND_LIMIT_REACHED_CONFIRMATION = 4;
    protected static final int EVENT_SEND_RETRY = 3;
    protected static final int EVENT_SEND_SMS_COMPLETE = 2;
    protected static final int EVENT_STOP_SENDING = 6;
    protected static final String MAP_KEY_DATA = "data";
    protected static final String MAP_KEY_DEST_ADDR = "destAddr";
    protected static final String MAP_KEY_DEST_PORT = "destPort";
    protected static final String MAP_KEY_PDU = "pdu";
    protected static final String MAP_KEY_SC_ADDR = "scAddr";
    protected static final String MAP_KEY_SMSC = "smsc";
    protected static final String MAP_KEY_TEXT = "text";
    protected static final int MAX_SEND_RETRIES = 3;
    private static final String MESSAGE_ID_EXTRA = "MessageId";
    public static final int MO_MSG_QUEUE_LIMIT = 5;
    protected static final int PREMIUM_RULE_USE_BOTH = 3;
    protected static final int PREMIUM_RULE_USE_NETWORK = 2;
    protected static final int PREMIUM_RULE_USE_SIM = 1;
    private static final String SEND_NEXT_MSG_EXTRA = "SendNextMsg";
    @VisibleForTesting
    public static final int SEND_RETRY_DELAY = 2000;
    static final String TAG = "SMSDispatcher";
    /* access modifiers changed from: private */
    public static final UUID sAnomalyNoResponseFromCarrierMessagingService = UUID.fromString("279d9fbc-462d-4fc2-802c-bf21ddd9dd90");
    /* access modifiers changed from: private */
    public static final UUID sAnomalyUnexpectedCallback = UUID.fromString("0103b6d2-ad07-4d86-9102-14341b9074ef");
    private static int sConcatenatedRef = new Random().nextInt(256);
    @VisibleForTesting
    public int mCarrierMessagingTimeout = CarrierServicesSmsFilter.FILTER_COMPLETE_TIMEOUT_MS;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final CommandsInterface mCi;
    @UnsupportedAppUsage
    protected final Context mContext;
    protected final LocalLog mLocalLog = new LocalLog(16);
    private int mPendingTrackerCount;
    @UnsupportedAppUsage
    protected Phone mPhone;
    protected final AtomicInteger mPremiumSmsRule;
    @UnsupportedAppUsage
    protected final ContentResolver mResolver;
    private final SettingsObserver mSettingsObserver;
    protected boolean mSmsCapable = true;
    protected SmsDispatchersController mSmsDispatchersController;
    protected boolean mSmsSendDisabled;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final TelephonyManager mTelephonyManager;

    protected static int getNotInServiceError(int i) {
        return i == 3 ? 2 : 4;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public abstract GsmAlphabet.TextEncodingDetails calculateLength(CharSequence charSequence, boolean z);

    /* access modifiers changed from: protected */
    public abstract String getFormat();

    /* access modifiers changed from: protected */
    public abstract SmsMessageBase.SubmitPduBase getSubmitPdu(String str, String str2, int i, byte[] bArr, boolean z);

    /* access modifiers changed from: protected */
    public abstract SmsMessageBase.SubmitPduBase getSubmitPdu(String str, String str2, String str3, boolean z, SmsHeader smsHeader, int i, int i2);

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage
    public abstract void sendSms(SmsTracker smsTracker);

    /* access modifiers changed from: protected */
    public abstract boolean shouldBlockSmsForEcbm();

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected static int getNextConcatenatedRef() {
        int i = sConcatenatedRef + 1;
        sConcatenatedRef = i;
        return i;
    }

    protected SMSDispatcher(Phone phone, SmsDispatchersController smsDispatchersController) {
        AtomicInteger atomicInteger = new AtomicInteger(1);
        this.mPremiumSmsRule = atomicInteger;
        this.mPhone = phone;
        this.mSmsDispatchersController = smsDispatchersController;
        Context context = phone.getContext();
        this.mContext = context;
        this.mResolver = context.getContentResolver();
        this.mCi = phone.mCi;
        TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService("phone");
        this.mTelephonyManager = telephonyManager;
        SettingsObserver settingsObserver = new SettingsObserver(this, atomicInteger, context);
        this.mSettingsObserver = settingsObserver;
        context.getContentResolver().registerContentObserver(Settings.Global.getUriFor("sms_short_code_rule"), false, settingsObserver);
        this.mSmsCapable = context.getResources().getBoolean(17891765);
        this.mSmsSendDisabled = !telephonyManager.getSmsSendCapableForPhone(this.mPhone.getPhoneId(), this.mSmsCapable);
        Rlog.d(TAG, "SMSDispatcher: ctor mSmsCapable=" + this.mSmsCapable + " format=" + getFormat() + " mSmsSendDisabled=" + this.mSmsSendDisabled);
    }

    private static class SettingsObserver extends ContentObserver {
        private final Context mContext;
        private final AtomicInteger mPremiumSmsRule;

        SettingsObserver(Handler handler, AtomicInteger atomicInteger, Context context) {
            super(handler);
            this.mPremiumSmsRule = atomicInteger;
            this.mContext = context;
            onChange(false);
        }

        public void onChange(boolean z) {
            this.mPremiumSmsRule.set(Settings.Global.getInt(this.mContext.getContentResolver(), "sms_short_code_rule", 1));
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void dispose() {
        this.mContext.getContentResolver().unregisterContentObserver(this.mSettingsObserver);
    }

    /* access modifiers changed from: protected */
    public void handleStatusReport(Object obj) {
        Rlog.d(TAG, "handleStatusReport() called with no subclass.");
    }

    public void handleMessage(Message message) {
        int i = 8;
        switch (message.what) {
            case 2:
                handleSendComplete((AsyncResult) message.obj);
                return;
            case 3:
                Rlog.d(TAG, "SMS retry..");
                sendRetrySms((SmsTracker) message.obj);
                return;
            case 4:
                handleReachSentLimit((SmsTracker[]) message.obj);
                return;
            case 5:
                for (SmsTracker sendSms : (SmsTracker[]) message.obj) {
                    sendSms(sendSms);
                }
                this.mPendingTrackerCount--;
                return;
            case 6:
                SmsTracker[] smsTrackerArr = (SmsTracker[]) message.obj;
                int i2 = message.arg1;
                if (i2 == 0) {
                    if (message.arg2 == 1) {
                        Rlog.d(TAG, "SMSDispatcher: EVENT_STOP_SENDING - sending SHORT_CODE_NEVER_ALLOWED error code.");
                    } else {
                        i = 7;
                        Rlog.d(TAG, "SMSDispatcher: EVENT_STOP_SENDING - sending SHORT_CODE_NOT_ALLOWED error code.");
                    }
                } else if (i2 == 1) {
                    i = 5;
                    Rlog.d(TAG, "SMSDispatcher: EVENT_STOP_SENDING - sending LIMIT_EXCEEDED error code.");
                } else {
                    i = 28;
                    Rlog.e(TAG, "SMSDispatcher: EVENT_STOP_SENDING - unexpected cases.");
                }
                handleSmsTrackersFailure(smsTrackerArr, i, -1);
                this.mPendingTrackerCount--;
                return;
            case 7:
                Rlog.d(TAG, "SMSDispatcher: EVENT_SENDING_NOT_ALLOWED - sending SHORT_CODE_NEVER_ALLOWED error code.");
                handleSmsTrackersFailure((SmsTracker[]) message.obj, 8, -1);
                return;
            case 8:
                handleConfirmShortCode(false, (SmsTracker[]) message.obj);
                return;
            case 9:
                handleConfirmShortCode(true, (SmsTracker[]) message.obj);
                return;
            case 10:
                handleStatusReport(message.obj);
                return;
            default:
                Rlog.e(TAG, "handleMessage() ignoring message of unexpected type " + message.what);
                return;
        }
    }

    protected abstract class SmsSender extends Handler {
        private static final int EVENT_TIMEOUT = 1;
        protected final CarrierMessagingServiceWrapper mCarrierMessagingServiceWrapper = new CarrierMessagingServiceWrapper();
        private String mCarrierPackageName;
        protected volatile CarrierMessagingServiceWrapper.CarrierMessagingCallback mSenderCallback;

        public abstract SmsTracker getSmsTracker();

        public abstract SmsTracker[] getSmsTrackers();

        public abstract void onSendComplete(int i);

        /* renamed from: onServiceReady */
        public abstract void lambda$sendSmsByCarrierApp$1();

        protected SmsSender() {
            super(Looper.getMainLooper());
        }

        public synchronized void sendSmsByCarrierApp(String str, CarrierMessagingServiceWrapper.CarrierMessagingCallback carrierMessagingCallback) {
            this.mCarrierPackageName = str;
            this.mSenderCallback = carrierMessagingCallback;
            if (!this.mCarrierMessagingServiceWrapper.bindToCarrierMessagingService(SMSDispatcher.this.mContext, str, new SMSDispatcher$SmsSender$$ExternalSyntheticLambda0(), new SMSDispatcher$SmsSender$$ExternalSyntheticLambda1(this))) {
                Rlog.e(SMSDispatcher.TAG, "bindService() for carrier messaging service failed");
                onSendComplete(1);
            } else {
                Rlog.d(SMSDispatcher.TAG, "bindService() for carrier messaging service succeeded");
                sendMessageDelayed(obtainMessage(1), (long) SMSDispatcher.this.mCarrierMessagingTimeout);
            }
        }

        public void handleMessage(Message message) {
            if (message.what == 1) {
                SMSDispatcher sMSDispatcher = SMSDispatcher.this;
                sMSDispatcher.logWithLocalLog("handleMessage: No response from " + this.mCarrierPackageName + " for " + SMSDispatcher.this.mCarrierMessagingTimeout + " ms");
                UUID r4 = SMSDispatcher.sAnomalyNoResponseFromCarrierMessagingService;
                StringBuilder sb = new StringBuilder();
                sb.append("No response from ");
                sb.append(this.mCarrierPackageName);
                AnomalyReporter.reportAnomaly(r4, sb.toString(), SMSDispatcher.this.mPhone.getCarrierId());
                onSendComplete(1);
                return;
            }
            SMSDispatcher sMSDispatcher2 = SMSDispatcher.this;
            sMSDispatcher2.logWithLocalLog("handleMessage: received unexpected message " + message.what);
        }

        public void removeTimeout() {
            removeMessages(1);
        }
    }

    /* access modifiers changed from: private */
    public void logWithLocalLog(String str) {
        this.mLocalLog.log(str);
        Rlog.d(TAG, str);
    }

    protected final class TextSmsSender extends SmsSender {
        private final SmsTracker mTracker;

        public TextSmsSender(SmsTracker smsTracker) {
            super();
            this.mTracker = smsTracker;
        }

        public synchronized void onServiceReady() {
            Rlog.d(SMSDispatcher.TAG, "TextSmsSender::onServiceReady");
            String str = (String) this.mTracker.getData().get(SMSDispatcher.MAP_KEY_TEXT);
            if (str != null) {
                try {
                    CarrierMessagingServiceWrapper carrierMessagingServiceWrapper = this.mCarrierMessagingServiceWrapper;
                    int subId = SMSDispatcher.this.getSubId();
                    SmsTracker smsTracker = this.mTracker;
                    carrierMessagingServiceWrapper.sendTextSms(str, subId, smsTracker.mDestAddress, smsTracker.mDeliveryIntent != null ? 1 : 0, new SMSDispatcher$TextSmsSender$$ExternalSyntheticLambda0(), this.mSenderCallback);
                } catch (RuntimeException e) {
                    Rlog.e(SMSDispatcher.TAG, "TextSmsSender::onServiceReady: Exception sending the SMS: " + e.getMessage());
                    onSendComplete(1);
                }
            } else {
                Rlog.d(SMSDispatcher.TAG, "TextSmsSender::onServiceReady: text == null");
                onSendComplete(1);
            }
        }

        public void onSendComplete(int i) {
            this.mSenderCallback.onSendSmsComplete(i, 0);
        }

        public SmsTracker getSmsTracker() {
            return this.mTracker;
        }

        public SmsTracker[] getSmsTrackers() {
            Rlog.e(SMSDispatcher.TAG, "getSmsTrackers: Unexpected call for TextSmsSender");
            return null;
        }
    }

    protected final class DataSmsSender extends SmsSender {
        private final SmsTracker mTracker;

        public DataSmsSender(SmsTracker smsTracker) {
            super();
            this.mTracker = smsTracker;
        }

        public synchronized void onServiceReady() {
            Rlog.d(SMSDispatcher.TAG, "DataSmsSender::onServiceReady");
            HashMap<String, Object> data = this.mTracker.getData();
            byte[] bArr = (byte[]) data.get(SMSDispatcher.MAP_KEY_DATA);
            int intValue = ((Integer) data.get(SMSDispatcher.MAP_KEY_DEST_PORT)).intValue();
            if (bArr != null) {
                try {
                    CarrierMessagingServiceWrapper carrierMessagingServiceWrapper = this.mCarrierMessagingServiceWrapper;
                    int subId = SMSDispatcher.this.getSubId();
                    SmsTracker smsTracker = this.mTracker;
                    carrierMessagingServiceWrapper.sendDataSms(bArr, subId, smsTracker.mDestAddress, intValue, smsTracker.mDeliveryIntent != null ? 1 : 0, new SMSDispatcher$DataSmsSender$$ExternalSyntheticLambda0(), this.mSenderCallback);
                } catch (RuntimeException e) {
                    Rlog.e(SMSDispatcher.TAG, "DataSmsSender::onServiceReady: Exception sending the SMS: " + e + " " + SmsController.formatCrossStackMessageId(this.mTracker.mMessageId));
                    onSendComplete(1);
                }
            } else {
                Rlog.d(SMSDispatcher.TAG, "DataSmsSender::onServiceReady: data == null");
                onSendComplete(1);
            }
        }

        public void onSendComplete(int i) {
            this.mSenderCallback.onSendSmsComplete(i, 0);
        }

        public SmsTracker getSmsTracker() {
            return this.mTracker;
        }

        public SmsTracker[] getSmsTrackers() {
            Rlog.e(SMSDispatcher.TAG, "getSmsTrackers: Unexpected call for DataSmsSender");
            return null;
        }
    }

    protected final class SmsSenderCallback implements CarrierMessagingServiceWrapper.CarrierMessagingCallback {
        private boolean mCallbackCalled = false;
        private final SmsSender mSmsSender;

        public SmsSenderCallback(SmsSender smsSender) {
            this.mSmsSender = smsSender;
        }

        public void onSendSmsComplete(int i, int i2) {
            Rlog.d(SMSDispatcher.TAG, "onSendSmsComplete: result=" + i + " messageRef=" + i2);
            if (this.mCallbackCalled) {
                SMSDispatcher.this.logWithLocalLog("onSendSmsComplete: unexpected call");
                AnomalyReporter.reportAnomaly(SMSDispatcher.sAnomalyUnexpectedCallback, "Unexpected onSendSmsComplete", SMSDispatcher.this.mPhone.getCarrierId());
                return;
            }
            this.mCallbackCalled = true;
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                this.mSmsSender.mCarrierMessagingServiceWrapper.disconnect();
                SMSDispatcher.this.processSendSmsResponse(this.mSmsSender.getSmsTracker(), i, i2);
                this.mSmsSender.removeTimeout();
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        }

        public void onSendMultipartSmsComplete(int i, int[] iArr) {
            Rlog.e(SMSDispatcher.TAG, "Unexpected onSendMultipartSmsComplete call with result: " + i);
        }

        public void onReceiveSmsComplete(int i) {
            Rlog.e(SMSDispatcher.TAG, "Unexpected onReceiveSmsComplete call with result: " + i);
        }

        public void onSendMmsComplete(int i, byte[] bArr) {
            Rlog.e(SMSDispatcher.TAG, "Unexpected onSendMmsComplete call with result: " + i);
        }

        public void onDownloadMmsComplete(int i) {
            Rlog.e(SMSDispatcher.TAG, "Unexpected onDownloadMmsComplete call with result: " + i);
        }
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void processSendSmsResponse(SmsTracker smsTracker, int i, int i2) {
        if (smsTracker == null) {
            Rlog.e(TAG, "processSendSmsResponse: null tracker");
            return;
        }
        SmsResponse smsResponse = new SmsResponse(i2, (String) null, -1, smsTracker.mMessageId);
        if (i == 0) {
            Rlog.d(TAG, "processSendSmsResponse: Sending SMS by CarrierMessagingService succeeded. " + SmsController.formatCrossStackMessageId(smsTracker.mMessageId));
            sendMessage(obtainMessage(2, new AsyncResult(smsTracker, smsResponse, (Throwable) null)));
        } else if (i == 1) {
            Rlog.d(TAG, "processSendSmsResponse: Sending SMS by CarrierMessagingService failed. Retry on carrier network. " + SmsController.formatCrossStackMessageId(smsTracker.mMessageId));
            sendSubmitPdu(smsTracker);
        } else if (i != 2) {
            Rlog.d(TAG, "processSendSmsResponse: Unknown result " + i + " Retry on carrier network. " + SmsController.formatCrossStackMessageId(smsTracker.mMessageId));
            sendSubmitPdu(smsTracker);
        } else {
            Rlog.d(TAG, "processSendSmsResponse: Sending SMS by CarrierMessagingService failed. " + SmsController.formatCrossStackMessageId(smsTracker.mMessageId));
            sendMessage(obtainMessage(2, new AsyncResult(smsTracker, smsResponse, new CommandException(CommandException.Error.GENERIC_FAILURE))));
        }
    }

    protected final class MultipartSmsSender extends SmsSender {
        private final List<String> mParts;
        public final SmsTracker[] mTrackers;

        public MultipartSmsSender(ArrayList<String> arrayList, SmsTracker[] smsTrackerArr) {
            super();
            this.mParts = arrayList;
            this.mTrackers = smsTrackerArr;
        }

        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public void sendSmsByCarrierApp(String str, MultipartSmsSenderCallback multipartSmsSenderCallback) {
            super.sendSmsByCarrierApp(str, multipartSmsSenderCallback);
        }

        public synchronized void onServiceReady() {
            boolean z;
            Rlog.d(SMSDispatcher.TAG, "MultipartSmsSender::onServiceReady");
            SmsTracker[] smsTrackerArr = this.mTrackers;
            int length = smsTrackerArr.length;
            int i = 0;
            while (true) {
                if (i >= length) {
                    z = false;
                    break;
                } else if (smsTrackerArr[i].mDeliveryIntent != null) {
                    z = true;
                    break;
                } else {
                    i++;
                }
            }
            try {
                this.mCarrierMessagingServiceWrapper.sendMultipartTextSms(this.mParts, SMSDispatcher.this.getSubId(), this.mTrackers[0].mDestAddress, z ? 1 : 0, new SMSDispatcher$MultipartSmsSender$$ExternalSyntheticLambda0(), this.mSenderCallback);
            } catch (RuntimeException e) {
                Rlog.e(SMSDispatcher.TAG, "MultipartSmsSender::onServiceReady: Exception sending the SMS: " + e);
                onSendComplete(1);
            }
            return;
        }

        public void onSendComplete(int i) {
            this.mSenderCallback.onSendMultipartSmsComplete(i, (int[]) null);
        }

        public SmsTracker getSmsTracker() {
            Rlog.e(SMSDispatcher.TAG, "getSmsTracker: Unexpected call for MultipartSmsSender");
            return null;
        }

        public SmsTracker[] getSmsTrackers() {
            return this.mTrackers;
        }
    }

    protected final class MultipartSmsSenderCallback implements CarrierMessagingServiceWrapper.CarrierMessagingCallback {
        private boolean mCallbackCalled = false;
        private final MultipartSmsSender mSmsSender;

        public MultipartSmsSenderCallback(MultipartSmsSender multipartSmsSender) {
            this.mSmsSender = multipartSmsSender;
        }

        public void onSendSmsComplete(int i, int i2) {
            Rlog.e(SMSDispatcher.TAG, "Unexpected onSendSmsComplete call with result: " + i);
        }

        public void onSendMultipartSmsComplete(int i, int[] iArr) {
            Rlog.d(SMSDispatcher.TAG, "onSendMultipartSmsComplete: result=" + i + " messageRefs=" + Arrays.toString(iArr));
            if (this.mCallbackCalled) {
                SMSDispatcher.this.logWithLocalLog("onSendMultipartSmsComplete: unexpected call");
                AnomalyReporter.reportAnomaly(SMSDispatcher.sAnomalyUnexpectedCallback, "Unexpected onSendMultipartSmsComplete", SMSDispatcher.this.mPhone.getCarrierId());
                return;
            }
            this.mCallbackCalled = true;
            this.mSmsSender.removeTimeout();
            this.mSmsSender.mCarrierMessagingServiceWrapper.disconnect();
            if (this.mSmsSender.mTrackers == null) {
                Rlog.e(SMSDispatcher.TAG, "Unexpected onSendMultipartSmsComplete call with null trackers.");
                return;
            }
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                SMSDispatcher.this.processSendMultipartSmsResponse(this.mSmsSender.mTrackers, i, iArr);
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        }

        public void onReceiveSmsComplete(int i) {
            Rlog.e(SMSDispatcher.TAG, "Unexpected onReceiveSmsComplete call with result: " + i);
        }

        public void onSendMmsComplete(int i, byte[] bArr) {
            Rlog.e(SMSDispatcher.TAG, "Unexpected onSendMmsComplete call with result: " + i);
        }

        public void onDownloadMmsComplete(int i) {
            Rlog.e(SMSDispatcher.TAG, "Unexpected onDownloadMmsComplete call with result: " + i);
        }
    }

    /* access modifiers changed from: private */
    public void processSendMultipartSmsResponse(SmsTracker[] smsTrackerArr, int i, int[] iArr) {
        if (smsTrackerArr == null) {
            Rlog.e(TAG, "processSendMultipartSmsResponse: null trackers");
        } else if (i == 0) {
            Rlog.d(TAG, "processSendMultipartSmsResponse: Sending SMS by CarrierMessagingService succeeded. " + SmsController.formatCrossStackMessageId(smsTrackerArr[0].mMessageId));
            int i2 = 0;
            while (i2 < smsTrackerArr.length) {
                sendMessage(obtainMessage(2, new AsyncResult(smsTrackerArr[i2], new SmsResponse((iArr == null || iArr.length <= i2) ? 0 : iArr[i2], (String) null, -1), (Throwable) null)));
                i2++;
            }
        } else if (i == 1) {
            Rlog.d(TAG, "processSendMultipartSmsResponse: Sending SMS by CarrierMessagingService failed. Retry on carrier network. " + SmsController.formatCrossStackMessageId(smsTrackerArr[0].mMessageId));
            sendSubmitPdu(smsTrackerArr);
        } else if (i != 2) {
            Rlog.d(TAG, "processSendMultipartSmsResponse: Unknown result " + i + ". Retry on carrier network. " + SmsController.formatCrossStackMessageId(smsTrackerArr[0].mMessageId));
            sendSubmitPdu(smsTrackerArr);
        } else {
            Rlog.d(TAG, "processSendMultipartSmsResponse: Sending SMS by CarrierMessagingService failed. " + SmsController.formatCrossStackMessageId(smsTrackerArr[0].mMessageId));
            int i3 = 0;
            while (i3 < smsTrackerArr.length) {
                sendMessage(obtainMessage(2, new AsyncResult(smsTrackerArr[i3], new SmsResponse((iArr == null || iArr.length <= i3) ? 0 : iArr[i3], (String) null, -1), new CommandException(CommandException.Error.GENERIC_FAILURE))));
                i3++;
            }
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void sendSubmitPdu(SmsTracker smsTracker) {
        sendSubmitPdu(new SmsTracker[]{smsTracker});
    }

    private void sendSubmitPdu(SmsTracker[] smsTrackerArr) {
        if (shouldBlockSmsForEcbm()) {
            Rlog.d(TAG, "Block SMS in Emergency Callback mode");
            handleSmsTrackersFailure(smsTrackerArr, 29, -1);
            return;
        }
        sendRawPdu(smsTrackerArr);
    }

    /* access modifiers changed from: protected */
    public void handleSendComplete(AsyncResult asyncResult) {
        int i;
        AsyncResult asyncResult2 = asyncResult;
        SmsTracker smsTracker = (SmsTracker) asyncResult2.userObj;
        PendingIntent pendingIntent = smsTracker.mSentIntent;
        SmsResponse smsResponse = (SmsResponse) asyncResult2.result;
        if (smsResponse != null) {
            smsTracker.mMessageRef = smsResponse.mMessageRef;
        } else {
            Rlog.d(TAG, "SmsResponse was null");
        }
        if (asyncResult2.exception == null) {
            if (smsTracker.mDeliveryIntent != null) {
                this.mSmsDispatchersController.putDeliveryPendingTracker(smsTracker);
            }
            smsTracker.onSent(this.mContext);
            this.mPhone.notifySmsSent(smsTracker.mDestAddress);
            this.mPhone.getSmsStats().onOutgoingSms(smsTracker.mImsRetry > 0, "3gpp2".equals(getFormat()), false, 0, smsTracker.mMessageId, smsTracker.isFromDefaultSmsApplication(this.mContext), smsTracker.getInterval());
            return;
        }
        int state = this.mPhone.getServiceState().getState();
        int rilErrorToSmsManagerResult = rilErrorToSmsManagerResult(((CommandException) asyncResult2.exception).getCommandError(), smsTracker);
        if (smsTracker.mImsRetry > 0 && state != 0) {
            smsTracker.mRetryCount = 3;
            Rlog.d(TAG, "handleSendComplete: Skipping retry:  isIms()=" + isIms() + " mRetryCount=" + smsTracker.mRetryCount + " mImsRetry=" + smsTracker.mImsRetry + " mMessageRef=" + smsTracker.mMessageRef + " SS= " + this.mPhone.getServiceState().getState() + " " + SmsController.formatCrossStackMessageId(smsTracker.mMessageId));
        }
        int i2 = -1;
        if (!isIms() && state != 0) {
            smsTracker.onFailed(this.mContext, getNotInServiceError(state), -1);
            this.mPhone.getSmsStats().onOutgoingSms(smsTracker.mImsRetry > 0, "3gpp2".equals(getFormat()), false, getNotInServiceError(state), smsTracker.mMessageId, smsTracker.isFromDefaultSmsApplication(this.mContext), smsTracker.getInterval());
        } else if (rilErrorToSmsManagerResult != 101 || (i = smsTracker.mRetryCount) >= 3) {
            int i3 = smsResponse != null ? smsResponse.mErrorCode : -1;
            smsTracker.onFailed(this.mContext, rilErrorToSmsManagerResult, i3);
            this.mPhone.getSmsStats().onOutgoingSms(smsTracker.mImsRetry > 0, "3gpp2".equals(getFormat()), false, rilErrorToSmsManagerResult, i3, smsTracker.mMessageId, smsTracker.isFromDefaultSmsApplication(this.mContext), smsTracker.getInterval());
        } else {
            smsTracker.mRetryCount = i + 1;
            if (smsResponse != null) {
                i2 = smsResponse.mErrorCode;
            }
            int i4 = i2;
            sendMessageDelayed(obtainMessage(3, smsTracker), LaunchConfig.ACTIVITY_CONSIDERED_RESUME);
            this.mPhone.getSmsStats().onOutgoingSms(smsTracker.mImsRetry > 0, "3gpp2".equals(getFormat()), false, 101, i4, smsTracker.mMessageId, smsTracker.isFromDefaultSmsApplication(this.mContext), smsTracker.getInterval());
        }
    }

    /* renamed from: com.android.internal.telephony.SMSDispatcher$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$CommandException$Error;

        /* JADX WARNING: Can't wrap try/catch for region: R(48:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|(3:47|48|50)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(50:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|50) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:13:0x0049 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:15:0x0054 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:17:0x0060 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:19:0x006c */
        /* JADX WARNING: Missing exception handler attribute for start block: B:21:0x0078 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:23:0x0084 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:25:0x0090 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:27:0x009c */
        /* JADX WARNING: Missing exception handler attribute for start block: B:29:0x00a8 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:31:0x00b4 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:33:0x00c0 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:35:0x00cc */
        /* JADX WARNING: Missing exception handler attribute for start block: B:37:0x00d8 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:39:0x00e4 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:41:0x00f0 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:43:0x00fc */
        /* JADX WARNING: Missing exception handler attribute for start block: B:45:0x0108 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:47:0x0114 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:9:0x0033 */
        static {
            /*
                com.android.internal.telephony.CommandException$Error[] r0 = com.android.internal.telephony.CommandException.Error.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$CommandException$Error = r0
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.RADIO_NOT_AVAILABLE     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.SMS_FAIL_RETRY     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.NETWORK_REJECT     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.INVALID_STATE     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.INVALID_ARGUMENTS     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.NO_MEMORY     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.REQUEST_RATE_LIMITED     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r2 = 7
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0060 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.INVALID_SMS_FORMAT     // Catch:{ NoSuchFieldError -> 0x0060 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0060 }
                r2 = 8
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0060 }
            L_0x0060:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x006c }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.SYSTEM_ERR     // Catch:{ NoSuchFieldError -> 0x006c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x006c }
                r2 = 9
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x006c }
            L_0x006c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0078 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.ENCODING_ERR     // Catch:{ NoSuchFieldError -> 0x0078 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0078 }
                r2 = 10
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0078 }
            L_0x0078:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0084 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.MODEM_ERR     // Catch:{ NoSuchFieldError -> 0x0084 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0084 }
                r2 = 11
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0084 }
            L_0x0084:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0090 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.NETWORK_ERR     // Catch:{ NoSuchFieldError -> 0x0090 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0090 }
                r2 = 12
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0090 }
            L_0x0090:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x009c }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.INTERNAL_ERR     // Catch:{ NoSuchFieldError -> 0x009c }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x009c }
                r2 = 13
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x009c }
            L_0x009c:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x00a8 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.REQUEST_NOT_SUPPORTED     // Catch:{ NoSuchFieldError -> 0x00a8 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00a8 }
                r2 = 14
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00a8 }
            L_0x00a8:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x00b4 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.INVALID_MODEM_STATE     // Catch:{ NoSuchFieldError -> 0x00b4 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00b4 }
                r2 = 15
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00b4 }
            L_0x00b4:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x00c0 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.NETWORK_NOT_READY     // Catch:{ NoSuchFieldError -> 0x00c0 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00c0 }
                r2 = 16
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00c0 }
            L_0x00c0:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x00cc }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.OPERATION_NOT_ALLOWED     // Catch:{ NoSuchFieldError -> 0x00cc }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00cc }
                r2 = 17
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00cc }
            L_0x00cc:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x00d8 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.NO_RESOURCES     // Catch:{ NoSuchFieldError -> 0x00d8 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00d8 }
                r2 = 18
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00d8 }
            L_0x00d8:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x00e4 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.REQUEST_CANCELLED     // Catch:{ NoSuchFieldError -> 0x00e4 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00e4 }
                r2 = 19
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00e4 }
            L_0x00e4:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x00f0 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.SIM_ABSENT     // Catch:{ NoSuchFieldError -> 0x00f0 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00f0 }
                r2 = 20
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00f0 }
            L_0x00f0:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x00fc }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.FDN_CHECK_FAILURE     // Catch:{ NoSuchFieldError -> 0x00fc }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x00fc }
                r2 = 21
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x00fc }
            L_0x00fc:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0108 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.SIMULTANEOUS_SMS_AND_CALL_NOT_ALLOWED     // Catch:{ NoSuchFieldError -> 0x0108 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0108 }
                r2 = 22
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0108 }
            L_0x0108:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0114 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.ACCESS_BARRED     // Catch:{ NoSuchFieldError -> 0x0114 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0114 }
                r2 = 23
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0114 }
            L_0x0114:
                int[] r0 = $SwitchMap$com$android$internal$telephony$CommandException$Error     // Catch:{ NoSuchFieldError -> 0x0120 }
                com.android.internal.telephony.CommandException$Error r1 = com.android.internal.telephony.CommandException.Error.BLOCKED_DUE_TO_CALL     // Catch:{ NoSuchFieldError -> 0x0120 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0120 }
                r2 = 24
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0120 }
            L_0x0120:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.SMSDispatcher.AnonymousClass1.<clinit>():void");
        }
    }

    private static int rilErrorToSmsManagerResult(CommandException.Error error, SmsTracker smsTracker) {
        switch (AnonymousClass1.$SwitchMap$com$android$internal$telephony$CommandException$Error[error.ordinal()]) {
            case 1:
                return 100;
            case 2:
                return 101;
            case 3:
                return 102;
            case 4:
                return 103;
            case 5:
                return 104;
            case 6:
                return 105;
            case 7:
                return 106;
            case 8:
                return 107;
            case 9:
                return 108;
            case 10:
                return 109;
            case 11:
                return 111;
            case 12:
                return 112;
            case 13:
                return 113;
            case 14:
                return 114;
            case 15:
                return 115;
            case 16:
                return 116;
            case 17:
                return 117;
            case 18:
                return 118;
            case 19:
                return 119;
            case 20:
                return 120;
            case 21:
                return 6;
            case 22:
                return 121;
            case 23:
                return 122;
            case 24:
                return 123;
            default:
                Rlog.d(TAG, "rilErrorToSmsManagerResult: " + error + " " + SmsController.formatCrossStackMessageId(smsTracker.mMessageId));
                return 124;
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage
    public void sendData(String str, String str2, String str3, int i, byte[] bArr, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z) {
        SmsMessageBase.SubmitPduBase onSendData = onSendData(str2, str3, i, bArr, pendingIntent, pendingIntent2);
        if (onSendData != null) {
            SmsTracker smsTracker = getSmsTracker(str, getSmsTrackerMap(str2, str3, i, bArr, onSendData), pendingIntent, pendingIntent2, getFormat(), (Uri) null, false, (String) null, false, true, z, 0);
            if (!sendSmsByCarrierApp(true, smsTracker)) {
                sendSubmitPdu(smsTracker);
                return;
            }
            return;
        }
        Rlog.e(TAG, "SMSDispatcher.sendData(): getSubmitPdu() returned null");
        triggerSentIntentForFailure(pendingIntent);
    }

    public void sendText(String str, String str2, String str3, PendingIntent pendingIntent, PendingIntent pendingIntent2, Uri uri, String str4, boolean z, int i, boolean z2, int i2, boolean z3, long j) {
        Rlog.d(TAG, "sendText id: " + SmsController.formatCrossStackMessageId(j));
        SmsMessageBase.SubmitPduBase onSendText = onSendText(str, str2, str3, pendingIntent, pendingIntent2, uri, str4, z, i, z2, i2);
        if (onSendText != null) {
            String str5 = str3;
            SmsTracker smsTracker = getSmsTracker(str4, getSmsTrackerMap(str, str2, str5, onSendText), pendingIntent, pendingIntent2, getFormat(), uri, z2, str5, true, z, i, i2, z3, j);
            if (!sendSmsByCarrierApp(false, smsTracker)) {
                sendSubmitPdu(smsTracker);
                return;
            }
            return;
        }
        Rlog.e(TAG, "SmsDispatcher.sendText(): getSubmitPdu() returned null " + SmsController.formatCrossStackMessageId(j));
        triggerSentIntentForFailure(pendingIntent);
    }

    private void triggerSentIntentForFailure(PendingIntent pendingIntent) {
        if (pendingIntent != null) {
            try {
                pendingIntent.send(1);
            } catch (PendingIntent.CanceledException unused) {
                Rlog.e(TAG, "Intent has been canceled!");
            }
        }
    }

    /* access modifiers changed from: protected */
    public void triggerSentIntentForFailure(List<PendingIntent> list) {
        if (list != null) {
            for (PendingIntent triggerSentIntentForFailure : list) {
                triggerSentIntentForFailure(triggerSentIntentForFailure);
            }
        }
    }

    /* access modifiers changed from: protected */
    public boolean sendSmsByCarrierApp(boolean z, SmsTracker smsTracker) {
        SmsSender smsSender;
        String carrierAppPackageName = getCarrierAppPackageName();
        if (carrierAppPackageName == null) {
            return false;
        }
        Rlog.d(TAG, "Found carrier package " + carrierAppPackageName);
        if (z) {
            smsSender = new DataSmsSender(smsTracker);
        } else {
            smsSender = new TextSmsSender(smsTracker);
        }
        smsSender.sendSmsByCarrierApp(carrierAppPackageName, new SmsSenderCallback(smsSender));
        return true;
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PROTECTED)
    public void sendMultipartText(String str, String str2, ArrayList<String> arrayList, ArrayList<PendingIntent> arrayList2, ArrayList<PendingIntent> arrayList3, Uri uri, String str3, boolean z, int i, boolean z2, int i2, long j) {
        PendingIntent pendingIntent;
        ArrayList<PendingIntent> arrayList4;
        ArrayList<PendingIntent> arrayList5 = arrayList2;
        ArrayList<PendingIntent> arrayList6 = arrayList3;
        String multipartMessageText = getMultipartMessageText(arrayList);
        int nextConcatenatedRef = getNextConcatenatedRef() & 255;
        int size = arrayList.size();
        if (size < 1) {
            triggerSentIntentForFailure((List<PendingIntent>) arrayList5);
            return;
        }
        GsmAlphabet.TextEncodingDetails[] textEncodingDetailsArr = new GsmAlphabet.TextEncodingDetails[size];
        int i3 = size;
        int i4 = nextConcatenatedRef;
        int onSendMultipartText = onSendMultipartText(str, str2, arrayList, arrayList2, arrayList3, uri, str3, z, i, z2, i2, textEncodingDetailsArr);
        SmsTracker[] smsTrackerArr = new SmsTracker[i3];
        AtomicInteger atomicInteger = new AtomicInteger(i3);
        boolean z3 = false;
        AtomicBoolean atomicBoolean = new AtomicBoolean(false);
        int i5 = 0;
        while (i5 < i3) {
            SmsHeader.ConcatRef concatRef = new SmsHeader.ConcatRef();
            concatRef.refNumber = i4;
            int i6 = i5 + 1;
            concatRef.seqNumber = i6;
            concatRef.msgCount = i3;
            concatRef.isEightBits = true;
            SmsHeader makeSmsHeader = TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName()).makeSmsHeader();
            makeSmsHeader.concatRef = concatRef;
            if (onSendMultipartText == 1) {
                GsmAlphabet.TextEncodingDetails textEncodingDetails = textEncodingDetailsArr[i5];
                makeSmsHeader.languageTable = textEncodingDetails.languageTable;
                makeSmsHeader.languageShiftTable = textEncodingDetails.languageShiftTable;
            }
            PendingIntent pendingIntent2 = null;
            if (arrayList5 == null || arrayList2.size() <= i5) {
                arrayList4 = arrayList3;
                pendingIntent = null;
            } else {
                arrayList4 = arrayList3;
                pendingIntent = arrayList5.get(i5);
            }
            if (arrayList4 != null && arrayList3.size() > i5) {
                pendingIntent2 = arrayList4.get(i5);
            }
            int i7 = i4;
            int i8 = i6;
            boolean z4 = z3;
            AtomicBoolean atomicBoolean2 = atomicBoolean;
            AtomicInteger atomicInteger2 = atomicInteger;
            int i9 = onSendMultipartText;
            int i10 = i3;
            SmsTracker newSubmitPduTracker = getNewSubmitPduTracker(str3, str, str2, arrayList.get(i5), makeSmsHeader, onSendMultipartText, pendingIntent, pendingIntent2, i5 == i3 + -1 ? true : z3, atomicInteger, atomicBoolean2, uri, multipartMessageText, i, z2, i2, j);
            SmsTracker[] smsTrackerArr2 = smsTrackerArr;
            smsTrackerArr2[i5] = newSubmitPduTracker;
            if (newSubmitPduTracker == null) {
                triggerSentIntentForFailure((List<PendingIntent>) arrayList2);
                return;
            }
            newSubmitPduTracker.mPersistMessage = z;
            smsTrackerArr = smsTrackerArr2;
            arrayList5 = arrayList2;
            i4 = i7;
            i5 = i8;
            z3 = z4;
            atomicBoolean = atomicBoolean2;
            atomicInteger = atomicInteger2;
            onSendMultipartText = i9;
            i3 = i10;
        }
        SmsTracker[] smsTrackerArr3 = smsTrackerArr;
        String carrierAppPackageName = getCarrierAppPackageName();
        if (carrierAppPackageName != null) {
            Rlog.d(TAG, "Found carrier package " + carrierAppPackageName + " " + SmsController.formatCrossStackMessageId(getMultiTrackermessageId(smsTrackerArr3)));
            MultipartSmsSender multipartSmsSender = new MultipartSmsSender(arrayList, smsTrackerArr3);
            multipartSmsSender.sendSmsByCarrierApp(carrierAppPackageName, new MultipartSmsSenderCallback(multipartSmsSender));
            return;
        }
        Rlog.v(TAG, "No carrier package. " + SmsController.formatCrossStackMessageId(getMultiTrackermessageId(smsTrackerArr3)));
        sendSubmitPdu(smsTrackerArr3);
    }

    private long getMultiTrackermessageId(SmsTracker[] smsTrackerArr) {
        if (smsTrackerArr.length == 0) {
            return 0;
        }
        return smsTrackerArr[0].mMessageId;
    }

    /* access modifiers changed from: protected */
    public SmsTracker getNewSubmitPduTracker(String str, String str2, String str3, String str4, SmsHeader smsHeader, int i, PendingIntent pendingIntent, PendingIntent pendingIntent2, boolean z, AtomicInteger atomicInteger, AtomicBoolean atomicBoolean, Uri uri, String str5, int i2, boolean z2, int i3, long j) {
        int i4;
        boolean z3;
        String str6 = str2;
        String str7 = str3;
        String str8 = str4;
        SmsHeader smsHeader2 = smsHeader;
        if (isCdmaMo()) {
            UserData userData = new UserData();
            userData.payloadStr = str8;
            userData.userDataHeader = smsHeader2;
            if (i == 1) {
                userData.msgEncoding = isAscii7bitSupportedForLongMessage() ? 2 : 9;
                Rlog.d(TAG, "Message encoding for proper 7 bit: " + userData.msgEncoding);
            } else {
                userData.msgEncoding = 4;
            }
            userData.msgEncodingSet = true;
            if (pendingIntent2 == null || !z) {
                i4 = i2;
                z3 = false;
            } else {
                i4 = i2;
                z3 = true;
            }
            SmsMessage.SubmitPdu submitPdu = SmsMessage.getSubmitPdu(str6, userData, z3, i4);
            if (submitPdu != null) {
                return getSmsTracker(str, getSmsTrackerMap(str6, str7, str8, submitPdu), pendingIntent, pendingIntent2, getFormat(), atomicInteger, atomicBoolean, uri, smsHeader, !z || z2, str5, true, true, i2, i3, false, j);
            }
            Rlog.e(TAG, "CdmaSMSDispatcher.getNewSubmitPduTracker(): getSubmitPdu() returned null " + SmsController.formatCrossStackMessageId(j));
            return null;
        }
        int i5 = i;
        SmsMessage.SubmitPdu submitPdu2 = com.android.internal.telephony.gsm.SmsMessage.getSubmitPdu(str3, str2, str4, pendingIntent2 != null, SmsHeader.toByteArray(smsHeader), i, smsHeader2.languageTable, smsHeader2.languageShiftTable, i3);
        if (submitPdu2 != null) {
            return getSmsTracker(str, getSmsTrackerMap(str6, str7, str8, submitPdu2), pendingIntent, pendingIntent2, getFormat(), atomicInteger, atomicBoolean, uri, smsHeader, !z || z2, str5, true, false, i2, i3, false, j);
        }
        Rlog.e(TAG, "GsmSMSDispatcher.getNewSubmitPduTracker(): getSubmitPdu() returned null " + SmsController.formatCrossStackMessageId(j));
        return null;
    }

    @VisibleForTesting
    public void sendRawPdu(SmsTracker[] smsTrackerArr) {
        int i;
        PackageInfo packageInfo = null;
        if (this.mSmsSendDisabled) {
            Rlog.e(TAG, "Device does not support sending sms.");
            i = 4;
        } else {
            int length = smsTrackerArr.length;
            int i2 = 0;
            while (true) {
                if (i2 >= length) {
                    i = 0;
                    break;
                } else if (smsTrackerArr[i2].getData().get(MAP_KEY_PDU) == null) {
                    Rlog.e(TAG, "Empty PDU");
                    i = 3;
                    break;
                } else {
                    i2++;
                }
            }
            if (i == 0) {
                try {
                    packageInfo = this.mContext.createContextAsUser(UserHandle.of(smsTrackerArr[0].mUserId), 0).getPackageManager().getPackageInfo(smsTrackerArr[0].getAppPackageName(), 64);
                } catch (PackageManager.NameNotFoundException unused) {
                    Rlog.e(TAG, "Can't get calling app package info: refusing to send SMS " + SmsController.formatCrossStackMessageId(getMultiTrackermessageId(smsTrackerArr)));
                    i = 1;
                }
            }
        }
        if (i != 0) {
            handleSmsTrackersFailure(smsTrackerArr, i, -1);
            return;
        }
        if (checkDestination(smsTrackerArr)) {
            if (!this.mSmsDispatchersController.getUsageMonitor().check(packageInfo.packageName, smsTrackerArr.length)) {
                sendMessage(obtainMessage(4, smsTrackerArr));
                return;
            }
            for (SmsTracker sendSms : smsTrackerArr) {
                sendSms(sendSms);
            }
        }
        if (this.mTelephonyManager.isEmergencyNumber(smsTrackerArr[0].mDestAddress)) {
            new AsyncEmergencyContactNotifier(this.mContext).execute(new Void[0]);
        }
    }

    /* access modifiers changed from: protected */
    public boolean checkDestination(SmsTracker[] smsTrackerArr) {
        int i;
        if (this.mContext.checkCallingOrSelfPermission("android.permission.SEND_SMS_NO_CONFIRMATION") != 0 && !smsTrackerArr[0].mIsForVvm) {
            int i2 = this.mPremiumSmsRule.get();
            if (i2 == 1 || i2 == 3) {
                String simCountryIsoForPhone = TelephonyManager.getSimCountryIsoForPhone(this.mPhone.getPhoneId());
                if (simCountryIsoForPhone == null || simCountryIsoForPhone.length() != 2) {
                    Rlog.e(TAG, "Can't get SIM country Iso: trying network country Iso " + SmsController.formatCrossStackMessageId(getMultiTrackermessageId(smsTrackerArr)));
                    simCountryIsoForPhone = this.mTelephonyManager.getNetworkCountryIso(this.mPhone.getPhoneId());
                }
                i = this.mSmsDispatchersController.getUsageMonitor().checkDestination(smsTrackerArr[0].mDestAddress, simCountryIsoForPhone);
            } else {
                i = 0;
            }
            if (i2 == 2 || i2 == 3) {
                String networkCountryIso = this.mTelephonyManager.getNetworkCountryIso(this.mPhone.getPhoneId());
                if (networkCountryIso == null || networkCountryIso.length() != 2) {
                    Rlog.e(TAG, "Can't get Network country Iso: trying SIM country Iso " + SmsController.formatCrossStackMessageId(getMultiTrackermessageId(smsTrackerArr)));
                    networkCountryIso = TelephonyManager.getSimCountryIsoForPhone(this.mPhone.getPhoneId());
                }
                i = SmsUsageMonitor.mergeShortCodeCategories(i, this.mSmsDispatchersController.getUsageMonitor().checkDestination(smsTrackerArr[0].mDestAddress, networkCountryIso));
            }
            if (!(i == 0 || i == 1 || i == 2)) {
                if (Settings.Global.getInt(this.mResolver, "device_provisioned", 0) == 0) {
                    Rlog.e(TAG, "Can't send premium sms during Setup Wizard " + SmsController.formatCrossStackMessageId(getMultiTrackermessageId(smsTrackerArr)));
                    return false;
                }
                int premiumSmsPermission = this.mSmsDispatchersController.getUsageMonitor().getPremiumSmsPermission(smsTrackerArr[0].getAppPackageName());
                if (premiumSmsPermission == 0) {
                    premiumSmsPermission = 1;
                }
                if (premiumSmsPermission == 2) {
                    Rlog.w(TAG, "User denied this app from sending to premium SMS " + SmsController.formatCrossStackMessageId(getMultiTrackermessageId(smsTrackerArr)));
                    sendMessage(obtainMessage(7, smsTrackerArr));
                    return false;
                } else if (premiumSmsPermission != 3) {
                    sendMessage(obtainMessage(i == 3 ? 8 : 9, smsTrackerArr));
                    return false;
                } else {
                    Rlog.d(TAG, "User approved this app to send to premium SMS " + SmsController.formatCrossStackMessageId(getMultiTrackermessageId(smsTrackerArr)));
                    return true;
                }
            }
        }
        return true;
    }

    private boolean denyIfQueueLimitReached(SmsTracker[] smsTrackerArr) {
        int i = this.mPendingTrackerCount;
        if (i >= 5) {
            Rlog.e(TAG, "Denied because queue limit reached " + SmsController.formatCrossStackMessageId(getMultiTrackermessageId(smsTrackerArr)));
            handleSmsTrackersFailure(smsTrackerArr, 5, -1);
            return true;
        }
        this.mPendingTrackerCount = i + 1;
        return false;
    }

    private CharSequence getAppLabel(String str, int i) {
        PackageManager packageManager = this.mContext.getPackageManager();
        try {
            return packageManager.getApplicationInfoAsUser(str, 0, UserHandle.of(i)).loadSafeLabel(packageManager);
        } catch (PackageManager.NameNotFoundException unused) {
            Rlog.e(TAG, "PackageManager Name Not Found for package " + str);
            return str;
        }
    }

    /* access modifiers changed from: protected */
    public void handleReachSentLimit(SmsTracker[] smsTrackerArr) {
        if (!denyIfQueueLimitReached(smsTrackerArr)) {
            CharSequence appLabel = getAppLabel(smsTrackerArr[0].getAppPackageName(), smsTrackerArr[0].mUserId);
            Resources system = Resources.getSystem();
            Spanned fromHtml = Html.fromHtml(system.getString(17041570, new Object[]{appLabel}));
            ConfirmDialogListener confirmDialogListener = new ConfirmDialogListener(smsTrackerArr, (TextView) null, 1);
            AlertDialog create = new AlertDialog.Builder(this.mContext).setTitle(17041572).setIcon(17301642).setMessage(fromHtml).setPositiveButton(system.getString(17041573), confirmDialogListener).setNegativeButton(system.getString(17041571), confirmDialogListener).setOnCancelListener(confirmDialogListener).create();
            create.getWindow().setType(TelephonyProto.TelephonyEvent.RilSetupDataCallResponse.RilDataCallFailCause.PDP_FAIL_MIP_FA_MOBILE_NODE_AUTHENTICATION_FAILURE);
            create.show();
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void handleConfirmShortCode(boolean z, SmsTracker[] smsTrackerArr) {
        if (!denyIfQueueLimitReached(smsTrackerArr)) {
            int i = z ? 17041574 : 17041580;
            CharSequence appLabel = getAppLabel(smsTrackerArr[0].getAppPackageName(), smsTrackerArr[0].mUserId);
            Resources system = Resources.getSystem();
            Spanned fromHtml = Html.fromHtml(system.getString(17041578, new Object[]{appLabel, smsTrackerArr[0].mDestAddress}));
            View inflate = ((LayoutInflater) this.mContext.getSystemService("layout_inflater")).inflate(17367346, (ViewGroup) null);
            ConfirmDialogListener confirmDialogListener = new ConfirmDialogListener(smsTrackerArr, (TextView) inflate.findViewById(16909554), 0);
            ((TextView) inflate.findViewById(16909549)).setText(fromHtml);
            ((TextView) ((ViewGroup) inflate.findViewById(16909550)).findViewById(16909551)).setText(i);
            ((CheckBox) inflate.findViewById(16909552)).setOnCheckedChangeListener(confirmDialogListener);
            AlertDialog create = new AlertDialog.Builder(this.mContext).setView(inflate).setPositiveButton(system.getString(17041575), confirmDialogListener).setNegativeButton(system.getString(17041577), confirmDialogListener).setOnCancelListener(confirmDialogListener).create();
            create.getWindow().setType(TelephonyProto.TelephonyEvent.RilSetupDataCallResponse.RilDataCallFailCause.PDP_FAIL_MIP_FA_MOBILE_NODE_AUTHENTICATION_FAILURE);
            create.show();
            confirmDialogListener.setPositiveButton(create.getButton(-1));
            confirmDialogListener.setNegativeButton(create.getButton(-2));
        }
    }

    public void sendRetrySms(SmsTracker smsTracker) {
        SmsDispatchersController smsDispatchersController = this.mSmsDispatchersController;
        if (smsDispatchersController != null) {
            smsDispatchersController.sendRetrySms(smsTracker);
            return;
        }
        Rlog.e(TAG, this.mSmsDispatchersController + " is null. Retry failed " + SmsController.formatCrossStackMessageId(smsTracker.mMessageId));
    }

    private void handleSmsTrackersFailure(SmsTracker[] smsTrackerArr, int i, int i2) {
        for (SmsTracker onFailed : smsTrackerArr) {
            onFailed.onFailed(this.mContext, i, i2);
        }
        if (smsTrackerArr.length > 0) {
            SmsStats smsStats = this.mPhone.getSmsStats();
            boolean isIms = isIms();
            boolean equals = "3gpp2".equals(getFormat());
            SmsTracker smsTracker = smsTrackerArr[0];
            smsStats.onOutgoingSms(isIms, equals, false, i, smsTracker.mMessageId, smsTracker.isFromDefaultSmsApplication(this.mContext), smsTrackerArr[0].getInterval());
        }
    }

    public static class SmsTracker {
        protected static String MSG_REF_NUM = "msg_ref_num";
        protected static String PDU_SIZE = "pdu_size";
        private final UUID mAnomalyUnexpectedErrorFromRilUUID = UUID.fromString("43043600-ea7a-44d2-9ae6-a58567ac7886");
        private AtomicBoolean mAnyPartFailed;
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public final PackageInfo mAppInfo;
        private int mCarrierId;
        @UnsupportedAppUsage
        public final HashMap<String, Object> mData;
        @UnsupportedAppUsage
        public final PendingIntent mDeliveryIntent;
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public final String mDestAddress;
        public boolean mExpectMore;
        public String mFormat;
        public String mFullMessageText;
        public int mImsRetry;
        /* access modifiers changed from: private */
        public final boolean mIsForVvm;
        private Boolean mIsFromDefaultSmsApplication;
        private boolean mIsText;
        public final long mMessageId;
        @UnsupportedAppUsage
        public int mMessageRef;
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public Uri mMessageUri;
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public boolean mPersistMessage;
        public int mPriority;
        public int mRetryCount;
        @UnsupportedAppUsage
        public final PendingIntent mSentIntent;
        public final SmsHeader mSmsHeader;
        public int mSubId;
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        private long mTimestamp = SystemClock.elapsedRealtime();
        /* access modifiers changed from: private */
        public AtomicInteger mUnsentPartCount;
        public final int mUserId;
        public boolean mUsesImsServiceForIms;
        public int mValidityPeriod;

        public SmsTracker(HashMap<String, Object> hashMap, PendingIntent pendingIntent, PendingIntent pendingIntent2, PackageInfo packageInfo, String str, String str2, AtomicInteger atomicInteger, AtomicBoolean atomicBoolean, Uri uri, SmsHeader smsHeader, boolean z, String str3, int i, boolean z2, boolean z3, int i2, int i3, int i4, boolean z4, long j, int i5) {
            this.mData = hashMap;
            this.mSentIntent = pendingIntent;
            this.mDeliveryIntent = pendingIntent2;
            this.mRetryCount = 0;
            this.mAppInfo = packageInfo;
            this.mDestAddress = str;
            this.mFormat = str2;
            this.mExpectMore = z;
            this.mImsRetry = 0;
            this.mUsesImsServiceForIms = false;
            this.mMessageRef = 0;
            this.mUnsentPartCount = atomicInteger;
            this.mAnyPartFailed = atomicBoolean;
            this.mMessageUri = uri;
            this.mSmsHeader = smsHeader;
            this.mFullMessageText = str3;
            this.mSubId = i;
            this.mIsText = z2;
            this.mPersistMessage = z3;
            this.mUserId = i2;
            this.mPriority = i3;
            this.mValidityPeriod = i4;
            this.mIsForVvm = z4;
            this.mMessageId = j;
            this.mCarrierId = i5;
        }

        public HashMap<String, Object> getData() {
            return this.mData;
        }

        public String getAppPackageName() {
            PackageInfo packageInfo = this.mAppInfo;
            if (packageInfo != null) {
                return packageInfo.packageName;
            }
            return null;
        }

        public boolean isFromDefaultSmsApplication(Context context) {
            if (this.mIsFromDefaultSmsApplication == null) {
                this.mIsFromDefaultSmsApplication = Boolean.valueOf(SmsApplication.isDefaultSmsApplication(context, getAppPackageName(), this.mUserId));
            }
            return this.mIsFromDefaultSmsApplication.booleanValue();
        }

        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public void updateSentMessageStatus(Context context, int i) {
            if (this.mMessageUri != null) {
                ContentValues contentValues = new ContentValues(1);
                contentValues.put(NotificationCompat.CATEGORY_STATUS, Integer.valueOf(i));
                context.getContentResolver().update(this.mMessageUri, contentValues, (String) null, (String[]) null);
            }
        }

        private void updateMessageState(Context context, int i, int i2) {
            if (this.mMessageUri != null) {
                ContentValues contentValues = new ContentValues(2);
                contentValues.put("type", Integer.valueOf(i));
                contentValues.put("error_code", Integer.valueOf(i2));
                long clearCallingIdentity = Binder.clearCallingIdentity();
                try {
                    if (context.getContentResolver().update(this.mMessageUri, contentValues, (String) null, (String[]) null) != 1) {
                        Rlog.e(SMSDispatcher.TAG, "Failed to move message to " + i);
                    }
                } finally {
                    Binder.restoreCallingIdentity(clearCallingIdentity);
                }
            }
        }

        /* access modifiers changed from: protected */
        public long getInterval() {
            return SystemClock.elapsedRealtime() - this.mTimestamp;
        }

        private Uri persistSentMessageIfRequired(Context context, int i, int i2) {
            if (!this.mIsText || !this.mPersistMessage || isFromDefaultSmsApplication(context)) {
                return null;
            }
            StringBuilder sb = new StringBuilder();
            sb.append("Persist SMS into ");
            sb.append(i == 5 ? "FAILED" : "SENT");
            Rlog.d(SMSDispatcher.TAG, sb.toString());
            ContentValues contentValues = new ContentValues();
            contentValues.put("sub_id", Integer.valueOf(this.mSubId));
            contentValues.put("address", this.mDestAddress);
            contentValues.put("body", this.mFullMessageText);
            contentValues.put("date", Long.valueOf(System.currentTimeMillis()));
            contentValues.put("seen", 1);
            contentValues.put("read", 1);
            PackageInfo packageInfo = this.mAppInfo;
            String str = packageInfo != null ? packageInfo.packageName : null;
            if (!TextUtils.isEmpty(str)) {
                contentValues.put("creator", str);
            }
            if (this.mDeliveryIntent != null) {
                contentValues.put(NotificationCompat.CATEGORY_STATUS, 32);
            }
            if (i2 != -1) {
                contentValues.put("error_code", Integer.valueOf(i2));
            }
            long clearCallingIdentity = Binder.clearCallingIdentity();
            ContentResolver contentResolver = context.getContentResolver();
            try {
                Uri insert = contentResolver.insert(Telephony.Sms.Sent.CONTENT_URI, contentValues);
                if (insert != null && i == 5) {
                    ContentValues contentValues2 = new ContentValues(1);
                    contentValues2.put("type", 5);
                    contentResolver.update(insert, contentValues2, (String) null, (String[]) null);
                }
                return insert;
            } catch (Exception e) {
                Rlog.e(SMSDispatcher.TAG, "writeOutboxMessage: Failed to persist outbox message", e);
                return null;
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        }

        /* access modifiers changed from: private */
        public void persistOrUpdateMessage(Context context, int i, int i2) {
            if (this.mMessageUri != null) {
                updateMessageState(context, i, i2);
            } else {
                this.mMessageUri = persistSentMessageIfRequired(context, i, i2);
            }
        }

        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public void onFailed(Context context, int i, int i2) {
            AtomicBoolean atomicBoolean = this.mAnyPartFailed;
            if (atomicBoolean != null) {
                atomicBoolean.set(true);
            }
            AtomicInteger atomicInteger = this.mUnsentPartCount;
            boolean z = atomicInteger == null || atomicInteger.decrementAndGet() == 0;
            if (z) {
                new AsyncPersistOrUpdateTask(context, 5, i2, i, true).execute(new Void[0]);
            } else if (this.mSentIntent != null) {
                try {
                    Intent intent = new Intent();
                    Uri uri = this.mMessageUri;
                    if (uri != null) {
                        intent.putExtra("uri", uri.toString());
                    }
                    if (i2 != -1) {
                        intent.putExtra("errorCode", i2);
                    }
                    if (this.mUnsentPartCount != null && z) {
                        intent.putExtra(SMSDispatcher.SEND_NEXT_MSG_EXTRA, true);
                    }
                    long j = this.mMessageId;
                    if (j != 0) {
                        intent.putExtra(SMSDispatcher.MESSAGE_ID_EXTRA, j);
                    }
                    intent.putExtra("format", this.mFormat);
                    intent.putExtra("ims", this.mUsesImsServiceForIms);
                    putPduSize(intent);
                    this.mSentIntent.send(context, i, intent);
                } catch (PendingIntent.CanceledException unused) {
                    Rlog.e(SMSDispatcher.TAG, "Failed to send result " + SmsController.formatCrossStackMessageId(this.mMessageId));
                }
            }
        }

        private void putPduSize(Intent intent) {
            HashMap<String, Object> hashMap = this.mData;
            int i = 0;
            if (hashMap != null) {
                int length = hashMap.get(SMSDispatcher.MAP_KEY_SMSC) != null ? ((byte[]) this.mData.get(SMSDispatcher.MAP_KEY_SMSC)).length : 0;
                if (this.mData.get(SMSDispatcher.MAP_KEY_PDU) != null) {
                    i = ((byte[]) this.mData.get(SMSDispatcher.MAP_KEY_PDU)).length;
                }
                i += length;
            }
            intent.putExtra(PDU_SIZE, i);
        }

        private void reportAnomaly(int i, int i2) {
            if (i != 2 && i != 29 && i != 4 && i != 5 && i != 7 && i != 8) {
                Rlog.d(SMSDispatcher.TAG, "SMS failed" + " with error " + i + ", errorCode " + i2);
                AnomalyReporter.reportAnomaly(generateUUID(i, i2), "SMS failed", this.mCarrierId);
            }
        }

        private UUID generateUUID(int i, int i2) {
            return new UUID(this.mAnomalyUnexpectedErrorFromRilUUID.getMostSignificantBits(), this.mAnomalyUnexpectedErrorFromRilUUID.getLeastSignificantBits() + (((long) i2) << 32) + ((long) i));
        }

        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public void onSent(Context context) {
            AtomicInteger atomicInteger = this.mUnsentPartCount;
            boolean z = atomicInteger == null || atomicInteger.decrementAndGet() == 0;
            if (z) {
                int i = 2;
                AtomicBoolean atomicBoolean = this.mAnyPartFailed;
                if (atomicBoolean != null && atomicBoolean.get()) {
                    i = 5;
                }
                new AsyncPersistOrUpdateTask(context, i, 0, 0, false).execute(new Void[0]);
            } else if (this.mSentIntent != null) {
                try {
                    Intent intent = new Intent();
                    Uri uri = this.mMessageUri;
                    if (uri != null) {
                        intent.putExtra("uri", uri.toString());
                    }
                    if (this.mUnsentPartCount != null && z) {
                        intent.putExtra(SMSDispatcher.SEND_NEXT_MSG_EXTRA, true);
                    }
                    intent.putExtra("format", this.mFormat);
                    intent.putExtra("ims", this.mUsesImsServiceForIms);
                    putPduSize(intent);
                    intent.putExtra(MSG_REF_NUM, this.mMessageRef);
                    Rlog.d(SMSDispatcher.TAG, "message reference number : " + this.mMessageRef);
                    this.mSentIntent.send(context, -1, intent);
                } catch (PendingIntent.CanceledException unused) {
                    Rlog.e(SMSDispatcher.TAG, "Failed to send result");
                }
            }
        }

        class AsyncPersistOrUpdateTask extends AsyncTask<Void, Void, Void> {
            private final Context mContext;
            private int mError;
            private int mErrorCode;
            private boolean mFail;
            private int mMessageType;

            public AsyncPersistOrUpdateTask(Context context, int i, int i2, int i3, boolean z) {
                this.mContext = context;
                this.mMessageType = i;
                this.mErrorCode = i2;
                this.mError = i3;
                this.mFail = z;
            }

            /* access modifiers changed from: protected */
            public Void doInBackground(Void... voidArr) {
                SmsTracker.this.persistOrUpdateMessage(this.mContext, this.mMessageType, this.mErrorCode);
                return null;
            }

            /* access modifiers changed from: protected */
            public void onPostExecute(Void voidR) {
                int i;
                if (SmsTracker.this.mSentIntent != null) {
                    try {
                        Intent intent = new Intent();
                        Uri uri = SmsTracker.this.mMessageUri;
                        if (uri != null) {
                            intent.putExtra("uri", uri.toString());
                        }
                        if (this.mFail && (i = this.mErrorCode) != 0) {
                            intent.putExtra("errorCode", i);
                        }
                        if (SmsTracker.this.mUnsentPartCount != null) {
                            intent.putExtra(SMSDispatcher.SEND_NEXT_MSG_EXTRA, true);
                        }
                        HashMap<String, Object> hashMap = SmsTracker.this.mData;
                        int i2 = 0;
                        if (hashMap != null) {
                            int length = hashMap.get(SMSDispatcher.MAP_KEY_SMSC) != null ? ((byte[]) SmsTracker.this.mData.get(SMSDispatcher.MAP_KEY_SMSC)).length : 0;
                            if (SmsTracker.this.mData.get(SMSDispatcher.MAP_KEY_PDU) != null) {
                                i2 = ((byte[]) SmsTracker.this.mData.get(SMSDispatcher.MAP_KEY_PDU)).length;
                            }
                            i2 += length;
                        }
                        intent.putExtra(SmsTracker.PDU_SIZE, i2);
                        if (!this.mFail) {
                            intent.putExtra(SmsTracker.MSG_REF_NUM, SmsTracker.this.mMessageRef);
                            Rlog.d(SMSDispatcher.TAG, "message reference number : " + SmsTracker.this.mMessageRef);
                            SmsTracker.this.mSentIntent.send(this.mContext, -1, intent);
                            return;
                        }
                        SmsTracker.this.mSentIntent.send(this.mContext, this.mError, intent);
                    } catch (PendingIntent.CanceledException unused) {
                        Rlog.e(SMSDispatcher.TAG, "Failed to send result");
                    }
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    public SmsTracker getSmsTracker(String str, HashMap<String, Object> hashMap, PendingIntent pendingIntent, PendingIntent pendingIntent2, String str2, AtomicInteger atomicInteger, AtomicBoolean atomicBoolean, Uri uri, SmsHeader smsHeader, boolean z, String str3, boolean z2, boolean z3, int i, int i2, boolean z4, long j) {
        PackageInfo packageInfo;
        UserHandle userHandleForUid = UserHandle.getUserHandleForUid(Binder.getCallingUid());
        int identifier = userHandleForUid.getIdentifier();
        try {
            packageInfo = this.mContext.createContextAsUser(userHandleForUid, 0).getPackageManager().getPackageInfo(str, 64);
        } catch (PackageManager.NameNotFoundException unused) {
            packageInfo = null;
        }
        HashMap<String, Object> hashMap2 = hashMap;
        return new SmsTracker(hashMap2, pendingIntent, pendingIntent2, packageInfo, PhoneNumberUtils.extractNetworkPortion((String) hashMap2.get(MAP_KEY_DEST_ADDR)), str2, atomicInteger, atomicBoolean, uri, smsHeader, z, str3, getSubId(), z2, z3, identifier, i, i2, z4, j, this.mPhone.getCarrierId());
    }

    /* access modifiers changed from: protected */
    public SmsTracker getSmsTracker(String str, HashMap<String, Object> hashMap, PendingIntent pendingIntent, PendingIntent pendingIntent2, String str2, Uri uri, boolean z, String str3, boolean z2, boolean z3, boolean z4, long j) {
        return getSmsTracker(str, hashMap, pendingIntent, pendingIntent2, str2, (AtomicInteger) null, (AtomicBoolean) null, uri, (SmsHeader) null, z, str3, z2, z3, -1, -1, z4, j);
    }

    /* access modifiers changed from: protected */
    public SmsTracker getSmsTracker(String str, HashMap<String, Object> hashMap, PendingIntent pendingIntent, PendingIntent pendingIntent2, String str2, Uri uri, boolean z, String str3, boolean z2, boolean z3, int i, int i2, boolean z4, long j) {
        return getSmsTracker(str, hashMap, pendingIntent, pendingIntent2, str2, (AtomicInteger) null, (AtomicBoolean) null, uri, (SmsHeader) null, z, str3, z2, z3, i, i2, z4, j);
    }

    /* access modifiers changed from: protected */
    public HashMap<String, Object> getSmsTrackerMap(String str, String str2, String str3, SmsMessageBase.SubmitPduBase submitPduBase) {
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put(MAP_KEY_DEST_ADDR, str);
        hashMap.put(MAP_KEY_SC_ADDR, str2);
        hashMap.put(MAP_KEY_TEXT, str3);
        hashMap.put(MAP_KEY_SMSC, submitPduBase.encodedScAddress);
        hashMap.put(MAP_KEY_PDU, submitPduBase.encodedMessage);
        return hashMap;
    }

    /* access modifiers changed from: protected */
    public HashMap<String, Object> getSmsTrackerMap(String str, String str2, int i, byte[] bArr, SmsMessageBase.SubmitPduBase submitPduBase) {
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put(MAP_KEY_DEST_ADDR, str);
        hashMap.put(MAP_KEY_SC_ADDR, str2);
        hashMap.put(MAP_KEY_DEST_PORT, Integer.valueOf(i));
        hashMap.put(MAP_KEY_DATA, bArr);
        hashMap.put(MAP_KEY_SMSC, submitPduBase.encodedScAddress);
        hashMap.put(MAP_KEY_PDU, submitPduBase.encodedMessage);
        return hashMap;
    }

    private final class ConfirmDialogListener implements DialogInterface.OnClickListener, DialogInterface.OnCancelListener, CompoundButton.OnCheckedChangeListener {
        private static final int NEVER_ALLOW = 1;
        private static final int RATE_LIMIT = 1;
        private static final int SHORT_CODE_MSG = 0;
        private int mConfirmationType;
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        private Button mNegativeButton;
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        private Button mPositiveButton;
        private boolean mRememberChoice;
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        private final TextView mRememberUndoInstruction;
        private final SmsTracker[] mTrackers;

        ConfirmDialogListener(SmsTracker[] smsTrackerArr, TextView textView, int i) {
            this.mTrackers = smsTrackerArr;
            this.mRememberUndoInstruction = textView;
            this.mConfirmationType = i;
        }

        /* access modifiers changed from: package-private */
        public void setPositiveButton(Button button) {
            this.mPositiveButton = button;
        }

        /* access modifiers changed from: package-private */
        public void setNegativeButton(Button button) {
            this.mNegativeButton = button;
        }

        public void onClick(DialogInterface dialogInterface, int i) {
            int i2 = 1;
            int i3 = -1;
            if (i == -1) {
                Rlog.d(SMSDispatcher.TAG, "CONFIRM sending SMS");
                ApplicationInfo applicationInfo = this.mTrackers[0].mAppInfo.applicationInfo;
                if (applicationInfo != null) {
                    i3 = applicationInfo.uid;
                }
                EventLog.writeEvent(EventLogTags.EXP_DET_SMS_SENT_BY_USER, i3);
                SMSDispatcher sMSDispatcher = SMSDispatcher.this;
                sMSDispatcher.sendMessage(sMSDispatcher.obtainMessage(5, this.mTrackers));
                if (this.mRememberChoice) {
                    i2 = 3;
                }
            } else if (i == -2) {
                Rlog.d(SMSDispatcher.TAG, "DENY sending SMS");
                ApplicationInfo applicationInfo2 = this.mTrackers[0].mAppInfo.applicationInfo;
                if (applicationInfo2 != null) {
                    i3 = applicationInfo2.uid;
                }
                EventLog.writeEvent(EventLogTags.EXP_DET_SMS_DENIED_BY_USER, i3);
                Message obtainMessage = SMSDispatcher.this.obtainMessage(6, this.mTrackers);
                obtainMessage.arg1 = this.mConfirmationType;
                if (this.mRememberChoice) {
                    obtainMessage.arg2 = 1;
                    i2 = 2;
                }
                SMSDispatcher.this.sendMessage(obtainMessage);
            }
            SMSDispatcher.this.mSmsDispatchersController.setPremiumSmsPermission(this.mTrackers[0].getAppPackageName(), i2);
        }

        public void onCancel(DialogInterface dialogInterface) {
            Rlog.d(SMSDispatcher.TAG, "dialog dismissed: don't send SMS");
            Message obtainMessage = SMSDispatcher.this.obtainMessage(6, this.mTrackers);
            obtainMessage.arg1 = this.mConfirmationType;
            SMSDispatcher.this.sendMessage(obtainMessage);
        }

        public void onCheckedChanged(CompoundButton compoundButton, boolean z) {
            Rlog.d(SMSDispatcher.TAG, "remember this choice: " + z);
            this.mRememberChoice = z;
            if (z) {
                this.mPositiveButton.setText(17041576);
                this.mNegativeButton.setText(17041579);
                TextView textView = this.mRememberUndoInstruction;
                if (textView != null) {
                    textView.setText(17041582);
                    this.mRememberUndoInstruction.setPadding(0, 0, 0, 32);
                    return;
                }
                return;
            }
            this.mPositiveButton.setText(17041575);
            this.mNegativeButton.setText(17041577);
            TextView textView2 = this.mRememberUndoInstruction;
            if (textView2 != null) {
                textView2.setText("");
                this.mRememberUndoInstruction.setPadding(0, 0, 0, 0);
            }
        }
    }

    public boolean isIms() {
        SmsDispatchersController smsDispatchersController = this.mSmsDispatchersController;
        if (smsDispatchersController != null) {
            return smsDispatchersController.isIms();
        }
        Rlog.e(TAG, "mSmsDispatchersController is null");
        return false;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getMultipartMessageText(ArrayList<String> arrayList) {
        StringBuilder sb = new StringBuilder();
        Iterator<String> it = arrayList.iterator();
        while (it.hasNext()) {
            String next = it.next();
            if (next != null) {
                sb.append(next);
            }
        }
        return sb.toString();
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getCarrierAppPackageName() {
        CarrierPrivilegesTracker carrierPrivilegesTracker = this.mPhone.getCarrierPrivilegesTracker();
        if (carrierPrivilegesTracker == null) {
            return null;
        }
        List<String> carrierPackageNamesForIntent = carrierPrivilegesTracker.getCarrierPackageNamesForIntent(new Intent("android.service.carrier.CarrierMessagingService"));
        if (carrierPackageNamesForIntent == null || carrierPackageNamesForIntent.size() != 1) {
            return CarrierSmsUtils.getImsRcsPackageForIntent(this.mContext, this.mPhone, new Intent("android.service.carrier.CarrierMessagingService"));
        }
        return carrierPackageNamesForIntent.get(0);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getSubId() {
        return SubscriptionController.getInstance().getSubIdUsingPhoneId(this.mPhone.getPhoneId());
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void checkCallerIsPhoneOrCarrierApp() {
        int callingUid = Binder.getCallingUid();
        if (UserHandle.getAppId(callingUid) != 1001 && callingUid != 0) {
            try {
                if (UserHandle.getAppId(this.mContext.getPackageManager().getApplicationInfo(getCarrierAppPackageName(), 0).uid) != UserHandle.getAppId(Binder.getCallingUid())) {
                    throw new SecurityException("Caller is not phone or carrier app!");
                }
            } catch (PackageManager.NameNotFoundException unused) {
                throw new SecurityException("Caller is not phone or carrier app!");
            }
        }
    }

    /* access modifiers changed from: protected */
    public boolean isCdmaMo() {
        return this.mSmsDispatchersController.isCdmaMo();
    }

    private boolean isAscii7bitSupportedForLongMessage() {
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            PersistableBundle configForSubId = ((CarrierConfigManager) this.mContext.getSystemService("carrier_config")).getConfigForSubId(this.mPhone.getSubId());
            if (configForSubId != null) {
                return configForSubId.getBoolean("ascii_7_bit_support_for_long_message_bool");
            }
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return false;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        AndroidUtilIndentingPrintWriter androidUtilIndentingPrintWriter = new AndroidUtilIndentingPrintWriter(printWriter, "  ");
        androidUtilIndentingPrintWriter.println(TAG);
        androidUtilIndentingPrintWriter.increaseIndent();
        androidUtilIndentingPrintWriter.println("mLocalLog:");
        androidUtilIndentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, androidUtilIndentingPrintWriter, strArr);
        androidUtilIndentingPrintWriter.decreaseIndent();
        androidUtilIndentingPrintWriter.decreaseIndent();
    }

    /* access modifiers changed from: protected */
    public SmsMessageBase.SubmitPduBase onSendData(String str, String str2, int i, byte[] bArr, PendingIntent pendingIntent, PendingIntent pendingIntent2) {
        return getSubmitPdu(str2, str, i, bArr, pendingIntent2 != null);
    }

    /* access modifiers changed from: protected */
    public SmsMessageBase.SubmitPduBase onSendText(String str, String str2, String str3, PendingIntent pendingIntent, PendingIntent pendingIntent2, Uri uri, String str4, boolean z, int i, boolean z2, int i2) {
        return getSubmitPdu(str2, str, str3, pendingIntent2 != null, (SmsHeader) null, i, i2);
    }

    /* access modifiers changed from: protected */
    public int onSendMultipartText(String str, String str2, ArrayList<String> arrayList, ArrayList<PendingIntent> arrayList2, ArrayList<PendingIntent> arrayList3, Uri uri, String str3, boolean z, int i, boolean z2, int i2, GsmAlphabet.TextEncodingDetails[] textEncodingDetailsArr) {
        int size = arrayList.size();
        int i3 = 0;
        for (int i4 = 0; i4 < size; i4++) {
            GsmAlphabet.TextEncodingDetails calculateLength = calculateLength(arrayList.get(i4), false);
            int i5 = calculateLength.codeUnitSize;
            if (i3 != i5 && (i3 == 0 || i3 == 1)) {
                i3 = i5;
            }
            textEncodingDetailsArr[i4] = calculateLength;
        }
        return i3;
    }
}
