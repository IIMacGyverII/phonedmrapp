.class Lcom/android/internal/telephony/IccSmsInterfaceManager$1;
.super Landroid/os/Handler;
.source "IccSmsInterfaceManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/IccSmsInterfaceManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/IccSmsInterfaceManager;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/IccSmsInterfaceManager;)V
    .locals 0

    .line 111
    iput-object p1, p0, Lcom/android/internal/telephony/IccSmsInterfaceManager$1;->this$0:Lcom/android/internal/telephony/IccSmsInterfaceManager;

    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method

.method private notifyPending(Lcom/android/internal/telephony/IccSmsInterfaceManager$Request;Ljava/lang/Object;)V
    .locals 0

    if-eqz p1, :cond_0

    .line 151
    monitor-enter p1

    .line 152
    :try_start_0
    iput-object p2, p1, Lcom/android/internal/telephony/IccSmsInterfaceManager$Request;->mResult:Ljava/lang/Object;

    .line 153
    iget-object p0, p1, Lcom/android/internal/telephony/IccSmsInterfaceManager$Request;->mStatus:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 p2, 0x1

    invoke-virtual {p0, p2}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 154
    invoke-virtual {p1}, Ljava/lang/Object;->notifyAll()V

    .line 155
    monitor-exit p1

    goto :goto_0

    :catchall_0
    move-exception p0

    monitor-exit p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0

    :cond_0
    :goto_0
    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 3

    .line 114
    iget-object v0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v0, Landroid/os/AsyncResult;

    .line 115
    iget-object v1, v0, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v1, Lcom/android/internal/telephony/IccSmsInterfaceManager$Request;

    .line 117
    iget p1, p1, Landroid/os/Message;->what:I

    const/4 v2, 0x0

    packed-switch p1, :pswitch_data_0

    goto :goto_3

    .line 139
    :pswitch_0
    iget-object p1, v0, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez p1, :cond_0

    .line 140
    iget-object p1, v0, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    move-object v2, p1

    check-cast v2, Ljava/lang/String;

    goto :goto_0

    .line 142
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/IccSmsInterfaceManager$1;->this$0:Lcom/android/internal/telephony/IccSmsInterfaceManager;

    const-string v0, "Cannot read SMSC"

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/IccSmsInterfaceManager;->loge(Ljava/lang/String;)V

    .line 144
    :goto_0
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/IccSmsInterfaceManager$1;->notifyPending(Lcom/android/internal/telephony/IccSmsInterfaceManager$Request;Ljava/lang/Object;)V

    goto :goto_3

    .line 122
    :pswitch_1
    iget-object p1, v0, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez p1, :cond_1

    const/4 p1, 0x1

    goto :goto_1

    :cond_1
    const/4 p1, 0x0

    :goto_1
    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p1

    invoke-direct {p0, v1, p1}, Lcom/android/internal/telephony/IccSmsInterfaceManager$1;->notifyPending(Lcom/android/internal/telephony/IccSmsInterfaceManager$Request;Ljava/lang/Object;)V

    goto :goto_3

    .line 126
    :pswitch_2
    iget-object p1, v0, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez p1, :cond_2

    .line 127
    iget-object p1, p0, Lcom/android/internal/telephony/IccSmsInterfaceManager$1;->this$0:Lcom/android/internal/telephony/IccSmsInterfaceManager;

    iget-object v2, v0, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast v2, Ljava/util/ArrayList;

    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/IccSmsInterfaceManager;->buildValidRawData(Ljava/util/ArrayList;)Ljava/util/ArrayList;

    move-result-object v2

    .line 129
    iget-object p1, p0, Lcom/android/internal/telephony/IccSmsInterfaceManager$1;->this$0:Lcom/android/internal/telephony/IccSmsInterfaceManager;

    iget-object v0, v0, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast v0, Ljava/util/ArrayList;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/IccSmsInterfaceManager;->markMessagesAsRead(Ljava/util/ArrayList;)V

    goto :goto_2

    :cond_2
    const/4 p1, 0x3

    const-string v0, "SMS"

    .line 131
    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->isLoggable(Ljava/lang/String;I)Z

    move-result p1

    if-eqz p1, :cond_3

    .line 132
    iget-object p1, p0, Lcom/android/internal/telephony/IccSmsInterfaceManager$1;->this$0:Lcom/android/internal/telephony/IccSmsInterfaceManager;

    const-string v0, "Cannot load Sms records"

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/IccSmsInterfaceManager;->loge(Ljava/lang/String;)V

    .line 135
    :cond_3
    :goto_2
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/IccSmsInterfaceManager$1;->notifyPending(Lcom/android/internal/telephony/IccSmsInterfaceManager$Request;Ljava/lang/Object;)V

    :goto_3
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_2
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method
