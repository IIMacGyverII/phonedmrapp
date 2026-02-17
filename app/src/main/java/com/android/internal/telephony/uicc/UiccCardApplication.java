package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.Registrant;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;

public class UiccCardApplication {
    public static final int AUTH_CONTEXT_EAP_AKA = 129;
    public static final int AUTH_CONTEXT_EAP_SIM = 128;
    public static final int AUTH_CONTEXT_UNDEFINED = -1;
    private static final boolean DBG = true;
    private static final int EVENT_CHANGE_FACILITY_FDN_DONE = 5;
    protected static final int EVENT_CHANGE_FACILITY_LOCK_DONE = 7;
    private static final int EVENT_CHANGE_PIN1_DONE = 2;
    private static final int EVENT_CHANGE_PIN2_DONE = 3;
    protected static final int EVENT_PIN1_PUK1_DONE = 1;
    private static final int EVENT_PIN2_PUK2_DONE = 8;
    protected static final int EVENT_QUERY_FACILITY_FDN_DONE = 4;
    protected static final int EVENT_QUERY_FACILITY_LOCK_DONE = 6;
    private static final int EVENT_RADIO_UNAVAILABLE = 9;
    protected static final String LOG_TAG = "UiccCardApplication";
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected String mAid;
    protected String mAppLabel;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected IccCardApplicationStatus.AppState mAppState;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected IccCardApplicationStatus.AppType mAppType;
    protected int mAuthContext;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected CommandsInterface mCi;
    protected Context mContext;
    private boolean mDesiredFdnEnabled;
    protected boolean mDesiredPinLocked;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mDestroyed;
    private RegistrantList mDetectedRegistrants = new RegistrantList();
    protected Handler mHandler = new Handler() {
        public void handleMessage(Message message) {
            AsyncResult asyncResult;
            UiccCardApplication uiccCardApplication = UiccCardApplication.this;
            if (uiccCardApplication.mDestroyed) {
                uiccCardApplication.loge("Received message " + message + "[" + message.what + "] while being destroyed. Ignoring.");
                if (message.what == 1 && (asyncResult = (AsyncResult) message.obj) != null) {
                    asyncResult.exception = new CommandException(CommandException.Error.ABORTED);
                    Message message2 = (Message) asyncResult.userObj;
                    if (message2 != null) {
                        AsyncResult.forMessage(message2).exception = asyncResult.exception;
                        message2.sendToTarget();
                        return;
                    }
                    return;
                }
                return;
            }
            switch (message.what) {
                case 1:
                case 2:
                case 3:
                case 8:
                    AsyncResult asyncResult2 = (AsyncResult) message.obj;
                    int parsePinPukErrorResult = uiccCardApplication.parsePinPukErrorResult(asyncResult2);
                    Message message3 = (Message) asyncResult2.userObj;
                    AsyncResult.forMessage(message3).exception = asyncResult2.exception;
                    message3.arg1 = parsePinPukErrorResult;
                    message3.sendToTarget();
                    return;
                case 4:
                    uiccCardApplication.onQueryFdnEnabled((AsyncResult) message.obj);
                    return;
                case 5:
                    uiccCardApplication.onChangeFdnDone((AsyncResult) message.obj);
                    return;
                case 6:
                    uiccCardApplication.onQueryFacilityLock((AsyncResult) message.obj);
                    return;
                case 7:
                    uiccCardApplication.onChangeFacilityLock((AsyncResult) message.obj);
                    return;
                case 9:
                    uiccCardApplication.log("handleMessage (EVENT_RADIO_UNAVAILABLE)");
                    UiccCardApplication.this.mAppState = IccCardApplicationStatus.AppState.APPSTATE_UNKNOWN;
                    return;
                default:
                    uiccCardApplication.loge("Unknown Event " + message.what);
                    return;
            }
        }
    };
    private boolean mIccFdnAvailable = true;
    private boolean mIccFdnEnabled;
    protected IccFileHandler mIccFh;
    private boolean mIccLockEnabled;
    protected IccRecords mIccRecords;
    private boolean mIgnoreApp;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected final Object mLock = new Object();
    protected RegistrantList mNetworkLockedRegistrants = new RegistrantList();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected IccCardApplicationStatus.PersoSubState mPersoSubState;
    protected boolean mPin1Replaced;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected IccCardStatus.PinState mPin1State;
    protected IccCardStatus.PinState mPin2State;
    private RegistrantList mPinLockedRegistrants = new RegistrantList();
    private RegistrantList mReadyRegistrants = new RegistrantList();
    private UiccProfile mUiccProfile;

    /* access modifiers changed from: protected */
    public boolean supportExtendedMeLockCategory() {
        return false;
    }

    public UiccCardApplication(UiccProfile uiccProfile, IccCardApplicationStatus iccCardApplicationStatus, Context context, CommandsInterface commandsInterface) {
        log("Creating UiccApp: " + iccCardApplicationStatus);
        this.mUiccProfile = uiccProfile;
        this.mAppState = iccCardApplicationStatus.app_state;
        IccCardApplicationStatus.AppType appType = iccCardApplicationStatus.app_type;
        this.mAppType = appType;
        this.mAuthContext = getAuthContext(appType);
        this.mPersoSubState = iccCardApplicationStatus.perso_substate;
        this.mAid = iccCardApplicationStatus.aid;
        this.mAppLabel = iccCardApplicationStatus.app_label;
        this.mPin1Replaced = iccCardApplicationStatus.pin1_replaced;
        this.mPin1State = iccCardApplicationStatus.pin1;
        this.mPin2State = iccCardApplicationStatus.pin2;
        this.mIgnoreApp = false;
        this.mContext = context;
        this.mCi = commandsInterface;
        this.mIccFh = createIccFileHandler(iccCardApplicationStatus.app_type);
        this.mIccRecords = createIccRecords(iccCardApplicationStatus.app_type, this.mContext, this.mCi);
        if (this.mAppState == IccCardApplicationStatus.AppState.APPSTATE_READY) {
            queryFdn();
            queryPin1State();
        }
        this.mCi.registerForNotAvailable(this.mHandler, 9, (Object) null);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:34:0x00d2, code lost:
        return;
     */
    @android.compat.annotation.UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void update(com.android.internal.telephony.uicc.IccCardApplicationStatus r7, android.content.Context r8, com.android.internal.telephony.CommandsInterface r9) {
        /*
            r6 = this;
            java.lang.Object r0 = r6.mLock
            monitor-enter(r0)
            boolean r1 = r6.mDestroyed     // Catch:{ all -> 0x00d3 }
            if (r1 == 0) goto L_0x000e
            java.lang.String r7 = "Application updated after destroyed! Fix me!"
            r6.loge(r7)     // Catch:{ all -> 0x00d3 }
            monitor-exit(r0)     // Catch:{ all -> 0x00d3 }
            return
        L_0x000e:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x00d3 }
            r1.<init>()     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r2 = r6.mAppType     // Catch:{ all -> 0x00d3 }
            r1.append(r2)     // Catch:{ all -> 0x00d3 }
            java.lang.String r2 = " update. New "
            r1.append(r2)     // Catch:{ all -> 0x00d3 }
            r1.append(r7)     // Catch:{ all -> 0x00d3 }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x00d3 }
            r6.log(r1)     // Catch:{ all -> 0x00d3 }
            r6.mContext = r8     // Catch:{ all -> 0x00d3 }
            r6.mCi = r9     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r1 = r6.mAppType     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r2 = r6.mAppState     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r3 = r6.mPersoSubState     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardStatus$PinState r4 = r6.mPin1State     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r5 = r7.app_type     // Catch:{ all -> 0x00d3 }
            r6.mAppType = r5     // Catch:{ all -> 0x00d3 }
            int r5 = getAuthContext(r5)     // Catch:{ all -> 0x00d3 }
            r6.mAuthContext = r5     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r5 = r7.app_state     // Catch:{ all -> 0x00d3 }
            r6.mAppState = r5     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r5 = r7.perso_substate     // Catch:{ all -> 0x00d3 }
            r6.mPersoSubState = r5     // Catch:{ all -> 0x00d3 }
            java.lang.String r5 = r7.aid     // Catch:{ all -> 0x00d3 }
            r6.mAid = r5     // Catch:{ all -> 0x00d3 }
            java.lang.String r5 = r7.app_label     // Catch:{ all -> 0x00d3 }
            r6.mAppLabel = r5     // Catch:{ all -> 0x00d3 }
            boolean r5 = r7.pin1_replaced     // Catch:{ all -> 0x00d3 }
            r6.mPin1Replaced = r5     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardStatus$PinState r5 = r7.pin1     // Catch:{ all -> 0x00d3 }
            r6.mPin1State = r5     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardStatus$PinState r5 = r7.pin2     // Catch:{ all -> 0x00d3 }
            r6.mPin2State = r5     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r5 = r6.mAppType     // Catch:{ all -> 0x00d3 }
            if (r5 == r1) goto L_0x007b
            com.android.internal.telephony.uicc.IccFileHandler r5 = r6.mIccFh     // Catch:{ all -> 0x00d3 }
            if (r5 == 0) goto L_0x0064
            r5.dispose()     // Catch:{ all -> 0x00d3 }
        L_0x0064:
            com.android.internal.telephony.uicc.IccRecords r5 = r6.mIccRecords     // Catch:{ all -> 0x00d3 }
            if (r5 == 0) goto L_0x006b
            r5.dispose()     // Catch:{ all -> 0x00d3 }
        L_0x006b:
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r5 = r7.app_type     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccFileHandler r5 = r6.createIccFileHandler(r5)     // Catch:{ all -> 0x00d3 }
            r6.mIccFh = r5     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r7 = r7.app_type     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccRecords r7 = r6.createIccRecords(r7, r8, r9)     // Catch:{ all -> 0x00d3 }
            r6.mIccRecords = r7     // Catch:{ all -> 0x00d3 }
        L_0x007b:
            com.android.internal.telephony.uicc.IccCardApplicationStatus$PersoSubState r7 = r6.mPersoSubState     // Catch:{ all -> 0x00d3 }
            r8 = 0
            if (r7 == r3) goto L_0x008f
            boolean r7 = com.android.internal.telephony.uicc.IccCardApplicationStatus.PersoSubState.isPersoLocked(r7)     // Catch:{ all -> 0x00d3 }
            if (r7 != 0) goto L_0x008c
            boolean r7 = r6.supportExtendedMeLockCategory()     // Catch:{ all -> 0x00d3 }
            if (r7 == 0) goto L_0x008f
        L_0x008c:
            r6.notifyNetworkLockedRegistrantsIfNeeded(r8)     // Catch:{ all -> 0x00d3 }
        L_0x008f:
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r7 = r6.mAppState     // Catch:{ all -> 0x00d3 }
            if (r7 == r2) goto L_0x00ca
            java.lang.StringBuilder r7 = new java.lang.StringBuilder     // Catch:{ all -> 0x00d3 }
            r7.<init>()     // Catch:{ all -> 0x00d3 }
            r7.append(r1)     // Catch:{ all -> 0x00d3 }
            java.lang.String r9 = " changed state: "
            r7.append(r9)     // Catch:{ all -> 0x00d3 }
            r7.append(r2)     // Catch:{ all -> 0x00d3 }
            java.lang.String r9 = " -> "
            r7.append(r9)     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r9 = r6.mAppState     // Catch:{ all -> 0x00d3 }
            r7.append(r9)     // Catch:{ all -> 0x00d3 }
            java.lang.String r7 = r7.toString()     // Catch:{ all -> 0x00d3 }
            r6.log(r7)     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r7 = r6.mAppState     // Catch:{ all -> 0x00d3 }
            com.android.internal.telephony.uicc.IccCardApplicationStatus$AppState r9 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppState.APPSTATE_READY     // Catch:{ all -> 0x00d3 }
            if (r7 != r9) goto L_0x00c0
            r6.queryFdn()     // Catch:{ all -> 0x00d3 }
            r6.queryPin1State()     // Catch:{ all -> 0x00d3 }
        L_0x00c0:
            r6.notifyPinLockedRegistrantsIfNeeded(r8)     // Catch:{ all -> 0x00d3 }
            r6.notifyReadyRegistrantsIfNeeded(r8)     // Catch:{ all -> 0x00d3 }
            r6.notifyDetectedRegistrantsIfNeeded(r8)     // Catch:{ all -> 0x00d3 }
            goto L_0x00d1
        L_0x00ca:
            com.android.internal.telephony.uicc.IccCardStatus$PinState r7 = r6.mPin1State     // Catch:{ all -> 0x00d3 }
            if (r7 == r4) goto L_0x00d1
            r6.queryPin1State()     // Catch:{ all -> 0x00d3 }
        L_0x00d1:
            monitor-exit(r0)     // Catch:{ all -> 0x00d3 }
            return
        L_0x00d3:
            r6 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x00d3 }
            throw r6
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccCardApplication.update(com.android.internal.telephony.uicc.IccCardApplicationStatus, android.content.Context, com.android.internal.telephony.CommandsInterface):void");
    }

    /* access modifiers changed from: package-private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void dispose() {
        synchronized (this.mLock) {
            log(this.mAppType + " being Disposed");
            this.mDestroyed = true;
            IccRecords iccRecords = this.mIccRecords;
            if (iccRecords != null) {
                iccRecords.dispose();
            }
            IccFileHandler iccFileHandler = this.mIccFh;
            if (iccFileHandler != null) {
                iccFileHandler.dispose();
            }
            this.mIccRecords = null;
            this.mIccFh = null;
            this.mCi.unregisterForNotAvailable(this.mHandler);
        }
    }

    /* access modifiers changed from: protected */
    public IccRecords createIccRecords(IccCardApplicationStatus.AppType appType, Context context, CommandsInterface commandsInterface) {
        if (appType == IccCardApplicationStatus.AppType.APPTYPE_USIM || appType == IccCardApplicationStatus.AppType.APPTYPE_SIM) {
            return new SIMRecords(this, context, commandsInterface);
        }
        if (appType == IccCardApplicationStatus.AppType.APPTYPE_RUIM || appType == IccCardApplicationStatus.AppType.APPTYPE_CSIM) {
            return new RuimRecords(this, context, commandsInterface);
        }
        if (appType == IccCardApplicationStatus.AppType.APPTYPE_ISIM) {
            return new IsimUiccRecords(this, context, commandsInterface);
        }
        return null;
    }

    /* access modifiers changed from: protected */
    public IccFileHandler createIccFileHandler(IccCardApplicationStatus.AppType appType) {
        int i = AnonymousClass2.$SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$AppType[appType.ordinal()];
        if (i == 1) {
            return new SIMFileHandler(this, this.mAid, this.mCi);
        }
        if (i == 2) {
            return new RuimFileHandler(this, this.mAid, this.mCi);
        }
        if (i == 3) {
            return new UsimFileHandler(this, this.mAid, this.mCi);
        }
        if (i == 4) {
            return new CsimFileHandler(this, this.mAid, this.mCi);
        }
        if (i != 5) {
            return null;
        }
        return new IsimFileHandler(this, this.mAid, this.mCi);
    }

    public void queryFdn() {
        this.mCi.queryFacilityLockForApp(CommandsInterface.CB_FACILITY_BA_FD, "", 7, this.mAid, this.mHandler.obtainMessage(4));
    }

    /* access modifiers changed from: private */
    /* JADX WARNING: Code restructure failed: missing block: B:20:0x0060, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void onQueryFdnEnabled(android.os.AsyncResult r4) {
        /*
            r3 = this;
            java.lang.Object r0 = r3.mLock
            monitor-enter(r0)
            java.lang.Throwable r1 = r4.exception     // Catch:{ all -> 0x0061 }
            if (r1 == 0) goto L_0x001f
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x0061 }
            r1.<init>()     // Catch:{ all -> 0x0061 }
            java.lang.String r2 = "Error in querying facility lock:"
            r1.append(r2)     // Catch:{ all -> 0x0061 }
            java.lang.Throwable r4 = r4.exception     // Catch:{ all -> 0x0061 }
            r1.append(r4)     // Catch:{ all -> 0x0061 }
            java.lang.String r4 = r1.toString()     // Catch:{ all -> 0x0061 }
            r3.log(r4)     // Catch:{ all -> 0x0061 }
            monitor-exit(r0)     // Catch:{ all -> 0x0061 }
            return
        L_0x001f:
            java.lang.Object r4 = r4.result     // Catch:{ all -> 0x0061 }
            int[] r4 = (int[]) r4     // Catch:{ all -> 0x0061 }
            int r1 = r4.length     // Catch:{ all -> 0x0061 }
            if (r1 == 0) goto L_0x005a
            r1 = 0
            r4 = r4[r1]     // Catch:{ all -> 0x0061 }
            r2 = 2
            if (r4 != r2) goto L_0x0031
            r3.mIccFdnEnabled = r1     // Catch:{ all -> 0x0061 }
            r3.mIccFdnAvailable = r1     // Catch:{ all -> 0x0061 }
            goto L_0x0039
        L_0x0031:
            r2 = 1
            if (r4 != r2) goto L_0x0035
            r1 = r2
        L_0x0035:
            r3.mIccFdnEnabled = r1     // Catch:{ all -> 0x0061 }
            r3.mIccFdnAvailable = r2     // Catch:{ all -> 0x0061 }
        L_0x0039:
            java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ all -> 0x0061 }
            r4.<init>()     // Catch:{ all -> 0x0061 }
            java.lang.String r1 = "Query facility FDN : FDN service available: "
            r4.append(r1)     // Catch:{ all -> 0x0061 }
            boolean r1 = r3.mIccFdnAvailable     // Catch:{ all -> 0x0061 }
            r4.append(r1)     // Catch:{ all -> 0x0061 }
            java.lang.String r1 = " enabled: "
            r4.append(r1)     // Catch:{ all -> 0x0061 }
            boolean r1 = r3.mIccFdnEnabled     // Catch:{ all -> 0x0061 }
            r4.append(r1)     // Catch:{ all -> 0x0061 }
            java.lang.String r4 = r4.toString()     // Catch:{ all -> 0x0061 }
            r3.log(r4)     // Catch:{ all -> 0x0061 }
            goto L_0x005f
        L_0x005a:
            java.lang.String r4 = "Bogus facility lock response"
            r3.loge(r4)     // Catch:{ all -> 0x0061 }
        L_0x005f:
            monitor-exit(r0)     // Catch:{ all -> 0x0061 }
            return
        L_0x0061:
            r3 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0061 }
            throw r3
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccCardApplication.onQueryFdnEnabled(android.os.AsyncResult):void");
    }

    /* access modifiers changed from: protected */
    public void onChangeFdnDone(AsyncResult asyncResult) {
        synchronized (this.mLock) {
            int i = -1;
            if (asyncResult.exception == null) {
                this.mIccFdnEnabled = this.mDesiredFdnEnabled;
                log("EVENT_CHANGE_FACILITY_FDN_DONE: mIccFdnEnabled=" + this.mIccFdnEnabled);
            } else {
                i = parsePinPukErrorResult(asyncResult);
                loge("Error change facility fdn with exception " + asyncResult.exception);
            }
            Message message = (Message) asyncResult.userObj;
            message.arg1 = i;
            AsyncResult.forMessage(message).exception = asyncResult.exception;
            message.sendToTarget();
        }
    }

    /* access modifiers changed from: protected */
    public void queryPin1State() {
        this.mCi.queryFacilityLockForApp(CommandsInterface.CB_FACILITY_BA_SIM, "", 7, this.mAid, this.mHandler.obtainMessage(6));
    }

    /* access modifiers changed from: private */
    /* JADX WARNING: Code restructure failed: missing block: B:33:0x008e, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void onQueryFacilityLock(android.os.AsyncResult r5) {
        /*
            r4 = this;
            java.lang.Object r0 = r4.mLock
            monitor-enter(r0)
            java.lang.Throwable r1 = r5.exception     // Catch:{ all -> 0x008f }
            if (r1 == 0) goto L_0x001f
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x008f }
            r1.<init>()     // Catch:{ all -> 0x008f }
            java.lang.String r2 = "Error in querying facility lock:"
            r1.append(r2)     // Catch:{ all -> 0x008f }
            java.lang.Throwable r5 = r5.exception     // Catch:{ all -> 0x008f }
            r1.append(r5)     // Catch:{ all -> 0x008f }
            java.lang.String r5 = r1.toString()     // Catch:{ all -> 0x008f }
            r4.log(r5)     // Catch:{ all -> 0x008f }
            monitor-exit(r0)     // Catch:{ all -> 0x008f }
            return
        L_0x001f:
            java.lang.Object r5 = r5.result     // Catch:{ all -> 0x008f }
            int[] r5 = (int[]) r5     // Catch:{ all -> 0x008f }
            int r1 = r5.length     // Catch:{ all -> 0x008f }
            if (r1 == 0) goto L_0x0088
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x008f }
            r1.<init>()     // Catch:{ all -> 0x008f }
            java.lang.String r2 = "Query facility lock : "
            r1.append(r2)     // Catch:{ all -> 0x008f }
            r2 = 0
            r3 = r5[r2]     // Catch:{ all -> 0x008f }
            r1.append(r3)     // Catch:{ all -> 0x008f }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x008f }
            r4.log(r1)     // Catch:{ all -> 0x008f }
            r5 = r5[r2]     // Catch:{ all -> 0x008f }
            r1 = 1
            if (r5 == 0) goto L_0x0043
            r2 = r1
        L_0x0043:
            r4.mIccLockEnabled = r2     // Catch:{ all -> 0x008f }
            int[] r5 = com.android.internal.telephony.uicc.UiccCardApplication.AnonymousClass2.$SwitchMap$com$android$internal$telephony$uicc$IccCardStatus$PinState     // Catch:{ all -> 0x008f }
            com.android.internal.telephony.uicc.IccCardStatus$PinState r2 = r4.mPin1State     // Catch:{ all -> 0x008f }
            int r2 = r2.ordinal()     // Catch:{ all -> 0x008f }
            r5 = r5[r2]     // Catch:{ all -> 0x008f }
            if (r5 == r1) goto L_0x007e
            r1 = 2
            if (r5 == r1) goto L_0x005e
            r1 = 3
            if (r5 == r1) goto L_0x005e
            r1 = 4
            if (r5 == r1) goto L_0x005e
            r1 = 5
            if (r5 == r1) goto L_0x005e
            goto L_0x0067
        L_0x005e:
            boolean r5 = r4.mIccLockEnabled     // Catch:{ all -> 0x008f }
            if (r5 != 0) goto L_0x0067
            java.lang.String r5 = "QUERY_FACILITY_LOCK:disabled GET_SIM_STATUS.Pin1:enabled. Fixme"
            r4.loge(r5)     // Catch:{ all -> 0x008f }
        L_0x0067:
            java.lang.StringBuilder r5 = new java.lang.StringBuilder     // Catch:{ all -> 0x008f }
            r5.<init>()     // Catch:{ all -> 0x008f }
            java.lang.String r1 = "Ignoring: pin1state="
            r5.append(r1)     // Catch:{ all -> 0x008f }
            com.android.internal.telephony.uicc.IccCardStatus$PinState r1 = r4.mPin1State     // Catch:{ all -> 0x008f }
            r5.append(r1)     // Catch:{ all -> 0x008f }
            java.lang.String r5 = r5.toString()     // Catch:{ all -> 0x008f }
            r4.log(r5)     // Catch:{ all -> 0x008f }
            goto L_0x008d
        L_0x007e:
            boolean r5 = r4.mIccLockEnabled     // Catch:{ all -> 0x008f }
            if (r5 == 0) goto L_0x008d
            java.lang.String r5 = "QUERY_FACILITY_LOCK:enabled GET_SIM_STATUS.Pin1:disabled. Fixme"
            r4.loge(r5)     // Catch:{ all -> 0x008f }
            goto L_0x008d
        L_0x0088:
            java.lang.String r5 = "Bogus facility lock response"
            r4.loge(r5)     // Catch:{ all -> 0x008f }
        L_0x008d:
            monitor-exit(r0)     // Catch:{ all -> 0x008f }
            return
        L_0x008f:
            r4 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x008f }
            throw r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccCardApplication.onQueryFacilityLock(android.os.AsyncResult):void");
    }

    /* renamed from: com.android.internal.telephony.uicc.UiccCardApplication$2  reason: invalid class name */
    static /* synthetic */ class AnonymousClass2 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$AppType;
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$uicc$IccCardStatus$PinState;

        /* JADX WARNING: Can't wrap try/catch for region: R(23:0|(2:1|2)|3|(2:5|6)|7|9|10|11|(2:13|14)|15|17|18|(2:19|20)|21|23|24|25|26|27|28|29|30|(3:31|32|34)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(25:0|1|2|3|(2:5|6)|7|9|10|11|(2:13|14)|15|17|18|19|20|21|23|24|25|26|27|28|29|30|(3:31|32|34)) */
        /* JADX WARNING: Can't wrap try/catch for region: R(28:0|1|2|3|(2:5|6)|7|9|10|11|13|14|15|17|18|19|20|21|23|24|25|26|27|28|29|30|31|32|34) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:19:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:25:0x005a */
        /* JADX WARNING: Missing exception handler attribute for start block: B:27:0x0064 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:29:0x006e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:31:0x0078 */
        static {
            /*
                com.android.internal.telephony.uicc.IccCardStatus$PinState[] r0 = com.android.internal.telephony.uicc.IccCardStatus.PinState.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$uicc$IccCardStatus$PinState = r0
                r1 = 1
                com.android.internal.telephony.uicc.IccCardStatus$PinState r2 = com.android.internal.telephony.uicc.IccCardStatus.PinState.PINSTATE_DISABLED     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r2 = r2.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r0[r2] = r1     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                r0 = 2
                int[] r2 = $SwitchMap$com$android$internal$telephony$uicc$IccCardStatus$PinState     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.uicc.IccCardStatus$PinState r3 = com.android.internal.telephony.uicc.IccCardStatus.PinState.PINSTATE_ENABLED_NOT_VERIFIED     // Catch:{ NoSuchFieldError -> 0x001d }
                int r3 = r3.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2[r3] = r0     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                r2 = 3
                int[] r3 = $SwitchMap$com$android$internal$telephony$uicc$IccCardStatus$PinState     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.uicc.IccCardStatus$PinState r4 = com.android.internal.telephony.uicc.IccCardStatus.PinState.PINSTATE_ENABLED_VERIFIED     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r4 = r4.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r3[r4] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                r3 = 4
                int[] r4 = $SwitchMap$com$android$internal$telephony$uicc$IccCardStatus$PinState     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.uicc.IccCardStatus$PinState r5 = com.android.internal.telephony.uicc.IccCardStatus.PinState.PINSTATE_ENABLED_BLOCKED     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r4[r5] = r3     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                r4 = 5
                int[] r5 = $SwitchMap$com$android$internal$telephony$uicc$IccCardStatus$PinState     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.uicc.IccCardStatus$PinState r6 = com.android.internal.telephony.uicc.IccCardStatus.PinState.PINSTATE_ENABLED_PERM_BLOCKED     // Catch:{ NoSuchFieldError -> 0x003e }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r5[r6] = r4     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r5 = $SwitchMap$com$android$internal$telephony$uicc$IccCardStatus$PinState     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.uicc.IccCardStatus$PinState r6 = com.android.internal.telephony.uicc.IccCardStatus.PinState.PINSTATE_UNKNOWN     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r7 = 6
                r5[r6] = r7     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType[] r5 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppType.values()
                int r5 = r5.length
                int[] r5 = new int[r5]
                $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$AppType = r5
                com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r6 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppType.APPTYPE_SIM     // Catch:{ NoSuchFieldError -> 0x005a }
                int r6 = r6.ordinal()     // Catch:{ NoSuchFieldError -> 0x005a }
                r5[r6] = r1     // Catch:{ NoSuchFieldError -> 0x005a }
            L_0x005a:
                int[] r1 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$AppType     // Catch:{ NoSuchFieldError -> 0x0064 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r5 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppType.APPTYPE_RUIM     // Catch:{ NoSuchFieldError -> 0x0064 }
                int r5 = r5.ordinal()     // Catch:{ NoSuchFieldError -> 0x0064 }
                r1[r5] = r0     // Catch:{ NoSuchFieldError -> 0x0064 }
            L_0x0064:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$AppType     // Catch:{ NoSuchFieldError -> 0x006e }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppType.APPTYPE_USIM     // Catch:{ NoSuchFieldError -> 0x006e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x006e }
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x006e }
            L_0x006e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$AppType     // Catch:{ NoSuchFieldError -> 0x0078 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppType.APPTYPE_CSIM     // Catch:{ NoSuchFieldError -> 0x0078 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0078 }
                r0[r1] = r3     // Catch:{ NoSuchFieldError -> 0x0078 }
            L_0x0078:
                int[] r0 = $SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$AppType     // Catch:{ NoSuchFieldError -> 0x0082 }
                com.android.internal.telephony.uicc.IccCardApplicationStatus$AppType r1 = com.android.internal.telephony.uicc.IccCardApplicationStatus.AppType.APPTYPE_ISIM     // Catch:{ NoSuchFieldError -> 0x0082 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0082 }
                r0[r1] = r4     // Catch:{ NoSuchFieldError -> 0x0082 }
            L_0x0082:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.UiccCardApplication.AnonymousClass2.<clinit>():void");
        }
    }

    /* access modifiers changed from: protected */
    public void onChangeFacilityLock(AsyncResult asyncResult) {
        synchronized (this.mLock) {
            int i = -1;
            if (asyncResult.exception == null) {
                this.mIccLockEnabled = this.mDesiredPinLocked;
                log("EVENT_CHANGE_FACILITY_LOCK_DONE: mIccLockEnabled= " + this.mIccLockEnabled);
            } else {
                i = parsePinPukErrorResult(asyncResult);
                loge("Error change facility lock with exception " + asyncResult.exception);
            }
            Message message = (Message) asyncResult.userObj;
            AsyncResult.forMessage(message).exception = asyncResult.exception;
            message.arg1 = i;
            message.sendToTarget();
        }
    }

    /* access modifiers changed from: protected */
    public int parsePinPukErrorResult(AsyncResult asyncResult) {
        int[] iArr = (int[]) asyncResult.result;
        int i = -1;
        if (iArr == null) {
            return -1;
        }
        if (iArr.length > 0) {
            i = iArr[0];
        }
        log("parsePinPukErrorResult: attemptsRemaining=" + i);
        return i;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void registerForReady(Handler handler, int i, Object obj) {
        synchronized (this.mLock) {
            Registrant registrant = new Registrant(handler, i, obj);
            this.mReadyRegistrants.add(registrant);
            notifyReadyRegistrantsIfNeeded(registrant);
        }
    }

    @UnsupportedAppUsage
    public void unregisterForReady(Handler handler) {
        synchronized (this.mLock) {
            this.mReadyRegistrants.remove(handler);
        }
    }

    public void registerForDetected(Handler handler, int i, Object obj) {
        synchronized (this.mLock) {
            Registrant registrant = new Registrant(handler, i, obj);
            this.mDetectedRegistrants.add(registrant);
            notifyDetectedRegistrantsIfNeeded(registrant);
        }
    }

    public void unregisterForDetected(Handler handler) {
        synchronized (this.mLock) {
            this.mDetectedRegistrants.remove(handler);
        }
    }

    /* access modifiers changed from: protected */
    public void registerForLocked(Handler handler, int i, Object obj) {
        synchronized (this.mLock) {
            Registrant registrant = new Registrant(handler, i, obj);
            this.mPinLockedRegistrants.add(registrant);
            notifyPinLockedRegistrantsIfNeeded(registrant);
        }
    }

    /* access modifiers changed from: protected */
    public void unregisterForLocked(Handler handler) {
        synchronized (this.mLock) {
            this.mPinLockedRegistrants.remove(handler);
        }
    }

    /* access modifiers changed from: protected */
    public void registerForNetworkLocked(Handler handler, int i, Object obj) {
        synchronized (this.mLock) {
            Registrant registrant = new Registrant(handler, i, obj);
            this.mNetworkLockedRegistrants.add(registrant);
            notifyNetworkLockedRegistrantsIfNeeded(registrant);
        }
    }

    /* access modifiers changed from: protected */
    public void unregisterForNetworkLocked(Handler handler) {
        synchronized (this.mLock) {
            this.mNetworkLockedRegistrants.remove(handler);
        }
    }

    /* access modifiers changed from: protected */
    public void notifyReadyRegistrantsIfNeeded(Registrant registrant) {
        if (!this.mDestroyed && this.mAppState == IccCardApplicationStatus.AppState.APPSTATE_READY) {
            IccCardStatus.PinState pinState = this.mPin1State;
            if (pinState == IccCardStatus.PinState.PINSTATE_ENABLED_NOT_VERIFIED || pinState == IccCardStatus.PinState.PINSTATE_ENABLED_BLOCKED || pinState == IccCardStatus.PinState.PINSTATE_ENABLED_PERM_BLOCKED) {
                loge("Sanity check failed! APPSTATE is ready while PIN1 is not verified!!!");
            } else if (registrant == null) {
                log("Notifying registrants: READY");
                this.mReadyRegistrants.notifyRegistrants();
            } else {
                log("Notifying 1 registrant: READY");
                registrant.notifyRegistrant(new AsyncResult((Object) null, (Object) null, (Throwable) null));
            }
        }
    }

    private void notifyDetectedRegistrantsIfNeeded(Registrant registrant) {
        if (this.mDestroyed || this.mAppState != IccCardApplicationStatus.AppState.APPSTATE_DETECTED) {
            return;
        }
        if (registrant == null) {
            log("Notifying registrants: DETECTED");
            this.mDetectedRegistrants.notifyRegistrants();
            return;
        }
        log("Notifying 1 registrant: DETECTED");
        registrant.notifyRegistrant(new AsyncResult((Object) null, (Object) null, (Throwable) null));
    }

    /* access modifiers changed from: protected */
    public void notifyPinLockedRegistrantsIfNeeded(Registrant registrant) {
        if (!this.mDestroyed) {
            IccCardApplicationStatus.AppState appState = this.mAppState;
            if (appState == IccCardApplicationStatus.AppState.APPSTATE_PIN || appState == IccCardApplicationStatus.AppState.APPSTATE_PUK) {
                IccCardStatus.PinState pinState = this.mPin1State;
                if (pinState == IccCardStatus.PinState.PINSTATE_ENABLED_VERIFIED || pinState == IccCardStatus.PinState.PINSTATE_DISABLED) {
                    loge("Sanity check failed! APPSTATE is locked while PIN1 is not!!!");
                } else if (registrant == null) {
                    log("Notifying registrants: LOCKED");
                    this.mPinLockedRegistrants.notifyRegistrants();
                } else {
                    log("Notifying 1 registrant: LOCKED");
                    registrant.notifyRegistrant(new AsyncResult((Object) null, (Object) null, (Throwable) null));
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    public void notifyNetworkLockedRegistrantsIfNeeded(Registrant registrant) {
        if (!this.mDestroyed && this.mAppState == IccCardApplicationStatus.AppState.APPSTATE_SUBSCRIPTION_PERSO && IccCardApplicationStatus.PersoSubState.isPersoLocked(this.mPersoSubState)) {
            AsyncResult asyncResult = new AsyncResult((Object) null, Integer.valueOf(this.mPersoSubState.ordinal()), (Throwable) null);
            if (registrant == null) {
                log("Notifying registrants: NETWORK_LOCKED with mPersoSubState" + this.mPersoSubState);
                this.mNetworkLockedRegistrants.notifyRegistrants(asyncResult);
                return;
            }
            log("Notifying 1 registrant: NETWORK_LOCKED with mPersoSubState" + this.mPersoSubState);
            registrant.notifyRegistrant(asyncResult);
        }
    }

    @UnsupportedAppUsage
    public IccCardApplicationStatus.AppState getState() {
        IccCardApplicationStatus.AppState appState;
        synchronized (this.mLock) {
            appState = this.mAppState;
        }
        return appState;
    }

    @UnsupportedAppUsage
    public IccCardApplicationStatus.AppType getType() {
        IccCardApplicationStatus.AppType appType;
        synchronized (this.mLock) {
            appType = this.mAppType;
        }
        return appType;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getAuthContext() {
        int i;
        synchronized (this.mLock) {
            i = this.mAuthContext;
        }
        return i;
    }

    private static int getAuthContext(IccCardApplicationStatus.AppType appType) {
        int i = AnonymousClass2.$SwitchMap$com$android$internal$telephony$uicc$IccCardApplicationStatus$AppType[appType.ordinal()];
        if (i != 1) {
            return i != 3 ? -1 : 129;
        }
        return 128;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public IccCardApplicationStatus.PersoSubState getPersoSubState() {
        IccCardApplicationStatus.PersoSubState persoSubState;
        synchronized (this.mLock) {
            persoSubState = this.mPersoSubState;
        }
        return persoSubState;
    }

    @UnsupportedAppUsage
    public String getAid() {
        String str;
        synchronized (this.mLock) {
            str = this.mAid;
        }
        return str;
    }

    public String getAppLabel() {
        return this.mAppLabel;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public IccCardStatus.PinState getPin1State() {
        synchronized (this.mLock) {
            if (this.mPin1Replaced) {
                IccCardStatus.PinState universalPinState = this.mUiccProfile.getUniversalPinState();
                return universalPinState;
            }
            IccCardStatus.PinState pinState = this.mPin1State;
            return pinState;
        }
    }

    @UnsupportedAppUsage
    public IccFileHandler getIccFileHandler() {
        IccFileHandler iccFileHandler;
        synchronized (this.mLock) {
            iccFileHandler = this.mIccFh;
        }
        return iccFileHandler;
    }

    @UnsupportedAppUsage
    public IccRecords getIccRecords() {
        IccRecords iccRecords;
        synchronized (this.mLock) {
            iccRecords = this.mIccRecords;
        }
        return iccRecords;
    }

    public void supplyPin(String str, Message message) {
        synchronized (this.mLock) {
            this.mCi.supplyIccPinForApp(str, this.mAid, this.mHandler.obtainMessage(1, message));
        }
    }

    public void supplyPuk(String str, String str2, Message message) {
        synchronized (this.mLock) {
            this.mCi.supplyIccPukForApp(str, str2, this.mAid, this.mHandler.obtainMessage(1, message));
        }
    }

    public void supplyPin2(String str, Message message) {
        synchronized (this.mLock) {
            this.mCi.supplyIccPin2ForApp(str, this.mAid, this.mHandler.obtainMessage(8, message));
        }
    }

    public void supplyPuk2(String str, String str2, Message message) {
        synchronized (this.mLock) {
            this.mCi.supplyIccPuk2ForApp(str, str2, this.mAid, this.mHandler.obtainMessage(8, message));
        }
    }

    public void supplyNetworkDepersonalization(String str, Message message) {
        synchronized (this.mLock) {
            log("supplyNetworkDepersonalization");
            this.mCi.supplyNetworkDepersonalization(str, message);
        }
    }

    public void supplySimDepersonalization(IccCardApplicationStatus.PersoSubState persoSubState, String str, Message message) {
        synchronized (this.mLock) {
            log("supplySimDepersonalization");
            this.mCi.supplySimDepersonalization(persoSubState, str, message);
        }
    }

    public boolean getIccLockEnabled() {
        return this.mIccLockEnabled;
    }

    public boolean getIccFdnEnabled() {
        boolean z;
        synchronized (this.mLock) {
            z = this.mIccFdnEnabled;
        }
        return z;
    }

    public boolean getIccFdnAvailable() {
        return this.mIccFdnAvailable;
    }

    public void setIccLockEnabled(boolean z, String str, Message message) {
        synchronized (this.mLock) {
            this.mDesiredPinLocked = z;
            this.mCi.setFacilityLockForApp(CommandsInterface.CB_FACILITY_BA_SIM, z, str, 7, this.mAid, this.mHandler.obtainMessage(7, message));
        }
    }

    public void setIccFdnEnabled(boolean z, String str, Message message) {
        synchronized (this.mLock) {
            this.mDesiredFdnEnabled = z;
            this.mCi.setFacilityLockForApp(CommandsInterface.CB_FACILITY_BA_FD, z, str, 15, this.mAid, this.mHandler.obtainMessage(5, message));
        }
    }

    public void changeIccLockPassword(String str, String str2, Message message) {
        synchronized (this.mLock) {
            log("changeIccLockPassword");
            this.mCi.changeIccPinForApp(str, str2, this.mAid, this.mHandler.obtainMessage(2, message));
        }
    }

    public void changeIccFdnPassword(String str, String str2, Message message) {
        synchronized (this.mLock) {
            log("changeIccFdnPassword");
            this.mCi.changeIccPin2ForApp(str, str2, this.mAid, this.mHandler.obtainMessage(3, message));
        }
    }

    public boolean isReady() {
        synchronized (this.mLock) {
            if (this.mAppState != IccCardApplicationStatus.AppState.APPSTATE_READY) {
                return false;
            }
            IccCardStatus.PinState pinState = this.mPin1State;
            if (!(pinState == IccCardStatus.PinState.PINSTATE_ENABLED_NOT_VERIFIED || pinState == IccCardStatus.PinState.PINSTATE_ENABLED_BLOCKED)) {
                if (pinState != IccCardStatus.PinState.PINSTATE_ENABLED_PERM_BLOCKED) {
                    return true;
                }
            }
            loge("Sanity check failed! APPSTATE is ready while PIN1 is not verified!!!");
            return false;
        }
    }

    public boolean getIccPin2Blocked() {
        boolean z;
        synchronized (this.mLock) {
            z = this.mPin2State == IccCardStatus.PinState.PINSTATE_ENABLED_BLOCKED;
        }
        return z;
    }

    public boolean getIccPuk2Blocked() {
        boolean z;
        synchronized (this.mLock) {
            z = this.mPin2State == IccCardStatus.PinState.PINSTATE_ENABLED_PERM_BLOCKED;
        }
        return z;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int getPhoneId() {
        return this.mUiccProfile.getPhoneId();
    }

    public boolean isAppIgnored() {
        return this.mIgnoreApp;
    }

    public void setAppIgnoreState(boolean z) {
        this.mIgnoreApp = z;
    }

    /* access modifiers changed from: protected */
    public UiccProfile getUiccProfile() {
        return this.mUiccProfile;
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void log(String str) {
        Rlog.d(LOG_TAG, str);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void loge(String str) {
        Rlog.e(LOG_TAG, str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("UiccCardApplication: " + this);
        printWriter.println(" mUiccProfile=" + this.mUiccProfile);
        printWriter.println(" mAppState=" + this.mAppState);
        printWriter.println(" mAppType=" + this.mAppType);
        printWriter.println(" mPersoSubState=" + this.mPersoSubState);
        printWriter.println(" mAid=" + this.mAid);
        printWriter.println(" mAppLabel=" + this.mAppLabel);
        printWriter.println(" mPin1Replaced=" + this.mPin1Replaced);
        printWriter.println(" mPin1State=" + this.mPin1State);
        printWriter.println(" mPin2State=" + this.mPin2State);
        printWriter.println(" mIccFdnEnabled=" + this.mIccFdnEnabled);
        printWriter.println(" mDesiredFdnEnabled=" + this.mDesiredFdnEnabled);
        printWriter.println(" mIccLockEnabled=" + this.mIccLockEnabled);
        printWriter.println(" mDesiredPinLocked=" + this.mDesiredPinLocked);
        printWriter.println(" mCi=" + this.mCi);
        printWriter.println(" mIccRecords=" + this.mIccRecords);
        printWriter.println(" mIccFh=" + this.mIccFh);
        printWriter.println(" mDestroyed=" + this.mDestroyed);
        printWriter.println(" mReadyRegistrants: size=" + this.mReadyRegistrants.size());
        for (int i = 0; i < this.mReadyRegistrants.size(); i++) {
            printWriter.println("  mReadyRegistrants[" + i + "]=" + ((Registrant) this.mReadyRegistrants.get(i)).getHandler());
        }
        printWriter.println(" mPinLockedRegistrants: size=" + this.mPinLockedRegistrants.size());
        for (int i2 = 0; i2 < this.mPinLockedRegistrants.size(); i2++) {
            printWriter.println("  mPinLockedRegistrants[" + i2 + "]=" + ((Registrant) this.mPinLockedRegistrants.get(i2)).getHandler());
        }
        printWriter.println(" mNetworkLockedRegistrants: size=" + this.mNetworkLockedRegistrants.size());
        for (int i3 = 0; i3 < this.mNetworkLockedRegistrants.size(); i3++) {
            printWriter.println("  mNetworkLockedRegistrants[" + i3 + "]=" + ((Registrant) this.mNetworkLockedRegistrants.get(i3)).getHandler());
        }
        printWriter.flush();
    }
}
