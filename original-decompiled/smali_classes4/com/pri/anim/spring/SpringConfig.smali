.class public Lcom/pri/anim/spring/SpringConfig;
.super Ljava/lang/Object;
.source "SpringConfig.java"


# static fields
.field public static defaultConfig:Lcom/pri/anim/spring/SpringConfig;


# instance fields
.field public friction:D

.field public tension:D


# direct methods
.method static constructor <clinit>()V
    .locals 4

    const-wide/high16 v0, 0x4044000000000000L    # 40.0

    const-wide/high16 v2, 0x401c000000000000L    # 7.0

    .line 11
    invoke-static {v0, v1, v2, v3}, Lcom/pri/anim/spring/SpringConfig;->fromOrigamiTensionAndFriction(DD)Lcom/pri/anim/spring/SpringConfig;

    move-result-object v0

    sput-object v0, Lcom/pri/anim/spring/SpringConfig;->defaultConfig:Lcom/pri/anim/spring/SpringConfig;

    return-void
.end method

.method public constructor <init>(DD)V
    .locals 0

    .line 18
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 19
    iput-wide p1, p0, Lcom/pri/anim/spring/SpringConfig;->tension:D

    .line 20
    iput-wide p3, p0, Lcom/pri/anim/spring/SpringConfig;->friction:D

    return-void
.end method

.method public static fromOrigamiTensionAndFriction(DD)Lcom/pri/anim/spring/SpringConfig;
    .locals 1

    .line 30
    new-instance v0, Lcom/pri/anim/spring/SpringConfig;

    .line 31
    invoke-static {p0, p1}, Lcom/pri/anim/spring/OrigamiValueConverter;->tensionFromOrigamiValue(D)D

    move-result-wide p0

    .line 32
    invoke-static {p2, p3}, Lcom/pri/anim/spring/OrigamiValueConverter;->frictionFromOrigamiValue(D)D

    move-result-wide p2

    invoke-direct {v0, p0, p1, p2, p3}, Lcom/pri/anim/spring/SpringConfig;-><init>(DD)V

    return-object v0
.end method
