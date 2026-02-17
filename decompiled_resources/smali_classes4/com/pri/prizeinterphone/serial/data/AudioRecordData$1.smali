.class Lcom/pri/prizeinterphone/serial/data/AudioRecordData$1;
.super Ljava/lang/Object;
.source "AudioRecordData.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/serial/data/AudioRecordData;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/pri/prizeinterphone/serial/data/AudioRecordData;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 43
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/pri/prizeinterphone/serial/data/AudioRecordData;
    .locals 0

    .line 46
    new-instance p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;-><init>(Landroid/os/Parcel;)V

    return-object p0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 43
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData$1;->createFromParcel(Landroid/os/Parcel;)Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    move-result-object p0

    return-object p0
.end method

.method public newArray(I)[Lcom/pri/prizeinterphone/serial/data/AudioRecordData;
    .locals 0

    .line 51
    new-array p0, p1, [Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    return-object p0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 43
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData$1;->newArray(I)[Lcom/pri/prizeinterphone/serial/data/AudioRecordData;

    move-result-object p0

    return-object p0
.end method
