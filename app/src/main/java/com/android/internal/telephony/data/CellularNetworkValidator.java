package com.android.internal.telephony.data;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import android.net.TelephonyNetworkSpecifier;
import android.os.Handler;
import android.telephony.CellIdentity;
import android.telephony.CellIdentityLte;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.SubscriptionManager;
import android.util.Log;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConfigurationManager;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.SubscriptionController;
import com.android.internal.telephony.metrics.TelephonyMetrics;
import java.util.HashMap;
import java.util.Map;
import java.util.PriorityQueue;
import java.util.concurrent.TimeUnit;

public class CellularNetworkValidator {
    private static final String LOG_TAG = "NetworkValidator";
    @VisibleForTesting
    public static final long MAX_VALIDATION_CACHE_TTL = TimeUnit.DAYS.toMillis(1);
    private static final int STATE_IDLE = 0;
    private static final int STATE_VALIDATED = 2;
    private static final int STATE_VALIDATING = 1;
    private static CellularNetworkValidator sInstance = null;
    private static boolean sWaitForNetworkAvailableWhenCacheHit = true;
    private ConnectivityManager mConnectivityManager;
    /* access modifiers changed from: private */
    public Context mContext;
    @VisibleForTesting
    public Handler mHandler = new Handler();
    @VisibleForTesting
    public ConnectivityNetworkCallback mNetworkCallback;
    private NetworkRequest mNetworkRequest;
    private boolean mReleaseAfterValidation;
    private int mState = 0;
    private int mSubId;
    private long mTimeoutInMs;
    /* access modifiers changed from: private */
    public final ValidatedNetworkCache mValidatedNetworkCache = new ValidatedNetworkCache();
    private ValidationCallback mValidationCallback;

    public interface ValidationCallback {
        void onNetworkAvailable(Network network, int i);

        void onValidationDone(boolean z, int i);
    }

    private class ValidatedNetworkCache {
        private static final int VALIDATED_NETWORK_CACHE_SIZE = 10;
        private final Map<String, ValidatedNetwork> mValidatedNetworkMap;
        private final PriorityQueue<ValidatedNetwork> mValidatedNetworkPQ;

        private ValidatedNetworkCache() {
            this.mValidatedNetworkPQ = new PriorityQueue<>(new CellularNetworkValidator$ValidatedNetworkCache$$ExternalSyntheticLambda0());
            this.mValidatedNetworkMap = new HashMap();
        }

        /* access modifiers changed from: private */
        public static /* synthetic */ int lambda$new$0(ValidatedNetwork validatedNetwork, ValidatedNetwork validatedNetwork2) {
            long j = validatedNetwork.mValidationTimeStamp;
            long j2 = validatedNetwork2.mValidationTimeStamp;
            if (j < j2) {
                return -1;
            }
            return j > j2 ? 1 : 0;
        }

        private final class ValidatedNetwork {
            final String mValidationIdentity;
            long mValidationTimeStamp;

            ValidatedNetwork(String str, long j) {
                this.mValidationIdentity = str;
                this.mValidationTimeStamp = j;
            }

            /* access modifiers changed from: package-private */
            public void update(long j) {
                this.mValidationTimeStamp = j;
            }
        }

        /* access modifiers changed from: package-private */
        /* JADX WARNING: Code restructure failed: missing block: B:14:0x0048, code lost:
            return false;
         */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public synchronized boolean isRecentlyValidated(int r9) {
            /*
                r8 = this;
                monitor-enter(r8)
                long r0 = r8.getValidationCacheTtl(r9)     // Catch:{ all -> 0x0049 }
                java.lang.String r2 = r8.getValidationNetworkIdentity(r9)     // Catch:{ all -> 0x0049 }
                r3 = 0
                if (r2 == 0) goto L_0x0047
                java.util.Map<java.lang.String, com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork> r4 = r8.mValidatedNetworkMap     // Catch:{ all -> 0x0049 }
                boolean r4 = r4.containsKey(r2)     // Catch:{ all -> 0x0049 }
                if (r4 != 0) goto L_0x0015
                goto L_0x0047
            L_0x0015:
                java.util.Map<java.lang.String, com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork> r4 = r8.mValidatedNetworkMap     // Catch:{ all -> 0x0049 }
                java.lang.Object r2 = r4.get(r2)     // Catch:{ all -> 0x0049 }
                com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork r2 = (com.android.internal.telephony.data.CellularNetworkValidator.ValidatedNetworkCache.ValidatedNetwork) r2     // Catch:{ all -> 0x0049 }
                long r4 = r2.mValidationTimeStamp     // Catch:{ all -> 0x0049 }
                long r6 = java.lang.System.currentTimeMillis()     // Catch:{ all -> 0x0049 }
                long r6 = r6 - r4
                int r0 = (r6 > r0 ? 1 : (r6 == r0 ? 0 : -1))
                if (r0 >= 0) goto L_0x0029
                r3 = 1
            L_0x0029:
                java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x0049 }
                r0.<init>()     // Catch:{ all -> 0x0049 }
                java.lang.String r1 = "isRecentlyValidated on subId "
                r0.append(r1)     // Catch:{ all -> 0x0049 }
                r0.append(r9)     // Catch:{ all -> 0x0049 }
                java.lang.String r9 = " ? "
                r0.append(r9)     // Catch:{ all -> 0x0049 }
                r0.append(r3)     // Catch:{ all -> 0x0049 }
                java.lang.String r9 = r0.toString()     // Catch:{ all -> 0x0049 }
                com.android.internal.telephony.data.CellularNetworkValidator.logd(r9)     // Catch:{ all -> 0x0049 }
                monitor-exit(r8)
                return r3
            L_0x0047:
                monitor-exit(r8)
                return r3
            L_0x0049:
                r9 = move-exception
                monitor-exit(r8)
                throw r9
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.data.CellularNetworkValidator.ValidatedNetworkCache.isRecentlyValidated(int):boolean");
        }

        /* access modifiers changed from: package-private */
        /* JADX WARNING: Code restructure failed: missing block: B:24:0x0081, code lost:
            return;
         */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public synchronized void storeLastValidationResult(int r4, boolean r5) {
            /*
                r3 = this;
                monitor-enter(r3)
                java.lang.String r0 = r3.getValidationNetworkIdentity(r4)     // Catch:{ all -> 0x0082 }
                java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x0082 }
                r1.<init>()     // Catch:{ all -> 0x0082 }
                java.lang.String r2 = "storeLastValidationResult for subId "
                r1.append(r2)     // Catch:{ all -> 0x0082 }
                r1.append(r4)     // Catch:{ all -> 0x0082 }
                if (r5 == 0) goto L_0x0018
                java.lang.String r4 = " validated."
                goto L_0x001a
            L_0x0018:
                java.lang.String r4 = " not validated."
            L_0x001a:
                r1.append(r4)     // Catch:{ all -> 0x0082 }
                java.lang.String r4 = r1.toString()     // Catch:{ all -> 0x0082 }
                com.android.internal.telephony.data.CellularNetworkValidator.logd(r4)     // Catch:{ all -> 0x0082 }
                if (r0 != 0) goto L_0x0028
                monitor-exit(r3)
                return
            L_0x0028:
                if (r5 != 0) goto L_0x003c
                java.util.PriorityQueue<com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork> r4 = r3.mValidatedNetworkPQ     // Catch:{ all -> 0x0082 }
                java.util.Map<java.lang.String, com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork> r5 = r3.mValidatedNetworkMap     // Catch:{ all -> 0x0082 }
                java.lang.Object r5 = r5.get(r0)     // Catch:{ all -> 0x0082 }
                r4.remove(r5)     // Catch:{ all -> 0x0082 }
                java.util.Map<java.lang.String, com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork> r4 = r3.mValidatedNetworkMap     // Catch:{ all -> 0x0082 }
                r4.remove(r0)     // Catch:{ all -> 0x0082 }
                monitor-exit(r3)
                return
            L_0x003c:
                long r4 = java.lang.System.currentTimeMillis()     // Catch:{ all -> 0x0082 }
                java.util.Map<java.lang.String, com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork> r1 = r3.mValidatedNetworkMap     // Catch:{ all -> 0x0082 }
                java.lang.Object r1 = r1.get(r0)     // Catch:{ all -> 0x0082 }
                com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork r1 = (com.android.internal.telephony.data.CellularNetworkValidator.ValidatedNetworkCache.ValidatedNetwork) r1     // Catch:{ all -> 0x0082 }
                if (r1 == 0) goto L_0x0058
                r1.update(r4)     // Catch:{ all -> 0x0082 }
                java.util.PriorityQueue<com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork> r4 = r3.mValidatedNetworkPQ     // Catch:{ all -> 0x0082 }
                r4.remove(r1)     // Catch:{ all -> 0x0082 }
                java.util.PriorityQueue<com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork> r4 = r3.mValidatedNetworkPQ     // Catch:{ all -> 0x0082 }
                r4.add(r1)     // Catch:{ all -> 0x0082 }
                goto L_0x0067
            L_0x0058:
                com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork r1 = new com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork     // Catch:{ all -> 0x0082 }
                r1.<init>(r0, r4)     // Catch:{ all -> 0x0082 }
                java.util.Map<java.lang.String, com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork> r4 = r3.mValidatedNetworkMap     // Catch:{ all -> 0x0082 }
                r4.put(r0, r1)     // Catch:{ all -> 0x0082 }
                java.util.PriorityQueue<com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork> r4 = r3.mValidatedNetworkPQ     // Catch:{ all -> 0x0082 }
                r4.add(r1)     // Catch:{ all -> 0x0082 }
            L_0x0067:
                java.util.PriorityQueue<com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork> r4 = r3.mValidatedNetworkPQ     // Catch:{ all -> 0x0082 }
                int r4 = r4.size()     // Catch:{ all -> 0x0082 }
                r5 = 10
                if (r4 <= r5) goto L_0x0080
                java.util.PriorityQueue<com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork> r4 = r3.mValidatedNetworkPQ     // Catch:{ all -> 0x0082 }
                java.lang.Object r4 = r4.poll()     // Catch:{ all -> 0x0082 }
                com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork r4 = (com.android.internal.telephony.data.CellularNetworkValidator.ValidatedNetworkCache.ValidatedNetwork) r4     // Catch:{ all -> 0x0082 }
                java.util.Map<java.lang.String, com.android.internal.telephony.data.CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork> r5 = r3.mValidatedNetworkMap     // Catch:{ all -> 0x0082 }
                java.lang.String r4 = r4.mValidationIdentity     // Catch:{ all -> 0x0082 }
                r5.remove(r4)     // Catch:{ all -> 0x0082 }
            L_0x0080:
                monitor-exit(r3)
                return
            L_0x0082:
                r4 = move-exception
                monitor-exit(r3)
                throw r4
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.data.CellularNetworkValidator.ValidatedNetworkCache.storeLastValidationResult(int, boolean):void");
        }

        private String getValidationNetworkIdentity(int i) {
            SubscriptionController instance;
            Phone phone;
            NetworkRegistrationInfo networkRegistrationInfo;
            if (!(!SubscriptionManager.isUsableSubscriptionId(i) || (instance = SubscriptionController.getInstance()) == null || (phone = PhoneFactory.getPhone(instance.getPhoneId(i))) == null || phone.getServiceState() == null || (networkRegistrationInfo = phone.getServiceState().getNetworkRegistrationInfo(2, 1)) == null || networkRegistrationInfo.getCellIdentity() == null)) {
                CellIdentity cellIdentity = networkRegistrationInfo.getCellIdentity();
                if (!(cellIdentity.getType() != 3 || cellIdentity.getMccString() == null || cellIdentity.getMncString() == null)) {
                    CellIdentityLte cellIdentityLte = (CellIdentityLte) cellIdentity;
                    if (cellIdentityLte.getTac() != Integer.MAX_VALUE) {
                        return cellIdentity.getMccString() + cellIdentity.getMncString() + "_" + cellIdentityLte.getTac() + "_" + i;
                    }
                }
            }
            return null;
        }

        /* JADX WARNING: Code restructure failed: missing block: B:2:0x0010, code lost:
            r2 = r2.getConfigForSubId(r3);
         */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        private long getValidationCacheTtl(int r3) {
            /*
                r2 = this;
                com.android.internal.telephony.data.CellularNetworkValidator r2 = com.android.internal.telephony.data.CellularNetworkValidator.this
                android.content.Context r2 = r2.mContext
                java.lang.String r0 = "carrier_config"
                java.lang.Object r2 = r2.getSystemService(r0)
                android.telephony.CarrierConfigManager r2 = (android.telephony.CarrierConfigManager) r2
                if (r2 == 0) goto L_0x001d
                android.os.PersistableBundle r2 = r2.getConfigForSubId(r3)
                if (r2 == 0) goto L_0x001d
                java.lang.String r3 = "data_switch_validation_min_gap_long"
                long r2 = r2.getLong(r3)
                goto L_0x001f
            L_0x001d:
                r2 = 0
            L_0x001f:
                long r0 = com.android.internal.telephony.data.CellularNetworkValidator.MAX_VALIDATION_CACHE_TTL
                long r2 = java.lang.Math.min(r2, r0)
                return r2
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.data.CellularNetworkValidator.ValidatedNetworkCache.getValidationCacheTtl(int):long");
        }
    }

    public static CellularNetworkValidator make(Context context) {
        if (sInstance != null) {
            logd("createCellularNetworkValidator failed. Instance already exists.");
        } else {
            sInstance = new CellularNetworkValidator(context);
        }
        return sInstance;
    }

    public static CellularNetworkValidator getInstance() {
        return sInstance;
    }

    public boolean isValidationFeatureSupported() {
        return PhoneConfigurationManager.getInstance().getCurrentPhoneCapability().isNetworkValidationBeforeSwitchSupported();
    }

    @VisibleForTesting
    public CellularNetworkValidator(Context context) {
        this.mContext = context;
        this.mConnectivityManager = (ConnectivityManager) context.getSystemService("connectivity");
    }

    public synchronized void validate(int i, long j, boolean z, ValidationCallback validationCallback) {
        if (i != this.mSubId) {
            if (!SubscriptionController.getInstance().isActiveSubId(i)) {
                logd("Failed to start validation. Inactive subId " + i);
                validationCallback.onValidationDone(false, i);
                return;
            }
            if (isValidating()) {
                lambda$reportValidationResult$1();
            }
            if (sWaitForNetworkAvailableWhenCacheHit || !this.mValidatedNetworkCache.isRecentlyValidated(i)) {
                this.mState = 1;
                this.mSubId = i;
                this.mTimeoutInMs = j;
                this.mValidationCallback = validationCallback;
                this.mReleaseAfterValidation = z;
                this.mNetworkRequest = createNetworkRequest();
                logd("Start validating subId " + this.mSubId + " mTimeoutInMs " + this.mTimeoutInMs + " mReleaseAfterValidation " + this.mReleaseAfterValidation);
                ConnectivityNetworkCallback connectivityNetworkCallback = new ConnectivityNetworkCallback(i);
                this.mNetworkCallback = connectivityNetworkCallback;
                this.mConnectivityManager.requestNetwork(this.mNetworkRequest, connectivityNetworkCallback, this.mHandler);
                this.mHandler.postDelayed(new CellularNetworkValidator$$ExternalSyntheticLambda0(this, i), this.mTimeoutInMs);
                return;
            }
            validationCallback.onValidationDone(true, i);
        }
    }

    /* access modifiers changed from: private */
    /* renamed from: onValidationTimeout */
    public synchronized void lambda$validate$0(int i) {
        logd("timeout on subId " + i + " validation.");
        this.mValidatedNetworkCache.storeLastValidationResult(i, false);
        reportValidationResult(false, i);
    }

    /* renamed from: stopValidation */
    public synchronized void lambda$reportValidationResult$1() {
        if (!isValidating()) {
            logd("No need to stop validation.");
            return;
        }
        ConnectivityNetworkCallback connectivityNetworkCallback = this.mNetworkCallback;
        if (connectivityNetworkCallback != null) {
            this.mConnectivityManager.unregisterNetworkCallback(connectivityNetworkCallback);
        }
        this.mState = 0;
        this.mHandler.removeCallbacksAndMessages((Object) null);
        this.mSubId = -1;
    }

    public synchronized int getSubIdInValidation() {
        return this.mSubId;
    }

    public synchronized boolean isValidating() {
        return this.mState != 0;
    }

    private NetworkRequest createNetworkRequest() {
        return new NetworkRequest.Builder().addCapability(12).addTransportType(0).setNetworkSpecifier(new TelephonyNetworkSpecifier.Builder().setSubscriptionId(this.mSubId).build()).build();
    }

    /* access modifiers changed from: private */
    /* JADX WARNING: Code restructure failed: missing block: B:19:0x003d, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public synchronized void reportValidationResult(boolean r5, int r6) {
        /*
            r4 = this;
            monitor-enter(r4)
            int r0 = r4.mSubId     // Catch:{ all -> 0x003e }
            if (r0 == r6) goto L_0x0007
            monitor-exit(r4)
            return
        L_0x0007:
            android.os.Handler r6 = r4.mHandler     // Catch:{ all -> 0x003e }
            r0 = 0
            r6.removeCallbacksAndMessages(r0)     // Catch:{ all -> 0x003e }
            int r6 = r4.mState     // Catch:{ all -> 0x003e }
            r0 = 1
            if (r6 != r0) goto L_0x003c
            com.android.internal.telephony.data.CellularNetworkValidator$ValidationCallback r6 = r4.mValidationCallback     // Catch:{ all -> 0x003e }
            int r0 = r4.mSubId     // Catch:{ all -> 0x003e }
            r6.onValidationDone(r5, r0)     // Catch:{ all -> 0x003e }
            r6 = 2
            r4.mState = r6     // Catch:{ all -> 0x003e }
            boolean r0 = r4.mReleaseAfterValidation     // Catch:{ all -> 0x003e }
            if (r0 != 0) goto L_0x002f
            if (r5 == 0) goto L_0x002f
            android.os.Handler r0 = r4.mHandler     // Catch:{ all -> 0x003e }
            com.android.internal.telephony.data.CellularNetworkValidator$$ExternalSyntheticLambda1 r1 = new com.android.internal.telephony.data.CellularNetworkValidator$$ExternalSyntheticLambda1     // Catch:{ all -> 0x003e }
            r1.<init>(r4)     // Catch:{ all -> 0x003e }
            r2 = 500(0x1f4, double:2.47E-321)
            r0.postDelayed(r1, r2)     // Catch:{ all -> 0x003e }
            goto L_0x0032
        L_0x002f:
            r4.lambda$reportValidationResult$1()     // Catch:{ all -> 0x003e }
        L_0x0032:
            com.android.internal.telephony.metrics.TelephonyMetrics r0 = com.android.internal.telephony.metrics.TelephonyMetrics.getInstance()     // Catch:{ all -> 0x003e }
            if (r5 == 0) goto L_0x0039
            r6 = 3
        L_0x0039:
            r0.writeNetworkValidate(r6)     // Catch:{ all -> 0x003e }
        L_0x003c:
            monitor-exit(r4)
            return
        L_0x003e:
            r5 = move-exception
            monitor-exit(r4)
            throw r5
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.data.CellularNetworkValidator.reportValidationResult(boolean, int):void");
    }

    /* access modifiers changed from: private */
    public synchronized void reportNetworkAvailable(Network network, int i) {
        if (this.mSubId == i) {
            this.mValidationCallback.onNetworkAvailable(network, i);
        }
    }

    @VisibleForTesting
    public class ConnectivityNetworkCallback extends ConnectivityManager.NetworkCallback {
        private final int mSubId;

        ConnectivityNetworkCallback(int i) {
            this.mSubId = i;
        }

        public void onAvailable(Network network) {
            CellularNetworkValidator.logd("network onAvailable " + network);
            TelephonyMetrics.getInstance().writeNetworkValidate(1);
            if (CellularNetworkValidator.this.mValidatedNetworkCache.isRecentlyValidated(this.mSubId)) {
                CellularNetworkValidator.this.reportValidationResult(true, this.mSubId);
            } else {
                CellularNetworkValidator.this.reportNetworkAvailable(network, this.mSubId);
            }
        }

        public void onLosing(Network network, int i) {
            CellularNetworkValidator.logd("network onLosing " + network + " maxMsToLive " + i);
            CellularNetworkValidator.this.mValidatedNetworkCache.storeLastValidationResult(this.mSubId, false);
            CellularNetworkValidator.this.reportValidationResult(false, this.mSubId);
        }

        public void onLost(Network network) {
            CellularNetworkValidator.logd("network onLost " + network);
            CellularNetworkValidator.this.mValidatedNetworkCache.storeLastValidationResult(this.mSubId, false);
            CellularNetworkValidator.this.reportValidationResult(false, this.mSubId);
        }

        public void onUnavailable() {
            CellularNetworkValidator.logd("onUnavailable");
            CellularNetworkValidator.this.mValidatedNetworkCache.storeLastValidationResult(this.mSubId, false);
            CellularNetworkValidator.this.reportValidationResult(false, this.mSubId);
        }

        public void onCapabilitiesChanged(Network network, NetworkCapabilities networkCapabilities) {
            if (networkCapabilities.hasCapability(16)) {
                CellularNetworkValidator.logd("onValidated");
                CellularNetworkValidator.this.mValidatedNetworkCache.storeLastValidationResult(this.mSubId, true);
                CellularNetworkValidator.this.reportValidationResult(true, this.mSubId);
            }
        }
    }

    /* access modifiers changed from: private */
    public static void logd(String str) {
        Log.d(LOG_TAG, str);
    }
}
