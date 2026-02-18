.class public Lcom/mediatek/internal/widget/LockPatternUtilsExt;
.super Ljava/lang/Object;
.source "LockPatternUtilsExt.java"


# static fields
.field private static final ALLOWING_FR:I = 0x4


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 26
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static isFRAllowedForUser(I)Z
    .locals 0

    and-int/lit8 p0, p0, -0x5

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method
