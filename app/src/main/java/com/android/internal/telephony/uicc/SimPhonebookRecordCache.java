package com.android.internal.telephony.uicc;

import android.content.Context;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.telephony.Rlog;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.RadioInterfaceCapabilityController;
import com.android.internal.telephony.uicc.SimPhonebookRecord;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentSkipListMap;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Collectors;

public class SimPhonebookRecordCache extends Handler {
    private static final boolean DBG = true;
    @VisibleForTesting
    static final boolean ENABLE_INFLATE_WITH_EMPTY_RECORDS = true;
    private static final int EVENT_GET_PHONEBOOK_CAPACITY_DONE = 4;
    private static final int EVENT_GET_PHONEBOOK_RECORDS_DONE = 3;
    private static final int EVENT_GET_PHONEBOOK_RECORDS_RETRY = 7;
    private static final int EVENT_PHONEBOOK_CHANGED = 1;
    private static final int EVENT_PHONEBOOK_RECORDS_RECEIVED = 2;
    private static final int EVENT_SIM_REFRESH = 6;
    private static final int EVENT_UPDATE_PHONEBOOK_RECORD_DONE = 5;
    private static final int INVALID_RECORD_ID = -1;
    private static final int MAX_RETRY_COUNT = 3;
    private static final int RETRY_INTERVAL = 3000;
    private String LOG_TAG = "SimPhonebookRecordCache";
    private AtomicReference<AdnCapacity> mAdnCapacity = new AtomicReference<>((Object) null);
    ArrayList<Message> mAdnLoadingWaiters = new ArrayList<>();
    private final CommandsInterface mCi;
    private Context mContext;
    private AtomicBoolean mIsCacheInvalidated = new AtomicBoolean(false);
    private AtomicBoolean mIsInRetry = new AtomicBoolean(false);
    private AtomicBoolean mIsInitialized = new AtomicBoolean(false);
    private AtomicBoolean mIsRecordLoading = new AtomicBoolean(false);
    boolean mIsUpdateDone = false;
    private int mPhoneId;
    private Object mReadLock = new Object();
    private final ConcurrentSkipListMap<Integer, AdnRecord> mSimPbRecords = new ConcurrentSkipListMap<>();
    private final List<UpdateRequest> mUpdateRequests = Collections.synchronizedList(new ArrayList());

    /* access modifiers changed from: private */
    public static /* synthetic */ AdnRecord lambda$populateAdnRecords$1(AdnRecord adnRecord) {
        return adnRecord;
    }

    @VisibleForTesting
    public void clear() {
    }

    public SimPhonebookRecordCache(Context context, int i, CommandsInterface commandsInterface) {
        this.mCi = commandsInterface;
        this.mPhoneId = i;
        this.mContext = context;
        this.LOG_TAG += "[" + i + "]";
        commandsInterface.registerForSimPhonebookChanged(this, 1, (Object) null);
        commandsInterface.registerForIccRefresh(this, 6, (Object) null);
        commandsInterface.registerForSimPhonebookRecordsReceived(this, 2, (Object) null);
    }

    public boolean isEnabled() {
        return this.mIsInitialized.get() || RadioInterfaceCapabilityController.getInstance().getCapabilities().contains("CAPABILITY_SIM_PHONEBOOK_IN_MODEM");
    }

    public void dispose() {
        reset();
        this.mCi.unregisterForSimPhonebookChanged(this);
        this.mCi.unregisterForIccRefresh(this);
        this.mCi.unregisterForSimPhonebookRecordsReceived(this);
    }

    private void reset() {
        this.mAdnCapacity.set((Object) null);
        this.mSimPbRecords.clear();
        this.mIsCacheInvalidated.set(false);
        this.mIsRecordLoading.set(false);
        this.mIsInRetry.set(false);
        this.mIsInitialized.set(false);
        this.mIsUpdateDone = false;
    }

    private void sendErrorResponse(Message message, String str) {
        if (message != null) {
            AsyncResult.forMessage(message).exception = new RuntimeException(str);
            message.sendToTarget();
        }
    }

    private void notifyAndClearWaiters() {
        synchronized (this.mReadLock) {
            Iterator<Message> it = this.mAdnLoadingWaiters.iterator();
            while (it.hasNext()) {
                Message next = it.next();
                if (next != null) {
                    AsyncResult.forMessage(next, new ArrayList(this.mSimPbRecords.values()), (Throwable) null);
                    next.sendToTarget();
                }
            }
            this.mAdnLoadingWaiters.clear();
        }
    }

    private void sendResponsesToWaitersWithError() {
        synchronized (this.mReadLock) {
            this.mReadLock.notify();
            Iterator<Message> it = this.mAdnLoadingWaiters.iterator();
            while (it.hasNext()) {
                sendErrorResponse(it.next(), "Query adn record failed");
            }
            this.mAdnLoadingWaiters.clear();
        }
    }

    private void getSimPhonebookCapacity() {
        logd("Start to getSimPhonebookCapacity");
        this.mCi.getSimPhonebookCapacity(obtainMessage(4));
    }

    public AdnCapacity getAdnCapacity() {
        return this.mAdnCapacity.get();
    }

    private void fillCache() {
        synchronized (this.mReadLock) {
            fillCacheWithoutWaiting();
            try {
                this.mReadLock.wait();
            } catch (InterruptedException unused) {
                loge("Interrupted Exception in queryAdnRecord");
            }
        }
    }

    private void fillCacheWithoutWaiting() {
        logd("Start to queryAdnRecord");
        if (this.mIsRecordLoading.compareAndSet(false, true)) {
            this.mCi.getSimPhonebookRecords(obtainMessage(3));
        } else {
            logd("The loading is ongoing");
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:21:0x0047, code lost:
        if (r3.mIsRecordLoading.get() != false) goto L_0x0062;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:23:0x004f, code lost:
        if (r3.mIsInRetry.get() != false) goto L_0x0062;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:24:0x0051, code lost:
        logd("ADN cache has already filled in");
     */
    /* JADX WARNING: Code restructure failed: missing block: B:25:0x005c, code lost:
        if (r3.mIsCacheInvalidated.get() != false) goto L_0x0062;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:26:0x005e, code lost:
        notifyAndClearWaiters();
     */
    /* JADX WARNING: Code restructure failed: missing block: B:27:0x0061, code lost:
        return;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:28:0x0062, code lost:
        fillCache();
     */
    /* JADX WARNING: Code restructure failed: missing block: B:29:0x0065, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void requestLoadAllPbRecords(android.os.Message r4) {
        /*
            r3 = this;
            if (r4 != 0) goto L_0x0013
            java.util.concurrent.atomic.AtomicBoolean r0 = r3.mIsInitialized
            boolean r0 = r0.get()
            if (r0 != 0) goto L_0x0013
            java.lang.String r4 = "Try to enforce flushing cache"
            r3.logd(r4)
            r3.fillCacheWithoutWaiting()
            return
        L_0x0013:
            java.lang.Object r0 = r3.mReadLock
            monitor-enter(r0)
            java.util.ArrayList<android.os.Message> r1 = r3.mAdnLoadingWaiters     // Catch:{ all -> 0x0098 }
            r1.add(r4)     // Catch:{ all -> 0x0098 }
            java.util.ArrayList<android.os.Message> r4 = r3.mAdnLoadingWaiters     // Catch:{ all -> 0x0098 }
            int r4 = r4.size()     // Catch:{ all -> 0x0098 }
            boolean r1 = r3.isAdnCapacityInvalid()     // Catch:{ all -> 0x0098 }
            if (r1 == 0) goto L_0x002a
            r3.getSimPhonebookCapacity()     // Catch:{ all -> 0x0098 }
        L_0x002a:
            r2 = 1
            if (r4 > r2) goto L_0x0066
            java.util.concurrent.atomic.AtomicBoolean r2 = r3.mIsInRetry     // Catch:{ all -> 0x0098 }
            boolean r2 = r2.get()     // Catch:{ all -> 0x0098 }
            if (r2 != 0) goto L_0x0066
            java.util.concurrent.atomic.AtomicBoolean r2 = r3.mIsInitialized     // Catch:{ all -> 0x0098 }
            boolean r2 = r2.get()     // Catch:{ all -> 0x0098 }
            if (r2 == 0) goto L_0x0066
            if (r1 == 0) goto L_0x0040
            goto L_0x0066
        L_0x0040:
            monitor-exit(r0)     // Catch:{ all -> 0x0098 }
            java.util.concurrent.atomic.AtomicBoolean r4 = r3.mIsRecordLoading
            boolean r4 = r4.get()
            if (r4 != 0) goto L_0x0062
            java.util.concurrent.atomic.AtomicBoolean r4 = r3.mIsInRetry
            boolean r4 = r4.get()
            if (r4 != 0) goto L_0x0062
            java.lang.String r4 = "ADN cache has already filled in"
            r3.logd(r4)
            java.util.concurrent.atomic.AtomicBoolean r4 = r3.mIsCacheInvalidated
            boolean r4 = r4.get()
            if (r4 != 0) goto L_0x0062
            r3.notifyAndClearWaiters()
            return
        L_0x0062:
            r3.fillCache()
            return
        L_0x0066:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x0098 }
            r1.<init>()     // Catch:{ all -> 0x0098 }
            java.lang.String r2 = "Add to the pending list as pending size = "
            r1.append(r2)     // Catch:{ all -> 0x0098 }
            r1.append(r4)     // Catch:{ all -> 0x0098 }
            java.lang.String r4 = " is retrying = "
            r1.append(r4)     // Catch:{ all -> 0x0098 }
            java.util.concurrent.atomic.AtomicBoolean r4 = r3.mIsInRetry     // Catch:{ all -> 0x0098 }
            boolean r4 = r4.get()     // Catch:{ all -> 0x0098 }
            r1.append(r4)     // Catch:{ all -> 0x0098 }
            java.lang.String r4 = " IsInitialized = "
            r1.append(r4)     // Catch:{ all -> 0x0098 }
            java.util.concurrent.atomic.AtomicBoolean r4 = r3.mIsInitialized     // Catch:{ all -> 0x0098 }
            boolean r4 = r4.get()     // Catch:{ all -> 0x0098 }
            r1.append(r4)     // Catch:{ all -> 0x0098 }
            java.lang.String r4 = r1.toString()     // Catch:{ all -> 0x0098 }
            r3.logd(r4)     // Catch:{ all -> 0x0098 }
            monitor-exit(r0)     // Catch:{ all -> 0x0098 }
            return
        L_0x0098:
            r3 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x0098 }
            throw r3
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.SimPhonebookRecordCache.requestLoadAllPbRecords(android.os.Message):void");
    }

    private boolean isAdnCapacityInvalid() {
        return getAdnCapacity() == null || !getAdnCapacity().isSimValid();
    }

    @VisibleForTesting
    public boolean isLoading() {
        return this.mIsRecordLoading.get();
    }

    @VisibleForTesting
    public List<AdnRecord> getAdnRecords() {
        return (List) this.mSimPbRecords.values().stream().collect(Collectors.toList());
    }

    private void notifyAdnLoadingWaiters() {
        synchronized (this.mReadLock) {
            this.mReadLock.notify();
        }
        notifyAndClearWaiters();
    }

    public void updateSimPbAdnByRecordId(int i, AdnRecord adnRecord, Message message) {
        if (adnRecord == null) {
            sendErrorResponse(message, "There is an invalid new Adn for update");
        } else if (!this.mSimPbRecords.containsKey(Integer.valueOf(i))) {
            sendErrorResponse(message, "There is an invalid old Adn for update");
        } else {
            updateSimPhonebookByNewAdn(i, adnRecord, message);
        }
    }

    public void updateSimPbAdnBySearch(AdnRecord adnRecord, AdnRecord adnRecord2, Message message) {
        int i;
        if (adnRecord2 == null) {
            sendErrorResponse(message, "There is an invalid new Adn for update");
            return;
        }
        if (adnRecord != null && !adnRecord.isEmpty()) {
            Iterator<AdnRecord> it = this.mSimPbRecords.values().iterator();
            while (true) {
                if (!it.hasNext()) {
                    break;
                }
                AdnRecord next = it.next();
                if (adnRecord.isEqual(next)) {
                    i = next.getRecId();
                    break;
                }
            }
        }
        i = -1;
        if (i != -1 || this.mAdnCapacity.get() == null || !this.mAdnCapacity.get().isSimFull()) {
            updateSimPhonebookByNewAdn(i, adnRecord2, message);
        } else {
            sendErrorResponse(message, "SIM Phonebook record is full");
        }
    }

    private void updateSimPhonebookByNewAdn(int i, AdnRecord adnRecord, Message message) {
        logd("update sim contact for record ID = " + i);
        UpdateRequest updateRequest = new UpdateRequest(i, adnRecord, new SimPhonebookRecord.Builder().setRecordId(i == -1 ? 0 : i).setAlphaTag(adnRecord.getAlphaTag()).setNumber(adnRecord.getNumber()).setEmails(adnRecord.getEmails()).setAdditionalNumbers(adnRecord.getAdditionalNumbers()).build(), message);
        this.mUpdateRequests.add(updateRequest);
        boolean isAdnCapacityInvalid = isAdnCapacityInvalid();
        if (isAdnCapacityInvalid) {
            getSimPhonebookCapacity();
        }
        if (this.mIsRecordLoading.get() || this.mIsInRetry.get() || this.mUpdateRequests.size() > 1 || !this.mIsInitialized.get() || isAdnCapacityInvalid) {
            logd("It is pending on update as  mIsRecordLoading = " + this.mIsRecordLoading.get() + " mIsInRetry = " + this.mIsInRetry.get() + " pending size = " + this.mUpdateRequests.size() + " mIsInitialized = " + this.mIsInitialized.get());
            return;
        }
        updateSimPhonebook(updateRequest);
    }

    private void updateSimPhonebook(UpdateRequest updateRequest) {
        logd("update Sim phonebook");
        this.mCi.updateSimPhonebookRecord(updateRequest.phonebookRecord, obtainMessage(5, updateRequest));
    }

    public void handleMessage(Message message) {
        switch (message.what) {
            case 1:
                logd("EVENT_PHONEBOOK_CHANGED");
                handlePhonebookChanged();
                return;
            case 2:
                logd("EVENT_PHONEBOOK_RECORDS_RECEIVED");
                AsyncResult asyncResult = (AsyncResult) message.obj;
                if (asyncResult.exception != null) {
                    loge("Unexpected exception happened");
                    asyncResult.result = null;
                }
                handlePhonebookRecordReceived((ReceivedPhonebookRecords) asyncResult.result);
                return;
            case 3:
                logd("EVENT_GET_PHONEBOOK_RECORDS_DONE");
                AsyncResult asyncResult2 = (AsyncResult) message.obj;
                if (asyncResult2 != null && asyncResult2.exception != null) {
                    loge("Failed to gain phonebook records");
                    invalidateSimPbCache();
                    if (!this.mIsInRetry.get()) {
                        sendGettingPhonebookRecordsRetry(0);
                        return;
                    }
                    return;
                }
                return;
            case 4:
                logd("EVENT_GET_PHONEBOOK_CAPACITY_DONE");
                AsyncResult asyncResult3 = (AsyncResult) message.obj;
                if (asyncResult3 == null || asyncResult3.exception != null) {
                    if (!isAdnCapacityInvalid()) {
                        this.mAdnCapacity.set(new AdnCapacity());
                    }
                    invalidateSimPbCache();
                    return;
                }
                handlePhonebookCapacityChanged((AdnCapacity) asyncResult3.result);
                return;
            case 5:
                logd("EVENT_UPDATE_PHONEBOOK_RECORD_DONE");
                handleUpdatePhonebookRecordDone((AsyncResult) message.obj);
                return;
            case 6:
                logd("EVENT_SIM_REFRESH");
                AsyncResult asyncResult4 = (AsyncResult) message.obj;
                if (asyncResult4.exception == null) {
                    handleSimRefresh((IccRefreshResponse) asyncResult4.result);
                    return;
                }
                logd("SIM refresh Exception: " + asyncResult4.exception);
                return;
            case 7:
                int i = message.arg1;
                logd("EVENT_GET_PHONEBOOK_RECORDS_RETRY cnt = " + i);
                if (i < 3) {
                    this.mIsRecordLoading.set(false);
                    fillCacheWithoutWaiting();
                    sendGettingPhonebookRecordsRetry(i + 1);
                    return;
                }
                responseToWaitersWithErrorOrSuccess(false);
                return;
            default:
                loge("Unexpected event: " + message.what);
                return;
        }
    }

    private void responseToWaitersWithErrorOrSuccess(boolean z) {
        logd("responseToWaitersWithErrorOrSuccess success = " + z);
        this.mIsRecordLoading.set(false);
        this.mIsInRetry.set(false);
        if (z) {
            notifyAdnLoadingWaiters();
        } else {
            sendResponsesToWaitersWithError();
        }
        tryFireUpdatePendingList();
    }

    private void handlePhonebookChanged() {
        if (this.mUpdateRequests.isEmpty()) {
            getSimPhonebookCapacity();
        } else {
            logd("Do nothing in the midst of multiple update");
        }
    }

    private void handlePhonebookCapacityChanged(AdnCapacity adnCapacity) {
        AdnCapacity adnCapacity2 = this.mAdnCapacity.get();
        if (adnCapacity == null) {
            adnCapacity = new AdnCapacity();
        }
        this.mAdnCapacity.set(adnCapacity);
        if (adnCapacity2 == null) {
            inflateWithEmptyRecords(adnCapacity);
            if (!adnCapacity.isSimEmpty()) {
                this.mIsCacheInvalidated.set(true);
                fillCacheWithoutWaiting();
            } else {
                notifyAdnLoadingWaiters();
            }
            this.mIsInitialized.set(true);
            return;
        }
        if (adnCapacity.isSimEmpty() || !adnCapacity.isSimValid()) {
            this.mIsCacheInvalidated.set(false);
            notifyAdnLoadingWaiters();
        } else if (!this.mIsUpdateDone) {
            invalidateSimPbCache();
            fillCacheWithoutWaiting();
        }
        this.mIsUpdateDone = false;
    }

    private void inflateWithEmptyRecords(AdnCapacity adnCapacity) {
        logd("inflateWithEmptyRecords");
        if (adnCapacity != null && this.mSimPbRecords.isEmpty()) {
            for (int i = 1; i <= adnCapacity.getMaxAdnCount(); i++) {
                this.mSimPbRecords.putIfAbsent(Integer.valueOf(i), new AdnRecord(28474, i, (String) null, (String) null, (String[]) null, (String[]) null));
            }
        }
    }

    private void handlePhonebookRecordReceived(ReceivedPhonebookRecords receivedPhonebookRecords) {
        if (receivedPhonebookRecords == null) {
            loge("No records there");
            responseToWaitersWithErrorOrSuccess(true);
        } else if (receivedPhonebookRecords.isOk()) {
            logd("Partial data is received");
            populateAdnRecords(receivedPhonebookRecords.getPhonebookRecords());
        } else if (receivedPhonebookRecords.isCompleted()) {
            logd("The whole loading process is finished");
            populateAdnRecords(receivedPhonebookRecords.getPhonebookRecords());
            this.mIsRecordLoading.set(false);
            this.mIsInRetry.set(false);
            this.mIsCacheInvalidated.set(false);
            notifyAdnLoadingWaiters();
            tryFireUpdatePendingList();
        } else if (!receivedPhonebookRecords.isRetryNeeded() || this.mIsInRetry.get()) {
            loge("Error happened");
            responseToWaitersWithErrorOrSuccess(true);
        } else {
            logd("Start to retry as aborted");
            sendGettingPhonebookRecordsRetry(0);
        }
    }

    private void handleUpdatePhonebookRecordDone(AsyncResult asyncResult) {
        RuntimeException runtimeException;
        UpdateRequest updateRequest = (UpdateRequest) asyncResult.userObj;
        this.mIsUpdateDone = true;
        if (asyncResult.exception == null) {
            int r1 = updateRequest.myRecordId;
            AdnRecord r2 = updateRequest.adnRecord;
            int i = ((int[]) asyncResult.result)[0];
            logd("my record ID = " + r1 + " new record ID = " + i);
            if (r1 == -1 || r1 == i) {
                if (!r2.isEmpty()) {
                    addOrChangeSimPbRecord(r2, i);
                } else {
                    deleteSimPbRecord(i);
                }
                runtimeException = null;
            } else {
                runtimeException = new RuntimeException("The record ID for update doesn't match");
            }
        } else {
            runtimeException = new RuntimeException("Update adn record failed", asyncResult.exception);
        }
        if (this.mUpdateRequests.contains(updateRequest)) {
            this.mUpdateRequests.remove(updateRequest);
            updateRequest.responseResult(runtimeException);
        } else {
            loge("this update request isn't found");
        }
        tryFireUpdatePendingList();
    }

    private void tryFireUpdatePendingList() {
        if (!this.mUpdateRequests.isEmpty()) {
            updateSimPhonebook(this.mUpdateRequests.get(0));
        }
    }

    private void handleSimRefresh(IccRefreshResponse iccRefreshResponse) {
        int i;
        if (iccRefreshResponse != null) {
            int i2 = iccRefreshResponse.refreshResult;
            if ((i2 == 0 && ((i = iccRefreshResponse.efId) == 20272 || i == 28474)) || i2 == 1) {
                invalidateSimPbCache();
                getSimPhonebookCapacity();
                return;
            }
            return;
        }
        logd("IccRefreshResponse received is null");
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ AdnRecord lambda$populateAdnRecords$0(SimPhonebookRecord simPhonebookRecord) {
        return new AdnRecord(28474, simPhonebookRecord.getRecordId(), simPhonebookRecord.getAlphaTag(), simPhonebookRecord.getNumber(), simPhonebookRecord.getEmails(), simPhonebookRecord.getAdditionalNumbers());
    }

    private void populateAdnRecords(List<SimPhonebookRecord> list) {
        if (list != null) {
            this.mSimPbRecords.putAll((Map) list.stream().map(new SimPhonebookRecordCache$$ExternalSyntheticLambda0()).collect(Collectors.toMap(new SimPhonebookRecordCache$$ExternalSyntheticLambda1(), new SimPhonebookRecordCache$$ExternalSyntheticLambda2())));
        }
    }

    private void sendGettingPhonebookRecordsRetry(int i) {
        if (hasMessages(7)) {
            removeMessages(7);
        }
        this.mIsInRetry.set(true);
        sendMessageDelayed(obtainMessage(7, 1, 0), 3000);
    }

    private void addOrChangeSimPbRecord(AdnRecord adnRecord, int i) {
        logd("Record number for the added or changed ADN is " + i);
        adnRecord.setRecId(i);
        this.mSimPbRecords.replace(Integer.valueOf(i), adnRecord);
    }

    private void deleteSimPbRecord(int i) {
        logd("Record number for the deleted ADN is " + i);
        this.mSimPbRecords.replace(Integer.valueOf(i), new AdnRecord(28474, i, (String) null, (String) null, (String[]) null, (String[]) null));
    }

    private void invalidateSimPbCache() {
        logd("invalidateSimPbCache");
        this.mIsCacheInvalidated.set(true);
        this.mSimPbRecords.replaceAll(new SimPhonebookRecordCache$$ExternalSyntheticLambda3());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ AdnRecord lambda$invalidateSimPbCache$2(Integer num, AdnRecord adnRecord) {
        return new AdnRecord(28474, num.intValue(), (String) null, (String) null, (String[]) null, (String[]) null);
    }

    private void logd(String str) {
        Rlog.d(this.LOG_TAG, str);
    }

    private void loge(String str) {
        Rlog.e(this.LOG_TAG, str);
    }

    private static final class UpdateRequest {
        /* access modifiers changed from: private */
        public AdnRecord adnRecord;
        /* access modifiers changed from: private */
        public int myRecordId;
        /* access modifiers changed from: private */
        public SimPhonebookRecord phonebookRecord;
        private Message response;

        UpdateRequest(int i, AdnRecord adnRecord2, SimPhonebookRecord simPhonebookRecord, Message message) {
            this.myRecordId = i;
            this.adnRecord = adnRecord2;
            this.phonebookRecord = simPhonebookRecord;
            this.response = message;
        }

        /* access modifiers changed from: package-private */
        public void responseResult(Exception exc) {
            Message message = this.response;
            if (message != null) {
                AsyncResult.forMessage(message, (Object) null, exc);
                this.response.sendToTarget();
            }
        }
    }
}
