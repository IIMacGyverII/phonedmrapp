package com.pri.prizeinterphone;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.OnLifecycleEvent;
import com.pri.prizeinterphone.activity.DeviceKilledActivity;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.BaseMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
/* loaded from: classes4.dex */
public class AppObserver implements LifecycleObserver, DmrManager.MessageListener {
    private static final String TAG = "InterPhoneAppObs";
    private boolean isAppFg = false;
    private Context mContext;

    public AppObserver(Context context) {
        this.mContext = context;
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_CREATE)
    public void onCreate() {
        Log.d(TAG, ">>>>>>>>>>>>>>>>> onCreate");
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    public void onStart() {
        Log.d(TAG, ">>>>>>>>>>>>>>>>> onStart");
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
    public void onResume() {
        Log.d(TAG, ">>>>>>>>>>>>>>>>> onResume");
        this.isAppFg = true;
        DmrManager.getInstance().registerEventListener(Const.Command.SET_ENHANCE_FUNCTION_CMD, this);
        if (PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_IS_ALREADY_KILL, 0) != 0) {
            PrizeInterPhoneApp.getContext().startActivity(new Intent(PrizeInterPhoneApp.getContext(), DeviceKilledActivity.class).addFlags(268435456));
        }
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
    public void onPause() {
        Log.d(TAG, ">>>>>>>>>>>>>>>>> onPause");
        this.isAppFg = false;
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    public void onStop() {
        DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_ENHANCE_FUNCTION_CMD), this);
        Log.d(TAG, ">>>>>>>>>>>>>>>>> onStop");
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_DESTROY)
    public void onDestroy() {
        Log.d(TAG, ">>>>>>>>>>>>>>>>> onStop");
    }

    public boolean isAppFg() {
        return this.isAppFg;
    }

    @Override // com.pri.prizeinterphone.manager.DmrManager.MessageListener
    public void dealEvent(BaseMessage baseMessage) {
        if (baseMessage.packet.cmd != 40 || PersonSharePrefData.getIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_IS_ALREADY_KILL, 0) == 0) {
            return;
        }
        this.mContext.startActivity(new Intent(this.mContext, DeviceKilledActivity.class).addFlags(268435456));
    }
}
