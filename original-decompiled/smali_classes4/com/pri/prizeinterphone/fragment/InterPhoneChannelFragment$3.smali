.class Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$3;
.super Ljava/lang/Object;
.source "InterPhoneChannelFragment.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->createDeleteDialog(Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)V
    .locals 0

    .line 440
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$3;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 1

    .line 443
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$3;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$misTalkSend(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Z

    move-result p1

    if-nez p1, :cond_0

    .line 444
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    iget-object p2, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$3;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    iget-object v0, p2, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    invoke-static {p2}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetmCurrentClickPosition(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)I

    move-result p2

    invoke-interface {v0, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    invoke-virtual {p1, p2}, Lcom/pri/prizeinterphone/manager/DmrManager;->deleteChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 445
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$3;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p2

    invoke-virtual {p2}, Lcom/pri/prizeinterphone/manager/DmrManager;->getChannelList()Ljava/util/List;

    move-result-object p2

    iput-object p2, p1, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->channels:Ljava/util/List;

    .line 446
    iget-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$3;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->updateAdapter()V

    .line 448
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$3;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetdeleteDialog(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Landroid/app/AlertDialog;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog;->dismiss()V

    return-void
.end method
