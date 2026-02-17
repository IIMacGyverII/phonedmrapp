.class public final Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;
.super Ljava/lang/Object;
.source "EuiccSpecVersion.java"

# interfaces
.implements Ljava/lang/Comparable;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/lang/Comparable<",
        "Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;",
        ">;"
    }
.end annotation


# static fields
.field private static final LOG_TAG:Ljava/lang/String; = "EuiccSpecVer"

.field private static final TAG_ISD_R_APP_TEMPLATE:I = 0xe0

.field private static final TAG_VERSION:I = 0x82


# instance fields
.field private final mVersionValues:[I


# direct methods
.method public constructor <init>(III)V
    .locals 1

    .line 76
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x3

    new-array v0, v0, [I

    .line 38
    iput-object v0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->mVersionValues:[I

    const/4 p0, 0x0

    aput p1, v0, p0

    const/4 p0, 0x1

    aput p2, v0, p0

    const/4 p0, 0x2

    aput p3, v0, p0

    return-void
.end method

.method public constructor <init>([B)V
    .locals 2

    .line 85
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x3

    new-array v0, v0, [I

    .line 38
    iput-object v0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->mVersionValues:[I

    const/4 p0, 0x0

    .line 86
    aget-byte v1, p1, p0

    and-int/lit16 v1, v1, 0xff

    aput v1, v0, p0

    const/4 p0, 0x1

    .line 87
    aget-byte v1, p1, p0

    and-int/lit16 v1, v1, 0xff

    aput v1, v0, p0

    const/4 p0, 0x2

    .line 88
    aget-byte p1, p1, p0

    and-int/lit16 p1, p1, 0xff

    aput p1, v0, p0

    return-void
.end method

.method public static fromOpenChannelResponse([B)Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;
    .locals 7

    const-string v0, "Cannot parse select response of ISD-R: "

    const-string v1, "EuiccSpecVer"

    const/4 v2, 0x0

    .line 48
    :try_start_0
    new-instance v3, Lcom/android/internal/telephony/uicc/asn1/Asn1Decoder;

    invoke-direct {v3, p0}, Lcom/android/internal/telephony/uicc/asn1/Asn1Decoder;-><init>([B)V

    .line 49
    invoke-virtual {v3}, Lcom/android/internal/telephony/uicc/asn1/Asn1Decoder;->hasNextNode()Z

    move-result p0

    if-nez p0, :cond_0

    return-object v2

    .line 52
    :cond_0
    invoke-virtual {v3}, Lcom/android/internal/telephony/uicc/asn1/Asn1Decoder;->nextNode()Lcom/android/internal/telephony/uicc/asn1/Asn1Node;

    move-result-object p0
    :try_end_0
    .catch Lcom/android/internal/telephony/uicc/asn1/InvalidAsn1DataException; {:try_start_0 .. :try_end_0} :catch_1

    .line 59
    :try_start_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/asn1/Asn1Node;->getTag()I

    move-result v3

    const/4 v4, 0x0

    const/16 v5, 0x82

    const/16 v6, 0xe0

    if-ne v3, v6, :cond_1

    new-array v3, v4, [I

    .line 60
    invoke-virtual {p0, v5, v3}, Lcom/android/internal/telephony/uicc/asn1/Asn1Node;->getChild(I[I)Lcom/android/internal/telephony/uicc/asn1/Asn1Node;

    move-result-object v3

    invoke-virtual {v3}, Lcom/android/internal/telephony/uicc/asn1/Asn1Node;->asBytes()[B

    move-result-object v3

    goto :goto_0

    :cond_1
    const/4 v3, 0x1

    new-array v3, v3, [I

    aput v5, v3, v4

    .line 63
    invoke-virtual {p0, v6, v3}, Lcom/android/internal/telephony/uicc/asn1/Asn1Node;->getChild(I[I)Lcom/android/internal/telephony/uicc/asn1/Asn1Node;

    move-result-object v3

    invoke-virtual {v3}, Lcom/android/internal/telephony/uicc/asn1/Asn1Node;->asBytes()[B

    move-result-object v3

    .line 65
    :goto_0
    array-length v4, v3

    const/4 v5, 0x3

    if-ne v4, v5, :cond_2

    .line 66
    new-instance v4, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;

    invoke-direct {v4, v3}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;-><init>([B)V

    return-object v4

    .line 68
    :cond_2
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/asn1/Asn1Node;->toHex()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v3}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catch Lcom/android/internal/telephony/uicc/asn1/InvalidAsn1DataException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Lcom/android/internal/telephony/uicc/asn1/TagNotFoundException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_1

    .line 71
    :catch_0
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/asn1/Asn1Node;->toHex()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_1
    return-object v2

    :catch_1
    move-exception p0

    const-string v0, "Cannot parse the select response of ISD-R."

    .line 54
    invoke-static {v1, v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v2
.end method


# virtual methods
.method public compareTo(Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;)I
    .locals 4

    .line 105
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->getMajor()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->getMajor()I

    move-result v1

    const/4 v2, 0x1

    if-le v0, v1, :cond_0

    return v2

    .line 107
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->getMajor()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->getMajor()I

    move-result v1

    const/4 v3, -0x1

    if-ge v0, v1, :cond_1

    return v3

    .line 110
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->getMinor()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->getMinor()I

    move-result v1

    if-le v0, v1, :cond_2

    return v2

    .line 112
    :cond_2
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->getMinor()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->getMinor()I

    move-result v1

    if-ge v0, v1, :cond_3

    return v3

    .line 115
    :cond_3
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->getRevision()I

    move-result v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->getRevision()I

    move-result v1

    if-le v0, v1, :cond_4

    return v2

    .line 117
    :cond_4
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->getRevision()I

    move-result p0

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->getRevision()I

    move-result p1

    if-ge p0, p1, :cond_5

    return v3

    :cond_5
    const/4 p0, 0x0

    return p0
.end method

.method public bridge synthetic compareTo(Ljava/lang/Object;)I
    .locals 0

    .line 31
    check-cast p1, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->compareTo(Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;)I

    move-result p0

    return p0
.end method

.method public equals(Ljava/lang/Object;)Z
    .locals 2

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    if-eqz p1, :cond_2

    .line 128
    const-class v0, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    if-eq v0, v1, :cond_1

    goto :goto_0

    .line 131
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->mVersionValues:[I

    check-cast p1, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;

    iget-object p1, p1, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->mVersionValues:[I

    invoke-static {p0, p1}, Ljava/util/Arrays;->equals([I[I)Z

    move-result p0

    return p0

    :cond_2
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method public getMajor()I
    .locals 1

    .line 92
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->mVersionValues:[I

    const/4 v0, 0x0

    aget p0, p0, v0

    return p0
.end method

.method public getMinor()I
    .locals 1

    .line 96
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->mVersionValues:[I

    const/4 v0, 0x1

    aget p0, p0, v0

    return p0
.end method

.method public getRevision()I
    .locals 1

    .line 100
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->mVersionValues:[I

    const/4 v0, 0x2

    aget p0, p0, v0

    return p0
.end method

.method public hashCode()I
    .locals 0

    .line 136
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->mVersionValues:[I

    invoke-static {p0}, Ljava/util/Arrays;->hashCode([I)I

    move-result p0

    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 4

    .line 141
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->mVersionValues:[I

    const/4 v2, 0x0

    aget v1, v1, v2

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, "."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->mVersionValues:[I

    const/4 v3, 0x1

    aget v2, v2, v3

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;->mVersionValues:[I

    const/4 v1, 0x2

    aget p0, p0, v1

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
