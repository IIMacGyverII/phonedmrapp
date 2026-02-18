.class Lcom/android/internal/telephony/uicc/AdnCapacity$1;
.super Ljava/lang/Object;
.source "AdnCapacity.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/uicc/AdnCapacity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/android/internal/telephony/uicc/AdnCapacity;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 114
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/android/internal/telephony/uicc/AdnCapacity;
    .locals 11

    .line 117
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    .line 118
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v2

    .line 119
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v3

    .line 120
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v4

    .line 121
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v5

    .line 122
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v6

    .line 123
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v7

    .line 124
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v8

    .line 125
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v9

    .line 126
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v10

    .line 127
    new-instance p0, Lcom/android/internal/telephony/uicc/AdnCapacity;

    move-object v0, p0

    invoke-direct/range {v0 .. v10}, Lcom/android/internal/telephony/uicc/AdnCapacity;-><init>(IIIIIIIIII)V

    return-object p0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 114
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/AdnCapacity$1;->createFromParcel(Landroid/os/Parcel;)Lcom/android/internal/telephony/uicc/AdnCapacity;

    move-result-object p0

    return-object p0
.end method

.method public newArray(I)[Lcom/android/internal/telephony/uicc/AdnCapacity;
    .locals 0

    .line 134
    new-array p0, p1, [Lcom/android/internal/telephony/uicc/AdnCapacity;

    return-object p0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 114
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/AdnCapacity$1;->newArray(I)[Lcom/android/internal/telephony/uicc/AdnCapacity;

    move-result-object p0

    return-object p0
.end method
