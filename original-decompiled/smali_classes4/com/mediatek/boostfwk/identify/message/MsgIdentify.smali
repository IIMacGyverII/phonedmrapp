.class public Lcom/mediatek/boostfwk/identify/message/MsgIdentify;
.super Lcom/mediatek/boostfwk/identify/BaseIdentify;
.source "MsgIdentify.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/boostfwk/identify/message/MsgIdentify$AudioStateListener;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "MsgIdentify"

.field private static sInstance:Lcom/mediatek/boostfwk/identify/message/MsgIdentify;

.field private static slock:Ljava/lang/Object;


# instance fields
.field private mAudioStateListeners:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/mediatek/boostfwk/identify/message/MsgIdentify$AudioStateListener;",
            ">;"
        }
    .end annotation
.end field

.field private mIsAudioMsgBegin:Z

.field private final mSpAudioMsgViewList:[Ljava/lang/String;

.field private mSpAudioStepList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 55
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->slock:Ljava/lang/Object;

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 85
    invoke-direct {p0}, Lcom/mediatek/boostfwk/identify/BaseIdentify;-><init>()V

    const/4 v0, 0x0

    .line 56
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mIsAudioMsgBegin:Z

    .line 57
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mSpAudioStepList:Ljava/util/List;

    const-string v0, "SoundWaveView"

    const-string v1, "LanguageChoiceLayout"

    .line 58
    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mSpAudioMsgViewList:[Ljava/lang/String;

    .line 61
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mAudioStateListeners:Ljava/util/List;

    return-void
.end method

.method private audioMsgUpdate(I)Z
    .locals 0

    if-nez p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/identify/message/MsgIdentify;
    .locals 2

    .line 64
    sget-object v0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/message/MsgIdentify;

    if-nez v0, :cond_1

    .line 65
    sget-object v0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->slock:Ljava/lang/Object;

    monitor-enter v0

    .line 66
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/message/MsgIdentify;

    if-nez v1, :cond_0

    .line 67
    new-instance v1, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/message/MsgIdentify;

    .line 69
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 71
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->sInstance:Lcom/mediatek/boostfwk/identify/message/MsgIdentify;

    return-object v0
.end method

.method private specialAudioMsgUpdate(Ljava/lang/String;I)Z
    .locals 5

    .line 143
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 144
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "specialAudioMsgUpdate. viewName = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " visibilityMask = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "MsgIdentify"

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 148
    :cond_0
    iget-boolean v0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mIsAudioMsgBegin:Z

    const/16 v1, 0x8

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v0, :cond_2

    .line 149
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    iget-object v4, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mSpAudioMsgViewList:[Ljava/lang/String;

    aget-object v4, v4, v2

    invoke-virtual {v0, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mSpAudioStepList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    const/4 v4, 0x3

    if-lt v0, v4, :cond_1

    if-ne p2, v1, :cond_1

    .line 151
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mSpAudioStepList:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->clear()V

    return v3

    .line 153
    :cond_1
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mSpAudioMsgViewList:[Ljava/lang/String;

    aget-object p0, p0, v3

    invoke-virtual {p1, p0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    return v2

    .line 161
    :cond_2
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    iget-object v0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mSpAudioMsgViewList:[Ljava/lang/String;

    aget-object v0, v0, v3

    invoke-virtual {p1, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p1

    if-eqz p1, :cond_6

    .line 162
    iget-object p1, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mSpAudioStepList:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    if-eqz p1, :cond_5

    if-eq p1, v2, :cond_4

    const/4 v0, 0x2

    if-eq p1, v0, :cond_3

    goto :goto_0

    :cond_3
    if-nez p2, :cond_6

    .line 174
    iget-object p1, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mSpAudioStepList:Ljava/util/List;

    invoke-interface {p1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    if-ne p1, v1, :cond_6

    .line 175
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mSpAudioStepList:Ljava/util/List;

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_1

    :cond_4
    if-ne p2, v1, :cond_6

    .line 169
    iget-object p1, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mSpAudioStepList:Ljava/util/List;

    invoke-interface {p1, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    if-nez p1, :cond_6

    .line 170
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mSpAudioStepList:Ljava/util/List;

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_5
    if-nez p2, :cond_6

    .line 165
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mSpAudioStepList:Ljava/util/List;

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_6
    :goto_0
    move v2, v3

    :goto_1
    return v2
.end method


# virtual methods
.method public audioMsgStatusUpdate(Lcom/mediatek/boostfwk/scenario/message/MessageScenario;)V
    .locals 4

    .line 118
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/message/MessageScenario;->getViewName()Ljava/lang/String;

    move-result-object v0

    .line 119
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/message/MessageScenario;->getVisibilityMask()I

    move-result p1

    .line 121
    sget-object v1, Lcom/mediatek/boostfwk/scenario/message/MessageScenario;->mAudioMsgViewList:[Ljava/lang/String;

    const/4 v2, 0x0

    aget-object v1, v1, v2

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 122
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->audioMsgUpdate(I)Z

    move-result v2

    goto :goto_0

    .line 123
    :cond_0
    sget-object v1, Lcom/mediatek/boostfwk/scenario/message/MessageScenario;->mAudioMsgViewList:[Ljava/lang/String;

    const/4 v3, 0x1

    aget-object v1, v1, v3

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 124
    invoke-direct {p0, v0, p1}, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->specialAudioMsgUpdate(Ljava/lang/String;I)Z

    move-result v2

    .line 127
    :cond_1
    :goto_0
    iget-boolean p1, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mIsAudioMsgBegin:Z

    if-eq p1, v2, :cond_3

    .line 128
    iput-boolean v2, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mIsAudioMsgBegin:Z

    .line 129
    iget-object p1, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mAudioStateListeners:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_1
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify$AudioStateListener;

    .line 130
    iget-boolean v1, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mIsAudioMsgBegin:Z

    invoke-interface {v0, v1}, Lcom/mediatek/boostfwk/identify/message/MsgIdentify$AudioStateListener;->onAudioMsgStatusUpdate(Z)V

    goto :goto_1

    .line 132
    :cond_2
    sget-boolean p1, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p1, :cond_3

    .line 133
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "audioMsgStatusUpdate. status = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mIsAudioMsgBegin:Z

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "MsgIdentify"

    invoke-static {p1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_3
    return-void
.end method

.method public dispatchScenario(Lcom/mediatek/boostfwk/scenario/BasicScenario;)Z
    .locals 4

    const-string v0, "MsgIdentify"

    if-nez p1, :cond_0

    const-string p0, "No message scenario to dispatcher."

    .line 96
    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogw(Ljava/lang/String;Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0

    .line 99
    :cond_0
    check-cast p1, Lcom/mediatek/boostfwk/scenario/message/MessageScenario;

    .line 100
    invoke-virtual {p1}, Lcom/mediatek/boostfwk/scenario/message/MessageScenario;->getScenarioAction()I

    move-result v1

    .line 102
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 103
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Message action dispatcher to = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    if-eqz v1, :cond_2

    const-string p0, "Not found dispatcher message action."

    .line 110
    invoke-static {v0, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogw(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 107
    :cond_2
    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->audioMsgStatusUpdate(Lcom/mediatek/boostfwk/scenario/message/MessageScenario;)V

    :goto_0
    const/4 p0, 0x1

    return p0
.end method

.method public registerAudioStateListener(Lcom/mediatek/boostfwk/identify/message/MsgIdentify$AudioStateListener;)V
    .locals 0

    if-nez p1, :cond_0

    return-void

    .line 82
    :cond_0
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/message/MsgIdentify;->mAudioStateListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method
