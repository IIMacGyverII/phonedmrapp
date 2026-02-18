.class Lcom/mediatek/powerhalmgr/BoosterInfo$1;
.super Ljava/lang/Object;
.source "BoosterInfo.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/powerhalmgr/BoosterInfo;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/mediatek/powerhalmgr/BoosterInfo;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 286
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/mediatek/powerhalmgr/BoosterInfo;
    .locals 1

    .line 289
    new-instance p0, Lcom/mediatek/powerhalmgr/BoosterInfo;

    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Lcom/mediatek/powerhalmgr/BoosterInfo;-><init>(Landroid/os/Parcel;Lcom/mediatek/powerhalmgr/BoosterInfo-IA;)V

    return-object p0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 286
    invoke-virtual {p0, p1}, Lcom/mediatek/powerhalmgr/BoosterInfo$1;->createFromParcel(Landroid/os/Parcel;)Lcom/mediatek/powerhalmgr/BoosterInfo;

    move-result-object p0

    return-object p0
.end method

.method public newArray(I)[Lcom/mediatek/powerhalmgr/BoosterInfo;
    .locals 0

    .line 294
    new-array p0, p1, [Lcom/mediatek/powerhalmgr/BoosterInfo;

    return-object p0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 286
    invoke-virtual {p0, p1}, Lcom/mediatek/powerhalmgr/BoosterInfo$1;->newArray(I)[Lcom/mediatek/powerhalmgr/BoosterInfo;

    move-result-object p0

    return-object p0
.end method
