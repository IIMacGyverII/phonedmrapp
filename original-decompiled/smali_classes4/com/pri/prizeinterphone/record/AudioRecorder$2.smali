.class Lcom/pri/prizeinterphone/record/AudioRecorder$2;
.super Ljava/lang/Object;
.source "AudioRecorder.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/record/AudioRecorder;->mergePCMFilesToWAVFile(Ljava/util/List;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/record/AudioRecorder;

.field final synthetic val$filePaths:Ljava/util/List;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/record/AudioRecorder;Ljava/util/List;)V
    .locals 0

    .line 257
    iput-object p1, p0, Lcom/pri/prizeinterphone/record/AudioRecorder$2;->this$0:Lcom/pri/prizeinterphone/record/AudioRecorder;

    iput-object p2, p0, Lcom/pri/prizeinterphone/record/AudioRecorder$2;->val$filePaths:Ljava/util/List;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 260
    iget-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder$2;->val$filePaths:Ljava/util/List;

    iget-object v1, p0, Lcom/pri/prizeinterphone/record/AudioRecorder$2;->this$0:Lcom/pri/prizeinterphone/record/AudioRecorder;

    invoke-static {v1}, Lcom/pri/prizeinterphone/record/AudioRecorder;->-$$Nest$fgetfileName(Lcom/pri/prizeinterphone/record/AudioRecorder;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/pri/prizeinterphone/record/FileUtil;->getWavFileAbsolutePath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/record/PcmToWav;->mergePCMFilesToWAVFile(Ljava/util/List;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 267
    iget-object p0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder$2;->this$0:Lcom/pri/prizeinterphone/record/AudioRecorder;

    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/pri/prizeinterphone/record/AudioRecorder;->-$$Nest$fputfileName(Lcom/pri/prizeinterphone/record/AudioRecorder;Ljava/lang/String;)V

    return-void

    :cond_0
    const-string p0, "AudioRecorder"

    const-string v0, "mergePCMFilesToWAVFile fail"

    .line 264
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 265
    new-instance p0, Ljava/lang/IllegalStateException;

    invoke-direct {p0, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
