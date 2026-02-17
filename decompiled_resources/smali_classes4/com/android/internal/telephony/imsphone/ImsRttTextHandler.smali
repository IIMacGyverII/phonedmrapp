.class public Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;
.super Landroid/os/Handler;
.source "ImsRttTextHandler.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$InCallReaderThread;,
        Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$NetworkWriter;
    }
.end annotation


# static fields
.field private static final APPEND_TO_NETWORK_BUFFER:I = 0x2

.field private static final ATTEMPT_SEND_TO_NETWORK:I = 0x4

.field private static final EXPIRE_SENT_CODEPOINT_COUNT:I = 0x5

.field private static final INITIALIZE:I = 0x1

.field private static final LOG_TAG:Ljava/lang/String; = "ImsRttTextHandler"

.field public static final MAX_BUFFERED_CHARACTER_COUNT:I = 0x5

.field public static final MAX_BUFFERING_DELAY_MILLIS:I = 0xc8

.field public static final MAX_CODEPOINTS_PER_SECOND:I = 0x1e

.field private static final MILLIS_PER_SECOND:I = 0x3e8

.field private static final SEND_TO_INCALL:I = 0x3

.field private static final TEARDOWN:I = 0x270f


# instance fields
.field private mBufferedTextToIncall:Ljava/lang/StringBuffer;

.field private mBufferedTextToNetwork:Ljava/lang/StringBuffer;

.field private mCodepointsAvailableForTransmission:I

.field private final mNetworkWriter:Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$NetworkWriter;

.field private mReadNotifier:Ljava/util/concurrent/CountDownLatch;

.field private mReaderThread:Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$InCallReaderThread;

.field private mRttTextStream:Landroid/telecom/Connection$RttTextStream;


# direct methods
.method static bridge synthetic -$$Nest$fgetmReadNotifier(Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;)Ljava/util/concurrent/CountDownLatch;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mReadNotifier:Ljava/util/concurrent/CountDownLatch;

    return-object p0
.end method

.method public constructor <init>(Landroid/os/Looper;Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$NetworkWriter;)V
    .locals 0

    .line 206
    invoke-direct {p0, p1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    const/16 p1, 0x1e

    .line 110
    iput p1, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mCodepointsAvailableForTransmission:I

    .line 111
    new-instance p1, Ljava/lang/StringBuffer;

    invoke-direct {p1}, Ljava/lang/StringBuffer;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mBufferedTextToNetwork:Ljava/lang/StringBuffer;

    .line 115
    new-instance p1, Ljava/lang/StringBuffer;

    invoke-direct {p1}, Ljava/lang/StringBuffer;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mBufferedTextToIncall:Ljava/lang/StringBuffer;

    .line 207
    iput-object p2, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mNetworkWriter:Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$NetworkWriter;

    return-void
.end method


# virtual methods
.method public getBufferedTextToIncall()Ljava/lang/StringBuffer;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 230
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mBufferedTextToIncall:Ljava/lang/StringBuffer;

    return-object p0
.end method

.method public getNetworkBufferText()Ljava/lang/String;
    .locals 0

    .line 244
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mBufferedTextToNetwork:Ljava/lang/StringBuffer;

    invoke-virtual {p0}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getSendToIncall()I
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    const/4 p0, 0x3

    return p0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 7

    .line 120
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    const-string v2, "ImsRttTextHandler"

    if-eq v0, v1, :cond_a

    const/4 v1, 0x2

    const/4 v3, 0x5

    const/4 v4, 0x4

    const/4 v5, 0x0

    if-eq v0, v1, :cond_8

    const/4 v1, 0x3

    const/16 v6, 0x270f

    if-eq v0, v1, :cond_5

    const-wide/16 v1, 0x3e8

    if-eq v0, v4, :cond_3

    if-eq v0, v3, :cond_2

    if-eq v0, v6, :cond_0

    goto/16 :goto_0

    .line 192
    :cond_0
    :try_start_0
    iget-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mReaderThread:Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$InCallReaderThread;

    if-eqz p1, :cond_1

    .line 193
    invoke-virtual {p1}, Ljava/lang/Thread;->interrupt()V

    .line 194
    iget-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mReaderThread:Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$InCallReaderThread;

    invoke-virtual {p1, v1, v2}, Ljava/lang/Thread;->join(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_1
    const/4 p1, 0x0

    .line 199
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mReaderThread:Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$InCallReaderThread;

    .line 200
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mRttTextStream:Landroid/telecom/Connection$RttTextStream;

    goto/16 :goto_0

    .line 185
    :cond_2
    iget v0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mCodepointsAvailableForTransmission:I

    iget p1, p1, Landroid/os/Message;->arg1:I

    add-int/2addr v0, p1

    iput v0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mCodepointsAvailableForTransmission:I

    if-lez v0, :cond_c

    .line 187
    invoke-virtual {p0, v4}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto/16 :goto_0

    .line 165
    :cond_3
    iget-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mBufferedTextToNetwork:Ljava/lang/StringBuffer;

    .line 166
    invoke-virtual {p1}, Ljava/lang/StringBuffer;->length()I

    move-result v0

    .line 165
    invoke-virtual {p1, v5, v0}, Ljava/lang/StringBuffer;->codePointCount(II)I

    move-result p1

    .line 167
    iget v0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mCodepointsAvailableForTransmission:I

    invoke-static {p1, v0}, Ljava/lang/Math;->min(II)I

    move-result p1

    if-nez p1, :cond_4

    goto/16 :goto_0

    .line 172
    :cond_4
    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mBufferedTextToNetwork:Ljava/lang/StringBuffer;

    invoke-virtual {v0, v5, p1}, Ljava/lang/StringBuffer;->offsetByCodePoints(II)I

    move-result v0

    .line 175
    iget-object v4, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mBufferedTextToNetwork:Ljava/lang/StringBuffer;

    invoke-virtual {v4, v5, v0}, Ljava/lang/StringBuffer;->substring(II)Ljava/lang/String;

    move-result-object v4

    .line 177
    iget-object v6, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mBufferedTextToNetwork:Ljava/lang/StringBuffer;

    invoke-virtual {v6, v5, v0}, Ljava/lang/StringBuffer;->delete(II)Ljava/lang/StringBuffer;

    .line 178
    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mNetworkWriter:Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$NetworkWriter;

    invoke-interface {v0, v4}, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$NetworkWriter;->write(Ljava/lang/String;)V

    .line 179
    iget v0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mCodepointsAvailableForTransmission:I

    sub-int/2addr v0, p1

    iput v0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mCodepointsAvailableForTransmission:I

    .line 181
    invoke-virtual {p0, v3, p1, v5}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p1

    .line 180
    invoke-virtual {p0, p1, v1, v2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    goto/16 :goto_0

    .line 131
    :cond_5
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    if-nez p1, :cond_6

    const-string p0, "RTT msg.obj is null. Ignoring."

    .line 132
    invoke-static {v2, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 135
    :cond_6
    check-cast p1, Ljava/lang/String;

    .line 136
    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mRttTextStream:Landroid/telecom/Connection$RttTextStream;

    if-nez v0, :cond_7

    const-string v0, "RTT text stream is null. Writing to in-call buffer."

    .line 137
    invoke-static {v2, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 138
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mBufferedTextToIncall:Ljava/lang/StringBuffer;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    return-void

    .line 142
    :cond_7
    :try_start_1
    invoke-virtual {v0, p1}, Landroid/telecom/Connection$RttTextStream;->write(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_0

    :catch_1
    move-exception v0

    const-string v1, "IOException encountered writing to in-call: %s"

    .line 144
    invoke-static {v2, v1, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 145
    invoke-virtual {p0, v6}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {v0}, Landroid/os/Message;->sendToTarget()V

    .line 146
    iget-object p0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mBufferedTextToIncall:Ljava/lang/StringBuffer;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    goto :goto_0

    .line 151
    :cond_8
    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mBufferedTextToNetwork:Ljava/lang/StringBuffer;

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    .line 154
    iget-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mBufferedTextToNetwork:Ljava/lang/StringBuffer;

    .line 155
    invoke-virtual {p1}, Ljava/lang/StringBuffer;->length()I

    move-result v0

    invoke-virtual {p1, v5, v0}, Ljava/lang/StringBuffer;->codePointCount(II)I

    move-result p1

    if-lt p1, v3, :cond_9

    .line 157
    invoke-virtual {p0, v4}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto :goto_0

    :cond_9
    const-wide/16 v0, 0xc8

    .line 159
    invoke-virtual {p0, v4, v0, v1}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    goto :goto_0

    .line 122
    :cond_a
    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mRttTextStream:Landroid/telecom/Connection$RttTextStream;

    if-nez v0, :cond_d

    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mReaderThread:Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$InCallReaderThread;

    if-eqz v0, :cond_b

    goto :goto_1

    .line 126
    :cond_b
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/telecom/Connection$RttTextStream;

    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mRttTextStream:Landroid/telecom/Connection$RttTextStream;

    .line 127
    new-instance p1, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$InCallReaderThread;

    iget-object v0, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mRttTextStream:Landroid/telecom/Connection$RttTextStream;

    invoke-direct {p1, p0, v0}, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$InCallReaderThread;-><init>(Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;Landroid/telecom/Connection$RttTextStream;)V

    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mReaderThread:Lcom/android/internal/telephony/imsphone/ImsRttTextHandler$InCallReaderThread;

    .line 128
    invoke-virtual {p1}, Ljava/lang/Thread;->start()V

    :cond_c
    :goto_0
    return-void

    :cond_d
    :goto_1
    const-string p0, "RTT text stream already initialized. Ignoring."

    .line 123
    invoke-static {v2, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public initialize(Landroid/telecom/Connection$RttTextStream;)V
    .locals 2

    .line 215
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Initializing: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ImsRttTextHandler"

    invoke-static {v1, v0}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v0, 0x1

    .line 216
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public sendToInCall(Ljava/lang/String;)V
    .locals 1

    const/4 v0, 0x3

    .line 211
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method

.method public setReadNotifier(Ljava/util/concurrent/CountDownLatch;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 225
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mReadNotifier:Ljava/util/concurrent/CountDownLatch;

    return-void
.end method

.method public setRttTextStream(Landroid/telecom/Connection$RttTextStream;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 235
    iput-object p1, p0, Lcom/android/internal/telephony/imsphone/ImsRttTextHandler;->mRttTextStream:Landroid/telecom/Connection$RttTextStream;

    return-void
.end method

.method public tearDown()V
    .locals 1

    const/16 v0, 0x270f

    .line 220
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method
