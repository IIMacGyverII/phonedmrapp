.class public interface abstract Lcom/pri/prizeinterphone/manager/MessageLisenter;
.super Ljava/lang/Object;
.source "MessageLisenter.java"


# virtual methods
.method public abstract onConversationClean(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V
.end method

.method public abstract onMessageDelete(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
.end method

.method public abstract onMessageReceived()V
.end method

.method public abstract onMessageSend(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
.end method

.method public abstract onUnreadStatusUpdated()V
.end method
