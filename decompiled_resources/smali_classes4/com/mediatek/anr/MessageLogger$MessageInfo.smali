.class public Lcom/mediatek/anr/MessageLogger$MessageInfo;
.super Ljava/lang/Object;
.source "MessageLogger.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/anr/MessageLogger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "MessageInfo"
.end annotation


# instance fields
.field public durationElapsed:J

.field public durationUp:J

.field public finishDispatch:Ljava/lang/String;

.field public msgIdFinish:J

.field public msgIdStart:J

.field public startDispatch:Ljava/lang/String;

.field public startTimeElapsed:J

.field public startTimeUp:J

.field final synthetic this$0:Lcom/mediatek/anr/MessageLogger;


# direct methods
.method public constructor <init>(Lcom/mediatek/anr/MessageLogger;)V
    .locals 0

    .line 354
    iput-object p1, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->this$0:Lcom/mediatek/anr/MessageLogger;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 355
    invoke-virtual {p0}, Lcom/mediatek/anr/MessageLogger$MessageInfo;->init()V

    return-void
.end method


# virtual methods
.method public copy(Lcom/mediatek/anr/MessageLogger$MessageInfo;)V
    .locals 2

    .line 370
    iget-object v0, p1, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startDispatch:Ljava/lang/String;

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startDispatch:Ljava/lang/String;

    .line 371
    iget-object v0, p1, Lcom/mediatek/anr/MessageLogger$MessageInfo;->finishDispatch:Ljava/lang/String;

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->finishDispatch:Ljava/lang/String;

    .line 372
    iget-wide v0, p1, Lcom/mediatek/anr/MessageLogger$MessageInfo;->msgIdStart:J

    iput-wide v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->msgIdStart:J

    .line 373
    iget-wide v0, p1, Lcom/mediatek/anr/MessageLogger$MessageInfo;->msgIdFinish:J

    iput-wide v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->msgIdFinish:J

    .line 374
    iget-wide v0, p1, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startTimeUp:J

    iput-wide v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startTimeUp:J

    .line 375
    iget-wide v0, p1, Lcom/mediatek/anr/MessageLogger$MessageInfo;->durationUp:J

    iput-wide v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->durationUp:J

    .line 376
    iget-wide v0, p1, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startTimeElapsed:J

    iput-wide v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startTimeElapsed:J

    .line 377
    iget-wide v0, p1, Lcom/mediatek/anr/MessageLogger$MessageInfo;->durationElapsed:J

    iput-wide v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->durationElapsed:J

    return-void
.end method

.method public init()V
    .locals 4

    const/4 v0, 0x0

    .line 359
    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startDispatch:Ljava/lang/String;

    .line 360
    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->finishDispatch:Ljava/lang/String;

    const-wide/16 v0, -0x1

    .line 361
    iput-wide v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->msgIdStart:J

    .line 362
    iput-wide v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->msgIdFinish:J

    const-wide/16 v2, 0x0

    .line 363
    iput-wide v2, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startTimeUp:J

    .line 364
    iput-wide v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->durationUp:J

    .line 365
    iput-wide v2, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startTimeElapsed:J

    .line 366
    iput-wide v0, p0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->durationElapsed:J

    return-void
.end method
