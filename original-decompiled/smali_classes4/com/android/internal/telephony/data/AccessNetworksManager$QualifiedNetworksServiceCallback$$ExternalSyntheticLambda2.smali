.class public final synthetic Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceCallback$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;

.field public final synthetic f$1:I


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceCallback$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;

    iput p2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceCallback$$ExternalSyntheticLambda2;->f$1:I

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceCallback$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;

    iget p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceCallback$$ExternalSyntheticLambda2;->f$1:I

    invoke-static {v0, p0}, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceCallback;->$r8$lambda$3Py07wBHNfQJ0MrhbNjs7kKsNdE(Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;I)V

    return-void
.end method
