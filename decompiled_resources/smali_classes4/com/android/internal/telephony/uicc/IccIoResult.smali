.class public Lcom/android/internal/telephony/uicc/IccIoResult;
.super Ljava/lang/Object;
.source "IccIoResult.java"


# static fields
.field private static final UNKNOWN_ERROR:Ljava/lang/String; = "unknown"


# instance fields
.field public payload:[B
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public sw1:I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public sw2:I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field


# direct methods
.method public constructor <init>(IILjava/lang/String;)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation

    .line 195
    invoke-static {p3}, Lcom/android/internal/telephony/uicc/IccUtils;->hexStringToBytes(Ljava/lang/String;)[B

    move-result-object p3

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/uicc/IccIoResult;-><init>(II[B)V

    return-void
.end method

.method public constructor <init>(II[B)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation

    .line 187
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 188
    iput p1, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw1:I

    .line 189
    iput p2, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    .line 190
    iput-object p3, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->payload:[B

    return-void
.end method

.method private getErrorString()Ljava/lang/String;
    .locals 10

    .line 37
    iget v0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw1:I

    const/16 v1, 0x98

    const/16 v2, 0x40

    const/16 v3, 0x8

    const/4 v4, 0x2

    const/4 v5, 0x4

    if-eq v0, v1, :cond_16

    const/16 v1, 0x9e

    const/4 v6, 0x0

    if-eq v0, v1, :cond_15

    const/16 v1, 0x9f

    if-eq v0, v1, :cond_15

    const-string v1, "memory problem"

    const/16 v7, 0x81

    packed-switch v0, :pswitch_data_0

    const-string v8, "no information given"

    const-string/jumbo v9, "the interpretation of this status word is command dependent"

    packed-switch v0, :pswitch_data_1

    packed-switch v0, :pswitch_data_2

    goto/16 :goto_0

    .line 142
    :pswitch_0
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    if-eqz p0, :cond_3

    if-eq p0, v4, :cond_2

    if-eq p0, v5, :cond_1

    if-eq p0, v3, :cond_0

    goto/16 :goto_0

    :cond_0
    const-string p0, "file is inconsistent with the command"

    return-object p0

    :cond_1
    const-string p0, "file ID not found/pattern not found"

    return-object p0

    :cond_2
    const-string p0, "out f range (invalid address)"

    return-object p0

    :cond_3
    const-string p0, "no EF selected"

    return-object p0

    .line 136
    :pswitch_1
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    if-eqz p0, :cond_4

    goto/16 :goto_0

    :cond_4
    const-string p0, "SIM Application Toolkit is busy. Command cannot be executed at present, further normal commands are allowed"

    return-object p0

    .line 128
    :pswitch_2
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    shr-int/lit8 v0, p0, 0x4

    if-nez v0, :cond_5

    const-string p0, "command successful but after using an internal update retry routine"

    return-object p0

    :cond_5
    if-eq p0, v2, :cond_6

    goto/16 :goto_0

    :cond_6
    return-object v1

    :pswitch_3
    return-object v6

    .line 119
    :pswitch_4
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    if-eqz p0, :cond_7

    return-object v9

    :cond_7
    const-string/jumbo p0, "technical problem with no diagnostic given"

    return-object p0

    :pswitch_5
    const-string/jumbo p0, "wrong instruction class given in the command"

    return-object p0

    :pswitch_6
    const-string/jumbo p0, "unknown instruction code given in the command"

    return-object p0

    .line 115
    :pswitch_7
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "wrong length, retry with "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :pswitch_8
    const-string p0, "incorrect parameter P1 or P2"

    return-object p0

    .line 103
    :pswitch_9
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    packed-switch p0, :pswitch_data_3

    :pswitch_a
    goto/16 :goto_0

    :pswitch_b
    const-string p0, "referenced data not found"

    return-object p0

    :pswitch_c
    const-string p0, "lc inconsistent with P1 to P2"

    return-object p0

    :pswitch_d
    const-string p0, "incorrect parameters P1 to P2"

    return-object p0

    :pswitch_e
    const-string p0, "not enough memory space"

    return-object p0

    :pswitch_f
    const-string p0, "record not found"

    return-object p0

    :pswitch_10
    const-string p0, "file not found"

    return-object p0

    :pswitch_11
    const-string p0, "function not supported"

    return-object p0

    :pswitch_12
    const-string p0, "incorrect parameters in the data field"

    return-object p0

    .line 90
    :pswitch_13
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    if-eqz p0, :cond_9

    const/16 v0, 0x89

    if-eq p0, v0, :cond_8

    packed-switch p0, :pswitch_data_4

    goto/16 :goto_0

    :pswitch_14
    const-string p0, "command not allowed (no EF selected)"

    return-object p0

    :pswitch_15
    const-string p0, "conditions of use not satisfied"

    return-object p0

    :pswitch_16
    const-string p0, "referenced data invalidated"

    return-object p0

    :pswitch_17
    const-string p0, "authentication/PIN method blocked"

    return-object p0

    :pswitch_18
    const-string p0, "security status not satisfied"

    return-object p0

    :pswitch_19
    const-string p0, "command incompatible with file structure"

    return-object p0

    :cond_8
    const-string p0, "command not allowed - secure channel - security not satisfied"

    return-object p0

    :cond_9
    return-object v8

    .line 83
    :pswitch_1a
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    if-eqz p0, :cond_c

    if-eq p0, v7, :cond_b

    const/16 v0, 0x82

    if-eq p0, v0, :cond_a

    goto/16 :goto_0

    :cond_a
    const-string p0, "secure messaging not supported"

    return-object p0

    :cond_b
    const-string p0, "logical channel not supported"

    return-object p0

    :cond_c
    return-object v8

    .line 77
    :pswitch_1b
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    if-eqz p0, :cond_d

    return-object v9

    :cond_d
    const-string p0, "incorrect parameter P3"

    return-object p0

    .line 71
    :pswitch_1c
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    if-eqz p0, :cond_f

    if-eq p0, v7, :cond_e

    goto/16 :goto_0

    :cond_e
    return-object v1

    :cond_f
    const-string p0, "no information given, state of non-volatile memory changed"

    return-object p0

    .line 65
    :pswitch_1d
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    if-eqz p0, :cond_10

    goto/16 :goto_0

    :cond_10
    const-string p0, "no information given, state of non-volatile memory unchanged"

    return-object p0

    .line 53
    :pswitch_1e
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    shr-int/lit8 v0, p0, 0x4

    const/16 v1, 0xc

    if-ne v0, v1, :cond_11

    and-int/lit8 p0, p0, 0xf

    .line 55
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "command successful but after using an internal update retry routine "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " times, or verification failed, "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " retries remaining"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_11
    const/16 v0, 0xf1

    if-eq p0, v0, :cond_13

    const/16 v0, 0xf2

    if-eq p0, v0, :cond_12

    goto :goto_0

    :cond_12
    const-string p0, "more data expected and proactive command pending"

    return-object p0

    :cond_13
    const-string p0, "more data expected"

    return-object p0

    .line 40
    :pswitch_1f
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    if-eqz p0, :cond_14

    packed-switch p0, :pswitch_data_5

    packed-switch p0, :pswitch_data_6

    goto :goto_0

    :pswitch_20
    const-string p0, "response data available"

    return-object p0

    :pswitch_21
    const-string p0, "more data available and proactive command pending"

    return-object p0

    :pswitch_22
    const-string p0, "more data available"

    return-object p0

    :pswitch_23
    const-string p0, "selected file in termination state"

    return-object p0

    :pswitch_24
    const-string p0, "selected file invalidated"

    return-object p0

    :pswitch_25
    const-string p0, "end of file/record reached before reading Le bytes"

    return-object p0

    :pswitch_26
    const-string p0, "part of returned data may be corrupted"

    return-object p0

    :cond_14
    const-string p0, "no information given, state of non volatile memory unchanged"

    return-object p0

    .line 38
    :pswitch_27
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " more response bytes available"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_15
    return-object v6

    .line 150
    :cond_16
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    if-eq p0, v4, :cond_1d

    if-eq p0, v5, :cond_1c

    if-eq p0, v3, :cond_1b

    const/16 v0, 0x10

    if-eq p0, v0, :cond_1a

    if-eq p0, v2, :cond_19

    const/16 v0, 0x50

    if-eq p0, v0, :cond_18

    const/16 v0, 0x62

    if-eq p0, v0, :cond_17

    packed-switch p0, :pswitch_data_7

    :goto_0
    const-string/jumbo p0, "unknown"

    return-object p0

    :pswitch_28
    const-string p0, "authentication error, no memory space available in EF_MUK"

    return-object p0

    :pswitch_29
    const-string p0, "authentication error, no memory space available"

    return-object p0

    :pswitch_2a
    const-string p0, "key freshness failure"

    return-object p0

    :pswitch_2b
    const-string p0, "authentication error, security context not supported"

    return-object p0

    :cond_17
    const-string p0, "authentication error, application specific"

    return-object p0

    :cond_18
    const-string p0, "increase cannot be performed, Max value reached"

    return-object p0

    :cond_19
    const-string/jumbo p0, "unsuccessful CHV verification, no attempt left/unsuccessful UNBLOCK CHV verification, no attempt left/CHV blocked/UNBLOCK CHV blocked"

    return-object p0

    :cond_1a
    const-string p0, "in contradiction with invalidation status"

    return-object p0

    :cond_1b
    const-string p0, "in contradiction with CHV status"

    return-object p0

    :cond_1c
    const-string p0, "access condition not fulfilled/unsuccessful CHV verification, at least one attempt left/unsuccessful UNBLOCK CHV verification, at least one attempt left/authentication failed"

    return-object p0

    :cond_1d
    const-string p0, "no CHV initialized"

    return-object p0

    nop

    :pswitch_data_0
    .packed-switch 0x61
        :pswitch_27
        :pswitch_1f
        :pswitch_1e
        :pswitch_1d
        :pswitch_1c
    .end packed-switch

    :pswitch_data_1
    .packed-switch 0x67
        :pswitch_1b
        :pswitch_1a
        :pswitch_13
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
    .end packed-switch

    :pswitch_data_2
    .packed-switch 0x90
        :pswitch_3
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch

    :pswitch_data_3
    .packed-switch 0x80
        :pswitch_12
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
        :pswitch_a
        :pswitch_d
        :pswitch_c
        :pswitch_b
    .end packed-switch

    :pswitch_data_4
    .packed-switch 0x81
        :pswitch_19
        :pswitch_18
        :pswitch_17
        :pswitch_16
        :pswitch_15
        :pswitch_14
    .end packed-switch

    :pswitch_data_5
    .packed-switch 0x81
        :pswitch_26
        :pswitch_25
        :pswitch_24
        :pswitch_23
    .end packed-switch

    :pswitch_data_6
    .packed-switch 0xf1
        :pswitch_22
        :pswitch_21
        :pswitch_20
    .end packed-switch

    :pswitch_data_7
    .packed-switch 0x64
        :pswitch_2b
        :pswitch_2a
        :pswitch_29
        :pswitch_28
    .end packed-switch
.end method


# virtual methods
.method public getException()Lcom/android/internal/telephony/uicc/IccException;
    .locals 3

    .line 223
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccIoResult;->success()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 225
    :cond_0
    iget v0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw1:I

    const/16 v1, 0x94

    if-eq v0, v1, :cond_1

    .line 233
    new-instance v0, Lcom/android/internal/telephony/uicc/IccException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "sw1:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw1:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " sw2:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/uicc/IccException;-><init>(Ljava/lang/String;)V

    return-object v0

    .line 227
    :cond_1
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    const/16 v0, 0x8

    if-ne p0, v0, :cond_2

    .line 228
    new-instance p0, Lcom/android/internal/telephony/uicc/IccFileTypeMismatch;

    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/IccFileTypeMismatch;-><init>()V

    return-object p0

    .line 230
    :cond_2
    new-instance p0, Lcom/android/internal/telephony/uicc/IccFileNotFound;

    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/IccFileNotFound;-><init>()V

    return-object p0
.end method

.method public success()Z
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation

    .line 216
    iget p0, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw1:I

    const/16 v0, 0x90

    if-eq p0, v0, :cond_1

    const/16 v0, 0x91

    if-eq p0, v0, :cond_1

    const/16 v0, 0x9e

    if-eq p0, v0, :cond_1

    const/16 v0, 0x9f

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 200
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "IccIoResult sw1:0x"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw1:I

    .line 201
    invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " sw2:0x"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    .line 203
    invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " Payload: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 205
    sget-boolean v1, Lcom/android/internal/telephony/util/TelephonyUtils;->IS_DEBUGGABLE:Z

    if-eqz v1, :cond_0

    iget-object v1, p0, Lcom/android/internal/telephony/uicc/IccIoResult;->payload:[B

    invoke-static {v1}, Lcom/android/internal/telephony/uicc/IccUtils;->bytesToHexString([B)Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    :cond_0
    const-string v1, "*******"

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 206
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccIoResult;->success()Z

    move-result v1

    if-nez v1, :cond_1

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, " Error: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/IccIoResult;->getErrorString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_1

    :cond_1
    const-string p0, ""

    :goto_1
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
