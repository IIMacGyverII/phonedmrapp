.class Lcom/pri/prizeinterphone/manager/PrizePcmManager$1;
.super Ljava/lang/Thread;
.source "PrizePcmManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/manager/PrizePcmManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/manager/PrizePcmManager;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/manager/PrizePcmManager;Ljava/lang/String;)V
    .locals 0

    .line 73
    iput-object p1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager$1;->this$0:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-direct {p0, p2}, Ljava/lang/Thread;-><init>(Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 75
    :cond_0
    :goto_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager$1;->this$0:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-static {v0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->-$$Nest$fgetmIsExit(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)Z

    move-result v0

    if-nez v0, :cond_2

    .line 76
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager$1;->this$0:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-static {v0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->-$$Nest$fgetmRecordWait(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)Ljava/lang/Object;

    move-result-object v0

    monitor-enter v0

    .line 77
    :catch_0
    :goto_1
    :try_start_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager$1;->this$0:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-static {v1}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->-$$Nest$fgetmIsRecording(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)Z

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v1, :cond_1

    :try_start_1
    const-string v1, "PrizePcmManager"

    const-string v2, "mRecordThread wait"

    .line 79
    invoke-static {v1, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 80
    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager$1;->this$0:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-static {v1}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->-$$Nest$fgetmRecordWait(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->wait()V
    :try_end_1
    .catch Ljava/lang/InterruptedException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_1

    .line 84
    :cond_1
    :try_start_2
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 85
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager$1;->this$0:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-static {v0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->-$$Nest$fgetmRecord(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)Landroid/media/AudioRecord;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 86
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager$1;->this$0:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-static {v0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->-$$Nest$mrecordReadRun(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)V

    goto :goto_0

    :catchall_0
    move-exception p0

    .line 84
    :try_start_3
    monitor-exit v0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    throw p0

    :cond_2
    return-void
.end method
