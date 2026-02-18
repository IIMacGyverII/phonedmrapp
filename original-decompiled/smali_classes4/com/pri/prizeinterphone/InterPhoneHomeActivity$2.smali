.class Lcom/pri/prizeinterphone/InterPhoneHomeActivity$2;
.super Ljava/lang/Object;
.source "InterPhoneHomeActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/InterPhoneHomeActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/InterPhoneHomeActivity;)V
    .locals 0

    .line 159
    iput-object p1, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$2;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 0

    .line 162
    iget-object p0, p0, Lcom/pri/prizeinterphone/InterPhoneHomeActivity$2;->this$0:Lcom/pri/prizeinterphone/InterPhoneHomeActivity;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/InterPhoneHomeActivity;->dismissProgressDialog()V

    return-void
.end method
