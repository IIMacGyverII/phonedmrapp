.class Lcom/android/internal/telephony/data/PhoneSwitcher$5;
.super Landroid/content/BroadcastReceiver;
.source "PhoneSwitcher.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/PhoneSwitcher;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/PhoneSwitcher;)V
    .locals 0

    .line 590
    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$5;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 0

    .line 593
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$5;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    const/16 p1, 0x65

    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    .line 594
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method
