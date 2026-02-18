.class public interface abstract Lcom/android/internal/telephony/NitzStateMachine$DeviceState;
.super Ljava/lang/Object;
.source "NitzStateMachine.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/NitzStateMachine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x609
    name = "DeviceState"
.end annotation


# virtual methods
.method public abstract currentTimeMillis()J
.end method

.method public abstract elapsedRealtimeMillis()J
.end method

.method public abstract getIgnoreNitz()Z
.end method

.method public abstract getNitzNetworkDisconnectRetentionMillis()I
.end method

.method public abstract getNitzUpdateDiffMillis()I
.end method

.method public abstract getNitzUpdateSpacingMillis()I
.end method
