.class Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$1;
.super Ljava/lang/Object;
.source "InterPhoneContactsFragment.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;)V
    .locals 0

    .line 403
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$1;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    const-string v0, "InterPhoneContactsFragment"

    const-string v1, "run: mUpdateChannelListRunnable"

    .line 406
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 407
    iget-object v0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$1;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;

    invoke-static {v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->-$$Nest$minitData(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;)V

    .line 408
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment$1;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->-$$Nest$fgetmCurrentType(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;)I

    move-result v0

    invoke-static {p0, v0}, Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;->-$$Nest$mrefreshUI(Lcom/pri/prizeinterphone/fragment/InterPhoneContactsFragment;I)V

    return-void
.end method
