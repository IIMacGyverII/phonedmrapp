package com.pri.prizeinterphone.handler;

import android.util.Log;
import com.pri.prizeinterphone.message.InitMessage;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.state.CmdStateMachine;

public class InitMessageHandler extends BaseMessageHandler<InitMessage> {
    public static final String TAG = "TAG_InitMessageHandler";

    public InitMessage decode(Packet packet) {
        return new InitMessage(packet);
    }

    public void handle(InitMessage initMessage) {
        Log.i(TAG, "handle: " + initMessage.toString());
        CmdStateMachine.getInstance().getCmdResultFromModule(initMessage);
    }
}
