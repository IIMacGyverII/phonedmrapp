.class Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler$GsmCbTestBroadcastReceiver;
.super Lcom/android/internal/telephony/InboundSmsHandler$CbTestBroadcastReceiver;
.source "GsmInboundSmsHandler.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "GsmCbTestBroadcastReceiver"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;)V
    .locals 1

    .line 99
    iput-object p1, p0, Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler$GsmCbTestBroadcastReceiver;->this$0:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    const-string v0, "com.android.internal.telephony.gsm.TEST_TRIGGER_CELL_BROADCAST"

    .line 100
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/InboundSmsHandler$CbTestBroadcastReceiver;-><init>(Lcom/android/internal/telephony/InboundSmsHandler;Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method protected handleTestAction(Landroid/content/Intent;)V
    .locals 2

    const-string v0, "pdu"

    .line 105
    invoke-virtual {p1, v0}, Landroid/content/Intent;->getByteArrayExtra(Ljava/lang/String;)[B

    move-result-object v0

    if-nez v0, :cond_0

    const-string v0, "pdu_string"

    .line 107
    invoke-virtual {p1, v0}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 108
    iget-object v0, p0, Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler$GsmCbTestBroadcastReceiver;->this$0:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    invoke-static {v0, p1}, Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;->access$000(Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;Ljava/lang/String;)[B

    move-result-object v0

    :cond_0
    if-nez v0, :cond_1

    .line 111
    iget-object p0, p0, Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler$GsmCbTestBroadcastReceiver;->this$0:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    const-string p1, "No pdu or pdu_string extra, ignoring CB test intent"

    invoke-static {p0, p1}, Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;->access$100(Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;Ljava/lang/String;)V

    return-void

    .line 115
    :cond_1
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object p1

    const/4 v1, 0x0

    .line 116
    invoke-static {p1, v0, v1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 117
    iget-object p0, p0, Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler$GsmCbTestBroadcastReceiver;->this$0:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    invoke-static {p0}, Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;->access$200(Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;)Lcom/android/internal/telephony/CellBroadcastServiceManager;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/CellBroadcastServiceManager;->sendGsmMessageToHandler(Landroid/os/Message;)V

    return-void
.end method
