.class public final synthetic Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;

    check-cast p1, Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->$r8$lambda$z7oDEz23l3J_ZEiQA8PurcLrADA(Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworks;Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;)V

    return-void
.end method
