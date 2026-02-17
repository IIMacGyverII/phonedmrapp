.class Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;
.super Ljava/lang/Object;
.source "DcNetworkAgent.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "DcKeepaliveTracker"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;
    }
.end annotation


# instance fields
.field private final mKeepalives:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;",
            ">;"
        }
    .end annotation
.end field

.field final synthetic this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;)V
    .locals 0

    .line 497
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 508
    new-instance p1, Landroid/util/SparseArray;

    invoke-direct {p1}, Landroid/util/SparseArray;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->mKeepalives:Landroid/util/SparseArray;

    return-void
.end method


# virtual methods
.method getHandleForSlot(I)I
    .locals 2

    const/4 v0, 0x0

    .line 511
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->mKeepalives:Landroid/util/SparseArray;

    invoke-virtual {v1}, Landroid/util/SparseArray;->size()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 512
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->mKeepalives:Landroid/util/SparseArray;

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;

    .line 513
    iget v1, v1, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;->slotId:I

    if-ne v1, p1, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->mKeepalives:Landroid/util/SparseArray;

    invoke-virtual {p0, v0}, Landroid/util/SparseArray;->keyAt(I)I

    move-result p0

    return p0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, -0x1

    return p0
.end method

.method handleKeepaliveStarted(ILcom/android/internal/telephony/data/KeepaliveStatus;)V
    .locals 3

    .line 533
    iget v0, p2, Lcom/android/internal/telephony/data/KeepaliveStatus;->statusCode:I

    if-eqz v0, :cond_1

    const/4 v1, 0x1

    if-eq v0, v1, :cond_0

    const/4 v1, 0x2

    if-eq v0, v1, :cond_2

    .line 550
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Invalid KeepaliveStatus Code: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p2, p2, Lcom/android/internal/telephony/data/KeepaliveStatus;->statusCode:I

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$mlogd(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V

    goto :goto_0

    .line 535
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    iget p2, p2, Lcom/android/internal/telephony/data/KeepaliveStatus;->errorCode:I

    .line 536
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->keepaliveStatusErrorToPacketKeepaliveError(I)I

    move-result p0

    .line 535
    invoke-virtual {v0, p1, p0}, Landroid/net/NetworkAgent;->sendSocketKeepaliveEvent(II)V

    goto :goto_0

    .line 539
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    const/4 v1, 0x0

    invoke-virtual {v0, p1, v1}, Landroid/net/NetworkAgent;->sendSocketKeepaliveEvent(II)V

    .line 543
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Adding keepalive handle="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p2, Lcom/android/internal/telephony/data/KeepaliveStatus;->sessionHandle:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " slot = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$mlogd(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V

    .line 545
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->mKeepalives:Landroid/util/SparseArray;

    iget v1, p2, Lcom/android/internal/telephony/data/KeepaliveStatus;->sessionHandle:I

    new-instance v2, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;

    iget p2, p2, Lcom/android/internal/telephony/data/KeepaliveStatus;->statusCode:I

    invoke-direct {v2, p0, p1, p2}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;-><init>(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;II)V

    invoke-virtual {v0, v1, v2}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    :goto_0
    return-void
.end method

.method handleKeepaliveStatus(Lcom/android/internal/telephony/data/KeepaliveStatus;)V
    .locals 6

    .line 557
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->mKeepalives:Landroid/util/SparseArray;

    iget v1, p1, Lcom/android/internal/telephony/data/KeepaliveStatus;->sessionHandle:I

    invoke-virtual {v0, v1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;

    if-nez v0, :cond_0

    .line 563
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Discarding keepalive event for different data connection:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$mloge(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V

    return-void

    .line 567
    :cond_0
    iget v1, v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;->currentStatus:I

    const/4 v2, 0x0

    const-string v3, "Invalid Keepalive Status received, "

    const/4 v4, 0x2

    const/4 v5, 0x1

    if-eqz v1, :cond_6

    if-eq v1, v5, :cond_5

    if-eq v1, v4, :cond_1

    .line 613
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;->currentStatus:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$mloge(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V

    goto/16 :goto_0

    .line 574
    :cond_1
    iget v1, p1, Lcom/android/internal/telephony/data/KeepaliveStatus;->statusCode:I

    if-eqz v1, :cond_4

    if-eq v1, v5, :cond_3

    if-eq v1, v4, :cond_2

    .line 591
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Lcom/android/internal/telephony/data/KeepaliveStatus;->statusCode:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$mloge(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V

    goto/16 :goto_0

    .line 588
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    const-string p1, "Invalid unsolicied Keepalive Pending Status!"

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$mloge(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V

    goto/16 :goto_0

    .line 576
    :cond_3
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    iget v2, v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;->slotId:I

    iget v3, p1, Lcom/android/internal/telephony/data/KeepaliveStatus;->errorCode:I

    .line 577
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->keepaliveStatusErrorToPacketKeepaliveError(I)I

    move-result v3

    .line 576
    invoke-virtual {v1, v2, v3}, Landroid/net/NetworkAgent;->sendSocketKeepaliveEvent(II)V

    .line 578
    iput v5, v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;->currentStatus:I

    .line 579
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->mKeepalives:Landroid/util/SparseArray;

    iget p1, p1, Lcom/android/internal/telephony/data/KeepaliveStatus;->sessionHandle:I

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->remove(I)V

    goto :goto_0

    .line 582
    :cond_4
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    const-string v1, "Pending Keepalive received active status!"

    invoke-static {p1, v1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$mlogd(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V

    .line 583
    iput v2, v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;->currentStatus:I

    .line 584
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    iget p1, v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;->slotId:I

    invoke-virtual {p0, p1, v2}, Landroid/net/NetworkAgent;->sendSocketKeepaliveEvent(II)V

    goto :goto_0

    .line 569
    :cond_5
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    const-string v1, "Inactive Keepalive received status!"

    invoke-static {p1, v1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$mlogd(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V

    .line 570
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    iget p1, v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;->slotId:I

    const/16 v0, -0x1f

    invoke-virtual {p0, p1, v0}, Landroid/net/NetworkAgent;->sendSocketKeepaliveEvent(II)V

    goto :goto_0

    .line 595
    :cond_6
    iget v1, p1, Lcom/android/internal/telephony/data/KeepaliveStatus;->statusCode:I

    if-eqz v1, :cond_8

    if-eq v1, v5, :cond_7

    if-eq v1, v4, :cond_8

    .line 609
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Lcom/android/internal/telephony/data/KeepaliveStatus;->statusCode:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$mloge(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V

    goto :goto_0

    .line 597
    :cond_7
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    const-string v3, "Keepalive received stopped status!"

    invoke-static {v1, v3}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$mlogd(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V

    .line 598
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    iget v3, v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;->slotId:I

    invoke-virtual {v1, v3, v2}, Landroid/net/NetworkAgent;->sendSocketKeepaliveEvent(II)V

    .line 601
    iput v5, v0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker$KeepaliveRecord;->currentStatus:I

    .line 602
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->mKeepalives:Landroid/util/SparseArray;

    iget p1, p1, Lcom/android/internal/telephony/data/KeepaliveStatus;->sessionHandle:I

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->remove(I)V

    goto :goto_0

    .line 606
    :cond_8
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent$DcKeepaliveTracker;->this$0:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    const-string p1, "Active Keepalive received invalid status!"

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->-$$Nest$mloge(Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method keepaliveStatusErrorToPacketKeepaliveError(I)I
    .locals 0

    if-eqz p1, :cond_2

    const/4 p0, 0x1

    if-eq p1, p0, :cond_1

    const/4 p0, 0x2

    if-eq p1, p0, :cond_0

    const/16 p0, -0x1f

    return p0

    :cond_0
    const/16 p0, -0x20

    return p0

    :cond_1
    const/16 p0, -0x1e

    return p0

    :cond_2
    const/4 p0, 0x0

    return p0
.end method
