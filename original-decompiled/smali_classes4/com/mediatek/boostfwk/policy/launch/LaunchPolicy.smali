.class public Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;
.super Ljava/lang/Object;
.source "LaunchPolicy.java"


# static fields
.field private static MTKPOWER_HINT_PROCESS_CREATE:I = 0x15

.field private static PERF_RES_POWER_END_HINT_HOLD_TIME:I = 0x3410300

.field private static final TAG:Ljava/lang/String; = "SBE-LaunchPolicy"

.field private static mPowerHandle:I = 0x0

.field private static mReleaseLaunchDuration:I = 0xbb8


# instance fields
.field private mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 53
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 54
    invoke-static {}, Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;->getInstance()Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;

    move-result-object v0

    .line 55
    invoke-virtual {v0}, Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;->makePowerHalMgr()Lcom/mediatek/powerhalmgr/PowerHalMgr;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    return-void
.end method

.method private perfLockAcquire([I)V
    .locals 3

    .line 70
    iget-object v0, p0, Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    if-eqz v0, :cond_0

    .line 71
    sget v1, Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;->mPowerHandle:I

    sget v2, Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;->mReleaseLaunchDuration:I

    invoke-virtual {v0, v1, v2, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockAcquire(II[I)I

    move-result p1

    sput p1, Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;->mPowerHandle:I

    .line 73
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;->mPowerHalService:Lcom/mediatek/powerhalmgr/PowerHalMgr;

    invoke-virtual {p0, p1}, Lcom/mediatek/powerhalmgr/PowerHalMgr;->perfLockRelease(I)V

    :cond_0
    return-void
.end method


# virtual methods
.method public boostEnd(Ljava/lang/String;)V
    .locals 4

    const-wide/16 v0, 0x40

    const-string p1, "SBE boost end"

    .line 59
    invoke-static {v0, v1, p1}, Landroid/os/Trace;->traceBegin(JLjava/lang/String;)V

    const/4 p1, 0x2

    new-array p1, p1, [I

    .line 61
    sget v2, Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;->PERF_RES_POWER_END_HINT_HOLD_TIME:I

    const/4 v3, 0x0

    aput v2, p1, v3

    sget v2, Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;->MTKPOWER_HINT_PROCESS_CREATE:I

    const/4 v3, 0x1

    aput v2, p1, v3

    .line 64
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/policy/launch/LaunchPolicy;->perfLockAcquire([I)V

    .line 66
    invoke-static {v0, v1}, Landroid/os/Trace;->traceEnd(J)V

    return-void
.end method
