.class Lcom/android/internal/telephony/data/DataNetworkController$3;
.super Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;
.source "DataNetworkController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/DataNetworkController;-><init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataNetworkController;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/DataNetworkController;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 855
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController$3;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onDataProfilesChanged()V
    .locals 3

    .line 858
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController$3;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_PROFILES_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const/16 v2, 0x10

    .line 859
    invoke-virtual {v0, v2, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v2

    .line 858
    invoke-virtual {v0, v2}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 861
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$3;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    const/4 v0, 0x5

    .line 862
    invoke-virtual {p0, v0, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    .line 861
    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method
