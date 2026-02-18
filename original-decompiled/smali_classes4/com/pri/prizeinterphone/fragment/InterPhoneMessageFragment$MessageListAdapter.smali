.class Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;
.super Landroid/widget/BaseAdapter;
.source "InterPhoneMessageFragment.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "MessageListAdapter"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;
    }
.end annotation


# instance fields
.field private mContext:Landroid/content/Context;

.field private mDeleteItemIndex:I

.field private mList:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/ConversationData;",
            ">;"
        }
    .end annotation
.end field

.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;Landroid/content/Context;Ljava/util/ArrayList;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/ConversationData;",
            ">;)V"
        }
    .end annotation

    .line 287
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment;

    invoke-direct {p0}, Landroid/widget/BaseAdapter;-><init>()V

    const/4 p1, 0x0

    .line 285
    iput p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;->mDeleteItemIndex:I

    .line 288
    iput-object p2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;->mContext:Landroid/content/Context;

    .line 289
    iput-object p3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;->mList:Ljava/util/ArrayList;

    return-void
.end method


# virtual methods
.method public getCount()I
    .locals 0

    .line 300
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;->mList:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result p0

    return p0
.end method

.method public getDeleteItemIndex()I
    .locals 0

    .line 292
    iget p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;->mDeleteItemIndex:I

    return p0
.end method

.method public getItem(I)Ljava/lang/Object;
    .locals 0

    const/4 p0, 0x0

    return-object p0
.end method

.method public getItemId(I)J
    .locals 0

    const-wide/16 p0, 0x0

    return-wide p0
.end method

.method public getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 3

    .line 319
    new-instance p3, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;

    invoke-direct {p3, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;)V

    .line 320
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;->mContext:Landroid/content/Context;

    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    if-nez p2, :cond_0

    const p2, 0x7f0c004a

    const/4 v1, 0x0

    .line 322
    invoke-virtual {v0, p2, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p2

    const v0, 0x7f0901c6

    .line 323
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/LinearLayout;

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fputmItemview(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;Landroid/widget/LinearLayout;)V

    const v0, 0x7f0901c3

    .line 324
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fputmTvListName(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f0901c0

    .line 325
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fputmTvListContent(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f0901c5

    .line 326
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fputmTvListUnread(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f0901c4

    .line 327
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fputmTvListTime(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f0901c1

    .line 328
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fputmImgIcon(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;Landroid/widget/ImageView;)V

    const v0, 0x7f0901c2

    .line 329
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fputmLine(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;Landroid/view/View;)V

    .line 330
    invoke-virtual {p2, p3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    .line 333
    :cond_0
    invoke-virtual {p2}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;

    .line 336
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;->mList:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/ConversationData;

    .line 337
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getView: conver "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "InterPhoneMessageFragment"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 338
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getUnReadCount()I

    move-result v0

    if-lez v0, :cond_2

    .line 339
    invoke-static {p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvListUnread(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 340
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getUnReadCount()I

    move-result v0

    const/16 v1, 0x63

    if-le v0, v1, :cond_1

    .line 341
    invoke-static {p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvListUnread(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v0

    const-string v1, "99+"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    .line 343
    :cond_1
    invoke-static {p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvListUnread(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getUnReadCount()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    .line 346
    :cond_2
    invoke-static {p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvListUnread(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v0

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 349
    :goto_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getConvType()I

    move-result v1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getConvTarget()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->getLastSms(II)Lcom/pri/prizeinterphone/serial/data/MessageData;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 351
    invoke-static {p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvListContent(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v1

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getContent()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 354
    :cond_3
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getConvType()I

    move-result v0

    if-nez v0, :cond_4

    .line 355
    invoke-static {p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fgetmImgIcon(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object v0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;->mContext:Landroid/content/Context;

    const v1, 0x7f0800a3

    invoke-virtual {p0, v1}, Landroid/content/Context;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    goto :goto_1

    .line 357
    :cond_4
    invoke-static {p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fgetmImgIcon(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object v0

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;->mContext:Landroid/content/Context;

    const v1, 0x7f08009f

    invoke-virtual {p0, v1}, Landroid/content/Context;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 359
    :goto_1
    invoke-static {p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvListName(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object p0

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 360
    new-instance p0, Ljava/text/SimpleDateFormat;

    const-string/jumbo v0, "yyyy.MM.dd HH:mm:ss"

    invoke-direct {p0, v0}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    .line 361
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getTimestamp()Ljava/lang/Long;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/text/SimpleDateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    .line 362
    invoke-static {p3}, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvListTime(Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object p1

    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-object p2
.end method

.method public setDeleteItemIndex(I)V
    .locals 0

    .line 295
    iput p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;->mDeleteItemIndex:I

    return-void
.end method

.method public setList(Ljava/util/ArrayList;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/ConversationData;",
            ">;)V"
        }
    .end annotation

    .line 304
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneMessageFragment$MessageListAdapter;->mList:Ljava/util/ArrayList;

    return-void
.end method
