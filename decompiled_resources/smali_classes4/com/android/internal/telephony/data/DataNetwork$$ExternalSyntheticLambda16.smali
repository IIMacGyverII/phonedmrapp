.class public final synthetic Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda16;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/DataNetwork;

.field public final synthetic f$1:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda16;->f$0:Lcom/android/internal/telephony/data/DataNetwork;

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda16;->f$1:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda16;->f$0:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda16;->f$1:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-static {v0, p0}, Lcom/android/internal/telephony/data/DataNetwork;->$r8$lambda$IKQK1VVDj1wJCO5ObLjEdlke6-w(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V

    return-void
.end method
