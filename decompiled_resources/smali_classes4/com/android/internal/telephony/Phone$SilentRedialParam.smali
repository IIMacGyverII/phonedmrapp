.class public Lcom/android/internal/telephony/Phone$SilentRedialParam;
.super Ljava/lang/Object;
.source "Phone.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/Phone;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "SilentRedialParam"
.end annotation


# instance fields
.field public causeCode:I

.field public dialArgs:Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;

.field public dialString:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;ILcom/android/internal/telephony/PhoneInternalInterface$DialArgs;)V
    .locals 0

    .line 298
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 299
    iput-object p1, p0, Lcom/android/internal/telephony/Phone$SilentRedialParam;->dialString:Ljava/lang/String;

    .line 300
    iput p2, p0, Lcom/android/internal/telephony/Phone$SilentRedialParam;->causeCode:I

    .line 301
    iput-object p3, p0, Lcom/android/internal/telephony/Phone$SilentRedialParam;->dialArgs:Lcom/android/internal/telephony/PhoneInternalInterface$DialArgs;

    return-void
.end method
