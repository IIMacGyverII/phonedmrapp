package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;

public class CatResponseMessage {
    public byte[] mAddedInfo = null;
    public int mAdditionalInfo = 0;
    public CommandDetails mCmdDet = null;
    public int mEventValue = -1;
    public boolean mIncludeAdditionalInfo = false;
    public ResultCode mResCode = ResultCode.OK;
    public boolean mUsersConfirm = false;
    public String mUsersInput = null;
    public int mUsersMenuSelection = 0;
    public boolean mUsersYesNoSelection = false;

    public CatResponseMessage(CatCmdMessage catCmdMessage) {
        this.mCmdDet = catCmdMessage.mCmdDet;
    }

    public void setResultCode(ResultCode resultCode) {
        this.mResCode = resultCode;
    }

    public void setMenuSelection(int i) {
        this.mUsersMenuSelection = i;
    }

    public void setInput(String str) {
        this.mUsersInput = str;
    }

    @UnsupportedAppUsage
    public void setEventDownload(int i, byte[] bArr) {
        this.mEventValue = i;
        this.mAddedInfo = bArr;
    }

    public void setYesNo(boolean z) {
        this.mUsersYesNoSelection = z;
    }

    public void setConfirmation(boolean z) {
        this.mUsersConfirm = z;
    }

    public void setAdditionalInfo(int i) {
        this.mIncludeAdditionalInfo = true;
        this.mAdditionalInfo = i;
    }

    public CommandDetails getCmdDetails() {
        return this.mCmdDet;
    }
}
