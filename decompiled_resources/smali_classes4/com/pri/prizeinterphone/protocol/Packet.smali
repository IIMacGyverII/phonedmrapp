.class public final Lcom/pri/prizeinterphone/protocol/Packet;
.super Ljava/lang/Object;
.source "Packet.java"


# static fields
.field public static final HEADER_LEN:I = 0x8


# instance fields
.field public body:[B

.field public ckSum:S

.field public cmd:B

.field public head:B

.field public len:S

.field public rw:B

.field public sr:B

.field public final tail:B


# direct methods
.method public constructor <init>(B)V
    .locals 1

    .line 68
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/16 v0, 0x68

    .line 12
    iput-byte v0, p0, Lcom/pri/prizeinterphone/protocol/Packet;->head:B

    const/16 v0, 0x10

    .line 66
    iput-byte v0, p0, Lcom/pri/prizeinterphone/protocol/Packet;->tail:B

    .line 69
    iput-byte p1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    return-void
.end method

.method public static cmd2Str(I)Ljava/lang/String;
    .locals 1

    const/16 v0, -0x56

    if-eq p0, v0, :cond_0

    packed-switch p0, :pswitch_data_0

    const-string/jumbo p0, "unknown"

    return-object p0

    :pswitch_0
    const-string p0, "SET_SPK_EN_CMD"

    return-object p0

    :pswitch_1
    const-string p0, "SET_TOTO_CMD"

    return-object p0

    :pswitch_2
    const-string p0, "SET_SMS_PROTOCOL_TYPE_CMD"

    return-object p0

    :pswitch_3
    const-string p0, "QUERY_MIX_CHECK_INFO_CMD"

    return-object p0

    :pswitch_4
    const-string p0, "SET_MIX_CHECK_INFO_CMD"

    return-object p0

    :pswitch_5
    const-string p0, "SET_POLITE_POLICY_CMD"

    return-object p0

    :pswitch_6
    const-string p0, "MODULE_PRINT_STATUS_INFO_CMD"

    return-object p0

    :pswitch_7
    const-string p0, "INTERRUPT_TRANSMIT_CMD"

    return-object p0

    :pswitch_8
    const-string p0, "QUERY_VERSION_CMD"

    return-object p0

    :pswitch_9
    const-string p0, "SET_OFFLINE_MODE_CMD"

    return-object p0

    :pswitch_a
    const-string p0, "QUERY_SIGNAL_STRENGTH_CMD"

    return-object p0

    :pswitch_b
    const-string p0, "SET_POWER_SAVE_MODE_CMD"

    return-object p0

    :pswitch_c
    const-string p0, "SET_SQUELCH_CMD"

    return-object p0

    :pswitch_d
    const-string p0, "SET_LISTEN_CMD"

    return-object p0

    :pswitch_e
    const-string p0, "SET_VOL_CMD"

    return-object p0

    :pswitch_f
    const-string p0, "RECEIVE_SMS_CMD"

    return-object p0

    :pswitch_10
    const-string p0, "SEND_SMS_CMD"

    return-object p0

    :pswitch_11
    const-string p0, "QUERY_DIGITAL_AUDIO_RECEIVE_INFO"

    return-object p0

    :pswitch_12
    const-string p0, "SET_GAIN_MIC_CMD"

    return-object p0

    :pswitch_13
    const-string p0, "SET_ENCRYPT_FUNCTION_CMD"

    return-object p0

    :pswitch_14
    const-string p0, "SET_ENHANCE_FUNCTION_CMD"

    return-object p0

    :pswitch_15
    const-string p0, "QUERY_INIT_STATUS_CMD"

    return-object p0

    :pswitch_16
    const-string p0, "SET_LAUNCH_INFO_CMD"

    return-object p0

    :pswitch_17
    const-string p0, "QUERY_ANALOG_INFO_CMD"

    return-object p0

    :pswitch_18
    const-string p0, "QUERY_DIGITAL_INFO_CMD"

    return-object p0

    :pswitch_19
    const-string p0, "SET_ANALOG_INFO_CMD"

    return-object p0

    :pswitch_1a
    const-string p0, "SET_DIGITAL_INFO_CMD"

    return-object p0

    :cond_0
    const-string p0, "MODULE_INIT_CMD"

    return-object p0

    nop

    :pswitch_data_0
    .packed-switch 0x22
        :pswitch_1a
        :pswitch_19
        :pswitch_18
        :pswitch_17
        :pswitch_16
        :pswitch_15
        :pswitch_14
        :pswitch_13
        :pswitch_12
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method


# virtual methods
.method public getBodyLength()I
    .locals 0

    .line 89
    iget-object p0, p0, Lcom/pri/prizeinterphone/protocol/Packet;->body:[B

    if-nez p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    array-length p0, p0

    :goto_0
    return p0
.end method

.method public getCmd()B
    .locals 0

    .line 81
    iget-byte p0, p0, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    return p0
.end method

.method public getHead()B
    .locals 0

    .line 73
    iget-byte p0, p0, Lcom/pri/prizeinterphone/protocol/Packet;->head:B

    return p0
.end method

.method public setCmd(B)V
    .locals 0

    .line 85
    iput-byte p1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    return-void
.end method

.method public setHead(B)V
    .locals 0

    .line 77
    iput-byte p1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->head:B

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 3
    .annotation build Landroidx/annotation/NonNull;
    .end annotation

    .line 96
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Packet{head="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->head:B

    and-int/lit16 v1, v1, 0xff

    .line 97
    invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", cmd="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    and-int/lit16 v1, v1, 0xff

    .line 98
    invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->cmd:B

    invoke-static {v1}, Lcom/pri/prizeinterphone/protocol/Packet;->cmd2Str(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "), rw="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->rw:B

    and-int/lit16 v1, v1, 0xff

    .line 99
    invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", sr="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-byte v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->sr:B

    and-int/lit16 v1, v1, 0xff

    .line 100
    invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", ckSum="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-short v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->ckSum:S

    const v2, 0xffff

    and-int/2addr v1, v2

    .line 101
    invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", len="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-short v1, p0, Lcom/pri/prizeinterphone/protocol/Packet;->len:S

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", body="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/pri/prizeinterphone/protocol/Packet;->body:[B

    .line 103
    invoke-static {p0}, Ljava/util/Arrays;->toString([B)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ", tail="

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 p0, 0x10

    .line 104
    invoke-static {p0}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
