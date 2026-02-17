.class Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$2;
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

    .line 310
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 0

    .line 313
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;->-$$Nest$fgetdeleteDialog(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaListActivity;)Landroid/app/AlertDialog;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog;->dismiss()V

    return-void
.end method
