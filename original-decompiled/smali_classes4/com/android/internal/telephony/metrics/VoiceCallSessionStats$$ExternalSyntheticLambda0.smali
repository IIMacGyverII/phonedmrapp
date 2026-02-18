.class public final synthetic Lcom/android/internal/telephony/metrics/VoiceCallSessionStats$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Function;


# direct methods
.method public synthetic constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final apply(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    check-cast p1, Lcom/android/internal/telephony/Connection;

    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->$r8$lambda$PR4s0xU97skEthjdr2br7KZ7rAs(Lcom/android/internal/telephony/Connection;)I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    return-object p0
.end method
