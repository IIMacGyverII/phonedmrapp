.class public interface abstract Lcom/android/internal/telephony/cdnr/EfData;
.super Ljava/lang/Object;
.source "EfData.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/cdnr/EfData$EFSource;
    }
.end annotation


# static fields
.field public static final EF_SOURCE_CARRIER_API:I = 0x2

.field public static final EF_SOURCE_CARRIER_CONFIG:I = 0x1

.field public static final EF_SOURCE_CSIM:I = 0x5

.field public static final EF_SOURCE_DATA_OPERATOR_SIGNALLING:I = 0x8

.field public static final EF_SOURCE_ERI:I = 0xa

.field public static final EF_SOURCE_MODEM_CONFIG:I = 0x9

.field public static final EF_SOURCE_RUIM:I = 0x6

.field public static final EF_SOURCE_SIM:I = 0x4

.field public static final EF_SOURCE_USIM:I = 0x3

.field public static final EF_SOURCE_VOICE_OPERATOR_SIGNALLING:I = 0x7


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

    const/4 p0, 0x0

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
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;",
            ">;"
        }
    .end annotation

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

    const/4 p0, 0x0

    return-object p0
.end method

.method public getServiceProviderName()Ljava/lang/String;
    .locals 0

    const/4 p0, 0x0

    return-object p0
.end method

.method public getServiceProviderNameDisplayCondition(Z)I
    .locals 0

    const/4 p0, -0x1

    return p0
.end method
