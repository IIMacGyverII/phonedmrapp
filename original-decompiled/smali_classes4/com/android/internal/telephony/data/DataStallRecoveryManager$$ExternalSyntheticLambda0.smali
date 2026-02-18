.class public final synthetic Lcom/android/internal/telephony/data/DataStallRecoveryManager$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/concurrent/Executor;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/DataStallRecoveryManager;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/DataStallRecoveryManager;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    return-void
.end method


# virtual methods
.method public final execute(Ljava/lang/Runnable;)V
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
