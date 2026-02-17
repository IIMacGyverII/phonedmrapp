.class public Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;
.super Ljava/lang/Object;
.source "OpenMsyncAppList.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/appresolutiontuner/OpenMsyncAppList$Applic;
    }
.end annotation


# static fields
.field private static final APP_LIST_PATH:Ljava/lang/String; = "system/etc/open_msync_app_list.xml"

.field private static final NODE_PACKAGE_NAME:Ljava/lang/String; = "packagename"

.field private static final TAG:Ljava/lang/String; = "OpenMsyncAppList"

.field private static final TAG_APP:Ljava/lang/String; = "app"

.field private static sInstance:Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;


# instance fields
.field private isRead:Z

.field private mMsyncAppCache:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/mediatek/appresolutiontuner/OpenMsyncAppList$Applic;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 51
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 49
    iput-boolean v0, p0, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;->isRead:Z

    return-void
.end method

.method public static getInstance()Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;
    .locals 1

    .line 56
    sget-object v0, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;->sInstance:Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;

    if-nez v0, :cond_0

    .line 57
    new-instance v0, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;

    invoke-direct {v0}, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;-><init>()V

    sput-object v0, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;->sInstance:Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;

    .line 59
    :cond_0
    sget-object v0, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;->sInstance:Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;

    return-object v0
.end method

.method private parseAppListFile(Ljava/io/InputStream;)Ljava/util/ArrayList;
    .locals 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/io/InputStream;",
            ")",
            "Ljava/util/ArrayList<",
            "Lcom/mediatek/appresolutiontuner/OpenMsyncAppList$Applic;",
            ">;"
        }
    .end annotation

    const-string v0, "OpenMsyncAppList"

    .line 125
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 128
    :try_start_0
    invoke-static {}, Ljavax/xml/parsers/DocumentBuilderFactory;->newInstance()Ljavax/xml/parsers/DocumentBuilderFactory;

    move-result-object v2

    .line 129
    invoke-virtual {v2}, Ljavax/xml/parsers/DocumentBuilderFactory;->newDocumentBuilder()Ljavax/xml/parsers/DocumentBuilder;

    move-result-object v2

    .line 130
    invoke-virtual {v2, p1}, Ljavax/xml/parsers/DocumentBuilder;->parse(Ljava/io/InputStream;)Lorg/w3c/dom/Document;

    move-result-object p1
    :try_end_0
    .catch Ljavax/xml/parsers/ParserConfigurationException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Lorg/xml/sax/SAXException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    const-string v2, "app"

    .line 142
    invoke-interface {p1, v2}, Lorg/w3c/dom/Document;->getElementsByTagName(Ljava/lang/String;)Lorg/w3c/dom/NodeList;

    move-result-object p1

    const/4 v2, 0x0

    move v3, v2

    .line 144
    :goto_0
    invoke-interface {p1}, Lorg/w3c/dom/NodeList;->getLength()I

    move-result v4

    if-ge v3, v4, :cond_2

    .line 145
    invoke-interface {p1, v3}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v4

    .line 146
    invoke-interface {v4}, Lorg/w3c/dom/Node;->getChildNodes()Lorg/w3c/dom/NodeList;

    move-result-object v4

    .line 147
    new-instance v5, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList$Applic;

    invoke-direct {v5, p0}, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList$Applic;-><init>(Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;)V

    move v6, v2

    .line 148
    :goto_1
    invoke-interface {v4}, Lorg/w3c/dom/NodeList;->getLength()I

    move-result v7

    if-ge v6, v7, :cond_1

    .line 149
    invoke-interface {v4, v6}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v7

    .line 150
    invoke-interface {v7}, Lorg/w3c/dom/Node;->getNodeName()Ljava/lang/String;

    move-result-object v8

    const-string v9, "packagename"

    invoke-virtual {v8, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_0

    .line 151
    invoke-interface {v7}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v7

    .line 152
    invoke-virtual {v5, v7}, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList$Applic;->setPackageName(Ljava/lang/String;)V

    :cond_0
    add-int/lit8 v6, v6, 0x1

    goto :goto_1

    .line 155
    :cond_1
    invoke-virtual {v1, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 156
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "dom2xml: "

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v0, v4}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_2
    return-object v1

    :catch_0
    move-exception p0

    const-string p1, "IOException"

    .line 138
    invoke-static {v0, p1, p0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v1

    :catch_1
    move-exception p0

    const-string p1, "dom2xml SAXException"

    .line 135
    invoke-static {v0, p1, p0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v1

    :catch_2
    move-exception p0

    const-string p1, "dom2xml ParserConfigurationException"

    .line 132
    invoke-static {v0, p1, p0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v1
.end method


# virtual methods
.method public isRead()Z
    .locals 0

    .line 63
    iget-boolean p0, p0, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;->isRead:Z

    return p0
.end method

.method public isScaledBySurfaceView(Ljava/lang/String;)Z
    .locals 1

    .line 99
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;->mMsyncAppCache:Ljava/util/ArrayList;

    if-eqz p0, :cond_1

    .line 100
    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList$Applic;

    .line 101
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList$Applic;->getPackageName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method public loadOpenMsyncAppList()V
    .locals 5

    const-string v0, "close failed.."

    const-string v1, "OpenMsyncAppList"

    const-string v2, "loadTunerAppList + "

    .line 70
    invoke-static {v1, v2}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v2, 0x0

    .line 74
    :try_start_0
    new-instance v3, Ljava/io/File;

    const-string/jumbo v4, "system/etc/open_msync_app_list.xml"

    invoke-direct {v3, v4}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 75
    invoke-virtual {v3}, Ljava/io/File;->exists()Z

    move-result v4

    if-nez v4, :cond_0

    const-string p0, "Target file doesn\'t exist: system/etc/open_msync_app_list.xml"

    .line 76
    invoke-static {v1, p0}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 79
    :cond_0
    new-instance v4, Ljava/io/FileInputStream;

    invoke-direct {v4, v3}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 80
    :try_start_1
    invoke-direct {p0, v4}, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;->parseAppListFile(Ljava/io/InputStream;)Ljava/util/ArrayList;

    move-result-object v2

    iput-object v2, p0, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;->mMsyncAppCache:Ljava/util/ArrayList;

    const/4 v2, 0x1

    .line 81
    iput-boolean v2, p0, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;->isRead:Z
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 86
    :try_start_2
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catchall_0
    move-exception p0

    move-object v2, v4

    goto :goto_2

    :catch_0
    move-exception p0

    move-object v2, v4

    goto :goto_0

    :catchall_1
    move-exception p0

    goto :goto_2

    :catch_1
    move-exception p0

    :goto_0
    :try_start_3
    const-string v3, "IOException"

    .line 83
    invoke-static {v1, v3, p0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    if-eqz v2, :cond_1

    .line 86
    :try_start_4
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    .line 88
    invoke-static {v1, v0, p0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_1
    :goto_1
    const-string p0, "loadTunerAppList - "

    .line 91
    invoke-static {v1, p0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :goto_2
    if-eqz v2, :cond_2

    .line 86
    :try_start_5
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_3

    goto :goto_3

    :catch_3
    move-exception v2

    .line 88
    invoke-static {v1, v0, v2}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 90
    :cond_2
    :goto_3
    throw p0
.end method
