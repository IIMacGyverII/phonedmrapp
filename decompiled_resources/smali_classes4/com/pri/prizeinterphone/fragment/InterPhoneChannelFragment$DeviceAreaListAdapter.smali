.class Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;
.super Landroid/widget/BaseAdapter;
.source "InterPhoneChannelFragment.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "DeviceAreaListAdapter"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;
    }
.end annotation


# instance fields
.field private mContext:Landroid/content/Context;

.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;Landroid/content/Context;)V
    .locals 0

    .line 181
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-direct {p0}, Landroid/widget/BaseAdapter;-><init>()V

    .line 182
    iput-object p2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;->mContext:Landroid/content/Context;

    return-void
.end method


# virtual methods
.method public getCount()I
    .locals 0

    .line 187
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->size()I

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

.method public getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 5

    if-nez p2, :cond_0

    .line 204
    new-instance p2, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;

    invoke-direct {p2, p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;-><init>(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;)V

    .line 205
    iget-object p3, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;->mContext:Landroid/content/Context;

    invoke-static {p3}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p3

    const v0, 0x7f0c003f

    const/4 v1, 0x0

    .line 206
    invoke-virtual {p3, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p3

    const v0, 0x7f09009e

    .line 207
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fputmTvListTitle(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f09009f

    .line 208
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fputmTvListTX(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f09009d

    .line 209
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fputmTvListRX(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f090177

    .line 210
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fputmImgListSelect(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;Landroid/widget/ImageView;)V

    .line 211
    invoke-virtual {p3, p2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    goto :goto_0

    .line 213
    :cond_0
    invoke-virtual {p2}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;

    move-object v4, p3

    move-object p3, p2

    move-object p2, v4

    .line 218
    :goto_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object v0, v0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v0, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object v0, v0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v0, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_1

    .line 225
    :cond_1
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fgetmTvListTitle(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object v1, v1, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-interface {v1, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget-object v1, v1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->name:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_2

    .line 219
    :cond_2
    :goto_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object v0, v0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v0, v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;->type:I

    if-nez v0, :cond_3

    .line 220
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fgetmTvListTitle(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v2

    const v3, 0x7f1100f9

    invoke-virtual {v2, v3}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object v2, v2, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-interface {v2, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v2, v2, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_2

    .line 222
    :cond_3
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fgetmTvListTitle(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v2

    const v3, 0x7f1100f7

    invoke-virtual {v2, v3}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object v2, v2, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-interface {v2, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v2, v2, Lcom/pri/prizeinterphone/serial/data/ChannelData;->number:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 227
    :goto_2
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fgetmTvListTX(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "tx: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object v2, v2, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-interface {v2, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v2, v2, Lcom/pri/prizeinterphone/serial/data/ChannelData;->txFreq:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 228
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fgetmTvListRX(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "rx: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object v2, v2, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-interface {v2, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v2, v2, Lcom/pri/prizeinterphone/serial/data/ChannelData;->rxFreq:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 230
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetmCurrentSelected(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)I

    move-result p0

    if-ne p0, p1, :cond_4

    .line 231
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fgetmImgListSelect(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object p0

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setVisibility(I)V

    goto :goto_3

    .line 233
    :cond_4
    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fgetmImgListSelect(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$DeviceAreaListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object p0

    const/16 p1, 0x8

    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setVisibility(I)V

    :goto_3
    return-object p3
.end method
