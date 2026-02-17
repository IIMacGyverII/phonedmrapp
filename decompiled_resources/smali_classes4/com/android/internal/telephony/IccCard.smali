.class public Lcom/android/internal/telephony/IccCard;
.super Ljava/lang/Object;
.source "IccCard.java"


# instance fields
.field private mIccCardState:Lcom/android/internal/telephony/IccCardConstants$State;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 50
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 45
    sget-object v0, Lcom/android/internal/telephony/IccCardConstants$State;->UNKNOWN:Lcom/android/internal/telephony/IccCardConstants$State;

    iput-object v0, p0, Lcom/android/internal/telephony/IccCard;->mIccCardState:Lcom/android/internal/telephony/IccCardConstants$State;

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/IccCardConstants$State;)V
    .locals 1

    .line 55
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 45
    sget-object v0, Lcom/android/internal/telephony/IccCardConstants$State;->UNKNOWN:Lcom/android/internal/telephony/IccCardConstants$State;

    .line 56
    iput-object p1, p0, Lcom/android/internal/telephony/IccCard;->mIccCardState:Lcom/android/internal/telephony/IccCardConstants$State;

    return-void
.end method

.method private sendMessageWithCardAbsentException(Landroid/os/Message;)V
    .locals 2

    .line 303
    invoke-static {p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;)Landroid/os/AsyncResult;

    move-result-object p0

    .line 304
    new-instance v0, Ljava/lang/RuntimeException;

    const-string v1, "No valid IccCard"

    invoke-direct {v0, v1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    .line 305
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method


# virtual methods
.method public changeIccFdnPassword(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
    .locals 0

    .line 242
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/IccCard;->sendMessageWithCardAbsentException(Landroid/os/Message;)V

    return-void
.end method

.method public changeIccLockPassword(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
    .locals 0

    .line 226
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/IccCard;->sendMessageWithCardAbsentException(Landroid/os/Message;)V

    return-void
.end method

.method public getIccCardType()Ljava/lang/String;
    .locals 0

    const/4 p0, 0x0

    return-object p0
.end method

.method public getIccFdnAvailable()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getIccFdnEnabled()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getIccLockEnabled()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getIccPin2Blocked()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getIccPuk2Blocked()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getIccRecords()Lcom/android/internal/telephony/uicc/IccRecords;
    .locals 0

    const/4 p0, 0x0

    return-object p0
.end method

.method public getServiceProviderName()Ljava/lang/String;
    .locals 0

    const/4 p0, 0x0

    return-object p0
.end method

.method public getState()Lcom/android/internal/telephony/IccCardConstants$State;
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 64
    iget-object p0, p0, Lcom/android/internal/telephony/IccCard;->mIccCardState:Lcom/android/internal/telephony/IccCardConstants$State;

    return-object p0
.end method

.method public hasIccCard()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public iccExchangeSimIOEx(IIIIILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public iccGetAtr(Landroid/os/Message;)V
    .locals 0

    return-void
.end method

.method public isApplicationOnIcc(Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public isEmptyProfile()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public registerForFdnChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0

    return-void
.end method

.method public registerForNetworkLocked(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation

    return-void
.end method

.method public repollIccStateForModemSmlChangeFeatrue(Z)V
    .locals 0

    return-void
.end method

.method public setIccFdnEnabled(ZLjava/lang/String;Landroid/os/Message;)V
    .locals 0

    .line 210
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/IccCard;->sendMessageWithCardAbsentException(Landroid/os/Message;)V

    return-void
.end method

.method public setIccLockEnabled(ZLjava/lang/String;Landroid/os/Message;)V
    .locals 0

    .line 194
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/IccCard;->sendMessageWithCardAbsentException(Landroid/os/Message;)V

    return-void
.end method

.method public supplyNetworkDepersonalization(Ljava/lang/String;Landroid/os/Message;)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 139
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/IccCard;->sendMessageWithCardAbsentException(Landroid/os/Message;)V

    return-void
.end method

.method public supplyPin(Ljava/lang/String;Landroid/os/Message;)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation

    .line 109
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/IccCard;->sendMessageWithCardAbsentException(Landroid/os/Message;)V

    return-void
.end method

.method public supplyPin2(Ljava/lang/String;Landroid/os/Message;)V
    .locals 0

    .line 124
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/IccCard;->sendMessageWithCardAbsentException(Landroid/os/Message;)V

    return-void
.end method

.method public supplyPuk(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation

    .line 117
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/IccCard;->sendMessageWithCardAbsentException(Landroid/os/Message;)V

    return-void
.end method

.method public supplyPuk2(Ljava/lang/String;Ljava/lang/String;Landroid/os/Message;)V
    .locals 0

    .line 131
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/IccCard;->sendMessageWithCardAbsentException(Landroid/os/Message;)V

    return-void
.end method

.method public supplySimDepersonalization(Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$PersoSubState;Ljava/lang/String;Landroid/os/Message;)V
    .locals 0

    .line 147
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/IccCard;->sendMessageWithCardAbsentException(Landroid/os/Message;)V

    return-void
.end method

.method public unregisterForFdnChanged(Landroid/os/Handler;)V
    .locals 0

    return-void
.end method

.method public unregisterForNetworkLocked(Landroid/os/Handler;)V
    .locals 0

    return-void
.end method
