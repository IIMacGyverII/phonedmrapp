package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.FetchSmsMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class FetchSmsMessageHandler extends BaseMessageHandler<FetchSmsMessage> {
    public FetchSmsMessage decode(Packet packet) {
        return new FetchSmsMessage(packet);
    }

    public void handle(FetchSmsMessage fetchSmsMessage) {
        DmrManager.getInstance().onSmsReceived(fetchSmsMessage);
    }
}
