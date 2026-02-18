.class Lcom/android/internal/telephony/NetworkFactoryLegacyImpl$1;
.super Landroid/net/NetworkProvider;
.source "NetworkFactoryLegacyImpl.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->register(Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;Landroid/content/Context;Landroid/os/Looper;Ljava/lang/String;)V
    .locals 0

    .line 128
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl$1;->this$0:Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;

    invoke-direct {p0, p2, p3, p4}, Landroid/net/NetworkProvider;-><init>(Landroid/content/Context;Landroid/os/Looper;Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public onNetworkRequestWithdrawn(Landroid/net/NetworkRequest;)V
    .locals 0

    .line 137
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl$1;->this$0:Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->-$$Nest$mhandleRemoveRequest(Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;Landroid/net/NetworkRequest;)V

    return-void
.end method

.method public onNetworkRequested(Landroid/net/NetworkRequest;II)V
    .locals 0

    .line 132
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl$1;->this$0:Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;

    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/NetworkFactoryLegacyImpl;->handleAddRequest(Landroid/net/NetworkRequest;II)V

    return-void
.end method
