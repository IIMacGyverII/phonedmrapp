.class public final Lcom/pri/prizeinterphone/Util/ByteBuf;
.super Ljava/lang/Object;
.source "ByteBuf.java"


# instance fields
.field private tmpNioBuf:Ljava/nio/ByteBuffer;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 26
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static allocate(I)Lcom/pri/prizeinterphone/Util/ByteBuf;
    .locals 2

    .line 30
    new-instance v0, Lcom/pri/prizeinterphone/Util/ByteBuf;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;-><init>()V

    .line 31
    invoke-static {p0}, Ljava/nio/ByteBuffer;->allocate(I)Ljava/nio/ByteBuffer;

    move-result-object p0

    sget-object v1, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {p0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object p0

    iput-object p0, v0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    return-object v0
.end method

.method public static allocateDirect(I)Lcom/pri/prizeinterphone/Util/ByteBuf;
    .locals 2

    .line 36
    new-instance v0, Lcom/pri/prizeinterphone/Util/ByteBuf;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;-><init>()V

    .line 37
    invoke-static {p0}, Ljava/nio/ByteBuffer;->allocateDirect(I)Ljava/nio/ByteBuffer;

    move-result-object p0

    sget-object v1, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {p0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object p0

    iput-object p0, v0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    return-object v0
.end method

.method private newCapacity(I)I
    .locals 0

    const/16 p0, 0x40

    :goto_0
    if-ge p0, p1, :cond_0

    shl-int/lit8 p0, p0, 0x1

    goto :goto_0

    :cond_0
    return p0
.end method

.method public static wrap([B)Lcom/pri/prizeinterphone/Util/ByteBuf;
    .locals 2

    .line 42
    new-instance v0, Lcom/pri/prizeinterphone/Util/ByteBuf;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;-><init>()V

    .line 43
    invoke-static {p0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object p0

    sget-object v1, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {p0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object p0

    iput-object p0, v0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    return-object v0
.end method


# virtual methods
.method public checkCapacity(I)Lcom/pri/prizeinterphone/Util/ByteBuf;
    .locals 1

    .line 107
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v0

    if-ge v0, p1, :cond_1

    .line 109
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->capacity()I

    move-result v0

    add-int/2addr v0, p1

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->newCapacity(I)I

    move-result p1

    .line 110
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->isDirect()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {p1}, Ljava/nio/ByteBuffer;->allocateDirect(I)Ljava/nio/ByteBuffer;

    move-result-object p1

    goto :goto_0

    :cond_0
    invoke-static {p1}, Ljava/nio/ByteBuffer;->allocate(I)Ljava/nio/ByteBuffer;

    move-result-object p1

    .line 111
    :goto_0
    sget-object v0, Ljava/nio/ByteOrder;->LITTLE_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {p1, v0}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    .line 112
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->flip()Ljava/nio/Buffer;

    .line 113
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {p1, v0}, Ljava/nio/ByteBuffer;->put(Ljava/nio/ByteBuffer;)Ljava/nio/ByteBuffer;

    .line 114
    iput-object p1, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    :cond_1
    return-object p0
.end method

.method public clear()Lcom/pri/prizeinterphone/Util/ByteBuf;
    .locals 1

    .line 132
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->clear()Ljava/nio/Buffer;

    return-object p0
.end method

.method public flip()Lcom/pri/prizeinterphone/Util/ByteBuf;
    .locals 1

    .line 137
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->flip()Ljava/nio/Buffer;

    return-object p0
.end method

.method public get()B
    .locals 0

    .line 61
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->get()B

    move-result p0

    return p0
.end method

.method public get([B)Lcom/pri/prizeinterphone/Util/ByteBuf;
    .locals 1

    .line 56
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v0, p1}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    return-object p0
.end method

.method public getArray()[B
    .locals 2

    .line 48
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->flip()Ljava/nio/Buffer;

    .line 49
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v0

    new-array v0, v0, [B

    .line 50
    iget-object v1, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v1, v0}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 51
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->compact()Ljava/nio/ByteBuffer;

    return-object v0
.end method

.method public getInt()I
    .locals 0

    .line 81
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getInt()I

    move-result p0

    return p0
.end method

.method public getLong()J
    .locals 2

    .line 91
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getLong()J

    move-result-wide v0

    return-wide v0
.end method

.method public getShort()S
    .locals 0

    .line 71
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getShort()S

    move-result p0

    return p0
.end method

.method public nioBuffer()Ljava/nio/ByteBuffer;
    .locals 0

    .line 128
    iget-object p0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    return-object p0
.end method

.method public put(B)Lcom/pri/prizeinterphone/Util/ByteBuf;
    .locals 1

    const/4 v0, 0x1

    .line 65
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->checkCapacity(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 66
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v0, p1}, Ljava/nio/ByteBuffer;->put(B)Ljava/nio/ByteBuffer;

    return-object p0
.end method

.method public put([B)Lcom/pri/prizeinterphone/Util/ByteBuf;
    .locals 1

    .line 101
    array-length v0, p1

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->checkCapacity(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 102
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v0, p1}, Ljava/nio/ByteBuffer;->put([B)Ljava/nio/ByteBuffer;

    return-object p0
.end method

.method public putInt(I)Lcom/pri/prizeinterphone/Util/ByteBuf;
    .locals 1

    const/4 v0, 0x4

    .line 85
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->checkCapacity(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 86
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v0, p1}, Ljava/nio/ByteBuffer;->putInt(I)Ljava/nio/ByteBuffer;

    return-object p0
.end method

.method public putLong(J)Lcom/pri/prizeinterphone/Util/ByteBuf;
    .locals 1

    const/16 v0, 0x8

    .line 95
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->checkCapacity(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 96
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    invoke-virtual {v0, p1, p2}, Ljava/nio/ByteBuffer;->putLong(J)Ljava/nio/ByteBuffer;

    return-object p0
.end method

.method public putShort(I)Lcom/pri/prizeinterphone/Util/ByteBuf;
    .locals 1

    const/4 v0, 0x2

    .line 75
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/Util/ByteBuf;->checkCapacity(I)Lcom/pri/prizeinterphone/Util/ByteBuf;

    .line 76
    iget-object v0, p0, Lcom/pri/prizeinterphone/Util/ByteBuf;->tmpNioBuf:Ljava/nio/ByteBuffer;

    int-to-short p1, p1

    invoke-virtual {v0, p1}, Ljava/nio/ByteBuffer;->putShort(S)Ljava/nio/ByteBuffer;

    return-object p0
.end method
