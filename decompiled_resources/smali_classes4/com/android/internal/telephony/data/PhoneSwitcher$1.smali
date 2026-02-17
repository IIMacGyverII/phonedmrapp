.class Lcom/android/internal/telephony/data/PhoneSwitcher$1;
.super Ljava/lang/Object;
.source "PhoneSwitcher.java"

# interfaces
.implements Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidationCallback;


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

    .line 204
    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$1;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onNetworkAvailable(Landroid/net/Network;I)V
    .locals 2

    .line 213
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$1;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    const/16 v0, 0x76

    const/4 v1, 0x0

    invoke-static {p0, v0, p2, v1, p1}, Landroid/os/Message;->obtain(Landroid/os/Handler;IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    .line 214
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public onValidationDone(ZI)V
    .locals 1

    .line 207
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$1;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    const/16 v0, 0x6e

    invoke-static {p0, v0, p2, p1}, Landroid/os/Message;->obtain(Landroid/os/Handler;III)Landroid/os/Message;

    move-result-object p0

    .line 208
    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method
