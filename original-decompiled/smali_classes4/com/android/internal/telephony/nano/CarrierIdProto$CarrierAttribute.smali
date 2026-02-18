.class public final Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;
.super Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;
.source "CarrierIdProto.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/nano/CarrierIdProto;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "CarrierAttribute"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano<",
        "Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;",
        ">;"
    }
.end annotation


# static fields
.field private static volatile _emptyArray:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;


# instance fields
.field public gid1:[Ljava/lang/String;

.field public gid2:[Ljava/lang/String;

.field public iccidPrefix:[Ljava/lang/String;

.field public imsiPrefixXpattern:[Ljava/lang/String;

.field public mccmncTuple:[Ljava/lang/String;

.field public plmn:[Ljava/lang/String;

.field public preferredApn:[Ljava/lang/String;

.field public privilegeAccessRule:[Ljava/lang/String;

.field public spn:[Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 334
    invoke-direct {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;-><init>()V

    .line 335
    invoke-virtual {p0}, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->clear()Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    return-void
.end method

.method public static emptyArray()[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;
    .locals 2

    .line 296
    sget-object v0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->_emptyArray:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    if-nez v0, :cond_1

    .line 297
    sget-object v0, Lcom/android/internal/telephony/protobuf/nano/InternalNano;->LAZY_INIT_LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 299
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->_emptyArray:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    if-nez v1, :cond_0

    const/4 v1, 0x0

    new-array v1, v1, [Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    .line 300
    sput-object v1, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->_emptyArray:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    .line 302
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 304
    :cond_1
    :goto_0
    sget-object v0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->_emptyArray:[Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    return-object v0
.end method

.method public static parseFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 743
    new-instance v0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;-><init>()V

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    move-result-object p0

    return-object p0
.end method

.method public static parseFrom([B)Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/protobuf/nano/InvalidProtocolBufferNanoException;
        }
    .end annotation

    .line 737
    new-instance v0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;-><init>()V

    invoke-static {v0, p0}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/MessageNano;[B)Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    return-object p0
.end method


# virtual methods
.method public clear()Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;
    .locals 1

    .line 339
    sget-object v0, Lcom/android/internal/telephony/protobuf/nano/WireFormatNano;->EMPTY_STRING_ARRAY:[Ljava/lang/String;

    iput-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->mccmncTuple:[Ljava/lang/String;

    .line 340
    iput-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->imsiPrefixXpattern:[Ljava/lang/String;

    .line 341
    iput-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->spn:[Ljava/lang/String;

    .line 342
    iput-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->plmn:[Ljava/lang/String;

    .line 343
    iput-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid1:[Ljava/lang/String;

    .line 344
    iput-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid2:[Ljava/lang/String;

    .line 345
    iput-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->preferredApn:[Ljava/lang/String;

    .line 346
    iput-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->iccidPrefix:[Ljava/lang/String;

    .line 347
    iput-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->privilegeAccessRule:[Ljava/lang/String;

    const/4 v0, 0x0

    .line 348
    iput-object v0, p0, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->unknownFieldData:Lcom/android/internal/telephony/protobuf/nano/FieldArray;

    const/4 v0, -0x1

    .line 349
    iput v0, p0, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->cachedSize:I

    return-object p0
.end method

.method protected computeSerializedSize()I
    .locals 7

    .line 433
    invoke-super {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->computeSerializedSize()I

    move-result v0

    .line 434
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->mccmncTuple:[Ljava/lang/String;

    const/4 v2, 0x0

    if-eqz v1, :cond_2

    array-length v1, v1

    if-lez v1, :cond_2

    move v1, v2

    move v3, v1

    move v4, v3

    .line 437
    :goto_0
    iget-object v5, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->mccmncTuple:[Ljava/lang/String;

    array-length v6, v5

    if-ge v1, v6, :cond_1

    .line 438
    aget-object v5, v5, v1

    if-eqz v5, :cond_0

    add-int/lit8 v4, v4, 0x1

    .line 442
    invoke-static {v5}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSizeNoTag(Ljava/lang/String;)I

    move-result v5

    add-int/2addr v3, v5

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    add-int/2addr v0, v3

    mul-int/lit8 v4, v4, 0x1

    add-int/2addr v0, v4

    .line 448
    :cond_2
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->imsiPrefixXpattern:[Ljava/lang/String;

    if-eqz v1, :cond_5

    array-length v1, v1

    if-lez v1, :cond_5

    move v1, v2

    move v3, v1

    move v4, v3

    .line 451
    :goto_1
    iget-object v5, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->imsiPrefixXpattern:[Ljava/lang/String;

    array-length v6, v5

    if-ge v1, v6, :cond_4

    .line 452
    aget-object v5, v5, v1

    if-eqz v5, :cond_3

    add-int/lit8 v4, v4, 0x1

    .line 456
    invoke-static {v5}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSizeNoTag(Ljava/lang/String;)I

    move-result v5

    add-int/2addr v3, v5

    :cond_3
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    :cond_4
    add-int/2addr v0, v3

    mul-int/lit8 v4, v4, 0x1

    add-int/2addr v0, v4

    .line 462
    :cond_5
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->spn:[Ljava/lang/String;

    if-eqz v1, :cond_8

    array-length v1, v1

    if-lez v1, :cond_8

    move v1, v2

    move v3, v1

    move v4, v3

    .line 465
    :goto_2
    iget-object v5, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->spn:[Ljava/lang/String;

    array-length v6, v5

    if-ge v1, v6, :cond_7

    .line 466
    aget-object v5, v5, v1

    if-eqz v5, :cond_6

    add-int/lit8 v4, v4, 0x1

    .line 470
    invoke-static {v5}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSizeNoTag(Ljava/lang/String;)I

    move-result v5

    add-int/2addr v3, v5

    :cond_6
    add-int/lit8 v1, v1, 0x1

    goto :goto_2

    :cond_7
    add-int/2addr v0, v3

    mul-int/lit8 v4, v4, 0x1

    add-int/2addr v0, v4

    .line 476
    :cond_8
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->plmn:[Ljava/lang/String;

    if-eqz v1, :cond_b

    array-length v1, v1

    if-lez v1, :cond_b

    move v1, v2

    move v3, v1

    move v4, v3

    .line 479
    :goto_3
    iget-object v5, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->plmn:[Ljava/lang/String;

    array-length v6, v5

    if-ge v1, v6, :cond_a

    .line 480
    aget-object v5, v5, v1

    if-eqz v5, :cond_9

    add-int/lit8 v4, v4, 0x1

    .line 484
    invoke-static {v5}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSizeNoTag(Ljava/lang/String;)I

    move-result v5

    add-int/2addr v3, v5

    :cond_9
    add-int/lit8 v1, v1, 0x1

    goto :goto_3

    :cond_a
    add-int/2addr v0, v3

    mul-int/lit8 v4, v4, 0x1

    add-int/2addr v0, v4

    .line 490
    :cond_b
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid1:[Ljava/lang/String;

    if-eqz v1, :cond_e

    array-length v1, v1

    if-lez v1, :cond_e

    move v1, v2

    move v3, v1

    move v4, v3

    .line 493
    :goto_4
    iget-object v5, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid1:[Ljava/lang/String;

    array-length v6, v5

    if-ge v1, v6, :cond_d

    .line 494
    aget-object v5, v5, v1

    if-eqz v5, :cond_c

    add-int/lit8 v4, v4, 0x1

    .line 498
    invoke-static {v5}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSizeNoTag(Ljava/lang/String;)I

    move-result v5

    add-int/2addr v3, v5

    :cond_c
    add-int/lit8 v1, v1, 0x1

    goto :goto_4

    :cond_d
    add-int/2addr v0, v3

    mul-int/lit8 v4, v4, 0x1

    add-int/2addr v0, v4

    .line 504
    :cond_e
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid2:[Ljava/lang/String;

    if-eqz v1, :cond_11

    array-length v1, v1

    if-lez v1, :cond_11

    move v1, v2

    move v3, v1

    move v4, v3

    .line 507
    :goto_5
    iget-object v5, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid2:[Ljava/lang/String;

    array-length v6, v5

    if-ge v1, v6, :cond_10

    .line 508
    aget-object v5, v5, v1

    if-eqz v5, :cond_f

    add-int/lit8 v4, v4, 0x1

    .line 512
    invoke-static {v5}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSizeNoTag(Ljava/lang/String;)I

    move-result v5

    add-int/2addr v3, v5

    :cond_f
    add-int/lit8 v1, v1, 0x1

    goto :goto_5

    :cond_10
    add-int/2addr v0, v3

    mul-int/lit8 v4, v4, 0x1

    add-int/2addr v0, v4

    .line 518
    :cond_11
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->preferredApn:[Ljava/lang/String;

    if-eqz v1, :cond_14

    array-length v1, v1

    if-lez v1, :cond_14

    move v1, v2

    move v3, v1

    move v4, v3

    .line 521
    :goto_6
    iget-object v5, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->preferredApn:[Ljava/lang/String;

    array-length v6, v5

    if-ge v1, v6, :cond_13

    .line 522
    aget-object v5, v5, v1

    if-eqz v5, :cond_12

    add-int/lit8 v4, v4, 0x1

    .line 526
    invoke-static {v5}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSizeNoTag(Ljava/lang/String;)I

    move-result v5

    add-int/2addr v3, v5

    :cond_12
    add-int/lit8 v1, v1, 0x1

    goto :goto_6

    :cond_13
    add-int/2addr v0, v3

    mul-int/lit8 v4, v4, 0x1

    add-int/2addr v0, v4

    .line 532
    :cond_14
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->iccidPrefix:[Ljava/lang/String;

    if-eqz v1, :cond_17

    array-length v1, v1

    if-lez v1, :cond_17

    move v1, v2

    move v3, v1

    move v4, v3

    .line 535
    :goto_7
    iget-object v5, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->iccidPrefix:[Ljava/lang/String;

    array-length v6, v5

    if-ge v1, v6, :cond_16

    .line 536
    aget-object v5, v5, v1

    if-eqz v5, :cond_15

    add-int/lit8 v4, v4, 0x1

    .line 540
    invoke-static {v5}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSizeNoTag(Ljava/lang/String;)I

    move-result v5

    add-int/2addr v3, v5

    :cond_15
    add-int/lit8 v1, v1, 0x1

    goto :goto_7

    :cond_16
    add-int/2addr v0, v3

    mul-int/lit8 v4, v4, 0x1

    add-int/2addr v0, v4

    .line 546
    :cond_17
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->privilegeAccessRule:[Ljava/lang/String;

    if-eqz v1, :cond_1a

    array-length v1, v1

    if-lez v1, :cond_1a

    move v1, v2

    move v3, v1

    .line 549
    :goto_8
    iget-object v4, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->privilegeAccessRule:[Ljava/lang/String;

    array-length v5, v4

    if-ge v2, v5, :cond_19

    .line 550
    aget-object v4, v4, v2

    if-eqz v4, :cond_18

    add-int/lit8 v3, v3, 0x1

    .line 554
    invoke-static {v4}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSizeNoTag(Ljava/lang/String;)I

    move-result v4

    add-int/2addr v1, v4

    :cond_18
    add-int/lit8 v2, v2, 0x1

    goto :goto_8

    :cond_19
    add-int/2addr v0, v1

    mul-int/lit8 v3, v3, 0x1

    add-int/2addr v0, v3

    :cond_1a
    return v0
.end method

.method public mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 568
    :cond_0
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    move-result v0

    if-eqz v0, :cond_25

    const/16 v1, 0xa

    const/4 v2, 0x0

    if-eq v0, v1, :cond_21

    const/16 v1, 0x12

    if-eq v0, v1, :cond_1d

    const/16 v1, 0x1a

    if-eq v0, v1, :cond_19

    const/16 v1, 0x22

    if-eq v0, v1, :cond_15

    const/16 v1, 0x2a

    if-eq v0, v1, :cond_11

    const/16 v1, 0x32

    if-eq v0, v1, :cond_d

    const/16 v1, 0x3a

    if-eq v0, v1, :cond_9

    const/16 v1, 0x42

    if-eq v0, v1, :cond_5

    const/16 v1, 0x4a

    if-eq v0, v1, :cond_1

    .line 573
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->storeUnknownField(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)Z

    move-result v0

    if-nez v0, :cond_0

    return-object p0

    .line 716
    :cond_1
    invoke-static {p1, v1}, Lcom/android/internal/telephony/protobuf/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 717
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->privilegeAccessRule:[Ljava/lang/String;

    if-nez v1, :cond_2

    move v3, v2

    goto :goto_1

    :cond_2
    array-length v3, v1

    :goto_1
    add-int/2addr v0, v3

    .line 718
    new-array v4, v0, [Ljava/lang/String;

    if-eqz v3, :cond_3

    .line 720
    invoke-static {v1, v2, v4, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_3
    :goto_2
    add-int/lit8 v1, v0, -0x1

    if-ge v3, v1, :cond_4

    .line 723
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v3

    .line 724
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    .line 727
    :cond_4
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    aput-object v0, v4, v3

    .line 728
    iput-object v4, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->privilegeAccessRule:[Ljava/lang/String;

    goto :goto_0

    .line 699
    :cond_5
    invoke-static {p1, v1}, Lcom/android/internal/telephony/protobuf/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 700
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->iccidPrefix:[Ljava/lang/String;

    if-nez v1, :cond_6

    move v3, v2

    goto :goto_3

    :cond_6
    array-length v3, v1

    :goto_3
    add-int/2addr v0, v3

    .line 701
    new-array v4, v0, [Ljava/lang/String;

    if-eqz v3, :cond_7

    .line 703
    invoke-static {v1, v2, v4, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_7
    :goto_4
    add-int/lit8 v1, v0, -0x1

    if-ge v3, v1, :cond_8

    .line 706
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v3

    .line 707
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    add-int/lit8 v3, v3, 0x1

    goto :goto_4

    .line 710
    :cond_8
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    aput-object v0, v4, v3

    .line 711
    iput-object v4, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->iccidPrefix:[Ljava/lang/String;

    goto/16 :goto_0

    .line 682
    :cond_9
    invoke-static {p1, v1}, Lcom/android/internal/telephony/protobuf/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 683
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->preferredApn:[Ljava/lang/String;

    if-nez v1, :cond_a

    move v3, v2

    goto :goto_5

    :cond_a
    array-length v3, v1

    :goto_5
    add-int/2addr v0, v3

    .line 684
    new-array v4, v0, [Ljava/lang/String;

    if-eqz v3, :cond_b

    .line 686
    invoke-static {v1, v2, v4, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_b
    :goto_6
    add-int/lit8 v1, v0, -0x1

    if-ge v3, v1, :cond_c

    .line 689
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v3

    .line 690
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    add-int/lit8 v3, v3, 0x1

    goto :goto_6

    .line 693
    :cond_c
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    aput-object v0, v4, v3

    .line 694
    iput-object v4, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->preferredApn:[Ljava/lang/String;

    goto/16 :goto_0

    .line 665
    :cond_d
    invoke-static {p1, v1}, Lcom/android/internal/telephony/protobuf/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 666
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid2:[Ljava/lang/String;

    if-nez v1, :cond_e

    move v3, v2

    goto :goto_7

    :cond_e
    array-length v3, v1

    :goto_7
    add-int/2addr v0, v3

    .line 667
    new-array v4, v0, [Ljava/lang/String;

    if-eqz v3, :cond_f

    .line 669
    invoke-static {v1, v2, v4, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_f
    :goto_8
    add-int/lit8 v1, v0, -0x1

    if-ge v3, v1, :cond_10

    .line 672
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v3

    .line 673
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    add-int/lit8 v3, v3, 0x1

    goto :goto_8

    .line 676
    :cond_10
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    aput-object v0, v4, v3

    .line 677
    iput-object v4, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid2:[Ljava/lang/String;

    goto/16 :goto_0

    .line 648
    :cond_11
    invoke-static {p1, v1}, Lcom/android/internal/telephony/protobuf/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 649
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid1:[Ljava/lang/String;

    if-nez v1, :cond_12

    move v3, v2

    goto :goto_9

    :cond_12
    array-length v3, v1

    :goto_9
    add-int/2addr v0, v3

    .line 650
    new-array v4, v0, [Ljava/lang/String;

    if-eqz v3, :cond_13

    .line 652
    invoke-static {v1, v2, v4, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_13
    :goto_a
    add-int/lit8 v1, v0, -0x1

    if-ge v3, v1, :cond_14

    .line 655
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v3

    .line 656
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    add-int/lit8 v3, v3, 0x1

    goto :goto_a

    .line 659
    :cond_14
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    aput-object v0, v4, v3

    .line 660
    iput-object v4, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid1:[Ljava/lang/String;

    goto/16 :goto_0

    .line 631
    :cond_15
    invoke-static {p1, v1}, Lcom/android/internal/telephony/protobuf/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 632
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->plmn:[Ljava/lang/String;

    if-nez v1, :cond_16

    move v3, v2

    goto :goto_b

    :cond_16
    array-length v3, v1

    :goto_b
    add-int/2addr v0, v3

    .line 633
    new-array v4, v0, [Ljava/lang/String;

    if-eqz v3, :cond_17

    .line 635
    invoke-static {v1, v2, v4, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_17
    :goto_c
    add-int/lit8 v1, v0, -0x1

    if-ge v3, v1, :cond_18

    .line 638
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v3

    .line 639
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    add-int/lit8 v3, v3, 0x1

    goto :goto_c

    .line 642
    :cond_18
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    aput-object v0, v4, v3

    .line 643
    iput-object v4, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->plmn:[Ljava/lang/String;

    goto/16 :goto_0

    .line 614
    :cond_19
    invoke-static {p1, v1}, Lcom/android/internal/telephony/protobuf/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 615
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->spn:[Ljava/lang/String;

    if-nez v1, :cond_1a

    move v3, v2

    goto :goto_d

    :cond_1a
    array-length v3, v1

    :goto_d
    add-int/2addr v0, v3

    .line 616
    new-array v4, v0, [Ljava/lang/String;

    if-eqz v3, :cond_1b

    .line 618
    invoke-static {v1, v2, v4, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_1b
    :goto_e
    add-int/lit8 v1, v0, -0x1

    if-ge v3, v1, :cond_1c

    .line 621
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v3

    .line 622
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    add-int/lit8 v3, v3, 0x1

    goto :goto_e

    .line 625
    :cond_1c
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    aput-object v0, v4, v3

    .line 626
    iput-object v4, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->spn:[Ljava/lang/String;

    goto/16 :goto_0

    .line 597
    :cond_1d
    invoke-static {p1, v1}, Lcom/android/internal/telephony/protobuf/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 598
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->imsiPrefixXpattern:[Ljava/lang/String;

    if-nez v1, :cond_1e

    move v3, v2

    goto :goto_f

    :cond_1e
    array-length v3, v1

    :goto_f
    add-int/2addr v0, v3

    .line 599
    new-array v4, v0, [Ljava/lang/String;

    if-eqz v3, :cond_1f

    .line 601
    invoke-static {v1, v2, v4, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_1f
    :goto_10
    add-int/lit8 v1, v0, -0x1

    if-ge v3, v1, :cond_20

    .line 604
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v3

    .line 605
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    add-int/lit8 v3, v3, 0x1

    goto :goto_10

    .line 608
    :cond_20
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    aput-object v0, v4, v3

    .line 609
    iput-object v4, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->imsiPrefixXpattern:[Ljava/lang/String;

    goto/16 :goto_0

    .line 580
    :cond_21
    invoke-static {p1, v1}, Lcom/android/internal/telephony/protobuf/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 581
    iget-object v1, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->mccmncTuple:[Ljava/lang/String;

    if-nez v1, :cond_22

    move v3, v2

    goto :goto_11

    :cond_22
    array-length v3, v1

    :goto_11
    add-int/2addr v0, v3

    .line 582
    new-array v4, v0, [Ljava/lang/String;

    if-eqz v3, :cond_23

    .line 584
    invoke-static {v1, v2, v4, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_23
    :goto_12
    add-int/lit8 v1, v0, -0x1

    if-ge v3, v1, :cond_24

    .line 587
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v3

    .line 588
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    add-int/lit8 v3, v3, 0x1

    goto :goto_12

    .line 591
    :cond_24
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    aput-object v0, v4, v3

    .line 592
    iput-object v4, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->mccmncTuple:[Ljava/lang/String;

    goto/16 :goto_0

    :cond_25
    return-object p0
.end method

.method public bridge synthetic mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/protobuf/nano/MessageNano;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 290
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;

    move-result-object p0

    return-object p0
.end method

.method public writeTo(Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 356
    iget-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->mccmncTuple:[Ljava/lang/String;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    array-length v0, v0

    if-lez v0, :cond_1

    move v0, v1

    .line 357
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->mccmncTuple:[Ljava/lang/String;

    array-length v3, v2

    if-ge v0, v3, :cond_1

    .line 358
    aget-object v2, v2, v0

    if-eqz v2, :cond_0

    const/4 v3, 0x1

    .line 360
    invoke-virtual {p1, v3, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 364
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->imsiPrefixXpattern:[Ljava/lang/String;

    if-eqz v0, :cond_3

    array-length v0, v0

    if-lez v0, :cond_3

    move v0, v1

    .line 365
    :goto_1
    iget-object v2, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->imsiPrefixXpattern:[Ljava/lang/String;

    array-length v3, v2

    if-ge v0, v3, :cond_3

    .line 366
    aget-object v2, v2, v0

    if-eqz v2, :cond_2

    const/4 v3, 0x2

    .line 368
    invoke-virtual {p1, v3, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    :cond_2
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 372
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->spn:[Ljava/lang/String;

    if-eqz v0, :cond_5

    array-length v0, v0

    if-lez v0, :cond_5

    move v0, v1

    .line 373
    :goto_2
    iget-object v2, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->spn:[Ljava/lang/String;

    array-length v3, v2

    if-ge v0, v3, :cond_5

    .line 374
    aget-object v2, v2, v0

    if-eqz v2, :cond_4

    const/4 v3, 0x3

    .line 376
    invoke-virtual {p1, v3, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    :cond_4
    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    .line 380
    :cond_5
    iget-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->plmn:[Ljava/lang/String;

    if-eqz v0, :cond_7

    array-length v0, v0

    if-lez v0, :cond_7

    move v0, v1

    .line 381
    :goto_3
    iget-object v2, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->plmn:[Ljava/lang/String;

    array-length v3, v2

    if-ge v0, v3, :cond_7

    .line 382
    aget-object v2, v2, v0

    if-eqz v2, :cond_6

    const/4 v3, 0x4

    .line 384
    invoke-virtual {p1, v3, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    :cond_6
    add-int/lit8 v0, v0, 0x1

    goto :goto_3

    .line 388
    :cond_7
    iget-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid1:[Ljava/lang/String;

    if-eqz v0, :cond_9

    array-length v0, v0

    if-lez v0, :cond_9

    move v0, v1

    .line 389
    :goto_4
    iget-object v2, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid1:[Ljava/lang/String;

    array-length v3, v2

    if-ge v0, v3, :cond_9

    .line 390
    aget-object v2, v2, v0

    if-eqz v2, :cond_8

    const/4 v3, 0x5

    .line 392
    invoke-virtual {p1, v3, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    :cond_8
    add-int/lit8 v0, v0, 0x1

    goto :goto_4

    .line 396
    :cond_9
    iget-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid2:[Ljava/lang/String;

    if-eqz v0, :cond_b

    array-length v0, v0

    if-lez v0, :cond_b

    move v0, v1

    .line 397
    :goto_5
    iget-object v2, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->gid2:[Ljava/lang/String;

    array-length v3, v2

    if-ge v0, v3, :cond_b

    .line 398
    aget-object v2, v2, v0

    if-eqz v2, :cond_a

    const/4 v3, 0x6

    .line 400
    invoke-virtual {p1, v3, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    :cond_a
    add-int/lit8 v0, v0, 0x1

    goto :goto_5

    .line 404
    :cond_b
    iget-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->preferredApn:[Ljava/lang/String;

    if-eqz v0, :cond_d

    array-length v0, v0

    if-lez v0, :cond_d

    move v0, v1

    .line 405
    :goto_6
    iget-object v2, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->preferredApn:[Ljava/lang/String;

    array-length v3, v2

    if-ge v0, v3, :cond_d

    .line 406
    aget-object v2, v2, v0

    if-eqz v2, :cond_c

    const/4 v3, 0x7

    .line 408
    invoke-virtual {p1, v3, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    :cond_c
    add-int/lit8 v0, v0, 0x1

    goto :goto_6

    .line 412
    :cond_d
    iget-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->iccidPrefix:[Ljava/lang/String;

    if-eqz v0, :cond_f

    array-length v0, v0

    if-lez v0, :cond_f

    move v0, v1

    .line 413
    :goto_7
    iget-object v2, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->iccidPrefix:[Ljava/lang/String;

    array-length v3, v2

    if-ge v0, v3, :cond_f

    .line 414
    aget-object v2, v2, v0

    if-eqz v2, :cond_e

    const/16 v3, 0x8

    .line 416
    invoke-virtual {p1, v3, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    :cond_e
    add-int/lit8 v0, v0, 0x1

    goto :goto_7

    .line 420
    :cond_f
    iget-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->privilegeAccessRule:[Ljava/lang/String;

    if-eqz v0, :cond_11

    array-length v0, v0

    if-lez v0, :cond_11

    .line 421
    :goto_8
    iget-object v0, p0, Lcom/android/internal/telephony/nano/CarrierIdProto$CarrierAttribute;->privilegeAccessRule:[Ljava/lang/String;

    array-length v2, v0

    if-ge v1, v2, :cond_11

    .line 422
    aget-object v0, v0, v1

    if-eqz v0, :cond_10

    const/16 v2, 0x9

    .line 424
    invoke-virtual {p1, v2, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    :cond_10
    add-int/lit8 v1, v1, 0x1

    goto :goto_8

    .line 428
    :cond_11
    invoke-super {p0, p1}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->writeTo(Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;)V

    return-void
.end method
