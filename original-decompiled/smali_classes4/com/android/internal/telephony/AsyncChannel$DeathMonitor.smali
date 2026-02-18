.class final Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;
.super Ljava/lang/Object;
.source "AsyncChannel.java"

# interfaces
.implements Landroid/os/IBinder$DeathRecipient;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/AsyncChannel;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "DeathMonitor"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/AsyncChannel;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/AsyncChannel;)V
    .locals 0

    .line 947
    iput-object p1, p0, Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;->this$0:Lcom/android/internal/telephony/AsyncChannel;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public binderDied()V
    .locals 1

    .line 951
    iget-object p0, p0, Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;->this$0:Lcom/android/internal/telephony/AsyncChannel;

    const/4 v0, 0x4

    invoke-static {p0, v0}, Lcom/android/internal/telephony/AsyncChannel;->-$$Nest$mreplyDisconnected(Lcom/android/internal/telephony/AsyncChannel;I)V

    return-void
.end method
