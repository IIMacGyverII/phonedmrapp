.class Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter$1;
.super Lcom/android/ims/internal/IImsRegistrationListener$Stub;
.source "ImsRegistrationCompatAdapter.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;)V
    .locals 0

    .line 44
    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter$1;->this$0:Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

    invoke-direct {p0}, Lcom/android/ims/internal/IImsRegistrationListener$Stub;-><init>()V

    return-void
.end method


# virtual methods
.method public registrationAssociatedUriChanged([Landroid/net/Uri;)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 99
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter$1;->this$0:Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

    invoke-virtual {p0, p1}, Landroid/telephony/ims/stub/ImsRegistrationImplBase;->onSubscriberAssociatedUriChanged([Landroid/net/Uri;)V

    return-void
.end method

.method public registrationChangeFailed(ILandroid/telephony/ims/ImsReasonInfo;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 105
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter$1;->this$0:Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

    invoke-static {}, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;->-$$Nest$sfgetRADIO_TECH_MAPPER()Ljava/util/Map;

    move-result-object v0

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const/4 v1, -0x1

    .line 106
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    .line 105
    invoke-interface {v0, p1, v1}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-virtual {p0, p1, p2}, Landroid/telephony/ims/stub/ImsRegistrationImplBase;->onTechnologyChangeFailed(ILandroid/telephony/ims/ImsReasonInfo;)V

    return-void
.end method

.method public registrationConnected()V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 47
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter$1;->this$0:Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

    const/4 v0, -0x1

    invoke-virtual {p0, v0}, Landroid/telephony/ims/stub/ImsRegistrationImplBase;->onRegistered(I)V

    return-void
.end method

.method public registrationConnectedWithRadioTech(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 57
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter$1;->this$0:Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

    invoke-static {}, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;->-$$Nest$sfgetRADIO_TECH_MAPPER()Ljava/util/Map;

    move-result-object v0

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const/4 v1, -0x1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, p1, v1}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-virtual {p0, p1}, Landroid/telephony/ims/stub/ImsRegistrationImplBase;->onRegistered(I)V

    return-void
.end method

.method public registrationDisconnected(Landroid/telephony/ims/ImsReasonInfo;)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 67
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter$1;->this$0:Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

    invoke-virtual {p0, p1}, Landroid/telephony/ims/stub/ImsRegistrationImplBase;->onDeregistered(Landroid/telephony/ims/ImsReasonInfo;)V

    return-void
.end method

.method public registrationFeatureCapabilityChanged(I[I[I)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    return-void
.end method

.method public registrationProgressing()V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 52
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter$1;->this$0:Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

    const/4 v0, -0x1

    invoke-virtual {p0, v0}, Landroid/telephony/ims/stub/ImsRegistrationImplBase;->onRegistering(I)V

    return-void
.end method

.method public registrationProgressingWithRadioTech(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 62
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter$1;->this$0:Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

    invoke-static {}, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;->-$$Nest$sfgetRADIO_TECH_MAPPER()Ljava/util/Map;

    move-result-object v0

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const/4 v1, -0x1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, p1, v1}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-virtual {p0, p1}, Landroid/telephony/ims/stub/ImsRegistrationImplBase;->onRegistering(I)V

    return-void
.end method

.method public registrationResumed()V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    return-void
.end method

.method public registrationServiceCapabilityChanged(II)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    return-void
.end method

.method public registrationSuspended()V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    return-void
.end method

.method public voiceMessageCountUpdate(I)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    return-void
.end method
