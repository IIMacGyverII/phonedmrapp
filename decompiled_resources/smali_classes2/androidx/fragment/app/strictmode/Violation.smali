.class public abstract Landroidx/fragment/app/strictmode/Violation;
.super Ljava/lang/RuntimeException;
.source "Violation.java"


# instance fields
.field final mFragment:Landroidx/fragment/app/Fragment;


# direct methods
.method constructor <init>(Landroidx/fragment/app/Fragment;)V
    .locals 0
    .param p1    # Landroidx/fragment/app/Fragment;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param

    .line 28
    invoke-direct {p0}, Ljava/lang/RuntimeException;-><init>()V

    .line 29
    iput-object p1, p0, Landroidx/fragment/app/strictmode/Violation;->mFragment:Landroidx/fragment/app/Fragment;

    return-void
.end method


# virtual methods
.method public getFragment()Landroidx/fragment/app/Fragment;
    .locals 0
    .annotation build Landroidx/annotation/NonNull;
    .end annotation

    .line 37
    iget-object p0, p0, Landroidx/fragment/app/strictmode/Violation;->mFragment:Landroidx/fragment/app/Fragment;

    return-object p0
.end method
