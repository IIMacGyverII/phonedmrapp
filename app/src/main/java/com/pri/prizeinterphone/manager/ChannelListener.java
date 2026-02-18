package com.pri.prizeinterphone.manager;

import com.pri.prizeinterphone.serial.data.ChannelData;
/* loaded from: classes4.dex */
public interface ChannelListener {
    default void onChannelAdded(ChannelData channelData) {
    }

    default void onChannelRemoved(ChannelData channelData) {
    }

    default void onChannelSetResultCallBack(int i, boolean z) {
    }

    default void onChannelUpdated(ChannelData channelData) {
    }
}
