.class final Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;
.super Ljava/lang/Object;
.source "CellularNetworkValidator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "ValidatedNetwork"
.end annotation


# instance fields
.field final mValidationIdentity:Ljava/lang/String;

.field mValidationTimeStamp:J

.field final synthetic this$1:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;Ljava/lang/String;J)V
    .locals 0

    .line 110
    iput-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;->this$1:Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 111
    iput-object p2, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;->mValidationIdentity:Ljava/lang/String;

    .line 112
    iput-wide p3, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;->mValidationTimeStamp:J

    return-void
.end method


# virtual methods
.method update(J)V
    .locals 0

    .line 115
    iput-wide p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;->mValidationTimeStamp:J

    return-void
.end method
