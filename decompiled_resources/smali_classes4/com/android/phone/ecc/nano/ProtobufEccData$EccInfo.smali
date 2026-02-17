.class public final Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;
.super Lcom/android/phone/ecc/nano/ExtendableMessageNano;
.source "ProtobufEccData.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/phone/ecc/nano/ProtobufEccData;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "EccInfo"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo$Type;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/android/phone/ecc/nano/ExtendableMessageNano<",
        "Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;",
        ">;"
    }
.end annotation


# static fields
.field private static volatile _emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;


# instance fields
.field public phoneNumber:Ljava/lang/String;

.field public types:[I


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 43
    invoke-direct {p0}, Lcom/android/phone/ecc/nano/ExtendableMessageNano;-><init>()V

    .line 44
    invoke-virtual {p0}, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->clear()Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    return-void
.end method

.method public static emptyArray()[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;
    .locals 2

    .line 26
    sget-object v0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->_emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    if-nez v0, :cond_1

    .line 27
    sget-object v0, Lcom/android/phone/ecc/nano/InternalNano;->LAZY_INIT_LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 29
    :try_start_0
    sget-object v1, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->_emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    if-nez v1, :cond_0

    const/4 v1, 0x0

    new-array v1, v1, [Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    .line 30
    sput-object v1, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->_emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    .line 32
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 34
    :cond_1
    :goto_0
    sget-object v0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->_emptyArray:[Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    return-object v0
.end method

.method public static parseFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 215
    new-instance v0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    invoke-direct {v0}, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;-><init>()V

    invoke-virtual {v0, p0}, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->mergeFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    move-result-object p0

    return-object p0
.end method

.method public static parseFrom([B)Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/phone/ecc/nano/InvalidProtocolBufferNanoException;
        }
    .end annotation

    .line 209
    new-instance v0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    invoke-direct {v0}, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;-><init>()V

    invoke-static {v0, p0}, Lcom/android/phone/ecc/nano/MessageNano;->mergeFrom(Lcom/android/phone/ecc/nano/MessageNano;[B)Lcom/android/phone/ecc/nano/MessageNano;

    move-result-object p0

    check-cast p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    return-object p0
.end method


# virtual methods
.method public clear()Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;
    .locals 1

    const-string v0, ""

    .line 48
    iput-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->phoneNumber:Ljava/lang/String;

    .line 49
    sget-object v0, Lcom/android/phone/ecc/nano/WireFormatNano;->EMPTY_INT_ARRAY:[I

    iput-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->types:[I

    const/4 v0, 0x0

    .line 50
    iput-object v0, p0, Lcom/android/phone/ecc/nano/ExtendableMessageNano;->unknownFieldData:Lcom/android/phone/ecc/nano/FieldArray;

    const/4 v0, -0x1

    .line 51
    iput v0, p0, Lcom/android/phone/ecc/nano/MessageNano;->cachedSize:I

    return-object p0
.end method

.method protected computeSerializedSize()I
    .locals 6

    .line 79
    invoke-super {p0}, Lcom/android/phone/ecc/nano/ExtendableMessageNano;->computeSerializedSize()I

    move-result v0

    .line 80
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->phoneNumber:Ljava/lang/String;

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const/4 v2, 0x1

    if-nez v1, :cond_0

    .line 81
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->phoneNumber:Ljava/lang/String;

    .line 82
    invoke-static {v2, v1}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result v1

    add-int/2addr v0, v1

    .line 84
    :cond_0
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->types:[I

    if-eqz v1, :cond_2

    array-length v1, v1

    if-lez v1, :cond_2

    const/4 v1, 0x0

    move v3, v1

    .line 86
    :goto_0
    iget-object v4, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->types:[I

    array-length v5, v4

    if-ge v1, v5, :cond_1

    .line 87
    aget v4, v4, v1

    .line 89
    invoke-static {v4}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->computeInt32SizeNoTag(I)I

    move-result v4

    add-int/2addr v3, v4

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    add-int/2addr v0, v3

    add-int/2addr v0, v2

    .line 94
    invoke-static {v3}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->computeRawVarint32Size(I)I

    move-result p0

    add-int/2addr v0, p0

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

    .line 8
    invoke-virtual {p0, p1}, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->mergeFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;

    move-result-object p0

    return-object p0
.end method

.method public mergeFrom(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;)Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 104
    :cond_0
    :goto_0
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readTag()I

    move-result v0

    if-eqz v0, :cond_e

    const/16 v1, 0xa

    if-eq v0, v1, :cond_d

    const/16 v1, 0x10

    const/4 v2, 0x0

    if-eq v0, v1, :cond_7

    const/16 v1, 0x12

    if-eq v0, v1, :cond_1

    .line 109
    invoke-virtual {p0, p1, v0}, Lcom/android/phone/ecc/nano/ExtendableMessageNano;->storeUnknownField(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;I)Z

    move-result v0

    if-nez v0, :cond_0

    return-object p0

    .line 157
    :cond_1
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readRawVarint32()I

    move-result v0

    .line 158
    invoke-virtual {p1, v0}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->pushLimit(I)I

    move-result v0

    .line 161
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->getPosition()I

    move-result v1

    move v3, v2

    .line 162
    :goto_1
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->getBytesUntilLimit()I

    move-result v4

    if-lez v4, :cond_2

    .line 163
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v4

    packed-switch v4, :pswitch_data_0

    goto :goto_1

    :pswitch_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_2
    if-eqz v3, :cond_6

    .line 177
    invoke-virtual {p1, v1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->rewindToPosition(I)V

    .line 178
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->types:[I

    if-nez v1, :cond_3

    move v4, v2

    goto :goto_2

    :cond_3
    array-length v4, v1

    :goto_2
    add-int/2addr v3, v4

    .line 179
    new-array v3, v3, [I

    if-eqz v4, :cond_4

    .line 181
    invoke-static {v1, v2, v3, v2, v4}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 183
    :cond_4
    :goto_3
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->getBytesUntilLimit()I

    move-result v1

    if-lez v1, :cond_5

    .line 184
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v1

    packed-switch v1, :pswitch_data_1

    goto :goto_3

    :pswitch_1
    add-int/lit8 v2, v4, 0x1

    .line 194
    aput v1, v3, v4

    move v4, v2

    goto :goto_3

    .line 198
    :cond_5
    iput-object v3, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->types:[I

    .line 200
    :cond_6
    invoke-virtual {p1, v0}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->popLimit(I)V

    goto :goto_0

    .line 120
    :cond_7
    invoke-static {p1, v1}, Lcom/android/phone/ecc/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 121
    new-array v1, v0, [I

    move v3, v2

    move v4, v3

    :goto_4
    if-ge v3, v0, :cond_9

    if-eqz v3, :cond_8

    .line 125
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readTag()I

    .line 127
    :cond_8
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v5

    packed-switch v5, :pswitch_data_2

    goto :goto_5

    :pswitch_2
    add-int/lit8 v6, v4, 0x1

    .line 137
    aput v5, v1, v4

    move v4, v6

    :goto_5
    add-int/lit8 v3, v3, 0x1

    goto :goto_4

    :cond_9
    if-eqz v4, :cond_0

    .line 142
    iget-object v3, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->types:[I

    if-nez v3, :cond_a

    move v5, v2

    goto :goto_6

    :cond_a
    array-length v5, v3

    :goto_6
    if-nez v5, :cond_b

    if-ne v4, v0, :cond_b

    .line 144
    iput-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->types:[I

    goto/16 :goto_0

    :cond_b
    add-int v0, v5, v4

    .line 146
    new-array v0, v0, [I

    if-eqz v5, :cond_c

    .line 148
    invoke-static {v3, v2, v0, v2, v5}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 150
    :cond_c
    invoke-static {v1, v2, v0, v5, v4}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 151
    iput-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->types:[I

    goto/16 :goto_0

    .line 115
    :cond_d
    invoke-virtual {p1}, Lcom/android/phone/ecc/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->phoneNumber:Ljava/lang/String;

    goto/16 :goto_0

    :cond_e
    return-object p0

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
    .end packed-switch

    :pswitch_data_1
    .packed-switch 0x0
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_1
    .end packed-switch

    :pswitch_data_2
    .packed-switch 0x0
        :pswitch_2
        :pswitch_2
        :pswitch_2
        :pswitch_2
        :pswitch_2
        :pswitch_2
        :pswitch_2
        :pswitch_2
    .end packed-switch
.end method

.method public writeTo(Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 58
    iget-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->phoneNumber:Ljava/lang/String;

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 59
    iget-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->phoneNumber:Ljava/lang/String;

    const/4 v1, 0x1

    invoke-virtual {p1, v1, v0}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 61
    :cond_0
    iget-object v0, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->types:[I

    if-eqz v0, :cond_2

    array-length v0, v0

    if-lez v0, :cond_2

    const/4 v0, 0x0

    move v1, v0

    move v2, v1

    .line 63
    :goto_0
    iget-object v3, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->types:[I

    array-length v4, v3

    if-ge v1, v4, :cond_1

    .line 64
    aget v3, v3, v1

    .line 66
    invoke-static {v3}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->computeInt32SizeNoTag(I)I

    move-result v3

    add-int/2addr v2, v3

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/16 v1, 0x12

    .line 68
    invoke-virtual {p1, v1}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->writeRawVarint32(I)V

    .line 69
    invoke-virtual {p1, v2}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->writeRawVarint32(I)V

    .line 70
    :goto_1
    iget-object v1, p0, Lcom/android/phone/ecc/nano/ProtobufEccData$EccInfo;->types:[I

    array-length v2, v1

    if-ge v0, v2, :cond_2

    .line 71
    aget v1, v1, v0

    invoke-virtual {p1, v1}, Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;->writeRawVarint32(I)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 74
    :cond_2
    invoke-super {p0, p1}, Lcom/android/phone/ecc/nano/ExtendableMessageNano;->writeTo(Lcom/android/phone/ecc/nano/CodedOutputByteBufferNano;)V

    return-void
.end method
