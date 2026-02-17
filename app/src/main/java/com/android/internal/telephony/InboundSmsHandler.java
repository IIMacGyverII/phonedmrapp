package com.android.internal.telephony;

import android.app.BroadcastOptions;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.compat.annotation.UnsupportedAppUsage;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.IPackageManager;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.database.SQLException;
import android.net.Uri;
import android.os.AsyncResult;
import android.os.Bundle;
import android.os.Message;
import android.os.PowerManager;
import android.os.PowerWhitelistManager;
import android.os.RemoteException;
import android.os.ServiceManager;
import android.os.UserHandle;
import android.os.UserManager;
import android.os.storage.StorageManager;
import android.provider.Telephony;
import android.telephony.SmsMessage;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CarrierServicesSmsFilter;
import com.android.internal.telephony.SmsConstants;
import com.android.internal.telephony.SmsHeader;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import com.android.internal.telephony.util.NotificationChannelController;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import com.mediatek.gnssdebugreport.DebugDataReport;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

public abstract class InboundSmsHandler extends StateMachine {
    /* access modifiers changed from: private */
    public static String ACTION_OPEN_SMS_APP = "com.android.internal.telephony.OPEN_DEFAULT_SMS_APP";
    public static final int ADDRESS_COLUMN = 6;
    public static final int COUNT_COLUMN = 5;
    public static final int DATE_COLUMN = 3;
    protected static final boolean DBG = true;
    public static final int DELETED_FLAG_COLUMN = 10;
    public static final int DESTINATION_PORT_COLUMN = 2;
    public static final int DISPLAY_ADDRESS_COLUMN = 9;
    public static final int EVENT_BROADCAST_COMPLETE = 3;
    public static final int EVENT_BROADCAST_SMS = 2;
    public static final int EVENT_INJECT_SMS = 7;
    public static final int EVENT_NEW_SMS = 1;
    public static final int EVENT_RECEIVER_TIMEOUT = 9;
    private static final int EVENT_RELEASE_WAKELOCK = 5;
    protected static final int EVENT_RETURN_TO_IDLE = 4;
    public static final int EVENT_START_ACCEPTING_SMS = 6;
    public static final int EVENT_UPDATE_TRACKER = 8;
    public static final int ID_COLUMN = 7;
    public static final int MESSAGE_BODY_COLUMN = 8;
    @VisibleForTesting
    public static final int NOTIFICATION_ID_NEW_MESSAGE = 1;
    @VisibleForTesting
    public static final String NOTIFICATION_TAG = "InboundSmsHandler";
    public static final int PDU_COLUMN = 0;
    protected static final String[] PDU_DELETED_FLAG_PROJECTION = {"pdu", "deleted"};
    private static final Map<Integer, Integer> PDU_DELETED_FLAG_PROJECTION_INDEX_MAPPING = new HashMap<Integer, Integer>() {
        {
            put(0, 0);
            put(10, 1);
        }
    };
    protected static final String[] PDU_SEQUENCE_PORT_PROJECTION = {"pdu", "sequence", "destination_port", "display_originating_addr", "date"};
    protected static final Map<Integer, Integer> PDU_SEQUENCE_PORT_PROJECTION_INDEX_MAPPING = new HashMap<Integer, Integer>() {
        {
            put(0, 0);
            put(1, 1);
            put(2, 2);
            put(9, 3);
            put(3, 4);
        }
    };
    public static final int REFERENCE_NUMBER_COLUMN = 4;
    public static final String SELECT_BY_ID = "_id=?";
    public static final int SEQUENCE_COLUMN = 1;
    public static final int SOURCE_INJECTED_FROM_IMS = 1;
    public static final int SOURCE_INJECTED_FROM_UNKNOWN = 2;
    public static final int SOURCE_NOT_INJECTED = 0;
    public static final int SUBID_COLUMN = 11;
    protected static final boolean VDBG = false;
    private static final int WAKELOCK_TIMEOUT = 3000;
    public static final Uri sRawUri = Uri.withAppendedPath(Telephony.Sms.CONTENT_URI, "raw");
    public static final Uri sRawUriPermanentDelete = Uri.withAppendedPath(Telephony.Sms.CONTENT_URI, "raw/permanentDelete");
    @VisibleForTesting
    public static int sTimeoutDurationMillis = CarrierServicesSmsFilter.FILTER_COMPLETE_TIMEOUT_MS;
    protected final int DELETE_PERMANENTLY = 1;
    protected final int MARK_DELETED = 2;
    private LocalLog mCarrierServiceLocalLog = new LocalLog(8);
    protected CellBroadcastServiceManager mCellBroadcastServiceManager;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final Context mContext;
    protected DefaultState mDefaultState = new DefaultState();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected DeliveringState mDeliveringState = new DeliveringState();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected IdleState mIdleState = new IdleState();
    private LocalLog mLocalLog = new LocalLog(64);
    protected TelephonyMetrics mMetrics = TelephonyMetrics.getInstance();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected Phone mPhone;
    PowerWhitelistManager mPowerWhitelistManager;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final ContentResolver mResolver;
    private List<SmsFilter> mSmsFilters;
    private final boolean mSmsReceiveDisabled;
    protected StartupState mStartupState = new StartupState();
    public SmsStorageMonitor mStorageMonitor;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected UserManager mUserManager;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected WaitingState mWaitingState = new WaitingState();
    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public final PowerManager.WakeLock mWakeLock;
    private int mWakeLockTimeout;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final WapPushOverSms mWapPush;

    @VisibleForTesting
    public interface SmsFilter {
        boolean filterSms(byte[][] bArr, int i, InboundSmsTracker inboundSmsTracker, SmsBroadcastReceiver smsBroadcastReceiver, boolean z, boolean z2, List<SmsFilter> list);
    }

    @Retention(RetentionPolicy.SOURCE)
    public @interface SmsSource {
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public boolean isSkipNotifyFlagSet(int i) {
        return (i & 2) > 0;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public abstract void acknowledgeLastIncomingSms(boolean z, int i, Message message);

    /* access modifiers changed from: protected */
    public abstract int dispatchMessageRadioSpecific(SmsMessageBase smsMessageBase, int i);

    /* access modifiers changed from: protected */
    public abstract boolean is3gpp2();

    /* access modifiers changed from: protected */
    public boolean onCheckIfOverrideStates() {
        return false;
    }

    /* access modifiers changed from: protected */
    public boolean onCheckIfStopProcessMessagePart(byte[][] bArr, String str, InboundSmsTracker inboundSmsTracker) {
        return false;
    }

    /* access modifiers changed from: protected */
    public String[] onModifyQueryWhereArgs(String[] strArr) {
        return strArr;
    }

    protected InboundSmsHandler(String str, Context context, SmsStorageMonitor smsStorageMonitor, Phone phone) {
        super(str);
        this.mContext = context;
        this.mStorageMonitor = smsStorageMonitor;
        this.mPhone = phone;
        this.mResolver = context.getContentResolver();
        this.mWapPush = TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName()).makeWapPushOverSms(context);
        this.mSmsReceiveDisabled = !TelephonyManager.from(context).getSmsReceiveCapableForPhone(this.mPhone.getPhoneId(), context.getResources().getBoolean(17891765));
        PowerManager.WakeLock newWakeLock = ((PowerManager) context.getSystemService(XmlTagConst.TAG_POWER)).newWakeLock(1, str);
        this.mWakeLock = newWakeLock;
        newWakeLock.acquire();
        this.mUserManager = (UserManager) context.getSystemService("user");
        this.mPowerWhitelistManager = (PowerWhitelistManager) context.getSystemService("power_whitelist");
        this.mCellBroadcastServiceManager = new CellBroadcastServiceManager(context, phone);
        this.mSmsFilters = createDefaultSmsFilters();
        if (!onCheckIfOverrideStates()) {
            addState(this.mDefaultState);
            addState(this.mStartupState, this.mDefaultState);
            addState(this.mIdleState, this.mDefaultState);
            addState(this.mDeliveringState, this.mDefaultState);
            addState(this.mWaitingState, this.mDeliveringState);
            setInitialState(this.mStartupState);
        }
        log("created InboundSmsHandler");
    }

    public void dispose() {
        quit();
    }

    /* access modifiers changed from: protected */
    public void onQuitting() {
        this.mWapPush.dispose();
        this.mCellBroadcastServiceManager.disable();
        while (this.mWakeLock.isHeld()) {
            this.mWakeLock.release();
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Phone getPhone() {
        return this.mPhone;
    }

    /* access modifiers changed from: protected */
    public String getWhatToString(int i) {
        switch (i) {
            case 1:
                return "EVENT_NEW_SMS";
            case 2:
                return "EVENT_BROADCAST_SMS";
            case 3:
                return "EVENT_BROADCAST_COMPLETE";
            case 4:
                return "EVENT_RETURN_TO_IDLE";
            case 5:
                return "EVENT_RELEASE_WAKELOCK";
            case 6:
                return "EVENT_START_ACCEPTING_SMS";
            case 7:
                return "EVENT_INJECT_SMS";
            case 8:
                return "EVENT_UPDATE_TRACKER";
            case 9:
                return "EVENT_RECEIVER_TIMEOUT";
            default:
                return "UNKNOWN EVENT " + i;
        }
    }

    public class DefaultState extends State {
        public DefaultState() {
        }

        public boolean processMessage(Message message) {
            int i = message.what;
            String str = "processMessage: unhandled message type " + InboundSmsHandler.this.getWhatToString(message.what) + " currState=" + InboundSmsHandler.this.getCurrentState().getName();
            if (TelephonyUtils.IS_DEBUGGABLE) {
                InboundSmsHandler.this.loge("---- Dumping InboundSmsHandler ----");
                InboundSmsHandler.this.loge("Total records=" + InboundSmsHandler.this.getLogRecCount());
                for (int max = Math.max(InboundSmsHandler.this.getLogRecSize() + -20, 0); max < InboundSmsHandler.this.getLogRecSize(); max++) {
                    InboundSmsHandler.this.loge("Rec[%d]: %s\n" + max + InboundSmsHandler.this.getLogRec(max).toString());
                }
                InboundSmsHandler.this.loge("---- Dumped InboundSmsHandler ----");
                throw new RuntimeException(str);
            }
            InboundSmsHandler.this.loge(str);
            return true;
        }
    }

    public class StartupState extends State {
        public StartupState() {
        }

        public void enter() {
            InboundSmsHandler.this.log("StartupState.enter: entering StartupState");
            InboundSmsHandler.this.setWakeLockTimeout(0);
        }

        public boolean processMessage(Message message) {
            InboundSmsHandler inboundSmsHandler = InboundSmsHandler.this;
            inboundSmsHandler.log("StartupState.processMessage: processing " + InboundSmsHandler.this.getWhatToString(message.what));
            int i = message.what;
            if (!(i == 1 || i == 2)) {
                if (i == 6) {
                    InboundSmsHandler inboundSmsHandler2 = InboundSmsHandler.this;
                    inboundSmsHandler2.transitionTo(inboundSmsHandler2.mIdleState);
                    return true;
                } else if (i != 7) {
                    return false;
                }
            }
            InboundSmsHandler.this.deferMessage(message);
            return true;
        }
    }

    public class IdleState extends State {
        public IdleState() {
        }

        public void enter() {
            InboundSmsHandler.this.log("IdleState.enter: entering IdleState");
            InboundSmsHandler inboundSmsHandler = InboundSmsHandler.this;
            inboundSmsHandler.sendMessageDelayed(5, (long) inboundSmsHandler.getWakeLockTimeout());
        }

        public void exit() {
            InboundSmsHandler.this.mWakeLock.acquire();
            InboundSmsHandler.this.log("IdleState.exit: acquired wakelock, leaving IdleState");
        }

        public boolean processMessage(Message message) {
            InboundSmsHandler inboundSmsHandler = InboundSmsHandler.this;
            inboundSmsHandler.log("IdleState.processMessage: processing " + InboundSmsHandler.this.getWhatToString(message.what));
            int i = message.what;
            if (!(i == 1 || i == 2)) {
                if (i != 4) {
                    if (i == 5) {
                        InboundSmsHandler.this.mWakeLock.release();
                        if (InboundSmsHandler.this.mWakeLock.isHeld()) {
                            InboundSmsHandler.this.log("IdleState.processMessage: EVENT_RELEASE_WAKELOCK: mWakeLock is still held after release");
                        } else {
                            InboundSmsHandler.this.log("IdleState.processMessage: EVENT_RELEASE_WAKELOCK: mWakeLock released");
                        }
                    } else if (i != 7) {
                        return false;
                    }
                }
                return true;
            }
            InboundSmsHandler.this.deferMessage(message);
            InboundSmsHandler inboundSmsHandler2 = InboundSmsHandler.this;
            inboundSmsHandler2.transitionTo(inboundSmsHandler2.mDeliveringState);
            return true;
        }
    }

    public class DeliveringState extends State {
        public DeliveringState() {
        }

        public void enter() {
            InboundSmsHandler.this.log("DeliveringState.enter: entering DeliveringState");
        }

        public void exit() {
            InboundSmsHandler.this.log("DeliveringState.exit: leaving DeliveringState");
        }

        public boolean processMessage(Message message) {
            InboundSmsHandler.this.log("DeliveringState.processMessage: processing " + InboundSmsHandler.this.getWhatToString(message.what));
            int i = message.what;
            if (i == 1) {
                InboundSmsHandler.this.handleNewSms((AsyncResult) message.obj);
                InboundSmsHandler.this.sendMessage(4);
                return true;
            } else if (i == 2) {
                if (InboundSmsHandler.this.processMessagePart((InboundSmsTracker) message.obj)) {
                    InboundSmsHandler inboundSmsHandler = InboundSmsHandler.this;
                    inboundSmsHandler.sendMessage(inboundSmsHandler.obtainMessage(8, message.obj));
                    InboundSmsHandler inboundSmsHandler2 = InboundSmsHandler.this;
                    inboundSmsHandler2.transitionTo(inboundSmsHandler2.mWaitingState);
                } else {
                    InboundSmsHandler.this.log("DeliveringState.processMessage: EVENT_BROADCAST_SMS: No broadcast sent. Return to IdleState");
                    InboundSmsHandler.this.sendMessage(4);
                }
                return true;
            } else if (i == 4) {
                InboundSmsHandler inboundSmsHandler3 = InboundSmsHandler.this;
                inboundSmsHandler3.transitionTo(inboundSmsHandler3.mIdleState);
                return true;
            } else if (i != 5) {
                boolean z = false;
                if (i == 7) {
                    InboundSmsHandler inboundSmsHandler4 = InboundSmsHandler.this;
                    AsyncResult asyncResult = (AsyncResult) message.obj;
                    if (message.arg1 == 1) {
                        z = true;
                    }
                    inboundSmsHandler4.handleInjectSms(asyncResult, z);
                    InboundSmsHandler.this.sendMessage(4);
                    return true;
                } else if (i != 8) {
                    InboundSmsHandler.this.logeWithLocalLog("Unhandled msg in delivering state, msg.what = " + InboundSmsHandler.this.getWhatToString(message.what));
                    return false;
                } else {
                    InboundSmsHandler.this.logd("process tracker message in DeliveringState " + message.arg1);
                    return true;
                }
            } else {
                InboundSmsHandler.this.mWakeLock.release();
                if (!InboundSmsHandler.this.mWakeLock.isHeld()) {
                    InboundSmsHandler.this.loge("mWakeLock released while delivering/broadcasting!");
                }
                return true;
            }
        }
    }

    public class WaitingState extends State {
        private InboundSmsTracker mLastDeliveredSmsTracker;

        public WaitingState() {
        }

        public void enter() {
            InboundSmsHandler.this.log("WaitingState.enter: entering WaitingState");
        }

        public void exit() {
            InboundSmsHandler.this.log("WaitingState.exit: leaving WaitingState");
            InboundSmsHandler.this.setWakeLockTimeout(3000);
            InboundSmsHandler.this.mPhone.getIccSmsInterfaceManager().mDispatchersController.sendEmptyMessage(17);
        }

        public boolean processMessage(Message message) {
            InboundSmsHandler inboundSmsHandler = InboundSmsHandler.this;
            inboundSmsHandler.log("WaitingState.processMessage: processing " + InboundSmsHandler.this.getWhatToString(message.what));
            int i = message.what;
            if (i == 2) {
                if (this.mLastDeliveredSmsTracker != null) {
                    InboundSmsHandler.this.logWithLocalLog("Defer sms broadcast due to undelivered sms,  messageCount = " + this.mLastDeliveredSmsTracker.getMessageCount() + " destPort = " + this.mLastDeliveredSmsTracker.getDestPort() + " timestamp = " + this.mLastDeliveredSmsTracker.getTimestamp() + " currentTimestamp = " + System.currentTimeMillis(), this.mLastDeliveredSmsTracker.getMessageId());
                }
                InboundSmsHandler.this.deferMessage(message);
                return true;
            } else if (i != 3) {
                if (i != 4) {
                    if (i == 8) {
                        this.mLastDeliveredSmsTracker = (InboundSmsTracker) message.obj;
                    } else if (i != 9) {
                        return false;
                    } else {
                        InboundSmsHandler.this.logeWithLocalLog("WaitingState.processMessage: received EVENT_RECEIVER_TIMEOUT");
                        InboundSmsTracker inboundSmsTracker = this.mLastDeliveredSmsTracker;
                        if (inboundSmsTracker != null) {
                            inboundSmsTracker.getSmsBroadcastReceiver(InboundSmsHandler.this).fakeNextAction();
                        }
                        return true;
                    }
                }
                return true;
            } else {
                this.mLastDeliveredSmsTracker = null;
                InboundSmsHandler.this.sendMessage(4);
                InboundSmsHandler inboundSmsHandler2 = InboundSmsHandler.this;
                inboundSmsHandler2.transitionTo(inboundSmsHandler2.mDeliveringState);
                return true;
            }
        }
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void handleNewSms(AsyncResult asyncResult) {
        int i;
        if (asyncResult.exception != null) {
            loge("Exception processing incoming SMS: " + asyncResult.exception);
            return;
        }
        boolean z = false;
        try {
            i = dispatchMessage(((SmsMessage) asyncResult.result).mWrappedSmsMessage, 0);
        } catch (RuntimeException e) {
            loge("Exception dispatching message", (Throwable) e);
            i = 6;
        }
        if (i != -1) {
            if (i == 1) {
                z = true;
            }
            notifyAndAcknowledgeLastIncomingSms(z, i, (Message) null);
        }
    }

    /* access modifiers changed from: private */
    /* JADX WARNING: Removed duplicated region for block: B:16:0x002b  */
    /* JADX WARNING: Removed duplicated region for block: B:18:? A[RETURN, SYNTHETIC] */
    @android.compat.annotation.UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void handleInjectSms(android.os.AsyncResult r3, boolean r4) {
        /*
            r2 = this;
            r0 = 0
            java.lang.Object r1 = r3.userObj     // Catch:{ RuntimeException -> 0x0021 }
            com.android.internal.telephony.SmsDispatchersController$SmsInjectionCallback r1 = (com.android.internal.telephony.SmsDispatchersController.SmsInjectionCallback) r1     // Catch:{ RuntimeException -> 0x0021 }
            java.lang.Object r3 = r3.result     // Catch:{ RuntimeException -> 0x001e }
            android.telephony.SmsMessage r3 = (android.telephony.SmsMessage) r3     // Catch:{ RuntimeException -> 0x001e }
            if (r3 != 0) goto L_0x0012
            java.lang.String r3 = "Null injected sms"
            r2.loge(r3)     // Catch:{ RuntimeException -> 0x001e }
            r2 = 7
            goto L_0x0029
        L_0x0012:
            if (r4 == 0) goto L_0x0016
            r4 = 1
            goto L_0x0017
        L_0x0016:
            r4 = 2
        L_0x0017:
            com.android.internal.telephony.SmsMessageBase r3 = r3.mWrappedSmsMessage     // Catch:{ RuntimeException -> 0x001e }
            int r2 = r2.dispatchMessage(r3, r4)     // Catch:{ RuntimeException -> 0x001e }
            goto L_0x0029
        L_0x001e:
            r3 = move-exception
            r0 = r1
            goto L_0x0022
        L_0x0021:
            r3 = move-exception
        L_0x0022:
            java.lang.String r4 = "Exception dispatching message"
            r2.loge((java.lang.String) r4, (java.lang.Throwable) r3)
            r2 = 6
            r1 = r0
        L_0x0029:
            if (r1 == 0) goto L_0x002e
            r1.onSmsInjectedResult(r2)
        L_0x002e:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.InboundSmsHandler.handleInjectSms(android.os.AsyncResult, boolean):void");
    }

    private int dispatchMessage(SmsMessageBase smsMessageBase, int i) {
        if (smsMessageBase == null) {
            loge("dispatchSmsMessage: message is null");
            return 8;
        } else if (this.mSmsReceiveDisabled) {
            log("Received short message on device which doesn't support receiving SMS. Ignored.");
            return 1;
        } else {
            boolean z = false;
            try {
                z = IPackageManager.Stub.asInterface(ServiceManager.getService("package")).isOnlyCoreApps();
            } catch (RemoteException unused) {
            }
            if (z) {
                log("Received a short message in encrypted state. Rejecting.");
                return 9;
            }
            int dispatchMessageRadioSpecific = dispatchMessageRadioSpecific(smsMessageBase, i);
            if (!(dispatchMessageRadioSpecific == 1 || dispatchMessageRadioSpecific == -1)) {
                this.mMetrics.writeIncomingSmsError(this.mPhone.getPhoneId(), is3gpp2(), i, dispatchMessageRadioSpecific);
                this.mPhone.getSmsStats().onIncomingSmsError(is3gpp2(), i, dispatchMessageRadioSpecific);
            }
            return dispatchMessageRadioSpecific;
        }
    }

    private void notifyAndAcknowledgeLastIncomingSms(boolean z, int i, Message message) {
        if (!z) {
            Intent intent = new Intent("android.provider.Telephony.SMS_REJECTED");
            intent.putExtra(DebugDataReport.DebugDataAgpsSessionInfo.KEY_RESULT, i);
            intent.putExtra("subId", this.mPhone.getSubId());
            this.mContext.sendBroadcast(intent, "android.permission.RECEIVE_SMS");
        }
        acknowledgeLastIncomingSms(z, i, message);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int dispatchNormalMessage(SmsMessageBase smsMessageBase, int i) {
        InboundSmsTracker inboundSmsTracker;
        int i2;
        SmsHeader.PortAddrs portAddrs;
        SmsHeader.ConcatRef concatRef;
        Class<InboundSmsTracker> cls = InboundSmsTracker.class;
        SmsHeader userDataHeader = smsMessageBase.getUserDataHeader();
        if (userDataHeader == null || (concatRef = userDataHeader.concatRef) == null) {
            if (userDataHeader == null || (portAddrs = userDataHeader.portAddrs) == null) {
                i2 = -1;
            } else {
                int i3 = portAddrs.destPort;
                log("destination port: " + i3);
                i2 = i3;
            }
            inboundSmsTracker = TelephonyComponentFactory.getInstance().inject(cls.getName()).makeInboundSmsTracker(this.mContext, smsMessageBase.getPdu(), smsMessageBase.getTimestampMillis(), i2, is3gpp2(), false, smsMessageBase.getOriginatingAddress(), smsMessageBase.getDisplayOriginatingAddress(), smsMessageBase.getMessageBody(), smsMessageBase.getMessageClass() == SmsConstants.MessageClass.CLASS_0, this.mPhone.getSubId(), i);
        } else {
            SmsHeader.PortAddrs portAddrs2 = userDataHeader.portAddrs;
            inboundSmsTracker = TelephonyComponentFactory.getInstance().inject(cls.getName()).makeInboundSmsTracker(this.mContext, smsMessageBase.getPdu(), smsMessageBase.getTimestampMillis(), portAddrs2 != null ? portAddrs2.destPort : -1, is3gpp2(), smsMessageBase.getOriginatingAddress(), smsMessageBase.getDisplayOriginatingAddress(), concatRef.refNumber, concatRef.seqNumber, concatRef.msgCount, false, smsMessageBase.getMessageBody(), smsMessageBase.getMessageClass() == SmsConstants.MessageClass.CLASS_0, this.mPhone.getSubId(), i);
        }
        return addTrackerToRawTableAndSendMessage(inboundSmsTracker, inboundSmsTracker.getDestPort() == -1);
    }

    /* access modifiers changed from: protected */
    public int addTrackerToRawTableAndSendMessage(InboundSmsTracker inboundSmsTracker, boolean z) {
        int addTrackerToRawTable = addTrackerToRawTable(inboundSmsTracker, z);
        if (addTrackerToRawTable == 1) {
            sendMessage(2, (Object) inboundSmsTracker);
            return 1;
        } else if (addTrackerToRawTable != 5) {
            return addTrackerToRawTable;
        } else {
            return 1;
        }
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Removed duplicated region for block: B:104:0x03c2  */
    /* JADX WARNING: Removed duplicated region for block: B:108:0x03c9  */
    @android.compat.annotation.UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean processMessagePart(com.android.internal.telephony.InboundSmsTracker r28) {
        /*
            r27 = this;
            r9 = r27
            r10 = r28
            int r0 = r28.getMessageCount()
            int r1 = r28.getDestPort()
            java.lang.String r5 = r28.getAddress()
            r11 = 0
            if (r0 > 0) goto L_0x002c
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "processMessagePart: returning false due to invalid message count "
            r1.append(r2)
            r1.append(r0)
            java.lang.String r0 = r1.toString()
            long r1 = r28.getMessageId()
            r9.loge((java.lang.String) r0, (long) r1)
            return r11
        L_0x002c:
            r12 = -1
            r2 = 0
            r13 = 2
            r14 = 1
            if (r0 != r14) goto L_0x0053
            byte[][] r3 = new byte[r14][]
            byte[] r4 = r28.getPdu()
            r3[r11] = r4
            long[] r4 = new long[r14]
            long r6 = r28.getTimestamp()
            r4[r11] = r6
            android.content.Context r6 = r9.mContext
            java.lang.String r7 = r28.getDisplayAddress()
            boolean r6 = com.android.internal.telephony.BlockChecker.isBlocked(r6, r7, r2)
            r12 = r1
            r8 = r3
            r23 = r4
            r14 = r6
            goto L_0x01af
        L_0x0053:
            int r3 = r28.getReferenceNumber()     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            java.lang.String r3 = java.lang.Integer.toString(r3)     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            int r4 = r28.getMessageCount()     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            java.lang.String r4 = java.lang.Integer.toString(r4)     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            r6 = 3
            java.lang.String[] r7 = new java.lang.String[r6]     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            r7[r11] = r5     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            r7[r14] = r3     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            r7[r13] = r4     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            java.lang.String[] r19 = r9.onModifyQueryWhereArgs(r7)     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            android.content.ContentResolver r15 = r9.mResolver     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            android.net.Uri r16 = sRawUri     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            java.lang.String[] r17 = PDU_SEQUENCE_PORT_PROJECTION     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            java.lang.String r18 = r28.getQueryForSegments()     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            r20 = 0
            android.database.Cursor r4 = r15.query(r16, r17, r18, r19, r20)     // Catch:{ SQLException -> 0x03a2, all -> 0x039f }
            int r7 = r4.getCount()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            if (r7 >= r0) goto L_0x00b2
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r1.<init>()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.String r2 = "processMessagePart: returning false. Only "
            r1.append(r2)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r1.append(r7)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.String r2 = " of "
            r1.append(r2)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r1.append(r0)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.String r0 = " segments  have arrived. refNumber: "
            r1.append(r0)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r1.append(r3)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.String r0 = r1.toString()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            long r1 = r28.getMessageId()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r9.log(r0, r1)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r4.close()
            return r11
        L_0x00b2:
            byte[][] r7 = new byte[r0][]     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            long[] r8 = new long[r0]     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r15 = r11
        L_0x00b7:
            boolean r16 = r4.moveToNext()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            if (r16 == 0) goto L_0x0186
            java.util.Map<java.lang.Integer, java.lang.Integer> r2 = PDU_SEQUENCE_PORT_PROJECTION_INDEX_MAPPING     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Integer r6 = java.lang.Integer.valueOf(r14)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Object r6 = r2.get(r6)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Integer r6 = (java.lang.Integer) r6     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            int r6 = r6.intValue()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            int r6 = r4.getInt(r6)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            int r18 = r28.getIndexOffset()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            int r6 = r6 - r18
            if (r6 >= r0) goto L_0x015a
            if (r6 >= 0) goto L_0x00dd
            goto L_0x015a
        L_0x00dd:
            java.lang.Integer r14 = java.lang.Integer.valueOf(r11)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Object r14 = r2.get(r14)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Integer r14 = (java.lang.Integer) r14     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            int r14 = r14.intValue()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.String r14 = r4.getString(r14)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            byte[] r14 = com.android.internal.telephony.HexDump.hexStringToByteArray(r14)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r7[r6] = r14     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            if (r6 != 0) goto L_0x0124
            java.lang.Integer r14 = java.lang.Integer.valueOf(r13)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Object r14 = r2.get(r14)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Integer r14 = (java.lang.Integer) r14     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            int r14 = r14.intValue()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            boolean r14 = r4.isNull(r14)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            if (r14 != 0) goto L_0x0124
            java.lang.Integer r14 = java.lang.Integer.valueOf(r13)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Object r14 = r2.get(r14)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Integer r14 = (java.lang.Integer) r14     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            int r14 = r14.intValue()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            int r14 = r4.getInt(r14)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            int r14 = com.android.internal.telephony.InboundSmsTracker.getRealDestPort(r14)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            if (r14 == r12) goto L_0x0124
            r1 = r14
        L_0x0124:
            r14 = 3
            java.lang.Integer r12 = java.lang.Integer.valueOf(r14)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Object r12 = r2.get(r12)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Integer r12 = (java.lang.Integer) r12     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            int r12 = r12.intValue()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            long r19 = r4.getLong(r12)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r8[r6] = r19     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            if (r15 != 0) goto L_0x0157
            android.content.Context r6 = r9.mContext     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r12 = 9
            java.lang.Integer r12 = java.lang.Integer.valueOf(r12)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Object r2 = r2.get(r12)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Integer r2 = (java.lang.Integer) r2     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            int r2 = r2.intValue()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.String r2 = r4.getString(r2)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r12 = 0
            boolean r2 = com.android.internal.telephony.BlockChecker.isBlocked(r6, r2, r12)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r15 = r2
        L_0x0157:
            r6 = r14
            r2 = 0
            goto L_0x0182
        L_0x015a:
            r14 = 3
            java.lang.String r2 = "processMessagePart: invalid seqNumber = %d, messageCount = %d"
            java.lang.Object[] r12 = new java.lang.Object[r13]     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            int r19 = r28.getIndexOffset()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            int r6 = r6 + r19
            java.lang.Integer r6 = java.lang.Integer.valueOf(r6)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r12[r11] = r6     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.Integer r6 = java.lang.Integer.valueOf(r0)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r18 = 1
            r12[r18] = r6     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.String r2 = java.lang.String.format(r2, r12)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r12 = r15
            long r14 = r28.getMessageId()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r9.loge((java.lang.String) r2, (long) r14)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r15 = r12
            r2 = 0
            r6 = 3
        L_0x0182:
            r12 = -1
            r14 = 1
            goto L_0x00b7
        L_0x0186:
            r12 = r15
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r2.<init>()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.String r6 = "processMessagePart: all "
            r2.append(r6)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r2.append(r0)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.String r6 = " segments  received. refNumber: "
            r2.append(r6)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r2.append(r3)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            java.lang.String r2 = r2.toString()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            long r14 = r28.getMessageId()     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r9.log(r2, r14)     // Catch:{ SQLException -> 0x039c, all -> 0x0399 }
            r4.close()
            r23 = r8
            r14 = r12
            r12 = r1
            r8 = r7
        L_0x01af:
            r1 = 2948(0xb84, float:4.131E-42)
            if (r12 != r1) goto L_0x01b5
            r1 = 1
            goto L_0x01b6
        L_0x01b5:
            r1 = r11
        L_0x01b6:
            java.lang.String r15 = r28.getFormat()
            java.util.List r2 = java.util.Arrays.asList(r8)
            int r3 = r2.size()
            if (r3 == 0) goto L_0x0363
            r3 = 0
            boolean r3 = r2.contains(r3)
            if (r3 == 0) goto L_0x01cd
            goto L_0x0363
        L_0x01cd:
            java.io.ByteArrayOutputStream r2 = new java.io.ByteArrayOutputStream
            r2.<init>()
            if (r1 == 0) goto L_0x0227
            int r3 = r8.length
            r4 = r11
        L_0x01d6:
            if (r4 >= r3) goto L_0x0227
            r6 = r8[r4]
            java.lang.String r7 = "3gpp"
            if (r15 != r7) goto L_0x0220
            android.telephony.SmsMessage r6 = r9.onCreateSmsMessage(r6, r7)
            if (r6 == 0) goto L_0x01e9
            byte[] r6 = r6.getUserData()
            goto L_0x0220
        L_0x01e9:
            long r1 = r28.getMessageId()
            java.lang.String r3 = "processMessagePart: SmsMessage.createFromPdu returned null"
            r9.loge((java.lang.String) r3, (long) r1)
            com.android.internal.telephony.metrics.TelephonyMetrics r1 = r9.mMetrics
            com.android.internal.telephony.Phone r2 = r9.mPhone
            int r20 = r2.getPhoneId()
            int r21 = r28.getSource()
            r24 = 0
            long r25 = r28.getMessageId()
            java.lang.String r22 = "3gpp"
            r19 = r1
            r19.writeIncomingWapPush(r20, r21, r22, r23, r24, r25)
            com.android.internal.telephony.Phone r1 = r9.mPhone
            com.android.internal.telephony.metrics.SmsStats r1 = r1.getSmsStats()
            int r2 = r28.getSource()
            r4 = 8
            long r5 = r28.getMessageId()
            r3 = r0
            r1.onIncomingSmsWapPush(r2, r3, r4, r5)
            return r11
        L_0x0220:
            int r7 = r6.length
            r2.write(r6, r11, r7)
            int r4 = r4 + 1
            goto L_0x01d6
        L_0x0227:
            com.android.internal.telephony.InboundSmsHandler$SmsBroadcastReceiver r16 = r10.getSmsBroadcastReceiver(r9)
            java.lang.String r3 = r28.getFormat()
            boolean r3 = r9.onCheckIfStopProcessMessagePart(r8, r3, r10)
            if (r3 == 0) goto L_0x0236
            return r11
        L_0x0236:
            android.os.UserManager r3 = r9.mUserManager
            boolean r3 = r3.isUserUnlocked()
            if (r3 != 0) goto L_0x0271
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r3 = "processMessagePart: !isUserUnlocked; calling processMessagePartWithUserLocked. Port: "
            r0.append(r3)
            r0.append(r12)
            java.lang.String r0 = r0.toString()
            long r3 = r28.getMessageId()
            r9.log(r0, r3)
            if (r1 == 0) goto L_0x0263
            r0 = 1
            byte[][] r0 = new byte[r0][]
            byte[] r1 = r2.toByteArray()
            r0[r11] = r1
            r3 = r0
            goto L_0x0264
        L_0x0263:
            r3 = r8
        L_0x0264:
            r1 = r27
            r2 = r28
            r4 = r12
            r5 = r16
            r6 = r14
            boolean r0 = r1.processMessagePartWithUserLocked(r2, r3, r4, r5, r6)
            return r0
        L_0x0271:
            if (r1 == 0) goto L_0x02f2
            byte[] r3 = r2.toByteArray()
            int r6 = r28.getSubId()
            long r19 = r28.getMessageId()
            r1 = r27
            r2 = r8
            r4 = r16
            r7 = r19
            int r7 = r1.onDispatchWapPdu(r2, r3, r4, r5, r6, r7)
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r2 = "processMessagePart: dispatchWapPdu() returned "
            r1.append(r2)
            r1.append(r7)
            java.lang.String r1 = r1.toString()
            long r2 = r28.getMessageId()
            r9.log(r1, r2)
            r1 = -1
            if (r7 == r1) goto L_0x02ac
            r1 = 1
            if (r7 != r1) goto L_0x02a9
            goto L_0x02ac
        L_0x02a9:
            r24 = r11
            goto L_0x02ae
        L_0x02ac:
            r24 = 1
        L_0x02ae:
            com.android.internal.telephony.metrics.TelephonyMetrics r1 = r9.mMetrics
            com.android.internal.telephony.Phone r2 = r9.mPhone
            int r20 = r2.getPhoneId()
            int r21 = r28.getSource()
            long r25 = r28.getMessageId()
            r19 = r1
            r22 = r15
            r19.writeIncomingWapPush(r20, r21, r22, r23, r24, r25)
            com.android.internal.telephony.Phone r1 = r9.mPhone
            com.android.internal.telephony.metrics.SmsStats r1 = r1.getSmsStats()
            int r2 = r28.getSource()
            long r5 = r28.getMessageId()
            r3 = r0
            r4 = r7
            r1.onIncomingSmsWapPush(r2, r3, r4, r5)
            r0 = -1
            if (r7 != r0) goto L_0x02dd
            r0 = 1
            return r0
        L_0x02dd:
            java.lang.String r0 = r28.getDeleteWhere()
            java.lang.String[] r1 = r28.getDeleteWhereArgs()
            r9.deleteFromRawTable(r0, r1, r13)
            long r0 = r28.getMessageId()
            java.lang.String r2 = "processMessagePart: returning false as the ordered broadcast for WAP push was not sent"
            r9.loge((java.lang.String) r2, (long) r0)
            return r11
        L_0x02f2:
            com.android.internal.telephony.metrics.TelephonyMetrics r1 = r9.mMetrics
            com.android.internal.telephony.Phone r2 = r9.mPhone
            int r20 = r2.getPhoneId()
            int r21 = r28.getSource()
            long r25 = r28.getMessageId()
            r19 = r1
            r22 = r15
            r24 = r14
            r19.writeIncomingSmsSession(r20, r21, r22, r23, r24, r25)
            com.android.internal.telephony.Phone r1 = r9.mPhone
            com.android.internal.telephony.metrics.SmsStats r1 = r1.getSmsStats()
            boolean r2 = r27.is3gpp2()
            int r3 = r28.getSource()
            long r6 = r28.getMessageId()
            r4 = r0
            r5 = r14
            r1.onIncomingSmsSuccess(r2, r3, r4, r5, r6)
            r6 = 1
            r1 = r27
            r2 = r8
            r3 = r12
            r4 = r28
            r5 = r16
            r7 = r14
            boolean r0 = r1.filterSms(r2, r3, r4, r5, r6, r7)
            if (r0 != 0) goto L_0x0361
            if (r14 == 0) goto L_0x034a
            java.lang.String r0 = r28.getDeleteWhere()
            java.lang.String[] r1 = r28.getDeleteWhereArgs()
            r2 = 1
            r9.deleteFromRawTable(r0, r1, r2)
            long r0 = r28.getMessageId()
            java.lang.String r2 = "processMessagePart: returning false as the phone number is blocked"
            r9.log(r2, r0)
            return r11
        L_0x034a:
            boolean r6 = r28.isClass0()
            int r7 = r28.getSubId()
            long r10 = r28.getMessageId()
            r1 = r27
            r2 = r8
            r3 = r15
            r4 = r12
            r5 = r16
            r8 = r10
            r1.dispatchSmsDeliveryIntent(r2, r3, r4, r5, r6, r7, r8)
        L_0x0361:
            r0 = 1
            return r0
        L_0x0363:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "processMessagePart: returning false due to "
            r0.append(r1)
            int r1 = r2.size()
            if (r1 != 0) goto L_0x0376
            java.lang.String r1 = "pduList.size() == 0"
            goto L_0x0378
        L_0x0376:
            java.lang.String r1 = "pduList.contains(null)"
        L_0x0378:
            r0.append(r1)
            java.lang.String r0 = r0.toString()
            long r1 = r28.getMessageId()
            r9.logeWithLocalLog(r0, r1)
            com.android.internal.telephony.Phone r0 = r9.mPhone
            com.android.internal.telephony.metrics.SmsStats r0 = r0.getSmsStats()
            boolean r1 = r27.is3gpp2()
            int r2 = r28.getSource()
            r3 = 7
            r0.onIncomingSmsError(r1, r2, r3)
            return r11
        L_0x0399:
            r0 = move-exception
            r2 = r4
            goto L_0x03c7
        L_0x039c:
            r0 = move-exception
            r2 = r4
            goto L_0x03a4
        L_0x039f:
            r0 = move-exception
            r3 = r2
            goto L_0x03c7
        L_0x03a2:
            r0 = move-exception
            r3 = r2
        L_0x03a4:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x03c6 }
            r1.<init>()     // Catch:{ all -> 0x03c6 }
            java.lang.String r3 = "processMessagePart: Can't access multipart SMS database, "
            r1.append(r3)     // Catch:{ all -> 0x03c6 }
            long r3 = r28.getMessageId()     // Catch:{ all -> 0x03c6 }
            java.lang.String r3 = com.android.internal.telephony.SmsController.formatCrossStackMessageId(r3)     // Catch:{ all -> 0x03c6 }
            r1.append(r3)     // Catch:{ all -> 0x03c6 }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x03c6 }
            r9.loge((java.lang.String) r1, (java.lang.Throwable) r0)     // Catch:{ all -> 0x03c6 }
            if (r2 == 0) goto L_0x03c5
            r2.close()
        L_0x03c5:
            return r11
        L_0x03c6:
            r0 = move-exception
        L_0x03c7:
            if (r2 == 0) goto L_0x03cc
            r2.close()
        L_0x03cc:
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.InboundSmsHandler.processMessagePart(com.android.internal.telephony.InboundSmsTracker):boolean");
    }

    /* access modifiers changed from: protected */
    public boolean processMessagePartWithUserLocked(InboundSmsTracker inboundSmsTracker, byte[][] bArr, int i, SmsBroadcastReceiver smsBroadcastReceiver, boolean z) {
        if (i != 2948 || !this.mWapPush.isWapPushForMms(bArr[0], this)) {
            if (i == -1) {
                if (filterSms(bArr, i, inboundSmsTracker, smsBroadcastReceiver, false, z)) {
                    return true;
                }
                if (!z) {
                    showNewMessageNotification();
                }
            }
            return false;
        }
        showNewMessageNotification();
        return false;
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void showNewMessageNotification() {
        if (StorageManager.isFileEncryptedNativeOrEmulated()) {
            log("Show new message notification.");
            ((NotificationManager) this.mContext.getSystemService("notification")).notify(NOTIFICATION_TAG, 1, new Notification.Builder(this.mContext).setSmallIcon(17301646).setAutoCancel(true).setVisibility(1).setDefaults(-1).setContentTitle(this.mContext.getString(17040869)).setContentText(this.mContext.getString(17040868)).setContentIntent(PendingIntent.getBroadcast(this.mContext, 0, new Intent(ACTION_OPEN_SMS_APP), 1140850688)).setChannelId(NotificationChannelController.CHANNEL_ID_SMS).build());
        }
    }

    static void cancelNewMessageNotification(Context context) {
        ((NotificationManager) context.getSystemService("notification")).cancel(NOTIFICATION_TAG, 1);
    }

    private List<SmsFilter> createDefaultSmsFilters() {
        ArrayList arrayList = new ArrayList(3);
        arrayList.add(new InboundSmsHandler$$ExternalSyntheticLambda0(this));
        arrayList.add(new InboundSmsHandler$$ExternalSyntheticLambda1(this));
        arrayList.add(new InboundSmsHandler$$ExternalSyntheticLambda2(this));
        return arrayList;
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$createDefaultSmsFilters$0(byte[][] bArr, int i, InboundSmsTracker inboundSmsTracker, SmsBroadcastReceiver smsBroadcastReceiver, boolean z, boolean z2, List list) {
        CarrierServicesSmsFilterCallback carrierServicesSmsFilterCallback = new CarrierServicesSmsFilterCallback(bArr, i, inboundSmsTracker, inboundSmsTracker.getFormat(), smsBroadcastReceiver, z, inboundSmsTracker.isClass0(), inboundSmsTracker.getSubId(), inboundSmsTracker.getMessageId(), z2, list);
        Context context = this.mContext;
        Phone phone = this.mPhone;
        String format = inboundSmsTracker.getFormat();
        if (!new CarrierServicesSmsFilter(context, phone, bArr, i, format, carrierServicesSmsFilterCallback, getName() + "::CarrierServicesSmsFilter", this.mCarrierServiceLocalLog, inboundSmsTracker.getMessageId()).filter()) {
            return false;
        }
        log("SMS is being handled by carrier service", inboundSmsTracker.getMessageId());
        return true;
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$createDefaultSmsFilters$1(byte[][] bArr, int i, InboundSmsTracker inboundSmsTracker, SmsBroadcastReceiver smsBroadcastReceiver, boolean z, boolean z2, List list) {
        if (!VisualVoicemailSmsFilter.filter(this.mContext, bArr, inboundSmsTracker.getFormat(), i, inboundSmsTracker.getSubId())) {
            return false;
        }
        logWithLocalLog("Visual voicemail SMS dropped", inboundSmsTracker.getMessageId());
        dropFilteredSms(inboundSmsTracker, smsBroadcastReceiver, z2);
        return true;
    }

    /* access modifiers changed from: private */
    public /* synthetic */ boolean lambda$createDefaultSmsFilters$2(byte[][] bArr, int i, InboundSmsTracker inboundSmsTracker, SmsBroadcastReceiver smsBroadcastReceiver, boolean z, boolean z2, List list) {
        if (!new MissedIncomingCallSmsFilter(this.mPhone).filter(bArr, inboundSmsTracker.getFormat())) {
            return false;
        }
        logWithLocalLog("Missed incoming call SMS received", inboundSmsTracker.getMessageId());
        dropFilteredSms(inboundSmsTracker, smsBroadcastReceiver, z2);
        return true;
    }

    /* access modifiers changed from: private */
    public void dropFilteredSms(InboundSmsTracker inboundSmsTracker, SmsBroadcastReceiver smsBroadcastReceiver, boolean z) {
        if (z) {
            deleteFromRawTable(inboundSmsTracker.getDeleteWhere(), inboundSmsTracker.getDeleteWhereArgs(), 1);
            sendMessage(3);
            return;
        }
        dropSms(smsBroadcastReceiver);
    }

    /* access modifiers changed from: protected */
    public boolean filterSms(byte[][] bArr, int i, InboundSmsTracker inboundSmsTracker, SmsBroadcastReceiver smsBroadcastReceiver, boolean z, boolean z2) {
        return filterSms(bArr, i, inboundSmsTracker, smsBroadcastReceiver, z, z2, this.mSmsFilters);
    }

    /* access modifiers changed from: private */
    public static boolean filterSms(byte[][] bArr, int i, InboundSmsTracker inboundSmsTracker, SmsBroadcastReceiver smsBroadcastReceiver, boolean z, boolean z2, List<SmsFilter> list) {
        ListIterator<SmsFilter> listIterator = list.listIterator();
        while (listIterator.hasNext()) {
            if (listIterator.next().filterSms(bArr, i, inboundSmsTracker, smsBroadcastReceiver, z, z2, list.subList(listIterator.nextIndex(), list.size()))) {
                return true;
            }
        }
        return false;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void dispatchIntent(Intent intent, String str, String str2, Bundle bundle, SmsBroadcastReceiver smsBroadcastReceiver, UserHandle userHandle, int i) {
        int[] iArr;
        Intent intent2 = intent;
        SmsBroadcastReceiver smsBroadcastReceiver2 = smsBroadcastReceiver;
        UserHandle userHandle2 = userHandle;
        intent2.addFlags(134217728);
        String action = intent.getAction();
        if ("android.provider.Telephony.SMS_DELIVER".equals(action) || "android.provider.Telephony.SMS_RECEIVED".equals(action) || "android.provider.Telephony.WAP_PUSH_DELIVER".equals(action) || "android.provider.Telephony.WAP_PUSH_RECEIVED".equals(action)) {
            intent2.addFlags(268435456);
        }
        SubscriptionManager.putPhoneIdAndSubIdExtra(intent2, this.mPhone.getPhoneId());
        if (SubscriptionManager.isValidSubscriptionId(i)) {
            SubscriptionManager.putSubscriptionIdExtra(intent2, i);
        }
        if (userHandle2.equals(UserHandle.ALL)) {
            List<UserHandle> userHandles = this.mUserManager.getUserHandles(false);
            ArrayList arrayList = new ArrayList();
            for (UserHandle userHandle3 : userHandles) {
                if (this.mUserManager.isUserRunning(userHandle3)) {
                    arrayList.add(userHandle3);
                } else if (userHandle3.equals(UserHandle.SYSTEM)) {
                    logeWithLocalLog("dispatchIntent: SYSTEM user is not running", smsBroadcastReceiver.mInboundSmsTracker.getMessageId());
                }
            }
            if (arrayList.isEmpty()) {
                iArr = new int[]{userHandle.getIdentifier()};
            } else {
                iArr = new int[arrayList.size()];
                for (int i2 = 0; i2 < arrayList.size(); i2++) {
                    iArr[i2] = ((UserHandle) arrayList.get(i2)).getIdentifier();
                }
            }
            int[] iArr2 = iArr;
            for (int length = iArr2.length - 1; length >= 0; length--) {
                UserHandle of = UserHandle.of(iArr2[length]);
                if (iArr2[length] == UserHandle.SYSTEM.getIdentifier() || (!hasUserRestriction("no_sms", of) && !this.mUserManager.isManagedProfile(iArr2[length]))) {
                    try {
                        if (iArr2[length] == UserHandle.SYSTEM.getIdentifier()) {
                            smsBroadcastReceiver2.setWaitingForIntent(intent2);
                        }
                        Context context = this.mContext;
                        context.createPackageContextAsUser(context.getPackageName(), 0, of).sendOrderedBroadcast(intent, -1, str, str2, iArr2[length] == UserHandle.SYSTEM.getIdentifier() ? smsBroadcastReceiver2 : null, getHandler(), (String) null, (Bundle) null, bundle);
                    } catch (PackageManager.NameNotFoundException unused) {
                    }
                }
            }
            return;
        }
        try {
            smsBroadcastReceiver2.setWaitingForIntent(intent2);
            Context context2 = this.mContext;
            context2.createPackageContextAsUser(context2.getPackageName(), 0, userHandle2).sendOrderedBroadcast(intent, -1, str, str2, smsBroadcastReceiver, getHandler(), (String) null, (Bundle) null, bundle);
        } catch (PackageManager.NameNotFoundException unused2) {
        }
    }

    private boolean hasUserRestriction(String str, UserHandle userHandle) {
        List userRestrictionSources = this.mUserManager.getUserRestrictionSources(str, userHandle);
        return userRestrictionSources != null && !userRestrictionSources.isEmpty();
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void deleteFromRawTable(String str, String[] strArr, int i) {
        int delete = this.mResolver.delete(i == 1 ? sRawUriPermanentDelete : sRawUri, str, strArr);
        if (delete == 0) {
            loge("No rows were deleted from raw table!");
            return;
        }
        log("Deleted " + delete + " rows from raw table.");
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public Bundle handleSmsWhitelisting(ComponentName componentName, boolean z) {
        String str;
        String str2;
        if (componentName != null) {
            str = componentName.getPackageName();
            str2 = "sms-app";
        } else {
            str = this.mContext.getPackageName();
            str2 = "sms-broadcast";
        }
        BroadcastOptions broadcastOptions = null;
        if (z) {
            broadcastOptions = BroadcastOptions.makeBasic();
            broadcastOptions.setBackgroundActivityStartsAllowed(true);
            broadcastOptions.toBundle();
        }
        long whitelistAppTemporarilyForEvent = this.mPowerWhitelistManager.whitelistAppTemporarilyForEvent(str, 1, 314, str2);
        if (broadcastOptions == null) {
            broadcastOptions = BroadcastOptions.makeBasic();
        }
        broadcastOptions.setTemporaryAppAllowlist(whitelistAppTemporarilyForEvent, 0, 314, "");
        return broadcastOptions.toBundle();
    }

    /* JADX WARNING: type inference failed for: r9v0, types: [byte[][], java.io.Serializable] */
    /* access modifiers changed from: protected */
    /* JADX WARNING: Unknown variable types count: 1 */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void dispatchSmsDeliveryIntent(byte[][] r9, java.lang.String r10, int r11, com.android.internal.telephony.InboundSmsHandler.SmsBroadcastReceiver r12, boolean r13, int r14, long r15) {
        /*
            r8 = this;
            r0 = r8
            r1 = r11
            r2 = r15
            android.content.Intent r4 = new android.content.Intent
            r4.<init>()
            java.lang.String r5 = "pdus"
            r6 = r9
            r4.putExtra(r5, r9)
            java.lang.String r5 = "format"
            r6 = r10
            r4.putExtra(r5, r10)
            r5 = 0
            int r5 = (r2 > r5 ? 1 : (r2 == r5 ? 0 : -1))
            if (r5 == 0) goto L_0x001f
            java.lang.String r5 = "messageId"
            r4.putExtra(r5, r2)
        L_0x001f:
            r5 = -1
            r6 = 0
            if (r1 != r5) goto L_0x006f
            java.lang.String r1 = "android.provider.Telephony.SMS_DELIVER"
            r4.setAction(r1)
            android.content.Context r1 = r0.mContext
            r5 = 1
            android.content.ComponentName r1 = com.android.internal.telephony.SmsApplication.getDefaultSmsApplication(r1, r5)
            if (r1 == 0) goto L_0x0059
            r4.setComponent(r1)
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            java.lang.String r6 = "Delivering SMS to: "
            r5.append(r6)
            java.lang.String r6 = r1.getPackageName()
            r5.append(r6)
            java.lang.String r6 = " "
            r5.append(r6)
            java.lang.String r1 = r1.getClassName()
            r5.append(r1)
            java.lang.String r1 = r5.toString()
            r8.logWithLocalLog(r1, r2)
            goto L_0x005c
        L_0x0059:
            r4.setComponent(r6)
        L_0x005c:
            com.android.internal.telephony.Phone r1 = r0.mPhone
            com.android.internal.telephony.AppSmsManager r1 = r1.getAppSmsManager()
            boolean r1 = r1.handleSmsReceivedIntent(r4)
            if (r1 == 0) goto L_0x006d
            r5 = r12
            r8.dropSms(r12)
            return
        L_0x006d:
            r5 = r12
            goto L_0x0091
        L_0x006f:
            r5 = r12
            java.lang.String r2 = "android.intent.action.DATA_SMS_RECEIVED"
            r4.setAction(r2)
            java.lang.StringBuilder r2 = new java.lang.StringBuilder
            r2.<init>()
            java.lang.String r3 = "sms://localhost:"
            r2.append(r3)
            r2.append(r11)
            java.lang.String r1 = r2.toString()
            android.net.Uri r1 = android.net.Uri.parse(r1)
            r4.setData(r1)
            r4.setComponent(r6)
        L_0x0091:
            android.content.ComponentName r1 = r4.getComponent()
            r2 = r13
            android.os.Bundle r6 = r8.handleSmsWhitelisting(r1, r13)
            android.os.UserHandle r7 = android.os.UserHandle.SYSTEM
            java.lang.String r2 = "android.permission.RECEIVE_SMS"
            java.lang.String r3 = "android:receive_sms"
            r0 = r8
            r1 = r4
            r4 = r6
            r5 = r12
            r6 = r7
            r7 = r14
            r0.dispatchIntent(r1, r2, r3, r4, r5, r6, r7)
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.InboundSmsHandler.dispatchSmsDeliveryIntent(byte[][], java.lang.String, int, com.android.internal.telephony.InboundSmsHandler$SmsBroadcastReceiver, boolean, int, long):void");
    }

    /* JADX WARNING: Removed duplicated region for block: B:44:0x0130  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private boolean checkAndHandleDuplicate(com.android.internal.telephony.InboundSmsTracker r13) throws android.database.SQLException {
        /*
            r12 = this;
            android.util.Pair r0 = r13.getExactMatchDupDetectQuery()
            r1 = 0
            android.content.ContentResolver r2 = r12.mResolver     // Catch:{ all -> 0x012d }
            android.net.Uri r8 = sRawUri     // Catch:{ all -> 0x012d }
            java.lang.String[] r9 = PDU_DELETED_FLAG_PROJECTION     // Catch:{ all -> 0x012d }
            java.lang.Object r3 = r0.first     // Catch:{ all -> 0x012d }
            r5 = r3
            java.lang.String r5 = (java.lang.String) r5     // Catch:{ all -> 0x012d }
            java.lang.Object r3 = r0.second     // Catch:{ all -> 0x012d }
            r6 = r3
            java.lang.String[] r6 = (java.lang.String[]) r6     // Catch:{ all -> 0x012d }
            r7 = 0
            r3 = r8
            r4 = r9
            android.database.Cursor r2 = r2.query(r3, r4, r5, r6, r7)     // Catch:{ all -> 0x012d }
            java.lang.String r10 = " rows"
            r11 = 1
            if (r2 == 0) goto L_0x00ac
            boolean r3 = r2.moveToNext()     // Catch:{ all -> 0x00a8 }
            if (r3 == 0) goto L_0x00ac
            int r3 = r2.getCount()     // Catch:{ all -> 0x00a8 }
            if (r3 == r11) goto L_0x004c
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x00a8 }
            r3.<init>()     // Catch:{ all -> 0x00a8 }
            java.lang.String r4 = "checkAndHandleDuplicate: Exact match query returned "
            r3.append(r4)     // Catch:{ all -> 0x00a8 }
            int r4 = r2.getCount()     // Catch:{ all -> 0x00a8 }
            r3.append(r4)     // Catch:{ all -> 0x00a8 }
            r3.append(r10)     // Catch:{ all -> 0x00a8 }
            java.lang.String r3 = r3.toString()     // Catch:{ all -> 0x00a8 }
            long r4 = r13.getMessageId()     // Catch:{ all -> 0x00a8 }
            r12.logeWithLocalLog(r3, r4)     // Catch:{ all -> 0x00a8 }
        L_0x004c:
            java.util.Map<java.lang.Integer, java.lang.Integer> r3 = PDU_DELETED_FLAG_PROJECTION_INDEX_MAPPING     // Catch:{ all -> 0x00a8 }
            r4 = 10
            java.lang.Integer r4 = java.lang.Integer.valueOf(r4)     // Catch:{ all -> 0x00a8 }
            java.lang.Object r3 = r3.get(r4)     // Catch:{ all -> 0x00a8 }
            java.lang.Integer r3 = (java.lang.Integer) r3     // Catch:{ all -> 0x00a8 }
            int r3 = r3.intValue()     // Catch:{ all -> 0x00a8 }
            int r3 = r2.getInt(r3)     // Catch:{ all -> 0x00a8 }
            if (r3 != r11) goto L_0x007f
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x00a8 }
            r0.<init>()     // Catch:{ all -> 0x00a8 }
            java.lang.String r1 = "checkAndHandleDuplicate: Discarding duplicate message/segment: "
            r0.append(r1)     // Catch:{ all -> 0x00a8 }
            r0.append(r13)     // Catch:{ all -> 0x00a8 }
            java.lang.String r0 = r0.toString()     // Catch:{ all -> 0x00a8 }
            r12.logWithLocalLog(r0)     // Catch:{ all -> 0x00a8 }
            r12.logDupPduMismatch(r2, r13)     // Catch:{ all -> 0x00a8 }
            r2.close()
            return r11
        L_0x007f:
            int r3 = r13.getMessageCount()     // Catch:{ all -> 0x00a8 }
            if (r3 != r11) goto L_0x00ac
            java.lang.Object r3 = r0.first     // Catch:{ all -> 0x00a8 }
            java.lang.String r3 = (java.lang.String) r3     // Catch:{ all -> 0x00a8 }
            java.lang.Object r0 = r0.second     // Catch:{ all -> 0x00a8 }
            java.lang.String[] r0 = (java.lang.String[]) r0     // Catch:{ all -> 0x00a8 }
            r12.deleteFromRawTable(r3, r0, r11)     // Catch:{ all -> 0x00a8 }
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x00a8 }
            r0.<init>()     // Catch:{ all -> 0x00a8 }
            java.lang.String r3 = "checkAndHandleDuplicate: Replacing duplicate message: "
            r0.append(r3)     // Catch:{ all -> 0x00a8 }
            r0.append(r13)     // Catch:{ all -> 0x00a8 }
            java.lang.String r0 = r0.toString()     // Catch:{ all -> 0x00a8 }
            r12.logWithLocalLog(r0)     // Catch:{ all -> 0x00a8 }
            r12.logDupPduMismatch(r2, r13)     // Catch:{ all -> 0x00a8 }
            goto L_0x00ac
        L_0x00a8:
            r12 = move-exception
            r1 = r2
            goto L_0x012e
        L_0x00ac:
            if (r2 == 0) goto L_0x00b1
            r2.close()
        L_0x00b1:
            int r0 = r13.getMessageCount()
            if (r0 <= r11) goto L_0x012b
            android.util.Pair r0 = r13.getInexactMatchDupDetectQuery()
            android.content.ContentResolver r3 = r12.mResolver     // Catch:{ all -> 0x0124 }
            java.lang.Object r2 = r0.first     // Catch:{ all -> 0x0124 }
            r6 = r2
            java.lang.String r6 = (java.lang.String) r6     // Catch:{ all -> 0x0124 }
            java.lang.Object r2 = r0.second     // Catch:{ all -> 0x0124 }
            r7 = r2
            java.lang.String[] r7 = (java.lang.String[]) r7     // Catch:{ all -> 0x0124 }
            r2 = 0
            r4 = r8
            r5 = r9
            r8 = r2
            android.database.Cursor r1 = r3.query(r4, r5, r6, r7, r8)     // Catch:{ all -> 0x0124 }
            if (r1 == 0) goto L_0x011e
            boolean r2 = r1.moveToNext()     // Catch:{ all -> 0x0124 }
            if (r2 == 0) goto L_0x011e
            int r2 = r1.getCount()     // Catch:{ all -> 0x0124 }
            if (r2 == r11) goto L_0x00fc
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x0124 }
            r2.<init>()     // Catch:{ all -> 0x0124 }
            java.lang.String r3 = "checkAndHandleDuplicate: Inexact match query returned "
            r2.append(r3)     // Catch:{ all -> 0x0124 }
            int r3 = r1.getCount()     // Catch:{ all -> 0x0124 }
            r2.append(r3)     // Catch:{ all -> 0x0124 }
            r2.append(r10)     // Catch:{ all -> 0x0124 }
            java.lang.String r2 = r2.toString()     // Catch:{ all -> 0x0124 }
            long r3 = r13.getMessageId()     // Catch:{ all -> 0x0124 }
            r12.logeWithLocalLog(r2, r3)     // Catch:{ all -> 0x0124 }
        L_0x00fc:
            java.lang.Object r2 = r0.first     // Catch:{ all -> 0x0124 }
            java.lang.String r2 = (java.lang.String) r2     // Catch:{ all -> 0x0124 }
            java.lang.Object r0 = r0.second     // Catch:{ all -> 0x0124 }
            java.lang.String[] r0 = (java.lang.String[]) r0     // Catch:{ all -> 0x0124 }
            r12.deleteFromRawTable(r2, r0, r11)     // Catch:{ all -> 0x0124 }
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x0124 }
            r0.<init>()     // Catch:{ all -> 0x0124 }
            java.lang.String r2 = "checkAndHandleDuplicate: Replacing duplicate message segment: "
            r0.append(r2)     // Catch:{ all -> 0x0124 }
            r0.append(r13)     // Catch:{ all -> 0x0124 }
            java.lang.String r0 = r0.toString()     // Catch:{ all -> 0x0124 }
            r12.logWithLocalLog(r0)     // Catch:{ all -> 0x0124 }
            r12.logDupPduMismatch(r1, r13)     // Catch:{ all -> 0x0124 }
        L_0x011e:
            if (r1 == 0) goto L_0x012b
            r1.close()
            goto L_0x012b
        L_0x0124:
            r12 = move-exception
            if (r1 == 0) goto L_0x012a
            r1.close()
        L_0x012a:
            throw r12
        L_0x012b:
            r12 = 0
            return r12
        L_0x012d:
            r12 = move-exception
        L_0x012e:
            if (r1 == 0) goto L_0x0133
            r1.close()
        L_0x0133:
            throw r12
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.InboundSmsHandler.checkAndHandleDuplicate(com.android.internal.telephony.InboundSmsTracker):boolean");
    }

    private void logDupPduMismatch(Cursor cursor, InboundSmsTracker inboundSmsTracker) {
        String string = cursor.getString(PDU_DELETED_FLAG_PROJECTION_INDEX_MAPPING.get(0).intValue());
        byte[] pdu = inboundSmsTracker.getPdu();
        byte[] hexStringToByteArray = HexDump.hexStringToByteArray(string);
        if (!Arrays.equals(hexStringToByteArray, inboundSmsTracker.getPdu())) {
            logeWithLocalLog("Warning: dup message PDU of length " + pdu.length + " is different from existing PDU of length " + hexStringToByteArray.length, inboundSmsTracker.getMessageId());
        }
    }

    /* access modifiers changed from: protected */
    public int addTrackerToRawTable(InboundSmsTracker inboundSmsTracker, boolean z) {
        if (z) {
            try {
                if (checkAndHandleDuplicate(inboundSmsTracker)) {
                    return 5;
                }
            } catch (SQLException e) {
                loge("addTrackerToRawTable: Can't access SMS database, " + SmsController.formatCrossStackMessageId(inboundSmsTracker.getMessageId()), (Throwable) e);
                return 10;
            }
        } else {
            log("addTrackerToRawTable: Skipped message de-duping logic", inboundSmsTracker.getMessageId());
        }
        String address = inboundSmsTracker.getAddress();
        String num = Integer.toString(inboundSmsTracker.getReferenceNumber());
        String num2 = Integer.toString(inboundSmsTracker.getMessageCount());
        Uri insert = this.mResolver.insert(sRawUri, inboundSmsTracker.getContentValues());
        log("addTrackerToRawTable: URI of new row: " + insert, inboundSmsTracker.getMessageId());
        try {
            long parseId = ContentUris.parseId(insert);
            if (inboundSmsTracker.getMessageCount() == 1) {
                inboundSmsTracker.setDeleteWhere(SELECT_BY_ID, new String[]{Long.toString(parseId)});
            } else {
                inboundSmsTracker.setDeleteWhere(inboundSmsTracker.getQueryForSegments(), new String[]{address, num, num2});
            }
            return 1;
        } catch (Exception e2) {
            loge("addTrackerToRawTable: error parsing URI for new row: " + insert + " " + SmsController.formatCrossStackMessageId(inboundSmsTracker.getMessageId()), (Throwable) e2);
            return 11;
        }
    }

    public static boolean isCurrentFormat3gpp2() {
        return 2 == TelephonyManager.getDefault().getCurrentPhoneType();
    }

    public final class SmsBroadcastReceiver extends BroadcastReceiver {
        private long mBroadcastTimeMillis;
        /* access modifiers changed from: private */
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public final String mDeleteWhere;
        /* access modifiers changed from: private */
        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public final String[] mDeleteWhereArgs;
        /* access modifiers changed from: private */
        public final InboundSmsTracker mInboundSmsTracker;
        public Intent mWaitingForIntent;

        public synchronized void setWaitingForIntent(Intent intent) {
            this.mWaitingForIntent = intent;
            this.mBroadcastTimeMillis = System.currentTimeMillis();
            InboundSmsHandler.this.removeMessages(9);
            InboundSmsHandler.this.sendMessageDelayed(9, (long) InboundSmsHandler.sTimeoutDurationMillis);
        }

        public SmsBroadcastReceiver(InboundSmsTracker inboundSmsTracker) {
            this.mDeleteWhere = inboundSmsTracker.getDeleteWhere();
            this.mDeleteWhereArgs = inboundSmsTracker.getDeleteWhereArgs();
            this.mInboundSmsTracker = inboundSmsTracker;
        }

        public void fakeNextAction() {
            if (this.mWaitingForIntent != null) {
                InboundSmsHandler inboundSmsHandler = InboundSmsHandler.this;
                inboundSmsHandler.logeWithLocalLog("fakeNextAction: " + this.mWaitingForIntent.getAction(), this.mInboundSmsTracker.getMessageId());
                handleAction(this.mWaitingForIntent, false);
                return;
            }
            InboundSmsHandler.this.logeWithLocalLog("fakeNextAction: mWaitingForIntent is null", this.mInboundSmsTracker.getMessageId());
        }

        public void onReceive(Context context, Intent intent) {
            if (intent == null) {
                InboundSmsHandler inboundSmsHandler = InboundSmsHandler.this;
                inboundSmsHandler.logeWithLocalLog("onReceive: received null intent, faking " + this.mWaitingForIntent, this.mInboundSmsTracker.getMessageId());
                return;
            }
            handleAction(intent, true);
        }

        /* JADX WARNING: Code restructure failed: missing block: B:35:0x0168, code lost:
            return;
         */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        private synchronized void handleAction(android.content.Intent r17, boolean r18) {
            /*
                r16 = this;
                r9 = r16
                r0 = r17
                monitor-enter(r16)
                java.lang.String r1 = r17.getAction()     // Catch:{ all -> 0x019c }
                android.content.Intent r2 = r9.mWaitingForIntent     // Catch:{ all -> 0x019c }
                if (r2 == 0) goto L_0x0169
                java.lang.String r2 = r2.getAction()     // Catch:{ all -> 0x019c }
                boolean r2 = r2.equals(r1)     // Catch:{ all -> 0x019c }
                if (r2 != 0) goto L_0x0019
                goto L_0x0169
            L_0x0019:
                if (r18 == 0) goto L_0x006e
                long r2 = java.lang.System.currentTimeMillis()     // Catch:{ all -> 0x019c }
                long r4 = r9.mBroadcastTimeMillis     // Catch:{ all -> 0x019c }
                long r2 = r2 - r4
                int r2 = (int) r2     // Catch:{ all -> 0x019c }
                r3 = 5000(0x1388, float:7.006E-42)
                if (r2 < r3) goto L_0x004b
                com.android.internal.telephony.InboundSmsHandler r3 = com.android.internal.telephony.InboundSmsHandler.this     // Catch:{ all -> 0x019c }
                java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ all -> 0x019c }
                r4.<init>()     // Catch:{ all -> 0x019c }
                java.lang.String r5 = "Slow ordered broadcast completion time for "
                r4.append(r5)     // Catch:{ all -> 0x019c }
                r4.append(r1)     // Catch:{ all -> 0x019c }
                java.lang.String r5 = ": "
                r4.append(r5)     // Catch:{ all -> 0x019c }
                r4.append(r2)     // Catch:{ all -> 0x019c }
                java.lang.String r2 = " ms"
                r4.append(r2)     // Catch:{ all -> 0x019c }
                java.lang.String r2 = r4.toString()     // Catch:{ all -> 0x019c }
                r3.loge(r2)     // Catch:{ all -> 0x019c }
                goto L_0x006e
            L_0x004b:
                com.android.internal.telephony.InboundSmsHandler r3 = com.android.internal.telephony.InboundSmsHandler.this     // Catch:{ all -> 0x019c }
                java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ all -> 0x019c }
                r4.<init>()     // Catch:{ all -> 0x019c }
                java.lang.String r5 = "Ordered broadcast completed for "
                r4.append(r5)     // Catch:{ all -> 0x019c }
                r4.append(r1)     // Catch:{ all -> 0x019c }
                java.lang.String r5 = " in: "
                r4.append(r5)     // Catch:{ all -> 0x019c }
                r4.append(r2)     // Catch:{ all -> 0x019c }
                java.lang.String r2 = " ms"
                r4.append(r2)     // Catch:{ all -> 0x019c }
                java.lang.String r2 = r4.toString()     // Catch:{ all -> 0x019c }
                r3.log(r2)     // Catch:{ all -> 0x019c }
            L_0x006e:
                java.lang.String r2 = "android.telephony.extra.SUBSCRIPTION_INDEX"
                r3 = -1
                int r8 = r0.getIntExtra(r2, r3)     // Catch:{ all -> 0x019c }
                java.lang.String r2 = "android.provider.Telephony.SMS_DELIVER"
                boolean r2 = r1.equals(r2)     // Catch:{ all -> 0x019c }
                r4 = 0
                if (r2 == 0) goto L_0x00a1
                java.lang.String r1 = "android.provider.Telephony.SMS_RECEIVED"
                r0.setAction(r1)     // Catch:{ all -> 0x019c }
                r0.setComponent(r4)     // Catch:{ all -> 0x019c }
                com.android.internal.telephony.InboundSmsHandler r1 = com.android.internal.telephony.InboundSmsHandler.this     // Catch:{ all -> 0x019c }
                r2 = 0
                android.os.Bundle r5 = r1.handleSmsWhitelisting(r4, r2)     // Catch:{ all -> 0x019c }
                r16.setWaitingForIntent(r17)     // Catch:{ all -> 0x019c }
                com.android.internal.telephony.InboundSmsHandler r1 = com.android.internal.telephony.InboundSmsHandler.this     // Catch:{ all -> 0x019c }
                java.lang.String r3 = "android.permission.RECEIVE_SMS"
                java.lang.String r4 = "android:receive_sms"
                android.os.UserHandle r7 = android.os.UserHandle.ALL     // Catch:{ all -> 0x019c }
                r2 = r17
                r6 = r16
                r1.dispatchIntent(r2, r3, r4, r5, r6, r7, r8)     // Catch:{ all -> 0x019c }
                goto L_0x0167
            L_0x00a1:
                java.lang.String r2 = "android.provider.Telephony.WAP_PUSH_DELIVER"
                boolean r2 = r1.equals(r2)     // Catch:{ all -> 0x019c }
                r5 = 2
                if (r2 == 0) goto L_0x00f1
                java.lang.String r1 = "android.provider.Telephony.WAP_PUSH_RECEIVED"
                r0.setAction(r1)     // Catch:{ all -> 0x019c }
                r0.setComponent(r4)     // Catch:{ all -> 0x019c }
                com.android.internal.telephony.InboundSmsHandler r1 = com.android.internal.telephony.InboundSmsHandler.this     // Catch:{ all -> 0x019c }
                android.os.PowerWhitelistManager r2 = r1.mPowerWhitelistManager     // Catch:{ all -> 0x019c }
                android.content.Context r1 = r1.mContext     // Catch:{ all -> 0x019c }
                java.lang.String r1 = r1.getPackageName()     // Catch:{ all -> 0x019c }
                r3 = 315(0x13b, float:4.41E-43)
                java.lang.String r4 = "mms-broadcast"
                long r11 = r2.whitelistAppTemporarilyForEvent(r1, r5, r3, r4)     // Catch:{ all -> 0x019c }
                android.app.BroadcastOptions r1 = android.app.BroadcastOptions.makeBasic()     // Catch:{ all -> 0x019c }
                r13 = 0
                r14 = 315(0x13b, float:4.41E-43)
                java.lang.String r15 = ""
                r10 = r1
                r10.setTemporaryAppAllowlist(r11, r13, r14, r15)     // Catch:{ all -> 0x019c }
                android.os.Bundle r5 = r1.toBundle()     // Catch:{ all -> 0x019c }
                java.lang.String r1 = r17.getType()     // Catch:{ all -> 0x019c }
                r16.setWaitingForIntent(r17)     // Catch:{ all -> 0x019c }
                com.android.internal.telephony.InboundSmsHandler r2 = com.android.internal.telephony.InboundSmsHandler.this     // Catch:{ all -> 0x019c }
                java.lang.String r3 = com.android.internal.telephony.WapPushOverSms.getPermissionForType(r1)     // Catch:{ all -> 0x019c }
                java.lang.String r4 = com.android.internal.telephony.WapPushOverSms.getAppOpsStringPermissionForIntent(r1)     // Catch:{ all -> 0x019c }
                android.os.UserHandle r7 = android.os.UserHandle.SYSTEM     // Catch:{ all -> 0x019c }
                r1 = r2
                r2 = r17
                r6 = r16
                r1.dispatchIntent(r2, r3, r4, r5, r6, r7, r8)     // Catch:{ all -> 0x019c }
                goto L_0x0167
            L_0x00f1:
                java.lang.String r0 = "android.intent.action.DATA_SMS_RECEIVED"
                boolean r0 = r0.equals(r1)     // Catch:{ all -> 0x019c }
                if (r0 != 0) goto L_0x0120
                java.lang.String r0 = "android.provider.Telephony.SMS_RECEIVED"
                boolean r0 = r0.equals(r1)     // Catch:{ all -> 0x019c }
                if (r0 != 0) goto L_0x0120
                java.lang.String r0 = "android.provider.Telephony.WAP_PUSH_RECEIVED"
                boolean r0 = r0.equals(r1)     // Catch:{ all -> 0x019c }
                if (r0 != 0) goto L_0x0120
                com.android.internal.telephony.InboundSmsHandler r0 = com.android.internal.telephony.InboundSmsHandler.this     // Catch:{ all -> 0x019c }
                java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x019c }
                r2.<init>()     // Catch:{ all -> 0x019c }
                java.lang.String r6 = "unexpected BroadcastReceiver action: "
                r2.append(r6)     // Catch:{ all -> 0x019c }
                r2.append(r1)     // Catch:{ all -> 0x019c }
                java.lang.String r1 = r2.toString()     // Catch:{ all -> 0x019c }
                r0.loge(r1)     // Catch:{ all -> 0x019c }
            L_0x0120:
                if (r18 == 0) goto L_0x014f
                int r0 = r16.getResultCode()     // Catch:{ all -> 0x019c }
                if (r0 == r3) goto L_0x0147
                r1 = 1
                if (r0 == r1) goto L_0x0147
                com.android.internal.telephony.InboundSmsHandler r1 = com.android.internal.telephony.InboundSmsHandler.this     // Catch:{ all -> 0x019c }
                java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x019c }
                r2.<init>()     // Catch:{ all -> 0x019c }
                java.lang.String r3 = "a broadcast receiver set the result code to "
                r2.append(r3)     // Catch:{ all -> 0x019c }
                r2.append(r0)     // Catch:{ all -> 0x019c }
                java.lang.String r0 = ", deleting from raw table anyway!"
                r2.append(r0)     // Catch:{ all -> 0x019c }
                java.lang.String r0 = r2.toString()     // Catch:{ all -> 0x019c }
                r1.loge(r0)     // Catch:{ all -> 0x019c }
                goto L_0x014f
            L_0x0147:
                com.android.internal.telephony.InboundSmsHandler r0 = com.android.internal.telephony.InboundSmsHandler.this     // Catch:{ all -> 0x019c }
                java.lang.String r1 = "successful broadcast, deleting from raw table."
                r0.log(r1)     // Catch:{ all -> 0x019c }
            L_0x014f:
                com.android.internal.telephony.InboundSmsHandler r0 = com.android.internal.telephony.InboundSmsHandler.this     // Catch:{ all -> 0x019c }
                java.lang.String r1 = r9.mDeleteWhere     // Catch:{ all -> 0x019c }
                java.lang.String[] r2 = r9.mDeleteWhereArgs     // Catch:{ all -> 0x019c }
                r0.deleteFromRawTable(r1, r2, r5)     // Catch:{ all -> 0x019c }
                r9.mWaitingForIntent = r4     // Catch:{ all -> 0x019c }
                com.android.internal.telephony.InboundSmsHandler r0 = com.android.internal.telephony.InboundSmsHandler.this     // Catch:{ all -> 0x019c }
                r1 = 9
                r0.removeMessages(r1)     // Catch:{ all -> 0x019c }
                com.android.internal.telephony.InboundSmsHandler r0 = com.android.internal.telephony.InboundSmsHandler.this     // Catch:{ all -> 0x019c }
                r1 = 3
                r0.sendMessage((int) r1)     // Catch:{ all -> 0x019c }
            L_0x0167:
                monitor-exit(r16)
                return
            L_0x0169:
                com.android.internal.telephony.InboundSmsHandler r0 = com.android.internal.telephony.InboundSmsHandler.this     // Catch:{ all -> 0x019c }
                java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x019c }
                r2.<init>()     // Catch:{ all -> 0x019c }
                java.lang.String r3 = "handleAction: Received "
                r2.append(r3)     // Catch:{ all -> 0x019c }
                r2.append(r1)     // Catch:{ all -> 0x019c }
                java.lang.String r1 = " when expecting "
                r2.append(r1)     // Catch:{ all -> 0x019c }
                android.content.Intent r1 = r9.mWaitingForIntent     // Catch:{ all -> 0x019c }
                r2.append(r1)     // Catch:{ all -> 0x019c }
                java.lang.String r1 = r2.toString()     // Catch:{ all -> 0x019c }
                if (r1 != 0) goto L_0x018b
                java.lang.String r1 = "none"
                goto L_0x0191
            L_0x018b:
                android.content.Intent r1 = r9.mWaitingForIntent     // Catch:{ all -> 0x019c }
                java.lang.String r1 = r1.getAction()     // Catch:{ all -> 0x019c }
            L_0x0191:
                com.android.internal.telephony.InboundSmsTracker r2 = r9.mInboundSmsTracker     // Catch:{ all -> 0x019c }
                long r2 = r2.getMessageId()     // Catch:{ all -> 0x019c }
                r0.logeWithLocalLog(r1, r2)     // Catch:{ all -> 0x019c }
                monitor-exit(r16)
                return
            L_0x019c:
                r0 = move-exception
                monitor-exit(r16)
                throw r0
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.InboundSmsHandler.SmsBroadcastReceiver.handleAction(android.content.Intent, boolean):void");
        }
    }

    public final class CarrierServicesSmsFilterCallback implements CarrierServicesSmsFilter.CarrierServicesSmsFilterCallbackInterface {
        private final boolean mBlock;
        private final int mDestPort;
        private final boolean mIsClass0;
        private final long mMessageId;
        private final byte[][] mPdus;
        private final List<SmsFilter> mRemainingFilters;
        private final SmsBroadcastReceiver mSmsBroadcastReceiver;
        private final String mSmsFormat;
        private final int mSubId;
        private final InboundSmsTracker mTracker;
        private final boolean mUserUnlocked;

        public CarrierServicesSmsFilterCallback(byte[][] bArr, int i, InboundSmsTracker inboundSmsTracker, String str, SmsBroadcastReceiver smsBroadcastReceiver, boolean z, boolean z2, int i2, long j, boolean z3, List<SmsFilter> list) {
            this.mPdus = bArr;
            this.mDestPort = i;
            this.mTracker = inboundSmsTracker;
            this.mSmsFormat = str;
            this.mSmsBroadcastReceiver = smsBroadcastReceiver;
            this.mUserUnlocked = z;
            this.mIsClass0 = z2;
            this.mSubId = i2;
            this.mMessageId = j;
            this.mBlock = z3;
            this.mRemainingFilters = list;
        }

        public void onFilterComplete(int i) {
            InboundSmsHandler inboundSmsHandler = InboundSmsHandler.this;
            inboundSmsHandler.log("onFilterComplete: result is " + i, this.mTracker.getMessageId());
            if ((i & 1) != 0) {
                InboundSmsHandler.this.dropFilteredSms(this.mTracker, this.mSmsBroadcastReceiver, this.mBlock);
            } else if (!InboundSmsHandler.filterSms(this.mPdus, this.mDestPort, this.mTracker, this.mSmsBroadcastReceiver, this.mUserUnlocked, this.mBlock, this.mRemainingFilters)) {
                if (this.mBlock) {
                    if (this.mUserUnlocked) {
                        InboundSmsHandler.this.log("onFilterComplete: dropping message as the sender is blocked", this.mTracker.getMessageId());
                        InboundSmsHandler.this.dropFilteredSms(this.mTracker, this.mSmsBroadcastReceiver, this.mBlock);
                        return;
                    }
                    InboundSmsHandler.this.sendMessage(3);
                } else if (this.mUserUnlocked) {
                    InboundSmsHandler.this.dispatchSmsDeliveryIntent(this.mPdus, this.mSmsFormat, this.mDestPort, this.mSmsBroadcastReceiver, this.mIsClass0, this.mSubId, this.mMessageId);
                } else {
                    if (!InboundSmsHandler.this.isSkipNotifyFlagSet(i)) {
                        InboundSmsHandler.this.showNewMessageNotification();
                    }
                    InboundSmsHandler.this.sendMessage(3);
                }
            }
        }
    }

    private void dropSms(SmsBroadcastReceiver smsBroadcastReceiver) {
        deleteFromRawTable(smsBroadcastReceiver.mDeleteWhere, smsBroadcastReceiver.mDeleteWhereArgs, 2);
        sendMessage(3);
    }

    /* access modifiers changed from: protected */
    public void logWithLocalLog(String str) {
        log(str);
        this.mLocalLog.log(str);
    }

    /* access modifiers changed from: protected */
    public void logWithLocalLog(String str, long j) {
        log(str, j);
        LocalLog localLog = this.mLocalLog;
        localLog.log(str + ", " + SmsController.formatCrossStackMessageId(j));
    }

    /* access modifiers changed from: protected */
    public void logeWithLocalLog(String str) {
        loge(str);
        this.mLocalLog.log(str);
    }

    /* access modifiers changed from: protected */
    public void logeWithLocalLog(String str, long j) {
        loge(str, j);
        LocalLog localLog = this.mLocalLog;
        localLog.log(str + ", " + SmsController.formatCrossStackMessageId(j));
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void log(String str) {
        Rlog.d(getName(), str);
    }

    /* access modifiers changed from: protected */
    public void log(String str, long j) {
        log(str + ", " + SmsController.formatCrossStackMessageId(j));
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void loge(String str) {
        Rlog.e(getName(), str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str, long j) {
        loge(str + ", " + SmsController.formatCrossStackMessageId(j));
    }

    /* access modifiers changed from: protected */
    public void loge(String str, Throwable th) {
        Rlog.e(getName(), str, th);
    }

    private static String buildMessageBodyFromPdus(SmsMessage[] smsMessageArr) {
        if (smsMessageArr.length == 1) {
            return replaceFormFeeds(smsMessageArr[0].getDisplayMessageBody());
        }
        StringBuilder sb = new StringBuilder();
        for (SmsMessage displayMessageBody : smsMessageArr) {
            sb.append(displayMessageBody.getDisplayMessageBody());
        }
        return replaceFormFeeds(sb.toString());
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        IndentingPrintWriter indentingPrintWriter = new IndentingPrintWriter(printWriter, "  ");
        indentingPrintWriter.println(getName() + " extends StateMachine:");
        indentingPrintWriter.increaseIndent();
        super.dump(fileDescriptor, indentingPrintWriter, strArr);
        CellBroadcastServiceManager cellBroadcastServiceManager = this.mCellBroadcastServiceManager;
        if (cellBroadcastServiceManager != null) {
            cellBroadcastServiceManager.dump(fileDescriptor, indentingPrintWriter, strArr);
        }
        indentingPrintWriter.println("mLocalLog:");
        indentingPrintWriter.increaseIndent();
        this.mLocalLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.println("mCarrierServiceLocalLog:");
        indentingPrintWriter.increaseIndent();
        this.mCarrierServiceLocalLog.dump(fileDescriptor, indentingPrintWriter, strArr);
        indentingPrintWriter.decreaseIndent();
        indentingPrintWriter.decreaseIndent();
    }

    private static String replaceFormFeeds(String str) {
        return str == null ? "" : str.replace(12, 10);
    }

    @VisibleForTesting
    public PowerManager.WakeLock getWakeLock() {
        return this.mWakeLock;
    }

    @VisibleForTesting
    public int getWakeLockTimeout() {
        return this.mWakeLockTimeout;
    }

    /* access modifiers changed from: private */
    public void setWakeLockTimeout(int i) {
        this.mWakeLockTimeout = i;
    }

    @VisibleForTesting
    public void setSmsFiltersForTesting(List<SmsFilter> list) {
        if (list == null) {
            this.mSmsFilters = createDefaultSmsFilters();
        } else {
            this.mSmsFilters = list;
        }
    }

    private static class NewMessageNotificationActionReceiver extends BroadcastReceiver {
        private NewMessageNotificationActionReceiver() {
        }

        public void onReceive(Context context, Intent intent) {
            if (InboundSmsHandler.ACTION_OPEN_SMS_APP.equals(intent.getAction()) && ((UserManager) context.getSystemService("user")).isUserUnlocked()) {
                context.startActivity(context.getPackageManager().getLaunchIntentForPackage(Telephony.Sms.getDefaultSmsPackage(context)));
            }
        }
    }

    /* access modifiers changed from: protected */
    public byte[] decodeHexString(String str) {
        if (str == null || str.length() % 2 == 1) {
            return null;
        }
        byte[] bArr = new byte[(str.length() / 2)];
        int i = 0;
        while (i < str.length()) {
            int i2 = i + 2;
            bArr[i / 2] = hexToByte(str.substring(i, i2));
            i = i2;
        }
        return bArr;
    }

    private byte hexToByte(String str) {
        int digit = toDigit(str.charAt(0));
        return (byte) ((digit << 4) + toDigit(str.charAt(1)));
    }

    private int toDigit(char c) {
        int digit = Character.digit(c, 16);
        if (digit == -1) {
            return 0;
        }
        return digit;
    }

    static void registerNewMessageNotificationActionHandler(Context context) {
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(ACTION_OPEN_SMS_APP);
        context.registerReceiver(new NewMessageNotificationActionReceiver(), intentFilter, 4);
    }

    protected abstract class CbTestBroadcastReceiver extends BroadcastReceiver {
        protected final String mTestAction;

        /* access modifiers changed from: protected */
        public abstract void handleTestAction(Intent intent);

        public CbTestBroadcastReceiver(String str) {
            this.mTestAction = str;
        }

        public void onReceive(Context context, Intent intent) {
            InboundSmsHandler inboundSmsHandler = InboundSmsHandler.this;
            inboundSmsHandler.logd("Received test intent action=" + intent.getAction());
            if (intent.getAction().equals(this.mTestAction)) {
                int phoneId = InboundSmsHandler.this.mPhone.getPhoneId();
                if (intent.getIntExtra("phone_id", phoneId) == phoneId) {
                    handleTestAction(intent);
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    public SmsMessage onCreateSmsMessage(byte[] bArr, String str) {
        return SmsMessage.createFromPdu(bArr, "3gpp");
    }

    /* access modifiers changed from: protected */
    public int onDispatchWapPdu(byte[][] bArr, byte[] bArr2, SmsBroadcastReceiver smsBroadcastReceiver, String str, int i, long j) {
        return this.mWapPush.dispatchWapPdu(bArr2, smsBroadcastReceiver, this, str, i, j);
    }
}
