.class public Lcom/pri/prizeinterphone/message/EnhanceMessage;
.super Lcom/pri/prizeinterphone/message/BaseMessage;
.source "EnhanceMessage.java"


# static fields
.field public static final CALL_PROMPT:B = 0x2t

.field public static final CHECK:B = 0x1t

.field public static final KILL:B = 0x4t

.field public static final REMOTE_MONITORING:B = 0x3t

.field public static final REVIVE:B = 0x5t


# instance fields
.field public callNum:I

.field public fun:B


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 51
    new-instance v0, Lcom/pri/prizeinterphone/protocol/Packet;

    const/16 v1, 0x28

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-void
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 0

    .line 55
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    return-void
.end method

.method public static fun2str(B)Ljava/lang/String;
    .locals 1

    const/4 v0, 0x1

    if-eq p0, v0, :cond_4

    const/4 v0, 0x2

    if-eq p0, v0, :cond_3

    const/4 v0, 0x3

    if-eq p0, v0, :cond_2

    const/4 v0, 0x4

    if-eq p0, v0, :cond_1

    const/4 v0, 0x5

    if-eq p0, v0, :cond_0

    const-string/jumbo p0, "unknown"

    return-object p0

    :cond_0
    const-string p0, "REVIVE"

    return-object p0

    :cond_1
    const-string p0, "KILL"

    return-object p0

    :cond_2
    const-string p0, "REMOTE_MONITORING"

    return-object p0

    :cond_3
    const-string p0, "CALL_PROMPT"

    return-object p0

    :cond_4
    const-string p0, "CHECK"

    return-object p0
.end method


# virtual methods
.method protected decodeBody([B)V
    .locals 1

    .line 60
    invoke-static {p1}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object p1

    sget-object v0, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {p1, v0}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object p1

    .line 61
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->get()B

    move-result v0

    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/EnhanceMessage;->fun:B

    .line 63
    :try_start_0
    invoke-virtual {p1}, Ljava/nio/ByteBuffer;->getInt()I

    move-result p1

    iput p1, p0, Lcom/pri/prizeinterphone/message/EnhanceMessage;->callNum:I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "EnhanceMessage"

    const-string v0, "decodeBody,error"

    .line 65
    invoke-static {p1, v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_0
    return-void
.end method

.method protected encodeBody()[B
    .locals 2

    const/16 v0, 0x400

    .line 71
    invoke-static {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object v0

    .line 72
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/EnhanceMessage;->fun:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 73
    iget p0, p0, Lcom/pri/prizeinterphone/message/EnhanceMessage;->callNum:I

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 74
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->getArray()[B

    move-result-object p0

    return-object p0
.end method
