.class public Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;
.super Ljava/lang/Object;
.source "ResolutionTunerAppList.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;
    }
.end annotation


# static fields
.field private static final APP_LIST_PATH:Ljava/lang/String; = "system/etc/resolution_tuner_app_list.xml"

.field private static final APP_LIST_PATH_FOR_AIVRS:Ljava/lang/String; = "/vendor/etc/aivrs.ini"

.field private static final APP_LIST_PATH_FOR_GAISR:Ljava/lang/String; = "/vendor/etc/gaisr.ini"

.field private static final NODE_FILTERED_WINDOW:Ljava/lang/String; = "filteredwindow"

.field private static final NODE_PACKAGE_NAME:Ljava/lang/String; = "packagename"

.field private static final NODE_SCALE:Ljava/lang/String; = "scale"

.field private static final NODE_SCALING_FLOW:Ljava/lang/String; = "flow"

.field private static final TAG:Ljava/lang/String; = "AppResolutionTuner"

.field private static final TAG_APP:Ljava/lang/String; = "app"

.field private static final VALUE_SCALING_FLOW_GAME:Ljava/lang/String; = "game"

.field private static final VALUE_SCALING_FLOW_SURFACEVIEW:Ljava/lang/String; = "surfaceview"

.field private static final VALUE_SCALING_FLOW_WMS:Ljava/lang/String; = "wms"

.field private static sInstance:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;


# instance fields
.field private mTunerAppCache:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 61
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getInstance()Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;
    .locals 1

    .line 66
    sget-object v0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->sInstance:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    if-nez v0, :cond_0

    .line 67
    new-instance v0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    invoke-direct {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;-><init>()V

    sput-object v0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->sInstance:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    .line 69
    :cond_0
    sget-object v0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->sInstance:Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;

    return-object v0
.end method

.method private parseAppListFile(Ljava/io/InputStream;)Ljava/util/ArrayList;
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/io/InputStream;",
            ")",
            "Ljava/util/ArrayList<",
            "Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;",
            ">;"
        }
    .end annotation

    const-string p0, "AppResolutionTuner"

    .line 274
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 277
    :try_start_0
    invoke-static {}, Ljavax/xml/parsers/DocumentBuilderFactory;->newInstance()Ljavax/xml/parsers/DocumentBuilderFactory;

    move-result-object v1

    .line 278
    invoke-virtual {v1}, Ljavax/xml/parsers/DocumentBuilderFactory;->newDocumentBuilder()Ljavax/xml/parsers/DocumentBuilder;

    move-result-object v1

    .line 279
    invoke-virtual {v1, p1}, Ljavax/xml/parsers/DocumentBuilder;->parse(Ljava/io/InputStream;)Lorg/w3c/dom/Document;

    move-result-object p1
    :try_end_0
    .catch Ljavax/xml/parsers/ParserConfigurationException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Lorg/xml/sax/SAXException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    const-string v1, "app"

    .line 291
    invoke-interface {p1, v1}, Lorg/w3c/dom/Document;->getElementsByTagName(Ljava/lang/String;)Lorg/w3c/dom/NodeList;

    move-result-object p1

    const/4 v1, 0x0

    move v2, v1

    .line 293
    :goto_0
    invoke-interface {p1}, Lorg/w3c/dom/NodeList;->getLength()I

    move-result v3

    if-ge v2, v3, :cond_5

    .line 294
    invoke-interface {p1, v2}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v3

    .line 295
    invoke-interface {v3}, Lorg/w3c/dom/Node;->getChildNodes()Lorg/w3c/dom/NodeList;

    move-result-object v3

    .line 296
    new-instance v4, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;

    invoke-direct {v4}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;-><init>()V

    move v5, v1

    .line 297
    :goto_1
    invoke-interface {v3}, Lorg/w3c/dom/NodeList;->getLength()I

    move-result v6

    if-ge v5, v6, :cond_4

    .line 298
    invoke-interface {v3, v5}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v6

    .line 299
    invoke-interface {v6}, Lorg/w3c/dom/Node;->getNodeName()Ljava/lang/String;

    move-result-object v7

    const-string v8, "packagename"

    invoke-virtual {v7, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_0

    .line 300
    invoke-interface {v6}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v6

    .line 301
    invoke-virtual {v4, v6}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->setPackageName(Ljava/lang/String;)V

    goto :goto_2

    .line 302
    :cond_0
    invoke-interface {v6}, Lorg/w3c/dom/Node;->getNodeName()Ljava/lang/String;

    move-result-object v7

    const-string v8, "scale"

    invoke-virtual {v7, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_1

    .line 303
    invoke-interface {v6}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v6

    .line 304
    invoke-static {v6}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v6

    invoke-virtual {v4, v6}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->setScale(F)V

    goto :goto_2

    .line 305
    :cond_1
    invoke-interface {v6}, Lorg/w3c/dom/Node;->getNodeName()Ljava/lang/String;

    move-result-object v7

    const-string v8, "filteredwindow"

    invoke-virtual {v7, v8}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_2

    .line 306
    invoke-interface {v6}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v6

    .line 307
    invoke-virtual {v4, v6}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->addFilteredWindow(Ljava/lang/String;)V

    goto :goto_2

    .line 308
    :cond_2
    invoke-interface {v6}, Lorg/w3c/dom/Node;->getNodeName()Ljava/lang/String;

    move-result-object v7

    const-string v8, "flow"

    invoke-virtual {v7, v8}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_3

    .line 309
    invoke-interface {v6}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v6

    .line 310
    invoke-virtual {v4, v6}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->setScalingFlow(Ljava/lang/String;)V

    :cond_3
    :goto_2
    add-int/lit8 v5, v5, 0x1

    goto :goto_1

    .line 313
    :cond_4
    invoke-virtual {v0, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 314
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "dom2xml: "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {p0, v3}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    add-int/lit8 v2, v2, 0x1

    goto/16 :goto_0

    :cond_5
    return-object v0

    :catch_0
    move-exception p1

    const-string v1, "IOException"

    .line 287
    invoke-static {p0, v1, p1}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v0

    :catch_1
    move-exception p1

    const-string v1, "dom2xml SAXException"

    .line 284
    invoke-static {p0, v1, p1}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v0

    :catch_2
    move-exception p1

    const-string v1, "dom2xml ParserConfigurationException"

    .line 281
    invoke-static {p0, v1, p1}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v0
.end method

.method private parseAppListFileForAIVRS(Ljava/io/File;)Ljava/util/ArrayList;
    .locals 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/io/File;",
            ")",
            "Ljava/util/ArrayList<",
            "Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;",
            ">;"
        }
    .end annotation

    const-string p0, "="

    const-string v0, "AppResolutionTuner"

    const-string v1, "\""

    .line 355
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 356
    :try_start_0
    new-instance v3, Ljava/io/BufferedReader;

    new-instance v4, Ljava/io/FileReader;

    invoke-direct {v4, p1}, Ljava/io/FileReader;-><init>(Ljava/io/File;)V

    invoke-direct {v3, v4}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 358
    :cond_0
    :goto_0
    :try_start_1
    invoke-virtual {v3}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_5

    .line 359
    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-nez v5, :cond_0

    invoke-virtual {v4, p0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v5

    const/4 v6, 0x1

    if-lt v5, v6, :cond_0

    invoke-virtual {v4, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v5

    if-ge v5, v6, :cond_1

    goto :goto_0

    .line 363
    :cond_1
    invoke-virtual {v4, v1}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v5

    add-int/2addr v5, v6

    const/4 v7, 0x0

    invoke-virtual {v4, v7, v5}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    const-string v5, "game\""

    .line 364
    invoke-virtual {v4, v5}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_2

    const-string v8, ",game"

    const-string v9, ""

    .line 366
    invoke-virtual {v4, v8, v9}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v4

    .line 368
    :cond_2
    invoke-virtual {v4, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v8

    add-int/2addr v8, v6

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v9

    sub-int/2addr v9, v6

    invoke-virtual {v4, v8, v9}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v6

    .line 369
    invoke-static {v6}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v8

    const/16 v9, 0x46

    if-ge v8, v9, :cond_0

    invoke-static {v6}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v8

    if-gtz v8, :cond_3

    goto :goto_0

    .line 372
    :cond_3
    invoke-virtual {v4, p0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v8

    invoke-virtual {v4, v7, v8}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    .line 373
    new-instance v7, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;

    invoke-direct {v7}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;-><init>()V

    if-eqz v5, :cond_4

    const-string v5, "game"

    .line 375
    invoke-virtual {v7, v5}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->setScalingFlow(Ljava/lang/String;)V

    .line 377
    :cond_4
    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v7, v5}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->setPackageName(Ljava/lang/String;)V

    const/high16 v5, 0x3fc00000    # 1.5f

    .line 378
    invoke-virtual {v7, v5}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->setScale(F)V

    .line 379
    invoke-virtual {v2, v7}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 380
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "parseAppListFileForAIVRS  packageName: "

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " value:"

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v0, v4}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0

    .line 382
    :cond_5
    invoke-virtual {v3}, Ljava/io/BufferedReader;->close()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 383
    :try_start_2
    invoke-virtual {v3}, Ljava/io/BufferedReader;->close()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_2

    :catchall_0
    move-exception p0

    .line 356
    :try_start_3
    invoke-virtual {v3}, Ljava/io/BufferedReader;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_1

    :catchall_1
    move-exception v1

    :try_start_4
    invoke-virtual {p0, v1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_1
    throw p0
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0

    :catch_0
    move-exception p0

    .line 384
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Failed to read app list for resolution tuner app list "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1, p0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_2
    return-object v2
.end method

.method private parseAppListFileForGAISR(Ljava/io/File;)Ljava/util/ArrayList;
    .locals 12
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/io/File;",
            ")",
            "Ljava/util/ArrayList<",
            "Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;",
            ">;"
        }
    .end annotation

    const-string p0, " "

    const-string v0, "\""

    const-string v1, "="

    const-string v2, "AppResolutionTuner"

    .line 320
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 321
    :try_start_0
    new-instance v4, Ljava/io/BufferedReader;

    new-instance v5, Ljava/io/FileReader;

    invoke-direct {v5, p1}, Ljava/io/FileReader;-><init>(Ljava/io/File;)V

    invoke-direct {v4, v5}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 323
    :cond_0
    :goto_0
    :try_start_1
    invoke-virtual {v4}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_4

    .line 324
    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-nez v6, :cond_0

    invoke-virtual {v5, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v6

    const/4 v7, 0x1

    if-ge v6, v7, :cond_1

    goto :goto_0

    .line 328
    :cond_1
    invoke-virtual {v5, v0}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v6

    add-int/2addr v6, v7

    const/4 v8, 0x0

    invoke-virtual {v5, v8, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    const-string v6, "game\""

    .line 329
    invoke-virtual {v5, v6}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_2

    const-string v9, ",game"

    const-string v10, ""

    .line 331
    invoke-virtual {v5, v9, v10}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v5

    .line 333
    :cond_2
    invoke-virtual {v5, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v9

    invoke-virtual {v5, v8, v9}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v8

    .line 335
    invoke-virtual {v5, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v9

    add-int/2addr v9, v7

    invoke-virtual {v5, p0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v10

    invoke-virtual {v5, v9, v10}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v9

    invoke-static {v9}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v9

    .line 337
    invoke-virtual {v5, p0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v10

    add-int/2addr v10, v7

    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v11

    sub-int/2addr v11, v7

    invoke-virtual {v5, v10, v11}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v5

    .line 338
    new-instance v7, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;

    invoke-direct {v7}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;-><init>()V

    if-eqz v6, :cond_3

    const-string v6, "game"

    .line 340
    invoke-virtual {v7, v6}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->setScalingFlow(Ljava/lang/String;)V

    .line 342
    :cond_3
    invoke-virtual {v8}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v7, v6}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->setPackageName(Ljava/lang/String;)V

    .line 343
    invoke-virtual {v7, v9, v5}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->setScale(FF)V

    .line 344
    invoke-virtual {v3, v7}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 345
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "parseAppListFileForGAISR  packageName: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v2, v5}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0

    .line 347
    :cond_4
    invoke-virtual {v4}, Ljava/io/BufferedReader;->close()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 348
    :try_start_2
    invoke-virtual {v4}, Ljava/io/BufferedReader;->close()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_2

    :catchall_0
    move-exception p0

    .line 321
    :try_start_3
    invoke-virtual {v4}, Ljava/io/BufferedReader;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_1

    :catchall_1
    move-exception v0

    :try_start_4
    invoke-virtual {p0, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_1
    throw p0
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0

    :catch_0
    move-exception p0

    .line 349
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Failed to read app list for resolution tuner app list "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v2, p1, p0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_2
    return-object v3
.end method


# virtual methods
.method public getScaleHeight(Ljava/lang/String;)F
    .locals 2

    .line 185
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->mTunerAppCache:Ljava/util/ArrayList;

    if-eqz p0, :cond_1

    .line 186
    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;

    .line 187
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 188
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->getScaleHeight()F

    move-result p0

    return p0

    :cond_1
    const/high16 p0, 0x3f800000    # 1.0f

    return p0
.end method

.method public getScaleValue(Ljava/lang/String;)F
    .locals 2

    .line 163
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->mTunerAppCache:Ljava/util/ArrayList;

    if-eqz p0, :cond_1

    .line 164
    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;

    .line 165
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 166
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->getScale()F

    move-result p0

    return p0

    :cond_1
    const/high16 p0, 0x3f800000    # 1.0f

    return p0
.end method

.method public getScaleWidth(Ljava/lang/String;)F
    .locals 2

    .line 174
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->mTunerAppCache:Ljava/util/ArrayList;

    if-eqz p0, :cond_1

    .line 175
    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;

    .line 176
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 177
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->getScaleWidth()F

    move-result p0

    return p0

    :cond_1
    const/high16 p0, 0x3f800000    # 1.0f

    return p0
.end method

.method public isScaledByGameMode(Ljava/lang/String;)Z
    .locals 2

    .line 135
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->mTunerAppCache:Ljava/util/ArrayList;

    if-eqz p0, :cond_1

    .line 136
    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;

    .line 137
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 138
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->getScalingFlow()Ljava/lang/String;

    move-result-object v0

    const-string v1, "game"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method public isScaledBySurfaceView(Ljava/lang/String;)Z
    .locals 3

    .line 150
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->mTunerAppCache:Ljava/util/ArrayList;

    if-eqz p0, :cond_1

    .line 151
    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;

    .line 152
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 153
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->getScalingFlow()Ljava/lang/String;

    move-result-object v1

    const-string/jumbo v2, "wms"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 154
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->getScalingFlow()Ljava/lang/String;

    move-result-object v0

    const-string v1, "game"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method public isScaledByWMS(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 3

    .line 120
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->mTunerAppCache:Ljava/util/ArrayList;

    if-eqz p0, :cond_1

    .line 121
    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;

    .line 122
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 123
    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->getScalingFlow()Ljava/lang/String;

    move-result-object v1

    const-string/jumbo v2, "wms"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 124
    invoke-virtual {v0, p2}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->isFiltered(Ljava/lang/String;)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method public loadTunerAppList()Ljava/util/ArrayList;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;",
            ">;"
        }
    .end annotation

    const-string v0, "close failed.."

    const-string v1, "loadTunerAppList - "

    const-string v2, "AppResolutionTuner"

    const-string v3, "loadTunerAppList + "

    .line 76
    invoke-static {v2, v3}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v3, 0x0

    :try_start_0
    const-string v4, "1"

    const-string v5, "ro.vendor.game_aisr_enable"

    .line 80
    invoke-static {v5}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_2

    .line 81
    new-instance v4, Ljava/io/File;

    const-string v5, "/vendor/etc/aivrs.ini"

    invoke-direct {v4, v5}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 82
    invoke-virtual {v4}, Ljava/io/File;->exists()Z

    move-result v5

    if-eqz v5, :cond_0

    .line 83
    invoke-direct {p0, v4}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->parseAppListFileForAIVRS(Ljava/io/File;)Ljava/util/ArrayList;

    move-result-object v4

    iput-object v4, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->mTunerAppCache:Ljava/util/ArrayList;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 111
    invoke-static {v2, v1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v4

    :cond_0
    :try_start_1
    const-string v4, "Target file doesn\'t exist: /vendor/etc/aivrs.ini"

    .line 87
    invoke-static {v2, v4}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 88
    new-instance v4, Ljava/io/File;

    const-string v5, "/vendor/etc/gaisr.ini"

    invoke-direct {v4, v5}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 89
    invoke-virtual {v4}, Ljava/io/File;->exists()Z

    move-result v5

    if-eqz v5, :cond_1

    .line 90
    invoke-direct {p0, v4}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->parseAppListFileForGAISR(Ljava/io/File;)Ljava/util/ArrayList;

    move-result-object v4

    iput-object v4, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->mTunerAppCache:Ljava/util/ArrayList;
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_2
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 111
    invoke-static {v2, v1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v4

    :cond_1
    :try_start_2
    const-string v4, "Target file doesn\'t exist: /vendor/etc/gaisr.ini"

    .line 93
    invoke-static {v2, v4}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 94
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->mTunerAppCache:Ljava/util/ArrayList;
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 111
    invoke-static {v2, v1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object p0

    .line 96
    :cond_2
    :try_start_3
    new-instance v4, Ljava/io/File;

    const-string/jumbo v5, "system/etc/resolution_tuner_app_list.xml"

    invoke-direct {v4, v5}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 97
    invoke-virtual {v4}, Ljava/io/File;->exists()Z

    move-result v5

    if-nez v5, :cond_3

    const-string v4, "Target file doesn\'t exist: system/etc/resolution_tuner_app_list.xml"

    .line 98
    invoke-static {v2, v4}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 99
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->mTunerAppCache:Ljava/util/ArrayList;
    :try_end_3
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_2
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    .line 111
    invoke-static {v2, v1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object p0

    .line 101
    :cond_3
    :try_start_4
    new-instance v5, Ljava/io/FileInputStream;

    invoke-direct {v5, v4}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_2
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    .line 102
    :try_start_5
    invoke-direct {p0, v5}, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->parseAppListFile(Ljava/io/InputStream;)Ljava/util/ArrayList;

    move-result-object v3

    iput-object v3, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->mTunerAppCache:Ljava/util/ArrayList;
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_1
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    .line 107
    :try_start_6
    invoke-virtual {v5}, Ljava/io/InputStream;->close()V
    :try_end_6
    .catch Ljava/io/IOException; {:try_start_6 .. :try_end_6} :catch_0

    goto :goto_2

    :catch_0
    move-exception v3

    goto :goto_1

    :catchall_0
    move-exception p0

    move-object v3, v5

    goto :goto_3

    :catch_1
    move-exception v4

    move-object v3, v5

    goto :goto_0

    :catchall_1
    move-exception p0

    goto :goto_3

    :catch_2
    move-exception v4

    :goto_0
    :try_start_7
    const-string v5, "IOException"

    .line 104
    invoke-static {v2, v5, v4}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_1

    if-eqz v3, :cond_4

    .line 107
    :try_start_8
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_8
    .catch Ljava/io/IOException; {:try_start_8 .. :try_end_8} :catch_3

    goto :goto_2

    :catch_3
    move-exception v3

    .line 109
    :goto_1
    invoke-static {v2, v0, v3}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 111
    :cond_4
    :goto_2
    invoke-static {v2, v1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 113
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;->mTunerAppCache:Ljava/util/ArrayList;

    return-object p0

    :goto_3
    if-eqz v3, :cond_5

    .line 107
    :try_start_9
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_9
    .catch Ljava/io/IOException; {:try_start_9 .. :try_end_9} :catch_4

    goto :goto_4

    :catch_4
    move-exception v3

    .line 109
    invoke-static {v2, v0, v3}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 111
    :cond_5
    :goto_4
    invoke-static {v2, v1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 112
    throw p0
.end method
