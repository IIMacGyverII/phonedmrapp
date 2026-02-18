.class public Lcom/mediatek/powerhalmgr/PowerHalMgrFactoryImpl;
.super Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;
.source "PowerHalMgrFactoryImpl.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 38
    invoke-direct {p0}, Lcom/mediatek/powerhalmgr/PowerHalMgrFactory;-><init>()V

    return-void
.end method


# virtual methods
.method public makePowerHalMgr()Lcom/mediatek/powerhalmgr/PowerHalMgr;
    .locals 0

    .line 42
    invoke-static {}, Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;->getInstance()Lcom/mediatek/powerhalmgr/PowerHalMgrImpl;

    move-result-object p0

    return-object p0
.end method
