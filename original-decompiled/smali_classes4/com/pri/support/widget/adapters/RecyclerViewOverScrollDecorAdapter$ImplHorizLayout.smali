.class public Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter$ImplHorizLayout;
.super Ljava/lang/Object;
.source "RecyclerViewOverScrollDecorAdapter.java"

# interfaces
.implements Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter$Impl;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4
    name = "ImplHorizLayout"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;


# direct methods
.method protected constructor <init>(Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;)V
    .locals 0

    .line 50
    iput-object p1, p0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter$ImplHorizLayout;->this$0:Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public isInAbsoluteEnd()Z
    .locals 1

    .line 56
    iget-object p0, p0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter$ImplHorizLayout;->this$0:Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;

    invoke-static {p0}, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;->access$000(Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;)Landroidx/recyclerview/widget/RecyclerView;

    move-result-object p0

    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->canScrollHorizontally(I)Z

    move-result p0

    xor-int/2addr p0, v0

    return p0
.end method

.method public isInAbsoluteStart()Z
    .locals 1

    .line 52
    iget-object p0, p0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter$ImplHorizLayout;->this$0:Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;

    invoke-static {p0}, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;->access$000(Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;)Landroidx/recyclerview/widget/RecyclerView;

    move-result-object p0

    const/4 v0, -0x1

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->canScrollHorizontally(I)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method
