.class public Lcom/pri/prizeinterphone/InterPhoneHomeActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "InterPhoneHomeActivity.java"

# interfaces
.implements Lcom/pri/prizeinterphone/manager/DmrManager$UpdateChannelDataNotificationListener;
.implements Lcom/pri/prizeinterphone/manager/MessageLisenter;
.implements Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;
.implements Lcom/pri/prizeinterphone/state/CmdStateMachine$InitializedFeedBack;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/InterPhoneHomeActivity$ViewPageChangeListener;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "InterPhoneHomeAct"


# instance fields
.field private dangrousPermissions:[Ljava/lang/String;

.field private mAdapter:Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;

.field public mDismissRunnable:Ljava/lang/Runnable;

.field private mFmChannel:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

.field private mFmContacts:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

.field private mFmLocal:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

.field private mFmMessage:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

.field private mFmTalkBack:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

.field private mFragmentManager:Landroidx/fragment/app/FragmentManager;

.field private mGlobalSetChannelMessageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

.field private mHandler:Landroid/os/Handler;

.field private mImgChannel:Landroid/widget/ImageView;

.field private mImgContacts:Landroid/widget/ImageView;

.field private mImgList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/widget/ImageView;",
            ">;"
        }
    .end annotation
.end field

.field private mImgLocal:Landroid/widget/ImageView;

.field private mImgMessage:Landroid/widget/ImageView;

.field private mImgTalkBack:Landroid/widget/ImageView;

.field private mInterPhoneViewPager:Landroidx/viewpager/widget/ViewPager;

.field private mLlInterPhoneTapView:Landroid/widget/LinearLayout;

.field private mModulePowerOn:Ljava/lang/Runnable;

.field private mProgressDialog:Landroid/app/ProgressDialog;

.field private mStartUpdateActivity:Ljava/lang/Runnable;

.field private mToastInitFail:Ljava/lang/Runnable;

.field private mToastInitTry:Ljava/lang/Runnable;

.field private mTvChannel:Landroid/widget/TextView;

.field private mTvContacts:Landroid/widget/TextView;

.field private mTvList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/widget/TextView;",
            ">;"
        }
    .end annotation
.end field

.field private mTvLocal:Landroid/widget/TextView;

.field private mTvMessage:Landroid/widget/TextView;

.field private mTvTalkBack:Landroid/widget/TextView;

.field private mTvUnread:Landroid/widget/TextView;


# direct methods
.method public static synthetic $r8$lambda$vpyyF6i8BGDWak528fjyFo4eTRA(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->lambda$updateModuleInit$0()V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetmAdapter(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mAdapter:Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmGlobalSetChannelMessageListener(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mGlobalSetChannelMessageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmHandler(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mHandler:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmLlInterPhoneTapView(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Landroid/widget/LinearLayout;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mLlInterPhoneTapView:Landroid/widget/LinearLayout;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmTvUnread(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)Landroid/widget/TextView;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvUnread:Landroid/widget/TextView;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$msetCurrentViewPagerItem(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->setCurrentViewPagerItem(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateTapView(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->updateTapView(I)V

    return-void
.end method

.method public constructor <init>()V
    .locals 4

    .line 58
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    .line 71
    invoke-virtual {p0}, Landroidx/fragment/app/FragmentActivity;->getSupportFragmentManager()Landroidx/fragment/app/FragmentManager;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFragmentManager:Landroidx/fragment/app/FragmentManager;

    .line 73
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mHandler:Landroid/os/Handler;

    .line 119
    new-instance v0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$1;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$1;-><init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mGlobalSetChannelMessageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    .line 159
    new-instance v0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$2;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$2;-><init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mDismissRunnable:Ljava/lang/Runnable;

    .line 166
    new-instance v0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$3;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$3;-><init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mToastInitFail:Ljava/lang/Runnable;

    .line 177
    new-instance v0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$4;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$4;-><init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mToastInitTry:Ljava/lang/Runnable;

    .line 185
    new-instance v0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$5;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$5;-><init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mModulePowerOn:Ljava/lang/Runnable;

    .line 192
    new-instance v0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$6;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$6;-><init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mStartUpdateActivity:Ljava/lang/Runnable;

    const-string v0, "android.permission.READ_EXTERNAL_STORAGE"

    const-string v1, "android.permission.WRITE_EXTERNAL_STORAGE"

    const-string v2, "android.permission.READ_PHONE_STATE"

    const-string v3, "android.permission.RECORD_AUDIO"

    .line 200
    filled-new-array {v0, v1, v2, v3}, [Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->dangrousPermissions:[Ljava/lang/String;

    return-void
.end method

.method private checkHasPermissions()Z
    .locals 5

    .line 208
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->dangrousPermissions:[Ljava/lang/String;

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_1

    aget-object v4, v0, v3

    .line 209
    invoke-static {p0, v4}, Landroidx/core/content/ContextCompat;->checkSelfPermission(Landroid/content/Context;Ljava/lang/String;)I

    move-result v4

    if-eqz v4, :cond_0

    return v2

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x1

    return p0
.end method

.method public static getDefaultDisplayDensity(I)I
    .locals 1

    .line 544
    :try_start_0
    invoke-static {}, Landroid/view/WindowManagerGlobal;->getWindowManagerService()Landroid/view/IWindowManager;

    move-result-object v0

    .line 545
    invoke-interface {v0, p0}, Landroid/view/IWindowManager;->getInitialDisplayDensity(I)I

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    return p0

    :catch_0
    const/4 p0, -0x1

    return p0
.end method

.method private initFragmentList()V
    .locals 1

    .line 253
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFmTalkBack:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    .line 254
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFmChannel:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

    .line 255
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFmContacts:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

    .line 256
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFmMessage:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

    .line 257
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFmLocal:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

    return-void
.end method

.method private initTapView()V
    .locals 3

    const v0, 0x7f090270

    .line 275
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvTalkBack:Landroid/widget/TextView;

    .line 276
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const v2, 0x7f06024f

    invoke-virtual {v1, v2}, Landroid/content/res/Resources;->getColor(I)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    const v0, 0x7f090068

    .line 277
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvChannel:Landroid/widget/TextView;

    const v0, 0x7f090085

    .line 278
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvContacts:Landroid/widget/TextView;

    const v0, 0x7f0901c7

    .line 279
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvMessage:Landroid/widget/TextView;

    const v0, 0x7f0901a5

    .line 280
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvLocal:Landroid/widget/TextView;

    .line 281
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvList:Ljava/util/List;

    .line 282
    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvTalkBack:Landroid/widget/TextView;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 283
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvList:Ljava/util/List;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvChannel:Landroid/widget/TextView;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 284
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvList:Ljava/util/List;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvContacts:Landroid/widget/TextView;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 285
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvList:Ljava/util/List;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvMessage:Landroid/widget/TextView;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 286
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvList:Ljava/util/List;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvLocal:Landroid/widget/TextView;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    const v0, 0x7f09026f

    .line 288
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgTalkBack:Landroid/widget/ImageView;

    const/4 v1, 0x1

    .line 289
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setSelected(Z)V

    const v0, 0x7f090067

    .line 290
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgChannel:Landroid/widget/ImageView;

    const v0, 0x7f09007e

    .line 291
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgContacts:Landroid/widget/ImageView;

    const v0, 0x7f0901bf

    .line 292
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgMessage:Landroid/widget/ImageView;

    const v0, 0x7f0901c8

    .line 293
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvUnread:Landroid/widget/TextView;

    const v0, 0x7f090184

    .line 294
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgLocal:Landroid/widget/ImageView;

    .line 295
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgList:Ljava/util/List;

    .line 296
    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgTalkBack:Landroid/widget/ImageView;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 297
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgList:Ljava/util/List;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgChannel:Landroid/widget/ImageView;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 298
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgList:Ljava/util/List;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgContacts:Landroid/widget/ImageView;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 299
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgList:Ljava/util/List;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgMessage:Landroid/widget/ImageView;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 300
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgList:Ljava/util/List;

    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgLocal:Landroid/widget/ImageView;

    invoke-interface {v0, p0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private initViewPager()V
    .locals 3

    .line 261
    new-instance v0, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFragmentManager:Landroidx/fragment/app/FragmentManager;

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;-><init>(Landroidx/fragment/app/FragmentManager;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mAdapter:Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;

    .line 262
    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFmTalkBack:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->add(Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;)V

    .line 263
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mAdapter:Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFmChannel:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->add(Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;)V

    .line 264
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mAdapter:Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFmContacts:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->add(Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;)V

    .line 265
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mAdapter:Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFmMessage:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->add(Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;)V

    .line 266
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mAdapter:Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFmLocal:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->add(Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;)V

    const v0, 0x7f090156

    .line 267
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroidx/viewpager/widget/ViewPager;

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mInterPhoneViewPager:Landroidx/viewpager/widget/ViewPager;

    .line 268
    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mAdapter:Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;

    invoke-virtual {v0, v1}, Landroidx/viewpager/widget/ViewPager;->setAdapter(Landroidx/viewpager/widget/PagerAdapter;)V

    .line 269
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mInterPhoneViewPager:Landroidx/viewpager/widget/ViewPager;

    new-instance v1, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$ViewPageChangeListener;

    const/4 v2, 0x0

    invoke-direct {v1, p0, v2}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$ViewPageChangeListener;-><init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;Lcom/pri/prizeinterphone/InterPhoneHomeActivity$ViewPageChangeListener-IA;)V

    invoke-virtual {v0, v1}, Landroidx/viewpager/widget/ViewPager;->setOnPageChangeListener(Landroidx/viewpager/widget/ViewPager$OnPageChangeListener;)V

    .line 270
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mInterPhoneViewPager:Landroidx/viewpager/widget/ViewPager;

    const/4 v1, 0x4

    invoke-virtual {v0, v1}, Landroidx/viewpager/widget/ViewPager;->setOffscreenPageLimit(I)V

    const/4 v0, 0x0

    .line 271
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->setCurrentViewPagerItem(I)V

    return-void
.end method

.method private synthetic lambda$updateModuleInit$0()V
    .locals 2

    .line 406
    invoke-direct {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->initTapView()V

    .line 407
    invoke-direct {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->updateAllTapViewText()V

    .line 408
    invoke-direct {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->initFragmentList()V

    .line 409
    invoke-direct {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->initViewPager()V

    .line 410
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->getInstance()Lcom/pri/prizeinterphone/ymodem/YModemManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->isNeedUpdateDmr()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 411
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    :cond_0
    return-void
.end method

.method private setCurrentViewPagerItem(I)V
    .locals 2

    .line 378
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mInterPhoneViewPager:Landroidx/viewpager/widget/ViewPager;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroidx/viewpager/widget/ViewPager;->getCurrentItem()I

    move-result v0

    if-ne p1, v0, :cond_0

    goto :goto_0

    .line 380
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mAdapter:Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;

    if-eqz v0, :cond_1

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mInterPhoneViewPager:Landroidx/viewpager/widget/ViewPager;

    if-eqz v1, :cond_1

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->getCount()I

    move-result v0

    if-lez v0, :cond_1

    .line 381
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mInterPhoneViewPager:Landroidx/viewpager/widget/ViewPager;

    invoke-virtual {v0, p1}, Landroidx/viewpager/widget/ViewPager;->setCurrentItem(I)V

    .line 382
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->updateTapView(I)V

    :cond_1
    :goto_0
    return-void
.end method

.method private setDefaultDisplay(Landroid/content/Context;)V
    .locals 1

    .line 553
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    const/4 v0, 0x0

    .line 554
    invoke-static {v0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->getDefaultDisplayDensity(I)I

    move-result v0

    iput v0, p0, Landroid/content/res/Configuration;->densityDpi:I

    const/high16 v0, 0x3f800000    # 1.0f

    .line 555
    iput v0, p0, Landroid/content/res/Configuration;->fontScale:F

    .line 556
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p1

    invoke-virtual {v0, p0, p1}, Landroid/content/res/Resources;->updateConfiguration(Landroid/content/res/Configuration;Landroid/util/DisplayMetrics;)V

    return-void
.end method

.method private setDefaultDisplayWhenDensityAndFontChange(Landroid/content/res/Configuration;)V
    .locals 4

    .line 561
    iget v0, p1, Landroid/content/res/Configuration;->densityDpi:I

    const/4 v1, 0x0

    invoke-static {v1}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->getDefaultDisplayDensity(I)I

    move-result v1

    if-ne v0, v1, :cond_0

    iget p1, p1, Landroid/content/res/Configuration;->fontScale:F

    float-to-double v0, p1

    const-wide/high16 v2, 0x3ff0000000000000L    # 1.0

    cmpl-double p1, v0, v2

    if-eqz p1, :cond_1

    .line 563
    :cond_0
    invoke-direct {p0, p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->setDefaultDisplay(Landroid/content/Context;)V

    :cond_1
    return-void
.end method

.method private showProgressDialog(Ljava/lang/String;)V
    .locals 1

    .line 144
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mProgressDialog:Landroid/app/ProgressDialog;

    if-nez v0, :cond_0

    .line 145
    new-instance v0, Landroid/app/ProgressDialog;

    invoke-direct {v0, p0}, Landroid/app/ProgressDialog;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mProgressDialog:Landroid/app/ProgressDialog;

    .line 148
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mProgressDialog:Landroid/app/ProgressDialog;

    invoke-virtual {v0, p1}, Landroid/app/ProgressDialog;->setMessage(Ljava/lang/CharSequence;)V

    .line 149
    iget-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mProgressDialog:Landroid/app/ProgressDialog;

    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Landroid/app/ProgressDialog;->setCancelable(Z)V

    .line 150
    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mProgressDialog:Landroid/app/ProgressDialog;

    invoke-virtual {p0}, Landroid/app/ProgressDialog;->show()V

    return-void
.end method

.method private updateAllTapViewText()V
    .locals 2

    .line 304
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvTalkBack:Landroid/widget/TextView;

    if-eqz v0, :cond_0

    const v1, 0x7f11009f

    .line 305
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 307
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvChannel:Landroid/widget/TextView;

    if-eqz v0, :cond_1

    const v1, 0x7f11009b

    .line 308
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 310
    :cond_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvContacts:Landroid/widget/TextView;

    if-eqz v0, :cond_2

    const v1, 0x7f11009c

    .line 311
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 313
    :cond_2
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvMessage:Landroid/widget/TextView;

    if-eqz v0, :cond_3

    const v1, 0x7f11009e

    .line 314
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 316
    :cond_3
    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvLocal:Landroid/widget/TextView;

    if-eqz p0, :cond_4

    const v0, 0x7f11009d

    .line 317
    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setText(I)V

    :cond_4
    return-void
.end method

.method private updateFragmentView()V
    .locals 0

    .line 353
    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mAdapter:Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;

    if-eqz p0, :cond_0

    .line 354
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/fragment/ViewPagerFragmentAdapter;->updateFragmentView()V

    :cond_0
    return-void
.end method

.method private updateTapView(I)V
    .locals 5

    .line 323
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvList:Ljava/util/List;

    if-eqz v0, :cond_1

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-lez v0, :cond_1

    const/4 v0, 0x0

    move v1, v0

    .line 324
    :goto_0
    iget-object v2, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvList:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_1

    if-ne p1, v1, :cond_0

    .line 326
    iget-object v2, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvList:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/widget/TextView;

    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x7f06024f

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getColor(I)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    .line 327
    iget-object v2, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgList:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/widget/ImageView;

    const/4 v3, 0x1

    invoke-virtual {v2, v3}, Landroid/widget/ImageView;->setSelected(Z)V

    goto :goto_1

    .line 329
    :cond_0
    iget-object v2, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mTvList:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/widget/TextView;

    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x7f060250

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getColor(I)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    .line 330
    iget-object v2, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mImgList:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/widget/ImageView;

    invoke-virtual {v2, v0}, Landroid/widget/ImageView;->setSelected(Z)V

    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    return-void
.end method


# virtual methods
.method public dismissProgressDialog()V
    .locals 0

    .line 154
    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mProgressDialog:Landroid/app/ProgressDialog;

    if-eqz p0, :cond_0

    .line 155
    invoke-virtual {p0}, Landroid/app/ProgressDialog;->dismiss()V

    :cond_0
    return-void
.end method

.method public init()V
    .locals 0

    .line 217
    invoke-static {}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->getInstance()Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->pullUpPwdFoot()V

    return-void
.end method

.method public initializedNotify()V
    .locals 1

    .line 418
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mHandler:Landroid/os/Handler;

    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mToastInitTry:Ljava/lang/Runnable;

    invoke-virtual {v0, p0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    return-void
.end method

.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 2
    .param p3    # Landroid/content/Intent;
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param

    .line 442
    invoke-super {p0, p1, p2, p3}, Landroidx/fragment/app/FragmentActivity;->onActivityResult(IILandroid/content/Intent;)V

    const/16 v0, 0x3ea

    if-eq p1, v0, :cond_0

    const/16 v0, 0x3e9

    if-eq p1, v0, :cond_0

    const/16 v0, 0x3eb

    if-ne p1, v0, :cond_1

    :cond_0
    const/4 v0, -0x1

    if-ne p2, v0, :cond_1

    .line 444
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onActivityResult mFmLocal = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFmLocal:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "InterPhoneHomeAct"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 445
    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mFmLocal:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

    if-eqz p0, :cond_1

    .line 446
    invoke-virtual {p0, p1, p2, p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->onPrizeActivityResult(IILandroid/content/Intent;)V

    :cond_1
    return-void
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 1

    .line 504
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 505
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->setDefaultDisplayWhenDensityAndFontChange(Landroid/content/res/Configuration;)V

    const-string p1, "InterPhoneHomeAct"

    const-string v0, "onConfigurationChanged,updateAllTapViewText"

    .line 506
    invoke-static {p1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 507
    invoke-direct {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->updateAllTapViewText()V

    return-void
.end method

.method public onConversationClean(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V
    .locals 0

    .line 474
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->updateUnreadDot()V

    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 3

    .line 79
    invoke-super {p0, p1}, Landroidx/fragment/app/FragmentActivity;->onCreate(Landroid/os/Bundle;)V

    const-string p1, "InterPhoneHomeAct"

    const-string v0, "onCreate"

    .line 80
    invoke-static {p1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p1, 0x1

    .line 81
    invoke-virtual {p0, p1}, Landroid/app/Activity;->requestWindowFeature(I)Z

    .line 82
    invoke-direct {p0, p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->setDefaultDisplay(Landroid/content/Context;)V

    const p1, 0x7f0c001c

    .line 83
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(I)V

    .line 85
    new-instance p1, Landroid/os/StrictMode$VmPolicy$Builder;

    invoke-direct {p1}, Landroid/os/StrictMode$VmPolicy$Builder;-><init>()V

    .line 86
    invoke-virtual {p1}, Landroid/os/StrictMode$VmPolicy$Builder;->build()Landroid/os/StrictMode$VmPolicy;

    move-result-object v0

    invoke-static {v0}, Landroid/os/StrictMode;->setVmPolicy(Landroid/os/StrictMode$VmPolicy;)V

    .line 87
    invoke-virtual {p1}, Landroid/os/StrictMode$VmPolicy$Builder;->detectFileUriExposure()Landroid/os/StrictMode$VmPolicy$Builder;

    .line 89
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerUpdateListener(Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;)V

    .line 90
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->addMessageListener(Lcom/pri/prizeinterphone/manager/MessageLisenter;)V

    .line 91
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->setTestBitErrorRate(Z)V

    const p1, 0x7f110153

    .line 93
    invoke-virtual {p0, p1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->showProgressDialog(Ljava/lang/String;)V

    .line 94
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->getInstance()Lcom/pri/prizeinterphone/ymodem/YModemManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->isRunning()Z

    move-result p1

    if-nez p1, :cond_1

    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->isDmrUpdateIdle()Z

    move-result p1

    if-eqz p1, :cond_1

    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->getInstance()Lcom/pri/prizeinterphone/ymodem/YModemManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->isExternalSdcardHaveFirmware()Z

    move-result p1

    if-eqz p1, :cond_0

    goto :goto_0

    .line 98
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->setInitializedFeedBack(Lcom/pri/prizeinterphone/state/CmdStateMachine$InitializedFeedBack;)V

    .line 99
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->startCmdMachine()V

    .line 101
    invoke-static {}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->getInstance()Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->startPcmRead()V

    .line 102
    iget-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mHandler:Landroid/os/Handler;

    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mModulePowerOn:Ljava/lang/Runnable;

    const-wide/16 v1, 0x3e8

    invoke-virtual {p1, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 103
    iget-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mHandler:Landroid/os/Handler;

    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mToastInitTry:Ljava/lang/Runnable;

    const-wide/16 v1, 0x1770

    invoke-virtual {p1, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 104
    iget-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mHandler:Landroid/os/Handler;

    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mToastInitFail:Ljava/lang/Runnable;

    const-wide/16 v1, 0x2710

    invoke-virtual {p1, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto :goto_1

    .line 95
    :cond_1
    :goto_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mHandler:Landroid/os/Handler;

    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mDismissRunnable:Ljava/lang/Runnable;

    invoke-virtual {p1, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 96
    new-instance p1, Landroid/content/Intent;

    const-class v0, Lcom/pri/prizeinterphone/activity/UpdateFirmwareActivity;

    invoke-direct {p1, p0, v0}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, p1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    :goto_1
    const p1, 0x7f090155

    .line 110
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/LinearLayout;

    iput-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mLlInterPhoneTapView:Landroid/widget/LinearLayout;

    .line 111
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    const/16 v0, 0x22

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mGlobalSetChannelMessageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    invoke-virtual {p1, v0, v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerEventListener(BLcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 112
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    const/16 v0, 0x23

    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mGlobalSetChannelMessageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    invoke-virtual {p1, v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerEventListener(BLcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    return-void
.end method

.method protected onDestroy()V
    .locals 3

    const-string v0, "InterPhoneHomeAct"

    const-string v1, "onDestroy"

    .line 234
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 235
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->setInitializedFeedBack(Lcom/pri/prizeinterphone/state/CmdStateMachine$InitializedFeedBack;)V

    .line 236
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->quitCmdMachine()V

    .line 237
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mHandler:Landroid/os/Handler;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    .line 241
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    const/16 v1, 0x22

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v1

    iget-object v2, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mGlobalSetChannelMessageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 242
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    const/16 v1, 0x23

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v1

    iget-object v2, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mGlobalSetChannelMessageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 243
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterUpdateListener(Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;)V

    .line 244
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->removeMessageListener(Lcom/pri/prizeinterphone/manager/MessageLisenter;)V

    .line 245
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->getInstance()Lcom/pri/prizeinterphone/ymodem/YModemManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->isRunning()Z

    move-result v0

    if-nez v0, :cond_0

    .line 246
    invoke-static {}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->getInstance()Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->pullDownPwdFoot()V

    .line 248
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->getInstance()Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->stopPcmRead()V

    .line 249
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onDestroy()V

    return-void
.end method

.method public onMessageDelete(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
    .locals 0

    .line 469
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->updateUnreadDot()V

    return-void
.end method

.method public onMessageReceived()V
    .locals 2

    const-string v0, "InterPhoneHomeAct"

    const-string v1, "onMessageReceived: "

    .line 453
    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/Util/Clog;->i(Ljava/lang/String;Ljava/lang/String;)V

    .line 454
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->updateUnreadDot()V

    return-void
.end method

.method public onMessageSend(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
    .locals 0

    return-void
.end method

.method protected onPause()V
    .locals 1

    .line 348
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onPause()V

    const-string p0, "InterPhoneHomeAct"

    const-string v0, "onPause"

    .line 349
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onRequestPermissionsResult(I[Ljava/lang/String;[I)V
    .locals 2
    .param p2    # [Ljava/lang/String;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .param p3    # [I
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 524
    invoke-super {p0, p1, p2, p3}, Landroidx/fragment/app/FragmentActivity;->onRequestPermissionsResult(I[Ljava/lang/String;[I)V

    const/16 v0, 0x3e8

    if-ne p1, v0, :cond_3

    const/4 p1, 0x0

    move v0, p1

    .line 527
    :goto_0
    array-length v1, p2

    if-ge v0, v1, :cond_1

    .line 528
    aget v1, p3, v0

    if-eqz v1, :cond_0

    goto :goto_1

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    const/4 p1, 0x1

    .line 533
    :goto_1
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "onRequestPermissionsResult: allGrant "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const-string p3, "InterPhoneHomeAct"

    invoke-static {p3, p2}, Lcom/pri/prizeinterphone/Util/Clog;->i(Ljava/lang/String;Ljava/lang/String;)V

    if-eqz p1, :cond_2

    .line 535
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->init()V

    goto :goto_2

    .line 537
    :cond_2
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    :cond_3
    :goto_2
    return-void
.end method

.method public onRestoreInstanceState(Landroid/os/Bundle;)V
    .locals 0

    const-string p0, "InterPhoneHomeAct"

    const-string p1, "onRestoreInstanceState"

    .line 519
    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/Util/Clog;->i(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method protected onResume()V
    .locals 2

    .line 338
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onResume()V

    const-string v0, "InterPhoneHomeAct"

    const-string v1, "onResume"

    .line 339
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 340
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->updateUnreadDot()V

    return-void
.end method

.method public onSaveInstanceState(Landroid/os/Bundle;)V
    .locals 0

    .line 512
    invoke-super {p0, p1}, Landroidx/activity/ComponentActivity;->onSaveInstanceState(Landroid/os/Bundle;)V

    const-string p0, "InterPhoneHomeAct"

    const-string p1, "onSaveInstanceState"

    .line 513
    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/Util/Clog;->i(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method protected onStart()V
    .locals 1

    .line 222
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onStart()V

    const-string p0, "InterPhoneHomeAct"

    const-string v0, "onStart"

    .line 223
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected onStop()V
    .locals 1

    .line 228
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onStop()V

    const-string p0, "InterPhoneHomeAct"

    const-string v0, "onStop"

    .line 229
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onUnreadStatusUpdated()V
    .locals 0

    .line 459
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->updateUnreadDot()V

    return-void
.end method

.method public tapOnClick(Landroid/view/View;)V
    .locals 0

    .line 360
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    sparse-switch p1, :sswitch_data_0

    const/4 p1, 0x0

    goto :goto_0

    :sswitch_0
    const/4 p1, 0x3

    goto :goto_0

    :sswitch_1
    const/4 p1, 0x4

    goto :goto_0

    :sswitch_2
    const/4 p1, 0x2

    goto :goto_0

    :sswitch_3
    const/4 p1, 0x1

    .line 374
    :goto_0
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->setCurrentViewPagerItem(I)V

    return-void

    :sswitch_data_0
    .sparse-switch
        0x7f090066 -> :sswitch_3
        0x7f090079 -> :sswitch_2
        0x7f09016c -> :sswitch_1
        0x7f0901bd -> :sswitch_0
    .end sparse-switch
.end method

.method public updateModuleInit()V
    .locals 2

    const-string v0, "InterPhoneHomeAct"

    const-string/jumbo v1, "updateModuleInit"

    .line 399
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 400
    invoke-static {}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->getInstance()Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->stopPcmRead()V

    .line 401
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mDismissRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 402
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mToastInitTry:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 403
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mToastInitFail:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 404
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mStartUpdateActivity:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 405
    new-instance v0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$$ExternalSyntheticLambda0;-><init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V

    invoke-virtual {p0, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

.method public updateNotification(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 0

    return-void
.end method

.method public updateTalkBackChannelList()V
    .locals 0

    return-void
.end method

.method public updateUnreadDot()V
    .locals 2

    .line 479
    iget-object v0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->mHandler:Landroid/os/Handler;

    new-instance v1, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$7;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$7;-><init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
