.class public Lcom/mediatek/anr/AnrAppFactoryImpl;
.super Lcom/mediatek/anr/AnrAppFactory;
.source "AnrAppFactoryImpl.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 38
    invoke-direct {p0}, Lcom/mediatek/anr/AnrAppFactory;-><init>()V

    return-void
.end method


# virtual methods
.method public makeAnrAppManager()Lcom/mediatek/anr/AnrAppManager;
    .locals 0

    .line 42
    new-instance p0, Lcom/mediatek/anr/AnrAppManagerImpl;

    invoke-direct {p0}, Lcom/mediatek/anr/AnrAppManagerImpl;-><init>()V

    return-object p0
.end method
