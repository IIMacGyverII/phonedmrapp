.class public final Lcom/android/internal/telephony/AsyncService$AsyncServiceInfo;
.super Ljava/lang/Object;
.source "AsyncService.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/AsyncService;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "AsyncServiceInfo"
.end annotation


# instance fields
.field public mHandler:Landroid/os/Handler;

.field public mRestartFlags:I


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 52
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
