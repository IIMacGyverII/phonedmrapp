.class public Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;
.super Landroid/telephony/ims/aidl/IRcsConfigCallback$Stub;
.source "RcsStats.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/metrics/RcsStats;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "RcsProvisioningCallback"
.end annotation


# instance fields
.field private mEnableSingleRegistration:Z

.field private mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

.field private mRegistered:Z

.field private mSubId:I

.field final synthetic this$0:Lcom/android/internal/telephony/metrics/RcsStats;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/metrics/RcsStats;Lcom/android/internal/telephony/metrics/RcsStats;IZ)V
    .locals 1

    .line 653
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->this$0:Lcom/android/internal/telephony/metrics/RcsStats;

    invoke-direct {p0}, Landroid/telephony/ims/aidl/IRcsConfigCallback$Stub;-><init>()V

    const-string v0, "created RcsProvisioningCallback"

    .line 654
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/metrics/RcsStats;->logd(Ljava/lang/String;)V

    .line 655
    iput-object p2, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

    .line 656
    iput p3, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mSubId:I

    .line 657
    iput-boolean p4, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mEnableSingleRegistration:Z

    const/4 p1, 0x0

    .line 658
    iput-boolean p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mRegistered:Z

    return-void
.end method


# virtual methods
.method public getRegistered()Z
    .locals 0

    .line 666
    iget-boolean p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mRegistered:Z

    return p0
.end method

.method public onAutoConfigurationErrorReceived(ILjava/lang/String;)V
    .locals 4

    .line 680
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 682
    :try_start_0
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

    iget v2, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mSubId:I

    const/4 v3, 0x1

    iget-boolean p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mEnableSingleRegistration:Z

    invoke-virtual {p2, v2, p1, v3, p0}, Lcom/android/internal/telephony/metrics/RcsStats;->onRcsAcsProvisioningStats(IIIZ)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 686
    invoke-static {v0, v1}, Landroid/telephony/ims/aidl/IRcsConfigCallback$Stub;->restoreCallingIdentity(J)V

    return-void

    :catchall_0
    move-exception p0

    invoke-static {v0, v1}, Landroid/telephony/ims/aidl/IRcsConfigCallback$Stub;->restoreCallingIdentity(J)V

    .line 687
    throw p0
.end method

.method public onConfigurationChanged([B)V
    .locals 0

    return-void
.end method

.method public onConfigurationReset()V
    .locals 0

    return-void
.end method

.method public onPreProvisioningReceived([B)V
    .locals 5

    .line 710
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 713
    :try_start_0
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

    iget v2, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mSubId:I

    const/16 v3, 0xc8

    const/4 v4, 0x3

    iget-boolean p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mEnableSingleRegistration:Z

    invoke-virtual {p1, v2, v3, v4, p0}, Lcom/android/internal/telephony/metrics/RcsStats;->onRcsAcsProvisioningStats(IIIZ)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 717
    invoke-static {v0, v1}, Landroid/telephony/ims/aidl/IRcsConfigCallback$Stub;->restoreCallingIdentity(J)V

    return-void

    :catchall_0
    move-exception p0

    invoke-static {v0, v1}, Landroid/telephony/ims/aidl/IRcsConfigCallback$Stub;->restoreCallingIdentity(J)V

    .line 718
    throw p0
.end method

.method public onRemoved()V
    .locals 4

    .line 697
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 700
    :try_start_0
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

    iget v3, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mSubId:I

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/metrics/RcsStats;->onStoreCompleteRcsAcsProvisioningStats(I)V

    .line 702
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mRcsStats:Lcom/android/internal/telephony/metrics/RcsStats;

    iget p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mSubId:I

    invoke-static {v2, p0}, Lcom/android/internal/telephony/metrics/RcsStats;->-$$Nest$mremoveRcsProvisioningCallback(Lcom/android/internal/telephony/metrics/RcsStats;I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 704
    invoke-static {v0, v1}, Landroid/telephony/ims/aidl/IRcsConfigCallback$Stub;->restoreCallingIdentity(J)V

    return-void

    :catchall_0
    move-exception p0

    invoke-static {v0, v1}, Landroid/telephony/ims/aidl/IRcsConfigCallback$Stub;->restoreCallingIdentity(J)V

    .line 705
    throw p0
.end method

.method public declared-synchronized setEnableSingleRegistration(Z)V
    .locals 0

    monitor-enter p0

    .line 662
    :try_start_0
    iput-boolean p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mEnableSingleRegistration:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 663
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public setRegistered(Z)V
    .locals 0

    .line 670
    iput-boolean p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$RcsProvisioningCallback;->mRegistered:Z

    return-void
.end method
