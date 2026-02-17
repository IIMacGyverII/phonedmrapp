.class public final enum Lcom/android/internal/telephony/cat/Duration$TimeUnit;
.super Ljava/lang/Enum;
.source "Duration.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/cat/Duration;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "TimeUnit"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/cat/Duration$TimeUnit;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/cat/Duration$TimeUnit;

.field public static final enum MINUTE:Lcom/android/internal/telephony/cat/Duration$TimeUnit;

.field public static final enum SECOND:Lcom/android/internal/telephony/cat/Duration$TimeUnit;

.field public static final enum TENTH_SECOND:Lcom/android/internal/telephony/cat/Duration$TimeUnit;


# instance fields
.field private mValue:I


# direct methods
.method static constructor <clinit>()V
    .locals 7

    .line 37
    new-instance v0, Lcom/android/internal/telephony/cat/Duration$TimeUnit;

    const-string v1, "MINUTE"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2, v2}, Lcom/android/internal/telephony/cat/Duration$TimeUnit;-><init>(Ljava/lang/String;II)V

    sput-object v0, Lcom/android/internal/telephony/cat/Duration$TimeUnit;->MINUTE:Lcom/android/internal/telephony/cat/Duration$TimeUnit;

    .line 38
    new-instance v1, Lcom/android/internal/telephony/cat/Duration$TimeUnit;

    const-string v3, "SECOND"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4, v4}, Lcom/android/internal/telephony/cat/Duration$TimeUnit;-><init>(Ljava/lang/String;II)V

    sput-object v1, Lcom/android/internal/telephony/cat/Duration$TimeUnit;->SECOND:Lcom/android/internal/telephony/cat/Duration$TimeUnit;

    .line 39
    new-instance v3, Lcom/android/internal/telephony/cat/Duration$TimeUnit;

    const-string v5, "TENTH_SECOND"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6, v6}, Lcom/android/internal/telephony/cat/Duration$TimeUnit;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/Duration$TimeUnit;->TENTH_SECOND:Lcom/android/internal/telephony/cat/Duration$TimeUnit;

    const/4 v5, 0x3

    new-array v5, v5, [Lcom/android/internal/telephony/cat/Duration$TimeUnit;

    aput-object v0, v5, v2

    aput-object v1, v5, v4

    aput-object v3, v5, v6

    .line 36
    sput-object v5, Lcom/android/internal/telephony/cat/Duration$TimeUnit;->$VALUES:[Lcom/android/internal/telephony/cat/Duration$TimeUnit;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;II)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)V"
        }
    .end annotation

    .line 43
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    .line 44
    iput p3, p0, Lcom/android/internal/telephony/cat/Duration$TimeUnit;->mValue:I

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/cat/Duration$TimeUnit;
    .locals 1

    .line 36
    const-class v0, Lcom/android/internal/telephony/cat/Duration$TimeUnit;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/cat/Duration$TimeUnit;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/cat/Duration$TimeUnit;
    .locals 1

    .line 36
    sget-object v0, Lcom/android/internal/telephony/cat/Duration$TimeUnit;->$VALUES:[Lcom/android/internal/telephony/cat/Duration$TimeUnit;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/cat/Duration$TimeUnit;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/cat/Duration$TimeUnit;

    return-object v0
.end method


# virtual methods
.method public value()I
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 49
    iget p0, p0, Lcom/android/internal/telephony/cat/Duration$TimeUnit;->mValue:I

    return p0
.end method
