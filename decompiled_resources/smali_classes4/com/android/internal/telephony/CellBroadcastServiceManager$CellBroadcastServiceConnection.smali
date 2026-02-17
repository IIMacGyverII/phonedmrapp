.class Lcom/android/internal/telephony/CellBroadcastServiceManager$CellBroadcastServiceConnection;
.super Ljava/lang/Object;
.source "CellBroadcastServiceManager.java"

# interfaces
.implements Landroid/content/ServiceConnection;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/CellBroadcastServiceManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "CellBroadcastServiceConnection"
.end annotation


# instance fields
.field mService:Landroid/os/IBinder;

.field final synthetic this$0:Lcom/android/internal/telephony/CellBroadcastServiceManager;


# direct methods
.method private constructor <init>(Lcom/android/internal/telephony/CellBroadcastServiceManager;)V
    .locals 0

    .line 295
    iput-object p1, p0, Lcom/android/internal/telephony/CellBroadcastServiceManager$CellBroadcastServiceConnection;->this$0:Lcom/android/internal/telephony/CellBroadcastServiceManager;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/CellBroadcastServiceManager;Lcom/android/internal/telephony/CellBroadcastServiceManager$CellBroadcastServiceConnection-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/CellBroadcastServiceManager$CellBroadcastServiceConnection;-><init>(Lcom/android/internal/telephony/CellBroadcastServiceManager;)V

    return-void
.end method


# virtual methods
.method public onBindingDied(Landroid/content/ComponentName;)V
    .locals 0

    const-string p0, "CellBroadcastServiceManager"

    const-string p1, "Binding died"

    .line 312
    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onNullBinding(Landroid/content/ComponentName;)V
    .locals 0

    const-string p0, "CellBroadcastServiceManager"

    const-string p1, "Null binding"

    .line 317
    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onServiceConnected(Landroid/content/ComponentName;Landroid/os/IBinder;)V
    .locals 1

    const-string p1, "CellBroadcastServiceManager"

    const-string v0, "connected to CellBroadcastService"

    .line 300
    invoke-static {p1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 301
    iput-object p2, p0, Lcom/android/internal/telephony/CellBroadcastServiceManager$CellBroadcastServiceConnection;->mService:Landroid/os/IBinder;

    return-void
.end method

.method public onServiceDisconnected(Landroid/content/ComponentName;)V
    .locals 1

    const-string p1, "CellBroadcastServiceManager"

    const-string v0, "mICellBroadcastService has disconnected unexpectedly"

    .line 306
    invoke-static {p1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p1, 0x0

    .line 307
    iput-object p1, p0, Lcom/android/internal/telephony/CellBroadcastServiceManager$CellBroadcastServiceConnection;->mService:Landroid/os/IBinder;

    return-void
.end method
