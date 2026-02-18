package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.QueryInitMessage;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.state.CmdStateMachine;
/* loaded from: classes4.dex */
public class QueryInitMessageHandler extends BaseMessageHandler<QueryInitMessage> {
    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public QueryInitMessage decode(Packet packet) {
        return new QueryInitMessage(packet);
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(QueryInitMessage queryInitMessage) {
        CmdStateMachine.getInstance().getCmdResultFromModule(queryInitMessage);
    }
}
