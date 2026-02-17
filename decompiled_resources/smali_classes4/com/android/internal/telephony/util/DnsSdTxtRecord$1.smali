.class Lcom/android/internal/telephony/util/DnsSdTxtRecord$1;
.super Ljava/lang/Object;
.source "DnsSdTxtRecord.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/util/DnsSdTxtRecord;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/android/internal/telephony/util/DnsSdTxtRecord;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 314
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/android/internal/telephony/util/DnsSdTxtRecord;
    .locals 1

    .line 316
    new-instance p0, Lcom/android/internal/telephony/util/DnsSdTxtRecord;

    invoke-direct {p0}, Lcom/android/internal/telephony/util/DnsSdTxtRecord;-><init>()V

    .line 317
    invoke-static {p0}, Lcom/android/internal/telephony/util/DnsSdTxtRecord;->-$$Nest$fgetmData(Lcom/android/internal/telephony/util/DnsSdTxtRecord;)[B

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/os/Parcel;->readByteArray([B)V

    return-object p0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 314
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/util/DnsSdTxtRecord$1;->createFromParcel(Landroid/os/Parcel;)Lcom/android/internal/telephony/util/DnsSdTxtRecord;

    move-result-object p0

    return-object p0
.end method

.method public newArray(I)[Lcom/android/internal/telephony/util/DnsSdTxtRecord;
    .locals 0

    .line 322
    new-array p0, p1, [Lcom/android/internal/telephony/util/DnsSdTxtRecord;

    return-object p0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 314
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/util/DnsSdTxtRecord$1;->newArray(I)[Lcom/android/internal/telephony/util/DnsSdTxtRecord;

    move-result-object p0

    return-object p0
.end method
