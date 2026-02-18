.class public Lcom/pri/prizeinterphone/record/WaveHeader;
.super Ljava/lang/Object;
.source "WaveHeader.java"


# instance fields
.field public AvgBytesPerSec:I

.field public BitsPerSample:S

.field public BlockAlign:S

.field public Channels:S

.field public DataHdrID:[C

.field public DataHdrLeth:I

.field public FmtHdrID:[C

.field public FmtHdrLeth:I

.field public FormatTag:S

.field public SamplesPerSec:I

.field public final fileID:[C

.field public fileLength:I

.field public wavTag:[C


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x4

    new-array v1, v0, [C

    .line 11
    fill-array-data v1, :array_0

    iput-object v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->fileID:[C

    new-array v1, v0, [C

    .line 13
    fill-array-data v1, :array_1

    iput-object v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->wavTag:[C

    new-array v1, v0, [C

    .line 14
    fill-array-data v1, :array_2

    iput-object v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->FmtHdrID:[C

    new-array v0, v0, [C

    .line 22
    fill-array-data v0, :array_3

    iput-object v0, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->DataHdrID:[C

    return-void

    nop

    :array_0
    .array-data 2
        0x52s
        0x49s
        0x46s
        0x46s
    .end array-data

    :array_1
    .array-data 2
        0x57s
        0x41s
        0x56s
        0x45s
    .end array-data

    :array_2
    .array-data 2
        0x66s
        0x6ds
        0x74s
        0x20s
    .end array-data

    :array_3
    .array-data 2
        0x64s
        0x61s
        0x74s
        0x61s
    .end array-data
.end method

.method private WriteChar(Ljava/io/ByteArrayOutputStream;[C)V
    .locals 1

    const/4 p0, 0x0

    .line 64
    :goto_0
    array-length v0, p2

    if-ge p0, v0, :cond_0

    .line 65
    aget-char v0, p2, p0

    .line 66
    invoke-virtual {p1, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    add-int/lit8 p0, p0, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method

.method private WriteInt(Ljava/io/ByteArrayOutputStream;I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    const/4 p0, 0x4

    new-array p0, p0, [B

    shr-int/lit8 v0, p2, 0x18

    int-to-byte v0, v0

    const/4 v1, 0x3

    aput-byte v0, p0, v1

    shl-int/lit8 v0, p2, 0x8

    shr-int/lit8 v0, v0, 0x18

    int-to-byte v0, v0

    const/4 v1, 0x2

    aput-byte v0, p0, v1

    shl-int/lit8 v0, p2, 0x10

    shr-int/lit8 v0, v0, 0x18

    int-to-byte v0, v0

    const/4 v1, 0x1

    aput-byte v0, p0, v1

    shl-int/lit8 p2, p2, 0x18

    shr-int/lit8 p2, p2, 0x18

    int-to-byte p2, p2

    const/4 v0, 0x0

    aput-byte p2, p0, v0

    .line 60
    invoke-virtual {p1, p0}, Ljava/io/ByteArrayOutputStream;->write([B)V

    return-void
.end method

.method private WriteShort(Ljava/io/ByteArrayOutputStream;I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    const/4 p0, 0x2

    new-array p0, p0, [B

    shl-int/lit8 v0, p2, 0x10

    shr-int/lit8 v0, v0, 0x18

    int-to-byte v0, v0

    const/4 v1, 0x1

    aput-byte v0, p0, v1

    shl-int/lit8 p2, p2, 0x18

    shr-int/lit8 p2, p2, 0x18

    int-to-byte p2, p2

    const/4 v0, 0x0

    aput-byte p2, p0, v0

    .line 50
    invoke-virtual {p1, p0}, Ljava/io/ByteArrayOutputStream;->write([B)V

    return-void
.end method


# virtual methods
.method public getHeader()[B
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 26
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 27
    iget-object v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->fileID:[C

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/record/WaveHeader;->WriteChar(Ljava/io/ByteArrayOutputStream;[C)V

    .line 28
    iget v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->fileLength:I

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/record/WaveHeader;->WriteInt(Ljava/io/ByteArrayOutputStream;I)V

    .line 29
    iget-object v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->wavTag:[C

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/record/WaveHeader;->WriteChar(Ljava/io/ByteArrayOutputStream;[C)V

    .line 30
    iget-object v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->FmtHdrID:[C

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/record/WaveHeader;->WriteChar(Ljava/io/ByteArrayOutputStream;[C)V

    .line 31
    iget v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->FmtHdrLeth:I

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/record/WaveHeader;->WriteInt(Ljava/io/ByteArrayOutputStream;I)V

    .line 32
    iget-short v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->FormatTag:S

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/record/WaveHeader;->WriteShort(Ljava/io/ByteArrayOutputStream;I)V

    .line 33
    iget-short v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->Channels:S

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/record/WaveHeader;->WriteShort(Ljava/io/ByteArrayOutputStream;I)V

    .line 34
    iget v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->SamplesPerSec:I

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/record/WaveHeader;->WriteInt(Ljava/io/ByteArrayOutputStream;I)V

    .line 35
    iget v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->AvgBytesPerSec:I

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/record/WaveHeader;->WriteInt(Ljava/io/ByteArrayOutputStream;I)V

    .line 36
    iget-short v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->BlockAlign:S

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/record/WaveHeader;->WriteShort(Ljava/io/ByteArrayOutputStream;I)V

    .line 37
    iget-short v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->BitsPerSample:S

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/record/WaveHeader;->WriteShort(Ljava/io/ByteArrayOutputStream;I)V

    .line 38
    iget-object v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->DataHdrID:[C

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/record/WaveHeader;->WriteChar(Ljava/io/ByteArrayOutputStream;[C)V

    .line 39
    iget v1, p0, Lcom/pri/prizeinterphone/record/WaveHeader;->DataHdrLeth:I

    invoke-direct {p0, v0, v1}, Lcom/pri/prizeinterphone/record/WaveHeader;->WriteInt(Ljava/io/ByteArrayOutputStream;I)V

    .line 40
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->flush()V

    .line 41
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    .line 42
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->close()V

    return-object p0
.end method
