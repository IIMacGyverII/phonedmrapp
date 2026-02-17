package com.android.internal.telephony.util;

import android.util.Log;
import java.time.Clock;
import java.time.DateTimeException;
import java.time.Instant;
import java.time.ZoneId;
import java.util.Arrays;

public final class BestClock extends Clock {
    private static final String TAG = "BestClock";
    private final Clock[] mClocks;
    private final ZoneId mZone;

    public BestClock(ZoneId zoneId, Clock... clockArr) {
        this.mZone = zoneId;
        this.mClocks = clockArr;
    }

    public long millis() {
        Clock[] clockArr = this.mClocks;
        int length = clockArr.length;
        int i = 0;
        while (i < length) {
            try {
                return clockArr[i].millis();
            } catch (DateTimeException e) {
                Log.w(TAG, e.toString());
                i++;
            }
        }
        throw new DateTimeException("No clocks in " + Arrays.toString(this.mClocks) + " were able to provide time");
    }

    public ZoneId getZone() {
        return this.mZone;
    }

    public Clock withZone(ZoneId zoneId) {
        return new BestClock(zoneId, this.mClocks);
    }

    public Instant instant() {
        return Instant.ofEpochMilli(millis());
    }
}
