.class public Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;
.super Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;
.source "ImsPhone.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/imsphone/ImsPhone;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "ImsDialArgs"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;
    }
.end annotation


# instance fields
.field public final isWpsCall:Z

.field public final retryCallFailCause:I

.field public final retryCallFailNetworkType:I

.field public final rttTextStream:Landroid/telecom/Connection$RttTextStream;


# direct methods
.method private constructor <init>(Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;)V
    .locals 1

    .line 245
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;-><init>(Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs$Builder;)V

    .line 246
    invoke-static {p1}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->-$$Nest$fgetmRttTextStream(Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;)Landroid/telecom/Connection$RttTextStream;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;->rttTextStream:Landroid/telecom/Connection$RttTextStream;

    .line 247
    invoke-static {p1}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->-$$Nest$fgetmRetryCallFailCause(Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;)I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;->retryCallFailCause:I

    .line 248
    invoke-static {p1}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->-$$Nest$fgetmRetryCallFailNetworkType(Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;)I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;->retryCallFailNetworkType:I

    .line 249
    invoke-static {p1}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;->-$$Nest$fgetmIsWpsCall(Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;)Z

    move-result p1

    iput-boolean p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;->isWpsCall:Z

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs;-><init>(Lcom/android/internal/telephony/imsphone/ImsPhone$ImsDialArgs$Builder;)V

    return-void
.end method
