.class public Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "FragmentLocalDeviceAreaListActivity.java"

# interfaces
.implements Landroid/widget/AdapterView$OnItemClickListener;
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$DeviceAreaListAdapter;
    }
.end annotation


# static fields
.field public static final REQUEST_EDIT_CHANNEL:I = 0x3ed

.field private static final TAG:Ljava/lang/String; = "FragmentLocalDeviceAreaListActivity"


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

.field private mAdd:Landroid/widget/Button;

.field private mCurrentClickPosition:I

.field private mCurrentSelected:I

.field private mDeviceAreaDataList:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDeviceAreaListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$DeviceAreaListAdapter;

.field private mDialog:Landroid/app/Dialog;

.field private mListView:Landroid/widget/ListView;

.field private mSeletedChannelIndex:Ljava/lang/String;

.field private mTitle:Landroid/widget/TextView;

.field private mToast:Landroid/widget/Toast;


# direct methods
.method static bridge synthetic -$$Nest$fgetdeleteDialog(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)Landroid/app/AlertDialog;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->deleteDialog:Landroid/app/AlertDialog;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmCurrentClickPosition(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)I
    .locals 0

    iget p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mCurrentClickPosition:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmCurrentSelected(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)I
    .locals 0

    iget p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mCurrentSelected:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmDeviceAreaListAdapter(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$DeviceAreaListAdapter;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mDeviceAreaListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$DeviceAreaListAdapter;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmSeletedChannelIndex(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mSeletedChannelIndex:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$misTalkSend(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)Z
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->isTalkSend()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mshowToast(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->showToast(I)V

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 41
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    .line 48
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->KEY_DEF_AREA:Ljava/lang/String;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mSeletedChannelIndex:Ljava/lang/String;

    .line 50
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    return-void
.end method

.method private createDeleteDialog(Ljava/lang/String;)V
    .locals 2

    .line 307
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const v1, 0x7f110107

    .line 308
    invoke-virtual {p0, v1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 309
    invoke-virtual {v0, p1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    const/high16 v0, 0x1040000

    .line 310
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$2;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$2;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)V

    invoke-virtual {p1, v0, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    const v0, 0x104000a

    .line 316
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$1;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$1;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)V

    invoke-virtual {p1, v0, v1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 330
    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->deleteDialog:Landroid/app/AlertDialog;

    return-void
.end method

.method private dismissDialog()V
    .locals 1

    .line 163
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mDialog:Landroid/app/Dialog;

    if-eqz v0, :cond_0

    .line 164
    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    const/4 v0, 0x0

    .line 165
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mDialog:Landroid/app/Dialog;

    :cond_0
    return-void
.end method

.method private initData()V
    .locals 3

    .line 71
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    const-string v1, "selectedId"

    .line 72
    invoke-virtual {v0, v1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mSeletedChannelIndex:Ljava/lang/String;

    const-string/jumbo v1, "title"

    .line 73
    invoke-virtual {v0, v1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 74
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mTitle:Landroid/widget/TextView;

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 76
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInitChannelDataDB()Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mSeletedChannelIndex:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->dbChannelHelper:Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    .line 78
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->getAllChannels()Ljava/util/ArrayList;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    const/4 v0, 0x0

    .line 80
    :goto_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    const/4 v2, 0x1

    if-ge v0, v1, :cond_1

    .line 81
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v1, v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    if-ne v1, v2, :cond_0

    .line 82
    iput v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mCurrentSelected:I

    goto :goto_1

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 87
    :cond_1
    :goto_1
    new-instance v0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$DeviceAreaListAdapter;

    invoke-direct {v0, p0, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$DeviceAreaListAdapter;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mDeviceAreaListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$DeviceAreaListAdapter;

    .line 88
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mListView:Landroid/widget/ListView;

    invoke-virtual {v1, v0}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    .line 89
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mListView:Landroid/widget/ListView;

    invoke-virtual {p0, v2}, Landroid/widget/ListView;->setChoiceMode(I)V

    return-void
.end method

.method private initView()V
    .locals 1

    const v0, 0x7f090176

    .line 61
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ListView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mListView:Landroid/widget/ListView;

    .line 62
    invoke-virtual {v0, p0}, Landroid/widget/ListView;->setOnItemClickListener(Landroid/widget/AdapterView$OnItemClickListener;)V

    const v0, 0x7f0900d5

    .line 64
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mTitle:Landroid/widget/TextView;

    const v0, 0x7f09016f

    .line 66
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mAdd:Landroid/widget/Button;

    .line 67
    invoke-virtual {v0, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method

.method private isTalkSend()Z
    .locals 3

    const-string v0, "pref_person_send_status"

    const/4 v1, 0x0

    .line 343
    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_0

    move v1, v2

    :cond_0
    if-eqz v1, :cond_1

    const v0, 0x7f11011c

    .line 345
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->showToast(I)V

    :cond_1
    return v1
.end method

.method private setDialogWindowLayoutParams(Landroid/app/Dialog;)V
    .locals 2

    .line 150
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    .line 151
    iget p0, p0, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 153
    invoke-virtual {p1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    .line 154
    invoke-virtual {p1}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    const/16 v1, 0x50

    .line 155
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v1, 0x3c

    .line 156
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float p0, p0

    const v1, 0x3f666666    # 0.9f

    mul-float/2addr p0, v1

    float-to-int p0, p0

    .line 157
    iput p0, v0, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 158
    invoke-virtual {p1, v0}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const p0, 0x106000d

    .line 159
    invoke-virtual {p1, p0}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    return-void
.end method

.method private showDialog(ZI)V
    .locals 5

    .line 109
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c0059

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    const v1, 0x7f090174

    .line 111
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    .line 112
    invoke-virtual {v1, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v2, 0x7f090172

    .line 113
    invoke-virtual {v0, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/TextView;

    .line 114
    invoke-virtual {v2, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v2, 0x7f090171

    .line 115
    invoke-virtual {v0, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/TextView;

    .line 116
    invoke-virtual {v2, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v3, 0x7f090173

    .line 117
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    .line 118
    invoke-virtual {v3, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    if-eqz p1, :cond_1

    .line 120
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    invoke-interface {p1, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget p1, p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    const/4 p2, 0x1

    const/16 v4, 0x8

    if-ne p1, p2, :cond_0

    .line 121
    invoke-virtual {v2, v4}, Landroid/widget/TextView;->setVisibility(I)V

    .line 123
    :cond_0
    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setVisibility(I)V

    .line 124
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setVisibility(I)V

    goto :goto_0

    :cond_1
    const/4 p1, 0x0

    .line 126
    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 127
    invoke-virtual {v2, p1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 128
    invoke-virtual {v3, p1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 130
    :goto_0
    new-instance p1, Landroid/app/Dialog;

    invoke-direct {p1, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mDialog:Landroid/app/Dialog;

    .line 131
    invoke-virtual {p1, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 132
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mDialog:Landroid/app/Dialog;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->setDialogWindowLayoutParams(Landroid/app/Dialog;)V

    .line 133
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mDialog:Landroid/app/Dialog;

    invoke-virtual {p0}, Landroid/app/Dialog;->show()V

    return-void
.end method

.method private showToast(I)V
    .locals 1

    .line 335
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 336
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    :cond_0
    const/4 v0, 0x0

    .line 338
    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mToast:Landroid/widget/Toast;

    .line 339
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private updateListView()V
    .locals 1

    .line 170
    iget v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mCurrentClickPosition:I

    iput v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mCurrentSelected:I

    .line 171
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mDeviceAreaListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$DeviceAreaListAdapter;

    invoke-virtual {p0}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    return-void
.end method


# virtual methods
.method public onBackPressed()V
    .locals 0

    .line 251
    invoke-super {p0}, Landroidx/activity/ComponentActivity;->onBackPressed()V

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 3

    .line 258
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    const/4 v0, 0x1

    const-string v1, "FragmentLocalDeviceAreaListActivity"

    const-string v2, "currentAreaId"

    sparse-switch p1, :sswitch_data_0

    goto/16 :goto_2

    .line 263
    :sswitch_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->dismissDialog()V

    .line 264
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->isMonkeyRunning()Z

    move-result p1

    if-eqz p1, :cond_0

    const-string p0, "monkey is running, not let edit channel"

    .line 265
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_2

    .line 268
    :cond_0
    new-instance p1, Landroid/content/Intent;

    const-class v1, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-direct {p1, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "edit"

    .line 269
    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    .line 270
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    iget v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mCurrentClickPosition:I

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getId()I

    move-result v0

    const-string v1, "channelId"

    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 271
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mSeletedChannelIndex:Ljava/lang/String;

    invoke-virtual {p1, v2, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const/16 v0, 0x3ed

    .line 272
    invoke-virtual {p0, p1, v0}, Landroidx/activity/ComponentActivity;->startActivityForResult(Landroid/content/Intent;I)V

    goto/16 :goto_2

    .line 275
    :sswitch_1
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->dismissDialog()V

    .line 276
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->isMonkeyRunning()Z

    move-result p1

    if-eqz p1, :cond_1

    const-string p0, "monkey is running, not let delete channel"

    .line 277
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_2

    .line 280
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    iget v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mCurrentClickPosition:I

    invoke-interface {p1, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getName()Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_2

    const-string v1, ""

    .line 281
    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_4

    .line 282
    :cond_2
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    iget v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mCurrentClickPosition:I

    invoke-interface {p1, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget p1, p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    if-nez p1, :cond_3

    .line 283
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const v1, 0x7f1100f9

    invoke-virtual {p0, v1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    iget v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mCurrentClickPosition:I

    invoke-interface {v1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v1, v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    goto :goto_0

    .line 285
    :cond_3
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const v1, 0x7f1100f7

    invoke-virtual {p0, v1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    iget v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mCurrentClickPosition:I

    invoke-interface {v1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v1, v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    :cond_4
    :goto_0
    const v1, 0x7f110106

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v2, 0x0

    aput-object p1, v0, v2

    .line 288
    invoke-virtual {p0, v1, v0}, Landroid/app/Activity;->getString(I[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    .line 289
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->deleteDialog:Landroid/app/AlertDialog;

    if-nez v0, :cond_5

    .line 290
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->createDeleteDialog(Ljava/lang/String;)V

    goto :goto_1

    .line 292
    :cond_5
    invoke-virtual {v0, p1}, Landroid/app/AlertDialog;->setMessage(Ljava/lang/CharSequence;)V

    .line 294
    :goto_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->deleteDialog:Landroid/app/AlertDialog;

    invoke-virtual {p0}, Landroid/app/AlertDialog;->show()V

    goto :goto_2

    .line 297
    :sswitch_2
    new-instance p1, Landroid/content/Intent;

    const-class v0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-direct {p1, p0, v0}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 298
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mSeletedChannelIndex:Ljava/lang/String;

    invoke-virtual {p1, v2, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 299
    invoke-virtual {p0, p1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    goto :goto_2

    .line 260
    :sswitch_3
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->onBackPressed()V

    :goto_2
    return-void

    nop

    :sswitch_data_0
    .sparse-switch
        0x7f090054 -> :sswitch_3
        0x7f09016f -> :sswitch_2
        0x7f090171 -> :sswitch_1
        0x7f090172 -> :sswitch_0
    .end sparse-switch
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 0
    .param p1    # Landroid/content/res/Configuration;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 138
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 139
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->initData()V

    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 0

    .line 54
    invoke-super {p0, p1}, Landroidx/fragment/app/FragmentActivity;->onCreate(Landroid/os/Bundle;)V

    const p1, 0x7f0c0040

    .line 55
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(I)V

    .line 56
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->initView()V

    .line 57
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->initData()V

    return-void
.end method

.method public onCreateOptionsMenu(Landroid/view/Menu;)Z
    .locals 1

    .line 96
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getMenuInflater()Landroid/view/MenuInflater;

    move-result-object p0

    const/high16 v0, 0x7f0d0000

    invoke-virtual {p0, v0, p1}, Landroid/view/MenuInflater;->inflate(ILandroid/view/Menu;)V

    const/4 p0, 0x1

    return p0
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

    .line 176
    iput p3, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mCurrentClickPosition:I

    const/4 p1, 0x1

    .line 177
    invoke-direct {p0, p1, p3}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->showDialog(ZI)V

    return-void
.end method

.method protected onResume()V
    .locals 1

    .line 144
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onResume()V

    .line 145
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->dbChannelHelper:Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->getAllChannels()Ljava/util/ArrayList;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    .line 146
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->mDeviceAreaListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$DeviceAreaListAdapter;

    invoke-virtual {p0}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    return-void
.end method
