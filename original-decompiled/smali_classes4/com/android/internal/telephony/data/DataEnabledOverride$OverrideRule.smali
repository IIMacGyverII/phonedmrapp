.class Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;
.super Ljava/lang/Object;
.source "DataEnabledOverride.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataEnabledOverride;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "OverrideRule"
.end annotation


# instance fields
.field private final mApnType:I

.field private final mRequiredConditions:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;


# direct methods
.method private constructor <init>(II)V
    .locals 0

    .line 115
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 116
    iput p1, p0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mApnType:I

    .line 117
    new-instance p1, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;

    invoke-direct {p1, p2}, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;-><init>(I)V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mRequiredConditions:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;

    return-void
.end method

.method synthetic constructor <init>(IILcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule-IA;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;-><init>(II)V

    return-void
.end method

.method constructor <init>(Ljava/lang/String;)V
    .locals 3

    .line 90
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 91
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    const-string v1, "\\s*=\\s*"

    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    .line 92
    array-length v1, v0

    const/4 v2, 0x2

    if-ne v1, v2, :cond_2

    const/4 v1, 0x0

    .line 97
    aget-object v2, v0, v1

    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_1

    .line 101
    aget-object v1, v0, v1

    invoke-static {v1}, Landroid/telephony/data/ApnSetting;->getApnTypesBitmaskFromString(Ljava/lang/String;)I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mApnType:I

    if-eqz v1, :cond_0

    .line 106
    new-instance p1, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;

    const/4 v1, 0x1

    aget-object v0, v0, v1

    invoke-direct {p1, v0}, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;-><init>(Ljava/lang/String;)V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mRequiredConditions:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;

    return-void

    .line 103
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Invalid APN type. Rule="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 98
    :cond_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "APN type can\'t be empty"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 93
    :cond_2
    new-instance p0, Ljava/lang/IllegalArgumentException;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Invalid data enabled override rule format: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method


# virtual methods
.method public equals(Ljava/lang/Object;)Z
    .locals 4

    const/4 v0, 0x1

    if-ne p0, p1, :cond_0

    return v0

    :cond_0
    const/4 v1, 0x0

    if-eqz p1, :cond_3

    .line 140
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    if-eq v2, v3, :cond_1

    goto :goto_1

    .line 141
    :cond_1
    check-cast p1, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;

    .line 142
    iget v2, p0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mApnType:I

    iget v3, p1, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mApnType:I

    if-ne v2, v3, :cond_2

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mRequiredConditions:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;

    iget-object p1, p1, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mRequiredConditions:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;

    .line 143
    invoke-static {p0, p1}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_2

    goto :goto_0

    :cond_2
    move v0, v1

    :goto_0
    return v0

    :cond_3
    :goto_1
    return v1
.end method

.method public hashCode()I
    .locals 3

    const/4 v0, 0x2

    new-array v0, v0, [Ljava/lang/Object;

    .line 148
    iget v1, p0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mApnType:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mRequiredConditions:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;

    const/4 v1, 0x1

    aput-object p0, v0, v1

    invoke-static {v0}, Ljava/util/Objects;->hash([Ljava/lang/Object;)I

    move-result p0

    return p0
.end method

.method isSatisfiedByConditions(II)Z
    .locals 1

    .line 128
    iget v0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mApnType:I

    if-eq v0, p1, :cond_0

    const/16 p1, 0xff

    if-ne v0, p1, :cond_1

    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mRequiredConditions:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;

    .line 129
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;->allMet(I)Z

    move-result p0

    if-eqz p0, :cond_1

    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 134
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget v1, p0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mApnType:I

    invoke-static {v1}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideRule;->mRequiredConditions:Lcom/android/internal/telephony/data/DataEnabledOverride$OverrideConditions;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
