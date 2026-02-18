.class public Lcom/android/internal/telephony/cat/IconLoader;
.super Landroid/os/Handler;
.source "IconLoader.java"


# static fields
.field protected static final CLUT_ENTRY_SIZE:I = 0x3

.field protected static final CLUT_LOCATION_OFFSET:I = 0x4

.field protected static final EVENT_READ_CLUT_DONE:I = 0x3

.field protected static final EVENT_READ_EF_IMG_RECOED_DONE:I = 0x1

.field protected static final EVENT_READ_ICON_DONE:I = 0x2

.field protected static final STATE_MULTI_ICONS:I = 0x2

.field protected static final STATE_SINGLE_ICON:I = 0x1

.field private static sLoader:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Object;",
            "Lcom/android/internal/telephony/cat/IconLoader;",
            ">;"
        }
    .end annotation
.end field

.field private static sThread:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Object;",
            "Landroid/os/HandlerThread;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field protected mCurrentIcon:Landroid/graphics/Bitmap;

.field protected mCurrentRecordIndex:I

.field protected mEndMsg:Landroid/os/Message;

.field protected mIconData:[B

.field protected mIcons:[Landroid/graphics/Bitmap;

.field protected mIconsCache:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Integer;",
            "Landroid/graphics/Bitmap;",
            ">;"
        }
    .end annotation
.end field

.field protected mId:Lcom/android/internal/telephony/cat/ImageDescriptor;

.field protected mRecordNumber:I

.field protected mRecordNumbers:[I

.field protected mSimFH:Lcom/android/internal/telephony/uicc/IccFileHandler;

.field protected mState:I


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>(Landroid/os/Looper;Lcom/android/internal/telephony/uicc/IccFileHandler;)V
    .locals 1

    .line 81
    invoke-direct {p0, p1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    const/4 p1, 0x1

    .line 44
    iput p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mState:I

    const/4 p1, 0x0

    .line 45
    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mId:Lcom/android/internal/telephony/cat/ImageDescriptor;

    .line 46
    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentIcon:Landroid/graphics/Bitmap;

    .line 49
    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mEndMsg:Landroid/os/Message;

    .line 50
    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIconData:[B

    .line 52
    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mRecordNumbers:[I

    const/4 v0, 0x0

    .line 53
    iput v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentRecordIndex:I

    .line 54
    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIcons:[Landroid/graphics/Bitmap;

    .line 55
    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIconsCache:Ljava/util/HashMap;

    .line 82
    iput-object p2, p0, Lcom/android/internal/telephony/cat/IconLoader;->mSimFH:Lcom/android/internal/telephony/uicc/IccFileHandler;

    .line 84
    new-instance p1, Ljava/util/HashMap;

    const/16 p2, 0x32

    invoke-direct {p1, p2}, Ljava/util/HashMap;-><init>(I)V

    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIconsCache:Ljava/util/HashMap;

    return-void
.end method

.method private static bitToBnW(I)I
    .locals 1

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    const/4 p0, -0x1

    return p0

    :cond_0
    const/high16 p0, -0x1000000

    return p0
.end method

.method static getInstance(Landroid/os/Handler;Lcom/android/internal/telephony/uicc/IccFileHandler;)Lcom/android/internal/telephony/cat/IconLoader;
    .locals 2

    .line 88
    sget-object p0, Lcom/android/internal/telephony/cat/IconLoader;->sLoader:Ljava/util/HashMap;

    if-eqz p0, :cond_0

    invoke-virtual {p0, p1}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    .line 89
    sget-object p0, Lcom/android/internal/telephony/cat/IconLoader;->sLoader:Ljava/util/HashMap;

    invoke-virtual {p0, p1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/cat/IconLoader;

    return-object p0

    :cond_0
    if-eqz p1, :cond_3

    .line 95
    sget-object p0, Lcom/android/internal/telephony/cat/IconLoader;->sThread:Ljava/util/HashMap;

    const/4 v0, 0x4

    if-nez p0, :cond_1

    .line 96
    new-instance p0, Ljava/util/HashMap;

    invoke-direct {p0, v0}, Ljava/util/HashMap;-><init>(I)V

    sput-object p0, Lcom/android/internal/telephony/cat/IconLoader;->sThread:Ljava/util/HashMap;

    .line 98
    :cond_1
    new-instance p0, Landroid/os/HandlerThread;

    const-string v1, "Cat Icon Loader"

    invoke-direct {p0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    .line 99
    sget-object v1, Lcom/android/internal/telephony/cat/IconLoader;->sThread:Ljava/util/HashMap;

    invoke-virtual {v1, p1, p0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 100
    invoke-virtual {p0}, Landroid/os/HandlerThread;->start()V

    .line 102
    sget-object v1, Lcom/android/internal/telephony/cat/IconLoader;->sLoader:Ljava/util/HashMap;

    if-nez v1, :cond_2

    .line 103
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1, v0}, Ljava/util/HashMap;-><init>(I)V

    sput-object v1, Lcom/android/internal/telephony/cat/IconLoader;->sLoader:Ljava/util/HashMap;

    .line 105
    :cond_2
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v0

    const-class v1, Lcom/android/internal/telephony/TelephonyComponentFactory;

    .line 106
    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v0

    .line 107
    invoke-virtual {p0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object p0

    invoke-virtual {v0, p0, p1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeIconLoader(Landroid/os/Looper;Lcom/android/internal/telephony/uicc/IccFileHandler;)Lcom/android/internal/telephony/cat/IconLoader;

    move-result-object p0

    .line 108
    sget-object v0, Lcom/android/internal/telephony/cat/IconLoader;->sLoader:Ljava/util/HashMap;

    invoke-virtual {v0, p1, p0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-object p0

    :cond_3
    const/4 p0, 0x0

    return-object p0
.end method

.method private static getMask(I)I
    .locals 0

    packed-switch p0, :pswitch_data_0

    const/4 p0, 0x0

    goto :goto_0

    :pswitch_0
    const/16 p0, 0xff

    goto :goto_0

    :pswitch_1
    const/16 p0, 0x7f

    goto :goto_0

    :pswitch_2
    const/16 p0, 0x3f

    goto :goto_0

    :pswitch_3
    const/16 p0, 0x1f

    goto :goto_0

    :pswitch_4
    const/16 p0, 0xf

    goto :goto_0

    :pswitch_5
    const/4 p0, 0x7

    goto :goto_0

    :pswitch_6
    const/4 p0, 0x3

    goto :goto_0

    :pswitch_7
    const/4 p0, 0x1

    :goto_0
    return p0

    :pswitch_data_0
    .packed-switch 0x1
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

.method public static parseToBnW([BI)Landroid/graphics/Bitmap;
    .locals 12

    const/4 p1, 0x0

    .line 285
    aget-byte v0, p0, p1

    and-int/lit16 v0, v0, 0xff

    const/4 v1, 0x1

    .line 286
    aget-byte v2, p0, v1

    and-int/lit16 v2, v2, 0xff

    mul-int v3, v0, v2

    .line 289
    new-array v4, v3, [I

    const/4 v5, 0x7

    const/4 v6, 0x2

    move v8, v5

    move v7, v6

    move v6, p1

    :goto_0
    if-ge p1, v3, :cond_1

    .line 296
    rem-int/lit8 v9, p1, 0x8

    if-nez v9, :cond_0

    add-int/lit8 v6, v7, 0x1

    .line 297
    aget-byte v7, p0, v7

    move v8, v5

    move v11, v7

    move v7, v6

    move v6, v11

    :cond_0
    add-int/lit8 v9, p1, 0x1

    add-int/lit8 v10, v8, -0x1

    shr-int v8, v6, v8

    and-int/2addr v8, v1

    .line 300
    invoke-static {v8}, Lcom/android/internal/telephony/cat/IconLoader;->bitToBnW(I)I

    move-result v8

    aput v8, v4, p1

    move p1, v9

    move v8, v10

    goto :goto_0

    :cond_1
    if-eq p1, v3, :cond_2

    const-string p0, "IconLoader"

    const-string p1, "parseToBnW; size error"

    .line 304
    invoke-static {p0, p1}, Lcom/android/internal/telephony/cat/CatLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 306
    :cond_2
    sget-object p0, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v4, v0, v2, p0}, Landroid/graphics/Bitmap;->createBitmap([IIILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object p0

    return-object p0
.end method

.method public static parseToRGB([BIZ[B)Landroid/graphics/Bitmap;
    .locals 18

    const/4 v0, 0x0

    .line 336
    aget-byte v1, p0, v0

    and-int/lit16 v1, v1, 0xff

    const/4 v2, 0x1

    .line 337
    aget-byte v3, p0, v2

    and-int/lit16 v3, v3, 0xff

    const/4 v4, 0x2

    .line 338
    aget-byte v5, p0, v4

    and-int/lit16 v5, v5, 0xff

    const/4 v6, 0x3

    .line 339
    aget-byte v7, p0, v6

    and-int/lit16 v7, v7, 0xff

    move/from16 v8, p2

    if-ne v2, v8, :cond_0

    sub-int/2addr v7, v2

    .line 342
    aput-byte v0, p3, v7

    :cond_0
    mul-int v7, v1, v3

    .line 346
    new-array v8, v7, [I

    const/4 v9, 0x6

    rsub-int/lit8 v10, v5, 0x8

    const/4 v11, 0x7

    .line 352
    aget-byte v9, p0, v9

    .line 353
    invoke-static {v5}, Lcom/android/internal/telephony/cat/IconLoader;->getMask(I)I

    move-result v12

    const/16 v13, 0x8

    .line 354
    rem-int/2addr v13, v5

    if-nez v13, :cond_1

    goto :goto_0

    :cond_1
    move v2, v0

    :goto_0
    move v13, v10

    :goto_1
    if-ge v0, v7, :cond_4

    if-gez v13, :cond_3

    add-int/lit8 v9, v11, 0x1

    .line 358
    aget-byte v11, p0, v11

    if-eqz v2, :cond_2

    move v13, v10

    goto :goto_2

    :cond_2
    mul-int/lit8 v13, v13, -0x1

    :goto_2
    move/from16 v17, v11

    move v11, v9

    move/from16 v9, v17

    :cond_3
    shr-int v14, v9, v13

    and-int/2addr v14, v12

    mul-int/2addr v14, v6

    add-int/lit8 v15, v0, 0x1

    .line 363
    aget-byte v6, p3, v14

    add-int/lit8 v16, v14, 0x1

    move/from16 p2, v2

    aget-byte v2, p3, v16

    add-int/2addr v14, v4

    aget-byte v14, p3, v14

    invoke-static {v6, v2, v14}, Landroid/graphics/Color;->rgb(III)I

    move-result v2

    aput v2, v8, v0

    sub-int/2addr v13, v5

    move/from16 v2, p2

    move v0, v15

    const/4 v6, 0x3

    goto :goto_1

    .line 368
    :cond_4
    sget-object v0, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v8, v1, v3, v0}, Landroid/graphics/Bitmap;->createBitmap([IIILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v0

    return-object v0
.end method


# virtual methods
.method public dispose()V
    .locals 3

    .line 411
    sget-object v0, Lcom/android/internal/telephony/cat/IconLoader;->sThread:Ljava/util/HashMap;

    if-eqz v0, :cond_1

    iget-object v1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mSimFH:Lcom/android/internal/telephony/uicc/IccFileHandler;

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 412
    sget-object v0, Lcom/android/internal/telephony/cat/IconLoader;->sThread:Ljava/util/HashMap;

    iget-object v1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mSimFH:Lcom/android/internal/telephony/uicc/IccFileHandler;

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/HandlerThread;

    if-eqz v0, :cond_0

    .line 414
    invoke-virtual {v0}, Landroid/os/HandlerThread;->quit()Z

    .line 417
    :cond_0
    sget-object v0, Lcom/android/internal/telephony/cat/IconLoader;->sThread:Ljava/util/HashMap;

    iget-object v1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mSimFH:Lcom/android/internal/telephony/uicc/IccFileHandler;

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1
    const/4 v0, 0x0

    .line 426
    iput-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIconsCache:Ljava/util/HashMap;

    .line 429
    sget-object v1, Lcom/android/internal/telephony/cat/IconLoader;->sLoader:Ljava/util/HashMap;

    if-eqz v1, :cond_2

    iget-object v2, p0, Lcom/android/internal/telephony/cat/IconLoader;->mSimFH:Lcom/android/internal/telephony/uicc/IccFileHandler;

    invoke-virtual {v1, v2}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 430
    sget-object v1, Lcom/android/internal/telephony/cat/IconLoader;->sLoader:Ljava/util/HashMap;

    iget-object v2, p0, Lcom/android/internal/telephony/cat/IconLoader;->mSimFH:Lcom/android/internal/telephony/uicc/IccFileHandler;

    invoke-virtual {v1, v2}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/cat/IconLoader;

    .line 432
    sget-object v1, Lcom/android/internal/telephony/cat/IconLoader;->sLoader:Ljava/util/HashMap;

    iget-object v2, p0, Lcom/android/internal/telephony/cat/IconLoader;->mSimFH:Lcom/android/internal/telephony/uicc/IccFileHandler;

    invoke-virtual {v1, v2}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 434
    :cond_2
    iput-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mSimFH:Lcom/android/internal/telephony/uicc/IccFileHandler;

    return-void
.end method

.method protected handleImageDescriptor([B)Z
    .locals 1

    const/4 v0, 0x1

    .line 219
    invoke-static {p1, v0}, Lcom/android/internal/telephony/cat/ImageDescriptor;->parse([BI)Lcom/android/internal/telephony/cat/ImageDescriptor;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mId:Lcom/android/internal/telephony/cat/ImageDescriptor;

    if-nez p1, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    return v0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 3

    .line 168
    :try_start_0
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_4

    const/4 v1, 0x2

    if-eq v0, v1, :cond_1

    const/4 v1, 0x3

    if-eq v0, v1, :cond_0

    goto/16 :goto_0

    .line 194
    :cond_0
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 195
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [B

    .line 196
    iget-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIconData:[B

    array-length v1, v0

    const/4 v2, 0x0

    invoke-static {v0, v1, v2, p1}, Lcom/android/internal/telephony/cat/IconLoader;->parseToRGB([BIZ[B)Landroid/graphics/Bitmap;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentIcon:Landroid/graphics/Bitmap;

    .line 198
    iget-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIconsCache:Ljava/util/HashMap;

    iget v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mRecordNumber:I

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentIcon:Landroid/graphics/Bitmap;

    invoke-virtual {p1, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 199
    invoke-virtual {p0}, Lcom/android/internal/telephony/cat/IconLoader;->postIcon()V

    goto :goto_0

    :cond_1
    const-string v0, "load icon done"

    .line 178
    invoke-static {p0, v0}, Lcom/android/internal/telephony/cat/CatLog;->d(Ljava/lang/Object;Ljava/lang/String;)V

    .line 179
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 180
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [B

    .line 181
    iget-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mId:Lcom/android/internal/telephony/cat/ImageDescriptor;

    iget v0, v0, Lcom/android/internal/telephony/cat/ImageDescriptor;->mCodingScheme:I

    const/16 v1, 0x11

    if-ne v0, v1, :cond_2

    .line 182
    array-length v0, p1

    invoke-static {p1, v0}, Lcom/android/internal/telephony/cat/IconLoader;->parseToBnW([BI)Landroid/graphics/Bitmap;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentIcon:Landroid/graphics/Bitmap;

    .line 183
    iget-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIconsCache:Ljava/util/HashMap;

    iget v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mRecordNumber:I

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentIcon:Landroid/graphics/Bitmap;

    invoke-virtual {p1, v0, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 184
    invoke-virtual {p0}, Lcom/android/internal/telephony/cat/IconLoader;->postIcon()V

    goto :goto_0

    :cond_2
    const/16 v1, 0x21

    if-ne v0, v1, :cond_3

    .line 186
    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIconData:[B

    .line 187
    invoke-virtual {p0}, Lcom/android/internal/telephony/cat/IconLoader;->readClut()V

    goto :goto_0

    :cond_3
    const-string p1, "else  /postIcon "

    .line 189
    invoke-static {p0, p1}, Lcom/android/internal/telephony/cat/CatLog;->d(Ljava/lang/Object;Ljava/lang/String;)V

    .line 190
    invoke-virtual {p0}, Lcom/android/internal/telephony/cat/IconLoader;->postIcon()V

    goto :goto_0

    .line 170
    :cond_4
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 171
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [B

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/cat/IconLoader;->handleImageDescriptor([B)Z

    move-result p1

    if-eqz p1, :cond_5

    .line 172
    invoke-virtual {p0}, Lcom/android/internal/telephony/cat/IconLoader;->readIconData()V

    goto :goto_0

    .line 174
    :cond_5
    new-instance p1, Ljava/lang/Exception;

    const-string v0, "Unable to parse image descriptor"

    invoke-direct {p1, v0}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    const-string p1, "Icon load failed"

    .line 203
    invoke-static {p0, p1}, Lcom/android/internal/telephony/cat/CatLog;->d(Ljava/lang/Object;Ljava/lang/String;)V

    .line 205
    invoke-virtual {p0}, Lcom/android/internal/telephony/cat/IconLoader;->postIcon()V

    :goto_0
    return-void
.end method

.method public loadIcon(ILandroid/os/Message;)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    if-nez p2, :cond_0

    return-void

    .line 138
    :cond_0
    iput-object p2, p0, Lcom/android/internal/telephony/cat/IconLoader;->mEndMsg:Landroid/os/Message;

    const/4 p2, 0x1

    .line 139
    iput p2, p0, Lcom/android/internal/telephony/cat/IconLoader;->mState:I

    .line 140
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/cat/IconLoader;->startLoadingIcon(I)V

    return-void
.end method

.method public loadIcons([ILandroid/os/Message;)V
    .locals 1

    if-eqz p1, :cond_1

    .line 119
    array-length v0, p1

    if-eqz v0, :cond_1

    if-nez p2, :cond_0

    goto :goto_0

    .line 122
    :cond_0
    iput-object p2, p0, Lcom/android/internal/telephony/cat/IconLoader;->mEndMsg:Landroid/os/Message;

    .line 124
    array-length p2, p1

    new-array p2, p2, [Landroid/graphics/Bitmap;

    iput-object p2, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIcons:[Landroid/graphics/Bitmap;

    .line 125
    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mRecordNumbers:[I

    const/4 p2, 0x0

    .line 126
    iput p2, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentRecordIndex:I

    const/4 v0, 0x2

    .line 127
    iput v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mState:I

    .line 128
    aget p1, p1, p2

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/cat/IconLoader;->startLoadingIcon(I)V

    :cond_1
    :goto_0
    return-void
.end method

.method protected postIcon()V
    .locals 4

    .line 262
    iget v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mState:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 263
    iget-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mEndMsg:Landroid/os/Message;

    iget-object p0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentIcon:Landroid/graphics/Bitmap;

    iput-object p0, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 264
    invoke-virtual {v0}, Landroid/os/Message;->sendToTarget()V

    goto :goto_0

    :cond_0
    const/4 v1, 0x2

    if-ne v0, v1, :cond_2

    .line 266
    iget-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIcons:[Landroid/graphics/Bitmap;

    iget v1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentRecordIndex:I

    add-int/lit8 v2, v1, 0x1

    iput v2, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentRecordIndex:I

    iget-object v3, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentIcon:Landroid/graphics/Bitmap;

    aput-object v3, v0, v1

    .line 268
    iget-object v1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mRecordNumbers:[I

    array-length v3, v1

    if-ge v2, v3, :cond_1

    .line 269
    aget v0, v1, v2

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/cat/IconLoader;->startLoadingIcon(I)V

    goto :goto_0

    .line 271
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mEndMsg:Landroid/os/Message;

    iput-object v0, p0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 272
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    :cond_2
    :goto_0
    return-void
.end method

.method protected readClut()V
    .locals 8

    .line 230
    iget-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIconData:[B

    const/4 v1, 0x3

    aget-byte v0, v0, v1

    mul-int/lit8 v6, v0, 0x3

    .line 231
    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v7

    .line 232
    iget-object v2, p0, Lcom/android/internal/telephony/cat/IconLoader;->mSimFH:Lcom/android/internal/telephony/uicc/IccFileHandler;

    iget-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mId:Lcom/android/internal/telephony/cat/ImageDescriptor;

    iget v3, v0, Lcom/android/internal/telephony/cat/ImageDescriptor;->mImageId:I

    iget-object p0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIconData:[B

    const/4 v0, 0x4

    aget-byte v4, p0, v0

    const/4 v0, 0x5

    aget-byte v5, p0, v0

    invoke-virtual/range {v2 .. v7}, Lcom/android/internal/telephony/uicc/IccFileHandler;->loadEFImgTransparent(IIIILandroid/os/Message;)V

    return-void
.end method

.method protected readIconData()V
    .locals 7

    const/4 v0, 0x2

    .line 254
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v6

    .line 255
    iget-object v1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mSimFH:Lcom/android/internal/telephony/uicc/IccFileHandler;

    iget-object p0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mId:Lcom/android/internal/telephony/cat/ImageDescriptor;

    iget v2, p0, Lcom/android/internal/telephony/cat/ImageDescriptor;->mImageId:I

    iget v5, p0, Lcom/android/internal/telephony/cat/ImageDescriptor;->mLength:I

    const/4 v3, 0x0

    const/4 v4, 0x0

    invoke-virtual/range {v1 .. v6}, Lcom/android/internal/telephony/uicc/IccFileHandler;->loadEFImgTransparent(IIIILandroid/os/Message;)V

    return-void
.end method

.method protected readId()V
    .locals 2

    .line 241
    iget v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mRecordNumber:I

    if-gez v0, :cond_0

    const/4 v0, 0x0

    .line 242
    iput-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentIcon:Landroid/graphics/Bitmap;

    .line 243
    invoke-virtual {p0}, Lcom/android/internal/telephony/cat/IconLoader;->postIcon()V

    return-void

    :cond_0
    const/4 v0, 0x1

    .line 246
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    .line 247
    iget-object v1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mSimFH:Lcom/android/internal/telephony/uicc/IccFileHandler;

    iget p0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mRecordNumber:I

    invoke-virtual {v1, p0, v0}, Lcom/android/internal/telephony/uicc/IccFileHandler;->loadEFImgLinearFixed(ILandroid/os/Message;)V

    return-void
.end method

.method protected startLoadingIcon(I)V
    .locals 2

    const/4 v0, 0x0

    .line 147
    iput-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mId:Lcom/android/internal/telephony/cat/ImageDescriptor;

    .line 148
    iput-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIconData:[B

    .line 149
    iput-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentIcon:Landroid/graphics/Bitmap;

    .line 150
    iput p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mRecordNumber:I

    .line 153
    iget-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIconsCache:Ljava/util/HashMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 154
    iget-object v0, p0, Lcom/android/internal/telephony/cat/IconLoader;->mIconsCache:Ljava/util/HashMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/graphics/Bitmap;

    iput-object p1, p0, Lcom/android/internal/telephony/cat/IconLoader;->mCurrentIcon:Landroid/graphics/Bitmap;

    .line 155
    invoke-virtual {p0}, Lcom/android/internal/telephony/cat/IconLoader;->postIcon()V

    return-void

    .line 160
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/cat/IconLoader;->readId()V

    return-void
.end method
