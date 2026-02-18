.class public final synthetic Lcom/android/internal/telephony/metrics/RcsStats$$ExternalSyntheticLambda3;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$$ExternalSyntheticLambda3;->f$0:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/metrics/RcsStats$$ExternalSyntheticLambda3;->f$0:Ljava/lang/String;

    check-cast p1, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/RcsStats;->$r8$lambda$HfeApF4_C0BkIaOYbqTiPuEQcCQ(Ljava/lang/String;Lcom/android/internal/telephony/metrics/RcsStats$SipTransportSessionArray;)Z

    move-result p0

    return p0
.end method
