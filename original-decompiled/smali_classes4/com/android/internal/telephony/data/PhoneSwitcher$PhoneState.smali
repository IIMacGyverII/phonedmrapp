.class public Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;
.super Ljava/lang/Object;
.source "PhoneSwitcher.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/PhoneSwitcher;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xc
    name = "PhoneState"
.end annotation


# instance fields
.field public volatile active:Z

.field public lastRequested:J


# direct methods
.method protected constructor <init>()V
    .locals 2

    .line 1206
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 1207
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;->active:Z

    const-wide/16 v0, 0x0

    .line 1208
    iput-wide v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$PhoneState;->lastRequested:J

    return-void
.end method
