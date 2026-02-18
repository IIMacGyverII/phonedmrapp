.class Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$CacheEntry;
.super Ljava/lang/Object;
.source "ImsPhoneCallTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "CacheEntry"
.end annotation


# instance fields
.field private mCachedTime:J

.field private mCallDirection:I

.field private mConnectElapsedTime:J

.field private mConnectTime:J


# direct methods
.method static bridge synthetic -$$Nest$fgetmCachedTime(Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$CacheEntry;)J
    .locals 2

    iget-wide v0, p0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$CacheEntry;->mCachedTime:J

    return-wide v0
.end method

.method static bridge synthetic -$$Nest$fgetmCallDirection(Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$CacheEntry;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$CacheEntry;->mCallDirection:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmConnectElapsedTime(Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$CacheEntry;)J
    .locals 2

    iget-wide v0, p0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$CacheEntry;->mConnectElapsedTime:J

    return-wide v0
.end method

.method static bridge synthetic -$$Nest$fgetmConnectTime(Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$CacheEntry;)J
    .locals 2

    iget-wide v0, p0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$CacheEntry;->mConnectTime:J

    return-wide v0
.end method

.method constructor <init>(JJJI)V
    .locals 0

    .line 557
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 558
    iput-wide p1, p0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$CacheEntry;->mCachedTime:J

    .line 559
    iput-wide p3, p0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$CacheEntry;->mConnectTime:J

    .line 560
    iput-wide p5, p0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$CacheEntry;->mConnectElapsedTime:J

    .line 561
    iput p7, p0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$CacheEntry;->mCallDirection:I

    return-void
.end method
