.class Lcom/pri/prizeinterphone/ymodem/YModemManager$1;
.super Ljava/lang/Object;
.source "YModemManager.java"

# interfaces
.implements Lcom/pri/prizeinterphone/ymodem/YModemListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/ymodem/YModemManager;->startUpdateFirmware()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/ymodem/YModemManager;)V
    .locals 0

    .line 118
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onDataReady([BI)V
    .locals 2

    .line 121
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$fgetmYModemThread(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Lcom/pri/prizeinterphone/ymodem/YModemThread;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->write([B)Z

    const/4 p1, 0x2

    if-eq p1, p2, :cond_0

    const/4 p1, 0x4

    if-ne p1, p2, :cond_1

    .line 123
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    const/4 v0, 0x0

    invoke-static {p1, p2, v0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$mnotifyUpdate2Notification(Lcom/pri/prizeinterphone/ymodem/YModemManager;II)V

    .line 125
    :cond_1
    iget-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$fgetmClientMessengers(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Ljava/util/Set;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/Set;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_2

    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$sfgetmCanSendClientWhenOnDataReadySet()Landroidx/collection/ArraySet;

    move-result-object p1

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroidx/collection/ArraySet;->contains(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 126
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object p1

    const/16 v0, 0x82

    .line 127
    iput v0, p1, Landroid/os/Message;->what:I

    .line 128
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->anYModemTXMsg()Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->withStep(I)Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;

    move-result-object p2

    invoke-virtual {p2}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->build()Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;

    move-result-object p2

    iput-object p2, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 129
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {p0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$fgetmClientMessengers(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Ljava/util/Set;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p0

    .line 130
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_2

    .line 131
    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/os/Messenger;

    .line 133
    :try_start_0
    invoke-virtual {p2, p1}, Landroid/os/Messenger;->send(Landroid/os/Message;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p2

    .line 135
    invoke-interface {p0}, Ljava/util/Iterator;->remove()V

    const-string v0, "YModemManager"

    const-string v1, "onDataReady error"

    .line 136
    invoke-static {v0, v1, p2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0

    :cond_2
    return-void
.end method

.method public onFailed(Ljava/lang/String;)V
    .locals 4

    .line 197
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onFailed,reason="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "YModemManager"

    invoke-static {v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 198
    iget-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    const/16 v1, 0x40

    const/16 v2, 0x64

    invoke-static {p1, v1, v2}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$mnotifyUpdate2Notification(Lcom/pri/prizeinterphone/ymodem/YModemManager;II)V

    .line 199
    iget-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$fgetmClientMessengers(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Ljava/util/Set;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/Set;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_0

    .line 200
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object p1

    const/16 v2, 0x82

    .line 201
    iput v2, p1, Landroid/os/Message;->what:I

    .line 202
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->anYModemTXMsg()Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->withStep(I)Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->build()Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;

    move-result-object v1

    iput-object v1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 203
    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {v1}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$fgetmClientMessengers(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    .line 204
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 205
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/os/Messenger;

    .line 207
    :try_start_0
    invoke-virtual {v2, p1}, Landroid/os/Messenger;->send(Landroid/os/Message;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v2

    .line 209
    invoke-interface {v1}, Ljava/util/Iterator;->remove()V

    const-string v3, "onFailed error"

    .line 210
    invoke-static {v0, v3, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 211
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v2

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/manager/DmrManager;->restartApp()V

    const-string v2, "onFailed restart app"

    .line 212
    invoke-static {v0, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 216
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {p1}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$fgetmYModemThread(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Lcom/pri/prizeinterphone/ymodem/YModemThread;

    move-result-object p1

    if-eqz p1, :cond_1

    .line 217
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {p0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$fgetmYModemThread(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Lcom/pri/prizeinterphone/ymodem/YModemThread;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->stopRead()V

    :cond_1
    const-string p0, "3"

    .line 219
    invoke-static {p0}, Lcom/pri/prizeinterphone/Util/Util;->setDMRUpdateStatusToNvram(Ljava/lang/String;)Z

    return-void
.end method

.method public onProgress(II)V
    .locals 6

    .line 144
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "currentSent="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ",total="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "YModemManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    int-to-double v2, p1

    int-to-double v4, p2

    div-double/2addr v2, v4

    const-wide/high16 v4, 0x4059000000000000L    # 100.0

    mul-double/2addr v2, v4

    .line 146
    invoke-static {v2, v3}, Ljava/lang/Math;->round(D)J

    move-result-wide v2

    long-to-int v0, v2

    const/16 v2, 0x8

    const/16 v3, 0x64

    if-eq v0, v3, :cond_0

    .line 148
    iget-object v3, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {v3, v2, v0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$mnotifyUpdate2Notification(Lcom/pri/prizeinterphone/ymodem/YModemManager;II)V

    .line 150
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$fgetmClientMessengers(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_1

    .line 151
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    const/16 v3, 0x82

    .line 152
    iput v3, v0, Landroid/os/Message;->what:I

    .line 153
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->anYModemTXMsg()Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->withStep(I)Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;

    move-result-object v2

    invoke-virtual {v2, p2}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->withTotal(I)Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;

    move-result-object p2

    .line 154
    invoke-virtual {p2, p1}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->withCurrentSent(I)Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->build()Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;

    move-result-object p1

    iput-object p1, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 155
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {p0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$fgetmClientMessengers(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Ljava/util/Set;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p0

    .line 156
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 157
    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/os/Messenger;

    .line 159
    :try_start_0
    invoke-virtual {p1, v0}, Landroid/os/Messenger;->send(Landroid/os/Message;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 161
    invoke-interface {p0}, Ljava/util/Iterator;->remove()V

    const-string p2, "onProgress error"

    .line 162
    invoke-static {v1, p2, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0

    :cond_1
    return-void
.end method

.method public onSuccess()V
    .locals 5

    const-string v0, "YModemManager"

    const-string v1, "onSuccess"

    .line 170
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 171
    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    const/16 v2, 0x20

    const/16 v3, 0x64

    invoke-static {v1, v2, v3}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$mnotifyUpdate2Notification(Lcom/pri/prizeinterphone/ymodem/YModemManager;II)V

    .line 172
    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {v1}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$fgetmClientMessengers(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_0

    .line 173
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v1

    const/16 v3, 0x82

    .line 174
    iput v3, v1, Landroid/os/Message;->what:I

    .line 175
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->anYModemTXMsg()Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->withStep(I)Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;

    move-result-object v2

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;->build()Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;

    move-result-object v2

    iput-object v2, v1, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 176
    iget-object v2, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {v2}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$fgetmClientMessengers(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Ljava/util/Set;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    .line 177
    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_0

    .line 178
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/os/Messenger;

    .line 180
    :try_start_0
    invoke-virtual {v3, v1}, Landroid/os/Messenger;->send(Landroid/os/Message;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v3

    .line 182
    invoke-interface {v2}, Ljava/util/Iterator;->remove()V

    const-string v4, "onSuccess error"

    .line 183
    invoke-static {v0, v4, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    const-string v3, "onSuccess restart app"

    .line 184
    invoke-static {v0, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 185
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/manager/DmrManager;->restartApp()V

    goto :goto_0

    .line 189
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$fgetmYModemThread(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Lcom/pri/prizeinterphone/ymodem/YModemThread;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 190
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;->this$0:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {p0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->-$$Nest$fgetmYModemThread(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Lcom/pri/prizeinterphone/ymodem/YModemThread;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->stopRead()V

    :cond_1
    const-string p0, "1"

    .line 192
    invoke-static {p0}, Lcom/pri/prizeinterphone/Util/Util;->setDMRUpdateStatusToNvram(Ljava/lang/String;)Z

    return-void
.end method
