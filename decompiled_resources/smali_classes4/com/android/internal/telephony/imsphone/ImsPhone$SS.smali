.class public Lcom/android/internal/telephony/imsphone/ImsPhone$SS;
.super Ljava/lang/Object;
.source "ImsPhone.java"


# annotations
.annotation build Lcom/android/internal/annotations/VisibleForTesting;
.end annotation

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/imsphone/ImsPhone;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "SS"
.end annotation


# instance fields
.field mCfAction:I

.field public mCfReason:I

.field mClirMode:I

.field public mDialingNumber:Ljava/lang/String;

.field mEnable:Z

.field mFacility:Ljava/lang/String;

.field mLockState:Z

.field public mOnComplete:Landroid/os/Message;
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field mPassword:Ljava/lang/String;

.field public mServiceClass:I

.field mTimerSeconds:I


# direct methods
.method constructor <init>(IILandroid/os/Message;)V
    .locals 0

    .line 403
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 404
    iput p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mCfReason:I

    .line 405
    iput p2, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mServiceClass:I

    .line 406
    iput-object p3, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mOnComplete:Landroid/os/Message;

    return-void
.end method

.method constructor <init>(IILjava/lang/String;IILandroid/os/Message;)V
    .locals 0

    .line 411
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 412
    iput p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mCfAction:I

    .line 413
    iput p2, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mCfReason:I

    .line 414
    iput-object p3, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mDialingNumber:Ljava/lang/String;

    .line 415
    iput p4, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mServiceClass:I

    .line 416
    iput p5, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mTimerSeconds:I

    .line 417
    iput-object p6, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mOnComplete:Landroid/os/Message;

    return-void
.end method

.method constructor <init>(ILandroid/os/Message;)V
    .locals 0

    .line 390
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 391
    iput p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mClirMode:I

    .line 392
    iput-object p2, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mOnComplete:Landroid/os/Message;

    return-void
.end method

.method constructor <init>(Landroid/os/Message;)V
    .locals 0

    .line 379
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 380
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mOnComplete:Landroid/os/Message;

    return-void
.end method

.method constructor <init>(Ljava/lang/String;Ljava/lang/String;ILandroid/os/Message;)V
    .locals 0

    .line 421
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 422
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mFacility:Ljava/lang/String;

    .line 423
    iput-object p2, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mPassword:Ljava/lang/String;

    .line 424
    iput p3, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mServiceClass:I

    .line 425
    iput-object p4, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mOnComplete:Landroid/os/Message;

    return-void
.end method

.method constructor <init>(Ljava/lang/String;ZLjava/lang/String;ILandroid/os/Message;)V
    .locals 0

    .line 430
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 431
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mFacility:Ljava/lang/String;

    .line 432
    iput-boolean p2, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mLockState:Z

    .line 433
    iput-object p3, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mPassword:Ljava/lang/String;

    .line 434
    iput p4, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mServiceClass:I

    .line 435
    iput-object p5, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mOnComplete:Landroid/os/Message;

    return-void
.end method

.method constructor <init>(ZILandroid/os/Message;)V
    .locals 0

    .line 396
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 397
    iput-boolean p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mEnable:Z

    .line 398
    iput p2, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mServiceClass:I

    .line 399
    iput-object p3, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mOnComplete:Landroid/os/Message;

    return-void
.end method

.method constructor <init>(ZLandroid/os/Message;)V
    .locals 0

    .line 384
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 385
    iput-boolean p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mEnable:Z

    .line 386
    iput-object p2, p0, Lcom/android/internal/telephony/imsphone/ImsPhone$SS;->mOnComplete:Landroid/os/Message;

    return-void
.end method
