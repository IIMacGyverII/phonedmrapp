.class Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$3;
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

    .line 412
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$3;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 0

    .line 415
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$3;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$fgetdeleteDialog(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Landroid/app/AlertDialog;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog;->dismiss()V

    return-void
.end method
