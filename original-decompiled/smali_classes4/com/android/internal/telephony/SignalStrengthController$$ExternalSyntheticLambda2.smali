.class public final synthetic Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/Comparator;


# instance fields
.field public final synthetic f$0:I


# direct methods
.method public synthetic constructor <init>(I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda2;->f$0:I

    return-void
.end method


# virtual methods
.method public final compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda2;->f$0:I

    check-cast p1, Ljava/lang/Integer;

    check-cast p2, Ljava/lang/Integer;

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/SignalStrengthController;->$r8$lambda$4Hz8txT3RiS7V8_46FdgzXN6650(ILjava/lang/Integer;Ljava/lang/Integer;)I

    move-result p0

    return p0
.end method
