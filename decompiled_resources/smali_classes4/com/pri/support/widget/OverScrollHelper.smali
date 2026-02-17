.class public Lcom/pri/support/widget/OverScrollHelper;
.super Ljava/lang/Object;
.source "OverScrollHelper.java"


# static fields
.field public static final HORIZONTAL:I = 0x0

.field public static final VERTICAL:I = 0x1


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 12
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static setupOverScroll(Landroidx/core/widget/NestedScrollView;I)Lcom/pri/support/common/IOverScrollDecor;
    .locals 2

    if-eqz p1, :cond_1

    const/4 v0, 0x1

    if-ne p1, v0, :cond_0

    .line 42
    new-instance v0, Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator;

    new-instance v1, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;

    invoke-direct {v1, p0, p1}, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;-><init>(Landroidx/core/widget/NestedScrollView;I)V

    invoke-direct {v0, v1}, Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator;-><init>(Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;)V

    goto :goto_0

    .line 47
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string/jumbo p1, "unknown orientation! Only accept HORIZONTAL & VERTICAL orientation"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 37
    :cond_1
    new-instance v0, Lcom/pri/support/common/HorizontalOverScrollBounceEffectDecorator;

    new-instance v1, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;

    invoke-direct {v1, p0, p1}, Lcom/pri/support/widget/adapters/NestedScrollViewOverScrollDecorAdapter;-><init>(Landroidx/core/widget/NestedScrollView;I)V

    invoke-direct {v0, v1}, Lcom/pri/support/common/HorizontalOverScrollBounceEffectDecorator;-><init>(Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;)V

    :goto_0
    return-object v0
.end method

.method public static setupOverScroll(Landroidx/recyclerview/widget/RecyclerView;I)Lcom/pri/support/common/IOverScrollDecor;
    .locals 1

    if-eqz p1, :cond_1

    const/4 v0, 0x1

    if-ne p1, v0, :cond_0

    .line 24
    new-instance p1, Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator;

    new-instance v0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;

    invoke-direct {v0, p0}, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;-><init>(Landroidx/recyclerview/widget/RecyclerView;)V

    invoke-direct {p1, v0}, Lcom/pri/support/common/VerticalOverScrollBounceEffectDecorator;-><init>(Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;)V

    goto :goto_0

    .line 28
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string/jumbo p1, "unknown orientation! Only accept HORIZONTAL & VERTICAL orientation"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 20
    :cond_1
    new-instance p1, Lcom/pri/support/common/HorizontalOverScrollBounceEffectDecorator;

    new-instance v0, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;

    invoke-direct {v0, p0}, Lcom/pri/support/widget/adapters/RecyclerViewOverScrollDecorAdapter;-><init>(Landroidx/recyclerview/widget/RecyclerView;)V

    invoke-direct {p1, v0}, Lcom/pri/support/common/HorizontalOverScrollBounceEffectDecorator;-><init>(Lcom/pri/support/common/adapters/IOverScrollDecoratorAdapter;)V

    :goto_0
    return-object p1
.end method
