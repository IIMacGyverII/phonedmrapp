package com.android.internal.telephony.euicc;

import android.app.AppOpsManager;
import android.app.PendingIntent;
import android.app.compat.CompatChanges;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ComponentInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Binder;
import android.os.Bundle;
import android.os.Parcelable;
import android.provider.Settings;
import android.service.euicc.DownloadSubscriptionResult;
import android.service.euicc.GetDefaultDownloadableSubscriptionListResult;
import android.service.euicc.GetDownloadableSubscriptionMetadataResult;
import android.service.euicc.GetEuiccProfileInfoListResult;
import android.telephony.AnomalyReporter;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyFrameworkInitializer;
import android.telephony.TelephonyManager;
import android.telephony.UiccAccessRule;
import android.telephony.UiccCardInfo;
import android.telephony.UiccPortInfo;
import android.telephony.UiccSlotInfo;
import android.telephony.euicc.DownloadableSubscription;
import android.telephony.euicc.EuiccInfo;
import android.text.TextUtils;
import android.util.EventLog;
import android.util.Log;
import android.util.Pair;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CarrierPrivilegesTracker;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.euicc.EuiccConnector;
import com.android.internal.telephony.euicc.IEuiccController;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.internal.telephony.uicc.UiccController;
import com.android.internal.telephony.uicc.UiccPort;
import com.android.internal.telephony.uicc.UiccSlot;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Stack;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicReference;

public class EuiccController extends IEuiccController.Stub {
    private static final int ERROR = 2;
    private static final int EUICC_DUMP_TIME_OUT_SECONDS = 5;
    private static final String EXTRA_EMBEDDED_SUBSCRIPTION_DOWNLOADABLE_SUBSCRIPTION = "android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_DOWNLOADABLE_SUBSCRIPTION";
    @VisibleForTesting
    static final String EXTRA_OPERATION = "operation";
    private static final int OK = 0;
    private static final String RESOLUTION_ACTIVITY_CLASS_NAME = "com.android.phone.euicc.EuiccResolutionUiDispatcherActivity";
    private static final String RESOLUTION_ACTIVITY_PACKAGE_NAME = "com.android.phone";
    private static final int RESOLVABLE_ERROR = 1;
    private static final String TAG = "EuiccController";
    private static EuiccController sInstance;
    private final AppOpsManager mAppOpsManager;
    private final EuiccConnector mConnector;
    /* access modifiers changed from: private */
    public final Context mContext;
    private final PackageManager mPackageManager;
    private final SubscriptionManager mSubscriptionManager;
    private List<String> mSupportedCountries;
    private final TelephonyManager mTelephonyManager;
    private List<String> mUnsupportedCountries;

    public static EuiccController init(Context context) {
        synchronized (EuiccController.class) {
            if (sInstance == null) {
                sInstance = new EuiccController(context);
            } else {
                Log.wtf(TAG, "init() called multiple times! sInstance = " + sInstance);
            }
        }
        return sInstance;
    }

    public static EuiccController get() {
        if (sInstance == null) {
            synchronized (EuiccController.class) {
                if (sInstance == null) {
                    throw new IllegalStateException("get() called before init()");
                }
            }
        }
        return sInstance;
    }

    /* JADX WARNING: type inference failed for: r1v0, types: [com.android.internal.telephony.euicc.EuiccController, android.os.IBinder] */
    private EuiccController(Context context) {
        this(context, new EuiccConnector(context));
        TelephonyFrameworkInitializer.getTelephonyServiceManager().getEuiccControllerService().register(this);
    }

    @VisibleForTesting
    public EuiccController(Context context, EuiccConnector euiccConnector) {
        this.mContext = context;
        this.mConnector = euiccConnector;
        this.mSubscriptionManager = (SubscriptionManager) context.getSystemService("telephony_subscription_service");
        this.mTelephonyManager = (TelephonyManager) context.getSystemService("phone");
        this.mAppOpsManager = (AppOpsManager) context.getSystemService("appops");
        this.mPackageManager = context.getPackageManager();
    }

    public void continueOperation(int i, Intent intent, Bundle bundle) {
        if (callerCanWriteEmbeddedSubscriptions()) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                EuiccOperation euiccOperation = (EuiccOperation) intent.getParcelableExtra(EXTRA_OPERATION);
                if (euiccOperation != null) {
                    boolean booleanExtra = intent.getBooleanExtra("android.service.euicc.extra.RESOLUTION_USE_PORT_INDEX", false);
                    bundle.putBoolean("android.service.euicc.extra.RESOLUTION_USE_PORT_INDEX", booleanExtra);
                    Log.i(TAG, " continueOperation portIndex: " + bundle.getInt("android.service.euicc.extra.RESOLUTION_PORT_INDEX") + " usePortIndex: " + booleanExtra);
                    euiccOperation.continueOperation(i, bundle, (PendingIntent) intent.getParcelableExtra("android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_RESOLUTION_CALLBACK_INTENT"));
                    return;
                }
                throw new IllegalArgumentException("Invalid resolution intent");
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        } else {
            throw new SecurityException("Must have WRITE_EMBEDDED_SUBSCRIPTIONS to continue operation");
        }
    }

    public String getEid(int i, String str) {
        boolean callerCanReadPhoneStatePrivileged = callerCanReadPhoneStatePrivileged();
        try {
            this.mAppOpsManager.checkPackage(Binder.getCallingUid(), str);
            long clearCallingIdentity = Binder.clearCallingIdentity();
            if (!callerCanReadPhoneStatePrivileged) {
                try {
                    if (!canManageSubscriptionOnTargetSim(i, str, false, -1)) {
                        throw new SecurityException("Must have carrier privileges on subscription to read EID for cardId=" + i);
                    }
                } catch (Throwable th) {
                    Binder.restoreCallingIdentity(clearCallingIdentity);
                    throw th;
                }
            }
            String blockingGetEidFromEuiccService = blockingGetEidFromEuiccService(i);
            Binder.restoreCallingIdentity(clearCallingIdentity);
            return blockingGetEidFromEuiccService;
        } catch (SecurityException e) {
            EventLog.writeEvent(1397638484, new Object[]{"159062405", -1, "Missing UID checking"});
            throw e;
        }
    }

    public int getOtaStatus(int i) {
        if (callerCanWriteEmbeddedSubscriptions()) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                return blockingGetOtaStatusFromEuiccService(i);
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        } else {
            throw new SecurityException("Must have WRITE_EMBEDDED_SUBSCRIPTIONS to get OTA status");
        }
    }

    public void startOtaUpdatingIfNecessary() {
        startOtaUpdatingIfNecessary(this.mTelephonyManager.getCardIdForDefaultEuicc());
    }

    public void startOtaUpdatingIfNecessary(int i) {
        this.mConnector.startOtaIfNecessary(i, new EuiccConnector.OtaStatusChangedCallback() {
            public void onEuiccServiceUnavailable() {
            }

            public void onOtaStatusChanged(int i) {
                EuiccController.this.sendOtaStatusChangedBroadcast();
            }
        });
    }

    public void getDownloadableSubscriptionMetadata(int i, DownloadableSubscription downloadableSubscription, String str, PendingIntent pendingIntent) {
        getDownloadableSubscriptionMetadata(i, downloadableSubscription, false, str, pendingIntent);
    }

    public void setSupportedCountries(boolean z, List<String> list) {
        if (!callerCanWriteEmbeddedSubscriptions()) {
            throw new SecurityException("Must have WRITE_EMBEDDED_SUBSCRIPTIONS to set supported countries");
        } else if (z) {
            this.mSupportedCountries = list;
        } else {
            this.mUnsupportedCountries = list;
        }
    }

    public List<String> getSupportedCountries(boolean z) {
        List<String> list;
        List<String> list2;
        if (!callerCanWriteEmbeddedSubscriptions()) {
            throw new SecurityException("Must have WRITE_EMBEDDED_SUBSCRIPTIONS to get supported countries");
        } else if (z && (list2 = this.mSupportedCountries) != null) {
            return list2;
        } else {
            if (z || (list = this.mUnsupportedCountries) == null) {
                return Collections.emptyList();
            }
            return list;
        }
    }

    public boolean isSupportedCountry(String str) {
        if (callerCanWriteEmbeddedSubscriptions()) {
            List<String> list = this.mSupportedCountries;
            if (list == null || list.isEmpty()) {
                Log.i(TAG, "Using deny list unsupportedCountries=" + this.mUnsupportedCountries);
                return !isEsimUnsupportedCountry(str);
            }
            Log.i(TAG, "Using allow list supportedCountries=" + this.mSupportedCountries);
            return isEsimSupportedCountry(str);
        }
        throw new SecurityException("Must have WRITE_EMBEDDED_SUBSCRIPTIONS to check if the country is supported");
    }

    private boolean isEsimSupportedCountry(String str) {
        if (this.mSupportedCountries == null || TextUtils.isEmpty(str)) {
            return true;
        }
        return this.mSupportedCountries.contains(str);
    }

    private boolean isEsimUnsupportedCountry(String str) {
        if (this.mUnsupportedCountries == null || TextUtils.isEmpty(str)) {
            return false;
        }
        return this.mUnsupportedCountries.contains(str);
    }

    /* access modifiers changed from: package-private */
    public void getDownloadableSubscriptionMetadata(int i, DownloadableSubscription downloadableSubscription, boolean z, String str, PendingIntent pendingIntent) {
        if (callerCanWriteEmbeddedSubscriptions()) {
            this.mAppOpsManager.checkPackage(Binder.getCallingUid(), str);
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                int i2 = i;
                DownloadableSubscription downloadableSubscription2 = downloadableSubscription;
                boolean z2 = z;
                this.mConnector.getDownloadableSubscriptionMetadata(i, downloadableSubscription, z, new GetMetadataCommandCallback(clearCallingIdentity, downloadableSubscription, str, pendingIntent));
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        } else {
            throw new SecurityException("Must have WRITE_EMBEDDED_SUBSCRIPTIONS to get metadata");
        }
    }

    class GetMetadataCommandCallback implements EuiccConnector.GetMetadataCommandCallback {
        protected final PendingIntent mCallbackIntent;
        protected final String mCallingPackage;
        protected final long mCallingToken;
        protected final DownloadableSubscription mSubscription;

        GetMetadataCommandCallback(long j, DownloadableSubscription downloadableSubscription, String str, PendingIntent pendingIntent) {
            this.mCallingToken = j;
            this.mSubscription = downloadableSubscription;
            this.mCallingPackage = str;
            this.mCallbackIntent = pendingIntent;
        }

        public void onGetMetadataComplete(int i, GetDownloadableSubscriptionMetadataResult getDownloadableSubscriptionMetadataResult) {
            int i2;
            Intent intent = new Intent();
            int result = getDownloadableSubscriptionMetadataResult.getResult();
            if (result == -1) {
                EuiccController.this.addResolutionIntentWithPort(intent, "android.service.euicc.action.RESOLVE_DEACTIVATE_SIM", this.mCallingPackage, 0, false, getOperationForDeactivateSim(), i, 0, false);
                i2 = 1;
            } else if (result != 0) {
                i2 = 2;
                EuiccController.this.addExtrasToResultIntent(intent, getDownloadableSubscriptionMetadataResult.getResult());
            } else {
                i2 = 0;
                intent.putExtra(EuiccController.EXTRA_EMBEDDED_SUBSCRIPTION_DOWNLOADABLE_SUBSCRIPTION, getDownloadableSubscriptionMetadataResult.getDownloadableSubscription());
            }
            EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(this.mCallbackIntent, i2, intent);
        }

        public void onEuiccServiceUnavailable() {
            EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(this.mCallbackIntent, 2, (Intent) null);
        }

        /* access modifiers changed from: protected */
        public EuiccOperation getOperationForDeactivateSim() {
            return EuiccOperation.forGetMetadataDeactivateSim(this.mCallingToken, this.mSubscription, this.mCallingPackage);
        }
    }

    public void downloadSubscription(int i, DownloadableSubscription downloadableSubscription, boolean z, String str, Bundle bundle, PendingIntent pendingIntent) {
        downloadSubscription(i, z ? -1 : 0, downloadableSubscription, z, str, false, bundle, pendingIntent);
    }

    /* access modifiers changed from: package-private */
    public Pair<String, String> decodeSmdxSubjectAndReasonCode(int i) {
        Stack stack = new Stack();
        for (int i2 = 0; i2 < 6; i2++) {
            stack.push(Integer.valueOf(i & 15));
            i >>>= 4;
        }
        return Pair.create((stack.pop() + "." + stack.pop() + "." + stack.pop()).replaceAll("^(0\\.)*", ""), (stack.pop() + "." + stack.pop() + "." + stack.pop()).replaceAll("^(0\\.)*", ""));
    }

    /* access modifiers changed from: private */
    public void addExtrasToResultIntent(Intent intent, int i) {
        int i2 = i >>> 24;
        intent.putExtra("android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_DETAILED_CODE", i);
        intent.putExtra("android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_OPERATION_CODE", i2);
        if (i2 == 10) {
            Pair<String, String> decodeSmdxSubjectAndReasonCode = decodeSmdxSubjectAndReasonCode(i);
            intent.putExtra("android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_SMDX_SUBJECT_CODE", (String) decodeSmdxSubjectAndReasonCode.first);
            intent.putExtra("android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_SMDX_REASON_CODE", (String) decodeSmdxSubjectAndReasonCode.second);
            return;
        }
        intent.putExtra("android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_ERROR_CODE", 16777215 & i);
    }

    /* access modifiers changed from: package-private */
    public void downloadSubscription(int i, int i2, DownloadableSubscription downloadableSubscription, boolean z, String str, boolean z2, Bundle bundle, PendingIntent pendingIntent) {
        long j;
        int i3;
        int i4 = i;
        DownloadableSubscription downloadableSubscription2 = downloadableSubscription;
        boolean z3 = z;
        String str2 = str;
        boolean z4 = z2;
        boolean callerCanWriteEmbeddedSubscriptions = callerCanWriteEmbeddedSubscriptions();
        this.mAppOpsManager.checkPackage(Binder.getCallingUid(), str2);
        boolean isCompatChangeEnabled = isCompatChangeEnabled(str2, 224562872);
        long clearCallingIdentity = Binder.clearCallingIdentity();
        boolean z5 = false;
        if (z3) {
            i3 = i2;
            if (i3 == -1) {
                if (isCompatChangeEnabled) {
                    try {
                        i3 = getResolvedPortIndexForSubscriptionSwitch(i);
                    } catch (Throwable th) {
                        th = th;
                        j = clearCallingIdentity;
                        Binder.restoreCallingIdentity(j);
                        throw th;
                    }
                } else {
                    i3 = 0;
                }
                if (i3 == -1) {
                    z5 = true;
                }
            }
        } else {
            i3 = i2;
        }
        int i5 = i3;
        Log.d(TAG, " downloadSubscription cardId: " + i4 + " switchAfterDownload: " + z3 + " portIndex: " + i5 + " forceDeactivateSim: " + z4 + " callingPackage: " + str2 + " isConsentNeededToResolvePortIndex: " + z5 + " shouldResolvePortIndex:" + isCompatChangeEnabled);
        if (z5 || !callerCanWriteEmbeddedSubscriptions) {
            if (!z5) {
                if (canManageSubscriptionOnTargetSim(i4, str2, true, i5)) {
                    EuiccConnector euiccConnector = this.mConnector;
                    DownloadSubscriptionGetMetadataCommandCallback downloadSubscriptionGetMetadataCommandCallback = r1;
                    long j2 = clearCallingIdentity;
                    EuiccConnector euiccConnector2 = euiccConnector;
                    try {
                        DownloadSubscriptionGetMetadataCommandCallback downloadSubscriptionGetMetadataCommandCallback2 = new DownloadSubscriptionGetMetadataCommandCallback(this, clearCallingIdentity, downloadableSubscription, z, str, z2, pendingIntent, false, i5);
                        euiccConnector2.getDownloadableSubscriptionMetadata(i4, downloadableSubscription2, z4, downloadSubscriptionGetMetadataCommandCallback);
                        j = j2;
                        Binder.restoreCallingIdentity(j);
                    } catch (Throwable th2) {
                        th = th2;
                        j = j2;
                        Binder.restoreCallingIdentity(j);
                        throw th;
                    }
                }
            }
            long j3 = clearCallingIdentity;
            Log.i(TAG, "Caller can't manage subscription on target SIM or  User consent is required for resolving port index. Ask user's consent first");
            Intent intent = new Intent();
            clearCallingIdentity = j3;
            j = clearCallingIdentity;
            try {
                addResolutionIntentWithPort(intent, "android.service.euicc.action.RESOLVE_NO_PRIVILEGES", str, 0, false, EuiccOperation.forDownloadNoPrivilegesOrDeactivateSimCheckMetadata(clearCallingIdentity, downloadableSubscription2, z3, str2), i, i5, z);
                lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 1, intent);
                Binder.restoreCallingIdentity(j);
            } catch (Throwable th3) {
                th = th3;
                Binder.restoreCallingIdentity(j);
                throw th;
            }
        } else {
            long j4 = clearCallingIdentity;
            try {
                downloadSubscriptionPrivileged(i, i5, clearCallingIdentity, downloadableSubscription, z, z2, str, bundle, pendingIntent);
                Binder.restoreCallingIdentity(j4);
            } catch (Throwable th4) {
                th = th4;
                j = j4;
                Binder.restoreCallingIdentity(j);
                throw th;
            }
        }
    }

    class DownloadSubscriptionGetMetadataCommandCallback extends GetMetadataCommandCallback {
        private final boolean mForceDeactivateSim;
        private final int mPortIndex;
        private final boolean mSwitchAfterDownload;
        private final boolean mWithUserConsent;
        final /* synthetic */ EuiccController this$0;

        /* JADX WARNING: Illegal instructions before constructor call */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        DownloadSubscriptionGetMetadataCommandCallback(com.android.internal.telephony.euicc.EuiccController r9, long r10, android.telephony.euicc.DownloadableSubscription r12, boolean r13, java.lang.String r14, boolean r15, android.app.PendingIntent r16, boolean r17, int r18) {
            /*
                r8 = this;
                r7 = r8
                r1 = r9
                r7.this$0 = r1
                r0 = r8
                r2 = r10
                r4 = r12
                r5 = r14
                r6 = r16
                r0.<init>(r2, r4, r5, r6)
                r0 = r13
                r7.mSwitchAfterDownload = r0
                r0 = r15
                r7.mForceDeactivateSim = r0
                r0 = r17
                r7.mWithUserConsent = r0
                r0 = r18
                r7.mPortIndex = r0
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.euicc.EuiccController.DownloadSubscriptionGetMetadataCommandCallback.<init>(com.android.internal.telephony.euicc.EuiccController, long, android.telephony.euicc.DownloadableSubscription, boolean, java.lang.String, boolean, android.app.PendingIntent, boolean, int):void");
        }

        public void onGetMetadataComplete(int i, GetDownloadableSubscriptionMetadataResult getDownloadableSubscriptionMetadataResult) {
            DownloadableSubscription downloadableSubscription = getDownloadableSubscriptionMetadataResult.getDownloadableSubscription();
            if (this.mWithUserConsent) {
                if (getDownloadableSubscriptionMetadataResult.getResult() != 0) {
                    super.onGetMetadataComplete(i, getDownloadableSubscriptionMetadataResult);
                } else if (this.this$0.checkCarrierPrivilegeInMetadata(downloadableSubscription, this.mCallingPackage)) {
                    this.this$0.downloadSubscriptionPrivileged(i, this.mPortIndex, this.mCallingToken, downloadableSubscription, this.mSwitchAfterDownload, this.mForceDeactivateSim, this.mCallingPackage, (Bundle) null, this.mCallbackIntent);
                } else {
                    Log.e(EuiccController.TAG, "Caller does not have carrier privilege in metadata.");
                    this.this$0.lambda$refreshSubscriptionsAndSendResult$0(this.mCallbackIntent, 2, (Intent) null);
                }
            } else if (getDownloadableSubscriptionMetadataResult.getResult() == -1) {
                Intent intent = new Intent();
                EuiccController euiccController = this.this$0;
                String str = this.mCallingPackage;
                euiccController.addResolutionIntentWithPort(intent, "android.service.euicc.action.RESOLVE_DEACTIVATE_SIM", str, 0, false, EuiccOperation.forDownloadNoPrivilegesOrDeactivateSimCheckMetadata(this.mCallingToken, this.mSubscription, this.mSwitchAfterDownload, str), i, this.mPortIndex, this.mSwitchAfterDownload);
                this.this$0.lambda$refreshSubscriptionsAndSendResult$0(this.mCallbackIntent, 1, intent);
            } else if (getDownloadableSubscriptionMetadataResult.getResult() != 0) {
                super.onGetMetadataComplete(i, getDownloadableSubscriptionMetadataResult);
            } else if (this.this$0.checkCarrierPrivilegeInMetadata(downloadableSubscription, this.mCallingPackage)) {
                this.this$0.downloadSubscriptionPrivileged(i, this.mPortIndex, this.mCallingToken, downloadableSubscription, this.mSwitchAfterDownload, this.mForceDeactivateSim, this.mCallingPackage, (Bundle) null, this.mCallbackIntent);
            } else {
                Log.e(EuiccController.TAG, "Caller is not permitted to download this profile per metadata");
                this.this$0.lambda$refreshSubscriptionsAndSendResult$0(this.mCallbackIntent, 2, (Intent) null);
            }
        }
    }

    /* access modifiers changed from: package-private */
    public void downloadSubscriptionPrivilegedCheckMetadata(int i, int i2, long j, DownloadableSubscription downloadableSubscription, boolean z, boolean z2, String str, Bundle bundle, PendingIntent pendingIntent) {
        int i3 = i;
        boolean z3 = z2;
        StringBuilder sb = new StringBuilder();
        sb.append(" downloadSubscriptionPrivilegedCheckMetadata cardId: ");
        sb.append(i3);
        sb.append(" switchAfterDownload: ");
        boolean z4 = z;
        sb.append(z4);
        sb.append(" portIndex: ");
        int i4 = i2;
        sb.append(i4);
        sb.append(" forceDeactivateSim: ");
        sb.append(z3);
        Log.d(TAG, sb.toString());
        this.mConnector.getDownloadableSubscriptionMetadata(i3, downloadableSubscription, z3, new DownloadSubscriptionGetMetadataCommandCallback(this, j, downloadableSubscription, z4, str, z2, pendingIntent, true, i4));
    }

    /* access modifiers changed from: package-private */
    public void downloadSubscriptionPrivileged(int i, int i2, long j, DownloadableSubscription downloadableSubscription, boolean z, boolean z2, String str, Bundle bundle, PendingIntent pendingIntent) {
        final DownloadableSubscription downloadableSubscription2 = downloadableSubscription;
        final boolean z3 = z;
        final PendingIntent pendingIntent2 = pendingIntent;
        final String str2 = str;
        final long j2 = j;
        final int i3 = i;
        final int i4 = i2;
        this.mConnector.downloadSubscription(i, i2, downloadableSubscription, z, z2, bundle, new EuiccConnector.DownloadCommandCallback() {
            public void onDownloadComplete(DownloadSubscriptionResult downloadSubscriptionResult) {
                Intent intent = new Intent();
                int result = downloadSubscriptionResult.getResult();
                int i = 1;
                if (result == -2) {
                    boolean z = !TextUtils.isEmpty(downloadableSubscription2.getConfirmationCode());
                    if (downloadSubscriptionResult.getResolvableErrors() != 0) {
                        Intent intent2 = intent;
                        EuiccController.this.addResolutionIntentWithPort(intent2, "android.service.euicc.action.RESOLVE_RESOLVABLE_ERRORS", str2, downloadSubscriptionResult.getResolvableErrors(), z, EuiccOperation.forDownloadResolvableErrors(j2, downloadableSubscription2, z3, str2, downloadSubscriptionResult.getResolvableErrors()), i3, i4, z3);
                    } else {
                        EuiccController euiccController = EuiccController.this;
                        String str = str2;
                        euiccController.addResolutionIntentWithPort(intent, "android.service.euicc.action.RESOLVE_CONFIRMATION_CODE", str, 0, z, EuiccOperation.forDownloadConfirmationCode(j2, downloadableSubscription2, z3, str), i3, i4, z3);
                    }
                } else if (result == -1) {
                    EuiccController euiccController2 = EuiccController.this;
                    String str2 = str2;
                    euiccController2.addResolutionIntentWithPort(intent, "android.service.euicc.action.RESOLVE_DEACTIVATE_SIM", str2, 0, false, EuiccOperation.forDownloadDeactivateSim(j2, downloadableSubscription2, z3, str2), i3, i4, z3);
                } else if (result != 0) {
                    i = 2;
                    EuiccController.this.addExtrasToResultIntent(intent, downloadSubscriptionResult.getResult());
                } else {
                    Settings.Global.putInt(EuiccController.this.mContext.getContentResolver(), "euicc_provisioned", 1);
                    intent.putExtra(EuiccController.EXTRA_EMBEDDED_SUBSCRIPTION_DOWNLOADABLE_SUBSCRIPTION, downloadableSubscription2);
                    if (!z3) {
                        EuiccController.this.refreshSubscriptionsAndSendResult(pendingIntent2, 0, intent);
                        return;
                    }
                    i = 0;
                }
                EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent2, i, intent);
            }

            public void onEuiccServiceUnavailable() {
                EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent2, 2, (Intent) null);
            }
        });
    }

    public GetEuiccProfileInfoListResult blockingGetEuiccProfileInfoList(int i) {
        final CountDownLatch countDownLatch = new CountDownLatch(1);
        final AtomicReference atomicReference = new AtomicReference();
        this.mConnector.getEuiccProfileInfoList(i, new EuiccConnector.GetEuiccProfileInfoListCommandCallback() {
            public void onListComplete(GetEuiccProfileInfoListResult getEuiccProfileInfoListResult) {
                atomicReference.set(getEuiccProfileInfoListResult);
                countDownLatch.countDown();
            }

            public void onEuiccServiceUnavailable() {
                countDownLatch.countDown();
            }
        });
        try {
            countDownLatch.await();
        } catch (InterruptedException e) {
            Log.e(TAG, "blockingGetEuiccInfoFromEuiccService got InterruptedException e: " + e);
            Thread.currentThread().interrupt();
        }
        return (GetEuiccProfileInfoListResult) atomicReference.get();
    }

    public void getDefaultDownloadableSubscriptionList(int i, String str, PendingIntent pendingIntent) {
        getDefaultDownloadableSubscriptionList(i, false, str, pendingIntent);
    }

    /* access modifiers changed from: package-private */
    public void getDefaultDownloadableSubscriptionList(int i, boolean z, String str, PendingIntent pendingIntent) {
        if (callerCanWriteEmbeddedSubscriptions()) {
            this.mAppOpsManager.checkPackage(Binder.getCallingUid(), str);
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                this.mConnector.getDefaultDownloadableSubscriptionList(i, z, new GetDefaultListCommandCallback(clearCallingIdentity, str, pendingIntent));
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        } else {
            throw new SecurityException("Must have WRITE_EMBEDDED_SUBSCRIPTIONS to get default list");
        }
    }

    class GetDefaultListCommandCallback implements EuiccConnector.GetDefaultListCommandCallback {
        final PendingIntent mCallbackIntent;
        final String mCallingPackage;
        final long mCallingToken;

        GetDefaultListCommandCallback(long j, String str, PendingIntent pendingIntent) {
            this.mCallingToken = j;
            this.mCallingPackage = str;
            this.mCallbackIntent = pendingIntent;
        }

        public void onGetDefaultListComplete(int i, GetDefaultDownloadableSubscriptionListResult getDefaultDownloadableSubscriptionListResult) {
            int i2;
            Intent intent = new Intent();
            int result = getDefaultDownloadableSubscriptionListResult.getResult();
            if (result == -1) {
                EuiccController euiccController = EuiccController.this;
                String str = this.mCallingPackage;
                euiccController.addResolutionIntentWithPort(intent, "android.service.euicc.action.RESOLVE_DEACTIVATE_SIM", str, 0, false, EuiccOperation.forGetDefaultListDeactivateSim(this.mCallingToken, str), i, 0, false);
                i2 = 1;
            } else if (result != 0) {
                i2 = 2;
                EuiccController.this.addExtrasToResultIntent(intent, getDefaultDownloadableSubscriptionListResult.getResult());
            } else {
                i2 = 0;
                List downloadableSubscriptions = getDefaultDownloadableSubscriptionListResult.getDownloadableSubscriptions();
                if (downloadableSubscriptions != null && downloadableSubscriptions.size() > 0) {
                    intent.putExtra("android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_DOWNLOADABLE_SUBSCRIPTIONS", (Parcelable[]) downloadableSubscriptions.toArray(new DownloadableSubscription[downloadableSubscriptions.size()]));
                }
            }
            EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(this.mCallbackIntent, i2, intent);
        }

        public void onEuiccServiceUnavailable() {
            EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(this.mCallbackIntent, 2, (Intent) null);
        }
    }

    public EuiccInfo getEuiccInfo(int i) {
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            return blockingGetEuiccInfoFromEuiccService(i);
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public void deleteSubscription(int i, int i2, String str, PendingIntent pendingIntent) {
        boolean callerCanWriteEmbeddedSubscriptions = callerCanWriteEmbeddedSubscriptions();
        this.mAppOpsManager.checkPackage(Binder.getCallingUid(), str);
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            SubscriptionInfo subscriptionForSubscriptionId = getSubscriptionForSubscriptionId(i2);
            if (subscriptionForSubscriptionId == null) {
                Log.e(TAG, "Cannot delete nonexistent subscription: " + i2);
                lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, (Intent) null);
                return;
            }
            if (!callerCanWriteEmbeddedSubscriptions) {
                if (!this.mSubscriptionManager.canManageSubscription(subscriptionForSubscriptionId, str)) {
                    Log.e(TAG, "No permissions: " + i2);
                    lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, (Intent) null);
                    Binder.restoreCallingIdentity(clearCallingIdentity);
                    return;
                }
            }
            deleteSubscriptionPrivileged(i, subscriptionForSubscriptionId.getIccId(), pendingIntent);
            Binder.restoreCallingIdentity(clearCallingIdentity);
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    /* access modifiers changed from: package-private */
    public void deleteSubscriptionPrivileged(int i, String str, final PendingIntent pendingIntent) {
        this.mConnector.deleteSubscription(i, str, new EuiccConnector.DeleteCommandCallback() {
            public void onDeleteComplete(int i) {
                Intent intent = new Intent();
                if (i != 0) {
                    EuiccController.this.addExtrasToResultIntent(intent, i);
                    EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, intent);
                    return;
                }
                EuiccController.this.refreshSubscriptionsAndSendResult(pendingIntent, 0, intent);
            }

            public void onEuiccServiceUnavailable() {
                EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, (Intent) null);
            }
        });
    }

    public void switchToSubscription(int i, int i2, String str, PendingIntent pendingIntent) {
        switchToSubscription(i, i2, 0, false, str, pendingIntent, false);
    }

    public void switchToSubscriptionWithPort(int i, int i2, int i3, String str, PendingIntent pendingIntent) {
        switchToSubscription(i, i2, i3, false, str, pendingIntent, true);
    }

    /* access modifiers changed from: package-private */
    /* JADX WARNING: Removed duplicated region for block: B:44:0x00f8 A[Catch:{ all -> 0x0182 }] */
    /* JADX WARNING: Removed duplicated region for block: B:50:0x011c  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void switchToSubscription(int r18, int r19, int r20, boolean r21, java.lang.String r22, android.app.PendingIntent r23, boolean r24) {
        /*
            r17 = this;
            r0 = r17
            r8 = r18
            r11 = r19
            r1 = r20
            r9 = r22
            r12 = r23
            r2 = r24
            boolean r3 = r17.callerCanWriteEmbeddedSubscriptions()
            android.app.AppOpsManager r4 = r0.mAppOpsManager
            int r5 = android.os.Binder.getCallingUid()
            r4.checkPackage(r5, r9)
            r4 = 224562872(0xd628eb8, double:1.109488004E-315)
            boolean r4 = r0.isCompatChangeEnabled(r9, r4)
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            java.lang.String r6 = " subId: "
            r5.append(r6)
            r5.append(r11)
            java.lang.String r6 = " portIndex: "
            r5.append(r6)
            r5.append(r1)
            java.lang.String r6 = " forceDeactivateSim: "
            r5.append(r6)
            r6 = r21
            r5.append(r6)
            java.lang.String r7 = " usePortIndex: "
            r5.append(r7)
            r5.append(r2)
            java.lang.String r7 = " callingPackage: "
            r5.append(r7)
            r5.append(r9)
            java.lang.String r7 = " shouldResolvePortIndex: "
            r5.append(r7)
            r5.append(r4)
            java.lang.String r5 = r5.toString()
            java.lang.String r7 = "EuiccController"
            android.util.Log.d(r7, r5)
            long r13 = android.os.Binder.clearCallingIdentity()
            if (r3 == 0) goto L_0x006a
            r10 = 1
            goto L_0x006b
        L_0x006a:
            r10 = r6
        L_0x006b:
            r5 = -1
            r6 = 2
            r15 = 0
            if (r11 != r5) goto L_0x00a2
            if (r2 != 0) goto L_0x0085
            int r1 = r0.getResolvedPortIndexForDisableSubscription(r8, r9, r3)     // Catch:{ all -> 0x0182 }
            if (r1 != r5) goto L_0x0084
            java.lang.String r1 = "Disable is not permitted: no active subscription or cannot manage subscription"
            android.util.Log.e(r7, r1)     // Catch:{ all -> 0x0182 }
            r0.lambda$refreshSubscriptionsAndSendResult$0(r12, r6, r15)     // Catch:{ all -> 0x0182 }
            android.os.Binder.restoreCallingIdentity(r13)
            return
        L_0x0084:
            r2 = 1
        L_0x0085:
            if (r3 != 0) goto L_0x009a
            boolean r3 = r0.canManageActiveSubscriptionOnTargetSim(r8, r9, r2, r1)     // Catch:{ all -> 0x0182 }
            if (r3 == 0) goto L_0x008e
            goto L_0x009a
        L_0x008e:
            java.lang.String r1 = "Not permitted to switch to empty subscription"
            android.util.Log.e(r7, r1)     // Catch:{ all -> 0x0182 }
            r0.lambda$refreshSubscriptionsAndSendResult$0(r12, r6, r15)     // Catch:{ all -> 0x0182 }
            android.os.Binder.restoreCallingIdentity(r13)
            return
        L_0x009a:
            r16 = r2
            r7 = r15
            r3 = 1
            r6 = 0
            r15 = r1
            goto L_0x0142
        L_0x00a2:
            android.telephony.SubscriptionInfo r5 = r0.getSubscriptionForSubscriptionId(r11)     // Catch:{ all -> 0x0182 }
            if (r5 != 0) goto L_0x00c3
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x0182 }
            r1.<init>()     // Catch:{ all -> 0x0182 }
            java.lang.String r2 = "Cannot switch to nonexistent sub: "
            r1.append(r2)     // Catch:{ all -> 0x0182 }
            r1.append(r11)     // Catch:{ all -> 0x0182 }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x0182 }
            android.util.Log.e(r7, r1)     // Catch:{ all -> 0x0182 }
            r0.lambda$refreshSubscriptionsAndSendResult$0(r12, r6, r15)     // Catch:{ all -> 0x0182 }
            android.os.Binder.restoreCallingIdentity(r13)
            return
        L_0x00c3:
            if (r3 == 0) goto L_0x00c7
        L_0x00c5:
            r3 = 1
            goto L_0x00f2
        L_0x00c7:
            android.telephony.SubscriptionManager r3 = r0.mSubscriptionManager     // Catch:{ all -> 0x0182 }
            boolean r3 = r3.canManageSubscription(r5, r9)     // Catch:{ all -> 0x0182 }
            if (r3 != 0) goto L_0x00ea
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x0182 }
            r1.<init>()     // Catch:{ all -> 0x0182 }
            java.lang.String r2 = "Not permitted to switch to sub: "
            r1.append(r2)     // Catch:{ all -> 0x0182 }
            r1.append(r11)     // Catch:{ all -> 0x0182 }
            java.lang.String r1 = r1.toString()     // Catch:{ all -> 0x0182 }
            android.util.Log.e(r7, r1)     // Catch:{ all -> 0x0182 }
            r0.lambda$refreshSubscriptionsAndSendResult$0(r12, r6, r15)     // Catch:{ all -> 0x0182 }
            android.os.Binder.restoreCallingIdentity(r13)
            return
        L_0x00ea:
            boolean r3 = r0.canManageSubscriptionOnTargetSim(r8, r9, r2, r1)     // Catch:{ all -> 0x0182 }
            if (r3 == 0) goto L_0x00f1
            goto L_0x00c5
        L_0x00f1:
            r3 = 0
        L_0x00f2:
            java.lang.String r5 = r5.getIccId()     // Catch:{ all -> 0x0182 }
            if (r2 == 0) goto L_0x011c
            boolean r4 = r0.isTargetPortIndexValid(r8, r1)     // Catch:{ all -> 0x0182 }
            if (r4 != 0) goto L_0x0116
            java.lang.String r1 = "Not permitted to switch to invalid portIndex"
            android.util.Log.e(r7, r1)     // Catch:{ all -> 0x0182 }
            android.content.Intent r1 = new android.content.Intent     // Catch:{ all -> 0x0182 }
            r1.<init>()     // Catch:{ all -> 0x0182 }
            java.lang.String r2 = "android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_ERROR_CODE"
            r3 = 10017(0x2721, float:1.4037E-41)
            r1.putExtra(r2, r3)     // Catch:{ all -> 0x0182 }
            r0.lambda$refreshSubscriptionsAndSendResult$0(r12, r6, r1)     // Catch:{ all -> 0x0182 }
            android.os.Binder.restoreCallingIdentity(r13)
            return
        L_0x0116:
            r15 = r1
            r16 = r2
            r7 = r5
            r6 = 0
            goto L_0x0142
        L_0x011c:
            if (r4 == 0) goto L_0x0123
            int r1 = r17.getResolvedPortIndexForSubscriptionSwitch(r18)     // Catch:{ all -> 0x0182 }
            goto L_0x0124
        L_0x0123:
            r1 = 0
        L_0x0124:
            r2 = -1
            if (r1 != r2) goto L_0x0129
            r6 = 1
            goto L_0x012a
        L_0x0129:
            r6 = 0
        L_0x012a:
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x0182 }
            r2.<init>()     // Catch:{ all -> 0x0182 }
            java.lang.String r4 = " Resolved portIndex: "
            r2.append(r4)     // Catch:{ all -> 0x0182 }
            r2.append(r1)     // Catch:{ all -> 0x0182 }
            java.lang.String r2 = r2.toString()     // Catch:{ all -> 0x0182 }
            android.util.Log.d(r7, r2)     // Catch:{ all -> 0x0182 }
            r15 = r1
            r7 = r5
            r16 = 1
        L_0x0142:
            if (r3 == 0) goto L_0x015d
            if (r6 == 0) goto L_0x0147
            goto L_0x015d
        L_0x0147:
            r1 = r17
            r2 = r18
            r3 = r15
            r4 = r13
            r6 = r19
            r8 = r10
            r9 = r22
            r10 = r23
            r11 = r16
            r1.switchToSubscriptionPrivileged(r2, r3, r4, r6, r7, r8, r9, r10, r11)     // Catch:{ all -> 0x0182 }
            android.os.Binder.restoreCallingIdentity(r13)
            return
        L_0x015d:
            android.content.Intent r10 = new android.content.Intent     // Catch:{ all -> 0x0182 }
            r10.<init>()     // Catch:{ all -> 0x0182 }
            java.lang.String r3 = "android.service.euicc.action.RESOLVE_NO_PRIVILEGES"
            r5 = 0
            r6 = 0
            com.android.internal.telephony.euicc.EuiccOperation r7 = com.android.internal.telephony.euicc.EuiccOperation.forSwitchNoPrivileges(r13, r11, r9)     // Catch:{ all -> 0x0182 }
            r1 = r17
            r2 = r10
            r4 = r22
            r8 = r18
            r9 = r15
            r15 = r10
            r10 = r16
            r11 = r19
            r1.addResolutionIntent(r2, r3, r4, r5, r6, r7, r8, r9, r10, r11)     // Catch:{ all -> 0x0182 }
            r1 = 1
            r0.lambda$refreshSubscriptionsAndSendResult$0(r12, r1, r15)     // Catch:{ all -> 0x0182 }
            android.os.Binder.restoreCallingIdentity(r13)
            return
        L_0x0182:
            r0 = move-exception
            android.os.Binder.restoreCallingIdentity(r13)
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.euicc.EuiccController.switchToSubscription(int, int, int, boolean, java.lang.String, android.app.PendingIntent, boolean):void");
    }

    private int getResolvedPortIndexForDisableSubscription(int i, String str, boolean z) {
        List<SubscriptionInfo> activeSubscriptionInfoList = this.mSubscriptionManager.getActiveSubscriptionInfoList(false);
        if (!(activeSubscriptionInfoList == null || activeSubscriptionInfoList.size() == 0)) {
            for (SubscriptionInfo subscriptionInfo : activeSubscriptionInfoList) {
                if ((i == -1 || subscriptionInfo.getCardId() == i) && subscriptionInfo.isEmbedded()) {
                    if (z || this.mSubscriptionManager.canManageSubscription(subscriptionInfo, str)) {
                        return subscriptionInfo.getPortIndex();
                    }
                }
            }
        }
        return -1;
    }

    private int getResolvedPortIndexForSubscriptionSwitch(int i) {
        SubscriptionInfo activeSubscriptionInfoForSimSlotIndex;
        int slotIndexFromCardId = getSlotIndexFromCardId(i);
        UiccSlot uiccSlot = UiccController.getInstance().getUiccSlot(slotIndexFromCardId);
        int i2 = 0;
        if (uiccSlot == null) {
            Log.d(TAG, "Switch to inactive slot, return default port index. slotIndex: " + slotIndexFromCardId);
            return 0;
        } else if (!uiccSlot.isMultipleEnabledProfileSupported()) {
            Log.d(TAG, "Multiple enabled profiles is not supported, return default port index");
            return 0;
        } else {
            boolean z = getRemovableNonEuiccSlot() != null && getRemovableNonEuiccSlot().isActive();
            if (this.mTelephonyManager.getActiveModemCount() != 1) {
                for (int i3 : uiccSlot.getPortList()) {
                    if (uiccSlot.isPortActive(i3) && ((activeSubscriptionInfoForSimSlotIndex = this.mSubscriptionManager.getActiveSubscriptionInfoForSimSlotIndex(uiccSlot.getPhoneIdFromPortIndex(i3))) == null || activeSubscriptionInfoForSimSlotIndex.isOpportunistic())) {
                        return i3;
                    }
                }
                if (z && !isRemovalNonEuiccSlotHasActiveSubscription()) {
                    i2 = 1;
                }
                if (i2 != 0) {
                    return getNextAvailableInActivePortIndex(uiccSlot);
                }
                return -1;
            } else if (z) {
                return 0;
            } else {
                int[] portList = uiccSlot.getPortList();
                int length = portList.length;
                while (i2 < length) {
                    int i4 = portList[i2];
                    if (uiccSlot.isPortActive(i4)) {
                        return i4;
                    }
                    i2++;
                }
                return -1;
            }
        }
    }

    private boolean isTargetPortIndexValid(int i, int i2) {
        if (i2 < 0) {
            Log.e(TAG, "Invalid portIndex: " + i2);
            return false;
        }
        UiccSlot uiccSlot = UiccController.getInstance().getUiccSlot(getSlotIndexFromCardId(i));
        if (uiccSlot == null || uiccSlot.getPortList().length == 0 || i2 >= uiccSlot.getPortList().length) {
            Log.e(TAG, "Invalid portIndex");
            return false;
        }
        if (this.mTelephonyManager.getActiveModemCount() == 1) {
            int[] portList = uiccSlot.getPortList();
            int length = portList.length;
            int i3 = 0;
            while (i3 < length) {
                int i4 = portList[i3];
                if (!uiccSlot.isPortActive(i4) || i4 == i2) {
                    i3++;
                } else {
                    Log.e(TAG, "In SS Mode, slot already has active port on portIndex " + i4 + " , reject the switch request to portIndex " + i2);
                    return false;
                }
            }
        } else if (this.mTelephonyManager.getActiveModemCount() > 1 && isRemovalNonEuiccSlotHasActiveSubscription()) {
            int[] portList2 = uiccSlot.getPortList();
            int length2 = portList2.length;
            int i5 = 0;
            while (i5 < length2) {
                int i6 = portList2[i5];
                if (!uiccSlot.isPortActive(i6) || this.mSubscriptionManager.getActiveSubscriptionInfoForSimSlotIndex(uiccSlot.getPhoneIdFromPortIndex(i6)) != null || i6 == i2) {
                    i5++;
                } else {
                    Log.e(TAG, "In DSDS Mode, pSim has active subscription, eSim has empty active port on portIndex " + i6 + " , reject the switch request to portIndex " + i2);
                    return false;
                }
            }
        }
        return true;
    }

    private int getNextAvailableInActivePortIndex(UiccSlot uiccSlot) {
        if (uiccSlot == null) {
            return -1;
        }
        for (int i : uiccSlot.getPortList()) {
            if (!uiccSlot.isPortActive(i)) {
                return i;
            }
        }
        return -1;
    }

    private int getSlotIndexFromCardId(int i) {
        UiccSlotInfo[] uiccSlotsInfo = this.mTelephonyManager.getUiccSlotsInfo();
        if (uiccSlotsInfo == null || uiccSlotsInfo.length == 0) {
            Log.e(TAG, "UiccSlotInfo is null or empty");
            return -1;
        }
        String convertToCardString = UiccController.getInstance().convertToCardString(i);
        for (int i2 = 0; i2 < uiccSlotsInfo.length; i2++) {
            if (uiccSlotsInfo[i2] == null) {
                AnomalyReporter.reportAnomaly(UUID.fromString("e9517acf-e1a1-455f-9231-1b5515a0d0eb"), "EuiccController: Found UiccSlotInfo Null object.");
            }
            UiccSlotInfo uiccSlotInfo = uiccSlotsInfo[i2];
            if (IccUtils.compareIgnoreTrailingFs(convertToCardString, uiccSlotInfo != null ? uiccSlotInfo.getCardId() : null)) {
                return i2;
            }
        }
        Log.i(TAG, "No UiccSlotInfo found for cardId: " + i);
        return -1;
    }

    private boolean isRemovalNonEuiccSlotHasActiveSubscription() {
        UiccSlot removableNonEuiccSlot = getRemovableNonEuiccSlot();
        if (removableNonEuiccSlot != null) {
            for (int i : removableNonEuiccSlot.getPortList()) {
                if (removableNonEuiccSlot.isPortActive(i) && this.mSubscriptionManager.getActiveSubscriptionInfoForSimSlotIndex(removableNonEuiccSlot.getPhoneIdFromPortIndex(i)) != null) {
                    return true;
                }
            }
        }
        return false;
    }

    private UiccSlot getRemovableNonEuiccSlot() {
        UiccSlot[] uiccSlots = UiccController.getInstance().getUiccSlots();
        if (uiccSlots == null) {
            return null;
        }
        for (int i = 0; i < uiccSlots.length; i++) {
            UiccSlot uiccSlot = uiccSlots[i];
            if (uiccSlot != null && uiccSlot.isRemovable() && !uiccSlots[i].isEuicc()) {
                return uiccSlots[i];
            }
        }
        return null;
    }

    /* access modifiers changed from: package-private */
    public void switchToSubscriptionPrivileged(int i, int i2, long j, int i3, boolean z, String str, PendingIntent pendingIntent, boolean z2) {
        SubscriptionInfo subscriptionForSubscriptionId = getSubscriptionForSubscriptionId(i3);
        switchToSubscriptionPrivileged(i, i2, j, i3, subscriptionForSubscriptionId != null ? subscriptionForSubscriptionId.getIccId() : null, z, str, pendingIntent, z2);
    }

    /* access modifiers changed from: package-private */
    public void switchToSubscriptionPrivileged(int i, int i2, long j, int i3, String str, boolean z, String str2, PendingIntent pendingIntent, boolean z2) {
        final String str3 = str2;
        final long j2 = j;
        final int i4 = i3;
        final int i5 = i;
        final int i6 = i2;
        final boolean z3 = z2;
        final PendingIntent pendingIntent2 = pendingIntent;
        this.mConnector.switchToSubscription(i, i2, str, z, new EuiccConnector.SwitchCommandCallback() {
            public void onSwitchComplete(int i) {
                int i2;
                Intent intent = new Intent();
                if (i == -1) {
                    EuiccController euiccController = EuiccController.this;
                    String str = str3;
                    euiccController.addResolutionIntent(intent, "android.service.euicc.action.RESOLVE_DEACTIVATE_SIM", str, 0, false, EuiccOperation.forSwitchDeactivateSim(j2, i4, str), i5, i6, z3, i4);
                    i2 = 1;
                } else if (i != 0) {
                    i2 = 2;
                    EuiccController.this.addExtrasToResultIntent(intent, i);
                } else {
                    i2 = 0;
                }
                EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent2, i2, intent);
            }

            public void onEuiccServiceUnavailable() {
                EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent2, 2, (Intent) null);
            }
        }, z2);
    }

    public void updateSubscriptionNickname(int i, int i2, String str, String str2, final PendingIntent pendingIntent) {
        boolean callerCanWriteEmbeddedSubscriptions = callerCanWriteEmbeddedSubscriptions();
        this.mAppOpsManager.checkPackage(Binder.getCallingUid(), str2);
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            SubscriptionInfo subscriptionForSubscriptionId = getSubscriptionForSubscriptionId(i2);
            if (subscriptionForSubscriptionId == null) {
                Log.e(TAG, "Cannot update nickname to nonexistent sub: " + i2);
                lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, (Intent) null);
                return;
            }
            if (!callerCanWriteEmbeddedSubscriptions) {
                if (!this.mSubscriptionManager.canManageSubscription(subscriptionForSubscriptionId, str2)) {
                    Log.e(TAG, "No permissions: " + i2);
                    lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, (Intent) null);
                    Binder.restoreCallingIdentity(clearCallingIdentity);
                    return;
                }
            }
            this.mConnector.updateSubscriptionNickname(i, subscriptionForSubscriptionId.getIccId(), str, new EuiccConnector.UpdateNicknameCommandCallback() {
                public void onUpdateNicknameComplete(int i) {
                    Intent intent = new Intent();
                    if (i != 0) {
                        EuiccController.this.addExtrasToResultIntent(intent, i);
                        EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, intent);
                        return;
                    }
                    EuiccController.this.refreshSubscriptionsAndSendResult(pendingIntent, 0, intent);
                }

                public void onEuiccServiceUnavailable() {
                    EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, (Intent) null);
                }
            });
            Binder.restoreCallingIdentity(clearCallingIdentity);
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public void eraseSubscriptions(int i, final PendingIntent pendingIntent) {
        if (callerCanWriteEmbeddedSubscriptions()) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                this.mConnector.eraseSubscriptions(i, new EuiccConnector.EraseCommandCallback() {
                    public void onEraseComplete(int i) {
                        Intent intent = new Intent();
                        if (i != 0) {
                            EuiccController.this.addExtrasToResultIntent(intent, i);
                            EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, intent);
                            return;
                        }
                        EuiccController.this.refreshSubscriptionsAndSendResult(pendingIntent, 0, intent);
                    }

                    public void onEuiccServiceUnavailable() {
                        EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, (Intent) null);
                    }
                });
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        } else {
            throw new SecurityException("Must have WRITE_EMBEDDED_SUBSCRIPTIONS to erase subscriptions");
        }
    }

    public void eraseSubscriptionsWithOptions(int i, int i2, final PendingIntent pendingIntent) {
        if (callerCanWriteEmbeddedSubscriptions()) {
            long clearCallingIdentity = Binder.clearCallingIdentity();
            try {
                this.mConnector.eraseSubscriptionsWithOptions(i, i2, new EuiccConnector.EraseCommandCallback() {
                    public void onEraseComplete(int i) {
                        Intent intent = new Intent();
                        if (i != 0) {
                            EuiccController.this.addExtrasToResultIntent(intent, i);
                            EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, intent);
                            return;
                        }
                        EuiccController.this.refreshSubscriptionsAndSendResult(pendingIntent, 0, intent);
                    }

                    public void onEuiccServiceUnavailable() {
                        EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, (Intent) null);
                    }
                });
            } finally {
                Binder.restoreCallingIdentity(clearCallingIdentity);
            }
        } else {
            throw new SecurityException("Must have WRITE_EMBEDDED_SUBSCRIPTIONS to erase subscriptions");
        }
    }

    public void retainSubscriptionsForFactoryReset(int i, final PendingIntent pendingIntent) {
        this.mContext.enforceCallingPermission("android.permission.MASTER_CLEAR", "Must have MASTER_CLEAR to retain subscriptions for factory reset");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            this.mConnector.retainSubscriptions(i, new EuiccConnector.RetainSubscriptionsCommandCallback() {
                public void onRetainSubscriptionsComplete(int i) {
                    int i2;
                    Intent intent = new Intent();
                    if (i != 0) {
                        i2 = 2;
                        EuiccController.this.addExtrasToResultIntent(intent, i);
                    } else {
                        i2 = 0;
                    }
                    EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, i2, intent);
                }

                public void onEuiccServiceUnavailable() {
                    EuiccController.this.lambda$refreshSubscriptionsAndSendResult$0(pendingIntent, 2, (Intent) null);
                }
            });
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public void refreshSubscriptionsAndSendResult(PendingIntent pendingIntent, int i, Intent intent) {
        SubscriptionController.getInstance().requestEmbeddedSubscriptionInfoListRefresh((Runnable) new EuiccController$$ExternalSyntheticLambda0(this, pendingIntent, i, intent));
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    /* renamed from: sendResult */
    public void lambda$refreshSubscriptionsAndSendResult$0(PendingIntent pendingIntent, int i, Intent intent) {
        try {
            pendingIntent.send(this.mContext, i, intent);
        } catch (PendingIntent.CanceledException unused) {
        }
    }

    public void addResolutionIntentWithPort(Intent intent, String str, String str2, int i, boolean z, EuiccOperation euiccOperation, int i2, int i3, boolean z2) {
        addResolutionIntent(intent, str, str2, i, z, euiccOperation, i2, i3, z2, -1);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public void addResolutionIntent(Intent intent, String str, String str2, int i, boolean z, EuiccOperation euiccOperation, int i2, int i3, boolean z2, int i4) {
        Intent intent2 = new Intent("android.telephony.euicc.action.RESOLVE_ERROR");
        intent2.setPackage(RESOLUTION_ACTIVITY_PACKAGE_NAME);
        intent2.setComponent(new ComponentName(RESOLUTION_ACTIVITY_PACKAGE_NAME, RESOLUTION_ACTIVITY_CLASS_NAME));
        intent2.putExtra("android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_RESOLUTION_ACTION", str);
        intent2.putExtra("android.service.euicc.extra.RESOLUTION_CALLING_PACKAGE", str2);
        intent2.putExtra("android.service.euicc.extra.RESOLVABLE_ERRORS", i);
        intent2.putExtra("android.service.euicc.extra.RESOLUTION_CARD_ID", i2);
        intent2.putExtra("android.service.euicc.extra.RESOLUTION_SUBSCRIPTION_ID", i4);
        intent2.putExtra("android.service.euicc.extra.RESOLUTION_PORT_INDEX", i3);
        intent2.putExtra("android.service.euicc.extra.RESOLUTION_USE_PORT_INDEX", z2);
        intent2.putExtra("android.service.euicc.extra.RESOLUTION_CONFIRMATION_CODE_RETRIED", z);
        intent2.putExtra(EXTRA_OPERATION, euiccOperation);
        intent.putExtra("android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_RESOLUTION_INTENT", PendingIntent.getActivity(this.mContext, 0, intent2, 1107296256));
    }

    public void dump(FileDescriptor fileDescriptor, final PrintWriter printWriter, String[] strArr) {
        this.mContext.enforceCallingOrSelfPermission("android.permission.DUMP", "Requires DUMP");
        long clearCallingIdentity = Binder.clearCallingIdentity();
        printWriter.println("===== BEGIN EUICC CLINIC =====");
        try {
            printWriter.println("===== EUICC CONNECTOR =====");
            this.mConnector.dump(fileDescriptor, printWriter, strArr);
            final CountDownLatch countDownLatch = new CountDownLatch(1);
            this.mConnector.dumpEuiccService(new EuiccConnector.DumpEuiccServiceCommandCallback() {
                public void onDumpEuiccServiceComplete(String str) {
                    printWriter.println("===== EUICC SERVICE =====");
                    printWriter.println(str);
                    countDownLatch.countDown();
                }

                public void onEuiccServiceUnavailable() {
                    printWriter.println("===== EUICC SERVICE UNAVAILABLE =====");
                    countDownLatch.countDown();
                }
            });
            if (!countDownLatch.await(5, TimeUnit.SECONDS)) {
                printWriter.println("===== EUICC SERVICE TIMEOUT =====");
            }
        } catch (InterruptedException unused) {
            printWriter.println("===== EUICC SERVICE INTERRUPTED =====");
        } catch (Throwable th) {
            printWriter.println("===== END EUICC CLINIC =====");
            Binder.restoreCallingIdentity(clearCallingIdentity);
            throw th;
        }
        printWriter.println("===== END EUICC CLINIC =====");
        Binder.restoreCallingIdentity(clearCallingIdentity);
    }

    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public void sendOtaStatusChangedBroadcast() {
        Intent intent = new Intent("android.telephony.euicc.action.OTA_STATUS_CHANGED");
        ComponentInfo findBestComponent = EuiccConnector.findBestComponent(this.mContext.getPackageManager());
        if (findBestComponent != null) {
            intent.setPackage(findBestComponent.packageName);
        }
        this.mContext.sendBroadcast(intent, "android.permission.WRITE_EMBEDDED_SUBSCRIPTIONS");
    }

    private SubscriptionInfo getSubscriptionForSubscriptionId(int i) {
        List availableSubscriptionInfoList = this.mSubscriptionManager.getAvailableSubscriptionInfoList();
        int size = availableSubscriptionInfoList != null ? availableSubscriptionInfoList.size() : 0;
        for (int i2 = 0; i2 < size; i2++) {
            SubscriptionInfo subscriptionInfo = (SubscriptionInfo) availableSubscriptionInfoList.get(i2);
            if (i == subscriptionInfo.getSubscriptionId()) {
                return subscriptionInfo;
            }
        }
        return null;
    }

    private String blockingGetEidFromEuiccService(int i) {
        final CountDownLatch countDownLatch = new CountDownLatch(1);
        final AtomicReference atomicReference = new AtomicReference();
        this.mConnector.getEid(i, new EuiccConnector.GetEidCommandCallback() {
            public void onGetEidComplete(String str) {
                atomicReference.set(str);
                countDownLatch.countDown();
            }

            public void onEuiccServiceUnavailable() {
                countDownLatch.countDown();
            }
        });
        return (String) awaitResult(countDownLatch, atomicReference);
    }

    private int blockingGetOtaStatusFromEuiccService(int i) {
        final CountDownLatch countDownLatch = new CountDownLatch(1);
        final AtomicReference atomicReference = new AtomicReference(5);
        this.mConnector.getOtaStatus(i, new EuiccConnector.GetOtaStatusCommandCallback() {
            public void onGetOtaStatusComplete(int i) {
                atomicReference.set(Integer.valueOf(i));
                countDownLatch.countDown();
            }

            public void onEuiccServiceUnavailable() {
                countDownLatch.countDown();
            }
        });
        return ((Integer) awaitResult(countDownLatch, atomicReference)).intValue();
    }

    private EuiccInfo blockingGetEuiccInfoFromEuiccService(int i) {
        final CountDownLatch countDownLatch = new CountDownLatch(1);
        final AtomicReference atomicReference = new AtomicReference();
        this.mConnector.getEuiccInfo(i, new EuiccConnector.GetEuiccInfoCommandCallback() {
            public void onGetEuiccInfoComplete(EuiccInfo euiccInfo) {
                atomicReference.set(euiccInfo);
                countDownLatch.countDown();
            }

            public void onEuiccServiceUnavailable() {
                countDownLatch.countDown();
            }
        });
        return (EuiccInfo) awaitResult(countDownLatch, atomicReference);
    }

    private static <T> T awaitResult(CountDownLatch countDownLatch, AtomicReference<T> atomicReference) {
        try {
            countDownLatch.await();
        } catch (InterruptedException unused) {
            Thread.currentThread().interrupt();
        }
        return atomicReference.get();
    }

    /* access modifiers changed from: private */
    public boolean checkCarrierPrivilegeInMetadata(DownloadableSubscription downloadableSubscription, String str) {
        List accessRules = downloadableSubscription.getAccessRules();
        UiccAccessRule[] uiccAccessRuleArr = accessRules != null ? (UiccAccessRule[]) accessRules.toArray(new UiccAccessRule[accessRules.size()]) : null;
        if (uiccAccessRuleArr == null) {
            Log.e(TAG, "No access rules but caller is unprivileged");
            return false;
        }
        try {
            PackageInfo packageInfo = this.mPackageManager.getPackageInfo(str, 134217728);
            for (UiccAccessRule carrierPrivilegeStatus : uiccAccessRuleArr) {
                if (carrierPrivilegeStatus.getCarrierPrivilegeStatus(packageInfo) == 1) {
                    Log.i(TAG, "Calling package has carrier privilege to this profile");
                    return true;
                }
            }
            Log.e(TAG, "Calling package doesn't have carrier privilege to this profile");
            return false;
        } catch (PackageManager.NameNotFoundException unused) {
            Log.e(TAG, "Calling package valid but gone");
            return false;
        }
    }

    private boolean supportMultiActiveSlots() {
        return this.mTelephonyManager.getSupportedModemCount() > 1;
    }

    private boolean canManageActiveSubscriptionOnTargetSim(int i, String str, boolean z, int i2) {
        List<SubscriptionInfo> activeSubscriptionInfoList = this.mSubscriptionManager.getActiveSubscriptionInfoList(false);
        if (!(activeSubscriptionInfoList == null || activeSubscriptionInfoList.size() == 0)) {
            for (SubscriptionInfo subscriptionInfo : activeSubscriptionInfoList) {
                if ((i == -1 || subscriptionInfo.getCardId() == i) && subscriptionInfo.isEmbedded()) {
                    if ((!z || subscriptionInfo.getPortIndex() == i2) && this.mSubscriptionManager.canManageSubscription(subscriptionInfo, str)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    private boolean canManageSubscriptionOnTargetSim(int i, String str, boolean z, int i2) {
        boolean z2;
        boolean z3;
        boolean z4 = false;
        List<SubscriptionInfo> activeSubscriptionInfoList = this.mSubscriptionManager.getActiveSubscriptionInfoList(false);
        if (!(activeSubscriptionInfoList == null || activeSubscriptionInfoList.size() == 0)) {
            if (supportMultiActiveSlots()) {
                List<UiccCardInfo> uiccCardsInfo = this.mTelephonyManager.getUiccCardsInfo();
                if (uiccCardsInfo == null || uiccCardsInfo.isEmpty()) {
                    return false;
                }
                Iterator<UiccCardInfo> it = uiccCardsInfo.iterator();
                while (true) {
                    if (!it.hasNext()) {
                        z2 = false;
                        z3 = false;
                        break;
                    }
                    UiccCardInfo next = it.next();
                    if (next != null && next.getCardId() == i && next.isEuicc()) {
                        z2 = next.isMultipleEnabledProfilesSupported();
                        z3 = true;
                        break;
                    }
                }
                if (!z3) {
                    Log.i(TAG, "The target SIM is not an eUICC.");
                    return false;
                }
                for (SubscriptionInfo subscriptionInfo : activeSubscriptionInfoList) {
                    if (subscriptionInfo.isEmbedded() && subscriptionInfo.getCardId() == i) {
                        if (!z2 || !z || subscriptionInfo.getPortIndex() == i2) {
                            return this.mSubscriptionManager.canManageSubscription(subscriptionInfo, str);
                        }
                    }
                }
                long clearCallingIdentity = Binder.clearCallingIdentity();
                try {
                    if (this.mTelephonyManager.checkCarrierPrivilegesForPackageAnyPhone(str) == 1) {
                        z4 = true;
                    }
                    return z4;
                } finally {
                    Binder.restoreCallingIdentity(clearCallingIdentity);
                }
            } else {
                for (SubscriptionInfo subscriptionInfo2 : activeSubscriptionInfoList) {
                    if (subscriptionInfo2.isEmbedded() && this.mSubscriptionManager.canManageSubscription(subscriptionInfo2, str)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    private boolean callerCanReadPhoneStatePrivileged() {
        return this.mContext.checkCallingOrSelfPermission("android.permission.READ_PRIVILEGED_PHONE_STATE") == 0;
    }

    private boolean callerCanWriteEmbeddedSubscriptions() {
        return this.mContext.checkCallingOrSelfPermission("android.permission.WRITE_EMBEDDED_SUBSCRIPTIONS") == 0;
    }

    /* JADX INFO: finally extract failed */
    public boolean isSimPortAvailable(int i, int i2, String str) {
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            List<UiccCardInfo> uiccCardsInfo = this.mTelephonyManager.getUiccCardsInfo();
            Binder.restoreCallingIdentity(clearCallingIdentity);
            for (UiccCardInfo next : uiccCardsInfo) {
                if (next != null && next.getCardId() == i) {
                    if (!next.isEuicc() || i2 == -1 || i2 >= next.getPorts().size()) {
                        return false;
                    }
                    for (UiccPortInfo uiccPortInfo : next.getPorts()) {
                        if (uiccPortInfo != null && uiccPortInfo.getPortIndex() == i2) {
                            if (!uiccPortInfo.isActive()) {
                                return false;
                            }
                            if (TextUtils.isEmpty(uiccPortInfo.getIccId())) {
                                return true;
                            }
                            UiccPort uiccPortForSlot = UiccController.getInstance().getUiccPortForSlot(next.getPhysicalSlotIndex(), i2);
                            if (uiccPortForSlot != null && uiccPortForSlot.getUiccProfile() != null && uiccPortForSlot.getUiccProfile().isEmptyProfile()) {
                                return true;
                            }
                            Phone phone = PhoneFactory.getPhone(uiccPortInfo.getLogicalSlotIndex());
                            if (phone == null) {
                                Log.e(TAG, "Invalid logical slot: " + uiccPortInfo.getLogicalSlotIndex());
                                return false;
                            }
                            CarrierPrivilegesTracker carrierPrivilegesTracker = phone.getCarrierPrivilegesTracker();
                            if (carrierPrivilegesTracker == null) {
                                Log.e(TAG, "No CarrierPrivilegesTracker");
                                return false;
                            } else if (carrierPrivilegesTracker.getCarrierPrivilegeStatusForPackage(str) == 1) {
                                return true;
                            } else {
                                return false;
                            }
                        }
                    }
                    continue;
                }
            }
            return false;
        } catch (Throwable th) {
            Binder.restoreCallingIdentity(clearCallingIdentity);
            throw th;
        }
    }

    public boolean hasCarrierPrivilegesForPackageOnAnyPhone(String str) {
        this.mAppOpsManager.checkPackage(Binder.getCallingUid(), str);
        long clearCallingIdentity = Binder.clearCallingIdentity();
        try {
            int checkCarrierPrivilegesForPackageAnyPhone = this.mTelephonyManager.checkCarrierPrivilegesForPackageAnyPhone(str);
            boolean z = true;
            if (checkCarrierPrivilegesForPackageAnyPhone != 1) {
                z = false;
            }
            return z;
        } finally {
            Binder.restoreCallingIdentity(clearCallingIdentity);
        }
    }

    public boolean isCompatChangeEnabled(String str, long j) {
        this.mAppOpsManager.checkPackage(Binder.getCallingUid(), str);
        boolean isChangeEnabled = CompatChanges.isChangeEnabled(j, str, Binder.getCallingUserHandle());
        Log.i(TAG, "isCompatChangeEnabled changeId: " + j + " changeEnabled: " + isChangeEnabled);
        return isChangeEnabled;
    }
}
