.class public abstract Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;
.super Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;
.source "DefaultTrigger.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/didouix/springback/trigger/DefaultTrigger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x409
    name = "IndeterminateAction"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;
    }
.end annotation


# static fields
.field public static final DEFAULT_OFFSET_POINT:I

.field static final DEFAULT_TRIGGER_TEXTIDS:[I


# instance fields
.field public mCompleteListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;

.field public mTriggerTextIDs:[I

.field public mTriggerTexts:[Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    const/4 v0, 0x4

    new-array v0, v0, [I

    .line 481
    sget v1, Lcom/pri/R$string;->didouix_sbl_tracking_progress_labe_pull_to_refresh:I

    const/4 v2, 0x0

    aput v1, v0, v2

    sget v1, Lcom/pri/R$string;->didouix_sbl_tracking_progress_labe_release_to_refresh:I

    const/4 v2, 0x1

    aput v1, v0, v2

    sget v1, Lcom/pri/R$string;->didouix_sbl_tracking_progress_labe_refreshing:I

    const/4 v2, 0x2

    aput v1, v0, v2

    sget v1, Lcom/pri/R$string;->didouix_sbl_tracking_progress_labe_refreshed:I

    const/4 v2, 0x3

    aput v1, v0, v2

    sput-object v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->DEFAULT_TRIGGER_TEXTIDS:[I

    return-void
.end method

.method public constructor <init>(I)V
    .locals 2

    .line 498
    sget v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndeterminateDistance:I

    add-int/2addr v0, p1

    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;-><init>(II)V

    .line 499
    sget-object v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->DEFAULT_TRIGGER_TEXTIDS:[I

    .line 500
    array-length v1, v0

    new-array v1, v1, [Ljava/lang/String;

    iput-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mTriggerTexts:[Ljava/lang/String;

    if-ltz p1, :cond_0

    .line 502
    iput-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mTriggerTextIDs:[I

    return-void

    .line 505
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "invalid offsetPoint"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public constructor <init>(I[I)V
    .locals 2

    .line 509
    sget v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger;->mIndeterminateDistance:I

    add-int/2addr v0, p1

    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$Action;-><init>(II)V

    .line 510
    sget-object v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->DEFAULT_TRIGGER_TEXTIDS:[I

    .line 511
    array-length v1, v0

    new-array v1, v1, [Ljava/lang/String;

    iput-object v1, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mTriggerTexts:[Ljava/lang/String;

    if-ltz p1, :cond_1

    if-eqz p2, :cond_0

    .line 514
    array-length p1, p2

    array-length v0, v0

    if-ne p1, v0, :cond_0

    .line 517
    iput-object p2, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mTriggerTextIDs:[I

    return-void

    .line 515
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "invalid text Ids"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 513
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "invalid offsetPoint"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method


# virtual methods
.method public notifyLoadComplete()V
    .locals 1

    .line 522
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mCompleteListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;

    if-eqz v0, :cond_0

    .line 524
    invoke-interface {v0, p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;->onActionComplete(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;)V

    :cond_0
    return-void
.end method

.method public notifyTriggerTextIndex(ILjava/lang/String;)V
    .locals 1

    .line 536
    sget-object v0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->DEFAULT_TRIGGER_TEXTIDS:[I

    array-length v0, v0

    if-ge p1, v0, :cond_1

    .line 537
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mCompleteListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;

    if-eqz v0, :cond_0

    .line 539
    invoke-interface {v0, p0, p1, p2}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;->onUpdateTriggerTextIndex(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;ILjava/lang/String;)V

    :cond_0
    return-void

    .line 544
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "invalid index"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public startIndeterminateAction()V
    .locals 1

    .line 529
    iget-object v0, p0, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;->mCompleteListener:Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;

    if-eqz v0, :cond_0

    .line 531
    invoke-interface {v0, p0}, Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction$OnActionCompleteListener;->onActionStart(Lcom/pri/didouix/springback/trigger/DefaultTrigger$IndeterminateAction;)V

    :cond_0
    return-void
.end method
