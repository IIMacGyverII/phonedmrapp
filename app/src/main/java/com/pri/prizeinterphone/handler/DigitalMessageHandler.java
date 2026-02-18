package com.pri.prizeinterphone.handler;

import android.util.Log;
import com.pri.prizeinterphone.message.DigitalMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.state.CmdStateMachine;
/* loaded from: classes4.dex */
public class DigitalMessageHandler extends BaseMessageHandler<DigitalMessage> {
    public static final String TAG = "TAG_DigitalMessageHandler";

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public DigitalMessage decode(Packet packet) {
        return new DigitalMessage(packet);
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(DigitalMessage digitalMessage) {
        Log.i(TAG, "handle: " + digitalMessage.toString() + ",sr=" + Const.sRFlag2Str(digitalMessage.packet.sr));
        CmdStateMachine.getInstance().getCmdResultFromModule(digitalMessage);
    }
}
