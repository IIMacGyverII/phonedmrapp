.class public Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;
.super Ljava/lang/Object;
.source "NitzStateMachine.java"

# interfaces
.implements Lcom/android/internal/telephony/NitzStateMachine$DeviceState;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/NitzStateMachine;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "DeviceStateImpl"
.end annotation


# static fields
.field private static final NITZ_NETWORK_DISCONNECT_RETENTION_MILLIS_DEFAULT:I = 0x493e0

.field private static final NITZ_UPDATE_DIFF_MILLIS_DEFAULT:I = 0x7d0

.field private static final NITZ_UPDATE_SPACING_MILLIS_DEFAULT:I = 0x927c0


# instance fields
.field private final mCr:Landroid/content/ContentResolver;

.field private final mNitzNetworkDisconnectRetentionMillis:I

.field private final mNitzUpdateDiffMillis:I

.field private final mNitzUpdateSpacingMillis:I


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/Phone;)V
    .locals 1

    .line 154
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 155
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    .line 156
    invoke-virtual {p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;->mCr:Landroid/content/ContentResolver;

    const-string p1, "ro.nitz_update_spacing"

    const v0, 0x927c0

    .line 158
    invoke-static {p1, v0}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;->mNitzUpdateSpacingMillis:I

    const-string p1, "ro.nitz_update_diff"

    const/16 v0, 0x7d0

    .line 161
    invoke-static {p1, v0}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;->mNitzUpdateDiffMillis:I

    const-string p1, "ro.nitz_network_disconnect_retention"

    const v0, 0x493e0

    .line 163
    invoke-static {p1, v0}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;->mNitzNetworkDisconnectRetentionMillis:I

    return-void
.end method


# virtual methods
.method public currentTimeMillis()J
    .locals 2

    .line 198
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    return-wide v0
.end method

.method public elapsedRealtimeMillis()J
    .locals 2

    .line 193
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    return-wide v0
.end method

.method public getIgnoreNitz()Z
    .locals 1

    const-string p0, "gsm.ignore-nitz"

    .line 187
    invoke-static {p0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_0

    const-string/jumbo v0, "yes"

    .line 188
    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public getNitzNetworkDisconnectRetentionMillis()I
    .locals 2

    .line 181
    iget-object v0, p0, Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;->mCr:Landroid/content/ContentResolver;

    iget p0, p0, Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;->mNitzNetworkDisconnectRetentionMillis:I

    const-string v1, "nitz_network_disconnect_retention"

    invoke-static {v0, v1, p0}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p0

    return p0
.end method

.method public getNitzUpdateDiffMillis()I
    .locals 2

    .line 175
    iget-object v0, p0, Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;->mCr:Landroid/content/ContentResolver;

    iget p0, p0, Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;->mNitzUpdateDiffMillis:I

    const-string v1, "nitz_update_diff"

    invoke-static {v0, v1, p0}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p0

    return p0
.end method

.method public getNitzUpdateSpacingMillis()I
    .locals 2

    .line 169
    iget-object v0, p0, Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;->mCr:Landroid/content/ContentResolver;

    iget p0, p0, Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;->mNitzUpdateSpacingMillis:I

    const-string v1, "nitz_update_spacing"

    invoke-static {v0, v1, p0}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p0

    return p0
.end method
