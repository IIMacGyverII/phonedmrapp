package com.pri.prizeinterphone.handler;

import android.util.Log;
import com.pri.prizeinterphone.message.AnalogMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.state.CmdStateMachine;

public class AnalogMessageHandler extends BaseMessageHandler<AnalogMessage> {
    private static final String TAG = "AnalogMessageHandler";

    public AnalogMessage decode(Packet packet) {
        return new AnalogMessage(packet);
    }

    public void handle(AnalogMessage analogMessage) {
        Log.i(TAG, "handle: " + analogMessage.toString() + ",sr=" + Const.sRFlag2Str(analogMessage.packet.sr));
        CmdStateMachine.getInstance().getCmdResultFromModule(analogMessage);
    }
}
