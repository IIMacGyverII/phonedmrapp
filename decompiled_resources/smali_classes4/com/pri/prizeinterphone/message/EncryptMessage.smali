.class public Lcom/pri/prizeinterphone/message/EncryptMessage;
.super Lcom/pri/prizeinterphone/message/BaseMessage;
.source "EncryptMessage.java"


# instance fields
.field public aesKey:[B

.field public fun:B

.field private final random:Ljava/security/SecureRandom;

.field public sw:B


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 18
    new-instance v0, Lcom/pri/prizeinterphone/protocol/Packet;

    const/16 v1, 0x29

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/protocol/Packet;-><init>(B)V

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const/4 v0, 0x1

    .line 14
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->fun:B

    .line 15
    new-instance v0, Ljava/security/SecureRandom;

    invoke-direct {v0}, Ljava/security/SecureRandom;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->random:Ljava/security/SecureRandom;

    return-void
.end method

.method public constructor <init>(Lcom/pri/prizeinterphone/protocol/Packet;)V
    .locals 0

    .line 22
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/message/BaseMessage;-><init>(Lcom/pri/prizeinterphone/protocol/Packet;)V

    const/4 p1, 0x1

    .line 14
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->fun:B

    .line 15
    new-instance p1, Ljava/security/SecureRandom;

    invoke-direct {p1}, Ljava/security/SecureRandom;-><init>()V

    iput-object p1, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->random:Ljava/security/SecureRandom;

    return-void
.end method

.method public static buildEnableEncryptKey(I)Lcom/pri/prizeinterphone/message/EncryptMessage;
    .locals 4

    const/16 v0, 0x10

    const/16 v1, 0x8

    if-eq p0, v1, :cond_1

    if-eq p0, v0, :cond_1

    const/16 v2, 0x20

    if-ne p0, v2, :cond_0

    goto :goto_0

    .line 63
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string/jumbo v0, "\u5bc6\u94a5\u9519\u8bef\uff0c \u53ea\u80fd\u662f 8\u4f4d\uff0c16\u4f4d \u548c32 \u4f4d"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 64
    :cond_1
    :goto_0
    new-instance v2, Lcom/pri/prizeinterphone/message/EncryptMessage;

    invoke-direct {v2}, Lcom/pri/prizeinterphone/message/EncryptMessage;-><init>()V

    const/4 v3, 0x1

    .line 65
    iput-byte v3, v2, Lcom/pri/prizeinterphone/message/EncryptMessage;->sw:B

    if-ne p0, v1, :cond_2

    .line 67
    iput-byte v3, v2, Lcom/pri/prizeinterphone/message/EncryptMessage;->fun:B

    goto :goto_2

    :cond_2
    if-ne p0, v0, :cond_3

    const/4 v0, 0x3

    goto :goto_1

    :cond_3
    const/4 v0, 0x4

    :goto_1
    int-to-byte v0, v0

    .line 69
    iput-byte v0, v2, Lcom/pri/prizeinterphone/message/EncryptMessage;->fun:B

    .line 71
    :goto_2
    new-array p0, p0, [B

    .line 72
    iget-object v0, v2, Lcom/pri/prizeinterphone/message/EncryptMessage;->random:Ljava/security/SecureRandom;

    invoke-virtual {v0, p0}, Ljava/security/SecureRandom;->nextBytes([B)V

    .line 73
    iput-object p0, v2, Lcom/pri/prizeinterphone/message/EncryptMessage;->aesKey:[B

    return-object v2
.end method

.method public static buildQueryEncryptKey()Lcom/pri/prizeinterphone/message/EncryptMessage;
    .locals 2

    .line 78
    new-instance v0, Lcom/pri/prizeinterphone/message/EncryptMessage;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/message/EncryptMessage;-><init>()V

    const/4 v1, 0x0

    .line 79
    iput-byte v1, v0, Lcom/pri/prizeinterphone/message/EncryptMessage;->fun:B

    return-object v0
.end method


# virtual methods
.method protected decodeBody([B)V
    .locals 0

    return-void
.end method

.method public disableEncrypt()V
    .locals 1

    const/4 v0, 0x2

    .line 58
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->sw:B

    return-void
.end method

.method public enableEncrypt([B)V
    .locals 3

    const/4 v0, 0x1

    .line 44
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->sw:B

    .line 45
    iput-object p1, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->aesKey:[B

    .line 46
    array-length v1, p1

    const/16 v2, 0x8

    if-ne v1, v2, :cond_0

    .line 47
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->fun:B

    goto :goto_0

    .line 48
    :cond_0
    array-length v0, p1

    const/16 v1, 0x10

    if-ne v0, v1, :cond_1

    const/4 p1, 0x3

    .line 49
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->fun:B

    goto :goto_0

    .line 50
    :cond_1
    array-length p1, p1

    const/16 v0, 0x20

    if-ne p1, v0, :cond_2

    const/4 p1, 0x4

    .line 51
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->fun:B

    :goto_0
    return-void

    .line 53
    :cond_2
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string/jumbo p1, "\u5bc6\u94a5\u9519\u8bef\uff0c \u53ea\u80fd\u662f 8\u4f4d\uff0c16\u4f4d \u548c32 \u4f4d"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method protected encodeBody()[B
    .locals 3

    const/16 v0, 0x400

    .line 32
    invoke-static {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    move-result-object v0

    .line 33
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->fun:B

    const/4 v2, 0x3

    if-eq v1, v2, :cond_0

    const/4 v2, 0x4

    if-eq v1, v2, :cond_0

    if-nez v1, :cond_1

    .line 34
    :cond_0
    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 36
    :cond_1
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->fun:B

    if-eqz v1, :cond_2

    .line 37
    iget-byte v1, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->sw:B

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 38
    iget-object p0, p0, Lcom/pri/prizeinterphone/message/EncryptMessage;->aesKey:[B

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->put([B)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 40
    :cond_2
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->getArray()[B

    move-result-object p0

    return-object p0
.end method
