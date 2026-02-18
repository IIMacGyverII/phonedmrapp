.class Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;
.super Ljava/lang/Object;
.source "RadioConfigProxy.java"

# interfaces
.implements Landroid/os/IHwBinder$DeathRecipient;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/RadioConfigProxy;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "RadioConfigHidlServiceDeathRecipient"
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "RadioConfigHidlSDR"


# instance fields
.field private final mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

.field private mService:Landroid/hardware/radio/config/V1_0/IRadioConfig;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/RadioConfig;)V
    .locals 0

    .line 270
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 271
    iput-object p1, p0, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;->mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    return-void
.end method


# virtual methods
.method public clear()V
    .locals 1

    const/4 v0, 0x0

    .line 283
    iput-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;->mService:Landroid/hardware/radio/config/V1_0/IRadioConfig;

    return-void
.end method

.method public linkToDeath(J)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 279
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;->mService:Landroid/hardware/radio/config/V1_0/IRadioConfig;

    invoke-interface {v0, p0, p1, p2}, Landroid/hardware/radio/config/V1_0/IRadioConfig;->linkToDeath(Landroid/os/IHwBinder$DeathRecipient;J)Z

    return-void
.end method

.method public serviceDied(J)V
    .locals 2

    const-string v0, "RadioConfigHidlSDR"

    const-string v1, "serviceDied"

    .line 289
    invoke-static {v0, v1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 290
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;->mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    .line 291
    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    const/4 p2, 0x1

    invoke-virtual {p0, p2, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 290
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public setService(Landroid/hardware/radio/config/V1_0/IRadioConfig;)V
    .locals 0

    .line 275
    iput-object p1, p0, Lcom/android/internal/telephony/RadioConfigProxy$RadioConfigHidlServiceDeathRecipient;->mService:Landroid/hardware/radio/config/V1_0/IRadioConfig;

    return-void
.end method
