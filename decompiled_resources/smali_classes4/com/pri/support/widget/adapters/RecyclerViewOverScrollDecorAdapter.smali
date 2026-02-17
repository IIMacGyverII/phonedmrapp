.class public Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;
.super Ljava/lang/Object;
.source "RecyclerViewOverScrollDecorAdapter.java"

# interfaces
.implements Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter$ImplVerticalLayout;,
        Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter$ImplHorizLayout;
    }
.end annotation


# instance fields
.field private final mImpl:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter$Impl;

.field private mIsItemTouchInEffect:Z

.field private final mRecyclerView:Landroidx/recyclerview/widget/RecyclerView;


# direct methods
.method public constructor <init>(Landroidx/recyclerview/widget/RecyclerView;)V
    .locals 2

    .line 17
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 15
    iput-boolean v0, p0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;->mIsItemTouchInEffect:Z

    .line 19
    iput-object p1, p0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;->mRecyclerView:Landroidx/recyclerview/widget/RecyclerView;

    .line 20
    invoke-virtual {p1}, Landroidx/recyclerview/widget/RecyclerView;->getLayoutManager()Landroidx/recyclerview/widget/RecyclerView$LayoutManager;

    move-result-object p1

    .line 21
    instance-of v0, p1, Landroidx/recyclerview/widget/LinearLayoutManager;

    if-nez v0, :cond_1

    .line 22
    instance-of v1, p1, Landroidx/recyclerview/widget/StaggeredGridLayoutManager;

    if-eqz v1, :cond_0

    goto :goto_0

    .line 34
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Only support LinearLayoutManager&StaggeredGridLayoutManager layout manager or their subclasses!"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_1
    :goto_0
    if-eqz v0, :cond_2

    .line 24
    check-cast p1, Landroidx/recyclerview/widget/LinearLayoutManager;

    invoke-virtual {p1}, Landroidx/recyclerview/widget/LinearLayoutManager;->getOrientation()I

    move-result p1

    goto :goto_1

    .line 26
    :cond_2
    check-cast p1, Landroidx/recyclerview/widget/StaggeredGridLayoutManager;

    invoke-virtual {p1}, Landroidx/recyclerview/widget/StaggeredGridLayoutManager;->getOrientation()I

    move-result p1

    :goto_1
    if-nez p1, :cond_3

    .line 29
    new-instance p1, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter$ImplHorizLayout;

    invoke-direct {p1, p0}, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter$ImplHorizLayout;-><init>(Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;)V

    iput-object p1, p0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;->mImpl:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter$Impl;

    goto :goto_2

    .line 31
    :cond_3
    new-instance p1, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter$ImplVerticalLayout;

    invoke-direct {p1, p0}, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter$ImplVerticalLayout;-><init>(Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;)V

    iput-object p1, p0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;->mImpl:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter$Impl;

    :goto_2
    return-void
.end method

.method static synthetic access$000(Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;)Landroidx/recyclerview/widget/RecyclerView;
    .locals 0

    .line 12
    iget-object p0, p0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;->mRecyclerView:Landroidx/recyclerview/widget/RecyclerView;

    return-object p0
.end method


# virtual methods
.method public getView()Landroid/view/View;
    .locals 0

    .line 39
    iget-object p0, p0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;->mRecyclerView:Landroidx/recyclerview/widget/RecyclerView;

    return-object p0
.end method

.method public isInAbsoluteEnd()Z
    .locals 1

    .line 47
    iget-boolean v0, p0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;->mIsItemTouchInEffect:Z

    if-nez v0, :cond_0

    iget-object p0, p0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;->mImpl:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter$Impl;

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

    .line 43
    iget-boolean v0, p0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;->mIsItemTouchInEffect:Z

    if-nez v0, :cond_0

    iget-object p0, p0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;->mImpl:Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter$Impl;

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
