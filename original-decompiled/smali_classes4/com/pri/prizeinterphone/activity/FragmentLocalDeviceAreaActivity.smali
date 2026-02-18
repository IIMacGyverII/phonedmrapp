.class public Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "FragmentLocalDeviceAreaActivity.java"

# interfaces
.implements Landroid/widget/AdapterView$OnItemClickListener;
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "FragmentLocalDeviceAreaActivity"


# instance fields
.field private deleteDialog:Landroid/app/AlertDialog;

.field private mAdd:Landroid/widget/Button;

.field private mAddDialog:Landroid/app/Dialog;

.field private mAddEdit:Landroid/widget/EditText;

.field private mCurrentClickPosition:Ljava/lang/String;

.field private mCurrentSelected:Ljava/lang/String;

.field private mDeviceAreaDataList:Ljava/util/LinkedHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mDeviceAreaListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;

.field private mDialog:Landroid/app/Dialog;

.field private mListView:Landroid/widget/ListView;

.field private mToast:Landroid/widget/Toast;


# direct methods
.method public static synthetic $r8$lambda$fcoepDgMOKATgpqIVa_BvyRLsz8(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->lambda$onClick$0(Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetdeleteDialog(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Landroid/app/AlertDialog;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->deleteDialog:Landroid/app/AlertDialog;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmAddEdit(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Landroid/widget/EditText;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddEdit:Landroid/widget/EditText;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmCurrentClickPosition(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentClickPosition:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmCurrentSelected(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentSelected:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDeviceAreaDataList(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Ljava/util/LinkedHashMap;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDeviceAreaDataList:Ljava/util/LinkedHashMap;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$misTalkSend(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Z
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->isTalkSend()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mupdateListView(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->updateListView()V

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 46
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    return-void
.end method

.method private createDeleteDialog(Ljava/lang/String;)V
    .locals 2

    .line 409
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const v1, 0x7f110105

    .line 410
    invoke-virtual {p0, v1}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 411
    invoke-virtual {v0, p1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    const/high16 v0, 0x1040000

    .line 412
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$3;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$3;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)V

    invoke-virtual {p1, v0, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    const v0, 0x104000a

    .line 418
    invoke-virtual {p0, v0}, Landroid/app/Activity;->getString(I)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$2;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$2;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)V

    invoke-virtual {p1, v0, v1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 428
    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->deleteDialog:Landroid/app/AlertDialog;

    return-void
.end method

.method private dismissDialog()V
    .locals 1

    .line 208
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDialog:Landroid/app/Dialog;

    if-eqz v0, :cond_0

    .line 209
    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    const/4 v0, 0x0

    .line 210
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDialog:Landroid/app/Dialog;

    :cond_0
    return-void
.end method

.method private getSelectedChannelAreaIndex(Ljava/lang/String;)I
    .locals 1

    .line 94
    new-instance v0, Ljava/util/ArrayList;

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDeviceAreaDataList:Ljava/util/LinkedHashMap;

    invoke-virtual {p0}, Ljava/util/LinkedHashMap;->keySet()Ljava/util/Set;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->indexOf(Ljava/lang/Object;)I

    move-result p0

    return p0
.end method

.method private initData()V
    .locals 2

    .line 71
    invoke-static {p0}, Lcom/pri/prizeinterphone/constant/Constants;->getSavedChannelAreas(Landroid/content/Context;)Ljava/util/LinkedHashMap;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDeviceAreaDataList:Ljava/util/LinkedHashMap;

    .line 75
    invoke-static {p0}, Lcom/pri/prizeinterphone/constant/Constants;->getSelectedChannelArea(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentSelected:Ljava/lang/String;

    .line 76
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mCurrentSelected="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentSelected:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "FragmentLocalDeviceAreaActivity"

    invoke-static {v1, v0}, Lcom/pri/prizeinterphone/Util/Clog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 78
    new-instance v0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDeviceAreaDataList:Ljava/util/LinkedHashMap;

    invoke-direct {v0, p0, p0, v1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;Landroid/content/Context;Ljava/util/LinkedHashMap;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDeviceAreaListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;

    .line 80
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mListView:Landroid/widget/ListView;

    invoke-virtual {v1, v0}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    .line 81
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mListView:Landroid/widget/ListView;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/ListView;->setChoiceMode(I)V

    .line 82
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mListView:Landroid/widget/ListView;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentSelected:Ljava/lang/String;

    invoke-direct {p0, v1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->getSelectedChannelAreaIndex(Ljava/lang/String;)I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/widget/ListView;->smoothScrollToPosition(I)V

    return-void
.end method

.method private initView()V
    .locals 1

    const v0, 0x7f090176

    .line 62
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ListView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mListView:Landroid/widget/ListView;

    .line 63
    invoke-virtual {v0, p0}, Landroid/widget/ListView;->setOnItemClickListener(Landroid/widget/AdapterView$OnItemClickListener;)V

    const v0, 0x7f09016f

    .line 65
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAdd:Landroid/widget/Button;

    .line 66
    invoke-virtual {v0, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method

.method private isTalkSend()Z
    .locals 3

    const-string v0, "pref_person_send_status"

    const/4 v1, 0x0

    .line 442
    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_0

    move v1, v2

    :cond_0
    if-eqz v1, :cond_1

    const v0, 0x7f11011c

    .line 444
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->showToast(I)V

    :cond_1
    return v1
.end method

.method private static synthetic lambda$onClick$0(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    .line 380
    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private setDialogWindowLayoutParams(Landroid/app/Dialog;)V
    .locals 2

    .line 195
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    .line 196
    iget p0, p0, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 198
    invoke-virtual {p1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    .line 199
    invoke-virtual {p1}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    const/16 v1, 0x50

    .line 200
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v1, 0x3c

    .line 201
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float p0, p0

    const v1, 0x3f666666    # 0.9f

    mul-float/2addr p0, v1

    float-to-int p0, p0

    .line 202
    iput p0, v0, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 203
    invoke-virtual {p1, v0}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const p0, 0x106000d

    .line 204
    invoke-virtual {p1, p0}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    return-void
.end method

.method private showAddDialog()V
    .locals 3

    .line 101
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c0058

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 102
    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddDialog:Landroid/app/Dialog;

    .line 103
    invoke-virtual {v1, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 104
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddDialog:Landroid/app/Dialog;

    invoke-direct {p0, v1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->setDialogWindowLayoutParams(Landroid/app/Dialog;)V

    .line 105
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddDialog:Landroid/app/Dialog;

    invoke-virtual {v1}, Landroid/app/Dialog;->show()V

    const v1, 0x7f090170

    .line 106
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/Button;

    .line 107
    invoke-virtual {v1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v1, 0x7f090179

    .line 108
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/Button;

    .line 109
    invoke-virtual {v1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v1, 0x7f090175

    .line 110
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddEdit:Landroid/widget/EditText;

    .line 111
    new-instance v1, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$1;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$1;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    return-void
.end method

.method private showDialog(ZLjava/lang/String;)V
    .locals 5

    .line 160
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c0059

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    const v1, 0x7f090174

    .line 162
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    .line 163
    invoke-virtual {v1, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v2, 0x7f090172

    .line 164
    invoke-virtual {v0, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/TextView;

    .line 165
    invoke-virtual {v2, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v2, 0x7f090171

    .line 166
    invoke-virtual {v0, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/TextView;

    .line 167
    invoke-virtual {v2, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v3, 0x7f090173

    .line 168
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    .line 169
    invoke-virtual {v3, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const/16 v4, 0x8

    if-eqz p1, :cond_0

    .line 171
    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setVisibility(I)V

    .line 172
    invoke-virtual {v2, v4}, Landroid/widget/TextView;->setVisibility(I)V

    .line 173
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setVisibility(I)V

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    .line 176
    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 177
    invoke-virtual {v2, p1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 178
    sget-object v2, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    invoke-virtual {v2, p2}, Ljava/util/LinkedHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 179
    invoke-virtual {v3, p1}, Landroid/widget/TextView;->setVisibility(I)V

    goto :goto_0

    .line 181
    :cond_1
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setVisibility(I)V

    .line 182
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInitChannelDataDB()Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    move-result-object p1

    invoke-virtual {p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->getAllChannels()Ljava/util/ArrayList;

    move-result-object p1

    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I

    move-result p1

    if-nez p1, :cond_2

    .line 183
    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setVisibility(I)V

    .line 187
    :cond_2
    :goto_0
    new-instance p1, Landroid/app/Dialog;

    invoke-direct {p1, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDialog:Landroid/app/Dialog;

    .line 188
    invoke-virtual {p1, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 189
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDialog:Landroid/app/Dialog;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->setDialogWindowLayoutParams(Landroid/app/Dialog;)V

    .line 191
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDialog:Landroid/app/Dialog;

    invoke-virtual {p0}, Landroid/app/Dialog;->show()V

    return-void
.end method

.method private showToast(I)V
    .locals 1

    .line 434
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 435
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    :cond_0
    const/4 v0, 0x0

    .line 437
    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mToast:Landroid/widget/Toast;

    .line 438
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private updateListView()V
    .locals 2

    .line 215
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDeviceAreaListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;

    invoke-virtual {v0}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    .line 216
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mListView:Landroid/widget/ListView;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentSelected:Ljava/lang/String;

    invoke-direct {p0, v1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->getSelectedChannelAreaIndex(Ljava/lang/String;)I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/widget/ListView;->smoothScrollToPosition(I)V

    return-void
.end method


# virtual methods
.method public onBackPressed()V
    .locals 0

    .line 291
    invoke-super {p0}, Landroidx/activity/ComponentActivity;->onBackPressed()V

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 4

    .line 296
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    const v0, 0x7f090054

    if-eq p1, v0, :cond_f

    const v0, 0x7f090179

    const/4 v1, 0x0

    if-eq p1, v0, :cond_a

    const-string v0, "FragmentLocalDeviceAreaActivity"

    packed-switch p1, :pswitch_data_0

    goto/16 :goto_2

    .line 301
    :pswitch_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->dismissDialog()V

    .line 302
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_0

    goto/16 :goto_2

    .line 305
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->isMonkeyRunning()Z

    move-result p1

    if-eqz p1, :cond_1

    const-string p0, "monkey is running, not let use area"

    .line 306
    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_2

    .line 309
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentClickPosition:Ljava/lang/String;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentSelected:Ljava/lang/String;

    .line 310
    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/constant/Constants;->saveSelectedChannelArea(Landroid/content/Context;Ljava/lang/String;)V

    .line 313
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateChannelList()V

    .line 314
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->syncChannelInfo()V

    .line 315
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->updateListView()V

    goto/16 :goto_2

    .line 351
    :pswitch_1
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->isMonkeyRunning()Z

    move-result p1

    if-eqz p1, :cond_2

    const-string p0, "monkey is running, not let reset area"

    .line 352
    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_2

    .line 355
    :cond_2
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->isTalkSend()Z

    move-result p1

    if-nez p1, :cond_3

    .line 356
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInitChannelDataDB()Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    move-result-object p1

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentClickPosition:Ljava/lang/String;

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->resetChannelDataList(Ljava/lang/String;)V

    .line 358
    :cond_3
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->dismissDialog()V

    goto/16 :goto_2

    .line 318
    :pswitch_2
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->dismissDialog()V

    .line 319
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_4

    goto/16 :goto_2

    .line 322
    :cond_4
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->isMonkeyRunning()Z

    move-result p1

    if-eqz p1, :cond_5

    const-string p0, "monkey is running, not let edit area"

    .line 323
    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_2

    .line 326
    :cond_5
    new-instance p1, Landroid/content/Intent;

    const-class v0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;

    invoke-direct {p1, p0, v0}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 327
    invoke-virtual {p0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentClickPosition:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/constant/Constants;->getChannelAreaName(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v1, "title"

    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 328
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentClickPosition:Ljava/lang/String;

    const-string v1, "selectedId"

    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 329
    invoke-virtual {p0, p1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    goto/16 :goto_2

    .line 332
    :pswitch_3
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->dismissDialog()V

    .line 333
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_6

    goto/16 :goto_2

    .line 336
    :cond_6
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->isMonkeyRunning()Z

    move-result p1

    if-eqz p1, :cond_7

    const-string p0, "monkey is running, not let delete area"

    .line 337
    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_2

    .line 340
    :cond_7
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDeviceAreaDataList:Ljava/util/LinkedHashMap;

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentClickPosition:Ljava/lang/String;

    invoke-static {p0, p1, v0}, Lcom/pri/prizeinterphone/constant/Constants;->getChannelAreaName(Landroid/content/Context;Ljava/util/LinkedHashMap;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const v0, 0x7f110106

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    aput-object p1, v1, v2

    .line 341
    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->getString(I[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    .line 343
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->deleteDialog:Landroid/app/AlertDialog;

    if-nez v0, :cond_8

    .line 344
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->createDeleteDialog(Ljava/lang/String;)V

    goto :goto_0

    .line 346
    :cond_8
    invoke-virtual {v0, p1}, Landroid/app/AlertDialog;->setMessage(Ljava/lang/CharSequence;)V

    .line 348
    :goto_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->deleteDialog:Landroid/app/AlertDialog;

    invoke-virtual {p0}, Landroid/app/AlertDialog;->show()V

    goto/16 :goto_2

    .line 367
    :pswitch_4
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_10

    .line 368
    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 369
    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddDialog:Landroid/app/Dialog;

    goto/16 :goto_2

    .line 361
    :pswitch_5
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_9

    goto/16 :goto_2

    .line 364
    :cond_9
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->showAddDialog()V

    goto/16 :goto_2

    .line 373
    :cond_a
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->isTalkSend()Z

    move-result p1

    if-nez p1, :cond_e

    .line 374
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddEdit:Landroid/widget/EditText;

    if-eqz p1, :cond_d

    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_d

    .line 375
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddEdit:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "[^a-zA-Z0-9\u4e00-\u9fa5]"

    .line 377
    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    .line 378
    invoke-virtual {v0, p1}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object p1

    const-string v0, ""

    .line 379
    invoke-virtual {p1, v0}, Ljava/util/regex/Matcher;->replaceAll(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    .line 380
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDeviceAreaDataList:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Collection;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v2, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$$ExternalSyntheticLambda0;

    invoke-direct {v2, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$$ExternalSyntheticLambda0;-><init>(Ljava/lang/String;)V

    invoke-interface {v0, v2}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result v0

    const v2, 0x7f110078

    if-nez v0, :cond_c

    .line 382
    invoke-static {}, Lcom/pri/prizeinterphone/constant/Constants;->randExtraChannelAreaName()Ljava/lang/String;

    move-result-object v0

    .line 383
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInitChannelDataDB()Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    move-result-object v3

    invoke-virtual {v3, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->isCheckDbName(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_b

    .line 384
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDeviceAreaDataList:Ljava/util/LinkedHashMap;

    invoke-virtual {v2, v0, p1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 385
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInitChannelDataDB()Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    move-result-object p1

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDeviceAreaDataList:Ljava/util/LinkedHashMap;

    invoke-virtual {p1, v0, v2}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->addChannelDataList(Ljava/lang/String;Ljava/util/LinkedHashMap;)V

    .line 386
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->updateListView()V

    goto :goto_1

    .line 388
    :cond_b
    invoke-direct {p0, v2}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->showToast(I)V

    goto :goto_1

    .line 391
    :cond_c
    invoke-direct {p0, v2}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->showToast(I)V

    goto :goto_1

    :cond_d
    const p1, 0x7f110079

    .line 395
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->showToast(I)V

    .line 398
    :cond_e
    :goto_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_10

    .line 399
    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 400
    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddDialog:Landroid/app/Dialog;

    goto :goto_2

    .line 298
    :cond_f
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->onBackPressed()V

    :cond_10
    :goto_2
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x7f09016f
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 2
    .param p1    # Landroid/content/res/Configuration;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 276
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 277
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDialog:Landroid/app/Dialog;

    const/4 v0, 0x0

    if-eqz p1, :cond_0

    invoke-virtual {p1}, Landroid/app/Dialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 278
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDialog:Landroid/app/Dialog;

    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 279
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDialog:Landroid/app/Dialog;

    .line 280
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentSelected:Ljava/lang/String;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentClickPosition:Ljava/lang/String;

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentClickPosition:Ljava/lang/String;

    invoke-direct {p0, p1, v1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->showDialog(ZLjava/lang/String;)V

    .line 282
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_1

    invoke-virtual {p1}, Landroid/app/Dialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 283
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddDialog:Landroid/app/Dialog;

    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 284
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mAddDialog:Landroid/app/Dialog;

    .line 285
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->showAddDialog()V

    :cond_1
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 0

    .line 55
    invoke-super {p0, p1}, Landroidx/fragment/app/FragmentActivity;->onCreate(Landroid/os/Bundle;)V

    const p1, 0x7f0c003e

    .line 56
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(I)V

    .line 57
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->initView()V

    .line 58
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->initData()V

    return-void
.end method

.method public onCreateOptionsMenu(Landroid/view/Menu;)Z
    .locals 1

    .line 89
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

    .line 144
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_0

    return-void

    .line 147
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mDeviceAreaListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;

    invoke-virtual {p1, p3}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;->getItem(I)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentClickPosition:Ljava/lang/String;

    .line 148
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "onItemClick,mCurrentClickPosition="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentClickPosition:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "FragmentLocalDeviceAreaActivity"

    invoke-static {p2, p1}, Lcom/pri/prizeinterphone/Util/Clog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 149
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentSelected:Ljava/lang/String;

    iget-object p2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentClickPosition:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    const/4 p1, 0x1

    .line 150
    iget-object p2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentClickPosition:Ljava/lang/String;

    invoke-direct {p0, p1, p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->showDialog(ZLjava/lang/String;)V

    goto :goto_0

    :cond_1
    const/4 p1, 0x0

    .line 152
    iget-object p2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->mCurrentClickPosition:Ljava/lang/String;

    invoke-direct {p0, p1, p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->showDialog(ZLjava/lang/String;)V

    :goto_0
    return-void
.end method
