package com.google.android.material.datepicker;

import androidx.annotation.Nullable;
import java.util.Calendar;
import java.util.TimeZone;

class TimeSource {
    private static final TimeSource SYSTEM_TIME_SOURCE = new TimeSource((Long) null, (TimeZone) null);
    @Nullable
    private final Long fixedTimeMs;
    @Nullable
    private final TimeZone fixedTimeZone;

    private TimeSource(@Nullable Long l, @Nullable TimeZone timeZone) {
        this.fixedTimeMs = l;
        this.fixedTimeZone = timeZone;
    }

    static TimeSource system() {
        return SYSTEM_TIME_SOURCE;
    }

    static TimeSource fixed(long j, @Nullable TimeZone timeZone) {
        return new TimeSource(Long.valueOf(j), timeZone);
    }

    static TimeSource fixed(long j) {
        return new TimeSource(Long.valueOf(j), (TimeZone) null);
    }

    /* access modifiers changed from: package-private */
    public Calendar now() {
        return now(this.fixedTimeZone);
    }

    /* access modifiers changed from: package-private */
    public Calendar now(@Nullable TimeZone timeZone) {
        Calendar instance = timeZone == null ? Calendar.getInstance() : Calendar.getInstance(timeZone);
        Long l = this.fixedTimeMs;
        if (l != null) {
            instance.setTimeInMillis(l.longValue());
        }
        return instance;
    }
}
