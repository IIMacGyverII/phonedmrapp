.class public Lcom/mediatek/pq/PictureQuality$Range;
.super Ljava/lang/Object;
.source "PictureQuality.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/pq/PictureQuality;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Range"
.end annotation


# instance fields
.field public defaultValue:I

.field public max:I

.field public min:I


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 106
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 107
    invoke-virtual {p0, v0, v0, v0}, Lcom/mediatek/pq/PictureQuality$Range;->set(III)V

    return-void
.end method


# virtual methods
.method public set(III)V
    .locals 0

    .line 111
    iput p1, p0, Lcom/mediatek/pq/PictureQuality$Range;->min:I

    .line 112
    iput p2, p0, Lcom/mediatek/pq/PictureQuality$Range;->max:I

    .line 113
    iput p3, p0, Lcom/mediatek/pq/PictureQuality$Range;->defaultValue:I

    return-void
.end method
