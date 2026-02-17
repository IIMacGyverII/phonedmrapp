.class public Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;
.super Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;
.source "InterPhoneMessageFragment.java"

# interfaces
.implements Landroid/widget/AdapterView$OnItemClickListener;
.implements Landroid/widget/AdapterView$OnItemLongClickListener;
.implements Landroid/widget/AdapterView$OnItemSelectedListener;
.implements Lcom/pri/prizeinterphone/manager/MessageLisenter;
.implements Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeOnItemClickListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;
    }
.end annotation


# static fields
.field private static final REQUEST_CODE_ADD_MESSAGE:I = 0x3e9

.field private static final REQUEST_CODE_EDIT_CONV:I = 0x3ec

.field private static final REQUEST_CODE_EDIT_MESSAGE:I = 0x3ea

.field private static final TAG:Ljava/lang/String; = "InterPhoneMessageFragment"


# instance fields
.field public deleteIndex:I

.field private mConversationDataList:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/ConversationData;",
            ">;"
        }
    .end annotation
.end field

.field private mEmptyMessageWarning:Landroid/widget/TextView;

.field private mFragmentManager:Landroidx/fragment/app/FragmentManager;

.field public mHandler:Landroid/os/Handler;

.field private mLocalView:Landroid/view/View;

.field private mMessageListAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;

.field private mMessagetListView:Landroid/widget/ListView;

.field private mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

.field private mToast:Landroid/widget/Toast;

.field private mUtilContactsDataPeople:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

.field private mUtilConversationData:Lcom/pri/prizeinterphone/serial/data/UtilConversationData;


# direct methods
.method static bridge synthetic -$$Nest$mreFreshUI(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->reFreshUI()V

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 62
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;-><init>()V

    const/4 v0, -0x1

    .line 185
    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->deleteIndex:I

    .line 243
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$2;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$2;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mHandler:Landroid/os/Handler;

    return-void
.end method

.method private isTalkSend()Z
    .locals 3

    .line 434
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

    .line 436
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->showToast(I)V

    :cond_1
    return v2
.end method

.method private reFreshUI()V
    .locals 4

    .line 103
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->isAdded()Z

    move-result v0

    if-eqz v0, :cond_4

    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mMessageListAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;

    if-nez v0, :cond_0

    goto :goto_1

    .line 106
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getAllConversations()Ljava/util/ArrayList;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mConversationDataList:Ljava/util/ArrayList;

    const/4 v0, 0x0

    move v1, v0

    .line 107
    :goto_0
    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mConversationDataList:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    if-ge v1, v2, :cond_2

    .line 108
    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mConversationDataList:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/ConversationData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getName()Ljava/lang/String;

    move-result-object v2

    const-string v3, ""

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 109
    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mConversationDataList:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    goto :goto_0

    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 114
    :cond_2
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mMessageListAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mConversationDataList:Ljava/util/ArrayList;

    invoke-virtual {v1, v2}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;->setList(Ljava/util/ArrayList;)V

    .line 115
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mMessageListAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;

    invoke-virtual {v1}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    .line 117
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mConversationDataList:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    const/16 v2, 0x8

    if-nez v1, :cond_3

    .line 118
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mEmptyMessageWarning:Landroid/widget/TextView;

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setVisibility(I)V

    .line 119
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mEmptyMessageWarning:Landroid/widget/TextView;

    const v1, 0x7f110040

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(I)V

    .line 120
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mMessagetListView:Landroid/widget/ListView;

    invoke-virtual {p0, v2}, Landroid/widget/ListView;->setVisibility(I)V

    goto :goto_1

    .line 122
    :cond_3
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mEmptyMessageWarning:Landroid/widget/TextView;

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setVisibility(I)V

    .line 123
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mMessagetListView:Landroid/widget/ListView;

    invoke-virtual {p0, v0}, Landroid/widget/ListView;->setVisibility(I)V

    :cond_4
    :goto_1
    return-void
.end method

.method private showPopupWindow(Landroid/view/View;)V
    .locals 6

    .line 214
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 217
    :cond_0
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object v0

    const/high16 v1, 0x42480000    # 50.0f

    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/Util/UtilDensity;->dip2px(Landroid/content/Context;F)I

    move-result v0

    .line 218
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    const v2, 0x7f110110

    .line 219
    invoke-virtual {p0, v2}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 220
    iget-object v3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-virtual {p0, v2}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v3, v1, v2}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->refreshData(Ljava/util/ArrayList;Ljava/lang/String;)V

    .line 221
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->setNotShowSelect(Z)V

    .line 222
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    const-wide v2, 0x400a666666666666L    # 3.3

    int-to-double v4, v0

    mul-double/2addr v4, v2

    double-to-int v2, v4

    invoke-virtual {v1, v2}, Landroid/widget/PopupWindow;->setWidth(I)V

    .line 223
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-virtual {v1, v0}, Landroid/widget/PopupWindow;->setHeight(I)V

    .line 224
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-virtual {p0, p1}, Landroid/widget/PopupWindow;->showAsDropDown(Landroid/view/View;)V

    return-void
.end method

.method private showToast(I)V
    .locals 2

    .line 426
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 427
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    .line 429
    :cond_0
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mToast:Landroid/widget/Toast;

    .line 430
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method


# virtual methods
.method public doAddAction()V
    .locals 3

    .line 132
    invoke-super {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->doAddAction()V

    .line 133
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 136
    :cond_0
    new-instance v0, Landroid/content/Intent;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v1

    const-class v2, Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 138
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    const/16 v1, 0x3e9

    invoke-virtual {p0, v0, v1}, Landroidx/activity/ComponentActivity;->startActivityForResult(Landroid/content/Intent;I)V

    return-void
.end method

.method public getMessageListItemId(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    const-string p0, "_"

    .line 379
    invoke-virtual {p1, p0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 381
    array-length p1, p0

    const/4 v0, 0x1

    if-le p1, v0, :cond_0

    .line 382
    aget-object p0, p0, v0

    return-object p0

    :cond_0
    const-string p0, "1"

    return-object p0
.end method

.method public getMessageListItemType(Ljava/lang/String;)I
    .locals 2

    const-string p0, "_"

    .line 389
    invoke-virtual {p1, p0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 391
    array-length p1, p0

    const/4 v0, 0x0

    const/4 v1, 0x1

    if-le p1, v1, :cond_1

    .line 392
    aget-object p1, p0, v1

    .line 393
    aget-object p0, p0, v0

    .line 394
    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0

    if-nez p0, :cond_0

    return v0

    :cond_0
    return v1

    :cond_1
    return v0
.end method

.method public getMyTag()Ljava/lang/String;
    .locals 0

    const-string p0, "InterPhoneMessageFragment"

    return-object p0
.end method

.method public initView(Landroid/view/View;)V
    .locals 2

    .line 67
    invoke-super {p0, p1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->initView(Landroid/view/View;)V

    .line 69
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p1

    const v0, 0x7f0c004b

    const/4 v1, 0x0

    .line 70
    invoke-virtual {p1, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mLocalView:Landroid/view/View;

    .line 71
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mFragmentContainer:Landroid/widget/FrameLayout;

    invoke-virtual {v0, p1}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;)V

    const p1, 0x7f08008c

    .line 72
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setAddButton(I)V

    .line 74
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900b3

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mEmptyMessageWarning:Landroid/widget/TextView;

    .line 75
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900de

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ListView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mMessagetListView:Landroid/widget/ListView;

    .line 76
    invoke-virtual {p1, p0}, Landroid/widget/ListView;->setOnItemClickListener(Landroid/widget/AdapterView$OnItemClickListener;)V

    .line 77
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mMessagetListView:Landroid/widget/ListView;

    invoke-virtual {p1, p0}, Landroid/widget/ListView;->setOnItemLongClickListener(Landroid/widget/AdapterView$OnItemLongClickListener;)V

    .line 78
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mMessagetListView:Landroid/widget/ListView;

    invoke-virtual {p1, p0}, Landroid/widget/ListView;->setOnItemSelectedListener(Landroid/widget/AdapterView$OnItemSelectedListener;)V

    .line 79
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mConversationDataList:Ljava/util/ArrayList;

    .line 80
    new-instance p1, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mConversationDataList:Ljava/util/ArrayList;

    invoke-direct {p1, p0, v0, v1}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;Landroid/content/Context;Ljava/util/ArrayList;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mMessageListAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;

    .line 81
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mMessagetListView:Landroid/widget/ListView;

    invoke-virtual {v0, p1}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    .line 82
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->addMessageListener(Lcom/pri/prizeinterphone/manager/MessageLisenter;)V

    .line 83
    new-instance p1, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-direct {p1, v0}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;-><init>(Landroid/content/Context;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    .line 84
    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/widget/SpinerPopWindow;->setPrizeOnItemClickListener(Lcom/pri/prizeinterphone/widget/SpinerPopWindow$PrizeOnItemClickListener;)V

    return-void
.end method

.method public onActivityResult(IILandroid/content/Intent;)V
    .locals 0
    .param p3    # Landroid/content/Intent;
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param

    .line 143
    invoke-super {p0, p1, p2, p3}, Landroidx/fragment/app/Fragment;->onActivityResult(IILandroid/content/Intent;)V

    const-string p0, "InterPhoneMessageFragment"

    const-string p1, "onActivityResult: resultCode "

    .line 144
    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onConversationClean(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V
    .locals 0

    return-void
.end method

.method public onDestroy()V
    .locals 1

    .line 98
    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onDestroy()V

    .line 99
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->removeMessageListener(Lcom/pri/prizeinterphone/manager/MessageLisenter;)V

    return-void
.end method

.method public onItemClick(I)V
    .locals 3

    .line 172
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 175
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mConversationDataList:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;

    const/4 v0, 0x0

    .line 176
    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->setUnReadCount(I)V

    .line 177
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateConversation(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V

    .line 178
    new-instance v0, Landroid/content/Intent;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v1

    const-class v2, Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const/4 v1, 0x1

    const-string v2, "isedit"

    .line 179
    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    .line 180
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onItemClick: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "InterPhoneMessageFragment"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 181
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getConvType()I

    move-result v1

    const-string v2, "conver_type"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 182
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getConvTarget()I

    move-result p1

    const-string v1, "conver_target"

    invoke-virtual {v0, v1, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 183
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    invoke-virtual {p0, v0}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

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

    .line 157
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_0

    return-void

    .line 160
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mConversationDataList:Ljava/util/ArrayList;

    invoke-virtual {p1, p3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;

    const/4 p2, 0x0

    .line 161
    invoke-virtual {p1, p2}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->setUnReadCount(I)V

    .line 162
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p2

    invoke-virtual {p2, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateConversation(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V

    .line 163
    new-instance p2, Landroid/content/Intent;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p3

    const-class p4, Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-direct {p2, p3, p4}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const/4 p3, 0x1

    const-string p4, "isedit"

    .line 165
    invoke-virtual {p2, p4, p3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    .line 166
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "onItemClick: "

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->toString()Ljava/lang/String;

    move-result-object p4

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    const-string p4, "InterPhoneMessageFragment"

    invoke-static {p4, p3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 167
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getConvType()I

    move-result p3

    const-string p4, "conver_type"

    invoke-virtual {p2, p4, p3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 168
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getConvTarget()I

    move-result p1

    const-string p3, "conver_target"

    invoke-virtual {p2, p3, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 169
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    invoke-virtual {p0, p2}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method public onItemLongClick(Landroid/widget/AdapterView;Landroid/view/View;IJ)Z
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/widget/AdapterView<",
            "*>;",
            "Landroid/view/View;",
            "IJ)Z"
        }
    .end annotation

    .line 188
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 p0, 0x0

    return p0

    .line 191
    :cond_0
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "onItemLongClick: position "

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p4, "InterPhoneMessageFragment"

    invoke-static {p4, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 194
    iput p3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->deleteIndex:I

    .line 195
    invoke-direct {p0, p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->showPopupWindow(Landroid/view/View;)V

    const/4 p0, 0x1

    return p0
.end method

.method public onItemSelected(Landroid/widget/AdapterView;Landroid/view/View;IJ)V
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

    const-string p0, "InterPhoneMessageFragment"

    const-string p1, "onItemSelected: "

    .line 275
    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onMessageDelete(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
    .locals 0

    const-string p0, "InterPhoneMessageFragment"

    const-string p1, "onMessageDelete: "

    .line 265
    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onMessageReceived()V
    .locals 2

    const-string v0, "InterPhoneMessageFragment"

    const-string v1, "onMessageReceived: "

    .line 229
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 230
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mHandler:Landroid/os/Handler;

    new-instance v1, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$1;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$1;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public onMessageSend(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
    .locals 1

    const-string p1, "InterPhoneMessageFragment"

    const-string v0, "onMessageSend: "

    .line 254
    invoke-static {p1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 255
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mHandler:Landroid/os/Handler;

    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$3;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$3;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;)V

    invoke-virtual {p1, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public onNothingSelected(Landroid/widget/AdapterView;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/widget/AdapterView<",
            "*>;)V"
        }
    .end annotation

    const-string p0, "InterPhoneMessageFragment"

    const-string p1, "onNothingSelected: "

    .line 279
    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onResume()V
    .locals 1

    .line 89
    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onResume()V

    .line 90
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->isAdded()Z

    move-result v0

    if-eqz v0, :cond_0

    const v0, 0x7f110098

    .line 91
    invoke-virtual {p0, v0}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setTitle(Ljava/lang/String;)V

    .line 93
    :cond_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->reFreshUI()V

    return-void
.end method

.method public onUnreadStatusUpdated()V
    .locals 1

    const-string p0, "InterPhoneMessageFragment"

    const-string v0, "onUnreadStatusUpdated: "

    .line 240
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public setOnItemClick(Ljava/lang/String;)V
    .locals 4

    .line 200
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_0

    return-void

    .line 203
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mPopWindow:Lcom/pri/prizeinterphone/widget/SpinerPopWindow;

    invoke-virtual {p1}, Landroid/widget/PopupWindow;->dismiss()V

    .line 204
    iget p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->deleteIndex:I

    const/4 v0, -0x1

    if-eq p1, v0, :cond_1

    .line 205
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mConversationDataList:Ljava/util/ArrayList;

    iget v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->deleteIndex:I

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/ConversationData;

    invoke-virtual {p1, v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->deleteConverList(Lcom/pri/prizeinterphone/serial/data/ConversationData;)Z

    .line 206
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mConversationDataList:Ljava/util/ArrayList;

    iget v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->deleteIndex:I

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/ConversationData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getConvType()I

    move-result v1

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->mConversationDataList:Ljava/util/ArrayList;

    iget v3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->deleteIndex:I

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/ConversationData;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getConvTarget()I

    move-result v2

    invoke-virtual {p1, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->deleteAllSms(II)Z

    const p1, 0x7f110151

    .line 207
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->showToast(I)V

    .line 209
    :cond_1
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->reFreshUI()V

    .line 210
    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->deleteIndex:I

    return-void
.end method

.method public updateView()V
    .locals 0

    .line 149
    invoke-super {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->updateView()V

    .line 150
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;->reFreshUI()V

    return-void
.end method
