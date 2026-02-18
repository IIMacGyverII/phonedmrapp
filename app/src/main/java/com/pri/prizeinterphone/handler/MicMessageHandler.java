package com.pri.prizeinterphone.handler;

import android.util.Log;
import com.pri.prizeinterphone.message.MicMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.state.CmdStateMachine;
/* loaded from: classes4.dex */
public class MicMessageHandler extends BaseMessageHandler<MicMessage> {
    public static final String TAG = "MicMessageHandler";

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public MicMessage decode(Packet packet) {
        return new MicMessage(packet);
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(MicMessage micMessage) {
        Log.i(TAG, "handle: " + micMessage.toString() + ",sr=" + Const.sRFlag2Str(micMessage.packet.sr));
        CmdStateMachine.getInstance().getCmdResultFromModule(micMessage);
    }
}
