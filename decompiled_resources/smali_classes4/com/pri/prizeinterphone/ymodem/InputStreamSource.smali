.class Lcom/pri/prizeinterphone/ymodem/InputStreamSource;
.super Ljava/lang/Object;
.source "InputStreamSource.java"


# static fields
.field private static final BUFFER_SIZE:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 15
    sget-object v0, Lcom/pri/prizeinterphone/ymodem/YModem;->mSize:Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    mul-int/lit8 v0, v0, 0x20

    sput v0, Lcom/pri/prizeinterphone/ymodem/InputStreamSource;->BUFFER_SIZE:I

    return-void
.end method

.method constructor <init>()V
    .locals 0

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private getStreamFromAssets(Landroid/content/Context;Ljava/lang/String;)Ljava/io/InputStream;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 38
    sget-object p0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->ASSETS:Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    invoke-virtual {p0, p2}, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->crop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 39
    invoke-virtual {p1}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object p1

    invoke-virtual {p1, p0}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object p0

    return-object p0
.end method

.method private getStreamFromFile(Ljava/lang/String;)Ljava/io/InputStream;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 33
    sget-object p0, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->FILE:Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->crop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 34
    new-instance p1, Ljava/io/BufferedInputStream;

    new-instance v0, Ljava/io/FileInputStream;

    invoke-direct {v0, p0}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V

    sget p0, Lcom/pri/prizeinterphone/ymodem/InputStreamSource;->BUFFER_SIZE:I

    invoke-direct {p1, v0, p0}, Ljava/io/BufferedInputStream;-><init>(Ljava/io/InputStream;I)V

    return-object p1
.end method

.method private getStreamFromOtherSource(Ljava/lang/String;)Ljava/io/InputStream;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 46
    new-instance p0, Ljava/io/BufferedInputStream;

    new-instance v0, Ljava/io/FileInputStream;

    invoke-direct {v0, p1}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V

    sget p1, Lcom/pri/prizeinterphone/ymodem/InputStreamSource;->BUFFER_SIZE:I

    invoke-direct {p0, v0, p1}, Ljava/io/BufferedInputStream;-><init>(Ljava/io/InputStream;I)V

    return-object p0
.end method


# virtual methods
.method getStream(Landroid/content/Context;Ljava/lang/String;)Ljava/io/InputStream;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 19
    sget-object v0, Lcom/pri/prizeinterphone/ymodem/InputStreamSource$1;->$SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme:[I

    invoke-static {p2}, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->ofUri(Ljava/lang/String;)Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Enum;->ordinal()I

    move-result v1

    aget v0, v0, v1

    const/4 v1, 0x1

    if-eq v0, v1, :cond_1

    const/4 v1, 0x2

    if-eq v0, v1, :cond_0

    .line 28
    invoke-direct {p0, p2}, Lcom/pri/prizeinterphone/ymodem/InputStreamSource;->getStreamFromOtherSource(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object p0

    return-object p0

    .line 24
    :cond_0
    invoke-direct {p0, p1, p2}, Lcom/pri/prizeinterphone/ymodem/InputStreamSource;->getStreamFromAssets(Landroid/content/Context;Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object p0

    return-object p0

    .line 21
    :cond_1
    invoke-direct {p0, p2}, Lcom/pri/prizeinterphone/ymodem/InputStreamSource;->getStreamFromFile(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object p0

    return-object p0
.end method
