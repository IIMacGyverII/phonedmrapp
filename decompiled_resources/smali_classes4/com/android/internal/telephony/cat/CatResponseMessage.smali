.class public Lcom/android/internal/telephony/cat/CatResponseMessage;
.super Ljava/lang/Object;
.source "CatResponseMessage.java"


# instance fields
.field public mAddedInfo:[B

.field public mAdditionalInfo:I

.field public mCmdDet:Lcom/android/internal/telephony/cat/CommandDetails;

.field public mEventValue:I

.field public mIncludeAdditionalInfo:Z

.field public mResCode:Lcom/android/internal/telephony/cat/ResultCode;

.field public mUsersConfirm:Z

.field public mUsersInput:Ljava/lang/String;

.field public mUsersMenuSelection:I

.field public mUsersYesNoSelection:Z


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/cat/CatCmdMessage;)V
    .locals 2

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 23
    iput-object v0, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mCmdDet:Lcom/android/internal/telephony/cat/CommandDetails;

    .line 24
    sget-object v1, Lcom/android/internal/telephony/cat/ResultCode;->OK:Lcom/android/internal/telephony/cat/ResultCode;

    iput-object v1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mResCode:Lcom/android/internal/telephony/cat/ResultCode;

    const/4 v1, 0x0

    .line 25
    iput v1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mUsersMenuSelection:I

    .line 26
    iput-object v0, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mUsersInput:Ljava/lang/String;

    .line 27
    iput-boolean v1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mUsersYesNoSelection:Z

    .line 28
    iput-boolean v1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mUsersConfirm:Z

    .line 29
    iput-boolean v1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mIncludeAdditionalInfo:Z

    .line 30
    iput v1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mAdditionalInfo:I

    const/4 v1, -0x1

    .line 31
    iput v1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mEventValue:I

    .line 32
    iput-object v0, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mAddedInfo:[B

    .line 35
    iget-object p1, p1, Lcom/android/internal/telephony/cat/CatCmdMessage;->mCmdDet:Lcom/android/internal/telephony/cat/CommandDetails;

    iput-object p1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mCmdDet:Lcom/android/internal/telephony/cat/CommandDetails;

    return-void
.end method


# virtual methods
.method public getCmdDetails()Lcom/android/internal/telephony/cat/CommandDetails;
    .locals 0

    .line 71
    iget-object p0, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mCmdDet:Lcom/android/internal/telephony/cat/CommandDetails;

    return-object p0
.end method

.method public setAdditionalInfo(I)V
    .locals 1

    const/4 v0, 0x1

    .line 65
    iput-boolean v0, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mIncludeAdditionalInfo:Z

    .line 66
    iput p1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mAdditionalInfo:I

    return-void
.end method

.method public setConfirmation(Z)V
    .locals 0

    .line 61
    iput-boolean p1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mUsersConfirm:Z

    return-void
.end method

.method public setEventDownload(I[B)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation

    .line 52
    iput p1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mEventValue:I

    .line 53
    iput-object p2, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mAddedInfo:[B

    return-void
.end method

.method public setInput(Ljava/lang/String;)V
    .locals 0

    .line 47
    iput-object p1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mUsersInput:Ljava/lang/String;

    return-void
.end method

.method public setMenuSelection(I)V
    .locals 0

    .line 43
    iput p1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mUsersMenuSelection:I

    return-void
.end method

.method public setResultCode(Lcom/android/internal/telephony/cat/ResultCode;)V
    .locals 0

    .line 39
    iput-object p1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mResCode:Lcom/android/internal/telephony/cat/ResultCode;

    return-void
.end method

.method public setYesNo(Z)V
    .locals 0

    .line 57
    iput-boolean p1, p0, Lcom/android/internal/telephony/cat/CatResponseMessage;->mUsersYesNoSelection:Z

    return-void
.end method
