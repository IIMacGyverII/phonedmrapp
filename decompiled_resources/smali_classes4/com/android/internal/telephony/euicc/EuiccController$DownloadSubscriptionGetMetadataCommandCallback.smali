.class Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;
.super Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;
.source "EuiccController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/euicc/EuiccController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "DownloadSubscriptionGetMetadataCommandCallback"
.end annotation


# instance fields
.field private final mForceDeactivateSim:Z

.field private final mPortIndex:I

.field private final mSwitchAfterDownload:Z

.field private final mWithUserConsent:Z

.field final synthetic this$0:Lcom/android/internal/telephony/euicc/EuiccController;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/euicc/EuiccController;JLandroid/telephony/euicc/DownloadableSubscription;ZLjava/lang/String;ZLandroid/app/PendingIntent;ZI)V
    .locals 8

    move-object v7, p0

    move-object v1, p1

    .line 638
    iput-object v1, v7, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->this$0:Lcom/android/internal/telephony/euicc/EuiccController;

    move-object v0, p0

    move-wide v2, p2

    move-object v4, p4

    move-object v5, p6

    move-object/from16 v6, p8

    .line 639
    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;JLandroid/telephony/euicc/DownloadableSubscription;Ljava/lang/String;Landroid/app/PendingIntent;)V

    move v0, p5

    .line 640
    iput-boolean v0, v7, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mSwitchAfterDownload:Z

    move v0, p7

    .line 641
    iput-boolean v0, v7, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mForceDeactivateSim:Z

    move/from16 v0, p9

    .line 642
    iput-boolean v0, v7, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mWithUserConsent:Z

    move/from16 v0, p10

    .line 643
    iput v0, v7, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mPortIndex:I

    return-void
.end method


# virtual methods
.method public onGetMetadataComplete(ILandroid/service/euicc/GetDownloadableSubscriptionMetadataResult;)V
    .locals 17

    move-object/from16 v0, p0

    .line 649
    invoke-virtual/range {p2 .. p2}, Landroid/service/euicc/GetDownloadableSubscriptionMetadataResult;->getDownloadableSubscription()Landroid/telephony/euicc/DownloadableSubscription;

    move-result-object v5

    .line 650
    iget-boolean v1, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mWithUserConsent:Z

    const/4 v2, 0x0

    const/4 v3, 0x2

    const-string v4, "EuiccController"

    if-eqz v1, :cond_2

    .line 652
    invoke-virtual/range {p2 .. p2}, Landroid/service/euicc/GetDownloadableSubscriptionMetadataResult;->getResult()I

    move-result v1

    if-eqz v1, :cond_0

    .line 654
    invoke-super/range {p0 .. p2}, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->onGetMetadataComplete(ILandroid/service/euicc/GetDownloadableSubscriptionMetadataResult;)V

    return-void

    .line 658
    :cond_0
    iget-object v1, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->this$0:Lcom/android/internal/telephony/euicc/EuiccController;

    iget-object v6, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mCallingPackage:Ljava/lang/String;

    invoke-static {v1, v5, v6}, Lcom/android/internal/telephony/euicc/EuiccController;->-$$Nest$mcheckCarrierPrivilegeInMetadata(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/telephony/euicc/DownloadableSubscription;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 661
    iget-object v1, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->this$0:Lcom/android/internal/telephony/euicc/EuiccController;

    iget v2, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mPortIndex:I

    iget-wide v3, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mCallingToken:J

    iget-boolean v6, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mSwitchAfterDownload:Z

    iget-boolean v7, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mForceDeactivateSim:Z

    iget-object v8, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mCallingPackage:Ljava/lang/String;

    const/4 v9, 0x0

    iget-object v10, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mCallbackIntent:Landroid/app/PendingIntent;

    move-object v0, v1

    move/from16 v1, p1

    invoke-virtual/range {v0 .. v10}, Lcom/android/internal/telephony/euicc/EuiccController;->downloadSubscriptionPrivileged(IIJLandroid/telephony/euicc/DownloadableSubscription;ZZLjava/lang/String;Landroid/os/Bundle;Landroid/app/PendingIntent;)V

    goto/16 :goto_0

    :cond_1
    const-string v1, "Caller does not have carrier privilege in metadata."

    .line 666
    invoke-static {v4, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 667
    iget-object v1, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->this$0:Lcom/android/internal/telephony/euicc/EuiccController;

    iget-object v0, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mCallbackIntent:Landroid/app/PendingIntent;

    invoke-virtual {v1, v0, v3, v2}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V

    goto :goto_0

    .line 670
    :cond_2
    invoke-virtual/range {p2 .. p2}, Landroid/service/euicc/GetDownloadableSubscriptionMetadataResult;->getResult()I

    move-result v1

    const/4 v6, -0x1

    if-ne v1, v6, :cond_3

    .line 673
    new-instance v1, Landroid/content/Intent;

    invoke-direct {v1}, Landroid/content/Intent;-><init>()V

    .line 674
    iget-object v7, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->this$0:Lcom/android/internal/telephony/euicc/EuiccController;

    iget-object v10, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mCallingPackage:Ljava/lang/String;

    const/4 v11, 0x0

    const/4 v12, 0x0

    iget-wide v2, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mCallingToken:J

    iget-object v4, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mSubscription:Landroid/telephony/euicc/DownloadableSubscription;

    iget-boolean v5, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mSwitchAfterDownload:Z

    .line 679
    invoke-static {v2, v3, v4, v5, v10}, Lcom/android/internal/telephony/euicc/EuiccOperation;->forDownloadNoPrivilegesOrDeactivateSimCheckMetadata(JLandroid/telephony/euicc/DownloadableSubscription;ZLjava/lang/String;)Lcom/android/internal/telephony/euicc/EuiccOperation;

    move-result-object v13

    iget v15, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mPortIndex:I

    iget-boolean v2, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mSwitchAfterDownload:Z

    const-string v9, "android.service.euicc.action.RESOLVE_DEACTIVATE_SIM"

    move-object v8, v1

    move/from16 v14, p1

    move/from16 v16, v2

    .line 674
    invoke-virtual/range {v7 .. v16}, Lcom/android/internal/telephony/euicc/EuiccController;->addResolutionIntentWithPort(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/String;IZLcom/android/internal/telephony/euicc/EuiccOperation;IIZ)V

    .line 683
    iget-object v2, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->this$0:Lcom/android/internal/telephony/euicc/EuiccController;

    iget-object v0, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mCallbackIntent:Landroid/app/PendingIntent;

    const/4 v3, 0x1

    invoke-virtual {v2, v0, v3, v1}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V

    return-void

    .line 687
    :cond_3
    invoke-virtual/range {p2 .. p2}, Landroid/service/euicc/GetDownloadableSubscriptionMetadataResult;->getResult()I

    move-result v1

    if-eqz v1, :cond_4

    .line 689
    invoke-super/range {p0 .. p2}, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->onGetMetadataComplete(ILandroid/service/euicc/GetDownloadableSubscriptionMetadataResult;)V

    return-void

    .line 693
    :cond_4
    iget-object v1, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->this$0:Lcom/android/internal/telephony/euicc/EuiccController;

    iget-object v6, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mCallingPackage:Ljava/lang/String;

    invoke-static {v1, v5, v6}, Lcom/android/internal/telephony/euicc/EuiccController;->-$$Nest$mcheckCarrierPrivilegeInMetadata(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/telephony/euicc/DownloadableSubscription;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_5

    .line 696
    iget-object v1, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->this$0:Lcom/android/internal/telephony/euicc/EuiccController;

    iget v2, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mPortIndex:I

    iget-wide v3, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mCallingToken:J

    iget-boolean v6, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mSwitchAfterDownload:Z

    iget-boolean v7, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->mForceDeactivateSim:Z

    iget-object v8, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mCallingPackage:Ljava/lang/String;

    const/4 v9, 0x0

    iget-object v10, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mCallbackIntent:Landroid/app/PendingIntent;

    move-object v0, v1

    move/from16 v1, p1

    invoke-virtual/range {v0 .. v10}, Lcom/android/internal/telephony/euicc/EuiccController;->downloadSubscriptionPrivileged(IIJLandroid/telephony/euicc/DownloadableSubscription;ZZLjava/lang/String;Landroid/os/Bundle;Landroid/app/PendingIntent;)V

    goto :goto_0

    :cond_5
    const-string v1, "Caller is not permitted to download this profile per metadata"

    .line 701
    invoke-static {v4, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 702
    iget-object v1, v0, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;->this$0:Lcom/android/internal/telephony/euicc/EuiccController;

    iget-object v0, v0, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;->mCallbackIntent:Landroid/app/PendingIntent;

    invoke-virtual {v1, v0, v3, v2}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V

    :goto_0
    return-void
.end method
