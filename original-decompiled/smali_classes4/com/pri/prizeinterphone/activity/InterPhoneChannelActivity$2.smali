.class Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$2;
.super Ljava/lang/Object;
.source "InterPhoneChannelActivity.java"

# interfaces
.implements Landroid/view/View$OnFocusChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->initView()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)V
    .locals 0

    .line 198
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onFocusChange(Landroid/view/View;Z)V
    .locals 0

    if-eqz p2, :cond_0

    .line 202
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    const/4 p2, 0x0

    invoke-static {p1, p2}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->-$$Nest$fputmCurrentFrequency(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;I)V

    .line 203
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->-$$Nest$fgetmEditFrequncySend(Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;)Landroid/widget/EditText;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/EditText;->getId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    :cond_0
    return-void
.end method
