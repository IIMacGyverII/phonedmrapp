.class public Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;
.super Landroidx/fragment/app/Fragment;
.source "BaseViewPagerFragment.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$OnFragmentInteractionListener;
    }
.end annotation


# static fields
.field private static final ARG_PARAM1:Ljava/lang/String; = "param1"

.field private static final ARG_PARAM2:Ljava/lang/String; = "param2"

.field private static final TAG:Ljava/lang/String; = "BaseViewPagerFragment"


# instance fields
.field public mCurrentPosition:I

.field public mDismissRunnable:Ljava/lang/Runnable;

.field public mFragmentAdd:Landroid/widget/ImageView;

.field public mFragmentContainer:Landroid/widget/FrameLayout;

.field public mFragmentTile:Landroid/widget/TextView;

.field public mHandler:Landroid/os/Handler;

.field private mListener:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$OnFragmentInteractionListener;

.field private mParam1:Ljava/lang/String;

.field private mParam2:Ljava/lang/String;

.field private mProgressDialog:Landroid/app/ProgressDialog;

.field public mRootView:Landroid/view/View;

.field public mTitle:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 54
    invoke-direct {p0}, Landroidx/fragment/app/Fragment;-><init>()V

    .line 183
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mHandler:Landroid/os/Handler;

    .line 198
    new-instance v0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$2;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$2;-><init>(Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mDismissRunnable:Ljava/lang/Runnable;

    return-void
.end method

.method public constructor <init>(Ljava/lang/String;)V
    .locals 1

    .line 58
    invoke-direct {p0}, Landroidx/fragment/app/Fragment;-><init>()V

    .line 183
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mHandler:Landroid/os/Handler;

    .line 198
    new-instance v0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$2;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$2;-><init>(Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mDismissRunnable:Ljava/lang/Runnable;

    .line 60
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mTitle:Ljava/lang/String;

    return-void
.end method

.method public static newInstance(Ljava/lang/String;Ljava/lang/String;)Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;
    .locals 3

    .line 72
    new-instance v0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;-><init>()V

    .line 73
    new-instance v1, Landroid/os/Bundle;

    invoke-direct {v1}, Landroid/os/Bundle;-><init>()V

    const-string v2, "param1"

    .line 74
    invoke-virtual {v1, v2, p0}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    const-string p0, "param2"

    .line 75
    invoke-virtual {v1, p0, p1}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 76
    invoke-virtual {v0, v1}, Landroidx/fragment/app/Fragment;->setArguments(Landroid/os/Bundle;)V

    return-object v0
.end method


# virtual methods
.method public dismissProgressDialog()V
    .locals 1

    .line 194
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mProgressDialog:Landroid/app/ProgressDialog;

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->isAdded()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 195
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mProgressDialog:Landroid/app/ProgressDialog;

    invoke-virtual {p0}, Landroid/app/ProgressDialog;->dismiss()V

    :cond_0
    return-void
.end method

.method public doAddAction()V
    .locals 0

    return-void
.end method

.method public getMyTag()Ljava/lang/String;
    .locals 0

    const-string p0, "BaseViewPagerFragment"

    return-object p0
.end method

.method public initView(Landroid/view/View;)V
    .locals 1

    const v0, 0x7f0900ea

    .line 100
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mFragmentTile:Landroid/widget/TextView;

    .line 101
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->updateTitle()V

    const v0, 0x7f0900c9

    .line 102
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ImageView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mFragmentAdd:Landroid/widget/ImageView;

    .line 103
    new-instance v0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$1;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$1;-><init>(Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;)V

    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 109
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mRootView:Landroid/view/View;

    const v0, 0x7f0900d2

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/FrameLayout;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mFragmentContainer:Landroid/widget/FrameLayout;

    return-void
.end method

.method public onAttach(Landroid/content/Context;)V
    .locals 0

    .line 152
    invoke-super {p0, p1}, Landroidx/fragment/app/Fragment;->onAttach(Landroid/content/Context;)V

    return-void
.end method

.method public onButtonPressed(Landroid/net/Uri;)V
    .locals 0

    .line 145
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mListener:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$OnFragmentInteractionListener;

    if-eqz p0, :cond_0

    .line 146
    invoke-interface {p0, p1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$OnFragmentInteractionListener;->onFragmentInteraction(Landroid/net/Uri;)V

    :cond_0
    return-void
.end method

.method public onCreate(Landroid/os/Bundle;)V
    .locals 1

    .line 82
    invoke-super {p0, p1}, Landroidx/fragment/app/Fragment;->onCreate(Landroid/os/Bundle;)V

    .line 83
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getArguments()Landroid/os/Bundle;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 84
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getArguments()Landroid/os/Bundle;

    move-result-object p1

    const-string v0, "param1"

    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mParam1:Ljava/lang/String;

    .line 85
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getArguments()Landroid/os/Bundle;

    move-result-object p1

    const-string v0, "param2"

    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mParam2:Ljava/lang/String;

    :cond_0
    return-void
.end method

.method public onCreateView(Landroid/view/LayoutInflater;Landroid/view/ViewGroup;Landroid/os/Bundle;)Landroid/view/View;
    .locals 1

    const p3, 0x7f0c0037

    const/4 v0, 0x0

    .line 93
    invoke-virtual {p1, p3, p2, v0}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mRootView:Landroid/view/View;

    .line 94
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->getMyTag()Ljava/lang/String;

    move-result-object p1

    const-string p2, "onCreateView->initView"

    invoke-static {p1, p2}, Lcom/pri/prizeinterphone/Util/Clog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 95
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mRootView:Landroid/view/View;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->initView(Landroid/view/View;)V

    .line 96
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mRootView:Landroid/view/View;

    return-object p0
.end method

.method public onDetach()V
    .locals 1

    .line 163
    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onDetach()V

    const/4 v0, 0x0

    .line 164
    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mListener:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$OnFragmentInteractionListener;

    return-void
.end method

.method public setAddButton(I)V
    .locals 2

    .line 124
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mFragmentAdd:Landroid/widget/ImageView;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 125
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mFragmentAdd:Landroid/widget/ImageView;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/content/res/Resources;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    return-void
.end method

.method public setCurrentPosition(I)V
    .locals 0

    .line 129
    iput p1, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mCurrentPosition:I

    return-void
.end method

.method public setTitle(Ljava/lang/String;)V
    .locals 0

    .line 118
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mFragmentTile:Landroid/widget/TextView;

    if-eqz p0, :cond_0

    .line 119
    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_0
    return-void
.end method

.method public showProgressDialog(Ljava/lang/String;)V
    .locals 2

    .line 185
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mProgressDialog:Landroid/app/ProgressDialog;

    if-nez v0, :cond_0

    .line 186
    new-instance v0, Landroid/app/ProgressDialog;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/app/ProgressDialog;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mProgressDialog:Landroid/app/ProgressDialog;

    .line 189
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mProgressDialog:Landroid/app/ProgressDialog;

    invoke-virtual {v0, p1}, Landroid/app/ProgressDialog;->setMessage(Ljava/lang/CharSequence;)V

    .line 190
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mProgressDialog:Landroid/app/ProgressDialog;

    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Landroid/app/ProgressDialog;->setCancelable(Z)V

    .line 191
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mProgressDialog:Landroid/app/ProgressDialog;

    invoke-virtual {p0}, Landroid/app/ProgressDialog;->show()V

    return-void
.end method

.method public updateTitle()V
    .locals 1

    .line 134
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mTitle:Ljava/lang/String;

    if-eqz v0, :cond_0

    .line 135
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setTitle(Ljava/lang/String;)V

    :cond_0
    return-void
.end method

.method public updateView()V
    .locals 0

    return-void
.end method
