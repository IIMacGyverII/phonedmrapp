.class public Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;
.super Lcom/android/internal/telephony/data/DataCallback;
.source "DataSettingsManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataSettingsManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "DataSettingsManagerCallback"
.end annotation


# direct methods
.method public constructor <init>(Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 140
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onDataEnabledChanged(ZILjava/lang/String;)V
    .locals 0

    return-void
.end method

.method public onDataEnabledOverrideChanged(ZI)V
    .locals 0

    return-void
.end method

.method public onDataRoamingEnabledChanged(Z)V
    .locals 0

    return-void
.end method
