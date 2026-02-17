.class public Lcom/android/internal/telephony/WapPushOverSms;
.super Ljava/lang/Object;
.source "WapPushOverSms.java"

# interfaces
.implements Landroid/content/ServiceConnection;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;
    }
.end annotation


# static fields
.field private static final DBG:Z = false

.field private static final TAG:Ljava/lang/String; = "WAP PUSH"


# instance fields
.field protected final mContext:Landroid/content/Context;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field mPowerWhitelistManager:Landroid/os/PowerWhitelistManager;

.field protected volatile mWapPushManager:Lcom/android/internal/telephony/IWapPushManager;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mWapPushManagerPackage:Ljava/lang/String;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 137
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 138
    iput-object p1, p0, Lcom/android/internal/telephony/WapPushOverSms;->mContext:Landroid/content/Context;

    .line 139
    const-class v0, Landroid/os/PowerWhitelistManager;

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/PowerWhitelistManager;

    iput-object v0, p0, Lcom/android/internal/telephony/WapPushOverSms;->mPowerWhitelistManager:Landroid/os/PowerWhitelistManager;

    const-string/jumbo v0, "user"

    .line 141
    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/UserManager;

    .line 143
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/WapPushOverSms;->bindWapPushManagerService(Landroid/content/Context;)V

    return-void
.end method

.method private bindWapPushManagerService(Landroid/content/Context;)V
    .locals 3

    .line 85
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/android/internal/telephony/IWapPushManager;

    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 86
    invoke-virtual {p1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/android/internal/telephony/WapPushOverSms;->resolveSystemService(Landroid/content/pm/PackageManager;Landroid/content/Intent;)Landroid/content/ComponentName;

    move-result-object v1

    .line 87
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    if-eqz v1, :cond_1

    const/4 v2, 0x1

    .line 88
    invoke-virtual {p1, v0, p0, v2}, Landroid/content/Context;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    move-result p1

    if-nez p1, :cond_0

    goto :goto_0

    .line 91
    :cond_0
    monitor-enter p0

    .line 92
    :try_start_0
    invoke-virtual {v1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/WapPushOverSms;->mWapPushManagerPackage:Ljava/lang/String;

    .line 93
    monitor-exit p0

    goto :goto_1

    :catchall_0
    move-exception p1

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1

    :cond_1
    :goto_0
    const-string p0, "WAP PUSH"

    const-string p1, "bindService() for wappush manager failed"

    .line 89
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_1
    return-void
.end method

.method private decodeWapPdu([BLcom/android/internal/telephony/InboundSmsHandler;)Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;
    .locals 18

    move-object/from16 v1, p0

    move-object/from16 v0, p1

    const-string v2, "WAP PUSH"

    .line 165
    new-instance v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;

    const/4 v4, 0x0

    invoke-direct {v3, v1, v4}, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;-><init>(Lcom/android/internal/telephony/WapPushOverSms;Lcom/android/internal/telephony/WapPushOverSms$DecodedResult-IA;)V

    const/4 v5, 0x2

    const/4 v6, 0x0

    .line 170
    :try_start_0
    aget-byte v7, v0, v6

    and-int/lit16 v7, v7, 0xff

    const/4 v8, 0x1

    .line 171
    aget-byte v9, v0, v8

    and-int/lit16 v9, v9, 0xff

    .line 174
    invoke-virtual/range {p2 .. p2}, Lcom/android/internal/telephony/InboundSmsHandler;->getPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v10

    invoke-virtual {v10}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v10

    const/4 v11, -0x1

    const/4 v12, 0x6

    if-eq v9, v12, :cond_1

    const/4 v13, 0x7

    if-eq v9, v13, :cond_1

    .line 178
    iget-object v7, v1, Lcom/android/internal/telephony/WapPushOverSms;->mContext:Landroid/content/Context;

    invoke-virtual {v7}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v7

    const v9, 0x10e00f5

    invoke-virtual {v7, v9}, Landroid/content/res/Resources;->getInteger(I)I

    move-result v7

    if-eq v7, v11, :cond_0

    add-int/lit8 v9, v7, 0x1

    .line 181
    aget-byte v7, v0, v7

    and-int/lit16 v7, v7, 0xff

    add-int/lit8 v14, v9, 0x1

    .line 182
    aget-byte v9, v0, v9

    and-int/lit16 v9, v9, 0xff

    if-eq v9, v12, :cond_2

    if-eq v9, v13, :cond_2

    .line 191
    iput v8, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->statusCode:I

    return-object v3

    .line 196
    :cond_0
    iput v8, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->statusCode:I

    return-object v3

    :cond_1
    move v14, v5

    .line 201
    :cond_2
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v12

    const-class v13, Lcom/android/internal/telephony/WspTypeDecoder;

    invoke-virtual {v13}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v13

    invoke-virtual {v12, v13}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v12

    .line 202
    invoke-virtual {v12, v0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeWspTypeDecoder([B)Lcom/android/internal/telephony/WspTypeDecoder;

    move-result-object v12

    .line 210
    invoke-virtual {v12, v14}, Lcom/android/internal/telephony/WspTypeDecoder;->decodeUintvarInteger(I)Z

    move-result v13

    if-nez v13, :cond_3

    .line 212
    iput v5, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->statusCode:I

    return-object v3

    :cond_3
    move/from16 p2, v9

    .line 215
    invoke-virtual {v12}, Lcom/android/internal/telephony/WspTypeDecoder;->getValue32()J

    move-result-wide v8

    long-to-int v8, v8

    .line 216
    invoke-virtual {v12}, Lcom/android/internal/telephony/WspTypeDecoder;->getDecodedDataLength()I

    move-result v9

    add-int/2addr v14, v9

    .line 232
    invoke-virtual {v12, v14}, Lcom/android/internal/telephony/WspTypeDecoder;->decodeContentType(I)Z

    move-result v9

    if-nez v9, :cond_4

    .line 234
    iput v5, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->statusCode:I

    return-object v3

    .line 238
    :cond_4
    invoke-virtual {v12}, Lcom/android/internal/telephony/WspTypeDecoder;->getValueString()Ljava/lang/String;

    move-result-object v9

    .line 239
    invoke-virtual {v12}, Lcom/android/internal/telephony/WspTypeDecoder;->getValue32()J

    move-result-wide v15

    .line 240
    invoke-virtual {v12}, Lcom/android/internal/telephony/WspTypeDecoder;->getDecodedDataLength()I

    move-result v17

    add-int v13, v14, v17

    .line 242
    new-array v5, v8, [B

    .line 243
    invoke-static {v0, v14, v5, v6, v8}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    if-eqz v9, :cond_5

    const-string v11, "application/vnd.wap.coc"

    .line 247
    invoke-virtual {v9, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_5

    move-object v4, v0

    goto :goto_0

    :cond_5
    add-int/2addr v14, v8

    .line 251
    array-length v11, v0

    sub-int/2addr v11, v14

    new-array v4, v11, [B

    .line 252
    invoke-static {v0, v14, v4, v6, v11}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 255
    :goto_0
    invoke-static {v10}, Landroid/telephony/SubscriptionManager;->getSubId(I)[I

    move-result-object v0

    if-eqz v0, :cond_6

    .line 256
    array-length v11, v0

    if-lez v11, :cond_6

    aget v0, v0, v6

    goto :goto_1

    .line 257
    :cond_6
    invoke-static {}, Landroid/telephony/SmsManager;->getDefaultSmsSubscriptionId()I

    move-result v0
    :try_end_0
    .catch Ljava/lang/ArrayIndexOutOfBoundsException; {:try_start_0 .. :try_end_0} :catch_1

    :goto_1
    move v6, v0

    .line 263
    :try_start_1
    new-instance v0, Lcom/google/android/mms/pdu/PduParser;

    invoke-static {v6}, Lcom/android/internal/telephony/WapPushOverSms;->shouldParseContentDisposition(I)Z

    move-result v11

    invoke-direct {v0, v4, v11}, Lcom/google/android/mms/pdu/PduParser;-><init>([BZ)V

    invoke-virtual {v0}, Lcom/google/android/mms/pdu/PduParser;->parse()Lcom/google/android/mms/pdu/GenericPdu;

    move-result-object v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_2

    :catch_0
    move-exception v0

    .line 265
    :try_start_2
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v14, "Unable to parse PDU: "

    invoke-virtual {v11, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v11, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v0, 0x0

    :goto_2
    if-eqz v0, :cond_7

    .line 268
    invoke-virtual {v0}, Lcom/google/android/mms/pdu/GenericPdu;->getMessageType()I

    move-result v11

    const/16 v14, 0x82

    if-ne v11, v14, :cond_7

    .line 269
    move-object v11, v0

    check-cast v11, Lcom/google/android/mms/pdu/NotificationInd;

    .line 270
    invoke-virtual {v11}, Lcom/google/android/mms/pdu/NotificationInd;->getFrom()Lcom/google/android/mms/pdu/EncodedStringValue;

    move-result-object v14

    if-eqz v14, :cond_7

    iget-object v1, v1, Lcom/android/internal/telephony/WapPushOverSms;->mContext:Landroid/content/Context;

    .line 271
    invoke-virtual {v11}, Lcom/google/android/mms/pdu/NotificationInd;->getFrom()Lcom/google/android/mms/pdu/EncodedStringValue;

    move-result-object v11

    invoke-virtual {v11}, Lcom/google/android/mms/pdu/EncodedStringValue;->getString()Ljava/lang/String;

    move-result-object v11

    const/4 v14, 0x0

    invoke-static {v1, v11, v14}, Lcom/android/internal/telephony/BlockChecker;->isBlocked(Landroid/content/Context;Ljava/lang/String;Landroid/os/Bundle;)Z

    move-result v1

    if-eqz v1, :cond_7

    const/4 v1, 0x1

    .line 272
    iput v1, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->statusCode:I

    return-object v3

    :cond_7
    add-int/2addr v8, v13

    const/4 v1, 0x1

    sub-int/2addr v8, v1

    .line 283
    invoke-virtual {v12, v13, v8}, Lcom/android/internal/telephony/WspTypeDecoder;->seekXWapApplicationId(II)Z

    move-result v1

    if-eqz v1, :cond_a

    .line 284
    invoke-virtual {v12}, Lcom/android/internal/telephony/WspTypeDecoder;->getValue32()J

    move-result-wide v13

    long-to-int v1, v13

    .line 285
    invoke-virtual {v12, v1}, Lcom/android/internal/telephony/WspTypeDecoder;->decodeXWapApplicationId(I)Z

    .line 286
    invoke-virtual {v12}, Lcom/android/internal/telephony/WspTypeDecoder;->getValueString()Ljava/lang/String;

    move-result-object v1

    if-nez v1, :cond_8

    .line 288
    invoke-virtual {v12}, Lcom/android/internal/telephony/WspTypeDecoder;->getValue32()J

    move-result-wide v13

    long-to-int v1, v13

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    .line 290
    :cond_8
    iput-object v1, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->wapAppId:Ljava/lang/String;

    if-nez v9, :cond_9

    .line 292
    invoke-static/range {v15 .. v16}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v1

    goto :goto_3

    :cond_9
    move-object v1, v9

    .line 293
    :goto_3
    iput-object v1, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->contentType:Ljava/lang/String;

    .line 297
    :cond_a
    iput v6, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->subId:I

    .line 298
    iput v10, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->phoneId:I

    .line 299
    iput-object v0, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->parsedPdu:Lcom/google/android/mms/pdu/GenericPdu;

    .line 300
    iput-object v9, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->mimeType:Ljava/lang/String;

    .line 301
    iput v7, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->transactionId:I

    move/from16 v9, p2

    .line 302
    iput v9, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->pduType:I

    .line 303
    iput-object v5, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->header:[B

    .line 304
    iput-object v4, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->intentData:[B

    .line 305
    invoke-virtual {v12}, Lcom/android/internal/telephony/WspTypeDecoder;->getContentParameters()Ljava/util/HashMap;

    move-result-object v0

    iput-object v0, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->contentTypeParameters:Ljava/util/HashMap;

    const/4 v1, -0x1

    .line 306
    iput v1, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->statusCode:I
    :try_end_2
    .catch Ljava/lang/ArrayIndexOutOfBoundsException; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_4

    :catch_1
    move-exception v0

    .line 310
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "ignoring dispatchWapPdu() array index exception: "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v1, 0x2

    .line 311
    iput v1, v3, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->statusCode:I

    :goto_4
    return-object v3
.end method

.method public static getAppOpsStringPermissionForIntent(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    const-string v0, "application/vnd.wap.mms-message"

    .line 462
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    const-string p0, "android:receive_mms"

    goto :goto_0

    :cond_0
    const-string p0, "android:receive_wap_push"

    :goto_0
    return-object p0
.end method

.method public static getPermissionForType(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    const-string v0, "application/vnd.wap.mms-message"

    .line 447
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    const-string p0, "android.permission.RECEIVE_MMS"

    goto :goto_0

    :cond_0
    const-string p0, "android.permission.RECEIVE_WAP_PUSH"

    :goto_0
    return-object p0
.end method

.method private static resolveSystemService(Landroid/content/pm/PackageManager;Landroid/content/Intent;)Landroid/content/ComponentName;
    .locals 5

    const/high16 v0, 0x100000

    .line 106
    invoke-virtual {p0, p1, v0}, Landroid/content/pm/PackageManager;->queryIntentServices(Landroid/content/Intent;I)Ljava/util/List;

    move-result-object p0

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    :cond_0
    const/4 v1, 0x0

    .line 112
    :goto_0
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_2

    .line 113
    invoke-interface {p0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/content/pm/ResolveInfo;

    .line 114
    new-instance v3, Landroid/content/ComponentName;

    iget-object v2, v2, Landroid/content/pm/ResolveInfo;->serviceInfo:Landroid/content/pm/ServiceInfo;

    iget-object v4, v2, Landroid/content/pm/ServiceInfo;->applicationInfo:Landroid/content/pm/ApplicationInfo;

    iget-object v4, v4, Landroid/content/pm/ApplicationInfo;->packageName:Ljava/lang/String;

    iget-object v2, v2, Landroid/content/pm/ServiceInfo;->name:Ljava/lang/String;

    invoke-direct {v3, v4, v2}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    if-nez v0, :cond_1

    add-int/lit8 v1, v1, 0x1

    move-object v0, v3

    goto :goto_0

    .line 117
    :cond_1
    new-instance p0, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Multiple system services handle "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, ": "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, ", "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_2
    return-object v0
.end method

.method protected static shouldParseContentDisposition(I)Z
    .locals 2

    .line 440
    invoke-static {p0}, Landroid/telephony/SmsManager;->getSmsManagerForSubscriptionId(I)Landroid/telephony/SmsManager;

    move-result-object p0

    .line 441
    invoke-virtual {p0}, Landroid/telephony/SmsManager;->getCarrierConfigValues()Landroid/os/Bundle;

    move-result-object p0

    const-string/jumbo v0, "supportMmsContentDisposition"

    const/4 v1, 0x1

    .line 442
    invoke-virtual {p0, v0, v1}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method


# virtual methods
.method public dispatchWapPdu([BLcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Lcom/android/internal/telephony/InboundSmsHandler;Ljava/lang/String;IJ)I
    .locals 18

    move-object/from16 v1, p0

    move-object/from16 v2, p4

    move-object/from16 v0, p1

    move-object/from16 v3, p3

    move-wide/from16 v4, p6

    .line 328
    invoke-direct {v1, v0, v3}, Lcom/android/internal/telephony/WapPushOverSms;->decodeWapPdu([BLcom/android/internal/telephony/InboundSmsHandler;)Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;

    move-result-object v6

    .line 329
    iget v0, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->statusCode:I

    const/4 v8, -0x1

    if-eq v0, v8, :cond_0

    return v0

    .line 338
    :cond_0
    iget-object v0, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->wapAppId:Ljava/lang/String;

    const/16 v7, 0x13b

    const/4 v9, 0x2

    const/4 v10, 0x1

    if-eqz v0, :cond_4

    .line 341
    :try_start_0
    iget-object v0, v1, Lcom/android/internal/telephony/WapPushOverSms;->mWapPushManager:Lcom/android/internal/telephony/IWapPushManager;

    if-nez v0, :cond_1

    goto :goto_0

    .line 346
    :cond_1
    monitor-enter p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    .line 347
    :try_start_1
    iget-object v11, v1, Lcom/android/internal/telephony/WapPushOverSms;->mPowerWhitelistManager:Landroid/os/PowerWhitelistManager;

    iget-object v12, v1, Lcom/android/internal/telephony/WapPushOverSms;->mWapPushManagerPackage:Ljava/lang/String;

    const-string v13, "mms-mgr"

    invoke-virtual {v11, v12, v9, v7, v13}, Landroid/os/PowerWhitelistManager;->whitelistAppTemporarilyForEvent(Ljava/lang/String;IILjava/lang/String;)J

    .line 350
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 352
    :try_start_2
    new-instance v11, Landroid/content/Intent;

    invoke-direct {v11}, Landroid/content/Intent;-><init>()V

    const-string/jumbo v12, "transactionId"

    .line 353
    iget v13, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->transactionId:I

    invoke-virtual {v11, v12, v13}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const-string v12, "pduType"

    .line 354
    iget v13, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->pduType:I

    invoke-virtual {v11, v12, v13}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const-string v12, "header"

    .line 355
    iget-object v13, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->header:[B

    invoke-virtual {v11, v12, v13}, Landroid/content/Intent;->putExtra(Ljava/lang/String;[B)Landroid/content/Intent;

    const-string v12, "data"

    .line 356
    iget-object v13, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->intentData:[B

    invoke-virtual {v11, v12, v13}, Landroid/content/Intent;->putExtra(Ljava/lang/String;[B)Landroid/content/Intent;

    const-string v12, "contentTypeParameters"

    .line 357
    iget-object v13, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->contentTypeParameters:Ljava/util/HashMap;

    invoke-virtual {v11, v12, v13}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/io/Serializable;)Landroid/content/Intent;

    .line 358
    iget v12, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->phoneId:I

    invoke-static {v11, v12}, Landroid/telephony/SubscriptionManager;->putPhoneIdAndSubIdExtra(Landroid/content/Intent;I)V

    .line 359
    invoke-static/range {p4 .. p4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v12

    if-nez v12, :cond_2

    const-string v12, "address"

    .line 360
    invoke-virtual {v11, v12, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 363
    :cond_2
    iget-object v12, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->wapAppId:Ljava/lang/String;

    iget-object v13, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->contentType:Ljava/lang/String;

    invoke-interface {v0, v12, v13, v11}, Lcom/android/internal/telephony/IWapPushManager;->processMessage(Ljava/lang/String;Ljava/lang/String;Landroid/content/Intent;)I

    move-result v0
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_0

    and-int/lit8 v11, v0, 0x1

    if-lez v11, :cond_3

    const v11, 0x8000

    and-int/2addr v0, v11

    if-nez v0, :cond_3

    const/4 v0, 0x0

    goto :goto_1

    :cond_3
    :goto_0
    move v0, v10

    :goto_1
    if-nez v0, :cond_4

    return v10

    :catchall_0
    move-exception v0

    .line 350
    :try_start_3
    monitor-exit p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :try_start_4
    throw v0
    :try_end_4
    .catch Landroid/os/RemoteException; {:try_start_4 .. :try_end_4} :catch_0

    .line 380
    :catch_0
    :cond_4
    iget-object v0, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->mimeType:Ljava/lang/String;

    if-nez v0, :cond_5

    return v9

    .line 385
    :cond_5
    new-instance v11, Landroid/content/Intent;

    const-string v0, "android.provider.Telephony.WAP_PUSH_DELIVER"

    invoke-direct {v11, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 386
    iget-object v0, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->mimeType:Ljava/lang/String;

    invoke-virtual {v11, v0}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    const-string/jumbo v0, "transactionId"

    .line 387
    iget v12, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->transactionId:I

    invoke-virtual {v11, v0, v12}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const-string v0, "pduType"

    .line 388
    iget v12, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->pduType:I

    invoke-virtual {v11, v0, v12}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const-string v0, "header"

    .line 389
    iget-object v12, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->header:[B

    invoke-virtual {v11, v0, v12}, Landroid/content/Intent;->putExtra(Ljava/lang/String;[B)Landroid/content/Intent;

    const-string v0, "data"

    .line 390
    iget-object v12, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->intentData:[B

    invoke-virtual {v11, v0, v12}, Landroid/content/Intent;->putExtra(Ljava/lang/String;[B)Landroid/content/Intent;

    const-string v0, "contentTypeParameters"

    .line 391
    iget-object v12, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->contentTypeParameters:Ljava/util/HashMap;

    invoke-virtual {v11, v0, v12}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/io/Serializable;)Landroid/content/Intent;

    .line 392
    invoke-static/range {p4 .. p4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_6

    const-string v0, "address"

    .line 393
    invoke-virtual {v11, v0, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    :cond_6
    const-wide/16 v12, 0x0

    cmp-long v0, v4, v12

    if-eqz v0, :cond_7

    const-string v0, "messageId"

    .line 396
    invoke-virtual {v11, v0, v4, v5}, Landroid/content/Intent;->putExtra(Ljava/lang/String;J)Landroid/content/Intent;

    .line 401
    :cond_7
    iget-object v0, v1, Lcom/android/internal/telephony/WapPushOverSms;->mContext:Landroid/content/Context;

    invoke-static {v0, v10}, Lcom/android/internal/telephony/SmsApplication;->getDefaultMmsApplication(Landroid/content/Context;Z)Landroid/content/ComponentName;

    move-result-object v0

    const/4 v2, 0x0

    if-eqz v0, :cond_8

    .line 405
    invoke-virtual {v11, v0}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    .line 408
    iget-object v1, v1, Lcom/android/internal/telephony/WapPushOverSms;->mPowerWhitelistManager:Landroid/os/PowerWhitelistManager;

    .line 409
    invoke-virtual {v0}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object v0

    const-string v2, "mms-app"

    .line 408
    invoke-virtual {v1, v0, v9, v7, v2}, Landroid/os/PowerWhitelistManager;->whitelistAppTemporarilyForEvent(Ljava/lang/String;IILjava/lang/String;)J

    move-result-wide v13

    .line 411
    invoke-static {}, Landroid/app/BroadcastOptions;->makeBasic()Landroid/app/BroadcastOptions;

    move-result-object v0

    const/4 v15, 0x0

    const/16 v16, 0x13b

    const-string v17, ""

    move-object v12, v0

    .line 412
    invoke-virtual/range {v12 .. v17}, Landroid/app/BroadcastOptions;->setTemporaryAppAllowlist(JIILjava/lang/String;)V

    .line 416
    invoke-virtual {v0}, Landroid/app/BroadcastOptions;->toBundle()Landroid/os/Bundle;

    move-result-object v0

    move-object v4, v0

    goto :goto_2

    :cond_8
    move-object v4, v2

    .line 419
    :goto_2
    iget-object v0, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->mimeType:Ljava/lang/String;

    invoke-static {v0}, Lcom/android/internal/telephony/WapPushOverSms;->getPermissionForType(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    iget-object v0, v6, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->mimeType:Ljava/lang/String;

    .line 420
    invoke-static {v0}, Lcom/android/internal/telephony/WapPushOverSms;->getAppOpsStringPermissionForIntent(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    sget-object v6, Landroid/os/UserHandle;->SYSTEM:Landroid/os/UserHandle;

    move-object/from16 v0, p3

    move-object v1, v11

    move-object v3, v5

    move-object/from16 v5, p2

    move/from16 v7, p5

    .line 419
    invoke-virtual/range {v0 .. v7}, Lcom/android/internal/telephony/InboundSmsHandler;->dispatchIntent(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/String;Landroid/os/Bundle;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;Landroid/os/UserHandle;I)V

    return v8
.end method

.method public dispose()V
    .locals 1

    .line 147
    iget-object v0, p0, Lcom/android/internal/telephony/WapPushOverSms;->mWapPushManager:Lcom/android/internal/telephony/IWapPushManager;

    if-eqz v0, :cond_0

    .line 149
    iget-object v0, p0, Lcom/android/internal/telephony/WapPushOverSms;->mContext:Landroid/content/Context;

    invoke-virtual {v0, p0}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V

    goto :goto_0

    :cond_0
    const-string p0, "WAP PUSH"

    const-string v0, "dispose: not bound to a wappush manager"

    .line 151
    invoke-static {p0, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method public isWapPushForMms([BLcom/android/internal/telephony/InboundSmsHandler;)Z
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 430
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/WapPushOverSms;->decodeWapPdu([BLcom/android/internal/telephony/InboundSmsHandler;)Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;

    move-result-object p0

    .line 431
    iget p1, p0, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->statusCode:I

    const/4 p2, -0x1

    if-ne p1, p2, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/WapPushOverSms$DecodedResult;->mimeType:Ljava/lang/String;

    const-string p1, "application/vnd.wap.mms-message"

    .line 432
    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public onServiceConnected(Landroid/content/ComponentName;Landroid/os/IBinder;)V
    .locals 0

    .line 127
    invoke-static {p2}, Lcom/android/internal/telephony/IWapPushManager$Stub;->asInterface(Landroid/os/IBinder;)Lcom/android/internal/telephony/IWapPushManager;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/WapPushOverSms;->mWapPushManager:Lcom/android/internal/telephony/IWapPushManager;

    return-void
.end method

.method public onServiceDisconnected(Landroid/content/ComponentName;)V
    .locals 0

    const/4 p1, 0x0

    .line 133
    iput-object p1, p0, Lcom/android/internal/telephony/WapPushOverSms;->mWapPushManager:Lcom/android/internal/telephony/IWapPushManager;

    return-void
.end method
