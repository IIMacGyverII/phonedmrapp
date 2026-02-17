.class public Lcom/pri/prizeinterphone/activity/MessageContentActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "MessageContentActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;
.implements Lcom/pri/prizeinterphone/manager/MessageLisenter;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "InterPhoneMessageActivity"


# instance fields
.field freshSendBtnRunn:Ljava/lang/Runnable;

.field private isEdit:Z

.field private mActiveChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

.field private mActiveContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

.field private mBtSend:Landroid/widget/Button;

.field private mContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

.field private mContactSeletedId:Ljava/lang/String;

.field private mConvTarget:I

.field private mConvType:I

.field private mConverListData:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/ConversationData;",
            ">;"
        }
    .end annotation
.end field

.field private mConverSeletedTarget:Ljava/lang/String;

.field private mConversation:Lcom/pri/prizeinterphone/serial/data/ConversationData;

.field private mCurrentPosition:I

.field private mCurrentScrollPosition:I

.field private mDialog:Landroid/app/Dialog;

.field private mEdit:Landroid/widget/EditText;

.field private mEditRel:Landroid/widget/RelativeLayout;

.field public mHandler:Landroid/os/Handler;

.field private mListView:Landroid/widget/ListView;

.field private mMessageListAdapter:Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;

.field private mMessageListData:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/MessageData;",
            ">;"
        }
    .end annotation
.end field

.field private mRecieveIconDrawable:Landroid/graphics/drawable/Drawable;

.field private mSendIconDrawable:Landroid/graphics/drawable/Drawable;

.field private mToast:Landroid/widget/Toast;

.field private mTvTitle:Landroid/widget/TextView;


# direct methods
.method static bridge synthetic -$$Nest$fgetmListView(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Landroid/widget/ListView;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mListView:Landroid/widget/ListView;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmMessageListData(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Ljava/util/ArrayList;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmRecieveIconDrawable(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Landroid/graphics/drawable/Drawable;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mRecieveIconDrawable:Landroid/graphics/drawable/Drawable;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmSendIconDrawable(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Landroid/graphics/drawable/Drawable;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mSendIconDrawable:Landroid/graphics/drawable/Drawable;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmCurrentScrollPosition(Lcom/pri/prizeinterphone/activity/MessageContentActivity;I)V
    .locals 0

    iput p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mCurrentScrollPosition:I

    return-void
.end method

.method static bridge synthetic -$$Nest$mfreshSendButton(Lcom/pri/prizeinterphone/activity/MessageContentActivity;Z)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->freshSendButton(Z)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mreFreshUI(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->reFreshUI()V

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 48
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    const/4 v0, -0x1

    .line 74
    iput v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvType:I

    .line 75
    iput v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvTarget:I

    const/4 v0, 0x0

    .line 77
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->isEdit:Z

    .line 255
    new-instance v0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$2;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$2;-><init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->freshSendBtnRunn:Ljava/lang/Runnable;

    .line 345
    new-instance v0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$5;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$5;-><init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mHandler:Landroid/os/Handler;

    return-void
.end method

.method private copy()V
    .locals 2

    .line 244
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    iget v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mCurrentPosition:I

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getContent()Ljava/lang/String;

    move-result-object v0

    const-string v1, "clipboard"

    .line 245
    invoke-virtual {p0, v1}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/content/ClipboardManager;

    const/4 v1, 0x0

    .line 246
    invoke-static {v1, v0}, Landroid/content/ClipData;->newPlainText(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Landroid/content/ClipData;

    move-result-object v0

    .line 247
    invoke-virtual {p0, v0}, Landroid/content/ClipboardManager;->setPrimaryClip(Landroid/content/ClipData;)V

    return-void
.end method

.method private deleteAllData()V
    .locals 5

    .line 233
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    iget v2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mCurrentPosition:I

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getConvType()I

    move-result v1

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    iget v3, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mCurrentPosition:I

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getConv_target()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->getConversationData(II)Lcom/pri/prizeinterphone/serial/data/ConversationData;

    move-result-object v0

    .line 234
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    iget v3, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mCurrentPosition:I

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getConvType()I

    move-result v2

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    iget v4, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mCurrentPosition:I

    invoke-virtual {v3, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getConv_target()I

    move-result v3

    invoke-virtual {v1, v2, v3}, Lcom/pri/prizeinterphone/manager/DmrManager;->deleteAllSms(II)Z

    .line 235
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->clear()V

    .line 236
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListAdapter:Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;

    invoke-virtual {v1}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    if-eqz v0, :cond_0

    .line 238
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->deleteConverList(Lcom/pri/prizeinterphone/serial/data/ConversationData;)Z

    .line 240
    :cond_0
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->onBackPressed()V

    return-void
.end method

.method private deleteData()V
    .locals 4

    .line 219
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 220
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    iget v2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mCurrentPosition:I

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getConvType()I

    move-result v1

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    iget v3, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mCurrentPosition:I

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getConv_target()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->getConversationData(II)Lcom/pri/prizeinterphone/serial/data/ConversationData;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 222
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->deleteConverList(Lcom/pri/prizeinterphone/serial/data/ConversationData;)Z

    .line 225
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    iget v2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mCurrentPosition:I

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->deleteSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)Z

    .line 226
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    iget v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mCurrentPosition:I

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    .line 227
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListAdapter:Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;

    invoke-virtual {v0}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    .line 228
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mListView:Landroid/widget/ListView;

    iget p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mCurrentScrollPosition:I

    invoke-virtual {v0, p0}, Landroid/widget/ListView;->setSelection(I)V

    return-void
.end method

.method private dismissDialog()V
    .locals 1

    .line 516
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mDialog:Landroid/app/Dialog;

    if-eqz v0, :cond_0

    .line 517
    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    const/4 v0, 0x0

    .line 518
    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mDialog:Landroid/app/Dialog;

    :cond_0
    return-void
.end method

.method private freshSendButton(Z)V
    .locals 1

    if-nez p1, :cond_0

    .line 119
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mBtSend:Landroid/widget/Button;

    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Landroid/widget/Button;->setEnabled(Z)V

    .line 120
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mBtSend:Landroid/widget/Button;

    const v0, 0x7f0800b8

    invoke-virtual {p0, v0}, Landroid/app/Activity;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/widget/Button;->setBackground(Landroid/graphics/drawable/Drawable;)V

    goto :goto_0

    .line 122
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mBtSend:Landroid/widget/Button;

    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Landroid/widget/Button;->setEnabled(Z)V

    .line 123
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mBtSend:Landroid/widget/Button;

    const v0, 0x7f0800b6

    invoke-virtual {p0, v0}, Landroid/app/Activity;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/widget/Button;->setBackground(Landroid/graphics/drawable/Drawable;)V

    :goto_0
    return-void
.end method

.method private isTalkSend()Z
    .locals 3

    const-string v0, "pref_person_send_status"

    const/4 v1, 0x0

    .line 532
    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_0

    move v1, v2

    :cond_0
    if-eqz v1, :cond_1

    const v0, 0x7f11011c

    .line 534
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->showToast(I)V

    :cond_1
    return v1
.end method

.method private reFreshListUI()V
    .locals 4

    .line 133
    iget v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvType:I

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    iget v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvTarget:I

    if-eq v0, v1, :cond_0

    .line 134
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    .line 135
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    iget v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvType:I

    iget v2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvTarget:I

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->getAllSms(II)Ljava/util/ArrayList;

    .line 136
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    iget v2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvType:I

    iget v3, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvTarget:I

    invoke-virtual {v1, v2, v3}, Lcom/pri/prizeinterphone/manager/DmrManager;->getAllSms(II)Ljava/util/ArrayList;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    .line 138
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListAdapter:Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;

    invoke-virtual {v0}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    .line 139
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mListView:Landroid/widget/ListView;

    const/16 v0, 0x82

    invoke-virtual {p0, v0}, Landroid/widget/ListView;->setSelection(I)V

    return-void
.end method

.method private reFreshUI()V
    .locals 0

    .line 128
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->reFreshListUI()V

    return-void
.end method

.method private saveAndSendMsg()V
    .locals 3

    .line 205
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/serial/data/MessageData;-><init>()V

    .line 206
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mEdit:Landroid/widget/EditText;

    invoke-virtual {v1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v1

    .line 207
    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setContent(Ljava/lang/String;)V

    const-string v1, "pref_person_device_id"

    const/4 v2, 0x1

    .line 208
    invoke-static {p0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setFrom(I)V

    .line 209
    iget v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvTarget:I

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setTo(I)V

    .line 210
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setTimestamp(J)V

    const/4 v1, 0x0

    .line 211
    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setDirection(I)V

    .line 212
    iget v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvType:I

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setConvType(I)V

    .line 213
    iget p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvTarget:I

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setConv_target(I)V

    .line 214
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->saveSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)Z

    return-void
.end method

.method private setDialogWindowLayoutParams(Landroid/app/Dialog;)V
    .locals 2

    .line 503
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    .line 504
    iget p0, p0, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 506
    invoke-virtual {p1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    .line 507
    invoke-virtual {p1}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    const/16 v1, 0x50

    .line 508
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v1, 0x3c

    .line 509
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float p0, p0

    const v1, 0x3f666666    # 0.9f

    mul-float/2addr p0, v1

    float-to-int p0, p0

    .line 510
    iput p0, v0, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 511
    invoke-virtual {p1, v0}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const p0, 0x106000d

    .line 512
    invoke-virtual {p1, p0}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    return-void
.end method

.method private showToast(I)V
    .locals 1

    .line 524
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 525
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    :cond_0
    const/4 v0, 0x0

    .line 527
    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mToast:Landroid/widget/Toast;

    .line 528
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method


# virtual methods
.method public formatTime(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 469
    invoke-static {p1}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Long;->longValue()J

    move-result-wide p0

    .line 470
    new-instance v0, Ljava/text/SimpleDateFormat;

    const-string/jumbo v1, "yyyy.MM.dd  ahh:mm"

    invoke-direct {v0, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    .line 471
    invoke-static {p0, p1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/text/SimpleDateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public hideEditBar()V
    .locals 1

    .line 199
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mEditRel:Landroid/widget/RelativeLayout;

    if-eqz p0, :cond_0

    const/16 v0, 0x8

    .line 200
    invoke-virtual {p0, v0}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    :cond_0
    return-void
.end method

.method public initData()V
    .locals 4

    .line 144
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mActiveChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    .line 145
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mActiveChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getContactType()I

    move-result v1

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mActiveChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxContact()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->getContact(II)Lcom/pri/prizeinterphone/serial/data/ContactData;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mActiveContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    .line 146
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    const-string v1, "isedit"

    const/4 v2, 0x0

    .line 147
    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result v1

    iput-boolean v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->isEdit:Z

    if-eqz v1, :cond_1

    const-string v1, "conver_type"

    .line 149
    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvType:I

    const/4 v1, 0x1

    const-string v2, "conver_target"

    .line 150
    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvTarget:I

    .line 151
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    iget v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvType:I

    iget v2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvTarget:I

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->getContact(II)Lcom/pri/prizeinterphone/serial/data/ContactData;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    .line 152
    iget v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvType:I

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mActiveChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getContactType()I

    move-result v1

    if-ne v0, v1, :cond_0

    iget v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvTarget:I

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mActiveChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxContact()I

    move-result v1

    if-eq v0, v1, :cond_3

    .line 153
    :cond_0
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->hideEditBar()V

    goto :goto_0

    .line 156
    :cond_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mActiveContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    if-nez v0, :cond_2

    .line 158
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mActiveChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getContactType()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvType:I

    .line 159
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mActiveChannelData:Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxContact()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvTarget:I

    goto :goto_0

    .line 161
    :cond_2
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getType()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvType:I

    .line 162
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getNumber()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvTarget:I

    .line 166
    :cond_3
    :goto_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    const v1, 0x7f080092

    if-eqz v0, :cond_7

    .line 167
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getBitmap()Landroid/graphics/Bitmap;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 169
    invoke-static {p0, v0}, Lcom/pri/prizeinterphone/widget/CircleFramedDrawable;->getInstance(Landroid/content/Context;Landroid/graphics/Bitmap;)Lcom/pri/prizeinterphone/widget/CircleFramedDrawable;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mRecieveIconDrawable:Landroid/graphics/drawable/Drawable;

    goto :goto_1

    .line 171
    :cond_4
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getType()I

    move-result v0

    if-nez v0, :cond_5

    .line 172
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mRecieveIconDrawable:Landroid/graphics/drawable/Drawable;

    goto :goto_1

    .line 174
    :cond_5
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v2, 0x7f080093

    invoke-virtual {v0, v2}, Landroid/content/res/Resources;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mRecieveIconDrawable:Landroid/graphics/drawable/Drawable;

    .line 177
    :goto_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getName()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_6

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_6

    .line 178
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mTvTitle:Landroid/widget/TextView;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_2

    .line 180
    :cond_6
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mTvTitle:Landroid/widget/TextView;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mContactData:Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getNumber()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_2

    .line 183
    :cond_7
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mRecieveIconDrawable:Landroid/graphics/drawable/Drawable;

    .line 184
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mTvTitle:Landroid/widget/TextView;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget v3, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConvTarget:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ""

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 187
    :goto_2
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getAllConversations()Ljava/util/ArrayList;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mConverListData:Ljava/util/ArrayList;

    .line 188
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->reFreshListUI()V

    const/4 v0, 0x0

    const-string v2, "pref_person_icon"

    .line 190
    invoke-static {p0, v2, v0}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getImgData(Landroid/content/Context;Ljava/lang/String;Landroid/graphics/Bitmap;)Landroid/graphics/Bitmap;

    move-result-object v0

    if-nez v0, :cond_8

    .line 192
    invoke-virtual {p0}, Landroidx/appcompat/app/AppCompatActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mSendIconDrawable:Landroid/graphics/drawable/Drawable;

    goto :goto_3

    .line 194
    :cond_8
    invoke-static {p0, v0}, Lcom/pri/prizeinterphone/widget/CircleFramedDrawable;->getInstance(Landroid/content/Context;Landroid/graphics/Bitmap;)Lcom/pri/prizeinterphone/widget/CircleFramedDrawable;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mSendIconDrawable:Landroid/graphics/drawable/Drawable;

    :goto_3
    return-void
.end method

.method public initView()V
    .locals 2

    const v0, 0x7f090150

    .line 89
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mTvTitle:Landroid/widget/TextView;

    const v0, 0x7f090142

    .line 92
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mEdit:Landroid/widget/EditText;

    const v0, 0x7f090143

    .line 94
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/RelativeLayout;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mEditRel:Landroid/widget/RelativeLayout;

    const v0, 0x7f09014f

    .line 96
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mBtSend:Landroid/widget/Button;

    const/4 v0, 0x1

    .line 97
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->freshSendButton(Z)V

    .line 98
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mBtSend:Landroid/widget/Button;

    invoke-virtual {v0, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f09014e

    .line 100
    invoke-virtual {p0, v0}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ListView;

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mListView:Landroid/widget/ListView;

    .line 101
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListData:Ljava/util/ArrayList;

    .line 102
    new-instance v0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;

    invoke-direct {v0, p0, p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;-><init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity;Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mMessageListAdapter:Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;

    .line 103
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mListView:Landroid/widget/ListView;

    invoke-virtual {v1, v0}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    .line 104
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mListView:Landroid/widget/ListView;

    new-instance v1, Lcom/pri/prizeinterphone/activity/MessageContentActivity$1;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$1;-><init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/ListView;->setOnScrollListener(Landroid/widget/AbsListView$OnScrollListener;)V

    return-void
.end method

.method public isInThreeMins(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 2

    .line 460
    invoke-static {p1}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Long;->longValue()J

    move-result-wide p0

    .line 461
    invoke-static {p2}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    sub-long/2addr v0, p0

    const-wide/16 p0, 0x4650

    cmp-long p0, v0, p0

    if-gez p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public onBackPressed()V
    .locals 0

    .line 252
    invoke-super {p0}, Landroidx/activity/ComponentActivity;->onBackPressed()V

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 2

    .line 264
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    const v0, 0x7f090054

    if-eq p1, v0, :cond_5

    const v0, 0x7f09014f

    if-eq p1, v0, :cond_2

    const v0, 0x7f110150

    packed-switch p1, :pswitch_data_0

    goto :goto_0

    .line 294
    :pswitch_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_0

    return-void

    .line 297
    :cond_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->deleteAllData()V

    .line 298
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->dismissDialog()V

    .line 299
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->showToast(I)V

    goto :goto_0

    .line 286
    :pswitch_1
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_1

    return-void

    .line 289
    :cond_1
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->deleteData()V

    .line 290
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->dismissDialog()V

    .line 291
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->showToast(I)V

    goto :goto_0

    .line 282
    :pswitch_2
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->copy()V

    .line 283
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->dismissDialog()V

    goto :goto_0

    .line 269
    :cond_2
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mEdit:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    .line 270
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_3

    return-void

    .line 273
    :cond_3
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_4

    return-void

    .line 276
    :cond_4
    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->saveAndSendMsg()V

    .line 277
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mEdit:Landroid/widget/EditText;

    const-string v0, ""

    invoke-virtual {p1, v0}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    const/4 p1, 0x0

    .line 278
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->freshSendButton(Z)V

    .line 279
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mHandler:Landroid/os/Handler;

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->freshSendBtnRunn:Ljava/lang/Runnable;

    const-wide/16 v0, 0xdac

    invoke-virtual {p1, p0, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto :goto_0

    .line 266
    :cond_5
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->onBackPressed()V

    :goto_0
    return-void

    :pswitch_data_0
    .packed-switch 0x7f090144
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 0
    .param p1    # Landroid/content/res/Configuration;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 494
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 495
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_0

    invoke-virtual {p1}, Landroid/app/Dialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 496
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mDialog:Landroid/app/Dialog;

    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    const/4 p1, 0x0

    .line 497
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mDialog:Landroid/app/Dialog;

    .line 498
    iget p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mCurrentPosition:I

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->showListDialog(I)V

    :cond_0
    return-void
.end method

.method public onConversationClean(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V
    .locals 0

    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 0

    .line 81
    invoke-super {p0, p1}, Landroidx/fragment/app/FragmentActivity;->onCreate(Landroid/os/Bundle;)V

    const p1, 0x7f0c0054

    .line 82
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(I)V

    .line 83
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->initView()V

    .line 84
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->initData()V

    .line 85
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->addMessageListener(Lcom/pri/prizeinterphone/manager/MessageLisenter;)V

    return-void
.end method

.method public onMessageDelete(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
    .locals 0

    const-string p0, "InterPhoneMessageActivity"

    const-string p1, "onMessageDelete: "

    .line 338
    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onMessageReceived()V
    .locals 2

    const-string v0, "InterPhoneMessageActivity"

    const-string v1, "onMessageReceived: "

    .line 306
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 307
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mHandler:Landroid/os/Handler;

    new-instance v1, Lcom/pri/prizeinterphone/activity/MessageContentActivity$3;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$3;-><init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public onMessageSend(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
    .locals 2

    .line 322
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onMessageSend: msg "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getStatus()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "InterPhoneMessageActivity"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 323
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mHandler:Landroid/os/Handler;

    new-instance v1, Lcom/pri/prizeinterphone/activity/MessageContentActivity$4;

    invoke-direct {v1, p0, p1}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$4;-><init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity;Lcom/pri/prizeinterphone/serial/data/MessageData;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public onUnreadStatusUpdated()V
    .locals 1

    const-string p0, "InterPhoneMessageActivity"

    const-string v0, "onUnreadStatusUpdated: "

    .line 317
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public showListDialog(I)V
    .locals 2

    .line 477
    iput p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mCurrentPosition:I

    .line 478
    invoke-static {p0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p1

    const v0, 0x7f0c0055

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p1

    const v0, 0x7f090144

    .line 480
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    .line 481
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f090145

    .line 482
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    .line 483
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f090146

    .line 484
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    .line 485
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 486
    new-instance v0, Landroid/app/Dialog;

    invoke-direct {v0, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mDialog:Landroid/app/Dialog;

    .line 487
    invoke-virtual {v0, p1}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 488
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mDialog:Landroid/app/Dialog;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->setDialogWindowLayoutParams(Landroid/app/Dialog;)V

    .line 489
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->mDialog:Landroid/app/Dialog;

    invoke-virtual {p0}, Landroid/app/Dialog;->show()V

    return-void
.end method
