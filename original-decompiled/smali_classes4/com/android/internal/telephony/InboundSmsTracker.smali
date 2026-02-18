.class public Lcom/android/internal/telephony/InboundSmsTracker;
.super Ljava/lang/Object;
.source "InboundSmsTracker.java"


# static fields
.field public static final DEST_PORT_FLAG_3GPP:I = 0x20000

.field public static final DEST_PORT_FLAG_3GPP2:I = 0x40000
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field public static final DEST_PORT_FLAG_3GPP2_WAP_PDU:I = 0x80000
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field public static final DEST_PORT_FLAG_NO_PORT:I = 0x10000
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final DEST_PORT_MASK:I = 0xffff

.field private static final NUM_OF_BYTES_HASH_VALUE_FOR_MESSAGE_ID:I = 0x8

.field public static final SELECT_BY_REFERENCE:Ljava/lang/String; = "address=? AND reference_number=? AND count=? AND (destination_port & 524288=0) AND deleted=0"
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field public static final SELECT_BY_REFERENCE_3GPP2WAP:Ljava/lang/String; = "address=? AND reference_number=? AND count=? AND (destination_port & 524288=524288) AND deleted=0"
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field


# instance fields
.field protected final mAddress:Ljava/lang/String;

.field protected mDeleteWhere:Ljava/lang/String;

.field protected mDeleteWhereArgs:[Ljava/lang/String;

.field private final mDestPort:I

.field private final mDisplayAddress:Ljava/lang/String;

.field private final mIs3gpp2:Z

.field private final mIs3gpp2WapPdu:Z

.field private final mIsClass0:Z

.field private final mMessageBody:Ljava/lang/String;

.field protected final mMessageCount:I

.field private final mMessageId:J

.field private final mPdu:[B

.field protected final mReferenceNumber:I

.field private final mSequenceNumber:I

.field private mSmsBroadcastReceiver:Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;

.field private final mSmsSource:I

.field protected final mSubId:I

.field private final mTimestamp:J


# direct methods
.method public constructor <init>(Landroid/content/Context;Landroid/database/Cursor;Z)V
    .locals 11

    .line 209
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 210
    invoke-interface {p2, v0}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/HexDump;->hexStringToByteArray(Ljava/lang/String;)[B

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mPdu:[B

    .line 213
    iput-boolean v0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIsClass0:Z

    const/4 v1, 0x2

    .line 215
    invoke-interface {p2, v1}, Landroid/database/Cursor;->isNull(I)Z

    move-result v2

    const/4 v3, -0x1

    const/4 v4, 0x1

    if-eqz v2, :cond_0

    .line 216
    iput v3, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDestPort:I

    .line 217
    iput-boolean p3, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2:Z

    .line 218
    iput-boolean v0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2WapPdu:Z

    goto :goto_2

    .line 220
    :cond_0
    invoke-interface {p2, v1}, Landroid/database/Cursor;->getInt(I)I

    move-result v2

    const/high16 v5, 0x20000

    and-int/2addr v5, v2

    if-eqz v5, :cond_1

    .line 222
    iput-boolean v0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2:Z

    goto :goto_0

    :cond_1
    const/high16 v5, 0x40000

    and-int/2addr v5, v2

    if-eqz v5, :cond_2

    .line 224
    iput-boolean v4, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2:Z

    goto :goto_0

    .line 226
    :cond_2
    iput-boolean p3, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2:Z

    :goto_0
    const/high16 p3, 0x80000

    and-int/2addr p3, v2

    if-eqz p3, :cond_3

    move p3, v4

    goto :goto_1

    :cond_3
    move p3, v0

    .line 228
    :goto_1
    iput-boolean p3, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2WapPdu:Z

    .line 229
    invoke-static {v2}, Lcom/android/internal/telephony/InboundSmsTracker;->getRealDestPort(I)I

    move-result p3

    iput p3, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDestPort:I

    :goto_2
    const/4 p3, 0x3

    .line 232
    invoke-interface {p2, p3}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v5

    iput-wide v5, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mTimestamp:J

    const/4 v2, 0x6

    .line 233
    invoke-interface {p2, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v2

    iput-object v2, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mAddress:Ljava/lang/String;

    const/16 v7, 0x9

    .line 234
    invoke-interface {p2, v7}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v7

    iput-object v7, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDisplayAddress:Ljava/lang/String;

    .line 235
    sget-object v7, Lcom/android/internal/telephony/SmsBroadcastUndelivered;->PDU_PENDING_MESSAGE_PROJECTION_INDEX_MAPPING:Ljava/util/Map;

    const/16 v8, 0xb

    .line 236
    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    invoke-interface {v7, v8}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/Integer;

    invoke-virtual {v7}, Ljava/lang/Integer;->intValue()I

    move-result v7

    .line 235
    invoke-interface {p2, v7}, Landroid/database/Cursor;->getInt(I)I

    move-result v7

    iput v7, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSubId:I

    const/4 v8, 0x5

    .line 238
    invoke-interface {p2, v8}, Landroid/database/Cursor;->getInt(I)I

    move-result v9

    if-ne v9, v4, :cond_4

    const/4 p3, 0x7

    .line 240
    invoke-interface {p2, p3}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v1

    .line 241
    iput v3, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mReferenceNumber:I

    .line 242
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getIndexOffset()I

    move-result p3

    iput p3, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSequenceNumber:I

    .line 243
    iput v4, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageCount:I

    const-string p3, "_id=?"

    .line 244
    iput-object p3, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDeleteWhere:Ljava/lang/String;

    new-array p3, v4, [Ljava/lang/String;

    .line 245
    invoke-static {v1, v2}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v1

    aput-object v1, p3, v0

    iput-object p3, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDeleteWhereArgs:[Ljava/lang/String;

    goto :goto_3

    :cond_4
    const/4 v3, 0x4

    .line 248
    invoke-interface {p2, v3}, Landroid/database/Cursor;->getInt(I)I

    move-result v3

    iput v3, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mReferenceNumber:I

    .line 249
    invoke-interface {p2, v8}, Landroid/database/Cursor;->getInt(I)I

    move-result v8

    iput v8, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageCount:I

    .line 252
    invoke-interface {p2, v4}, Landroid/database/Cursor;->getInt(I)I

    move-result v9

    iput v9, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSequenceNumber:I

    .line 253
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getIndexOffset()I

    move-result v10

    sub-int v10, v9, v10

    if-ltz v10, :cond_5

    if-ge v10, v8, :cond_5

    .line 260
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getQueryForSegments()Ljava/lang/String;

    move-result-object v9

    iput-object v9, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDeleteWhere:Ljava/lang/String;

    new-array p3, p3, [Ljava/lang/String;

    aput-object v2, p3, v0

    .line 262
    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v2

    aput-object v2, p3, v4

    invoke-static {v8}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v2

    aput-object v2, p3, v1

    iput-object p3, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDeleteWhereArgs:[Ljava/lang/String;

    :goto_3
    const/16 p3, 0x8

    .line 264
    invoke-interface {p2, p3}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageBody:Ljava/lang/String;

    .line 265
    invoke-static {p1, v5, v6, v7}, Lcom/android/internal/telephony/InboundSmsTracker;->createMessageId(Landroid/content/Context;JI)J

    move-result-wide p1

    iput-wide p1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageId:J

    .line 267
    iput v0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSmsSource:I

    return-void

    .line 256
    :cond_5
    new-instance p0, Ljava/lang/IllegalArgumentException;

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "invalid PDU sequence "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, " of "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public constructor <init>(Landroid/content/Context;[BJIZLjava/lang/String;Ljava/lang/String;IIIZLjava/lang/String;ZII)V
    .locals 5

    move-object v0, p0

    move-wide v1, p3

    move/from16 v3, p15

    .line 184
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    move-object v4, p2

    .line 185
    iput-object v4, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mPdu:[B

    .line 186
    iput-wide v1, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mTimestamp:J

    move v4, p5

    .line 187
    iput v4, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mDestPort:I

    move v4, p6

    .line 188
    iput-boolean v4, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2:Z

    move/from16 v4, p12

    .line 189
    iput-boolean v4, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2WapPdu:Z

    move-object/from16 v4, p13

    .line 190
    iput-object v4, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageBody:Ljava/lang/String;

    move/from16 v4, p14

    .line 191
    iput-boolean v4, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mIsClass0:Z

    move-object v4, p8

    .line 193
    iput-object v4, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mDisplayAddress:Ljava/lang/String;

    move-object v4, p7

    .line 195
    iput-object v4, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mAddress:Ljava/lang/String;

    move v4, p9

    .line 196
    iput v4, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mReferenceNumber:I

    move v4, p10

    .line 197
    iput v4, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mSequenceNumber:I

    move/from16 v4, p11

    .line 198
    iput v4, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageCount:I

    .line 199
    iput v3, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mSubId:I

    move-object v4, p1

    .line 200
    invoke-static {p1, p3, p4, v3}, Lcom/android/internal/telephony/InboundSmsTracker;->createMessageId(Landroid/content/Context;JI)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageId:J

    move/from16 v1, p16

    .line 201
    iput v1, v0, Lcom/android/internal/telephony/InboundSmsTracker;->mSmsSource:I

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;[BJIZZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZII)V
    .locals 0

    .line 142
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 143
    iput-object p2, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mPdu:[B

    .line 144
    iput-wide p3, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mTimestamp:J

    .line 145
    iput p5, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDestPort:I

    .line 146
    iput-boolean p6, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2:Z

    .line 147
    iput-boolean p7, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2WapPdu:Z

    .line 148
    iput-object p10, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageBody:Ljava/lang/String;

    .line 149
    iput-object p8, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mAddress:Ljava/lang/String;

    .line 150
    iput-object p9, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDisplayAddress:Ljava/lang/String;

    .line 151
    iput-boolean p11, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIsClass0:Z

    const/4 p2, -0x1

    .line 153
    iput p2, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mReferenceNumber:I

    .line 154
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getIndexOffset()I

    move-result p2

    iput p2, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSequenceNumber:I

    const/4 p2, 0x1

    .line 155
    iput p2, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageCount:I

    .line 156
    iput p12, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSubId:I

    .line 157
    invoke-static {p1, p3, p4, p12}, Lcom/android/internal/telephony/InboundSmsTracker;->createMessageId(Landroid/content/Context;JI)J

    move-result-wide p1

    iput-wide p1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageId:J

    .line 158
    iput p13, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSmsSource:I

    return-void
.end method

.method private addDestPortQuery(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 433
    iget-boolean p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2WapPdu:Z

    if-eqz p0, :cond_0

    const-string p0, "destination_port & 524288=524288"

    goto :goto_0

    :cond_0
    const-string p0, "destination_port & 524288=0"

    .line 439
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " AND ("

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static createMessageId(Landroid/content/Context;JI)J
    .locals 1

    .line 443
    invoke-static {p3}, Landroid/telephony/SubscriptionManager;->getSlotIndex(I)I

    move-result p3

    const-string v0, "phone"

    .line 445
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/TelephonyManager;

    .line 446
    invoke-virtual {p0, p3}, Landroid/telephony/TelephonyManager;->getImei(I)Ljava/lang/String;

    move-result-object p0

    .line 447
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p3

    if-eqz p3, :cond_0

    const-wide/16 p0, 0x0

    return-wide p0

    .line 450
    :cond_0
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 451
    invoke-static {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getShaValue(Ljava/lang/String;)J

    move-result-wide p0

    return-wide p0
.end method

.method public static getRealDestPort(I)I
    .locals 1

    const/high16 v0, 0x10000

    and-int/2addr v0, p0

    if-eqz v0, :cond_0

    const/4 p0, -0x1

    return p0

    :cond_0
    const v0, 0xffff

    and-int/2addr p0, v0

    return p0
.end method

.method private static getShaBytes(Ljava/lang/String;I)[B
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/security/NoSuchAlgorithmException;,
            Ljava/io/UnsupportedEncodingException;
        }
    .end annotation

    const-string v0, "SHA-1"

    .line 467
    invoke-static {v0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v0

    .line 468
    invoke-virtual {v0}, Ljava/security/MessageDigest;->reset()V

    const-string v1, "UTF-8"

    .line 469
    invoke-virtual {p0, v1}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/security/MessageDigest;->update([B)V

    .line 470
    invoke-virtual {v0}, Ljava/security/MessageDigest;->digest()[B

    move-result-object p0

    .line 471
    array-length v0, p0

    if-lt v0, p1, :cond_0

    .line 472
    new-array v0, p1, [B

    const/4 v1, 0x0

    .line 473
    invoke-static {p0, v1, v0, v1, p1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    return-object v0

    :cond_0
    return-object p0
.end method

.method private static getShaValue(Ljava/lang/String;)J
    .locals 2

    const/16 v0, 0x8

    .line 456
    :try_start_0
    invoke-static {p0, v0}, Lcom/android/internal/telephony/InboundSmsTracker;->getShaBytes(Ljava/lang/String;I)[B

    move-result-object p0

    invoke-static {p0}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object p0

    .line 457
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->getLong()J

    move-result-wide v0
    :try_end_0
    .catch Ljava/security/NoSuchAlgorithmException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/io/UnsupportedEncodingException; {:try_start_0 .. :try_end_0} :catch_0

    return-wide v0

    :catch_0
    move-exception p0

    const-string v0, "InboundSmsTracker"

    const-string v1, "Exception while getting SHA value for message"

    .line 459
    invoke-static {v0, v1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    const-wide/16 v0, 0x0

    return-wide v0
.end method


# virtual methods
.method public getAddress()Ljava/lang/String;
    .locals 0

    .line 490
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mAddress:Ljava/lang/String;

    return-object p0
.end method

.method public getContentValues()Landroid/content/ContentValues;
    .locals 3

    .line 271
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 272
    iget-object v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mPdu:[B

    invoke-static {v1}, Lcom/android/internal/telephony/HexDump;->toHexString([B)Ljava/lang/String;

    move-result-object v1

    const-string v2, "pdu"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 273
    iget-wide v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mTimestamp:J

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    const-string v2, "date"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 277
    iget v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDestPort:I

    const/4 v2, -0x1

    if-ne v1, v2, :cond_0

    const/high16 v1, 0x10000

    goto :goto_0

    :cond_0
    const v2, 0xffff

    and-int/2addr v1, v2

    .line 282
    :goto_0
    iget-boolean v2, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2:Z

    if-eqz v2, :cond_1

    const/high16 v2, 0x40000

    goto :goto_1

    :cond_1
    const/high16 v2, 0x20000

    :goto_1
    or-int/2addr v1, v2

    .line 287
    iget-boolean v2, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2WapPdu:Z

    if-eqz v2, :cond_2

    const/high16 v2, 0x80000

    or-int/2addr v1, v2

    .line 290
    :cond_2
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "destination_port"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 291
    iget-object v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mAddress:Ljava/lang/String;

    if-eqz v1, :cond_3

    const-string v2, "address"

    .line 292
    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 293
    iget-object v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDisplayAddress:Ljava/lang/String;

    const-string v2, "display_originating_addr"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 294
    iget v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mReferenceNumber:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "reference_number"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 295
    iget v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSequenceNumber:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "sequence"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 297
    :cond_3
    iget v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageCount:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const-string v2, "count"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 298
    iget-object v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageBody:Ljava/lang/String;

    const-string v2, "message_body"

    invoke-virtual {v0, v2, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 299
    iget p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSubId:I

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    const-string/jumbo v1, "sub_id"

    invoke-virtual {v0, v1, p0}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    return-object v0
.end method

.method public getDeleteWhere()Ljava/lang/String;
    .locals 0

    .line 514
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDeleteWhere:Ljava/lang/String;

    return-object p0
.end method

.method public getDeleteWhereArgs()[Ljava/lang/String;
    .locals 0

    .line 518
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDeleteWhereArgs:[Ljava/lang/String;

    return-object p0
.end method

.method public getDestPort()I
    .locals 0

    .line 360
    iget p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDestPort:I

    return p0
.end method

.method public getDisplayAddress()Ljava/lang/String;
    .locals 0

    .line 494
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDisplayAddress:Ljava/lang/String;

    return-object p0
.end method

.method public getExactMatchDupDetectQuery()Landroid/util/Pair;
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Landroid/util/Pair<",
            "Ljava/lang/String;",
            "[",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 390
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getAddress()Ljava/lang/String;

    move-result-object v0

    .line 391
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getReferenceNumber()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    .line 392
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageCount()I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v2

    .line 393
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getSequenceNumber()I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    .line 394
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getTimestamp()J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v4

    .line 395
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageBody()Ljava/lang/String;

    move-result-object v5

    const-string v6, "address=? AND reference_number=? AND count=? AND sequence=? AND date=? AND message_body=?"

    .line 399
    invoke-direct {p0, v6}, Lcom/android/internal/telephony/InboundSmsTracker;->addDestPortQuery(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    const/4 v6, 0x6

    new-array v6, v6, [Ljava/lang/String;

    const/4 v7, 0x0

    aput-object v0, v6, v7

    const/4 v0, 0x1

    aput-object v1, v6, v0

    const/4 v0, 0x2

    aput-object v2, v6, v0

    const/4 v0, 0x3

    aput-object v3, v6, v0

    const/4 v0, 0x4

    aput-object v4, v6, v0

    const/4 v0, 0x5

    aput-object v5, v6, v0

    .line 402
    new-instance v0, Landroid/util/Pair;

    invoke-direct {v0, p0, v6}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    return-object v0
.end method

.method public getFormat()Ljava/lang/String;
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 377
    iget-boolean p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2:Z

    if-eqz p0, :cond_0

    const-string p0, "3gpp2"

    goto :goto_0

    :cond_0
    const-string p0, "3gpp"

    :goto_0
    return-object p0
.end method

.method public getIndexOffset()I
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 486
    iget-boolean v0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2:Z

    if-eqz v0, :cond_0

    iget-boolean p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2WapPdu:Z

    if-eqz p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    const/4 p0, 0x1

    :goto_0
    return p0
.end method

.method public getInexactMatchDupDetectQuery()Landroid/util/Pair;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Landroid/util/Pair<",
            "Ljava/lang/String;",
            "[",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 415
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageCount()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 418
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getAddress()Ljava/lang/String;

    move-result-object v0

    .line 419
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getReferenceNumber()I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v2

    .line 420
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getMessageCount()I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v3

    .line 421
    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsTracker;->getSequenceNumber()I

    move-result v4

    invoke-static {v4}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, "address=? AND reference_number=? AND count=? AND sequence=? AND deleted=0"

    .line 425
    invoke-direct {p0, v5}, Lcom/android/internal/telephony/InboundSmsTracker;->addDestPortQuery(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    const/4 v5, 0x4

    new-array v5, v5, [Ljava/lang/String;

    const/4 v6, 0x0

    aput-object v0, v5, v6

    aput-object v2, v5, v1

    const/4 v0, 0x2

    aput-object v3, v5, v0

    const/4 v0, 0x3

    aput-object v4, v5, v0

    .line 428
    new-instance v0, Landroid/util/Pair;

    invoke-direct {v0, p0, v5}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    return-object v0
.end method

.method public getMessageBody()Ljava/lang/String;
    .locals 0

    .line 498
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageBody:Ljava/lang/String;

    return-object p0
.end method

.method public getMessageCount()I
    .locals 0

    .line 510
    iget p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageCount:I

    return p0
.end method

.method public getMessageId()J
    .locals 2

    .line 522
    iget-wide v0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageId:J

    return-wide v0
.end method

.method public getPdu()[B
    .locals 0

    .line 352
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mPdu:[B

    return-object p0
.end method

.method public getQueryForSegments()Ljava/lang/String;
    .locals 0

    .line 381
    iget-boolean p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2WapPdu:Z

    if-eqz p0, :cond_0

    const-string p0, "address=? AND reference_number=? AND count=? AND (destination_port & 524288=524288) AND deleted=0"

    goto :goto_0

    :cond_0
    const-string p0, "address=? AND reference_number=? AND count=? AND (destination_port & 524288=0) AND deleted=0"

    :goto_0
    return-object p0
.end method

.method public getReferenceNumber()I
    .locals 0

    .line 502
    iget p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mReferenceNumber:I

    return p0
.end method

.method public getSequenceNumber()I
    .locals 0

    .line 506
    iget p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSequenceNumber:I

    return p0
.end method

.method public getSmsBroadcastReceiver(Lcom/android/internal/telephony/InboundSmsHandler;)Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;
    .locals 1

    .line 535
    iget-object v0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSmsBroadcastReceiver:Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;

    if-nez v0, :cond_0

    .line 536
    new-instance v0, Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;

    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;-><init>(Lcom/android/internal/telephony/InboundSmsHandler;Lcom/android/internal/telephony/InboundSmsTracker;)V

    iput-object v0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSmsBroadcastReceiver:Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;

    .line 538
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSmsBroadcastReceiver:Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;

    return-object p0
.end method

.method public getSource()I
    .locals 0

    .line 526
    iget p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSmsSource:I

    return p0
.end method

.method public getSubId()I
    .locals 0

    .line 372
    iget p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSubId:I

    return p0
.end method

.method public getTimestamp()J
    .locals 2

    .line 356
    iget-wide v0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mTimestamp:J

    return-wide v0
.end method

.method public is3gpp2()Z
    .locals 0

    .line 364
    iget-boolean p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2:Z

    return p0
.end method

.method public isClass0()Z
    .locals 0

    .line 368
    iget-boolean p0, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIsClass0:Z

    return p0
.end method

.method public setDeleteWhere(Ljava/lang/String;[Ljava/lang/String;)V
    .locals 0

    .line 322
    iput-object p1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDeleteWhere:Ljava/lang/String;

    .line 323
    iput-object p2, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDeleteWhereArgs:[Ljava/lang/String;

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 4

    .line 327
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "SmsTracker{timestamp="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 328
    new-instance v1, Ljava/util/Date;

    iget-wide v2, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mTimestamp:J

    invoke-direct {v1, v2, v3}, Ljava/util/Date;-><init>(J)V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " destPort="

    .line 329
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDestPort:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " is3gpp2="

    .line 330
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mIs3gpp2:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " display_originating_addr="

    .line 336
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDisplayAddress:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " refNumber="

    .line 337
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mReferenceNumber:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " seqNumber="

    .line 338
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mSequenceNumber:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " msgCount="

    .line 339
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageCount:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 340
    iget-object v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDeleteWhere:Ljava/lang/String;

    if-eqz v1, :cond_0

    const-string v1, " deleteWhere("

    .line 341
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDeleteWhere:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ") deleteArgs=("

    .line 342
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mDeleteWhereArgs:[Ljava/lang/String;

    invoke-static {v1}, Ljava/util/Arrays;->toString([Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x29

    .line 343
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    :cond_0
    const-string v1, " "

    .line 345
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 346
    iget-wide v1, p0, Lcom/android/internal/telephony/InboundSmsTracker;->mMessageId:J

    invoke-static {v1, v2}, Lcom/android/internal/telephony/SmsController;->formatCrossStackMessageId(J)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string/jumbo p0, "}"

    .line 347
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 348
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
