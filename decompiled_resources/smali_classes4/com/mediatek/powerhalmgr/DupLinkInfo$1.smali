.class Lcom/mediatek/powerhalmgr/DupLinkInfo$1;
.super Ljava/lang/Object;
.source "DupLinkInfo.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/powerhalmgr/DupLinkInfo;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/mediatek/powerhalmgr/DupLinkInfo;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 80
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/mediatek/powerhalmgr/DupLinkInfo;
    .locals 1

    .line 83
    new-instance p0, Lcom/mediatek/powerhalmgr/DupLinkInfo;

    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Lcom/mediatek/powerhalmgr/DupLinkInfo;-><init>(Landroid/os/Parcel;Lcom/mediatek/powerhalmgr/DupLinkInfo-IA;)V

    return-object p0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 80
    invoke-virtual {p0, p1}, Lcom/mediatek/powerhalmgr/DupLinkInfo$1;->createFromParcel(Landroid/os/Parcel;)Lcom/mediatek/powerhalmgr/DupLinkInfo;

    move-result-object p0

    return-object p0
.end method

.method public newArray(I)[Lcom/mediatek/powerhalmgr/DupLinkInfo;
    .locals 0

    .line 88
    new-array p0, p1, [Lcom/mediatek/powerhalmgr/DupLinkInfo;

    return-object p0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 80
    invoke-virtual {p0, p1}, Lcom/mediatek/powerhalmgr/DupLinkInfo$1;->newArray(I)[Lcom/mediatek/powerhalmgr/DupLinkInfo;

    move-result-object p0

    return-object p0
.end method
