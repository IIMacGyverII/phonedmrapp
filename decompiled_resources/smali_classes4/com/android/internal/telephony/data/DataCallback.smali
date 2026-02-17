.class public Lcom/android/internal/telephony/data/DataCallback;
.super Ljava/lang/Object;
.source "DataCallback.java"


# instance fields
.field private final mExecutor:Ljava/util/concurrent/Executor;


# direct methods
.method public constructor <init>(Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 39
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataCallback;->mExecutor:Ljava/util/concurrent/Executor;

    return-void
.end method


# virtual methods
.method public getExecutor()Ljava/util/concurrent/Executor;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 47
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataCallback;->mExecutor:Ljava/util/concurrent/Executor;

    return-object p0
.end method

.method public invokeFromExecutor(Ljava/lang/Runnable;)V
    .locals 0

    .line 56
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataCallback;->mExecutor:Ljava/util/concurrent/Executor;

    invoke-interface {p0, p1}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    return-void
.end method
