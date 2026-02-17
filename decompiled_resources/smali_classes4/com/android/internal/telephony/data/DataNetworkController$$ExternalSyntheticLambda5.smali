.class public final synthetic Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda5;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/DataNetworkController;

.field public final synthetic f$1:Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda5;->f$0:Lcom/android/internal/telephony/data/DataNetworkController;

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda5;->f$1:Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda5;->f$0:Lcom/android/internal/telephony/data/DataNetworkController;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda5;->f$1:Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;

    invoke-static {v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController;->$r8$lambda$MvJmLluqs0RtFvjKGRj2pKoK3dw(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method
