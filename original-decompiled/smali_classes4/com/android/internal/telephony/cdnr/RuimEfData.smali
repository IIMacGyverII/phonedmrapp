.class public final Lcom/android/internal/telephony/cdnr/RuimEfData;
.super Ljava/lang/Object;
.source "RuimEfData.java"

# interfaces
.implements Lcom/android/internal/telephony/cdnr/EfData;


# static fields
.field private static final DEFAULT_CARRIER_NAME_DISPLAY_CONDITION_BITMASK:I


# instance fields
.field private final mRuim:Lcom/android/internal/telephony/uicc/RuimRecords;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/uicc/RuimRecords;)V
    .locals 0

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 31
    iput-object p1, p0, Lcom/android/internal/telephony/cdnr/RuimEfData;->mRuim:Lcom/android/internal/telephony/uicc/RuimRecords;

    return-void
.end method


# virtual methods
.method public getServiceProviderName()Ljava/lang/String;
    .locals 1

    .line 36
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/RuimEfData;->mRuim:Lcom/android/internal/telephony/uicc/RuimRecords;

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getServiceProviderName()Ljava/lang/String;

    move-result-object p0

    .line 37
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x0

    :cond_0
    return-object p0
.end method

.method public getServiceProviderNameDisplayCondition(Z)I
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/RuimEfData;->mRuim:Lcom/android/internal/telephony/uicc/RuimRecords;

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/RuimRecords;->getCsimSpnDisplayCondition()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x2

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method
