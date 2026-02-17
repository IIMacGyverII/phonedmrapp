package com.android.internal.telephony.dataconnection;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Handler;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import java.util.Iterator;

public class DcTesterDeactivateAll {
    private static final boolean DBG = true;
    private static final String LOG_TAG = "DcTesterDeacativateAll";
    public static String sActionDcTesterDeactivateAll = "com.android.internal.telephony.dataconnection.action_deactivate_all";
    /* access modifiers changed from: private */
    public DcController mDcc;
    /* access modifiers changed from: private */
    public Phone mPhone;
    protected BroadcastReceiver sIntentReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            DcTesterDeactivateAll.log("sIntentReceiver.onReceive: action=" + action);
            if (action.equals(DcTesterDeactivateAll.sActionDcTesterDeactivateAll) || action.equals(DcTesterDeactivateAll.this.mPhone.getActionDetached())) {
                DcTesterDeactivateAll.log("Send DEACTIVATE to all Dcc's");
                if (DcTesterDeactivateAll.this.mDcc != null) {
                    Iterator<DataConnection> it = DcTesterDeactivateAll.this.mDcc.mDcListAll.iterator();
                    while (it.hasNext()) {
                        it.next().tearDownNow();
                    }
                    return;
                }
                DcTesterDeactivateAll.log("onReceive: mDcc is null, ignoring");
                return;
            }
            DcTesterDeactivateAll.log("onReceive: unknown action=" + action);
        }
    };

    DcTesterDeactivateAll(Phone phone, DcController dcController, Handler handler) {
        this.mPhone = phone;
        this.mDcc = dcController;
        if (TelephonyUtils.IS_DEBUGGABLE) {
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction(sActionDcTesterDeactivateAll);
            log("register for intent action=" + sActionDcTesterDeactivateAll);
            intentFilter.addAction(this.mPhone.getActionDetached());
            log("register for intent action=" + this.mPhone.getActionDetached());
            phone.getContext().registerReceiver(this.sIntentReceiver, intentFilter, (String) null, handler, 2);
        }
    }

    /* access modifiers changed from: package-private */
    public void dispose() {
        if (TelephonyUtils.IS_DEBUGGABLE) {
            this.mPhone.getContext().unregisterReceiver(this.sIntentReceiver);
        }
    }

    /* access modifiers changed from: private */
    public static void log(String str) {
        Rlog.d(LOG_TAG, str);
    }
}
