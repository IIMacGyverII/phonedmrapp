.class public final Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;
.super Ljava/lang/Object;
.source "TimeZoneLookupHelper.java"


# annotations
.annotation build Lcom/android/internal/annotations/VisibleForTesting;
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper$CountryResult;
    }
.end annotation


# instance fields
.field private mLastCountryTimeZones:Landroid/timezone/CountryTimeZones;


# direct methods
.method public constructor <init>()V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 117
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static countryUsesDifferentOffsets(JLjava/util/List;Landroid/icu/util/TimeZone;)Z
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(J",
            "Ljava/util/List<",
            "Landroid/timezone/CountryTimeZones$TimeZoneMapping;",
            ">;",
            "Landroid/icu/util/TimeZone;",
            ")Z"
        }
    .end annotation

    .line 243
    invoke-virtual {p3}, Landroid/icu/util/TimeZone;->getID()Ljava/lang/String;

    move-result-object v0

    .line 244
    invoke-virtual {p3, p0, p1}, Landroid/icu/util/TimeZone;->getOffset(J)I

    move-result p3

    .line 245
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :cond_0
    :goto_0
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/timezone/CountryTimeZones$TimeZoneMapping;

    .line 246
    invoke-virtual {v1}, Landroid/timezone/CountryTimeZones$TimeZoneMapping;->getTimeZoneId()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    goto :goto_0

    .line 250
    :cond_1
    invoke-virtual {v1}, Landroid/timezone/CountryTimeZones$TimeZoneMapping;->getTimeZone()Landroid/icu/util/TimeZone;

    move-result-object v1

    .line 251
    invoke-virtual {v1, p0, p1}, Landroid/icu/util/TimeZone;->getOffset(J)I

    move-result v1

    if-eq p3, v1, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_2
    const/4 p0, 0x0

    return p0
.end method

.method private getCountryTimeZones(Ljava/lang/String;)Landroid/timezone/CountryTimeZones;
    .locals 1

    .line 321
    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 325
    monitor-enter p0

    .line 326
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;->mLastCountryTimeZones:Landroid/timezone/CountryTimeZones;

    if-eqz v0, :cond_0

    .line 327
    invoke-virtual {v0, p1}, Landroid/timezone/CountryTimeZones;->matchesCountryCode(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 328
    iget-object p1, p0, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;->mLastCountryTimeZones:Landroid/timezone/CountryTimeZones;

    monitor-exit p0

    return-object p1

    .line 334
    :cond_0
    invoke-static {}, Landroid/timezone/TimeZoneFinder;->getInstance()Landroid/timezone/TimeZoneFinder;

    move-result-object v0

    invoke-virtual {v0, p1}, Landroid/timezone/TimeZoneFinder;->lookupCountryTimeZones(Ljava/lang/String;)Landroid/timezone/CountryTimeZones;

    move-result-object p1

    if-eqz p1, :cond_1

    .line 336
    iput-object p1, p0, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;->mLastCountryTimeZones:Landroid/timezone/CountryTimeZones;

    .line 338
    :cond_1
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    .line 339
    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method private static lookupByInstantOffsetDst(JILjava/lang/Boolean;)Landroid/timezone/CountryTimeZones$OffsetResult;
    .locals 8

    .line 266
    invoke-static {}, Ljava/util/TimeZone;->getAvailableIDs()[Ljava/lang/String;

    move-result-object v0

    .line 269
    array-length v1, v0

    const/4 v2, 0x0

    const/4 v3, 0x0

    move v4, v2

    move-object v5, v3

    :goto_0
    if-ge v4, v1, :cond_1

    aget-object v6, v0, v4

    .line 270
    invoke-static {v6}, Landroid/icu/util/TimeZone;->getFrozenTimeZone(Ljava/lang/String;)Landroid/icu/util/TimeZone;

    move-result-object v6

    .line 271
    invoke-static {v6, p2, p3, p0, p1}, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;->offsetMatchesAtTime(Landroid/icu/util/TimeZone;ILjava/lang/Boolean;J)Z

    move-result v7

    if-eqz v7, :cond_0

    if-nez v5, :cond_2

    move-object v5, v6

    :cond_0
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_1
    const/4 v2, 0x1

    :cond_2
    if-nez v5, :cond_3

    return-object v3

    .line 284
    :cond_3
    new-instance p0, Landroid/timezone/CountryTimeZones$OffsetResult;

    invoke-direct {p0, v5, v2}, Landroid/timezone/CountryTimeZones$OffsetResult;-><init>(Landroid/icu/util/TimeZone;Z)V

    return-object p0
.end method

.method private static offsetMatchesAtTime(Landroid/icu/util/TimeZone;ILjava/lang/Boolean;J)Z
    .locals 2

    const/4 v0, 0x2

    new-array v0, v0, [I

    const/4 v1, 0x0

    .line 296
    invoke-virtual {p0, p3, p4, v1, v0}, Landroid/icu/util/TimeZone;->getOffset(JZ[I)V

    aget p0, v0, v1

    const/4 p3, 0x1

    aget p4, v0, p3

    add-int/2addr p0, p4

    if-eq p1, p0, :cond_0

    return v1

    :cond_0
    if-eqz p2, :cond_2

    .line 302
    invoke-virtual {p2}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p0

    aget p1, v0, p3

    if-eqz p1, :cond_1

    move p1, p3

    goto :goto_0

    :cond_1
    move p1, v1

    :goto_0
    if-ne p0, p1, :cond_3

    :cond_2
    move v1, p3

    :cond_3
    return v1
.end method


# virtual methods
.method public countryUsesUtc(Ljava/lang/String;J)Z
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 311
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    return v1

    .line 315
    :cond_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;->getCountryTimeZones(Ljava/lang/String;)Landroid/timezone/CountryTimeZones;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 316
    invoke-virtual {p0, p2, p3}, Landroid/timezone/CountryTimeZones;->hasUtcZone(J)Z

    move-result p0

    if-eqz p0, :cond_1

    const/4 v1, 0x1

    :cond_1
    return v1
.end method

.method public lookupByCountry(Ljava/lang/String;J)Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper$CountryResult;
    .locals 3
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 199
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;->getCountryTimeZones(Ljava/lang/String;)Landroid/timezone/CountryTimeZones;

    move-result-object p0

    const/4 p1, 0x0

    if-nez p0, :cond_0

    return-object p1

    .line 204
    :cond_0
    invoke-virtual {p0}, Landroid/timezone/CountryTimeZones;->getDefaultTimeZone()Landroid/icu/util/TimeZone;

    move-result-object v0

    if-nez v0, :cond_1

    return-object p1

    .line 212
    :cond_1
    invoke-virtual {p0}, Landroid/timezone/CountryTimeZones;->isDefaultTimeZoneBoosted()Z

    move-result p1

    const/4 v1, 0x4

    const/4 v2, 0x1

    if-eqz p1, :cond_2

    const/4 v1, 0x2

    const-string p0, "Country default is boosted"

    goto :goto_1

    .line 217
    :cond_2
    invoke-virtual {p0, p2, p3}, Landroid/timezone/CountryTimeZones;->getEffectiveTimeZoneMappingsAt(J)Ljava/util/List;

    move-result-object p0

    .line 218
    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_3

    .line 222
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "No effective time zones found at whenMillis="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2, p3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_1

    .line 223
    :cond_3
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result p1

    if-ne p1, v2, :cond_4

    .line 226
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "One effective time zone found at whenMillis="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2, p3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    move v1, v2

    goto :goto_1

    .line 228
    :cond_4
    invoke-static {p2, p3, p0, v0}, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;->countryUsesDifferentOffsets(JLjava/util/List;Landroid/icu/util/TimeZone;)Z

    move-result p0

    if-eqz p0, :cond_5

    goto :goto_0

    :cond_5
    const/4 p1, 0x3

    move v1, p1

    .line 233
    :goto_0
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "countryUsesDifferentOffsets="

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, " at whenMillis="

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2, p3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 237
    :goto_1
    new-instance p1, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper$CountryResult;

    invoke-virtual {v0}, Landroid/icu/util/TimeZone;->getID()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p1, p2, v1, p0}, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper$CountryResult;-><init>(Ljava/lang/String;ILjava/lang/String;)V

    return-object p1
.end method

.method public lookupByNitz(Lcom/android/internal/telephony/NitzData;)Landroid/timezone/CountryTimeZones$OffsetResult;
    .locals 4
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 168
    invoke-virtual {p1}, Lcom/android/internal/telephony/NitzData;->getLocalOffsetMillis()I

    move-result p0

    .line 169
    invoke-virtual {p1}, Lcom/android/internal/telephony/NitzData;->getCurrentTimeInMillis()J

    move-result-wide v0

    .line 175
    invoke-virtual {p1}, Lcom/android/internal/telephony/NitzData;->getDstAdjustmentMillis()Ljava/lang/Integer;

    move-result-object p1

    const/4 v2, 0x0

    if-nez p1, :cond_0

    move-object p1, v2

    goto :goto_1

    .line 176
    :cond_0
    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    if-eqz p1, :cond_1

    const/4 p1, 0x1

    goto :goto_0

    :cond_1
    const/4 p1, 0x0

    :goto_0
    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p1

    .line 178
    :goto_1
    invoke-static {v0, v1, p0, p1}, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;->lookupByInstantOffsetDst(JILjava/lang/Boolean;)Landroid/timezone/CountryTimeZones$OffsetResult;

    move-result-object v3

    if-nez v3, :cond_2

    if-eqz p1, :cond_2

    .line 185
    invoke-static {v0, v1, p0, v2}, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;->lookupByInstantOffsetDst(JILjava/lang/Boolean;)Landroid/timezone/CountryTimeZones$OffsetResult;

    move-result-object v3

    :cond_2
    return-object v3
.end method

.method public lookupByNitzCountry(Lcom/android/internal/telephony/NitzData;Ljava/lang/String;)Landroid/timezone/CountryTimeZones$OffsetResult;
    .locals 6
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 131
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;->getCountryTimeZones(Ljava/lang/String;)Landroid/timezone/CountryTimeZones;

    move-result-object v0

    if-nez v0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 135
    :cond_0
    invoke-static {}, Landroid/icu/util/TimeZone;->getDefault()Landroid/icu/util/TimeZone;

    move-result-object v3

    .line 141
    invoke-virtual {p1}, Lcom/android/internal/telephony/NitzData;->getDstAdjustmentMillis()Ljava/lang/Integer;

    move-result-object p0

    if-nez p0, :cond_1

    .line 144
    invoke-virtual {p1}, Lcom/android/internal/telephony/NitzData;->getCurrentTimeInMillis()J

    move-result-wide v1

    invoke-virtual {p1}, Lcom/android/internal/telephony/NitzData;->getLocalOffsetMillis()I

    move-result p0

    .line 143
    invoke-virtual {v0, v1, v2, v3, p0}, Landroid/timezone/CountryTimeZones;->lookupByOffsetWithBias(JLandroid/icu/util/TimeZone;I)Landroid/timezone/CountryTimeZones$OffsetResult;

    move-result-object p0

    return-object p0

    .line 149
    :cond_1
    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    if-eqz p0, :cond_2

    const/4 p0, 0x1

    goto :goto_0

    :cond_2
    const/4 p0, 0x0

    :goto_0
    move v5, p0

    .line 151
    invoke-virtual {p1}, Lcom/android/internal/telephony/NitzData;->getCurrentTimeInMillis()J

    move-result-wide v1

    .line 152
    invoke-virtual {p1}, Lcom/android/internal/telephony/NitzData;->getLocalOffsetMillis()I

    move-result v4

    .line 150
    invoke-virtual/range {v0 .. v5}, Landroid/timezone/CountryTimeZones;->lookupByOffsetWithBias(JLandroid/icu/util/TimeZone;IZ)Landroid/timezone/CountryTimeZones$OffsetResult;

    move-result-object p0

    return-object p0
.end method
