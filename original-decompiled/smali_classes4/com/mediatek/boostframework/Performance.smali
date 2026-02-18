.class public Lcom/mediatek/boostframework/Performance;
.super Ljava/lang/Object;
.source "Performance.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "Performance"

.field private static mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;


# instance fields
.field private mhandle:I


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 60
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 57
    iput v0, p0, Lcom/mediatek/boostframework/Performance;->mhandle:I

    .line 61
    invoke-static {}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->getInstance()Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    move-result-object p0

    sput-object p0, Lcom/mediatek/boostframework/Performance;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    return-void
.end method

.method private static log(Ljava/lang/String;)V
    .locals 2

    .line 95
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[Performance] "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "@M_Performance"

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static loge(Ljava/lang/String;)V
    .locals 2

    .line 99
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[Performance] ERR: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "@M_Performance"

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method public varargs perfLockAcquire(I[I)I
    .locals 2

    .line 72
    invoke-virtual {p0, p2}, Lcom/mediatek/boostframework/Performance;->perfchecklist([I)I

    move-result v0

    if-nez v0, :cond_0

    const/4 p0, -0x1

    return p0

    .line 75
    :cond_0
    sget-object v0, Lcom/mediatek/boostframework/Performance;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    iget v1, p0, Lcom/mediatek/boostframework/Performance;->mhandle:I

    invoke-virtual {v0, v1, p1, p2}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->perfLockAcquire(II[I)I

    move-result p1

    iput p1, p0, Lcom/mediatek/boostframework/Performance;->mhandle:I

    return p1
.end method

.method public perfLockRelease()I
    .locals 1

    .line 84
    sget-object v0, Lcom/mediatek/boostframework/Performance;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    iget p0, p0, Lcom/mediatek/boostframework/Performance;->mhandle:I

    invoke-virtual {v0, p0}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->perfLockRelease(I)V

    const/4 p0, 0x0

    return p0
.end method

.method public perfLockRelease(I)I
    .locals 0

    .line 90
    sget-object p0, Lcom/mediatek/boostframework/Performance;->mPowerHalWrap:Lcom/mediatek/powerhalwrapper/PowerHalWrapper;

    invoke-virtual {p0, p1}, Lcom/mediatek/powerhalwrapper/PowerHalWrapper;->perfLockRelease(I)V

    const/4 p0, 0x0

    return p0
.end method

.method public varargs perfchecklist([I)I
    .locals 0

    .line 65
    array-length p0, p1

    rem-int/lit8 p0, p0, 0x2

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method
