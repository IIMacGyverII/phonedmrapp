.class Lcom/android/internal/telephony/metrics/PersistAtomsStorage$1;
.super Ljava/lang/Object;
.source "PersistAtomsStorage.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/metrics/PersistAtomsStorage;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/metrics/PersistAtomsStorage;)V
    .locals 0

    .line 173
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$1;->this$0:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 0

    .line 176
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$1;->this$0:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->-$$Nest$msaveAtomsToFileNow(Lcom/android/internal/telephony/metrics/PersistAtomsStorage;)V

    return-void
.end method
