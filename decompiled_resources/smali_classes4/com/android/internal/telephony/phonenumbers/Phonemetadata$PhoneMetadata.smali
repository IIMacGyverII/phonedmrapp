.class public Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
.super Ljava/lang/Object;
.source "Phonemetadata.java"

# interfaces
.implements Ljava/io/Externalizable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/phonenumbers/Phonemetadata;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "PhoneMetadata"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata$Builder;
    }
.end annotation


# static fields
.field private static final serialVersionUID:J = 0x1L


# instance fields
.field private carrierSpecific_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private countryCode_:I

.field private emergency_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private fixedLine_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private generalDesc_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private hasCarrierSpecific:Z

.field private hasCountryCode:Z

.field private hasEmergency:Z

.field private hasFixedLine:Z

.field private hasGeneralDesc:Z

.field private hasId:Z

.field private hasInternationalPrefix:Z

.field private hasLeadingDigits:Z

.field private hasLeadingZeroPossible:Z

.field private hasMainCountryForCode:Z

.field private hasMobile:Z

.field private hasMobileNumberPortableRegion:Z

.field private hasNationalPrefix:Z

.field private hasNationalPrefixForParsing:Z

.field private hasNationalPrefixTransformRule:Z

.field private hasNoInternationalDialling:Z

.field private hasPager:Z

.field private hasPersonalNumber:Z

.field private hasPreferredExtnPrefix:Z

.field private hasPreferredInternationalPrefix:Z

.field private hasPremiumRate:Z

.field private hasSameMobileAndFixedLinePattern:Z

.field private hasSharedCost:Z

.field private hasShortCode:Z

.field private hasSmsServices:Z

.field private hasStandardRate:Z

.field private hasTollFree:Z

.field private hasUan:Z

.field private hasVoicemail:Z

.field private hasVoip:Z

.field private id_:Ljava/lang/String;

.field private internationalPrefix_:Ljava/lang/String;

.field private intlNumberFormat_:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;",
            ">;"
        }
    .end annotation
.end field

.field private leadingDigits_:Ljava/lang/String;

.field private leadingZeroPossible_:Z

.field private mainCountryForCode_:Z

.field private mobileNumberPortableRegion_:Z

.field private mobile_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private nationalPrefixForParsing_:Ljava/lang/String;

.field private nationalPrefixTransformRule_:Ljava/lang/String;

.field private nationalPrefix_:Ljava/lang/String;

.field private noInternationalDialling_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private numberFormat_:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;",
            ">;"
        }
    .end annotation
.end field

.field private pager_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private personalNumber_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private preferredExtnPrefix_:Ljava/lang/String;

.field private preferredInternationalPrefix_:Ljava/lang/String;

.field private premiumRate_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private sameMobileAndFixedLinePattern_:Z

.field private sharedCost_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private shortCode_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private smsServices_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private standardRate_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private tollFree_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private uan_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private voicemail_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

.field private voip_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;


# direct methods
.method public constructor <init>()V
    .locals 3

    .line 355
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 383
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->generalDesc_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 403
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->fixedLine_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 417
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mobile_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 431
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->tollFree_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 445
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->premiumRate_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 459
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->sharedCost_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 473
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->personalNumber_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 487
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->voip_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 501
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->pager_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 515
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->uan_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 529
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->emergency_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 543
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->voicemail_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 557
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->shortCode_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 571
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->standardRate_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 585
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->carrierSpecific_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 599
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->smsServices_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 613
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->noInternationalDialling_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    const-string v0, ""

    .line 627
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->id_:Ljava/lang/String;

    const/4 v1, 0x0

    .line 638
    iput v1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->countryCode_:I

    .line 649
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->internationalPrefix_:Ljava/lang/String;

    .line 660
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->preferredInternationalPrefix_:Ljava/lang/String;

    .line 676
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefix_:Ljava/lang/String;

    .line 692
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->preferredExtnPrefix_:Ljava/lang/String;

    .line 708
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefixForParsing_:Ljava/lang/String;

    .line 719
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefixTransformRule_:Ljava/lang/String;

    .line 735
    iput-boolean v1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->sameMobileAndFixedLinePattern_:Z

    .line 750
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->numberFormat_:Ljava/util/List;

    .line 773
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->intlNumberFormat_:Ljava/util/List;

    .line 803
    iput-boolean v1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mainCountryForCode_:Z

    .line 822
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->leadingDigits_:Ljava/lang/String;

    .line 833
    iput-boolean v1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->leadingZeroPossible_:Z

    .line 849
    iput-boolean v1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mobileNumberPortableRegion_:Z

    return-void
.end method

.method public static newBuilder()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata$Builder;
    .locals 1

    .line 378
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata$Builder;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata$Builder;-><init>()V

    return-object v0
.end method


# virtual methods
.method public addIntlNumberFormat(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 791
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 793
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->intlNumberFormat_:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-object p0
.end method

.method public addNumberFormat(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 766
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 768
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->numberFormat_:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-object p0
.end method

.method public clearIntlNumberFormat()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 797
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->intlNumberFormat_:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    return-object p0
.end method

.method public clearLeadingZeroPossible()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x0

    .line 842
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasLeadingZeroPossible:Z

    .line 843
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->leadingZeroPossible_:Z

    return-object p0
.end method

.method public clearMainCountryForCode()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x0

    .line 815
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasMainCountryForCode:Z

    .line 816
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mainCountryForCode_:Z

    return-object p0
.end method

.method public clearMobileNumberPortableRegion()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x0

    .line 860
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasMobileNumberPortableRegion:Z

    .line 861
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mobileNumberPortableRegion_:Z

    return-object p0
.end method

.method public clearNationalPrefix()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x0

    .line 685
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefix:Z

    const-string v0, ""

    .line 686
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefix_:Ljava/lang/String;

    return-object p0
.end method

.method public clearNationalPrefixTransformRule()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x0

    .line 728
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefixTransformRule:Z

    const-string v0, ""

    .line 729
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefixTransformRule_:Ljava/lang/String;

    return-object p0
.end method

.method public clearPreferredExtnPrefix()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x0

    .line 701
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPreferredExtnPrefix:Z

    const-string v0, ""

    .line 702
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->preferredExtnPrefix_:Ljava/lang/String;

    return-object p0
.end method

.method public clearPreferredInternationalPrefix()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x0

    .line 669
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPreferredInternationalPrefix:Z

    const-string v0, ""

    .line 670
    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->preferredInternationalPrefix_:Ljava/lang/String;

    return-object p0
.end method

.method public clearSameMobileAndFixedLinePattern()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x0

    .line 744
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasSameMobileAndFixedLinePattern:Z

    .line 745
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->sameMobileAndFixedLinePattern_:Z

    return-object p0
.end method

.method public getCarrierSpecific()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 587
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->carrierSpecific_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getCountryCode()I
    .locals 0

    .line 640
    iget p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->countryCode_:I

    return p0
.end method

.method public getEmergency()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 531
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->emergency_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getFixedLine()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 405
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->fixedLine_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getGeneralDesc()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 385
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->generalDesc_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getGeneralDescBuilder()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 1

    .line 387
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->generalDesc_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    if-nez v0, :cond_0

    .line 388
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->generalDesc_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    .line 390
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->generalDesc_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getId()Ljava/lang/String;
    .locals 0

    .line 629
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->id_:Ljava/lang/String;

    return-object p0
.end method

.method public getInternationalPrefix()Ljava/lang/String;
    .locals 0

    .line 651
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->internationalPrefix_:Ljava/lang/String;

    return-object p0
.end method

.method public getIntlNumberFormat(I)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;
    .locals 0

    .line 786
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->intlNumberFormat_:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;

    return-object p0
.end method

.method public getIntlNumberFormatCount()I
    .locals 0

    .line 784
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->intlNumberFormat_:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result p0

    return p0
.end method

.method public getIntlNumberFormatList()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;",
            ">;"
        }
    .end annotation

    .line 780
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->intlNumberFormat_:Ljava/util/List;

    return-object p0
.end method

.method public getLeadingDigits()Ljava/lang/String;
    .locals 0

    .line 824
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->leadingDigits_:Ljava/lang/String;

    return-object p0
.end method

.method public getMainCountryForCode()Z
    .locals 0

    .line 808
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mainCountryForCode_:Z

    return p0
.end method

.method public getMobile()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 419
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mobile_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getMobileNumberPortableRegion()Z
    .locals 0

    .line 853
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mobileNumberPortableRegion_:Z

    return p0
.end method

.method public getNationalPrefix()Ljava/lang/String;
    .locals 0

    .line 678
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefix_:Ljava/lang/String;

    return-object p0
.end method

.method public getNationalPrefixForParsing()Ljava/lang/String;
    .locals 0

    .line 710
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefixForParsing_:Ljava/lang/String;

    return-object p0
.end method

.method public getNationalPrefixTransformRule()Ljava/lang/String;
    .locals 0

    .line 721
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefixTransformRule_:Ljava/lang/String;

    return-object p0
.end method

.method public getNoInternationalDialling()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 615
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->noInternationalDialling_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getNumberFormat(I)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;
    .locals 0

    .line 762
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->numberFormat_:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;

    return-object p0
.end method

.method public getNumberFormatCount()I
    .locals 0

    .line 760
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->numberFormat_:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result p0

    return p0
.end method

.method public getNumberFormatList()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;",
            ">;"
        }
    .end annotation

    .line 756
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->numberFormat_:Ljava/util/List;

    return-object p0
.end method

.method public getPager()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 503
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->pager_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getPersonalNumber()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 475
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->personalNumber_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getPreferredExtnPrefix()Ljava/lang/String;
    .locals 0

    .line 694
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->preferredExtnPrefix_:Ljava/lang/String;

    return-object p0
.end method

.method public getPreferredInternationalPrefix()Ljava/lang/String;
    .locals 0

    .line 662
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->preferredInternationalPrefix_:Ljava/lang/String;

    return-object p0
.end method

.method public getPremiumRate()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 447
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->premiumRate_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getSameMobileAndFixedLinePattern()Z
    .locals 0

    .line 737
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->sameMobileAndFixedLinePattern_:Z

    return p0
.end method

.method public getSharedCost()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 461
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->sharedCost_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getShortCode()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 559
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->shortCode_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getSmsServices()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 601
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->smsServices_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getStandardRate()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 573
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->standardRate_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getTollFree()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 433
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->tollFree_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getUan()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 517
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->uan_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getVoicemail()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 545
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->voicemail_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public getVoip()Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;
    .locals 0

    .line 489
    iget-object p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->voip_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public hasCarrierSpecific()Z
    .locals 0

    .line 586
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasCarrierSpecific:Z

    return p0
.end method

.method public hasCountryCode()Z
    .locals 0

    .line 639
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasCountryCode:Z

    return p0
.end method

.method public hasEmergency()Z
    .locals 0

    .line 530
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasEmergency:Z

    return p0
.end method

.method public hasFixedLine()Z
    .locals 0

    .line 404
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasFixedLine:Z

    return p0
.end method

.method public hasGeneralDesc()Z
    .locals 0

    .line 384
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasGeneralDesc:Z

    return p0
.end method

.method public hasId()Z
    .locals 0

    .line 628
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasId:Z

    return p0
.end method

.method public hasInternationalPrefix()Z
    .locals 0

    .line 650
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasInternationalPrefix:Z

    return p0
.end method

.method public hasLeadingDigits()Z
    .locals 0

    .line 823
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasLeadingDigits:Z

    return p0
.end method

.method public hasLeadingZeroPossible()Z
    .locals 0

    .line 834
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasLeadingZeroPossible:Z

    return p0
.end method

.method public hasMainCountryForCode()Z
    .locals 0

    .line 804
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasMainCountryForCode:Z

    return p0
.end method

.method public hasMobile()Z
    .locals 0

    .line 418
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasMobile:Z

    return p0
.end method

.method public hasMobileNumberPortableRegion()Z
    .locals 0

    .line 850
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasMobileNumberPortableRegion:Z

    return p0
.end method

.method public hasNationalPrefix()Z
    .locals 0

    .line 677
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefix:Z

    return p0
.end method

.method public hasNationalPrefixForParsing()Z
    .locals 0

    .line 709
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefixForParsing:Z

    return p0
.end method

.method public hasNationalPrefixTransformRule()Z
    .locals 0

    .line 720
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefixTransformRule:Z

    return p0
.end method

.method public hasNoInternationalDialling()Z
    .locals 0

    .line 614
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNoInternationalDialling:Z

    return p0
.end method

.method public hasPager()Z
    .locals 0

    .line 502
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPager:Z

    return p0
.end method

.method public hasPersonalNumber()Z
    .locals 0

    .line 474
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPersonalNumber:Z

    return p0
.end method

.method public hasPreferredExtnPrefix()Z
    .locals 0

    .line 693
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPreferredExtnPrefix:Z

    return p0
.end method

.method public hasPreferredInternationalPrefix()Z
    .locals 0

    .line 661
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPreferredInternationalPrefix:Z

    return p0
.end method

.method public hasPremiumRate()Z
    .locals 0

    .line 446
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPremiumRate:Z

    return p0
.end method

.method public hasSameMobileAndFixedLinePattern()Z
    .locals 0

    .line 736
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasSameMobileAndFixedLinePattern:Z

    return p0
.end method

.method public hasSharedCost()Z
    .locals 0

    .line 460
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasSharedCost:Z

    return p0
.end method

.method public hasShortCode()Z
    .locals 0

    .line 558
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasShortCode:Z

    return p0
.end method

.method public hasSmsServices()Z
    .locals 0

    .line 600
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasSmsServices:Z

    return p0
.end method

.method public hasStandardRate()Z
    .locals 0

    .line 572
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasStandardRate:Z

    return p0
.end method

.method public hasTollFree()Z
    .locals 0

    .line 432
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasTollFree:Z

    return p0
.end method

.method public hasUan()Z
    .locals 0

    .line 516
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasUan:Z

    return p0
.end method

.method public hasVoicemail()Z
    .locals 0

    .line 544
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasVoicemail:Z

    return p0
.end method

.method public hasVoip()Z
    .locals 0

    .line 488
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasVoip:Z

    return p0
.end method

.method public intlNumberFormatSize()I
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 783
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getIntlNumberFormatCount()I

    move-result p0

    return p0
.end method

.method public intlNumberFormats()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;",
            ">;"
        }
    .end annotation

    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 777
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getIntlNumberFormatList()Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method public isLeadingZeroPossible()Z
    .locals 0

    .line 835
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->leadingZeroPossible_:Z

    return p0
.end method

.method public isMainCountryForCode()Z
    .locals 0

    .line 805
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mainCountryForCode_:Z

    return p0
.end method

.method public isMobileNumberPortableRegion()Z
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 852
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getMobileNumberPortableRegion()Z

    move-result p0

    return p0
.end method

.method public numberFormatSize()I
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 759
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getNumberFormatCount()I

    move-result p0

    return p0
.end method

.method public numberFormats()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;",
            ">;"
        }
    .end annotation

    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 753
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->getNumberFormatList()Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method public readExternal(Ljava/io/ObjectInput;)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 991
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 993
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 994
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 995
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setGeneralDesc(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 997
    :cond_0
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 999
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1000
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1001
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setFixedLine(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1003
    :cond_1
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 1005
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1006
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1007
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setMobile(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1009
    :cond_2
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 1011
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1012
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1013
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setTollFree(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1015
    :cond_3
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_4

    .line 1017
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1018
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1019
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setPremiumRate(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1021
    :cond_4
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_5

    .line 1023
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1024
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1025
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setSharedCost(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1027
    :cond_5
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_6

    .line 1029
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1030
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1031
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setPersonalNumber(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1033
    :cond_6
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_7

    .line 1035
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1036
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1037
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setVoip(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1039
    :cond_7
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_8

    .line 1041
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1042
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1043
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setPager(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1045
    :cond_8
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_9

    .line 1047
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1048
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1049
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setUan(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1051
    :cond_9
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_a

    .line 1053
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1054
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1055
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setEmergency(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1057
    :cond_a
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_b

    .line 1059
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1060
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1061
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setVoicemail(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1063
    :cond_b
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_c

    .line 1065
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1066
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1067
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setShortCode(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1069
    :cond_c
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_d

    .line 1071
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1072
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1073
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setStandardRate(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1075
    :cond_d
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_e

    .line 1077
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1078
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1079
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setCarrierSpecific(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1081
    :cond_e
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_f

    .line 1083
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1084
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1085
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setSmsServices(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1087
    :cond_f
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_10

    .line 1089
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-direct {v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;-><init>()V

    .line 1090
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->readExternal(Ljava/io/ObjectInput;)V

    .line 1091
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setNoInternationalDialling(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1094
    :cond_10
    invoke-interface {p1}, Ljava/io/ObjectInput;->readUTF()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setId(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1095
    invoke-interface {p1}, Ljava/io/ObjectInput;->readInt()I

    move-result v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setCountryCode(I)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1096
    invoke-interface {p1}, Ljava/io/ObjectInput;->readUTF()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setInternationalPrefix(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1098
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_11

    .line 1100
    invoke-interface {p1}, Ljava/io/ObjectInput;->readUTF()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setPreferredInternationalPrefix(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1103
    :cond_11
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_12

    .line 1105
    invoke-interface {p1}, Ljava/io/ObjectInput;->readUTF()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setNationalPrefix(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1108
    :cond_12
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_13

    .line 1110
    invoke-interface {p1}, Ljava/io/ObjectInput;->readUTF()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setPreferredExtnPrefix(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1113
    :cond_13
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_14

    .line 1115
    invoke-interface {p1}, Ljava/io/ObjectInput;->readUTF()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setNationalPrefixForParsing(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1118
    :cond_14
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_15

    .line 1120
    invoke-interface {p1}, Ljava/io/ObjectInput;->readUTF()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setNationalPrefixTransformRule(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1123
    :cond_15
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setSameMobileAndFixedLinePattern(Z)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1125
    invoke-interface {p1}, Ljava/io/ObjectInput;->readInt()I

    move-result v0

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ge v2, v0, :cond_16

    .line 1127
    new-instance v3, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;

    invoke-direct {v3}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;-><init>()V

    .line 1128
    invoke-virtual {v3, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;->readExternal(Ljava/io/ObjectInput;)V

    .line 1129
    iget-object v4, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->numberFormat_:Ljava/util/List;

    invoke-interface {v4, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1132
    :cond_16
    invoke-interface {p1}, Ljava/io/ObjectInput;->readInt()I

    move-result v0

    :goto_1
    if-ge v1, v0, :cond_17

    .line 1134
    new-instance v2, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;

    invoke-direct {v2}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;-><init>()V

    .line 1135
    invoke-virtual {v2, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;->readExternal(Ljava/io/ObjectInput;)V

    .line 1136
    iget-object v3, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->intlNumberFormat_:Ljava/util/List;

    invoke-interface {v3, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 1139
    :cond_17
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setMainCountryForCode(Z)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1141
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    if-eqz v0, :cond_18

    .line 1143
    invoke-interface {p1}, Ljava/io/ObjectInput;->readUTF()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setLeadingDigits(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1146
    :cond_18
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setLeadingZeroPossible(Z)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    .line 1148
    invoke-interface {p1}, Ljava/io/ObjectInput;->readBoolean()Z

    move-result p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->setMobileNumberPortableRegion(Z)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;

    return-void
.end method

.method public setCarrierSpecific(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 590
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 592
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasCarrierSpecific:Z

    .line 593
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->carrierSpecific_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setCountryCode(I)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x1

    .line 642
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasCountryCode:Z

    .line 643
    iput p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->countryCode_:I

    return-object p0
.end method

.method public setEmergency(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 534
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 536
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasEmergency:Z

    .line 537
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->emergency_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setFixedLine(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 408
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 410
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasFixedLine:Z

    .line 411
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->fixedLine_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setGeneralDesc(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 394
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 396
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasGeneralDesc:Z

    .line 397
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->generalDesc_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setId(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x1

    .line 631
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasId:Z

    .line 632
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->id_:Ljava/lang/String;

    return-object p0
.end method

.method public setInternationalPrefix(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x1

    .line 653
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasInternationalPrefix:Z

    .line 654
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->internationalPrefix_:Ljava/lang/String;

    return-object p0
.end method

.method public setLeadingDigits(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x1

    .line 826
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasLeadingDigits:Z

    .line 827
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->leadingDigits_:Ljava/lang/String;

    return-object p0
.end method

.method public setLeadingZeroPossible(Z)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x1

    .line 837
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasLeadingZeroPossible:Z

    .line 838
    iput-boolean p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->leadingZeroPossible_:Z

    return-object p0
.end method

.method public setMainCountryForCode(Z)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x1

    .line 810
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasMainCountryForCode:Z

    .line 811
    iput-boolean p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mainCountryForCode_:Z

    return-object p0
.end method

.method public setMobile(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 422
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 424
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasMobile:Z

    .line 425
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mobile_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setMobileNumberPortableRegion(Z)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x1

    .line 855
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasMobileNumberPortableRegion:Z

    .line 856
    iput-boolean p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mobileNumberPortableRegion_:Z

    return-object p0
.end method

.method public setNationalPrefix(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x1

    .line 680
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefix:Z

    .line 681
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefix_:Ljava/lang/String;

    return-object p0
.end method

.method public setNationalPrefixForParsing(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x1

    .line 712
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefixForParsing:Z

    .line 713
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefixForParsing_:Ljava/lang/String;

    return-object p0
.end method

.method public setNationalPrefixTransformRule(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x1

    .line 723
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefixTransformRule:Z

    .line 724
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefixTransformRule_:Ljava/lang/String;

    return-object p0
.end method

.method public setNoInternationalDialling(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 618
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 620
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNoInternationalDialling:Z

    .line 621
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->noInternationalDialling_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setPager(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 506
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 508
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPager:Z

    .line 509
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->pager_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setPersonalNumber(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 478
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 480
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPersonalNumber:Z

    .line 481
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->personalNumber_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setPreferredExtnPrefix(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x1

    .line 696
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPreferredExtnPrefix:Z

    .line 697
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->preferredExtnPrefix_:Ljava/lang/String;

    return-object p0
.end method

.method public setPreferredInternationalPrefix(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x1

    .line 664
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPreferredInternationalPrefix:Z

    .line 665
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->preferredInternationalPrefix_:Ljava/lang/String;

    return-object p0
.end method

.method public setPremiumRate(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 450
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 452
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPremiumRate:Z

    .line 453
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->premiumRate_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setSameMobileAndFixedLinePattern(Z)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    const/4 v0, 0x1

    .line 739
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasSameMobileAndFixedLinePattern:Z

    .line 740
    iput-boolean p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->sameMobileAndFixedLinePattern_:Z

    return-object p0
.end method

.method public setSharedCost(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 464
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 466
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasSharedCost:Z

    .line 467
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->sharedCost_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setShortCode(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 562
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 564
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasShortCode:Z

    .line 565
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->shortCode_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setSmsServices(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 604
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 606
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasSmsServices:Z

    .line 607
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->smsServices_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setStandardRate(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 576
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 578
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasStandardRate:Z

    .line 579
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->standardRate_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setTollFree(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 436
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 438
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasTollFree:Z

    .line 439
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->tollFree_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setUan(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 520
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 522
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasUan:Z

    .line 523
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->uan_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setVoicemail(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 548
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 550
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasVoicemail:Z

    .line 551
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->voicemail_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public setVoip(Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;)Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;
    .locals 1

    .line 492
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/4 v0, 0x1

    .line 494
    iput-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasVoip:Z

    .line 495
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->voip_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    return-object p0
.end method

.method public writeExternal(Ljava/io/ObjectOutput;)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 866
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasGeneralDesc:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 867
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasGeneralDesc:Z

    if-eqz v0, :cond_0

    .line 868
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->generalDesc_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 870
    :cond_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasFixedLine:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 871
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasFixedLine:Z

    if-eqz v0, :cond_1

    .line 872
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->fixedLine_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 874
    :cond_1
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasMobile:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 875
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasMobile:Z

    if-eqz v0, :cond_2

    .line 876
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mobile_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 878
    :cond_2
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasTollFree:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 879
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasTollFree:Z

    if-eqz v0, :cond_3

    .line 880
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->tollFree_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 882
    :cond_3
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPremiumRate:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 883
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPremiumRate:Z

    if-eqz v0, :cond_4

    .line 884
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->premiumRate_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 886
    :cond_4
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasSharedCost:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 887
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasSharedCost:Z

    if-eqz v0, :cond_5

    .line 888
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->sharedCost_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 890
    :cond_5
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPersonalNumber:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 891
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPersonalNumber:Z

    if-eqz v0, :cond_6

    .line 892
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->personalNumber_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 894
    :cond_6
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasVoip:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 895
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasVoip:Z

    if-eqz v0, :cond_7

    .line 896
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->voip_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 898
    :cond_7
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPager:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 899
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPager:Z

    if-eqz v0, :cond_8

    .line 900
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->pager_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 902
    :cond_8
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasUan:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 903
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasUan:Z

    if-eqz v0, :cond_9

    .line 904
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->uan_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 906
    :cond_9
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasEmergency:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 907
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasEmergency:Z

    if-eqz v0, :cond_a

    .line 908
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->emergency_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 910
    :cond_a
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasVoicemail:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 911
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasVoicemail:Z

    if-eqz v0, :cond_b

    .line 912
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->voicemail_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 914
    :cond_b
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasShortCode:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 915
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasShortCode:Z

    if-eqz v0, :cond_c

    .line 916
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->shortCode_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 918
    :cond_c
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasStandardRate:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 919
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasStandardRate:Z

    if-eqz v0, :cond_d

    .line 920
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->standardRate_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 922
    :cond_d
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasCarrierSpecific:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 923
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasCarrierSpecific:Z

    if-eqz v0, :cond_e

    .line 924
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->carrierSpecific_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 926
    :cond_e
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasSmsServices:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 927
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasSmsServices:Z

    if-eqz v0, :cond_f

    .line 928
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->smsServices_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 930
    :cond_f
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNoInternationalDialling:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 931
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNoInternationalDialling:Z

    if-eqz v0, :cond_10

    .line 932
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->noInternationalDialling_:Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneNumberDesc;->writeExternal(Ljava/io/ObjectOutput;)V

    .line 935
    :cond_10
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->id_:Ljava/lang/String;

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeUTF(Ljava/lang/String;)V

    .line 936
    iget v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->countryCode_:I

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeInt(I)V

    .line 937
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->internationalPrefix_:Ljava/lang/String;

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeUTF(Ljava/lang/String;)V

    .line 939
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPreferredInternationalPrefix:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 940
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPreferredInternationalPrefix:Z

    if-eqz v0, :cond_11

    .line 941
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->preferredInternationalPrefix_:Ljava/lang/String;

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeUTF(Ljava/lang/String;)V

    .line 944
    :cond_11
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefix:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 945
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefix:Z

    if-eqz v0, :cond_12

    .line 946
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefix_:Ljava/lang/String;

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeUTF(Ljava/lang/String;)V

    .line 949
    :cond_12
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPreferredExtnPrefix:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 950
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasPreferredExtnPrefix:Z

    if-eqz v0, :cond_13

    .line 951
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->preferredExtnPrefix_:Ljava/lang/String;

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeUTF(Ljava/lang/String;)V

    .line 954
    :cond_13
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefixForParsing:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 955
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefixForParsing:Z

    if-eqz v0, :cond_14

    .line 956
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefixForParsing_:Ljava/lang/String;

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeUTF(Ljava/lang/String;)V

    .line 959
    :cond_14
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefixTransformRule:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 960
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasNationalPrefixTransformRule:Z

    if-eqz v0, :cond_15

    .line 961
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->nationalPrefixTransformRule_:Ljava/lang/String;

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeUTF(Ljava/lang/String;)V

    .line 964
    :cond_15
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->sameMobileAndFixedLinePattern_:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 966
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->numberFormatSize()I

    move-result v0

    .line 967
    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeInt(I)V

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ge v2, v0, :cond_16

    .line 969
    iget-object v3, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->numberFormat_:Ljava/util/List;

    invoke-interface {v3, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;

    invoke-virtual {v3, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;->writeExternal(Ljava/io/ObjectOutput;)V

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 972
    :cond_16
    invoke-virtual {p0}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->intlNumberFormatSize()I

    move-result v0

    .line 973
    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeInt(I)V

    :goto_1
    if-ge v1, v0, :cond_17

    .line 975
    iget-object v2, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->intlNumberFormat_:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;

    invoke-virtual {v2, p1}, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$NumberFormat;->writeExternal(Ljava/io/ObjectOutput;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 978
    :cond_17
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mainCountryForCode_:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 980
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasLeadingDigits:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 981
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->hasLeadingDigits:Z

    if-eqz v0, :cond_18

    .line 982
    iget-object v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->leadingDigits_:Ljava/lang/String;

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeUTF(Ljava/lang/String;)V

    .line 985
    :cond_18
    iget-boolean v0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->leadingZeroPossible_:Z

    invoke-interface {p1, v0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    .line 987
    iget-boolean p0, p0, Lcom/android/internal/telephony/phonenumbers/Phonemetadata$PhoneMetadata;->mobileNumberPortableRegion_:Z

    invoke-interface {p1, p0}, Ljava/io/ObjectOutput;->writeBoolean(Z)V

    return-void
.end method
