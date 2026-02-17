.class public Lcom/android/internal/telephony/data/DataUtils;
.super Ljava/lang/Object;
.source "DataUtils.java"


# static fields
.field private static final TIME_FORMAT:Ljava/text/SimpleDateFormat;


# direct methods
.method public static synthetic $r8$lambda$1hdlC8Dh0WhAQy8JagZaOxNJgqw(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)I
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataUtils;->lambda$getGroupedNetworkRequestList$1(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)I

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$KHXcFFNYxvdxcri3mEH3dVtMlQg(Ljava/util/Set;)Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataUtils;->lambda$getGroupedNetworkRequestList$0(Ljava/util/Set;)Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    move-result-object p0

    return-object p0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 62
    new-instance v0, Ljava/text/SimpleDateFormat;

    sget-object v1, Ljava/util/Locale;->US:Ljava/util/Locale;

    const-string v2, "HH:mm:ss.SSS"

    invoke-direct {v0, v2, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    sput-object v0, Lcom/android/internal/telephony/data/DataUtils;->TIME_FORMAT:Ljava/text/SimpleDateFormat;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 60
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static apnTypeToNetworkCapability(I)I
    .locals 0

    sparse-switch p0, :sswitch_data_0

    const/4 p0, -0x1

    return p0

    :sswitch_0
    const/16 p0, 0x1d

    return p0

    :sswitch_1
    const/16 p0, 0x1f

    return p0

    :sswitch_2
    const/16 p0, 0x1e

    return p0

    :sswitch_3
    const/16 p0, 0x9

    return p0

    :sswitch_4
    const/16 p0, 0x17

    return p0

    :sswitch_5
    const/16 p0, 0xa

    return p0

    :sswitch_6
    const/4 p0, 0x7

    return p0

    :sswitch_7
    const/4 p0, 0x5

    return p0

    :sswitch_8
    const/4 p0, 0x4

    return p0

    :sswitch_9
    const/4 p0, 0x3

    return p0

    :sswitch_a
    const/16 p0, 0xc

    return p0

    :sswitch_b
    const/4 p0, 0x2

    return p0

    :sswitch_c
    const/4 p0, 0x1

    return p0

    :sswitch_d
    const/4 p0, 0x0

    return p0

    :sswitch_data_0
    .sparse-switch
        0x2 -> :sswitch_d
        0x4 -> :sswitch_c
        0x8 -> :sswitch_b
        0x11 -> :sswitch_a
        0x20 -> :sswitch_9
        0x40 -> :sswitch_8
        0x80 -> :sswitch_7
        0x100 -> :sswitch_6
        0x200 -> :sswitch_5
        0x400 -> :sswitch_4
        0x800 -> :sswitch_3
        0x1000 -> :sswitch_2
        0x2000 -> :sswitch_1
        0x4000 -> :sswitch_0
    .end sparse-switch
.end method

.method public static dataActivityToString(I)Ljava/lang/String;
    .locals 2

    if-eqz p0, :cond_4

    const/4 v0, 0x1

    if-eq p0, v0, :cond_3

    const/4 v0, 0x2

    if-eq p0, v0, :cond_2

    const/4 v0, 0x3

    if-eq p0, v0, :cond_1

    const/4 v0, 0x4

    if-eq p0, v0, :cond_0

    .line 490
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UNKNOWN("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "DORMANT"

    return-object p0

    :cond_1
    const-string p0, "INOUT"

    return-object p0

    :cond_2
    const-string p0, "OUT"

    return-object p0

    :cond_3
    const-string p0, "IN"

    return-object p0

    :cond_4
    const-string p0, "NONE"

    return-object p0
.end method

.method public static elapsedTimeToString(J)Ljava/lang/String;
    .locals 4

    const-wide/16 v0, 0x0

    cmp-long v0, p0, v0

    if-eqz v0, :cond_0

    .line 344
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 345
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    sub-long/2addr v0, v2

    add-long/2addr v0, p0

    .line 344
    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataUtils;->systemTimeToString(J)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, "never"

    :goto_0
    return-object p0
.end method

.method public static getGroupedNetworkRequestList(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Ljava/util/List;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;",
            ")",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;",
            ">;"
        }
    .end annotation

    .line 401
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    .line 402
    invoke-virtual {p0}, Ljava/util/LinkedList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 403
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getCapabilities()[I

    move-result-object v2

    invoke-static {v2}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object v2

    .line 404
    invoke-interface {v2}, Ljava/util/stream/IntStream;->boxed()Ljava/util/stream/Stream;

    move-result-object v2

    invoke-static {}, Ljava/util/stream/Collectors;->toSet()Ljava/util/stream/Collector;

    move-result-object v3

    invoke-interface {v2, v3}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/util/Set;

    new-instance v3, Lcom/android/internal/telephony/data/DataUtils$$ExternalSyntheticLambda2;

    invoke-direct {v3}, Lcom/android/internal/telephony/data/DataUtils$$ExternalSyntheticLambda2;-><init>()V

    .line 403
    invoke-interface {v0, v2, v3}, Ljava/util/Map;->computeIfAbsent(Ljava/lang/Object;Ljava/util/function/Function;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    .line 405
    invoke-virtual {v2, v1}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;->add(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    goto :goto_0

    .line 409
    :cond_0
    new-instance p0, Ljava/util/ArrayList;

    invoke-interface {v0}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-direct {p0, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    invoke-virtual {p0}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataUtils$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataUtils$$ExternalSyntheticLambda3;-><init>()V

    .line 410
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->sorted(Ljava/util/Comparator;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 412
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/List;

    return-object p0
.end method

.method public static getHighestPriorityNetworkCapabilityFromDataProfile(Lcom/android/internal/telephony/data/DataConfigManager;Landroid/telephony/data/DataProfile;)I
    .locals 1

    .line 382
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 383
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getApnTypes()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 384
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getApnTypes()Ljava/util/List;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda14;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda14;-><init>()V

    .line 385
    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p1

    .line 386
    invoke-static {p0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v0, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda2;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/data/DataConfigManager;)V

    invoke-static {v0}, Ljava/util/Comparator;->comparing(Ljava/util/function/Function;)Ljava/util/Comparator;

    move-result-object p0

    .line 387
    invoke-interface {p0}, Ljava/util/Comparator;->reversed()Ljava/util/Comparator;

    move-result-object p0

    .line 386
    invoke-interface {p1, p0}, Ljava/util/stream/Stream;->sorted(Ljava/util/Comparator;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 388
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/List;

    const/4 p1, 0x0

    .line 389
    invoke-interface {p0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    return p0

    :cond_1
    :goto_0
    const/4 p0, -0x1

    return p0
.end method

.method public static getNetworkCapabilitiesFromString(Ljava/lang/String;)Ljava/util/Set;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    const-string v0, "(\\s*[a-zA-Z]+\\s*)(\\|\\s*[a-zA-Z]+\\s*)*"

    .line 107
    invoke-virtual {p0, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    const/4 p0, -0x1

    .line 108
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-static {p0}, Ljava/util/Collections;->singleton(Ljava/lang/Object;)Ljava/util/Set;

    move-result-object p0

    return-object p0

    :cond_0
    const-string v0, "\\s*\\|\\s*"

    .line 110
    invoke-virtual {p0, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule$$ExternalSyntheticLambda0;-><init>()V

    .line 111
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataUtils$$ExternalSyntheticLambda4;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataUtils$$ExternalSyntheticLambda4;-><init>()V

    .line 112
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 113
    invoke-static {}, Ljava/util/stream/Collectors;->toSet()Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/Set;

    return-object p0
.end method

.method public static getNetworkCapabilityFromString(Ljava/lang/String;)I
    .locals 11

    .line 73
    sget-object v0, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {p0, v0}, Ljava/lang/String;->toUpperCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->hashCode()I

    invoke-virtual {p0}, Ljava/lang/String;->hashCode()I

    move-result v0

    const/16 v1, 0xc

    const/16 v2, 0xa

    const/16 v3, 0x9

    const/4 v4, 0x5

    const/4 v5, 0x4

    const/4 v6, 0x3

    const/4 v7, 0x2

    const/4 v8, 0x1

    const/4 v9, 0x0

    const/4 v10, -0x1

    sparse-switch v0, :sswitch_data_0

    :goto_0
    move p0, v10

    goto/16 :goto_1

    :sswitch_0
    const-string v0, "INTERNET"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_0

    goto :goto_0

    :cond_0
    const/16 p0, 0xe

    goto/16 :goto_1

    :sswitch_1
    const-string v0, "PRIORITIZE_LATENCY"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_1

    goto :goto_0

    :cond_1
    const/16 p0, 0xd

    goto/16 :goto_1

    :sswitch_2
    const-string v0, "XCAP"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_2

    goto :goto_0

    :cond_2
    move p0, v1

    goto/16 :goto_1

    :sswitch_3
    const-string v0, "VSIM"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_3

    goto :goto_0

    :cond_3
    const/16 p0, 0xb

    goto/16 :goto_1

    :sswitch_4
    const-string v0, "SUPL"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_4

    goto :goto_0

    :cond_4
    move p0, v2

    goto/16 :goto_1

    :sswitch_5
    const-string v0, "FOTA"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_5

    goto :goto_0

    :cond_5
    move p0, v3

    goto/16 :goto_1

    :sswitch_6
    const-string v0, "EIMS"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_6

    goto :goto_0

    :cond_6
    const/16 p0, 0x8

    goto/16 :goto_1

    :sswitch_7
    const-string v0, "MMS"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_7

    goto :goto_0

    :cond_7
    const/4 p0, 0x7

    goto :goto_1

    :sswitch_8
    const-string v0, "MCX"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_8

    goto :goto_0

    :cond_8
    const/4 p0, 0x6

    goto :goto_1

    :sswitch_9
    const-string v0, "IMS"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_9

    goto :goto_0

    :cond_9
    move p0, v4

    goto :goto_1

    :sswitch_a
    const-string v0, "DUN"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_a

    goto/16 :goto_0

    :cond_a
    move p0, v5

    goto :goto_1

    :sswitch_b
    const-string v0, "CBS"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_b

    goto/16 :goto_0

    :cond_b
    move p0, v6

    goto :goto_1

    :sswitch_c
    const-string v0, "BIP"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_c

    goto/16 :goto_0

    :cond_c
    move p0, v7

    goto :goto_1

    :sswitch_d
    const-string v0, "ENTERPRISE"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_d

    goto/16 :goto_0

    :cond_d
    move p0, v8

    goto :goto_1

    :sswitch_e
    const-string v0, "PRIORITIZE_BANDWIDTH"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_e

    goto/16 :goto_0

    :cond_e
    move p0, v9

    :goto_1
    packed-switch p0, :pswitch_data_0

    return v10

    :pswitch_0
    return v1

    :pswitch_1
    const/16 p0, 0x22

    return p0

    :pswitch_2
    return v3

    :pswitch_3
    const/16 p0, 0x1e

    return p0

    :pswitch_4
    return v8

    :pswitch_5
    return v6

    :pswitch_6
    return v2

    :pswitch_7
    return v9

    :pswitch_8
    const/16 p0, 0x17

    return p0

    :pswitch_9
    return v5

    :pswitch_a
    return v7

    :pswitch_b
    return v4

    :pswitch_c
    const/16 p0, 0x1f

    return p0

    :pswitch_d
    const/16 p0, 0x1d

    return p0

    :pswitch_e
    const/16 p0, 0x23

    return p0

    nop

    :sswitch_data_0
    .sparse-switch
        -0x1c2137ef -> :sswitch_e
        -0x12eee09f -> :sswitch_d
        0x100e9 -> :sswitch_c
        0x103d4 -> :sswitch_b
        0x109dd -> :sswitch_a
        0x11baf -> :sswitch_9
        0x12982 -> :sswitch_8
        0x12ab3 -> :sswitch_7
        0x20794a -> :sswitch_6
        0x2104f6 -> :sswitch_5
        0x2703de -> :sswitch_4
        0x2858a1 -> :sswitch_3
        0x29045a -> :sswitch_2
        0x360eb05e -> :sswitch_1
        0x50a5b741 -> :sswitch_0
    .end sparse-switch

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static getSourceTransport(I)I
    .locals 1

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    const/4 v0, 0x2

    :cond_0
    return v0
.end method

.method public static getTargetTransport(I)I
    .locals 1

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    const/4 v0, 0x2

    :cond_0
    return v0
.end method

.method public static imsFeatureToString(I)Ljava/lang/String;
    .locals 2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_1

    const/4 v0, 0x2

    if-eq p0, v0, :cond_0

    .line 369
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unknown("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "RCS"

    return-object p0

    :cond_1
    const-string p0, "MMTEL"

    return-object p0
.end method

.method public static isValidAccessNetwork(I)Z
    .locals 0

    packed-switch p0, :pswitch_data_0

    const/4 p0, 0x0

    return p0

    :pswitch_0
    const/4 p0, 0x1

    return p0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
    .end packed-switch
.end method

.method private static synthetic lambda$getGroupedNetworkRequestList$0(Ljava/util/Set;)Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;
    .locals 0

    .line 405
    new-instance p0, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;-><init>()V

    return-object p0
.end method

.method private static synthetic lambda$getGroupedNetworkRequestList$1(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)I
    .locals 1

    const/4 v0, 0x0

    .line 411
    invoke-virtual {p1, v0}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getPriority()I

    move-result p1

    invoke-virtual {p0, v0}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getPriority()I

    move-result p0

    .line 410
    invoke-static {p1, p0}, Ljava/lang/Integer;->compare(II)I

    move-result p0

    return p0
.end method

.method public static linkStatusToString(I)Ljava/lang/String;
    .locals 2

    const/4 v0, -0x1

    if-eq p0, v0, :cond_3

    if-eqz p0, :cond_2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_1

    const/4 v0, 0x2

    if-eq p0, v0, :cond_0

    .line 453
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UNKNOWN("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "ACTIVE"

    return-object p0

    :cond_1
    const-string p0, "DORMANT"

    return-object p0

    :cond_2
    const-string p0, "INACTIVE"

    return-object p0

    :cond_3
    const-string p0, "UNKNOWN"

    return-object p0
.end method

.method public static networkCapabilitiesToString(Ljava/util/Collection;)Ljava/lang/String;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Collection<",
            "Ljava/lang/Integer;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    if-eqz p0, :cond_1

    .line 181
    invoke-interface {p0}, Ljava/util/Collection;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 182
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {p0}, Ljava/util/Collection;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v1, Lcom/android/internal/telephony/data/DataUtils$$ExternalSyntheticLambda1;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataUtils$$ExternalSyntheticLambda1;-><init>()V

    .line 183
    invoke-interface {p0, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    const-string/jumbo v1, "|"

    .line 184
    invoke-static {v1}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {p0, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "]"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_1
    :goto_0
    const-string p0, ""

    return-object p0
.end method

.method public static networkCapabilitiesToString([I)Ljava/lang/String;
    .locals 2

    if-nez p0, :cond_0

    const-string p0, ""

    return-object p0

    .line 197
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p0}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object p0

    new-instance v1, Lcom/android/internal/telephony/data/DataUtils$$ExternalSyntheticLambda0;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataUtils$$ExternalSyntheticLambda0;-><init>()V

    .line 198
    invoke-interface {p0, v1}, Ljava/util/stream/IntStream;->mapToObj(Ljava/util/function/IntFunction;)Ljava/util/stream/Stream;

    move-result-object p0

    const-string/jumbo v1, "|"

    .line 199
    invoke-static {v1}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {p0, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "]"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static networkCapabilityToApnType(I)I
    .locals 3

    const/4 v0, 0x2

    if-eqz p0, :cond_a

    const/4 v1, 0x1

    const/4 v2, 0x4

    if-eq p0, v1, :cond_9

    if-eq p0, v0, :cond_8

    const/4 v0, 0x3

    if-eq p0, v0, :cond_7

    if-eq p0, v2, :cond_6

    const/4 v0, 0x5

    if-eq p0, v0, :cond_5

    const/4 v0, 0x7

    if-eq p0, v0, :cond_4

    const/16 v0, 0xc

    if-eq p0, v0, :cond_3

    const/16 v0, 0x17

    if-eq p0, v0, :cond_2

    const/16 v0, 0x9

    if-eq p0, v0, :cond_1

    const/16 v0, 0xa

    if-eq p0, v0, :cond_0

    packed-switch p0, :pswitch_data_0

    const/4 p0, 0x0

    return p0

    :pswitch_0
    const/16 p0, 0x2000

    return p0

    :pswitch_1
    const/16 p0, 0x1000

    return p0

    :pswitch_2
    const/16 p0, 0x4000

    return p0

    :cond_0
    const/16 p0, 0x200

    return p0

    :cond_1
    const/16 p0, 0x800

    return p0

    :cond_2
    const/16 p0, 0x400

    return p0

    :cond_3
    const/16 p0, 0x11

    return p0

    :cond_4
    const/16 p0, 0x100

    return p0

    :cond_5
    const/16 p0, 0x80

    return p0

    :cond_6
    const/16 p0, 0x40

    return p0

    :cond_7
    const/16 p0, 0x20

    return p0

    :cond_8
    const/16 p0, 0x8

    return p0

    :cond_9
    return v2

    :cond_a
    return v0

    nop

    :pswitch_data_0
    .packed-switch 0x1d
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static networkCapabilityToString(I)Ljava/lang/String;
    .locals 2

    packed-switch p0, :pswitch_data_0

    .line 167
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unknown("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :pswitch_0
    const-string p0, "PRIORITIZE_BANDWIDTH"

    return-object p0

    :pswitch_1
    const-string p0, "PRIORITIZE_LATENCY"

    return-object p0

    :pswitch_2
    const-string p0, "MMTEL"

    return-object p0

    :pswitch_3
    const-string p0, "HEAD_UNIT"

    return-object p0

    :pswitch_4
    const-string p0, "BIP"

    return-object p0

    :pswitch_5
    const-string p0, "VSIM"

    return-object p0

    :pswitch_6
    const-string p0, "ENTERPRISE"

    return-object p0

    :pswitch_7
    const-string p0, "NOT_VCN_MANAGED"

    return-object p0

    :pswitch_8
    const-string p0, "VEHICLE_INTERNAL"

    return-object p0

    :pswitch_9
    const-string p0, "OEM_PRIVATE"

    return-object p0

    :pswitch_a
    const-string p0, "TEMPORARILY_NOT_METERED"

    return-object p0

    :pswitch_b
    const-string p0, "PARTIAL_CONNECTIVITY"

    return-object p0

    :pswitch_c
    const-string p0, "MCX"

    return-object p0

    :pswitch_d
    const-string p0, "OEM_PAID"

    return-object p0

    :pswitch_e
    const-string p0, "NOT_SUSPENDED"

    return-object p0

    :pswitch_f
    const-string p0, "NOT_CONGESTED"

    return-object p0

    :pswitch_10
    const-string p0, "FOREGROUND"

    return-object p0

    :pswitch_11
    const-string p0, "NOT_ROAMING"

    return-object p0

    :pswitch_12
    const-string p0, "CAPTIVE_PORTAL"

    return-object p0

    :pswitch_13
    const-string p0, "VALIDATED"

    return-object p0

    :pswitch_14
    const-string p0, "NOT_VPN"

    return-object p0

    :pswitch_15
    const-string p0, "TRUSTED"

    return-object p0

    :pswitch_16
    const-string p0, "NOT_RESTRICTED"

    return-object p0

    :pswitch_17
    const-string p0, "INTERNET"

    return-object p0

    :pswitch_18
    const-string p0, "NOT_METERED"

    return-object p0

    :pswitch_19
    const-string p0, "EIMS"

    return-object p0

    :pswitch_1a
    const-string p0, "XCAP"

    return-object p0

    :pswitch_1b
    const-string p0, "RCS"

    return-object p0

    :pswitch_1c
    const-string p0, "IA"

    return-object p0

    :pswitch_1d
    const-string p0, "WIFI_P2P"

    return-object p0

    :pswitch_1e
    const-string p0, "CBS"

    return-object p0

    :pswitch_1f
    const-string p0, "IMS"

    return-object p0

    :pswitch_20
    const-string p0, "FOTA"

    return-object p0

    :pswitch_21
    const-string p0, "DUN"

    return-object p0

    :pswitch_22
    const-string p0, "SUPL"

    return-object p0

    :pswitch_23
    const-string p0, "MMS"

    return-object p0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_23
        :pswitch_22
        :pswitch_21
        :pswitch_20
        :pswitch_1f
        :pswitch_1e
        :pswitch_1d
        :pswitch_1c
        :pswitch_1b
        :pswitch_1a
        :pswitch_19
        :pswitch_18
        :pswitch_17
        :pswitch_16
        :pswitch_15
        :pswitch_14
        :pswitch_13
        :pswitch_12
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static networkTypeToAccessNetworkType(I)I
    .locals 0

    packed-switch p0, :pswitch_data_0

    :pswitch_0
    const/4 p0, 0x0

    return p0

    :pswitch_1
    const/4 p0, 0x6

    return p0

    :pswitch_2
    const/4 p0, 0x5

    return p0

    :pswitch_3
    const/4 p0, 0x3

    return p0

    :pswitch_4
    const/4 p0, 0x4

    return p0

    :pswitch_5
    const/4 p0, 0x2

    return p0

    :pswitch_6
    const/4 p0, 0x1

    return p0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_6
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_4
        :pswitch_4
        :pswitch_4
        :pswitch_5
        :pswitch_5
        :pswitch_5
        :pswitch_0
        :pswitch_4
        :pswitch_3
        :pswitch_4
        :pswitch_5
        :pswitch_6
        :pswitch_5
        :pswitch_2
        :pswitch_3
        :pswitch_1
    .end packed-switch
.end method

.method public static systemTimeToString(J)Ljava/lang/String;
    .locals 2

    const-wide/16 v0, 0x0

    cmp-long v0, p0, v0

    if-eqz v0, :cond_0

    .line 355
    sget-object v0, Lcom/android/internal/telephony/data/DataUtils;->TIME_FORMAT:Ljava/text/SimpleDateFormat;

    invoke-static {p0, p1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/text/SimpleDateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, "never"

    :goto_0
    return-object p0
.end method

.method public static validationStatusToString(I)Ljava/lang/String;
    .locals 2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_1

    const/4 v0, 0x2

    if-eq p0, v0, :cond_0

    .line 212
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UNKNOWN("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "INVALID"

    return-object p0

    :cond_1
    const-string p0, "VALID"

    return-object p0
.end method
