.class public interface abstract Lcom/android/internal/telephony/NitzStateMachine;
.super Ljava/lang/Object;
.source "NitzStateMachine.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;,
        Lcom/android/internal/telephony/NitzStateMachine$DeviceState;
    }
.end annotation


# virtual methods
.method public abstract dumpLogs(Ljava/io/FileDescriptor;Lcom/android/internal/telephony/IndentingPrintWriter;[Ljava/lang/String;)V
.end method

.method public abstract dumpState(Ljava/io/PrintWriter;)V
.end method

.method public abstract handleAirplaneModeChanged(Z)V
.end method

.method public abstract handleCountryDetected(Ljava/lang/String;)V
.end method

.method public abstract handleCountryUnavailable()V
.end method

.method public abstract handleNetworkAvailable()V
.end method

.method public abstract handleNetworkUnavailable()V
.end method

.method public abstract handleNitzReceived(Lcom/android/internal/telephony/NitzSignal;)V
.end method
