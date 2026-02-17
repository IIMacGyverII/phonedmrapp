.class public Lcom/android/internal/telephony/GsmCdmaCall;
.super Lcom/android/internal/telephony/Call;
.source "GsmCdmaCall.java"


# instance fields
.field mOwner:Lcom/android/internal/telephony/GsmCdmaCallTracker;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/GsmCdmaCallTracker;)V
    .locals 0

    .line 34
    invoke-direct {p0}, Lcom/android/internal/telephony/Call;-><init>()V

    .line 35
    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaCall;->mOwner:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    return-void
.end method


# virtual methods
.method public attach(Lcom/android/internal/telephony/Connection;Lcom/android/internal/telephony/DriverCall;)V
    .locals 0

    .line 77
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/Call;->addConnection(Lcom/android/internal/telephony/Connection;)V

    .line 79
    iget-object p1, p2, Lcom/android/internal/telephony/DriverCall;->state:Lcom/android/internal/telephony/DriverCall$State;

    invoke-static {p1}, Lcom/android/internal/telephony/Call;->stateFromDCState(Lcom/android/internal/telephony/DriverCall$State;)Lcom/android/internal/telephony/Call$State;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/Call;->mState:Lcom/android/internal/telephony/Call$State;

    return-void
.end method

.method public attachFake(Lcom/android/internal/telephony/Connection;Lcom/android/internal/telephony/Call$State;)V
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 84
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/Call;->addConnection(Lcom/android/internal/telephony/Connection;)V

    .line 86
    iput-object p2, p0, Lcom/android/internal/telephony/Call;->mState:Lcom/android/internal/telephony/Call$State;

    return-void
.end method

.method public connectionDisconnected(Lcom/android/internal/telephony/GsmCdmaConnection;)Z
    .locals 4

    .line 93
    iget-object p1, p0, Lcom/android/internal/telephony/Call;->mState:Lcom/android/internal/telephony/Call$State;

    sget-object v0, Lcom/android/internal/telephony/Call$State;->DISCONNECTED:Lcom/android/internal/telephony/Call$State;

    const/4 v1, 0x0

    if-eq p1, v0, :cond_2

    .line 98
    invoke-virtual {p0}, Lcom/android/internal/telephony/Call;->getConnections()Ljava/util/ArrayList;

    move-result-object p1

    invoke-virtual {p1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    const/4 v2, 0x1

    if-eqz v0, :cond_1

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/Connection;

    .line 99
    invoke-virtual {v0}, Lcom/android/internal/telephony/Connection;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object v0

    sget-object v3, Lcom/android/internal/telephony/Call$State;->DISCONNECTED:Lcom/android/internal/telephony/Call$State;

    if-eq v0, v3, :cond_0

    move p1, v1

    goto :goto_0

    :cond_1
    move p1, v2

    :goto_0
    if-eqz p1, :cond_2

    .line 106
    sget-object p1, Lcom/android/internal/telephony/Call$State;->DISCONNECTED:Lcom/android/internal/telephony/Call$State;

    iput-object p1, p0, Lcom/android/internal/telephony/Call;->mState:Lcom/android/internal/telephony/Call$State;

    return v2

    :cond_2
    return v1
.end method

.method public detach(Lcom/android/internal/telephony/GsmCdmaConnection;)V
    .locals 0

    .line 115
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/Call;->removeConnection(Lcom/android/internal/telephony/Connection;)V

    .line 117
    invoke-virtual {p0}, Lcom/android/internal/telephony/Call;->getConnectionsCount()I

    move-result p1

    if-nez p1, :cond_0

    .line 118
    sget-object p1, Lcom/android/internal/telephony/Call$State;->IDLE:Lcom/android/internal/telephony/Call$State;

    iput-object p1, p0, Lcom/android/internal/telephony/Call;->mState:Lcom/android/internal/telephony/Call$State;

    :cond_0
    return-void
.end method

.method public getPhone()Lcom/android/internal/telephony/Phone;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaCall;->mOwner:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->getPhone()Lcom/android/internal/telephony/GsmCdmaPhone;

    move-result-object p0

    return-object p0
.end method

.method public hangup()V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation

    .line 56
    iget-object v0, p0, Lcom/android/internal/telephony/GsmCdmaCall;->mOwner:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->hangup(Lcom/android/internal/telephony/GsmCdmaCall;)V

    return-void
.end method

.method public hangup(I)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation

    .line 66
    iget-object p1, p0, Lcom/android/internal/telephony/GsmCdmaCall;->mOwner:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->hangup(Lcom/android/internal/telephony/GsmCdmaCall;)V

    return-void
.end method

.method isFull()Z
    .locals 1

    .line 141
    invoke-virtual {p0}, Lcom/android/internal/telephony/Call;->getConnectionsCount()I

    move-result v0

    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaCall;->mOwner:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaCallTracker;->getMaxConnectionsPerCall()I

    move-result p0

    if-ne v0, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isMultiparty()Z
    .locals 1

    .line 47
    invoke-virtual {p0}, Lcom/android/internal/telephony/Call;->getConnectionsCount()I

    move-result p0

    const/4 v0, 0x1

    if-le p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public onHangupLocal()V
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 154
    iget-object v0, p0, Lcom/android/internal/telephony/Call;->mState:Lcom/android/internal/telephony/Call$State;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Call$State;->isAlive()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 157
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/Call;->getConnections()Ljava/util/ArrayList;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/Connection;

    .line 158
    check-cast v1, Lcom/android/internal/telephony/GsmCdmaConnection;

    invoke-virtual {v1}, Lcom/android/internal/telephony/GsmCdmaConnection;->onHangupLocal()V

    goto :goto_0

    .line 160
    :cond_1
    sget-object v0, Lcom/android/internal/telephony/Call$State;->DISCONNECTING:Lcom/android/internal/telephony/Call$State;

    iput-object v0, p0, Lcom/android/internal/telephony/Call;->mState:Lcom/android/internal/telephony/Call$State;

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 0

    .line 71
    iget-object p0, p0, Lcom/android/internal/telephony/Call;->mState:Lcom/android/internal/telephony/Call$State;

    invoke-virtual {p0}, Ljava/lang/Enum;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public update(Lcom/android/internal/telephony/GsmCdmaConnection;Lcom/android/internal/telephony/DriverCall;)Z
    .locals 0

    .line 126
    iget-object p1, p2, Lcom/android/internal/telephony/DriverCall;->state:Lcom/android/internal/telephony/DriverCall$State;

    invoke-static {p1}, Lcom/android/internal/telephony/Call;->stateFromDCState(Lcom/android/internal/telephony/DriverCall$State;)Lcom/android/internal/telephony/Call$State;

    move-result-object p1

    .line 128
    iget-object p2, p0, Lcom/android/internal/telephony/Call;->mState:Lcom/android/internal/telephony/Call$State;

    if-eq p1, p2, :cond_0

    .line 129
    iput-object p1, p0, Lcom/android/internal/telephony/Call;->mState:Lcom/android/internal/telephony/Call$State;

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method
