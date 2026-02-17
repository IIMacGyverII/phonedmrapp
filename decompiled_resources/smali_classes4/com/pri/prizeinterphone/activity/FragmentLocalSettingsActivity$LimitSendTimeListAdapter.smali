.class Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;
.super Landroid/widget/BaseAdapter;
.source "FragmentLocalSettingsActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "LimitSendTimeListAdapter"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;
    }
.end annotation


# instance fields
.field private mContext:Landroid/content/Context;

.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;Landroid/content/Context;)V
    .locals 0

    .line 507
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-direct {p0}, Landroid/widget/BaseAdapter;-><init>()V

    .line 508
    iput-object p2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;->mContext:Landroid/content/Context;

    return-void
.end method


# virtual methods
.method public getCount()I
    .locals 0

    .line 513
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$fgetmLimitSendTimeList(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)Ljava/util/ArrayList;

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

.method public getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 4

    if-nez p2, :cond_0

    .line 530
    new-instance p2, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;

    invoke-direct {p2, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;)V

    .line 531
    iget-object p3, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;->mContext:Landroid/content/Context;

    invoke-static {p3}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p3

    const v0, 0x7f0c005e

    const/4 v1, 0x0

    .line 532
    invoke-virtual {p3, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p3

    const v0, 0x7f090164

    .line 533
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;->-$$Nest$fputmTvTile(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f090163

    .line 534
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;->-$$Nest$fputmSeleted(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;Landroid/widget/ImageView;)V

    const v0, 0x7f090162

    .line 535
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;->-$$Nest$fputmLine(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;Landroid/view/View;)V

    .line 536
    invoke-virtual {p3, p2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    goto :goto_0

    .line 538
    :cond_0
    invoke-virtual {p2}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;

    move-object v3, p3

    move-object p3, p2

    move-object p2, v3

    .line 541
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getView  position = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "FragmentLocalSettingsActivity"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 542
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "getView  mDataList = "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-static {v2}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$fgetmLimitSendTimeList(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)Ljava/util/ArrayList;

    move-result-object v2

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 543
    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;->-$$Nest$fgetmTvTile(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-static {v1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$fgetmLimitSendTimeList(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)Ljava/util/ArrayList;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/CharSequence;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 544
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$fgetmCurrentCheckItem(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)I

    move-result v0

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-ne v0, p1, :cond_1

    .line 545
    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;->-$$Nest$fgetmSeleted(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setSelected(Z)V

    goto :goto_1

    .line 547
    :cond_1
    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;->-$$Nest$fgetmSeleted(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/widget/ImageView;->setSelected(Z)V

    .line 549
    :goto_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$fgetmLimitSendTimeList(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)Ljava/util/ArrayList;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result p0

    sub-int/2addr p0, v1

    if-ne p0, p1, :cond_2

    .line 550
    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;->-$$Nest$fgetmLine(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;)Landroid/view/View;

    move-result-object p0

    const/16 p1, 0x8

    invoke-virtual {p0, p1}, Landroid/view/View;->setVisibility(I)V

    goto :goto_2

    .line 552
    :cond_2
    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;->-$$Nest$fgetmLine(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$LimitSendTimeListAdapter$ViewHolder;)Landroid/view/View;

    move-result-object p0

    invoke-virtual {p0, v2}, Landroid/view/View;->setVisibility(I)V

    :goto_2
    return-object p3
.end method
