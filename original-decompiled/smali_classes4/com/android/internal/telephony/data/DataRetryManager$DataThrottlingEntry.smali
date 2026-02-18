.class public Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;
.super Ljava/lang/Object;
.source "DataRetryManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataRetryManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "DataThrottlingEntry"
.end annotation


# instance fields
.field public final dataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

.field public final dataProfile:Landroid/telephony/data/DataProfile;

.field public final expirationTimeMillis:J

.field public final networkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

.field public final retryType:I
    .annotation build Landroid/telephony/data/ThrottleStatus$RetryType;
    .end annotation
.end field

.field public final transport:I


# direct methods
.method public constructor <init>(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;Lcom/android/internal/telephony/data/DataNetwork;IIJ)V
    .locals 0
    .param p5    # I
        .annotation build Landroid/telephony/data/ThrottleStatus$RetryType;
        .end annotation
    .end param

    .line 229
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 230
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataProfile:Landroid/telephony/data/DataProfile;

    .line 231
    iput-object p2, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->networkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    .line 232
    iput-object p3, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    .line 233
    iput p4, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->transport:I

    .line 234
    iput p5, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->retryType:I

    .line 235
    iput-wide p6, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->expirationTimeMillis:J

    return-void
.end method


# virtual methods
.method public toString()Ljava/lang/String;
    .locals 3

    .line 240
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[DataThrottlingEntry: dataProfile="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", request list="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->networkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", dataNetwork="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", transport="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->transport:I

    .line 242
    invoke-static {v1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", expiration time="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->expirationTimeMillis:J

    .line 243
    invoke-static {v1, v2}, Lcom/android/internal/telephony/data/DataUtils;->elapsedTimeToString(J)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "]"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
