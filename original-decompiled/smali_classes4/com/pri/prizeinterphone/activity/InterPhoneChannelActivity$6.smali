.class Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$6;
.super Ljava/lang/Object;
.source "InterPhoneChannelActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;
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

    .line 684
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$6;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 0

    .line 687
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity$6;->this$0:Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->dismissProgressDialog()V

    return-void
.end method
