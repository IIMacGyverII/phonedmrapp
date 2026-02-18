package com.pri.prizeinterphone.handler;

import android.util.Log;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.TestBiteErrorRateMessage;
import com.pri.prizeinterphone.protocol.Packet;
/* loaded from: classes4.dex */
public class TestBiteErrorRateMessageHandler extends BaseMessageHandler<TestBiteErrorRateMessage> {
    private static final String TAG = "TestBiteErrorRateMessageHandler";

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public TestBiteErrorRateMessage decode(Packet packet) {
        return new TestBiteErrorRateMessage(packet);
    }

    @Override // com.pri.prizeinterphone.handler.BaseMessageHandler
    public void handle(TestBiteErrorRateMessage testBiteErrorRateMessage) {
        Log.d(TAG, "handle");
        if (testBiteErrorRateMessage.packet != null) {
            DmrManager.getInstance().dealEvent((byte) 63, testBiteErrorRateMessage);
        }
    }
}
