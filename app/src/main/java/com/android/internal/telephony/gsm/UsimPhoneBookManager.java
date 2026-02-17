package com.android.internal.telephony.gsm;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.util.SparseArray;
import android.util.SparseIntArray;
import com.android.internal.telephony.uicc.AdnRecord;
import com.android.internal.telephony.uicc.AdnRecordCache;
import com.android.internal.telephony.uicc.IccConstants;
import com.android.internal.telephony.uicc.IccFileHandler;
import com.android.internal.telephony.uicc.IccUtils;
import com.android.telephony.Rlog;
import java.util.ArrayList;
import java.util.Iterator;

public class UsimPhoneBookManager extends Handler implements IccConstants {
    private static final boolean DBG = true;
    protected static final int EVENT_EMAIL_LOAD_DONE = 4;
    protected static final int EVENT_IAP_LOAD_DONE = 3;
    protected static final int EVENT_PBR_LOAD_DONE = 1;
    protected static final int EVENT_USIM_ADN_LOAD_DONE = 2;
    protected static final byte INVALID_BYTE = -1;
    protected static final int INVALID_SFI = -1;
    private static final String LOG_TAG = "UsimPhoneBookManager";
    protected static final int USIM_EFAAS_TAG = 199;
    protected static final int USIM_EFADN_TAG = 192;
    protected static final int USIM_EFANR_TAG = 196;
    protected static final int USIM_EFCCP1_TAG = 203;
    protected static final int USIM_EFEMAIL_TAG = 202;
    protected static final int USIM_EFEXT1_TAG = 194;
    protected static final int USIM_EFGRP_TAG = 198;
    protected static final int USIM_EFGSD_TAG = 200;
    protected static final int USIM_EFIAP_TAG = 193;
    protected static final int USIM_EFPBC_TAG = 197;
    protected static final int USIM_EFSNE_TAG = 195;
    protected static final int USIM_EFUID_TAG = 201;
    protected static final int USIM_TYPE1_TAG = 168;
    protected static final int USIM_TYPE2_TAG = 169;
    protected static final int USIM_TYPE3_TAG = 170;
    protected AdnRecordCache mAdnCache;
    protected ArrayList<byte[]> mEmailFileRecord;
    protected SparseArray<ArrayList<String>> mEmailsForAdnRec;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected IccFileHandler mFh;
    protected ArrayList<byte[]> mIapFileRecord;
    protected Boolean mIsPbrPresent;
    @UnsupportedAppUsage
    protected Object mLock = new Object();
    protected ArrayList<PbrRecord> mPbrRecords;
    @UnsupportedAppUsage
    protected ArrayList<AdnRecord> mPhoneBookRecords;
    protected boolean mRefreshCache = false;
    protected SparseIntArray mSfiEfidTable;

    private class File {
        private final int mEfid;
        private final int mIndex;
        private final int mParentTag;
        private final int mSfi;

        File(int i, int i2, int i3, int i4) {
            this.mParentTag = i;
            this.mEfid = i2;
            this.mSfi = i3;
            this.mIndex = i4;
        }

        public int getParentTag() {
            return this.mParentTag;
        }

        public int getEfid() {
            return this.mEfid;
        }

        public int getSfi() {
            return this.mSfi;
        }

        public int getIndex() {
            return this.mIndex;
        }
    }

    public UsimPhoneBookManager(IccFileHandler iccFileHandler, AdnRecordCache adnRecordCache) {
        this.mFh = iccFileHandler;
        this.mPhoneBookRecords = new ArrayList<>();
        this.mPbrRecords = null;
        this.mIsPbrPresent = Boolean.TRUE;
        this.mAdnCache = adnRecordCache;
        this.mEmailsForAdnRec = new SparseArray<>();
        this.mSfiEfidTable = new SparseIntArray();
    }

    @UnsupportedAppUsage
    public void reset() {
        this.mPhoneBookRecords.clear();
        this.mIapFileRecord = null;
        this.mEmailFileRecord = null;
        this.mPbrRecords = null;
        this.mIsPbrPresent = Boolean.TRUE;
        this.mRefreshCache = false;
        this.mEmailsForAdnRec.clear();
        this.mSfiEfidTable.clear();
    }

    @UnsupportedAppUsage
    public ArrayList<AdnRecord> loadEfFilesFromUsim() {
        synchronized (this.mLock) {
            if (!this.mPhoneBookRecords.isEmpty()) {
                if (this.mRefreshCache) {
                    this.mRefreshCache = false;
                    refreshCache();
                }
                ArrayList<AdnRecord> arrayList = this.mPhoneBookRecords;
                return arrayList;
            } else if (!this.mIsPbrPresent.booleanValue()) {
                return null;
            } else {
                if (this.mPbrRecords == null) {
                    readPbrFileAndWait();
                }
                ArrayList<PbrRecord> arrayList2 = this.mPbrRecords;
                if (arrayList2 == null) {
                    return null;
                }
                int size = arrayList2.size();
                log("loadEfFilesFromUsim: Loading adn and emails");
                for (int i = 0; i < size; i++) {
                    readAdnFileAndWait(i);
                    readEmailFileAndWait(i);
                }
                updatePhoneAdnRecord();
                return this.mPhoneBookRecords;
            }
        }
    }

    /* access modifiers changed from: protected */
    public void refreshCache() {
        if (this.mPbrRecords != null) {
            this.mPhoneBookRecords.clear();
            int size = this.mPbrRecords.size();
            for (int i = 0; i < size; i++) {
                readAdnFileAndWait(i);
            }
        }
    }

    public void invalidateCache() {
        this.mRefreshCache = true;
    }

    /* access modifiers changed from: protected */
    public void readPbrFileAndWait() {
        this.mFh.loadEFLinearFixedAll(IccConstants.EF_PBR, obtainMessage(1));
        try {
            this.mLock.wait();
        } catch (InterruptedException unused) {
            Rlog.e(LOG_TAG, "Interrupted Exception in readAdnFileAndWait");
        }
    }

    private void readEmailFileAndWait(int i) {
        File file;
        SparseArray r6;
        File file2;
        SparseArray r0 = this.mPbrRecords.get(i).mFileIds;
        if (r0 != null && (file = (File) r0.get(USIM_EFEMAIL_TAG)) != null) {
            if (file.getParentTag() == USIM_TYPE2_TAG) {
                if (r0.get(USIM_EFIAP_TAG) == null) {
                    Rlog.e(LOG_TAG, "Can't locate EF_IAP in EF_PBR.");
                    return;
                }
                log("EF_IAP exists. Loading EF_IAP to retrieve the index.");
                readIapFileAndWait(((File) r0.get(USIM_EFIAP_TAG)).getEfid());
                if (this.mIapFileRecord == null) {
                    Rlog.e(LOG_TAG, "Error: IAP file is empty");
                    return;
                }
                log("EF_EMAIL order in PBR record: " + file.getIndex());
            }
            int efid = file.getEfid();
            log("EF_EMAIL exists in PBR. efid = 0x" + Integer.toHexString(efid).toUpperCase());
            int i2 = 0;
            while (i2 < i) {
                if (this.mPbrRecords.get(i2) == null || (r6 = this.mPbrRecords.get(i2).mFileIds) == null || (file2 = (File) r6.get(USIM_EFEMAIL_TAG)) == null || file2.getEfid() != efid) {
                    i2++;
                } else {
                    log("Skipped this EF_EMAIL which was loaded earlier");
                    return;
                }
            }
            this.mFh.loadEFLinearFixedAll(efid, obtainMessage(4));
            try {
                this.mLock.wait();
            } catch (InterruptedException unused) {
                Rlog.e(LOG_TAG, "Interrupted Exception in readEmailFileAndWait");
            }
            if (this.mEmailFileRecord == null) {
                Rlog.e(LOG_TAG, "Error: Email file is empty");
            } else if (file.getParentTag() != USIM_TYPE2_TAG || this.mIapFileRecord == null) {
                buildType1EmailList(i);
            } else {
                buildType2EmailList(i);
            }
        }
    }

    private void buildType1EmailList(int i) {
        int i2;
        if (this.mPbrRecords.get(i) != null) {
            int r0 = this.mPbrRecords.get(i).mMainFileRecordNum;
            log("Building type 1 email list. recId = " + i + ", numRecs = " + r0);
            int i3 = 0;
            while (i3 < r0) {
                try {
                    byte[] bArr = this.mEmailFileRecord.get(i3);
                    byte b = bArr[bArr.length - 2];
                    byte b2 = bArr[bArr.length - 1];
                    String readEmailRecord = readEmailRecord(i3);
                    if (readEmailRecord != null && !readEmailRecord.equals("")) {
                        if (b == -1 || this.mSfiEfidTable.get(b) == 0) {
                            File file = (File) this.mPbrRecords.get(i).mFileIds.get(192);
                            if (file != null) {
                                i2 = file.getEfid();
                            }
                        } else {
                            i2 = this.mSfiEfidTable.get(b);
                        }
                        int i4 = ((b2 - 1) & 255) | ((i2 & 65535) << 8);
                        ArrayList arrayList = this.mEmailsForAdnRec.get(i4);
                        if (arrayList == null) {
                            arrayList = new ArrayList();
                        }
                        log("Adding email #" + i3 + " list to index 0x" + Integer.toHexString(i4).toUpperCase());
                        arrayList.add(readEmailRecord);
                        this.mEmailsForAdnRec.put(i4, arrayList);
                    }
                    i3++;
                } catch (IndexOutOfBoundsException unused) {
                    Rlog.e(LOG_TAG, "Error: Improper ICC card: No email record for ADN, continuing");
                    return;
                }
            }
        }
    }

    private boolean buildType2EmailList(int i) {
        if (this.mPbrRecords.get(i) == null) {
            return false;
        }
        int r0 = this.mPbrRecords.get(i).mMainFileRecordNum;
        log("Building type 2 email list. recId = " + i + ", numRecs = " + r0);
        File file = (File) this.mPbrRecords.get(i).mFileIds.get(192);
        if (file == null) {
            Rlog.e(LOG_TAG, "Error: Improper ICC card: EF_ADN does not exist in PBR files");
            return false;
        }
        int efid = file.getEfid();
        for (int i2 = 0; i2 < r0; i2++) {
            try {
                String readEmailRecord = readEmailRecord(this.mIapFileRecord.get(i2)[((File) this.mPbrRecords.get(i).mFileIds.get(USIM_EFEMAIL_TAG)).getIndex()] - 1);
                if (readEmailRecord != null && !readEmailRecord.equals("")) {
                    int i3 = ((65535 & efid) << 8) | (i2 & 255);
                    ArrayList arrayList = this.mEmailsForAdnRec.get(i3);
                    if (arrayList == null) {
                        arrayList = new ArrayList();
                    }
                    arrayList.add(readEmailRecord);
                    log("Adding email list to index 0x" + Integer.toHexString(i3).toUpperCase());
                    this.mEmailsForAdnRec.put(i3, arrayList);
                }
            } catch (IndexOutOfBoundsException unused) {
                Rlog.e(LOG_TAG, "Error: Improper ICC card: Corrupted EF_IAP");
            }
        }
        return true;
    }

    private void readIapFileAndWait(int i) {
        this.mFh.loadEFLinearFixedAll(i, obtainMessage(3));
        try {
            this.mLock.wait();
        } catch (InterruptedException unused) {
            Rlog.e(LOG_TAG, "Interrupted Exception in readIapFileAndWait");
        }
    }

    private void updatePhoneAdnRecord() {
        int size = this.mPhoneBookRecords.size();
        for (int i = 0; i < size; i++) {
            AdnRecord adnRecord = this.mPhoneBookRecords.get(i);
            try {
                ArrayList arrayList = this.mEmailsForAdnRec.get(((adnRecord.getEfid() & 65535) << 8) | ((adnRecord.getRecId() - 1) & 255));
                if (arrayList != null) {
                    String[] strArr = new String[arrayList.size()];
                    System.arraycopy(arrayList.toArray(), 0, strArr, 0, arrayList.size());
                    adnRecord.setEmails(strArr);
                    log("Adding email list to ADN (0x" + Integer.toHexString(this.mPhoneBookRecords.get(i).getEfid()).toUpperCase() + ") record #" + this.mPhoneBookRecords.get(i).getRecId());
                    this.mPhoneBookRecords.set(i, adnRecord);
                }
            } catch (IndexOutOfBoundsException unused) {
            }
        }
    }

    private String readEmailRecord(int i) {
        try {
            byte[] bArr = this.mEmailFileRecord.get(i);
            return IccUtils.adnStringFieldToString(bArr, 0, bArr.length - 2);
        } catch (IndexOutOfBoundsException unused) {
            return null;
        }
    }

    private void readAdnFileAndWait(int i) {
        SparseArray r0 = this.mPbrRecords.get(i).mFileIds;
        if (r0 != null && r0.size() != 0) {
            int i2 = 0;
            if (r0.get(USIM_EFEXT1_TAG) != null) {
                i2 = ((File) r0.get(USIM_EFEXT1_TAG)).getEfid();
            }
            if (r0.get(192) != null) {
                int size = this.mPhoneBookRecords.size();
                this.mAdnCache.requestLoadAllAdnLike(((File) r0.get(192)).getEfid(), i2, obtainMessage(2));
                try {
                    this.mLock.wait();
                } catch (InterruptedException unused) {
                    Rlog.e(LOG_TAG, "Interrupted Exception in readAdnFileAndWait");
                }
                this.mPbrRecords.get(i).mMainFileRecordNum = this.mPhoneBookRecords.size() - size;
            }
        }
    }

    private void createPbrFile(ArrayList<byte[]> arrayList) {
        int sfi;
        if (arrayList == null) {
            this.mPbrRecords = null;
            this.mIsPbrPresent = Boolean.FALSE;
            return;
        }
        this.mPbrRecords = new ArrayList<>();
        for (int i = 0; i < arrayList.size(); i++) {
            if (arrayList.get(i)[0] != -1) {
                this.mPbrRecords.add(new PbrRecord(arrayList.get(i)));
            }
        }
        Iterator<PbrRecord> it = this.mPbrRecords.iterator();
        while (it.hasNext()) {
            PbrRecord next = it.next();
            File file = (File) next.mFileIds.get(192);
            if (!(file == null || (sfi = file.getSfi()) == -1)) {
                this.mSfiEfidTable.put(sfi, ((File) next.mFileIds.get(192)).getEfid());
            }
        }
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 1) {
            log("Loading PBR records done");
            AsyncResult asyncResult = (AsyncResult) message.obj;
            if (asyncResult.exception == null) {
                createPbrFile((ArrayList) asyncResult.result);
            }
            synchronized (this.mLock) {
                this.mLock.notify();
            }
        } else if (i == 2) {
            log("Loading USIM ADN records done");
            AsyncResult asyncResult2 = (AsyncResult) message.obj;
            if (asyncResult2.exception == null) {
                this.mPhoneBookRecords.addAll((ArrayList) asyncResult2.result);
            }
            synchronized (this.mLock) {
                this.mLock.notify();
            }
        } else if (i == 3) {
            log("Loading USIM IAP records done");
            AsyncResult asyncResult3 = (AsyncResult) message.obj;
            if (asyncResult3.exception == null) {
                this.mIapFileRecord = (ArrayList) asyncResult3.result;
            }
            synchronized (this.mLock) {
                this.mLock.notify();
            }
        } else if (i == 4) {
            log("Loading USIM Email records done");
            AsyncResult asyncResult4 = (AsyncResult) message.obj;
            if (asyncResult4.exception == null) {
                this.mEmailFileRecord = (ArrayList) asyncResult4.result;
            }
            synchronized (this.mLock) {
                this.mLock.notify();
            }
        }
    }

    private class PbrRecord {
        /* access modifiers changed from: private */
        public SparseArray<File> mFileIds = new SparseArray<>();
        /* access modifiers changed from: private */
        public int mMainFileRecordNum;

        PbrRecord(byte[] bArr) {
            UsimPhoneBookManager.this.log("PBR rec: " + IccUtils.bytesToHexString(bArr));
            parseTag(new SimTlv(bArr, 0, bArr.length));
        }

        /* access modifiers changed from: package-private */
        public void parseTag(SimTlv simTlv) {
            do {
                int tag = simTlv.getTag();
                switch (tag) {
                    case UsimPhoneBookManager.USIM_TYPE1_TAG /*168*/:
                    case UsimPhoneBookManager.USIM_TYPE2_TAG /*169*/:
                    case UsimPhoneBookManager.USIM_TYPE3_TAG /*170*/:
                        byte[] data = simTlv.getData();
                        parseEfAndSFI(new SimTlv(data, 0, data.length), tag);
                        break;
                }
            } while (simTlv.nextObject());
        }

        /* access modifiers changed from: package-private */
        public void parseEfAndSFI(SimTlv simTlv, int i) {
            int i2 = 0;
            do {
                int tag = simTlv.getTag();
                switch (tag) {
                    case 192:
                    case UsimPhoneBookManager.USIM_EFIAP_TAG /*193*/:
                    case UsimPhoneBookManager.USIM_EFEXT1_TAG /*194*/:
                    case UsimPhoneBookManager.USIM_EFSNE_TAG /*195*/:
                    case UsimPhoneBookManager.USIM_EFANR_TAG /*196*/:
                    case UsimPhoneBookManager.USIM_EFPBC_TAG /*197*/:
                    case UsimPhoneBookManager.USIM_EFGRP_TAG /*198*/:
                    case UsimPhoneBookManager.USIM_EFAAS_TAG /*199*/:
                    case 200:
                    case UsimPhoneBookManager.USIM_EFUID_TAG /*201*/:
                    case UsimPhoneBookManager.USIM_EFEMAIL_TAG /*202*/:
                    case UsimPhoneBookManager.USIM_EFCCP1_TAG /*203*/:
                        byte b = -1;
                        byte[] data = simTlv.getData();
                        if (data.length >= 2 && data.length <= 3) {
                            if (data.length == 3) {
                                b = data[2] & 255;
                            }
                            this.mFileIds.put(tag, new File(i, ((data[0] & 255) << 8) | (data[1] & 255), b, i2));
                            break;
                        } else {
                            UsimPhoneBookManager.this.log("Invalid TLV length: " + data.length);
                            break;
                        }
                        break;
                }
                i2++;
            } while (simTlv.nextObject());
        }
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage
    public void log(String str) {
        Rlog.d(LOG_TAG, str);
    }
}
