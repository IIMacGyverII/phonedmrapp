.class Lcom/pri/prizeinterphone/config/data/InsertChannels$1;
.super Ljava/lang/Object;
.source "InsertChannels.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/config/data/InsertChannels;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/pri/prizeinterphone/config/data/InsertChannels;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 48
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/pri/prizeinterphone/config/data/InsertChannels;
    .locals 0

    .line 51
    new-instance p0, Lcom/pri/prizeinterphone/config/data/InsertChannels;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/config/data/InsertChannels;-><init>(Landroid/os/Parcel;)V

    return-object p0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 48
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/config/data/InsertChannels$1;->createFromParcel(Landroid/os/Parcel;)Lcom/pri/prizeinterphone/config/data/InsertChannels;

    move-result-object p0

    return-object p0
.end method

.method public newArray(I)[Lcom/pri/prizeinterphone/config/data/InsertChannels;
    .locals 0

    .line 56
    new-array p0, p1, [Lcom/pri/prizeinterphone/config/data/InsertChannels;

    return-object p0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 48
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/config/data/InsertChannels$1;->newArray(I)[Lcom/pri/prizeinterphone/config/data/InsertChannels;

    move-result-object p0

    return-object p0
.end method
