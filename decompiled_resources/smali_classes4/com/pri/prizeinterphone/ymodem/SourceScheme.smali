.class public final enum Lcom/pri/prizeinterphone/ymodem/SourceScheme;
.super Ljava/lang/Enum;
.source "SourceScheme.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/pri/prizeinterphone/ymodem/SourceScheme;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/pri/prizeinterphone/ymodem/SourceScheme;

.field public static final enum ASSETS:Lcom/pri/prizeinterphone/ymodem/SourceScheme;

.field public static final enum FILE:Lcom/pri/prizeinterphone/ymodem/SourceScheme;

.field public static final enum UNKNOWN:Lcom/pri/prizeinterphone/ymodem/SourceScheme;


# instance fields
.field private final scheme:Ljava/lang/String;

.field private final uriPrefix:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 8

    .line 7
    new-instance v0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    const-string v1, "FILE"

    const/4 v2, 0x0

    const-string v3, "file"

    invoke-direct {v0, v1, v2, v3}, Lcom/pri/prizeinterphone/ymodem/SourceScheme;-><init>(Ljava/lang/String;ILjava/lang/String;)V

    sput-object v0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->FILE:Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    new-instance v1, Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    const-string v3, "ASSETS"

    const/4 v4, 0x1

    const-string v5, "assets"

    invoke-direct {v1, v3, v4, v5}, Lcom/pri/prizeinterphone/ymodem/SourceScheme;-><init>(Ljava/lang/String;ILjava/lang/String;)V

    sput-object v1, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->ASSETS:Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    new-instance v3, Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    const-string v5, "UNKNOWN"

    const/4 v6, 0x2

    const-string v7, ""

    invoke-direct {v3, v5, v6, v7}, Lcom/pri/prizeinterphone/ymodem/SourceScheme;-><init>(Ljava/lang/String;ILjava/lang/String;)V

    sput-object v3, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->UNKNOWN:Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    const/4 v5, 0x3

    new-array v5, v5, [Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    aput-object v0, v5, v2

    aput-object v1, v5, v4

    aput-object v3, v5, v6

    .line 5
    sput-object v5, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->$VALUES:[Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;ILjava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .line 12
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    .line 13
    iput-object p3, p0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->scheme:Ljava/lang/String;

    .line 14
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, "://"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->uriPrefix:Ljava/lang/String;

    return-void
.end method

.method private belongsTo(Ljava/lang/String;)Z
    .locals 1

    .line 35
    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-virtual {p1, v0}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p1

    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->uriPrefix:Ljava/lang/String;

    invoke-virtual {p1, p0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static ofUri(Ljava/lang/String;)Lcom/pri/prizeinterphone/ymodem/SourceScheme;
    .locals 5

    if-eqz p0, :cond_1

    .line 25
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->values()[Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    aget-object v3, v0, v2

    .line 26
    invoke-direct {v3, p0}, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->belongsTo(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_0

    return-object v3

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 31
    :cond_1
    sget-object p0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->UNKNOWN:Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    return-object p0
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/pri/prizeinterphone/ymodem/SourceScheme;
    .locals 1

    .line 5
    const-class v0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    return-object p0
.end method

.method public static values()[Lcom/pri/prizeinterphone/ymodem/SourceScheme;
    .locals 1

    .line 5
    sget-object v0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->$VALUES:[Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    invoke-virtual {v0}, [Lcom/pri/prizeinterphone/ymodem/SourceScheme;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    return-object v0
.end method


# virtual methods
.method public crop(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    .line 42
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->belongsTo(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 45
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->uriPrefix:Ljava/lang/String;

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    invoke-virtual {p1, p0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 43
    :cond_0
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const/4 v1, 0x2

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    aput-object p1, v1, v2

    const/4 p1, 0x1

    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->scheme:Ljava/lang/String;

    aput-object p0, v1, p1

    const-string p0, "URI [%1$s] doesn\'t have expected scheme [%2$s]"

    invoke-static {p0, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public getUriPrefix()Ljava/lang/String;
    .locals 0

    .line 49
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->uriPrefix:Ljava/lang/String;

    return-object p0
.end method
