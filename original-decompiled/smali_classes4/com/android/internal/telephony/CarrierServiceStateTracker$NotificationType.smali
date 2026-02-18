.class public interface abstract Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;
.super Ljava/lang/Object;
.source "CarrierServiceStateTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/CarrierServiceStateTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x609
    name = "NotificationType"
.end annotation


# virtual methods
.method public abstract getDelay()I
.end method

.method public abstract getNotificationBuilder()Landroid/app/Notification$Builder;
.end method

.method public abstract getNotificationId()I
.end method

.method public abstract getNotificationTag()Ljava/lang/String;
.end method

.method public abstract getTypeId()I
.end method

.method public abstract sendMessage()Z
.end method

.method public abstract setDelay(Landroid/os/PersistableBundle;)V
.end method
