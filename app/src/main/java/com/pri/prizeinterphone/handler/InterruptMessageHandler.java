package com.pri.prizeinterphone.handler;

import android.util.Log;
import com.pri.prizeinterphone.message.InterruptMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.state.CmdStateMachine;

public class InterruptMessageHandler extends BaseMessageHandler<InterruptMessage> {
    private static final String TAG = "InterruptMessageHandler";

    public InterruptMessage decode(Packet packet) {
        return new InterruptMessage(packet);
    }

    public void handle(InterruptMessage interruptMessage) {
        Log.d(TAG, "handle,message.packet.sr = " + Const.sRFlag2Str(interruptMessage.packet.sr));
        CmdStateMachine.getInstance().getCmdResultFromModule(interruptMessage);
    }
}
