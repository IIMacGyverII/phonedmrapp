.class public interface abstract Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;
.super Ljava/lang/Object;
.source "TransportProtocol.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/d2d/TransportProtocol;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x609
    name = "Callback"
.end annotation


# virtual methods
.method public abstract onMessagesReceived(Ljava/util/Set;)V
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/d2d/Communicator$Message;",
            ">;)V"
        }
    .end annotation
.end method

.method public abstract onNegotiationFailed(Lcom/android/internal/telephony/d2d/TransportProtocol;)V
.end method

.method public abstract onNegotiationSuccess(Lcom/android/internal/telephony/d2d/TransportProtocol;)V
.end method
