.class public Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;
.super Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;
.source "InterPhoneChannelFragment.java"

# interfaces
.implements Landroid/widget/AdapterView$OnItemClickListener;
.implements Landroid/view/View$OnClickListener;
.implements Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;
    }
.end annotation


# static fields
.field public static final REQUEST_EDIT_CHANNEL:I = 0x3ed

.field private static final TAG:Ljava/lang/String; = "InterPhoneChannelFragment"


# instance fields
.field public channels:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/serial/data/ChannelData;",
            ">;"
        }
    .end annotation
.end field

.field private dbChannelHelper:Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

.field private deleteDialog:Landroid/app/AlertDialog;

.field private mCurrentClickPosition:I

.field private mCurrentSelected:I

.field private mDeviceAreaListAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;

.field private mDialog:Landroid/app/Dialog;

.field private mFragmentManager:Landroidx/fragment/app/FragmentManager;

.field private mListView:Landroid/widget/ListView;

.field private mLocalView:Landroid/view/View;

.field private mToast:Landroid/widget/Toast;

.field private mUpdateChannelListRunnable:Ljava/lang/Runnable;

.field private messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;


# direct methods
.method static bridge synthetic -$$Nest$fgetdbChannelHelper(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->dbChannelHelper:Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetdeleteDialog(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Landroid/app/AlertDialog;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->deleteDialog:Landroid/app/AlertDialog;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmCurrentClickPosition(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)I
    .locals 0

    iget p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentClickPosition:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmCurrentSelected(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)I
    .locals 0

    iget p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentSelected:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmLocalView(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Landroid/view/View;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mLocalView:Landroid/view/View;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmessageListener(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmCurrentSelected(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;I)V
    .locals 0

    iput p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentSelected:I

    return-void
.end method

.method static bridge synthetic -$$Nest$minitData(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->initData()V

    return-void
.end method

.method static bridge synthetic -$$Nest$misTalkSend(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Z
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->isTalkSend()Z

    move-result p0

    return p0
.end method

.method public constructor <init>()V
    .locals 1

    .line 65
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;-><init>()V

    .line 57
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    .line 170
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$1;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$1;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mUpdateChannelListRunnable:Ljava/lang/Runnable;

    return-void
.end method

.method private createDeleteDialog(Ljava/lang/String;)V
    .locals 2

    .line 431
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const v1, 0x7f110107

    .line 432
    invoke-virtual {p0, v1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 433
    invoke-virtual {v0, p1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    const/high16 v0, 0x1040000

    .line 434
    invoke-virtual {p0, v0}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$4;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$4;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)V

    invoke-virtual {p1, v0, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    const v0, 0x104000a

    .line 440
    invoke-virtual {p0, v0}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$3;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$3;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)V

    invoke-virtual {p1, v0, v1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 450
    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->deleteDialog:Landroid/app/AlertDialog;

    return-void
.end method

.method private dismissDialog()V
    .locals 1

    .line 290
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mDialog:Landroid/app/Dialog;

    if-eqz v0, :cond_0

    .line 291
    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    const/4 v0, 0x0

    .line 292
    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mDialog:Landroid/app/Dialog;

    :cond_0
    return-void
.end method

.method private initData()V
    .locals 3

    .line 81
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    sget-object v1, Lcom/pri/prizeinterphone/constant/Constants;->KEY_DEF_AREA:Ljava/lang/String;

    const-string v2, "pref_person_channel_area_selected_index"

    invoke-static {v0, v2, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 84
    :try_start_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInitChannelDataDB()Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->dbChannelHelper:Lcom/pri/prizeinterphone/serial/data/UtilChannelData;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 90
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getChannelList(Ljava/lang/String;)Ljava/util/List;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    .line 91
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->updateLanguageArea()V

    const/4 v0, 0x0

    .line 93
    :goto_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    const/4 v2, 0x1

    if-ge v0, v1, :cond_1

    .line 94
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v1, v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    if-ne v1, v2, :cond_0

    .line 95
    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentSelected:I

    goto :goto_1

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 100
    :cond_1
    :goto_1
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v1

    invoke-direct {v0, p0, v1}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mDeviceAreaListAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;

    .line 101
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mListView:Landroid/widget/ListView;

    invoke-virtual {v1, v0}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    .line 102
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mListView:Landroid/widget/ListView;

    invoke-virtual {v0, v2}, Landroid/widget/ListView;->setChoiceMode(I)V

    .line 103
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mListView:Landroid/widget/ListView;

    invoke-virtual {v0, p0}, Landroid/widget/ListView;->setOnItemClickListener(Landroid/widget/AdapterView$OnItemClickListener;)V

    .line 104
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->updateAdapter()V

    return-void

    :catch_0
    move-exception p0

    const-string v0, "InterPhoneChannelFragment"

    const-string v1, "initData,not call DmrManager.initChannelData() or faster than call DmrManager.initChannelData(),so InitChannelDataDB is null"

    .line 86
    invoke-static {v0, v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method private isTalkSend()Z
    .locals 3

    .line 463
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    const-string v1, "pref_person_send_status"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    move v2, v1

    :cond_0
    if-eqz v2, :cond_1

    const v0, 0x7f11011c

    .line 465
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->showToast(I)V

    :cond_1
    return v2
.end method

.method private saveData()V
    .locals 3

    .line 353
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/state/StateMachine;->getCurrentState()Lcom/pri/prizeinterphone/state/IState;

    move-result-object v0

    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getSetChannelState()Lcom/pri/prizeinterphone/state/IState;

    move-result-object v1

    if-ne v0, v1, :cond_0

    const-string p0, "InterPhoneChannelFragment"

    const-string v0, "saveData is setting channel..."

    .line 354
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_0
    const v0, 0x7f1100ac

    .line 358
    invoke-virtual {p0, v0}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->showProgressDialog(Ljava/lang/String;)V

    .line 359
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    if-nez v0, :cond_1

    .line 360
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$2;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    .line 395
    :cond_1
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    const/16 v1, 0x22

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerEventListener(BLcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 396
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    const/16 v1, 0x23

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerEventListener(BLcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 398
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    iget v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentClickPosition:I

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    .line 399
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->syncChannelInfoWithData(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 405
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mHandler:Landroid/os/Handler;

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mDismissRunnable:Ljava/lang/Runnable;

    const-wide/16 v1, 0x7d0

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method private setDialogWindowLayoutParams(Landroid/app/Dialog;)V
    .locals 2

    .line 277
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    .line 278
    iget p0, p0, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 280
    invoke-virtual {p1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    .line 281
    invoke-virtual {p1}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    const/16 v1, 0x50

    .line 282
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v1, 0x3c

    .line 283
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float p0, p0

    const v1, 0x3f666666    # 0.9f

    mul-float/2addr p0, v1

    float-to-int p0, p0

    .line 284
    iput p0, v0, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 285
    invoke-virtual {p1, v0}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const p0, 0x106000d

    .line 286
    invoke-virtual {p1, p0}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    return-void
.end method

.method private showDialog(ZI)V
    .locals 4

    .line 250
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p2

    invoke-static {p2}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p2

    const v0, 0x7f0c0059

    const/4 v1, 0x0

    invoke-virtual {p2, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p2

    const v0, 0x7f090174

    .line 252
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    .line 253
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v1, 0x7f090172

    .line 254
    invoke-virtual {p2, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    .line 255
    invoke-virtual {v1, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v1, 0x7f090171

    .line 256
    invoke-virtual {p2, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    .line 257
    invoke-virtual {v1, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v2, 0x7f090173

    .line 258
    invoke-virtual {p2, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/TextView;

    .line 259
    invoke-virtual {v2, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const/16 v3, 0x8

    if-eqz p1, :cond_0

    .line 261
    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setVisibility(I)V

    .line 262
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setVisibility(I)V

    .line 263
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setVisibility(I)V

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    .line 265
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 266
    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 267
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setVisibility(I)V

    .line 269
    :goto_0
    new-instance p1, Landroid/app/Dialog;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    invoke-direct {p1, v0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mDialog:Landroid/app/Dialog;

    .line 270
    invoke-virtual {p1, p2}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 271
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mDialog:Landroid/app/Dialog;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->setDialogWindowLayoutParams(Landroid/app/Dialog;)V

    .line 272
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mDialog:Landroid/app/Dialog;

    invoke-virtual {p0}, Landroid/app/Dialog;->show()V

    return-void
.end method

.method private showToast(I)V
    .locals 2

    .line 455
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 456
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    .line 458
    :cond_0
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mToast:Landroid/widget/Toast;

    .line 459
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private updateLanguageArea()V
    .locals 1

    .line 108
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    invoke-static {v0}, Lcom/pri/prizeinterphone/constant/Constants;->getChannelAreaName(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 109
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setTitle(Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public doAddAction()V
    .locals 4

    .line 114
    invoke-super {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->doAddAction()V

    .line 115
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 118
    :cond_0
    new-instance v0, Landroid/content/Intent;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v1

    const-class v2, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 119
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    sget-object v2, Lcom/pri/prizeinterphone/constant/Constants;->KEY_DEF_AREA:Ljava/lang/String;

    const-string v3, "pref_person_channel_area_selected_index"

    invoke-static {v1, v3, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "currentAreaId"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 121
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    invoke-virtual {p0, v0}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method public getMyTag()Ljava/lang/String;
    .locals 0

    const-string p0, "InterPhoneChannelFragment"

    return-object p0
.end method

.method public initView(Landroid/view/View;)V
    .locals 2

    .line 70
    invoke-super {p0, p1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->initView(Landroid/view/View;)V

    .line 71
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p1

    const v0, 0x7f0c0039

    const/4 v1, 0x0

    .line 72
    invoke-virtual {p1, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mLocalView:Landroid/view/View;

    .line 73
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mFragmentContainer:Landroid/widget/FrameLayout;

    invoke-virtual {v0, p1}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;)V

    .line 74
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900ca

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ListView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mListView:Landroid/widget/ListView;

    const p1, 0x7f08008c

    .line 75
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setAddButton(I)V

    .line 77
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerUpdateListener(Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;)V

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 3

    .line 300
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 303
    :cond_0
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    const/4 v0, 0x1

    const-string v1, "InterPhoneChannelFragment"

    packed-switch p1, :pswitch_data_0

    :pswitch_0
    goto/16 :goto_2

    .line 305
    :pswitch_1
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->dismissDialog()V

    .line 306
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->isMonkeyRunning()Z

    move-result p1

    if-eqz p1, :cond_1

    const-string p0, "monkey is running, not let use the channel"

    .line 307
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_2

    .line 310
    :cond_1
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->saveData()V

    goto/16 :goto_2

    .line 313
    :pswitch_2
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->dismissDialog()V

    .line 314
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->isMonkeyRunning()Z

    move-result p1

    if-eqz p1, :cond_2

    const-string p0, "monkey is running, not let edit the channel"

    .line 315
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_2

    .line 319
    :cond_2
    new-instance p1, Landroid/content/Intent;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v1

    const-class v2, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-direct {p1, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "edit"

    .line 320
    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    .line 321
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    iget v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentClickPosition:I

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getId()I

    move-result v0

    const-string v1, "channelId"

    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 322
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    sget-object v1, Lcom/pri/prizeinterphone/constant/Constants;->KEY_DEF_AREA:Ljava/lang/String;

    const-string v2, "pref_person_channel_area_selected_index"

    invoke-static {v0, v2, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "currentAreaId"

    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const/16 v0, 0x3ed

    .line 324
    invoke-virtual {p0, p1, v0}, Landroidx/fragment/app/Fragment;->startActivityForResult(Landroid/content/Intent;I)V

    goto/16 :goto_2

    .line 327
    :pswitch_3
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->dismissDialog()V

    .line 328
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->isMonkeyRunning()Z

    move-result p1

    if-eqz p1, :cond_3

    const-string p0, "monkey is running, not let delete the channel"

    .line 329
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_2

    .line 332
    :cond_3
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    iget v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentClickPosition:I

    invoke-interface {p1, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getName()Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_4

    const-string v1, ""

    .line 333
    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_6

    .line 334
    :cond_4
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    iget v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentClickPosition:I

    invoke-interface {p1, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget p1, p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    if-nez p1, :cond_5

    .line 335
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const v1, 0x7f1100f9

    invoke-virtual {p0, v1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    iget v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentClickPosition:I

    invoke-interface {v1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v1, v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    goto :goto_0

    .line 337
    :cond_5
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const v1, 0x7f1100f7

    invoke-virtual {p0, v1}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    iget v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentClickPosition:I

    invoke-interface {v1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v1, v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    :cond_6
    :goto_0
    const v1, 0x7f110106

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v2, 0x0

    aput-object p1, v0, v2

    .line 340
    invoke-virtual {p0, v1, v0}, Landroidx/fragment/app/Fragment;->getString(I[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    .line 341
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->deleteDialog:Landroid/app/AlertDialog;

    if-nez v0, :cond_7

    .line 342
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->createDeleteDialog(Ljava/lang/String;)V

    goto :goto_1

    .line 344
    :cond_7
    invoke-virtual {v0, p1}, Landroid/app/AlertDialog;->setMessage(Ljava/lang/CharSequence;)V

    .line 346
    :goto_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->deleteDialog:Landroid/app/AlertDialog;

    invoke-virtual {p0}, Landroid/app/AlertDialog;->show()V

    :goto_2
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x7f090171
        :pswitch_3
        :pswitch_2
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 1
    .param p1    # Landroid/content/res/Configuration;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 152
    invoke-super {p0, p1}, Landroidx/fragment/app/Fragment;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 153
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_1

    invoke-virtual {p1}, Landroid/app/Dialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 154
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mDialog:Landroid/app/Dialog;

    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    const/4 p1, 0x0

    .line 155
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mDialog:Landroid/app/Dialog;

    .line 156
    iget p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentClickPosition:I

    iget v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentSelected:I

    if-ne p1, v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->showDialog(ZI)V

    :cond_1
    return-void
.end method

.method public onDestroy()V
    .locals 1

    .line 424
    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onDestroy()V

    .line 425
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterUpdateListener(Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;)V

    return-void
.end method

.method public onItemClick(Landroid/widget/AdapterView;Landroid/view/View;IJ)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/widget/AdapterView<",
            "*>;",
            "Landroid/view/View;",
            "IJ)V"
        }
    .end annotation

    .line 137
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_0

    return-void

    .line 142
    :cond_0
    iput p3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentClickPosition:I

    .line 143
    iget p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mCurrentSelected:I

    if-ne p3, p1, :cond_1

    const/4 p1, 0x1

    .line 144
    invoke-direct {p0, p1, p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->showDialog(ZI)V

    goto :goto_0

    :cond_1
    const/4 p1, 0x0

    .line 146
    invoke-direct {p0, p1, p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->showDialog(ZI)V

    :goto_0
    return-void
.end method

.method public onResume()V
    .locals 2

    .line 417
    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onResume()V

    const-string v0, "InterPhoneChannelFragment"

    const-string v1, "onResume"

    .line 418
    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/Util/Clog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 419
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->initData()V

    return-void
.end method

.method public updateAdapter()V
    .locals 0

    .line 410
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mDeviceAreaListAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;

    if-eqz p0, :cond_0

    .line 411
    invoke-virtual {p0}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    :cond_0
    return-void
.end method

.method public updateModuleInit()V
    .locals 1

    const-string p0, "InterPhoneChannelFragment"

    const-string/jumbo v0, "updateModuleInit: "

    .line 167
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public updateTalkBackChannelList()V
    .locals 1

    .line 162
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mHandler:Landroid/os/Handler;

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->mUpdateChannelListRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, p0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public updateView()V
    .locals 1

    .line 126
    invoke-super {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->updateView()V

    .line 127
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getChannelList()Ljava/util/List;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    return-void
.end method
