package com.android.internal.telephony.dataconnection;

import com.android.internal.annotations.VisibleForTesting;
import java.util.HashSet;
import java.util.Iterator;

public class DataConnectionReasons {
    private DataAllowedReasonType mDataAllowedReason = DataAllowedReasonType.NONE;
    private HashSet<DataDisallowedReasonType> mDataDisallowedReasonSet = new HashSet<>();

    enum DataAllowedReasonType {
        NONE,
        NORMAL,
        UNMETERED_APN,
        RESTRICTED_REQUEST,
        EMERGENCY_APN
    }

    /* access modifiers changed from: package-private */
    public void add(DataDisallowedReasonType dataDisallowedReasonType) {
        this.mDataAllowedReason = DataAllowedReasonType.NONE;
        this.mDataDisallowedReasonSet.add(dataDisallowedReasonType);
    }

    /* access modifiers changed from: package-private */
    public void add(DataAllowedReasonType dataAllowedReasonType) {
        this.mDataDisallowedReasonSet.clear();
        if (dataAllowedReasonType.ordinal() > this.mDataAllowedReason.ordinal()) {
            this.mDataAllowedReason = dataAllowedReasonType;
        }
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        if (this.mDataDisallowedReasonSet.size() > 0) {
            sb.append("Data disallowed reasons:");
            Iterator<DataDisallowedReasonType> it = this.mDataDisallowedReasonSet.iterator();
            while (it.hasNext()) {
                sb.append(" ");
                sb.append(it.next());
            }
        } else {
            sb.append("Data allowed reason:");
            sb.append(" ");
            sb.append(this.mDataAllowedReason);
        }
        return sb.toString();
    }

    /* access modifiers changed from: package-private */
    public void copyFrom(DataConnectionReasons dataConnectionReasons) {
        this.mDataDisallowedReasonSet = dataConnectionReasons.mDataDisallowedReasonSet;
        this.mDataAllowedReason = dataConnectionReasons.mDataAllowedReason;
    }

    /* access modifiers changed from: package-private */
    public boolean allowed() {
        return this.mDataDisallowedReasonSet.size() == 0;
    }

    @VisibleForTesting
    public boolean contains(DataDisallowedReasonType dataDisallowedReasonType) {
        return this.mDataDisallowedReasonSet.contains(dataDisallowedReasonType);
    }

    public boolean containsOnly(DataDisallowedReasonType dataDisallowedReasonType) {
        return this.mDataDisallowedReasonSet.size() == 1 && contains(dataDisallowedReasonType);
    }

    /* access modifiers changed from: package-private */
    public boolean contains(DataAllowedReasonType dataAllowedReasonType) {
        return dataAllowedReasonType == this.mDataAllowedReason;
    }

    /* access modifiers changed from: package-private */
    public boolean containsHardDisallowedReasons() {
        Iterator<DataDisallowedReasonType> it = this.mDataDisallowedReasonSet.iterator();
        while (it.hasNext()) {
            if (it.next().isHardReason()) {
                return true;
            }
        }
        return false;
    }

    public enum DataDisallowedReasonType {
        DATA_DISABLED(false),
        ROAMING_DISABLED(false),
        DEFAULT_DATA_UNSELECTED(false),
        NOT_ATTACHED(true),
        SIM_NOT_READY(true),
        INVALID_PHONE_STATE(true),
        CONCURRENT_VOICE_DATA_NOT_ALLOWED(true),
        PS_RESTRICTED(true),
        UNDESIRED_POWER_STATE(true),
        INTERNAL_DATA_DISABLED(true),
        RADIO_DISABLED_BY_CARRIER(true),
        APN_NOT_CONNECTABLE(true),
        DATA_IS_CONNECTING(true),
        DATA_IS_DISCONNECTING(true),
        DATA_ALREADY_CONNECTED(true),
        ON_IWLAN(true),
        NOT_ON_NR(true),
        IN_ECBM(true),
        ON_OTHER_TRANSPORT(true),
        DATA_SERVICE_NOT_READY(true),
        DISABLED_BY_QNS(true),
        DATA_THROTTLED(true);
        
        private boolean mIsHardReason;

        /* access modifiers changed from: package-private */
        public boolean isHardReason() {
            return this.mIsHardReason;
        }

        private DataDisallowedReasonType(boolean z) {
            this.mIsHardReason = z;
        }
    }
}
