package com.pri.prizeinterphone.handler;

import android.util.Log;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.talkbak.Talkbak;
/* loaded from: classes4.dex */
public abstract class BaseTalkbakHandler<T extends Talkbak> implements TalkbakHandler {
    public abstract T decode(Packet packet);

    public abstract void handle(T t);

    @Override // com.pri.prizeinterphone.handler.TalkbakHandler
    public void handle(Packet packet) {
        Log.i("caoshaowei", "handle packet == " + packet);
        T decode = decode(packet);
        if (decode != null) {
            decode.decode();
            handle(decode);
        }
    }
}
