.class public interface abstract Landroidx/fragment/app/strictmode/FragmentStrictMode$OnViolationListener;
.super Ljava/lang/Object;
.source "FragmentStrictMode.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroidx/fragment/app/strictmode/FragmentStrictMode;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x609
    name = "OnViolationListener"
.end annotation


# virtual methods
.method public abstract onViolation(Landroidx/fragment/app/strictmode/Violation;)V
    .param p1    # Landroidx/fragment/app/strictmode/Violation;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
.end method
