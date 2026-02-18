.class public Lcom/pri/prizeinterphone/Util/Util;
.super Ljava/lang/Object;
.source "Util.java"


# static fields
.field public static final DMR_UPDATE_STATUS_ERROR:Ljava/lang/String; = "3"

.field public static final DMR_UPDATE_STATUS_IDLE:Ljava/lang/String; = "1"

.field public static final DMR_UPDATE_STATUS_UPDATING:Ljava/lang/String; = "2"

.field public static final FRAGMENT_TALKBACK_NUM_RES:[I

.field private static final NARAM_INDEX_FOR_DMR_UPDATE_STATUS:I = 0x144

.field private static final NARAM_INDEX_LENGTH_FOR_DMR_UPDATE_STATUS:I = 0x1

.field private static final TAG:Ljava/lang/String; = "InterphoneUtil"

.field public static final TAP_VIEW_CHANNEL:I = 0x1

.field public static final TAP_VIEW_CONTACTS:I = 0x2

.field public static final TAP_VIEW_LOCAL:I = 0x4

.field public static final TAP_VIEW_MESSAGE:I = 0x3

.field public static final TAP_VIEW_TALKBACK:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/16 v0, 0xa

    new-array v0, v0, [I

    .line 19
    fill-array-data v0, :array_0

    sput-object v0, Lcom/pri/prizeinterphone/Util/Util;->FRAGMENT_TALKBACK_NUM_RES:[I

    return-void

    :array_0
    .array-data 4
        0x7f0800c6
        0x7f0800c7
        0x7f0800c8
        0x7f0800c9
        0x7f0800ca
        0x7f0800cb
        0x7f0800cc
        0x7f0800cd
        0x7f0800ce
        0x7f0800cf
    .end array-data
.end method

.method public constructor <init>()V
    .locals 0

    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static bytesToHex([B)Ljava/lang/String;
    .locals 6

    .line 33
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 34
    array-length v1, p0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_0

    aget-byte v4, p0, v3

    const/4 v5, 0x1

    new-array v5, v5, [Ljava/lang/Object;

    .line 35
    invoke-static {v4}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v4

    aput-object v4, v5, v2

    const-string v4, "%02X"

    invoke-static {v4, v5}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 37
    :cond_0
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static convertNvChars(Ljava/lang/String;)Ljava/lang/String;
    .locals 4

    .line 81
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p0, " "

    return-object p0

    .line 85
    :cond_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_4

    .line 87
    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v2

    const/16 v3, 0x8

    if-le v2, v3, :cond_2

    const/16 v3, 0xb

    if-lt v2, v3, :cond_1

    const/16 v3, 0xc

    if-le v2, v3, :cond_2

    :cond_1
    const/16 v3, 0xe

    if-lt v2, v3, :cond_3

    const/16 v3, 0x1f

    if-gt v2, v3, :cond_3

    :cond_2
    const/16 v3, 0x20

    .line 90
    invoke-virtual {p0, v2, v3}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p0

    :cond_3
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_4
    return-object p0
.end method

.method public static dMRUpdateStatus2Str(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 109
    invoke-virtual {p0}, Ljava/lang/String;->hashCode()I

    const-string v0, "1"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "2"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_0

    const-string p0, "DMR_UPDATE_STATUS_UNKNOWN"

    return-object p0

    :cond_0
    const-string p0, "DMR_UPDATE_STATUS_UPDATING"

    return-object p0

    :cond_1
    const-string p0, "DMR_UPDATE_STATUS_IDLE"

    return-object p0
.end method

.method public static getDMRUpdateStatusFromNvram()Ljava/lang/String;
    .locals 5

    const-string v0, "InterphoneUtil"

    const-string v1, "1"

    const/16 v2, 0x144

    const/4 v3, 0x1

    .line 50
    :try_start_0
    invoke-static {v2, v3}, Lcom/mediatek/common/prizeoption/NvramUtils;->readUserNvramInfo(II)Ljava/lang/String;

    move-result-object v2

    .line 51
    invoke-static {v2}, Lcom/pri/prizeinterphone/Util/Util;->convertNvChars(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 52
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    sub-int/2addr v4, v3

    invoke-virtual {v2, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    .line 53
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "getDMRUpdateStatusFromNvram,status="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "("

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v2}, Lcom/pri/prizeinterphone/Util/Util;->dMRUpdateStatus2Str(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ")"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 54
    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_0

    return-object v1

    .line 57
    :cond_0
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_1

    const-string v3, "2"

    .line 58
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_1

    const-string v3, "3"

    .line 59
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    if-nez v0, :cond_1

    return-object v1

    :cond_1
    return-object v2

    :catch_0
    move-exception v2

    const-string v3, "getDMRUpdateStatusFromNvram,error"

    .line 65
    invoke-static {v0, v3, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v1
.end method

.method public static isDmrUpdateError()Z
    .locals 2

    .line 101
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->getDMRUpdateStatusFromNvram()Ljava/lang/String;

    move-result-object v0

    const-string v1, "3"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    return v0
.end method

.method public static isDmrUpdateIdle()Z
    .locals 2

    .line 97
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->getDMRUpdateStatusFromNvram()Ljava/lang/String;

    move-result-object v0

    const-string v1, "1"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    return v0
.end method

.method public static isDmrUpdating()Z
    .locals 2

    .line 105
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->getDMRUpdateStatusFromNvram()Ljava/lang/String;

    move-result-object v0

    const-string v1, "2"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    return v0
.end method

.method public static isMonkeyRunning()Z
    .locals 1

    .line 120
    invoke-static {}, Landroid/app/ActivityManager;->isUserAMonkey()Z

    move-result v0

    return v0
.end method

.method public static setDMRUpdateStatusToNvram(Ljava/lang/String;)Z
    .locals 2

    .line 71
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x1

    if-eq v0, v1, :cond_0

    const-string p0, "InterphoneUtil"

    const-string v0, "setDMRUpdateStatusToNvram,status.length() must be 1"

    .line 72
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return p0

    :cond_0
    const/16 v0, 0x144

    .line 75
    invoke-static {v0, v1, p0}, Lcom/mediatek/common/prizeoption/NvramUtils;->writeUserNvramInfo(IILjava/lang/String;)Z

    move-result p0

    .line 76
    invoke-static {}, Lcom/pri/prizeinterphone/Util/Util;->getDMRUpdateStatusFromNvram()Ljava/lang/String;

    return p0
.end method
