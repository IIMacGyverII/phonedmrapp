.class Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver;
.super Landroid/os/UEventObserver;
.source "CpuLoadingObserver.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/cpuloading/CpuLoadingObserver;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "MyUEventObserver"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mediatek/cpuloading/CpuLoadingObserver;


# direct methods
.method private constructor <init>(Lcom/mediatek/cpuloading/CpuLoadingObserver;)V
    .locals 0

    .line 208
    iput-object p1, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver;->this$0:Lcom/mediatek/cpuloading/CpuLoadingObserver;

    invoke-direct {p0}, Landroid/os/UEventObserver;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/mediatek/cpuloading/CpuLoadingObserver;Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver;-><init>(Lcom/mediatek/cpuloading/CpuLoadingObserver;)V

    return-void
.end method


# virtual methods
.method public onUEvent(Landroid/os/UEventObserver$UEvent;)V
    .locals 2

    const-string v0, "over"

    .line 212
    invoke-virtual {p1, v0}, Landroid/os/UEventObserver$UEvent;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string/jumbo v1, "specify_over"

    .line 213
    invoke-virtual {p1, v1}, Landroid/os/UEventObserver$UEvent;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string v1, "1"

    if-eqz v0, :cond_0

    .line 214
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 215
    iget-object p0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver;->this$0:Lcom/mediatek/cpuloading/CpuLoadingObserver;

    invoke-static {p0}, Lcom/mediatek/cpuloading/CpuLoadingObserver;->-$$Nest$fgetmObserver(Lcom/mediatek/cpuloading/CpuLoadingObserver;)Lcom/mediatek/cpuloading/CpuLoadingObserver$Observer;

    move-result-object p0

    const/4 p1, -0x1

    invoke-interface {p0, p1}, Lcom/mediatek/cpuloading/CpuLoadingObserver$Observer;->onHighCpuLoading(I)V

    goto :goto_0

    :cond_0
    if-eqz p1, :cond_1

    .line 216
    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 217
    iget-object p0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver;->this$0:Lcom/mediatek/cpuloading/CpuLoadingObserver;

    invoke-static {p0}, Lcom/mediatek/cpuloading/CpuLoadingObserver;->-$$Nest$fgetmObserver(Lcom/mediatek/cpuloading/CpuLoadingObserver;)Lcom/mediatek/cpuloading/CpuLoadingObserver$Observer;

    move-result-object p0

    invoke-static {}, Lcom/mediatek/cpuloading/CpuLoadingObserver;->-$$Nest$sfgetSPECIFY_RELEASE_TARGET()I

    move-result p1

    invoke-interface {p0, p1}, Lcom/mediatek/cpuloading/CpuLoadingObserver$Observer;->onHighCpuLoading(I)V

    :cond_1
    :goto_0
    return-void
.end method
