.class public final synthetic Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda5;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/DataNetwork;

.field public final synthetic f$1:I


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda5;->f$0:Lcom/android/internal/telephony/data/DataNetwork;

    iput p2, p0, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda5;->f$1:I

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda5;->f$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget p0, p0, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda5;->f$1:I

    invoke-static {v0, p0}, Lcom/android/internal/telephony/data/DataNetwork;->$r8$lambda$dwRkYI7LpD1PZk5GlgbtqK5p5OM(Lcom/android/internal/telephony/data/DataNetwork;I)V

    return-void
.end method
