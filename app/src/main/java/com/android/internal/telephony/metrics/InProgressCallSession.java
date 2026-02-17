package com.android.internal.telephony.metrics;

import android.os.SystemClock;
import com.android.internal.telephony.nano.TelephonyProto;
import java.util.ArrayDeque;
import java.util.Deque;

public class InProgressCallSession {
    private static final int MAX_EVENTS = 300;
    public final Deque<TelephonyProto.TelephonyCallSession.Event> events;
    private boolean mEventsDropped = false;
    private long mLastElapsedTimeMs;
    private int mLastKnownPhoneState;
    public final int phoneId;
    public final long startElapsedTimeMs;
    public final int startSystemTimeMin;

    public boolean isEventsDropped() {
        return this.mEventsDropped;
    }

    public InProgressCallSession(int i) {
        this.phoneId = i;
        this.events = new ArrayDeque();
        this.startSystemTimeMin = TelephonyMetrics.roundSessionStart(System.currentTimeMillis());
        long elapsedRealtime = SystemClock.elapsedRealtime();
        this.startElapsedTimeMs = elapsedRealtime;
        this.mLastElapsedTimeMs = elapsedRealtime;
    }

    public void addEvent(CallSessionEventBuilder callSessionEventBuilder) {
        addEvent(SystemClock.elapsedRealtime(), callSessionEventBuilder);
    }

    public synchronized void addEvent(long j, CallSessionEventBuilder callSessionEventBuilder) {
        if (this.events.size() >= MAX_EVENTS) {
            this.events.removeFirst();
            this.mEventsDropped = true;
        }
        callSessionEventBuilder.setDelay(TelephonyMetrics.toPrivacyFuzzedTimeInterval(this.mLastElapsedTimeMs, j));
        this.events.add(callSessionEventBuilder.build());
        this.mLastElapsedTimeMs = j;
    }

    public synchronized boolean containsCsCalls() {
        for (TelephonyProto.TelephonyCallSession.Event event : this.events) {
            if (event.type == 10) {
                return true;
            }
        }
        return false;
    }

    public void setLastKnownPhoneState(int i) {
        this.mLastKnownPhoneState = i;
    }

    public boolean isPhoneIdle() {
        return this.mLastKnownPhoneState == 1;
    }
}
