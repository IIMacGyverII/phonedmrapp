.class public Lcom/mediatek/widget/CustomAccountRemoteViews;
.super Ljava/lang/Object;
.source "CustomAccountRemoteViews.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;,
        Lcom/mediatek/widget/CustomAccountRemoteViews$IdIndex;
    }
.end annotation


# static fields
.field private static final MOSTACCOUNTNUMBER:I = 0x8

.field private static final ROWACCOUNTNUMBER:I = 0x4

.field private static final TAG:Ljava/lang/String; = "CustomAccountRemoteViews"


# instance fields
.field private final RESOURCE_ID:[[I

.field private mBigRemoteViews:Landroid/widget/RemoteViews;

.field private mContext:Landroid/content/Context;

.field private mData:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;",
            ">;"
        }
    .end annotation
.end field

.field private mNormalRemoteViews:Landroid/widget/RemoteViews;

.field private mRequestCode:I


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .locals 1

    const/4 v0, 0x0

    .line 68
    invoke-direct {p0, p1, p2, v0}, Lcom/mediatek/widget/CustomAccountRemoteViews;-><init>(Landroid/content/Context;Ljava/lang/String;Ljava/util/List;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;Ljava/util/List;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/lang/String;",
            "Ljava/util/List<",
            "Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;",
            ">;)V"
        }
    .end annotation

    .line 77
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/16 v0, 0x8

    new-array v0, v0, [[I

    const/4 v1, 0x6

    new-array v2, v1, [I

    .line 30
    fill-array-data v2, :array_0

    const/4 v3, 0x0

    aput-object v2, v0, v3

    new-array v2, v1, [I

    fill-array-data v2, :array_1

    const/4 v4, 0x1

    aput-object v2, v0, v4

    new-array v2, v1, [I

    fill-array-data v2, :array_2

    const/4 v4, 0x2

    aput-object v2, v0, v4

    new-array v2, v1, [I

    fill-array-data v2, :array_3

    const/4 v4, 0x3

    aput-object v2, v0, v4

    new-array v2, v1, [I

    fill-array-data v2, :array_4

    const/4 v4, 0x4

    aput-object v2, v0, v4

    new-array v2, v1, [I

    fill-array-data v2, :array_5

    const/4 v4, 0x5

    aput-object v2, v0, v4

    new-array v2, v1, [I

    fill-array-data v2, :array_6

    aput-object v2, v0, v1

    new-array v1, v1, [I

    fill-array-data v1, :array_7

    const/4 v2, 0x7

    aput-object v1, v0, v2

    iput-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->RESOURCE_ID:[[I

    .line 79
    new-instance v0, Landroid/widget/RemoteViews;

    const v1, 0x80d001a

    invoke-direct {v0, p2, v1}, Landroid/widget/RemoteViews;-><init>(Ljava/lang/String;I)V

    iput-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mNormalRemoteViews:Landroid/widget/RemoteViews;

    .line 80
    new-instance v0, Landroid/widget/RemoteViews;

    const v1, 0x80d000e

    invoke-direct {v0, p2, v1}, Landroid/widget/RemoteViews;-><init>(Ljava/lang/String;I)V

    iput-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    .line 82
    iput-object p3, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mData:Ljava/util/List;

    .line 83
    iput-object p1, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mContext:Landroid/content/Context;

    .line 84
    iput v3, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mRequestCode:I

    return-void

    :array_0
    .array-data 4
        0x80a0033
        0x80a0035
        0x80a0036
        0x80a0038
        0x80a0037
        0x80a0034
    .end array-data

    :array_1
    .array-data 4
        0x80a0012
        0x80a0014
        0x80a0015
        0x80a0017
        0x80a0016
        0x80a0013
    .end array-data

    :array_2
    .array-data 4
        0x80a002d
        0x80a002f
        0x80a0030
        0x80a0032
        0x80a0031
        0x80a002e
    .end array-data

    :array_3
    .array-data 4
        0x80a0027
        0x80a0029
        0x80a002a
        0x80a002c
        0x80a002b
        0x80a0028
    .end array-data

    :array_4
    .array-data 4
        0x80a000a
        0x80a000c
        0x80a000d
        0x80a000f
        0x80a000e
        0x80a000b
    .end array-data

    :array_5
    .array-data 4
        0x80a0004
        0x80a0006
        0x80a0007
        0x80a0009
        0x80a0008
        0x80a0005
    .end array-data

    :array_6
    .array-data 4
        0x80a0021
        0x80a0023
        0x80a0024
        0x80a0026
        0x80a0025
        0x80a0022
    .end array-data

    :array_7
    .array-data 4
        0x80a001b
        0x80a001d
        0x80a001e
        0x80a0020
        0x80a001f
        0x80a001c
    .end array-data
.end method

.method private configureAccount([ILcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;)V
    .locals 6

    .line 148
    invoke-virtual {p2}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->getIcon()Landroid/graphics/Bitmap;

    move-result-object v0

    const-string v1, "CustomAccountRemoteViews"

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v0, :cond_0

    .line 149
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    aget v4, p1, v3

    invoke-virtual {v0, v4, v3}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    .line 150
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    aget v2, p1, v2

    invoke-virtual {p2}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->getIcon()Landroid/graphics/Bitmap;

    move-result-object v4

    invoke-virtual {v0, v2, v4}, Landroid/widget/RemoteViews;->setImageViewBitmap(ILandroid/graphics/Bitmap;)V

    goto :goto_0

    .line 151
    :cond_0
    invoke-virtual {p2}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->getIconId()I

    move-result v0

    if-eqz v0, :cond_1

    .line 152
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    aget v4, p1, v3

    invoke-virtual {v0, v4, v3}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    .line 153
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    aget v2, p1, v2

    invoke-virtual {p2}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->getIconId()I

    move-result v4

    invoke-virtual {v0, v2, v4}, Landroid/widget/RemoteViews;->setImageViewResource(II)V

    goto :goto_0

    :cond_1
    const-string v0, "--- The icon of account is null ---"

    .line 155
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 158
    :goto_0
    invoke-virtual {p2}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->getLabel()Ljava/lang/String;

    move-result-object v0

    const/4 v2, 0x2

    const/16 v4, 0x8

    if-nez v0, :cond_2

    .line 159
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    aget v2, p1, v2

    invoke-virtual {v0, v2, v4}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    goto :goto_1

    .line 161
    :cond_2
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    aget v2, p1, v2

    invoke-virtual {p2}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->getLabel()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v2, v5}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    .line 164
    :goto_1
    invoke-virtual {p2}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->getNumber()Ljava/lang/String;

    move-result-object v0

    const/4 v2, 0x3

    if-nez v0, :cond_3

    .line 165
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    aget v2, p1, v2

    invoke-virtual {v0, v2, v4}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    goto :goto_2

    .line 167
    :cond_3
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    aget v2, p1, v2

    invoke-virtual {p2}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->getNumber()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v2, v5}, Landroid/widget/RemoteViews;->setTextViewText(ILjava/lang/CharSequence;)V

    .line 170
    :goto_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "active: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->isActive()Z

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 172
    invoke-virtual {p2}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->isActive()Z

    move-result v0

    const/4 v1, 0x5

    const/4 v2, 0x4

    if-eqz v0, :cond_4

    .line 174
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    aget v2, p1, v2

    invoke-virtual {v0, v2, v4}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    .line 175
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    aget v1, p1, v1

    invoke-virtual {v0, v1, v3}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    goto :goto_3

    .line 178
    :cond_4
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    aget v2, p1, v2

    invoke-virtual {v0, v2, v3}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    .line 179
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    aget v1, p1, v1

    invoke-virtual {v0, v1, v4}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    .line 182
    :goto_3
    invoke-virtual {p2}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->getIntent()Landroid/content/Intent;

    move-result-object v0

    if-eqz v0, :cond_5

    .line 183
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mContext:Landroid/content/Context;

    iget v1, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mRequestCode:I

    add-int/lit8 v2, v1, 0x1

    iput v2, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mRequestCode:I

    invoke-virtual {p2}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->getIntent()Landroid/content/Intent;

    move-result-object p2

    const/high16 v2, 0x8000000

    invoke-static {v0, v1, p2, v2}, Landroid/app/PendingIntent;->getBroadcast(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object p2

    .line 184
    iget-object p0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    aget p1, p1, v3

    invoke-virtual {p0, p1, p2}, Landroid/widget/RemoteViews;->setOnClickPendingIntent(ILandroid/app/PendingIntent;)V

    :cond_5
    return-void
.end method


# virtual methods
.method public configureView()V
    .locals 7

    .line 117
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mData:Ljava/util/List;

    const-string v1, "CustomAccountRemoteViews"

    if-eqz v0, :cond_3

    .line 119
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "---configureView---view size = "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mData:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 120
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mData:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    const v2, 0x80a007c

    const/4 v3, 0x0

    const/4 v4, 0x4

    if-le v0, v4, :cond_0

    .line 121
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    invoke-virtual {v0, v2, v3}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    :cond_0
    move v0, v3

    .line 123
    :goto_0
    iget-object v5, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mData:Ljava/util/List;

    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v5

    const/16 v6, 0x8

    if-ge v0, v5, :cond_1

    if-ge v0, v6, :cond_1

    .line 124
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "--- configure account id: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v1, v5}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 126
    iget-object v5, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mData:Ljava/util/List;

    invoke-interface {v5, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;

    .line 128
    iget-object v6, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->RESOURCE_ID:[[I

    aget-object v6, v6, v0

    .line 129
    invoke-direct {p0, v6, v5}, Lcom/mediatek/widget/CustomAccountRemoteViews;->configureAccount([ILcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 133
    :cond_1
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mData:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-gt v0, v4, :cond_2

    .line 135
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    invoke-virtual {v0, v2, v6}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    goto :goto_1

    :cond_2
    move v4, v6

    .line 137
    :goto_1
    iget-object v0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mData:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    :goto_2
    if-ge v0, v4, :cond_4

    .line 138
    iget-object v1, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    iget-object v2, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->RESOURCE_ID:[[I

    aget-object v2, v2, v0

    aget v2, v2, v3

    invoke-virtual {v1, v2, v6}, Landroid/widget/RemoteViews;->setViewVisibility(II)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    :cond_3
    const-string p0, "Data can not be null"

    .line 141
    invoke-static {v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :cond_4
    return-void
.end method

.method public getBigRemoteViews()Landroid/widget/RemoteViews;
    .locals 0

    .line 102
    iget-object p0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mBigRemoteViews:Landroid/widget/RemoteViews;

    return-object p0
.end method

.method public getNormalRemoteViews()Landroid/widget/RemoteViews;
    .locals 0

    .line 93
    iget-object p0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mNormalRemoteViews:Landroid/widget/RemoteViews;

    return-object p0
.end method

.method public setData(Ljava/util/List;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;",
            ">;)V"
        }
    .end annotation

    .line 110
    iput-object p1, p0, Lcom/mediatek/widget/CustomAccountRemoteViews;->mData:Ljava/util/List;

    return-void
.end method
