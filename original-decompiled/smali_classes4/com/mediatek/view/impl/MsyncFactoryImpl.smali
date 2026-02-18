.class public Lcom/mediatek/view/impl/MsyncFactoryImpl;
.super Lcom/mediatek/view/MsyncFactory;
.source "MsyncFactoryImpl.java"


# static fields
.field private static mMsyncExt:Lcom/mediatek/view/MsyncExt;


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 6
    invoke-direct {p0}, Lcom/mediatek/view/MsyncFactory;-><init>()V

    return-void
.end method


# virtual methods
.method public getMsyncExt()Lcom/mediatek/view/MsyncExt;
    .locals 0

    .line 11
    sget-object p0, Lcom/mediatek/view/impl/MsyncFactoryImpl;->mMsyncExt:Lcom/mediatek/view/MsyncExt;

    if-nez p0, :cond_0

    .line 12
    new-instance p0, Lcom/mediatek/view/impl/MsyncExtimpl;

    invoke-direct {p0}, Lcom/mediatek/view/impl/MsyncExtimpl;-><init>()V

    sput-object p0, Lcom/mediatek/view/impl/MsyncFactoryImpl;->mMsyncExt:Lcom/mediatek/view/MsyncExt;

    .line 14
    :cond_0
    sget-object p0, Lcom/mediatek/view/impl/MsyncFactoryImpl;->mMsyncExt:Lcom/mediatek/view/MsyncExt;

    return-object p0
.end method
