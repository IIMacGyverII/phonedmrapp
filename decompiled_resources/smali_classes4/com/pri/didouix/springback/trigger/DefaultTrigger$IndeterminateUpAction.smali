.class public abstract Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;
.super Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;
.source "DefaultTrigger.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x409
    name = "IndeterminateUpAction"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;
    }
.end annotation


# static fields
.field public static final DEFAULT_OFFSET_POINT:I

.field static final DEFAULT_TRIGGER_TEXTIDS:[I


# instance fields
.field private mCountNoData:I

.field public mTriggerTextIDs:[I

.field public mTriggerTexts:[Ljava/lang/String;

.field public mUpDataListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    const/4 v0, 0x4

    new-array v0, v0, [I

    .line 550
    sget v1, Lcom/pri/R$string;->didouix_sbl_tracking_progress_labe_up_refresh:I

    const/4 v2, 0x0

    aput v1, v0, v2

    sget v1, Lcom/pri/R$string;->didouix_sbl_tracking_progress_labe_up_refresh_fail:I

    const/4 v2, 0x1

    aput v1, v0, v2

    sget v1, Lcom/pri/R$string;->didouix_sbl_tracking_progress_labe_up_nodata:I

    const/4 v2, 0x2

    aput v1, v0, v2

    sget v1, Lcom/pri/R$string;->didouix_sbl_tracking_progress_labe_up_none:I

    const/4 v2, 0x3

    aput v1, v0, v2

    sput-object v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->DEFAULT_TRIGGER_TEXTIDS:[I

    return-void
.end method

.method public constructor <init>(I)V
    .locals 2

    .line 580
    sget v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpIndeterminateDistance:I

    add-int/2addr v0, p1

    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;-><init>(II)V

    const/4 v0, 0x0

    .line 551
    iput v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mCountNoData:I

    .line 581
    sget-object v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->DEFAULT_TRIGGER_TEXTIDS:[I

    .line 582
    array-length v1, v0

    new-array v1, v1, [Ljava/lang/String;

    iput-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    if-ltz p1, :cond_0

    .line 584
    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTextIDs:[I

    return-void

    .line 587
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "invalid offsetPoint"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public constructor <init>(I[I)V
    .locals 2

    .line 591
    sget v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mUpIndeterminateDistance:I

    add-int/2addr v0, p1

    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;-><init>(II)V

    const/4 v0, 0x0

    .line 551
    iput v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mCountNoData:I

    .line 592
    sget-object v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->DEFAULT_TRIGGER_TEXTIDS:[I

    .line 593
    array-length v1, v0

    new-array v1, v1, [Ljava/lang/String;

    iput-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTexts:[Ljava/lang/String;

    if-ltz p1, :cond_1

    if-eqz p2, :cond_0

    .line 596
    array-length p1, p2

    array-length v0, v0

    if-ne p1, v0, :cond_0

    .line 599
    iput-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mTriggerTextIDs:[I

    return-void

    .line 597
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "invalid text Ids"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 595
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "invalid offsetPoint"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method


# virtual methods
.method public getCountNoData()I
    .locals 0

    .line 576
    iget p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mCountNoData:I

    return p0
.end method

.method public isNoData()Z
    .locals 0

    .line 572
    iget p0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mCountNoData:I

    if-lez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public notifyActionNoData()V
    .locals 2

    .line 604
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mUpDataListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;

    if-eqz v0, :cond_0

    .line 606
    iget v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mCountNoData:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mCountNoData:I

    .line 607
    invoke-interface {v0, p0, v1}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;->onActionNoData(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;I)V

    :cond_0
    return-void
.end method

.method public notifyLoadComplete()V
    .locals 2

    .line 612
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mUpDataListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;

    if-eqz v0, :cond_0

    const/4 v1, 0x0

    .line 614
    iput v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mCountNoData:I

    .line 615
    invoke-interface {v0, p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;->onActionComplete(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;)V

    :cond_0
    return-void
.end method

.method public notifyLoadFail()V
    .locals 1

    .line 632
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mUpDataListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;

    if-eqz v0, :cond_0

    .line 634
    invoke-interface {v0, p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;->onActionLoadFail(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;)V

    :cond_0
    return-void
.end method

.method public notifyTriggerTextIndex(ILjava/lang/String;)V
    .locals 1

    .line 620
    sget-object v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->DEFAULT_TRIGGER_TEXTIDS:[I

    array-length v0, v0

    if-ge p1, v0, :cond_1

    .line 621
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mUpDataListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;

    if-eqz v0, :cond_0

    .line 623
    invoke-interface {v0, p0, p1, p2}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;->onUpdateTriggerTextIndex(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;ILjava/lang/String;)V

    :cond_0
    return-void

    .line 628
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "invalid index"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public startIndeterminateUpAction()V
    .locals 2

    .line 639
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mUpDataListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;

    if-eqz v0, :cond_0

    const/4 v1, 0x0

    .line 641
    iput v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;->mCountNoData:I

    .line 642
    invoke-interface {v0, p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction$OnUpActionDataListener;->onActionStart(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateUpAction;)V

    :cond_0
    return-void
.end method
