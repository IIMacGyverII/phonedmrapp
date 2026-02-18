.class public final synthetic Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

.field public final synthetic f$1:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState$$ExternalSyntheticLambda1;->f$1:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState$$ExternalSyntheticLambda1;->f$1:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-static {v0, p0}, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;->$r8$lambda$zTpwxNesj_YWray_GohnsPmBukk(Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V

    return-void
.end method
