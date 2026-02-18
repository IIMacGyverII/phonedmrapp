.class public interface abstract Lcom/android/internal/telephony/d2d/TransportProtocol;
.super Ljava/lang/Object;
.source "TransportProtocol.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;
    }
.end annotation


# virtual methods
.method public abstract forceNegotiated()V
.end method

.method public abstract forceNotNegotiated()V
.end method

.method public abstract sendMessages(Ljava/util/Set;)V
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/d2d/Communicator$Message;",
            ">;)V"
        }
    .end annotation
.end method

.method public abstract setCallback(Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;)V
.end method

.method public abstract startNegotiation()V
.end method
