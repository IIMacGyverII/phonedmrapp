.class public final Lcom/android/internal/telephony/cdnr/UsimEfData;
.super Ljava/lang/Object;
.source "UsimEfData.java"

# interfaces
.implements Lcom/android/internal/telephony/cdnr/EfData;


# instance fields
.field private final mUsim:Lcom/android/internal/telephony/uicc/SIMRecords;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/uicc/SIMRecords;)V
    .locals 0

    .line 33
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 34
    iput-object p1, p0, Lcom/android/internal/telephony/cdnr/UsimEfData;->mUsim:Lcom/android/internal/telephony/uicc/SIMRecords;

    return-void
.end method


# virtual methods
.method public getEhplmnList()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 65
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/UsimEfData;->mUsim:Lcom/android/internal/telephony/uicc/SIMRecords;

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getEhplmns()[Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 66
    invoke-static {p0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public getOperatorPlmnList()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/IccRecords$OperatorPlmnInfo;",
            ">;"
        }
    .end annotation

    const/4 p0, 0x0

    return-object p0
.end method

.method public getPlmnNetworkNameList()Ljava/util/List;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;",
            ">;"
        }
    .end annotation

    .line 71
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/UsimEfData;->mUsim:Lcom/android/internal/telephony/uicc/SIMRecords;

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getPnnHomeName()Ljava/lang/String;

    move-result-object p0

    .line 72
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, 0x1

    new-array v0, v0, [Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;

    const/4 v1, 0x0

    .line 75
    new-instance v2, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;

    const-string v3, ""

    invoke-direct {v2, p0, v3}, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    aput-object v2, v0, v1

    invoke-static {v0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method public getServiceProviderDisplayInformation()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 59
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/UsimEfData;->mUsim:Lcom/android/internal/telephony/uicc/SIMRecords;

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getServiceProviderDisplayInformation()[Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 60
    invoke-static {p0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public getServiceProviderName()Ljava/lang/String;
    .locals 1

    .line 39
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/UsimEfData;->mUsim:Lcom/android/internal/telephony/uicc/SIMRecords;

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getServiceProviderName()Ljava/lang/String;

    move-result-object p0

    .line 40
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x0

    :cond_0
    return-object p0
.end method

.method public getServiceProviderNameDisplayCondition(Z)I
    .locals 0

    if-eqz p1, :cond_0

    .line 48
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/UsimEfData;->mUsim:Lcom/android/internal/telephony/uicc/SIMRecords;

    .line 49
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/SIMRecords;->getCarrierNameDisplayCondition()I

    move-result p0

    or-int/lit8 p0, p0, 0x1

    return p0

    .line 52
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/UsimEfData;->mUsim:Lcom/android/internal/telephony/uicc/SIMRecords;

    .line 53
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/SIMRecords;->getCarrierNameDisplayCondition()I

    move-result p0

    or-int/lit8 p0, p0, 0x2

    return p0
.end method
