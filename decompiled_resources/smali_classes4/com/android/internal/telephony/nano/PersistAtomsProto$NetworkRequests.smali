.class public final Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;
.super Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;
.source "PersistAtomsProto.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/nano/PersistAtomsProto;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "NetworkRequests"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano<",
        "Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;",
        ">;"
    }
.end annotation


# static fields
.field private static volatile _emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;


# instance fields
.field public carrierId:I

.field public enterpriseReleaseCount:I

.field public enterpriseRequestCount:I


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 4183
    invoke-direct {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;-><init>()V

    .line 4184
    invoke-virtual {p0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->clear()Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;

    return-void
.end method

.method public static emptyArray()[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;
    .locals 2

    .line 4163
    sget-object v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->_emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;

    if-nez v0, :cond_1

    .line 4164
    sget-object v0, Lcom/android/internal/telephony/protobuf/nano/InternalNano;->LAZY_INIT_LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 4166
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->_emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;

    if-nez v1, :cond_0

    const/4 v1, 0x0

    new-array v1, v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;

    .line 4167
    sput-object v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->_emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;

    .line 4169
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 4171
    :cond_1
    :goto_0
    sget-object v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->_emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;

    return-object v0
.end method

.method public static parseFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 4268
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;-><init>()V

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;

    move-result-object p0

    return-object p0
.end method

.method public static parseFrom([B)Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/protobuf/nano/InvalidProtocolBufferNanoException;
        }
    .end annotation

    .line 4262
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;-><init>()V

    invoke-static {v0, p0}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/MessageNano;[B)Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;

    return-object p0
.end method


# virtual methods
.method public clear()Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;
    .locals 1

    const/4 v0, 0x0

    .line 4188
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->carrierId:I

    .line 4189
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->enterpriseRequestCount:I

    .line 4190
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->enterpriseReleaseCount:I

    const/4 v0, 0x0

    .line 4191
    iput-object v0, p0, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->unknownFieldData:Lcom/android/internal/telephony/protobuf/nano/FieldArray;

    const/4 v0, -0x1

    .line 4192
    iput v0, p0, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->cachedSize:I

    return-object p0
.end method

.method protected computeSerializedSize()I
    .locals 3

    .line 4213
    invoke-super {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->computeSerializedSize()I

    move-result v0

    .line 4214
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->carrierId:I

    if-eqz v1, :cond_0

    const/4 v2, 0x1

    .line 4216
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 4218
    :cond_0
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->enterpriseRequestCount:I

    if-eqz v1, :cond_1

    const/4 v2, 0x2

    .line 4220
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 4222
    :cond_1
    iget p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->enterpriseReleaseCount:I

    if-eqz p0, :cond_2

    const/4 v1, 0x3

    .line 4224
    invoke-static {v1, p0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result p0

    add-int/2addr v0, p0

    :cond_2
    return v0
.end method

.method public mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 4234
    :cond_0
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    move-result v0

    if-eqz v0, :cond_4

    const/16 v1, 0x8

    if-eq v0, v1, :cond_3

    const/16 v1, 0x10

    if-eq v0, v1, :cond_2

    const/16 v1, 0x18

    if-eq v0, v1, :cond_1

    .line 4239
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->storeUnknownField(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)Z

    move-result v0

    if-nez v0, :cond_0

    return-object p0

    .line 4253
    :cond_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->enterpriseReleaseCount:I

    goto :goto_0

    .line 4249
    :cond_2
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->enterpriseRequestCount:I

    goto :goto_0

    .line 4245
    :cond_3
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->carrierId:I

    goto :goto_0

    :cond_4
    return-object p0
.end method

.method public bridge synthetic mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/protobuf/nano/MessageNano;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 4157
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;

    move-result-object p0

    return-object p0
.end method

.method public writeTo(Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 4199
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->carrierId:I

    if-eqz v0, :cond_0

    const/4 v1, 0x1

    .line 4200
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 4202
    :cond_0
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->enterpriseRequestCount:I

    if-eqz v0, :cond_1

    const/4 v1, 0x2

    .line 4203
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 4205
    :cond_1
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequests;->enterpriseReleaseCount:I

    if-eqz v0, :cond_2

    const/4 v1, 0x3

    .line 4206
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 4208
    :cond_2
    invoke-super {p0, p1}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->writeTo(Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;)V

    return-void
.end method
