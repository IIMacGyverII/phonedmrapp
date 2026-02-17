.class public final Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;
.super Ljava/lang/Object;
.source "IccRecords.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/uicc/IccRecords;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "PlmnNetworkName"
.end annotation


# instance fields
.field public final fullName:Ljava/lang/String;

.field public final shortName:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 1502
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 1503
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->fullName:Ljava/lang/String;

    .line 1504
    iput-object p2, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->shortName:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public equals(Ljava/lang/Object;)Z
    .locals 4

    const/4 v0, 0x1

    if-ne p0, p1, :cond_0

    return v0

    .line 1527
    :cond_0
    instance-of v1, p1, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;

    const/4 v2, 0x0

    if-nez v1, :cond_1

    return v2

    .line 1529
    :cond_1
    check-cast p1, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;

    .line 1530
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->fullName:Ljava/lang/String;

    iget-object v3, p1, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->fullName:Ljava/lang/String;

    invoke-static {v1, v3}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_2

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->shortName:Ljava/lang/String;

    iget-object p1, p1, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->shortName:Ljava/lang/String;

    .line 1531
    invoke-static {p0, p1}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_2

    goto :goto_0

    :cond_2
    move v0, v2

    :goto_0
    return v0
.end method

.method public getName()Ljava/lang/String;
    .locals 1

    .line 1512
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->fullName:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1513
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->fullName:Ljava/lang/String;

    return-object p0

    .line 1515
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->shortName:Ljava/lang/String;

    return-object p0
.end method

.method public hashCode()I
    .locals 3

    const/4 v0, 0x2

    new-array v0, v0, [Ljava/lang/Object;

    .line 1521
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->fullName:Ljava/lang/String;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->shortName:Ljava/lang/String;

    const/4 v1, 0x1

    aput-object p0, v0, v1

    invoke-static {v0}, Ljava/util/Objects;->hash([Ljava/lang/Object;)I

    move-result p0

    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 1536
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "{fullName = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->fullName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", shortName = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->shortName:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string/jumbo p0, "}"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
