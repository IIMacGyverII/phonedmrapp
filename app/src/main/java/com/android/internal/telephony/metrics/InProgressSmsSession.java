package com.android.internal.telephony.metrics;

import android.os.SystemClock;
import com.android.internal.telephony.nano.TelephonyProto;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.concurrent.atomic.AtomicInteger;

public class InProgressSmsSession {
    private static final int MAX_EVENTS = 20;
    public final Deque<TelephonyProto.SmsSession.Event> events;
    private boolean mEventsDropped = false;
    private long mLastElapsedTimeMs;
    private AtomicInteger mNumExpectedResponses = new AtomicInteger(0);
    public final int phoneId;
    public final long startElapsedTimeMs;
    public final int startSystemTimeMin;

    public void increaseExpectedResponse() {
        this.mNumExpectedResponses.incrementAndGet();
    }

    public void decreaseExpectedResponse() {
        this.mNumExpectedResponses.decrementAndGet();
    }

    public int getNumExpectedResponses() {
        return this.mNumExpectedResponses.get();
    }

    public boolean isEventsDropped() {
        return this.mEventsDropped;
    }

    public InProgressSmsSession(int i) {
        this.phoneId = i;
        this.events = new ArrayDeque();
        this.startSystemTimeMin = TelephonyMetrics.roundSessionStart(System.currentTimeMillis());
        long elapsedRealtime = SystemClock.elapsedRealtime();
        this.startElapsedTimeMs = elapsedRealtime;
        this.mLastElapsedTimeMs = elapsedRealtime;
    }

    public void addEvent(SmsSessionEventBuilder smsSessionEventBuilder) {
        addEvent(SystemClock.elapsedRealtime(), smsSessionEventBuilder);
    }

    public synchronized void addEvent(long j, SmsSessionEventBuilder smsSessionEventBuilder) {
        if (this.events.size() >= 20) {
            this.events.removeFirst();
            this.mEventsDropped = true;
        }
        smsSessionEventBuilder.setDelay(TelephonyMetrics.toPrivacyFuzzedTimeInterval(this.mLastElapsedTimeMs, j));
        this.events.add(smsSessionEventBuilder.build());
        this.mLastElapsedTimeMs = j;
    }
}
