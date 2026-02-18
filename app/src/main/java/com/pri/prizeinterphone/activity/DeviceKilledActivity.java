package com.pri.prizeinterphone.activity;

import android.os.Bundle;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import com.pri.prizeinterphone.PrizeInterPhoneApp;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.BaseMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
/* loaded from: classes4.dex */
public class DeviceKilledActivity extends AppCompatActivity {
    private static final String TAG = "DeviceKilledActivity";
    DmrManager.MessageListener mMessageListener = new DmrManager.MessageListener() { // from class: com.pri.prizeinterphone.activity.DeviceKilledActivity.1
        @Override // com.pri.prizeinterphone.manager.DmrManager.MessageListener
        public void dealEvent(BaseMessage baseMessage) {
            if (baseMessage.packet.cmd == 40 && PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_IS_ALREADY_KILL, 0) == 0) {
                Log.d(DeviceKilledActivity.TAG, "dealEvent is already revive, so finish()");
                DeviceKilledActivity.this.finish();
            }
        }
    };

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, androidx.activity.ComponentActivity, androidx.core.app.ComponentActivity, android.app.Activity
    public void onCreate(@Nullable Bundle bundle) {
        super.onCreate(bundle);
        supportRequestWindowFeature(1);
        setContentView(R.layout.device_kill_dialog);
        if (!PrizeInterPhoneApp.isAppFg()) {
            Log.d(TAG, "onCreate is not foreground, so finish()");
            finish();
        }
        if (PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_IS_ALREADY_KILL, 0) == 0) {
            Log.d(TAG, "onCreate is already revive, so finish()");
            finish();
        }
        setFinishOnTouchOutside(false);
        setWindowLayoutParams();
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, android.app.Activity
    public void onResume() {
        super.onResume();
        DmrManager.getInstance().registerEventListener(Const.Command.SET_ENHANCE_FUNCTION_CMD, this.mMessageListener);
        if (PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_IS_ALREADY_KILL, 0) == 0) {
            Log.d(TAG, "onResume is already revive, so finish()");
            finish();
        }
    }

    @Override // androidx.activity.ComponentActivity, android.app.Activity
    public void onBackPressed() {
        if (PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_IS_ALREADY_KILL, 0) != 0) {
            Log.d(TAG, "onBackPressed is not already revive, return ");
            return;
        }
        Log.d(TAG, "onBackPressed is already revive, so finish()");
        finish();
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, android.app.Activity
    public void onPause() {
        super.onPause();
        DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_ENHANCE_FUNCTION_CMD), this.mMessageListener);
    }

    private void setWindowLayoutParams() {
        int i = getResources().getDisplayMetrics().widthPixels;
        Window window = getWindow();
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.gravity = 80;
        attributes.y = 60;
        attributes.width = (int) (i * 0.9f);
        window.setAttributes(attributes);
        window.setBackgroundDrawableResource(17170445);
    }
}
