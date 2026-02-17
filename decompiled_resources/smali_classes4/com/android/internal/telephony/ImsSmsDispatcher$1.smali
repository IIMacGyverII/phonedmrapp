.class Lcom/android/internal/telephony/ImsSmsDispatcher$1;
.super Ljava/lang/Object;
.source "ImsSmsDispatcher.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/ImsSmsDispatcher;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/ImsSmsDispatcher;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/ImsSmsDispatcher;)V
    .locals 0

    .line 89
    iput-object p1, p0, Lcom/android/internal/telephony/ImsSmsDispatcher$1;->this$0:Lcom/android/internal/telephony/ImsSmsDispatcher;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 0

    .line 92
    iget-object p0, p0, Lcom/android/internal/telephony/ImsSmsDispatcher$1;->this$0:Lcom/android/internal/telephony/ImsSmsDispatcher;

    invoke-static {p0}, Lcom/android/internal/telephony/ImsSmsDispatcher;->-$$Nest$fgetmImsManagerConnector(Lcom/android/internal/telephony/ImsSmsDispatcher;)Lcom/android/ims/FeatureConnector;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/ims/FeatureConnector;->connect()V

    return-void
.end method
