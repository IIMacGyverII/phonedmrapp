.class Lcom/android/internal/telephony/euicc/EuiccController$10;
.super Ljava/lang/Object;
.source "EuiccController.java"

# interfaces
.implements Lcom/android/internal/telephony/euicc/EuiccConnector$DumpEuiccServiceCommandCallback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/euicc/EuiccController;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/euicc/EuiccController;

.field final synthetic val$countDownLatch:Ljava/util/concurrent/CountDownLatch;

.field final synthetic val$pw:Ljava/io/PrintWriter;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/euicc/EuiccController;Ljava/io/PrintWriter;Ljava/util/concurrent/CountDownLatch;)V
    .locals 0

    .line 1652
    iput-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccController$10;->this$0:Lcom/android/internal/telephony/euicc/EuiccController;

    iput-object p2, p0, Lcom/android/internal/telephony/euicc/EuiccController$10;->val$pw:Ljava/io/PrintWriter;

    iput-object p3, p0, Lcom/android/internal/telephony/euicc/EuiccController$10;->val$countDownLatch:Ljava/util/concurrent/CountDownLatch;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onDumpEuiccServiceComplete(Ljava/lang/String;)V
    .locals 2

    .line 1655
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController$10;->val$pw:Ljava/io/PrintWriter;

    const-string v1, "===== EUICC SERVICE ====="

    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1656
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController$10;->val$pw:Ljava/io/PrintWriter;

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1657
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController$10;->val$countDownLatch:Ljava/util/concurrent/CountDownLatch;

    invoke-virtual {p0}, Ljava/util/concurrent/CountDownLatch;->countDown()V

    return-void
.end method

.method public onEuiccServiceUnavailable()V
    .locals 2

    .line 1662
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController$10;->val$pw:Ljava/io/PrintWriter;

    const-string v1, "===== EUICC SERVICE UNAVAILABLE ====="

    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1663
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController$10;->val$countDownLatch:Ljava/util/concurrent/CountDownLatch;

    invoke-virtual {p0}, Ljava/util/concurrent/CountDownLatch;->countDown()V

    return-void
.end method
