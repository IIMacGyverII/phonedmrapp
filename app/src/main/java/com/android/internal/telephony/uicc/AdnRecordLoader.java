package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import com.android.telephony.Rlog;
import java.util.ArrayList;

public class AdnRecordLoader extends Handler {
    protected static final int EVENT_ADN_LOAD_ALL_DONE = 3;
    protected static final int EVENT_ADN_LOAD_DONE = 1;
    protected static final int EVENT_EF_LINEAR_RECORD_SIZE_DONE = 4;
    protected static final int EVENT_EXT_RECORD_LOAD_DONE = 2;
    protected static final int EVENT_UPDATE_RECORD_DONE = 5;
    protected static final String LOG_TAG = "AdnRecordLoader";
    protected static final boolean VDBG = false;
    protected ArrayList<AdnRecord> mAdns;
    protected int mEf;
    protected int mExtensionEF;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected IccFileHandler mFh;
    protected int mPendingExtLoads;
    protected String mPin2;
    protected int mRecordNumber;
    protected Object mResult;
    protected Message mUserResponse;

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String getEFPath(int i) {
        if (i == 28474) {
            return "3F007F10";
        }
        return null;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public AdnRecordLoader(IccFileHandler iccFileHandler) {
        super(Looper.getMainLooper());
        this.mFh = iccFileHandler;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void loadFromEF(int i, int i2, int i3, Message message) {
        this.mEf = i;
        this.mExtensionEF = i2;
        this.mRecordNumber = i3;
        this.mUserResponse = message;
        this.mFh.loadEFLinearFixed(i, getEFPath(i), i3, obtainMessage(1));
    }

    public void loadAllFromEF(int i, int i2, Message message) {
        this.mEf = i;
        this.mExtensionEF = i2;
        this.mUserResponse = message;
        this.mFh.loadEFLinearFixedAll(i, getEFPath(i), obtainMessage(3));
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void updateEF(AdnRecord adnRecord, int i, int i2, int i3, String str, Message message) {
        this.mEf = i;
        this.mExtensionEF = i2;
        this.mRecordNumber = i3;
        this.mUserResponse = message;
        this.mPin2 = str;
        this.mFh.getEFLinearRecordSize(i, getEFPath(i), obtainMessage(4, adnRecord));
    }

    public void handleMessage(Message message) {
        Message message2 = message;
        try {
            int i = message2.what;
            if (i == 1) {
                AsyncResult asyncResult = (AsyncResult) message2.obj;
                byte[] bArr = (byte[]) asyncResult.result;
                if (asyncResult.exception == null) {
                    AdnRecord adnRecord = new AdnRecord(this.mEf, this.mRecordNumber, bArr);
                    this.mResult = adnRecord;
                    if (adnRecord.hasExtendedRecord()) {
                        this.mPendingExtLoads = 1;
                        this.mFh.loadEFLinearFixed(this.mExtensionEF, adnRecord.mExtRecord, obtainMessage(2, adnRecord));
                    }
                } else {
                    throw new RuntimeException("load failed", asyncResult.exception);
                }
            } else if (i != 2) {
                int i2 = 0;
                if (i == 3) {
                    AsyncResult asyncResult2 = (AsyncResult) message2.obj;
                    ArrayList arrayList = (ArrayList) asyncResult2.result;
                    if (asyncResult2.exception == null) {
                        ArrayList<AdnRecord> arrayList2 = new ArrayList<>(arrayList.size());
                        this.mAdns = arrayList2;
                        this.mResult = arrayList2;
                        this.mPendingExtLoads = 0;
                        int size = arrayList.size();
                        while (i2 < size) {
                            int i3 = i2 + 1;
                            AdnRecord adnRecord2 = new AdnRecord(this.mEf, i3, (byte[]) arrayList.get(i2));
                            this.mAdns.add(adnRecord2);
                            if (adnRecord2.hasExtendedRecord()) {
                                this.mPendingExtLoads++;
                                this.mFh.loadEFLinearFixed(this.mExtensionEF, adnRecord2.mExtRecord, obtainMessage(2, adnRecord2));
                            }
                            i2 = i3;
                        }
                    } else {
                        throw new RuntimeException("load failed", asyncResult2.exception);
                    }
                } else if (i == 4) {
                    AsyncResult asyncResult3 = (AsyncResult) message2.obj;
                    AdnRecord adnRecord3 = (AdnRecord) asyncResult3.userObj;
                    if (asyncResult3.exception == null) {
                        int[] iArr = (int[]) asyncResult3.result;
                        if (iArr.length != 3 || this.mRecordNumber > iArr[2]) {
                            throw new RuntimeException("get wrong EF record size format", asyncResult3.exception);
                        }
                        byte[] buildAdnString = adnRecord3.buildAdnString(iArr[0]);
                        if (buildAdnString != null) {
                            IccFileHandler iccFileHandler = this.mFh;
                            int i4 = this.mEf;
                            iccFileHandler.updateEFLinearFixed(i4, getEFPath(i4), this.mRecordNumber, buildAdnString, this.mPin2, obtainMessage(5));
                            this.mPendingExtLoads = 1;
                        } else {
                            throw new RuntimeException("wrong ADN format", asyncResult3.exception);
                        }
                    } else {
                        throw new RuntimeException("get EF record size failed", asyncResult3.exception);
                    }
                } else if (i == 5) {
                    AsyncResult asyncResult4 = (AsyncResult) message2.obj;
                    if (asyncResult4.exception == null) {
                        this.mPendingExtLoads = 0;
                        this.mResult = null;
                    } else {
                        throw new RuntimeException("update EF adn record failed", asyncResult4.exception);
                    }
                }
            } else {
                AsyncResult asyncResult5 = (AsyncResult) message2.obj;
                byte[] bArr2 = (byte[]) asyncResult5.result;
                AdnRecord adnRecord4 = (AdnRecord) asyncResult5.userObj;
                if (asyncResult5.exception == null) {
                    Rlog.d(LOG_TAG, "ADN extension EF: 0x" + Integer.toHexString(this.mExtensionEF) + ":" + adnRecord4.mExtRecord + "\n" + IccUtils.bytesToHexString(bArr2));
                    adnRecord4.appendExtRecord(bArr2);
                } else {
                    Rlog.e(LOG_TAG, "Failed to read ext record. Clear the number now.");
                    adnRecord4.setNumber("");
                }
                this.mPendingExtLoads--;
            }
            Message message3 = this.mUserResponse;
            if (message3 != null && this.mPendingExtLoads == 0) {
                AsyncResult.forMessage(message3).result = this.mResult;
                this.mUserResponse.sendToTarget();
                this.mUserResponse = null;
            }
        } catch (RuntimeException e) {
            Message message4 = this.mUserResponse;
            if (message4 != null) {
                AsyncResult.forMessage(message4).exception = e;
                this.mUserResponse.sendToTarget();
                this.mUserResponse = null;
            }
        }
    }
}
