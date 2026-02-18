.class public final synthetic Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    check-cast p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->$r8$lambda$1nvbB2I5NTRvEFzN4_mgPL6obhM(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)V

    return-void
.end method
