.class public abstract Lcom/pri/anim/spring/SpringLooper;
.super Ljava/lang/Object;
.source "SpringLooper.java"


# instance fields
.field protected mSpringSystem:Lcom/pri/anim/spring/BaseSpringSystem;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public setSpringSystem(Lcom/pri/anim/spring/BaseSpringSystem;)V
    .locals 0

    .line 16
    iput-object p1, p0, Lcom/pri/anim/spring/SpringLooper;->mSpringSystem:Lcom/pri/anim/spring/BaseSpringSystem;

    return-void
.end method

.method public abstract start()V
.end method

.method public abstract stop()V
.end method
