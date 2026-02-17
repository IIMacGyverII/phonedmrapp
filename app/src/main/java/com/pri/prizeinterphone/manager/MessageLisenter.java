package com.pri.prizeinterphone.manager;

import com.pri.prizeinterphone.serial.data.ConversationData;
import com.pri.prizeinterphone.serial.data.MessageData;

public interface MessageLisenter {
    void onConversationClean(ConversationData conversationData);

    void onMessageDelete(MessageData messageData);

    void onMessageReceived();

    void onMessageSend(MessageData messageData);

    void onUnreadStatusUpdated();
}
