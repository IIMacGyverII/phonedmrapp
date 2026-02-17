package com.android.internal.telephony;

import android.content.Context;
import android.database.ContentObserver;
import android.net.Uri;
import android.os.Handler;
import com.android.telephony.Rlog;
import java.util.HashMap;
import java.util.Map;

public class SettingsObserver extends ContentObserver {
    private static final String TAG = "SettingsObserver";
    private final Context mContext;
    private final Handler mHandler;
    private final Map<Uri, Integer> mUriEventMap = new HashMap();

    public SettingsObserver(Context context, Handler handler) {
        super((Handler) null);
        this.mContext = context;
        this.mHandler = handler;
    }

    public void observe(Uri uri, int i) {
        this.mUriEventMap.put(uri, Integer.valueOf(i));
        this.mContext.getContentResolver().registerContentObserver(uri, false, this);
    }

    public void unobserve() {
        this.mContext.getContentResolver().unregisterContentObserver(this);
    }

    public void onChange(boolean z) {
        Rlog.e(TAG, "Should never be reached.");
    }

    public void onChange(boolean z, Uri uri) {
        Integer num = this.mUriEventMap.get(uri);
        if (num != null) {
            this.mHandler.obtainMessage(num.intValue()).sendToTarget();
            return;
        }
        Rlog.e(TAG, "No matching event to send for URI=" + uri);
    }
}
