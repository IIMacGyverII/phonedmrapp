package com.pri.prizeinterphone.manager;

import com.pri.prizeinterphone.serial.data.ChannelData;

public interface ChannelListener {
    void onChannelAdded(ChannelData channelData) {
    }

    void onChannelRemoved(ChannelData channelData) {
    }

    void onChannelSetResultCallBack(int i, boolean z) {
    }

    void onChannelUpdated(ChannelData channelData) {
    }
}
