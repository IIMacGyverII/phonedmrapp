.class Lcom/android/internal/telephony/data/DataNetworkController$8;
.super Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;
.source "DataNetworkController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/DataNetworkController;->onRegisterAllEvents()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataNetworkController;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/DataNetworkController;)V
    .locals 0

    .line 990
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController$8;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-direct {p0}, Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;-><init>()V

    return-void
.end method


# virtual methods
.method public onSubscriptionsChanged()V
    .locals 1

    .line 993
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController$8;->this$0:Lcom/android/internal/telephony/data/DataNetworkController;

    const/16 v0, 0xf

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    return-void
.end method
