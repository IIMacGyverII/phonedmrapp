.class final Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;
.super Ljava/lang/Object;
.source "AsyncChannel.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/AsyncChannel;->connect(Landroid/content/Context;Landroid/os/Handler;Ljava/lang/String;Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x10
    name = "ConnectAsync"
.end annotation


# instance fields
.field mDstClassName:Ljava/lang/String;

.field mDstPackageName:Ljava/lang/String;

.field mSrcCtx:Landroid/content/Context;

.field mSrcHdlr:Landroid/os/Handler;

.field final synthetic this$0:Lcom/android/internal/telephony/AsyncChannel;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/AsyncChannel;Landroid/content/Context;Landroid/os/Handler;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 334
    iput-object p1, p0, Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;->this$0:Lcom/android/internal/telephony/AsyncChannel;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 335
    iput-object p2, p0, Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;->mSrcCtx:Landroid/content/Context;

    .line 336
    iput-object p3, p0, Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;->mSrcHdlr:Landroid/os/Handler;

    .line 337
    iput-object p4, p0, Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;->mDstPackageName:Ljava/lang/String;

    .line 338
    iput-object p5, p0, Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;->mDstClassName:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public run()V
    .locals 5

    .line 343
    iget-object v0, p0, Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;->this$0:Lcom/android/internal/telephony/AsyncChannel;

    iget-object v1, p0, Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;->mSrcCtx:Landroid/content/Context;

    iget-object v2, p0, Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;->mSrcHdlr:Landroid/os/Handler;

    iget-object v3, p0, Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;->mDstPackageName:Ljava/lang/String;

    iget-object v4, p0, Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;->mDstClassName:Ljava/lang/String;

    invoke-virtual {v0, v1, v2, v3, v4}, Lcom/android/internal/telephony/AsyncChannel;->connectSrcHandlerToPackageSync(Landroid/content/Context;Landroid/os/Handler;Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    .line 345
    iget-object p0, p0, Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;->this$0:Lcom/android/internal/telephony/AsyncChannel;

    invoke-static {p0, v0}, Lcom/android/internal/telephony/AsyncChannel;->-$$Nest$mreplyHalfConnected(Lcom/android/internal/telephony/AsyncChannel;I)V

    return-void
.end method
