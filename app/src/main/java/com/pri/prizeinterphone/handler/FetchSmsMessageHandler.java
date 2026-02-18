package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.FetchSmsMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class FetchSmsMessageHandler extends BaseMessageHandler<FetchSmsMessage> {
    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public FetchSmsMessage decode(Packet packet) {
        return new FetchSmsMessage(packet);
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(FetchSmsMessage fetchSmsMessage) {
        DmrManager.getInstance().onSmsReceived(fetchSmsMessage);
    }
}
