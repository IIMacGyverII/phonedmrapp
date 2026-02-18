.class Lcom/mediatek/anr/AnrManagerProxy;
.super Ljava/lang/Object;
.source "AnrManagerProxy.java"

# interfaces
.implements Lcom/mediatek/anr/IAnrManager;


# instance fields
.field private mRemote:Landroid/os/IBinder;


# direct methods
.method public constructor <init>(Landroid/os/IBinder;)V
    .locals 0

    .line 47
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 48
    iput-object p1, p0, Lcom/mediatek/anr/AnrManagerProxy;->mRemote:Landroid/os/IBinder;

    return-void
.end method


# virtual methods
.method public asBinder()Landroid/os/IBinder;
    .locals 0

    .line 52
    iget-object p0, p0, Lcom/mediatek/anr/AnrManagerProxy;->mRemote:Landroid/os/IBinder;

    return-object p0
.end method

.method public informMessageDump(Ljava/lang/String;I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 56
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v0

    const-string v1, "android.app.IAnrManager"

    .line 57
    invoke-virtual {v0, v1}, Landroid/os/Parcel;->writeInterfaceToken(Ljava/lang/String;)V

    .line 58
    invoke-virtual {v0, p1}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 59
    invoke-virtual {v0, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 60
    iget-object p0, p0, Lcom/mediatek/anr/AnrManagerProxy;->mRemote:Landroid/os/IBinder;

    const/4 p1, 0x2

    const/4 p2, 0x0

    const/4 v1, 0x1

    invoke-interface {p0, p1, v0, p2, v1}, Landroid/os/IBinder;->transact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    .line 61
    invoke-virtual {v0}, Landroid/os/Parcel;->recycle()V

    return-void
.end method
