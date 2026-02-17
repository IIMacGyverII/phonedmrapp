.class public Lcom/android/internal/telephony/metrics/CallQualityMetrics;
.super Ljava/lang/Object;
.source "CallQualityMetrics.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/metrics/CallQualityMetrics$TimestampedQualitySnapshot;
    }
.end annotation


# static fields
.field private static final BAD_QUALITY:I = 0x1

.field private static final GOOD_QUALITY:I = 0x0

.field private static final IS_DEBUGGABLE:Z

.field private static final MAX_SNAPSHOTS:I = 0x5

.field private static final TAG:Ljava/lang/String; = "CallQualityMetrics"


# instance fields
.field private mBestSsWithBadDlQuality:Landroid/util/Pair;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/Pair<",
            "Landroid/telephony/CallQuality;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mBestSsWithBadUlQuality:Landroid/util/Pair;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/Pair<",
            "Landroid/telephony/CallQuality;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mBestSsWithGoodDlQuality:Landroid/util/Pair;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/Pair<",
            "Landroid/telephony/CallQuality;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mBestSsWithGoodUlQuality:Landroid/util/Pair;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/Pair<",
            "Landroid/telephony/CallQuality;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mDlCallQualityState:I

.field private mDlSnapshots:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/util/Pair<",
            "Landroid/telephony/CallQuality;",
            "Ljava/lang/Integer;",
            ">;>;"
        }
    .end annotation
.end field

.field private mFullDownlinkQuality:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/android/internal/telephony/metrics/CallQualityMetrics$TimestampedQualitySnapshot;",
            ">;"
        }
    .end annotation
.end field

.field private mFullUplinkQuality:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/android/internal/telephony/metrics/CallQualityMetrics$TimestampedQualitySnapshot;",
            ">;"
        }
    .end annotation
.end field

.field private mLastCallQuality:Landroid/telephony/CallQuality;

.field private mPhone:Lcom/android/internal/telephony/Phone;

.field private mUlCallQualityState:I

.field private mUlSnapshots:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/util/Pair<",
            "Landroid/telephony/CallQuality;",
            "Ljava/lang/Integer;",
            ">;>;"
        }
    .end annotation
.end field

.field private mWorstSsWithBadDlQuality:Landroid/util/Pair;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/Pair<",
            "Landroid/telephony/CallQuality;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mWorstSsWithBadUlQuality:Landroid/util/Pair;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/Pair<",
            "Landroid/telephony/CallQuality;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mWorstSsWithGoodDlQuality:Landroid/util/Pair;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/Pair<",
            "Landroid/telephony/CallQuality;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mWorstSsWithGoodUlQuality:Landroid/util/Pair;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/Pair<",
            "Landroid/telephony/CallQuality;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 46
    sget-boolean v0, Lcom/android/internal/telephony/util/TelephonyUtils;->IS_DEBUGGABLE:Z

    sput-boolean v0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->IS_DEBUGGABLE:Z

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;)V
    .locals 1

    .line 96
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 62
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mUlSnapshots:Ljava/util/ArrayList;

    .line 65
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mDlSnapshots:Ljava/util/ArrayList;

    .line 70
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mFullUplinkQuality:Ljava/util/ArrayList;

    .line 71
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mFullDownlinkQuality:Ljava/util/ArrayList;

    const/4 v0, 0x0

    .line 74
    iput v0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mDlCallQualityState:I

    .line 77
    iput v0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mUlCallQualityState:I

    .line 97
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 98
    new-instance p1, Landroid/telephony/CallQuality;

    invoke-direct {p1}, Landroid/telephony/CallQuality;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mLastCallQuality:Landroid/telephony/CallQuality;

    return-void
.end method

.method private addSnapshot(Landroid/telephony/CallQuality;Ljava/util/ArrayList;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/telephony/CallQuality;",
            "Ljava/util/ArrayList<",
            "Landroid/util/Pair<",
            "Landroid/telephony/CallQuality;",
            "Ljava/lang/Integer;",
            ">;>;)V"
        }
    .end annotation

    .line 157
    invoke-virtual {p2}, Ljava/util/ArrayList;->size()I

    move-result v0

    const/4 v1, 0x5

    if-ge v0, v1, :cond_0

    .line 158
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->getLteSnr()Ljava/lang/Integer;

    move-result-object p0

    .line 159
    invoke-static {p1, p0}, Landroid/util/Pair;->create(Ljava/lang/Object;Ljava/lang/Object;)Landroid/util/Pair;

    move-result-object p0

    invoke-virtual {p2, p0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_0
    return-void
.end method

.method private getLteSnr()Ljava/lang/Integer;
    .locals 4

    .line 218
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDefaultPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSignalStrengthController()Lcom/android/internal/telephony/SignalStrengthController;

    move-result-object v0

    const v1, 0x7fffffff

    .line 221
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    if-nez v0, :cond_0

    .line 220
    sget-object v0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "getLteSnr: unable to get SSC for phone "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-object v2

    .line 224
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/SignalStrengthController;->getSignalStrength()Landroid/telephony/SignalStrength;

    move-result-object v0

    if-nez v0, :cond_1

    .line 226
    sget-object v0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "getLteSnr: unable to get SignalStrength for phone "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-object v2

    .line 231
    :cond_1
    const-class p0, Landroid/telephony/CellSignalStrengthLte;

    invoke-virtual {v0, p0}, Landroid/telephony/SignalStrength;->getCellSignalStrengths(Ljava/lang/Class;)Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_2
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_3

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CellSignalStrengthLte;

    .line 232
    invoke-virtual {v0}, Landroid/telephony/CellSignalStrengthLte;->getRssnr()I

    move-result v0

    if-eq v0, v1, :cond_2

    .line 234
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    return-object p0

    :cond_3
    return-object v2
.end method

.method private getTotalGoodAndBadQualityTimeMs(Ljava/util/ArrayList;)Landroid/util/Pair;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Lcom/android/internal/telephony/metrics/CallQualityMetrics$TimestampedQualitySnapshot;",
            ">;)",
            "Landroid/util/Pair<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 368
    invoke-static {p1}, Ljava/util/Collections;->sort(Ljava/util/List;)V

    .line 369
    invoke-virtual {p1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    const/4 p1, 0x0

    move v0, p1

    move v1, v0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/metrics/CallQualityMetrics$TimestampedQualitySnapshot;

    .line 370
    iget v3, v2, Lcom/android/internal/telephony/metrics/CallQualityMetrics$TimestampedQualitySnapshot;->mTimestampMs:I

    sub-int/2addr v3, v1

    .line 371
    iget v1, v2, Lcom/android/internal/telephony/metrics/CallQualityMetrics$TimestampedQualitySnapshot;->mCallQualityLevel:I

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->isGoodQuality(I)Z

    move-result v1

    if-eqz v1, :cond_0

    add-int/2addr p1, v3

    goto :goto_1

    :cond_0
    add-int/2addr v0, v3

    .line 376
    :goto_1
    iget v1, v2, Lcom/android/internal/telephony/metrics/CallQualityMetrics$TimestampedQualitySnapshot;->mTimestampMs:I

    goto :goto_0

    .line 379
    :cond_1
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Pair;->create(Ljava/lang/Object;Ljava/lang/Object;)Landroid/util/Pair;

    move-result-object p0

    return-object p0
.end method

.method private static isGoodQuality(I)Z
    .locals 1

    const/4 v0, 0x4

    if-ge p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static toProto(I)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;
    .locals 1

    .line 242
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;-><init>()V

    .line 244
    iput p0, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;->lteSnr:I

    return-object v0
.end method

.method private updateMinAndMaxSignalStrengthSnapshots(IILandroid/telephony/CallQuality;)V
    .locals 2

    .line 176
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->getLteSnr()Ljava/lang/Integer;

    move-result-object v0

    const v1, 0x7fffffff

    .line 177
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/Integer;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    return-void

    :cond_0
    if-nez p1, :cond_4

    .line 183
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithGoodDlQuality:Landroid/util/Pair;

    if-eqz p1, :cond_1

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithGoodDlQuality:Landroid/util/Pair;

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    if-ge p1, v1, :cond_2

    .line 184
    :cond_1
    invoke-static {p3, v0}, Landroid/util/Pair;->create(Ljava/lang/Object;Ljava/lang/Object;)Landroid/util/Pair;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithGoodDlQuality:Landroid/util/Pair;

    .line 186
    :cond_2
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithGoodDlQuality:Landroid/util/Pair;

    if-eqz p1, :cond_3

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithGoodDlQuality:Landroid/util/Pair;

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    if-le p1, v1, :cond_8

    .line 187
    :cond_3
    invoke-static {p3, v0}, Landroid/util/Pair;->create(Ljava/lang/Object;Ljava/lang/Object;)Landroid/util/Pair;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithGoodDlQuality:Landroid/util/Pair;

    goto :goto_0

    .line 190
    :cond_4
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithBadDlQuality:Landroid/util/Pair;

    if-eqz p1, :cond_5

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithBadDlQuality:Landroid/util/Pair;

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    if-ge p1, v1, :cond_6

    .line 191
    :cond_5
    invoke-static {p3, v0}, Landroid/util/Pair;->create(Ljava/lang/Object;Ljava/lang/Object;)Landroid/util/Pair;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithBadDlQuality:Landroid/util/Pair;

    .line 193
    :cond_6
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithBadDlQuality:Landroid/util/Pair;

    if-eqz p1, :cond_7

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithBadDlQuality:Landroid/util/Pair;

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    if-le p1, v1, :cond_8

    .line 194
    :cond_7
    invoke-static {p3, v0}, Landroid/util/Pair;->create(Ljava/lang/Object;Ljava/lang/Object;)Landroid/util/Pair;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithBadDlQuality:Landroid/util/Pair;

    :cond_8
    :goto_0
    if-nez p2, :cond_c

    .line 200
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithGoodUlQuality:Landroid/util/Pair;

    if-eqz p1, :cond_9

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iget-object p2, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithGoodUlQuality:Landroid/util/Pair;

    iget-object p2, p2, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast p2, Ljava/lang/Integer;

    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p2

    if-ge p1, p2, :cond_a

    .line 201
    :cond_9
    invoke-static {p3, v0}, Landroid/util/Pair;->create(Ljava/lang/Object;Ljava/lang/Object;)Landroid/util/Pair;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithGoodUlQuality:Landroid/util/Pair;

    .line 203
    :cond_a
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithGoodUlQuality:Landroid/util/Pair;

    if-eqz p1, :cond_b

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iget-object p2, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithGoodUlQuality:Landroid/util/Pair;

    iget-object p2, p2, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast p2, Ljava/lang/Integer;

    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p2

    if-le p1, p2, :cond_10

    .line 204
    :cond_b
    invoke-static {p3, v0}, Landroid/util/Pair;->create(Ljava/lang/Object;Ljava/lang/Object;)Landroid/util/Pair;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithGoodUlQuality:Landroid/util/Pair;

    goto :goto_1

    .line 207
    :cond_c
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithBadUlQuality:Landroid/util/Pair;

    if-eqz p1, :cond_d

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iget-object p2, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithBadUlQuality:Landroid/util/Pair;

    iget-object p2, p2, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast p2, Ljava/lang/Integer;

    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p2

    if-ge p1, p2, :cond_e

    .line 208
    :cond_d
    invoke-static {p3, v0}, Landroid/util/Pair;->create(Ljava/lang/Object;Ljava/lang/Object;)Landroid/util/Pair;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithBadUlQuality:Landroid/util/Pair;

    .line 210
    :cond_e
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithBadUlQuality:Landroid/util/Pair;

    if-eqz p1, :cond_f

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iget-object p2, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithBadUlQuality:Landroid/util/Pair;

    iget-object p2, p2, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast p2, Ljava/lang/Integer;

    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p2

    if-le p1, p2, :cond_10

    .line 211
    :cond_f
    invoke-static {p3, v0}, Landroid/util/Pair;->create(Ljava/lang/Object;Ljava/lang/Object;)Landroid/util/Pair;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithBadUlQuality:Landroid/util/Pair;

    :cond_10
    :goto_1
    return-void
.end method

.method private updateTotalDurations(Landroid/telephony/CallQuality;)V
    .locals 4

    .line 142
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mFullDownlinkQuality:Ljava/util/ArrayList;

    new-instance v1, Lcom/android/internal/telephony/metrics/CallQualityMetrics$TimestampedQualitySnapshot;

    invoke-virtual {p1}, Landroid/telephony/CallQuality;->getCallDuration()I

    move-result v2

    .line 143
    invoke-virtual {p1}, Landroid/telephony/CallQuality;->getDownlinkCallQualityLevel()I

    move-result v3

    invoke-direct {v1, p0, v2, v3}, Lcom/android/internal/telephony/metrics/CallQualityMetrics$TimestampedQualitySnapshot;-><init>(Lcom/android/internal/telephony/metrics/CallQualityMetrics;II)V

    .line 142
    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 144
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mFullUplinkQuality:Ljava/util/ArrayList;

    new-instance v1, Lcom/android/internal/telephony/metrics/CallQualityMetrics$TimestampedQualitySnapshot;

    invoke-virtual {p1}, Landroid/telephony/CallQuality;->getCallDuration()I

    move-result v2

    .line 145
    invoke-virtual {p1}, Landroid/telephony/CallQuality;->getUplinkCallQualityLevel()I

    move-result p1

    invoke-direct {v1, p0, v2, p1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics$TimestampedQualitySnapshot;-><init>(Lcom/android/internal/telephony/metrics/CallQualityMetrics;II)V

    .line 144
    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-void
.end method


# virtual methods
.method public getCallQualitySummaryDl()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;
    .locals 3

    .line 252
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;-><init>()V

    .line 254
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mFullDownlinkQuality:Ljava/util/ArrayList;

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->getTotalGoodAndBadQualityTimeMs(Ljava/util/ArrayList;)Landroid/util/Pair;

    move-result-object v1

    .line 256
    iget-object v2, v1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    div-int/lit16 v2, v2, 0x3e8

    iput v2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->totalGoodQualityDurationInSeconds:I

    .line 257
    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    div-int/lit16 v1, v1, 0x3e8

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->totalBadQualityDurationInSeconds:I

    .line 262
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mLastCallQuality:Landroid/telephony/CallQuality;

    .line 263
    invoke-virtual {v1}, Landroid/telephony/CallQuality;->getCallDuration()I

    move-result v1

    div-int/lit16 v1, v1, 0x3e8

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->totalDurationWithQualityInformationInSeconds:I

    .line 264
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithGoodDlQuality:Landroid/util/Pair;

    if-eqz v1, :cond_0

    .line 265
    iget-object v1, v1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v1, Landroid/telephony/CallQuality;

    .line 266
    invoke-static {v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toCallQualityProto(Landroid/telephony/CallQuality;)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->snapshotOfWorstSsWithGoodQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    .line 267
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithGoodDlQuality:Landroid/util/Pair;

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->toProto(I)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->worstSsWithGoodQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    .line 269
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithGoodDlQuality:Landroid/util/Pair;

    if-eqz v1, :cond_1

    .line 270
    iget-object v1, v1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v1, Landroid/telephony/CallQuality;

    .line 271
    invoke-static {v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toCallQualityProto(Landroid/telephony/CallQuality;)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->snapshotOfBestSsWithGoodQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    .line 272
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithGoodDlQuality:Landroid/util/Pair;

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->toProto(I)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->bestSsWithGoodQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    .line 274
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithBadDlQuality:Landroid/util/Pair;

    if-eqz v1, :cond_2

    .line 275
    iget-object v1, v1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v1, Landroid/telephony/CallQuality;

    .line 276
    invoke-static {v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toCallQualityProto(Landroid/telephony/CallQuality;)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->snapshotOfWorstSsWithBadQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    .line 277
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithBadDlQuality:Landroid/util/Pair;

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->toProto(I)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->worstSsWithBadQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    .line 279
    :cond_2
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithBadDlQuality:Landroid/util/Pair;

    if-eqz v1, :cond_3

    .line 280
    iget-object v1, v1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v1, Landroid/telephony/CallQuality;

    .line 281
    invoke-static {v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toCallQualityProto(Landroid/telephony/CallQuality;)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->snapshotOfBestSsWithBadQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    .line 282
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithBadDlQuality:Landroid/util/Pair;

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->toProto(I)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->bestSsWithBadQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    .line 284
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mLastCallQuality:Landroid/telephony/CallQuality;

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toCallQualityProto(Landroid/telephony/CallQuality;)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    move-result-object p0

    iput-object p0, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->snapshotOfEnd:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    return-object v0
.end method

.method public getCallQualitySummaryUl()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;
    .locals 3

    .line 292
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;-><init>()V

    .line 294
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mFullUplinkQuality:Ljava/util/ArrayList;

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->getTotalGoodAndBadQualityTimeMs(Ljava/util/ArrayList;)Landroid/util/Pair;

    move-result-object v1

    .line 296
    iget-object v2, v1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    div-int/lit16 v2, v2, 0x3e8

    iput v2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->totalGoodQualityDurationInSeconds:I

    .line 297
    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    div-int/lit16 v1, v1, 0x3e8

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->totalBadQualityDurationInSeconds:I

    .line 302
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mLastCallQuality:Landroid/telephony/CallQuality;

    .line 303
    invoke-virtual {v1}, Landroid/telephony/CallQuality;->getCallDuration()I

    move-result v1

    div-int/lit16 v1, v1, 0x3e8

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->totalDurationWithQualityInformationInSeconds:I

    .line 304
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithGoodUlQuality:Landroid/util/Pair;

    if-eqz v1, :cond_0

    .line 305
    iget-object v1, v1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v1, Landroid/telephony/CallQuality;

    .line 306
    invoke-static {v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toCallQualityProto(Landroid/telephony/CallQuality;)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->snapshotOfWorstSsWithGoodQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    .line 307
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithGoodUlQuality:Landroid/util/Pair;

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->toProto(I)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->worstSsWithGoodQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    .line 309
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithGoodUlQuality:Landroid/util/Pair;

    if-eqz v1, :cond_1

    .line 310
    iget-object v1, v1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v1, Landroid/telephony/CallQuality;

    .line 311
    invoke-static {v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toCallQualityProto(Landroid/telephony/CallQuality;)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->snapshotOfBestSsWithGoodQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    .line 312
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithGoodUlQuality:Landroid/util/Pair;

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->toProto(I)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->bestSsWithGoodQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    .line 314
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithBadUlQuality:Landroid/util/Pair;

    if-eqz v1, :cond_2

    .line 315
    iget-object v1, v1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v1, Landroid/telephony/CallQuality;

    .line 316
    invoke-static {v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toCallQualityProto(Landroid/telephony/CallQuality;)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->snapshotOfWorstSsWithBadQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    .line 317
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mWorstSsWithBadUlQuality:Landroid/util/Pair;

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->toProto(I)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->worstSsWithBadQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    .line 319
    :cond_2
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithBadUlQuality:Landroid/util/Pair;

    if-eqz v1, :cond_3

    .line 320
    iget-object v1, v1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v1, Landroid/telephony/CallQuality;

    .line 321
    invoke-static {v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toCallQualityProto(Landroid/telephony/CallQuality;)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->snapshotOfBestSsWithBadQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    .line 322
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mBestSsWithBadUlQuality:Landroid/util/Pair;

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->toProto(I)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->bestSsWithBadQuality:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$SignalStrength;

    .line 324
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mLastCallQuality:Landroid/telephony/CallQuality;

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toCallQualityProto(Landroid/telephony/CallQuality;)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    move-result-object p0

    iput-object p0, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;->snapshotOfEnd:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    return-object v0
.end method

.method public saveCallQuality(Landroid/telephony/CallQuality;)V
    .locals 3

    .line 105
    invoke-virtual {p1}, Landroid/telephony/CallQuality;->getUplinkCallQualityLevel()I

    move-result v0

    const/4 v1, 0x5

    if-eq v0, v1, :cond_3

    .line 106
    invoke-virtual {p1}, Landroid/telephony/CallQuality;->getDownlinkCallQualityLevel()I

    move-result v0

    if-ne v0, v1, :cond_0

    goto :goto_0

    .line 113
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/CallQuality;->getUplinkCallQualityLevel()I

    move-result v0

    invoke-static {v0}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->isGoodQuality(I)Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    .line 116
    invoke-virtual {p1}, Landroid/telephony/CallQuality;->getDownlinkCallQualityLevel()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->isGoodQuality(I)Z

    move-result v1

    xor-int/lit8 v1, v1, 0x1

    .line 120
    sget-boolean v2, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->IS_DEBUGGABLE:Z

    if-eqz v2, :cond_2

    .line 121
    iget v2, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mUlCallQualityState:I

    if-eq v0, v2, :cond_1

    .line 122
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mUlSnapshots:Ljava/util/ArrayList;

    invoke-direct {p0, p1, v2}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->addSnapshot(Landroid/telephony/CallQuality;Ljava/util/ArrayList;)V

    .line 124
    :cond_1
    iget v2, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mDlCallQualityState:I

    if-eq v1, v2, :cond_2

    .line 125
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mDlSnapshots:Ljava/util/ArrayList;

    invoke-direct {p0, p1, v2}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->addSnapshot(Landroid/telephony/CallQuality;Ljava/util/ArrayList;)V

    .line 129
    :cond_2
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->updateTotalDurations(Landroid/telephony/CallQuality;)V

    .line 131
    invoke-direct {p0, v1, v0, p1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->updateMinAndMaxSignalStrengthSnapshots(IILandroid/telephony/CallQuality;)V

    .line 133
    iput v0, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mUlCallQualityState:I

    .line 134
    iput v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mDlCallQualityState:I

    .line 136
    invoke-virtual {p1}, Landroid/telephony/CallQuality;->getCallDuration()I

    move-result v0

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mLastCallQuality:Landroid/telephony/CallQuality;

    invoke-virtual {v1}, Landroid/telephony/CallQuality;->getCallDuration()I

    move-result v1

    if-le v0, v1, :cond_3

    .line 137
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mLastCallQuality:Landroid/telephony/CallQuality;

    :cond_3
    :goto_0
    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 7

    .line 384
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[CallQualityMetrics phone "

    .line 385
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 386
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " mUlSnapshots: {"

    .line 387
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 388
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mUlSnapshots:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    const-string v3, " ss="

    const-string v4, " {cq="

    const-string/jumbo v5, "}"

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/util/Pair;

    .line 389
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 390
    iget-object v4, v2, Landroid/util/Pair;->first:Ljava/lang/Object;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 391
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 392
    iget-object v2, v2, Landroid/util/Pair;->second:Ljava/lang/Object;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 393
    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_0

    .line 395
    :cond_0
    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " mDlSnapshots:{"

    .line 396
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 397
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mDlSnapshots:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_1
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/util/Pair;

    .line 398
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 399
    iget-object v6, v2, Landroid/util/Pair;->first:Ljava/lang/Object;

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 400
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 401
    iget-object v2, v2, Landroid/util/Pair;->second:Ljava/lang/Object;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 402
    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_1

    .line 404
    :cond_1
    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " "

    .line 405
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 406
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mFullDownlinkQuality:Ljava/util/ArrayList;

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->getTotalGoodAndBadQualityTimeMs(Ljava/util/ArrayList;)Landroid/util/Pair;

    move-result-object v1

    .line 407
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->mFullUplinkQuality:Ljava/util/ArrayList;

    invoke-direct {p0, v2}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->getTotalGoodAndBadQualityTimeMs(Ljava/util/ArrayList;)Landroid/util/Pair;

    move-result-object p0

    const-string v2, " TotalDlGoodQualityTimeMs: "

    .line 408
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 409
    iget-object v2, v1, Landroid/util/Pair;->first:Ljava/lang/Object;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, " TotalDlBadQualityTimeMs: "

    .line 410
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 411
    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " TotalUlGoodQualityTimeMs: "

    .line 412
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 413
    iget-object v1, p0, Landroid/util/Pair;->first:Ljava/lang/Object;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " TotalUlBadQualityTimeMs: "

    .line 414
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 415
    iget-object p0, p0, Landroid/util/Pair;->second:Ljava/lang/Object;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p0, "]"

    .line 416
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 417
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
