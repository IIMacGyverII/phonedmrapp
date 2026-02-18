.class Lcom/android/internal/telephony/data/KeepaliveStatus$1;
.super Ljava/lang/Object;
.source "KeepaliveStatus.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/KeepaliveStatus;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/android/internal/telephony/data/KeepaliveStatus;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 101
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/android/internal/telephony/data/KeepaliveStatus;
    .locals 1

    .line 104
    new-instance p0, Lcom/android/internal/telephony/data/KeepaliveStatus;

    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/data/KeepaliveStatus;-><init>(Landroid/os/Parcel;Lcom/android/internal/telephony/data/KeepaliveStatus-IA;)V

    return-object p0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 101
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/KeepaliveStatus$1;->createFromParcel(Landroid/os/Parcel;)Lcom/android/internal/telephony/data/KeepaliveStatus;

    move-result-object p0

    return-object p0
.end method

.method public newArray(I)[Lcom/android/internal/telephony/data/KeepaliveStatus;
    .locals 0

    .line 109
    new-array p0, p1, [Lcom/android/internal/telephony/data/KeepaliveStatus;

    return-object p0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 101
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/KeepaliveStatus$1;->newArray(I)[Lcom/android/internal/telephony/data/KeepaliveStatus;

    move-result-object p0

    return-object p0
.end method
