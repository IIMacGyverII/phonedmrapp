.class public Lcom/android/internal/telephony/phonenumbers/prefixmapper/PrefixTimeZonesMap;
.super Ljava/lang/Object;
.source "PrefixTimeZonesMap.java"

# interfaces
.implements Ljava/io/Externalizable;


# static fields
.field private static final RAW_STRING_TIMEZONES_SEPARATOR:Ljava/lang/String; = "&"


# instance fields
.field private final phonePrefixMap:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 35
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 36
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PrefixTimeZonesMap;->phonePrefixMap:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;

    return-void
.end method

.method private lookupTimeZonesForNumber(J)Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(J)",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 76
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PrefixTimeZonesMap;->phonePrefixMap:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;

    invoke-virtual {v0, p1, p2}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->lookup(J)Ljava/lang/String;

    move-result-object p1

    if-nez p1, :cond_0

    .line 78
    new-instance p0, Ljava/util/LinkedList;

    invoke-direct {p0}, Ljava/util/LinkedList;-><init>()V

    return-object p0

    .line 80
    :cond_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PrefixTimeZonesMap;->tokenizeRawOutputString(Ljava/lang/String;)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method private tokenizeRawOutputString(Ljava/lang/String;)Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 110
    new-instance p0, Ljava/util/StringTokenizer;

    const-string v0, "&"

    invoke-direct {p0, p1, v0}, Ljava/util/StringTokenizer;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 112
    new-instance p1, Ljava/util/LinkedList;

    invoke-direct {p1}, Ljava/util/LinkedList;-><init>()V

    .line 113
    :goto_0
    invoke-virtual {p0}, Ljava/util/StringTokenizer;->hasMoreTokens()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 114
    invoke-virtual {p0}, Ljava/util/StringTokenizer;->nextToken()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/util/LinkedList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-object p1
.end method


# virtual methods
.method public lookupCountryLevelTimeZonesForNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/util/List;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 103
    invoke-virtual {p1}, Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;->getCountryCode()I

    move-result p1

    int-to-long v0, p1

    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PrefixTimeZonesMap;->lookupTimeZonesForNumber(J)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method public lookupTimeZonesForNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/util/List;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 91
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;->getCountryCode()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 92
    invoke-static {}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;->getInstance()Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;

    move-result-object v1

    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;->getNationalSignificantNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 91
    invoke-static {p1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0

    .line 93
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PrefixTimeZonesMap;->lookupTimeZonesForNumber(J)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method public readExternal(Ljava/io/ObjectInput;)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 59
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PrefixTimeZonesMap;->phonePrefixMap:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->readExternal(Ljava/io/ObjectInput;)V

    return-void
.end method

.method public readPrefixTimeZonesMap(Ljava/util/SortedMap;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/SortedMap<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 48
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PrefixTimeZonesMap;->phonePrefixMap:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->readPhonePrefixMap(Ljava/util/SortedMap;)V

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 0

    .line 124
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PrefixTimeZonesMap;->phonePrefixMap:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;

    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeExternal(Ljava/io/ObjectOutput;)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 55
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PrefixTimeZonesMap;->phonePrefixMap:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->writeExternal(Ljava/io/ObjectOutput;)V

    return-void
.end method
