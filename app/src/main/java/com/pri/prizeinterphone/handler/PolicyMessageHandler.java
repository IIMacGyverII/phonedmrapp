package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.PolicyMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class PolicyMessageHandler extends BaseMessageHandler<PolicyMessage> {
    public void handle(PolicyMessage policyMessage) {
    }

    public PolicyMessage decode(Packet packet) {
        return new PolicyMessage(packet);
    }
}
