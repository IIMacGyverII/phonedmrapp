package com.android.internal.telephony.nitz;

import android.content.Context;
import android.os.PowerManager;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.NitzData;
import com.android.internal.telephony.NitzSignal;
import com.android.internal.telephony.NitzStateMachine;
import com.android.internal.telephony.nitz.NitzStateMachineImpl;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.util.Arrays;
import java.util.Objects;

@VisibleForTesting
public final class NitzSignalInputFilterPredicateFactory {
    private static final boolean DBG = true;
    private static final String LOG_TAG = "NitzStateMachineImpl";
    private static final String WAKELOCK_TAG = "NitzSignalInputFilterPredicateFactory";

    @FunctionalInterface
    @VisibleForTesting
    public interface TrivalentPredicate {
        Boolean mustProcessNitzSignal(NitzSignal nitzSignal, NitzSignal nitzSignal2);
    }

    private NitzSignalInputFilterPredicateFactory() {
    }

    public static NitzStateMachineImpl.NitzSignalInputFilterPredicate create(Context context, NitzStateMachine.DeviceState deviceState) {
        Objects.requireNonNull(context);
        Objects.requireNonNull(deviceState);
        return new NitzSignalInputFilterPredicateImpl(new TrivalentPredicate[]{createIgnoreNitzPropertyCheck(deviceState), createBogusElapsedRealtimeCheck(context, deviceState), createNoOldSignalCheck(), createRateLimitCheck(deviceState)});
    }

    @VisibleForTesting
    public static TrivalentPredicate createIgnoreNitzPropertyCheck(NitzStateMachine.DeviceState deviceState) {
        return new NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda1(deviceState);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ Boolean lambda$createIgnoreNitzPropertyCheck$0(NitzStateMachine.DeviceState deviceState, NitzSignal nitzSignal, NitzSignal nitzSignal2) {
        if (!deviceState.getIgnoreNitz()) {
            return null;
        }
        Rlog.d(LOG_TAG, "mustProcessNitzSignal: Not processing NITZ signal because gsm.ignore-nitz is set");
        return Boolean.FALSE;
    }

    @VisibleForTesting
    public static TrivalentPredicate createBogusElapsedRealtimeCheck(Context context, NitzStateMachine.DeviceState deviceState) {
        return new NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda0(((PowerManager) context.getSystemService(XmlTagConst.TAG_POWER)).newWakeLock(1, WAKELOCK_TAG), deviceState);
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ Boolean lambda$createBogusElapsedRealtimeCheck$1(PowerManager.WakeLock wakeLock, NitzStateMachine.DeviceState deviceState, NitzSignal nitzSignal, NitzSignal nitzSignal2) {
        Objects.requireNonNull(nitzSignal2);
        try {
            wakeLock.acquire();
            long elapsedRealtimeMillis = deviceState.elapsedRealtimeMillis();
            long receiptElapsedRealtimeMillis = elapsedRealtimeMillis - nitzSignal2.getReceiptElapsedRealtimeMillis();
            if (receiptElapsedRealtimeMillis < 0 || receiptElapsedRealtimeMillis > 2147483647L) {
                Rlog.d(LOG_TAG, "mustProcessNitzSignal: Not processing NITZ signal because unexpected elapsedRealtime=" + elapsedRealtimeMillis + " nitzSignal=" + nitzSignal2);
                Boolean bool = Boolean.FALSE;
                wakeLock.release();
                return bool;
            }
            return null;
        } finally {
            wakeLock.release();
        }
    }

    @VisibleForTesting
    public static TrivalentPredicate createNoOldSignalCheck() {
        return new NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda2();
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ Boolean lambda$createNoOldSignalCheck$2(NitzSignal nitzSignal, NitzSignal nitzSignal2) {
        if (nitzSignal == null) {
            return Boolean.TRUE;
        }
        return null;
    }

    @VisibleForTesting
    public static TrivalentPredicate createRateLimitCheck(final NitzStateMachine.DeviceState deviceState) {
        return new TrivalentPredicate() {
            public Boolean mustProcessNitzSignal(NitzSignal nitzSignal, NitzSignal nitzSignal2) {
                Objects.requireNonNull(nitzSignal2);
                Objects.requireNonNull(nitzSignal2.getNitzData());
                Objects.requireNonNull(nitzSignal);
                Objects.requireNonNull(nitzSignal.getNitzData());
                NitzData nitzData = nitzSignal2.getNitzData();
                NitzData nitzData2 = nitzSignal.getNitzData();
                if (!offsetInfoIsTheSame(nitzData2, nitzData)) {
                    return Boolean.TRUE;
                }
                int nitzUpdateSpacingMillis = NitzStateMachine.DeviceState.this.getNitzUpdateSpacingMillis();
                if (nitzSignal2.getReceiptElapsedRealtimeMillis() - nitzSignal.getReceiptElapsedRealtimeMillis() > ((long) nitzUpdateSpacingMillis)) {
                    return Boolean.TRUE;
                }
                int nitzUpdateDiffMillis = NitzStateMachine.DeviceState.this.getNitzUpdateDiffMillis();
                if (Math.abs((nitzData.getCurrentTimeInMillis() - nitzData2.getCurrentTimeInMillis()) - (nitzSignal2.getAgeAdjustedElapsedRealtimeMillis() - nitzSignal.getAgeAdjustedElapsedRealtimeMillis())) > ((long) nitzUpdateDiffMillis)) {
                    return Boolean.TRUE;
                }
                Rlog.d(NitzSignalInputFilterPredicateFactory.LOG_TAG, "mustProcessNitzSignal: NITZ signal filtered previousSignal=" + nitzSignal + ", newSignal=" + nitzSignal2 + ", nitzUpdateSpacing=" + nitzUpdateSpacingMillis + ", nitzUpdateDiff=" + nitzUpdateDiffMillis);
                return Boolean.FALSE;
            }

            private boolean offsetInfoIsTheSame(NitzData nitzData, NitzData nitzData2) {
                return Objects.equals(nitzData2.getDstAdjustmentMillis(), nitzData.getDstAdjustmentMillis()) && Objects.equals(nitzData2.getEmulatorHostTimeZone(), nitzData.getEmulatorHostTimeZone()) && nitzData2.getLocalOffsetMillis() == nitzData.getLocalOffsetMillis();
            }
        };
    }

    @VisibleForTesting
    public static class NitzSignalInputFilterPredicateImpl implements NitzStateMachineImpl.NitzSignalInputFilterPredicate {
        private final TrivalentPredicate[] mComponents;

        @VisibleForTesting
        public NitzSignalInputFilterPredicateImpl(TrivalentPredicate[] trivalentPredicateArr) {
            this.mComponents = (TrivalentPredicate[]) Arrays.copyOf(trivalentPredicateArr, trivalentPredicateArr.length);
        }

        public boolean mustProcessNitzSignal(NitzSignal nitzSignal, NitzSignal nitzSignal2) {
            Objects.requireNonNull(nitzSignal2);
            for (TrivalentPredicate mustProcessNitzSignal : this.mComponents) {
                Boolean mustProcessNitzSignal2 = mustProcessNitzSignal.mustProcessNitzSignal(nitzSignal, nitzSignal2);
                if (mustProcessNitzSignal2 != null) {
                    return mustProcessNitzSignal2.booleanValue();
                }
            }
            return true;
        }
    }
}
