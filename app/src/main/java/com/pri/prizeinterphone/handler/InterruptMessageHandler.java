package com.pri.prizeinterphone.handler;

import android.util.Log;
import com.pri.prizeinterphone.message.InterruptMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.state.CmdStateMachine;
/* loaded from: classes4.dex */
public class InterruptMessageHandler extends BaseMessageHandler<InterruptMessage> {
    private static final String TAG = "InterruptMessageHandler";

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public InterruptMessage decode(Packet packet) {
        return new InterruptMessage(packet);
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(InterruptMessage interruptMessage) {
        Log.d(TAG, "handle,message.packet.sr = " + Const.sRFlag2Str(interruptMessage.packet.sr));
        CmdStateMachine.getInstance().getCmdResultFromModule(interruptMessage);
    }
}
