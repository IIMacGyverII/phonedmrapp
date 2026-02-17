package com.android.internal.telephony.uicc.euicc.apdu;

import android.os.AsyncResult;
import android.os.Message;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.uicc.IccIoResult;
import com.android.internal.telephony.uicc.euicc.async.AsyncMessageInvocation;
import com.android.telephony.Rlog;

public class TransmitApduLogicalChannelInvocation extends AsyncMessageInvocation<ApduCommand, IccIoResult> {
    private static final String LOG_TAG = "TransApdu";
    private static final int SW1_ERROR = 111;
    private final CommandsInterface mCi;

    TransmitApduLogicalChannelInvocation(CommandsInterface commandsInterface) {
        this.mCi = commandsInterface;
    }

    /* access modifiers changed from: protected */
    public void sendRequestMessage(ApduCommand apduCommand, Message message) {
        Rlog.v(LOG_TAG, "Send: " + apduCommand);
        CommandsInterface commandsInterface = this.mCi;
        int i = apduCommand.channel;
        commandsInterface.iccTransmitApduLogicalChannel(i, apduCommand.cla | i, apduCommand.ins, apduCommand.p1, apduCommand.p2, apduCommand.p3, apduCommand.cmdHex, message);
    }

    /* access modifiers changed from: protected */
    public IccIoResult parseResult(AsyncResult asyncResult) {
        IccIoResult iccIoResult;
        Object obj;
        Throwable th = asyncResult.exception;
        if (th != null || (obj = asyncResult.result) == null) {
            if (asyncResult.result == null) {
                Rlog.e(LOG_TAG, "Empty response");
            } else if (th instanceof CommandException) {
                Rlog.e(LOG_TAG, "CommandException", th);
            } else {
                Rlog.e(LOG_TAG, "CommandException", th);
            }
            iccIoResult = new IccIoResult(111, 0, (byte[]) null);
        } else {
            iccIoResult = (IccIoResult) obj;
        }
        Rlog.v(LOG_TAG, "Response: " + iccIoResult);
        return iccIoResult;
    }
}
