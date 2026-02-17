.class public final Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;
.super Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;
.source "CarrierIdProto.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/nano/CarrierIdProto;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "CarrierId"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano<",
        "Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;",
        ">;"
    }
.end annotation


# static fields
.field private static volatile _emptyArray:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;


# instance fields
.field public canonicalId:I

.field public carrierAttribute:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

.field public carrierName:Ljava/lang/String;

.field public parentCanonicalId:I


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 163
    invoke-direct {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;-><init>()V

    .line 164
    invoke-virtual {p0}, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->clear()Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;

    return-void
.end method

.method public static emptyArray()[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;
    .locals 2

    .line 140
    sget-object v0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->_emptyArray:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;

    if-nez v0, :cond_1

    .line 141
    sget-object v0, Lcom/android/internal/telephony/protobuf/nano/InternalNano;->LAZY_INIT_LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 143
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->_emptyArray:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;

    if-nez v1, :cond_0

    const/4 v1, 0x0

    new-array v1, v1, [Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;

    .line 144
    sput-object v1, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->_emptyArray:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;

    .line 146
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 148
    :cond_1
    :goto_0
    sget-object v0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->_emptyArray:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;

    return-object v0
.end method

.method public static parseFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 286
    new-instance v0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;-><init>()V

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;

    move-result-object p0

    return-object p0
.end method

.method public static parseFrom([B)Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/protobuf/nano/InvalidProtocolBufferNanoException;
        }
    .end annotation

    .line 280
    new-instance v0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;-><init>()V

    invoke-static {v0, p0}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/MessageNano;[B)Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;

    return-object p0
.end method


# virtual methods
.method public clear()Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;
    .locals 2

    const/4 v0, 0x0

    .line 168
    iput v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->canonicalId:I

    const-string v1, ""

    .line 169
    iput-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->carrierName:Ljava/lang/String;

    .line 170
    invoke-static {}, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->emptyArray()[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->carrierAttribute:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    .line 171
    iput v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->parentCanonicalId:I

    const/4 v0, 0x0

    .line 172
    iput-object v0, p0, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->unknownFieldData:Lcom/android/internal/telephony/protobuf/nano/FieldArray;

    const/4 v0, -0x1

    .line 173
    iput v0, p0, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->cachedSize:I

    return-object p0
.end method

.method protected computeSerializedSize()I
    .locals 4

    .line 202
    invoke-super {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->computeSerializedSize()I

    move-result v0

    .line 203
    iget v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->canonicalId:I

    if-eqz v1, :cond_0

    const/4 v2, 0x1

    .line 205
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 207
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->carrierName:Ljava/lang/String;

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_1

    const/4 v1, 0x2

    .line 208
    iget-object v2, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->carrierName:Ljava/lang/String;

    .line 209
    invoke-static {v1, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result v1

    add-int/2addr v0, v1

    .line 211
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->carrierAttribute:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    if-eqz v1, :cond_3

    array-length v1, v1

    if-lez v1, :cond_3

    const/4 v1, 0x0

    .line 212
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->carrierAttribute:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    array-length v3, v2

    if-ge v1, v3, :cond_3

    .line 213
    aget-object v2, v2, v1

    if-eqz v2, :cond_2

    const/4 v3, 0x3

    .line 216
    invoke-static {v3, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeMessageSize(ILcom/android/internal/telephony/protobuf/nano/MessageNano;)I

    move-result v2

    add-int/2addr v0, v2

    :cond_2
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 220
    :cond_3
    iget p0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->parentCanonicalId:I

    if-eqz p0, :cond_4

    const/4 v1, 0x4

    .line 222
    invoke-static {v1, p0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result p0

    add-int/2addr v0, p0

    :cond_4
    return v0
.end method

.method public mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 232
    :cond_0
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    move-result v0

    if-eqz v0, :cond_8

    const/16 v1, 0x8

    if-eq v0, v1, :cond_7

    const/16 v1, 0x12

    if-eq v0, v1, :cond_6

    const/16 v1, 0x1a

    if-eq v0, v1, :cond_2

    const/16 v1, 0x20

    if-eq v0, v1, :cond_1

    .line 237
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->storeUnknownField(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)Z

    move-result v0

    if-nez v0, :cond_0

    return-object p0

    .line 271
    :cond_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->parentCanonicalId:I

    goto :goto_0

    .line 252
    :cond_2
    invoke-static {p1, v1}, Lcom/android/internal/telephony/protobuf/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 253
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->carrierAttribute:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    const/4 v2, 0x0

    if-nez v1, :cond_3

    move v3, v2

    goto :goto_1

    :cond_3
    array-length v3, v1

    :goto_1
    add-int/2addr v0, v3

    .line 254
    new-array v4, v0, [Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    if-eqz v3, :cond_4

    .line 257
    invoke-static {v1, v2, v4, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_4
    :goto_2
    add-int/lit8 v1, v0, -0x1

    if-ge v3, v1, :cond_5

    .line 260
    new-instance v1, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    invoke-direct {v1}, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;-><init>()V

    aput-object v1, v4, v3

    .line 261
    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readMessage(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)V

    .line 262
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    .line 265
    :cond_5
    new-instance v0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;-><init>()V

    aput-object v0, v4, v3

    .line 266
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readMessage(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)V

    .line 267
    iput-object v4, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->carrierAttribute:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    goto :goto_0

    .line 247
    :cond_6
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->carrierName:Ljava/lang/String;

    goto :goto_0

    .line 243
    :cond_7
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->canonicalId:I

    goto :goto_0

    :cond_8
    return-object p0
.end method

.method public bridge synthetic mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/protobuf/nano/MessageNano;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 134
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;

    move-result-object p0

    return-object p0
.end method

.method public writeTo(Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 180
    iget v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->canonicalId:I

    if-eqz v0, :cond_0

    const/4 v1, 0x1

    .line 181
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 183
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->carrierName:Ljava/lang/String;

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const/4 v0, 0x2

    .line 184
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->carrierName:Ljava/lang/String;

    invoke-virtual {p1, v0, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 186
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->carrierAttribute:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    if-eqz v0, :cond_3

    array-length v0, v0

    if-lez v0, :cond_3

    const/4 v0, 0x0

    .line 187
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->carrierAttribute:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    array-length v2, v1

    if-ge v0, v2, :cond_3

    .line 188
    aget-object v1, v1, v0

    if-eqz v1, :cond_2

    const/4 v2, 0x3

    .line 190
    invoke-virtual {p1, v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeMessage(ILcom/android/internal/telephony/protobuf/nano/MessageNano;)V

    :cond_2
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 194
    :cond_3
    iget v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierId;->parentCanonicalId:I

    if-eqz v0, :cond_4

    const/4 v1, 0x4

    .line 195
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 197
    :cond_4
    invoke-super {p0, p1}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->writeTo(Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;)V

    return-void
.end method
