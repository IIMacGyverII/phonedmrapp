.class public Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;
.super Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;
.source "ImsPhone.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Builder"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder<",
        "Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;",
        ">;"
    }
.end annotation


# instance fields
.field private mIsWpsCall:Z

.field private mRetryCallFailCause:I

.field private mRetryCallFailNetworkType:I

.field private mRttTextStream:Landroid/telecom/Connection$RttTextStream;


# direct methods
.method static bridge synthetic -$$Nest$fgetmIsWpsCall(Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->mIsWpsCall:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmRetryCallFailCause(Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->mRetryCallFailCause:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmRetryCallFailNetworkType(Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->mRetryCallFailNetworkType:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmRttTextStream(Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;)Landroid/telecom/Connection$RttTextStream;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->mRttTextStream:Landroid/telecom/Connection$RttTextStream;

    return-object p0
.end method

.method public constructor <init>()V
    .locals 1

    .line 178
    invoke-direct {p0}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;-><init>()V

    const/4 v0, 0x0

    .line 180
    iput v0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->mRetryCallFailCause:I

    .line 181
    iput v0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->mRetryCallFailNetworkType:I

    .line 182
    iput-boolean v0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->mIsWpsCall:Z

    return-void
.end method

.method public static from(Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;
    .locals 3

    .line 185
    instance-of v0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;

    if-eqz v0, :cond_0

    .line 186
    new-instance v0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    invoke-direct {v0}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;-><init>()V

    iget-object v1, p0, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->uusInfo:Lcom/android/internal/telephony/UUSInfo;

    .line 187
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;->setUusInfo(Lcom/android/internal/telephony/UUSInfo;)Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->isEmergency:Z

    .line 188
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;->setIsEmergency(Z)Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    iget v1, p0, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->videoState:I

    .line 189
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;->setVideoState(I)Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    iget-object v1, p0, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->intentExtras:Landroid/os/Bundle;

    .line 190
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;->setIntentExtras(Landroid/os/Bundle;)Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    move-object v1, p0

    check-cast v1, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;

    iget-object v2, v1, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;->rttTextStream:Landroid/telecom/Connection$RttTextStream;

    .line 191
    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->setRttTextStream(Landroid/telecom/Connection$RttTextStream;)Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    move-result-object v0

    iget p0, p0, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->clirMode:I

    .line 192
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;->setClirMode(I)Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    iget v0, v1, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;->retryCallFailCause:I

    .line 193
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->setRetryCallFailCause(I)Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    move-result-object p0

    iget v0, v1, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;->retryCallFailNetworkType:I

    .line 194
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->setRetryCallFailNetworkType(I)Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    move-result-object p0

    iget-boolean v0, v1, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;->isWpsCall:Z

    .line 196
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->setIsWpsCall(Z)Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    move-result-object p0

    return-object p0

    .line 198
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    invoke-direct {v0}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;-><init>()V

    iget-object v1, p0, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->uusInfo:Lcom/android/internal/telephony/UUSInfo;

    .line 199
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;->setUusInfo(Lcom/android/internal/telephony/UUSInfo;)Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->isEmergency:Z

    .line 200
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;->setIsEmergency(Z)Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    iget v1, p0, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->videoState:I

    .line 201
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;->setVideoState(I)Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    iget v1, p0, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->clirMode:I

    .line 202
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;->setClirMode(I)Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    iget-object p0, p0, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;->intentExtras:Landroid/os/Bundle;

    .line 203
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;->setIntentExtras(Landroid/os/Bundle;)Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;

    return-object p0
.end method


# virtual methods
.method public bridge synthetic build()Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;
    .locals 0

    .line 178
    invoke-virtual {p0}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->build()Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;

    move-result-object p0

    return-object p0
.end method

.method public build()Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;
    .locals 2

    .line 228
    new-instance v0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;

    const/4 v1, 0x0

    invoke-direct {v0, p0, v1}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;-><init>(Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs-IA;)V

    return-object v0
.end method

.method public setIsWpsCall(Z)Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;
    .locals 0

    .line 223
    iput-boolean p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->mIsWpsCall:Z

    return-object p0
.end method

.method public setRetryCallFailCause(I)Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;
    .locals 0

    .line 213
    iput p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->mRetryCallFailCause:I

    return-object p0
.end method

.method public setRetryCallFailNetworkType(I)Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;
    .locals 0

    .line 218
    iput p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->mRetryCallFailNetworkType:I

    return-object p0
.end method

.method public setRttTextStream(Landroid/telecom/Connection$RttTextStream;)Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;
    .locals 0

    .line 208
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->mRttTextStream:Landroid/telecom/Connection$RttTextStream;

    return-object p0
.end method
