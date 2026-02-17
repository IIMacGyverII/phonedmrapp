.class Lcom/android/internal/telephony/data/DataStallRecoveryManager$2;
.super Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;
.source "DataStallRecoveryManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/DataStallRecoveryManager;->registerAllEvents()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataStallRecoveryManager;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/DataStallRecoveryManager;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 250
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager$2;->this$0:Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onInternetDataNetworkConnected(Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/data/DataProfile;",
            ">;)V"
        }
    .end annotation

    .line 260
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager$2;->this$0:Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    const/4 v0, 0x1

    invoke-static {p1, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->-$$Nest$fputmIsInternetNetworkConnected(Lcom/android/internal/telephony/data/DataStallRecoveryManager;Z)V

    .line 261
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager$2;->this$0:Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    const-string p1, "onInternetDataNetworkConnected"

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->-$$Nest$mlogl(Lcom/android/internal/telephony/data/DataStallRecoveryManager;Ljava/lang/String;)V

    return-void
.end method

.method public onInternetDataNetworkDisconnected()V
    .locals 2

    .line 266
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager$2;->this$0:Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->-$$Nest$fputmIsInternetNetworkConnected(Lcom/android/internal/telephony/data/DataStallRecoveryManager;Z)V

    .line 267
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager$2;->this$0:Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    const-string v0, "onInternetDataNetworkDisconnected"

    invoke-static {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->-$$Nest$mlogl(Lcom/android/internal/telephony/data/DataStallRecoveryManager;Ljava/lang/String;)V

    return-void
.end method

.method public onInternetDataNetworkValidationStatusChanged(I)V
    .locals 0

    .line 254
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager$2;->this$0:Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->-$$Nest$monInternetValidationStatusChanged(Lcom/android/internal/telephony/data/DataStallRecoveryManager;I)V

    return-void
.end method
