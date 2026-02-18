.class public Lcom/android/internal/telephony/d2d/RtpTransport;
.super Ljava/lang/Object;
.source "RtpTransport.java"

# interfaces
.implements Lcom/android/internal/telephony/d2d/TransportProtocol;
.implements Lcom/android/internal/telephony/d2d/RtpAdapter$Callback;


# static fields
.field private static final BATTERY_STATE_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lcom/android/internal/telephony/BiMap<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Byte;",
            ">;"
        }
    .end annotation
.end field

.field public static CALL_STATE_LOCAL_IDENTIFIER:I = 0x0

.field private static final CALL_STATE_MSG_TYPE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lcom/android/internal/telephony/BiMap<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Byte;",
            ">;"
        }
    .end annotation
.end field

.field public static CALL_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri; = null

.field public static CALL_STATE_RTP_HEADER_EXTENSION_TYPE:Landroid/telephony/ims/RtpHeaderExtensionType; = null

.field private static final CODEC_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lcom/android/internal/telephony/BiMap<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Byte;",
            ">;"
        }
    .end annotation
.end field

.field public static DEVICE_STATE_LOCAL_IDENTIFIER:I = 0x0

.field private static final DEVICE_STATE_MSG_TYPE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lcom/android/internal/telephony/BiMap<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Byte;",
            ">;"
        }
    .end annotation
.end field

.field public static DEVICE_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri; = null

.field public static DEVICE_STATE_RTP_HEADER_EXTENSION_TYPE:Landroid/telephony/ims/RtpHeaderExtensionType; = null

.field private static final NETWORK_COVERAGE_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lcom/android/internal/telephony/BiMap<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Byte;",
            ">;"
        }
    .end annotation
.end field

.field public static final PROTOCOL_STATUS_NEGOTIATION_COMPLETE:I = 0x3

.field public static final PROTOCOL_STATUS_NEGOTIATION_FAILED:I = 0x4

.field public static final PROTOCOL_STATUS_NEGOTIATION_REQUIRED:I = 0x1

.field public static final PROTOCOL_STATUS_NEGOTIATION_WAITING_ON_PACKET:I = 0x2

.field private static final RAT_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lcom/android/internal/telephony/BiMap<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Byte;",
            ">;"
        }
    .end annotation
.end field

.field public static final RTP_BATTERY_STATE_CHARGING_BITS:B = 0x30t

.field public static final RTP_BATTERY_STATE_GOOD_BITS:B = 0x10t

.field public static final RTP_BATTERY_STATE_LOW_BITS:B = 0x0t

.field public static final RTP_CALL_STATE_MSG_CODEC_BITS:B = 0x2t

.field public static final RTP_CALL_STATE_MSG_RADIO_ACCESS_TYPE_BITS:B = 0x1t

.field public static final RTP_CODEC_VALUE_AMR_NB_BITS:B = 0x30t

.field public static final RTP_CODEC_VALUE_AMR_WB_BITS:B = 0x20t

.field public static final RTP_CODEC_VALUE_EVS_BITS:B = 0x10t

.field public static final RTP_DEVICE_STATE_MSG_BATTERY_BITS:B = 0x1t

.field public static final RTP_DEVICE_STATE_MSG_NETWORK_COVERAGE_BITS:B = 0x2t

.field public static final RTP_NETWORK_COVERAGE_GOOD_BITS:B = 0x10t

.field public static final RTP_NETWORK_COVERAGE_POOR_BITS:B = 0x0t

.field public static final RTP_PARAMETER_BIT_OFFSET:I = 0x4

.field public static final RTP_RAT_VALUE_LTE_BITS:B = 0x10t

.field public static final RTP_RAT_VALUE_NR_BITS:B = 0x30t

.field public static final RTP_RAT_VALUE_WLAN_BITS:B = 0x20t


# instance fields
.field private mCallback:Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;

.field private final mHandler:Landroid/os/Handler;

.field private final mIsSdpNegotiationSupported:Z

.field private mProtocolStatus:I

.field private final mRtpAdapter:Lcom/android/internal/telephony/d2d/RtpAdapter;

.field private mSupportedRtpHeaderExtensionTypes:Landroid/util/ArraySet;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/ArraySet<",
            "Landroid/telephony/ims/RtpHeaderExtensionType;",
            ">;"
        }
    .end annotation
.end field

.field private final mTimeoutsAdapter:Lcom/android/internal/telephony/d2d/Timeouts$Adapter;


# direct methods
.method public static synthetic $r8$lambda$8aLmhMRjdMbYgfpwExeranILgTM(Landroid/telephony/ims/RtpHeaderExtensionType;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/d2d/RtpTransport;->lambda$startNegotiation$1(Landroid/telephony/ims/RtpHeaderExtensionType;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$E2Ic4KeotZ0Aq8eKmb0jPPkoFjA(Landroid/telephony/ims/RtpHeaderExtensionType;)Landroid/net/Uri;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/d2d/RtpTransport;->lambda$extractMessage$6(Landroid/telephony/ims/RtpHeaderExtensionType;)Landroid/net/Uri;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$dBh1TCvaN0PHHHUR7FlRiRqQQ_k(Landroid/telephony/ims/RtpHeaderExtension;Landroid/telephony/ims/RtpHeaderExtensionType;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/d2d/RtpTransport;->lambda$extractMessage$5(Landroid/telephony/ims/RtpHeaderExtension;Landroid/telephony/ims/RtpHeaderExtensionType;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$n_SkcZtXs0RZVAhgOnMs0mcATC8(Landroid/telephony/ims/RtpHeaderExtensionType;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/d2d/RtpTransport;->lambda$startNegotiation$0(Landroid/telephony/ims/RtpHeaderExtensionType;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$qq-ZNu_Bmu1UtX9Upvh3dQtiDTk(Lcom/android/internal/telephony/d2d/RtpTransport;Landroid/telephony/ims/RtpHeaderExtension;)Lcom/android/internal/telephony/d2d/Communicator$Message;
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/d2d/RtpTransport;->lambda$onRtpHeaderExtensionsReceived$4(Landroid/telephony/ims/RtpHeaderExtension;)Lcom/android/internal/telephony/d2d/Communicator$Message;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$sIx1mfrlrjwYbaeqsMLGz9gQNr4(Lcom/android/internal/telephony/d2d/RtpTransport;Lcom/android/internal/telephony/d2d/Communicator$Message;)Landroid/telephony/ims/RtpHeaderExtension;
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/d2d/RtpTransport;->lambda$sendMessages$3(Lcom/android/internal/telephony/d2d/Communicator$Message;)Landroid/telephony/ims/RtpHeaderExtension;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$vyaSEPjeVfgBI2MVx-OoZjI-uds(Landroid/telephony/ims/RtpHeaderExtensionType;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/d2d/RtpTransport;->lambda$startNegotiation$2(Landroid/telephony/ims/RtpHeaderExtensionType;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$zfJLoQnbhWML1hmuqjhnsIFdSUM(Landroid/net/Uri;Landroid/telephony/ims/RtpHeaderExtensionType;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/d2d/RtpTransport;->lambda$getRtpHeaderExtensionIdentifier$7(Landroid/net/Uri;Landroid/telephony/ims/RtpHeaderExtensionType;)Z

    move-result p0

    return p0
.end method

.method static constructor <clinit>()V
    .locals 7

    const-string v0, "http://develop.android.com/122020/d2dcomm#device-state"

    .line 65
    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri;

    const-string v0, "http://develop.android.com/122020/d2dcomm#call-state"

    .line 72
    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri;

    const/16 v0, 0xa

    .line 77
    sput v0, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_LOCAL_IDENTIFIER:I

    const/16 v0, 0xb

    .line 82
    sput v0, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_LOCAL_IDENTIFIER:I

    .line 87
    new-instance v0, Landroid/telephony/ims/RtpHeaderExtensionType;

    sget v1, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_LOCAL_IDENTIFIER:I

    sget-object v2, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri;

    invoke-direct {v0, v1, v2}, Landroid/telephony/ims/RtpHeaderExtensionType;-><init>(ILandroid/net/Uri;)V

    sput-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_RTP_HEADER_EXTENSION_TYPE:Landroid/telephony/ims/RtpHeaderExtensionType;

    .line 94
    new-instance v0, Landroid/telephony/ims/RtpHeaderExtensionType;

    sget v1, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_LOCAL_IDENTIFIER:I

    sget-object v2, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri;

    invoke-direct {v0, v1, v2}, Landroid/telephony/ims/RtpHeaderExtensionType;-><init>(ILandroid/net/Uri;)V

    sput-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_RTP_HEADER_EXTENSION_TYPE:Landroid/telephony/ims/RtpHeaderExtensionType;

    .line 131
    new-instance v0, Lcom/android/internal/telephony/BiMap;

    invoke-direct {v0}, Lcom/android/internal/telephony/BiMap;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_MSG_TYPE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    .line 132
    new-instance v1, Lcom/android/internal/telephony/BiMap;

    invoke-direct {v1}, Lcom/android/internal/telephony/BiMap;-><init>()V

    sput-object v1, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_MSG_TYPE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    const/4 v2, 0x1

    .line 136
    invoke-static {v2}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v3

    .line 135
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    .line 134
    invoke-virtual {v0, v2, v3}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    const/4 v4, 0x2

    .line 139
    invoke-static {v4}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v5

    .line 138
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    .line 137
    invoke-virtual {v0, v4, v5}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    const/4 v0, 0x3

    .line 141
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    .line 140
    invoke-virtual {v1, v0, v3}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    const/4 v3, 0x4

    .line 144
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    .line 143
    invoke-virtual {v1, v3, v5}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 170
    new-instance v1, Lcom/android/internal/telephony/BiMap;

    invoke-direct {v1}, Lcom/android/internal/telephony/BiMap;-><init>()V

    sput-object v1, Lcom/android/internal/telephony/d2d/RtpTransport;->RAT_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    const/16 v3, 0x20

    .line 173
    invoke-static {v3}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v3

    .line 172
    invoke-virtual {v1, v4, v3}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    const/16 v5, 0x10

    .line 175
    invoke-static {v5}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v5

    .line 174
    invoke-virtual {v1, v2, v5}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    const/16 v6, 0x30

    .line 177
    invoke-static {v6}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v6

    .line 176
    invoke-virtual {v1, v0, v6}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 192
    new-instance v1, Lcom/android/internal/telephony/BiMap;

    invoke-direct {v1}, Lcom/android/internal/telephony/BiMap;-><init>()V

    sput-object v1, Lcom/android/internal/telephony/d2d/RtpTransport;->CODEC_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    .line 194
    invoke-virtual {v1, v2, v5}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 196
    invoke-virtual {v1, v4, v3}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 198
    invoke-virtual {v1, v0, v6}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 210
    new-instance v1, Lcom/android/internal/telephony/BiMap;

    invoke-direct {v1}, Lcom/android/internal/telephony/BiMap;-><init>()V

    sput-object v1, Lcom/android/internal/telephony/d2d/RtpTransport;->BATTERY_STATE_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    const/4 v3, 0x0

    .line 213
    invoke-static {v3}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v3

    .line 212
    invoke-virtual {v1, v2, v3}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 214
    invoke-virtual {v1, v4, v5}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 216
    invoke-virtual {v1, v0, v6}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 227
    new-instance v0, Lcom/android/internal/telephony/BiMap;

    invoke-direct {v0}, Lcom/android/internal/telephony/BiMap;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->NETWORK_COVERAGE_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    .line 229
    invoke-virtual {v0, v2, v3}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 231
    invoke-virtual {v0, v4, v5}, Lcom/android/internal/telephony/BiMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Z

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/d2d/RtpAdapter;Lcom/android/internal/telephony/d2d/Timeouts$Adapter;Landroid/os/Handler;Z)V
    .locals 1

    .line 313
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    .line 298
    iput v0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mProtocolStatus:I

    .line 303
    new-instance v0, Landroid/util/ArraySet;

    invoke-direct {v0}, Landroid/util/ArraySet;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mSupportedRtpHeaderExtensionTypes:Landroid/util/ArraySet;

    .line 314
    iput-object p1, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mRtpAdapter:Lcom/android/internal/telephony/d2d/RtpAdapter;

    .line 315
    iput-object p2, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mTimeoutsAdapter:Lcom/android/internal/telephony/d2d/Timeouts$Adapter;

    .line 316
    iput-object p3, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mHandler:Landroid/os/Handler;

    .line 317
    iput-boolean p4, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mIsSdpNegotiationSupported:Z

    return-void
.end method

.method private extractMessage(Landroid/telephony/ims/RtpHeaderExtension;)Lcom/android/internal/telephony/d2d/Communicator$Message;
    .locals 11

    .line 439
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mSupportedRtpHeaderExtensionTypes:Landroid/util/ArraySet;

    invoke-virtual {v0}, Landroid/util/ArraySet;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda7;

    invoke-direct {v1, p1}, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda7;-><init>(Landroid/telephony/ims/RtpHeaderExtension;)V

    .line 440
    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda8;

    invoke-direct {v1}, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda8;-><init>()V

    .line 441
    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v0

    .line 442
    invoke-interface {v0}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object v0

    .line 443
    invoke-virtual {v0}, Ljava/util/Optional;->isPresent()Z

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x0

    const/4 v4, 0x1

    if-nez v1, :cond_0

    new-array v0, v4, [Ljava/lang/Object;

    .line 445
    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtension;->getLocalIdentifier()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v0, v3

    const-string p1, "extractMessage: localIdentifier=%d not supported."

    .line 444
    invoke-static {p0, p1, v0}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v2

    .line 449
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtension;->getExtensionData()[B

    move-result-object v1

    if-eqz v1, :cond_e

    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtension;->getExtensionData()[B

    move-result-object v1

    array-length v1, v1

    if-eq v1, v4, :cond_1

    goto/16 :goto_1

    .line 455
    :cond_1
    invoke-virtual {v0}, Ljava/util/Optional;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/net/Uri;

    .line 458
    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtension;->getExtensionData()[B

    move-result-object v1

    aget-byte v1, v1, v3

    and-int/lit8 v1, v1, 0xf

    int-to-byte v1, v1

    .line 459
    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtension;->getExtensionData()[B

    move-result-object v5

    aget-byte v5, v5, v3

    and-int/lit16 v5, v5, 0xf0

    int-to-byte v5, v5

    .line 464
    sget-object v6, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri;

    invoke-virtual {v6, v0}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v6

    const-string v7, "messageType=%s, value=%s; invalid value"

    const/4 v8, 0x4

    const/4 v9, 0x3

    const/4 v10, 0x2

    if-eqz v6, :cond_7

    .line 465
    sget-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_MSG_TYPE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v6

    invoke-virtual {v0, v6}, Lcom/android/internal/telephony/BiMap;->getKey(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    if-nez v0, :cond_2

    new-array v0, v10, [Ljava/lang/Object;

    .line 468
    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtension;->getLocalIdentifier()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v0, v3

    invoke-static {v1}, Ljava/lang/Integer;->toBinaryString(I)Ljava/lang/String;

    move-result-object p1

    aput-object p1, v0, v4

    const-string p1, "extractMessage: localIdentifier=%d message with invalid type %s."

    .line 467
    invoke-static {p0, p1, v0}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v2

    .line 471
    :cond_2
    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    if-eq v0, v9, :cond_5

    if-eq v0, v8, :cond_3

    new-array p1, v10, [Ljava/lang/Object;

    .line 497
    invoke-static {v1}, Ljava/lang/Integer;->toBinaryString(I)Ljava/lang/String;

    move-result-object v0

    aput-object v0, p1, v3

    .line 498
    invoke-static {v5}, Ljava/lang/Integer;->toBinaryString(I)Ljava/lang/String;

    move-result-object v0

    aput-object v0, p1, v4

    .line 496
    invoke-static {p0, v7, p1}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v2

    .line 485
    :cond_3
    sget-object v6, Lcom/android/internal/telephony/d2d/RtpTransport;->NETWORK_COVERAGE_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-static {v5}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v7

    invoke-virtual {v6, v7}, Lcom/android/internal/telephony/BiMap;->getKey(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/Integer;

    if-nez v6, :cond_4

    new-array v0, v10, [Ljava/lang/Object;

    .line 489
    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtension;->getLocalIdentifier()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v0, v3

    .line 490
    invoke-static {v5}, Ljava/lang/Integer;->toBinaryString(I)Ljava/lang/String;

    move-result-object p1

    aput-object p1, v0, v4

    const-string p1, "extractMessage: localIdentifier=%d, network coverage msg with invalid value=%s"

    .line 487
    invoke-static {p0, p1, v0}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v2

    .line 493
    :cond_4
    invoke-virtual {v6}, Ljava/lang/Integer;->intValue()I

    move-result p1

    goto/16 :goto_0

    .line 474
    :cond_5
    sget-object v6, Lcom/android/internal/telephony/d2d/RtpTransport;->BATTERY_STATE_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-static {v5}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v7

    invoke-virtual {v6, v7}, Lcom/android/internal/telephony/BiMap;->getKey(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/Integer;

    if-nez v6, :cond_6

    new-array v0, v10, [Ljava/lang/Object;

    .line 478
    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtension;->getLocalIdentifier()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v0, v3

    .line 479
    invoke-static {v5}, Ljava/lang/Integer;->toBinaryString(I)Ljava/lang/String;

    move-result-object p1

    aput-object p1, v0, v4

    const-string p1, "extractMessage: localIdentifier=%d, battery state msg with invalid value=%s"

    .line 476
    invoke-static {p0, p1, v0}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v2

    .line 482
    :cond_6
    invoke-virtual {v6}, Ljava/lang/Integer;->intValue()I

    move-result p1

    goto/16 :goto_0

    .line 501
    :cond_7
    sget-object v6, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri;

    invoke-virtual {v6, v0}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_d

    .line 502
    sget-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_MSG_TYPE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v6

    invoke-virtual {v0, v6}, Lcom/android/internal/telephony/BiMap;->getKey(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    if-nez v0, :cond_8

    new-array v0, v10, [Ljava/lang/Object;

    .line 506
    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtension;->getLocalIdentifier()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v0, v3

    .line 507
    invoke-static {v1}, Ljava/lang/Integer;->toBinaryString(I)Ljava/lang/String;

    move-result-object p1

    aput-object p1, v0, v4

    const-string p1, "extractMessage: localIdentifier=%d, network coverage msg with invalid type=%s"

    .line 504
    invoke-static {p0, p1, v0}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v2

    .line 510
    :cond_8
    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    if-eq v0, v4, :cond_b

    if-eq v0, v10, :cond_9

    new-array p1, v10, [Ljava/lang/Object;

    .line 536
    invoke-static {v1}, Ljava/lang/Integer;->toBinaryString(I)Ljava/lang/String;

    move-result-object v0

    aput-object v0, p1, v3

    .line 537
    invoke-static {v5}, Ljava/lang/Integer;->toBinaryString(I)Ljava/lang/String;

    move-result-object v0

    aput-object v0, p1, v4

    .line 535
    invoke-static {p0, v7, p1}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v2

    .line 513
    :cond_9
    sget-object v6, Lcom/android/internal/telephony/d2d/RtpTransport;->CODEC_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-static {v5}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v7

    invoke-virtual {v6, v7}, Lcom/android/internal/telephony/BiMap;->getKey(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/Integer;

    if-nez v6, :cond_a

    new-array v0, v10, [Ljava/lang/Object;

    .line 517
    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtension;->getLocalIdentifier()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v0, v3

    .line 518
    invoke-static {v5}, Ljava/lang/Integer;->toBinaryString(I)Ljava/lang/String;

    move-result-object p1

    aput-object p1, v0, v4

    const-string p1, "extractMessage: localIdentifier=%d, audio codec msg with invalid value=%s"

    .line 515
    invoke-static {p0, p1, v0}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v2

    .line 521
    :cond_a
    invoke-virtual {v6}, Ljava/lang/Integer;->intValue()I

    move-result p1

    goto :goto_0

    .line 524
    :cond_b
    sget-object v6, Lcom/android/internal/telephony/d2d/RtpTransport;->RAT_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-static {v5}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v7

    invoke-virtual {v6, v7}, Lcom/android/internal/telephony/BiMap;->getKey(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/Integer;

    if-nez v6, :cond_c

    new-array v0, v10, [Ljava/lang/Object;

    .line 528
    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtension;->getLocalIdentifier()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v0, v3

    .line 529
    invoke-static {v5}, Ljava/lang/Integer;->toBinaryString(I)Ljava/lang/String;

    move-result-object p1

    aput-object p1, v0, v4

    const-string p1, "extractMessage: localIdentifier=%d, rat type msg with invalid value=%s"

    .line 526
    invoke-static {p0, p1, v0}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v2

    .line 532
    :cond_c
    invoke-virtual {v6}, Ljava/lang/Integer;->intValue()I

    move-result p1

    :goto_0
    new-array v2, v8, [Ljava/lang/Object;

    .line 545
    invoke-static {v1}, Ljava/lang/Integer;->toBinaryString(I)Ljava/lang/String;

    move-result-object v1

    aput-object v1, v2, v3

    invoke-static {v5}, Ljava/lang/Integer;->toBinaryString(I)Ljava/lang/String;

    move-result-object v1

    aput-object v1, v2, v4

    .line 546
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v2, v10

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v2, v9

    const-string v1, "extractMessage: messageType=%s, value=%s --> message=%d, value=%d"

    .line 544
    invoke-static {p0, v1, v2}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 547
    new-instance p0, Lcom/android/internal/telephony/d2d/Communicator$Message;

    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/d2d/Communicator$Message;-><init>(II)V

    return-object p0

    :cond_d
    new-array p1, v4, [Ljava/lang/Object;

    aput-object v0, p1, v3

    const-string v0, "invalid uri=%s"

    .line 541
    invoke-static {p0, v0, p1}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v2

    :cond_e
    :goto_1
    new-array v0, v4, [Ljava/lang/Object;

    .line 451
    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtension;->getLocalIdentifier()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v0, v3

    const-string p1, "extractMessage: localIdentifier=%d message with invalid data length."

    .line 450
    invoke-static {p0, p1, v0}, Landroid/telecom/Log;->w(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v2
.end method

.method private getRtpHeaderExtensionIdentifier(Landroid/net/Uri;)I
    .locals 1

    .line 622
    iget-object p0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mSupportedRtpHeaderExtensionTypes:Landroid/util/ArraySet;

    invoke-virtual {p0}, Landroid/util/ArraySet;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda2;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda2;-><init>(Landroid/net/Uri;)V

    .line 623
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 624
    invoke-interface {p0}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/Optional;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/ims/RtpHeaderExtensionType;

    invoke-virtual {p0}, Landroid/telephony/ims/RtpHeaderExtensionType;->getLocalIdentifier()I

    move-result p0

    return p0
.end method

.method private static synthetic lambda$extractMessage$5(Landroid/telephony/ims/RtpHeaderExtension;Landroid/telephony/ims/RtpHeaderExtensionType;)Z
    .locals 0

    .line 440
    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtensionType;->getLocalIdentifier()I

    move-result p1

    invoke-virtual {p0}, Landroid/telephony/ims/RtpHeaderExtension;->getLocalIdentifier()I

    move-result p0

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$extractMessage$6(Landroid/telephony/ims/RtpHeaderExtensionType;)Landroid/net/Uri;
    .locals 0

    .line 441
    invoke-virtual {p0}, Landroid/telephony/ims/RtpHeaderExtensionType;->getUri()Landroid/net/Uri;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getRtpHeaderExtensionIdentifier$7(Landroid/net/Uri;Landroid/telephony/ims/RtpHeaderExtensionType;)Z
    .locals 0

    .line 623
    invoke-virtual {p1}, Landroid/telephony/ims/RtpHeaderExtensionType;->getUri()Landroid/net/Uri;

    move-result-object p1

    invoke-virtual {p1, p0}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private synthetic lambda$onRtpHeaderExtensionsReceived$4(Landroid/telephony/ims/RtpHeaderExtension;)Lcom/android/internal/telephony/d2d/Communicator$Message;
    .locals 0

    .line 423
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/d2d/RtpTransport;->extractMessage(Landroid/telephony/ims/RtpHeaderExtension;)Lcom/android/internal/telephony/d2d/Communicator$Message;

    move-result-object p0

    return-object p0
.end method

.method private synthetic lambda$sendMessages$3(Lcom/android/internal/telephony/d2d/Communicator$Message;)Landroid/telephony/ims/RtpHeaderExtension;
    .locals 0

    .line 385
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/d2d/RtpTransport;->generateRtpHeaderExtension(Lcom/android/internal/telephony/d2d/Communicator$Message;)Landroid/telephony/ims/RtpHeaderExtension;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$startNegotiation$0(Landroid/telephony/ims/RtpHeaderExtensionType;)Ljava/lang/String;
    .locals 0

    .line 347
    invoke-virtual {p0}, Landroid/telephony/ims/RtpHeaderExtensionType;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$startNegotiation$1(Landroid/telephony/ims/RtpHeaderExtensionType;)Z
    .locals 1

    .line 352
    invoke-virtual {p0}, Landroid/telephony/ims/RtpHeaderExtensionType;->getUri()Landroid/net/Uri;

    move-result-object p0

    sget-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri;

    invoke-virtual {p0, v0}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$startNegotiation$2(Landroid/telephony/ims/RtpHeaderExtensionType;)Z
    .locals 1

    .line 354
    invoke-virtual {p0}, Landroid/telephony/ims/RtpHeaderExtensionType;->getUri()Landroid/net/Uri;

    move-result-object p0

    sget-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri;

    invoke-virtual {p0, v0}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private notifyProtocolReady()V
    .locals 1

    .line 631
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mCallback:Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;

    if-eqz v0, :cond_0

    .line 632
    invoke-interface {v0, p0}, Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;->onNegotiationSuccess(Lcom/android/internal/telephony/d2d/TransportProtocol;)V

    :cond_0
    return-void
.end method

.method private notifyProtocolUnavailable()V
    .locals 1

    .line 640
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mCallback:Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;

    if-eqz v0, :cond_0

    .line 641
    invoke-interface {v0, p0}, Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;->onNegotiationFailed(Lcom/android/internal/telephony/d2d/TransportProtocol;)V

    :cond_0
    return-void
.end method


# virtual methods
.method public forceNegotiated()V
    .locals 2

    .line 397
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mSupportedRtpHeaderExtensionTypes:Landroid/util/ArraySet;

    if-eqz v0, :cond_0

    .line 398
    invoke-virtual {v0}, Landroid/util/ArraySet;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 399
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mSupportedRtpHeaderExtensionTypes:Landroid/util/ArraySet;

    sget-object v1, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_RTP_HEADER_EXTENSION_TYPE:Landroid/telephony/ims/RtpHeaderExtensionType;

    invoke-virtual {v0, v1}, Landroid/util/ArraySet;->add(Ljava/lang/Object;)Z

    .line 400
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mSupportedRtpHeaderExtensionTypes:Landroid/util/ArraySet;

    sget-object v1, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_RTP_HEADER_EXTENSION_TYPE:Landroid/telephony/ims/RtpHeaderExtensionType;

    invoke-virtual {v0, v1}, Landroid/util/ArraySet;->add(Ljava/lang/Object;)Z

    :cond_1
    const/4 v0, 0x3

    .line 402
    iput v0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mProtocolStatus:I

    return-void
.end method

.method public forceNotNegotiated()V
    .locals 1

    const/4 v0, 0x1

    .line 410
    iput v0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mProtocolStatus:I

    return-void
.end method

.method public generateRtpHeaderExtension(Lcom/android/internal/telephony/d2d/Communicator$Message;)Landroid/telephony/ims/RtpHeaderExtension;
    .locals 5

    const/4 v0, 0x1

    new-array v1, v0, [B

    .line 586
    invoke-virtual {p1}, Lcom/android/internal/telephony/d2d/Communicator$Message;->getType()I

    move-result v2

    const/4 v3, 0x0

    if-eq v2, v0, :cond_3

    const/4 v0, 0x2

    if-eq v2, v0, :cond_2

    const/4 v0, 0x3

    if-eq v2, v0, :cond_1

    const/4 v0, 0x4

    if-eq v2, v0, :cond_0

    const/4 p0, 0x0

    return-object p0

    :cond_0
    aget-byte v0, v1, v3

    .line 606
    sget-object v2, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_MSG_TYPE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-virtual {p1}, Lcom/android/internal/telephony/d2d/Communicator$Message;->getType()I

    move-result v4

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-virtual {v2, v4}, Lcom/android/internal/telephony/BiMap;->getValue(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Byte;

    invoke-virtual {v2}, Ljava/lang/Byte;->byteValue()B

    move-result v2

    or-int/2addr v0, v2

    int-to-byte v0, v0

    aput-byte v0, v1, v3

    .line 607
    sget-object v2, Lcom/android/internal/telephony/d2d/RtpTransport;->NETWORK_COVERAGE_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-virtual {p1}, Lcom/android/internal/telephony/d2d/Communicator$Message;->getValue()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-virtual {v2, p1}, Lcom/android/internal/telephony/BiMap;->getValue(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Byte;

    invoke-virtual {p1}, Ljava/lang/Byte;->byteValue()B

    move-result p1

    or-int/2addr p1, v0

    int-to-byte p1, p1

    aput-byte p1, v1, v3

    .line 608
    new-instance p1, Landroid/telephony/ims/RtpHeaderExtension;

    sget-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri;

    .line 609
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/d2d/RtpTransport;->getRtpHeaderExtensionIdentifier(Landroid/net/Uri;)I

    move-result p0

    invoke-direct {p1, p0, v1}, Landroid/telephony/ims/RtpHeaderExtension;-><init>(I[B)V

    return-object p1

    :cond_1
    aget-byte v0, v1, v3

    .line 600
    sget-object v2, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_MSG_TYPE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-virtual {p1}, Lcom/android/internal/telephony/d2d/Communicator$Message;->getType()I

    move-result v4

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-virtual {v2, v4}, Lcom/android/internal/telephony/BiMap;->getValue(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Byte;

    invoke-virtual {v2}, Ljava/lang/Byte;->byteValue()B

    move-result v2

    or-int/2addr v0, v2

    int-to-byte v0, v0

    aput-byte v0, v1, v3

    .line 601
    sget-object v2, Lcom/android/internal/telephony/d2d/RtpTransport;->BATTERY_STATE_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-virtual {p1}, Lcom/android/internal/telephony/d2d/Communicator$Message;->getValue()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-virtual {v2, p1}, Lcom/android/internal/telephony/BiMap;->getValue(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Byte;

    invoke-virtual {p1}, Ljava/lang/Byte;->byteValue()B

    move-result p1

    or-int/2addr p1, v0

    int-to-byte p1, p1

    aput-byte p1, v1, v3

    .line 602
    new-instance p1, Landroid/telephony/ims/RtpHeaderExtension;

    sget-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->DEVICE_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri;

    .line 603
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/d2d/RtpTransport;->getRtpHeaderExtensionIdentifier(Landroid/net/Uri;)I

    move-result p0

    invoke-direct {p1, p0, v1}, Landroid/telephony/ims/RtpHeaderExtension;-><init>(I[B)V

    return-object p1

    :cond_2
    aget-byte v0, v1, v3

    .line 588
    sget-object v2, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_MSG_TYPE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-virtual {p1}, Lcom/android/internal/telephony/d2d/Communicator$Message;->getType()I

    move-result v4

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-virtual {v2, v4}, Lcom/android/internal/telephony/BiMap;->getValue(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Byte;

    invoke-virtual {v2}, Ljava/lang/Byte;->byteValue()B

    move-result v2

    or-int/2addr v0, v2

    int-to-byte v0, v0

    aput-byte v0, v1, v3

    .line 589
    sget-object v2, Lcom/android/internal/telephony/d2d/RtpTransport;->CODEC_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-virtual {p1}, Lcom/android/internal/telephony/d2d/Communicator$Message;->getValue()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-virtual {v2, p1}, Lcom/android/internal/telephony/BiMap;->getValue(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Byte;

    invoke-virtual {p1}, Ljava/lang/Byte;->byteValue()B

    move-result p1

    or-int/2addr p1, v0

    int-to-byte p1, p1

    aput-byte p1, v1, v3

    .line 590
    new-instance p1, Landroid/telephony/ims/RtpHeaderExtension;

    sget-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri;

    .line 591
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/d2d/RtpTransport;->getRtpHeaderExtensionIdentifier(Landroid/net/Uri;)I

    move-result p0

    invoke-direct {p1, p0, v1}, Landroid/telephony/ims/RtpHeaderExtension;-><init>(I[B)V

    return-object p1

    :cond_3
    aget-byte v0, v1, v3

    .line 594
    sget-object v2, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_MSG_TYPE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-virtual {p1}, Lcom/android/internal/telephony/d2d/Communicator$Message;->getType()I

    move-result v4

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-virtual {v2, v4}, Lcom/android/internal/telephony/BiMap;->getValue(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Byte;

    invoke-virtual {v2}, Ljava/lang/Byte;->byteValue()B

    move-result v2

    or-int/2addr v0, v2

    int-to-byte v0, v0

    aput-byte v0, v1, v3

    .line 595
    sget-object v2, Lcom/android/internal/telephony/d2d/RtpTransport;->RAT_VALUE_TO_RTP_BITS:Lcom/android/internal/telephony/BiMap;

    invoke-virtual {p1}, Lcom/android/internal/telephony/d2d/Communicator$Message;->getValue()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-virtual {v2, p1}, Lcom/android/internal/telephony/BiMap;->getValue(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Byte;

    invoke-virtual {p1}, Ljava/lang/Byte;->byteValue()B

    move-result p1

    or-int/2addr p1, v0

    int-to-byte p1, p1

    aput-byte p1, v1, v3

    .line 596
    new-instance p1, Landroid/telephony/ims/RtpHeaderExtension;

    sget-object v0, Lcom/android/internal/telephony/d2d/RtpTransport;->CALL_STATE_RTP_HEADER_EXTENSION:Landroid/net/Uri;

    .line 597
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/d2d/RtpTransport;->getRtpHeaderExtensionIdentifier(Landroid/net/Uri;)I

    move-result p0

    invoke-direct {p1, p0, v1}, Landroid/telephony/ims/RtpHeaderExtension;-><init>(I[B)V

    return-object p1
.end method

.method public onRtpHeaderExtensionsReceived(Ljava/util/Set;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Landroid/telephony/ims/RtpHeaderExtension;",
            ">;)V"
        }
    .end annotation

    .line 423
    invoke-interface {p1}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/d2d/RtpTransport;)V

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda1;

    invoke-direct {v0}, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda1;-><init>()V

    .line 424
    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p1

    .line 425
    invoke-static {}, Ljava/util/stream/Collectors;->toSet()Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/Set;

    .line 426
    invoke-interface {p1}, Ljava/util/Set;->size()I

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 429
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mCallback:Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;->onMessagesReceived(Ljava/util/Set;)V

    return-void
.end method

.method public sendMessages(Ljava/util/Set;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/d2d/Communicator$Message;",
            ">;)V"
        }
    .end annotation

    .line 385
    invoke-interface {p1}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda3;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/d2d/RtpTransport;)V

    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v0

    .line 386
    invoke-static {}, Ljava/util/stream/Collectors;->toSet()Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Set;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    aput-object p1, v1, v2

    const-string p1, "sendMessages: sending=%s"

    .line 387
    invoke-static {p0, p1, v1}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 388
    iget-object p0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mRtpAdapter:Lcom/android/internal/telephony/d2d/RtpAdapter;

    invoke-interface {p0, v0}, Lcom/android/internal/telephony/d2d/RtpAdapter;->sendRtpHeaderExtensions(Ljava/util/Set;)V

    return-void
.end method

.method public setCallback(Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;)V
    .locals 0

    .line 326
    iput-object p1, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mCallback:Lcom/android/internal/telephony/d2d/TransportProtocol$Callback;

    return-void
.end method

.method public startNegotiation()V
    .locals 5

    .line 341
    iget-object v0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mRtpAdapter:Lcom/android/internal/telephony/d2d/RtpAdapter;

    .line 342
    invoke-interface {v0}, Lcom/android/internal/telephony/d2d/RtpAdapter;->getAcceptedRtpHeaderExtensions()Ljava/util/Set;

    move-result-object v0

    .line 343
    iget-object v1, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mSupportedRtpHeaderExtensionTypes:Landroid/util/ArraySet;

    invoke-virtual {v1, v0}, Landroid/util/ArraySet;->addAll(Ljava/util/Collection;)Z

    const/4 v1, 0x1

    new-array v2, v1, [Ljava/lang/Object;

    .line 345
    iget-object v3, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mSupportedRtpHeaderExtensionTypes:Landroid/util/ArraySet;

    .line 346
    invoke-virtual {v3}, Landroid/util/ArraySet;->stream()Ljava/util/stream/Stream;

    move-result-object v3

    new-instance v4, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda4;

    invoke-direct {v4}, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda4;-><init>()V

    .line 347
    invoke-interface {v3, v4}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v3

    const-string v4, ","

    .line 348
    invoke-static {v4}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v4

    invoke-interface {v3, v4}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v3

    const/4 v4, 0x0

    aput-object v3, v2, v4

    const-string/jumbo v3, "startNegotiation: supportedExtensions=%s"

    .line 345
    invoke-static {p0, v3, v2}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 350
    iget-boolean v2, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mIsSdpNegotiationSupported:Z

    if-eqz v2, :cond_2

    .line 351
    invoke-interface {v0}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda5;

    invoke-direct {v3}, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda5;-><init>()V

    invoke-interface {v2, v3}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 353
    invoke-interface {v0}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v2, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda6;

    invoke-direct {v2}, Lcom/android/internal/telephony/d2d/RtpTransport$$ExternalSyntheticLambda6;-><init>()V

    invoke-interface {v0, v2}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    move v1, v4

    :goto_0
    if-eqz v1, :cond_1

    const/4 v0, 0x3

    .line 359
    iput v0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mProtocolStatus:I

    new-array v0, v4, [Ljava/lang/Object;

    const-string/jumbo v1, "startNegotiation: header extensions available, negotiation success"

    .line 360
    invoke-static {p0, v1, v0}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 361
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/RtpTransport;->notifyProtocolReady()V

    goto :goto_1

    :cond_1
    const/4 v0, 0x4

    .line 365
    iput v0, p0, Lcom/android/internal/telephony/d2d/RtpTransport;->mProtocolStatus:I

    new-array v0, v4, [Ljava/lang/Object;

    const-string/jumbo v1, "startNegotiation: header extensions not available; negotiation failed"

    .line 366
    invoke-static {p0, v1, v0}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 368
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/RtpTransport;->notifyProtocolUnavailable()V

    goto :goto_1

    :cond_2
    new-array v0, v4, [Ljava/lang/Object;

    const-string/jumbo v1, "startNegotiation: SDP negotiation not supported; negotiation complete"

    .line 371
    invoke-static {p0, v1, v0}, Landroid/telecom/Log;->i(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)V

    .line 374
    invoke-direct {p0}, Lcom/android/internal/telephony/d2d/RtpTransport;->notifyProtocolReady()V

    :goto_1
    return-void
.end method
