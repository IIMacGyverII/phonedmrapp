package com.android.internal.telephony;

import android.os.SystemClock;
import android.util.LongArrayQueue;
import com.android.internal.annotations.VisibleForTesting;

public class SlidingWindowEventCounter {
    private final int mNumOccurrences;
    private final LongArrayQueue mTimestampQueueMillis;
    private final long mWindowSizeMillis;

    public SlidingWindowEventCounter(long j, int i) {
        if (j < 0) {
            throw new IllegalArgumentException("windowSizeMillis must be greater or equal to 0");
        } else if (i > 1) {
            this.mWindowSizeMillis = j;
            this.mNumOccurrences = i;
            this.mTimestampQueueMillis = new LongArrayQueue(i);
        } else {
            throw new IllegalArgumentException("numOccurrences must be greater than 1");
        }
    }

    public synchronized boolean addOccurrence() {
        return addOccurrence(SystemClock.elapsedRealtime());
    }

    public synchronized boolean addOccurrence(long j) {
        this.mTimestampQueueMillis.addLast(j);
        if (this.mTimestampQueueMillis.size() > this.mNumOccurrences) {
            this.mTimestampQueueMillis.removeFirst();
        }
        return isInWindow();
    }

    public synchronized boolean isInWindow() {
        return this.mTimestampQueueMillis.size() == this.mNumOccurrences && this.mTimestampQueueMillis.peekFirst() + this.mWindowSizeMillis > this.mTimestampQueueMillis.peekLast();
    }

    /* access modifiers changed from: package-private */
    @VisibleForTesting
    public int getQueuedNumOccurrences() {
        return this.mTimestampQueueMillis.size();
    }

    public synchronized long getWindowSizeMillis() {
        return this.mWindowSizeMillis;
    }

    public synchronized int getNumOccurrences() {
        return this.mNumOccurrences;
    }

    public String getFrequencyString() {
        return String.format("%d times within %d ms.", new Object[]{Integer.valueOf(this.mNumOccurrences), Long.valueOf(this.mWindowSizeMillis)});
    }

    public String toString() {
        return String.format("SlidingWindowEventCounter=[windowSizeMillis=" + this.mWindowSizeMillis + ", numOccurrences=" + this.mNumOccurrences + ", timestampQueueMillis=" + this.mTimestampQueueMillis + "]", new Object[0]);
    }
}
