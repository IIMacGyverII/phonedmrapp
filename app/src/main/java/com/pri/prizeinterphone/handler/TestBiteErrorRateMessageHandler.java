package com.pri.prizeinterphone.handler;

import android.util.Log;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.TestBiteErrorRateMessage;
import com.pri.prizeinterphone.protocol.Packet;

public class TestBiteErrorRateMessageHandler extends BaseMessageHandler<TestBiteErrorRateMessage> {
    private static final String TAG = "TestBiteErrorRateMessageHandler";

    public TestBiteErrorRateMessage decode(Packet packet) {
        return new TestBiteErrorRateMessage(packet);
    }

    public void handle(TestBiteErrorRateMessage testBiteErrorRateMessage) {
        Log.d(TAG, "handle");
        if (testBiteErrorRateMessage.packet != null) {
            DmrManager.getInstance().dealEvent((byte) 63, testBiteErrorRateMessage);
        }
    }
}
