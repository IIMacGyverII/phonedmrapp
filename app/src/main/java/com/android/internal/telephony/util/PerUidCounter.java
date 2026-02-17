package com.android.internal.telephony.util;

import android.util.SparseIntArray;
import com.android.net.module.annotation.GuardedBy;
import com.android.net.module.annotation.VisibleForTesting;

public class PerUidCounter {
    private final int mMaxCountPerUid;
    @VisibleForTesting
    @GuardedBy({"mUidToCount"})
    final SparseIntArray mUidToCount = new SparseIntArray();

    public PerUidCounter(int i) {
        if (i > 0) {
            this.mMaxCountPerUid = i;
            return;
        }
        throw new IllegalArgumentException("Maximum counter value must be positive");
    }

    public void incrementCountOrThrow(int i) {
        incrementCountOrThrow(i, 1);
    }

    public synchronized void incrementCountOrThrow(int i, int i2) {
        if (i2 > 0) {
            try {
                long j = ((long) this.mUidToCount.get(i, 0)) + ((long) i2);
                if (j <= ((long) this.mMaxCountPerUid)) {
                    this.mUidToCount.put(i, (int) j);
                } else {
                    throw new IllegalStateException("Uid " + i + " exceeded its allowed limit");
                }
            } catch (Throwable th) {
                throw th;
            }
        } else {
            throw new IllegalArgumentException("Increment count must be positive");
        }
    }

    public void decrementCountOrThrow(int i) {
        decrementCountOrThrow(i, 1);
    }

    public synchronized void decrementCountOrThrow(int i, int i2) {
        if (i2 > 0) {
            try {
                int i3 = this.mUidToCount.get(i, 0) - i2;
                if (i3 < 0) {
                    throw new IllegalStateException("BUG: too small count " + i3 + " for UID " + i);
                } else if (i3 == 0) {
                    this.mUidToCount.delete(i);
                } else {
                    this.mUidToCount.put(i, i3);
                }
            } catch (Throwable th) {
                throw th;
            }
        } else {
            throw new IllegalArgumentException("Decrement count must be positive");
        }
    }
}
