package com.android.internal.telephony.nitz;

import android.app.timedetector.TelephonyTimeSuggestion;
import android.app.timezonedetector.TelephonyTimeZoneSuggestion;
import android.os.TimestampedValue;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.IndentingPrintWriter;
import com.android.internal.telephony.NitzData;
import com.android.internal.telephony.NitzSignal;
import com.android.internal.telephony.NitzStateMachine;
import com.android.internal.telephony.Phone;
import com.android.telephony.Rlog;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.Objects;

public final class NitzStateMachineImpl implements NitzStateMachine {
    static final boolean DBG = true;
    static final String LOG_TAG = "NitzStateMachineImpl";
    private String mCountryIsoCode;
    private final NitzStateMachine.DeviceState mDeviceState;
    private TimestampedValue<NitzSignal> mLastNitzSignalCleared;
    private NitzSignal mLatestNitzSignal;
    private final NitzSignalInputFilterPredicate mNitzSignalInputFilter;
    private final int mSlotIndex;
    private final TimeServiceHelper mTimeServiceHelper;
    private final TimeZoneSuggester mTimeZoneSuggester;

    @FunctionalInterface
    @VisibleForTesting
    public interface NitzSignalInputFilterPredicate {
        boolean mustProcessNitzSignal(NitzSignal nitzSignal, NitzSignal nitzSignal2);
    }

    @VisibleForTesting
    public interface TimeZoneSuggester {
        TelephonyTimeZoneSuggestion getTimeZoneSuggestion(int i, String str, NitzSignal nitzSignal);
    }

    public static NitzStateMachineImpl createInstance(Phone phone) {
        Objects.requireNonNull(phone);
        int phoneId = phone.getPhoneId();
        NitzStateMachine.DeviceStateImpl deviceStateImpl = new NitzStateMachine.DeviceStateImpl(phone);
        return new NitzStateMachineImpl(phoneId, deviceStateImpl, NitzSignalInputFilterPredicateFactory.create(phone.getContext(), deviceStateImpl), new TimeZoneSuggesterImpl(deviceStateImpl, new TimeZoneLookupHelper()), new TimeServiceHelperImpl(phone));
    }

    @VisibleForTesting
    public NitzStateMachineImpl(int i, NitzStateMachine.DeviceState deviceState, NitzSignalInputFilterPredicate nitzSignalInputFilterPredicate, TimeZoneSuggester timeZoneSuggester, TimeServiceHelper timeServiceHelper) {
        this.mSlotIndex = i;
        Objects.requireNonNull(deviceState);
        this.mDeviceState = deviceState;
        Objects.requireNonNull(timeZoneSuggester);
        this.mTimeZoneSuggester = timeZoneSuggester;
        Objects.requireNonNull(timeServiceHelper);
        this.mTimeServiceHelper = timeServiceHelper;
        Objects.requireNonNull(nitzSignalInputFilterPredicate);
        this.mNitzSignalInputFilter = nitzSignalInputFilterPredicate;
    }

    public void handleNetworkAvailable() {
        restoreNetworkStateAndRerunDetection("handleNetworkAvailable");
    }

    public void handleNetworkUnavailable() {
        clearNetworkStateAndRerunDetection("handleNetworkUnavailable", false);
    }

    public void handleCountryDetected(String str) {
        Rlog.d(LOG_TAG, "handleCountryDetected: countryIsoCode=" + str + ", mLatestNitzSignal=" + this.mLatestNitzSignal);
        String str2 = this.mCountryIsoCode;
        Objects.requireNonNull(str);
        this.mCountryIsoCode = str;
        if (!Objects.equals(str2, str)) {
            NitzSignal nitzSignal = this.mLatestNitzSignal;
            doTimeZoneDetection(str, nitzSignal, "handleCountryDetected(\"" + str + "\")");
        }
    }

    public void handleCountryUnavailable() {
        Rlog.d(LOG_TAG, "handleCountryUnavailable: mLatestNitzSignal=" + this.mLatestNitzSignal);
        this.mCountryIsoCode = null;
        doTimeZoneDetection((String) null, this.mLatestNitzSignal, "handleCountryUnavailable");
    }

    public void handleNitzReceived(NitzSignal nitzSignal) {
        Objects.requireNonNull(nitzSignal);
        NitzSignal nitzSignal2 = this.mLatestNitzSignal;
        if (!this.mNitzSignalInputFilter.mustProcessNitzSignal(nitzSignal2, nitzSignal)) {
            Rlog.d(LOG_TAG, "handleNitzReceived: previousNitzSignal=" + nitzSignal2 + ", nitzSignal=" + nitzSignal + ": NITZ filtered");
            return;
        }
        this.mLatestNitzSignal = nitzSignal;
        this.mLastNitzSignalCleared = null;
        runDetection("handleNitzReceived(" + nitzSignal + ")");
    }

    public void handleAirplaneModeChanged(boolean z) {
        this.mCountryIsoCode = null;
        clearNetworkStateAndRerunDetection("handleAirplaneModeChanged(" + z + ")", true);
    }

    private void restoreNetworkStateAndRerunDetection(String str) {
        if (this.mLastNitzSignalCleared == null) {
            Rlog.d(LOG_TAG, str + ": mLastNitzSignalCleared is null.");
            return;
        }
        if (this.mDeviceState.elapsedRealtimeMillis() - this.mLastNitzSignalCleared.getReferenceTimeMillis() < ((long) this.mDeviceState.getNitzNetworkDisconnectRetentionMillis())) {
            this.mLatestNitzSignal = (NitzSignal) this.mLastNitzSignalCleared.getValue();
            this.mLastNitzSignalCleared = null;
            runDetection(str + ", mLatestNitzSignal restored from mLastNitzSignalCleared=" + this.mLastNitzSignalCleared.getValue());
            return;
        }
        Rlog.d(LOG_TAG, str + ": mLastNitzSignalCleared is too old.");
    }

    private void clearNetworkStateAndRerunDetection(String str, boolean z) {
        if (this.mLatestNitzSignal == null) {
            if (z) {
                this.mLastNitzSignalCleared = null;
            }
            Rlog.d(LOG_TAG, str + ": mLatestNitzSignal was already null. Nothing to do.");
            return;
        }
        if (z) {
            this.mLastNitzSignalCleared = null;
        } else {
            this.mLastNitzSignalCleared = new TimestampedValue<>(this.mDeviceState.elapsedRealtimeMillis(), this.mLatestNitzSignal);
        }
        this.mLatestNitzSignal = null;
        runDetection(str);
    }

    private void runDetection(String str) {
        String str2 = this.mCountryIsoCode;
        NitzSignal nitzSignal = this.mLatestNitzSignal;
        Rlog.d(LOG_TAG, "runDetection: reason=" + str + ", countryIsoCode=" + str2 + ", nitzSignal=" + nitzSignal);
        doTimeZoneDetection(str2, nitzSignal, str);
        doTimeDetection(nitzSignal, str);
    }

    private void doTimeZoneDetection(String str, NitzSignal nitzSignal, String str2) {
        try {
            Objects.requireNonNull(str2);
            TelephonyTimeZoneSuggestion timeZoneSuggestion = this.mTimeZoneSuggester.getTimeZoneSuggestion(this.mSlotIndex, str, nitzSignal);
            timeZoneSuggestion.addDebugInfo("Detection reason=" + str2);
            Rlog.d(LOG_TAG, "doTimeZoneDetection: countryIsoCode=" + str + ", nitzSignal=" + nitzSignal + ", suggestion=" + timeZoneSuggestion + ", reason=" + str2);
            this.mTimeServiceHelper.maybeSuggestDeviceTimeZone(timeZoneSuggestion);
        } catch (RuntimeException e) {
            Rlog.e(LOG_TAG, "doTimeZoneDetection: Exception thrown mSlotIndex=" + this.mSlotIndex + ", countryIsoCode=" + str + ", nitzSignal=" + nitzSignal + ", reason=" + str2 + ", ex=" + e, e);
        }
    }

    private void doTimeDetection(NitzSignal nitzSignal, String str) {
        try {
            Objects.requireNonNull(str);
            TelephonyTimeSuggestion.Builder builder = new TelephonyTimeSuggestion.Builder(this.mSlotIndex);
            if (nitzSignal == null) {
                builder.addDebugInfo("Clearing time suggestion reason=" + str);
            } else {
                builder.setUnixEpochTime(nitzSignal.createTimeSignal());
                builder.addDebugInfo("Sending new time suggestion nitzSignal=" + nitzSignal + ", reason=" + str);
            }
            this.mTimeServiceHelper.suggestDeviceTime(builder.build());
        } catch (RuntimeException e) {
            Rlog.e(LOG_TAG, "doTimeDetection: Exception thrown mSlotIndex=" + this.mSlotIndex + ", nitzSignal=" + nitzSignal + ", reason=" + str + ", ex=" + e, e);
        }
    }

    public void dumpState(PrintWriter printWriter) {
        printWriter.println(" NitzStateMachineImpl.mLatestNitzSignal=" + this.mLatestNitzSignal);
        printWriter.println(" NitzStateMachineImpl.mCountryIsoCode=" + this.mCountryIsoCode);
        this.mTimeServiceHelper.dumpState(printWriter);
        printWriter.flush();
    }

    public void dumpLogs(FileDescriptor fileDescriptor, IndentingPrintWriter indentingPrintWriter, String[] strArr) {
        this.mTimeServiceHelper.dumpLogs(indentingPrintWriter);
    }

    @VisibleForTesting
    public NitzData getLatestNitzData() {
        NitzSignal nitzSignal = this.mLatestNitzSignal;
        if (nitzSignal != null) {
            return nitzSignal.getNitzData();
        }
        return null;
    }

    @VisibleForTesting
    public NitzData getLastNitzDataCleared() {
        TimestampedValue<NitzSignal> timestampedValue = this.mLastNitzSignalCleared;
        if (timestampedValue != null) {
            return ((NitzSignal) timestampedValue.getValue()).getNitzData();
        }
        return null;
    }
}
