.class Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$2;
.super Ljava/lang/Object;
.source "FragmentLocalDeviceAreaActivity.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->createDeleteDialog(Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)V
    .locals 0

    .line 418
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 0

    .line 421
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$misTalkSend(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Z

    move-result p1

    if-nez p1, :cond_0

    .line 422
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInitChannelDataDB()Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    move-result-object p1

    iget-object p2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$fgetmCurrentClickPosition(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->removeChannelDataList(Ljava/lang/String;)V

    .line 423
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$fgetmDeviceAreaDataList(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Ljava/util/LinkedHashMap;

    move-result-object p1

    iget-object p2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$fgetmCurrentClickPosition(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/util/LinkedHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 424
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$mupdateListView(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)V

    .line 426
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$fgetdeleteDialog(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Landroid/app/AlertDialog;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog;->dismiss()V

    return-void
.end method
