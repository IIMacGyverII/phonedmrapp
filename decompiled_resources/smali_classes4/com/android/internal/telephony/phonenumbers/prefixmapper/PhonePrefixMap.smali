.class public Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;
.super Ljava/lang/Object;
.source "PhonePrefixMap.java"

# interfaces
.implements Ljava/io/Externalizable;


# static fields
.field private static final logger:Ljava/util/logging/Logger;


# instance fields
.field private phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

.field private final phoneUtil:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 40
    const-class v0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/util/logging/Logger;->getLogger(Ljava/lang/String;)Ljava/util/logging/Logger;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->logger:Ljava/util/logging/Logger;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 54
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 39
    invoke-static {}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;->getInstance()Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phoneUtil:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;

    return-void
.end method

.method private binarySearch(IIJ)I
    .locals 3

    const/4 v0, 0x0

    :goto_0
    if-gt p1, p2, :cond_2

    add-int v0, p1, p2

    ushr-int/lit8 v0, v0, 0x1

    .line 196
    iget-object v1, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;->getPrefix(I)I

    move-result v1

    int-to-long v1, v1

    cmp-long v1, v1, p3

    if-nez v1, :cond_0

    return v0

    :cond_0
    if-lez v1, :cond_1

    add-int/lit8 v0, v0, -0x1

    move p2, v0

    goto :goto_0

    :cond_1
    add-int/lit8 p1, v0, 0x1

    goto :goto_0

    :cond_2
    return v0
.end method

.method private createDefaultMapStorage()Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;
    .locals 0

    .line 73
    new-instance p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/DefaultMapStorage;

    invoke-direct {p0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/DefaultMapStorage;-><init>()V

    return-object p0
.end method

.method private createFlyweightMapStorage()Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;
    .locals 0

    .line 77
    new-instance p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/FlyweightMapStorage;

    invoke-direct {p0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/FlyweightMapStorage;-><init>()V

    return-object p0
.end method

.method private static getSizeOfPhonePrefixMapStorage(Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;Ljava/util/SortedMap;)I
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;",
            "Ljava/util/SortedMap<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;)I"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 62
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;->readFromSortedMap(Ljava/util/SortedMap;)V

    .line 63
    new-instance p1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {p1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 64
    new-instance v0, Ljava/io/ObjectOutputStream;

    invoke-direct {v0, p1}, Ljava/io/ObjectOutputStream;-><init>(Ljava/io/OutputStream;)V

    .line 65
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 66
    invoke-virtual {v0}, Ljava/io/ObjectOutputStream;->flush()V

    .line 67
    invoke-virtual {p1}, Ljava/io/ByteArrayOutputStream;->size()I

    move-result p0

    .line 68
    invoke-virtual {v0}, Ljava/io/ObjectOutputStream;->close()V

    return p0
.end method


# virtual methods
.method getPhonePrefixMapStorage()Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;
    .locals 0

    .line 46
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    return-object p0
.end method

.method getSmallerMapStorage(Ljava/util/SortedMap;)Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/SortedMap<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;)",
            "Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;"
        }
    .end annotation

    .line 88
    :try_start_0
    invoke-direct {p0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->createFlyweightMapStorage()Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    move-result-object v0

    .line 89
    invoke-static {v0, p1}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->getSizeOfPhonePrefixMapStorage(Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;Ljava/util/SortedMap;)I

    move-result v1

    .line 92
    invoke-direct {p0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->createDefaultMapStorage()Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    move-result-object v2

    .line 93
    invoke-static {v2, p1}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->getSizeOfPhonePrefixMapStorage(Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;Ljava/util/SortedMap;)I

    move-result p0
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    if-ge v1, p0, :cond_0

    goto :goto_0

    :cond_0
    move-object v0, v2

    :goto_0
    return-object v0

    :catch_0
    move-exception p1

    .line 99
    sget-object v0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->logger:Ljava/util/logging/Logger;

    invoke-virtual {p1}, Ljava/io/IOException;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/util/logging/Logger;->severe(Ljava/lang/String;)V

    .line 100
    invoke-direct {p0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->createFlyweightMapStorage()Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    move-result-object p0

    return-object p0
.end method

.method lookup(J)Ljava/lang/String;
    .locals 8

    .line 148
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    invoke-virtual {v0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;->getNumOfEntries()I

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    :cond_0
    add-int/lit8 v0, v0, -0x1

    .line 154
    iget-object v2, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    invoke-virtual {v2}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;->getPossibleLengths()Ljava/util/TreeSet;

    move-result-object v2

    .line 155
    :goto_0
    invoke-interface {v2}, Ljava/util/SortedSet;->size()I

    move-result v3

    if-lez v3, :cond_4

    .line 156
    invoke-interface {v2}, Ljava/util/SortedSet;->last()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Integer;

    .line 157
    invoke-static {p1, p2}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object v4

    .line 158
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v5

    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result v6

    const/4 v7, 0x0

    if-le v5, v6, :cond_1

    .line 159
    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-virtual {v4, v7, p1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide p1

    .line 161
    :cond_1
    invoke-direct {p0, v7, v0, p1, p2}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->binarySearch(IIJ)I

    move-result v0

    if-gez v0, :cond_2

    return-object v1

    .line 165
    :cond_2
    iget-object v4, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    invoke-virtual {v4, v0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;->getPrefix(I)I

    move-result v4

    int-to-long v4, v4

    cmp-long v4, p1, v4

    if-nez v4, :cond_3

    .line 167
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;->getDescription(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 169
    :cond_3
    invoke-interface {v2, v3}, Ljava/util/SortedSet;->headSet(Ljava/lang/Object;)Ljava/util/SortedSet;

    move-result-object v2

    goto :goto_0

    :cond_4
    return-object v1
.end method

.method public lookup(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/lang/String;
    .locals 2

    .line 181
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 182
    invoke-virtual {p1}, Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;->getCountryCode()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phoneUtil:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;

    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;->getNationalSignificantNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0

    .line 183
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->lookup(J)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public readExternal(Ljava/io/ObjectInput;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 121
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 123
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/FlyweightMapStorage;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/FlyweightMapStorage;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    goto :goto_0

    .line 125
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/DefaultMapStorage;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/DefaultMapStorage;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    .line 127
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;->readExternal(Ljava/io/ObjectInput;)V

    return-void
.end method

.method public readPhonePrefixMap(Ljava/util/SortedMap;)V
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

    .line 113
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->getSmallerMapStorage(Ljava/util/SortedMap;)Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 0

    .line 214
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeExternal(Ljava/io/ObjectOutput;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 134
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    instance-of v0, v0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/FlyweightMapStorage;

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 135
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMap;->phonePrefixMapStorage:Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/phonenumbers/prefixmapper/PhonePrefixMapStorageStrategy;->writeExternal(Ljava/io/ObjectOutput;)V

    return-void
.end method
