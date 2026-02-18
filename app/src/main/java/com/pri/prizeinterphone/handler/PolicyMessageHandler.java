package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.PolicyMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class PolicyMessageHandler extends BaseMessageHandler<PolicyMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(PolicyMessage policyMessage) {
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public PolicyMessage decode(Packet packet) {
        return new PolicyMessage(packet);
    }
}
