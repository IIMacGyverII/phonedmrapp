.class final Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;
.super Ljava/lang/Object;
.source "SignalStrengthController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/SignalStrengthController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "AccessNetworkThresholds"
.end annotation


# static fields
.field public static final CDMA2000:[I

.field public static final EUTRAN_RSRP:[I

.field public static final EUTRAN_RSRQ:[I

.field public static final EUTRAN_RSSNR:[I

.field public static final GERAN:[I

.field public static final NGRAN_SSRSRP:[I

.field public static final NGRAN_SSRSRQ:[I

.field public static final NGRAN_SSSINR:[I

.field public static final UTRAN:[I


# direct methods
.method static constructor <clinit>()V
    .locals 2

    const/4 v0, 0x4

    new-array v1, v0, [I

    .line 1012
    fill-array-data v1, :array_0

    sput-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->GERAN:[I

    new-array v1, v0, [I

    .line 1026
    fill-array-data v1, :array_1

    sput-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->UTRAN:[I

    new-array v1, v0, [I

    .line 1039
    fill-array-data v1, :array_2

    sput-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->EUTRAN_RSRP:[I

    new-array v1, v0, [I

    .line 1052
    fill-array-data v1, :array_3

    sput-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->EUTRAN_RSRQ:[I

    new-array v1, v0, [I

    .line 1065
    fill-array-data v1, :array_4

    sput-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->EUTRAN_RSSNR:[I

    new-array v1, v0, [I

    .line 1077
    fill-array-data v1, :array_5

    sput-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->CDMA2000:[I

    new-array v1, v0, [I

    .line 1087
    fill-array-data v1, :array_6

    sput-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->NGRAN_SSRSRP:[I

    new-array v1, v0, [I

    .line 1097
    fill-array-data v1, :array_7

    sput-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->NGRAN_SSRSRQ:[I

    new-array v0, v0, [I

    .line 1107
    fill-array-data v0, :array_8

    sput-object v0, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->NGRAN_SSSINR:[I

    return-void

    nop

    :array_0
    .array-data 4
        -0x6d
        -0x67
        -0x61
        -0x59
    .end array-data

    :array_1
    .array-data 4
        -0x72
        -0x68
        -0x5e
        -0x54
    .end array-data

    :array_2
    .array-data 4
        -0x80
        -0x76
        -0x6c
        -0x62
    .end array-data

    :array_3
    .array-data 4
        -0x14
        -0x11
        -0xe
        -0xb
    .end array-data

    :array_4
    .array-data 4
        -0x3
        0x1
        0x5
        0xd
    .end array-data

    :array_5
    .array-data 4
        -0x69
        -0x5a
        -0x4b
        -0x41
    .end array-data

    :array_6
    .array-data 4
        -0x6e
        -0x5a
        -0x50
        -0x41
    .end array-data

    :array_7
    .array-data 4
        -0x1f
        -0x13
        -0x7
        0x6
    .end array-data

    :array_8
    .array-data 4
        -0x5
        0x5
        0xf
        0x1e
    .end array-data
.end method

.method private constructor <init>()V
    .locals 0

    .line 1005
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
