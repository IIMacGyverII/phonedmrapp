.class public final synthetic Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/DataNetwork$HandoverState;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/DataNetwork$HandoverState;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/data/DataNetwork$HandoverState;

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/data/DataNetwork$HandoverState;

    check-cast p1, Landroid/telephony/data/DataCallResponse;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->$r8$lambda$CZ3BN1LVU1spd2TKn6O-mGa49mk(Lcom/android/internal/telephony/data/DataNetwork$HandoverState;Landroid/telephony/data/DataCallResponse;)Z

    move-result p0

    return p0
.end method
