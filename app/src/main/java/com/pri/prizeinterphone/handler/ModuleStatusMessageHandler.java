package com.pri.prizeinterphone.handler;

import android.util.Log;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.ModuleStatusMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.serial.SerialManager;
/* loaded from: classes4.dex */
public class ModuleStatusMessageHandler extends BaseMessageHandler<ModuleStatusMessage> {
    public static final String TAG = "TAG_ModuleStatusMessageHandler";

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public ModuleStatusMessage decode(Packet packet) {
        return new ModuleStatusMessage(packet);
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(ModuleStatusMessage moduleStatusMessage) {
        Log.i(TAG, "handle: sendAck(),message=" + Const.moduleStatus2Str(moduleStatusMessage.status));
        sendAck();
        DmrManager.getInstance().onModuleStatusReceived(moduleStatusMessage.status);
    }

    private void sendAck() {
        Packet packet = new Packet(Const.Command.MODULE_PRINT_STATUS_INFO_CMD);
        packet.rw = (byte) 1;
        packet.sr = (byte) 1;
        packet.body = new byte[]{1};
        SerialManager.getInstance().send(packet);
    }
}
