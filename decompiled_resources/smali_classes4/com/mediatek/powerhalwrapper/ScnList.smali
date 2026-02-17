.class public Lcom/mediatek/powerhalwrapper/ScnList;
.super Ljava/lang/Object;
.source "ScnList.java"


# instance fields
.field public handle:I

.field public pid:I

.field public uid:I


# direct methods
.method constructor <init>(III)V
    .locals 0

    .line 49
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 50
    iput p1, p0, Lcom/mediatek/powerhalwrapper/ScnList;->handle:I

    .line 51
    iput p2, p0, Lcom/mediatek/powerhalwrapper/ScnList;->pid:I

    .line 52
    iput p3, p0, Lcom/mediatek/powerhalwrapper/ScnList;->uid:I

    return-void
.end method


# virtual methods
.method public gethandle()I
    .locals 0

    .line 72
    iget p0, p0, Lcom/mediatek/powerhalwrapper/ScnList;->handle:I

    return p0
.end method

.method public getpid()I
    .locals 0

    .line 56
    iget p0, p0, Lcom/mediatek/powerhalwrapper/ScnList;->pid:I

    return p0
.end method

.method public getuid()I
    .locals 0

    .line 64
    iget p0, p0, Lcom/mediatek/powerhalwrapper/ScnList;->uid:I

    return p0
.end method

.method public setPack_Name(I)V
    .locals 0

    .line 68
    iput p1, p0, Lcom/mediatek/powerhalwrapper/ScnList;->uid:I

    return-void
.end method

.method public sethandle(I)V
    .locals 0

    .line 76
    iput p1, p0, Lcom/mediatek/powerhalwrapper/ScnList;->handle:I

    return-void
.end method

.method public setpid(I)V
    .locals 0

    .line 60
    iput p1, p0, Lcom/mediatek/powerhalwrapper/ScnList;->pid:I

    return-void
.end method
