.class public Lcom/mediatek/util/MtkPatterns;
.super Ljava/lang/Object;
.source "MtkPatterns.java"


# static fields
.field public static final KEY_URLDATA_END:Ljava/lang/String; = "end"

.field public static final KEY_URLDATA_START:Ljava/lang/String; = "start"

.field public static final KEY_URLDATA_VALUE:Ljava/lang/String; = "value"

.field private static final MTK_WEB_PROTOCOL_NAMES:[Ljava/lang/String;

.field private static final TAG:Ljava/lang/String; = "MtkPatterns"

.field private static final mBadEndRemovingRegex:Ljava/lang/String;

.field private static final mBadFrontRemovingRegex:Ljava/lang/String;

.field private static final mValidCharRegex:Ljava/lang/String; = "a-zA-Z0-9\\-_"


# direct methods
.method static constructor <clinit>()V
    .locals 6

    const-string v0, "http://"

    const-string v1, "https://"

    const-string v2, "rtsp://"

    const-string v3, "ftp://"

    .line 53
    filled-new-array {v0, v1, v2, v3}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/mediatek/util/MtkPatterns;->MTK_WEB_PROTOCOL_NAMES:[Ljava/lang/String;

    const/4 v0, 0x2

    new-array v1, v0, [Ljava/lang/Object;

    const/4 v2, 0x0

    const-string v3, "a-zA-Z0-9\\-_"

    aput-object v3, v1, v2

    const/4 v4, 0x1

    aput-object v3, v1, v4

    const-string v5, "(^[^.]*[^%s.://#&=]+)(?:[a-zA-Z]+://|[%s]+.)"

    .line 71
    invoke-static {v5, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lcom/mediatek/util/MtkPatterns;->mBadFrontRemovingRegex:Ljava/lang/String;

    const/4 v1, 0x3

    new-array v1, v1, [Ljava/lang/Object;

    aput-object v3, v1, v2

    aput-object v3, v1, v4

    aput-object v3, v1, v0

    const-string v0, "([\\.\\:][%s)]+[/%s]*)([\\.\\:]?[^%s\\.\\:\\s/]+[^\\.=&%%/]*$)"

    .line 78
    invoke-static {v0, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/mediatek/util/MtkPatterns;->mBadEndRemovingRegex:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 51
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static final getMtkWebUrlPattern(Ljava/util/regex/Pattern;)Ljava/util/regex/Pattern;
    .locals 0

    .line 148
    sget-object p0, Lcom/mediatek/util/ChinaPatterns;->CHINA_AUTOLINK_WEB_URL:Ljava/util/regex/Pattern;

    return-object p0
.end method

.method public static getWebProtocolNames([Ljava/lang/String;)[Ljava/lang/String;
    .locals 0

    .line 63
    sget-object p0, Lcom/mediatek/util/MtkPatterns;->MTK_WEB_PROTOCOL_NAMES:[Ljava/lang/String;

    return-object p0
.end method

.method public static getWebUrl(Ljava/lang/String;II)Landroid/os/Bundle;
    .locals 3

    .line 117
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getWebUrl,  start="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " end="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "@M_MtkPatterns"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz p0, :cond_1

    .line 120
    sget-object v0, Lcom/mediatek/util/MtkPatterns;->mBadFrontRemovingRegex:Ljava/lang/String;

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v1

    .line 121
    invoke-virtual {v1, p0}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v1

    .line 122
    invoke-virtual {v1}, Ljava/util/regex/Matcher;->find()Z

    move-result v1

    const-string v2, ""

    if-eqz v1, :cond_0

    const/4 p1, 0x1

    .line 123
    invoke-static {v0, p0, p1, v2}, Lcom/mediatek/util/MtkPatterns;->replaceGroup(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 124
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p1

    sub-int p1, p2, p1

    .line 127
    :cond_0
    sget-object v0, Lcom/mediatek/util/MtkPatterns;->mBadEndRemovingRegex:Ljava/lang/String;

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v1

    .line 128
    invoke-virtual {v1, p0}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v1

    .line 129
    invoke-virtual {v1}, Ljava/util/regex/Matcher;->find()Z

    move-result v1

    if-eqz v1, :cond_1

    const/4 p2, 0x2

    .line 130
    invoke-static {v0, p0, p2, v2}, Lcom/mediatek/util/MtkPatterns;->replaceGroup(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 131
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p2

    add-int/2addr p2, p1

    .line 135
    :cond_1
    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    const-string/jumbo v1, "value"

    .line 136
    invoke-virtual {v0, v1, p0}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    const-string/jumbo p0, "start"

    .line 137
    invoke-virtual {v0, p0, p1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    const-string p0, "end"

    .line 138
    invoke-virtual {v0, p0, p2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    return-object v0
.end method

.method private static final replaceGroup(Ljava/lang/String;Ljava/lang/String;IILjava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 100
    invoke-static {p0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object p0

    invoke-virtual {p0, p1}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object p0

    const/4 v0, 0x0

    :goto_0
    if-ge v0, p3, :cond_1

    .line 102
    invoke-virtual {p0}, Ljava/util/regex/Matcher;->find()Z

    move-result v1

    if-nez v1, :cond_0

    return-object p1

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 106
    :cond_1
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p2}, Ljava/util/regex/Matcher;->start(I)I

    move-result p1

    invoke-virtual {p0, p2}, Ljava/util/regex/Matcher;->end(I)I

    move-result p0

    invoke-virtual {p3, p1, p0, p4}, Ljava/lang/StringBuilder;->replace(IILjava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 107
    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static final replaceGroup(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljava/lang/String;
    .locals 1

    const/4 v0, 0x1

    .line 94
    invoke-static {p0, p1, p2, v0, p3}, Lcom/mediatek/util/MtkPatterns;->replaceGroup(Ljava/lang/String;Ljava/lang/String;IILjava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
