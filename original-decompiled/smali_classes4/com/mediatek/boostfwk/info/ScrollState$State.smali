.class public Lcom/mediatek/boostfwk/info/ScrollState$State;
.super Ljava/lang/Object;
.source "ScrollState.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/boostfwk/info/ScrollState;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "State"
.end annotation


# instance fields
.field scrolling:Z

.field velocityX:I

.field velocityY:I


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 70
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 71
    iput-boolean v0, p0, Lcom/mediatek/boostfwk/info/ScrollState$State;->scrolling:Z

    const/4 v0, -0x1

    .line 72
    iput v0, p0, Lcom/mediatek/boostfwk/info/ScrollState$State;->velocityX:I

    .line 73
    iput v0, p0, Lcom/mediatek/boostfwk/info/ScrollState$State;->velocityY:I

    return-void
.end method
