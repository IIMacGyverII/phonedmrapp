.class public final Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;
.super Lcom/android/phone/ecc/nano/ExtendableMessageNano;
.source "ProtobufEccData.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/phone/ecc/nano/ProtobufEccData;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "CountryInfo"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/android/phone/ecc/nano/ExtendableMessageNano<",
        "Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;",
        ">;"
    }
.end annotation


# static fields
.field private static volatile _emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;


# instance fields
.field public eccFallback:Ljava/lang/String;

.field public eccs:[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

.field public isoCode:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 245
    invoke-direct {p0}, Lcom/android/phone/ecc/nano/ExtendableMessageNano;-><init>()V

    .line 246
    invoke-virtual {p0}, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->clear()Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    return-void
.end method

.method public static emptyArray()[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;
    .locals 2

    .line 225
    sget-object v0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->_emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    if-nez v0, :cond_1

    .line 226
    sget-object v0, Lcom/android/phone/ecc/nano/InternalNano;->LAZY_INIT_LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 228
    :try_start_0
    sget-object v1, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->_emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    if-nez v1, :cond_0

    const/4 v1, 0x0

    new-array v1, v1, [Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    .line 229
    sput-object v1, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->_emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    .line 231
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 233
    :cond_1
    :goto_0
    sget-object v0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->_emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    return-object v0
.end method

.method public static parseFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 356
    new-instance v0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    invoke-direct {v0}, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;-><init>()V

    invoke-virtual {v0, p0}, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->mergeFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    move-result-object p0

    return-object p0
.end method

.method public static parseFrom([B)Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/phone/ecc/nano/InvalidProtocolBufferNanoException;
        }
    .end annotation

    .line 350
    new-instance v0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    invoke-direct {v0}, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;-><init>()V

    invoke-static {v0, p0}, Lcom/android/phone/ecc/nano/MessageNano;->mergeFrom(Lcom/android/phone/ecc/nano/MessageNano;[B)Lcom/android/phone/ecc/nano/MessageNano;

    move-result-object p0

    check-cast p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    return-object p0
.end method


# virtual methods
.method public clear()Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;
    .locals 2

    const-string v0, ""

    .line 250
    iput-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->isoCode:Ljava/lang/String;

    .line 251
    invoke-static {}, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->emptyArray()[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    move-result-object v1

    iput-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->eccs:[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    .line 252
    iput-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->eccFallback:Ljava/lang/String;

    const/4 v0, 0x0

    .line 253
    iput-object v0, p0, Lcom/android/phone/ecc/nano/ExtendableMessageNano;->unknownFieldData:Lcom/android/phone/ecc/nano/FieldArray;

    const/4 v0, -0x1

    .line 254
    iput v0, p0, Lcom/android/phone/ecc/nano/MessageNano;->cachedSize:I

    return-object p0
.end method

.method protected computeSerializedSize()I
    .locals 5

    .line 280
    invoke-super {p0}, Lcom/android/phone/ecc/nano/ExtendableMessageNano;->computeSerializedSize()I

    move-result v0

    .line 281
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->isoCode:Ljava/lang/String;

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 282
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->isoCode:Ljava/lang/String;

    const/4 v3, 0x1

    .line 283
    invoke-static {v3, v1}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result v1

    add-int/2addr v0, v1

    .line 285
    :cond_0
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->eccs:[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    if-eqz v1, :cond_2

    array-length v1, v1

    if-lez v1, :cond_2

    const/4 v1, 0x0

    .line 286
    :goto_0
    iget-object v3, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->eccs:[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    array-length v4, v3

    if-ge v1, v4, :cond_2

    .line 287
    aget-object v3, v3, v1

    if-eqz v3, :cond_1

    const/4 v4, 0x2

    .line 290
    invoke-static {v4, v3}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->computeMessageSize(ILcom/android/phone/ecc/nano/MessageNano;)I

    move-result v3

    add-int/2addr v0, v3

    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 294
    :cond_2
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->eccFallback:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_3

    const/4 v1, 0x3

    .line 295
    iget-object p0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->eccFallback:Ljava/lang/String;

    .line 296
    invoke-static {v1, p0}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result p0

    add-int/2addr v0, p0

    :cond_3
    return v0
.end method

.method public bridge synthetic mergeFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/MessageNano;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 219
    invoke-virtual {p0, p1}, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->mergeFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;

    move-result-object p0

    return-object p0
.end method

.method public mergeFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 306
    :cond_0
    :goto_0
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readTag()I

    move-result v0

    if-eqz v0, :cond_7

    const/16 v1, 0xa

    if-eq v0, v1, :cond_6

    const/16 v1, 0x12

    if-eq v0, v1, :cond_2

    const/16 v1, 0x1a

    if-eq v0, v1, :cond_1

    .line 311
    invoke-virtual {p0, p1, v0}, Lcom/android/phone/ecc/nano/ExtendableMessageNano;->storeUnknownField(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;I)Z

    move-result v0

    if-nez v0, :cond_0

    return-object p0

    .line 341
    :cond_1
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->eccFallback:Ljava/lang/String;

    goto :goto_0

    .line 322
    :cond_2
    invoke-static {p1, v1}, Lcom/android/phone/ecc/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 323
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->eccs:[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    const/4 v2, 0x0

    if-nez v1, :cond_3

    move v3, v2

    goto :goto_1

    :cond_3
    array-length v3, v1

    :goto_1
    add-int/2addr v0, v3

    .line 324
    new-array v4, v0, [Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    if-eqz v3, :cond_4

    .line 327
    invoke-static {v1, v2, v4, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_4
    :goto_2
    add-int/lit8 v1, v0, -0x1

    if-ge v3, v1, :cond_5

    .line 330
    new-instance v1, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    invoke-direct {v1}, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;-><init>()V

    aput-object v1, v4, v3

    .line 331
    invoke-virtual {p1, v1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readMessage(Lcom/android/phone/ecc/nano/MessageNano;)V

    .line 332
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readTag()I

    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    .line 335
    :cond_5
    new-instance v0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    invoke-direct {v0}, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;-><init>()V

    aput-object v0, v4, v3

    .line 336
    invoke-virtual {p1, v0}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readMessage(Lcom/android/phone/ecc/nano/MessageNano;)V

    .line 337
    iput-object v4, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->eccs:[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    goto :goto_0

    .line 317
    :cond_6
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->isoCode:Ljava/lang/String;

    goto :goto_0

    :cond_7
    return-object p0
.end method

.method public writeTo(Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 261
    iget-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->isoCode:Ljava/lang/String;

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 262
    iget-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->isoCode:Ljava/lang/String;

    const/4 v2, 0x1

    invoke-virtual {p1, v2, v0}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 264
    :cond_0
    iget-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->eccs:[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    if-eqz v0, :cond_2

    array-length v0, v0

    if-lez v0, :cond_2

    const/4 v0, 0x0

    .line 265
    :goto_0
    iget-object v2, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->eccs:[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    array-length v3, v2

    if-ge v0, v3, :cond_2

    .line 266
    aget-object v2, v2, v0

    if-eqz v2, :cond_1

    const/4 v3, 0x2

    .line 268
    invoke-virtual {p1, v3, v2}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->writeMessage(ILcom/android/phone/ecc/nano/MessageNano;)V

    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 272
    :cond_2
    iget-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->eccFallback:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_3

    const/4 v0, 0x3

    .line 273
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$CountryInfo;->eccFallback:Ljava/lang/String;

    invoke-virtual {p1, v0, v1}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 275
    :cond_3
    invoke-super {p0, p1}, Lcom/android/phone/ecc/nano/ExtendableMessageNano;->writeTo(Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;)V

    return-void
.end method
