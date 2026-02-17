.class public final enum Lcom/android/internal/telephony/cat/TextColor;
.super Ljava/lang/Enum;
.source "TextColor.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/cat/TextColor;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum BLACK:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum BRIGHT_BLUE:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum BRIGHT_CYAN:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum BRIGHT_GREEN:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum BRIGHT_MAGENTA:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum BRIGHT_RED:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum BRIGHT_YELLOW:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum DARK_BLUE:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum DARK_CYAN:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum DARK_GRAY:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum DARK_GREEN:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum DARK_MAGENTA:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum DARK_RED:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum DARK_YELLOW:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum GRAY:Lcom/android/internal/telephony/cat/TextColor;

.field public static final enum WHITE:Lcom/android/internal/telephony/cat/TextColor;


# instance fields
.field private mValue:I


# direct methods
.method static constructor <clinit>()V
    .locals 19

    .line 26
    new-instance v0, Lcom/android/internal/telephony/cat/TextColor;

    const-string v1, "BLACK"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2, v2}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v0, Lcom/android/internal/telephony/cat/TextColor;->BLACK:Lcom/android/internal/telephony/cat/TextColor;

    .line 27
    new-instance v1, Lcom/android/internal/telephony/cat/TextColor;

    const-string v3, "DARK_GRAY"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4, v4}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v1, Lcom/android/internal/telephony/cat/TextColor;->DARK_GRAY:Lcom/android/internal/telephony/cat/TextColor;

    .line 28
    new-instance v3, Lcom/android/internal/telephony/cat/TextColor;

    const-string v5, "DARK_RED"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6, v6}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/TextColor;->DARK_RED:Lcom/android/internal/telephony/cat/TextColor;

    .line 29
    new-instance v5, Lcom/android/internal/telephony/cat/TextColor;

    const-string v7, "DARK_YELLOW"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8, v8}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v5, Lcom/android/internal/telephony/cat/TextColor;->DARK_YELLOW:Lcom/android/internal/telephony/cat/TextColor;

    .line 30
    new-instance v7, Lcom/android/internal/telephony/cat/TextColor;

    const-string v9, "DARK_GREEN"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10, v10}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v7, Lcom/android/internal/telephony/cat/TextColor;->DARK_GREEN:Lcom/android/internal/telephony/cat/TextColor;

    .line 31
    new-instance v9, Lcom/android/internal/telephony/cat/TextColor;

    const-string v11, "DARK_CYAN"

    const/4 v12, 0x5

    invoke-direct {v9, v11, v12, v12}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v9, Lcom/android/internal/telephony/cat/TextColor;->DARK_CYAN:Lcom/android/internal/telephony/cat/TextColor;

    .line 32
    new-instance v11, Lcom/android/internal/telephony/cat/TextColor;

    const-string v13, "DARK_BLUE"

    const/4 v14, 0x6

    invoke-direct {v11, v13, v14, v14}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v11, Lcom/android/internal/telephony/cat/TextColor;->DARK_BLUE:Lcom/android/internal/telephony/cat/TextColor;

    .line 33
    new-instance v13, Lcom/android/internal/telephony/cat/TextColor;

    const-string v15, "DARK_MAGENTA"

    const/4 v14, 0x7

    invoke-direct {v13, v15, v14, v14}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v13, Lcom/android/internal/telephony/cat/TextColor;->DARK_MAGENTA:Lcom/android/internal/telephony/cat/TextColor;

    .line 34
    new-instance v15, Lcom/android/internal/telephony/cat/TextColor;

    const-string v14, "GRAY"

    const/16 v12, 0x8

    invoke-direct {v15, v14, v12, v12}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v15, Lcom/android/internal/telephony/cat/TextColor;->GRAY:Lcom/android/internal/telephony/cat/TextColor;

    .line 35
    new-instance v14, Lcom/android/internal/telephony/cat/TextColor;

    const-string v12, "WHITE"

    const/16 v10, 0x9

    invoke-direct {v14, v12, v10, v10}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v14, Lcom/android/internal/telephony/cat/TextColor;->WHITE:Lcom/android/internal/telephony/cat/TextColor;

    .line 36
    new-instance v12, Lcom/android/internal/telephony/cat/TextColor;

    const-string v10, "BRIGHT_RED"

    const/16 v8, 0xa

    invoke-direct {v12, v10, v8, v8}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v12, Lcom/android/internal/telephony/cat/TextColor;->BRIGHT_RED:Lcom/android/internal/telephony/cat/TextColor;

    .line 37
    new-instance v10, Lcom/android/internal/telephony/cat/TextColor;

    const-string v8, "BRIGHT_YELLOW"

    const/16 v6, 0xb

    invoke-direct {v10, v8, v6, v6}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v10, Lcom/android/internal/telephony/cat/TextColor;->BRIGHT_YELLOW:Lcom/android/internal/telephony/cat/TextColor;

    .line 38
    new-instance v8, Lcom/android/internal/telephony/cat/TextColor;

    const-string v6, "BRIGHT_GREEN"

    const/16 v4, 0xc

    invoke-direct {v8, v6, v4, v4}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v8, Lcom/android/internal/telephony/cat/TextColor;->BRIGHT_GREEN:Lcom/android/internal/telephony/cat/TextColor;

    .line 39
    new-instance v6, Lcom/android/internal/telephony/cat/TextColor;

    const-string v4, "BRIGHT_CYAN"

    const/16 v2, 0xd

    invoke-direct {v6, v4, v2, v2}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v6, Lcom/android/internal/telephony/cat/TextColor;->BRIGHT_CYAN:Lcom/android/internal/telephony/cat/TextColor;

    .line 40
    new-instance v4, Lcom/android/internal/telephony/cat/TextColor;

    const-string v2, "BRIGHT_BLUE"

    move-object/from16 v17, v6

    const/16 v6, 0xe

    invoke-direct {v4, v2, v6, v6}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v4, Lcom/android/internal/telephony/cat/TextColor;->BRIGHT_BLUE:Lcom/android/internal/telephony/cat/TextColor;

    .line 41
    new-instance v2, Lcom/android/internal/telephony/cat/TextColor;

    const-string v6, "BRIGHT_MAGENTA"

    move-object/from16 v18, v4

    const/16 v4, 0xf

    invoke-direct {v2, v6, v4, v4}, Lcom/android/internal/telephony/cat/TextColor;-><init>(Ljava/lang/String;II)V

    sput-object v2, Lcom/android/internal/telephony/cat/TextColor;->BRIGHT_MAGENTA:Lcom/android/internal/telephony/cat/TextColor;

    const/16 v6, 0x10

    new-array v6, v6, [Lcom/android/internal/telephony/cat/TextColor;

    const/16 v16, 0x0

    aput-object v0, v6, v16

    const/4 v0, 0x1

    aput-object v1, v6, v0

    const/4 v0, 0x2

    aput-object v3, v6, v0

    const/4 v0, 0x3

    aput-object v5, v6, v0

    const/4 v0, 0x4

    aput-object v7, v6, v0

    const/4 v0, 0x5

    aput-object v9, v6, v0

    const/4 v0, 0x6

    aput-object v11, v6, v0

    const/4 v0, 0x7

    aput-object v13, v6, v0

    const/16 v0, 0x8

    aput-object v15, v6, v0

    const/16 v0, 0x9

    aput-object v14, v6, v0

    const/16 v0, 0xa

    aput-object v12, v6, v0

    const/16 v0, 0xb

    aput-object v10, v6, v0

    const/16 v0, 0xc

    aput-object v8, v6, v0

    const/16 v0, 0xd

    aput-object v17, v6, v0

    const/16 v0, 0xe

    aput-object v18, v6, v0

    aput-object v2, v6, v4

    .line 25
    sput-object v6, Lcom/android/internal/telephony/cat/TextColor;->$VALUES:[Lcom/android/internal/telephony/cat/TextColor;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;II)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)V"
        }
    .end annotation

    .line 45
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    .line 46
    iput p3, p0, Lcom/android/internal/telephony/cat/TextColor;->mValue:I

    return-void
.end method

.method public static fromInt(I)Lcom/android/internal/telephony/cat/TextColor;
    .locals 5

    .line 56
    invoke-static {}, Lcom/android/internal/telephony/cat/TextColor;->values()[Lcom/android/internal/telephony/cat/TextColor;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    aget-object v3, v0, v2

    .line 57
    iget v4, v3, Lcom/android/internal/telephony/cat/TextColor;->mValue:I

    if-ne v4, p0, :cond_0

    return-object v3

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/cat/TextColor;
    .locals 1

    .line 25
    const-class v0, Lcom/android/internal/telephony/cat/TextColor;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/cat/TextColor;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/cat/TextColor;
    .locals 1

    .line 25
    sget-object v0, Lcom/android/internal/telephony/cat/TextColor;->$VALUES:[Lcom/android/internal/telephony/cat/TextColor;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/cat/TextColor;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/cat/TextColor;

    return-object v0
.end method
