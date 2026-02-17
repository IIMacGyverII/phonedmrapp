.class public Lcom/android/internal/telephony/dataconnection/DcRequest;
.super Ljava/lang/Object;
.source "DcRequest.java"

# interfaces
.implements Ljava/lang/Comparable;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/lang/Comparable<",
        "Lcom/android/internal/telephony/dataconnection/DcRequest;",
        ">;"
    }
.end annotation


# static fields
.field private static final LOG_TAG:Ljava/lang/String; = "DcRequest"


# instance fields
.field public final apnType:I

.field public final networkRequest:Landroid/net/NetworkRequest;

.field public final priority:I


# direct methods
.method private constructor <init>(Landroid/net/NetworkRequest;II)V
    .locals 0

    .line 39
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 40
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcRequest;->networkRequest:Landroid/net/NetworkRequest;

    .line 41
    iput p3, p0, Lcom/android/internal/telephony/dataconnection/DcRequest;->priority:I

    .line 42
    iput p2, p0, Lcom/android/internal/telephony/dataconnection/DcRequest;->apnType:I

    return-void
.end method

.method private static checkForAnomalousNetworkRequest(Landroid/net/NetworkRequest;)V
    .locals 1

    .line 69
    invoke-virtual {p0}, Landroid/net/NetworkRequest;->getNetworkSpecifier()Landroid/net/NetworkSpecifier;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 71
    instance-of v0, v0, Landroid/net/TelephonyNetworkSpecifier;

    if-eqz v0, :cond_0

    .line 72
    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DcRequest;->reportAnomalousNetworkRequest(Landroid/net/NetworkRequest;)V

    :cond_0
    return-void
.end method

.method public static create(Landroid/net/NetworkRequest;Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;)Lcom/android/internal/telephony/dataconnection/DcRequest;
    .locals 4

    .line 56
    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnTypeFromNetworkRequest(Landroid/net/NetworkRequest;)I

    move-result v0

    .line 57
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->getByType(I)Lcom/android/internal/telephony/dataconnection/ApnConfigType;

    move-result-object p1

    const-string v1, "DcRequest"

    if-nez p1, :cond_0

    .line 59
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Non cellular request ignored: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/net/NetworkRequest;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 60
    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DcRequest;->checkForAnomalousNetworkRequest(Landroid/net/NetworkRequest;)V

    const/4 p0, 0x0

    return-object p0

    .line 63
    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Cellular request confirmed: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/net/NetworkRequest;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 64
    new-instance v1, Lcom/android/internal/telephony/dataconnection/DcRequest;

    invoke-virtual {p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigType;->getPriority()I

    move-result p1

    invoke-direct {v1, p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DcRequest;-><init>(Landroid/net/NetworkRequest;II)V

    return-object v1
.end method

.method private static reportAnomalousNetworkRequest(Landroid/net/NetworkRequest;)V
    .locals 2

    .line 79
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "A TelephonyNetworkSpecifier for a non-cellular request is invalid: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 80
    invoke-virtual {p0}, Landroid/net/NetworkRequest;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "DcRequest"

    .line 79
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method public compareTo(Lcom/android/internal/telephony/dataconnection/DcRequest;)I
    .locals 0

    .line 100
    iget p1, p1, Lcom/android/internal/telephony/dataconnection/DcRequest;->priority:I

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DcRequest;->priority:I

    sub-int/2addr p1, p0

    return p1
.end method

.method public bridge synthetic compareTo(Ljava/lang/Object;)I
    .locals 0

    .line 30
    check-cast p1, Lcom/android/internal/telephony/dataconnection/DcRequest;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcRequest;->compareTo(Lcom/android/internal/telephony/dataconnection/DcRequest;)I

    move-result p0

    return p0
.end method

.method public equals(Ljava/lang/Object;)Z
    .locals 1

    .line 93
    instance-of v0, p1, Lcom/android/internal/telephony/dataconnection/DcRequest;

    if-eqz v0, :cond_0

    .line 94
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcRequest;->networkRequest:Landroid/net/NetworkRequest;

    check-cast p1, Lcom/android/internal/telephony/dataconnection/DcRequest;

    iget-object p1, p1, Lcom/android/internal/telephony/dataconnection/DcRequest;->networkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {p0, p1}, Landroid/net/NetworkRequest;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public hashCode()I
    .locals 0

    .line 89
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcRequest;->networkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {p0}, Landroid/net/NetworkRequest;->hashCode()I

    move-result p0

    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 85
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcRequest;->networkRequest:Landroid/net/NetworkRequest;

    invoke-virtual {v1}, Landroid/net/NetworkRequest;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", priority="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DcRequest;->priority:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", apnType="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DcRequest;->apnType:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
