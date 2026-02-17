.class public Lcom/pri/didouix/core/view/NestedScrollingChildHelper;
.super Landroidx/core/view/NestedScrollingChildHelper;
.source "NestedScrollingChildHelper.java"


# instance fields
.field private mIsNestedScrollingEnabled:Z

.field private mNestedScrollingParentNonTouch:Landroid/view/ViewParent;

.field private mNestedScrollingParentTouch:Landroid/view/ViewParent;

.field private mTempNestedScrollConsumed:[I

.field private final mView:Landroid/view/View;


# direct methods
.method private constructor <init>(Landroid/view/View;)V
    .locals 0
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 22
    invoke-direct {p0, p1}, Landroidx/core/view/NestedScrollingChildHelper;-><init>(Landroid/view/View;)V

    .line 23
    iput-object p1, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    return-void
.end method

.method private dispatchNestedScrollInternal(IIII[II[I)Z
    .locals 15
    .param p5    # [I
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param
    .param p7    # [I
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param

    move-object v0, p0

    move-object/from16 v1, p5

    .line 100
    invoke-virtual {p0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->isNestedScrollingEnabled()Z

    move-result v2

    const/4 v3, 0x0

    if-eqz v2, :cond_6

    move/from16 v2, p6

    invoke-direct {p0, v2}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->getNestedScrollingParentForType(I)Landroid/view/ViewParent;

    move-result-object v4

    if-nez v4, :cond_0

    goto :goto_2

    :cond_0
    const/4 v12, 0x1

    if-nez p1, :cond_2

    if-nez p2, :cond_2

    if-nez p3, :cond_2

    if-nez p4, :cond_2

    if-eqz v1, :cond_1

    .line 105
    aput v3, v1, v3

    .line 106
    aput v3, v1, v12

    :cond_1
    return v3

    :cond_2
    if-eqz v1, :cond_3

    .line 111
    iget-object v5, v0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    invoke-virtual {v5, v1}, Landroid/view/View;->getLocationInWindow([I)V

    .line 112
    aget v5, v1, v3

    .line 113
    aget v6, v1, v12

    move v13, v5

    move v14, v6

    goto :goto_0

    :cond_3
    move v13, v3

    move v14, v13

    :goto_0
    if-nez p7, :cond_4

    .line 119
    invoke-direct {p0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->getTempNestedScrollConsumed()[I

    move-result-object v5

    .line 120
    aput v3, v5, v3

    .line 121
    aput v3, v5, v12

    move-object v11, v5

    goto :goto_1

    :cond_4
    move-object/from16 v11, p7

    .line 126
    :goto_1
    iget-object v5, v0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    move/from16 v6, p1

    move/from16 v7, p2

    move/from16 v8, p3

    move/from16 v9, p4

    move/from16 v10, p6

    invoke-static/range {v4 .. v11}, Lcom/pri/didouix/core/view/ViewParentCompat;->onNestedScroll(Landroid/view/ViewParent;Landroid/view/View;IIIII[I)V

    if-eqz v1, :cond_5

    .line 128
    iget-object v0, v0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/View;->getLocationInWindow([I)V

    .line 129
    aget v0, v1, v3

    sub-int/2addr v0, v13

    aput v0, v1, v3

    .line 130
    aget v0, v1, v12

    sub-int/2addr v0, v14

    aput v0, v1, v12

    :cond_5
    return v12

    :cond_6
    :goto_2
    return v3
.end method

.method private getNestedScrollingParentForType(I)Landroid/view/ViewParent;
    .locals 1

    if-nez p1, :cond_0

    .line 205
    iget-object p0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mNestedScrollingParentTouch:Landroid/view/ViewParent;

    return-object p0

    :cond_0
    const/4 v0, 0x1

    if-eq p1, v0, :cond_1

    const/4 p0, 0x0

    return-object p0

    .line 210
    :cond_1
    iget-object p0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mNestedScrollingParentNonTouch:Landroid/view/ViewParent;

    return-object p0
.end method

.method private getTempNestedScrollConsumed()[I
    .locals 1

    .line 222
    iget-object v0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mTempNestedScrollConsumed:[I

    if-nez v0, :cond_0

    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 223
    iput-object v0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mTempNestedScrollConsumed:[I

    .line 225
    :cond_0
    iget-object p0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mTempNestedScrollConsumed:[I

    return-object p0
.end method

.method private static isSupportDidouiNestedScrollingParent()Z
    .locals 1

    const/4 v0, 0x1

    return v0
.end method

.method public static obtain(Landroid/view/View;)Landroidx/core/view/NestedScrollingChildHelper;
    .locals 1

    .line 239
    new-instance v0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;

    invoke-direct {v0, p0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;-><init>(Landroid/view/View;)V

    return-object v0
.end method

.method private setNestedScrollingParentForType(ILandroid/view/ViewParent;)V
    .locals 1

    if-nez p1, :cond_0

    .line 215
    iput-object p2, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mNestedScrollingParentTouch:Landroid/view/ViewParent;

    goto :goto_0

    :cond_0
    const/4 v0, 0x1

    if-ne p1, v0, :cond_1

    .line 217
    iput-object p2, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mNestedScrollingParentNonTouch:Landroid/view/ViewParent;

    :cond_1
    :goto_0
    return-void
.end method


# virtual methods
.method public dispatchNestedFling(FFZ)Z
    .locals 2

    .line 181
    invoke-virtual {p0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->isNestedScrollingEnabled()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    invoke-direct {p0, v1}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->getNestedScrollingParentForType(I)Landroid/view/ViewParent;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 184
    :cond_0
    iget-object p0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    invoke-static {v0, p0, p1, p2, p3}, Lcom/pri/didouix/core/view/ViewParentCompat;->onNestedFling(Landroid/view/ViewParent;Landroid/view/View;FFZ)Z

    move-result p0

    return p0

    :cond_1
    :goto_0
    return v1
.end method

.method public dispatchNestedPreFling(FF)Z
    .locals 2

    .line 189
    invoke-virtual {p0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->isNestedScrollingEnabled()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    invoke-direct {p0, v1}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->getNestedScrollingParentForType(I)Landroid/view/ViewParent;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 192
    :cond_0
    iget-object p0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    invoke-static {v0, p0, p1, p2}, Lcom/pri/didouix/core/view/ViewParentCompat;->onNestedPreFling(Landroid/view/ViewParent;Landroid/view/View;FF)Z

    move-result p0

    return p0

    :cond_1
    :goto_0
    return v1
.end method

.method public dispatchNestedPreScroll(II[I[I)Z
    .locals 6

    const/4 v5, 0x0

    move-object v0, p0

    move v1, p1

    move v2, p2

    move-object v3, p3

    move-object v4, p4

    .line 137
    invoke-virtual/range {v0 .. v5}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->dispatchNestedPreScroll(II[I[II)Z

    move-result p0

    return p0
.end method

.method public dispatchNestedPreScroll(II[I[II)Z
    .locals 10
    .param p3    # [I
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param
    .param p4    # [I
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param

    .line 144
    invoke-virtual {p0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->isNestedScrollingEnabled()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_7

    invoke-direct {p0, p5}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->getNestedScrollingParentForType(I)Landroid/view/ViewParent;

    move-result-object v2

    if-nez v2, :cond_0

    goto :goto_1

    :cond_0
    const/4 v0, 0x1

    if-nez p1, :cond_2

    if-nez p2, :cond_2

    if-eqz p4, :cond_1

    .line 149
    aput v1, p4, v1

    .line 150
    aput v1, p4, v0

    :cond_1
    return v1

    :cond_2
    if-eqz p4, :cond_3

    .line 155
    iget-object v3, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    invoke-virtual {v3, p4}, Landroid/view/View;->getLocationInWindow([I)V

    .line 156
    aget v3, p4, v1

    .line 157
    aget v4, p4, v0

    move v8, v3

    move v9, v4

    goto :goto_0

    :cond_3
    move v8, v1

    move v9, v8

    :goto_0
    if-nez p3, :cond_4

    .line 163
    invoke-direct {p0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->getTempNestedScrollConsumed()[I

    move-result-object p3

    .line 165
    :cond_4
    aput v1, p3, v1

    .line 166
    aput v1, p3, v0

    .line 167
    iget-object v3, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    move v4, p1

    move v5, p2

    move-object v6, p3

    move v7, p5

    invoke-static/range {v2 .. v7}, Lcom/pri/didouix/core/view/ViewParentCompat;->onNestedPreScroll(Landroid/view/ViewParent;Landroid/view/View;II[II)V

    if-eqz p4, :cond_5

    .line 169
    iget-object p0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    invoke-virtual {p0, p4}, Landroid/view/View;->getLocationInWindow([I)V

    .line 170
    aget p0, p4, v1

    sub-int/2addr p0, v8

    aput p0, p4, v1

    .line 171
    aget p0, p4, v0

    sub-int/2addr p0, v9

    aput p0, p4, v0

    .line 173
    :cond_5
    aget p0, p3, v1

    if-nez p0, :cond_6

    aget p0, p3, v0

    if-nez p0, :cond_6

    return v1

    :cond_6
    return v0

    :cond_7
    :goto_1
    return v1
.end method

.method public dispatchNestedScroll(IIII[II[I)V
    .locals 0
    .param p5    # [I
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param
    .param p7    # [I
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param

    .line 91
    invoke-direct/range {p0 .. p7}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->dispatchNestedScrollInternal(IIII[II[I)Z

    return-void
.end method

.method public dispatchNestedScroll(IIII[I)Z
    .locals 8
    .param p5    # [I
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param

    const/4 v6, 0x0

    const/4 v7, 0x0

    move-object v0, p0

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move-object v5, p5

    .line 83
    invoke-direct/range {v0 .. v7}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->dispatchNestedScrollInternal(IIII[II[I)Z

    move-result p0

    return p0
.end method

.method public dispatchNestedScroll(IIII[II)Z
    .locals 8
    .param p5    # [I
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param

    const/4 v7, 0x0

    move-object v0, p0

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move-object v5, p5

    move v6, p6

    .line 87
    invoke-direct/range {v0 .. v7}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->dispatchNestedScrollInternal(IIII[II[I)Z

    move-result p0

    return p0
.end method

.method public hasNestedScrollingParent()Z
    .locals 1

    const/4 v0, 0x0

    .line 38
    invoke-virtual {p0, v0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->hasNestedScrollingParent(I)Z

    move-result p0

    return p0
.end method

.method public hasNestedScrollingParent(I)Z
    .locals 0

    .line 42
    invoke-direct {p0, p1}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->getNestedScrollingParentForType(I)Landroid/view/ViewParent;

    move-result-object p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isNestedScrollingEnabled()Z
    .locals 0

    .line 34
    iget-boolean p0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mIsNestedScrollingEnabled:Z

    return p0
.end method

.method public onDetachedFromWindow()V
    .locals 0

    .line 196
    iget-object p0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    invoke-static {p0}, Landroidx/core/view/ViewCompat;->stopNestedScroll(Landroid/view/View;)V

    return-void
.end method

.method public onStopNestedScroll(Landroid/view/View;)V
    .locals 0
    .param p1    # Landroid/view/View;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 200
    iget-object p0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    invoke-static {p0}, Landroidx/core/view/ViewCompat;->stopNestedScroll(Landroid/view/View;)V

    return-void
.end method

.method public setNestedScrollingEnabled(Z)V
    .locals 1

    .line 27
    iget-boolean v0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mIsNestedScrollingEnabled:Z

    if-eqz v0, :cond_0

    .line 28
    iget-object v0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    invoke-static {v0}, Landroidx/core/view/ViewCompat;->stopNestedScroll(Landroid/view/View;)V

    .line 30
    :cond_0
    iput-boolean p1, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mIsNestedScrollingEnabled:Z

    return-void
.end method

.method public startNestedScroll(I)Z
    .locals 1

    const/4 v0, 0x0

    .line 46
    invoke-virtual {p0, p1, v0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->startNestedScroll(II)Z

    move-result p0

    return p0
.end method

.method public startNestedScroll(II)Z
    .locals 5

    .line 50
    invoke-virtual {p0, p2}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->hasNestedScrollingParent(I)Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    return v1

    .line 53
    :cond_0
    invoke-virtual {p0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->isNestedScrollingEnabled()Z

    move-result v0

    const/4 v2, 0x0

    if-nez v0, :cond_1

    return v2

    .line 56
    :cond_1
    iget-object v0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    .line 57
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    :goto_0
    if-eqz v3, :cond_4

    .line 58
    iget-object v4, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    invoke-static {v3, v0, v4, p1, p2}, Lcom/pri/didouix/core/view/ViewParentCompat;->onStartNestedScroll(Landroid/view/ViewParent;Landroid/view/View;Landroid/view/View;II)Z

    move-result v4

    if-eqz v4, :cond_2

    .line 59
    invoke-direct {p0, p2, v3}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->setNestedScrollingParentForType(ILandroid/view/ViewParent;)V

    .line 60
    iget-object p0, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    invoke-static {v3, v0, p0, p1, p2}, Lcom/pri/didouix/core/view/ViewParentCompat;->onNestedScrollAccepted(Landroid/view/ViewParent;Landroid/view/View;Landroid/view/View;II)V

    return v1

    .line 63
    :cond_2
    instance-of v4, v3, Landroid/view/View;

    if-eqz v4, :cond_3

    .line 64
    move-object v0, v3

    check-cast v0, Landroid/view/View;

    .line 57
    :cond_3
    invoke-interface {v3}, Landroid/view/ViewParent;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    goto :goto_0

    :cond_4
    return v2
.end method

.method public stopNestedScroll()V
    .locals 1

    const/4 v0, 0x0

    .line 71
    invoke-virtual {p0, v0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->stopNestedScroll(I)V

    return-void
.end method

.method public stopNestedScroll(I)V
    .locals 2

    .line 75
    invoke-direct {p0, p1}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->getNestedScrollingParentForType(I)Landroid/view/ViewParent;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 77
    iget-object v1, p0, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->mView:Landroid/view/View;

    invoke-static {v0, v1, p1}, Lcom/pri/didouix/core/view/ViewParentCompat;->onStopNestedScroll(Landroid/view/ViewParent;Landroid/view/View;I)V

    const/4 v0, 0x0

    .line 78
    invoke-direct {p0, p1, v0}, Lcom/pri/didouix/core/view/NestedScrollingChildHelper;->setNestedScrollingParentForType(ILandroid/view/ViewParent;)V

    :cond_0
    return-void
.end method
