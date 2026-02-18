.class Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags$LastFeatureTagState;
.super Ljava/lang/Object;
.source "RcsStats.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "LastFeatureTagState"
.end annotation


# instance fields
.field public carrierId:I

.field public reason:I

.field public slotId:I

.field public state:I

.field final synthetic this$1:Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags;

.field public timeStamp:J


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags;IIIIJ)V
    .locals 0

    .line 414
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags$LastFeatureTagState;->this$1:Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 415
    iput p2, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags$LastFeatureTagState;->carrierId:I

    .line 416
    iput p3, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags$LastFeatureTagState;->slotId:I

    .line 417
    iput p4, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags$LastFeatureTagState;->state:I

    .line 418
    iput p5, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags$LastFeatureTagState;->reason:I

    .line 419
    iput-wide p6, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags$LastFeatureTagState;->timeStamp:J

    return-void
.end method


# virtual methods
.method public update(IIJ)V
    .locals 0

    .line 423
    iput p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags$LastFeatureTagState;->state:I

    .line 424
    iput p2, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags$LastFeatureTagState;->reason:I

    .line 425
    iput-wide p3, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags$LastFeatureTagState;->timeStamp:J

    return-void
.end method

.method public update(J)V
    .locals 0

    .line 429
    iput-wide p1, p0, Lcom/android/internal/telephony/metrics/RcsStats$SipTransportFeatureTags$LastFeatureTagState;->timeStamp:J

    return-void
.end method
