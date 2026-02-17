.class public Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;
.super Ljava/lang/Object;
.source "CustomAccountRemoteViews.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/widget/CustomAccountRemoteViews;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "AccountInfo"
.end annotation


# instance fields
.field private mIcon:Landroid/graphics/Bitmap;

.field private mIconId:I

.field private mIntent:Landroid/content/Intent;

.field private mIsActive:Z

.field private mLabel:Ljava/lang/String;

.field private mNumber:Ljava/lang/String;


# direct methods
.method public constructor <init>(ILandroid/graphics/Bitmap;Ljava/lang/String;Ljava/lang/String;Landroid/content/Intent;Z)V
    .locals 0

    .line 228
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 229
    iput p1, p0, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->mIconId:I

    .line 230
    iput-object p2, p0, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->mIcon:Landroid/graphics/Bitmap;

    .line 231
    iput-object p3, p0, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->mLabel:Ljava/lang/String;

    .line 232
    iput-object p4, p0, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->mNumber:Ljava/lang/String;

    .line 233
    iput-object p5, p0, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->mIntent:Landroid/content/Intent;

    .line 234
    iput-boolean p6, p0, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->mIsActive:Z

    return-void
.end method

.method public constructor <init>(ILjava/lang/String;Ljava/lang/String;Landroid/content/Intent;)V
    .locals 7

    const/4 v2, 0x0

    const/4 v6, 0x0

    move-object v0, p0

    move v1, p1

    move-object v3, p2

    move-object v4, p3

    move-object v5, p4

    .line 216
    invoke-direct/range {v0 .. v6}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;-><init>(ILandroid/graphics/Bitmap;Ljava/lang/String;Ljava/lang/String;Landroid/content/Intent;Z)V

    return-void
.end method

.method public constructor <init>(Landroid/graphics/Bitmap;Ljava/lang/String;Ljava/lang/String;Landroid/content/Intent;)V
    .locals 7

    const/4 v1, 0x0

    const/4 v6, 0x0

    move-object v0, p0

    move-object v2, p1

    move-object v3, p2

    move-object v4, p3

    move-object v5, p4

    .line 204
    invoke-direct/range {v0 .. v6}, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;-><init>(ILandroid/graphics/Bitmap;Ljava/lang/String;Ljava/lang/String;Landroid/content/Intent;Z)V

    return-void
.end method


# virtual methods
.method public getIcon()Landroid/graphics/Bitmap;
    .locals 0

    .line 253
    iget-object p0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->mIcon:Landroid/graphics/Bitmap;

    if-eqz p0, :cond_0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method public getIconId()I
    .locals 0

    .line 242
    iget p0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->mIconId:I

    if-eqz p0, :cond_0

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public getIntent()Landroid/content/Intent;
    .locals 0

    .line 280
    iget-object p0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->mIntent:Landroid/content/Intent;

    return-object p0
.end method

.method public getLabel()Ljava/lang/String;
    .locals 0

    .line 264
    iget-object p0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->mLabel:Ljava/lang/String;

    return-object p0
.end method

.method public getNumber()Ljava/lang/String;
    .locals 0

    .line 272
    iget-object p0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->mNumber:Ljava/lang/String;

    return-object p0
.end method

.method public isActive()Z
    .locals 0

    .line 288
    iget-boolean p0, p0, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->mIsActive:Z

    return p0
.end method

.method public setActiveStatus(Z)V
    .locals 0

    .line 296
    iput-boolean p1, p0, Lcom/mediatek/widget/CustomAccountRemoteViews$AccountInfo;->mIsActive:Z

    return-void
.end method
