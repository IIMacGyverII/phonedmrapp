.class Lcom/android/internal/telephony/data/DataProfileManager$1;
.super Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;
.source "DataProfileManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/DataProfileManager;->registerAllEvents()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/DataProfileManager;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/DataProfileManager;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 159
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataProfileManager$1;->this$0:Lcom/android/internal/telephony/data/DataProfileManager;

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onInternetDataNetworkConnected(Ljava/util/List;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/data/DataProfile;",
            ">;)V"
        }
    .end annotation

    .line 163
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager$1;->this$0:Lcom/android/internal/telephony/data/DataProfileManager;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->-$$Nest$monInternetDataNetworkConnected(Lcom/android/internal/telephony/data/DataProfileManager;Ljava/util/List;)V

    return-void
.end method
