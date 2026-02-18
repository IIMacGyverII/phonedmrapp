.class Lcom/pri/prizeinterphone/config/data/InsertChannel$1;
.super Ljava/lang/Object;
.source "InsertChannel.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/config/data/InsertChannel;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/pri/prizeinterphone/config/data/InsertChannel;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 404
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/pri/prizeinterphone/config/data/InsertChannel;
    .locals 0

    .line 407
    new-instance p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel;-><init>(Landroid/os/Parcel;)V

    return-object p0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 404
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$1;->createFromParcel(Landroid/os/Parcel;)Lcom/pri/prizeinterphone/config/data/InsertChannel;

    move-result-object p0

    return-object p0
.end method

.method public newArray(I)[Lcom/pri/prizeinterphone/config/data/InsertChannel;
    .locals 0

    .line 412
    new-array p0, p1, [Lcom/pri/prizeinterphone/config/data/InsertChannel;

    return-object p0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 404
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$1;->newArray(I)[Lcom/pri/prizeinterphone/config/data/InsertChannel;

    move-result-object p0

    return-object p0
.end method
