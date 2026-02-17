.class public final Lcom/pri/prizeinterphone/serial/MessageDispatcher;
.super Ljava/lang/Object;
.source "MessageDispatcher.java"

# interfaces
.implements Lcom/pri/prizeinterphone/serial/PacketReceiver;


# static fields
.field public static final TAG:Ljava/lang/String; = "TAG_MessageDispatcher"


# instance fields
.field private final executor:Ljava/util/concurrent/Executor;

.field private final handlers:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Byte;",
            "Lcom/pri/prizeinterphone/handler/MessageHandler;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$wSLWPLuOQNvoOsmQmJJqwCRxj9U(Lcom/pri/prizeinterphone/handler/MessageHandler;Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->lambda$onReceive$0(Lcom/pri/prizeinterphone/handler/MessageHandler;Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 48
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 45
    sget-object v0, Lcom/pri/prizeinterphone/Util/ExecutorManager;->INSTANCE:Lcom/pri/prizeinterphone/Util/ExecutorManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ExecutorManager;->getDispatchThread()Ljava/util/concurrent/ThreadPoolExecutor;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->executor:Ljava/util/concurrent/Executor;

    .line 46
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->handlers:Ljava/util/Map;

    .line 49
    new-instance v0, Lcom/pri/prizeinterphone/handler/InitMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/InitMessageHandler;-><init>()V

    const/16 v1, -0x56

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 51
    new-instance v0, Lcom/pri/prizeinterphone/handler/DigitalMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/DigitalMessageHandler;-><init>()V

    const/16 v1, 0x22

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 52
    new-instance v0, Lcom/pri/prizeinterphone/handler/AnalogMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/AnalogMessageHandler;-><init>()V

    const/16 v1, 0x23

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 53
    new-instance v0, Lcom/pri/prizeinterphone/handler/DigitalMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/DigitalMessageHandler;-><init>()V

    const/16 v1, 0x24

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 54
    new-instance v0, Lcom/pri/prizeinterphone/handler/AnalogMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/AnalogMessageHandler;-><init>()V

    const/16 v1, 0x25

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 55
    new-instance v0, Lcom/pri/prizeinterphone/handler/LaunchMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/LaunchMessageHandler;-><init>()V

    const/16 v1, 0x26

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 56
    new-instance v0, Lcom/pri/prizeinterphone/handler/QueryInitMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/QueryInitMessageHandler;-><init>()V

    const/16 v1, 0x27

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 57
    new-instance v0, Lcom/pri/prizeinterphone/handler/EnhanceMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/EnhanceMessageHandler;-><init>()V

    const/16 v1, 0x28

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 58
    new-instance v0, Lcom/pri/prizeinterphone/handler/EncryptMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/EncryptMessageHandler;-><init>()V

    const/16 v1, 0x29

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 59
    new-instance v0, Lcom/pri/prizeinterphone/handler/MicMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/MicMessageHandler;-><init>()V

    const/16 v1, 0x2a

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 60
    new-instance v0, Lcom/pri/prizeinterphone/handler/DigitalAudioMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/DigitalAudioMessageHandler;-><init>()V

    const/16 v1, 0x2b

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 61
    new-instance v0, Lcom/pri/prizeinterphone/handler/SendSmsMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/SendSmsMessageHandler;-><init>()V

    const/16 v1, 0x2c

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 62
    new-instance v0, Lcom/pri/prizeinterphone/handler/FetchSmsMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/FetchSmsMessageHandler;-><init>()V

    const/16 v1, 0x2d

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 63
    new-instance v0, Lcom/pri/prizeinterphone/handler/VolumeMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/VolumeMessageHandler;-><init>()V

    const/16 v1, 0x2e

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 64
    new-instance v0, Lcom/pri/prizeinterphone/handler/SquelchMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/SquelchMessageHandler;-><init>()V

    const/16 v1, 0x30

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 65
    new-instance v0, Lcom/pri/prizeinterphone/handler/MonitorMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/MonitorMessageHandler;-><init>()V

    const/16 v1, 0x2f

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 66
    new-instance v0, Lcom/pri/prizeinterphone/handler/PowerSaveMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/PowerSaveMessageHandler;-><init>()V

    const/16 v1, 0x31

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 67
    new-instance v0, Lcom/pri/prizeinterphone/handler/SignalMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/SignalMessageHandler;-><init>()V

    const/16 v1, 0x32

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 68
    new-instance v0, Lcom/pri/prizeinterphone/handler/RelayMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/RelayMessageHandler;-><init>()V

    const/16 v1, 0x33

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 69
    new-instance v0, Lcom/pri/prizeinterphone/handler/VersionMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/VersionMessageHandler;-><init>()V

    const/16 v1, 0x34

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 70
    new-instance v0, Lcom/pri/prizeinterphone/handler/InterruptMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/InterruptMessageHandler;-><init>()V

    const/16 v1, 0x35

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 71
    new-instance v0, Lcom/pri/prizeinterphone/handler/ModuleStatusMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/ModuleStatusMessageHandler;-><init>()V

    const/16 v1, 0x36

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 72
    new-instance v0, Lcom/pri/prizeinterphone/handler/PolicyMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/PolicyMessageHandler;-><init>()V

    const/16 v1, 0x37

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 73
    new-instance v0, Lcom/pri/prizeinterphone/handler/MixCheckMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/MixCheckMessageHandler;-><init>()V

    const/16 v1, 0x38

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 74
    new-instance v0, Lcom/pri/prizeinterphone/handler/SmsProtocolMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/SmsProtocolMessageHandler;-><init>()V

    const/16 v1, 0x3a

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 75
    new-instance v0, Lcom/pri/prizeinterphone/handler/TotMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/TotMessageHandler;-><init>()V

    const/16 v1, 0x3b

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    .line 76
    new-instance v0, Lcom/pri/prizeinterphone/handler/TestBiteErrorRateMessageHandler;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/handler/TestBiteErrorRateMessageHandler;-><init>()V

    const/16 v1, 0x3f

    invoke-virtual {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V

    return-void
.end method

.method private static synthetic lambda$onReceive$0(Lcom/pri/prizeinterphone/handler/MessageHandler;Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 0

    .line 89
    invoke-interface {p0, p1}, Lcom/pri/prizeinterphone/handler/MessageHandler;->handle(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-void
.end method


# virtual methods
.method public onReceive(Lcom/pri/prizeinterphone/protocol/Packet;Lcom/pri/prizeinterphone/serial/port/SerialPort;)V
    .locals 2

    .line 86
    iget-object p2, p0, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->handlers:Ljava/util/Map;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/protocol/Packet;->getCmd()B

    move-result v0

    invoke-static {v0}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/pri/prizeinterphone/handler/MessageHandler;

    .line 87
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onReceive: handler "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "TAG_MessageDispatcher"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz p2, :cond_0

    .line 89
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->executor:Ljava/util/concurrent/Executor;

    new-instance v0, Lcom/pri/prizeinterphone/serial/MessageDispatcher$$ExternalSyntheticLambda0;

    invoke-direct {v0, p2, p1}, Lcom/pri/prizeinterphone/serial/MessageDispatcher$$ExternalSyntheticLambda0;-><init>(Lcom/pri/prizeinterphone/handler/MessageHandler;Lcom/pri/prizeinterphone/protocol/Packet;)V

    invoke-interface {p0, v0}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V

    :cond_0
    return-void
.end method

.method public register(BLcom/pri/prizeinterphone/handler/MessageHandler;)V
    .locals 0

    .line 81
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/MessageDispatcher;->handlers:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object p1

    invoke-interface {p0, p1, p2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method
