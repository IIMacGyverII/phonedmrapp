package com.android.internal.telephony.metrics;

import com.android.internal.telephony.nano.PersistAtomsProto;
import com.android.telephony.Rlog;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

public class VoiceCallRatTracker {
    /* access modifiers changed from: private */
    public static final String TAG = "VoiceCallRatTracker";
    private Key mLastKey;
    private long mLastKeyTimestampMillis;
    private final Map<Key, Value> mRatUsageMap = new HashMap();

    VoiceCallRatTracker() {
        clear();
    }

    public static VoiceCallRatTracker fromProto(PersistAtomsProto.VoiceCallRatUsage[] voiceCallRatUsageArr) {
        VoiceCallRatTracker voiceCallRatTracker = new VoiceCallRatTracker();
        if (voiceCallRatUsageArr == null) {
            Rlog.e(TAG, "fromProto: usages=null");
        } else {
            Arrays.stream(voiceCallRatUsageArr).forEach(new VoiceCallRatTracker$$ExternalSyntheticLambda2(voiceCallRatTracker));
        }
        return voiceCallRatTracker;
    }

    public PersistAtomsProto.VoiceCallRatUsage[] toProto() {
        return (PersistAtomsProto.VoiceCallRatUsage[]) this.mRatUsageMap.entrySet().stream().map(new VoiceCallRatTracker$$ExternalSyntheticLambda0()).toArray(new VoiceCallRatTracker$$ExternalSyntheticLambda1());
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ PersistAtomsProto.VoiceCallRatUsage[] lambda$toProto$1(int i) {
        return new PersistAtomsProto.VoiceCallRatUsage[i];
    }

    public void clear() {
        this.mRatUsageMap.clear();
        this.mLastKey = null;
        this.mLastKeyTimestampMillis = 0;
    }

    public void add(int i, int i2, long j, Set<Integer> set) {
        if (this.mLastKey != null) {
            long j2 = j - this.mLastKeyTimestampMillis;
            if (j2 < 0) {
                Rlog.e(TAG, "add: durationMillis<0");
                j2 = 0;
            }
            addToKey(this.mLastKey, j2, set);
        }
        Key key = new Key(i, i2);
        addToKey(key, 0, set);
        this.mLastKey = key;
        this.mLastKeyTimestampMillis = j;
    }

    public void conclude(long j) {
        if (this.mLastKey != null) {
            long j2 = j - this.mLastKeyTimestampMillis;
            if (j2 < 0) {
                Rlog.e(TAG, "conclude: durationMillis<0");
                j2 = 0;
            }
            Value value = this.mRatUsageMap.get(this.mLastKey);
            if (value == null) {
                Rlog.e(TAG, "conclude: value=null && mLastKey!=null");
            } else {
                value.durationMillis += j2;
            }
            this.mRatUsageMap.values().stream().forEach(new VoiceCallRatTracker$$ExternalSyntheticLambda3());
            return;
        }
        Rlog.e(TAG, "conclude: mLastKey=null");
    }

    public VoiceCallRatTracker mergeWith(VoiceCallRatTracker voiceCallRatTracker) {
        if (voiceCallRatTracker == null) {
            Rlog.e(TAG, "mergeWith: attempting to merge with null", new Throwable());
        } else {
            voiceCallRatTracker.mRatUsageMap.entrySet().stream().forEach(new VoiceCallRatTracker$$ExternalSyntheticLambda4(this));
        }
        return this;
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$mergeWith$2(Map.Entry entry) {
        this.mRatUsageMap.merge((Key) entry.getKey(), (Value) entry.getValue(), new VoiceCallRatTracker$$ExternalSyntheticLambda5());
    }

    private void addToKey(Key key, long j, Set<Integer> set) {
        Value value = this.mRatUsageMap.get(key);
        if (value == null) {
            this.mRatUsageMap.put(key, new Value(j, set));
        } else {
            value.add(j, set);
        }
    }

    /* access modifiers changed from: private */
    public void addProto(PersistAtomsProto.VoiceCallRatUsage voiceCallRatUsage) {
        this.mRatUsageMap.put(Key.fromProto(voiceCallRatUsage), Value.fromProto(voiceCallRatUsage));
    }

    /* access modifiers changed from: private */
    public static PersistAtomsProto.VoiceCallRatUsage entryToProto(Map.Entry<Key, Value> entry) {
        Key key = entry.getKey();
        Value value = entry.getValue();
        PersistAtomsProto.VoiceCallRatUsage voiceCallRatUsage = new PersistAtomsProto.VoiceCallRatUsage();
        voiceCallRatUsage.carrierId = key.carrierId;
        voiceCallRatUsage.rat = key.rat;
        if (value.mConnectionIds != null) {
            Rlog.e(TAG, "call not concluded when converting to proto");
        }
        voiceCallRatUsage.totalDurationMillis = value.durationMillis;
        voiceCallRatUsage.callCount = value.callCount;
        return voiceCallRatUsage;
    }

    private static class Key {
        public final int carrierId;
        public final int rat;

        Key(int i, int i2) {
            this.carrierId = i;
            this.rat = i2;
        }

        static Key fromProto(PersistAtomsProto.VoiceCallRatUsage voiceCallRatUsage) {
            return new Key(voiceCallRatUsage.carrierId, voiceCallRatUsage.rat);
        }

        public int hashCode() {
            return Objects.hash(new Object[]{Integer.valueOf(this.carrierId), Integer.valueOf(this.rat)});
        }

        public boolean equals(Object obj) {
            if (obj == null || obj.getClass() != getClass()) {
                return false;
            }
            Key key = (Key) obj;
            if (key.carrierId == this.carrierId && key.rat == this.rat) {
                return true;
            }
            return false;
        }
    }

    private static class Value {
        public long callCount;
        public long durationMillis;
        /* access modifiers changed from: private */
        public Set<Integer> mConnectionIds;

        Value(long j, Set<Integer> set) {
            this.durationMillis = j;
            this.mConnectionIds = set;
            this.callCount = 0;
        }

        private Value(long j, long j2) {
            this.durationMillis = j;
            this.mConnectionIds = null;
            this.callCount = j2;
        }

        /* access modifiers changed from: package-private */
        public void add(long j, Set<Integer> set) {
            this.durationMillis += j;
            Set<Integer> set2 = this.mConnectionIds;
            if (set2 != null) {
                set2.addAll(set);
            } else {
                Rlog.e(VoiceCallRatTracker.TAG, "Value: trying to add to concluded call");
            }
        }

        /* access modifiers changed from: package-private */
        public void endSession() {
            if (this.mConnectionIds != null) {
                if (this.callCount != 0) {
                    Rlog.e(VoiceCallRatTracker.TAG, "Value: mConnectionIds!=null && callCount!=0");
                }
                this.callCount = (long) this.mConnectionIds.size();
                this.mConnectionIds = null;
            }
        }

        static Value fromProto(PersistAtomsProto.VoiceCallRatUsage voiceCallRatUsage) {
            return new Value(voiceCallRatUsage.totalDurationMillis, voiceCallRatUsage.callCount);
        }

        static Value mergeInPlace(Value value, Value value2) {
            if (!(value2.mConnectionIds == null && value.mConnectionIds == null)) {
                Rlog.e(VoiceCallRatTracker.TAG, "Value: call not concluded yet when merging");
            }
            value.durationMillis += value2.durationMillis;
            value.callCount += value2.callCount;
            return value;
        }
    }
}
