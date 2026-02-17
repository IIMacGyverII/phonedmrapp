.class public abstract enum Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;
.super Ljava/lang/Enum;
.source "PhoneNumberUtil.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4409
    name = "Leniency"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

.field public static final enum EXACT_GROUPING:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

.field public static final enum POSSIBLE:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

.field public static final enum STRICT_GROUPING:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

.field public static final enum VALID:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;


# direct methods
.method static constructor <clinit>()V
    .locals 9

    .line 533
    new-instance v0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency$1;

    const-string v1, "POSSIBLE"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency$1;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;->POSSIBLE:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

    .line 549
    new-instance v1, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency$2;

    const-string v3, "VALID"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency$2;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;->VALID:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

    .line 575
    new-instance v3, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency$3;

    const-string v5, "STRICT_GROUPING"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency$3;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;->STRICT_GROUPING:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

    .line 612
    new-instance v5, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency$4;

    const-string v7, "EXACT_GROUPING"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency$4;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;->EXACT_GROUPING:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

    const/4 v7, 0x4

    new-array v7, v7, [Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

    aput-object v0, v7, v2

    aput-object v1, v7, v4

    aput-object v3, v7, v6

    aput-object v5, v7, v8

    .line 528
    sput-object v7, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;->$VALUES:[Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 528
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method synthetic constructor <init>(Ljava/lang/String;ILcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$1;)V
    .locals 0

    .line 528
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;
    .locals 1

    .line 528
    const-class v0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;
    .locals 1

    .line 528
    sget-object v0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;->$VALUES:[Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

    return-object v0
.end method


# virtual methods
.method abstract verify(Lcom/android/internal/telephony/phonenumbers/Phonenumber$PhoneNumber;Ljava/lang/CharSequence;Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatcher;)Z
.end method
