package com.android.internal.telephony.dataconnection;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Handler;
import androidx.core.view.InputDeviceCompat;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;

public class DcTesterFailBringUpAll {
    private static final boolean DBG = true;
    private static final String LOG_TAG = "DcTesterFailBrinupAll";
    /* access modifiers changed from: private */
    public String mActionFailBringUp = (DcFailBringUp.INTENT_BASE + "." + "action_fail_bringup");
    /* access modifiers changed from: private */
    public DcFailBringUp mFailBringUp = new DcFailBringUp();
    private BroadcastReceiver mIntentReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            DcTesterFailBringUpAll dcTesterFailBringUpAll = DcTesterFailBringUpAll.this;
            dcTesterFailBringUpAll.log("sIntentReceiver.onReceive: action=" + action);
            if (action.equals(DcTesterFailBringUpAll.this.mActionFailBringUp)) {
                DcTesterFailBringUpAll.this.mFailBringUp.saveParameters(intent, "sFailBringUp");
            } else if (action.equals(DcTesterFailBringUpAll.this.mPhone.getActionDetached())) {
                DcTesterFailBringUpAll.this.log("simulate detaching");
                DcTesterFailBringUpAll.this.mFailBringUp.saveParameters(Integer.MAX_VALUE, InputDeviceCompat.SOURCE_TRACKBALL, -1);
            } else if (action.equals(DcTesterFailBringUpAll.this.mPhone.getActionAttached())) {
                DcTesterFailBringUpAll.this.log("simulate attaching");
                DcTesterFailBringUpAll.this.mFailBringUp.saveParameters(0, 0, -1);
            } else {
                DcTesterFailBringUpAll dcTesterFailBringUpAll2 = DcTesterFailBringUpAll.this;
                dcTesterFailBringUpAll2.log("onReceive: unknown action=" + action);
            }
        }
    };
    /* access modifiers changed from: private */
    public Phone mPhone;

    DcTesterFailBringUpAll(Phone phone, Handler handler) {
        this.mPhone = phone;
        if (TelephonyUtils.IS_DEBUGGABLE) {
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction(this.mActionFailBringUp);
            log("register for intent action=" + this.mActionFailBringUp);
            intentFilter.addAction(this.mPhone.getActionDetached());
            log("register for intent action=" + this.mPhone.getActionDetached());
            intentFilter.addAction(this.mPhone.getActionAttached());
            log("register for intent action=" + this.mPhone.getActionAttached());
            phone.getContext().registerReceiver(this.mIntentReceiver, intentFilter, (String) null, handler, 2);
        }
    }

    /* access modifiers changed from: package-private */
    public void dispose() {
        if (TelephonyUtils.IS_DEBUGGABLE) {
            this.mPhone.getContext().unregisterReceiver(this.mIntentReceiver);
        }
    }

    public DcFailBringUp getDcFailBringUp() {
        return this.mFailBringUp;
    }

    /* access modifiers changed from: private */
    public void log(String str) {
        Rlog.d(LOG_TAG, str);
    }
}
