.class public final Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;
.super Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;
.source "PersistAtomsProto.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/nano/PersistAtomsProto;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "VoiceCallSession"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano<",
        "Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;",
        ">;"
    }
.end annotation


# static fields
.field private static volatile _emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;


# instance fields
.field public bandAtEnd:I

.field public bearerAtEnd:I

.field public bearerAtStart:I

.field public callDuration:I

.field public carrierId:I

.field public codecBitmask:J

.field public concurrentCallCountAtEnd:I

.field public concurrentCallCountAtStart:I

.field public direction:I

.field public disconnectExtraCode:I

.field public disconnectExtraMessage:Ljava/lang/String;

.field public disconnectReasonCode:I

.field public isEmergency:Z

.field public isEsim:Z

.field public isMultiSim:Z

.field public isMultiparty:Z

.field public isRoaming:Z

.field public mainCodecQuality:I

.field public ratAtConnected:I

.field public ratAtEnd:I

.field public ratAtStart:I

.field public ratSwitchCount:J

.field public rttEnabled:Z

.field public setupBeginMillis:J

.field public setupDuration:I

.field public setupDurationMillis:I

.field public setupFailed:Z

.field public signalStrengthAtEnd:I

.field public simSlotIndex:I

.field public srvccCancellationCount:J

.field public srvccCompleted:Z

.field public srvccFailureCount:J

.field public videoEnabled:Z


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 1609
    invoke-direct {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;-><init>()V

    .line 1610
    invoke-virtual {p0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->clear()Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    return-void
.end method

.method public static emptyArray()[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;
    .locals 2

    .line 1499
    sget-object v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->_emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    if-nez v0, :cond_1

    .line 1500
    sget-object v0, Lcom/android/internal/telephony/protobuf/nano/InternalNano;->LAZY_INIT_LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 1502
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->_emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    if-nez v1, :cond_0

    const/4 v1, 0x0

    new-array v1, v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    .line 1503
    sput-object v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->_emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    .line 1505
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 1507
    :cond_1
    :goto_0
    sget-object v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->_emptyArray:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    return-object v0
.end method

.method public static parseFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 2054
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;-><init>()V

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    move-result-object p0

    return-object p0
.end method

.method public static parseFrom([B)Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/protobuf/nano/InvalidProtocolBufferNanoException;
        }
    .end annotation

    .line 2048
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;-><init>()V

    invoke-static {v0, p0}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/MessageNano;[B)Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    return-object p0
.end method


# virtual methods
.method public clear()Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;
    .locals 3

    const/4 v0, 0x0

    .line 1614
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtStart:I

    .line 1615
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtEnd:I

    .line 1616
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->direction:I

    .line 1617
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDuration:I

    .line 1618
    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupFailed:Z

    .line 1619
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectReasonCode:I

    .line 1620
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraCode:I

    const-string v1, ""

    .line 1621
    iput-object v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraMessage:Ljava/lang/String;

    .line 1622
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtStart:I

    .line 1623
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtEnd:I

    const-wide/16 v1, 0x0

    .line 1624
    iput-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratSwitchCount:J

    .line 1625
    iput-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->codecBitmask:J

    .line 1626
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->concurrentCallCountAtStart:I

    .line 1627
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->concurrentCallCountAtEnd:I

    .line 1628
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->simSlotIndex:I

    .line 1629
    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isMultiSim:Z

    .line 1630
    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isEsim:Z

    .line 1631
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->carrierId:I

    .line 1632
    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCompleted:Z

    .line 1633
    iput-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccFailureCount:J

    .line 1634
    iput-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCancellationCount:J

    .line 1635
    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->rttEnabled:Z

    .line 1636
    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isEmergency:Z

    .line 1637
    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isRoaming:Z

    .line 1638
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->signalStrengthAtEnd:I

    .line 1639
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bandAtEnd:I

    .line 1640
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDurationMillis:I

    .line 1641
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->mainCodecQuality:I

    .line 1642
    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->videoEnabled:Z

    .line 1643
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtConnected:I

    .line 1644
    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isMultiparty:Z

    .line 1645
    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->callDuration:I

    .line 1646
    iput-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupBeginMillis:J

    const/4 v0, 0x0

    .line 1647
    iput-object v0, p0, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->unknownFieldData:Lcom/android/internal/telephony/protobuf/nano/FieldArray;

    const/4 v0, -0x1

    .line 1648
    iput v0, p0, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->cachedSize:I

    return-object p0
.end method

.method protected computeSerializedSize()I
    .locals 6

    .line 1759
    invoke-super {p0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->computeSerializedSize()I

    move-result v0

    .line 1760
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtStart:I

    if-eqz v1, :cond_0

    const/4 v2, 0x1

    .line 1762
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1764
    :cond_0
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtEnd:I

    if-eqz v1, :cond_1

    const/4 v2, 0x2

    .line 1766
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1768
    :cond_1
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->direction:I

    if-eqz v1, :cond_2

    const/4 v2, 0x3

    .line 1770
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1772
    :cond_2
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDuration:I

    if-eqz v1, :cond_3

    const/4 v2, 0x4

    .line 1774
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1776
    :cond_3
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupFailed:Z

    if-eqz v1, :cond_4

    const/4 v2, 0x5

    .line 1778
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeBoolSize(IZ)I

    move-result v1

    add-int/2addr v0, v1

    .line 1780
    :cond_4
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectReasonCode:I

    if-eqz v1, :cond_5

    const/4 v2, 0x6

    .line 1782
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1784
    :cond_5
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraCode:I

    if-eqz v1, :cond_6

    const/4 v2, 0x7

    .line 1786
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1788
    :cond_6
    iget-object v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraMessage:Ljava/lang/String;

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_7

    const/16 v1, 0x8

    .line 1789
    iget-object v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraMessage:Ljava/lang/String;

    .line 1790
    invoke-static {v1, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeStringSize(ILjava/lang/String;)I

    move-result v1

    add-int/2addr v0, v1

    .line 1792
    :cond_7
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtStart:I

    if-eqz v1, :cond_8

    const/16 v2, 0x9

    .line 1794
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1796
    :cond_8
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtEnd:I

    if-eqz v1, :cond_9

    const/16 v2, 0xa

    .line 1798
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1800
    :cond_9
    iget-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratSwitchCount:J

    const-wide/16 v3, 0x0

    cmp-long v5, v1, v3

    if-eqz v5, :cond_a

    const/16 v5, 0xb

    .line 1802
    invoke-static {v5, v1, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt64Size(IJ)I

    move-result v1

    add-int/2addr v0, v1

    .line 1804
    :cond_a
    iget-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->codecBitmask:J

    cmp-long v5, v1, v3

    if-eqz v5, :cond_b

    const/16 v5, 0xc

    .line 1806
    invoke-static {v5, v1, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt64Size(IJ)I

    move-result v1

    add-int/2addr v0, v1

    .line 1808
    :cond_b
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->concurrentCallCountAtStart:I

    if-eqz v1, :cond_c

    const/16 v2, 0xd

    .line 1810
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1812
    :cond_c
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->concurrentCallCountAtEnd:I

    if-eqz v1, :cond_d

    const/16 v2, 0xe

    .line 1814
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1816
    :cond_d
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->simSlotIndex:I

    if-eqz v1, :cond_e

    const/16 v2, 0xf

    .line 1818
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1820
    :cond_e
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isMultiSim:Z

    if-eqz v1, :cond_f

    const/16 v2, 0x10

    .line 1822
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeBoolSize(IZ)I

    move-result v1

    add-int/2addr v0, v1

    .line 1824
    :cond_f
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isEsim:Z

    if-eqz v1, :cond_10

    const/16 v2, 0x11

    .line 1826
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeBoolSize(IZ)I

    move-result v1

    add-int/2addr v0, v1

    .line 1828
    :cond_10
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->carrierId:I

    if-eqz v1, :cond_11

    const/16 v2, 0x12

    .line 1830
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1832
    :cond_11
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCompleted:Z

    if-eqz v1, :cond_12

    const/16 v2, 0x13

    .line 1834
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeBoolSize(IZ)I

    move-result v1

    add-int/2addr v0, v1

    .line 1836
    :cond_12
    iget-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccFailureCount:J

    cmp-long v5, v1, v3

    if-eqz v5, :cond_13

    const/16 v5, 0x14

    .line 1838
    invoke-static {v5, v1, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt64Size(IJ)I

    move-result v1

    add-int/2addr v0, v1

    .line 1840
    :cond_13
    iget-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCancellationCount:J

    cmp-long v5, v1, v3

    if-eqz v5, :cond_14

    const/16 v5, 0x15

    .line 1842
    invoke-static {v5, v1, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt64Size(IJ)I

    move-result v1

    add-int/2addr v0, v1

    .line 1844
    :cond_14
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->rttEnabled:Z

    if-eqz v1, :cond_15

    const/16 v2, 0x16

    .line 1846
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeBoolSize(IZ)I

    move-result v1

    add-int/2addr v0, v1

    .line 1848
    :cond_15
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isEmergency:Z

    if-eqz v1, :cond_16

    const/16 v2, 0x17

    .line 1850
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeBoolSize(IZ)I

    move-result v1

    add-int/2addr v0, v1

    .line 1852
    :cond_16
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isRoaming:Z

    if-eqz v1, :cond_17

    const/16 v2, 0x18

    .line 1854
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeBoolSize(IZ)I

    move-result v1

    add-int/2addr v0, v1

    .line 1856
    :cond_17
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->signalStrengthAtEnd:I

    if-eqz v1, :cond_18

    const/16 v2, 0x19

    .line 1858
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1860
    :cond_18
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bandAtEnd:I

    if-eqz v1, :cond_19

    const/16 v2, 0x1a

    .line 1862
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1864
    :cond_19
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDurationMillis:I

    if-eqz v1, :cond_1a

    const/16 v2, 0x1b

    .line 1866
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1868
    :cond_1a
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->mainCodecQuality:I

    if-eqz v1, :cond_1b

    const/16 v2, 0x1c

    .line 1870
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1872
    :cond_1b
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->videoEnabled:Z

    if-eqz v1, :cond_1c

    const/16 v2, 0x1d

    .line 1874
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeBoolSize(IZ)I

    move-result v1

    add-int/2addr v0, v1

    .line 1876
    :cond_1c
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtConnected:I

    if-eqz v1, :cond_1d

    const/16 v2, 0x1e

    .line 1878
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1880
    :cond_1d
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isMultiparty:Z

    if-eqz v1, :cond_1e

    const/16 v2, 0x1f

    .line 1882
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeBoolSize(IZ)I

    move-result v1

    add-int/2addr v0, v1

    .line 1884
    :cond_1e
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->callDuration:I

    if-eqz v1, :cond_1f

    const/16 v2, 0x20

    .line 1886
    invoke-static {v2, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt32Size(II)I

    move-result v1

    add-int/2addr v0, v1

    .line 1888
    :cond_1f
    iget-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupBeginMillis:J

    cmp-long p0, v1, v3

    if-eqz p0, :cond_20

    const/16 p0, 0x2711

    .line 1890
    invoke-static {p0, v1, v2}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->computeInt64Size(IJ)I

    move-result p0

    add-int/2addr v0, p0

    :cond_20
    return v0
.end method

.method public mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 1900
    :cond_0
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readTag()I

    move-result v0

    sparse-switch v0, :sswitch_data_0

    .line 1905
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->storeUnknownField(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;I)Z

    move-result v0

    if-nez v0, :cond_0

    return-object p0

    .line 2039
    :sswitch_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt64()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupBeginMillis:J

    goto :goto_0

    .line 2035
    :sswitch_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->callDuration:I

    goto :goto_0

    .line 2031
    :sswitch_2
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readBool()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isMultiparty:Z

    goto :goto_0

    .line 2027
    :sswitch_3
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtConnected:I

    goto :goto_0

    .line 2023
    :sswitch_4
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readBool()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->videoEnabled:Z

    goto :goto_0

    .line 2019
    :sswitch_5
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->mainCodecQuality:I

    goto :goto_0

    .line 2015
    :sswitch_6
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDurationMillis:I

    goto :goto_0

    .line 2011
    :sswitch_7
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bandAtEnd:I

    goto :goto_0

    .line 2007
    :sswitch_8
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->signalStrengthAtEnd:I

    goto :goto_0

    .line 2003
    :sswitch_9
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readBool()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isRoaming:Z

    goto :goto_0

    .line 1999
    :sswitch_a
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readBool()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isEmergency:Z

    goto :goto_0

    .line 1995
    :sswitch_b
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readBool()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->rttEnabled:Z

    goto :goto_0

    .line 1991
    :sswitch_c
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt64()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCancellationCount:J

    goto :goto_0

    .line 1987
    :sswitch_d
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt64()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccFailureCount:J

    goto :goto_0

    .line 1983
    :sswitch_e
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readBool()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCompleted:Z

    goto :goto_0

    .line 1979
    :sswitch_f
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->carrierId:I

    goto :goto_0

    .line 1975
    :sswitch_10
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readBool()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isEsim:Z

    goto/16 :goto_0

    .line 1971
    :sswitch_11
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readBool()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isMultiSim:Z

    goto/16 :goto_0

    .line 1967
    :sswitch_12
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->simSlotIndex:I

    goto/16 :goto_0

    .line 1963
    :sswitch_13
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->concurrentCallCountAtEnd:I

    goto/16 :goto_0

    .line 1959
    :sswitch_14
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->concurrentCallCountAtStart:I

    goto/16 :goto_0

    .line 1955
    :sswitch_15
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt64()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->codecBitmask:J

    goto/16 :goto_0

    .line 1951
    :sswitch_16
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt64()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratSwitchCount:J

    goto/16 :goto_0

    .line 1947
    :sswitch_17
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtEnd:I

    goto/16 :goto_0

    .line 1943
    :sswitch_18
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtStart:I

    goto/16 :goto_0

    .line 1939
    :sswitch_19
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraMessage:Ljava/lang/String;

    goto/16 :goto_0

    .line 1935
    :sswitch_1a
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraCode:I

    goto/16 :goto_0

    .line 1931
    :sswitch_1b
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectReasonCode:I

    goto/16 :goto_0

    .line 1927
    :sswitch_1c
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readBool()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupFailed:Z

    goto/16 :goto_0

    .line 1923
    :sswitch_1d
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDuration:I

    goto/16 :goto_0

    .line 1919
    :sswitch_1e
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->direction:I

    goto/16 :goto_0

    .line 1915
    :sswitch_1f
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtEnd:I

    goto/16 :goto_0

    .line 1911
    :sswitch_20
    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;->readInt32()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtStart:I

    goto/16 :goto_0

    :sswitch_21
    return-object p0

    nop

    :sswitch_data_0
    .sparse-switch
        0x0 -> :sswitch_21
        0x8 -> :sswitch_20
        0x10 -> :sswitch_1f
        0x18 -> :sswitch_1e
        0x20 -> :sswitch_1d
        0x28 -> :sswitch_1c
        0x30 -> :sswitch_1b
        0x38 -> :sswitch_1a
        0x42 -> :sswitch_19
        0x48 -> :sswitch_18
        0x50 -> :sswitch_17
        0x58 -> :sswitch_16
        0x60 -> :sswitch_15
        0x68 -> :sswitch_14
        0x70 -> :sswitch_13
        0x78 -> :sswitch_12
        0x80 -> :sswitch_11
        0x88 -> :sswitch_10
        0x90 -> :sswitch_f
        0x98 -> :sswitch_e
        0xa0 -> :sswitch_d
        0xa8 -> :sswitch_c
        0xb0 -> :sswitch_b
        0xb8 -> :sswitch_a
        0xc0 -> :sswitch_9
        0xc8 -> :sswitch_8
        0xd0 -> :sswitch_7
        0xd8 -> :sswitch_6
        0xe0 -> :sswitch_5
        0xe8 -> :sswitch_4
        0xf0 -> :sswitch_3
        0xf8 -> :sswitch_2
        0x100 -> :sswitch_1
        0x13888 -> :sswitch_0
    .end sparse-switch
.end method

.method public bridge synthetic mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/protobuf/nano/MessageNano;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 1493
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->mergeFrom(Lcom/android/internal/telephony/protobuf/nano/CodedInputByteBufferNano;)Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    move-result-object p0

    return-object p0
.end method

.method public writeTo(Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 1655
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtStart:I

    if-eqz v0, :cond_0

    const/4 v1, 0x1

    .line 1656
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1658
    :cond_0
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtEnd:I

    if-eqz v0, :cond_1

    const/4 v1, 0x2

    .line 1659
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1661
    :cond_1
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->direction:I

    if-eqz v0, :cond_2

    const/4 v1, 0x3

    .line 1662
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1664
    :cond_2
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDuration:I

    if-eqz v0, :cond_3

    const/4 v1, 0x4

    .line 1665
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1667
    :cond_3
    iget-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupFailed:Z

    if-eqz v0, :cond_4

    const/4 v1, 0x5

    .line 1668
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeBool(IZ)V

    .line 1670
    :cond_4
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectReasonCode:I

    if-eqz v0, :cond_5

    const/4 v1, 0x6

    .line 1671
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1673
    :cond_5
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraCode:I

    if-eqz v0, :cond_6

    const/4 v1, 0x7

    .line 1674
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1676
    :cond_6
    iget-object v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraMessage:Ljava/lang/String;

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_7

    const/16 v0, 0x8

    .line 1677
    iget-object v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraMessage:Ljava/lang/String;

    invoke-virtual {p1, v0, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeString(ILjava/lang/String;)V

    .line 1679
    :cond_7
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtStart:I

    if-eqz v0, :cond_8

    const/16 v1, 0x9

    .line 1680
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1682
    :cond_8
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtEnd:I

    if-eqz v0, :cond_9

    const/16 v1, 0xa

    .line 1683
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1685
    :cond_9
    iget-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratSwitchCount:J

    const-wide/16 v2, 0x0

    cmp-long v4, v0, v2

    if-eqz v4, :cond_a

    const/16 v4, 0xb

    .line 1686
    invoke-virtual {p1, v4, v0, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt64(IJ)V

    .line 1688
    :cond_a
    iget-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->codecBitmask:J

    cmp-long v4, v0, v2

    if-eqz v4, :cond_b

    const/16 v4, 0xc

    .line 1689
    invoke-virtual {p1, v4, v0, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt64(IJ)V

    .line 1691
    :cond_b
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->concurrentCallCountAtStart:I

    if-eqz v0, :cond_c

    const/16 v1, 0xd

    .line 1692
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1694
    :cond_c
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->concurrentCallCountAtEnd:I

    if-eqz v0, :cond_d

    const/16 v1, 0xe

    .line 1695
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1697
    :cond_d
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->simSlotIndex:I

    if-eqz v0, :cond_e

    const/16 v1, 0xf

    .line 1698
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1700
    :cond_e
    iget-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isMultiSim:Z

    if-eqz v0, :cond_f

    const/16 v1, 0x10

    .line 1701
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeBool(IZ)V

    .line 1703
    :cond_f
    iget-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isEsim:Z

    if-eqz v0, :cond_10

    const/16 v1, 0x11

    .line 1704
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeBool(IZ)V

    .line 1706
    :cond_10
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->carrierId:I

    if-eqz v0, :cond_11

    const/16 v1, 0x12

    .line 1707
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1709
    :cond_11
    iget-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCompleted:Z

    if-eqz v0, :cond_12

    const/16 v1, 0x13

    .line 1710
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeBool(IZ)V

    .line 1712
    :cond_12
    iget-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccFailureCount:J

    cmp-long v4, v0, v2

    if-eqz v4, :cond_13

    const/16 v4, 0x14

    .line 1713
    invoke-virtual {p1, v4, v0, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt64(IJ)V

    .line 1715
    :cond_13
    iget-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCancellationCount:J

    cmp-long v4, v0, v2

    if-eqz v4, :cond_14

    const/16 v4, 0x15

    .line 1716
    invoke-virtual {p1, v4, v0, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt64(IJ)V

    .line 1718
    :cond_14
    iget-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->rttEnabled:Z

    if-eqz v0, :cond_15

    const/16 v1, 0x16

    .line 1719
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeBool(IZ)V

    .line 1721
    :cond_15
    iget-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isEmergency:Z

    if-eqz v0, :cond_16

    const/16 v1, 0x17

    .line 1722
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeBool(IZ)V

    .line 1724
    :cond_16
    iget-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isRoaming:Z

    if-eqz v0, :cond_17

    const/16 v1, 0x18

    .line 1725
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeBool(IZ)V

    .line 1727
    :cond_17
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->signalStrengthAtEnd:I

    if-eqz v0, :cond_18

    const/16 v1, 0x19

    .line 1728
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1730
    :cond_18
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bandAtEnd:I

    if-eqz v0, :cond_19

    const/16 v1, 0x1a

    .line 1731
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1733
    :cond_19
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDurationMillis:I

    if-eqz v0, :cond_1a

    const/16 v1, 0x1b

    .line 1734
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1736
    :cond_1a
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->mainCodecQuality:I

    if-eqz v0, :cond_1b

    const/16 v1, 0x1c

    .line 1737
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1739
    :cond_1b
    iget-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->videoEnabled:Z

    if-eqz v0, :cond_1c

    const/16 v1, 0x1d

    .line 1740
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeBool(IZ)V

    .line 1742
    :cond_1c
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtConnected:I

    if-eqz v0, :cond_1d

    const/16 v1, 0x1e

    .line 1743
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1745
    :cond_1d
    iget-boolean v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isMultiparty:Z

    if-eqz v0, :cond_1e

    const/16 v1, 0x1f

    .line 1746
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeBool(IZ)V

    .line 1748
    :cond_1e
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->callDuration:I

    if-eqz v0, :cond_1f

    const/16 v1, 0x20

    .line 1749
    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt32(II)V

    .line 1751
    :cond_1f
    iget-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupBeginMillis:J

    cmp-long v2, v0, v2

    if-eqz v2, :cond_20

    const/16 v2, 0x2711

    .line 1752
    invoke-virtual {p1, v2, v0, v1}, Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;->writeInt64(IJ)V

    .line 1754
    :cond_20
    invoke-super {p0, p1}, Lcom/android/internal/telephony/protobuf/nano/ExtendableMessageNano;->writeTo(Lcom/android/internal/telephony/protobuf/nano/CodedOutputByteBufferNano;)V

    return-void
.end method
