.class public Lcom/android/internal/telephony/cat/IconId;
.super Lcom/android/internal/telephony/cat/ValueObject;
.source "IconId.java"


# instance fields
.field public recordNumber:I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field public selfExplanatory:Z


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 22
    invoke-direct {p0}, Lcom/android/internal/telephony/cat/ValueObject;-><init>()V

    return-void
.end method


# virtual methods
.method getTag()Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .locals 0

    .line 29
    sget-object p0, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->ICON_ID:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    return-object p0
.end method
