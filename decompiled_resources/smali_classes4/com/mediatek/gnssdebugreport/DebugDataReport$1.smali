.class Lcom/mediatek/gnssdebugreport/DebugDataReport$1;
.super Ljava/lang/Object;
.source "DebugDataReport.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/gnssdebugreport/DebugDataReport;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/mediatek/gnssdebugreport/DebugDataReport;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 234
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/mediatek/gnssdebugreport/DebugDataReport;
    .locals 0

    .line 236
    new-instance p0, Lcom/mediatek/gnssdebugreport/DebugDataReport;

    invoke-direct {p0, p1}, Lcom/mediatek/gnssdebugreport/DebugDataReport;-><init>(Landroid/os/Parcel;)V

    return-object p0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 234
    invoke-virtual {p0, p1}, Lcom/mediatek/gnssdebugreport/DebugDataReport$1;->createFromParcel(Landroid/os/Parcel;)Lcom/mediatek/gnssdebugreport/DebugDataReport;

    move-result-object p0

    return-object p0
.end method

.method public newArray(I)[Lcom/mediatek/gnssdebugreport/DebugDataReport;
    .locals 0

    .line 240
    new-array p0, p1, [Lcom/mediatek/gnssdebugreport/DebugDataReport;

    return-object p0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 234
    invoke-virtual {p0, p1}, Lcom/mediatek/gnssdebugreport/DebugDataReport$1;->newArray(I)[Lcom/mediatek/gnssdebugreport/DebugDataReport;

    move-result-object p0

    return-object p0
.end method
