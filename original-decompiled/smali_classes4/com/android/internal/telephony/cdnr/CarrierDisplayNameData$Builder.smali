.class public final Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;
.super Ljava/lang/Object;
.source "CarrierDisplayNameData.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Builder"
.end annotation


# instance fields
.field private mDataSpn:Ljava/lang/String;

.field private mPlmn:Ljava/lang/String;

.field private mShowPlmn:Z

.field private mShowSpn:Z

.field private mSpn:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 158
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 159
    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mSpn:Ljava/lang/String;

    .line 160
    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mDataSpn:Ljava/lang/String;

    .line 161
    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mPlmn:Ljava/lang/String;

    const/4 v0, 0x0

    .line 162
    iput-boolean v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mShowPlmn:Z

    .line 163
    iput-boolean v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mShowSpn:Z

    return-void
.end method


# virtual methods
.method public build()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;
    .locals 8

    .line 168
    new-instance v7, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mSpn:Ljava/lang/String;

    iget-object v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mDataSpn:Ljava/lang/String;

    iget-boolean v3, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mShowSpn:Z

    iget-object v4, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mPlmn:Ljava/lang/String;

    iget-boolean v5, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mShowPlmn:Z

    const/4 v6, 0x0

    move-object v0, v7

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;-><init>(Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;ZLcom/android/internal/telephony/cdnr/CarrierDisplayNameData-IA;)V

    return-object v7
.end method

.method public setDataSpn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;
    .locals 0

    .line 179
    iput-object p1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mDataSpn:Ljava/lang/String;

    return-object p0
.end method

.method public setPlmn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;
    .locals 0

    .line 185
    iput-object p1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mPlmn:Ljava/lang/String;

    return-object p0
.end method

.method public setShowPlmn(Z)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;
    .locals 0

    .line 197
    iput-boolean p1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mShowPlmn:Z

    return-object p0
.end method

.method public setShowSpn(Z)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;
    .locals 0

    .line 191
    iput-boolean p1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mShowSpn:Z

    return-object p0
.end method

.method public setSpn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;
    .locals 0

    .line 173
    iput-object p1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->mSpn:Ljava/lang/String;

    return-object p0
.end method
