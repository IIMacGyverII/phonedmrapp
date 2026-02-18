.class Lcom/mediatek/anr/AnrManagerNative$1;
.super Lcom/mediatek/anr/AnrManagerNative$Singleton;
.source "AnrManagerNative.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/anr/AnrManagerNative;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/mediatek/anr/AnrManagerNative$Singleton<",
        "Lcom/mediatek/anr/IAnrManager;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 107
    invoke-direct {p0}, Lcom/mediatek/anr/AnrManagerNative$Singleton;-><init>()V

    return-void
.end method


# virtual methods
.method protected create()Lcom/mediatek/anr/IAnrManager;
    .locals 4

    const/4 p0, 0x0

    .line 111
    :try_start_0
    invoke-static {}, Lcom/mediatek/anr/AnrManagerNative;->-$$Nest$sfgetsGetService()Ljava/lang/reflect/Method;

    move-result-object v0

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    const-string v3, "anrmanager"

    aput-object v3, v1, v2

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/IBinder;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-object p0, v0

    .line 114
    :catch_0
    invoke-static {p0}, Lcom/mediatek/anr/AnrManagerNative;->asInterface(Landroid/os/IBinder;)Lcom/mediatek/anr/IAnrManager;

    move-result-object p0

    return-object p0
.end method

.method protected bridge synthetic create()Ljava/lang/Object;
    .locals 0

    .line 107
    invoke-virtual {p0}, Lcom/mediatek/anr/AnrManagerNative$1;->create()Lcom/mediatek/anr/IAnrManager;

    move-result-object p0

    return-object p0
.end method
