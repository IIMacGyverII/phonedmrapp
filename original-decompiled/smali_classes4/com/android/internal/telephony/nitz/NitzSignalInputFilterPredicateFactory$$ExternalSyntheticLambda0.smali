.class public final synthetic Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$TrivalentPredicate;


# instance fields
.field public final synthetic f$0:Landroid/os/PowerManager$WakeLock;

.field public final synthetic f$1:Lcom/android/internal/telephony/NitzStateMachine$DeviceState;


# direct methods
.method public synthetic constructor <init>(Landroid/os/PowerManager$WakeLock;Lcom/android/internal/telephony/NitzStateMachine$DeviceState;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda0;->f$0:Landroid/os/PowerManager$WakeLock;

    iput-object p2, p0, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda0;->f$1:Lcom/android/internal/telephony/NitzStateMachine$DeviceState;

    return-void
.end method


# virtual methods
.method public final mustProcessNitzSignal(Lcom/android/internal/telephony/NitzSignal;Lcom/android/internal/telephony/NitzSignal;)Ljava/lang/Boolean;
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda0;->f$0:Landroid/os/PowerManager$WakeLock;

    iget-object p0, p0, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda0;->f$1:Lcom/android/internal/telephony/NitzStateMachine$DeviceState;

    invoke-static {v0, p0, p1, p2}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory;->$r8$lambda$AFH-grvcNqec6oFVX3e6XyckO4g(Landroid/os/PowerManager$WakeLock;Lcom/android/internal/telephony/NitzStateMachine$DeviceState;Lcom/android/internal/telephony/NitzSignal;Lcom/android/internal/telephony/NitzSignal;)Ljava/lang/Boolean;

    move-result-object p0

    return-object p0
.end method
