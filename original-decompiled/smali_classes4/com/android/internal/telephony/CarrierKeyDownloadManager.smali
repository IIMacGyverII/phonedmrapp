.class public Lcom/android/internal/telephony/CarrierKeyDownloadManager;
.super Landroid/os/Handler;
.source "CarrierKeyDownloadManager.java"


# static fields
.field private static final CARRIER_KEY_TYPES:[I

.field private static final CERT_BEGIN_STRING:Ljava/lang/String; = "-----BEGIN CERTIFICATE-----"

.field private static final CERT_END_STRING:Ljava/lang/String; = "-----END CERTIFICATE-----"

.field private static final DAY_IN_MILLIS:I = 0x5265c00

.field private static final END_RENEWAL_WINDOW_DAYS:I = 0x7

.field private static final EVENT_ALARM_OR_CONFIG_CHANGE:I = 0x0

.field private static final EVENT_DOWNLOAD_COMPLETE:I = 0x1

.field private static final INTENT_KEY_RENEWAL_ALARM_PREFIX:Ljava/lang/String; = "com.android.internal.telephony.carrier_key_download_alarm"

.field private static final JSON_CARRIER_KEYS:Ljava/lang/String; = "carrier-keys"

.field private static final JSON_CERTIFICATE:Ljava/lang/String; = "certificate"

.field private static final JSON_CERTIFICATE_ALTERNATE:Ljava/lang/String; = "public-key"

.field private static final JSON_IDENTIFIER:Ljava/lang/String; = "key-identifier"

.field private static final JSON_TYPE:Ljava/lang/String; = "key-type"

.field private static final JSON_TYPE_VALUE_EPDG:Ljava/lang/String; = "EPDG"

.field private static final JSON_TYPE_VALUE_WLAN:Ljava/lang/String; = "WLAN"

.field private static final LOG_TAG:Ljava/lang/String; = "CarrierKeyDownloadManager"

.field private static final START_RENEWAL_WINDOW_DAYS:I = 0x15


# instance fields
.field private mAllowedOverMeteredNetwork:Z

.field private final mBroadcastReceiver:Landroid/content/BroadcastReceiver;

.field public mCarrierId:I

.field private final mContext:Landroid/content/Context;

.field private mDeleteOldKeyAfterDownload:Z

.field public mDownloadId:J
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field public final mDownloadManager:Landroid/app/DownloadManager;

.field private final mDownloadReceiver:Landroid/content/BroadcastReceiver;

.field public mKeyAvailability:I
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field public mMccMncForDownload:Ljava/lang/String;
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private mTelephonyManager:Landroid/telephony/TelephonyManager;

.field private mURL:Ljava/lang/String;


# direct methods
.method static bridge synthetic -$$Nest$fgetmPhone(Lcom/android/internal/telephony/CarrierKeyDownloadManager;)Lcom/android/internal/telephony/Phone;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mPhone:Lcom/android/internal/telephony/Phone;

    return-object p0
.end method

.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 104
    fill-array-data v0, :array_0

    sput-object v0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->CARRIER_KEY_TYPES:[I

    return-void

    nop

    :array_0
    .array-data 4
        0x1
        0x2
    .end array-data
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;)V
    .locals 4

    .line 121
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    const/4 v0, 0x0

    .line 89
    iput v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mKeyAvailability:I

    .line 111
    iput-boolean v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mAllowedOverMeteredNetwork:Z

    .line 112
    iput-boolean v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDeleteOldKeyAfterDownload:Z

    .line 134
    new-instance v0, Lcom/android/internal/telephony/CarrierKeyDownloadManager$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager$1;-><init>(Lcom/android/internal/telephony/CarrierKeyDownloadManager;)V

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadReceiver:Landroid/content/BroadcastReceiver;

    .line 146
    new-instance v0, Lcom/android/internal/telephony/CarrierKeyDownloadManager$2;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager$2;-><init>(Lcom/android/internal/telephony/CarrierKeyDownloadManager;)V

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mBroadcastReceiver:Landroid/content/BroadcastReceiver;

    .line 122
    iput-object p1, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 123
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mContext:Landroid/content/Context;

    .line 124
    new-instance v2, Landroid/content/IntentFilter;

    invoke-direct {v2}, Landroid/content/IntentFilter;-><init>()V

    const-string v3, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    .line 125
    invoke-virtual {v2, v3}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v3, "com.android.internal.telephony.carrier_key_download_alarm"

    .line 126
    invoke-virtual {v2, v3}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v3, "com.android.internal.telephony.ACTION_CARRIER_CERTIFICATE_DOWNLOAD"

    .line 127
    invoke-virtual {v2, v3}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const/4 v3, 0x0

    .line 128
    invoke-virtual {v1, v0, v2, v3, p1}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;)Landroid/content/Intent;

    const-string v0, "download"

    .line 129
    invoke-virtual {v1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/DownloadManager;

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadManager:Landroid/app/DownloadManager;

    .line 130
    const-class v0, Landroid/telephony/TelephonyManager;

    invoke-virtual {v1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyManager;

    .line 131
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    invoke-virtual {v0, p1}, Landroid/telephony/TelephonyManager;->createForSubscriptionId(I)Landroid/telephony/TelephonyManager;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    return-void
.end method

.method private carrierUsesKeys()Z
    .locals 5

    .line 386
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mContext:Landroid/content/Context;

    const-string v1, "carrier_config"

    .line 387
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 391
    :cond_0
    iget-object v2, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    .line 392
    invoke-virtual {v0, v2}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v0

    if-nez v0, :cond_1

    return v1

    :cond_1
    const-string v2, "imsi_key_availability_int"

    .line 396
    invoke-virtual {v0, v2}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result v2

    iput v2, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mKeyAvailability:I

    const-string v2, "imsi_key_download_url_string"

    .line 397
    invoke-virtual {v0, v2}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    iput-object v2, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mURL:Ljava/lang/String;

    const-string v2, "allow_metered_network_for_cert_download_bool"

    .line 398
    invoke-virtual {v0, v2}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mAllowedOverMeteredNetwork:Z

    .line 400
    iget v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mKeyAvailability:I

    if-eqz v0, :cond_5

    iget-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mURL:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_2

    goto :goto_1

    .line 406
    :cond_2
    sget-object v0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->CARRIER_KEY_TYPES:[I

    array-length v2, v0

    move v3, v1

    :goto_0
    if-ge v3, v2, :cond_4

    aget v4, v0, v3

    .line 407
    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->isKeyEnabled(I)Z

    move-result v4

    if-eqz v4, :cond_3

    const/4 p0, 0x1

    return p0

    :cond_3
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_4
    return v1

    .line 401
    :cond_5
    :goto_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Carrier not enabled or invalid values. mKeyAvailability="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mKeyAvailability:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " mURL="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mURL:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "CarrierKeyDownloadManager"

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return v1
.end method

.method public static cleanCertString(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    const-string v0, "-----BEGIN CERTIFICATE-----"

    .line 643
    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    const-string v1, "-----END CERTIFICATE-----"

    .line 644
    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    add-int/lit8 v1, v1, 0x19

    .line 642
    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private cleanupDownloadInfo()V
    .locals 2

    const-string v0, "CarrierKeyDownloadManager"

    const-string v1, "Cleaning up download info"

    .line 221
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const-wide/16 v0, -0x1

    .line 222
    iput-wide v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadId:J

    const/4 v0, 0x0

    .line 223
    iput-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mMccMncForDownload:Ljava/lang/String;

    const/4 v0, -0x1

    .line 224
    iput v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mCarrierId:I

    return-void
.end method

.method private cleanupRenewalAlarms()V
    .locals 4

    const-string v0, "CarrierKeyDownloadManager"

    const-string v1, "Cleaning up existing renewal alarms"

    .line 228
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 229
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->getSlotIndex(I)I

    move-result v0

    .line 230
    new-instance v1, Landroid/content/Intent;

    const-string v2, "com.android.internal.telephony.carrier_key_download_alarm"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v2, "android.telephony.extra.SLOT_INDEX"

    .line 231
    invoke-virtual {v1, v2, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 232
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mContext:Landroid/content/Context;

    const/4 v2, 0x0

    const/high16 v3, 0xc000000

    invoke-static {v0, v2, v1, v3}, Landroid/app/PendingIntent;->getBroadcast(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v0

    .line 234
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mContext:Landroid/content/Context;

    const-string v1, "alarm"

    .line 235
    invoke-virtual {p0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/app/AlarmManager;

    .line 236
    invoke-virtual {p0, v0}, Landroid/app/AlarmManager;->cancel(Landroid/app/PendingIntent;)V

    return-void
.end method

.method private static convertToString(Landroid/app/DownloadManager;J)Ljava/lang/String;
    .locals 4

    const-string v0, "CarrierKeyDownloadManager"

    const/4 v1, 0x0

    .line 435
    :try_start_0
    new-instance v2, Ljava/io/FileInputStream;

    .line 436
    invoke-virtual {p0, p1, p2}, Landroid/app/DownloadManager;->openDownloadedFile(J)Landroid/os/ParcelFileDescriptor;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/ParcelFileDescriptor;->getFileDescriptor()Ljava/io/FileDescriptor;

    move-result-object p0

    invoke-direct {v2, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/FileDescriptor;)V
    :try_end_0
    .catch Ljava/util/zip/ZipException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 437
    :try_start_1
    new-instance p0, Ljava/util/zip/GZIPInputStream;

    invoke-direct {p0, v2}, Ljava/util/zip/GZIPInputStream;-><init>(Ljava/io/InputStream;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    .line 438
    :try_start_2
    new-instance p1, Ljava/io/BufferedReader;

    new-instance p2, Ljava/io/InputStreamReader;

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {p2, p0, v3}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/nio/charset/Charset;)V

    invoke-direct {p1, p2}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 439
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    .line 442
    :goto_0
    invoke-virtual {p1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_0

    .line 443
    invoke-virtual {p2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v3, 0xa

    invoke-virtual {p2, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_0

    .line 445
    :cond_0
    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 446
    :try_start_3
    invoke-virtual {p0}, Ljava/io/InputStream;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    :try_start_4
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_4
    .catch Ljava/util/zip/ZipException; {:try_start_4 .. :try_end_4} :catch_1
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_0

    return-object p1

    :catchall_0
    move-exception p1

    .line 435
    :try_start_5
    invoke-virtual {p0}, Ljava/io/InputStream;->close()V
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_1

    goto :goto_1

    :catchall_1
    move-exception p0

    :try_start_6
    invoke-virtual {p1, p0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_1
    throw p1
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_2

    :catchall_2
    move-exception p0

    :try_start_7
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_3

    goto :goto_2

    :catchall_3
    move-exception p1

    :try_start_8
    invoke-virtual {p0, p1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_2
    throw p0
    :try_end_8
    .catch Ljava/util/zip/ZipException; {:try_start_8 .. :try_end_8} :catch_1
    .catch Ljava/io/IOException; {:try_start_8 .. :try_end_8} :catch_0

    :catch_0
    move-exception p0

    .line 451
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "Unexpected exception in convertToString e="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-object v1

    :catch_1
    move-exception p0

    .line 448
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "Stream is not gzipped e="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v1
.end method

.method private static convertToStringNoGZip(Landroid/app/DownloadManager;J)Ljava/lang/String;
    .locals 2

    .line 415
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 416
    :try_start_0
    new-instance v1, Ljava/io/FileInputStream;

    .line 417
    invoke-virtual {p0, p1, p2}, Landroid/app/DownloadManager;->openDownloadedFile(J)Landroid/os/ParcelFileDescriptor;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/ParcelFileDescriptor;->getFileDescriptor()Ljava/io/FileDescriptor;

    move-result-object p0

    invoke-direct {v1, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/FileDescriptor;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 421
    :try_start_1
    new-instance p0, Ljava/io/BufferedReader;

    new-instance p1, Ljava/io/InputStreamReader;

    sget-object p2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {p1, v1, p2}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/nio/charset/Charset;)V

    invoke-direct {p0, p1}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 424
    :goto_0
    invoke-virtual {p0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 425
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 p1, 0xa

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    .line 427
    :cond_0
    :try_start_2
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_0

    .line 431
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :catchall_0
    move-exception p0

    .line 416
    :try_start_3
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_1

    :catchall_1
    move-exception p1

    :try_start_4
    invoke-virtual {p0, p1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_1
    throw p0
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_0

    :catch_0
    move-exception p0

    .line 428
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    const/4 p0, 0x0

    return-object p0
.end method

.method private downloadKey()Z
    .locals 11

    .line 566
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "starting download from: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mURL:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "CarrierKeyDownloadManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 567
    invoke-virtual {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->getSimOperator()Ljava/lang/String;

    move-result-object v0

    .line 568
    invoke-virtual {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->getSimCarrierId()I

    move-result v2

    .line 569
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    const/4 v4, 0x0

    if-eqz v3, :cond_1

    const/4 v3, -0x1

    if-eq v2, v3, :cond_0

    goto :goto_0

    :cond_0
    const-string p0, "mccmnc or carrierId is UnKnown"

    .line 573
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v4

    .line 570
    :cond_1
    :goto_0
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "downloading key for mccmnc : "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, ", carrierId : "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 578
    :try_start_0
    new-instance v7, Landroid/content/IntentFilter;

    const-string v3, "android.intent.action.DOWNLOAD_COMPLETE"

    invoke-direct {v7, v3}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    .line 579
    iget-object v5, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mContext:Landroid/content/Context;

    iget-object v6, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadReceiver:Landroid/content/BroadcastReceiver;

    const/4 v8, 0x0

    iget-object v9, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mPhone:Lcom/android/internal/telephony/Phone;

    const/4 v10, 0x2

    invoke-virtual/range {v5 .. v10}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;I)Landroid/content/Intent;

    .line 582
    new-instance v3, Landroid/app/DownloadManager$Request;

    iget-object v5, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mURL:Ljava/lang/String;

    invoke-static {v5}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v5

    invoke-direct {v3, v5}, Landroid/app/DownloadManager$Request;-><init>(Landroid/net/Uri;)V

    .line 586
    iget-boolean v5, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mAllowedOverMeteredNetwork:Z

    invoke-virtual {v3, v5}, Landroid/app/DownloadManager$Request;->setAllowedOverMetered(Z)Landroid/app/DownloadManager$Request;

    const/4 v5, 0x2

    .line 587
    invoke-virtual {v3, v5}, Landroid/app/DownloadManager$Request;->setNotificationVisibility(I)Landroid/app/DownloadManager$Request;

    const-string v5, "Accept-Encoding"

    const-string v6, "gzip"

    .line 588
    invoke-virtual {v3, v5, v6}, Landroid/app/DownloadManager$Request;->addRequestHeader(Ljava/lang/String;Ljava/lang/String;)Landroid/app/DownloadManager$Request;

    .line 589
    iget-object v5, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadManager:Landroid/app/DownloadManager;

    invoke-virtual {v5, v3}, Landroid/app/DownloadManager;->enqueue(Landroid/app/DownloadManager$Request;)J

    move-result-wide v5

    invoke-static {v5, v6}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    .line 591
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "saving values mccmnc: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, ", downloadId: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v6, ", carrierId: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v1, v5}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 593
    iput-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mMccMncForDownload:Ljava/lang/String;

    .line 594
    iput v2, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mCarrierId:I

    .line 595
    invoke-virtual {v3}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    iput-wide v2, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadId:J
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const/4 p0, 0x1

    return p0

    .line 597
    :catch_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "exception trying to download key from url: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mURL:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v4
.end method

.method public static getKeyInformation([B)Landroid/util/Pair;
    .locals 4
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([B)",
            "Landroid/util/Pair<",
            "Ljava/security/PublicKey;",
            "Ljava/lang/Long;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 610
    new-instance v0, Ljava/io/ByteArrayInputStream;

    invoke-direct {v0, p0}, Ljava/io/ByteArrayInputStream;-><init>([B)V

    const-string p0, "X.509"

    .line 611
    invoke-static {p0}, Ljava/security/cert/CertificateFactory;->getInstance(Ljava/lang/String;)Ljava/security/cert/CertificateFactory;

    move-result-object p0

    .line 612
    invoke-virtual {p0, v0}, Ljava/security/cert/CertificateFactory;->generateCertificate(Ljava/io/InputStream;)Ljava/security/cert/Certificate;

    move-result-object p0

    check-cast p0, Ljava/security/cert/X509Certificate;

    .line 613
    new-instance v0, Landroid/util/Pair;

    .line 614
    invoke-virtual {p0}, Ljava/security/cert/X509Certificate;->getPublicKey()Ljava/security/PublicKey;

    move-result-object v1

    invoke-virtual {p0}, Ljava/security/cert/X509Certificate;->getNotAfter()Ljava/util/Date;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/Date;->getTime()J

    move-result-wide v2

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0

    invoke-direct {v0, v1, p0}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    return-object v0
.end method

.method private handleAlarmOrConfigChange()V
    .locals 1

    .line 201
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->carrierUsesKeys()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 202
    invoke-virtual {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->areCarrierKeysAbsentOrExpiring()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 203
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->downloadKey()Z

    move-result v0

    if-nez v0, :cond_2

    .line 208
    invoke-virtual {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->resetRenewalAlarm()V

    goto :goto_0

    :cond_0
    return-void

    .line 215
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->cleanupRenewalAlarms()V

    .line 216
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->getSimCarrierId()I

    move-result p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/Phone;->deleteCarrierInfoForImsiEncryption(I)V

    :cond_2
    :goto_0
    return-void
.end method

.method public static isKeyEnabled(II)Z
    .locals 1

    const/4 v0, 0x1

    sub-int/2addr p0, v0

    shr-int p0, p1, p0

    and-int/2addr p0, v0

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private onDownloadComplete(JLjava/lang/String;I)V
    .locals 6

    .line 347
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDownloadComplete: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "CarrierKeyDownloadManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 349
    new-instance v0, Landroid/app/DownloadManager$Query;

    invoke-direct {v0}, Landroid/app/DownloadManager$Query;-><init>()V

    const/4 v2, 0x1

    new-array v3, v2, [J

    const/4 v4, 0x0

    aput-wide p1, v3, v4

    .line 350
    invoke-virtual {v0, v3}, Landroid/app/DownloadManager$Query;->setFilterById([J)Landroid/app/DownloadManager$Query;

    .line 351
    iget-object v3, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadManager:Landroid/app/DownloadManager;

    invoke-virtual {v3, v0}, Landroid/app/DownloadManager;->query(Landroid/app/DownloadManager$Query;)Landroid/database/Cursor;

    move-result-object v0

    if-nez v0, :cond_0

    return-void

    .line 356
    :cond_0
    invoke-interface {v0}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v3

    if-eqz v3, :cond_3

    const-string/jumbo v3, "status"

    .line 357
    invoke-interface {v0, v3}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v3

    const/16 v5, 0x8

    .line 358
    invoke-interface {v0, v3}, Landroid/database/Cursor;->getInt(I)I

    move-result v3

    if-ne v5, v3, :cond_2

    .line 360
    :try_start_0
    iget-object v3, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadManager:Landroid/app/DownloadManager;

    invoke-static {v3, p1, p2}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->convertToString(Landroid/app/DownloadManager;J)Ljava/lang/String;

    move-result-object v3

    .line 361
    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-eqz v5, :cond_1

    const-string v3, "fallback to no gzip"

    .line 362
    invoke-static {v1, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 363
    iget-object v3, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadManager:Landroid/app/DownloadManager;

    invoke-static {v3, p1, p2}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->convertToStringNoGZip(Landroid/app/DownloadManager;J)Ljava/lang/String;

    move-result-object v3

    .line 366
    :cond_1
    invoke-virtual {p0, v3, p3, p4}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->parseJsonAndPersistKey(Ljava/lang/String;Ljava/lang/String;I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 371
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadManager:Landroid/app/DownloadManager;

    new-array p3, v2, [J

    aput-wide p1, p3, v4

    invoke-virtual {p0, p3}, Landroid/app/DownloadManager;->remove([J)I

    goto :goto_1

    :catchall_0
    move-exception p3

    goto :goto_0

    :catch_0
    move-exception p3

    .line 368
    :try_start_1
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Error in download:"

    invoke-virtual {p4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v3, ". "

    invoke-virtual {p4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-static {v1, p3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 371
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadManager:Landroid/app/DownloadManager;

    new-array p3, v2, [J

    aput-wide p1, p3, v4

    invoke-virtual {p0, p3}, Landroid/app/DownloadManager;->remove([J)I

    goto :goto_1

    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadManager:Landroid/app/DownloadManager;

    new-array p4, v2, [J

    aput-wide p1, p4, v4

    invoke-virtual {p0, p4}, Landroid/app/DownloadManager;->remove([J)I

    .line 372
    throw p3

    :cond_2
    :goto_1
    const-string p0, "Completed downloading keys"

    .line 374
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 376
    :cond_3
    invoke-interface {v0}, Landroid/database/Cursor;->close()V

    return-void
.end method

.method private onPostDownloadProcessing(J)V
    .locals 0

    .line 193
    invoke-virtual {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->resetRenewalAlarm()V

    .line 194
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->cleanupDownloadInfo()V

    .line 197
    iget-object p1, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mContext:Landroid/content/Context;

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {p1, p0}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V

    return-void
.end method


# virtual methods
.method public areCarrierKeysAbsentOrExpiring()Z
    .locals 6
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 542
    sget-object v0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->CARRIER_KEY_TYPES:[I

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_3

    aget v4, v0, v3

    .line 543
    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->isKeyEnabled(I)Z

    move-result v5

    if-nez v5, :cond_0

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 548
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 549
    invoke-virtual {v0, v4, v2}, Lcom/android/internal/telephony/Phone;->getCarrierInfoForImsiEncryption(IZ)Landroid/telephony/ImsiEncryptionInfo;

    move-result-object v0

    const-string v1, "CarrierKeyDownloadManager"

    const/4 v3, 0x1

    if-nez v0, :cond_1

    .line 551
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Key not found for: "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return v3

    .line 553
    :cond_1
    invoke-virtual {v0}, Landroid/telephony/ImsiEncryptionInfo;->getCarrierId()I

    move-result v4

    const/4 v5, -0x1

    if-ne v4, v5, :cond_2

    const-string v0, "carrier key is unknown carrier, so prefer to reDownload"

    .line 554
    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 555
    iput-boolean v3, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDeleteOldKeyAfterDownload:Z

    return v3

    .line 558
    :cond_2
    invoke-virtual {v0}, Landroid/telephony/ImsiEncryptionInfo;->getExpirationTime()Ljava/util/Date;

    move-result-object p0

    .line 559
    invoke-virtual {p0}, Ljava/util/Date;->getTime()J

    move-result-wide v0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    sub-long/2addr v0, v4

    const-wide/32 v4, 0x6c258c00

    cmp-long p0, v0, v4

    if-gez p0, :cond_3

    move v2, v3

    :cond_3
    return v2
.end method

.method public getExpirationDate()J
    .locals 11
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 246
    sget-object v0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->CARRIER_KEY_TYPES:[I

    array-length v1, v0

    const/4 v2, 0x0

    const-wide v3, 0x7fffffffffffffffL

    move v5, v2

    move-wide v6, v3

    :goto_0
    if-ge v5, v1, :cond_2

    aget v8, v0, v5

    .line 247
    invoke-virtual {p0, v8}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->isKeyEnabled(I)Z

    move-result v9

    if-nez v9, :cond_0

    goto :goto_1

    .line 250
    :cond_0
    iget-object v9, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 251
    invoke-virtual {v9, v8, v2}, Lcom/android/internal/telephony/Phone;->getCarrierInfoForImsiEncryption(IZ)Landroid/telephony/ImsiEncryptionInfo;

    move-result-object v8

    if-eqz v8, :cond_1

    .line 252
    invoke-virtual {v8}, Landroid/telephony/ImsiEncryptionInfo;->getExpirationTime()Ljava/util/Date;

    move-result-object v9

    if-eqz v9, :cond_1

    .line 253
    invoke-virtual {v8}, Landroid/telephony/ImsiEncryptionInfo;->getExpirationTime()Ljava/util/Date;

    move-result-object v9

    invoke-virtual {v9}, Ljava/util/Date;->getTime()J

    move-result-wide v9

    cmp-long v9, v6, v9

    if-lez v9, :cond_1

    .line 254
    invoke-virtual {v8}, Landroid/telephony/ImsiEncryptionInfo;->getExpirationTime()Ljava/util/Date;

    move-result-object v6

    invoke-virtual {v6}, Ljava/util/Date;->getTime()J

    move-result-wide v6

    :cond_1
    :goto_1
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    :cond_2
    cmp-long p0, v6, v3

    if-eqz p0, :cond_4

    .line 263
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    const-wide/32 v2, 0x240c8400

    add-long/2addr v0, v2

    cmp-long p0, v6, v0

    if-gez p0, :cond_3

    goto :goto_2

    .line 268
    :cond_3
    new-instance p0, Ljava/util/Random;

    invoke-direct {p0}, Ljava/util/Random;-><init>()V

    const v0, 0x240c8400

    const v1, 0x48190800

    .line 271
    invoke-virtual {p0, v1}, Ljava/util/Random;->nextInt(I)I

    move-result p0

    add-int/2addr p0, v0

    int-to-long v0, p0

    sub-long/2addr v6, v0

    goto :goto_3

    .line 264
    :cond_4
    :goto_2
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    const-wide/32 v2, 0x5265c00

    add-long v6, v0, v2

    :goto_3
    return-wide v6
.end method

.method public getSimCarrierId()I
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 313
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    invoke-virtual {p0}, Landroid/telephony/TelephonyManager;->getSimCarrierId()I

    move-result p0

    return p0
.end method

.method public getSimOperator()Ljava/lang/String;
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 305
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/telephony/TelephonyManager;->getSimOperator(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 4

    .line 176
    iget v0, p1, Landroid/os/Message;->what:I

    if-eqz v0, :cond_1

    const/4 v1, 0x1

    if-eq v0, v1, :cond_0

    goto :goto_0

    .line 181
    :cond_0
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Long;

    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    .line 182
    invoke-virtual {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->getSimOperator()Ljava/lang/String;

    move-result-object p1

    .line 183
    invoke-virtual {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->getSimCarrierId()I

    move-result v2

    .line 184
    invoke-virtual {p0, p1, v0, v1, v2}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->isValidDownload(Ljava/lang/String;JI)Z

    move-result v3

    if-eqz v3, :cond_2

    .line 185
    invoke-direct {p0, v0, v1, p1, v2}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->onDownloadComplete(JLjava/lang/String;I)V

    .line 186
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->onPostDownloadProcessing(J)V

    goto :goto_0

    .line 178
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->handleAlarmOrConfigChange()V

    :cond_2
    :goto_0
    return-void
.end method

.method public isKeyEnabled(I)Z
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 522
    iget p0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mKeyAvailability:I

    invoke-static {p1, p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->isKeyEnabled(II)Z

    move-result p0

    return p0
.end method

.method public isValidDownload(Ljava/lang/String;JI)Z
    .locals 3
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 323
    iget-wide v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadId:J

    cmp-long v0, p2, v0

    const/4 v1, 0x0

    const-string v2, "CarrierKeyDownloadManager"

    if-eqz v0, :cond_0

    .line 324
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "download ID="

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2, p3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p2, " for completed download does not match stored id="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide p2, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDownloadId:J

    invoke-virtual {p1, p2, p3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v1

    .line 329
    :cond_0
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mMccMncForDownload:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mMccMncForDownload:Ljava/lang/String;

    .line 330
    invoke-static {p1, v0}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_2

    iget v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mCarrierId:I

    if-eq v0, p4, :cond_1

    goto :goto_0

    .line 337
    :cond_1
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Matched MccMnc =  "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", carrierId = "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", downloadId: "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2, p3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0

    .line 332
    :cond_2
    :goto_0
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "currentMccMnc="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " storedMccMnc ="

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mMccMncForDownload:Ljava/lang/String;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "currentCarrierId = "

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, "  storedCarrierId = "

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mCarrierId:I

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v1
.end method

.method public parseJsonAndPersistKey(Ljava/lang/String;Ljava/lang/String;I)V
    .locals 20
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    move-object/from16 v0, p0

    move-object/from16 v1, p2

    const-string v10, "key-type"

    const-string v11, "certificate"

    .line 469
    invoke-static/range {p1 .. p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    const-string v12, "CarrierKeyDownloadManager"

    if-nez v2, :cond_6

    invoke-static/range {p2 .. p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_6

    const/4 v13, -0x1

    move/from16 v14, p3

    if-ne v14, v13, :cond_0

    goto/16 :goto_4

    :cond_0
    const/4 v2, 0x3

    const/4 v15, 0x0

    .line 475
    :try_start_0
    invoke-virtual {v1, v15, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v16

    .line 476
    invoke-virtual {v1, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v17

    .line 477
    new-instance v1, Lorg/json/JSONObject;

    move-object/from16 v2, p1

    invoke-direct {v1, v2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v2, "carrier-keys"

    .line 478
    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v9

    move v8, v15

    .line 479
    :goto_0
    invoke-virtual {v9}, Lorg/json/JSONArray;->length()I

    move-result v1

    if-ge v8, v1, :cond_5

    .line 480
    invoke-virtual {v9, v8}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v1

    .line 483
    invoke-virtual {v1, v11}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 484
    invoke-virtual {v1, v11}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    goto :goto_1

    :cond_1
    const-string v2, "public-key"

    .line 486
    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    :goto_1
    const/4 v3, 0x2

    .line 491
    invoke-virtual {v1, v10}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_3

    .line 492
    invoke-virtual {v1, v10}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, "EPDG"

    .line 493
    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_2

    const/4 v3, 0x1

    goto :goto_2

    :cond_2
    const-string v5, "WLAN"

    .line 495
    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_3

    .line 496
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Invalid key-type specified: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v12, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_3
    :goto_2
    const-string v4, "key-identifier"

    .line 499
    invoke-virtual {v1, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 501
    invoke-static {v2}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->cleanCertString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->getBytes()[B

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->getKeyInformation([B)Landroid/util/Pair;

    move-result-object v1

    .line 502
    iget-boolean v2, v0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDeleteOldKeyAfterDownload:Z

    if-eqz v2, :cond_4

    .line 503
    iget-object v2, v0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2, v13}, Lcom/android/internal/telephony/Phone;->deleteCarrierInfoForImsiEncryption(I)V

    .line 504
    iput-boolean v15, v0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mDeleteOldKeyAfterDownload:Z

    .line 506
    :cond_4
    iget-object v2, v1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v2, Ljava/security/PublicKey;

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Long;

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v5

    move-object/from16 v1, p0

    move-object/from16 v7, v16

    move/from16 v18, v8

    move-object/from16 v8, v17

    move-object/from16 v19, v9

    move/from16 v9, p3

    invoke-virtual/range {v1 .. v9}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->savePublicKey(Ljava/security/PublicKey;ILjava/lang/String;JLjava/lang/String;Ljava/lang/String;I)V
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    add-int/lit8 v8, v18, 0x1

    move-object/from16 v9, v19

    goto/16 :goto_0

    :catch_0
    move-exception v0

    .line 511
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Exception getting certificate: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v12, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_3

    :catch_1
    move-exception v0

    .line 509
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Json parsing error: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Lorg/json/JSONException;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v12, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_5
    :goto_3
    return-void

    :cond_6
    :goto_4
    const-string v0, "jsonStr or mcc, mnc: is empty or carrierId is UNKNOWN_CARRIER_ID"

    .line 471
    invoke-static {v12, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public resetRenewalAlarm()V
    .locals 7
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 285
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->cleanupRenewalAlarms()V

    .line 286
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->getSlotIndex(I)I

    move-result v0

    .line 287
    invoke-virtual {p0}, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->getExpirationDate()J

    move-result-wide v1

    .line 288
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "minExpirationDate: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v4, Ljava/util/Date;

    invoke-direct {v4, v1, v2}, Ljava/util/Date;-><init>(J)V

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v4, "CarrierKeyDownloadManager"

    invoke-static {v4, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 289
    iget-object v3, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mContext:Landroid/content/Context;

    const-string v5, "alarm"

    invoke-virtual {v3, v5}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/app/AlarmManager;

    .line 291
    new-instance v5, Landroid/content/Intent;

    const-string v6, "com.android.internal.telephony.carrier_key_download_alarm"

    invoke-direct {v5, v6}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v6, "android.telephony.extra.SLOT_INDEX"

    .line 292
    invoke-virtual {v5, v6, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 293
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mContext:Landroid/content/Context;

    const/4 v0, 0x0

    const/high16 v6, 0xc000000

    invoke-static {p0, v0, v5, v6}, Landroid/app/PendingIntent;->getBroadcast(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object p0

    .line 295
    invoke-virtual {v3, v0, v1, v2, p0}, Landroid/app/AlarmManager;->set(IJLandroid/app/PendingIntent;)V

    .line 296
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "setRenewalAlarm: action="

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " time="

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v0, Ljava/util/Date;

    invoke-direct {v0, v1, v2}, Ljava/util/Date;-><init>(J)V

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v4, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public savePublicKey(Ljava/security/PublicKey;ILjava/lang/String;JLjava/lang/String;Ljava/lang/String;I)V
    .locals 9
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 630
    new-instance v8, Landroid/telephony/ImsiEncryptionInfo;

    new-instance v6, Ljava/util/Date;

    move-wide v0, p4

    invoke-direct {v6, p4, p5}, Ljava/util/Date;-><init>(J)V

    move-object v0, v8

    move-object v1, p6

    move-object/from16 v2, p7

    move v3, p2

    move-object v4, p3

    move-object v5, p1

    move/from16 v7, p8

    invoke-direct/range {v0 .. v7}, Landroid/telephony/ImsiEncryptionInfo;-><init>(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;Ljava/security/PublicKey;Ljava/util/Date;I)V

    move-object v0, p0

    .line 632
    iget-object v0, v0, Lcom/android/internal/telephony/CarrierKeyDownloadManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0, v8}, Lcom/android/internal/telephony/Phone;->setCarrierInfoForImsiEncryption(Landroid/telephony/ImsiEncryptionInfo;)V

    return-void
.end method
