.class Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker$1;
.super Landroid/os/Handler;
.source "ImsExternalCallTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;)V
    .locals 0

    .line 145
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker$1;->this$0:Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;

    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 148
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_0

    goto :goto_0

    .line 150
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker$1;->this$0:Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;->-$$Nest$mhandleVideoCapabilitiesChanged(Lcom/android/internal/telephony/imsphone/ImsExternalCallTracker;Landroid/os/AsyncResult;)V

    :goto_0
    return-void
.end method
