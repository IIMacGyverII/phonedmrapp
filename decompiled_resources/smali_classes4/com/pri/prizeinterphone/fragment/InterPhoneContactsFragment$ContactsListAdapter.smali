.class Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;
.super Landroid/widget/BaseAdapter;
.source "InterPhoneContactsFragment.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "ContactsListAdapter"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;
    }
.end annotation


# instance fields
.field private mContext:Landroid/content/Context;

.field private mList:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/ContactData;",
            ">;"
        }
    .end annotation
.end field

.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;Landroid/content/Context;)V
    .locals 1

    .line 427
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;

    invoke-direct {p0}, Landroid/widget/BaseAdapter;-><init>()V

    const-string p1, "InterPhoneContactsFragment"

    const-string v0, "ContactsListAdapter: "

    .line 428
    invoke-static {p1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 429
    iput-object p2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->mContext:Landroid/content/Context;

    return-void
.end method


# virtual methods
.method public getCount()I
    .locals 0

    .line 434
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->mList:Ljava/util/ArrayList;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result p0

    :goto_0
    return p0
.end method

.method public getItem(I)Ljava/lang/Object;
    .locals 0

    const/4 p0, 0x0

    return-object p0
.end method

.method public getItemId(I)J
    .locals 0

    int-to-long p0, p1

    return-wide p0
.end method

.method public getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 6

    if-nez p2, :cond_0

    .line 455
    new-instance p2, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;

    invoke-direct {p2, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;)V

    .line 456
    iget-object p3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->mContext:Landroid/content/Context;

    invoke-static {p3}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p3

    const v0, 0x7f0c003b

    const/4 v1, 0x0

    .line 457
    invoke-virtual {p3, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p3

    const v0, 0x7f090082

    .line 458
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;->-$$Nest$fputmTvListName(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f090080

    .line 459
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;->-$$Nest$fputmTvListNumber(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f09007f

    .line 460
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;->-$$Nest$fputmImgIcon(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;Landroid/widget/ImageView;)V

    const v0, 0x7f090083

    .line 461
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;->-$$Nest$fputmImgListSelect(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;Landroid/widget/ImageView;)V

    const v0, 0x7f090081

    .line 462
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;->-$$Nest$fputmLine(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;Landroid/view/View;)V

    .line 463
    invoke-virtual {p3, p2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    goto :goto_0

    .line 465
    :cond_0
    invoke-virtual {p2}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;

    move-object v5, p3

    move-object p3, p2

    move-object p2, v5

    .line 471
    :goto_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->mList:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ContactData;

    .line 472
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;->-$$Nest$fgetmTvListName(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v1

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 473
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;->-$$Nest$fgetmTvListNumber(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v1

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getNumber()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 475
    iget-object v1, v0, Lcom/pri/prizeinterphone/serial/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    const/4 v2, 0x1

    if-eqz v1, :cond_1

    .line 476
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;->-$$Nest$fgetmImgIcon(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object v1

    iget-object v3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;

    invoke-virtual {v3}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;

    move-result-object v3

    iget-object v4, v0, Lcom/pri/prizeinterphone/serial/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    invoke-static {v3, v4}, Lcom/pri/prizeinterphone/widget/CircleFramedDrawable;->getInstance(Landroid/content/Context;Landroid/graphics/Bitmap;)Lcom/pri/prizeinterphone/widget/CircleFramedDrawable;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    goto :goto_1

    .line 478
    :cond_1
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;

    invoke-static {v1}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->-$$Nest$fgetmCurrentType(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;)I

    move-result v1

    if-nez v1, :cond_2

    .line 479
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;->-$$Nest$fgetmImgIcon(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object v1

    iget-object v3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;

    invoke-virtual {v3}, Landroidx/fragment/app/Fragment;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x7f080092

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    goto :goto_1

    .line 480
    :cond_2
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;

    invoke-static {v1}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->-$$Nest$fgetmCurrentType(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;)I

    move-result v1

    if-ne v1, v2, :cond_3

    .line 481
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;->-$$Nest$fgetmImgIcon(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object v1

    iget-object v3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;

    invoke-virtual {v3}, Landroidx/fragment/app/Fragment;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x7f080093

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 485
    :cond_3
    :goto_1
    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->mList:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    sub-int/2addr v1, v2

    const/16 v2, 0x8

    if-ne p1, v1, :cond_4

    .line 486
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;->-$$Nest$fgetmLine(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;)Landroid/view/View;

    move-result-object p1

    invoke-virtual {p1, v2}, Landroid/view/View;->setVisibility(I)V

    .line 489
    :cond_4
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->-$$Nest$fgetmActiveContactId(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;)I

    move-result p1

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getNumber()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1

    if-ne p1, v1, :cond_5

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->-$$Nest$fgetmActiveContactType(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;)I

    move-result p0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getType()I

    move-result p1

    if-ne p0, p1, :cond_5

    .line 490
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;->-$$Nest$fgetmImgListSelect(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object p0

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setVisibility(I)V

    goto :goto_2

    .line 492
    :cond_5
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;->-$$Nest$fgetmImgListSelect(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object p0

    invoke-virtual {p0, v2}, Landroid/widget/ImageView;->setVisibility(I)V

    :goto_2
    return-object p3
.end method

.method public setList(Ljava/util/ArrayList;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/ContactData;",
            ">;)V"
        }
    .end annotation

    .line 438
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$ContactsListAdapter;->mList:Ljava/util/ArrayList;

    return-void
.end method
