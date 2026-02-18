.class Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;
.super Landroid/os/AsyncTask;
.source "SMSDispatcher.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "AsyncPersistOrUpdateTask"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroid/os/AsyncTask<",
        "Ljava/lang/Void;",
        "Ljava/lang/Void;",
        "Ljava/lang/Void;",
        ">;"
    }
.end annotation


# instance fields
.field private final mContext:Landroid/content/Context;

.field private mError:I

.field private mErrorCode:I

.field private mFail:Z

.field private mMessageType:I

.field final synthetic this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;Landroid/content/Context;IIIZ)V
    .locals 0

    .line 2520
    iput-object p1, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    invoke-direct {p0}, Landroid/os/AsyncTask;-><init>()V

    .line 2521
    iput-object p2, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mContext:Landroid/content/Context;

    .line 2522
    iput p3, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mMessageType:I

    .line 2523
    iput p4, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mErrorCode:I

    .line 2524
    iput p5, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mError:I

    .line 2525
    iput-boolean p6, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mFail:Z

    return-void
.end method


# virtual methods
.method protected bridge synthetic doInBackground([Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    .line 2512
    check-cast p1, [Ljava/lang/Void;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->doInBackground([Ljava/lang/Void;)Ljava/lang/Void;

    move-result-object p0

    return-object p0
.end method

.method protected varargs doInBackground([Ljava/lang/Void;)Ljava/lang/Void;
    .locals 2

    .line 2530
    iget-object p1, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    iget-object v0, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mContext:Landroid/content/Context;

    iget v1, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mMessageType:I

    iget p0, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mErrorCode:I

    invoke-static {p1, v0, v1, p0}, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->-$$Nest$mpersistOrUpdateMessage(Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;Landroid/content/Context;II)V

    const/4 p0, 0x0

    return-object p0
.end method

.method protected bridge synthetic onPostExecute(Ljava/lang/Object;)V
    .locals 0

    .line 2512
    check-cast p1, Ljava/lang/Void;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->onPostExecute(Ljava/lang/Void;)V

    return-void
.end method

.method protected onPostExecute(Ljava/lang/Void;)V
    .locals 5

    const-string p1, "pdu"

    const-string/jumbo v0, "smsc"

    const-string v1, "SMSDispatcher"

    .line 2536
    iget-object v2, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    iget-object v2, v2, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mSentIntent:Landroid/app/PendingIntent;

    if-eqz v2, :cond_7

    .line 2539
    :try_start_0
    new-instance v2, Landroid/content/Intent;

    invoke-direct {v2}, Landroid/content/Intent;-><init>()V

    .line 2540
    iget-object v3, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    iget-object v3, v3, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mMessageUri:Landroid/net/Uri;

    if-eqz v3, :cond_0

    const-string/jumbo v4, "uri"

    .line 2542
    invoke-virtual {v3}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v4, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 2544
    :cond_0
    iget-boolean v3, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mFail:Z

    if-eqz v3, :cond_1

    iget v3, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mErrorCode:I

    if-eqz v3, :cond_1

    const-string v4, "errorCode"

    .line 2545
    invoke-virtual {v2, v4, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 2547
    :cond_1
    iget-object v3, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    invoke-static {v3}, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->-$$Nest$fgetmUnsentPartCount(Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;)Ljava/util/concurrent/atomic/AtomicInteger;

    move-result-object v3

    if-eqz v3, :cond_2

    const-string v3, "SendNextMsg"

    const/4 v4, 0x1

    .line 2549
    invoke-virtual {v2, v3, v4}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    .line 2554
    :cond_2
    iget-object v3, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    iget-object v3, v3, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mData:Ljava/util/HashMap;

    const/4 v4, 0x0

    if-eqz v3, :cond_5

    .line 2555
    invoke-virtual {v3, v0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    if-eqz v3, :cond_3

    .line 2556
    iget-object v3, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    iget-object v3, v3, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mData:Ljava/util/HashMap;

    invoke-virtual {v3, v0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [B

    array-length v0, v0

    goto :goto_0

    :cond_3
    move v0, v4

    .line 2558
    :goto_0
    iget-object v3, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    iget-object v3, v3, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mData:Ljava/util/HashMap;

    invoke-virtual {v3, p1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    if-eqz v3, :cond_4

    .line 2559
    iget-object v3, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    iget-object v3, v3, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mData:Ljava/util/HashMap;

    invoke-virtual {v3, p1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [B

    array-length v4, p1

    :cond_4
    add-int/2addr v4, v0

    .line 2563
    :cond_5
    sget-object p1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->PDU_SIZE:Ljava/lang/String;

    invoke-virtual {v2, p1, v4}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 2564
    iget-boolean p1, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mFail:Z

    if-nez p1, :cond_6

    .line 2565
    sget-object p1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->MSG_REF_NUM:Ljava/lang/String;

    iget-object v0, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    iget v0, v0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mMessageRef:I

    invoke-virtual {v2, p1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 2566
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "message reference number : "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    iget v0, v0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mMessageRef:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 2567
    iget-object p1, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    iget-object p1, p1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mSentIntent:Landroid/app/PendingIntent;

    iget-object p0, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mContext:Landroid/content/Context;

    const/4 v0, -0x1

    invoke-virtual {p1, p0, v0, v2}, Landroid/app/PendingIntent;->send(Landroid/content/Context;ILandroid/content/Intent;)V

    goto :goto_1

    .line 2569
    :cond_6
    iget-object p1, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->this$0:Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    iget-object p1, p1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mSentIntent:Landroid/app/PendingIntent;

    iget-object v0, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mContext:Landroid/content/Context;

    iget p0, p0, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker$AsyncPersistOrUpdateTask;->mError:I

    invoke-virtual {p1, v0, p0, v2}, Landroid/app/PendingIntent;->send(Landroid/content/Context;ILandroid/content/Intent;)V
    :try_end_0
    .catch Landroid/app/PendingIntent$CanceledException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    const-string p0, "Failed to send result"

    .line 2572
    invoke-static {v1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_7
    :goto_1
    return-void
.end method
