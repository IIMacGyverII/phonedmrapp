.class Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$1;
.super Ljava/lang/Object;
.source "FragmentLocalDeviceAreaListActivity.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->createDeleteDialog(Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)V
    .locals 0

    .line 316
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 2

    .line 319
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->-$$Nest$misTalkSend(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)Z

    move-result p1

    if-nez p1, :cond_1

    .line 320
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;

    iget-object p2, p1, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->-$$Nest$fgetmCurrentClickPosition(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)I

    move-result p1

    invoke-interface {p2, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getActive()I

    move-result p1

    if-nez p1, :cond_0

    .line 321
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    iget-object p2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;

    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->-$$Nest$fgetmSeletedChannelIndex(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)Ljava/lang/String;

    move-result-object p2

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;

    iget-object v1, v0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->-$$Nest$fgetmCurrentClickPosition(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)I

    move-result v0

    invoke-interface {v1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {p1, p2, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->deleteChannel(Ljava/lang/String;Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 322
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;

    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p2

    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;

    invoke-static {v0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->-$$Nest$fgetmSeletedChannelIndex(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getChannelList(Ljava/lang/String;)Ljava/util/List;

    move-result-object p2

    iput-object p2, p1, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->channels:Ljava/util/List;

    .line 323
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->-$$Nest$fgetmDeviceAreaListAdapter(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$DeviceAreaListAdapter;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/BaseAdapter;->notifyDataSetChanged()V

    goto :goto_0

    .line 325
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;

    const p2, 0x7f110108

    invoke-static {p1, p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->-$$Nest$mshowToast(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;I)V

    .line 328
    :cond_1
    :goto_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->-$$Nest$fgetdeleteDialog(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)Landroid/app/AlertDialog;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog;->dismiss()V

    return-void
.end method
