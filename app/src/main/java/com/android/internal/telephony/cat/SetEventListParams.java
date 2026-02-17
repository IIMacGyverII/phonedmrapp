package com.android.internal.telephony.cat;

public class SetEventListParams extends CommandParams {
    public int[] mEventInfo;

    public SetEventListParams(CommandDetails commandDetails, int[] iArr) {
        super(commandDetails);
        this.mEventInfo = iArr;
    }
}
