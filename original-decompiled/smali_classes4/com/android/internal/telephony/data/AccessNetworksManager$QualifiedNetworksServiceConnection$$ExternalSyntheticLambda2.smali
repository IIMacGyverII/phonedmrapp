.class public final synthetic Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;

.field public final synthetic f$1:Lcom/android/internal/telephony/dataconnection/DataThrottler;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;Lcom/android/internal/telephony/dataconnection/DataThrottler;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;

    iput-object p2, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection$$ExternalSyntheticLambda2;->f$1:Lcom/android/internal/telephony/dataconnection/DataThrottler;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection$$ExternalSyntheticLambda2;->f$1:Lcom/android/internal/telephony/dataconnection/DataThrottler;

    invoke-static {v0, p0}, Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;->$r8$lambda$e80T_sxlA1er0SNZzkLMKPYoH1Y(Lcom/android/internal/telephony/data/AccessNetworksManager$QualifiedNetworksServiceConnection;Lcom/android/internal/telephony/dataconnection/DataThrottler;)V

    return-void
.end method
