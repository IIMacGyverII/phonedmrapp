.class public Landroid/telephony/gsm/SmsMessage;
.super Ljava/lang/Object;
.source "SmsMessage.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroid/telephony/gsm/SmsMessage$SubmitPdu;,
        Landroid/telephony/gsm/SmsMessage$MessageClass;
    }
.end annotation

.annotation runtime Ljava/lang/Deprecated;
.end annotation


# static fields
.field public static final ENCODING_16BIT:I = 0x3
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation
.end field

.field public static final ENCODING_7BIT:I = 0x1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation
.end field

.field public static final ENCODING_8BIT:I = 0x2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation
.end field

.field public static final ENCODING_UNKNOWN:I = 0x0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation
.end field

.field public static final MAX_USER_DATA_BYTES:I = 0x8c
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation
.end field

.field public static final MAX_USER_DATA_BYTES_WITH_HEADER:I = 0x86
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation
.end field

.field public static final MAX_USER_DATA_SEPTETS:I = 0xa0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation
.end field

.field public static final MAX_USER_DATA_SEPTETS_WITH_HEADER:I = 0x99
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation
.end field


# instance fields
.field public mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 139
    invoke-static {}, Landroid/telephony/gsm/SmsMessage;->getSmsFacility()Lcom/android/internal/telephony/SmsMessageBase;

    move-result-object v0

    invoke-direct {p0, v0}, Landroid/telephony/gsm/SmsMessage;-><init>(Lcom/android/internal/telephony/SmsMessageBase;)V

    return-void
.end method

.method private constructor <init>(Lcom/android/internal/telephony/SmsMessageBase;)V
    .locals 0

    .line 142
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 143
    iput-object p1, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    return-void
.end method

.method public static calculateLength(Ljava/lang/CharSequence;Z)[I
    .locals 2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 200
    invoke-static {p0, p1}, Lcom/android/internal/telephony/gsm/SmsMessage;->calculateLength(Ljava/lang/CharSequence;Z)Lcom/android/internal/telephony/GsmAlphabet$TextEncodingDetails;

    move-result-object p0

    const/4 p1, 0x4

    new-array p1, p1, [I

    .line 202
    iget v0, p0, Lcom/android/internal/telephony/GsmAlphabet$TextEncodingDetails;->msgCount:I

    const/4 v1, 0x0

    aput v0, p1, v1

    .line 203
    iget v0, p0, Lcom/android/internal/telephony/GsmAlphabet$TextEncodingDetails;->codeUnitCount:I

    const/4 v1, 0x1

    aput v0, p1, v1

    .line 204
    iget v0, p0, Lcom/android/internal/telephony/GsmAlphabet$TextEncodingDetails;->codeUnitsRemaining:I

    const/4 v1, 0x2

    aput v0, p1, v1

    .line 205
    iget p0, p0, Lcom/android/internal/telephony/GsmAlphabet$TextEncodingDetails;->codeUnitSize:I

    const/4 v0, 0x3

    aput p0, p1, v0

    return-object p1
.end method

.method public static calculateLength(Ljava/lang/String;Z)[I
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 227
    invoke-static {p0, p1}, Landroid/telephony/gsm/SmsMessage;->calculateLength(Ljava/lang/CharSequence;Z)[I

    move-result-object p0

    return-object p0
.end method

.method public static createFromPdu([B)Landroid/telephony/gsm/SmsMessage;
    .locals 2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 153
    invoke-static {}, Landroid/telephony/TelephonyManager;->getDefault()Landroid/telephony/TelephonyManager;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getCurrentPhoneType()I

    move-result v0

    const/4 v1, 0x2

    if-ne v1, v0, :cond_0

    .line 156
    invoke-static {p0}, Lcom/android/internal/telephony/cdma/SmsMessage;->createFromPdu([B)Lcom/android/internal/telephony/cdma/SmsMessage;

    move-result-object p0

    goto :goto_0

    .line 158
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/gsm/SmsMessage;->createFromPdu([B)Lcom/android/internal/telephony/gsm/SmsMessage;

    move-result-object p0

    .line 161
    :goto_0
    new-instance v0, Landroid/telephony/gsm/SmsMessage;

    invoke-direct {v0, p0}, Landroid/telephony/gsm/SmsMessage;-><init>(Lcom/android/internal/telephony/SmsMessageBase;)V

    return-object v0
.end method

.method private static final getSmsFacility()Lcom/android/internal/telephony/SmsMessageBase;
    .locals 2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 618
    invoke-static {}, Landroid/telephony/TelephonyManager;->getDefault()Landroid/telephony/TelephonyManager;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getCurrentPhoneType()I

    move-result v0

    const/4 v1, 0x2

    if-ne v1, v0, :cond_0

    .line 620
    new-instance v0, Lcom/android/internal/telephony/cdma/SmsMessage;

    invoke-direct {v0}, Lcom/android/internal/telephony/cdma/SmsMessage;-><init>()V

    return-object v0

    .line 622
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/gsm/SmsMessage;

    invoke-direct {v0}, Lcom/android/internal/telephony/gsm/SmsMessage;-><init>()V

    return-object v0
.end method

.method public static getSubmitPdu(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Landroid/telephony/gsm/SmsMessage$SubmitPdu;
    .locals 2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 272
    invoke-static {}, Landroid/telephony/TelephonyManager;->getDefault()Landroid/telephony/TelephonyManager;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getCurrentPhoneType()I

    move-result v0

    const/4 v1, 0x2

    if-ne v1, v0, :cond_0

    const/4 v0, 0x0

    .line 275
    invoke-static {p0, p1, p2, p3, v0}, Lcom/android/internal/telephony/cdma/SmsMessage;->getSubmitPdu(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLcom/android/internal/telephony/SmsHeader;)Lcom/android/internal/telephony/cdma/SmsMessage$SubmitPdu;

    move-result-object p0

    goto :goto_0

    .line 278
    :cond_0
    invoke-static {p0, p1, p2, p3}, Lcom/android/internal/telephony/gsm/SmsMessage;->getSubmitPdu(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Lcom/android/internal/telephony/gsm/SmsMessage$SubmitPdu;

    move-result-object p0

    .line 282
    :goto_0
    new-instance p1, Landroid/telephony/gsm/SmsMessage$SubmitPdu;

    invoke-direct {p1, p0}, Landroid/telephony/gsm/SmsMessage$SubmitPdu;-><init>(Lcom/android/internal/telephony/SmsMessageBase$SubmitPduBase;)V

    return-object p1
.end method

.method public static getSubmitPdu(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z[B)Landroid/telephony/gsm/SmsMessage$SubmitPdu;
    .locals 2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 245
    invoke-static {}, Landroid/telephony/TelephonyManager;->getDefault()Landroid/telephony/TelephonyManager;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getCurrentPhoneType()I

    move-result v0

    const/4 v1, 0x2

    if-ne v1, v0, :cond_0

    .line 250
    invoke-static {p4}, Lcom/android/internal/telephony/SmsHeader;->fromByteArray([B)Lcom/android/internal/telephony/SmsHeader;

    move-result-object p4

    .line 248
    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/cdma/SmsMessage;->getSubmitPdu(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLcom/android/internal/telephony/SmsHeader;)Lcom/android/internal/telephony/cdma/SmsMessage$SubmitPdu;

    move-result-object p0

    goto :goto_0

    .line 252
    :cond_0
    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/gsm/SmsMessage;->getSubmitPdu(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z[B)Lcom/android/internal/telephony/gsm/SmsMessage$SubmitPdu;

    move-result-object p0

    .line 256
    :goto_0
    new-instance p1, Landroid/telephony/gsm/SmsMessage$SubmitPdu;

    invoke-direct {p1, p0}, Landroid/telephony/gsm/SmsMessage$SubmitPdu;-><init>(Lcom/android/internal/telephony/SmsMessageBase$SubmitPduBase;)V

    return-object p1
.end method

.method public static getSubmitPdu(Ljava/lang/String;Ljava/lang/String;S[BZ)Landroid/telephony/gsm/SmsMessage$SubmitPdu;
    .locals 2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 303
    invoke-static {}, Landroid/telephony/TelephonyManager;->getDefault()Landroid/telephony/TelephonyManager;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getCurrentPhoneType()I

    move-result v0

    const/4 v1, 0x2

    if-ne v1, v0, :cond_0

    .line 306
    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/cdma/SmsMessage;->getSubmitPdu(Ljava/lang/String;Ljava/lang/String;I[BZ)Lcom/android/internal/telephony/cdma/SmsMessage$SubmitPdu;

    move-result-object p0

    goto :goto_0

    .line 309
    :cond_0
    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/gsm/SmsMessage;->getSubmitPdu(Ljava/lang/String;Ljava/lang/String;I[BZ)Lcom/android/internal/telephony/gsm/SmsMessage$SubmitPdu;

    move-result-object p0

    .line 313
    :goto_0
    new-instance p1, Landroid/telephony/gsm/SmsMessage$SubmitPdu;

    invoke-direct {p1, p0}, Landroid/telephony/gsm/SmsMessage$SubmitPdu;-><init>(Lcom/android/internal/telephony/SmsMessageBase$SubmitPduBase;)V

    return-object p1
.end method

.method public static getTPLayerLengthForPDU(Ljava/lang/String;)I
    .locals 2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 171
    invoke-static {}, Landroid/telephony/TelephonyManager;->getDefault()Landroid/telephony/TelephonyManager;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getCurrentPhoneType()I

    move-result v0

    const/4 v1, 0x2

    if-ne v1, v0, :cond_0

    .line 174
    invoke-static {p0}, Lcom/android/internal/telephony/cdma/SmsMessage;->getTPLayerLengthForPDU(Ljava/lang/String;)I

    move-result p0

    return p0

    .line 176
    :cond_0
    invoke-static {p0}, Lcom/android/internal/telephony/gsm/SmsMessage;->getTPLayerLengthForPDU(Ljava/lang/String;)I

    move-result p0

    return p0
.end method


# virtual methods
.method public getDisplayMessageBody()Ljava/lang/String;
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 375
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getDisplayMessageBody()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getDisplayOriginatingAddress()Ljava/lang/String;
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 344
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getDisplayOriginatingAddress()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getEmailBody()Ljava/lang/String;
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 416
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getEmailBody()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getEmailFrom()Ljava/lang/String;
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 426
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getEmailFrom()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getIndexOnIcc()I
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 567
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getIndexOnIcc()I

    move-result p0

    return p0
.end method

.method public getIndexOnSim()I
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 554
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getIndexOnIcc()I

    move-result p0

    return p0
.end method

.method public getMessageBody()Ljava/lang/String;
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 354
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getMessageBody()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getMessageClass()Landroid/telephony/gsm/SmsMessage$MessageClass;
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 363
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getMessageClass()Lcom/android/internal/telephony/SmsConstants$MessageClass;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsConstants$MessageClass;->ordinal()I

    move-result p0

    .line 365
    invoke-static {}, Landroid/telephony/gsm/SmsMessage$MessageClass;->values()[Landroid/telephony/gsm/SmsMessage$MessageClass;

    move-result-object v0

    aget-object p0, v0, p0

    return-object p0
.end method

.method public getOriginatingAddress()Ljava/lang/String;
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 333
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getOriginatingAddress()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getPdu()[B
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 509
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getPdu()[B

    move-result-object p0

    return-object p0
.end method

.method public getProtocolIdentifier()I
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 435
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getProtocolIdentifier()I

    move-result p0

    return p0
.end method

.method public getPseudoSubject()Ljava/lang/String;
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 385
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getPseudoSubject()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getServiceCenterAddress()Ljava/lang/String;
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 323
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getServiceCenterAddress()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getStatus()I
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 589
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getStatus()I

    move-result p0

    return p0
.end method

.method public getStatusOnIcc()I
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 543
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getStatusOnIcc()I

    move-result p0

    return p0
.end method

.method public getStatusOnSim()I
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 525
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getStatusOnIcc()I

    move-result p0

    return p0
.end method

.method public getTimestampMillis()J
    .locals 2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 394
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getTimestampMillis()J

    move-result-wide v0

    return-wide v0
.end method

.method public getUserData()[B
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 494
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->getUserData()[B

    move-result-object p0

    return-object p0
.end method

.method public isCphsMwiMessage()Z
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 455
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->isCphsMwiMessage()Z

    move-result p0

    return p0
.end method

.method public isEmail()Z
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 406
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->isEmail()Z

    move-result p0

    return p0
.end method

.method public isMWIClearMessage()Z
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 465
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->isMWIClearMessage()Z

    move-result p0

    return p0
.end method

.method public isMWISetMessage()Z
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 475
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->isMWISetMessage()Z

    move-result p0

    return p0
.end method

.method public isMwiDontStore()Z
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 485
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->isMwiDontStore()Z

    move-result p0

    return p0
.end method

.method public isReplace()Z
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 444
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->isReplace()Z

    move-result p0

    return p0
.end method

.method public isReplyPathPresent()Z
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 608
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->isReplyPathPresent()Z

    move-result p0

    return p0
.end method

.method public isStatusReportMessage()Z
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 598
    iget-object p0, p0, Landroid/telephony/gsm/SmsMessage;->mWrappedSmsMessage:Lcom/android/internal/telephony/SmsMessageBase;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsMessageBase;->isStatusReportMessage()Z

    move-result p0

    return p0
.end method
