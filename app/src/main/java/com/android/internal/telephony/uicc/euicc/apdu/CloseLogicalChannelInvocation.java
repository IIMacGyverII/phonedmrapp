package com.android.internal.telephony.uicc.euicc.apdu;

import android.os.AsyncResult;
import android.os.Message;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.uicc.euicc.async.AsyncMessageInvocation;
import com.android.telephony.Rlog;

class CloseLogicalChannelInvocation extends AsyncMessageInvocation<Integer, Boolean> {
    private static final String LOG_TAG = "CloseChan";
    private final CommandsInterface mCi;

    CloseLogicalChannelInvocation(CommandsInterface commandsInterface) {
        this.mCi = commandsInterface;
    }

    /* access modifiers changed from: protected */
    public void sendRequestMessage(Integer num, Message message) {
        Rlog.v(LOG_TAG, "Channel: " + num);
        this.mCi.iccCloseLogicalChannel(num.intValue(), message);
    }

    /* access modifiers changed from: protected */
    public Boolean parseResult(AsyncResult asyncResult) {
        Throwable th = asyncResult.exception;
        if (th == null) {
            return Boolean.TRUE;
        }
        if (th instanceof CommandException) {
            Rlog.e(LOG_TAG, "CommandException", th);
        } else {
            Rlog.e(LOG_TAG, "Unknown exception", th);
        }
        return Boolean.FALSE;
    }
}
