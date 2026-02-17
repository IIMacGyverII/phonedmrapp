.class public Lcom/mediatek/view/impl/SurfaceFactoryImpl;
.super Lcom/mediatek/view/SurfaceFactory;
.source "SurfaceFactoryImpl.java"


# static fields
.field private static mSurfaceExt:Lcom/mediatek/view/SurfaceExt;


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 6
    invoke-direct {p0}, Lcom/mediatek/view/SurfaceFactory;-><init>()V

    return-void
.end method


# virtual methods
.method public getSurfaceExt()Lcom/mediatek/view/SurfaceExt;
    .locals 0

    .line 11
    sget-object p0, Lcom/mediatek/view/impl/SurfaceFactoryImpl;->mSurfaceExt:Lcom/mediatek/view/SurfaceExt;

    if-nez p0, :cond_0

    .line 12
    new-instance p0, Lcom/mediatek/view/impl/SurfaceExtimpl;

    invoke-direct {p0}, Lcom/mediatek/view/impl/SurfaceExtimpl;-><init>()V

    sput-object p0, Lcom/mediatek/view/impl/SurfaceFactoryImpl;->mSurfaceExt:Lcom/mediatek/view/SurfaceExt;

    .line 14
    :cond_0
    sget-object p0, Lcom/mediatek/view/impl/SurfaceFactoryImpl;->mSurfaceExt:Lcom/mediatek/view/SurfaceExt;

    return-object p0
.end method
