package com.android.internal.telephony.uicc.euicc.apdu;

import android.os.AsyncResult;
import android.os.Message;
import android.telephony.IccOpenLogicalChannelResponse;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.uicc.euicc.async.AsyncMessageInvocation;
import com.android.telephony.Rlog;

class OpenLogicalChannelInvocation extends AsyncMessageInvocation<String, IccOpenLogicalChannelResponse> {
    private static final String LOG_TAG = "OpenChan";
    private final CommandsInterface mCi;

    OpenLogicalChannelInvocation(CommandsInterface commandsInterface) {
        this.mCi = commandsInterface;
    }

    /* access modifiers changed from: protected */
    public void sendRequestMessage(String str, Message message) {
        this.mCi.iccOpenLogicalChannel(str, 0, message);
    }

    /* access modifiers changed from: protected */
    public IccOpenLogicalChannelResponse parseResult(AsyncResult asyncResult) {
        IccOpenLogicalChannelResponse iccOpenLogicalChannelResponse;
        Object obj;
        byte[] bArr = null;
        if (asyncResult.exception != null || (obj = asyncResult.result) == null) {
            if (asyncResult.result == null) {
                Rlog.e(LOG_TAG, "Empty response");
            }
            Throwable th = asyncResult.exception;
            if (th != null) {
                Rlog.e(LOG_TAG, "Exception", th);
            }
            int i = 4;
            Throwable th2 = asyncResult.exception;
            if (th2 instanceof CommandException) {
                CommandException.Error commandError = ((CommandException) th2).getCommandError();
                if (commandError == CommandException.Error.MISSING_RESOURCE) {
                    i = 2;
                } else if (commandError == CommandException.Error.NO_SUCH_ELEMENT) {
                    i = 3;
                }
            }
            iccOpenLogicalChannelResponse = new IccOpenLogicalChannelResponse(-1, i, (byte[]) null);
        } else {
            int[] iArr = (int[]) obj;
            int i2 = iArr[0];
            if (iArr.length > 1) {
                bArr = new byte[(iArr.length - 1)];
                for (int i3 = 1; i3 < iArr.length; i3++) {
                    bArr[i3 - 1] = (byte) iArr[i3];
                }
            }
            iccOpenLogicalChannelResponse = new IccOpenLogicalChannelResponse(i2, 1, bArr);
        }
        Rlog.v(LOG_TAG, "Response: " + iccOpenLogicalChannelResponse);
        return iccOpenLogicalChannelResponse;
    }
}
