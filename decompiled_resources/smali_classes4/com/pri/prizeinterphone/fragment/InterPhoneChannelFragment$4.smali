.class Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$4;
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

    .line 434
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$4;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 0

    .line 437
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment$4;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;->-$$Nest$fgetdeleteDialog(Lcom/pri/prizeinterphone/fragment/InterPhoneChannelFragment;)Landroid/app/AlertDialog;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog;->dismiss()V

    return-void
.end method
