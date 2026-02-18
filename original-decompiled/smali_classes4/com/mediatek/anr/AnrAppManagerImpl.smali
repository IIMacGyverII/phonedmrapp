.class public final Lcom/mediatek/anr/AnrAppManagerImpl;
.super Lcom/mediatek/anr/AnrAppManager;
.source "AnrAppManagerImpl.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "AnrAppManager"

.field private static lock:Ljava/lang/Object;

.field private static sInstance:Lcom/mediatek/anr/AnrAppManagerImpl;

.field protected static sMap:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Lcom/mediatek/anr/MessageLogger;",
            ">;"
        }
    .end annotation
.end field

.field private static sSingletonLogger:Lcom/mediatek/anr/MessageLogger;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 55
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/mediatek/anr/AnrAppManagerImpl;->sMap:Ljava/util/HashMap;

    const/4 v0, 0x0

    .line 56
    sput-object v0, Lcom/mediatek/anr/AnrAppManagerImpl;->sInstance:Lcom/mediatek/anr/AnrAppManagerImpl;

    .line 57
    sput-object v0, Lcom/mediatek/anr/AnrAppManagerImpl;->sSingletonLogger:Lcom/mediatek/anr/MessageLogger;

    .line 58
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/anr/AnrAppManagerImpl;->lock:Ljava/lang/Object;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 53
    invoke-direct {p0}, Lcom/mediatek/anr/AnrAppManager;-><init>()V

    return-void
.end method

.method public static dumpAllMessageHistory()V
    .locals 7

    .line 118
    sget-object v0, Lcom/mediatek/anr/AnrAppManagerImpl;->sSingletonLogger:Lcom/mediatek/anr/MessageLogger;

    const-string v1, "informMessageDump exception "

    const-string v2, "AnrAppManager"

    if-eqz v0, :cond_0

    const-string v0, "!!! It is under multiple instance mode, but you are in singleton usage style. !!!\n"

    .line 119
    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 122
    :try_start_0
    invoke-static {}, Lcom/mediatek/anr/AnrManagerNative;->getDefault()Lcom/mediatek/anr/IAnrManager;

    move-result-object v0

    const-string v3, "!!! It is under multiple instance mode,but you are in singleton usage style. !!!\n"

    .line 125
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v4

    .line 122
    invoke-interface {v0, v3, v4}, Lcom/mediatek/anr/IAnrManager;->informMessageDump(Ljava/lang/String;I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 127
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void

    .line 131
    :cond_0
    sget-object v0, Lcom/mediatek/anr/AnrAppManagerImpl;->sMap:Ljava/util/HashMap;

    const/4 v3, 0x0

    if-nez v0, :cond_1

    new-array v0, v3, [Ljava/lang/Object;

    const-string v3, "!!! DumpAll, sMap is null\n"

    .line 132
    invoke-static {v3, v0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 134
    :try_start_1
    invoke-static {}, Lcom/mediatek/anr/AnrManagerNative;->getDefault()Lcom/mediatek/anr/IAnrManager;

    move-result-object v0

    .line 135
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v4

    .line 134
    invoke-interface {v0, v3, v4}, Lcom/mediatek/anr/IAnrManager;->informMessageDump(Ljava/lang/String;I)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    :catch_1
    move-exception v0

    .line 137
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :goto_1
    return-void

    .line 141
    :cond_1
    invoke-virtual {v0}, Ljava/util/HashMap;->keySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    .line 142
    :goto_2
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 143
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    const/4 v4, 0x1

    new-array v5, v4, [Ljava/lang/Object;

    aput-object v1, v5, v3

    const-string v6, ">>> DumpByName, Thread name: %s dump is starting <<<\n"

    .line 144
    invoke-static {v6, v5}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-static {v2, v5}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 146
    sget-object v5, Lcom/mediatek/anr/AnrAppManagerImpl;->sMap:Ljava/util/HashMap;

    invoke-virtual {v5, v1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/mediatek/anr/MessageLogger;

    new-array v4, v4, [Ljava/lang/Object;

    aput-object v1, v4, v3

    invoke-static {v6, v4}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v5, v4}, Lcom/mediatek/anr/MessageLogger;->setInitStr(Ljava/lang/String;)V

    .line 148
    sget-object v4, Lcom/mediatek/anr/AnrAppManagerImpl;->sMap:Ljava/util/HashMap;

    invoke-virtual {v4, v1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/mediatek/anr/MessageLogger;

    invoke-virtual {v1}, Lcom/mediatek/anr/MessageLogger;->dumpMessageHistory()V

    goto :goto_2

    :cond_2
    return-void
.end method

.method public static dumpMessageHistory()V
    .locals 4

    .line 102
    sget-object v0, Lcom/mediatek/anr/AnrAppManagerImpl;->sSingletonLogger:Lcom/mediatek/anr/MessageLogger;

    if-nez v0, :cond_0

    const-string v0, "AnrAppManager"

    const-string v1, "!!! It is not under singleton mode, U can\'t use it. !!!\n"

    .line 103
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 105
    :try_start_0
    invoke-static {}, Lcom/mediatek/anr/AnrManagerNative;->getDefault()Lcom/mediatek/anr/IAnrManager;

    move-result-object v2

    .line 106
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v3

    .line 105
    invoke-interface {v2, v1, v3}, Lcom/mediatek/anr/IAnrManager;->informMessageDump(Ljava/lang/String;I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v1

    .line 108
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "informMessageDump exception "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 111
    :cond_0
    invoke-virtual {v0}, Lcom/mediatek/anr/MessageLogger;->dumpMessageHistory()V

    :goto_0
    return-void
.end method

.method public static getInstance()Lcom/mediatek/anr/AnrAppManagerImpl;
    .locals 2

    .line 61
    sget-object v0, Lcom/mediatek/anr/AnrAppManagerImpl;->sInstance:Lcom/mediatek/anr/AnrAppManagerImpl;

    if-nez v0, :cond_1

    .line 62
    sget-object v0, Lcom/mediatek/anr/AnrAppManagerImpl;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 63
    :try_start_0
    sget-object v1, Lcom/mediatek/anr/AnrAppManagerImpl;->sInstance:Lcom/mediatek/anr/AnrAppManagerImpl;

    if-nez v1, :cond_0

    .line 64
    new-instance v1, Lcom/mediatek/anr/AnrAppManagerImpl;

    invoke-direct {v1}, Lcom/mediatek/anr/AnrAppManagerImpl;-><init>()V

    sput-object v1, Lcom/mediatek/anr/AnrAppManagerImpl;->sInstance:Lcom/mediatek/anr/AnrAppManagerImpl;

    .line 66
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 68
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/anr/AnrAppManagerImpl;->sInstance:Lcom/mediatek/anr/AnrAppManagerImpl;

    return-object v0
.end method

.method public static newMessageLogger(Z)Landroid/util/Printer;
    .locals 1

    .line 88
    new-instance v0, Lcom/mediatek/anr/MessageLogger;

    invoke-direct {v0, p0}, Lcom/mediatek/anr/MessageLogger;-><init>(Z)V

    sput-object v0, Lcom/mediatek/anr/AnrAppManagerImpl;->sSingletonLogger:Lcom/mediatek/anr/MessageLogger;

    return-object v0
.end method

.method public static newMessageLogger(ZLjava/lang/String;)Landroid/util/Printer;
    .locals 1

    .line 93
    sget-object v0, Lcom/mediatek/anr/AnrAppManagerImpl;->sMap:Ljava/util/HashMap;

    invoke-virtual {v0, p1}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 94
    sget-object v0, Lcom/mediatek/anr/AnrAppManagerImpl;->sMap:Ljava/util/HashMap;

    invoke-virtual {v0, p1}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 96
    :cond_0
    new-instance v0, Lcom/mediatek/anr/MessageLogger;

    invoke-direct {v0, p0, p1}, Lcom/mediatek/anr/MessageLogger;-><init>(ZLjava/lang/String;)V

    .line 97
    sget-object p0, Lcom/mediatek/anr/AnrAppManagerImpl;->sMap:Ljava/util/HashMap;

    invoke-virtual {p0, p1, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-object v0
.end method


# virtual methods
.method public dumpMessage(Z)V
    .locals 0

    if-eqz p1, :cond_0

    .line 81
    invoke-static {}, Lcom/mediatek/anr/AnrAppManagerImpl;->dumpAllMessageHistory()V

    goto :goto_0

    .line 83
    :cond_0
    invoke-static {}, Lcom/mediatek/anr/AnrAppManagerImpl;->dumpMessageHistory()V

    :goto_0
    return-void
.end method

.method public setMessageLogger(Landroid/os/Looper;)V
    .locals 1

    .line 73
    sget-object p0, Landroid/os/Build;->TYPE:Ljava/lang/String;

    const-string v0, "eng"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    const-string/jumbo v0, "userdebug"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    :cond_0
    const/4 p0, 0x0

    .line 74
    invoke-static {p0}, Lcom/mediatek/anr/AnrAppManagerImpl;->newMessageLogger(Z)Landroid/util/Printer;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/os/Looper;->setMessageLogging(Landroid/util/Printer;)V

    :cond_1
    return-void
.end method
