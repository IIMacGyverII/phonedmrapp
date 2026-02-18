.class public Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;
.super Landroid/os/Handler;
.source "UsimDataDownloadHandler.java"


# static fields
.field private static final BER_SMS_PP_DOWNLOAD_TAG:I = 0xd1

.field private static final DEV_ID_NETWORK:I = 0x83

.field private static final DEV_ID_UICC:I = 0x81

.field private static final EVENT_SEND_ENVELOPE_RESPONSE:I = 0x2

.field private static final EVENT_START_DATA_DOWNLOAD:I = 0x1

.field private static final EVENT_WRITE_SMS_COMPLETE:I = 0x3

.field private static final TAG:Ljava/lang/String; = "UsimDataDownloadHandler"


# instance fields
.field private final mCi:Lcom/android/internal/telephony/CommandsInterface;

.field private final mPhoneId:I


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/CommandsInterface;I)V
    .locals 0

    .line 65
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    .line 66
    iput-object p1, p0, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 67
    iput p2, p0, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->mPhoneId:I

    return-void
.end method

.method private acknowledgeSmsWithError(I)V
    .locals 2

    .line 276
    iget-object p0, p0, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v0, 0x0

    const/4 v1, 0x0

    invoke-interface {p0, v0, p1, v1}, Lcom/android/internal/telephony/CommandsInterface;->acknowledgeLastIncomingGsmSms(ZILandroid/os/Message;)V

    return-void
.end method

.method private addUsimDataDownloadToMetrics(ZI)V
    .locals 3

    .line 297
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object v0

    .line 298
    iget v1, p0, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->mPhoneId:I

    const-string v2, "3gpp"

    invoke-virtual {v0, v1, v2, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeIncomingSMSPP(ILjava/lang/String;Z)V

    .line 299
    iget p0, p0, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->mPhoneId:I

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSmsStats()Lcom/android/internal/telephony/metrics/SmsStats;

    move-result-object p0

    invoke-virtual {p0, p2, p1}, Lcom/android/internal/telephony/metrics/SmsStats;->onIncomingSmsPP(IZ)V

    return-void
.end method

.method private static getEnvelopeBodyLength(II)I
    .locals 2

    add-int/lit8 v0, p1, 0x5

    const/16 v1, 0x7f

    if-le p1, v1, :cond_0

    const/4 p1, 0x2

    goto :goto_0

    :cond_0
    const/4 p1, 0x1

    :goto_0
    add-int/2addr v0, p1

    if-eqz p0, :cond_1

    add-int/lit8 v0, v0, 0x2

    add-int/2addr v0, p0

    :cond_1
    return v0
.end method

.method private handleDataDownload(Lcom/android/internal/telephony/gsm/SmsMessage;I)V
    .locals 19

    move-object/from16 v0, p0

    move/from16 v1, p2

    .line 126
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/gsm/SmsMessage;->getDataCodingScheme()I

    move-result v2

    .line 127
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/gsm/SmsMessage;->getProtocolIdentifier()I

    move-result v3

    .line 128
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/gsm/SmsMessage;->getPdu()[B

    move-result-object v4

    const/4 v5, 0x0

    .line 130
    aget-byte v6, v4, v5

    const/16 v7, 0xff

    and-int/2addr v6, v7

    add-int/lit8 v8, v6, 0x1

    .line 132
    array-length v9, v4

    sub-int/2addr v9, v8

    .line 134
    invoke-static {v6, v9}, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->getEnvelopeBodyLength(II)I

    move-result v10

    add-int/lit8 v11, v10, 0x1

    const/16 v12, 0x7f

    const/4 v13, 0x2

    const/4 v14, 0x1

    if-le v10, v12, :cond_0

    move v15, v13

    goto :goto_0

    :cond_0
    move v15, v14

    :goto_0
    add-int/2addr v11, v15

    .line 140
    new-array v15, v11, [B

    const/16 v16, -0x2f

    .line 144
    aput-byte v16, v15, v5

    const/16 v16, -0x7f

    if-le v10, v12, :cond_1

    .line 146
    aput-byte v16, v15, v14

    move/from16 v17, v13

    goto :goto_1

    :cond_1
    move/from16 v17, v14

    :goto_1
    add-int/lit8 v18, v17, 0x1

    int-to-byte v10, v10

    .line 148
    aput-byte v10, v15, v17

    add-int/lit8 v10, v18, 0x1

    .line 151
    sget-object v17, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->DEVICE_IDENTITIES:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    invoke-virtual/range {v17 .. v17}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->value()I

    move-result v5

    or-int/lit16 v5, v5, 0x80

    int-to-byte v5, v5

    aput-byte v5, v15, v18

    add-int/lit8 v5, v10, 0x1

    .line 152
    aput-byte v13, v15, v10

    add-int/lit8 v10, v5, 0x1

    const/16 v17, -0x7d

    .line 153
    aput-byte v17, v15, v5

    add-int/lit8 v5, v10, 0x1

    .line 154
    aput-byte v16, v15, v10

    if-eqz v6, :cond_2

    add-int/lit8 v10, v5, 0x1

    .line 158
    sget-object v17, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->ADDRESS:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    invoke-virtual/range {v17 .. v17}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->value()I

    move-result v13

    int-to-byte v13, v13

    aput-byte v13, v15, v5

    add-int/lit8 v5, v10, 0x1

    int-to-byte v13, v6

    .line 159
    aput-byte v13, v15, v10

    .line 160
    invoke-static {v4, v14, v15, v5, v6}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    add-int/2addr v5, v6

    :cond_2
    add-int/lit8 v6, v5, 0x1

    .line 165
    sget-object v10, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->SMS_TPDU:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    invoke-virtual {v10}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->value()I

    move-result v10

    or-int/lit16 v10, v10, 0x80

    int-to-byte v10, v10

    aput-byte v10, v15, v5

    if-le v9, v12, :cond_3

    add-int/lit8 v5, v6, 0x1

    .line 167
    aput-byte v16, v15, v6

    move v6, v5

    :cond_3
    add-int/lit8 v5, v6, 0x1

    int-to-byte v10, v9

    .line 169
    aput-byte v10, v15, v6

    .line 170
    invoke-static {v4, v8, v15, v5, v9}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    add-int/2addr v5, v9

    if-eq v5, v11, :cond_4

    const-string v2, "UsimDataDownloadHandler"

    const-string/jumbo v3, "startDataDownload() calculated incorrect envelope length, aborting."

    .line 175
    invoke-static {v2, v3}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 176
    invoke-direct {v0, v7}, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->acknowledgeSmsWithError(I)V

    const/4 v4, 0x0

    .line 177
    invoke-direct {v0, v4, v1}, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->addUsimDataDownloadToMetrics(ZI)V

    return-void

    :cond_4
    const/4 v4, 0x0

    .line 181
    invoke-static {v15}, Lcom/android/internal/telephony/uicc/IccUtils;->bytesToHexString([B)Ljava/lang/String;

    move-result-object v5

    .line 182
    iget-object v6, v0, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v7, 0x2

    new-array v8, v7, [I

    aput v2, v8, v4

    aput v3, v8, v14

    invoke-virtual {v0, v7, v8}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v2

    invoke-interface {v6, v5, v2}, Lcom/android/internal/telephony/CommandsInterface;->sendEnvelopeWithStatus(Ljava/lang/String;Landroid/os/Message;)V

    .line 185
    invoke-direct {v0, v14, v1}, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->addUsimDataDownloadToMetrics(ZI)V

    return-void
.end method

.method private static is7bitDcs(I)Z
    .locals 1

    and-int/lit16 v0, p0, 0x8c

    if-eqz v0, :cond_1

    and-int/lit16 p0, p0, 0xf4

    const/16 v0, 0xf0

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

.method private sendSmsAckForEnvelopeResponse(Lcom/android/internal/telephony/uicc/IccIoResult;II)V
    .locals 8

    .line 215
    iget v0, p1, Lcom/android/internal/telephony/uicc/IccIoResult;->sw1:I

    .line 216
    iget v1, p1, Lcom/android/internal/telephony/uicc/IccIoResult;->sw2:I

    const-string v2, "UsimDataDownloadHandler"

    const/4 v3, 0x0

    const/4 v4, 0x1

    const/16 v5, 0x90

    if-ne v0, v5, :cond_0

    if-eqz v1, :cond_1

    :cond_0
    const/16 v5, 0x91

    if-ne v0, v5, :cond_2

    .line 220
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "USIM data download succeeded: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/IccIoResult;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    move v0, v4

    goto :goto_2

    :cond_2
    const/16 v5, 0x93

    if-ne v0, v5, :cond_3

    if-nez v1, :cond_3

    const-string p1, "USIM data download failed: Toolkit busy"

    .line 223
    invoke-static {v2, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/16 p1, 0xd4

    .line 224
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->acknowledgeSmsWithError(I)V

    return-void

    :cond_3
    const/16 v1, 0x62

    if-eq v0, v1, :cond_5

    const/16 v1, 0x63

    if-ne v0, v1, :cond_4

    goto :goto_0

    .line 230
    :cond_4
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unexpected SW1/SW2 response from UICC: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/IccIoResult;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    .line 227
    :cond_5
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "USIM data download failed: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/IccIoResult;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_1
    move v0, v3

    .line 234
    :goto_2
    iget-object p1, p1, Lcom/android/internal/telephony/uicc/IccIoResult;->payload:[B

    const/4 v1, 0x0

    if-eqz p1, :cond_9

    .line 235
    array-length v2, p1

    if-nez v2, :cond_6

    goto :goto_5

    :cond_6
    const/4 v2, 0x2

    const/4 v5, 0x7

    if-eqz v0, :cond_7

    .line 248
    array-length v6, p1

    add-int/lit8 v6, v6, 0x5

    new-array v6, v6, [B

    .line 249
    aput-byte v3, v6, v3

    .line 250
    aput-byte v5, v6, v4

    goto :goto_3

    .line 252
    :cond_7
    array-length v6, p1

    add-int/lit8 v6, v6, 0x6

    new-array v6, v6, [B

    .line 253
    aput-byte v3, v6, v3

    const/16 v7, -0x2b

    .line 254
    aput-byte v7, v6, v4

    const/4 v4, 0x3

    .line 256
    aput-byte v5, v6, v2

    move v2, v4

    :goto_3
    add-int/lit8 v4, v2, 0x1

    int-to-byte p3, p3

    .line 259
    aput-byte p3, v6, v2

    add-int/lit8 p3, v4, 0x1

    int-to-byte v2, p2

    .line 260
    aput-byte v2, v6, v4

    .line 262
    invoke-static {p2}, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->is7bitDcs(I)Z

    move-result p2

    if-eqz p2, :cond_8

    .line 263
    array-length p2, p1

    mul-int/lit8 p2, p2, 0x8

    div-int/2addr p2, v5

    add-int/lit8 v2, p3, 0x1

    int-to-byte p2, p2

    .line 264
    aput-byte p2, v6, p3

    goto :goto_4

    :cond_8
    add-int/lit8 v2, p3, 0x1

    .line 266
    array-length p2, p1

    int-to-byte p2, p2

    aput-byte p2, v6, p3

    .line 269
    :goto_4
    array-length p2, p1

    invoke-static {p1, v3, v6, v2, p2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 271
    iget-object p0, p0, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 272
    invoke-static {v6}, Lcom/android/internal/telephony/uicc/IccUtils;->bytesToHexString([B)Ljava/lang/String;

    move-result-object p1

    .line 271
    invoke-interface {p0, v0, p1, v1}, Lcom/android/internal/telephony/CommandsInterface;->acknowledgeIncomingGsmSmsWithPdu(ZLjava/lang/String;Landroid/os/Message;)V

    return-void

    :cond_9
    :goto_5
    if-eqz v0, :cond_a

    .line 237
    iget-object p0, p0, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, v4, v3, v1}, Lcom/android/internal/telephony/CommandsInterface;->acknowledgeLastIncomingGsmSms(ZILandroid/os/Message;)V

    goto :goto_6

    :cond_a
    const/16 p1, 0xd5

    .line 239
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->acknowledgeSmsWithError(I)V

    :goto_6
    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 5

    .line 311
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_4

    const/4 v2, 0x2

    const/4 v3, 0x0

    const-string v4, "UsimDataDownloadHandler"

    if-eq v0, v2, :cond_2

    const/4 v2, 0x3

    if-eq v0, v2, :cond_0

    .line 343
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Ignoring unexpected message, what="

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v4, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 331
    :cond_0
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 332
    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    const/4 v0, 0x0

    if-nez p1, :cond_1

    const-string p1, "Successfully wrote SMS-PP message to UICC"

    .line 333
    invoke-static {v4, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 334
    iget-object p0, p0, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, v1, v3, v0}, Lcom/android/internal/telephony/CommandsInterface;->acknowledgeLastIncomingGsmSms(ZILandroid/os/Message;)V

    goto :goto_0

    :cond_1
    const-string v1, "Failed to write SMS-PP message to UICC"

    .line 336
    invoke-static {v4, v1, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 337
    iget-object p0, p0, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 p1, 0xff

    invoke-interface {p0, v3, p1, v0}, Lcom/android/internal/telephony/CommandsInterface;->acknowledgeLastIncomingGsmSms(ZILandroid/os/Message;)V

    goto :goto_0

    .line 317
    :cond_2
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 319
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz v0, :cond_3

    .line 320
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UICC Send Envelope failure, exception: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v4, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/16 p1, 0xd5

    .line 321
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->acknowledgeSmsWithError(I)V

    return-void

    .line 326
    :cond_3
    iget-object v0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v0, [I

    .line 327
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/uicc/IccIoResult;

    aget v2, v0, v3

    aget v0, v0, v1

    invoke-direct {p0, p1, v2, v0}, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->sendSmsAckForEnvelopeResponse(Lcom/android/internal/telephony/uicc/IccIoResult;II)V

    goto :goto_0

    .line 313
    :cond_4
    iget-object v0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v0, Lcom/android/internal/telephony/gsm/SmsMessage;

    iget p1, p1, Landroid/os/Message;->arg1:I

    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->handleDataDownload(Lcom/android/internal/telephony/gsm/SmsMessage;I)V

    :goto_0
    return-void
.end method

.method handleUsimDataDownload(Lcom/android/internal/telephony/uicc/UsimServiceTable;Lcom/android/internal/telephony/gsm/SmsMessage;I)I
    .locals 3

    const-string v0, "UsimDataDownloadHandler"

    if-eqz p1, :cond_0

    .line 87
    sget-object v1, Lcom/android/internal/telephony/uicc/UsimServiceTable$UsimService;->DATA_DL_VIA_SMS_PP:Lcom/android/internal/telephony/uicc/UsimServiceTable$UsimService;

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/uicc/UsimServiceTable;->isAvailable(Lcom/android/internal/telephony/uicc/UsimServiceTable$UsimService;)Z

    move-result p1

    if-eqz p1, :cond_0

    const-string p1, "Received SMS-PP data download, sending to UICC."

    .line 89
    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 90
    invoke-virtual {p0, p2, p3}, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->startDataDownload(Lcom/android/internal/telephony/gsm/SmsMessage;I)I

    move-result p0

    return p0

    :cond_0
    const-string p1, "DATA_DL_VIA_SMS_PP service not available, storing message to UICC."

    .line 92
    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 95
    invoke-virtual {p2}, Lcom/android/internal/telephony/gsm/SmsMessage;->getServiceCenterAddress()Ljava/lang/String;

    move-result-object p1

    .line 94
    invoke-static {p1}, Landroid/telephony/PhoneNumberUtils;->networkPortionToCalledPartyBCDWithLength(Ljava/lang/String;)[B

    move-result-object p1

    .line 93
    invoke-static {p1}, Lcom/android/internal/telephony/uicc/IccUtils;->bytesToHexString([B)Ljava/lang/String;

    move-result-object p1

    .line 96
    iget-object v0, p0, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 97
    invoke-virtual {p2}, Lcom/android/internal/telephony/gsm/SmsMessage;->getPdu()[B

    move-result-object p2

    invoke-static {p2}, Lcom/android/internal/telephony/uicc/IccUtils;->bytesToHexString([B)Ljava/lang/String;

    move-result-object p2

    const/4 v1, 0x3

    .line 98
    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v2

    .line 96
    invoke-interface {v0, v1, p1, p2, v2}, Lcom/android/internal/telephony/CommandsInterface;->writeSmsToSim(ILjava/lang/String;Ljava/lang/String;Landroid/os/Message;)V

    const/4 p1, 0x0

    .line 99
    invoke-direct {p0, p1, p3}, Lcom/android/internal/telephony/gsm/UsimDataDownloadHandler;->addUsimDataDownloadToMetrics(ZI)V

    const/4 p0, -0x1

    return p0
.end method

.method public startDataDownload(Lcom/android/internal/telephony/gsm/SmsMessage;I)I
    .locals 2

    const/4 v0, 0x1

    const/4 v1, 0x0

    .line 115
    invoke-virtual {p0, v0, p2, v1, p1}, Landroid/os/Handler;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, -0x1

    return p0

    :cond_0
    const-string p0, "UsimDataDownloadHandler"

    const-string/jumbo p1, "startDataDownload failed to send message to start data download."

    .line 119
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x2

    return p0
.end method
