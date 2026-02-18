.class Lcom/android/internal/telephony/data/DataRetryManager$1;
.super Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;
.source "DataRetryManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/DataRetryManager;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Landroid/util/SparseArray;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataRetryManager;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/DataRetryManager;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 942
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager$1;->this$0:Lcom/android/internal/telephony/data/DataRetryManager;

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onDataProfilesChanged()V
    .locals 1

    .line 945
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager$1;->this$0:Lcom/android/internal/telephony/data/DataRetryManager;

    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataRetryManager;->onReset(I)V

    return-void
.end method
