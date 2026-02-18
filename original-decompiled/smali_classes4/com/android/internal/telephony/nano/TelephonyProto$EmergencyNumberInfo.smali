.class public final Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;
.super Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;
.source "TelephonyProto.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/nano/TelephonyProto;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "EmergencyNumberInfo"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano<",
        "Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;",
        ">;"
    }
.end annotation


# static fields
.field private static volatile _emptyArray:[Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;


# instance fields
.field public address:Ljava/lang/String;

.field public countryIso:Ljava/lang/String;

.field public mnc:Ljava/lang/String;

.field public numberSourcesBitmask:I

.field public routing:I

.field public serviceCategoriesBitmask:I

.field public urns:[Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 2476
    invoke-direct {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;-><init>()V

    .line 2477
    invoke-virtual {p0}, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->clear()Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    return-void
.end method

.method public static emptyArray()[Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;
    .locals 2

    .line 2444
    sget-object v0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->_emptyArray:[Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    if-nez v0, :cond_1

    .line 2445
    sget-object v0, Lcom/android/internal/telephony/protobuf/nano/InternalNano;->LAZY_INIT_LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 2447
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->_emptyArray:[Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    if-nez v1, :cond_0

    const/4 v1, 0x0

    new-array v1, v1, [Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    .line 2448
    sput-object v1, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->_emptyArray:[Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    .line 2450
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 2452
    :cond_1
    :goto_0
    sget-object v0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->_emptyArray:[Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    return-object v0
.end method

.method public static parseFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 2637
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;-><init>()V

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    move-result-object p0

    return-object p0
.end method

.method public static parseFrom([B)Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/protobuf/nano/InvalidProtocolBufferNanoException;
        }
    .end annotation

    .line 2631
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;-><init>()V

    invoke-static {v0, p0}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/MessageNano;[B)Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    return-object p0
.end method


# virtual methods
.method public clear()Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;
    .locals 2

    const-string v0, ""

    .line 2481
    iput-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->address:Ljava/lang/String;

    .line 2482
    iput-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->countryIso:Ljava/lang/String;

    .line 2483
    iput-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->mnc:Ljava/lang/String;

    const/4 v0, 0x0

    .line 2484
    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->serviceCategoriesBitmask:I

    .line 2485
    sget-object v1, Lcom/android/internal/telephony/protobuf/nano/WireFormatNano;->EMPTY_STRING_ARRAY:[Ljava/lang/String;

    iput-object v1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->urns:[Ljava/lang/String;

    .line 2486
    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->numberSourcesBitmask:I

    .line 2487
    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->routing:I

    const/4 v0, 0x0

    .line 2488
    iput-object v0, p0, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->unknownFieldData:Lcom/android/internal/telephony/protobuf/nano/FieldArray;

    const/4 v0, -0x1

    .line 2489
    iput v0, p0, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->cachedSize:I

    return-object p0
.end method

.method protected computeSerializedSize()I
    .locals 7

    .line 2527
    invoke-super {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->computeSerializedSize()I

    move-result v0

    .line 2528
    iget-object v1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->address:Ljava/lang/String;

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const/4 v3, 0x1

    if-nez v1, :cond_0

    .line 2529
    iget-object v1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->address:Ljava/lang/String;

    .line 2530
    invoke-static {v3, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result v1

    add-int/2addr v0, v1

    .line 2532
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->countryIso:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_1

    const/4 v1, 0x2

    .line 2533
    iget-object v4, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->countryIso:Ljava/lang/String;

    .line 2534
    invoke-static {v1, v4}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result v1

    add-int/2addr v0, v1

    .line 2536
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->mnc:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2

    const/4 v1, 0x3

    .line 2537
    iget-object v2, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->mnc:Ljava/lang/String;

    .line 2538
    invoke-static {v1, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result v1

    add-int/2addr v0, v1

    .line 2540
    :cond_2
    iget v1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->serviceCategoriesBitmask:I

    if-eqz v1, :cond_3

    const/4 v2, 0x4

    .line 2542
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 2544
    :cond_3
    iget-object v1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->urns:[Ljava/lang/String;

    if-eqz v1, :cond_6

    array-length v1, v1

    if-lez v1, :cond_6

    const/4 v1, 0x0

    move v2, v1

    move v4, v2

    .line 2547
    :goto_0
    iget-object v5, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->urns:[Ljava/lang/String;

    array-length v6, v5

    if-ge v1, v6, :cond_5

    .line 2548
    aget-object v5, v5, v1

    if-eqz v5, :cond_4

    add-int/lit8 v4, v4, 0x1

    .line 2552
    invoke-static {v5}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSizeNoTag(Ljava/lang/String;)I

    move-result v5

    add-int/2addr v2, v5

    :cond_4
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_5
    add-int/2addr v0, v2

    mul-int/2addr v4, v3

    add-int/2addr v0, v4

    .line 2558
    :cond_6
    iget v1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->numberSourcesBitmask:I

    if-eqz v1, :cond_7

    const/4 v2, 0x6

    .line 2560
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 2562
    :cond_7
    iget p0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->routing:I

    if-eqz p0, :cond_8

    const/4 v1, 0x7

    .line 2564
    invoke-static {v1, p0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result p0

    add-int/2addr v0, p0

    :cond_8
    return v0
.end method

.method public mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 2574
    :cond_0
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    move-result v0

    if-eqz v0, :cond_b

    const/16 v1, 0xa

    if-eq v0, v1, :cond_a

    const/16 v1, 0x12

    if-eq v0, v1, :cond_9

    const/16 v1, 0x1a

    if-eq v0, v1, :cond_8

    const/16 v1, 0x20

    if-eq v0, v1, :cond_7

    const/16 v1, 0x2a

    if-eq v0, v1, :cond_3

    const/16 v1, 0x30

    if-eq v0, v1, :cond_2

    const/16 v1, 0x38

    if-eq v0, v1, :cond_1

    .line 2579
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->storeUnknownField(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)Z

    move-result v0

    if-nez v0, :cond_0

    return-object p0

    .line 2622
    :cond_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->routing:I

    goto :goto_0

    .line 2618
    :cond_2
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->numberSourcesBitmask:I

    goto :goto_0

    .line 2602
    :cond_3
    invoke-static {p1, v1}, Lcom/android/internal/telephony/protobuf/nano/WireFormatNano;->getRepeatedFieldArrayLength(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)I

    move-result v0

    .line 2603
    iget-object v1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->urns:[Ljava/lang/String;

    const/4 v2, 0x0

    if-nez v1, :cond_4

    move v3, v2

    goto :goto_1

    :cond_4
    array-length v3, v1

    :goto_1
    add-int/2addr v0, v3

    .line 2604
    new-array v4, v0, [Ljava/lang/String;

    if-eqz v3, :cond_5

    .line 2606
    invoke-static {v1, v2, v4, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    :cond_5
    :goto_2
    add-int/lit8 v1, v0, -0x1

    if-ge v3, v1, :cond_6

    .line 2609
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v3

    .line 2610
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    .line 2613
    :cond_6
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    aput-object v0, v4, v3

    .line 2614
    iput-object v4, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->urns:[Ljava/lang/String;

    goto :goto_0

    .line 2597
    :cond_7
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->serviceCategoriesBitmask:I

    goto :goto_0

    .line 2593
    :cond_8
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->mnc:Ljava/lang/String;

    goto :goto_0

    .line 2589
    :cond_9
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->countryIso:Ljava/lang/String;

    goto :goto_0

    .line 2585
    :cond_a
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->address:Ljava/lang/String;

    goto :goto_0

    :cond_b
    return-object p0
.end method

.method public bridge synthetic mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/protobuf/nano/MessageNano;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 2438
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

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

    .line 2496
    iget-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->address:Ljava/lang/String;

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 2497
    iget-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->address:Ljava/lang/String;

    const/4 v2, 0x1

    invoke-virtual {p1, v2, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 2499
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->countryIso:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const/4 v0, 0x2

    .line 2500
    iget-object v2, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->countryIso:Ljava/lang/String;

    invoke-virtual {p1, v0, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 2502
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->mnc:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    const/4 v0, 0x3

    .line 2503
    iget-object v1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->mnc:Ljava/lang/String;

    invoke-virtual {p1, v0, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 2505
    :cond_2
    iget v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->serviceCategoriesBitmask:I

    if-eqz v0, :cond_3

    const/4 v1, 0x4

    .line 2506
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 2508
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->urns:[Ljava/lang/String;

    if-eqz v0, :cond_5

    array-length v0, v0

    if-lez v0, :cond_5

    const/4 v0, 0x0

    .line 2509
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->urns:[Ljava/lang/String;

    array-length v2, v1

    if-ge v0, v2, :cond_5

    .line 2510
    aget-object v1, v1, v0

    if-eqz v1, :cond_4

    const/4 v2, 0x5

    .line 2512
    invoke-virtual {p1, v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    :cond_4
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 2516
    :cond_5
    iget v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->numberSourcesBitmask:I

    if-eqz v0, :cond_6

    const/4 v1, 0x6

    .line 2517
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 2519
    :cond_6
    iget v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->routing:I

    if-eqz v0, :cond_7

    const/4 v1, 0x7

    .line 2520
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 2522
    :cond_7
    invoke-super {p0, p1}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->writeTo(Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;)V

    return-void
.end method
