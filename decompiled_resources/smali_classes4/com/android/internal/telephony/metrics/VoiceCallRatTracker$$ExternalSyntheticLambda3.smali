.class public final synthetic Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda3;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# direct methods
.method public synthetic constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 0

    check-cast p1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->endSession()V

    return-void
.end method
