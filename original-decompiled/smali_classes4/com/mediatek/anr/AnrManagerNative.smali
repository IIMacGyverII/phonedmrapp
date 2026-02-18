.class public abstract Lcom/mediatek/anr/AnrManagerNative;
.super Landroid/os/Binder;
.source "AnrManagerNative.java"

# interfaces
.implements Lcom/mediatek/anr/IAnrManager;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/anr/AnrManagerNative$Singleton;
    }
.end annotation


# static fields
.field private static final gDefault:Lcom/mediatek/anr/AnrManagerNative$Singleton;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Lcom/mediatek/anr/AnrManagerNative$Singleton<",
            "Lcom/mediatek/anr/IAnrManager;",
            ">;"
        }
    .end annotation
.end field

.field private static sGetService:Ljava/lang/reflect/Method;


# direct methods
.method static bridge synthetic -$$Nest$sfgetsGetService()Ljava/lang/reflect/Method;
    .locals 1

    sget-object v0, Lcom/mediatek/anr/AnrManagerNative;->sGetService:Ljava/lang/reflect/Method;

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Class;

    const/4 v1, 0x0

    .line 49
    const-class v2, Ljava/lang/String;

    aput-object v2, v0, v1

    const-string v1, "getService"

    invoke-static {v1, v0}, Lcom/mediatek/anr/AnrManagerNative;->getServiceManagerMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    sput-object v0, Lcom/mediatek/anr/AnrManagerNative;->sGetService:Ljava/lang/reflect/Method;

    .line 107
    new-instance v0, Lcom/mediatek/anr/AnrManagerNative$1;

    invoke-direct {v0}, Lcom/mediatek/anr/AnrManagerNative$1;-><init>()V

    sput-object v0, Lcom/mediatek/anr/AnrManagerNative;->gDefault:Lcom/mediatek/anr/AnrManagerNative$Singleton;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 84
    invoke-direct {p0}, Landroid/os/Binder;-><init>()V

    const-string v0, "android.app.IAnrManager"

    .line 85
    invoke-virtual {p0, p0, v0}, Landroid/os/Binder;->attachInterface(Landroid/os/IInterface;Ljava/lang/String;)V

    return-void
.end method

.method public static asInterface(Landroid/os/IBinder;)Lcom/mediatek/anr/IAnrManager;
    .locals 1

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    :cond_0
    const-string v0, "android.app.IAnrManager"

    .line 69
    invoke-interface {p0, v0}, Landroid/os/IBinder;->queryLocalInterface(Ljava/lang/String;)Landroid/os/IInterface;

    move-result-object v0

    check-cast v0, Lcom/mediatek/anr/IAnrManager;

    if-eqz v0, :cond_1

    return-object v0

    .line 74
    :cond_1
    new-instance v0, Lcom/mediatek/anr/AnrManagerProxy;

    invoke-direct {v0, p0}, Lcom/mediatek/anr/AnrManagerProxy;-><init>(Landroid/os/IBinder;)V

    return-object v0
.end method

.method public static getDefault()Lcom/mediatek/anr/IAnrManager;
    .locals 1

    .line 81
    sget-object v0, Lcom/mediatek/anr/AnrManagerNative;->gDefault:Lcom/mediatek/anr/AnrManagerNative$Singleton;

    invoke-virtual {v0}, Lcom/mediatek/anr/AnrManagerNative$Singleton;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/anr/IAnrManager;

    return-object v0
.end method

.method private static getServiceManagerMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
    .locals 1

    :try_start_0
    const-string v0, "android.os.ServiceManager"

    .line 53
    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    .line 54
    invoke-virtual {v0, p0, p1}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    const/4 p0, 0x0

    return-object p0
.end method


# virtual methods
.method public asBinder()Landroid/os/IBinder;
    .locals 0

    return-object p0
.end method

.method public onTransact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    const/4 v0, 0x2

    if-eq p1, v0, :cond_0

    .line 100
    invoke-super {p0, p1, p2, p3, p4}, Landroid/os/Binder;->onTransact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    move-result p0

    return p0

    :cond_0
    const-string p1, "android.app.IAnrManager"

    .line 92
    invoke-virtual {p2, p1}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 93
    invoke-virtual {p2}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object p1

    .line 94
    invoke-virtual {p2}, Landroid/os/Parcel;->readInt()I

    move-result p2

    .line 95
    invoke-interface {p0, p1, p2}, Lcom/mediatek/anr/IAnrManager;->informMessageDump(Ljava/lang/String;I)V

    const/4 p0, 0x1

    return p0
.end method
