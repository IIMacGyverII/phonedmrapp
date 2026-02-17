.class public Lcom/android/internal/telephony/imsphone/ImsPhone$Cf;
.super Ljava/lang/Object;
.source "ImsPhone.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/imsphone/ImsPhone;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xc
    name = "Cf"
.end annotation


# instance fields
.field public final mIsCfu:Z

.field public final mOnComplete:Landroid/os/Message;

.field public final mSetCfNumber:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;ZLandroid/os/Message;)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 351
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 352
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$Cf;->mSetCfNumber:Ljava/lang/String;

    .line 353
    iput-boolean p2, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$Cf;->mIsCfu:Z

    .line 354
    iput-object p3, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$Cf;->mOnComplete:Landroid/os/Message;

    return-void
.end method
