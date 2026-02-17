.class Lcom/android/internal/telephony/dataconnection/DcTracker$3;
.super Landroid/net/NetworkPolicyManager$SubscriptionCallback;
.source "DcTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DcTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/dataconnection/DcTracker;)V
    .locals 0

    .line 461
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-direct {p0}, Landroid/net/NetworkPolicyManager$SubscriptionCallback;-><init>()V

    return-void
.end method


# virtual methods
.method public onSubscriptionOverride(III[I)V
    .locals 4

    .line 465
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/dataconnection/DcTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v0, :cond_5

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    if-eq v0, p1, :cond_0

    goto :goto_1

    .line 467
    :cond_0
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    .line 468
    array-length v0, p4

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ge v2, v0, :cond_1

    aget v3, p4, v2

    .line 469
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {p1, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 472
    :cond_1
    iget-object p4, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Subscription override: overrideMask="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", overrideValue="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", networkTypes="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p4, v0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->log(Ljava/lang/String;)V

    const/4 p4, 0x1

    if-ne p2, p4, :cond_3

    .line 476
    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {p2, p1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fputmUnmeteredNetworkTypes(Lcom/android/internal/telephony/dataconnection/DcTracker;Ljava/util/List;)V

    .line 477
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    if-eqz p3, :cond_2

    move v1, p4

    :cond_2
    invoke-static {p1, v1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fputmUnmeteredOverride(Lcom/android/internal/telephony/dataconnection/DcTracker;Z)V

    .line 478
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$mreevaluateUnmeteredConnections(Lcom/android/internal/telephony/dataconnection/DcTracker;)V

    goto :goto_1

    :cond_3
    const/4 v0, 0x2

    if-ne p2, v0, :cond_5

    .line 480
    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {p2, p1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fputmCongestedNetworkTypes(Lcom/android/internal/telephony/dataconnection/DcTracker;Ljava/util/List;)V

    .line 481
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    if-eqz p3, :cond_4

    move v1, p4

    :cond_4
    invoke-static {p1, v1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fputmCongestedOverride(Lcom/android/internal/telephony/dataconnection/DcTracker;Z)V

    .line 482
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$mreevaluateCongestedConnections(Lcom/android/internal/telephony/dataconnection/DcTracker;)V

    :cond_5
    :goto_1
    return-void
.end method

.method public onSubscriptionPlansChanged(I[Landroid/telephony/SubscriptionPlan;)V
    .locals 1

    .line 488
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/dataconnection/DcTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    if-eq v0, p1, :cond_0

    goto :goto_0

    .line 490
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {p2}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p2

    invoke-static {p1, p2}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fputmSubscriptionPlans(Lcom/android/internal/telephony/dataconnection/DcTracker;Ljava/util/List;)V

    .line 491
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "SubscriptionPlans changed: "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fgetmSubscriptionPlans(Lcom/android/internal/telephony/dataconnection/DcTracker;)Ljava/util/List;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/dataconnection/DcTracker;->log(Ljava/lang/String;)V

    .line 492
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$3;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$mreevaluateUnmeteredConnections(Lcom/android/internal/telephony/dataconnection/DcTracker;)V

    :cond_1
    :goto_0
    return-void
.end method
