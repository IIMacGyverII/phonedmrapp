.class final enum Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency$3;
.super Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;
.source "PhoneNumberUtil.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4010
    name = null
.end annotation


# direct methods
.method constructor <init>(Ljava/lang/String;I)V
    .locals 1

    const/4 v0, 0x0

    .line 575
    invoke-direct {p0, p1, p2, v0}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;-><init>(Ljava/lang/String;ILcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$1;)V

    return-void
.end method


# virtual methods
.method verify(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/CharSequence;Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatcher;)Z
    .locals 2

    .line 582
    invoke-interface {p2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    .line 583
    invoke-virtual {p3, p1}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;->isValidNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 584
    invoke-static {p1, v0, p3}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatcher;->containsOnlyValidXChars(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 585
    invoke-static {p1, v0}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatcher;->containsMoreThanOneSlashInNationalNumber(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 586
    invoke-static {p1, p3}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatcher;->isNationalPrefixPresentIfRequired(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 589
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency$3$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency$3$1;-><init>(Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency$3;)V

    invoke-virtual {p4, p1, p2, p3, v0}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatcher;->checkNumberGroupingIsValid(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/CharSequence;Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatcher$NumberGroupingChecker;)Z

    move-result p0

    return p0

    :cond_1
    :goto_0
    const/4 p0, 0x0

    return p0
.end method
