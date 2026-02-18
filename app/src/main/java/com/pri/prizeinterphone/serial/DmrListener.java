package com.pri.prizeinterphone.serial;

import com.pri.prizeinterphone.message.FetchSmsMessage;
import com.pri.prizeinterphone.message.VersionMessage;
/* loaded from: classes4.dex */
public interface DmrListener {
    void onModuleStatusReceived(byte b);

    void onSmsReceived(FetchSmsMessage fetchSmsMessage);

    void onVersionReceived(VersionMessage versionMessage);
}
