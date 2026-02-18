.class Lcom/android/internal/telephony/DeviceStateMonitor$2;
.super Ljava/lang/Object;
.source "DeviceStateMonitor.java"

# interfaces
.implements Landroid/hardware/display/DisplayManager$DisplayListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/DeviceStateMonitor;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/DeviceStateMonitor;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/DeviceStateMonitor;)V
    .locals 0

    .line 218
    iput-object p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor$2;->this$0:Lcom/android/internal/telephony/DeviceStateMonitor;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onDisplayAdded(I)V
    .locals 0

    return-void
.end method

.method public onDisplayChanged(I)V
    .locals 2

    .line 227
    iget-object p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor$2;->this$0:Lcom/android/internal/telephony/DeviceStateMonitor;

    invoke-static {p1}, Lcom/android/internal/telephony/DeviceStateMonitor;->-$$Nest$misScreenOn(Lcom/android/internal/telephony/DeviceStateMonitor;)Z

    move-result p1

    .line 228
    iget-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor$2;->this$0:Lcom/android/internal/telephony/DeviceStateMonitor;

    const/4 v1, 0x2

    invoke-virtual {v0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    .line 229
    iput p1, v0, Landroid/os/Message;->arg1:I

    .line 230
    iget-object p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor$2;->this$0:Lcom/android/internal/telephony/DeviceStateMonitor;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public onDisplayRemoved(I)V
    .locals 0

    return-void
.end method
