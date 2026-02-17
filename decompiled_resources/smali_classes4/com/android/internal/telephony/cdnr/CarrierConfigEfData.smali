.class public final Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;
.super Ljava/lang/Object;
.source "CarrierConfigEfData.java"

# interfaces
.implements Lcom/android/internal/telephony/cdnr/EfData;


# static fields
.field private static final TAG:Ljava/lang/String; = "CarrierConfigEfData"


# instance fields
.field private final mEhplmn:[Ljava/lang/String;

.field private final mOpl:[Ljava/lang/String;

.field private final mPnn:[Ljava/lang/String;

.field private final mSpdi:[Ljava/lang/String;

.field private final mSpn:Ljava/lang/String;

.field private final mSpnDisplayCondition:I


# direct methods
.method public constructor <init>(Landroid/os/PersistableBundle;)V
    .locals 2

    .line 44
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-string v0, "carrier_name_string"

    .line 46
    invoke-virtual {p1, v0}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mSpn:Ljava/lang/String;

    const-string/jumbo v0, "spn_display_condition_override_int"

    const/4 v1, -0x1

    .line 47
    invoke-virtual {p1, v0, v1}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;I)I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mSpnDisplayCondition:I

    const-string/jumbo v0, "spdi_override_string_array"

    .line 50
    invoke-virtual {p1, v0}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mSpdi:[Ljava/lang/String;

    const-string v0, "ehplmn_override_string_array"

    .line 51
    invoke-virtual {p1, v0}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mEhplmn:[Ljava/lang/String;

    const-string v0, "pnn_override_string_array"

    .line 52
    invoke-virtual {p1, v0}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mPnn:[Ljava/lang/String;

    const-string v0, "opl_override_opl_string_array"

    .line 53
    invoke-virtual {p1, v0}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mOpl:[Ljava/lang/String;

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

    .line 73
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mEhplmn:[Ljava/lang/String;

    if-eqz p0, :cond_0

    invoke-static {p0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public getOperatorPlmnList()Ljava/util/List;
    .locals 11
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/IccRecords$OperatorPlmnInfo;",
            ">;"
        }
    .end annotation

    .line 98
    iget-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mOpl:[Ljava/lang/String;

    if-eqz v0, :cond_0

    .line 99
    new-instance v0, Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mOpl:[Ljava/lang/String;

    array-length v1, v1

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 100
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mOpl:[Ljava/lang/String;

    array-length v1, p0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_1

    aget-object v4, p0, v3

    :try_start_0
    const-string v5, "\\s*,\\s*"

    .line 102
    invoke-virtual {v4, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v5

    .line 103
    new-instance v6, Lcom/android/internal/telephony/uicc/IccRecords$OperatorPlmnInfo;

    aget-object v7, v5, v2

    const/4 v8, 0x1

    aget-object v8, v5, v8

    .line 105
    invoke-static {v8}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v8

    const/4 v9, 0x2

    aget-object v9, v5, v9

    .line 106
    invoke-static {v9}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v9

    const/4 v10, 0x3

    aget-object v5, v5, v10

    .line 107
    invoke-static {v5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v5

    invoke-direct {v6, v7, v8, v9, v5}, Lcom/android/internal/telephony/uicc/IccRecords$OperatorPlmnInfo;-><init>(Ljava/lang/String;III)V

    .line 103
    invoke-interface {v0, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    .line 109
    :catch_0
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "CarrierConfig wrong opl format, oplStr = "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    const-string v5, "CarrierConfigEfData"

    invoke-static {v5, v4}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :cond_1
    return-object v0
.end method

.method public getPlmnNetworkNameList()Ljava/util/List;
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;",
            ">;"
        }
    .end annotation

    .line 79
    iget-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mPnn:[Ljava/lang/String;

    if-eqz v0, :cond_1

    .line 80
    new-instance v0, Ljava/util/ArrayList;

    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mPnn:[Ljava/lang/String;

    array-length v1, v1

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 81
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mPnn:[Ljava/lang/String;

    array-length v1, p0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_2

    aget-object v4, p0, v3

    :try_start_0
    const-string v5, "\\s*,\\s*"

    .line 83
    invoke-virtual {v4, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v5

    .line 84
    aget-object v6, v5, v2

    .line 85
    array-length v7, v5

    const/4 v8, 0x1

    if-le v7, v8, :cond_0

    aget-object v5, v5, v8

    goto :goto_1

    :cond_0
    const-string v5, ""

    .line 86
    :goto_1
    new-instance v7, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;

    invoke-direct {v7, v6, v5}, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-interface {v0, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    .line 88
    :catch_0
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "CarrierConfig wrong pnn format, pnnStr = "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    const-string v5, "CarrierConfigEfData"

    invoke-static {v5, v4}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_2
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    :cond_2
    return-object v0
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

    .line 68
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mSpdi:[Ljava/lang/String;

    if-eqz p0, :cond_0

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

    .line 58
    iget-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mSpn:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mSpn:Ljava/lang/String;

    :goto_0
    return-object p0
.end method

.method public getServiceProviderNameDisplayCondition(Z)I
    .locals 0

    .line 63
    iget p0, p0, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;->mSpnDisplayCondition:I

    return p0
.end method
