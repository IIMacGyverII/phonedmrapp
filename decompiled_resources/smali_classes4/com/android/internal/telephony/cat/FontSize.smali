.class public final enum Lcom/android/internal/telephony/cat/FontSize;
.super Ljava/lang/Enum;
.source "FontSize.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/cat/FontSize;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/cat/FontSize;

.field public static final enum LARGE:Lcom/android/internal/telephony/cat/FontSize;

.field public static final enum NORMAL:Lcom/android/internal/telephony/cat/FontSize;

.field public static final enum SMALL:Lcom/android/internal/telephony/cat/FontSize;


# instance fields
.field private mValue:I


# direct methods
.method static constructor <clinit>()V
    .locals 7

    .line 26
    new-instance v0, Lcom/android/internal/telephony/cat/FontSize;

    const-string v1, "NORMAL"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2, v2}, Lcom/android/internal/telephony/cat/FontSize;-><init>(Ljava/lang/String;II)V

    sput-object v0, Lcom/android/internal/telephony/cat/FontSize;->NORMAL:Lcom/android/internal/telephony/cat/FontSize;

    .line 27
    new-instance v1, Lcom/android/internal/telephony/cat/FontSize;

    const-string v3, "LARGE"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4, v4}, Lcom/android/internal/telephony/cat/FontSize;-><init>(Ljava/lang/String;II)V

    sput-object v1, Lcom/android/internal/telephony/cat/FontSize;->LARGE:Lcom/android/internal/telephony/cat/FontSize;

    .line 28
    new-instance v3, Lcom/android/internal/telephony/cat/FontSize;

    const-string v5, "SMALL"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6, v6}, Lcom/android/internal/telephony/cat/FontSize;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/FontSize;->SMALL:Lcom/android/internal/telephony/cat/FontSize;

    const/4 v5, 0x3

    new-array v5, v5, [Lcom/android/internal/telephony/cat/FontSize;

    aput-object v0, v5, v2

    aput-object v1, v5, v4

    aput-object v3, v5, v6

    .line 25
    sput-object v5, Lcom/android/internal/telephony/cat/FontSize;->$VALUES:[Lcom/android/internal/telephony/cat/FontSize;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;II)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)V"
        }
    .end annotation

    .line 32
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    .line 33
    iput p3, p0, Lcom/android/internal/telephony/cat/FontSize;->mValue:I

    return-void
.end method

.method public static fromInt(I)Lcom/android/internal/telephony/cat/FontSize;
    .locals 5

    .line 43
    invoke-static {}, Lcom/android/internal/telephony/cat/FontSize;->values()[Lcom/android/internal/telephony/cat/FontSize;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    aget-object v3, v0, v2

    .line 44
    iget v4, v3, Lcom/android/internal/telephony/cat/FontSize;->mValue:I

    if-ne v4, p0, :cond_0

    return-object v3

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/cat/FontSize;
    .locals 1

    .line 25
    const-class v0, Lcom/android/internal/telephony/cat/FontSize;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/cat/FontSize;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/cat/FontSize;
    .locals 1

    .line 25
    sget-object v0, Lcom/android/internal/telephony/cat/FontSize;->$VALUES:[Lcom/android/internal/telephony/cat/FontSize;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/cat/FontSize;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/cat/FontSize;

    return-object v0
.end method
