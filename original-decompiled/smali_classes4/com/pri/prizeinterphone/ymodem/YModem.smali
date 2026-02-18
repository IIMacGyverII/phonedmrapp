.class public Lcom/pri/prizeinterphone/ymodem/YModem;
.super Ljava/lang/Object;
.source "YModem.java"

# interfaces
.implements Lcom/pri/prizeinterphone/ymodem/FileStreamThread$DataRaderListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/ymodem/YModem$Builder;
    }
.end annotation


# static fields
.field private static final ACK:B = 0x6t

.field private static final CAN:B = 0x18t

.field private static CURR_STEP:I = 0x1

.field private static final MAX_PACKAGE_SEND_ERROR_TIMES:I = 0x6

.field private static final MD5_ERR:Ljava/lang/String; = "MD5_ERR"

.field private static final MD5_OK:Ljava/lang/String; = "MD5_OK"

.field private static final NAK:B = 0x15t

.field private static final PACKAGE_TIME_OUT:I = 0x3a98

.field public static final STEP_END:I = 0x20

.field public static final STEP_EOT:I = 0x10

.field public static final STEP_ERROR:I = 0x40

.field public static final STEP_FILE_BODY:I = 0x8

.field public static final STEP_FILE_NAME:I = 0x4

.field public static final STEP_HELLO:I = 0x2

.field public static final STEP_IDLE:I = 0x1

.field private static final ST_C:B = 0x43t

.field static mSize:Ljava/lang/Integer;


# instance fields
.field private bytesSent:I

.field private currSending:[B

.field private final fileMd5String:Ljava/lang/String;

.field private final fileNameString:Ljava/lang/String;

.field private final filePath:Ljava/lang/String;

.field private final listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

.field private final mContext:Landroid/content/Context;

.field private packageErrorTimes:I

.field private streamThread:Lcom/pri/prizeinterphone/ymodem/FileStreamThread;

.field private final timeoutListener:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;

.field private final timerHelper:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;


# direct methods
.method static bridge synthetic -$$Nest$fgetcurrSending(Lcom/pri/prizeinterphone/ymodem/YModem;)[B
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->currSending:[B

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mhandlePackageFail(Lcom/pri/prizeinterphone/ymodem/YModem;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handlePackageFail(Ljava/lang/String;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    const/16 v0, 0x400

    .line 71
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    sput-object v0, Lcom/pri/prizeinterphone/ymodem/YModem;->mSize:Ljava/lang/Integer;

    return-void
.end method

.method private constructor <init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;Lcom/pri/prizeinterphone/ymodem/YModemListener;)V
    .locals 2

    .line 83
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 60
    new-instance v0, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->timerHelper:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;

    const/4 v0, 0x0

    .line 64
    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->bytesSent:I

    const/4 v1, 0x0

    .line 66
    iput-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->currSending:[B

    .line 67
    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->packageErrorTimes:I

    .line 349
    new-instance v0, Lcom/pri/prizeinterphone/ymodem/YModem$1;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/ymodem/YModem$1;-><init>(Lcom/pri/prizeinterphone/ymodem/YModem;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->timeoutListener:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;

    .line 84
    iput-object p2, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->filePath:Ljava/lang/String;

    .line 85
    iput-object p3, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->fileNameString:Ljava/lang/String;

    .line 86
    iput-object p4, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->fileMd5String:Ljava/lang/String;

    .line 87
    invoke-virtual {p5}, Ljava/lang/Integer;->intValue()I

    move-result p2

    if-nez p2, :cond_0

    const/16 p2, 0x400

    .line 88
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    sput-object p2, Lcom/pri/prizeinterphone/ymodem/YModem;->mSize:Ljava/lang/Integer;

    .line 89
    :cond_0
    sput-object p5, Lcom/pri/prizeinterphone/ymodem/YModem;->mSize:Ljava/lang/Integer;

    .line 90
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->mContext:Landroid/content/Context;

    .line 91
    iput-object p6, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

    return-void
.end method

.method synthetic constructor <init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;Lcom/pri/prizeinterphone/ymodem/YModemListener;Lcom/pri/prizeinterphone/ymodem/YModem-IA;)V
    .locals 0

    invoke-direct/range {p0 .. p6}, Lcom/pri/prizeinterphone/ymodem/YModem;-><init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;Lcom/pri/prizeinterphone/ymodem/YModemListener;)V

    return-void
.end method

.method private handleData([B)V
    .locals 2

    const/4 v0, 0x0

    .line 225
    aget-byte p1, p1, v0

    const/16 v1, 0x43

    if-ne p1, v1, :cond_0

    const-string p1, "Received \'C\'"

    .line 227
    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 228
    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->packageErrorTimes:I

    .line 229
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/YModem;->sendFileName()V

    goto :goto_0

    .line 231
    :cond_0
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handleOthers(I)V

    :goto_0
    return-void
.end method

.method private handleEOT([B)V
    .locals 2

    const/4 v0, 0x0

    .line 273
    aget-byte p1, p1, v0

    const/4 v1, 0x6

    if-ne p1, v1, :cond_0

    const-string p1, "Received \'ACK\'"

    .line 274
    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 275
    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->packageErrorTimes:I

    .line 276
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/YModem;->sendEND()V

    goto :goto_0

    :cond_0
    const/16 v0, 0x43

    if-ne p1, v0, :cond_1

    const-string p1, "Received \'C\' after sent EOT"

    .line 278
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handlePackageFail(Ljava/lang/String;)V

    goto :goto_0

    :cond_1
    const/16 v0, 0x15

    if-ne p1, v0, :cond_2

    .line 280
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/YModem;->sendEOT()V

    goto :goto_0

    .line 282
    :cond_2
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handleOthers(I)V

    :goto_0
    return-void
.end method

.method private handleEnd([B)V
    .locals 3

    const/4 v0, 0x0

    .line 287
    aget-byte v1, p1, v0

    const/4 v2, 0x6

    if-ne v1, v2, :cond_1

    const-string p1, "Received \'ACK\'"

    .line 288
    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 289
    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->packageErrorTimes:I

    .line 291
    iget-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

    if-eqz p1, :cond_0

    .line 292
    invoke-interface {p1}, Lcom/pri/prizeinterphone/ymodem/YModemListener;->onSuccess()V

    .line 294
    :cond_0
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModem;->stop()V

    goto :goto_0

    .line 295
    :cond_1
    new-instance v1, Ljava/lang/String;

    invoke-direct {v1, p1}, Ljava/lang/String;-><init>([B)V

    const-string v2, "MD5_OK"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    const-string p1, "Received \'MD5_OK\'"

    .line 296
    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 297
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModem;->stop()V

    .line 298
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

    if-eqz p0, :cond_4

    .line 299
    invoke-interface {p0}, Lcom/pri/prizeinterphone/ymodem/YModemListener;->onSuccess()V

    goto :goto_0

    .line 301
    :cond_2
    new-instance v1, Ljava/lang/String;

    invoke-direct {v1, p1}, Ljava/lang/String;-><init>([B)V

    const-string v2, "MD5_ERR"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_3

    const-string p1, "Received \'MD5_ERR\'"

    .line 302
    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 303
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModem;->stop()V

    .line 304
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

    if-eqz p0, :cond_4

    const-string p1, "MD5 check failed!!!"

    .line 305
    invoke-interface {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModemListener;->onFailed(Ljava/lang/String;)V

    goto :goto_0

    .line 308
    :cond_3
    aget-byte p1, p1, v0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handleOthers(I)V

    :cond_4
    :goto_0
    return-void
.end method

.method private handleFileBody([B)V
    .locals 4

    .line 250
    array-length v0, p1

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-ne v0, v1, :cond_1

    aget-byte v0, p1, v2

    const/4 v3, 0x6

    if-ne v0, v3, :cond_1

    const-string p1, "Received \'ACK\'"

    .line 251
    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 252
    iput v2, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->packageErrorTimes:I

    .line 253
    iget p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->bytesSent:I

    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->currSending:[B

    array-length v0, v0

    add-int/2addr p1, v0

    iput p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->bytesSent:I

    .line 255
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

    if-eqz v0, :cond_0

    .line 256
    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->streamThread:Lcom/pri/prizeinterphone/ymodem/FileStreamThread;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->getFileByteSize()I

    move-result v1

    invoke-interface {v0, p1, v1}, Lcom/pri/prizeinterphone/ymodem/YModemListener;->onProgress(II)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 259
    invoke-virtual {p1}, Ljava/lang/Exception;->printStackTrace()V

    .line 261
    :cond_0
    :goto_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->streamThread:Lcom/pri/prizeinterphone/ymodem/FileStreamThread;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->keepReading()V

    goto :goto_1

    .line 263
    :cond_1
    array-length v0, p1

    if-ne v0, v1, :cond_2

    aget-byte v0, p1, v2

    const/16 v1, 0x43

    if-ne v0, v1, :cond_2

    const-string p1, "Received \'C\'"

    .line 264
    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    const-string p1, "Received \'C\' after sent file data"

    .line 266
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handlePackageFail(Ljava/lang/String;)V

    goto :goto_1

    .line 268
    :cond_2
    aget-byte p1, p1, v2

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handleOthers(I)V

    :goto_1
    return-void
.end method

.method private handleFileName([B)V
    .locals 4

    .line 237
    array-length v0, p1

    const/16 v1, 0x43

    const/4 v2, 0x0

    const/4 v3, 0x2

    if-ne v0, v3, :cond_0

    aget-byte v0, p1, v2

    const/4 v3, 0x6

    if-ne v0, v3, :cond_0

    const/4 v0, 0x1

    aget-byte v0, p1, v0

    if-ne v0, v1, :cond_0

    const-string p1, "Received \'ACK C\'"

    .line 238
    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 239
    iput v2, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->packageErrorTimes:I

    .line 240
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/YModem;->startSendFileData()V

    goto :goto_0

    .line 241
    :cond_0
    aget-byte p1, p1, v2

    if-ne p1, v1, :cond_1

    const-string p1, "Received \'C\'"

    .line 242
    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    const-string p1, "Received \'C\' without \'ACK\' after sent file name"

    .line 243
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handlePackageFail(Ljava/lang/String;)V

    goto :goto_0

    .line 245
    :cond_1
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handleOthers(I)V

    :goto_0
    return-void
.end method

.method private handleOthers(I)V
    .locals 1

    const/16 v0, 0x15

    if-ne p1, v0, :cond_0

    const-string p1, "Received \'NAK\'"

    .line 314
    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    const-string p1, "Received NAK"

    .line 315
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handlePackageFail(Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    const/16 v0, 0x18

    if-ne p1, v0, :cond_2

    const-string p1, "Received \'CAN\'"

    .line 317
    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 318
    iget-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

    if-eqz p1, :cond_1

    const-string v0, "Received CAN"

    .line 319
    invoke-interface {p1, v0}, Lcom/pri/prizeinterphone/ymodem/YModemListener;->onFailed(Ljava/lang/String;)V

    .line 321
    :cond_1
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModem;->stop()V

    :cond_2
    :goto_0
    return-void
.end method

.method private handlePackageFail(Ljava/lang/String;)V
    .locals 2

    .line 329
    iget v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->packageErrorTimes:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->packageErrorTimes:I

    .line 330
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Fail:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " for "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->packageErrorTimes:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " times"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 331
    iget v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->packageErrorTimes:I

    const/4 v1, 0x6

    if-ge v0, v1, :cond_0

    .line 332
    iget-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->currSending:[B

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->sendPackageData([B)V

    goto :goto_0

    .line 335
    :cond_0
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModem;->stop()V

    .line 336
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

    if-eqz p0, :cond_1

    .line 337
    invoke-interface {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModemListener;->onFailed(Ljava/lang/String;)V

    :cond_1
    :goto_0
    return-void
.end method

.method private sendData()V
    .locals 3

    .line 155
    new-instance v0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;

    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->mContext:Landroid/content/Context;

    iget-object v2, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->filePath:Ljava/lang/String;

    invoke-direct {v0, v1, v2, p0}, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;-><init>(Landroid/content/Context;Ljava/lang/String;Lcom/pri/prizeinterphone/ymodem/FileStreamThread$DataRaderListener;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->streamThread:Lcom/pri/prizeinterphone/ymodem/FileStreamThread;

    const/4 v0, 0x2

    .line 156
    sput v0, Lcom/pri/prizeinterphone/ymodem/YModem;->CURR_STEP:I

    const-string v0, "StartData!!!"

    .line 157
    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 158
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->getYModelData()[B

    move-result-object v0

    .line 159
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/ymodem/YModem;->sendPackageData([B)V

    return-void
.end method

.method private sendEND()V
    .locals 2

    const/16 v0, 0x20

    .line 196
    sput v0, Lcom/pri/prizeinterphone/ymodem/YModem;->CURR_STEP:I

    const-string v0, "sendEND"

    .line 197
    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 198
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

    if-eqz p0, :cond_0

    .line 200
    :try_start_0
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->getEnd()[B

    move-result-object v0

    sget v1, Lcom/pri/prizeinterphone/ymodem/YModem;->CURR_STEP:I

    invoke-interface {p0, v0, v1}, Lcom/pri/prizeinterphone/ymodem/YModemListener;->onDataReady([BI)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 202
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    :cond_0
    :goto_0
    return-void
.end method

.method private sendEOT()V
    .locals 2

    const/16 v0, 0x10

    .line 188
    sput v0, Lcom/pri/prizeinterphone/ymodem/YModem;->CURR_STEP:I

    const-string v0, "sendEOT"

    .line 189
    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 190
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

    if-eqz p0, :cond_0

    .line 191
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->getEOT()[B

    move-result-object v0

    sget v1, Lcom/pri/prizeinterphone/ymodem/YModem;->CURR_STEP:I

    invoke-interface {p0, v0, v1}, Lcom/pri/prizeinterphone/ymodem/YModemListener;->onDataReady([BI)V

    :cond_0
    return-void
.end method

.method private sendFileName()V
    .locals 3

    const/4 v0, 0x4

    .line 163
    sput v0, Lcom/pri/prizeinterphone/ymodem/YModem;->CURR_STEP:I

    const-string v0, "sendFileName"

    .line 164
    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 166
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->streamThread:Lcom/pri/prizeinterphone/ymodem/FileStreamThread;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->getFileByteSize()I

    move-result v0

    .line 167
    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->fileNameString:Ljava/lang/String;

    iget-object v2, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->fileMd5String:Ljava/lang/String;

    invoke-static {v1, v0, v2}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->getFileNamePackage(Ljava/lang/String;ILjava/lang/String;)[B

    move-result-object v0

    .line 169
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/ymodem/YModem;->sendPackageData([B)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 171
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    :goto_0
    return-void
.end method

.method private sendPackageData([B)V
    .locals 4

    .line 208
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

    if-eqz v0, :cond_0

    if-eqz p1, :cond_0

    .line 209
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->currSending:[B

    .line 214
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->timerHelper:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;

    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->timeoutListener:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;

    const-wide/16 v2, 0x3a98

    invoke-virtual {v0, v1, v2, v3}, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->startTimer(Lcom/pri/prizeinterphone/ymodem/TimeOutHelper$ITimeOut;J)V

    .line 215
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

    sget v0, Lcom/pri/prizeinterphone/ymodem/YModem;->CURR_STEP:I

    invoke-interface {p0, p1, v0}, Lcom/pri/prizeinterphone/ymodem/YModemListener;->onDataReady([BI)V

    :cond_0
    return-void
.end method

.method private startSendFileData()V
    .locals 1

    const/16 v0, 0x8

    .line 176
    sput v0, Lcom/pri/prizeinterphone/ymodem/YModem;->CURR_STEP:I

    const-string/jumbo v0, "startSendFileData"

    .line 177
    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 178
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->streamThread:Lcom/pri/prizeinterphone/ymodem/FileStreamThread;

    invoke-virtual {p0}, Ljava/lang/Thread;->start()V

    return-void
.end method


# virtual methods
.method public onDataReady([B)V
    .locals 0

    .line 184
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->sendPackageData([B)V

    return-void
.end method

.method public onFinish()V
    .locals 0

    .line 345
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/YModem;->sendEOT()V

    return-void
.end method

.method public onReceiveData([B)V
    .locals 2

    .line 122
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->timerHelper:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->stopTimer()V

    if-eqz p1, :cond_5

    .line 123
    array-length v0, p1

    if-lez v0, :cond_5

    array-length v0, p1

    const/4 v1, 0x3

    if-ge v0, v1, :cond_5

    .line 124
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "YModem received "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v1, p1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " bytes."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 125
    sget v0, Lcom/pri/prizeinterphone/ymodem/YModem;->CURR_STEP:I

    const/4 v1, 0x2

    if-eq v0, v1, :cond_4

    const/4 v1, 0x4

    if-eq v0, v1, :cond_3

    const/16 v1, 0x8

    if-eq v0, v1, :cond_2

    const/16 v1, 0x10

    if-eq v0, v1, :cond_1

    const/16 v1, 0x20

    if-eq v0, v1, :cond_0

    goto :goto_0

    .line 139
    :cond_0
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handleEnd([B)V

    goto :goto_0

    .line 136
    :cond_1
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handleEOT([B)V

    goto :goto_0

    .line 133
    :cond_2
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handleFileBody([B)V

    goto :goto_0

    .line 130
    :cond_3
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handleFileName([B)V

    goto :goto_0

    .line 127
    :cond_4
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModem;->handleData([B)V

    goto :goto_0

    :cond_5
    const-string p0, "The terminal do responsed something, but received nothing??"

    .line 145
    invoke-static {p0}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public start()V
    .locals 0

    .line 98
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/YModem;->sendData()V

    return-void
.end method

.method public stop()V
    .locals 2

    const/4 v0, 0x0

    .line 106
    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->bytesSent:I

    const/4 v1, 0x0

    .line 107
    iput-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->currSending:[B

    .line 108
    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->packageErrorTimes:I

    .line 109
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->streamThread:Lcom/pri/prizeinterphone/ymodem/FileStreamThread;

    if-eqz v0, :cond_0

    .line 110
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->release()V

    .line 112
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->timerHelper:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->stopTimer()V

    .line 113
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModem;->timerHelper:Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/TimeOutHelper;->unRegisterListener()V

    return-void
.end method
