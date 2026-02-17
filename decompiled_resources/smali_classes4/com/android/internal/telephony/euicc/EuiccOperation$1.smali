.class Lcom/android/internal/telephony/euicc/EuiccOperation$1;
.super Ljava/lang/Object;
.source "EuiccOperation.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/euicc/EuiccOperation;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/android/internal/telephony/euicc/EuiccOperation;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 47
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/android/internal/telephony/euicc/EuiccOperation;
    .locals 0

    .line 50
    new-instance p0, Lcom/android/internal/telephony/euicc/EuiccOperation;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccOperation;-><init>(Landroid/os/Parcel;)V

    return-object p0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 47
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccOperation$1;->createFromParcel(Landroid/os/Parcel;)Lcom/android/internal/telephony/euicc/EuiccOperation;

    move-result-object p0

    return-object p0
.end method

.method public newArray(I)[Lcom/android/internal/telephony/euicc/EuiccOperation;
    .locals 0

    .line 55
    new-array p0, p1, [Lcom/android/internal/telephony/euicc/EuiccOperation;

    return-object p0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 47
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccOperation$1;->newArray(I)[Lcom/android/internal/telephony/euicc/EuiccOperation;

    move-result-object p0

    return-object p0
.end method
