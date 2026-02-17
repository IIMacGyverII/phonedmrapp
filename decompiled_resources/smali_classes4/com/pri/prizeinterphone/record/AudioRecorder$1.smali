.class Lcom/pri/prizeinterphone/record/AudioRecorder$1;
.super Ljava/lang/Object;
.source "AudioRecorder.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/record/AudioRecorder;->startRecord(Lcom/pri/prizeinterphone/record/RecordStreamListener;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/record/AudioRecorder;

.field final synthetic val$listener:Lcom/pri/prizeinterphone/record/RecordStreamListener;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/record/AudioRecorder;Lcom/pri/prizeinterphone/record/RecordStreamListener;)V
    .locals 0

    .line 109
    iput-object p1, p0, Lcom/pri/prizeinterphone/record/AudioRecorder$1;->this$0:Lcom/pri/prizeinterphone/record/AudioRecorder;

    iput-object p2, p0, Lcom/pri/prizeinterphone/record/AudioRecorder$1;->val$listener:Lcom/pri/prizeinterphone/record/RecordStreamListener;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 112
    iget-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder$1;->this$0:Lcom/pri/prizeinterphone/record/AudioRecorder;

    iget-object p0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder$1;->val$listener:Lcom/pri/prizeinterphone/record/RecordStreamListener;

    invoke-static {v0, p0}, Lcom/pri/prizeinterphone/record/AudioRecorder;->-$$Nest$mwriteDataTOFile(Lcom/pri/prizeinterphone/record/AudioRecorder;Lcom/pri/prizeinterphone/record/RecordStreamListener;)V

    return-void
.end method
