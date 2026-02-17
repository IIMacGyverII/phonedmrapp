.class public final Lcom/google/android/material/color/ColorRoles;
.super Ljava/lang/Object;
.source "ColorRoles.java"


# instance fields
.field private final accent:I

.field private final accentContainer:I

.field private final onAccent:I

.field private final onAccentContainer:I


# direct methods
.method constructor <init>(IIII)V
    .locals 0
    .param p1    # I
        .annotation build Landroidx/annotation/ColorInt;
        .end annotation
    .end param
    .param p2    # I
        .annotation build Landroidx/annotation/ColorInt;
        .end annotation
    .end param
    .param p3    # I
        .annotation build Landroidx/annotation/ColorInt;
        .end annotation
    .end param
    .param p4    # I
        .annotation build Landroidx/annotation/ColorInt;
        .end annotation
    .end param

    .line 37
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 38
    iput p1, p0, Lcom/google/android/material/color/ColorRoles;->accent:I

    .line 39
    iput p2, p0, Lcom/google/android/material/color/ColorRoles;->onAccent:I

    .line 40
    iput p3, p0, Lcom/google/android/material/color/ColorRoles;->accentContainer:I

    .line 41
    iput p4, p0, Lcom/google/android/material/color/ColorRoles;->onAccentContainer:I

    return-void
.end method


# virtual methods
.method public getAccent()I
    .locals 0
    .annotation build Landroidx/annotation/ColorInt;
    .end annotation

    .line 47
    iget p0, p0, Lcom/google/android/material/color/ColorRoles;->accent:I

    return p0
.end method

.method public getAccentContainer()I
    .locals 0
    .annotation build Landroidx/annotation/ColorInt;
    .end annotation

    .line 62
    iget p0, p0, Lcom/google/android/material/color/ColorRoles;->accentContainer:I

    return p0
.end method

.method public getOnAccent()I
    .locals 0
    .annotation build Landroidx/annotation/ColorInt;
    .end annotation

    .line 56
    iget p0, p0, Lcom/google/android/material/color/ColorRoles;->onAccent:I

    return p0
.end method

.method public getOnAccentContainer()I
    .locals 0
    .annotation build Landroidx/annotation/ColorInt;
    .end annotation

    .line 71
    iget p0, p0, Lcom/google/android/material/color/ColorRoles;->onAccentContainer:I

    return p0
.end method
