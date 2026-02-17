package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncResult;
import android.os.Message;
import android.telephony.SubscriptionManager;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.gsm.SimTlv;
import com.android.internal.telephony.uicc.IccRecords;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Iterator;

public class IsimUiccRecords extends IccRecords implements IsimRecords {
    private static final boolean DBG = true;
    protected static final boolean DUMP_RECORDS = false;
    public static final String INTENT_ISIM_REFRESH = "com.android.intent.isim_refresh";
    protected static final String LOG_TAG = "IsimUiccRecords";
    private static final int TAG_ISIM_VALUE = 128;
    private static final boolean VDBG = false;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private String auth_rsp;
    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String mIsimDomain;
    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String mIsimImpi;
    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String[] mIsimImpu;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected String mIsimIst;
    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public String[] mIsimPcscf;

    public int getVoiceMessageCount() {
        return 0;
    }

    public void setVoiceMailNumber(String str, String str2, Message message) {
    }

    public void setVoiceMessageWaiting(int i, int i2) {
    }

    public String toString() {
        return "IsimUiccRecords: " + super.toString() + "";
    }

    public IsimUiccRecords(UiccCardApplication uiccCardApplication, Context context, CommandsInterface commandsInterface) {
        super(uiccCardApplication, context, commandsInterface);
        this.mRecordsRequested = false;
        this.mLockedRecordsReqReason = 0;
        this.mRecordsToLoad = 0;
        resetRecords();
        log("IsimUiccRecords X ctor this=" + this);
    }

    public void dispose() {
        log("Disposing " + this);
        resetRecords();
        super.dispose();
    }

    public void handleMessage(Message message) {
        if (this.mDestroyed.get()) {
            Rlog.e(LOG_TAG, "Received message " + message + "[" + message.what + "] while being destroyed. Ignoring.");
            return;
        }
        loge("IsimUiccRecords: handleMessage " + message + "[" + message.what + "] ");
        try {
            if (message.what != 31) {
                super.handleMessage(message);
                return;
            }
            broadcastRefresh();
            super.handleMessage(message);
        } catch (RuntimeException e) {
            Rlog.w(LOG_TAG, "Exception parsing SIM record", e);
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void fetchIsimRecords() {
        this.mRecordsRequested = true;
        this.mFh.loadEFTransparent(IccConstants.EF_IMPI, obtainMessage(100, new EfIsimImpiLoaded()));
        this.mRecordsToLoad++;
        this.mFh.loadEFLinearFixedAll(IccConstants.EF_IMPU, obtainMessage(100, new EfIsimImpuLoaded()));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_DOMAIN, obtainMessage(100, new EfIsimDomainLoaded()));
        this.mRecordsToLoad++;
        this.mFh.loadEFTransparent(IccConstants.EF_IST, obtainMessage(100, new EfIsimIstLoaded()));
        this.mRecordsToLoad++;
        this.mFh.loadEFLinearFixedAll(IccConstants.EF_PCSCF, obtainMessage(100, new EfIsimPcscfLoaded()));
        this.mRecordsToLoad++;
        log("fetchIsimRecords " + this.mRecordsToLoad + " requested: " + this.mRecordsRequested);
    }

    /* access modifiers changed from: protected */
    public void resetRecords() {
        this.mIsimImpi = null;
        this.mIsimDomain = null;
        this.mIsimImpu = null;
        this.mIsimIst = null;
        this.mIsimPcscf = null;
        this.auth_rsp = null;
        this.mRecordsRequested = false;
        this.mLockedRecordsReqReason = 0;
        this.mLoaded.set(false);
    }

    public class EfIsimImpiLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_ISIM_IMPI";
        }

        public EfIsimImpiLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            IsimUiccRecords.this.mIsimImpi = IsimUiccRecords.isimTlvToString((byte[]) asyncResult.result);
        }
    }

    public class EfIsimImpuLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_ISIM_IMPU";
        }

        public EfIsimImpuLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            ArrayList arrayList = (ArrayList) asyncResult.result;
            IsimUiccRecords isimUiccRecords = IsimUiccRecords.this;
            isimUiccRecords.log("EF_IMPU record count: " + arrayList.size());
            IsimUiccRecords.this.mIsimImpu = new String[arrayList.size()];
            Iterator it = arrayList.iterator();
            int i = 0;
            while (it.hasNext()) {
                IsimUiccRecords.this.mIsimImpu[i] = IsimUiccRecords.isimTlvToString((byte[]) it.next());
                i++;
            }
        }
    }

    public class EfIsimDomainLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_ISIM_DOMAIN";
        }

        public EfIsimDomainLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            IsimUiccRecords.this.mIsimDomain = IsimUiccRecords.isimTlvToString((byte[]) asyncResult.result);
        }
    }

    public class EfIsimIstLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_ISIM_IST";
        }

        public EfIsimIstLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            IsimUiccRecords.this.mIsimIst = IccUtils.bytesToHexString((byte[]) asyncResult.result);
        }
    }

    public class EfIsimPcscfLoaded implements IccRecords.IccRecordLoaded {
        public String getEfName() {
            return "EF_ISIM_PCSCF";
        }

        public EfIsimPcscfLoaded() {
        }

        public void onRecordLoaded(AsyncResult asyncResult) {
            ArrayList arrayList = (ArrayList) asyncResult.result;
            IsimUiccRecords isimUiccRecords = IsimUiccRecords.this;
            isimUiccRecords.log("EF_PCSCF record count: " + arrayList.size());
            IsimUiccRecords.this.mIsimPcscf = new String[arrayList.size()];
            Iterator it = arrayList.iterator();
            int i = 0;
            while (it.hasNext()) {
                IsimUiccRecords.this.mIsimPcscf[i] = IsimUiccRecords.isimTlvToString((byte[]) it.next());
                i++;
            }
        }
    }

    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static String isimTlvToString(byte[] bArr) {
        SimTlv simTlv = new SimTlv(bArr, 0, bArr.length);
        while (simTlv.getTag() != 128) {
            if (!simTlv.nextObject()) {
                return null;
            }
        }
        return new String(simTlv.getData(), Charset.forName("UTF-8"));
    }

    /* access modifiers changed from: protected */
    public void onRecordLoaded() {
        this.mRecordsToLoad--;
        log("onRecordLoaded " + this.mRecordsToLoad + " requested: " + this.mRecordsRequested);
        if (getRecordsLoaded()) {
            onAllRecordsLoaded();
        } else if (getLockedRecordsLoaded() || getNetworkLockedRecordsLoaded()) {
            onLockedAllRecordsLoaded();
        } else if (this.mRecordsToLoad < 0) {
            loge("recordsToLoad <0, programmer error suspected");
            this.mRecordsToLoad = 0;
        }
    }

    private void onLockedAllRecordsLoaded() {
        log("SIM locked; record load complete");
        int i = this.mLockedRecordsReqReason;
        if (i == 1) {
            this.mLockedRecordsLoadedRegistrants.notifyRegistrants(new AsyncResult((Object) null, (Object) null, (Throwable) null));
        } else if (i == 2) {
            this.mNetworkLockedRecordsLoadedRegistrants.notifyRegistrants(new AsyncResult((Object) null, (Object) null, (Throwable) null));
        } else {
            loge("onLockedAllRecordsLoaded: unexpected mLockedRecordsReqReason " + this.mLockedRecordsReqReason);
        }
    }

    /* access modifiers changed from: protected */
    public void onAllRecordsLoaded() {
        log("record load complete");
        this.mLoaded.set(true);
        this.mRecordsLoadedRegistrants.notifyRegistrants(new AsyncResult((Object) null, (Object) null, (Throwable) null));
    }

    /* access modifiers changed from: protected */
    public void handleFileUpdate(int i) {
        if (i != 28423) {
            if (i != 28425) {
                switch (i) {
                    case IccConstants.EF_IMPI:
                        this.mFh.loadEFTransparent(IccConstants.EF_IMPI, obtainMessage(100, new EfIsimImpiLoaded()));
                        this.mRecordsToLoad++;
                        return;
                    case IccConstants.EF_DOMAIN:
                        this.mFh.loadEFTransparent(IccConstants.EF_DOMAIN, obtainMessage(100, new EfIsimDomainLoaded()));
                        this.mRecordsToLoad++;
                        return;
                    case IccConstants.EF_IMPU:
                        this.mFh.loadEFLinearFixedAll(IccConstants.EF_IMPU, obtainMessage(100, new EfIsimImpuLoaded()));
                        this.mRecordsToLoad++;
                        return;
                }
            } else {
                this.mFh.loadEFLinearFixedAll(IccConstants.EF_PCSCF, obtainMessage(100, new EfIsimPcscfLoaded()));
                this.mRecordsToLoad++;
            }
            this.mLoaded.set(false);
            fetchIsimRecords();
            return;
        }
        this.mFh.loadEFTransparent(IccConstants.EF_IST, obtainMessage(100, new EfIsimIstLoaded()));
        this.mRecordsToLoad++;
    }

    private void broadcastRefresh() {
        Intent intent = new Intent(INTENT_ISIM_REFRESH);
        log("send ISim REFRESH: com.android.intent.isim_refresh");
        SubscriptionManager.putPhoneIdAndSubIdExtra(intent, this.mParentApp.getPhoneId());
        this.mContext.sendBroadcast(intent);
    }

    public String getIsimImpi() {
        return this.mIsimImpi;
    }

    public String getIsimDomain() {
        return this.mIsimDomain;
    }

    public String[] getIsimImpu() {
        String[] strArr = this.mIsimImpu;
        if (strArr != null) {
            return (String[]) strArr.clone();
        }
        return null;
    }

    public String getIsimIst() {
        return this.mIsimIst;
    }

    public String[] getIsimPcscf() {
        String[] strArr = this.mIsimPcscf;
        if (strArr != null) {
            return (String[]) strArr.clone();
        }
        return null;
    }

    public void onReady() {
        fetchIsimRecords();
    }

    public void onRefresh(boolean z, int[] iArr) {
        if (z) {
            fetchIsimRecords();
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void log(String str) {
        if (this.mParentApp != null) {
            Rlog.d(LOG_TAG, "[ISIM-" + this.mParentApp.getPhoneId() + "] " + str);
            return;
        }
        Rlog.d(LOG_TAG, "[ISIM] " + str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str) {
        if (this.mParentApp != null) {
            Rlog.e(LOG_TAG, "[ISIM-" + this.mParentApp.getPhoneId() + "] " + str);
            return;
        }
        Rlog.e(LOG_TAG, "[ISIM] " + str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("IsimRecords: " + this);
        printWriter.println(" extends:");
        super.dump(fileDescriptor, printWriter, strArr);
        printWriter.flush();
    }
}
