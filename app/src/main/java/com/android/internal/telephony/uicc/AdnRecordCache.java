package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.util.SparseArray;
import com.android.internal.telephony.gsm.UsimPhoneBookManager;
import java.util.ArrayList;
import java.util.Iterator;

public class AdnRecordCache extends Handler implements IccConstants {
    protected static final int EVENT_LOAD_ALL_ADN_LIKE_DONE = 1;
    protected static final int EVENT_UPDATE_ADN_DONE = 2;
    protected SparseArray<ArrayList<AdnRecord>> mAdnLikeFiles = new SparseArray<>();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected SparseArray<ArrayList<Message>> mAdnLikeWaiters = new SparseArray<>();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected IccFileHandler mFh;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected SparseArray<Message> mUserWriteResponse = new SparseArray<>();
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected UsimPhoneBookManager mUsimPhoneBookManager;

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int extensionEfForEf(int i) {
        if (i != 20272) {
            return i != 28480 ? i != 28489 ? i != 28615 ? i != 28474 ? i != 28475 ? (i & 20479) == i ? 0 : -1 : IccConstants.EF_EXT2 : IccConstants.EF_EXT1 : IccConstants.EF_EXT6 : IccConstants.EF_EXT3 : IccConstants.EF_EXT1;
        }
        return 0;
    }

    public AdnRecordCache(IccFileHandler iccFileHandler) {
        this.mFh = iccFileHandler;
        this.mUsimPhoneBookManager = new UsimPhoneBookManager(iccFileHandler, this);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void reset() {
        this.mAdnLikeFiles.clear();
        this.mUsimPhoneBookManager.reset();
        clearWaiters();
        clearUserWriters();
    }

    /* access modifiers changed from: protected */
    public void clearWaiters() {
        int size = this.mAdnLikeWaiters.size();
        for (int i = 0; i < size; i++) {
            notifyWaiters(this.mAdnLikeWaiters.valueAt(i), new AsyncResult((Object) null, (Object) null, new RuntimeException("AdnCache reset")));
        }
        this.mAdnLikeWaiters.clear();
    }

    private void clearUserWriters() {
        int size = this.mUserWriteResponse.size();
        for (int i = 0; i < size; i++) {
            sendErrorResponse(this.mUserWriteResponse.valueAt(i), "AdnCace reset");
        }
        this.mUserWriteResponse.clear();
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ArrayList<AdnRecord> getRecordsIfLoaded(int i) {
        return this.mAdnLikeFiles.get(i);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private void sendErrorResponse(Message message, String str) {
        if (message != null) {
            AsyncResult.forMessage(message).exception = new RuntimeException(str);
            message.sendToTarget();
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void updateAdnByIndex(int i, AdnRecord adnRecord, int i2, String str, Message message) {
        int extensionEfForEf = extensionEfForEf(i);
        if (extensionEfForEf < 0) {
            sendErrorResponse(message, "EF is not known ADN-like EF:0x" + Integer.toHexString(i).toUpperCase());
        } else if (this.mUserWriteResponse.get(i) != null) {
            sendErrorResponse(message, "Have pending update for EF:0x" + Integer.toHexString(i).toUpperCase());
        } else {
            this.mUserWriteResponse.put(i, message);
            new AdnRecordLoader(this.mFh).updateEF(adnRecord, i, extensionEfForEf, i2, str, obtainMessage(2, i, i2, adnRecord));
        }
    }

    public void updateAdnBySearch(int i, AdnRecord adnRecord, AdnRecord adnRecord2, String str, Message message) {
        ArrayList<AdnRecord> arrayList;
        int i2;
        int i3 = i;
        AdnRecord adnRecord3 = adnRecord;
        AdnRecord adnRecord4 = adnRecord2;
        Message message2 = message;
        int extensionEfForEf = extensionEfForEf(i);
        if (extensionEfForEf < 0) {
            sendErrorResponse(message2, "EF is not known ADN-like EF:0x" + Integer.toHexString(i).toUpperCase());
            return;
        }
        if (i3 == 20272) {
            arrayList = this.mUsimPhoneBookManager.loadEfFilesFromUsim();
        } else {
            arrayList = getRecordsIfLoaded(i);
        }
        if (arrayList == null) {
            sendErrorResponse(message2, "Adn list not exist for EF:0x" + Integer.toHexString(i).toUpperCase());
            return;
        }
        Iterator<AdnRecord> it = arrayList.iterator();
        int i4 = 1;
        while (true) {
            if (!it.hasNext()) {
                i4 = -1;
                break;
            } else if (adnRecord.isEqual(it.next())) {
                break;
            } else {
                i4++;
            }
        }
        if (i4 == -1) {
            sendErrorResponse(message2, "Adn record don't exist for " + adnRecord);
            return;
        }
        if (i3 == 20272) {
            AdnRecord adnRecord5 = arrayList.get(i4 - 1);
            i2 = adnRecord5.mEfid;
            extensionEfForEf = adnRecord5.mExtRecord;
            int i5 = adnRecord5.mRecordNumber;
            adnRecord4.mEfid = i2;
            adnRecord4.mExtRecord = extensionEfForEf;
            adnRecord4.mRecordNumber = i5;
            i4 = i5;
        } else {
            i2 = i3;
        }
        if (this.mUserWriteResponse.get(i2) != null) {
            sendErrorResponse(message2, "Have pending update for EF:0x" + Integer.toHexString(i2).toUpperCase());
            return;
        }
        this.mUserWriteResponse.put(i2, message2);
        new AdnRecordLoader(this.mFh).updateEF(adnRecord2, i2, extensionEfForEf, i4, str, obtainMessage(2, i2, i4, adnRecord2));
    }

    public void requestLoadAllAdnLike(int i, int i2, Message message) {
        ArrayList<AdnRecord> arrayList;
        if (i == 20272) {
            arrayList = this.mUsimPhoneBookManager.loadEfFilesFromUsim();
        } else {
            arrayList = getRecordsIfLoaded(i);
        }
        if (arrayList == null) {
            ArrayList arrayList2 = this.mAdnLikeWaiters.get(i);
            if (arrayList2 != null) {
                arrayList2.add(message);
                return;
            }
            ArrayList arrayList3 = new ArrayList();
            arrayList3.add(message);
            this.mAdnLikeWaiters.put(i, arrayList3);
            if (i2 >= 0) {
                new AdnRecordLoader(this.mFh).loadAllFromEF(i, i2, obtainMessage(1, i, 0));
            } else if (message != null) {
                AsyncResult forMessage = AsyncResult.forMessage(message);
                forMessage.exception = new RuntimeException("EF is not known ADN-like EF:0x" + Integer.toHexString(i).toUpperCase());
                message.sendToTarget();
            }
        } else if (message != null) {
            AsyncResult.forMessage(message).result = arrayList;
            message.sendToTarget();
        }
    }

    /* access modifiers changed from: protected */
    public void notifyWaiters(ArrayList<Message> arrayList, AsyncResult asyncResult) {
        if (arrayList != null) {
            int size = arrayList.size();
            for (int i = 0; i < size; i++) {
                Message message = arrayList.get(i);
                AsyncResult.forMessage(message, asyncResult.result, asyncResult.exception);
                message.sendToTarget();
            }
        }
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 1) {
            AsyncResult asyncResult = (AsyncResult) message.obj;
            int i2 = message.arg1;
            ArrayList arrayList = this.mAdnLikeWaiters.get(i2);
            this.mAdnLikeWaiters.delete(i2);
            if (asyncResult.exception == null) {
                this.mAdnLikeFiles.put(i2, (ArrayList) asyncResult.result);
            }
            notifyWaiters(arrayList, asyncResult);
        } else if (i == 2) {
            AsyncResult asyncResult2 = (AsyncResult) message.obj;
            int i3 = message.arg1;
            int i4 = message.arg2;
            AdnRecord adnRecord = (AdnRecord) asyncResult2.userObj;
            if (asyncResult2.exception == null) {
                this.mAdnLikeFiles.get(i3).set(i4 - 1, adnRecord);
                this.mUsimPhoneBookManager.invalidateCache();
            }
            Message message2 = this.mUserWriteResponse.get(i3);
            this.mUserWriteResponse.delete(i3);
            if (message2 != null) {
                AsyncResult.forMessage(message2, (Object) null, asyncResult2.exception);
                message2.sendToTarget();
            }
        }
    }
}
