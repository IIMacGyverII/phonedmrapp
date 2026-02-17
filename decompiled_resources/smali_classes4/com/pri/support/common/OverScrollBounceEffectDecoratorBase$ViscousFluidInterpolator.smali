.class Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$ViscousFluidInterpolator;
.super Ljava/lang/Object;
.source "OverScrollBounceEffectDecoratorBase.java"

# interfaces
.implements Landroid/view/animation/Interpolator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "ViscousFluidInterpolator"
.end annotation


# static fields
.field private static final VISCOUS_FLUID_NORMALIZE:F

.field private static final VISCOUS_FLUID_OFFSET:F


# direct methods
.method static constructor <clinit>()V
    .locals 3

    const/high16 v0, 0x3f800000    # 1.0f

    .line 188
    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$ViscousFluidInterpolator;->viscousFluid(F)F

    move-result v1

    div-float v1, v0, v1

    sput v1, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$ViscousFluidInterpolator;->VISCOUS_FLUID_NORMALIZE:F

    .line 189
    invoke-static {v0}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$ViscousFluidInterpolator;->viscousFluid(F)F

    move-result v2

    mul-float/2addr v1, v2

    sub-float/2addr v0, v1

    sput v0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$ViscousFluidInterpolator;->VISCOUS_FLUID_OFFSET:F

    return-void
.end method

.method constructor <init>()V
    .locals 0

    .line 191
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static viscousFluid(F)F
    .locals 3

    const/high16 v0, 0x41000000    # 8.0f

    mul-float/2addr p0, v0

    const/high16 v0, 0x3f800000    # 1.0f

    cmpg-float v1, p0, v0

    if-gez v1, :cond_0

    neg-float v1, p0

    float-to-double v1, v1

    .line 197
    invoke-static {v1, v2}, Ljava/lang/Math;->exp(D)D

    move-result-wide v1

    double-to-float v1, v1

    sub-float/2addr v0, v1

    sub-float/2addr p0, v0

    return p0

    :cond_0
    sub-float p0, v0, p0

    float-to-double v1, p0

    .line 199
    invoke-static {v1, v2}, Ljava/lang/Math;->exp(D)D

    move-result-wide v1

    double-to-float p0, v1

    sub-float/2addr v0, p0

    const p0, 0x3f21d2a7

    mul-float/2addr v0, p0

    const p0, 0x3ebc5ab2

    add-float/2addr v0, p0

    return v0
.end method


# virtual methods
.method public getInterpolation(F)F
    .locals 0

    .line 203
    sget p0, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$ViscousFluidInterpolator;->VISCOUS_FLUID_NORMALIZE:F

    invoke-static {p1}, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$ViscousFluidInterpolator;->viscousFluid(F)F

    move-result p1

    mul-float/2addr p0, p1

    const/4 p1, 0x0

    cmpl-float p1, p0, p1

    if-lez p1, :cond_0

    .line 204
    sget p1, Lcom/pri/support/common/OverScrollBounceEffectDecoratorBase$ViscousFluidInterpolator;->VISCOUS_FLUID_OFFSET:F

    add-float/2addr p0, p1

    :cond_0
    return p0
.end method
