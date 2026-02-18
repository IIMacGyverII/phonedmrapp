.class public final synthetic Lcom/android/internal/telephony/dataconnection/DataServiceManager$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

.field public final synthetic f$1:Ljava/util/concurrent/CountDownLatch;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Ljava/util/concurrent/CountDownLatch;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    iput-object p2, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$$ExternalSyntheticLambda1;->f$1:Ljava/util/concurrent/CountDownLatch;

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataServiceManager$$ExternalSyntheticLambda1;->f$1:Ljava/util/concurrent/CountDownLatch;

    check-cast p1, Ljava/lang/Boolean;

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->$r8$lambda$yxYmAEwpmTWYaQPbp3Uh2wJFsiE(Lcom/android/internal/telephony/dataconnection/DataServiceManager;Ljava/util/concurrent/CountDownLatch;Ljava/lang/Boolean;)V

    return-void
.end method
