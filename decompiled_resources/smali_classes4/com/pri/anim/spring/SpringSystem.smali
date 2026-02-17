.class public Lcom/pri/anim/spring/SpringSystem;
.super Lcom/pri/anim/spring/BaseSpringSystem;
.source "SpringSystem.java"


# direct methods
.method private constructor <init>(Lcom/pri/anim/spring/SpringLooper;)V
    .locals 0

    .line 15
    invoke-direct {p0, p1}, Lcom/pri/anim/spring/BaseSpringSystem;-><init>(Lcom/pri/anim/spring/SpringLooper;)V

    return-void
.end method

.method public static create()Lcom/pri/anim/spring/SpringSystem;
    .locals 2

    .line 11
    new-instance v0, Lcom/pri/anim/spring/SpringSystem;

    invoke-static {}, Lcom/pri/anim/spring/ChoreographerSpringLooper;->create()Lcom/pri/anim/spring/ChoreographerSpringLooper;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/pri/anim/spring/SpringSystem;-><init>(Lcom/pri/anim/spring/SpringLooper;)V

    return-object v0
.end method
