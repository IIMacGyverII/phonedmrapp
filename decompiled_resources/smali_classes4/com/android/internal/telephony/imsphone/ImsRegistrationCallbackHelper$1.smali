.class Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$1;
.super Landroid/telephony/ims/RegistrationManager$RegistrationCallback;
.source "ImsRegistrationCallbackHelper.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;)V
    .locals 0

    .line 67
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$1;->this$0:Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;

    invoke-direct {p0}, Landroid/telephony/ims/RegistrationManager$RegistrationCallback;-><init>()V

    return-void
.end method


# virtual methods
.method public onRegistered(I)V
    .locals 2

    .line 70
    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$1;->this$0:Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;

    const/4 v1, 0x2

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->updateRegistrationState(I)V

    .line 71
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$1;->this$0:Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;

    invoke-static {p0}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->-$$Nest$fgetmImsRegistrationUpdate(Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;)Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;

    move-result-object p0

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;->handleImsRegistered(I)V

    return-void
.end method

.method public onRegistering(I)V
    .locals 2

    .line 76
    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$1;->this$0:Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->updateRegistrationState(I)V

    .line 77
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$1;->this$0:Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;

    invoke-static {p0}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->-$$Nest$fgetmImsRegistrationUpdate(Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;)Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;

    move-result-object p0

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;->handleImsRegistering(I)V

    return-void
.end method

.method public onSubscriberAssociatedUriChanged([Landroid/net/Uri;)V
    .locals 0

    .line 88
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$1;->this$0:Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;

    invoke-static {p0}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->-$$Nest$fgetmImsRegistrationUpdate(Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;)Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;

    move-result-object p0

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;->handleImsSubscriberAssociatedUriChanged([Landroid/net/Uri;)V

    return-void
.end method

.method public onUnregistered(Landroid/telephony/ims/ImsReasonInfo;)V
    .locals 2

    .line 82
    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$1;->this$0:Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->updateRegistrationState(I)V

    .line 83
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$1;->this$0:Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;

    invoke-static {p0}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;->-$$Nest$fgetmImsRegistrationUpdate(Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper;)Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;

    move-result-object p0

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/imsphone/ImsRegistrationCallbackHelper$ImsRegistrationUpdate;->handleImsUnregistered(Landroid/telephony/ims/ImsReasonInfo;)V

    return-void
.end method
