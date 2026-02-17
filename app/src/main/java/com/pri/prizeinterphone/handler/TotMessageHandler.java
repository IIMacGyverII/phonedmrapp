package com.pri.prizeinterphone.handler;

import android.util.Log;
import com.pri.prizeinterphone.message.TotMessage;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.state.CmdStateMachine;

public class TotMessageHandler extends BaseMessageHandler<TotMessage> {
    public static final String TAG = "TAG_TotMessageHandler";

    public TotMessage decode(Packet packet) {
        return new TotMessage(packet);
    }

    public void handle(TotMessage totMessage) {
        Log.i(TAG, "handle: ");
        CmdStateMachine.getInstance().getCmdResultFromModule(totMessage);
    }
}
