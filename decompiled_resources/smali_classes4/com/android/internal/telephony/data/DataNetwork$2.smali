.class Lcom/android/internal/telephony/data/DataNetwork$2;
.super Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;
.source "DataNetwork.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/DataNetwork;->createNetworkAgent()Lcom/android/internal/telephony/data/TelephonyNetworkAgent;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataNetwork;


# direct methods
.method public static synthetic $r8$lambda$WWFl9aE78spuKAi28tyPFDYJuFU(Lcom/android/internal/telephony/data/DataNetwork$2;ILandroid/net/Uri;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetwork$2;->lambda$onValidationStatus$0(ILandroid/net/Uri;)V

    return-void
.end method

.method constructor <init>(Lcom/android/internal/telephony/data/DataNetwork;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 975
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$2;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method

.method private synthetic lambda$onValidationStatus$0(ILandroid/net/Uri;)V
    .locals 1

    .line 988
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$2;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    invoke-virtual {v0, p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;->onValidationStatusChanged(Lcom/android/internal/telephony/data/DataNetwork;ILandroid/net/Uri;)V

    return-void
.end method


# virtual methods
.method public onValidationStatus(ILandroid/net/Uri;)V
    .locals 2

    .line 980
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$2;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v0, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$2;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    .line 982
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object v1

    .line 981
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->mtkSkipDataStallAlarm(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 983
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$2;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    const-string p1, "configured skip data stall."

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    return-void

    .line 987
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$2;->this$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v0, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetwork$2$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetwork$2$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/data/DataNetwork$2;ILandroid/net/Uri;)V

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method
