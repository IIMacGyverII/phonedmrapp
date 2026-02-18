.class public Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;
.super Ljava/lang/Object;
.source "AsyncPacketWriter.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/codec/AsyncPacketWriter$WriteTask;
    }
.end annotation


# instance fields
.field private final executor:Ljava/util/concurrent/Executor;

.field private final serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;


# direct methods
.method static bridge synthetic -$$Nest$fgetserial(Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;)Lcom/pri/prizeinterphone/serial/port/SerialPort;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    return-object p0
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/serial/port/SerialPort;)V
    .locals 1

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 16
    sget-object v0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->INSTANCE:Lcom/pri/prizeinterphone/Util/ExecutorManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ExecutorManager;->getWriteThread()Ljava/util/concurrent/ThreadPoolExecutor;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;->executor:Ljava/util/concurrent/Executor;

    .line 22
    iput-object p1, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    return-void
.end method


# virtual methods
.method public write(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 2

    .line 26
    iget-object v0, p0, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;->executor:Ljava/util/concurrent/Executor;

    new-instance v1, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter$WriteTask;

    invoke-direct {v1, p0, p1}, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter$WriteTask;-><init>(Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;Lcom/pri/prizeinterphone/protocol/Packet;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    return-void
.end method
