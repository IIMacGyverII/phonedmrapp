.class public final synthetic Lcom/android/internal/telephony/metrics/ServiceStateStats$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/UnaryOperator;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/metrics/ServiceStateStats;

.field public final synthetic f$1:J


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/metrics/ServiceStateStats;J)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/metrics/ServiceStateStats;

    iput-wide p2, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats$$ExternalSyntheticLambda0;->f$1:J

    return-void
.end method


# virtual methods
.method public final apply(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 3

    iget-object v0, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/metrics/ServiceStateStats;

    iget-wide v1, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats$$ExternalSyntheticLambda0;->f$1:J

    check-cast p1, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    invoke-static {v0, v1, v2, p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->$r8$lambda$S5R0teoz3MA4LKEGoFOnkzr82PM(Lcom/android/internal/telephony/metrics/ServiceStateStats;JLcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    move-result-object p0

    return-object p0
.end method
