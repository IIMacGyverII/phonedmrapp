.class public Lcom/android/internal/telephony/AsyncChannel;
.super Ljava/lang/Object;
.source "AsyncChannel.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;,
        Lcom/android/internal/telephony/AsyncChannel$AsyncChannelConnection;,
        Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;
    }
.end annotation


# static fields
.field private static final BASE:I = 0x11000

.field public static final CMD_CHANNEL_DISCONNECT:I = 0x11003

.field public static final CMD_CHANNEL_DISCONNECTED:I = 0x11004

.field public static final CMD_CHANNEL_FULLY_CONNECTED:I = 0x11002

.field public static final CMD_CHANNEL_FULL_CONNECTION:I = 0x11001

.field public static final CMD_CHANNEL_HALF_CONNECTED:I = 0x11000

.field private static final CMD_TO_STRING_COUNT:I = 0x5

.field private static final DBG:Z = false

.field public static final STATUS_BINDING_UNSUCCESSFUL:I = 0x1

.field public static final STATUS_FULL_CONNECTION_REFUSED_ALREADY_CONNECTED:I = 0x3

.field public static final STATUS_REMOTE_DISCONNECTION:I = 0x4

.field public static final STATUS_SEND_UNSUCCESSFUL:I = 0x2

.field public static final STATUS_SUCCESSFUL:I = 0x0

.field private static final TAG:Ljava/lang/String; = "AsyncChannel"

.field private static sCmdToString:[Ljava/lang/String;


# instance fields
.field private mConnection:Lcom/android/internal/telephony/AsyncChannel$AsyncChannelConnection;

.field private mDeathMonitor:Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;

.field private mDstMessenger:Landroid/os/Messenger;

.field private mSrcContext:Landroid/content/Context;

.field private mSrcHandler:Landroid/os/Handler;

.field private mSrcMessenger:Landroid/os/Messenger;


# direct methods
.method static bridge synthetic -$$Nest$fputmDstMessenger(Lcom/android/internal/telephony/AsyncChannel;Landroid/os/Messenger;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/AsyncChannel;->mDstMessenger:Landroid/os/Messenger;

    return-void
.end method

.method static bridge synthetic -$$Nest$mreplyDisconnected(Lcom/android/internal/telephony/AsyncChannel;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/AsyncChannel;->replyDisconnected(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mreplyHalfConnected(Lcom/android/internal/telephony/AsyncChannel;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/AsyncChannel;->replyHalfConnected(I)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 3

    const/4 v0, 0x5

    new-array v0, v0, [Ljava/lang/String;

    .line 158
    sput-object v0, Lcom/android/internal/telephony/AsyncChannel;->sCmdToString:[Ljava/lang/String;

    const/4 v1, 0x0

    const-string v2, "CMD_CHANNEL_HALF_CONNECTED"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "CMD_CHANNEL_FULL_CONNECTION"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, "CMD_CHANNEL_FULLY_CONNECTED"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "CMD_CHANNEL_DISCONNECT"

    aput-object v2, v0, v1

    const/4 v1, 0x4

    const-string v2, "CMD_CHANNEL_DISCONNECTED"

    aput-object v2, v0, v1

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 214
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method protected static cmdToString(I)Ljava/lang/String;
    .locals 2

    const v0, 0x11000

    sub-int/2addr p0, v0

    if-ltz p0, :cond_0

    .line 169
    sget-object v0, Lcom/android/internal/telephony/AsyncChannel;->sCmdToString:[Ljava/lang/String;

    array-length v1, v0

    if-ge p0, v1, :cond_0

    .line 170
    aget-object p0, v0, p0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private linkToDeathMonitor()Z
    .locals 3

    .line 888
    iget-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mConnection:Lcom/android/internal/telephony/AsyncChannel$AsyncChannelConnection;

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mDeathMonitor:Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;

    if-nez v0, :cond_0

    .line 889
    new-instance v0, Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;-><init>(Lcom/android/internal/telephony/AsyncChannel;)V

    iput-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mDeathMonitor:Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;

    const/4 v0, 0x0

    .line 891
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/AsyncChannel;->mDstMessenger:Landroid/os/Messenger;

    invoke-virtual {v1}, Landroid/os/Messenger;->getBinder()Landroid/os/IBinder;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/AsyncChannel;->mDeathMonitor:Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;

    invoke-interface {v1, v2, v0}, Landroid/os/IBinder;->linkToDeath(Landroid/os/IBinder$DeathRecipient;I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const/4 v1, 0x0

    .line 893
    iput-object v1, p0, Lcom/android/internal/telephony/AsyncChannel;->mDeathMonitor:Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;

    return v0

    :cond_0
    :goto_0
    const/4 p0, 0x1

    return p0
.end method

.method private static log(Ljava/lang/String;)V
    .locals 1

    const-string v0, "AsyncChannel"

    .line 942
    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private replyDisconnected(I)V
    .locals 2

    .line 908
    iget-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcHandler:Landroid/os/Handler;

    if-nez v0, :cond_0

    return-void

    :cond_0
    const v1, 0x11004

    .line 909
    invoke-virtual {v0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    .line 910
    iput p1, v0, Landroid/os/Message;->arg1:I

    .line 911
    iput-object p0, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 912
    iget-object p1, p0, Lcom/android/internal/telephony/AsyncChannel;->mDstMessenger:Landroid/os/Messenger;

    iput-object p1, v0, Landroid/os/Message;->replyTo:Landroid/os/Messenger;

    .line 913
    iget-object p0, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcHandler:Landroid/os/Handler;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method private replyHalfConnected(I)V
    .locals 2

    .line 870
    iget-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcHandler:Landroid/os/Handler;

    const v1, 0x11000

    invoke-virtual {v0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    .line 871
    iput p1, v0, Landroid/os/Message;->arg1:I

    .line 872
    iput-object p0, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 873
    iget-object p1, p0, Lcom/android/internal/telephony/AsyncChannel;->mDstMessenger:Landroid/os/Messenger;

    iput-object p1, v0, Landroid/os/Message;->replyTo:Landroid/os/Messenger;

    .line 874
    invoke-direct {p0}, Lcom/android/internal/telephony/AsyncChannel;->linkToDeathMonitor()Z

    move-result p1

    if-nez p1, :cond_0

    const/4 p1, 0x1

    .line 876
    iput p1, v0, Landroid/os/Message;->arg1:I

    .line 879
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcHandler:Landroid/os/Handler;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method


# virtual methods
.method public connect(Landroid/content/Context;Landroid/os/Handler;Landroid/os/Handler;)V
    .locals 1

    .line 427
    new-instance v0, Landroid/os/Messenger;

    invoke-direct {v0, p3}, Landroid/os/Messenger;-><init>(Landroid/os/Handler;)V

    invoke-virtual {p0, p1, p2, v0}, Lcom/android/internal/telephony/AsyncChannel;->connect(Landroid/content/Context;Landroid/os/Handler;Landroid/os/Messenger;)V

    return-void
.end method

.method public connect(Landroid/content/Context;Landroid/os/Handler;Landroid/os/Messenger;)V
    .locals 0

    .line 386
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/AsyncChannel;->connected(Landroid/content/Context;Landroid/os/Handler;Landroid/os/Messenger;)V

    const/4 p1, 0x0

    .line 389
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/AsyncChannel;->replyHalfConnected(I)V

    return-void
.end method

.method public connect(Landroid/content/Context;Landroid/os/Handler;Ljava/lang/Class;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Landroid/os/Handler;",
            "Ljava/lang/Class<",
            "*>;)V"
        }
    .end annotation

    .line 367
    invoke-virtual {p3}, Ljava/lang/Class;->getPackage()Ljava/lang/Package;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Package;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p0, p1, p2, v0, p3}, Lcom/android/internal/telephony/AsyncChannel;->connect(Landroid/content/Context;Landroid/os/Handler;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public connect(Landroid/content/Context;Landroid/os/Handler;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7

    .line 349
    new-instance v6, Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;

    move-object v0, v6

    move-object v1, p0

    move-object v2, p1

    move-object v3, p2

    move-object v4, p3

    move-object v5, p4

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/AsyncChannel$1ConnectAsync;-><init>(Lcom/android/internal/telephony/AsyncChannel;Landroid/content/Context;Landroid/os/Handler;Ljava/lang/String;Ljava/lang/String;)V

    .line 350
    new-instance p0, Ljava/lang/Thread;

    invoke-direct {p0, v6}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {p0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method public connect(Lcom/android/internal/telephony/AsyncService;Landroid/os/Messenger;)V
    .locals 1

    .line 441
    invoke-virtual {p1}, Lcom/android/internal/telephony/AsyncService;->getHandler()Landroid/os/Handler;

    move-result-object v0

    invoke-virtual {p0, p1, v0, p2}, Lcom/android/internal/telephony/AsyncChannel;->connect(Landroid/content/Context;Landroid/os/Handler;Landroid/os/Messenger;)V

    return-void
.end method

.method public connectSrcHandlerToPackageSync(Landroid/content/Context;Landroid/os/Handler;Ljava/lang/String;Ljava/lang/String;)I
    .locals 1

    .line 233
    new-instance v0, Lcom/android/internal/telephony/AsyncChannel$AsyncChannelConnection;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/AsyncChannel$AsyncChannelConnection;-><init>(Lcom/android/internal/telephony/AsyncChannel;)V

    iput-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mConnection:Lcom/android/internal/telephony/AsyncChannel$AsyncChannelConnection;

    .line 236
    iput-object p1, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcContext:Landroid/content/Context;

    .line 237
    iput-object p2, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcHandler:Landroid/os/Handler;

    .line 238
    new-instance v0, Landroid/os/Messenger;

    invoke-direct {v0, p2}, Landroid/os/Messenger;-><init>(Landroid/os/Handler;)V

    iput-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcMessenger:Landroid/os/Messenger;

    const/4 p2, 0x0

    .line 245
    iput-object p2, p0, Lcom/android/internal/telephony/AsyncChannel;->mDstMessenger:Landroid/os/Messenger;

    .line 248
    new-instance p2, Landroid/content/Intent;

    const-string v0, "android.intent.action.MAIN"

    invoke-direct {p2, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 249
    invoke-virtual {p2, p3, p4}, Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 250
    iget-object p0, p0, Lcom/android/internal/telephony/AsyncChannel;->mConnection:Lcom/android/internal/telephony/AsyncChannel$AsyncChannelConnection;

    const/4 p3, 0x1

    invoke-virtual {p1, p2, p0, p3}, Landroid/content/Context;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    move-result p0

    xor-int/2addr p0, p3

    return p0
.end method

.method public connectSync(Landroid/content/Context;Landroid/os/Handler;Landroid/os/Handler;)I
    .locals 1

    .line 287
    new-instance v0, Landroid/os/Messenger;

    invoke-direct {v0, p3}, Landroid/os/Messenger;-><init>(Landroid/os/Handler;)V

    invoke-virtual {p0, p1, p2, v0}, Lcom/android/internal/telephony/AsyncChannel;->connectSync(Landroid/content/Context;Landroid/os/Handler;Landroid/os/Messenger;)I

    move-result p0

    return p0
.end method

.method public connectSync(Landroid/content/Context;Landroid/os/Handler;Landroid/os/Messenger;)I
    .locals 0

    .line 270
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/AsyncChannel;->connected(Landroid/content/Context;Landroid/os/Handler;Landroid/os/Messenger;)V

    const/4 p0, 0x0

    return p0
.end method

.method public connected(Landroid/content/Context;Landroid/os/Handler;Landroid/os/Messenger;)V
    .locals 0

    .line 409
    iput-object p1, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcContext:Landroid/content/Context;

    .line 410
    iput-object p2, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcHandler:Landroid/os/Handler;

    .line 411
    new-instance p1, Landroid/os/Messenger;

    iget-object p2, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcHandler:Landroid/os/Handler;

    invoke-direct {p1, p2}, Landroid/os/Messenger;-><init>(Landroid/os/Handler;)V

    iput-object p1, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcMessenger:Landroid/os/Messenger;

    .line 414
    iput-object p3, p0, Lcom/android/internal/telephony/AsyncChannel;->mDstMessenger:Landroid/os/Messenger;

    return-void
.end method

.method public disconnect()V
    .locals 4

    .line 461
    iget-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mConnection:Lcom/android/internal/telephony/AsyncChannel$AsyncChannelConnection;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    iget-object v2, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcContext:Landroid/content/Context;

    if-eqz v2, :cond_0

    .line 462
    invoke-virtual {v2, v0}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V

    .line 463
    iput-object v1, p0, Lcom/android/internal/telephony/AsyncChannel;->mConnection:Lcom/android/internal/telephony/AsyncChannel$AsyncChannelConnection;

    .line 468
    :cond_0
    :try_start_0
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    const v2, 0x11004

    .line 469
    iput v2, v0, Landroid/os/Message;->what:I

    .line 470
    iget-object v2, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcMessenger:Landroid/os/Messenger;

    iput-object v2, v0, Landroid/os/Message;->replyTo:Landroid/os/Messenger;

    .line 471
    iget-object v2, p0, Lcom/android/internal/telephony/AsyncChannel;->mDstMessenger:Landroid/os/Messenger;

    invoke-virtual {v2, v0}, Landroid/os/Messenger;->send(Landroid/os/Message;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    const/4 v0, 0x0

    .line 475
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/AsyncChannel;->replyDisconnected(I)V

    .line 476
    iput-object v1, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcHandler:Landroid/os/Handler;

    .line 478
    iget-object v2, p0, Lcom/android/internal/telephony/AsyncChannel;->mConnection:Lcom/android/internal/telephony/AsyncChannel$AsyncChannelConnection;

    if-nez v2, :cond_1

    iget-object v2, p0, Lcom/android/internal/telephony/AsyncChannel;->mDstMessenger:Landroid/os/Messenger;

    if-eqz v2, :cond_1

    iget-object v3, p0, Lcom/android/internal/telephony/AsyncChannel;->mDeathMonitor:Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;

    if-eqz v3, :cond_1

    .line 479
    invoke-virtual {v2}, Landroid/os/Messenger;->getBinder()Landroid/os/IBinder;

    move-result-object v2

    iget-object v3, p0, Lcom/android/internal/telephony/AsyncChannel;->mDeathMonitor:Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;

    invoke-interface {v2, v3, v0}, Landroid/os/IBinder;->unlinkToDeath(Landroid/os/IBinder$DeathRecipient;I)Z

    .line 480
    iput-object v1, p0, Lcom/android/internal/telephony/AsyncChannel;->mDeathMonitor:Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;

    :cond_1
    return-void
.end method

.method public disconnected()V
    .locals 1

    const/4 v0, 0x0

    .line 448
    iput-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcContext:Landroid/content/Context;

    .line 449
    iput-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcHandler:Landroid/os/Handler;

    .line 450
    iput-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcMessenger:Landroid/os/Messenger;

    .line 451
    iput-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mDstMessenger:Landroid/os/Messenger;

    .line 452
    iput-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mDeathMonitor:Lcom/android/internal/telephony/AsyncChannel$DeathMonitor;

    .line 453
    iput-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mConnection:Lcom/android/internal/telephony/AsyncChannel$AsyncChannelConnection;

    return-void
.end method

.method public fullyConnectSync(Landroid/content/Context;Landroid/os/Handler;Landroid/os/Handler;)I
    .locals 0

    .line 301
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/AsyncChannel;->connectSync(Landroid/content/Context;Landroid/os/Handler;Landroid/os/Handler;)I

    move-result p1

    if-nez p1, :cond_0

    const p1, 0x11001

    .line 303
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/AsyncChannel;->sendMessageSynchronously(I)Landroid/os/Message;

    move-result-object p0

    .line 304
    iget p1, p0, Landroid/os/Message;->arg1:I

    :cond_0
    return p1
.end method

.method public replyToMessage(Landroid/os/Message;I)V
    .locals 1

    .line 597
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 598
    iput p2, v0, Landroid/os/Message;->what:I

    .line 599
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/AsyncChannel;->replyToMessage(Landroid/os/Message;Landroid/os/Message;)V

    return-void
.end method

.method public replyToMessage(Landroid/os/Message;II)V
    .locals 1

    .line 611
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 612
    iput p2, v0, Landroid/os/Message;->what:I

    .line 613
    iput p3, v0, Landroid/os/Message;->arg1:I

    .line 614
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/AsyncChannel;->replyToMessage(Landroid/os/Message;Landroid/os/Message;)V

    return-void
.end method

.method public replyToMessage(Landroid/os/Message;III)V
    .locals 1

    .line 626
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 627
    iput p2, v0, Landroid/os/Message;->what:I

    .line 628
    iput p3, v0, Landroid/os/Message;->arg1:I

    .line 629
    iput p4, v0, Landroid/os/Message;->arg2:I

    .line 630
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/AsyncChannel;->replyToMessage(Landroid/os/Message;Landroid/os/Message;)V

    return-void
.end method

.method public replyToMessage(Landroid/os/Message;IIILjava/lang/Object;)V
    .locals 1

    .line 644
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 645
    iput p2, v0, Landroid/os/Message;->what:I

    .line 646
    iput p3, v0, Landroid/os/Message;->arg1:I

    .line 647
    iput p4, v0, Landroid/os/Message;->arg2:I

    .line 648
    iput-object p5, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 649
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/AsyncChannel;->replyToMessage(Landroid/os/Message;Landroid/os/Message;)V

    return-void
.end method

.method public replyToMessage(Landroid/os/Message;ILjava/lang/Object;)V
    .locals 1

    .line 661
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 662
    iput p2, v0, Landroid/os/Message;->what:I

    .line 663
    iput-object p3, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 664
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/AsyncChannel;->replyToMessage(Landroid/os/Message;Landroid/os/Message;)V

    return-void
.end method

.method public replyToMessage(Landroid/os/Message;Landroid/os/Message;)V
    .locals 0

    .line 581
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcMessenger:Landroid/os/Messenger;

    iput-object p0, p2, Landroid/os/Message;->replyTo:Landroid/os/Messenger;

    .line 582
    iget-object p0, p1, Landroid/os/Message;->replyTo:Landroid/os/Messenger;

    invoke-virtual {p0, p2}, Landroid/os/Messenger;->send(Landroid/os/Message;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 584
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "TODO: handle replyToMessage RemoteException"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/AsyncChannel;->log(Ljava/lang/String;)V

    .line 585
    invoke-virtual {p0}, Landroid/os/RemoteException;->printStackTrace()V

    :goto_0
    return-void
.end method

.method public sendMessage(I)V
    .locals 1

    .line 506
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 507
    iput p1, v0, Landroid/os/Message;->what:I

    .line 508
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/AsyncChannel;->sendMessage(Landroid/os/Message;)V

    return-void
.end method

.method public sendMessage(II)V
    .locals 1

    .line 519
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 520
    iput p1, v0, Landroid/os/Message;->what:I

    .line 521
    iput p2, v0, Landroid/os/Message;->arg1:I

    .line 522
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/AsyncChannel;->sendMessage(Landroid/os/Message;)V

    return-void
.end method

.method public sendMessage(III)V
    .locals 1

    .line 534
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 535
    iput p1, v0, Landroid/os/Message;->what:I

    .line 536
    iput p2, v0, Landroid/os/Message;->arg1:I

    .line 537
    iput p3, v0, Landroid/os/Message;->arg2:I

    .line 538
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/AsyncChannel;->sendMessage(Landroid/os/Message;)V

    return-void
.end method

.method public sendMessage(IIILjava/lang/Object;)V
    .locals 1

    .line 551
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 552
    iput p1, v0, Landroid/os/Message;->what:I

    .line 553
    iput p2, v0, Landroid/os/Message;->arg1:I

    .line 554
    iput p3, v0, Landroid/os/Message;->arg2:I

    .line 555
    iput-object p4, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 556
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/AsyncChannel;->sendMessage(Landroid/os/Message;)V

    return-void
.end method

.method public sendMessage(ILjava/lang/Object;)V
    .locals 1

    .line 566
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 567
    iput p1, v0, Landroid/os/Message;->what:I

    .line 568
    iput-object p2, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 569
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/AsyncChannel;->sendMessage(Landroid/os/Message;)V

    return-void
.end method

.method public sendMessage(Landroid/os/Message;)V
    .locals 1

    .line 491
    iget-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mSrcMessenger:Landroid/os/Messenger;

    iput-object v0, p1, Landroid/os/Message;->replyTo:Landroid/os/Messenger;

    .line 493
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/AsyncChannel;->mDstMessenger:Landroid/os/Messenger;

    invoke-virtual {v0, p1}, Landroid/os/Messenger;->send(Landroid/os/Message;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const/4 p1, 0x2

    .line 495
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/AsyncChannel;->replyDisconnected(I)V

    :goto_0
    return-void
.end method

.method public sendMessageSynchronously(I)Landroid/os/Message;
    .locals 1

    .line 686
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 687
    iput p1, v0, Landroid/os/Message;->what:I

    .line 688
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/AsyncChannel;->sendMessageSynchronously(Landroid/os/Message;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public sendMessageSynchronously(II)Landroid/os/Message;
    .locals 1

    .line 700
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 701
    iput p1, v0, Landroid/os/Message;->what:I

    .line 702
    iput p2, v0, Landroid/os/Message;->arg1:I

    .line 703
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/AsyncChannel;->sendMessageSynchronously(Landroid/os/Message;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public sendMessageSynchronously(III)Landroid/os/Message;
    .locals 1

    .line 717
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 718
    iput p1, v0, Landroid/os/Message;->what:I

    .line 719
    iput p2, v0, Landroid/os/Message;->arg1:I

    .line 720
    iput p3, v0, Landroid/os/Message;->arg2:I

    .line 721
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/AsyncChannel;->sendMessageSynchronously(Landroid/os/Message;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public sendMessageSynchronously(IIILjava/lang/Object;)Landroid/os/Message;
    .locals 1

    .line 735
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 736
    iput p1, v0, Landroid/os/Message;->what:I

    .line 737
    iput p2, v0, Landroid/os/Message;->arg1:I

    .line 738
    iput p3, v0, Landroid/os/Message;->arg2:I

    .line 739
    iput-object p4, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 740
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/AsyncChannel;->sendMessageSynchronously(Landroid/os/Message;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public sendMessageSynchronously(ILjava/lang/Object;)Landroid/os/Message;
    .locals 1

    .line 752
    invoke-static {}, Landroid/os/Message;->obtain()Landroid/os/Message;

    move-result-object v0

    .line 753
    iput p1, v0, Landroid/os/Message;->what:I

    .line 754
    iput-object p2, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 755
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/AsyncChannel;->sendMessageSynchronously(Landroid/os/Message;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method

.method public sendMessageSynchronously(Landroid/os/Message;)Landroid/os/Message;
    .locals 0

    .line 675
    iget-object p0, p0, Lcom/android/internal/telephony/AsyncChannel;->mDstMessenger:Landroid/os/Messenger;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/AsyncChannel$SyncMessenger;->-$$Nest$smsendMessageSynchronously(Landroid/os/Messenger;Landroid/os/Message;)Landroid/os/Message;

    move-result-object p0

    return-object p0
.end method
