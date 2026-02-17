.class Lcom/pri/prizeinterphone/record/AudioRecorder$3;
.super Ljava/lang/Object;
.source "AudioRecorder.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/record/AudioRecorder;->makePCMFileToWAVFile()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/record/AudioRecorder;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/record/AudioRecorder;)V
    .locals 0

    .line 276
    iput-object p1, p0, Lcom/pri/prizeinterphone/record/AudioRecorder$3;->this$0:Lcom/pri/prizeinterphone/record/AudioRecorder;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 279
    iget-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder$3;->this$0:Lcom/pri/prizeinterphone/record/AudioRecorder;

    invoke-static {v0}, Lcom/pri/prizeinterphone/record/AudioRecorder;->-$$Nest$fgetfileName(Lcom/pri/prizeinterphone/record/AudioRecorder;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/pri/prizeinterphone/record/FileUtil;->getPcmFileAbsolutePath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/pri/prizeinterphone/record/AudioRecorder$3;->this$0:Lcom/pri/prizeinterphone/record/AudioRecorder;

    invoke-static {v1}, Lcom/pri/prizeinterphone/record/AudioRecorder;->-$$Nest$fgetfileName(Lcom/pri/prizeinterphone/record/AudioRecorder;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/pri/prizeinterphone/record/FileUtil;->getWavFileAbsolutePath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x1

    invoke-static {v0, v1, v2}, Lcom/pri/prizeinterphone/record/PcmToWav;->makePCMFileToWAVFile(Ljava/lang/String;Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 286
    iget-object p0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder$3;->this$0:Lcom/pri/prizeinterphone/record/AudioRecorder;

    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/pri/prizeinterphone/record/AudioRecorder;->-$$Nest$fputfileName(Lcom/pri/prizeinterphone/record/AudioRecorder;Ljava/lang/String;)V

    return-void

    :cond_0
    const-string p0, "AudioRecorder"

    const-string v0, "makePCMFileToWAVFile fail"

    .line 283
    invoke-static {p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 284
    new-instance p0, Ljava/lang/IllegalStateException;

    invoke-direct {p0, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
