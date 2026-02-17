package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.VersionMessage;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.state.CmdStateMachine;

public class VersionMessageHandler extends BaseMessageHandler<VersionMessage> {
    public VersionMessage decode(Packet packet) {
        return new VersionMessage(packet);
    }

    public void handle(VersionMessage versionMessage) {
        DmrManager.getInstance().onVersionReceived(versionMessage);
        CmdStateMachine.getInstance().getCmdResultFromModule(versionMessage);
    }
}
