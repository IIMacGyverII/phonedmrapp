.class final Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;
.super Ljava/lang/Object;
.source "CarrierDisplayNameResolver.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "CarrierDisplayNameConditionRule"
.end annotation


# instance fields
.field private mDisplayConditionBitmask:I


# direct methods
.method constructor <init>(I)V
    .locals 0

    .line 536
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 537
    iput p1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;->mDisplayConditionBitmask:I

    return-void
.end method


# virtual methods
.method shouldShowPlmn(Ljava/lang/String;)Z
    .locals 2

    .line 551
    iget p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;->mDisplayConditionBitmask:I

    const/4 v0, 0x1

    and-int/2addr p0, v0

    const/4 v1, 0x0

    if-ne p0, v0, :cond_0

    move p0, v0

    goto :goto_0

    :cond_0
    move p0, v1

    :goto_0
    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    .line 555
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p1

    if-nez p1, :cond_1

    invoke-virtual {p0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p0

    if-eqz p0, :cond_1

    goto :goto_1

    :cond_1
    move v0, v1

    :goto_1
    return v0
.end method

.method shouldShowSpn(Ljava/lang/String;)Z
    .locals 3

    .line 542
    iget p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;->mDisplayConditionBitmask:I

    const/4 v0, 0x2

    and-int/2addr p0, v0

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-ne p0, v0, :cond_0

    move p0, v1

    goto :goto_0

    :cond_0
    move p0, v2

    :goto_0
    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    .line 546
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p1

    if-nez p1, :cond_1

    invoke-virtual {p0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p0

    if-eqz p0, :cond_1

    goto :goto_1

    :cond_1
    move v1, v2

    :goto_1
    return v1
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    const/4 v0, 0x2

    new-array v1, v0, [Ljava/lang/Object;

    .line 560
    iget v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;->mDisplayConditionBitmask:I

    and-int/2addr v0, v2

    .line 561
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    const/4 v2, 0x0

    aput-object v0, v1, v2

    iget p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;->mDisplayConditionBitmask:I

    const/4 v0, 0x1

    and-int/2addr p0, v0

    .line 563
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    aput-object p0, v1, v0

    const-string/jumbo p0, "{ SPN_bit = %d, PLMN_bit = %d }"

    .line 560
    invoke-static {p0, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
