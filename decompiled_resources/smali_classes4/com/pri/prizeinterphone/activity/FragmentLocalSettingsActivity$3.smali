.class Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$3;
.super Ljava/lang/Object;
.source "FragmentLocalSettingsActivity.java"

# interfaces
.implements Landroid/widget/AdapterView$OnItemClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->showMicGainValueDialog()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)V
    .locals 0

    .line 479
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$3;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onItemClick(Landroid/widget/AdapterView;Landroid/view/View;IJ)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/widget/AdapterView<",
            "*>;",
            "Landroid/view/View;",
            "IJ)V"
        }
    .end annotation

    .line 482
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$3;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$misTalkSend(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 483
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$3;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    const p2, 0x7f11011c

    invoke-static {p1, p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$mshowToast(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;I)V

    goto :goto_0

    .line 485
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$3;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$fgetmMicGainList(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)Ljava/util/ArrayList;

    move-result-object p2

    invoke-virtual {p2, p3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/lang/String;

    invoke-static {p1, p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$mupdatemicGainView(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;Ljava/lang/String;)V

    .line 486
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p1

    iget-object p2, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$3;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-static {p2}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$fgetarrayMicGainValues(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)[I

    move-result-object p2

    aget p2, p2, p3

    const-string p4, "pref_person_mic_gan_value"

    invoke-static {p1, p4, p2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putIntData(Landroid/content/Context;Ljava/lang/String;I)V

    .line 487
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$3;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-static {p1, p3}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$fputmMicCurrentCheckItem(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;I)V

    .line 488
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendSetMicGainCmdToMdl()V

    .line 490
    :goto_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$3;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$fgetmMicGainDialog(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)Landroid/app/Dialog;

    move-result-object p1

    if-eqz p1, :cond_1

    .line 491
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity$3;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;->-$$Nest$fgetmMicGainDialog(Lcom/pri/prizeinterphone/activity/FragmentLocalSettingsActivity;)Landroid/app/Dialog;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/Dialog;->dismiss()V

    :cond_1
    return-void
.end method
