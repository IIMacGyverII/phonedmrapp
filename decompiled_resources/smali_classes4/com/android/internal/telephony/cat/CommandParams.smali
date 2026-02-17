.class public Lcom/android/internal/telephony/cat/CommandParams;
.super Ljava/lang/Object;
.source "CommandParams.java"


# instance fields
.field public mCmdDet:Lcom/android/internal/telephony/cat/CommandDetails;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field public mLoadIconFailed:Z


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/cat/CommandDetails;)V
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 35
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 32
    iput-boolean v0, p0, Lcom/android/internal/telephony/cat/CommandParams;->mLoadIconFailed:Z

    .line 36
    iput-object p1, p0, Lcom/android/internal/telephony/cat/CommandParams;->mCmdDet:Lcom/android/internal/telephony/cat/CommandDetails;

    return-void
.end method


# virtual methods
.method public getCommandType()Lcom/android/internal/telephony/cat/AppInterface$CommandType;
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 41
    iget-object p0, p0, Lcom/android/internal/telephony/cat/CommandParams;->mCmdDet:Lcom/android/internal/telephony/cat/CommandDetails;

    iget p0, p0, Lcom/android/internal/telephony/cat/CommandDetails;->typeOfCommand:I

    invoke-static {p0}, Lcom/android/internal/telephony/cat/AppInterface$CommandType;->fromInt(I)Lcom/android/internal/telephony/cat/AppInterface$CommandType;

    move-result-object p0

    return-object p0
.end method

.method setIcon(Landroid/graphics/Bitmap;)Z
    .locals 0

    const/4 p0, 0x1

    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 0

    .line 49
    iget-object p0, p0, Lcom/android/internal/telephony/cat/CommandParams;->mCmdDet:Lcom/android/internal/telephony/cat/CommandDetails;

    invoke-virtual {p0}, Lcom/android/internal/telephony/cat/CommandDetails;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
