.class public Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;
.super Ljava/lang/Object;
.source "NestedScrollViewOverScrollDecorAdapter.java"

# interfaces
.implements Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter$ImplVerticalLayout;,
        Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter$ImplHorizLayout;
    }
.end annotation


# instance fields
.field private final mImpl:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter$Impl;

.field private mIsItemTouchInEffect:Z

.field private final mScrollView:Landroidx/core/widget/NestedScrollView;


# direct methods
.method public constructor <init>(Landroidx/core/widget/NestedScrollView;I)V
    .locals 1

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 11
    iput-boolean v0, p0, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;->mIsItemTouchInEffect:Z

    .line 14
    iput-object p1, p0, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;->mScrollView:Landroidx/core/widget/NestedScrollView;

    if-nez p2, :cond_0

    .line 16
    new-instance p1, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter$ImplHorizLayout;

    invoke-direct {p1, p0}, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter$ImplHorizLayout;-><init>(Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;)V

    iput-object p1, p0, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;->mImpl:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter$Impl;

    goto :goto_0

    :cond_0
    const/4 p1, 0x1

    if-ne p2, p1, :cond_1

    .line 18
    new-instance p1, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter$ImplVerticalLayout;

    invoke-direct {p1, p0}, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter$ImplVerticalLayout;-><init>(Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;)V

    iput-object p1, p0, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;->mImpl:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter$Impl;

    :goto_0
    return-void

    .line 20
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Unknown orientation!"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method static synthetic access$000(Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;)Landroidx/core/widget/NestedScrollView;
    .locals 0

    .line 8
    iget-object p0, p0, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;->mScrollView:Landroidx/core/widget/NestedScrollView;

    return-object p0
.end method


# virtual methods
.method public getView()Landroid/view/View;
    .locals 0

    .line 25
    iget-object p0, p0, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;->mScrollView:Landroidx/core/widget/NestedScrollView;

    return-object p0
.end method

.method public isInAbsoluteEnd()Z
    .locals 1

    .line 33
    iget-boolean v0, p0, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;->mIsItemTouchInEffect:Z

    if-nez v0, :cond_0

    iget-object p0, p0, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;->mImpl:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter$Impl;

    invoke-interface {p0}, Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter$Impl;->isInAbsoluteEnd()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isInAbsoluteStart()Z
    .locals 1

    .line 29
    iget-boolean v0, p0, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;->mIsItemTouchInEffect:Z

    if-nez v0, :cond_0

    iget-object p0, p0, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;->mImpl:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter$Impl;

    invoke-interface {p0}, Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter$Impl;->isInAbsoluteStart()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method
