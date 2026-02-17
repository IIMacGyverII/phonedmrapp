.class Lcom/android/internal/telephony/data/TelephonyNetworkFactory$1;
.super Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;
.source "TelephonyNetworkFactory.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/TelephonyNetworkFactory;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/TelephonyNetworkFactory;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/TelephonyNetworkFactory;)V
    .locals 0

    .line 128
    iput-object p1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$1;->this$0:Lcom/android/internal/telephony/data/TelephonyNetworkFactory;

    invoke-direct {p0}, Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;-><init>()V

    return-void
.end method


# virtual methods
.method public onSubscriptionsChanged()V
    .locals 1

    .line 131
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory$1;->this$0:Lcom/android/internal/telephony/data/TelephonyNetworkFactory;

    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkFactory;->mInternalHandler:Landroid/os/Handler;

    const/4 v0, 0x2

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    return-void
.end method
