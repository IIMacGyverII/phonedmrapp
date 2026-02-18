.class public Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;
.super Ljava/lang/Object;
.source "CarrierResolver.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/CarrierResolver;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "CarrierMatchingRule"
.end annotation


# static fields
.field private static final SCORE_APN:I = 0x1

.field private static final SCORE_GID1:I = 0x20

.field private static final SCORE_GID2:I = 0x10

.field private static final SCORE_ICCID_PREFIX:I = 0x40

.field private static final SCORE_IMSI_PREFIX:I = 0x80

.field private static final SCORE_INVALID:I = -0x1

.field private static final SCORE_MCCMNC:I = 0x100

.field private static final SCORE_PLMN:I = 0x8

.field private static final SCORE_PRIVILEGE_ACCESS_RULE:I = 0x4

.field private static final SCORE_SPN:I = 0x2


# instance fields
.field public final apn:Ljava/lang/String;

.field public final gid1:Ljava/lang/String;

.field public final gid2:Ljava/lang/String;

.field public final iccidPrefix:Ljava/lang/String;

.field public final imsiPrefixPattern:Ljava/lang/String;

.field private mCid:I

.field private mName:Ljava/lang/String;

.field private mParentCid:I

.field private mScore:I

.field public final mccMnc:Ljava/lang/String;

.field public final plmn:Ljava/lang/String;

.field public final privilegeAccessRule:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field public final spn:Ljava/lang/String;


# direct methods
.method static bridge synthetic -$$Nest$fgetmCid(Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mCid:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmName(Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mName:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmParentCid(Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mParentCid:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmScore(Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fputmCid(Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mCid:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmName(Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mName:Ljava/lang/String;

    return-void
.end method

.method private constructor <init>(Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;)V
    .locals 1

    .line 638
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 618
    iput v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    .line 639
    iget-object v0, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mccMnc:Ljava/lang/String;

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mccMnc:Ljava/lang/String;

    .line 640
    iget-object v0, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->imsiPrefixPattern:Ljava/lang/String;

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->imsiPrefixPattern:Ljava/lang/String;

    .line 641
    iget-object v0, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->iccidPrefix:Ljava/lang/String;

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->iccidPrefix:Ljava/lang/String;

    .line 642
    iget-object v0, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid1:Ljava/lang/String;

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid1:Ljava/lang/String;

    .line 643
    iget-object v0, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid2:Ljava/lang/String;

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid2:Ljava/lang/String;

    .line 644
    iget-object v0, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->plmn:Ljava/lang/String;

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->plmn:Ljava/lang/String;

    .line 645
    iget-object v0, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->spn:Ljava/lang/String;

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->spn:Ljava/lang/String;

    .line 646
    iget-object v0, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->apn:Ljava/lang/String;

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->apn:Ljava/lang/String;

    .line 647
    iget-object v0, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->privilegeAccessRule:Ljava/util/List;

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->privilegeAccessRule:Ljava/util/List;

    .line 648
    iget v0, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mCid:I

    iput v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mCid:I

    .line 649
    iget-object v0, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mName:Ljava/lang/String;

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mName:Ljava/lang/String;

    .line 650
    iget p1, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mParentCid:I

    iput p1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mParentCid:I

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;-><init>(Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;)V

    return-void
.end method

.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;ILjava/lang/String;I)V
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;I",
            "Ljava/lang/String;",
            "I)V"
        }
    .end annotation

    .line 623
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 618
    iput v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    .line 624
    iput-object p1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mccMnc:Ljava/lang/String;

    .line 625
    iput-object p2, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->imsiPrefixPattern:Ljava/lang/String;

    .line 626
    iput-object p3, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->iccidPrefix:Ljava/lang/String;

    .line 627
    iput-object p4, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid1:Ljava/lang/String;

    .line 628
    iput-object p5, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid2:Ljava/lang/String;

    .line 629
    iput-object p6, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->plmn:Ljava/lang/String;

    .line 630
    iput-object p7, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->spn:Ljava/lang/String;

    .line 631
    iput-object p8, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->apn:Ljava/lang/String;

    .line 632
    iput-object p9, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->privilegeAccessRule:Ljava/util/List;

    .line 633
    iput p10, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mCid:I

    .line 634
    iput-object p11, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mName:Ljava/lang/String;

    .line 635
    iput p12, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mParentCid:I

    return-void
.end method

.method private carrierPrivilegeRulesMatch(Ljava/util/List;Ljava/util/List;)Z
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;)Z"
        }
    .end annotation

    const/4 p0, 0x0

    if-eqz p1, :cond_3

    .line 759
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 762
    :cond_0
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :cond_1
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_3

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 763
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_2
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 764
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_2

    .line 765
    invoke-virtual {v0, v2}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_2

    const/4 p0, 0x1

    :cond_3
    :goto_0
    return p0
.end method

.method private gidMatch(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    if-eqz p1, :cond_0

    .line 754
    invoke-virtual {p1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p2}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private iccidPrefixMatch(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    if-eqz p1, :cond_1

    if-nez p2, :cond_0

    goto :goto_0

    .line 747
    :cond_0
    invoke-virtual {p1, p2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    return p0

    :cond_1
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method private imsiPrefixMatch(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 4

    .line 729
    invoke-static {p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p0

    const/4 v0, 0x1

    if-eqz p0, :cond_0

    return v0

    .line 730
    :cond_0
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p0

    const/4 v1, 0x0

    if-eqz p0, :cond_1

    return v1

    .line 731
    :cond_1
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p0

    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v2

    if-ge p0, v2, :cond_2

    return v1

    :cond_2
    move p0, v1

    .line 734
    :goto_0
    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v2

    if-ge p0, v2, :cond_4

    .line 735
    invoke-virtual {p2, p0}, Ljava/lang/String;->charAt(I)C

    move-result v2

    const/16 v3, 0x78

    if-eq v2, v3, :cond_3

    invoke-virtual {p2, p0}, Ljava/lang/String;->charAt(I)C

    move-result v2

    const/16 v3, 0x58

    if-eq v2, v3, :cond_3

    .line 736
    invoke-virtual {p2, p0}, Ljava/lang/String;->charAt(I)C

    move-result v2

    invoke-virtual {p1, p0}, Ljava/lang/String;->charAt(I)C

    move-result v3

    if-eq v2, v3, :cond_3

    return v1

    :cond_3
    add-int/lit8 p0, p0, 0x1

    goto :goto_0

    :cond_4
    return v0
.end method


# virtual methods
.method public match(Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;)V
    .locals 4

    const/4 v0, 0x0

    .line 659
    iput v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    .line 660
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mccMnc:Ljava/lang/String;

    const/4 v2, -0x1

    if-eqz v1, :cond_1

    .line 661
    iget-object v3, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mccMnc:Ljava/lang/String;

    invoke-static {v3, v1, v0}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$smequals(Ljava/lang/String;Ljava/lang/String;Z)Z

    move-result v0

    if-nez v0, :cond_0

    .line 662
    iput v2, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    return-void

    .line 665
    :cond_0
    iget v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    add-int/lit16 v0, v0, 0x100

    iput v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    .line 667
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->imsiPrefixPattern:Ljava/lang/String;

    if-eqz v0, :cond_3

    .line 668
    iget-object v1, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->imsiPrefixPattern:Ljava/lang/String;

    invoke-direct {p0, v1, v0}, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->imsiPrefixMatch(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_2

    .line 669
    iput v2, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    return-void

    .line 672
    :cond_2
    iget v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    add-int/lit16 v0, v0, 0x80

    iput v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    .line 674
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->iccidPrefix:Ljava/lang/String;

    if-eqz v0, :cond_5

    .line 675
    iget-object v1, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->iccidPrefix:Ljava/lang/String;

    invoke-direct {p0, v1, v0}, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->iccidPrefixMatch(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_4

    .line 676
    iput v2, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    return-void

    .line 679
    :cond_4
    iget v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    add-int/lit8 v0, v0, 0x40

    iput v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    .line 681
    :cond_5
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid1:Ljava/lang/String;

    if-eqz v0, :cond_7

    .line 682
    iget-object v1, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid1:Ljava/lang/String;

    invoke-direct {p0, v1, v0}, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gidMatch(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_6

    .line 683
    iput v2, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    return-void

    .line 686
    :cond_6
    iget v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    add-int/lit8 v0, v0, 0x20

    iput v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    .line 688
    :cond_7
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid2:Ljava/lang/String;

    if-eqz v0, :cond_9

    .line 689
    iget-object v1, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid2:Ljava/lang/String;

    invoke-direct {p0, v1, v0}, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gidMatch(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_8

    .line 690
    iput v2, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    return-void

    .line 693
    :cond_8
    iget v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    add-int/lit8 v0, v0, 0x10

    iput v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    .line 695
    :cond_9
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->plmn:Ljava/lang/String;

    const/4 v1, 0x1

    if-eqz v0, :cond_b

    .line 696
    iget-object v3, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->plmn:Ljava/lang/String;

    invoke-static {v3, v0, v1}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$smequals(Ljava/lang/String;Ljava/lang/String;Z)Z

    move-result v0

    if-nez v0, :cond_a

    .line 697
    iput v2, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    return-void

    .line 700
    :cond_a
    iget v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    add-int/lit8 v0, v0, 0x8

    iput v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    .line 702
    :cond_b
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->spn:Ljava/lang/String;

    if-eqz v0, :cond_d

    .line 703
    iget-object v3, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->spn:Ljava/lang/String;

    invoke-static {v3, v0, v1}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$smequals(Ljava/lang/String;Ljava/lang/String;Z)Z

    move-result v0

    if-nez v0, :cond_c

    .line 704
    iput v2, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    return-void

    .line 707
    :cond_c
    iget v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    add-int/lit8 v0, v0, 0x2

    iput v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    .line 710
    :cond_d
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->privilegeAccessRule:Ljava/util/List;

    if-eqz v0, :cond_f

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_f

    .line 711
    iget-object v0, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->privilegeAccessRule:Ljava/util/List;

    iget-object v3, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->privilegeAccessRule:Ljava/util/List;

    invoke-direct {p0, v0, v3}, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->carrierPrivilegeRulesMatch(Ljava/util/List;Ljava/util/List;)Z

    move-result v0

    if-nez v0, :cond_e

    .line 713
    iput v2, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    return-void

    .line 716
    :cond_e
    iget v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    add-int/lit8 v0, v0, 0x4

    iput v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    .line 719
    :cond_f
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->apn:Ljava/lang/String;

    if-eqz v0, :cond_11

    .line 720
    iget-object p1, p1, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->apn:Ljava/lang/String;

    invoke-static {p1, v0, v1}, Lcom/android/internal/telephony/CarrierResolver;->-$$Nest$smequals(Ljava/lang/String;Ljava/lang/String;Z)Z

    move-result p1

    if-nez p1, :cond_10

    .line 721
    iput v2, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    return-void

    .line 724
    :cond_10
    iget p1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    add-int/2addr p1, v1

    iput p1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    :cond_11
    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 774
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[CarrierMatchingRule] - mccmnc: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mccMnc:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " gid1: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid1:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " gid2: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid2:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " plmn: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->plmn:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " imsi_prefix: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->imsiPrefixPattern:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " iccid_prefix"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->iccidPrefix:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " spn: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->spn:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " privilege_access_rule: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->privilegeAccessRule:Ljava/util/List;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " apn: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->apn:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " name: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " cid: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mCid:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " score: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mScore:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
