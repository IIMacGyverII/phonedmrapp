package com.android.internal.telephony.metrics;

import android.content.Context;
import android.database.ContentObserver;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.provider.Settings;
import android.telephony.SubscriptionManager;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.TelephonyStatsLog;
import com.android.telephony.Rlog;

public class AirplaneModeStats extends ContentObserver {
    private static final long GRACE_PERIOD_MILLIS = 30000;
    private static final long SHORT_TOGGLE_MILLIS = 10000;
    private static final String TAG = AirplaneModeStats.class.getSimpleName();
    private final Uri mAirplaneModeSettingUri;
    private final Context mContext;
    private long mLastActivationTime = 0;

    public AirplaneModeStats(Context context) {
        super(new Handler(Looper.getMainLooper()));
        this.mContext = context;
        Uri uriFor = Settings.Global.getUriFor("airplane_mode_on");
        this.mAirplaneModeSettingUri = uriFor;
        context.getContentResolver().registerContentObserver(uriFor, false, this);
    }

    public void onChange(boolean z, Uri uri) {
        if (uri.equals(this.mAirplaneModeSettingUri)) {
            onAirplaneModeChanged(isAirplaneModeOn());
        }
    }

    private boolean isAirplaneModeOn() {
        return Settings.Global.getInt(this.mContext.getContentResolver(), "airplane_mode_on", 0) != 0;
    }

    private void onAirplaneModeChanged(boolean z) {
        String str = TAG;
        Rlog.d(str, "Airplane mode change. Value: " + z);
        long elapsedRealtime = SystemClock.elapsedRealtime();
        if (elapsedRealtime >= GRACE_PERIOD_MILLIS) {
            boolean calculateShortToggle = calculateShortToggle(elapsedRealtime, z);
            int carrierId = getCarrierId();
            Rlog.d(str, "Airplane mode: " + z + ", short=" + calculateShortToggle + ", carrierId=" + carrierId);
            TelephonyStatsLog.write(311, z, calculateShortToggle, carrierId);
        }
    }

    private boolean calculateShortToggle(long j, boolean z) {
        if (z) {
            if (this.mLastActivationTime == 0) {
                this.mLastActivationTime = j;
            }
            return false;
        }
        long j2 = j - this.mLastActivationTime;
        this.mLastActivationTime = 0;
        if (j2 <= 0 || j2 >= SHORT_TOGGLE_MILLIS) {
            return false;
        }
        return true;
    }

    private static int getCarrierId() {
        int activeDataSubscriptionId = SubscriptionManager.getActiveDataSubscriptionId();
        Phone phone = PhoneFactory.getPhone(activeDataSubscriptionId != -1 ? SubscriptionManager.getPhoneId(activeDataSubscriptionId) : 0);
        if (phone != null) {
            return phone.getCarrierId();
        }
        return -1;
    }
}
