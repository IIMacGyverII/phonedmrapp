.class public interface abstract Lcom/pri/prizeinterphone/ymodem/YModemThread$OnSendReceiveDataListener;
.super Ljava/lang/Object;
.source "YModemThread.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/ymodem/YModemThread;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x609
    name = "OnSendReceiveDataListener"
.end annotation


# virtual methods
.method public abstract onReceiveDataError(Ljava/lang/String;)V
.end method

.method public abstract onReceiveDataSuccess([B)V
.end method

.method public abstract onSendDataError([BLjava/lang/String;)V
.end method

.method public abstract onSendDataSuccess([B)V
.end method
