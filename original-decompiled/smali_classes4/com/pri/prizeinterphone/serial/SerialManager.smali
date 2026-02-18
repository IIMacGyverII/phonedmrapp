.class public Lcom/pri/prizeinterphone/serial/SerialManager;
.super Ljava/lang/Object;
.source "SerialManager.java"


# static fields
.field public static final TAG:Ljava/lang/String; = "TAG_SerialManager"

.field private static volatile instance:Lcom/pri/prizeinterphone/serial/SerialManager;


# instance fields
.field private reader:Lcom/pri/prizeinterphone/codec/AsyncPacketReader;

.field private receiver:Lcom/pri/prizeinterphone/serial/MessageDispatcher;

.field private serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

.field private writer:Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/serial/SerialManager;
    .locals 2

    .line 24
    sget-object v0, Lcom/pri/prizeinterphone/serial/SerialManager;->instance:Lcom/pri/prizeinterphone/serial/SerialManager;

    if-nez v0, :cond_1

    .line 25
    const-class v0, Lcom/pri/prizeinterphone/serial/SerialManager;

    monitor-enter v0

    .line 26
    :try_start_0
    sget-object v1, Lcom/pri/prizeinterphone/serial/SerialManager;->instance:Lcom/pri/prizeinterphone/serial/SerialManager;

    if-nez v1, :cond_0

    .line 27
    new-instance v1, Lcom/pri/prizeinterphone/serial/SerialManager;

    invoke-direct {v1}, Lcom/pri/prizeinterphone/serial/SerialManager;-><init>()V

    sput-object v1, Lcom/pri/prizeinterphone/serial/SerialManager;->instance:Lcom/pri/prizeinterphone/serial/SerialManager;

    .line 29
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 31
    :cond_1
    :goto_0
    sget-object v0, Lcom/pri/prizeinterphone/serial/SerialManager;->instance:Lcom/pri/prizeinterphone/serial/SerialManager;

    return-object v0
.end method


# virtual methods
.method public getSerial()Lcom/pri/prizeinterphone/serial/port/SerialPort;
    .locals 1

    .line 58
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    if-nez v0, :cond_0

    .line 59
    new-instance v0, Lcom/pri/prizeinterphone/serial/port/SerialPort;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/serial/port/SerialPort;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    .line 61
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->open()Z

    .line 62
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    return-object p0
.end method

.method public init()Z
    .locals 4

    .line 35
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "init(),"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TAG_SerialManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 36
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    if-nez v0, :cond_0

    .line 37
    new-instance v0, Lcom/pri/prizeinterphone/serial/port/SerialPort;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/serial/port/SerialPort;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    .line 39
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->open()Z

    move-result v0

    if-eqz v0, :cond_4

    .line 41
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->receiver:Lcom/pri/prizeinterphone/serial/MessageDispatcher;

    if-nez v1, :cond_1

    .line 42
    new-instance v1, Lcom/pri/prizeinterphone/serial/MessageDispatcher;

    invoke-direct {v1}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;-><init>()V

    iput-object v1, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->receiver:Lcom/pri/prizeinterphone/serial/MessageDispatcher;

    .line 44
    :cond_1
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->reader:Lcom/pri/prizeinterphone/codec/AsyncPacketReader;

    if-nez v1, :cond_2

    .line 45
    new-instance v1, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;

    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    iget-object v3, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->receiver:Lcom/pri/prizeinterphone/serial/MessageDispatcher;

    invoke-direct {v1, v2, v3}, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;-><init>(Lcom/pri/prizeinterphone/serial/port/SerialPort;Lcom/pri/prizeinterphone/serial/PacketReceiver;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->reader:Lcom/pri/prizeinterphone/codec/AsyncPacketReader;

    .line 47
    :cond_2
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->writer:Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;

    if-nez v1, :cond_3

    .line 48
    new-instance v1, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;

    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    invoke-direct {v1, v2}, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;-><init>(Lcom/pri/prizeinterphone/serial/port/SerialPort;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->writer:Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;

    .line 50
    :cond_3
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->reader:Lcom/pri/prizeinterphone/codec/AsyncPacketReader;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->isStop()Z

    move-result v1

    if-eqz v1, :cond_4

    .line 51
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->reader:Lcom/pri/prizeinterphone/codec/AsyncPacketReader;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->startRead()V

    :cond_4
    return v0
.end method

.method public release()V
    .locals 2

    .line 66
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "release(),"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TAG_SerialManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 67
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/SerialManager;->releaseReader()V

    .line 68
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/SerialManager;->releaseWriter()V

    .line 69
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/SerialManager;->releaseSerial()V

    const/4 p0, 0x0

    .line 70
    sput-object p0, Lcom/pri/prizeinterphone/serial/SerialManager;->instance:Lcom/pri/prizeinterphone/serial/SerialManager;

    return-void
.end method

.method public releaseReader()V
    .locals 2

    .line 82
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "releaseReader(),"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TAG_SerialManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 83
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->reader:Lcom/pri/prizeinterphone/codec/AsyncPacketReader;

    if-eqz v0, :cond_0

    .line 84
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/codec/AsyncPacketReader;->stopRead()V

    const/4 v0, 0x0

    .line 85
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->reader:Lcom/pri/prizeinterphone/codec/AsyncPacketReader;

    :cond_0
    return-void
.end method

.method public releaseSerial()V
    .locals 2

    .line 74
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "releaseSerial(),"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TAG_SerialManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 75
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    if-eqz v0, :cond_0

    .line 76
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->release()V

    const/4 v0, 0x0

    .line 77
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    :cond_0
    return-void
.end method

.method public releaseWriter()V
    .locals 2

    .line 90
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "releaseWriter()"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TAG_SerialManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 91
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->writer:Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;

    if-eqz v0, :cond_0

    const/4 v0, 0x0

    .line 92
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->reader:Lcom/pri/prizeinterphone/codec/AsyncPacketReader;

    :cond_0
    return-void
.end method

.method public send(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 2

    .line 97
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "packet = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TAG_SerialManager"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 98
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->isConnected()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 99
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/SerialManager;->writer:Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/codec/AsyncPacketWriter;->write(Lcom/pri/prizeinterphone/protocol/Packet;)V

    :cond_0
    return-void
.end method
