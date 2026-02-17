package com.pri.prizeinterphone.handler;

import android.util.Log;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.talkbak.Talkbak;

public abstract class BaseTalkbakHandler<T extends Talkbak> implements TalkbakHandler {
    public abstract T decode(Packet packet);

    public abstract void handle(T t);

    public void handle(Packet packet) {
        Log.i("caoshaowei", "handle packet == " + packet);
        Talkbak decode = decode(packet);
        if (decode != null) {
            decode.decode();
            handle(decode);
        }
    }
}
