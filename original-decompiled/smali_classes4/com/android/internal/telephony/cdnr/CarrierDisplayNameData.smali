.class public Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;
.super Ljava/lang/Object;
.source "CarrierDisplayNameData.java"

# interfaces
.implements Landroid/os/Parcelable;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;
    }
.end annotation


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private final mDataSpn:Ljava/lang/String;

.field private final mPlmn:Ljava/lang/String;

.field private final mShowPlmn:Z

.field private final mShowSpn:Z

.field private final mSpn:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 120
    new-instance v0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$1;

    invoke-direct {v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$1;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method private constructor <init>(Landroid/os/Parcel;)V
    .locals 1

    .line 112
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 113
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mSpn:Ljava/lang/String;

    .line 114
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mDataSpn:Ljava/lang/String;

    .line 115
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mPlmn:Ljava/lang/String;

    .line 116
    invoke-virtual {p1}, Landroid/os/Parcel;->readBoolean()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowSpn:Z

    .line 117
    invoke-virtual {p1}, Landroid/os/Parcel;->readBoolean()Z

    move-result p1

    iput-boolean p1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowPlmn:Z

    return-void
.end method

.method synthetic constructor <init>(Landroid/os/Parcel;Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;-><init>(Landroid/os/Parcel;)V

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;Z)V
    .locals 0

    .line 44
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 45
    iput-object p1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mSpn:Ljava/lang/String;

    .line 46
    iput-object p2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mDataSpn:Ljava/lang/String;

    .line 47
    iput-boolean p3, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowSpn:Z

    .line 48
    iput-object p4, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mPlmn:Ljava/lang/String;

    .line 49
    iput-boolean p5, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowPlmn:Z

    return-void
.end method

.method synthetic constructor <init>(Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;ZLcom/android/internal/telephony/cdnr/CarrierDisplayNameData-IA;)V
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;-><init>(Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;Z)V

    return-void
.end method


# virtual methods
.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public equals(Ljava/lang/Object;)Z
    .locals 4

    const/4 v0, 0x1

    if-ne p0, p1, :cond_0

    return v0

    :cond_0
    const/4 v1, 0x0

    if-eqz p1, :cond_3

    .line 136
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    if-eq v2, v3, :cond_1

    goto :goto_1

    .line 137
    :cond_1
    check-cast p1, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    .line 138
    iget-boolean v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowSpn:Z

    iget-boolean v3, p1, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowSpn:Z

    if-ne v2, v3, :cond_2

    iget-boolean v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowPlmn:Z

    iget-boolean v3, p1, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowPlmn:Z

    if-ne v2, v3, :cond_2

    iget-object v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mSpn:Ljava/lang/String;

    iget-object v3, p1, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mSpn:Ljava/lang/String;

    .line 140
    invoke-static {v2, v3}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    iget-object v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mDataSpn:Ljava/lang/String;

    iget-object v3, p1, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mDataSpn:Ljava/lang/String;

    .line 141
    invoke-static {v2, v3}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mPlmn:Ljava/lang/String;

    iget-object p1, p1, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mPlmn:Ljava/lang/String;

    .line 142
    invoke-static {p0, p1}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_2

    goto :goto_0

    :cond_2
    move v0, v1

    :goto_0
    return v0

    :cond_3
    :goto_1
    return v1
.end method

.method public getDataSpn()Ljava/lang/String;
    .locals 0

    .line 65
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mDataSpn:Ljava/lang/String;

    return-object p0
.end method

.method public getPlmn()Ljava/lang/String;
    .locals 0

    .line 73
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mPlmn:Ljava/lang/String;

    return-object p0
.end method

.method public getSpn()Ljava/lang/String;
    .locals 0

    .line 57
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mSpn:Ljava/lang/String;

    return-object p0
.end method

.method public hashCode()I
    .locals 3

    const/4 v0, 0x5

    new-array v0, v0, [Ljava/lang/Object;

    .line 147
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mSpn:Ljava/lang/String;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mDataSpn:Ljava/lang/String;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mPlmn:Ljava/lang/String;

    const/4 v2, 0x2

    aput-object v1, v0, v2

    iget-boolean v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowSpn:Z

    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    const/4 v2, 0x3

    aput-object v1, v0, v2

    iget-boolean p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowPlmn:Z

    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    const/4 v1, 0x4

    aput-object p0, v0, v1

    invoke-static {v0}, Ljava/util/Objects;->hash([Ljava/lang/Object;)I

    move-result p0

    return p0
.end method

.method public shouldShowPlmn()Z
    .locals 0

    .line 89
    iget-boolean p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowPlmn:Z

    return p0
.end method

.method public shouldShowSpn()Z
    .locals 0

    .line 81
    iget-boolean p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowSpn:Z

    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    const/4 v0, 0x5

    new-array v0, v0, [Ljava/lang/Object;

    .line 94
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mSpn:Ljava/lang/String;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mDataSpn:Ljava/lang/String;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    iget-boolean v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowSpn:Z

    .line 95
    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    const/4 v2, 0x2

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mPlmn:Ljava/lang/String;

    const/4 v2, 0x3

    aput-object v1, v0, v2

    iget-boolean p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowPlmn:Z

    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    const/4 v1, 0x4

    aput-object p0, v0, v1

    const-string/jumbo p0, "{ spn = %s, dataSpn = %s, showSpn = %b, plmn = %s, showPlmn = %b"

    .line 94
    invoke-static {p0, v0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 0

    .line 105
    iget-object p2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mSpn:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 106
    iget-object p2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mDataSpn:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 107
    iget-object p2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mPlmn:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 108
    iget-boolean p2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowSpn:Z

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeBoolean(Z)V

    .line 109
    iget-boolean p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->mShowPlmn:Z

    invoke-virtual {p1, p0}, Landroid/os/Parcel;->writeBoolean(Z)V

    return-void
.end method
