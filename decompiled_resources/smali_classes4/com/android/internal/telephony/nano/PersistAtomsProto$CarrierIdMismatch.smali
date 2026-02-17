.class public final Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;
.super Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;
.source "PersistAtomsProto.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/nano/PersistAtomsProto;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "CarrierIdMismatch"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano<",
        "Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;",
        ">;"
    }
.end annotation


# static fields
.field private static volatile _emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;


# instance fields
.field public gid1:Ljava/lang/String;

.field public mccMnc:Ljava/lang/String;

.field public pnn:Ljava/lang/String;

.field public spn:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 2777
    invoke-direct {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;-><init>()V

    .line 2778
    invoke-virtual {p0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->clear()Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    return-void
.end method

.method public static emptyArray()[Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;
    .locals 2

    .line 2754
    sget-object v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->_emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    if-nez v0, :cond_1

    .line 2755
    sget-object v0, Lcom/android/internal/telephony/protobuf/nano/InternalNano;->LAZY_INIT_LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 2757
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->_emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    if-nez v1, :cond_0

    const/4 v1, 0x0

    new-array v1, v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    .line 2758
    sput-object v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->_emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    .line 2760
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 2762
    :cond_1
    :goto_0
    sget-object v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->_emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    return-object v0
.end method

.method public static parseFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 2874
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;-><init>()V

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    move-result-object p0

    return-object p0
.end method

.method public static parseFrom([B)Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/protobuf/nano/InvalidProtocolBufferNanoException;
        }
    .end annotation

    .line 2868
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;-><init>()V

    invoke-static {v0, p0}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/MessageNano;[B)Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    return-object p0
.end method


# virtual methods
.method public clear()Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;
    .locals 1

    const-string v0, ""

    .line 2782
    iput-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->mccMnc:Ljava/lang/String;

    .line 2783
    iput-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->gid1:Ljava/lang/String;

    .line 2784
    iput-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->spn:Ljava/lang/String;

    .line 2785
    iput-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->pnn:Ljava/lang/String;

    const/4 v0, 0x0

    .line 2786
    iput-object v0, p0, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->unknownFieldData:Lcom/android/internal/telephony/protobuf/nano/FieldArray;

    const/4 v0, -0x1

    .line 2787
    iput v0, p0, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->cachedSize:I

    return-object p0
.end method

.method protected computeSerializedSize()I
    .locals 4

    .line 2811
    invoke-super {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->computeSerializedSize()I

    move-result v0

    .line 2812
    iget-object v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->mccMnc:Ljava/lang/String;

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    const/4 v1, 0x1

    .line 2813
    iget-object v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->mccMnc:Ljava/lang/String;

    .line 2814
    invoke-static {v1, v3}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result v1

    add-int/2addr v0, v1

    .line 2816
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->gid1:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_1

    const/4 v1, 0x2

    .line 2817
    iget-object v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->gid1:Ljava/lang/String;

    .line 2818
    invoke-static {v1, v3}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result v1

    add-int/2addr v0, v1

    .line 2820
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->spn:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2

    const/4 v1, 0x3

    .line 2821
    iget-object v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->spn:Ljava/lang/String;

    .line 2822
    invoke-static {v1, v3}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result v1

    add-int/2addr v0, v1

    .line 2824
    :cond_2
    iget-object v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->pnn:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_3

    const/4 v1, 0x4

    .line 2825
    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->pnn:Ljava/lang/String;

    .line 2826
    invoke-static {v1, p0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result p0

    add-int/2addr v0, p0

    :cond_3
    return v0
.end method

.method public mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 2836
    :cond_0
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    move-result v0

    if-eqz v0, :cond_5

    const/16 v1, 0xa

    if-eq v0, v1, :cond_4

    const/16 v1, 0x12

    if-eq v0, v1, :cond_3

    const/16 v1, 0x1a

    if-eq v0, v1, :cond_2

    const/16 v1, 0x22

    if-eq v0, v1, :cond_1

    .line 2841
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->storeUnknownField(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)Z

    move-result v0

    if-nez v0, :cond_0

    return-object p0

    .line 2859
    :cond_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->pnn:Ljava/lang/String;

    goto :goto_0

    .line 2855
    :cond_2
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->spn:Ljava/lang/String;

    goto :goto_0

    .line 2851
    :cond_3
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->gid1:Ljava/lang/String;

    goto :goto_0

    .line 2847
    :cond_4
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->mccMnc:Ljava/lang/String;

    goto :goto_0

    :cond_5
    return-object p0
.end method

.method public bridge synthetic mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/protobuf/nano/MessageNano;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 2748
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

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

    .line 2794
    iget-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->mccMnc:Ljava/lang/String;

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, 0x1

    .line 2795
    iget-object v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->mccMnc:Ljava/lang/String;

    invoke-virtual {p1, v0, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 2797
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->gid1:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const/4 v0, 0x2

    .line 2798
    iget-object v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->gid1:Ljava/lang/String;

    invoke-virtual {p1, v0, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 2800
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->spn:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    const/4 v0, 0x3

    .line 2801
    iget-object v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->spn:Ljava/lang/String;

    invoke-virtual {p1, v0, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 2803
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->pnn:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_3

    const/4 v0, 0x4

    .line 2804
    iget-object v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->pnn:Ljava/lang/String;

    invoke-virtual {p1, v0, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 2806
    :cond_3
    invoke-super {p0, p1}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->writeTo(Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;)V

    return-void
.end method
