.class public Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "FragmentLocalSettingsActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;
.implements Landroid/content/DialogInterface$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$MicGainListAdapter;,
        Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "FragmentLocalSettingsActivity"


# instance fields
.field private arrayLimitSendTimeValues:[I

.field private arrayMicGainValues:[I

.field private currentLimitSendTime:I

.field private currentMicGain:I

.field private mCurrentBusyNoSend:Z

.field private mCurrentCheckItem:I

.field private mCurrentEndTone:Z

.field private mCurrentRecord:Z

.field private mCurrentStartTone:Z

.field private mDeviceIdDialog:Landroid/app/Dialog;

.field private mDeviceIdDialogEdit:Landroid/widget/EditText;

.field private mLimitSendTimeDialog:Landroid/app/Dialog;

.field private mLimitSendTimeList:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mLimitSendTimeListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;

.field private mLimitSendTimeListView:Landroid/widget/ListView;

.field private mMicCurrentCheckItem:I

.field private mMicGainDialog:Landroid/app/Dialog;

.field private mMicGainList:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mMicGainListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$MicGainListAdapter;

.field private mMicGainListView:Landroid/widget/ListView;

.field private mMicGanValue:Landroid/view/View;

.field private mRelDeviceId:Landroid/view/View;

.field private mRelLimitSendTime:Landroid/view/View;

.field private mReviveWalkietalkie:Landroid/widget/RelativeLayout;

.field private mSwitchBusyNoSend:Landroid/widget/Switch;

.field private mSwitchEndTone:Landroid/widget/Switch;

.field private mSwitchRecord:Landroid/widget/Switch;

.field private mSwitchStartTone:Landroid/widget/Switch;

.field private mTVMicGanValue:Landroid/widget/TextView;

.field private mToast:Landroid/widget/Toast;

.field private mTvDeviceId:Landroid/widget/TextView;

.field private mTvLimitSendTime:Landroid/widget/TextView;

.field private messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

.field private mkillWalkieTalkie:Landroid/widget/RelativeLayout;


# direct methods
.method static bridge synthetic -$$Nest$fgetarrayLimitSendTimeValues(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)[I
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->arrayLimitSendTimeValues:[I

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetarrayMicGainValues(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)[I
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->arrayMicGainValues:[I

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmCurrentCheckItem(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)I
    .locals 0

    iget p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentCheckItem:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmLimitSendTimeDialog(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)Landroid/app/Dialog;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeDialog:Landroid/app/Dialog;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmLimitSendTimeList(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)Ljava/util/ArrayList;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeList:Ljava/util/ArrayList;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmMicCurrentCheckItem(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)I
    .locals 0

    iget p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicCurrentCheckItem:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmMicGainDialog(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)Landroid/app/Dialog;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainDialog:Landroid/app/Dialog;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmMicGainList(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)Ljava/util/ArrayList;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainList:Ljava/util/ArrayList;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmCurrentCheckItem(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;I)V
    .locals 0

    iput p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentCheckItem:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmMicCurrentCheckItem(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;I)V
    .locals 0

    iput p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicCurrentCheckItem:I

    return-void
.end method

.method static bridge synthetic -$$Nest$misTalkSend(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)Z
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->isTalkSend()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mshowToast(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->showToast(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateLimitSendTimeView(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->updateLimitSendTimeView(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdatemicGainView(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->updatemicGainView(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 45
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    .line 309
    new-instance v0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$1;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$1;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    return-void
.end method

.method private initData()V
    .locals 5

    .line 138
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x7f030025

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v0

    .line 139
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const v2, 0x7f030026

    invoke-virtual {v1, v2}, Landroid/content/res/Resources;->getIntArray(I)[I

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->arrayLimitSendTimeValues:[I

    const/4 v1, 0x0

    .line 140
    iput v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentCheckItem:I

    .line 141
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeList:Ljava/util/ArrayList;

    move v2, v1

    .line 142
    :goto_0
    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->arrayLimitSendTimeValues:[I

    array-length v4, v3

    if-ge v2, v4, :cond_1

    .line 143
    aget v3, v3, v2

    iget v4, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->currentLimitSendTime:I

    if-ne v3, v4, :cond_0

    .line 144
    iput v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentCheckItem:I

    .line 146
    :cond_0
    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeList:Ljava/util/ArrayList;

    aget-object v4, v0, v2

    invoke-virtual {v3, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    const-string v0, "pref_person_ptt_start_tone"

    const/4 v2, 0x1

    .line 149
    invoke-static {p0, v0, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getBooleanData(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentStartTone:Z

    .line 150
    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchStartTone:Landroid/widget/Switch;

    invoke-virtual {v3, v0}, Landroid/widget/Switch;->setChecked(Z)V

    const-string v0, "pref_person_ptt_end_tone"

    .line 151
    invoke-static {p0, v0, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getBooleanData(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentEndTone:Z

    .line 152
    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchEndTone:Landroid/widget/Switch;

    invoke-virtual {v3, v0}, Landroid/widget/Switch;->setChecked(Z)V

    const-string v0, "pref_person_ptt_record"

    .line 153
    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getBooleanData(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentRecord:Z

    .line 154
    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchRecord:Landroid/widget/Switch;

    invoke-virtual {v3, v0}, Landroid/widget/Switch;->setChecked(Z)V

    const-string v0, "pref_person_busy_no_send"

    .line 155
    invoke-static {p0, v0, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getBooleanData(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentBusyNoSend:Z

    .line 156
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchBusyNoSend:Landroid/widget/Switch;

    invoke-virtual {v2, v0}, Landroid/widget/Switch;->setChecked(Z)V

    .line 157
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mTvLimitSendTime:Landroid/widget/TextView;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeList:Ljava/util/ArrayList;

    iget v3, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentCheckItem:I

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/CharSequence;

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 159
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v2, 0x7f030027

    invoke-virtual {v0, v2}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v0

    .line 160
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    const v3, 0x7f030028

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getIntArray(I)[I

    move-result-object v2

    iput-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->arrayMicGainValues:[I

    .line 161
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainList:Ljava/util/ArrayList;

    .line 162
    :goto_1
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->arrayMicGainValues:[I

    array-length v3, v2

    if-ge v1, v3, :cond_3

    .line 163
    aget v2, v2, v1

    iget v3, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->currentMicGain:I

    if-ne v2, v3, :cond_2

    .line 164
    iput v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicCurrentCheckItem:I

    .line 166
    :cond_2
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainList:Ljava/util/ArrayList;

    aget-object v3, v0, v1

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 168
    :cond_3
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mTVMicGanValue:Landroid/widget/TextView;

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainList:Ljava/util/ArrayList;

    iget p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicCurrentCheckItem:I

    invoke-virtual {v1, p0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/CharSequence;

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method private initView()V
    .locals 5
    .annotation build Landroid/annotation/SuppressLint;
        value = {
            "WrongViewCast"
        }
    .end annotation

    const v0, 0x7f090196

    .line 73
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mRelDeviceId:Landroid/view/View;

    .line 74
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f090197

    .line 75
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mTvDeviceId:Landroid/widget/TextView;

    .line 76
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "pref_person_device_id"

    const/4 v2, 0x1

    invoke-static {p0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 77
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mTvDeviceId:Landroid/widget/TextView;

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v0, 0x7f090199

    .line 79
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mRelLimitSendTime:Landroid/view/View;

    .line 80
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f09019a

    .line 81
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mTvLimitSendTime:Landroid/widget/TextView;

    const-string v0, "pref_person_limit_send_time"

    const/16 v1, 0x1e

    .line 82
    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->currentLimitSendTime:I

    const v0, 0x7f0901a0

    .line 83
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Switch;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchStartTone:Landroid/widget/Switch;

    .line 84
    invoke-virtual {v0, p0}, Landroid/widget/Switch;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f09019c

    .line 85
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Switch;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchEndTone:Landroid/widget/Switch;

    .line 86
    invoke-virtual {v0, p0}, Landroid/widget/Switch;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f09019e

    .line 87
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Switch;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchRecord:Landroid/widget/Switch;

    .line 88
    invoke-virtual {v0, p0}, Landroid/widget/Switch;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f090194

    .line 89
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Switch;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchBusyNoSend:Landroid/widget/Switch;

    .line 90
    invoke-virtual {v0, p0}, Landroid/widget/Switch;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f090195

    .line 92
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGanValue:Landroid/view/View;

    .line 93
    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f0900dc

    .line 94
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mTVMicGanValue:Landroid/widget/TextView;

    const-string v0, "pref_person_mic_gan_value"

    const/4 v1, 0x0

    .line 95
    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->currentMicGain:I

    const v0, 0x7f090198

    .line 97
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/RelativeLayout;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mkillWalkieTalkie:Landroid/widget/RelativeLayout;

    const v0, 0x7f0901a1

    .line 98
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/RelativeLayout;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mReviveWalkietalkie:Landroid/widget/RelativeLayout;

    .line 99
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mkillWalkieTalkie:Landroid/widget/RelativeLayout;

    invoke-virtual {v0, p0}, Landroid/widget/RelativeLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 100
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mReviveWalkietalkie:Landroid/widget/RelativeLayout;

    invoke-virtual {v0, p0}, Landroid/widget/RelativeLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 102
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInitChannelDataDB()Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    move-result-object v0

    .line 103
    invoke-static {p0}, Lcom/pri/prizeinterphone/constant/Constants;->getSelectedChannelArea(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v0

    .line 104
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->getAllChannels()Ljava/util/ArrayList;

    move-result-object v0

    move v3, v1

    .line 107
    :goto_0
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v4

    if-ge v3, v4, :cond_1

    .line 108
    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v4, v4, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    if-ne v4, v2, :cond_0

    .line 109
    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    goto :goto_1

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    :goto_1
    if-eqz v0, :cond_2

    .line 114
    iget v3, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    if-ne v3, v2, :cond_2

    .line 115
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mkillWalkieTalkie:Landroid/widget/RelativeLayout;

    const/16 v3, 0x8

    invoke-virtual {v2, v3}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    .line 116
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mReviveWalkietalkie:Landroid/widget/RelativeLayout;

    invoke-virtual {v2, v3}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    :cond_2
    if-eqz v0, :cond_3

    .line 119
    iget v2, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    if-nez v2, :cond_3

    iget v0, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->interrupt:I

    const/4 v2, 0x3

    if-ne v0, v2, :cond_3

    .line 121
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchBusyNoSend:Landroid/widget/Switch;

    invoke-virtual {v0, v1}, Landroid/widget/Switch;->setEnabled(Z)V

    const v0, 0x7f09029b

    .line 122
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p0

    invoke-virtual {p0, v1}, Landroid/view/View;->setVisibility(I)V

    :cond_3
    return-void
.end method

.method private isTalkSend()Z
    .locals 2

    const-string v0, "pref_person_send_status"

    const/4 v1, 0x0

    .line 658
    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result p0

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    move v1, v0

    :cond_0
    return v1
.end method

.method private showDeviceIdeDialog()V
    .locals 5

    .line 333
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c005b

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 335
    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    .line 336
    invoke-virtual {v1, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 338
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    .line 339
    iget v1, v1, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 341
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    invoke-virtual {v2}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v2

    .line 342
    invoke-virtual {v2}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v3

    const/16 v4, 0x50

    .line 343
    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v4, 0x3c

    .line 344
    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float v1, v1

    const v4, 0x3f666666    # 0.9f

    mul-float/2addr v1, v4

    float-to-int v1, v1

    .line 345
    iput v1, v3, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 346
    invoke-virtual {v2, v3}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const v1, 0x106000d

    .line 347
    invoke-virtual {v2, v1}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    .line 348
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    invoke-virtual {v1}, Landroid/app/Dialog;->show()V

    const v1, 0x7f09017d

    .line 350
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/EditText;

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialogEdit:Landroid/widget/EditText;

    .line 351
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "pref_person_device_id"

    const/4 v3, 0x1

    invoke-static {p0, v2, v3}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 352
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialogEdit:Landroid/widget/EditText;

    invoke-virtual {v2, v1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    const v1, 0x7f09017c

    .line 353
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/Button;

    .line 354
    invoke-virtual {v1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v1, 0x7f09017e

    .line 355
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    .line 356
    invoke-virtual {v0, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method

.method private showKillOrReviveWalkieTalkies(Z)V
    .locals 5

    .line 377
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c005c

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 379
    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    .line 380
    invoke-virtual {v1, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 382
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    .line 383
    iget v1, v1, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 385
    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    invoke-virtual {v2}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v2

    .line 386
    invoke-virtual {v2}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v3

    const/16 v4, 0x50

    .line 387
    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v4, 0x3c

    .line 388
    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float v1, v1

    const v4, 0x3f666666    # 0.9f

    mul-float/2addr v1, v4

    float-to-int v1, v1

    .line 389
    iput v1, v3, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 390
    invoke-virtual {v2, v3}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const v1, 0x106000d

    .line 391
    invoke-virtual {v2, v1}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    .line 392
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    invoke-virtual {v1}, Landroid/app/Dialog;->show()V

    const v1, 0x7f09017d

    .line 394
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/EditText;

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialogEdit:Landroid/widget/EditText;

    const/4 v2, 0x2

    .line 395
    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setInputType(I)V

    const v1, 0x7f09005b

    .line 396
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/Button;

    .line 397
    invoke-virtual {v1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 398
    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/Button;->setTag(Ljava/lang/Object;)V

    const v1, 0x7f09005c

    .line 399
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/Button;

    .line 400
    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/Button;->setTag(Ljava/lang/Object;)V

    .line 401
    invoke-virtual {v1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const p0, 0x7f090287

    .line 402
    invoke-virtual {v0, p0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    check-cast p0, Landroid/widget/TextView;

    if-eqz p1, :cond_0

    const p1, 0x7f11010c

    goto :goto_0

    :cond_0
    const p1, 0x7f110117

    .line 403
    :goto_0
    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setText(I)V

    return-void
.end method

.method private showLimitSendTimeDialog()V
    .locals 6

    .line 427
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c005d

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 428
    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeDialog:Landroid/app/Dialog;

    .line 429
    invoke-virtual {v1, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 430
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    .line 431
    iget v1, v1, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 432
    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeDialog:Landroid/app/Dialog;

    invoke-virtual {v3}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v3

    .line 433
    invoke-virtual {v3}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v4

    const/16 v5, 0x50

    .line 434
    iput v5, v4, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v5, 0x3c

    .line 435
    iput v5, v4, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float v1, v1

    const v5, 0x3f666666    # 0.9f

    mul-float/2addr v1, v5

    float-to-int v1, v1

    .line 436
    iput v1, v4, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 437
    invoke-virtual {v3, v4}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const v1, 0x106000d

    .line 438
    invoke-virtual {v3, v1}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    .line 439
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeDialog:Landroid/app/Dialog;

    invoke-virtual {v1}, Landroid/app/Dialog;->show()V

    const v1, 0x7f09018d

    .line 440
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ListView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeListView:Landroid/widget/ListView;

    .line 441
    new-instance v0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;

    invoke-direct {v0, p0, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;

    .line 442
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeListView:Landroid/widget/ListView;

    invoke-virtual {v1, v0}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    .line 443
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeListView:Landroid/widget/ListView;

    invoke-virtual {v0, v2}, Landroid/widget/ListView;->setDivider(Landroid/graphics/drawable/Drawable;)V

    .line 444
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeListView:Landroid/widget/ListView;

    new-instance v1, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$2;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$2;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/ListView;->setOnItemClickListener(Landroid/widget/AdapterView$OnItemClickListener;)V

    return-void
.end method

.method private showMicGainValueDialog()V
    .locals 6

    .line 462
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c005f

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 463
    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainDialog:Landroid/app/Dialog;

    .line 464
    invoke-virtual {v1, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 465
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    .line 466
    iget v1, v1, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 467
    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainDialog:Landroid/app/Dialog;

    invoke-virtual {v3}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v3

    .line 468
    invoke-virtual {v3}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v4

    const/16 v5, 0x50

    .line 469
    iput v5, v4, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v5, 0x3c

    .line 470
    iput v5, v4, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float v1, v1

    const v5, 0x3f666666    # 0.9f

    mul-float/2addr v1, v5

    float-to-int v1, v1

    .line 471
    iput v1, v4, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 472
    invoke-virtual {v3, v4}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const v1, 0x106000d

    .line 473
    invoke-virtual {v3, v1}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    .line 474
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainDialog:Landroid/app/Dialog;

    invoke-virtual {v1}, Landroid/app/Dialog;->show()V

    const v1, 0x7f09018f

    .line 475
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ListView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainListView:Landroid/widget/ListView;

    .line 476
    new-instance v0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$MicGainListAdapter;

    invoke-direct {v0, p0, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$MicGainListAdapter;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$MicGainListAdapter;

    .line 477
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainListView:Landroid/widget/ListView;

    invoke-virtual {v1, v0}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    .line 478
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainListView:Landroid/widget/ListView;

    invoke-virtual {v0, v2}, Landroid/widget/ListView;->setDivider(Landroid/graphics/drawable/Drawable;)V

    .line 479
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainListView:Landroid/widget/ListView;

    new-instance v1, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$3;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$3;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/ListView;->setOnItemClickListener(Landroid/widget/AdapterView$OnItemClickListener;)V

    return-void
.end method

.method private showToast(I)V
    .locals 1

    .line 650
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 651
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    :cond_0
    const/4 v0, 0x0

    .line 653
    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mToast:Landroid/widget/Toast;

    .line 654
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private updateDeviceIdView(Ljava/lang/String;)V
    .locals 1

    .line 407
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mTvDeviceId:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 408
    invoke-static {p1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p1

    const-string v0, "pref_person_device_id"

    invoke-static {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putIntData(Landroid/content/Context;Ljava/lang/String;I)V

    return-void
.end method

.method private updateLimitSendTimeView(Ljava/lang/String;)V
    .locals 1

    .line 498
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;

    if-eqz v0, :cond_0

    .line 499
    invoke-virtual {v0}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    .line 501
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mTvLimitSendTime:Landroid/widget/TextView;

    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method private updateSwitchData(Ljava/lang/String;Z)V
    .locals 0

    .line 174
    invoke-static {p0, p1, p2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putBooleanData(Landroid/content/Context;Ljava/lang/String;Z)V

    return-void
.end method

.method private updatemicGainView(Ljava/lang/String;)V
    .locals 1

    .line 567
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainListAdapter:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$MicGainListAdapter;

    if-eqz v0, :cond_0

    .line 568
    invoke-virtual {v0}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    .line 570
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mTVMicGanValue:Landroid/widget/TextView;

    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method


# virtual methods
.method public onBackPressed()V
    .locals 0

    .line 67
    invoke-super {p0}, Landroidx/activity/ComponentActivity;->onBackPressed()V

    return-void
.end method

.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 0

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 6

    .line 179
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result v0

    const v1, 0x7f090054

    if-ne v1, v0, :cond_0

    .line 180
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->onBackPressed()V

    goto/16 :goto_7

    .line 182
    :cond_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 183
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    sparse-switch p1, :sswitch_data_0

    goto :goto_0

    .line 185
    :sswitch_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchStartTone:Landroid/widget/Switch;

    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentStartTone:Z

    invoke-virtual {p1, v0}, Landroid/widget/Switch;->setChecked(Z)V

    goto :goto_0

    .line 191
    :sswitch_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchRecord:Landroid/widget/Switch;

    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentRecord:Z

    invoke-virtual {p1, v0}, Landroid/widget/Switch;->setChecked(Z)V

    goto :goto_0

    .line 188
    :sswitch_2
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchEndTone:Landroid/widget/Switch;

    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentEndTone:Z

    invoke-virtual {p1, v0}, Landroid/widget/Switch;->setChecked(Z)V

    goto :goto_0

    .line 194
    :sswitch_3
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchBusyNoSend:Landroid/widget/Switch;

    iget-boolean v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentBusyNoSend:Z

    invoke-virtual {p1, v0}, Landroid/widget/Switch;->setChecked(Z)V

    goto :goto_0

    .line 197
    :sswitch_4
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    if-eqz p0, :cond_1

    .line 198
    invoke-virtual {p0}, Landroid/app/Dialog;->dismiss()V

    :cond_1
    return-void

    :goto_0
    const p1, 0x7f11011c

    .line 202
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->showToast(I)V

    goto/16 :goto_7

    .line 204
    :cond_2
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result v0

    const v1, 0xfffcdf

    const v2, 0x7f11007f

    const v3, 0x7f110079

    const/4 v4, 0x0

    const/4 v5, 0x1

    sparse-switch v0, :sswitch_data_1

    goto/16 :goto_7

    .line 273
    :sswitch_5
    invoke-direct {p0, v4}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->showKillOrReviveWalkieTalkies(Z)V

    goto/16 :goto_7

    .line 212
    :sswitch_6
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentStartTone:Z

    xor-int/2addr p1, v5

    iput-boolean p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentStartTone:Z

    .line 213
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchStartTone:Landroid/widget/Switch;

    invoke-virtual {v0, p1}, Landroid/widget/Switch;->setChecked(Z)V

    .line 214
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentStartTone:Z

    const-string v0, "pref_person_ptt_start_tone"

    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->updateSwitchData(Ljava/lang/String;Z)V

    goto/16 :goto_7

    .line 222
    :sswitch_7
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentRecord:Z

    xor-int/2addr p1, v5

    iput-boolean p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentRecord:Z

    .line 223
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchRecord:Landroid/widget/Switch;

    invoke-virtual {v0, p1}, Landroid/widget/Switch;->setChecked(Z)V

    .line 224
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentRecord:Z

    const-string v0, "pref_person_ptt_record"

    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->updateSwitchData(Ljava/lang/String;Z)V

    goto/16 :goto_7

    .line 217
    :sswitch_8
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentEndTone:Z

    xor-int/2addr p1, v5

    iput-boolean p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentEndTone:Z

    .line 218
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchEndTone:Landroid/widget/Switch;

    invoke-virtual {v0, p1}, Landroid/widget/Switch;->setChecked(Z)V

    .line 219
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentEndTone:Z

    const-string v0, "pref_person_ptt_end_tone"

    invoke-direct {p0, v0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->updateSwitchData(Ljava/lang/String;Z)V

    goto/16 :goto_7

    .line 209
    :sswitch_9
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->showLimitSendTimeDialog()V

    goto/16 :goto_7

    .line 270
    :sswitch_a
    invoke-direct {p0, v5}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->showKillOrReviveWalkieTalkies(Z)V

    goto/16 :goto_7

    .line 206
    :sswitch_b
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->showDeviceIdeDialog()V

    goto/16 :goto_7

    .line 239
    :sswitch_c
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->showMicGainValueDialog()V

    goto/16 :goto_3

    :sswitch_d
    const-string p1, "pref_person_interrupt_transmission_value"

    .line 227
    invoke-static {p0, p1, v5}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result p1

    const/4 v0, 0x3

    const-string v1, "pref_person_busy_no_send"

    if-eq p1, v0, :cond_3

    .line 229
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentBusyNoSend:Z

    xor-int/2addr p1, v5

    iput-boolean p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentBusyNoSend:Z

    .line 230
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchBusyNoSend:Landroid/widget/Switch;

    invoke-virtual {v0, p1}, Landroid/widget/Switch;->setChecked(Z)V

    .line 231
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mCurrentBusyNoSend:Z

    invoke-direct {p0, v1, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->updateSwitchData(Ljava/lang/String;Z)V

    goto/16 :goto_7

    .line 233
    :cond_3
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mSwitchBusyNoSend:Landroid/widget/Switch;

    invoke-virtual {p1, v4}, Landroid/widget/Switch;->setChecked(Z)V

    .line 234
    invoke-direct {p0, v1, v4}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->updateSwitchData(Ljava/lang/String;Z)V

    goto/16 :goto_7

    .line 247
    :sswitch_e
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialogEdit:Landroid/widget/EditText;

    if-eqz p1, :cond_8

    .line 248
    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    .line 249
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_4

    .line 250
    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->showToast(I)V

    return-void

    :cond_4
    const-string v0, "[0-9]+"

    .line 252
    invoke-virtual {p1, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_5

    const p1, 0x7f11007e

    .line 253
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->showToast(I)V

    return-void

    .line 256
    :cond_5
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    if-lt v0, v5, :cond_7

    if-le v0, v1, :cond_6

    goto :goto_1

    .line 261
    :cond_6
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->updateDeviceIdView(Ljava/lang/String;)V

    .line 262
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-static {p1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p1

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->setLocalId(I)V

    goto :goto_2

    .line 258
    :cond_7
    :goto_1
    invoke-direct {p0, v2}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->showToast(I)V

    return-void

    .line 265
    :cond_8
    :goto_2
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    if-eqz p0, :cond_e

    .line 266
    invoke-virtual {p0}, Landroid/app/Dialog;->dismiss()V

    goto/16 :goto_7

    .line 241
    :goto_3
    :sswitch_f
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    if-eqz p0, :cond_e

    .line 242
    invoke-virtual {p0}, Landroid/app/Dialog;->dismiss()V

    goto/16 :goto_7

    .line 277
    :sswitch_10
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialogEdit:Landroid/widget/EditText;

    if-eqz v0, :cond_d

    .line 278
    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    .line 279
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_9

    .line 280
    invoke-direct {p0, v3}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->showToast(I)V

    return-void

    .line 283
    :cond_9
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    if-lt v0, v5, :cond_c

    if-le v0, v1, :cond_a

    goto :goto_5

    .line 288
    :cond_a
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    const/16 v2, 0x28

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    invoke-virtual {v1, v2, v3}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerEventListener(BLcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 289
    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Boolean;

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p1

    .line 290
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "isKill="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "FragmentLocalSettingsActivity"

    invoke-static {v2, v1}, Lcom/pri/prizeinterphone/Util/Clog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 291
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    if-eqz p1, :cond_b

    const/4 p1, 0x4

    goto :goto_4

    :cond_b
    const/4 p1, 0x5

    :goto_4
    invoke-virtual {v1, p1, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->enhanceFunction(BI)V

    goto :goto_6

    .line 285
    :cond_c
    :goto_5
    invoke-direct {p0, v2}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->showToast(I)V

    return-void

    .line 295
    :cond_d
    :goto_6
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    if-eqz p0, :cond_e

    .line 296
    invoke-virtual {p0}, Landroid/app/Dialog;->dismiss()V

    goto :goto_7

    .line 300
    :sswitch_11
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    if-eqz p0, :cond_e

    .line 301
    invoke-virtual {p0}, Landroid/app/Dialog;->dismiss()V

    :cond_e
    :goto_7
    return-void

    :sswitch_data_0
    .sparse-switch
        0x7f09017c -> :sswitch_4
        0x7f090194 -> :sswitch_3
        0x7f09019c -> :sswitch_2
        0x7f09019e -> :sswitch_1
        0x7f0901a0 -> :sswitch_0
    .end sparse-switch

    :sswitch_data_1
    .sparse-switch
        0x7f09005b -> :sswitch_11
        0x7f09005c -> :sswitch_10
        0x7f09017c -> :sswitch_f
        0x7f09017e -> :sswitch_e
        0x7f090194 -> :sswitch_d
        0x7f090195 -> :sswitch_c
        0x7f090196 -> :sswitch_b
        0x7f090198 -> :sswitch_a
        0x7f090199 -> :sswitch_9
        0x7f09019c -> :sswitch_8
        0x7f09019e -> :sswitch_7
        0x7f0901a0 -> :sswitch_6
        0x7f0901a1 -> :sswitch_5
    .end sparse-switch
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 1
    .param p1    # Landroid/content/res/Configuration;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 361
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 362
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    const/4 v0, 0x0

    if-eqz p1, :cond_0

    invoke-virtual {p1}, Landroid/app/Dialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 363
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 364
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mDeviceIdDialog:Landroid/app/Dialog;

    .line 366
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_1

    invoke-virtual {p1}, Landroid/app/Dialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 367
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeDialog:Landroid/app/Dialog;

    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 368
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mLimitSendTimeDialog:Landroid/app/Dialog;

    .line 370
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_2

    invoke-virtual {p1}, Landroid/app/Dialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_2

    .line 371
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainDialog:Landroid/app/Dialog;

    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    .line 372
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->mMicGainDialog:Landroid/app/Dialog;

    :cond_2
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 0

    .line 59
    invoke-super {p0, p1}, Landroidx/fragment/app/FragmentActivity;->onCreate(Landroid/os/Bundle;)V

    const p1, 0x7f0c0045

    .line 60
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(I)V

    .line 61
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->initView()V

    .line 62
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->initData()V

    return-void
.end method

.method protected onPause()V
    .locals 2

    .line 133
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onPause()V

    .line 134
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    const/16 v1, 0x28

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v1

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->messageListener:Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;

    invoke-virtual {v0, v1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    return-void
.end method

.method protected onResume()V
    .locals 0

    .line 128
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onResume()V

    return-void
.end method
