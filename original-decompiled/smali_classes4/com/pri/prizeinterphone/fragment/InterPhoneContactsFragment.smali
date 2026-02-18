.class public Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;
.super Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;
.source "InterPhoneContactsFragment.java"

# interfaces
.implements Landroid/view/View$OnClickListener;
.implements Landroid/widget/AdapterView$OnItemClickListener;
.implements Lcom/pri/prizeinterphone/manager/ContactLisenter;
.implements Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;
    }
.end annotation


# static fields
.field private static final REQUEST_CREATE_CONTACT:I = 0x3ec


# instance fields
.field private final TAG:Ljava/lang/String;

.field private isNoGroup:Z

.field private isNoPeople:Z

.field private mActiveContactId:I

.field private mActiveContactType:I

.field private mCurrentClick:I

.field private mCurrentSeleted:I

.field private mCurrentSeletedId:I

.field private mCurrentSeletedType:I

.field private mCurrentType:I

.field private mDialog:Landroid/app/Dialog;

.field private mFragmentManager:Landroidx/fragment/app/FragmentManager;

.field private mGroupAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;

.field private mGroupList:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/ContactData;",
            ">;"
        }
    .end annotation
.end field

.field private mGroupListView:Landroid/widget/ListView;

.field private mLinContactsNoPeople:Landroid/widget/LinearLayout;

.field private mLocalView:Landroid/view/View;

.field private mPeopleAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;

.field private mPeopleDB:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

.field private mPeopleList:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/ContactData;",
            ">;"
        }
    .end annotation
.end field

.field private mPeopleListView:Landroid/widget/ListView;

.field private mRelContactsGroup:Landroid/view/View;

.field private mRelContactsPeople:Landroid/view/View;

.field private mToast:Landroid/widget/Toast;

.field private mTvContactsCreate:Landroid/widget/TextView;

.field private mTvContactsNoPeople:Landroid/widget/TextView;

.field private mUpdateChannelListRunnable:Ljava/lang/Runnable;


# direct methods
.method static bridge synthetic -$$Nest$fgetmActiveContactId(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;)I
    .locals 0

    iget p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mActiveContactId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmActiveContactType(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;)I
    .locals 0

    iget p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mActiveContactType:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmCurrentType(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;)I
    .locals 0

    iget p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentType:I

    return p0
.end method

.method static bridge synthetic -$$Nest$minitData(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->initData()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mrefreshUI(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->refreshUI(I)V

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 77
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;-><init>()V

    const-string v0, "InterPhoneContactsFragment"

    .line 44
    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->TAG:Ljava/lang/String;

    const/4 v0, 0x0

    .line 55
    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentType:I

    const/4 v0, -0x1

    .line 66
    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentSeleted:I

    .line 403
    new-instance v0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$1;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$1;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mUpdateChannelListRunnable:Ljava/lang/Runnable;

    return-void
.end method

.method private createActivity(ILcom/pri/prizeinterphone/serial/data/ContactData;)V
    .locals 4

    .line 257
    new-instance v0, Landroid/content/Intent;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v1

    const-class v2, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 258
    iget v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentType:I

    const-string v2, "contact_type"

    const/4 v3, 0x1

    if-nez v1, :cond_0

    const/4 p1, 0x0

    .line 259
    invoke-virtual {v0, v2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    goto :goto_0

    :cond_0
    if-ne p1, v3, :cond_1

    .line 261
    invoke-virtual {v0, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    :cond_1
    :goto_0
    if-eqz p2, :cond_2

    .line 264
    invoke-virtual {p2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getId()I

    move-result p1

    const-string p2, "_id"

    invoke-virtual {v0, p2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const-string p1, "isedit"

    .line 265
    invoke-virtual {v0, p1, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    :cond_2
    const/16 p1, 0x3ec

    .line 267
    invoke-virtual {p0, v0, p1}, Landroidx/fragment/app/Fragment;->startActivityForResult(Landroid/content/Intent;I)V

    return-void
.end method

.method private deleteData()V
    .locals 1

    .line 221
    iget v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentType:I

    if-nez v0, :cond_0

    .line 222
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleList:Ljava/util/ArrayList;

    iget p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentClick:I

    invoke-virtual {v0, p0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/pri/prizeinterphone/serial/data/ContactData;

    goto :goto_0

    .line 224
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupList:Ljava/util/ArrayList;

    iget p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentClick:I

    invoke-virtual {v0, p0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/pri/prizeinterphone/serial/data/ContactData;

    .line 226
    :goto_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->deleteContact(Lcom/pri/prizeinterphone/serial/data/ContactData;)Z

    return-void
.end method

.method private dismissDialog()V
    .locals 1

    .line 379
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mDialog:Landroid/app/Dialog;

    if-eqz v0, :cond_0

    .line 380
    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    const/4 v0, 0x0

    .line 381
    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mDialog:Landroid/app/Dialog;

    :cond_0
    return-void
.end method

.method private initData()V
    .locals 5

    const-string v0, "InterPhoneContactsFragment"

    .line 118
    :try_start_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxContact()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mActiveContactId:I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 124
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getContactType()I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mActiveContactType:I

    .line 126
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->getAllContacts(I)Ljava/util/ArrayList;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleList:Ljava/util/ArrayList;

    .line 127
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "initData().mPeopleList.size()="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleList:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 128
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;

    iget-object v3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleList:Ljava/util/ArrayList;

    invoke-virtual {v1, v3}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->setList(Ljava/util/ArrayList;)V

    .line 130
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleList:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    const/4 v3, 0x1

    if-lez v1, :cond_0

    .line 131
    iput-boolean v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->isNoPeople:Z

    goto :goto_0

    .line 133
    :cond_0
    iput-boolean v3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->isNoPeople:Z

    .line 135
    :goto_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    invoke-virtual {v1, v3}, Lcom/pri/prizeinterphone/manager/DmrManager;->getAllContacts(I)Ljava/util/ArrayList;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupList:Ljava/util/ArrayList;

    .line 136
    iget-object v4, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;

    invoke-virtual {v4, v1}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->setList(Ljava/util/ArrayList;)V

    .line 137
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "initData().mGroupList.size()="

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupList:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 139
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupList:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-lez v0, :cond_1

    .line 140
    iput-boolean v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->isNoGroup:Z

    goto :goto_1

    .line 142
    :cond_1
    iput-boolean v3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->isNoGroup:Z

    .line 144
    :goto_1
    iget v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentType:I

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->refreshUI(I)V

    return-void

    :catch_0
    move-exception p0

    const-string v1, "initData,not call DmrManager.initChannelData() or faster than call DmrManager.initChannelData(),so InitChannelDataDB is null"

    .line 120
    invoke-static {v0, v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method private isTalkSend()Z
    .locals 3

    .line 523
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

    .line 525
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->showToast(I)V

    :cond_1
    return v2
.end method

.method private refreshList()V
    .locals 1

    .line 246
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;

    if-eqz v0, :cond_0

    .line 247
    invoke-virtual {v0}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    .line 249
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;

    if-eqz p0, :cond_1

    .line 250
    invoke-virtual {p0}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    :cond_1
    return-void
.end method

.method private refreshUI(I)V
    .locals 3

    .line 272
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->isAdded()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 275
    :cond_0
    iput p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentType:I

    .line 276
    iput p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentSeletedType:I

    const/4 v0, 0x1

    const/16 v1, 0x8

    const/4 v2, 0x0

    if-nez p1, :cond_2

    .line 278
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mRelContactsPeople:Landroid/view/View;

    invoke-virtual {p1, v0}, Landroid/view/View;->setSelected(Z)V

    .line 279
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mRelContactsGroup:Landroid/view/View;

    invoke-virtual {p1, v2}, Landroid/view/View;->setSelected(Z)V

    .line 280
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->isNoPeople:Z

    if-eqz p1, :cond_1

    .line 281
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mLinContactsNoPeople:Landroid/widget/LinearLayout;

    invoke-virtual {p1, v2}, Landroid/widget/LinearLayout;->setVisibility(I)V

    .line 282
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mTvContactsNoPeople:Landroid/widget/TextView;

    const v0, 0x7f110050

    invoke-virtual {p0, v0}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 283
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mTvContactsCreate:Landroid/widget/TextView;

    const v0, 0x7f11004c

    invoke-virtual {p0, v0}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    .line 285
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mLinContactsNoPeople:Landroid/widget/LinearLayout;

    invoke-virtual {p1, v1}, Landroid/widget/LinearLayout;->setVisibility(I)V

    .line 287
    :goto_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleListView:Landroid/widget/ListView;

    invoke-virtual {p1, v2}, Landroid/widget/ListView;->setVisibility(I)V

    .line 288
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupListView:Landroid/widget/ListView;

    invoke-virtual {p1, v1}, Landroid/widget/ListView;->setVisibility(I)V

    goto :goto_2

    :cond_2
    if-ne p1, v0, :cond_4

    .line 290
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mRelContactsPeople:Landroid/view/View;

    invoke-virtual {p1, v2}, Landroid/view/View;->setSelected(Z)V

    .line 291
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mRelContactsGroup:Landroid/view/View;

    invoke-virtual {p1, v0}, Landroid/view/View;->setSelected(Z)V

    .line 292
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->isNoGroup:Z

    if-eqz p1, :cond_3

    .line 293
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mLinContactsNoPeople:Landroid/widget/LinearLayout;

    invoke-virtual {p1, v2}, Landroid/widget/LinearLayout;->setVisibility(I)V

    .line 294
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mTvContactsNoPeople:Landroid/widget/TextView;

    const v0, 0x7f11004f

    invoke-virtual {p0, v0}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 295
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mTvContactsCreate:Landroid/widget/TextView;

    const v0, 0x7f11004d

    invoke-virtual {p0, v0}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_1

    .line 297
    :cond_3
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mLinContactsNoPeople:Landroid/widget/LinearLayout;

    invoke-virtual {p1, v1}, Landroid/widget/LinearLayout;->setVisibility(I)V

    .line 299
    :goto_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleListView:Landroid/widget/ListView;

    invoke-virtual {p1, v1}, Landroid/widget/ListView;->setVisibility(I)V

    .line 300
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupListView:Landroid/widget/ListView;

    invoke-virtual {p1, v2}, Landroid/widget/ListView;->setVisibility(I)V

    .line 303
    :cond_4
    :goto_2
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->refreshList()V

    return-void
.end method

.method private saveSelectedData()V
    .locals 3

    .line 230
    iget v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentClick:I

    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentSeleted:I

    .line 231
    iget v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentType:I

    if-nez v1, :cond_0

    .line 232
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleList:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getNumber()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentSeletedId:I

    goto :goto_0

    :cond_0
    const/4 v2, 0x1

    if-ne v1, v2, :cond_1

    .line 234
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupList:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getNumber()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentSeletedId:I

    .line 236
    :cond_1
    :goto_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 238
    iget v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentSeletedId:I

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setTxContact(I)V

    .line 239
    iget v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentType:I

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->setContactType(I)V

    .line 241
    :cond_2
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 242
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->initData()V

    return-void
.end method

.method private setDialogWindowLayoutParams(Landroid/app/Dialog;)V
    .locals 2

    .line 366
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    .line 367
    iget p0, p0, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 369
    invoke-virtual {p1}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    .line 370
    invoke-virtual {p1}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    const/16 v1, 0x50

    .line 371
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->gravity:I

    const/16 v1, 0x3c

    .line 372
    iput v1, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float p0, p0

    const v1, 0x3f666666    # 0.9f

    mul-float/2addr p0, v1

    float-to-int p0, p0

    .line 373
    iput p0, v0, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 374
    invoke-virtual {p1, v0}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    const p0, 0x106000d

    .line 375
    invoke-virtual {p1, p0}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    return-void
.end method

.method private showDialog()V
    .locals 3

    .line 331
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const v1, 0x7f0c003c

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    const v1, 0x7f090084

    .line 332
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    .line 333
    invoke-virtual {v1, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 334
    new-instance v1, Landroid/app/Dialog;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mDialog:Landroid/app/Dialog;

    .line 335
    invoke-virtual {v1, v0}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 336
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mDialog:Landroid/app/Dialog;

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->setDialogWindowLayoutParams(Landroid/app/Dialog;)V

    .line 337
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mDialog:Landroid/app/Dialog;

    invoke-virtual {p0}, Landroid/app/Dialog;->show()V

    return-void
.end method

.method private showEditActivity()V
    .locals 2

    .line 211
    iget v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentType:I

    if-nez v0, :cond_0

    .line 212
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleList:Ljava/util/ArrayList;

    iget v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentClick:I

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ContactData;

    goto :goto_0

    :cond_0
    const/4 v1, 0x1

    if-ne v0, v1, :cond_1

    .line 214
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupList:Ljava/util/ArrayList;

    iget v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentClick:I

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ContactData;

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    .line 216
    :goto_0
    iget v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentType:I

    invoke-direct {p0, v1, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->createActivity(ILcom/pri/prizeinterphone/serial/data/ContactData;)V

    return-void
.end method

.method private showEditDialog(I)V
    .locals 2

    .line 343
    iput p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentClick:I

    .line 344
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p1

    invoke-static {p1}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p1

    const v0, 0x7f0c003a

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p1

    const v0, 0x7f09007d

    .line 345
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    .line 346
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f09007c

    .line 347
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    .line 348
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const v0, 0x7f09007b

    .line 349
    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    .line 350
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 351
    new-instance v0, Landroid/app/Dialog;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mDialog:Landroid/app/Dialog;

    .line 352
    invoke-virtual {v0, p1}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 353
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mDialog:Landroid/app/Dialog;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->setDialogWindowLayoutParams(Landroid/app/Dialog;)V

    .line 354
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mDialog:Landroid/app/Dialog;

    invoke-virtual {p0}, Landroid/app/Dialog;->show()V

    return-void
.end method

.method private showToast(I)V
    .locals 2

    .line 515
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mToast:Landroid/widget/Toast;

    if-eqz v0, :cond_0

    .line 516
    invoke-virtual {v0}, Landroid/widget/Toast;->cancel()V

    .line 518
    :cond_0
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;II)Landroid/widget/Toast;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mToast:Landroid/widget/Toast;

    .line 519
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method


# virtual methods
.method public doAddAction()V
    .locals 2

    .line 150
    invoke-super {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->doAddAction()V

    .line 151
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 154
    :cond_0
    iget v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentType:I

    const/4 v1, 0x0

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->createActivity(ILcom/pri/prizeinterphone/serial/data/ContactData;)V

    return-void
.end method

.method public getMyTag()Ljava/lang/String;
    .locals 0

    const-string p0, "InterPhoneContactsFragment"

    return-object p0
.end method

.method public initView(Landroid/view/View;)V
    .locals 2

    .line 82
    invoke-super {p0, p1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->initView(Landroid/view/View;)V

    .line 83
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p1

    const v0, 0x7f0c003d

    const/4 v1, 0x0

    .line 84
    invoke-virtual {p1, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mLocalView:Landroid/view/View;

    .line 85
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mFragmentContainer:Landroid/widget/FrameLayout;

    invoke-virtual {v0, p1}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;)V

    const p1, 0x7f08008c

    .line 86
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setAddButton(I)V

    .line 88
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900d1

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mRelContactsPeople:Landroid/view/View;

    .line 89
    invoke-virtual {p1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 90
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900cd

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mRelContactsGroup:Landroid/view/View;

    .line 91
    invoke-virtual {p1, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 93
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900cf

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/LinearLayout;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mLinContactsNoPeople:Landroid/widget/LinearLayout;

    .line 94
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900ce

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mTvContactsNoPeople:Landroid/widget/TextView;

    .line 95
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900cb

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mTvContactsCreate:Landroid/widget/TextView;

    .line 96
    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 98
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900d0

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ListView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleListView:Landroid/widget/ListView;

    .line 99
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mLocalView:Landroid/view/View;

    const v0, 0x7f0900cc

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ListView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupListView:Landroid/widget/ListView;

    .line 102
    new-instance p1, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-direct {p1, p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;Landroid/content/Context;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;

    .line 103
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleListView:Landroid/widget/ListView;

    invoke-virtual {v0, p1}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    .line 104
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleListView:Landroid/widget/ListView;

    invoke-virtual {p1, p0}, Landroid/widget/ListView;->setOnItemClickListener(Landroid/widget/AdapterView$OnItemClickListener;)V

    .line 106
    new-instance p1, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-direct {p1, p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;Landroid/content/Context;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupAdapter:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;

    .line 107
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupListView:Landroid/widget/ListView;

    invoke-virtual {v0, p1}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    .line 108
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupListView:Landroid/widget/ListView;

    invoke-virtual {p1, p0}, Landroid/widget/ListView;->setOnItemClickListener(Landroid/widget/AdapterView$OnItemClickListener;)V

    .line 110
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->addContactListener(Lcom/pri/prizeinterphone/manager/ContactLisenter;)V

    .line 111
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerUpdateListener(Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;)V

    .line 112
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->initData()V

    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 1

    .line 177
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->isTalkSend()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 180
    :cond_0
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    sparse-switch p1, :sswitch_data_0

    goto :goto_0

    :sswitch_0
    const/4 p1, 0x0

    .line 182
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->refreshUI(I)V

    goto :goto_0

    :sswitch_1
    const/4 p1, 0x1

    .line 185
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->refreshUI(I)V

    goto :goto_0

    .line 188
    :sswitch_2
    iget p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentType:I

    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->createActivity(ILcom/pri/prizeinterphone/serial/data/ContactData;)V

    goto :goto_0

    .line 204
    :sswitch_3
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->dismissDialog()V

    goto :goto_0

    .line 191
    :sswitch_4
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->saveSelectedData()V

    .line 192
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->refreshList()V

    .line 193
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->dismissDialog()V

    goto :goto_0

    .line 196
    :sswitch_5
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->showEditActivity()V

    .line 197
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->dismissDialog()V

    goto :goto_0

    .line 200
    :sswitch_6
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->deleteData()V

    .line 201
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->dismissDialog()V

    :goto_0
    return-void

    :sswitch_data_0
    .sparse-switch
        0x7f09007b -> :sswitch_6
        0x7f09007c -> :sswitch_5
        0x7f09007d -> :sswitch_4
        0x7f090084 -> :sswitch_3
        0x7f0900cb -> :sswitch_2
        0x7f0900cd -> :sswitch_1
        0x7f0900d1 -> :sswitch_0
    .end sparse-switch
.end method

.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 0
    .param p1    # Landroid/content/res/Configuration;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 359
    invoke-super {p0, p1}, Landroidx/fragment/app/Fragment;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 360
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mDialog:Landroid/app/Dialog;

    if-eqz p1, :cond_0

    invoke-virtual {p1}, Landroid/app/Dialog;->isShowing()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 361
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mDialog:Landroid/app/Dialog;

    invoke-virtual {p0}, Landroid/app/Dialog;->dismiss()V

    :cond_0
    return-void
.end method

.method public onContactAdded(Lcom/pri/prizeinterphone/serial/data/ContactData;)V
    .locals 1

    const-string p1, "InterPhoneContactsFragment"

    const-string v0, "onContactAdded: "

    .line 387
    invoke-static {p1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 388
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->initData()V

    return-void
.end method

.method public onContactRemoved(Lcom/pri/prizeinterphone/serial/data/ContactData;)V
    .locals 1

    const-string p1, "InterPhoneContactsFragment"

    const-string v0, "onContactRemoved: "

    .line 393
    invoke-static {p1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 394
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->initData()V

    return-void
.end method

.method public onContactUpdated(Lcom/pri/prizeinterphone/serial/data/ContactData;)V
    .locals 1

    const-string p1, "InterPhoneContactsFragment"

    const-string v0, "onContactUpdated: "

    .line 399
    invoke-static {p1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 400
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->initData()V

    return-void
.end method

.method public onDestroy()V
    .locals 1

    .line 509
    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onDestroy()V

    .line 510
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

    .line 309
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->isTalkSend()Z

    move-result p1

    if-eqz p1, :cond_0

    return-void

    .line 312
    :cond_0
    iget p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mCurrentType:I

    if-nez p1, :cond_2

    .line 313
    iget p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mActiveContactId:I

    iget-object p2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleList:Ljava/util/ArrayList;

    invoke-virtual {p2, p3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {p2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getNumber()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p2

    if-ne p1, p2, :cond_1

    iget p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mActiveContactType:I

    iget-object p2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mPeopleList:Ljava/util/ArrayList;

    .line 314
    invoke-virtual {p2, p3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {p2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getType()I

    move-result p2

    if-ne p1, p2, :cond_1

    .line 315
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->showDialog()V

    goto :goto_0

    .line 317
    :cond_1
    invoke-direct {p0, p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->showEditDialog(I)V

    goto :goto_0

    :cond_2
    const/4 p2, 0x1

    if-ne p1, p2, :cond_4

    .line 320
    iget p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mActiveContactId:I

    iget-object p2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupList:Ljava/util/ArrayList;

    invoke-virtual {p2, p3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {p2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getNumber()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p2

    if-ne p1, p2, :cond_3

    iget p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mActiveContactType:I

    iget-object p2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mGroupList:Ljava/util/ArrayList;

    .line 321
    invoke-virtual {p2, p3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/pri/prizeinterphone/serial/data/ContactData;

    invoke-virtual {p2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getType()I

    move-result p2

    if-ne p1, p2, :cond_3

    .line 322
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->showDialog()V

    goto :goto_0

    .line 324
    :cond_3
    invoke-direct {p0, p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->showEditDialog(I)V

    :cond_4
    :goto_0
    return-void
.end method

.method public onResume()V
    .locals 2

    .line 159
    invoke-super {p0}, Landroidx/fragment/app/Fragment;->onResume()V

    const-string v0, "InterPhoneContactsFragment"

    const-string v1, "onResume"

    .line 160
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 161
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->isAdded()Z

    move-result v0

    if-eqz v0, :cond_0

    const v0, 0x7f110096

    .line 162
    invoke-virtual {p0, v0}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->setTitle(Ljava/lang/String;)V

    .line 164
    :cond_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->initData()V

    return-void
.end method

.method public updateModuleInit()V
    .locals 1

    const-string p0, "InterPhoneContactsFragment"

    const-string/jumbo v0, "updateModuleInit: "

    .line 419
    invoke-static {p0, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public updateTalkBackChannelList()V
    .locals 1

    .line 414
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->mHandler:Landroid/os/Handler;

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->mUpdateChannelListRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, p0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public updateView()V
    .locals 0

    .line 170
    invoke-super {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->updateView()V

    return-void
.end method
