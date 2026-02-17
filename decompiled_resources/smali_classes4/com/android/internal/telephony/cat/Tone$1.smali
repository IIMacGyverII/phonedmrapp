.class Lcom/android/internal/telephony/cat/Tone$1;
.super Ljava/lang/Object;
.source "Tone.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/cat/Tone;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/android/internal/telephony/cat/Tone;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 183
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/android/internal/telephony/cat/Tone;
    .locals 0

    .line 186
    invoke-static {}, Lcom/android/internal/telephony/cat/Tone;->values()[Lcom/android/internal/telephony/cat/Tone;

    move-result-object p0

    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result p1

    aget-object p0, p0, p1

    return-object p0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 183
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/cat/Tone$1;->createFromParcel(Landroid/os/Parcel;)Lcom/android/internal/telephony/cat/Tone;

    move-result-object p0

    return-object p0
.end method

.method public newArray(I)[Lcom/android/internal/telephony/cat/Tone;
    .locals 0

    .line 191
    new-array p0, p1, [Lcom/android/internal/telephony/cat/Tone;

    return-object p0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 183
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/cat/Tone$1;->newArray(I)[Lcom/android/internal/telephony/cat/Tone;

    move-result-object p0

    return-object p0
.end method
