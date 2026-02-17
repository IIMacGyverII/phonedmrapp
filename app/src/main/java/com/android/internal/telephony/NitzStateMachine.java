package com.android.internal.telephony;

import android.content.ContentResolver;
import android.os.SystemClock;
import android.os.SystemProperties;
import android.provider.Settings;
import java.io.FileDescriptor;
import java.io.PrintWriter;

public interface NitzStateMachine {

    public interface DeviceState {
        long currentTimeMillis();

        long elapsedRealtimeMillis();

        boolean getIgnoreNitz();

        int getNitzNetworkDisconnectRetentionMillis();

        int getNitzUpdateDiffMillis();

        int getNitzUpdateSpacingMillis();
    }

    void dumpLogs(FileDescriptor fileDescriptor, IndentingPrintWriter indentingPrintWriter, String[] strArr);

    void dumpState(PrintWriter printWriter);

    void handleAirplaneModeChanged(boolean z);

    void handleCountryDetected(String str);

    void handleCountryUnavailable();

    void handleNetworkAvailable();

    void handleNetworkUnavailable();

    void handleNitzReceived(NitzSignal nitzSignal);

    public static class DeviceStateImpl implements DeviceState {
        private static final int NITZ_NETWORK_DISCONNECT_RETENTION_MILLIS_DEFAULT = 300000;
        private static final int NITZ_UPDATE_DIFF_MILLIS_DEFAULT = 2000;
        private static final int NITZ_UPDATE_SPACING_MILLIS_DEFAULT = 600000;
        private final ContentResolver mCr;
        private final int mNitzNetworkDisconnectRetentionMillis = SystemProperties.getInt("ro.nitz_network_disconnect_retention", NITZ_NETWORK_DISCONNECT_RETENTION_MILLIS_DEFAULT);
        private final int mNitzUpdateDiffMillis = SystemProperties.getInt("ro.nitz_update_diff", 2000);
        private final int mNitzUpdateSpacingMillis = SystemProperties.getInt("ro.nitz_update_spacing", 600000);

        public DeviceStateImpl(Phone phone) {
            this.mCr = phone.getContext().getContentResolver();
        }

        public int getNitzUpdateSpacingMillis() {
            return Settings.Global.getInt(this.mCr, "nitz_update_spacing", this.mNitzUpdateSpacingMillis);
        }

        public int getNitzUpdateDiffMillis() {
            return Settings.Global.getInt(this.mCr, "nitz_update_diff", this.mNitzUpdateDiffMillis);
        }

        public int getNitzNetworkDisconnectRetentionMillis() {
            return Settings.Global.getInt(this.mCr, "nitz_network_disconnect_retention", this.mNitzNetworkDisconnectRetentionMillis);
        }

        public boolean getIgnoreNitz() {
            String str = SystemProperties.get("gsm.ignore-nitz");
            return str != null && str.equals("yes");
        }

        public long elapsedRealtimeMillis() {
            return SystemClock.elapsedRealtime();
        }

        public long currentTimeMillis() {
            return System.currentTimeMillis();
        }
    }
}
