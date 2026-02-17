package com.pri.prizeinterphone.handler;

import com.pri.prizeinterphone.PrizeInterPhoneApp;
import com.pri.prizeinterphone.Util.Clog;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.EnhanceMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;

public class EnhanceMessageHandler extends BaseMessageHandler<EnhanceMessage> {
    private static final String TAG = "EnhanceMessageHandler";

    public EnhanceMessage decode(Packet packet) {
        return new EnhanceMessage(packet);
    }

    public void handle(EnhanceMessage enhanceMessage) {
        Clog.d(TAG, "handle,message.fun=" + enhanceMessage.fun + ",message.packet.sr=" + enhanceMessage.packet.sr);
        byte b = enhanceMessage.fun;
        if (b == 4) {
            PersonSharePrefData.putIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_IS_ALREADY_KILL, 1);
        } else if (b == 5) {
            PersonSharePrefData.putIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_IS_ALREADY_KILL, 0);
        }
        DmrManager.getInstance().dealEvent(Const.Command.SET_ENHANCE_FUNCTION_CMD, enhanceMessage);
    }
}
