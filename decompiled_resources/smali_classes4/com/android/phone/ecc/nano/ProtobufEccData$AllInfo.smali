.class public final Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;
.super Lcom/android/phone/ecc/nano/ExtendableMessageNano;
.source "ProtobufEccData.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/phone/ecc/nano/ProtobufEccData;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "AllInfo"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/android/phone/ecc/nano/ExtendableMessageNano<",
        "Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;",
        ">;"
    }
.end annotation


# static fields
.field private static volatile _emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;


# instance fields
.field public countries:[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

.field public revision:I


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 383
    invoke-direct {p0}, Lcom/android/phone/ecc/nano/ExtendableMessageNano;-><init>()V

    .line 384
    invoke-virtual {p0}, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->clear()Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;

    return-void
.end method

.method public static emptyArray()[Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;
    .locals 2

    .line 366
    sget-object v0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->_emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;

    if-nez v0, :cond_1

    .line 367
    sget-object v0, Lcom/android/phone/ecc/nano/InternalNano;->LAZY_INIT_LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 369
    :try_start_0
    sget-object v1, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->_emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;

    if-nez v1, :cond_0

    const/4 v1, 0x0

    new-array v1, v1, [Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;

    .line 370
    sput-object v1, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->_emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;

    .line 372
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 374
    :cond_1
    :goto_0
    sget-object v0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->_emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;

    return-object v0
.end method

.method public static parseFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 482
    new-instance v0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;

    invoke-direct {v0}, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;-><init>()V

    invoke-virtual {v0, p0}, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->mergeFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;

    move-result-object p0

    return-object p0
.end method

.method public static parseFrom([B)Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/phone/ecc/nano/InvalidProtocolBufferNanoException;
        }
    .end annotation

    .line 476
    new-instance v0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;

    invoke-direct {v0}, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;-><init>()V

    invoke-static {v0, p0}, Lcom/android/phone/ecc/nano/MessageNano;->mergeFrom(Lcom/android/phone/ecc/nano/MessageNano;[B)Lcom/android/phone/ecc/nano/MessageNano;

    move-result-object p0

    check-cast p0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;

    return-object p0
.end method


# virtual methods
.method public clear()Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;
    .locals 1

    const/4 v0, 0x0

    .line 388
    iput v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->revision:I

    .line 389
    invoke-static {}, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->emptyArray()[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    move-result-object v0

    iput-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->countries:[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    const/4 v0, 0x0

    .line 390
    iput-object v0, p0, Lcom/android/phone/ecc/nano/ExtendableMessageNano;->unknownFieldData:Lcom/android/phone/ecc/nano/FieldArray;

    const/4 v0, -0x1

    .line 391
    iput v0, p0, Lcom/android/phone/ecc/nano/MessageNano;->cachedSize:I

    return-object p0
.end method

.method protected computeSerializedSize()I
    .locals 4

    .line 414
    invoke-super {p0}, Lcom/android/phone/ecc/nano/ExtendableMessageNano;->computeSerializedSize()I

    move-result v0

    .line 415
    iget v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->revision:I

    if-eqz v1, :cond_0

    const/4 v2, 0x1

    .line 417
    invoke-static {v2, v1}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 419
    :cond_0
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->countries:[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    if-eqz v1, :cond_2

    array-length v1, v1

    if-lez v1, :cond_2

    const/4 v1, 0x0

    .line 420
    :goto_0
    iget-object v2, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->countries:[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    array-length v3, v2

    if-ge v1, v3, :cond_2

    .line 421
    aget-object v2, v2, v1

    if-eqz v2, :cond_1

    const/4 v3, 0x2

    .line 424
    invoke-static {v3, v2}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->computeMessageSize(ILcom/android/phone/ecc/nano/MessageNano;)I

    move-result v2

    add-int/2addr v0, v2

    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_2
    return v0
.end method

.method public bridge synthetic mergeFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/MessageNano;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 360
    invoke-virtual {p0, p1}, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->mergeFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;

    move-result-object p0

    return-object p0
.end method

.method public mergeFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 436
    :cond_0
    :goto_0
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readTag()I

    move-result v0

    if-eqz v0, :cond_6

    const/16 v1, 0x8

    if-eq v0, v1, :cond_5

    const/16 v1, 0x12

    if-eq v0, v1, :cond_1

    .line 441
    invoke-virtual {p0, p1, v0}, Lcom/android/phone/ecc/nano/ExtendableMessageNano;->storeUnknownField(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;I)Z

    move-result v0

    if-nez v0, :cond_0

    return-object p0

    .line 452
    :cond_1
    invoke-static {p1, v1}, Lcom/android/phone/ecc/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 453
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->countries:[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    const/4 v2, 0x0

    if-nez v1, :cond_2

    move v3, v2

    goto :goto_1

    :cond_2
    array-length v3, v1

    :goto_1
    add-int/2addr v0, v3

    .line 454
    new-array v4, v0, [Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    if-eqz v3, :cond_3

    .line 457
    invoke-static {v1, v2, v4, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_3
    :goto_2
    add-int/lit8 v1, v0, -0x1

    if-ge v3, v1, :cond_4

    .line 460
    new-instance v1, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    invoke-direct {v1}, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;-><init>()V

    aput-object v1, v4, v3

    .line 461
    invoke-virtual {p1, v1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readMessage(Lcom/android/phone/ecc/nano/MessageNano;)V

    .line 462
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readTag()I

    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    .line 465
    :cond_4
    new-instance v0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    invoke-direct {v0}, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;-><init>()V

    aput-object v0, v4, v3

    .line 466
    invoke-virtual {p1, v0}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readMessage(Lcom/android/phone/ecc/nano/MessageNano;)V

    .line 467
    iput-object v4, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->countries:[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    goto :goto_0

    .line 447
    :cond_5
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->revision:I

    goto :goto_0

    :cond_6
    return-object p0
.end method

.method public writeTo(Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 398
    iget v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->revision:I

    if-eqz v0, :cond_0

    const/4 v1, 0x1

    .line 399
    invoke-virtual {p1, v1, v0}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 401
    :cond_0
    iget-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->countries:[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    if-eqz v0, :cond_2

    array-length v0, v0

    if-lez v0, :cond_2

    const/4 v0, 0x0

    .line 402
    :goto_0
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$AllInfo;->countries:[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    array-length v2, v1

    if-ge v0, v2, :cond_2

    .line 403
    aget-object v1, v1, v0

    if-eqz v1, :cond_1

    const/4 v2, 0x2

    .line 405
    invoke-virtual {p1, v2, v1}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->writeMessage(ILcom/android/phone/ecc/nano/MessageNano;)V

    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 409
    :cond_2
    invoke-super {p0, p1}, Lcom/android/phone/ecc/nano/ExtendableMessageNano;->writeTo(Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;)V

    return-void
.end method
