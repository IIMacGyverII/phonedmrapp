package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.message.QueryInitMessage;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.state.CmdStateMachine;

public class QueryInitMessageHandler extends BaseMessageHandler<QueryInitMessage> {
    public QueryInitMessage decode(Packet packet) {
        return new QueryInitMessage(packet);
    }

    public void handle(QueryInitMessage queryInitMessage) {
        CmdStateMachine.getInstance().getCmdResultFromModule(queryInitMessage);
    }
}
