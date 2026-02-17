.class public final synthetic Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda20;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Function;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/DataRetryManager;

.field public final synthetic f$1:I

.field public final synthetic f$2:J

.field public final synthetic f$3:I


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/DataRetryManager;IJI)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda20;->f$0:Lcom/android/internal/telephony/data/DataRetryManager;

    iput p2, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda20;->f$1:I

    iput-wide p3, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda20;->f$2:J

    iput p5, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda20;->f$3:I

    return-void
.end method


# virtual methods
.method public final apply(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 6

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda20;->f$0:Lcom/android/internal/telephony/data/DataRetryManager;

    iget v1, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda20;->f$1:I

    iget-wide v2, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda20;->f$2:J

    iget v4, p0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda20;->f$3:I

    move-object v5, p1

    check-cast v5, Ljava/lang/Integer;

    invoke-static/range {v0 .. v5}, Lcom/android/internal/telephony/data/DataRetryManager;->$r8$lambda$a-CEndwerrz9qvE6s1sCV3WcWHY(Lcom/android/internal/telephony/data/DataRetryManager;IJILjava/lang/Integer;)Landroid/telephony/data/ThrottleStatus;

    move-result-object p0

    return-object p0
.end method
