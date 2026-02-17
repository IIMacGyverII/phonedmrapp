.class Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;
.super Landroid/widget/BaseAdapter;
.source "FragmentLocalDeviceAreaActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "DeviceAreaListAdapter"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;
    }
.end annotation


# instance fields
.field private mContext:Landroid/content/Context;

.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;Landroid/content/Context;Ljava/util/LinkedHashMap;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 224
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-direct {p0}, Landroid/widget/BaseAdapter;-><init>()V

    .line 225
    iput-object p2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;->mContext:Landroid/content/Context;

    return-void
.end method


# virtual methods
.method public getCount()I
    .locals 0

    .line 230
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$fgetmDeviceAreaDataList(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Ljava/util/LinkedHashMap;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/LinkedHashMap;->size()I

    move-result p0

    return p0
.end method

.method public bridge synthetic getItem(I)Ljava/lang/Object;
    .locals 0

    .line 220
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;->getItem(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getItem(I)Ljava/lang/String;
    .locals 0

    .line 235
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$fgetmDeviceAreaDataList(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Ljava/util/LinkedHashMap;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/LinkedHashMap;->keySet()Ljava/util/Set;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/stream/Stream;->toArray()[Ljava/lang/Object;

    move-result-object p0

    aget-object p0, p0, p1

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public getItemId(I)J
    .locals 0

    int-to-long p0, p1

    return-wide p0
.end method

.method public getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 5

    if-nez p2, :cond_0

    .line 247
    new-instance p2, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;

    invoke-direct {p2, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;)V

    .line 248
    iget-object p3, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;->mContext:Landroid/content/Context;

    invoke-static {p3}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p3

    const v0, 0x7f0c0041

    const/4 v1, 0x0

    .line 249
    invoke-virtual {p3, v0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object p3

    const v0, 0x7f090178

    .line 250
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fputmTvListTitle(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;Landroid/widget/TextView;)V

    const v0, 0x7f090177

    .line 251
    invoke-virtual {p3, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ImageView;

    invoke-static {p2, v0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fputmImgListSelect(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;Landroid/widget/ImageView;)V

    .line 252
    invoke-virtual {p3, p2}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    goto :goto_0

    .line 254
    :cond_0
    invoke-virtual {p2}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;

    move-object v4, p3

    move-object p3, p2

    move-object p2, v4

    .line 257
    :goto_0
    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fgetmTvListTitle(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;)Landroid/widget/TextView;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;->mContext:Landroid/content/Context;

    iget-object v2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {v2}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$fgetmDeviceAreaDataList(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Ljava/util/LinkedHashMap;

    move-result-object v2

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;->getItem(I)Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v2, v3}, Lcom/pri/prizeinterphone/constant/Constants;->getChannelAreaName(Landroid/content/Context;Ljava/util/LinkedHashMap;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 258
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$fgetmCurrentSelected(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter;->getItem(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    .line 259
    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fgetmImgListSelect(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object p0

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setVisibility(I)V

    goto :goto_1

    .line 261
    :cond_1
    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;->-$$Nest$fgetmImgListSelect(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$DeviceAreaListAdapter$ViewHolder;)Landroid/widget/ImageView;

    move-result-object p0

    const/16 p1, 0x8

    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setVisibility(I)V

    :goto_1
    return-object p3
.end method
