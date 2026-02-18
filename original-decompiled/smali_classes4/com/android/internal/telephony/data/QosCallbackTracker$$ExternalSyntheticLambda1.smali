.class public final synthetic Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/QosCallbackTracker;

.field public final synthetic f$1:I

.field public final synthetic f$2:Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/QosCallbackTracker;ILcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/data/QosCallbackTracker;

    iput p2, p0, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda1;->f$1:I

    iput-object p3, p0, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda1;->f$2:Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 2

    iget-object v0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/data/QosCallbackTracker;

    iget v1, p0, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda1;->f$1:I

    iget-object p0, p0, Lcom/android/internal/telephony/data/QosCallbackTracker$$ExternalSyntheticLambda1;->f$2:Lcom/android/internal/telephony/data/QosCallbackTracker$IFilter;

    invoke-static {v0, v1, p0}, Lcom/android/internal/telephony/data/QosCallbackTracker;->$r8$lambda$EzewSNFbqJolOJEcdY3ta-bJa6g(Lcom/android/internal/telephony/data/QosCallbackTracker;ILcom/android/internal/telephony/data/QosCallbackTracker$IFilter;)V

    return-void
.end method
