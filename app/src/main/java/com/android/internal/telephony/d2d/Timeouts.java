package com.android.internal.telephony.d2d;

import android.content.ContentResolver;
import android.provider.Settings;

public final class Timeouts {
    private static final String PREFIX = "telephony.d2d.";

    public static class Adapter {
        private final ContentResolver mContentResolver;

        public Adapter(ContentResolver contentResolver) {
            this.mContentResolver = contentResolver;
        }

        public long getRtpMessageAckDurationMillis() {
            return Timeouts.getRtpMessageAckDurationMillis(this.mContentResolver);
        }

        public long getDtmfMinimumIntervalMillis() {
            return Timeouts.getDtmfMinimumIntervalMillis(this.mContentResolver);
        }

        public long getMaxDurationOfDtmfMessageMillis() {
            return Timeouts.getMaxDurationOfDtmfMessageMillis(this.mContentResolver);
        }

        public long getDtmfDurationFuzzMillis() {
            return Timeouts.getDtmfDurationFuzzMillis(this.mContentResolver);
        }

        public long getDtmfNegotiationTimeoutMillis() {
            return Timeouts.getDtmfNegotiationTimeoutMillis(this.mContentResolver);
        }
    }

    private static long get(ContentResolver contentResolver, String str, long j) {
        return Settings.Secure.getLong(contentResolver, PREFIX + str, j);
    }

    public static long getRtpMessageAckDurationMillis(ContentResolver contentResolver) {
        return get(contentResolver, "rtp_message_ack_duration_millis", 1000);
    }

    public static long getDtmfMinimumIntervalMillis(ContentResolver contentResolver) {
        return get(contentResolver, "dtmf_minimum_interval_millis", 100);
    }

    public static long getMaxDurationOfDtmfMessageMillis(ContentResolver contentResolver) {
        return get(contentResolver, "dtmf_max_message_duration_millis", 1000);
    }

    public static long getDtmfNegotiationTimeoutMillis(ContentResolver contentResolver) {
        return get(contentResolver, "dtmf_negotiation_timeout_millis", 3000);
    }

    public static long getDtmfDurationFuzzMillis(ContentResolver contentResolver) {
        return get(contentResolver, "dtmf_duration_fuzz_millis", 10);
    }
}
