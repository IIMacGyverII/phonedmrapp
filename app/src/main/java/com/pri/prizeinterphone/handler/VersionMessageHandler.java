package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.VersionMessage;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.state.CmdStateMachine;
/* loaded from: classes4.dex */
public class VersionMessageHandler extends BaseMessageHandler<VersionMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public VersionMessage decode(Packet packet) {
        return new VersionMessage(packet);
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(VersionMessage versionMessage) {
        DmrManager.getInstance().onVersionReceived(versionMessage);
        CmdStateMachine.getInstance().getCmdResultFromModule(versionMessage);
    }
}
