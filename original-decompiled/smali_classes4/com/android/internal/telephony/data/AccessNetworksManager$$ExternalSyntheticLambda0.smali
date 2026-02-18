.class public final synthetic Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;

.field public final synthetic f$1:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;

    iput-object p2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda0;->f$1:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda0;->f$1:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;

    invoke-static {v0, p0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->$r8$lambda$KmLqnfX0vxiGY8gFbWZg6FNz-Hw(Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;)V

    return-void
.end method
