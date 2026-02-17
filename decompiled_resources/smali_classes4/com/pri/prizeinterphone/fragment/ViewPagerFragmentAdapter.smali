.class public Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;
.super Landroidx/fragment/app/FragmentPagerAdapter;
.source "ViewPagerFragmentAdapter.java"


# instance fields
.field private mFragments:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>(Landroidx/fragment/app/FragmentManager;)V
    .locals 0

    .line 14
    invoke-direct {p0, p1}, Landroidx/fragment/app/FragmentPagerAdapter;-><init>(Landroidx/fragment/app/FragmentManager;)V

    .line 11
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->mFragments:Ljava/util/ArrayList;

    return-void
.end method


# virtual methods
.method public add(Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;)V
    .locals 0

    .line 18
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->mFragments:Ljava/util/ArrayList;

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public getCount()I
    .locals 0

    .line 53
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->mFragments:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result p0

    return p0
.end method

.method public getItem(I)Landroidx/fragment/app/Fragment;
    .locals 0

    .line 48
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->mFragments:Ljava/util/ArrayList;

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroidx/fragment/app/Fragment;

    return-object p0
.end method

.method public getmFragments()Ljava/util/ArrayList;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;",
            ">;"
        }
    .end annotation

    .line 22
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->mFragments:Ljava/util/ArrayList;

    return-object p0
.end method

.method public updateFragmentView()V
    .locals 1

    .line 27
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->mFragments:Ljava/util/ArrayList;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-lez v0, :cond_0

    .line 28
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->mFragments:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

    .line 29
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->updateView()V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public updateFragmentView(I)V
    .locals 2

    .line 35
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->mFragments:Ljava/util/ArrayList;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-lez v0, :cond_1

    const/4 v0, 0x0

    .line 37
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->mFragments:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

    if-ne p1, v0, :cond_0

    .line 39
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->updateView()V

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    return-void
.end method
