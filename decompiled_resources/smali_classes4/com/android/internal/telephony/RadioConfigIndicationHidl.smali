.class public Lcom/android/internal/telephony/RadioConfigIndicationHidl;
.super Landroid/hardware/radio/config/V1_2/IRadioConfigIndication$Stub;
.source "RadioConfigIndicationHidl.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "RadioConfigIndicationHidl"


# instance fields
.field private final mRadioConfig:Lcom/android/internal/telephony/RadioConfig;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/RadioConfig;)V
    .locals 0

    .line 35
    invoke-direct {p0}, Landroid/hardware/radio/config/V1_2/IRadioConfigIndication$Stub;-><init>()V

    .line 36
    iput-object p1, p0, Lcom/android/internal/telephony/RadioConfigIndicationHidl;->mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    return-void
.end method

.method private static logd(Ljava/lang/String;)V
    .locals 1

    const-string v0, "RadioConfigIndicationHidl"

    .line 66
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method public simSlotsStatusChanged(ILjava/util/ArrayList;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/ArrayList<",
            "Landroid/hardware/radio/config/V1_0/SimSlotStatus;",
            ">;)V"
        }
    .end annotation

    .line 44
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertHalSlotStatus(Ljava/lang/Object;)Ljava/util/ArrayList;

    move-result-object p1

    .line 45
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "[UNSL]< UNSOL_SIM_SLOT_STATUS_CHANGED "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/util/ArrayList;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Lcom/android/internal/telephony/RadioConfigIndicationHidl;->logd(Ljava/lang/String;)V

    .line 46
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigIndicationHidl;->mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfig;->mSimSlotStatusRegistrant:Lcom/android/internal/telephony/Registrant;

    if-eqz p0, :cond_0

    .line 47
    new-instance p2, Landroid/os/AsyncResult;

    const/4 v0, 0x0

    invoke-direct {p2, v0, p1, v0}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant(Landroid/os/AsyncResult;)V

    :cond_0
    return-void
.end method

.method public simSlotsStatusChanged_1_2(ILjava/util/ArrayList;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/ArrayList<",
            "Landroid/hardware/radio/config/V1_2/SimSlotStatus;",
            ">;)V"
        }
    .end annotation

    .line 57
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertHalSlotStatus(Ljava/lang/Object;)Ljava/util/ArrayList;

    move-result-object p1

    .line 58
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "[UNSL]< UNSOL_SIM_SLOT_STATUS_CHANGED "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/util/ArrayList;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Lcom/android/internal/telephony/RadioConfigIndicationHidl;->logd(Ljava/lang/String;)V

    .line 59
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfigIndicationHidl;->mRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfig;->mSimSlotStatusRegistrant:Lcom/android/internal/telephony/Registrant;

    if-eqz p0, :cond_0

    .line 60
    new-instance p2, Landroid/os/AsyncResult;

    const/4 v0, 0x0

    invoke-direct {p2, v0, p1, v0}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant(Landroid/os/AsyncResult;)V

    :cond_0
    return-void
.end method
