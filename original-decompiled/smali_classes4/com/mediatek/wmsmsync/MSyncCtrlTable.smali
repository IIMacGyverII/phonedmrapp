.class public Lcom/mediatek/wmsmsync/MSyncCtrlTable;
.super Ljava/lang/Object;
.source "MSyncCtrlTable.java"


# static fields
.field private static final APP_LIST_PATH:Ljava/lang/String; = "system/etc/msync_ctrl_table.xml"

.field private static final ARRAY_ACTIVITY:Ljava/lang/String; = "activities"

.field private static final LOCK:Ljava/lang/Object;

.field private static final NODE_ACTIVITY:Ljava/lang/String; = "activity"

.field private static final NODE_ACTIVITY_FPS:Ljava/lang/String; = "fps"

.field private static final NODE_ACTIVITY_NAME:Ljava/lang/String; = "name"

.field private static final NODE_DEFAULT_FPS:Ljava/lang/String; = "defaultfps"

.field private static final NODE_GLOBAL_FPS:Ljava/lang/String; = "globalfps"

.field private static final NODE_IME_DEFAULT_FPS:Ljava/lang/String; = "defaultimefps"

.field private static final NODE_IME_FPS:Ljava/lang/String; = "imefps"

.field private static final NODE_IME_GLOBAL_CONTROL:Ljava/lang/String; = "enableimeglobalcontrol"

.field private static final NODE_PACKAGE_NAME:Ljava/lang/String; = "packagename"

.field private static final NODE_SLIDE_RESPONSE:Ljava/lang/String; = "slideresponse"

.field private static final NODE_VOICE_DEFAULT_FPS:Ljava/lang/String; = "defaultvoicefps"

.field private static final NODE_VOICE_FPS:Ljava/lang/String; = "voicefps"

.field private static final NODE_VOICE_GLOBAL_CONTROL:Ljava/lang/String; = "enablevoiceglobalcontrol"

.field private static final TAG:Ljava/lang/String; = "MSyncCtrlTable"

.field private static final TAG_APP:Ljava/lang/String; = "app"

.field private static volatile sInstance:Lcom/mediatek/wmsmsync/MSyncCtrlTable;


# instance fields
.field private mDefaultImeFps:F

.field private mDefaultVoiceFps:F

.field private mEnableImeGlobalFpsControl:Z

.field private mEnableVoiceGlobalFpsControl:Z

.field private mGlobalFPS:F

.field private mIsRead:Z

.field private mMSyncAppCache:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/mediatek/wmsmsync/MSyncCtrlBean;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 95
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->LOCK:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .line 112
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 86
    iput-boolean v0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mEnableImeGlobalFpsControl:Z

    .line 87
    iput-boolean v0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mEnableVoiceGlobalFpsControl:Z

    .line 94
    iput-boolean v0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mIsRead:Z

    return-void
.end method

.method public static getInstance()Lcom/mediatek/wmsmsync/MSyncCtrlTable;
    .locals 2

    .line 102
    sget-object v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->sInstance:Lcom/mediatek/wmsmsync/MSyncCtrlTable;

    if-nez v0, :cond_1

    .line 103
    sget-object v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 104
    :try_start_0
    sget-object v1, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->sInstance:Lcom/mediatek/wmsmsync/MSyncCtrlTable;

    if-nez v1, :cond_0

    .line 105
    new-instance v1, Lcom/mediatek/wmsmsync/MSyncCtrlTable;

    invoke-direct {v1}, Lcom/mediatek/wmsmsync/MSyncCtrlTable;-><init>()V

    sput-object v1, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->sInstance:Lcom/mediatek/wmsmsync/MSyncCtrlTable;

    .line 107
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 109
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->sInstance:Lcom/mediatek/wmsmsync/MSyncCtrlTable;

    return-object v0
.end method

.method private parseAppListFile(Ljava/io/InputStream;)Ljava/util/ArrayList;
    .locals 18
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/io/InputStream;",
            ")",
            "Ljava/util/ArrayList<",
            "Lcom/mediatek/wmsmsync/MSyncCtrlBean;",
            ">;"
        }
    .end annotation

    move-object/from16 v0, p0

    const-string v1, "MSyncCtrlTable"

    .line 168
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 171
    :try_start_0
    invoke-static {}, Ljavax/xml/parsers/DocumentBuilderFactory;->newInstance()Ljavax/xml/parsers/DocumentBuilderFactory;

    move-result-object v3

    .line 172
    invoke-virtual {v3}, Ljavax/xml/parsers/DocumentBuilderFactory;->newDocumentBuilder()Ljavax/xml/parsers/DocumentBuilder;

    move-result-object v3

    move-object/from16 v4, p1

    .line 173
    invoke-virtual {v3, v4}, Ljavax/xml/parsers/DocumentBuilder;->parse(Ljava/io/InputStream;)Lorg/w3c/dom/Document;

    move-result-object v3
    :try_end_0
    .catch Ljavax/xml/parsers/ParserConfigurationException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Lorg/xml/sax/SAXException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    :try_start_1
    const-string v4, "enableimeglobalcontrol"

    .line 187
    invoke-interface {v3, v4}, Lorg/w3c/dom/Document;->getElementsByTagName(Ljava/lang/String;)Lorg/w3c/dom/NodeList;

    move-result-object v4

    const/4 v5, 0x0

    invoke-interface {v4, v5}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v4

    invoke-interface {v4}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v4

    .line 186
    invoke-static {v4}, Ljava/lang/Boolean;->parseBoolean(Ljava/lang/String;)Z

    move-result v4

    iput-boolean v4, v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mEnableImeGlobalFpsControl:Z

    const-string v4, "enablevoiceglobalcontrol"

    .line 189
    invoke-interface {v3, v4}, Lorg/w3c/dom/Document;->getElementsByTagName(Ljava/lang/String;)Lorg/w3c/dom/NodeList;

    move-result-object v4

    invoke-interface {v4, v5}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v4

    invoke-interface {v4}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v4

    .line 188
    invoke-static {v4}, Ljava/lang/Boolean;->parseBoolean(Ljava/lang/String;)Z

    move-result v4

    iput-boolean v4, v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mEnableVoiceGlobalFpsControl:Z

    .line 190
    iget-boolean v4, v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mEnableImeGlobalFpsControl:Z

    if-eqz v4, :cond_0

    const-string v4, "defaultimefps"

    .line 192
    invoke-interface {v3, v4}, Lorg/w3c/dom/Document;->getElementsByTagName(Ljava/lang/String;)Lorg/w3c/dom/NodeList;

    move-result-object v4

    invoke-interface {v4, v5}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v4

    invoke-interface {v4}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v4

    .line 191
    invoke-static {v4}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v4

    iput v4, v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mDefaultImeFps:F

    .line 194
    :cond_0
    iget-boolean v4, v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mEnableVoiceGlobalFpsControl:Z

    if-eqz v4, :cond_1

    const-string v4, "defaultvoicefps"

    .line 196
    invoke-interface {v3, v4}, Lorg/w3c/dom/Document;->getElementsByTagName(Ljava/lang/String;)Lorg/w3c/dom/NodeList;

    move-result-object v4

    .line 197
    invoke-interface {v4, v5}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v4

    invoke-interface {v4}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v4

    .line 196
    invoke-static {v4}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v4

    iput v4, v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mDefaultVoiceFps:F

    :cond_1
    const-string v4, "globalfps"

    .line 200
    invoke-interface {v3, v4}, Lorg/w3c/dom/Document;->getElementsByTagName(Ljava/lang/String;)Lorg/w3c/dom/NodeList;

    move-result-object v4

    invoke-interface {v4, v5}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v4

    invoke-interface {v4}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v4

    .line 199
    invoke-static {v4}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v4

    iput v4, v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mGlobalFPS:F

    .line 201
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "mEnableIMEGlobalFPSControl = "

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v6, v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mEnableImeGlobalFpsControl:Z

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v6, " | mDefaultIMEFPS = "

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v6, v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mDefaultImeFps:F

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v6, "\nmEnableVoiceGlobalFPSControl = "

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v6, v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mEnableVoiceGlobalFpsControl:Z

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v6, " | mDefaultVoiceFPS = "

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v6, v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mDefaultVoiceFps:F

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v6, "\nmGlobalFPS = "

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, v0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mGlobalFPS:F

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    const-string v0, "app"

    .line 207
    invoke-interface {v3, v0}, Lorg/w3c/dom/Document;->getElementsByTagName(Ljava/lang/String;)Lorg/w3c/dom/NodeList;

    move-result-object v0

    move v3, v5

    .line 209
    :goto_0
    invoke-interface {v0}, Lorg/w3c/dom/NodeList;->getLength()I

    move-result v4

    if-ge v3, v4, :cond_12

    .line 210
    invoke-interface {v0, v3}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v4

    .line 211
    invoke-interface {v4}, Lorg/w3c/dom/Node;->getChildNodes()Lorg/w3c/dom/NodeList;

    move-result-object v4

    .line 212
    new-instance v6, Lcom/mediatek/wmsmsync/MSyncCtrlBean;

    invoke-direct {v6}, Lcom/mediatek/wmsmsync/MSyncCtrlBean;-><init>()V

    move v7, v5

    .line 213
    :goto_1
    invoke-interface {v4}, Lorg/w3c/dom/NodeList;->getLength()I

    move-result v8

    if-ge v7, v8, :cond_11

    .line 214
    invoke-interface {v4, v7}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v8

    .line 215
    invoke-interface {v8}, Lorg/w3c/dom/Node;->getNodeName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/String;->hashCode()I

    move-result v10
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    const-string v11, "imefps"

    const-string/jumbo v12, "voicefps"

    const/4 v14, 0x4

    const/4 v5, 0x3

    const/4 v15, 0x2

    const/4 v13, 0x1

    sparse-switch v10, :sswitch_data_0

    goto :goto_2

    :sswitch_0
    :try_start_2
    const-string v10, "activities"

    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_2

    const/4 v9, 0x5

    goto :goto_3

    :sswitch_1
    const-string/jumbo v10, "slideresponse"

    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_2

    move v9, v13

    goto :goto_3

    :sswitch_2
    const-string v10, "packagename"

    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_2

    const/4 v9, 0x0

    goto :goto_3

    :sswitch_3
    const-string v10, "defaultfps"

    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_2

    move v9, v15

    goto :goto_3

    :sswitch_4
    invoke-virtual {v9, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_2

    move v9, v5

    goto :goto_3

    :sswitch_5
    invoke-virtual {v9, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_2

    move v9, v14

    goto :goto_3

    :cond_2
    :goto_2
    const/4 v9, -0x1

    :goto_3
    if-eqz v9, :cond_10

    if-eq v9, v13, :cond_f

    if-eq v9, v15, :cond_e

    if-eq v9, v5, :cond_d

    if-eq v9, v14, :cond_c

    const/4 v10, 0x5

    if-eq v9, v10, :cond_3

    move-object/from16 v16, v0

    move-object/from16 v17, v4

    goto/16 :goto_a

    .line 238
    :cond_3
    invoke-interface {v8}, Lorg/w3c/dom/Node;->getChildNodes()Lorg/w3c/dom/NodeList;

    move-result-object v8

    .line 239
    new-instance v9, Ljava/util/ArrayList;

    invoke-direct {v9}, Ljava/util/ArrayList;-><init>()V

    const/4 v10, 0x0

    .line 241
    :goto_4
    invoke-interface {v8}, Lorg/w3c/dom/NodeList;->getLength()I

    move-result v14

    if-ge v10, v14, :cond_b

    .line 242
    invoke-interface {v8, v10}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v14

    const-string v5, "activity"

    .line 243
    invoke-interface {v14}, Lorg/w3c/dom/Node;->getNodeName()Ljava/lang/String;

    move-result-object v15

    invoke-virtual {v5, v15}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_a

    .line 244
    invoke-interface {v14}, Lorg/w3c/dom/Node;->getChildNodes()Lorg/w3c/dom/NodeList;

    move-result-object v5

    .line 245
    new-instance v14, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;

    invoke-direct {v14}, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;-><init>()V

    const/4 v15, 0x0

    .line 247
    :goto_5
    invoke-interface {v5}, Lorg/w3c/dom/NodeList;->getLength()I

    move-result v13

    if-ge v15, v13, :cond_9

    .line 248
    invoke-interface {v5, v15}, Lorg/w3c/dom/NodeList;->item(I)Lorg/w3c/dom/Node;

    move-result-object v13

    move-object/from16 v16, v0

    .line 249
    invoke-interface {v13}, Lorg/w3c/dom/Node;->getNodeName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    move-result v17

    sparse-switch v17, :sswitch_data_1

    move-object/from16 v17, v4

    goto :goto_6

    :sswitch_6
    move-object/from16 v17, v4

    const-string v4, "name"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    const/4 v0, 0x0

    goto :goto_7

    :sswitch_7
    move-object/from16 v17, v4

    const-string v4, "fps"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    const/4 v0, 0x1

    goto :goto_7

    :sswitch_8
    move-object/from16 v17, v4

    invoke-virtual {v0, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    const/4 v0, 0x2

    goto :goto_7

    :sswitch_9
    move-object/from16 v17, v4

    invoke-virtual {v0, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    const/4 v0, 0x3

    goto :goto_7

    :cond_4
    :goto_6
    const/4 v0, -0x1

    :goto_7
    if-eqz v0, :cond_8

    const/4 v4, 0x1

    if-eq v0, v4, :cond_7

    const/4 v4, 0x2

    if-eq v0, v4, :cond_6

    const/4 v4, 0x3

    if-eq v0, v4, :cond_5

    goto :goto_8

    .line 268
    :cond_5
    invoke-interface {v13}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v0

    .line 270
    invoke-static {v0}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v0

    .line 269
    invoke-virtual {v14, v0}, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->setVoiceFps(F)V

    goto :goto_8

    :cond_6
    const/4 v4, 0x3

    .line 262
    invoke-interface {v13}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v0

    .line 264
    invoke-static {v0}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v0

    invoke-virtual {v14, v0}, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->setImeFps(F)V

    goto :goto_8

    :cond_7
    const/4 v4, 0x3

    .line 257
    invoke-interface {v13}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v0

    .line 258
    invoke-static {v0}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v0

    invoke-virtual {v14, v0}, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->setFps(F)V

    goto :goto_8

    :cond_8
    const/4 v4, 0x3

    .line 252
    invoke-interface {v13}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v0

    .line 253
    invoke-virtual {v14, v0}, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->setName(Ljava/lang/String;)V

    :goto_8
    add-int/lit8 v15, v15, 0x1

    move-object/from16 v0, v16

    move-object/from16 v4, v17

    goto/16 :goto_5

    :cond_9
    move-object/from16 v16, v0

    move-object/from16 v17, v4

    const/4 v4, 0x3

    .line 274
    invoke-interface {v9, v14}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_9

    :cond_a
    move-object/from16 v16, v0

    move-object/from16 v17, v4

    const/4 v4, 0x3

    :goto_9
    add-int/lit8 v10, v10, 0x1

    move v5, v4

    move-object/from16 v0, v16

    move-object/from16 v4, v17

    const/4 v13, 0x1

    const/4 v15, 0x2

    goto/16 :goto_4

    :cond_b
    move-object/from16 v16, v0

    move-object/from16 v17, v4

    .line 277
    invoke-virtual {v6, v9}, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->setActivityBeans(Ljava/util/List;)V

    goto :goto_a

    :cond_c
    move-object/from16 v16, v0

    move-object/from16 v17, v4

    .line 234
    invoke-interface {v8}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v0

    .line 235
    invoke-static {v0}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v0

    invoke-virtual {v6, v0}, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->setVoiceFps(F)V

    goto :goto_a

    :cond_d
    move-object/from16 v16, v0

    move-object/from16 v17, v4

    .line 230
    invoke-interface {v8}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v0

    .line 231
    invoke-static {v0}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v0

    invoke-virtual {v6, v0}, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->setImeFps(F)V

    goto :goto_a

    :cond_e
    move-object/from16 v16, v0

    move-object/from16 v17, v4

    .line 226
    invoke-interface {v8}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v0

    .line 227
    invoke-static {v0}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v0

    invoke-virtual {v6, v0}, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->setFps(F)V

    goto :goto_a

    :cond_f
    move-object/from16 v16, v0

    move-object/from16 v17, v4

    .line 221
    invoke-interface {v8}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v0

    .line 223
    invoke-static {v0}, Ljava/lang/Boolean;->parseBoolean(Ljava/lang/String;)Z

    move-result v0

    invoke-virtual {v6, v0}, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->setSlideResponse(Z)V

    goto :goto_a

    :cond_10
    move-object/from16 v16, v0

    move-object/from16 v17, v4

    .line 217
    invoke-interface {v8}, Lorg/w3c/dom/Node;->getTextContent()Ljava/lang/String;

    move-result-object v0

    .line 218
    invoke-virtual {v6, v0}, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->setPackageName(Ljava/lang/String;)V

    :goto_a
    add-int/lit8 v7, v7, 0x1

    move-object/from16 v0, v16

    move-object/from16 v4, v17

    const/4 v5, 0x0

    goto/16 :goto_1

    :cond_11
    move-object/from16 v16, v0

    .line 283
    invoke-virtual {v2, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 284
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "MSyncCtrlTableBean dom2xml: "

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    add-int/lit8 v3, v3, 0x1

    move-object/from16 v0, v16

    const/4 v5, 0x0

    goto/16 :goto_0

    :cond_12
    return-object v2

    :catch_0
    move-exception v0

    .line 287
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 288
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    return-object v0

    :catch_1
    move-exception v0

    const-string v3, "IOException"

    .line 181
    invoke-static {v1, v3, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v2

    :catch_2
    move-exception v0

    const-string v3, "dom2xml SAXException"

    .line 178
    invoke-static {v1, v3, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v2

    :catch_3
    move-exception v0

    const-string v3, "dom2xml ParserConfigurationException"

    .line 175
    invoke-static {v1, v3, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v2

    nop

    :sswitch_data_0
    .sparse-switch
        -0x75923989 -> :sswitch_5
        -0x46a3ae78 -> :sswitch_4
        0x28738308 -> :sswitch_3
        0x36391bd1 -> :sswitch_2
        0x4d0210f2 -> :sswitch_1
        0x7a1b3bed -> :sswitch_0
    .end sparse-switch

    :sswitch_data_1
    .sparse-switch
        -0x75923989 -> :sswitch_9
        -0x46a3ae78 -> :sswitch_8
        0x18ce9 -> :sswitch_7
        0x337a8b -> :sswitch_6
    .end sparse-switch
.end method


# virtual methods
.method public getDefaultImeFps()F
    .locals 0

    .line 128
    iget p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mDefaultImeFps:F

    return p0
.end method

.method public getDefaultVoiceFps()F
    .locals 0

    .line 132
    iget p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mDefaultVoiceFps:F

    return p0
.end method

.method public getGlobalFPS()F
    .locals 0

    .line 136
    iget p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mGlobalFPS:F

    return p0
.end method

.method public getMSyncAppCache()Ljava/util/ArrayList;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Lcom/mediatek/wmsmsync/MSyncCtrlBean;",
            ">;"
        }
    .end annotation

    .line 98
    iget-object p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mMSyncAppCache:Ljava/util/ArrayList;

    return-object p0
.end method

.method public isEnableImeGlobalFpsControl()Z
    .locals 0

    .line 120
    iget-boolean p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mEnableImeGlobalFpsControl:Z

    return p0
.end method

.method public isEnableVoiceGlobalFpsControl()Z
    .locals 0

    .line 124
    iget-boolean p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mEnableVoiceGlobalFpsControl:Z

    return p0
.end method

.method public isRead()Z
    .locals 0

    .line 116
    iget-boolean p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mIsRead:Z

    return p0
.end method

.method public loadMSyncCtrlTable()V
    .locals 5

    const-string v0, "close failed.."

    const-string v1, "MSyncCtrlTable"

    const-string v2, "loadMSyncCtrlTable + "

    .line 143
    invoke-static {v1, v2}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v2, 0x0

    .line 147
    :try_start_0
    new-instance v3, Ljava/io/File;

    const-string/jumbo v4, "system/etc/msync_ctrl_table.xml"

    invoke-direct {v3, v4}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 148
    invoke-virtual {v3}, Ljava/io/File;->exists()Z

    move-result v4

    if-nez v4, :cond_0

    const-string p0, "Target file doesn\'t exist: system/etc/msync_ctrl_table.xml"

    .line 149
    invoke-static {v1, p0}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 152
    :cond_0
    new-instance v4, Ljava/io/FileInputStream;

    invoke-direct {v4, v3}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 153
    :try_start_1
    invoke-direct {p0, v4}, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->parseAppListFile(Ljava/io/InputStream;)Ljava/util/ArrayList;

    move-result-object v2

    iput-object v2, p0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mMSyncAppCache:Ljava/util/ArrayList;

    const/4 v2, 0x1

    .line 154
    iput-boolean v2, p0, Lcom/mediatek/wmsmsync/MSyncCtrlTable;->mIsRead:Z
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 159
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

    .line 156
    invoke-static {v1, v3, p0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    if-eqz v2, :cond_1

    .line 159
    :try_start_4
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    .line 161
    invoke-static {v1, v0, p0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_1
    :goto_1
    const-string p0, "loadMSyncCtrlTable - "

    .line 164
    invoke-static {v1, p0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :goto_2
    if-eqz v2, :cond_2

    .line 159
    :try_start_5
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_3

    goto :goto_3

    :catch_3
    move-exception v2

    .line 161
    invoke-static {v1, v0, v2}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 163
    :cond_2
    :goto_3
    throw p0
.end method
