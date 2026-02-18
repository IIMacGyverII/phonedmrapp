.class public Lcom/android/cellbroadcastservice/CellBroadcastStatsLog;
.super Ljava/lang/Object;
.source "CellBroadcastStatsLog.java"


# static fields
.field public static final ANNOTATION_ID_EXCLUSIVE_STATE:B

.field public static final ANNOTATION_ID_IS_UID:B

.field public static final ANNOTATION_ID_PRIMARY_FIELD:B

.field public static final ANNOTATION_ID_PRIMARY_FIELD_FIRST_UID:B

.field public static final ANNOTATION_ID_STATE_NESTED:B

.field public static final ANNOTATION_ID_TRIGGER_STATE_RESET:B

.field public static final ANNOTATION_ID_TRUNCATE_TIMESTAMP:B

.field public static final CB_MESSAGE_ERROR:I = 0xfa

.field public static final CB_MESSAGE_FILTERED:I = 0x116

.field public static final CB_MESSAGE_REPORTED:I = 0xf9

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__CDMA_DECODING_ERROR:I = 0x1

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__CDMA_SCP_EMPTY:I = 0x2

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__CDMA_SCP_HANDLING_ERROR:I = 0x3

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__FAILED_TO_INSERT_TO_DB:I = 0xa

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__GSM_INVALID_GEO_FENCING_DATA:I = 0x8

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__GSM_INVALID_HEADER_LENGTH:I = 0x4

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__GSM_INVALID_PDU:I = 0x7

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__GSM_UMTS_INVALID_WAC:I = 0x9

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__GSM_UNSUPPORTED_HEADER_DATA_CODING_SCHEME:I = 0x6

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__GSM_UNSUPPORTED_HEADER_MESSAGE_TYPE:I = 0x5

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__NO_CONNECTION_TO_CB_SERVICE:I = 0xf

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__UNEXPECTED_CDMA_MESSAGE_TYPE_FROM_FWK:I = 0xd

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__UNEXPECTED_CDMA_SCP_MESSAGE_TYPE_FROM_FWK:I = 0xe

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__UNEXPECTED_GEOMETRY_FROM_FWK:I = 0xb

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__UNEXPECTED_GSM_MESSAGE_TYPE_FROM_FWK:I = 0xc

.field public static final CELL_BROADCAST_MESSAGE_ERROR__TYPE__UNKNOWN_TYPE:I = 0x0

.field public static final CELL_BROADCAST_MESSAGE_FILTERED__FILTER__AREA_INFO_MESSAGE:I = 0x3

.field public static final CELL_BROADCAST_MESSAGE_FILTERED__FILTER__DISABLED_BY_OEM:I = 0x4

.field public static final CELL_BROADCAST_MESSAGE_FILTERED__FILTER__DUPLICATE_MESSAGE:I = 0x1

.field public static final CELL_BROADCAST_MESSAGE_FILTERED__FILTER__GEOFENCED_MESSAGE:I = 0x2

.field public static final CELL_BROADCAST_MESSAGE_FILTERED__FILTER__NOT_FILTERED:I = 0x0

.field public static final CELL_BROADCAST_MESSAGE_FILTERED__TYPE__CDMA:I = 0x2

.field public static final CELL_BROADCAST_MESSAGE_FILTERED__TYPE__CDMA_SPC:I = 0x3

.field public static final CELL_BROADCAST_MESSAGE_FILTERED__TYPE__GSM:I = 0x1

.field public static final CELL_BROADCAST_MESSAGE_FILTERED__TYPE__UNKNOWN_TYPE:I = 0x0

.field public static final CELL_BROADCAST_MESSAGE_REPORTED__SOURCE__CB_RECEIVER_APP:I = 0x3

.field public static final CELL_BROADCAST_MESSAGE_REPORTED__SOURCE__CB_SERVICE:I = 0x2

.field public static final CELL_BROADCAST_MESSAGE_REPORTED__SOURCE__FRAMEWORK:I = 0x1

.field public static final CELL_BROADCAST_MESSAGE_REPORTED__SOURCE__UNKNOWN_SOURCE:I = 0x0

.field public static final CELL_BROADCAST_MESSAGE_REPORTED__TYPE__CDMA:I = 0x2

.field public static final CELL_BROADCAST_MESSAGE_REPORTED__TYPE__CDMA_SPC:I = 0x3

.field public static final CELL_BROADCAST_MESSAGE_REPORTED__TYPE__GSM:I = 0x1

.field public static final CELL_BROADCAST_MESSAGE_REPORTED__TYPE__UNKNOWN_TYPE:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x1

    .line 83
    sput-byte v0, Lcom/android/cellbroadcastservice/CellBroadcastStatsLog;->ANNOTATION_ID_IS_UID:B

    const/4 v0, 0x2

    .line 87
    sput-byte v0, Lcom/android/cellbroadcastservice/CellBroadcastStatsLog;->ANNOTATION_ID_TRUNCATE_TIMESTAMP:B

    const/4 v0, 0x3

    .line 91
    sput-byte v0, Lcom/android/cellbroadcastservice/CellBroadcastStatsLog;->ANNOTATION_ID_PRIMARY_FIELD:B

    const/4 v0, 0x4

    .line 95
    sput-byte v0, Lcom/android/cellbroadcastservice/CellBroadcastStatsLog;->ANNOTATION_ID_EXCLUSIVE_STATE:B

    const/4 v0, 0x5

    .line 99
    sput-byte v0, Lcom/android/cellbroadcastservice/CellBroadcastStatsLog;->ANNOTATION_ID_PRIMARY_FIELD_FIRST_UID:B

    const/4 v0, 0x7

    .line 103
    sput-byte v0, Lcom/android/cellbroadcastservice/CellBroadcastStatsLog;->ANNOTATION_ID_TRIGGER_STATE_RESET:B

    const/16 v0, 0x8

    .line 107
    sput-byte v0, Lcom/android/cellbroadcastservice/CellBroadcastStatsLog;->ANNOTATION_ID_STATE_NESTED:B

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 14
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static write(III)V
    .locals 1

    .line 112
    invoke-static {}, Landroid/util/StatsEvent;->newBuilder()Landroid/util/StatsEvent$Builder;

    move-result-object v0

    .line 113
    invoke-virtual {v0, p0}, Landroid/util/StatsEvent$Builder;->setAtomId(I)Landroid/util/StatsEvent$Builder;

    .line 114
    invoke-virtual {v0, p1}, Landroid/util/StatsEvent$Builder;->writeInt(I)Landroid/util/StatsEvent$Builder;

    .line 115
    invoke-virtual {v0, p2}, Landroid/util/StatsEvent$Builder;->writeInt(I)Landroid/util/StatsEvent$Builder;

    .line 117
    invoke-virtual {v0}, Landroid/util/StatsEvent$Builder;->usePooledBuffer()Landroid/util/StatsEvent$Builder;

    .line 118
    invoke-virtual {v0}, Landroid/util/StatsEvent$Builder;->build()Landroid/util/StatsEvent;

    move-result-object p0

    invoke-static {p0}, Landroid/util/StatsLog;->write(Landroid/util/StatsEvent;)V

    return-void
.end method

.method public static write(IILjava/lang/String;)V
    .locals 1

    .line 122
    invoke-static {}, Landroid/util/StatsEvent;->newBuilder()Landroid/util/StatsEvent$Builder;

    move-result-object v0

    .line 123
    invoke-virtual {v0, p0}, Landroid/util/StatsEvent$Builder;->setAtomId(I)Landroid/util/StatsEvent$Builder;

    .line 124
    invoke-virtual {v0, p1}, Landroid/util/StatsEvent$Builder;->writeInt(I)Landroid/util/StatsEvent$Builder;

    .line 125
    invoke-virtual {v0, p2}, Landroid/util/StatsEvent$Builder;->writeString(Ljava/lang/String;)Landroid/util/StatsEvent$Builder;

    .line 127
    invoke-virtual {v0}, Landroid/util/StatsEvent$Builder;->usePooledBuffer()Landroid/util/StatsEvent$Builder;

    .line 128
    invoke-virtual {v0}, Landroid/util/StatsEvent$Builder;->build()Landroid/util/StatsEvent;

    move-result-object p0

    invoke-static {p0}, Landroid/util/StatsLog;->write(Landroid/util/StatsEvent;)V

    return-void
.end method
