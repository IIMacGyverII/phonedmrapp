.class public Lcom/android/internal/telephony/data/DataEnabledOverride;
.super Ljava/lang/Object;
.source "DataEnabledOverride.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;,
        Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;
    }
.end annotation


# static fields
.field private static final OVERRIDE_RULE_ALLOW_DATA_DURING_VOICE_CALL:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

.field private static final OVERRIDE_RULE_ALWAYS_ALLOW_MMS:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;


# instance fields
.field private final mRules:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 4

    .line 57
    new-instance v0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    const/16 v1, 0xff

    const/16 v2, 0xf

    const/4 v3, 0x0

    invoke-direct {v0, v1, v2, v3}, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;-><init>(IILcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule-IA;)V

    sput-object v0, Lcom/android/internal/telephony/data/DataEnabledOverride;->OVERRIDE_RULE_ALLOW_DATA_DURING_VOICE_CALL:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    .line 67
    new-instance v0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    const/4 v1, 0x2

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2, v3}, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;-><init>(IILcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule-IA;)V

    sput-object v0, Lcom/android/internal/telephony/data/DataEnabledOverride;->OVERRIDE_RULE_ALWAYS_ALLOW_MMS:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    return-void
.end method

.method public constructor <init>(Ljava/lang/String;)V
    .locals 1

    .line 309
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 52
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    .line 310
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataEnabledOverride;->updateRules(Ljava/lang/String;)V

    return-void
.end method

.method private canSatisfyAnyRule(II)Z
    .locals 1

    .line 374
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    invoke-interface {p0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    .line 375
    invoke-virtual {v0, p1, p2}, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->isSatisfiedByConditions(II)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method private getCurrentConditions(Lcom/android/internal/telephony/Phone;)I
    .locals 2

    const/4 p0, 0x0

    if-eqz p1, :cond_3

    .line 387
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getState()Lcom/android/internal/telephony/PhoneConstants$State;

    move-result-object v0

    sget-object v1, Lcom/android/internal/telephony/PhoneConstants$State;->IDLE:Lcom/android/internal/telephony/PhoneConstants$State;

    if-eq v0, v1, :cond_0

    const/4 p0, 0x2

    .line 391
    :cond_0
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/SubscriptionController;->getDefaultDataSubId()I

    move-result v0

    .line 393
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    if-eq v1, v0, :cond_1

    or-int/lit8 p0, p0, 0x1

    :cond_1
    const/4 v1, -0x1

    if-eq v0, v1, :cond_2

    .line 398
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/SubscriptionController;->getPhoneId(I)I

    move-result v0

    .line 400
    :try_start_0
    invoke-static {v0}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 401
    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->isUserDataEnabled()Z

    move-result v0
    :try_end_0
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz v0, :cond_2

    or-int/lit8 p0, p0, 0x4

    goto :goto_0

    :catch_0
    move-exception v0

    .line 406
    invoke-virtual {v0}, Ljava/lang/IllegalStateException;->getMessage()Ljava/lang/String;

    move-result-object v0

    const-string v1, "DataEnabledOverride"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 410
    :cond_2
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Landroid/telephony/TelephonyManager;->from(Landroid/content/Context;)Landroid/telephony/TelephonyManager;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/TelephonyManager;->isMultiSimEnabled()Z

    move-result p1

    if-eqz p1, :cond_3

    or-int/lit8 p0, p0, 0x8

    :cond_3
    return p0
.end method


# virtual methods
.method public equals(Ljava/lang/Object;)Z
    .locals 2

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    if-eqz p1, :cond_2

    .line 446
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    if-eq v0, v1, :cond_1

    goto :goto_0

    .line 447
    :cond_1
    check-cast p1, Lcom/android/internal/telephony/data/DataEnabledOverride;

    .line 448
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    iget-object p1, p1, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0

    :cond_2
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method public getRules()Ljava/lang/String;
    .locals 2

    .line 436
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 437
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    invoke-interface {p0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    .line 438
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    const-string p0, ","

    .line 440
    invoke-static {p0, v0}, Landroid/text/TextUtils;->join(Ljava/lang/CharSequence;Ljava/lang/Iterable;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public hashCode()I
    .locals 2

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    .line 453
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    const/4 v1, 0x0

    aput-object p0, v0, v1

    invoke-static {v0}, Ljava/util/Objects;->hash([Ljava/lang/Object;)I

    move-result p0

    return p0
.end method

.method public isDataAllowedInVoiceCall()Z
    .locals 1

    .line 365
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    sget-object v0, Lcom/android/internal/telephony/data/DataEnabledOverride;->OVERRIDE_RULE_ALLOW_DATA_DURING_VOICE_CALL:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    invoke-interface {p0, v0}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method public isMmsAlwaysAllowed()Z
    .locals 1

    .line 369
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    sget-object v0, Lcom/android/internal/telephony/data/DataEnabledOverride;->OVERRIDE_RULE_ALWAYS_ALLOW_MMS:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    invoke-interface {p0, v0}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method public setAlwaysAllowMms(Z)V
    .locals 0

    if-eqz p1, :cond_0

    .line 336
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    sget-object p1, Lcom/android/internal/telephony/data/DataEnabledOverride;->OVERRIDE_RULE_ALWAYS_ALLOW_MMS:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    invoke-interface {p0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 338
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    sget-object p1, Lcom/android/internal/telephony/data/DataEnabledOverride;->OVERRIDE_RULE_ALWAYS_ALLOW_MMS:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    invoke-interface {p0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    :goto_0
    return-void
.end method

.method public setDataAllowedInVoiceCall(Z)V
    .locals 0

    if-eqz p1, :cond_0

    .line 353
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    sget-object p1, Lcom/android/internal/telephony/data/DataEnabledOverride;->OVERRIDE_RULE_ALLOW_DATA_DURING_VOICE_CALL:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    invoke-interface {p0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 355
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    sget-object p1, Lcom/android/internal/telephony/data/DataEnabledOverride;->OVERRIDE_RULE_ALLOW_DATA_DURING_VOICE_CALL:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    invoke-interface {p0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    :goto_0
    return-void
.end method

.method public shouldOverrideDataEnabledSettings(Lcom/android/internal/telephony/Phone;I)Z
    .locals 0

    .line 426
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataEnabledOverride;->getCurrentConditions(Lcom/android/internal/telephony/Phone;)I

    move-result p1

    invoke-direct {p0, p2, p1}, Lcom/android/internal/telephony/data/DataEnabledOverride;->canSatisfyAnyRule(II)Z

    move-result p0

    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 458
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "DataEnabledOverride: [rules=\""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataEnabledOverride;->getRules()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\"]"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public updateRules(Ljava/lang/String;)V
    .locals 5
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 320
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->clear()V

    .line 321
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    const-string v0, "\\s*,\\s*"

    invoke-virtual {p1, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p1

    .line 322
    array-length v0, p1

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p1, v1

    .line 323
    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_0

    .line 324
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataEnabledOverride;->mRules:Ljava/util/Set;

    new-instance v4, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    invoke-direct {v4, v2}, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;-><init>(Ljava/lang/String;)V

    invoke-interface {v3, v4}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    return-void
.end method
