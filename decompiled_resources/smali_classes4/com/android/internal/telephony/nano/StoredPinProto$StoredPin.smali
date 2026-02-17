.class public final Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;
.super Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;
.source "StoredPinProto.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/nano/StoredPinProto;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "StoredPin"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin$PinStatus;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano<",
        "Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;",
        ">;"
    }
.end annotation


# static fields
.field private static volatile _emptyArray:[Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;


# instance fields
.field public bootCount:I

.field public iccid:Ljava/lang/String;

.field public pin:Ljava/lang/String;

.field public slotId:I

.field public status:I


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 47
    invoke-direct {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;-><init>()V

    .line 48
    invoke-virtual {p0}, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->clear()Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    return-void
.end method

.method public static emptyArray()[Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;
    .locals 2

    .line 21
    sget-object v0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->_emptyArray:[Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    if-nez v0, :cond_1

    .line 22
    sget-object v0, Lcom/android/internal/telephony/protobuf/nano/InternalNano;->LAZY_INIT_LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 24
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->_emptyArray:[Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    if-nez v1, :cond_0

    const/4 v1, 0x0

    new-array v1, v1, [Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    .line 25
    sput-object v1, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->_emptyArray:[Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    .line 27
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 29
    :cond_1
    :goto_0
    sget-object v0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->_emptyArray:[Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    return-object v0
.end method

.method public static parseFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 163
    new-instance v0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;-><init>()V

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    move-result-object p0

    return-object p0
.end method

.method public static parseFrom([B)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/protobuf/nano/InvalidProtocolBufferNanoException;
        }
    .end annotation

    .line 157
    new-instance v0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;-><init>()V

    invoke-static {v0, p0}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/MessageNano;[B)Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    return-object p0
.end method


# virtual methods
.method public clear()Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;
    .locals 2

    const-string v0, ""

    .line 52
    iput-object v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->iccid:Ljava/lang/String;

    .line 53
    iput-object v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->pin:Ljava/lang/String;

    const/4 v0, 0x0

    .line 54
    iput v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->slotId:I

    const/4 v1, 0x1

    .line 55
    iput v1, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    .line 56
    iput v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->bootCount:I

    const/4 v0, 0x0

    .line 57
    iput-object v0, p0, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->unknownFieldData:Lcom/android/internal/telephony/protobuf/nano/FieldArray;

    const/4 v0, -0x1

    .line 58
    iput v0, p0, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->cachedSize:I

    return-object p0
.end method

.method protected computeSerializedSize()I
    .locals 4

    .line 85
    invoke-super {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->computeSerializedSize()I

    move-result v0

    .line 86
    iget-object v1, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->iccid:Ljava/lang/String;

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const/4 v3, 0x1

    if-nez v1, :cond_0

    .line 87
    iget-object v1, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->iccid:Ljava/lang/String;

    .line 88
    invoke-static {v3, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result v1

    add-int/2addr v0, v1

    .line 90
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->pin:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_1

    const/4 v1, 0x2

    .line 91
    iget-object v2, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->pin:Ljava/lang/String;

    .line 92
    invoke-static {v1, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result v1

    add-int/2addr v0, v1

    .line 94
    :cond_1
    iget v1, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->slotId:I

    if-eqz v1, :cond_2

    const/4 v2, 0x3

    .line 96
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 98
    :cond_2
    iget v1, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    if-eq v1, v3, :cond_3

    const/4 v2, 0x4

    .line 100
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 102
    :cond_3
    iget p0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->bootCount:I

    if-eqz p0, :cond_4

    const/4 v1, 0x5

    .line 104
    invoke-static {v1, p0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result p0

    add-int/2addr v0, p0

    :cond_4
    return v0
.end method

.method public mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 114
    :cond_0
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    move-result v0

    if-eqz v0, :cond_7

    const/16 v1, 0xa

    if-eq v0, v1, :cond_6

    const/16 v1, 0x12

    if-eq v0, v1, :cond_5

    const/16 v1, 0x18

    if-eq v0, v1, :cond_4

    const/16 v1, 0x20

    if-eq v0, v1, :cond_2

    const/16 v1, 0x28

    if-eq v0, v1, :cond_1

    .line 119
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->storeUnknownField(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)Z

    move-result v0

    if-nez v0, :cond_0

    return-object p0

    .line 148
    :cond_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->bootCount:I

    goto :goto_0

    .line 137
    :cond_2
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    const/4 v1, 0x1

    if-eq v0, v1, :cond_3

    const/4 v1, 0x2

    if-eq v0, v1, :cond_3

    const/4 v1, 0x3

    if-eq v0, v1, :cond_3

    goto :goto_0

    .line 142
    :cond_3
    iput v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    goto :goto_0

    .line 133
    :cond_4
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->slotId:I

    goto :goto_0

    .line 129
    :cond_5
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->pin:Ljava/lang/String;

    goto :goto_0

    .line 125
    :cond_6
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->iccid:Ljava/lang/String;

    goto :goto_0

    :cond_7
    return-object p0
.end method

.method public bridge synthetic mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/protobuf/nano/MessageNano;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 8
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

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

    .line 65
    iget-object v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->iccid:Ljava/lang/String;

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v2, 0x1

    if-nez v0, :cond_0

    .line 66
    iget-object v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->iccid:Ljava/lang/String;

    invoke-virtual {p1, v2, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 68
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->pin:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const/4 v0, 0x2

    .line 69
    iget-object v1, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->pin:Ljava/lang/String;

    invoke-virtual {p1, v0, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 71
    :cond_1
    iget v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->slotId:I

    if-eqz v0, :cond_2

    const/4 v1, 0x3

    .line 72
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 74
    :cond_2
    iget v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    if-eq v0, v2, :cond_3

    const/4 v1, 0x4

    .line 75
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 77
    :cond_3
    iget v0, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->bootCount:I

    if-eqz v0, :cond_4

    const/4 v1, 0x5

    .line 78
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 80
    :cond_4
    invoke-super {p0, p1}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->writeTo(Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;)V

    return-void
.end method
