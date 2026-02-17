.class Lcom/android/internal/telephony/MockModem$MockModemConnection;
.super Ljava/lang/Object;
.source "MockModem.java"

# interfaces
.implements Landroid/content/ServiceConnection;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/MockModem;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "MockModemConnection"
.end annotation


# instance fields
.field private mService:I

.field final synthetic this$0:Lcom/android/internal/telephony/MockModem;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/MockModem;I)V
    .locals 0

    .line 83
    iput-object p1, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 84
    iput p2, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->mService:I

    return-void
.end method


# virtual methods
.method public onServiceConnected(Landroid/content/ComponentName;Landroid/os/IBinder;)V
    .locals 2

    .line 89
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "IRadio "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    iget v1, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->mService:I

    invoke-static {v0, v1}, Lcom/android/internal/telephony/MockModem;->-$$Nest$mgetModuleName(Lcom/android/internal/telephony/MockModem;I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "  - onServiceConnected"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "MockModem"

    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 91
    iget p1, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->mService:I

    const/4 v0, 0x3

    if-ne p1, v0, :cond_0

    .line 92
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, p2}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmModemBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    goto :goto_0

    :cond_0
    const/4 v0, 0x5

    if-ne p1, v0, :cond_1

    .line 94
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, p2}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmSimBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    goto :goto_0

    :cond_1
    const/4 v0, 0x2

    if-ne p1, v0, :cond_2

    .line 96
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, p2}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmMessagingBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    goto :goto_0

    :cond_2
    const/4 v0, 0x1

    if-ne p1, v0, :cond_3

    .line 98
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, p2}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmDataBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    goto :goto_0

    :cond_3
    const/4 v0, 0x4

    if-ne p1, v0, :cond_4

    .line 100
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, p2}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmNetworkBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    goto :goto_0

    :cond_4
    const/4 v0, 0x6

    if-ne p1, v0, :cond_5

    .line 102
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, p2}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmVoiceBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    goto :goto_0

    :cond_5
    const/4 v0, 0x7

    if-ne p1, v0, :cond_6

    .line 104
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, p2}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmConfigBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    :cond_6
    :goto_0
    return-void
.end method

.method public onServiceDisconnected(Landroid/content/ComponentName;)V
    .locals 2

    .line 110
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "IRadio "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    iget v1, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->mService:I

    invoke-static {v0, v1}, Lcom/android/internal/telephony/MockModem;->-$$Nest$mgetModuleName(Lcom/android/internal/telephony/MockModem;I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "  - onServiceDisconnected"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "MockModem"

    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 112
    iget p1, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->mService:I

    const/4 v0, 0x0

    const/4 v1, 0x3

    if-ne p1, v1, :cond_0

    .line 113
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, v0}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmModemBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    goto :goto_0

    :cond_0
    const/4 v1, 0x5

    if-ne p1, v1, :cond_1

    .line 115
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, v0}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmSimBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    goto :goto_0

    :cond_1
    const/4 v1, 0x2

    if-ne p1, v1, :cond_2

    .line 117
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, v0}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmMessagingBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    goto :goto_0

    :cond_2
    const/4 v1, 0x1

    if-ne p1, v1, :cond_3

    .line 119
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, v0}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmDataBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    goto :goto_0

    :cond_3
    const/4 v1, 0x4

    if-ne p1, v1, :cond_4

    .line 121
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, v0}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmNetworkBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    goto :goto_0

    :cond_4
    const/4 v1, 0x6

    if-ne p1, v1, :cond_5

    .line 123
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, v0}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmVoiceBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    goto :goto_0

    :cond_5
    const/4 v1, 0x7

    if-ne p1, v1, :cond_6

    .line 125
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem$MockModemConnection;->this$0:Lcom/android/internal/telephony/MockModem;

    invoke-static {p0, v0}, Lcom/android/internal/telephony/MockModem;->-$$Nest$fputmConfigBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V

    :cond_6
    :goto_0
    return-void
.end method
