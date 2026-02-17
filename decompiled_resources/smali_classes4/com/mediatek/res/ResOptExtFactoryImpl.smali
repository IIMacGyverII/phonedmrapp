.class public Lcom/mediatek/res/ResOptExtFactoryImpl;
.super Lcom/mediatek/res/ResOptExtFactory;
.source "ResOptExtFactoryImpl.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 41
    invoke-direct {p0}, Lcom/mediatek/res/ResOptExtFactory;-><init>()V

    return-void
.end method


# virtual methods
.method public makeResOptExt()Lcom/mediatek/res/ResOptExt;
    .locals 0

    .line 45
    invoke-static {}, Lcom/mediatek/res/ResOptExtImpl;->getInstance()Lcom/mediatek/res/ResOptExtImpl;

    move-result-object p0

    return-object p0
.end method
