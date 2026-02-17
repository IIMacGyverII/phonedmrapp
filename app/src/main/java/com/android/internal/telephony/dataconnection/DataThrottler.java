package com.android.internal.telephony.dataconnection;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.os.PersistableBundle;
import android.telephony.CarrierConfigManager;
import android.telephony.SubscriptionManager;
import android.telephony.data.ThrottleStatus;
import com.android.internal.telephony.Phone;
import com.android.telephony.Rlog;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class DataThrottler extends Handler {
    private static final int EVENT_AIRPLANE_MODE_CHANGED = 4;
    private static final int EVENT_CARRIER_CONFIG_CHANGED = 2;
    private static final int EVENT_RESET = 3;
    private static final int EVENT_SET_RETRY_TIME = 1;
    private static final int EVENT_TRACING_AREA_CODE_CHANGED = 5;
    private static final String TAG = DataThrottler.class.getSimpleName();
    private final BroadcastReceiver mBroadcastReceiver;
    private final List<Callback> mCallbacks = new ArrayList();
    /* access modifiers changed from: private */
    public final Phone mPhone;
    private boolean mResetWhenAreaCodeChanged = false;
    private final int mSlotIndex;
    private final Map<Integer, ThrottleStatus> mThrottleStatus = new ConcurrentHashMap();
    private final int mTransportType;

    public interface Callback {
        void onThrottleStatusChanged(List<ThrottleStatus> list);
    }

    public DataThrottler(Phone phone, int i) {
        super((Handler.Callback) null, false);
        AnonymousClass1 r1 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if (intent.getAction().equals("android.telephony.action.CARRIER_CONFIG_CHANGED") && DataThrottler.this.mPhone.getPhoneId() == intent.getIntExtra("android.telephony.extra.SLOT_INDEX", -1) && !intent.getBooleanExtra("android.telephony.extra.REBROADCAST_ON_UNLOCK", false) && SubscriptionManager.isValidSubscriptionId(intent.getIntExtra("android.telephony.extra.SUBSCRIPTION_INDEX", -1))) {
                    DataThrottler.this.sendEmptyMessage(2);
                }
            }
        };
        this.mBroadcastReceiver = r1;
        this.mPhone = phone;
        this.mSlotIndex = phone.getPhoneId();
        this.mTransportType = i;
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.telephony.action.CARRIER_CONFIG_CHANGED");
        phone.getContext().registerReceiver(r1, intentFilter, (String) null, phone);
        phone.getServiceStateTracker().registerForAirplaneModeChanged(this, 4, (Object) null);
        phone.getServiceStateTracker().registerForAreaCodeChanged(this, 5, (Object) null);
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i == 1) {
            setRetryTimeInternal(message.arg1, ((Long) message.obj).longValue(), message.arg2);
        } else if (i == 2) {
            onCarrierConfigChanged();
        } else if (i == 3) {
            resetInternal();
        } else if (i != 4) {
            if (i == 5 && this.mResetWhenAreaCodeChanged) {
                resetInternal();
            }
        } else if (!((Boolean) ((AsyncResult) message.obj).result).booleanValue()) {
            resetInternal();
        }
    }

    private PersistableBundle getCarrierConfig() {
        PersistableBundle configForSubId;
        CarrierConfigManager carrierConfigManager = (CarrierConfigManager) this.mPhone.getContext().getSystemService("carrier_config");
        if (carrierConfigManager == null || (configForSubId = carrierConfigManager.getConfigForSubId(this.mPhone.getSubId())) == null) {
            return CarrierConfigManager.getDefaultConfig();
        }
        return configForSubId;
    }

    private void onCarrierConfigChanged() {
        this.mResetWhenAreaCodeChanged = getCarrierConfig().getBoolean("unthrottle_data_retry_when_tac_changes_bool", false);
    }

    public void setRetryTime(int i, long j, int i2) {
        sendMessage(obtainMessage(1, i, i2, Long.valueOf(j)));
    }

    private void setRetryTimeInternal(int i, long j, int i2) {
        if (j < 0) {
            j = -1;
        }
        ArrayList arrayList = new ArrayList();
        while (i != 0) {
            int i3 = 17;
            if ((i & 17) == 17) {
                i &= -18;
            } else {
                i3 = i & (-i);
                i &= i - 1;
            }
            ThrottleStatus createStatus = createStatus(i3, j, i2);
            if (!createStatus.equals(this.mThrottleStatus.get(Integer.valueOf(i3)))) {
                arrayList.add(createStatus);
                this.mThrottleStatus.put(Integer.valueOf(i3), createStatus);
            }
        }
        if (arrayList.size() > 0) {
            sendThrottleStatusChanged(arrayList);
        }
    }

    public long getRetryTime(int i) {
        ThrottleStatus throttleStatus = this.mThrottleStatus.get(Integer.valueOf(i));
        if (throttleStatus == null || throttleStatus.getThrottleType() == 1) {
            return -1;
        }
        return throttleStatus.getThrottleExpiryTimeMillis();
    }

    public void reset() {
        sendEmptyMessage(3);
    }

    private void resetInternal() {
        ArrayList<Integer> arrayList = new ArrayList<>();
        for (ThrottleStatus apnType : this.mThrottleStatus.values()) {
            arrayList.add(Integer.valueOf(apnType.getApnType()));
        }
        for (Integer intValue : arrayList) {
            setRetryTime(intValue.intValue(), -1, 1);
        }
    }

    private ThrottleStatus createStatus(int i, long j, int i2) {
        ThrottleStatus.Builder builder = new ThrottleStatus.Builder();
        if (j == -1) {
            builder.setNoThrottle().setRetryType(getRetryType(i2));
        } else if (j == Long.MAX_VALUE) {
            builder.setThrottleExpiryTimeMillis(Long.MAX_VALUE).setRetryType(1);
        } else {
            builder.setThrottleExpiryTimeMillis(j).setRetryType(getRetryType(i2));
        }
        return builder.setSlotIndex(this.mSlotIndex).setTransportType(this.mTransportType).setApnType(i).build();
    }

    private static int getRetryType(int i) {
        if (i == 1) {
            return 2;
        }
        if (i == 2) {
            return 3;
        }
        loge("createStatus: Unknown requestType=" + i);
        return 2;
    }

    private void sendThrottleStatusChanged(List<ThrottleStatus> list) {
        synchronized (this.mCallbacks) {
            for (int i = 0; i < this.mCallbacks.size(); i++) {
                this.mCallbacks.get(i).onThrottleStatusChanged(list);
            }
        }
    }

    private static void loge(String str) {
        Rlog.e(TAG, str);
    }

    public void registerForThrottleStatusChanges(Callback callback) {
        synchronized (this.mCallbacks) {
            if (!this.mCallbacks.contains(callback)) {
                callback.onThrottleStatusChanged(new ArrayList(this.mThrottleStatus.values()));
                this.mCallbacks.add(callback);
            }
        }
    }

    public void unregisterForThrottleStatusChanges(Callback callback) {
        synchronized (this.mCallbacks) {
            this.mCallbacks.remove(callback);
        }
    }
}
