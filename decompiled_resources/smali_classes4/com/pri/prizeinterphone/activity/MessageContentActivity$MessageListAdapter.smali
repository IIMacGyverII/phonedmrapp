.class Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;
.super Landroid/widget/BaseAdapter;
.source "MessageContentActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/activity/MessageContentActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "MessageListAdapter"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;
    }
.end annotation


# instance fields
.field private final VIEWTYPE_RECEIVE:I

.field private final VIEWTYPE_SEND:I

.field private mContext:Landroid/content/Context;

.field private mLastTime:Ljava/lang/String;

.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity;Landroid/content/Context;)V
    .locals 0

    .line 358
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-direct {p0}, Landroid/widget/BaseAdapter;-><init>()V

    const/4 p1, 0x0

    .line 433
    iput p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->VIEWTYPE_RECEIVE:I

    const/4 p1, 0x1

    .line 434
    iput p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->VIEWTYPE_SEND:I

    .line 359
    iput-object p2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->mContext:Landroid/content/Context;

    return-void
.end method


# virtual methods
.method public getCount()I
    .locals 0

    .line 364
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$fgetmMessageListData(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Ljava/util/ArrayList;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result p0

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

.method public getItemViewType(I)I
    .locals 0

    .line 438
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$fgetmMessageListData(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Ljava/util/ArrayList;

    move-result-object p0

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getDirection()I

    move-result p0

    const/4 p1, 0x1

    if-ne p0, p1, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    return p1
.end method

.method public getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 7

    .line 379
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "position = "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "getView: "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$fgetmMessageListData(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Ljava/util/ArrayList;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/MessageData;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    const-string v0, "InterPhoneMessageActivity"

    invoke-static {v0, p3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 380
    iget-object p3, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->mContext:Landroid/content/Context;

    invoke-static {p3}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p3

    .line 382
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->getItemViewType(I)I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-eqz v0, :cond_1

    if-eq v0, v2, :cond_0

    goto :goto_0

    :cond_0
    if-nez p2, :cond_2

    const p2, 0x7f0c0057

    .line 396
    invoke-virtual {p3, p2, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p2

    .line 397
    new-instance p3, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;

    invoke-direct {p3, p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;-><init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;)V

    const v0, 0x7f09014c

    .line 398
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fputmTvListTime(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f09014d

    .line 399
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fputmTvValues(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f09014b

    .line 400
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fputmImgIcon(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;Landroid/widget/ImageView;)V

    .line 401
    invoke-virtual {p2, p3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    goto :goto_0

    :cond_1
    if-nez p2, :cond_2

    const p2, 0x7f0c0056

    .line 385
    invoke-virtual {p3, p2, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p2

    .line 386
    new-instance p3, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;

    invoke-direct {p3, p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;-><init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;)V

    const v0, 0x7f090148

    .line 387
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fputmTvName(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f090149

    .line 388
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fputmTvListTime(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f09014a

    .line 389
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fputmTvValues(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f090147

    .line 390
    invoke-virtual {p2, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    invoke-static {p3, v0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fputmImgIcon(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;Landroid/widget/ImageView;)V

    .line 391
    invoke-virtual {p2, p3}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    .line 405
    :cond_2
    :goto_0
    invoke-virtual {p2}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;

    const-string v0, ""

    if-lez p1, :cond_4

    .line 407
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {v3}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$fgetmMessageListData(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Ljava/util/ArrayList;

    move-result-object v3

    add-int/lit8 v4, p1, -0x1

    invoke-virtual {v3, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getTimestamp()J

    move-result-wide v3

    invoke-virtual {v1, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->mLastTime:Ljava/lang/String;

    .line 408
    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {v5}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$fgetmMessageListData(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Ljava/util/ArrayList;

    move-result-object v5

    invoke-virtual {v5, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v5}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getTimestamp()J

    move-result-wide v5

    invoke-virtual {v4, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v1, v4}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->isInThreeMins(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_3

    .line 409
    invoke-static {p3}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvListTime(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v1

    const/16 v3, 0x8

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setVisibility(I)V

    goto :goto_1

    .line 411
    :cond_3
    invoke-static {p3}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvListTime(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v1

    const/4 v3, 0x0

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setVisibility(I)V

    .line 414
    :cond_4
    :goto_1
    invoke-static {p3}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvListTime(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v1

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v5, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {v5}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$fgetmMessageListData(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Ljava/util/ArrayList;

    move-result-object v5

    invoke-virtual {v5, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v5}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getTimestamp()J

    move-result-wide v5

    invoke-virtual {v4, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->formatTime(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 415
    invoke-static {p3}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvValues(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v1

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {v3}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$fgetmMessageListData(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Ljava/util/ArrayList;

    move-result-object v3

    invoke-virtual {v3, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getContent()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 416
    invoke-static {p3}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvValues(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v1

    new-instance v3, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$1;

    invoke-direct {v3, p0, p1}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$1;-><init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;I)V

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 422
    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {v1}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$fgetmMessageListData(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Ljava/util/ArrayList;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getDirection()I

    move-result v1

    if-ne v1, v2, :cond_6

    .line 423
    invoke-static {p3}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvName(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v1

    if-eqz v1, :cond_5

    .line 424
    invoke-static {p3}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fgetmTvName(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {v3}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$fgetmMessageListData(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Ljava/util/ArrayList;

    move-result-object v3

    invoke-virtual {v3, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getFrom()I

    move-result p1

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 426
    :cond_5
    invoke-static {p3}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fgetmImgIcon(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object p1

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$fgetmRecieveIconDrawable(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    goto :goto_2

    .line 428
    :cond_6
    invoke-static {p3}, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;->-$$Nest$fgetmImgIcon(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object p1

    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$fgetmSendIconDrawable(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    :goto_2
    return-object p2
.end method

.method public getViewTypeCount()I
    .locals 0

    const/4 p0, 0x2

    return p0
.end method
