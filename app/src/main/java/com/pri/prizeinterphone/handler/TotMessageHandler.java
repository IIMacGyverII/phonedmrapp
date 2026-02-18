package com.pri.prizeinterphone.handler;

import android.util.Log;
import com.pri.prizeinterphone.message.TotMessage;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.state.CmdStateMachine;
/* loaded from: classes4.dex */
public class TotMessageHandler extends BaseMessageHandler<TotMessage> {
    public static final String TAG = "TAG_TotMessageHandler";

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public TotMessage decode(Packet packet) {
        return new TotMessage(packet);
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(TotMessage totMessage) {
        Log.i(TAG, "handle: ");
        CmdStateMachine.getInstance().getCmdResultFromModule(totMessage);
    }
}
