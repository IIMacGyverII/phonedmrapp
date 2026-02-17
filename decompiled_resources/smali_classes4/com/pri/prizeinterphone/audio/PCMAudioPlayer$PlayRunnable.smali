.class Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;
.super Ljava/lang/Object;
.source "PCMAudioPlayer.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "PlayRunnable"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;


# direct methods
.method private constructor <init>(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)V
    .locals 0

    .line 116
    iput-object p1, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;->this$0:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;-><init>(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    const/16 v0, -0x13

    .line 120
    :try_start_0
    invoke-static {v0}, Landroid/os/Process;->setThreadPriority(I)V

    .line 121
    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;->this$0:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    invoke-static {v0}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->-$$Nest$fgetmMinBufferSize(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)I

    move-result v0

    new-array v0, v0, [B

    .line 123
    iget-object v1, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;->this$0:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    invoke-static {v1}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->-$$Nest$fgetaudioTrack(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)Landroid/media/AudioTrack;

    move-result-object v1

    invoke-virtual {v1}, Landroid/media/AudioTrack;->play()V

    .line 124
    :cond_0
    :goto_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;->this$0:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    invoke-static {v1}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->-$$Nest$fgetdis(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)Ljava/io/DataInputStream;

    move-result-object v1

    invoke-virtual {v1}, Ljava/io/DataInputStream;->available()I

    move-result v1

    if-lez v1, :cond_2

    iget-object v1, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;->this$0:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    invoke-static {v1}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->-$$Nest$fgetisPlay(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)Z

    move-result v1

    if-eqz v1, :cond_2

    iget-object v1, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;->this$0:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    invoke-static {v1}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->-$$Nest$misTalkSend(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)Z

    move-result v1

    if-nez v1, :cond_2

    .line 125
    iget-object v1, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;->this$0:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    invoke-static {v1}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->-$$Nest$fgetdis(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)Ljava/io/DataInputStream;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/io/DataInputStream;->read([B)I

    move-result v1

    const/4 v2, -0x3

    if-eq v1, v2, :cond_0

    const/4 v2, -0x2

    if-ne v1, v2, :cond_1

    goto :goto_0

    :cond_1
    if-eqz v1, :cond_0

    const/4 v2, -0x1

    if-eq v1, v2, :cond_0

    .line 130
    iget-object v2, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;->this$0:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    invoke-static {v2}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->-$$Nest$fgetaudioTrack(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)Landroid/media/AudioTrack;

    move-result-object v2

    const/4 v3, 0x0

    invoke-virtual {v2, v0, v3, v1}, Landroid/media/AudioTrack;->write([BII)I

    goto :goto_0

    .line 133
    :cond_2
    iget-object p0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;->this$0:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->stopPlay()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception p0

    .line 135
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    :goto_1
    return-void
.end method
