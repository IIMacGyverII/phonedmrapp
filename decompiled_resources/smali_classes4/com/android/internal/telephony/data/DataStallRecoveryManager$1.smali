.class Lcom/android/internal/telephony/data/DataStallRecoveryManager$1;
.super Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;
.source "DataStallRecoveryManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/DataStallRecoveryManager;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataStallRecoveryManager$DataStallRecoveryManagerCallback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataStallRecoveryManager;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/DataStallRecoveryManager;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 230
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager$1;->this$0:Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onDataEnabledChanged(ZILjava/lang/String;)V
    .locals 0

    .line 236
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager$1;->this$0:Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->-$$Nest$monMobileDataEnabledChanged(Lcom/android/internal/telephony/data/DataStallRecoveryManager;Z)V

    return-void
.end method
