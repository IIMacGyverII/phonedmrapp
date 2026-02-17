.class public Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;
.super Ljava/lang/Object;
.source "ShortNumberInfo.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;
    }
.end annotation


# static fields
.field private static final INSTANCE:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;

.field private static final REGIONS_WHERE_EMERGENCY_NUMBERS_MUST_BE_EXACT:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private static final logger:Ljava/util/logging/Logger;


# instance fields
.field private final countryCallingCodeToRegionCodeMap:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;>;"
        }
    .end annotation
.end field

.field private final matcherApi:Lcom/android/internal/telephony/phonenumbers/internal/MatcherApi;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 44
    const-class v0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/util/logging/Logger;->getLogger(Ljava/lang/String;)Ljava/util/logging/Logger;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->logger:Ljava/util/logging/Logger;

    .line 46
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;

    .line 47
    invoke-static {}, Lcom/android/internal/telephony/phonenumbers/internal/RegexBasedMatcher;->create()Lcom/android/internal/telephony/phonenumbers/internal/MatcherApi;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;-><init>(Lcom/android/internal/telephony/phonenumbers/internal/MatcherApi;)V

    sput-object v0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->INSTANCE:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;

    .line 51
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->REGIONS_WHERE_EMERGENCY_NUMBERS_MUST_BE_EXACT:Ljava/util/Set;

    const-string v1, "BR"

    .line 54
    invoke-interface {v0, v1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string v1, "CL"

    .line 55
    invoke-interface {v0, v1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string v1, "NI"

    .line 56
    invoke-interface {v0, v1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method constructor <init>(Lcom/android/internal/telephony/phonenumbers/internal/MatcherApi;)V
    .locals 0

    .line 83
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 84
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matcherApi:Lcom/android/internal/telephony/phonenumbers/internal/MatcherApi;

    .line 87
    invoke-static {}, Lcom/android/internal/telephony/phonenumbers/CountryCodeToRegionCodeMap;->getCountryCodeToRegionCodeMap()Ljava/util/Map;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->countryCallingCodeToRegionCodeMap:Ljava/util/Map;

    return-void
.end method

.method public static getInstance()Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;
    .locals 1

    .line 69
    sget-object v0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->INSTANCE:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;

    return-object v0
.end method

.method private static getNationalSignificantNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/lang/String;
    .locals 3

    .line 539
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 540
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;->isItalianLeadingZero()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 541
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;->getNumberOfLeadingZeros()I

    move-result v1

    new-array v1, v1, [C

    const/16 v2, 0x30

    .line 542
    invoke-static {v1, v2}, Ljava/util/Arrays;->fill([CC)V

    .line 543
    new-instance v2, Ljava/lang/String;

    invoke-direct {v2, v1}, Ljava/lang/String;-><init>([C)V

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 545
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;->getNationalNumber()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    .line 546
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private getRegionCodeForShortNumberFromRegionList(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/util/List;)Ljava/lang/String;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    .line 322
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    .line 324
    :cond_0
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_1

    const/4 p0, 0x0

    .line 325
    invoke-interface {p2, p0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0

    .line 327
    :cond_1
    invoke-static {p1}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getNationalSignificantNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/lang/String;

    move-result-object p1

    .line 328
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :cond_2
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_3

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 329
    invoke-static {v0}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getShortNumberMetadataForRegion(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    move-result-object v2

    if-eqz v2, :cond_2

    .line 331
    invoke-virtual {v2}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getShortCode()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object v2

    invoke-direct {p0, p1, v2}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matchesPossibleNumberAndNationalNumber(Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Z

    move-result v2

    if-eqz v2, :cond_2

    return-object v0

    :cond_3
    return-object v1
.end method

.method private getRegionCodesForCountryCode(I)Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 96
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->countryCallingCodeToRegionCodeMap:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/List;

    if-nez p0, :cond_0

    .line 97
    new-instance p0, Ljava/util/ArrayList;

    const/4 p1, 0x0

    invoke-direct {p0, p1}, Ljava/util/ArrayList;-><init>(I)V

    :cond_0
    invoke-static {p0}, Ljava/util/Collections;->unmodifiableList(Ljava/util/List;)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method private matchesEmergencyNumberHelper(Ljava/lang/CharSequence;Ljava/lang/String;Z)Z
    .locals 3

    .line 437
    invoke-static {p1}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;->extractPossibleNumber(Ljava/lang/CharSequence;)Ljava/lang/CharSequence;

    move-result-object p1

    .line 438
    sget-object v0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;->PLUS_CHARS_PATTERN:Ljava/util/regex/Pattern;

    invoke-virtual {v0, p1}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/regex/Matcher;->lookingAt()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    return v1

    .line 444
    :cond_0
    invoke-static {p2}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getShortNumberMetadataForRegion(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 445
    invoke-virtual {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasEmergency()Z

    move-result v2

    if-nez v2, :cond_1

    goto :goto_0

    .line 449
    :cond_1
    invoke-static {p1}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;->normalizeDigitsOnly(Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p1

    if-eqz p3, :cond_2

    .line 450
    sget-object p3, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->REGIONS_WHERE_EMERGENCY_NUMBERS_MUST_BE_EXACT:Ljava/util/Set;

    .line 451
    invoke-interface {p3, p2}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_2

    const/4 v1, 0x1

    .line 452
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matcherApi:Lcom/android/internal/telephony/phonenumbers/internal/MatcherApi;

    invoke-virtual {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getEmergency()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object p2

    invoke-interface {p0, p1, p2, v1}, Lcom/android/internal/telephony/phonenumbers/internal/MatcherApi;->matchNationalNumber(Ljava/lang/CharSequence;Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;Z)Z

    move-result p0

    return p0

    :cond_3
    :goto_0
    return v1
.end method

.method private matchesPossibleNumberAndNationalNumber(Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Z
    .locals 3

    .line 553
    invoke-virtual {p2}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->getPossibleLengthCount()I

    move-result v0

    const/4 v1, 0x0

    if-lez v0, :cond_0

    .line 554
    invoke-virtual {p2}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->getPossibleLengthList()Ljava/util/List;

    move-result-object v0

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    return v1

    .line 557
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matcherApi:Lcom/android/internal/telephony/phonenumbers/internal/MatcherApi;

    invoke-interface {p0, p1, p2, v1}, Lcom/android/internal/telephony/phonenumbers/internal/MatcherApi;->matchNationalNumber(Ljava/lang/CharSequence;Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;Z)Z

    move-result p0

    return p0
.end method

.method private regionDialingFromMatchesNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Z
    .locals 0

    .line 107
    invoke-virtual {p1}, Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;->getCountryCode()I

    move-result p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getRegionCodesForCountryCode(I)Ljava/util/List;

    move-result-object p0

    .line 108
    invoke-interface {p0, p2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method


# virtual methods
.method public connectsToEmergencyNumber(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 1

    const/4 v0, 0x1

    .line 416
    invoke-direct {p0, p1, p2, v0}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matchesEmergencyNumberHelper(Ljava/lang/CharSequence;Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method getExampleShortNumber(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 355
    invoke-static {p1}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getShortNumberMetadataForRegion(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    move-result-object p0

    const-string p1, ""

    if-nez p0, :cond_0

    return-object p1

    .line 359
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getShortCode()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object p0

    .line 360
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->hasExampleNumber()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 361
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->getExampleNumber()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_1
    return-object p1
.end method

.method getExampleShortNumberForCost(Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;)Ljava/lang/String;
    .locals 2

    .line 376
    invoke-static {p1}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getShortNumberMetadataForRegion(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    move-result-object p0

    const-string p1, ""

    if-nez p0, :cond_0

    return-object p1

    :cond_0
    const/4 v0, 0x0

    .line 381
    sget-object v1, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$1;->$SwitchMap$com$google$i18n$phonenumbers$ShortNumberInfo$ShortNumberCost:[I

    invoke-virtual {p2}, Ljava/lang/Enum;->ordinal()I

    move-result p2

    aget p2, v1, p2

    const/4 v1, 0x1

    if-eq p2, v1, :cond_3

    const/4 v1, 0x3

    if-eq p2, v1, :cond_2

    const/4 v1, 0x4

    if-eq p2, v1, :cond_1

    goto :goto_0

    .line 383
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getTollFree()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object v0

    goto :goto_0

    .line 386
    :cond_2
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getStandardRate()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object v0

    goto :goto_0

    .line 389
    :cond_3
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getPremiumRate()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object v0

    :goto_0
    if-eqz v0, :cond_4

    .line 395
    invoke-virtual {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->hasExampleNumber()Z

    move-result p0

    if-eqz p0, :cond_4

    .line 396
    invoke-virtual {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->getExampleNumber()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_4
    return-object p1
.end method

.method public getExpectedCost(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;
    .locals 8

    .line 286
    invoke-virtual {p1}, Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;->getCountryCode()I

    move-result v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getRegionCodesForCountryCode(I)Ljava/util/List;

    move-result-object v0

    .line 287
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    if-nez v1, :cond_0

    .line 288
    sget-object p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->UNKNOWN_COST:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    return-object p0

    .line 290
    :cond_0
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    const/4 v2, 0x1

    if-ne v1, v2, :cond_1

    const/4 v1, 0x0

    .line 291
    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getExpectedCostForRegion(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    move-result-object p0

    return-object p0

    .line 293
    :cond_1
    sget-object v1, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->TOLL_FREE:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    .line 294
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_2
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_6

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 295
    invoke-virtual {p0, p1, v3}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getExpectedCostForRegion(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    move-result-object v3

    .line 296
    sget-object v4, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$1;->$SwitchMap$com$google$i18n$phonenumbers$ShortNumberInfo$ShortNumberCost:[I

    invoke-virtual {v3}, Ljava/lang/Enum;->ordinal()I

    move-result v5

    aget v4, v4, v5

    if-eq v4, v2, :cond_5

    const/4 v5, 0x2

    if-eq v4, v5, :cond_4

    const/4 v5, 0x3

    if-eq v4, v5, :cond_3

    const/4 v5, 0x4

    if-eq v4, v5, :cond_2

    .line 311
    sget-object v4, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->logger:Ljava/util/logging/Logger;

    sget-object v5, Ljava/util/logging/Level;->SEVERE:Ljava/util/logging/Level;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Unrecognised cost for region: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v5, v3}, Ljava/util/logging/Logger;->log(Ljava/util/logging/Level;Ljava/lang/String;)V

    goto :goto_0

    .line 303
    :cond_3
    sget-object v3, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->UNKNOWN_COST:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    if-eq v1, v3, :cond_2

    .line 304
    sget-object v1, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->STANDARD_RATE:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    goto :goto_0

    .line 300
    :cond_4
    sget-object v1, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->UNKNOWN_COST:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    goto :goto_0

    .line 298
    :cond_5
    sget-object p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->PREMIUM_RATE:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    return-object p0

    :cond_6
    return-object v1
.end method

.method public getExpectedCostForRegion(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;
    .locals 3

    .line 227
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->regionDialingFromMatchesNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 228
    sget-object p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->UNKNOWN_COST:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    return-object p0

    .line 231
    :cond_0
    invoke-static {p2}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getShortNumberMetadataForRegion(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    move-result-object v0

    if-nez v0, :cond_1

    .line 234
    sget-object p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->UNKNOWN_COST:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    return-object p0

    .line 237
    :cond_1
    invoke-static {p1}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getNationalSignificantNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/lang/String;

    move-result-object p1

    .line 242
    invoke-virtual {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getGeneralDesc()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->getPossibleLengthList()Ljava/util/List;

    move-result-object v1

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2

    .line 243
    sget-object p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->UNKNOWN_COST:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    return-object p0

    .line 248
    :cond_2
    invoke-virtual {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getPremiumRate()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object v1

    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matchesPossibleNumberAndNationalNumber(Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Z

    move-result v1

    if-eqz v1, :cond_3

    .line 249
    sget-object p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->PREMIUM_RATE:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    return-object p0

    .line 251
    :cond_3
    invoke-virtual {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getStandardRate()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object v1

    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matchesPossibleNumberAndNationalNumber(Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Z

    move-result v1

    if-eqz v1, :cond_4

    .line 252
    sget-object p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->STANDARD_RATE:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    return-object p0

    .line 254
    :cond_4
    invoke-virtual {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getTollFree()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object v0

    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matchesPossibleNumberAndNationalNumber(Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Z

    move-result v0

    if-eqz v0, :cond_5

    .line 255
    sget-object p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->TOLL_FREE:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    return-object p0

    .line 257
    :cond_5
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->isEmergencyNumber(Ljava/lang/CharSequence;Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_6

    .line 259
    sget-object p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->TOLL_FREE:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    return-object p0

    .line 261
    :cond_6
    sget-object p0, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;->UNKNOWN_COST:Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo$ShortNumberCost;

    return-object p0
.end method

.method getSupportedRegions()Ljava/util/Set;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 343
    invoke-static {}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getSupportedShortNumberRegions()Ljava/util/Set;

    move-result-object p0

    return-object p0
.end method

.method public isCarrierSpecific(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Z
    .locals 1

    .line 468
    invoke-virtual {p1}, Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;->getCountryCode()I

    move-result v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getRegionCodesForCountryCode(I)Ljava/util/List;

    move-result-object v0

    .line 469
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getRegionCodeForShortNumberFromRegionList(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/util/List;)Ljava/lang/String;

    move-result-object v0

    .line 470
    invoke-static {p1}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getNationalSignificantNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/lang/String;

    move-result-object p1

    .line 471
    invoke-static {v0}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getShortNumberMetadataForRegion(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 474
    invoke-virtual {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getCarrierSpecific()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object v0

    .line 473
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matchesPossibleNumberAndNationalNumber(Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isCarrierSpecificForRegion(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Z
    .locals 2

    .line 491
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->regionDialingFromMatchesNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 494
    :cond_0
    invoke-static {p1}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getNationalSignificantNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/lang/String;

    move-result-object p1

    .line 496
    invoke-static {p2}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getShortNumberMetadataForRegion(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    move-result-object p2

    if-eqz p2, :cond_1

    .line 499
    invoke-virtual {p2}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getCarrierSpecific()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object p2

    .line 498
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matchesPossibleNumberAndNationalNumber(Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Z

    move-result p0

    if-eqz p0, :cond_1

    const/4 v1, 0x1

    :cond_1
    return v1
.end method

.method public isEmergencyNumber(Ljava/lang/CharSequence;Ljava/lang/String;)Z
    .locals 1

    const/4 v0, 0x0

    .line 432
    invoke-direct {p0, p1, p2, v0}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matchesEmergencyNumberHelper(Ljava/lang/CharSequence;Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method public isPossibleShortNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Z
    .locals 2

    .line 142
    invoke-virtual {p1}, Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;->getCountryCode()I

    move-result v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getRegionCodesForCountryCode(I)Ljava/util/List;

    move-result-object p0

    .line 143
    invoke-static {p1}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getNationalSignificantNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    .line 144
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 145
    invoke-static {v0}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getShortNumberMetadataForRegion(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    move-result-object v0

    if-nez v0, :cond_1

    goto :goto_0

    .line 149
    :cond_1
    invoke-virtual {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getGeneralDesc()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->getPossibleLengthList()Ljava/util/List;

    move-result-object v0

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_2
    const/4 p0, 0x0

    return p0
.end method

.method public isPossibleShortNumberForRegion(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Z
    .locals 1

    .line 120
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->regionDialingFromMatchesNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Z

    move-result p0

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return v0

    .line 124
    :cond_0
    invoke-static {p2}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getShortNumberMetadataForRegion(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    move-result-object p0

    if-nez p0, :cond_1

    return v0

    .line 128
    :cond_1
    invoke-static {p1}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getNationalSignificantNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    .line 129
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getGeneralDesc()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->getPossibleLengthList()Ljava/util/List;

    move-result-object p0

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method public isSmsServiceForRegion(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Z
    .locals 2

    .line 516
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->regionDialingFromMatchesNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 520
    :cond_0
    invoke-static {p2}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getShortNumberMetadataForRegion(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    move-result-object p2

    if-eqz p2, :cond_1

    .line 522
    invoke-static {p1}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getNationalSignificantNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/lang/String;

    move-result-object p1

    .line 523
    invoke-virtual {p2}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getSmsServices()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object p2

    .line 522
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matchesPossibleNumberAndNationalNumber(Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Z

    move-result p0

    if-eqz p0, :cond_1

    const/4 v1, 0x1

    :cond_1
    return v1
.end method

.method public isValidShortNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Z
    .locals 3

    .line 193
    invoke-virtual {p1}, Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;->getCountryCode()I

    move-result v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getRegionCodesForCountryCode(I)Ljava/util/List;

    move-result-object v0

    .line 194
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getRegionCodeForShortNumberFromRegionList(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/util/List;)Ljava/lang/String;

    move-result-object v1

    .line 195
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    const/4 v2, 0x1

    if-le v0, v2, :cond_0

    if-eqz v1, :cond_0

    return v2

    .line 200
    :cond_0
    invoke-virtual {p0, p1, v1}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->isValidShortNumberForRegion(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public isValidShortNumberForRegion(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Z
    .locals 2

    .line 166
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->regionDialingFromMatchesNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 170
    :cond_0
    invoke-static {p2}, Lcom/android/internal/telephony/phonenumbers/MetadataManager;->getShortNumberMetadataForRegion(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    move-result-object p2

    if-nez p2, :cond_1

    return v1

    .line 174
    :cond_1
    invoke-static {p1}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->getNationalSignificantNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/lang/String;

    move-result-object p1

    .line 175
    invoke-virtual {p2}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getGeneralDesc()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object v0

    .line 176
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matchesPossibleNumberAndNationalNumber(Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Z

    move-result v0

    if-nez v0, :cond_2

    return v1

    .line 179
    :cond_2
    invoke-virtual {p2}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getShortCode()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    move-result-object p2

    .line 180
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/phonenumbers/ShortNumberInfo;->matchesPossibleNumberAndNationalNumber(Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Z

    move-result p0

    return p0
.end method
