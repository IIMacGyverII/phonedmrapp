.class public Lcom/mediatek/pq/PictureQuality$GammaLut;
.super Ljava/lang/Object;
.source "PictureQuality.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/pq/PictureQuality;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "GammaLut"
.end annotation


# instance fields
.field public hwid:I

.field public lut:[I


# direct methods
.method public constructor <init>()V
    .locals 3

    .line 122
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/16 v0, 0x200

    new-array v1, v0, [I

    .line 123
    iput-object v1, p0, Lcom/mediatek/pq/PictureQuality$GammaLut;->lut:[I

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ge v2, v0, :cond_0

    .line 125
    invoke-virtual {p0, v2, v1}, Lcom/mediatek/pq/PictureQuality$GammaLut;->set(II)V

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method


# virtual methods
.method public set(II)V
    .locals 1

    if-ltz p1, :cond_0

    const/16 v0, 0x200

    if-ge p1, v0, :cond_0

    .line 131
    iget-object p0, p0, Lcom/mediatek/pq/PictureQuality$GammaLut;->lut:[I

    aput p2, p0, p1

    :cond_0
    return-void
.end method
