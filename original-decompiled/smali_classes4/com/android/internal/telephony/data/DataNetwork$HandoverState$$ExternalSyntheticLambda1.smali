.class public final synthetic Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/DataNetwork$HandoverState;

.field public final synthetic f$1:J

.field public final synthetic f$2:I


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/DataNetwork$HandoverState;JI)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/data/DataNetwork$HandoverState;

    iput-wide p2, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda1;->f$1:J

    iput p4, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda1;->f$2:I

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 3

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/data/DataNetwork$HandoverState;

    iget-wide v1, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda1;->f$1:J

    iget p0, p0, Lcom/android/internal/telephony/data/DataNetwork$HandoverState$$ExternalSyntheticLambda1;->f$2:I

    invoke-static {v0, v1, v2, p0}, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;->$r8$lambda$O-8Ive-khuk6zPbss0WHLtn7UxU(Lcom/android/internal/telephony/data/DataNetwork$HandoverState;JI)V

    return-void
.end method
