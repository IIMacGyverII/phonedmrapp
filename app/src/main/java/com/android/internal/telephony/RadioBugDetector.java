package com.android.internal.telephony;

import android.content.Context;
import android.provider.Settings;
import com.android.internal.annotations.VisibleForTesting;
import java.util.HashMap;

public class RadioBugDetector {
    private static final int DEFAULT_SYSTEM_ERROR_COUNT_THRESHOLD = 100;
    private static final int DEFAULT_WAKELOCK_TIMEOUT_COUNT_THRESHOLD = 10;
    private static final int RADIO_BUG_NONE = 0;
    @VisibleForTesting
    protected static final int RADIO_BUG_REPETITIVE_SYSTEM_ERROR = 2;
    private static final int RADIO_BUG_REPETITIVE_WAKELOCK_TIMEOUT_ERROR = 1;
    private static final String TAG = "RadioBugDetector";
    private Context mContext;
    private int mContinuousWakelockTimoutCount = 0;
    private int mRadioBugStatus = 0;
    private int mSlotId;
    private HashMap<Integer, Integer> mSysErrRecord = new HashMap<>();
    private int mSystemErrorThreshold = 0;
    private int mWakelockTimeoutThreshold = 0;

    public RadioBugDetector(Context context, int i) {
        this.mContext = context;
        this.mSlotId = i;
        init();
    }

    private void init() {
        this.mWakelockTimeoutThreshold = Settings.Global.getInt(this.mContext.getContentResolver(), "radio_bug_wakelock_timeout_count_threshold", 10);
        this.mSystemErrorThreshold = Settings.Global.getInt(this.mContext.getContentResolver(), "radio_bug_system_error_count_threshold", 100);
    }

    public synchronized void detectRadioBug(int i, int i2) {
        this.mContinuousWakelockTimoutCount = 0;
        if (i2 == 39) {
            this.mSysErrRecord.put(Integer.valueOf(i), Integer.valueOf(this.mSysErrRecord.getOrDefault(Integer.valueOf(i), 0).intValue() + 1));
            broadcastBug(true);
        } else {
            this.mSysErrRecord.remove(Integer.valueOf(i));
            if (!isFrequentSystemError()) {
                this.mRadioBugStatus = 0;
            }
        }
    }

    public void processWakelockTimeout() {
        this.mContinuousWakelockTimoutCount++;
        broadcastBug(false);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:24:0x0058, code lost:
        return;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private synchronized void broadcastBug(boolean r3) {
        /*
            r2 = this;
            monitor-enter(r2)
            if (r3 == 0) goto L_0x000b
            boolean r0 = r2.isFrequentSystemError()     // Catch:{ all -> 0x0059 }
            if (r0 != 0) goto L_0x0013
            monitor-exit(r2)
            return
        L_0x000b:
            int r0 = r2.mContinuousWakelockTimoutCount     // Catch:{ all -> 0x0059 }
            int r1 = r2.mWakelockTimeoutThreshold     // Catch:{ all -> 0x0059 }
            if (r0 >= r1) goto L_0x0013
            monitor-exit(r2)
            return
        L_0x0013:
            int r0 = r2.mRadioBugStatus     // Catch:{ all -> 0x0059 }
            if (r0 != 0) goto L_0x0057
            if (r3 == 0) goto L_0x001b
            r3 = 2
            goto L_0x001c
        L_0x001b:
            r3 = 1
        L_0x001c:
            r2.mRadioBugStatus = r3     // Catch:{ all -> 0x0059 }
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch:{ all -> 0x0059 }
            r3.<init>()     // Catch:{ all -> 0x0059 }
            java.lang.String r0 = "Repeated radio error "
            r3.append(r0)     // Catch:{ all -> 0x0059 }
            int r0 = r2.mRadioBugStatus     // Catch:{ all -> 0x0059 }
            r3.append(r0)     // Catch:{ all -> 0x0059 }
            java.lang.String r0 = " on slot "
            r3.append(r0)     // Catch:{ all -> 0x0059 }
            int r0 = r2.mSlotId     // Catch:{ all -> 0x0059 }
            r3.append(r0)     // Catch:{ all -> 0x0059 }
            java.lang.String r3 = r3.toString()     // Catch:{ all -> 0x0059 }
            java.lang.String r0 = "RadioBugDetector"
            com.android.telephony.Rlog.d(r0, r3)     // Catch:{ all -> 0x0059 }
            int r0 = r2.mSlotId     // Catch:{ all -> 0x0059 }
            com.android.internal.telephony.Phone r0 = com.android.internal.telephony.PhoneFactory.getPhone(r0)     // Catch:{ all -> 0x0059 }
            if (r0 != 0) goto L_0x004a
            r0 = -1
            goto L_0x004e
        L_0x004a:
            int r0 = r0.getCarrierId()     // Catch:{ all -> 0x0059 }
        L_0x004e:
            java.lang.String r1 = "d264ead0-3f05-11ea-b77f-2e728ce88125"
            java.util.UUID r1 = java.util.UUID.fromString(r1)     // Catch:{ all -> 0x0059 }
            android.telephony.AnomalyReporter.reportAnomaly(r1, r3, r0)     // Catch:{ all -> 0x0059 }
        L_0x0057:
            monitor-exit(r2)
            return
        L_0x0059:
            r3 = move-exception
            monitor-exit(r2)
            throw r3
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.RadioBugDetector.broadcastBug(boolean):void");
    }

    private boolean isFrequentSystemError() {
        int i = 0;
        for (Integer intValue : this.mSysErrRecord.values()) {
            i += intValue.intValue();
            if (i >= this.mSystemErrorThreshold) {
                return true;
            }
        }
        return false;
    }

    @VisibleForTesting
    public int getRadioBugStatus() {
        return this.mRadioBugStatus;
    }

    @VisibleForTesting
    public int getWakelockTimeoutThreshold() {
        return this.mWakelockTimeoutThreshold;
    }

    @VisibleForTesting
    public int getSystemErrorThreshold() {
        return this.mSystemErrorThreshold;
    }

    @VisibleForTesting
    public int getWakelockTimoutCount() {
        return this.mContinuousWakelockTimoutCount;
    }
}
