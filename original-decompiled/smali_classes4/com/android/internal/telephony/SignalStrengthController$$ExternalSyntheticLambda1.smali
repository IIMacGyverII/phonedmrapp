.class public final synthetic Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;

    check-cast p1, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/SignalStrengthController;->$r8$lambda$f6d96MfFe5aU-WPW8VRo8ymoKzU(Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;)Z

    move-result p0

    return p0
.end method
