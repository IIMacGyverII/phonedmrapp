package com.android.internal.telephony.uicc.euicc;

import android.content.Context;
import android.os.AsyncResult;
import android.os.Handler;
import android.text.TextUtils;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.Registrant;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.uicc.IccCardStatus;
import com.android.internal.telephony.uicc.UiccCard;
import com.android.internal.telephony.uicc.UiccPort;
import com.android.internal.telephony.uicc.euicc.async.AsyncResultCallback;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;

public class EuiccCard extends UiccCard {
    private static final boolean DBG = true;
    private static final String LOG_TAG = "EuiccCard";
    /* access modifiers changed from: private */
    public volatile String mEid;
    /* access modifiers changed from: private */
    public RegistrantList mEidReadyRegistrants;

    public EuiccCard(Context context, CommandsInterface commandsInterface, IccCardStatus iccCardStatus, int i, Object obj, boolean z) {
        super(context, commandsInterface, iccCardStatus, i, obj, z);
        if (TextUtils.isEmpty(iccCardStatus.eid)) {
            loge("no eid given in constructor for phone " + i);
            loadEidAndNotifyRegistrants();
            return;
        }
        this.mEid = iccCardStatus.eid;
        this.mCardId = iccCardStatus.eid;
    }

    public void updateSupportMultipleEnabledProfile(boolean z) {
        this.mIsSupportsMultipleEnabledProfiles = z;
        for (UiccPort next : this.mUiccPorts.values()) {
            if (next instanceof EuiccPort) {
                ((EuiccPort) next).updateSupportMultipleEnabledProfile(z);
            } else {
                loge("eUICC card has non-euicc port object:" + next.toString());
            }
        }
    }

    public void update(Context context, CommandsInterface commandsInterface, IccCardStatus iccCardStatus, int i) {
        synchronized (this.mLock) {
            if (!TextUtils.isEmpty(iccCardStatus.eid)) {
                this.mEid = iccCardStatus.eid;
            }
            super.update(context, commandsInterface, iccCardStatus, i);
        }
    }

    /* access modifiers changed from: protected */
    public void updateCardId(String str) {
        if (TextUtils.isEmpty(this.mEid)) {
            super.updateCardId(str);
        } else {
            this.mCardId = this.mEid;
        }
    }

    public void registerForEidReady(Handler handler, int i, Object obj) {
        Registrant registrant = new Registrant(handler, i, obj);
        if (this.mEid != null) {
            registrant.notifyRegistrant(new AsyncResult((Object) null, (Object) null, (Throwable) null));
            return;
        }
        if (this.mEidReadyRegistrants == null) {
            this.mEidReadyRegistrants = new RegistrantList();
        }
        this.mEidReadyRegistrants.add(registrant);
    }

    public void unregisterForEidReady(Handler handler) {
        RegistrantList registrantList = this.mEidReadyRegistrants;
        if (registrantList != null) {
            registrantList.remove(handler);
        }
    }

    /* access modifiers changed from: protected */
    @VisibleForTesting(visibility = VisibleForTesting.Visibility.PRIVATE)
    public void loadEidAndNotifyRegistrants() {
        Handler handler = new Handler();
        ((EuiccPort) this.mUiccPorts.get(0)).getEid(new AsyncResultCallback<String>() {
            public void onResult(String str) {
                EuiccCard.this.mEid = str;
                String unused = EuiccCard.this.mCardId = str;
                if (TextUtils.isEmpty(str)) {
                    EuiccCard.logd("eid is loaded but empty ");
                }
                if (EuiccCard.this.mEidReadyRegistrants != null) {
                    EuiccCard.this.mEidReadyRegistrants.notifyRegistrants(new AsyncResult((Object) null, (Object) null, (Throwable) null));
                }
            }

            public void onException(Throwable th) {
                if (EuiccCard.this.mEidReadyRegistrants != null) {
                    EuiccCard.this.mEidReadyRegistrants.notifyRegistrants(new AsyncResult((Object) null, (Object) null, (Throwable) null));
                }
                EuiccCard.this.mEid = "";
                String unused = EuiccCard.this.mCardId = "";
                Rlog.e(EuiccCard.LOG_TAG, "Failed loading eid", th);
            }
        }, handler);
    }

    public String getEid() {
        return this.mEid;
    }

    private static void loge(String str) {
        Rlog.e(LOG_TAG, str);
    }

    private static void loge(String str, Throwable th) {
        Rlog.e(LOG_TAG, str, th);
    }

    private static void logi(String str) {
        Rlog.i(LOG_TAG, str);
    }

    /* access modifiers changed from: private */
    public static void logd(String str) {
        Rlog.d(LOG_TAG, str);
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        super.dump(fileDescriptor, printWriter, strArr);
        printWriter.println("EuiccCard:");
        printWriter.println(" mEid=" + this.mEid);
    }
}
