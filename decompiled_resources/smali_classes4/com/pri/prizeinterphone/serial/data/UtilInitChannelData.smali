.class public Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;
.super Ljava/lang/Object;
.source "UtilInitChannelData.java"


# static fields
.field public static final TAG:Ljava/lang/String; = "UtilInitChannelData"


# instance fields
.field private mContext:Landroid/content/Context;

.field public mCurrentChannelSelectIndex:Ljava/lang/String;

.field private mUtilChannelDataList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/serial/data/UtilChannelData;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$NjU3K43hg3nKeXtr-FmwGLgm-MA(Ljava/lang/String;Lcom/pri/prizeinterphone/serial/data/UtilChannelData;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->lambda$getCurrentDb$0(Ljava/lang/String;Lcom/pri/prizeinterphone/serial/data/UtilChannelData;)Z

    move-result p0

    return p0
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 33
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 28
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->KEY_DEF_AREA:Ljava/lang/String;

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mCurrentChannelSelectIndex:Ljava/lang/String;

    .line 29
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    .line 34
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    .line 35
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChannelDataList()V

    return-void
.end method

.method private buildDefaultAnalogChannel(IIIII)Lcom/pri/prizeinterphone/serial/data/ChannelData;
    .locals 0

    .line 474
    new-instance p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;-><init>()V

    .line 475
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    .line 477
    iput p4, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    .line 478
    iput p5, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->band:I

    const/4 p4, 0x1

    .line 479
    iput p4, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    .line 480
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    .line 481
    iput p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    .line 482
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    return-object p0
.end method

.method private buildDefaultAnalogChannel(IIIIILjava/lang/String;)Lcom/pri/prizeinterphone/serial/data/ChannelData;
    .locals 0

    .line 487
    new-instance p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;-><init>()V

    .line 488
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    .line 489
    iput-object p6, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    .line 490
    iput p4, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    .line 491
    iput p5, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->band:I

    const/4 p4, 0x1

    .line 492
    iput p4, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    .line 493
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    .line 494
    iput p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    .line 495
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    return-object p0
.end method

.method private buildDefaultDigitalChannel(III)Lcom/pri/prizeinterphone/serial/data/ChannelData;
    .locals 1

    .line 434
    new-instance p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;-><init>()V

    .line 435
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    const/4 v0, 0x0

    .line 436
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    .line 437
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    .line 438
    iput p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    .line 439
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    return-object p0
.end method

.method private buildDefaultDigitalChannel(IIILjava/lang/String;)Lcom/pri/prizeinterphone/serial/data/ChannelData;
    .locals 0

    .line 444
    new-instance p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;-><init>()V

    .line 445
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    .line 446
    iput-object p4, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    const/4 p4, 0x0

    .line 447
    iput p4, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    .line 448
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    .line 449
    iput p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    .line 450
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    return-object p0
.end method

.method private static getStrToArray(Ljava/lang/String;[I)[I
    .locals 3

    .line 562
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    return-object p1

    :cond_0
    const/16 p1, 0x20

    new-array p1, p1, [I

    const-string v0, ""

    .line 566
    invoke-virtual {p0, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    .line 567
    :goto_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    if-ge v1, v2, :cond_1

    .line 568
    aget-object v2, v0, v1

    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v2

    aput v2, p1, v1

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    return-object p1
.end method

.method private static getValueOrDefault(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 555
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    return-object p1

    :cond_0
    return-object p0
.end method

.method private initAUSChannelDb()V
    .locals 2

    const/high16 v0, 0x7f030000

    const-string v1, "channel_area_aus"

    .line 387
    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    return-void
.end method

.method private initChannelDataList()V
    .locals 4

    .line 39
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    invoke-static {v0}, Lcom/pri/prizeinterphone/constant/Constants;->getSavedChannelAreas(Landroid/content/Context;)Ljava/util/LinkedHashMap;

    move-result-object v0

    .line 40
    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 41
    new-instance v2, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    iget-object v3, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-direct {v2, v3, v1}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 42
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-void
.end method

.method private initChanneldb(ILjava/lang/String;)V
    .locals 9

    .line 419
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 420
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1, p1}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object p1

    const/4 v1, 0x1

    move v8, v1

    .line 421
    :goto_0
    array-length v2, p1

    if-gt v8, v2, :cond_1

    add-int/lit8 v2, v8, -0x1

    .line 422
    aget-object v2, p1, v2

    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v4

    const/4 v6, 0x1

    const/4 v7, 0x1

    move-object v2, p0

    move v3, v4

    move v5, v8

    .line 423
    invoke-direct/range {v2 .. v7}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->buildDefaultAnalogChannel(IIIII)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v2

    if-ne v8, v1, :cond_0

    .line 425
    iput v1, v2, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    .line 427
    :cond_0
    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v8, v8, 0x1

    goto :goto_0

    .line 430
    :cond_1
    invoke-virtual {p0, p2}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object p1

    invoke-direct {p0, p1, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->insertChannelDataToDb(Lcom/pri/prizeinterphone/serial/data/UtilChannelData;Ljava/util/List;)V

    return-void
.end method

.method private initChinaChannelDb()V
    .locals 2

    const v0, 0x7f030001

    const-string v1, "channel_area_cn"

    .line 371
    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    return-void
.end method

.method private initChinaTaiwanChannelDb()V
    .locals 2

    const v0, 0x7f030002

    const-string v1, "channel_area_tw"

    .line 375
    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    return-void
.end method

.method private initDefaultChannelDb()V
    .locals 1

    const/4 v0, 0x0

    .line 193
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultChannelDb(Z)V

    return-void
.end method

.method private initDefaultChannelDb(Z)V
    .locals 10

    if-eqz p1, :cond_0

    .line 197
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultChannelDbFromSdcard()V

    goto :goto_2

    .line 199
    :cond_0
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    .line 200
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x7f03000f

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x1

    move v2, v1

    .line 202
    :goto_0
    array-length v3, v0

    if-gt v2, v3, :cond_2

    add-int/lit8 v3, v2, -0x1

    .line 203
    aget-object v3, v0, v3

    invoke-static {v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v3

    .line 204
    invoke-direct {p0, v3, v3, v2}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->buildDefaultDigitalChannel(III)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v3

    if-ne v2, v1, :cond_1

    .line 206
    iput v1, v3, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    .line 208
    :cond_1
    invoke-interface {p1, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 210
    :cond_2
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    const v3, 0x7f030003

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v2

    .line 211
    array-length v3, v0

    add-int/2addr v3, v1

    :goto_1
    array-length v4, v2

    array-length v5, v0

    add-int/2addr v4, v5

    if-gt v3, v4, :cond_3

    .line 212
    array-length v4, v0

    sub-int v4, v3, v4

    sub-int/2addr v4, v1

    aget-object v4, v2, v4

    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v6

    const/4 v8, 0x1

    const/4 v9, 0x1

    move-object v4, p0

    move v5, v6

    move v7, v3

    .line 213
    invoke-direct/range {v4 .. v9}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->buildDefaultAnalogChannel(IIIII)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v4

    .line 214
    invoke-interface {p1, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_3
    const-string v0, "channel_area_default"

    .line 217
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v0

    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->insertChannelDataToDb(Lcom/pri/prizeinterphone/serial/data/UtilChannelData;Ljava/util/List;)V

    :goto_2
    return-void
.end method

.method private initDefaultChannelDbFromSdcard()V
    .locals 21

    move-object/from16 v11, p0

    .line 275
    invoke-static {}, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->getInstance()Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->parse()Lcom/pri/prizeinterphone/config/data/ParseConfig;

    move-result-object v0

    .line 276
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/data/ParseConfig;->isError()Z

    move-result v1

    if-nez v1, :cond_b

    .line 277
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/data/ParseConfig;->getInsertConfig()Lcom/pri/prizeinterphone/config/data/InsertConfig;

    move-result-object v0

    .line 279
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/data/InsertConfig;->getInsertChannels()Landroid/util/SparseArray;

    move-result-object v1

    .line 281
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/data/InsertConfig;->getLocalNumber()I

    move-result v0

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/config/data/InsertChannels;

    if-eqz v0, :cond_9

    .line 284
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/data/InsertChannels;->getChannels()Ljava/util/ArrayList;

    move-result-object v12

    .line 286
    new-instance v13, Ljava/util/ArrayList;

    invoke-direct {v13}, Ljava/util/ArrayList;-><init>()V

    const/4 v14, 0x0

    const/4 v15, 0x1

    move v10, v14

    move v3, v15

    .line 289
    :goto_0
    invoke-virtual {v12}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-ge v10, v0, :cond_6

    .line 290
    invoke-virtual {v12, v10}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    move-object/from16 v16, v0

    check-cast v16, Lcom/pri/prizeinterphone/config/data/InsertChannel;

    .line 291
    invoke-static/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkMustNotEmpty(Lcom/pri/prizeinterphone/config/data/InsertChannel;)Z

    move-result v0

    if-eqz v0, :cond_0

    move/from16 v18, v10

    goto/16 :goto_2

    :cond_0
    const/4 v0, 0x0

    .line 295
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getChanneltype()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1

    const-string v2, "1"

    const-string v4, "0"

    if-eqz v1, :cond_3

    if-eq v1, v15, :cond_1

    move/from16 v18, v10

    goto/16 :goto_1

    .line 300
    :cond_1
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getSendfreq()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1

    .line 301
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getRecfreq()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v5

    add-int/lit8 v17, v3, 0x1

    .line 303
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getPower()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    xor-int/lit8 v6, v0, 0x1

    .line 304
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getBand()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    .line 305
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getName()Ljava/lang/String;

    move-result-object v8

    .line 306
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getRecvsubaudiotype()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v4}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getValueOrDefault(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v9

    .line 307
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getRecvsubaudiofreq()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v4}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getValueOrDefault(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v18

    .line 308
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getSendsubaudiotype()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v4}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getValueOrDefault(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v19

    .line 309
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getSendsubaudiofreq()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v4}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getValueOrDefault(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v20

    move-object/from16 v0, p0

    move v2, v5

    move v4, v6

    move v5, v7

    move-object v6, v8

    move v7, v9

    move/from16 v8, v18

    move/from16 v9, v19

    move/from16 v18, v10

    move/from16 v10, v20

    .line 299
    invoke-direct/range {v0 .. v10}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->myBuildDefaultAnalogChannel(IIIIILjava/lang/String;IIII)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v0

    .line 311
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getSquelchlevel()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_2

    .line 312
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getSquelchlevel()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1

    iput v1, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->sq:I

    :cond_2
    move/from16 v3, v17

    goto :goto_1

    :cond_3
    move/from16 v18, v10

    .line 319
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getSendfreq()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1

    .line 320
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getRecfreq()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v5

    add-int/lit8 v8, v3, 0x1

    .line 322
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getName()Ljava/lang/String;

    move-result-object v6

    .line 323
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getContactype()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v4}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getValueOrDefault(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v7

    .line 324
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getNumber()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v2}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getValueOrDefault(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v9

    .line 325
    invoke-virtual/range {v16 .. v16}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getRecGroup()Ljava/lang/String;

    move-result-object v0

    new-array v2, v15, [I

    aput v15, v2, v14

    invoke-static {v0, v2}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getStrToArray(Ljava/lang/String;[I)[I

    move-result-object v10

    move-object/from16 v0, p0

    move v2, v5

    move-object v4, v6

    move v5, v7

    move v6, v9

    move-object v7, v10

    .line 318
    invoke-direct/range {v0 .. v7}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->myBuildDefaultDigitalChannel(IIILjava/lang/String;II[I)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v0

    move v3, v8

    :goto_1
    const/4 v1, 0x2

    if-ne v3, v1, :cond_4

    if-eqz v0, :cond_4

    .line 331
    iput v15, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    :cond_4
    if-eqz v0, :cond_5

    .line 335
    invoke-interface {v13, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_5
    :goto_2
    add-int/lit8 v10, v18, 0x1

    goto/16 :goto_0

    .line 339
    :cond_6
    invoke-interface {v13}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_7

    .line 340
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->KEY_DEF_AREA:Ljava/lang/String;

    invoke-virtual {v11, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v0

    invoke-direct {v11, v0, v13}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->insertChannelDataToDb(Lcom/pri/prizeinterphone/serial/data/UtilChannelData;Ljava/util/List;)V

    .line 341
    iget-object v0, v11, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    const v1, 0x7f110155

    invoke-static {v0, v1, v15}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    goto :goto_4

    .line 343
    :cond_7
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSupportUVFrequencyBand()Z

    move-result v0

    if-eqz v0, :cond_8

    .line 344
    invoke-direct/range {p0 .. p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultUHFChannelDb()V

    goto :goto_3

    .line 346
    :cond_8
    invoke-direct/range {p0 .. p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultChannelDb()V

    .line 348
    :goto_3
    iget-object v0, v11, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    const v1, 0x7f110154

    invoke-static {v0, v1, v15}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    goto :goto_4

    .line 351
    :cond_9
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSupportUVFrequencyBand()Z

    move-result v0

    if-eqz v0, :cond_a

    .line 352
    invoke-direct/range {p0 .. p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultUHFChannelDb()V

    goto :goto_4

    .line 354
    :cond_a
    invoke-direct/range {p0 .. p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultChannelDb()V

    goto :goto_4

    .line 360
    :cond_b
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSupportUVFrequencyBand()Z

    move-result v0

    if-eqz v0, :cond_c

    .line 361
    invoke-direct/range {p0 .. p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultUHFChannelDb()V

    goto :goto_4

    .line 363
    :cond_c
    invoke-direct/range {p0 .. p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultChannelDb()V

    :goto_4
    return-void
.end method

.method private initDefaultRelatedDb(Z)V
    .locals 1

    .line 172
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSupportUVFrequencyBand()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 174
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultUHFChannelDb(Z)V

    .line 175
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultVHFChannelDb(Z)V

    goto :goto_0

    .line 177
    :cond_0
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultChannelDb(Z)V

    :goto_0
    return-void
.end method

.method private initDefaultUHFChannelDb()V
    .locals 1

    const/4 v0, 0x0

    .line 243
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultUHFChannelDb(Z)V

    return-void
.end method

.method private initDefaultUHFChannelDb(Z)V
    .locals 10

    if-eqz p1, :cond_0

    .line 247
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultChannelDbFromSdcard()V

    goto :goto_2

    .line 249
    :cond_0
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    .line 250
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x7f030010

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x1

    move v2, v1

    .line 252
    :goto_0
    array-length v3, v0

    if-gt v2, v3, :cond_2

    add-int/lit8 v3, v2, -0x1

    .line 253
    aget-object v3, v0, v3

    invoke-static {v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v3

    .line 254
    invoke-direct {p0, v3, v3, v2}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->buildDefaultDigitalChannel(III)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v3

    if-ne v2, v1, :cond_1

    .line 256
    iput v1, v3, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    .line 258
    :cond_1
    invoke-interface {p1, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 260
    :cond_2
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    const v3, 0x7f030004

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v2

    .line 261
    array-length v3, v0

    add-int/2addr v3, v1

    :goto_1
    array-length v4, v2

    array-length v5, v0

    add-int/2addr v4, v5

    if-gt v3, v4, :cond_3

    .line 262
    array-length v4, v0

    sub-int v4, v3, v4

    sub-int/2addr v4, v1

    aget-object v4, v2, v4

    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v6

    const/4 v8, 0x1

    const/4 v9, 0x1

    move-object v4, p0

    move v5, v6

    move v7, v3

    .line 263
    invoke-direct/range {v4 .. v9}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->buildDefaultAnalogChannel(IIIII)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v4

    .line 264
    invoke-interface {p1, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_3
    const-string v0, "channel_area_default_uhf"

    .line 267
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v0

    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->insertChannelDataToDb(Lcom/pri/prizeinterphone/serial/data/UtilChannelData;Ljava/util/List;)V

    :goto_2
    return-void
.end method

.method private initDefaultVHFChannelDb(Z)V
    .locals 10

    .line 221
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    .line 222
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x7f030011

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x1

    move v2, v1

    .line 224
    :goto_0
    array-length v3, v0

    if-gt v2, v3, :cond_1

    add-int/lit8 v3, v2, -0x1

    .line 225
    aget-object v3, v0, v3

    invoke-static {v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v3

    .line 226
    invoke-direct {p0, v3, v3, v2}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->buildDefaultDigitalChannel(III)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v3

    if-ne v2, v1, :cond_0

    .line 228
    iput v1, v3, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    .line 230
    :cond_0
    invoke-interface {p1, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 232
    :cond_1
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    invoke-virtual {v2}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    const v3, 0x7f030005

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v2

    .line 233
    array-length v3, v0

    add-int/2addr v3, v1

    :goto_1
    array-length v4, v2

    array-length v5, v0

    add-int/2addr v4, v5

    if-gt v3, v4, :cond_2

    .line 234
    array-length v4, v0

    sub-int v4, v3, v4

    sub-int/2addr v4, v1

    aget-object v4, v2, v4

    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v6

    const/4 v8, 0x1

    const/4 v9, 0x1

    move-object v4, p0

    move v5, v6

    move v7, v3

    .line 235
    invoke-direct/range {v4 .. v9}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->buildDefaultAnalogChannel(IIIII)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v4

    .line 236
    invoke-interface {p1, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_2
    const-string v0, "channel_area_default_vhf"

    .line 239
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v0

    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->insertChannelDataToDb(Lcom/pri/prizeinterphone/serial/data/UtilChannelData;Ljava/util/List;)V

    return-void
.end method

.method private initEUChannelDb()V
    .locals 2

    const v0, 0x7f030006

    const-string v1, "channel_area_eu"

    .line 379
    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    return-void
.end method

.method private initIRANChannelDb()V
    .locals 2

    const v0, 0x7f030007

    const-string v1, "channel_area_iran"

    .line 395
    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    return-void
.end method

.method private initJAPANChannelDb()V
    .locals 2

    const v0, 0x7f030008

    const-string v1, "channel_area_japan"

    .line 407
    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    return-void
.end method

.method private initKOREAChannelDb()V
    .locals 2

    const v0, 0x7f030009

    const-string v1, "channel_area_ko"

    .line 399
    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    return-void
.end method

.method private initMALAYSIAChannelDb()V
    .locals 2

    const v0, 0x7f03000a

    const-string v1, "channel_area_malaysia"

    .line 403
    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    return-void
.end method

.method private initNorWayChannelDb()V
    .locals 2

    const v0, 0x7f03000b

    const-string v1, "channel_area_norway"

    .line 411
    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    return-void
.end method

.method private initRUSSIAChannelDb()V
    .locals 2

    const v0, 0x7f03000c

    const-string v1, "channel_area_rus"

    .line 391
    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    return-void
.end method

.method private initSouthAfricaChannelDb()V
    .locals 2

    const v0, 0x7f03000d

    const-string v1, "channel_area_south_af"

    .line 415
    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    return-void
.end method

.method private initUSAChannelDb()V
    .locals 2

    const v0, 0x7f03000e

    const-string v1, "channel_area_usa"

    .line 383
    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    return-void
.end method

.method private insertChannelDataToDb(Lcom/pri/prizeinterphone/serial/data/UtilChannelData;Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/pri/prizeinterphone/serial/data/UtilChannelData;",
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/serial/data/ChannelData;",
            ">;)V"
        }
    .end annotation

    .line 520
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    .line 521
    invoke-virtual {p2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getId()I

    move-result v0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->getChannel(I)Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 522
    invoke-virtual {p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->updateChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    goto :goto_0

    .line 524
    :cond_0
    invoke-virtual {p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->addChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    goto :goto_0

    :cond_1
    return-void
.end method

.method private static synthetic lambda$getCurrentDb$0(Ljava/lang/String;Lcom/pri/prizeinterphone/serial/data/UtilChannelData;)Z
    .locals 0

    .line 189
    iget-object p1, p1, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->mDataName:Ljava/lang/String;

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private myBuildDefaultAnalogChannel(IIIIILjava/lang/String;IIII)Lcom/pri/prizeinterphone/serial/data/ChannelData;
    .locals 0

    .line 503
    new-instance p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;-><init>()V

    .line 504
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    .line 505
    iput-object p6, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    .line 506
    iput p4, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->power:I

    .line 507
    iput p5, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->band:I

    const/4 p4, 0x1

    .line 508
    iput p4, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    .line 509
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    .line 510
    iput p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    .line 511
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    .line 512
    iput p7, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxType:I

    .line 513
    iput p8, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxSubCode:I

    .line 514
    iput p9, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txType:I

    .line 515
    iput p10, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txSubCode:I

    return-object p0
.end method

.method private myBuildDefaultDigitalChannel(IIILjava/lang/String;II[I)Lcom/pri/prizeinterphone/serial/data/ChannelData;
    .locals 0

    .line 457
    new-instance p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;-><init>()V

    .line 458
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->_id:I

    .line 459
    iput-object p4, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    const/4 p4, 0x0

    .line 460
    iput p4, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    .line 461
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    .line 462
    iput p2, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    .line 463
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    .line 464
    iput p5, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->contactType:I

    const/4 p1, 0x2

    if-eq p5, p1, :cond_0

    .line 466
    iput p6, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txContact:I

    .line 467
    iput-object p7, p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    :cond_0
    return-object p0
.end method


# virtual methods
.method public addChannelDataList(Ljava/lang/String;Ljava/util/LinkedHashMap;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 47
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    invoke-direct {v0, v1, p1}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .line 48
    iget-object p1, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {p1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 49
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    invoke-static {p0, p2}, Lcom/pri/prizeinterphone/constant/Constants;->saveChannelAreas(Landroid/content/Context;Ljava/util/LinkedHashMap;)Z

    return-void
.end method

.method public getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;
    .locals 1

    .line 186
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    invoke-static {v0}, Lcom/pri/prizeinterphone/constant/Constants;->getSavedChannelAreas(Landroid/content/Context;)Ljava/util/LinkedHashMap;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/util/LinkedHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 187
    new-instance p1, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->KEY_DEF_AREA:Ljava/lang/String;

    invoke-direct {p1, p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    return-object p1

    .line 189
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData$$ExternalSyntheticLambda0;

    invoke-direct {v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData$$ExternalSyntheticLambda0;-><init>(Ljava/lang/String;)V

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/Optional;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    return-object p0
.end method

.method public initChannelDb()V
    .locals 1

    const/4 v0, 0x0

    .line 153
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChannelDb(Z)V

    return-void
.end method

.method public initChannelDb(Z)V
    .locals 0

    .line 156
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultRelatedDb(Z)V

    .line 157
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChinaChannelDb()V

    .line 158
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChinaTaiwanChannelDb()V

    .line 159
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initEUChannelDb()V

    .line 160
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initUSAChannelDb()V

    .line 161
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initAUSChannelDb()V

    .line 162
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initRUSSIAChannelDb()V

    .line 163
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initIRANChannelDb()V

    .line 164
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initKOREAChannelDb()V

    .line 165
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initMALAYSIAChannelDb()V

    .line 166
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initJAPANChannelDb()V

    .line 167
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initNorWayChannelDb()V

    .line 168
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initSouthAfricaChannelDb()V

    return-void
.end method

.method public isCheckDbName(Ljava/lang/String;)Z
    .locals 5

    const/4 v0, 0x0

    move v1, v0

    .line 545
    :goto_0
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_1

    .line 546
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    iget-object v2, v2, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->mDBName:Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "database_"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    return v0
.end method

.method public isDBEmpty()Z
    .locals 0

    .line 182
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public removeChannelDataList(Ljava/lang/String;)V
    .locals 8

    const/4 v0, 0x0

    move v1, v0

    .line 54
    :goto_0
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_1

    .line 55
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    iget-object v2, v2, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->mDBName:Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "database_"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 56
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->deleteAll()V

    .line 57
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->close()V

    .line 58
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v4, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v4, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    iget-object v4, v4, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->mDBName:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ".db"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/content/Context;->deleteDatabase(Ljava/lang/String;)Z

    .line 59
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    goto :goto_1

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 64
    :cond_1
    :goto_1
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    const-string v2, "pref_person_device_area_list"

    const-string v3, ""

    invoke-static {v1, v2, v3}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v4, ","

    .line 65
    invoke-virtual {v1, v4}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    .line 66
    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    move v6, v0

    .line 67
    :goto_2
    array-length v7, v1

    if-ge v6, v7, :cond_2

    .line 68
    aget-object v7, v1, v6

    invoke-virtual {v5, v7}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v6, v6, 0x1

    goto :goto_2

    :cond_2
    move v1, v0

    .line 72
    :goto_3
    invoke-virtual {v5}, Ljava/util/ArrayList;->size()I

    move-result v6

    if-ge v1, v6, :cond_4

    .line 73
    invoke-virtual {v5, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    invoke-virtual {v6, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_3

    .line 74
    invoke-virtual {v5, v1}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    goto :goto_4

    :cond_3
    add-int/lit8 v1, v1, 0x1

    goto :goto_3

    .line 79
    :cond_4
    :goto_4
    invoke-virtual {v5}, Ljava/util/ArrayList;->size()I

    move-result p1

    if-ge v0, p1, :cond_6

    if-nez v0, :cond_5

    .line 81
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    goto :goto_5

    .line 83
    :cond_5
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    :goto_5
    move-object v3, p1

    add-int/lit8 v0, v0, 0x1

    goto :goto_4

    .line 86
    :cond_6
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    invoke-static {p0, v2, v3}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public resetChannelDataList(Ljava/lang/String;)V
    .locals 5

    .line 90
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "resetChannelDataList,name="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "UtilInitChannelData"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v0, 0x0

    move v1, v0

    .line 91
    :goto_0
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_1

    .line 92
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    iget-object v2, v2, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->mDBName:Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "database_"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 93
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "resetChannelDataList("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ") - dbname : "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v3, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    iget-object v3, v3, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->mDBName:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "caoshaowei"

    invoke-static {v3, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 94
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->deleteAll()V

    .line 95
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->close()V

    .line 96
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v4, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v4, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    iget-object v1, v1, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->mDBName:Ljava/lang/String;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ".db"

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Landroid/content/Context;->deleteDatabase(Ljava/lang/String;)Z

    goto :goto_1

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto/16 :goto_0

    .line 101
    :cond_1
    :goto_1
    invoke-virtual {p1}, Ljava/lang/String;->hashCode()I

    const/4 v1, -0x1

    invoke-virtual {p1}, Ljava/lang/String;->hashCode()I

    move-result v2

    sparse-switch v2, :sswitch_data_0

    goto/16 :goto_2

    :sswitch_0
    const-string v2, "channel_area_tw"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_2

    goto/16 :goto_2

    :cond_2
    const/16 v1, 0xe

    goto/16 :goto_2

    :sswitch_1
    const-string v2, "channel_area_ko"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_3

    goto/16 :goto_2

    :cond_3
    const/16 v1, 0xd

    goto/16 :goto_2

    :sswitch_2
    const-string v2, "channel_area_eu"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_4

    goto/16 :goto_2

    :cond_4
    const/16 v1, 0xc

    goto/16 :goto_2

    :sswitch_3
    const-string v2, "channel_area_cn"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_5

    goto/16 :goto_2

    :cond_5
    const/16 v1, 0xb

    goto/16 :goto_2

    :sswitch_4
    const-string v2, "channel_area_south_af"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_6

    goto/16 :goto_2

    :cond_6
    const/16 v1, 0xa

    goto/16 :goto_2

    :sswitch_5
    const-string v2, "channel_area_default_vhf"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_7

    goto/16 :goto_2

    :cond_7
    const/16 v1, 0x9

    goto/16 :goto_2

    :sswitch_6
    const-string v2, "channel_area_default_uhf"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_8

    goto/16 :goto_2

    :cond_8
    const/16 v1, 0x8

    goto/16 :goto_2

    :sswitch_7
    const-string v2, "channel_area_default"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_9

    goto :goto_2

    :cond_9
    const/4 v1, 0x7

    goto :goto_2

    :sswitch_8
    const-string v2, "channel_area_iran"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_a

    goto :goto_2

    :cond_a
    const/4 v1, 0x6

    goto :goto_2

    :sswitch_9
    const-string v2, "channel_area_malaysia"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_b

    goto :goto_2

    :cond_b
    const/4 v1, 0x5

    goto :goto_2

    :sswitch_a
    const-string v2, "channel_area_japan"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_c

    goto :goto_2

    :cond_c
    const/4 v1, 0x4

    goto :goto_2

    :sswitch_b
    const-string v2, "channel_area_usa"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_d

    goto :goto_2

    :cond_d
    const/4 v1, 0x3

    goto :goto_2

    :sswitch_c
    const-string v2, "channel_area_rus"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_e

    goto :goto_2

    :cond_e
    const/4 v1, 0x2

    goto :goto_2

    :sswitch_d
    const-string v2, "channel_area_aus"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_f

    goto :goto_2

    :cond_f
    const/4 v1, 0x1

    goto :goto_2

    :sswitch_e
    const-string v2, "channel_area_norway"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_10

    goto :goto_2

    :cond_10
    move v1, v0

    :goto_2
    packed-switch v1, :pswitch_data_0

    goto/16 :goto_3

    :pswitch_0
    const v0, 0x7f030002

    .line 117
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto/16 :goto_3

    :pswitch_1
    const v0, 0x7f030009

    .line 135
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto :goto_3

    :pswitch_2
    const v0, 0x7f030006

    .line 120
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto :goto_3

    :pswitch_3
    const v0, 0x7f030001

    .line 114
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto :goto_3

    :pswitch_4
    const v0, 0x7f03000d

    .line 147
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto :goto_3

    :pswitch_5
    const v0, 0x7f030005

    .line 111
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto :goto_3

    .line 107
    :pswitch_6
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultUHFChannelDb(Z)V

    const v0, 0x7f030004

    .line 108
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto :goto_3

    .line 103
    :pswitch_7
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initDefaultChannelDb()V

    const v0, 0x7f030003

    .line 104
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto :goto_3

    :pswitch_8
    const v0, 0x7f030007

    .line 132
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto :goto_3

    :pswitch_9
    const v0, 0x7f03000a

    .line 138
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto :goto_3

    :pswitch_a
    const v0, 0x7f030008

    .line 141
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto :goto_3

    :pswitch_b
    const v0, 0x7f03000e

    .line 123
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto :goto_3

    :pswitch_c
    const v0, 0x7f03000c

    .line 129
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto :goto_3

    :pswitch_d
    const/high16 v0, 0x7f030000

    .line 126
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    goto :goto_3

    :pswitch_e
    const v0, 0x7f03000b

    .line 144
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChanneldb(ILjava/lang/String;)V

    :goto_3
    return-void

    :sswitch_data_0
    .sparse-switch
        -0x79adcacc -> :sswitch_e
        -0x7477ec37 -> :sswitch_d
        -0x7477ac66 -> :sswitch_c
        -0x7477a173 -> :sswitch_b
        -0x35b7fd70 -> :sswitch_a
        -0x1d46eb8f -> :sswitch_9
        -0x1a8204b4 -> :sswitch_8
        0x2132da4b -> :sswitch_7
        0x3c83b03f -> :sswitch_6
        0x3c83b400 -> :sswitch_5
        0x46f6b50d -> :sswitch_4
        0x781d2a21 -> :sswitch_3
        0x781d2a66 -> :sswitch_2
        0x781d2b1a -> :sswitch_1
        0x781d2c39 -> :sswitch_0
    .end sparse-switch

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public resetData()V
    .locals 1

    const/4 v0, 0x0

    .line 530
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->resetData(Z)V

    return-void
.end method

.method public resetData(Z)V
    .locals 4

    .line 533
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    const-string v1, "pref_person_device_area_list"

    const-string v2, ""

    invoke-static {v0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 534
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    .line 535
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->deleteAll()V

    .line 536
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->close()V

    .line 537
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mContext:Landroid/content/Context;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, v1, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->mDBName:Ljava/lang/String;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ".db"

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Landroid/content/Context;->deleteDatabase(Ljava/lang/String;)Z

    goto :goto_0

    .line 539
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mUtilChannelDataList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 540
    invoke-direct {p0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChannelDataList()V

    .line 541
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChannelDb(Z)V

    return-void
.end method
