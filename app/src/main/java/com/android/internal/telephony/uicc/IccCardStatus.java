package com.android.internal.telephony.uicc;

import android.compat.annotation.UnsupportedAppUsage;
import android.telephony.SubscriptionInfo;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;

public class IccCardStatus {
    public static final int CARD_MAX_APPS = 8;
    public String atr;
    public String eid;
    public String iccid;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public IccCardApplicationStatus[] mApplications;
    @UnsupportedAppUsage
    public CardState mCardState;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int mCdmaSubscriptionAppIndex;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int mGsmUmtsSubscriptionAppIndex;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public int mImsSubscriptionAppIndex;
    public IccSlotPortMapping mSlotPortMapping;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public PinState mUniversalPinState;

    public enum CardState {
        CARDSTATE_ABSENT,
        CARDSTATE_PRESENT,
        CARDSTATE_ERROR,
        CARDSTATE_RESTRICTED;

        @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
        public boolean isCardPresent() {
            return this == CARDSTATE_PRESENT || this == CARDSTATE_RESTRICTED;
        }
    }

    public enum PinState {
        PINSTATE_UNKNOWN,
        PINSTATE_ENABLED_NOT_VERIFIED,
        PINSTATE_ENABLED_VERIFIED,
        PINSTATE_DISABLED,
        PINSTATE_ENABLED_BLOCKED,
        PINSTATE_ENABLED_PERM_BLOCKED;

        /* access modifiers changed from: package-private */
        public boolean isPermBlocked() {
            return this == PINSTATE_ENABLED_PERM_BLOCKED;
        }

        /* access modifiers changed from: package-private */
        public boolean isPinRequired() {
            return this == PINSTATE_ENABLED_NOT_VERIFIED;
        }

        /* access modifiers changed from: package-private */
        public boolean isPukRequired() {
            return this == PINSTATE_ENABLED_BLOCKED;
        }
    }

    public void setCardState(int i) {
        if (i == 0) {
            this.mCardState = CardState.CARDSTATE_ABSENT;
        } else if (i == 1) {
            this.mCardState = CardState.CARDSTATE_PRESENT;
        } else if (i == 2) {
            this.mCardState = CardState.CARDSTATE_ERROR;
        } else if (i == 3) {
            this.mCardState = CardState.CARDSTATE_RESTRICTED;
        } else {
            throw new RuntimeException("Unrecognized RIL_CardState: " + i);
        }
    }

    public void setUniversalPinState(int i) {
        if (i == 0) {
            this.mUniversalPinState = PinState.PINSTATE_UNKNOWN;
        } else if (i == 1) {
            this.mUniversalPinState = PinState.PINSTATE_ENABLED_NOT_VERIFIED;
        } else if (i == 2) {
            this.mUniversalPinState = PinState.PINSTATE_ENABLED_VERIFIED;
        } else if (i == 3) {
            this.mUniversalPinState = PinState.PINSTATE_DISABLED;
        } else if (i == 4) {
            this.mUniversalPinState = PinState.PINSTATE_ENABLED_BLOCKED;
        } else if (i == 5) {
            this.mUniversalPinState = PinState.PINSTATE_ENABLED_PERM_BLOCKED;
        } else {
            throw new RuntimeException("Unrecognized RIL_PinState: " + i);
        }
    }

    public String toString() {
        int i;
        int i2;
        int i3;
        StringBuilder sb = new StringBuilder();
        sb.append("IccCardState {");
        sb.append(this.mCardState);
        sb.append(",");
        sb.append(this.mUniversalPinState);
        if (this.mApplications != null) {
            sb.append(",num_apps=");
            sb.append(this.mApplications.length);
        } else {
            sb.append(",mApplications=null");
        }
        sb.append(",gsm_id=");
        sb.append(this.mGsmUmtsSubscriptionAppIndex);
        Object[] objArr = this.mApplications;
        Object obj = "null";
        if (objArr != null && (i3 = this.mGsmUmtsSubscriptionAppIndex) >= 0 && i3 < objArr.length) {
            Object obj2 = objArr[i3];
            if (obj2 == null) {
                obj2 = obj;
            }
            sb.append(obj2);
        }
        sb.append(",cdma_id=");
        sb.append(this.mCdmaSubscriptionAppIndex);
        Object[] objArr2 = this.mApplications;
        if (objArr2 != null && (i2 = this.mCdmaSubscriptionAppIndex) >= 0 && i2 < objArr2.length) {
            Object obj3 = objArr2[i2];
            if (obj3 == null) {
                obj3 = obj;
            }
            sb.append(obj3);
        }
        sb.append(",ims_id=");
        sb.append(this.mImsSubscriptionAppIndex);
        Object[] objArr3 = this.mApplications;
        if (objArr3 != null && (i = this.mImsSubscriptionAppIndex) >= 0 && i < objArr3.length) {
            Object obj4 = objArr3[i];
            if (obj4 != null) {
                obj = obj4;
            }
            sb.append(obj);
        }
        sb.append(",atr=");
        sb.append(this.atr);
        sb.append(",iccid=");
        sb.append(SubscriptionInfo.givePrintableIccid(this.iccid));
        sb.append(",eid=");
        sb.append(Rlog.pii(TelephonyUtils.IS_DEBUGGABLE, this.eid));
        sb.append(",SlotPortMapping=");
        sb.append(this.mSlotPortMapping);
        sb.append("}");
        return sb.toString();
    }
}
