.class final Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;
.super Ljava/lang/Object;
.source "CarrierPrivilegesTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/CarrierPrivilegesTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "PrivilegedPackageInfo"
.end annotation


# instance fields
.field final mCarrierService:Landroid/util/Pair;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/Pair<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field final mPackageNames:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field final mUids:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$r7jNJWT4UJwxTBk7Mzii1ytQb2M(Ljava/lang/String;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->lambda$toString$0(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method constructor <init>()V
    .locals 3

    .line 246
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 247
    invoke-static {}, Ljava/util/Collections;->emptySet()Ljava/util/Set;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mPackageNames:Ljava/util/Set;

    .line 248
    invoke-static {}, Ljava/util/Collections;->emptySet()Ljava/util/Set;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mUids:Ljava/util/Set;

    .line 249
    new-instance v0, Landroid/util/Pair;

    const/4 v1, -0x1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x0

    invoke-direct {v0, v2, v1}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mCarrierService:Landroid/util/Pair;

    return-void
.end method

.method constructor <init>(Ljava/util/Set;Ljava/util/Set;Landroid/util/Pair;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;",
            "Landroid/util/Pair<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;)V"
        }
    .end annotation

    .line 253
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 254
    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mPackageNames:Ljava/util/Set;

    .line 255
    iput-object p2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mUids:Ljava/util/Set;

    .line 256
    iput-object p3, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mCarrierService:Landroid/util/Pair;

    return-void
.end method

.method private static synthetic lambda$toString$0(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 262
    invoke-static {}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->-$$Nest$sfgetTAG()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->pii(Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method


# virtual methods
.method public equals(Ljava/lang/Object;)Z
    .locals 4

    const/4 v0, 0x1

    if-ne p0, p1, :cond_0

    return v0

    .line 277
    :cond_0
    instance-of v1, p1, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    const/4 v2, 0x0

    if-nez v1, :cond_1

    return v2

    .line 280
    :cond_1
    check-cast p1, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    .line 281
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mPackageNames:Ljava/util/Set;

    iget-object v3, p1, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mPackageNames:Ljava/util/Set;

    invoke-interface {v1, v3}, Ljava/util/Set;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mUids:Ljava/util/Set;

    iget-object v3, p1, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mUids:Ljava/util/Set;

    invoke-interface {v1, v3}, Ljava/util/Set;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mCarrierService:Landroid/util/Pair;

    iget-object p1, p1, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mCarrierService:Landroid/util/Pair;

    .line 282
    invoke-virtual {p0, p1}, Landroid/util/Pair;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_2

    goto :goto_0

    :cond_2
    move v0, v2

    :goto_0
    return v0
.end method

.method public hashCode()I
    .locals 3

    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/Object;

    .line 287
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mPackageNames:Ljava/util/Set;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mUids:Ljava/util/Set;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mCarrierService:Landroid/util/Pair;

    const/4 v1, 0x2

    aput-object p0, v0, v1

    invoke-static {v0}, Ljava/util/Objects;->hash([Ljava/lang/Object;)I

    move-result p0

    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 261
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "{packageNames="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mPackageNames:Ljava/util/Set;

    new-instance v2, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo$$ExternalSyntheticLambda0;

    invoke-direct {v2}, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo$$ExternalSyntheticLambda0;-><init>()V

    .line 262
    invoke-static {v1, v2}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->-$$Nest$smgetObfuscatedPackages(Ljava/util/Collection;Ljava/util/function/Function;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", uids="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mUids:Ljava/util/Set;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", carrierServicePackageName="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->-$$Nest$sfgetTAG()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mCarrierService:Landroid/util/Pair;

    iget-object v2, v2, Landroid/util/Pair;->first:Ljava/lang/Object;

    .line 266
    invoke-static {v1, v2}, Lcom/android/telephony/Rlog;->pii(Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", carrierServiceUid="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mCarrierService:Landroid/util/Pair;

    iget-object p0, p0, Landroid/util/Pair;->second:Ljava/lang/Object;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string/jumbo p0, "}"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
