.class public abstract Landroidx/fragment/app/strictmode/RetainInstanceUsageViolation;
.super Landroidx/fragment/app/strictmode/Violation;
.source "RetainInstanceUsageViolation.java"


# direct methods
.method constructor <init>(Landroidx/fragment/app/Fragment;)V
    .locals 0
    .param p1    # Landroidx/fragment/app/Fragment;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 26
    invoke-direct {p0, p1}, Landroidx/fragment/app/strictmode/Violation;-><init>(Landroidx/fragment/app/Fragment;)V

    return-void
.end method
