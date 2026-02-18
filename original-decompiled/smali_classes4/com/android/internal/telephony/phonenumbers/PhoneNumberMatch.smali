.class public final Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;
.super Ljava/lang/Object;
.source "PhoneNumberMatch.java"


# instance fields
.field private final number:Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;

.field private final rawString:Ljava/lang/String;

.field private final start:I


# direct methods
.method constructor <init>(ILjava/lang/String;Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)V
    .locals 0

    .line 69
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    if-ltz p1, :cond_1

    if-eqz p2, :cond_0

    if-eqz p3, :cond_0

    .line 76
    iput p1, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->start:I

    .line 77
    iput-object p2, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->rawString:Ljava/lang/String;

    .line 78
    iput-object p3, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->number:Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;

    return-void

    :cond_0
    const/4 p0, 0x0

    .line 74
    throw p0

    .line 71
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Start index must be >= 0."

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method


# virtual methods
.method public end()I
    .locals 1

    .line 93
    iget v0, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->start:I

    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->rawString:Ljava/lang/String;

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    add-int/2addr v0, p0

    return v0
.end method

.method public equals(Ljava/lang/Object;)Z
    .locals 4

    const/4 v0, 0x1

    if-ne p0, p1, :cond_0

    return v0

    .line 111
    :cond_0
    instance-of v1, p1, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;

    const/4 v2, 0x0

    if-nez v1, :cond_1

    return v2

    .line 114
    :cond_1
    check-cast p1, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;

    .line 115
    iget-object v1, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->rawString:Ljava/lang/String;

    iget-object v3, p1, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->rawString:Ljava/lang/String;

    invoke-virtual {v1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    iget v1, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->start:I

    iget v3, p1, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->start:I

    if-ne v1, v3, :cond_2

    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->number:Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;

    iget-object p1, p1, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->number:Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;

    .line 116
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_2

    goto :goto_0

    :cond_2
    move v0, v2

    :goto_0
    return v0
.end method

.method public hashCode()I
    .locals 3

    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/Object;

    .line 103
    iget v1, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->start:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->rawString:Ljava/lang/String;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->number:Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;

    const/4 v1, 0x2

    aput-object p0, v0, v1

    invoke-static {v0}, Ljava/util/Arrays;->hashCode([Ljava/lang/Object;)I

    move-result p0

    return p0
.end method

.method public number()Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;
    .locals 0

    .line 83
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->number:Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;

    return-object p0
.end method

.method public rawString()Ljava/lang/String;
    .locals 0

    .line 98
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->rawString:Ljava/lang/String;

    return-object p0
.end method

.method public start()I
    .locals 0

    .line 88
    iget p0, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->start:I

    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 121
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "PhoneNumberMatch ["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->start()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ","

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->end()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ") "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;->rawString:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
