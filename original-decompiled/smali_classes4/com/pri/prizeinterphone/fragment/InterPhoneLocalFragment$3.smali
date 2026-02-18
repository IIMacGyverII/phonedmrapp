.class Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$3;
.super Ljava/lang/Object;
.source "InterPhoneLocalFragment.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;)V
    .locals 0

    .line 516
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$3;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 519
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$3;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

    invoke-static {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;->-$$Nest$fgetmLocalView(Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;)Landroid/view/View;

    move-result-object v0

    const v1, 0x7f09017a

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment$3;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneLocalFragment;

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;

    move-result-object p0

    invoke-static {p0}, Lcom/pri/prizeinterphone/constant/Constants;->getChannelAreaName(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method
