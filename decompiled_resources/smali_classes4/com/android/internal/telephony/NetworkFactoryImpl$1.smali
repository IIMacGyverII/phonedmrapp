.class Lcom/android/internal/telephony/NetworkFactoryImpl$1;
.super Ljava/lang/Object;
.source "NetworkFactoryImpl.java"

# interfaces
.implements Landroid/net/NetworkProvider$NetworkOfferCallback;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/NetworkFactoryImpl;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/NetworkFactoryImpl;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/NetworkFactoryImpl;)V
    .locals 0

    .line 114
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkFactoryImpl$1;->this$0:Lcom/android/internal/telephony/NetworkFactoryImpl;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onNetworkNeeded(Landroid/net/NetworkRequest;)V
    .locals 0

    .line 117
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkFactoryImpl$1;->this$0:Lcom/android/internal/telephony/NetworkFactoryImpl;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl;->-$$Nest$mhandleAddRequest(Lcom/android/internal/telephony/NetworkFactoryImpl;Landroid/net/NetworkRequest;)V

    return-void
.end method

.method public onNetworkUnneeded(Landroid/net/NetworkRequest;)V
    .locals 0

    .line 122
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkFactoryImpl$1;->this$0:Lcom/android/internal/telephony/NetworkFactoryImpl;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/NetworkFactoryImpl;->-$$Nest$mhandleRemoveRequest(Lcom/android/internal/telephony/NetworkFactoryImpl;Landroid/net/NetworkRequest;)V

    return-void
.end method
