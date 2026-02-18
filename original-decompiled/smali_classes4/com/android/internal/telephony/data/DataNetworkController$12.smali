.class Lcom/android/internal/telephony/data/DataNetworkController$12;
.super Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;
.source "DataNetworkController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/DataNetworkController;->setupDataNetwork(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataNetworkController;

.field final synthetic val$dataSetupRetryEntry:Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/DataNetworkController;Ljava/util/concurrent/Executor;Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)V
    .locals 0

    .line 2392
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    iput-object p3, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->val$dataSetupRetryEntry:Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onAttachFailed(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V
    .locals 0

    .line 2415
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$monAttachNetworkRequestsFailed(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V

    return-void
.end method

.method public onConnected(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 2

    .line 2406
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->val$dataSetupRetryEntry:Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    if-eqz v0, :cond_0

    const/4 v1, 0x3

    .line 2407
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    .line 2409
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$monDataNetworkConnected(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method public onDisconnected(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    .line 2436
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$monDataNetworkDisconnected(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;I)V

    return-void
.end method

.method public onHandoverFailed(Lcom/android/internal/telephony/data/DataNetwork;IJI)V
    .locals 6

    .line 2449
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    move-object v1, p1

    move v2, p2

    move-wide v3, p3

    move v5, p5

    invoke-static/range {v0 .. v5}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$monDataNetworkHandoverFailed(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;IJI)V

    return-void
.end method

.method public onHandoverSucceeded(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    .line 2442
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$monDataNetworkHandoverSucceeded(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method public onLinkStatusChanged(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    .line 2456
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$monLinkStatusChanged(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;I)V

    return-void
.end method

.method public onNetworkCapabilitiesChanged(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    .line 2466
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$monNetworkCapabilitiesChanged(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method public onPcoDataChanged(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    .line 2461
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$monPcoDataChanged(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method public onSetupDataFailed(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V
    .locals 8

    .line 2397
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->val$dataSetupRetryEntry:Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    if-eqz v0, :cond_0

    const/4 v1, 0x2

    .line 2398
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    .line 2400
    :cond_0
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    move-object v3, p1

    move-object v4, p2

    move v5, p3

    move-wide v6, p4

    invoke-static/range {v2 .. v7}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$monDataNetworkSetupFailed(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V

    return-void
.end method

.method public onSuspendedStateChanged(Lcom/android/internal/telephony/data/DataNetwork;Z)V
    .locals 0

    .line 2429
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$monDataNetworkSuspendedStateChanged(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;Z)V

    return-void
.end method

.method public onTrackNetworkUnwanted(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    .line 2471
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$monTrackNetworkUnwanted(Lcom/android/internal/telephony/data/DataNetworkController;)V

    return-void
.end method

.method public onValidationStatusChanged(Lcom/android/internal/telephony/data/DataNetwork;ILandroid/net/Uri;)V
    .locals 0

    .line 2422
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$12;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-static {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/DataNetworkController;->-$$Nest$monDataNetworkValidationStatusChanged(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;ILandroid/net/Uri;)V

    return-void
.end method
