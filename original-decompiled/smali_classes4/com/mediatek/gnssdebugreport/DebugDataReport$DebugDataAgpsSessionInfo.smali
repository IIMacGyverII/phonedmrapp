.class public Lcom/mediatek/gnssdebugreport/DebugDataReport$DebugDataAgpsSessionInfo;
.super Ljava/lang/Object;
.source "DebugDataReport.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/gnssdebugreport/DebugDataReport;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "DebugDataAgpsSessionInfo"
.end annotation


# static fields
.field public static final JSON_TYPE_ID:I = 0x2329

.field public static final KEY_HAS_ACQUISION:Ljava/lang/String; = "has_acquision"

.field public static final KEY_HAS_ALMANAC:Ljava/lang/String; = "has_almanac"

.field public static final KEY_HAS_AUX_INFO:Ljava/lang/String; = "has_aux_info"

.field public static final KEY_HAS_DATA_BIT_ASSIST:Ljava/lang/String; = "has_data_bit_assist"

.field public static final KEY_HAS_DGPS:Ljava/lang/String; = "has_dgps"

.field public static final KEY_HAS_EOP:Ljava/lang/String; = "has_eop"

.field public static final KEY_HAS_EPHEMERIS:Ljava/lang/String; = "has_ephemeris"

.field public static final KEY_HAS_IONOSPHERE:Ljava/lang/String; = "has_ionosphere"

.field public static final KEY_HAS_LOC_EST:Ljava/lang/String; = "has_loc_est"

.field public static final KEY_HAS_REF_LOCATION:Ljava/lang/String; = "has_ref_location"

.field public static final KEY_HAS_REF_TIME:Ljava/lang/String; = "has_ref_time"

.field public static final KEY_HAS_RTI:Ljava/lang/String; = "has_rti"

.field public static final KEY_HAS_SAT_MEAS:Ljava/lang/String; = "has_sat_meas"

.field public static final KEY_HAS_TIME_MODEL:Ljava/lang/String; = "has_time_model"

.field public static final KEY_HAS_TOW_ASSIST:Ljava/lang/String; = "has_tow_assist"

.field public static final KEY_HAS_UTC:Ljava/lang/String; = "has_utc"

.field public static final KEY_INITIATOR:Ljava/lang/String; = "initiator"

.field public static final KEY_PLANE:Ljava/lang/String; = "plane"

.field public static final KEY_PROTOCOL:Ljava/lang/String; = "protocol"

.field public static final KEY_RESULT:Ljava/lang/String; = "result"

.field public static final KEY_SESSION_ID:Ljava/lang/String; = "session_id"

.field public static final KEY_SESSION_PERIOD:Ljava/lang/String; = "session_period"

.field public static final KEY_VER:Ljava/lang/String; = "ver"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 339
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
