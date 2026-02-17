.class public Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;
.super Ljava/lang/Object;
.source "ConfigXmlPullParser.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/config/ConfigXmlPullParser$SingletonHolder;
    }
.end annotation


# static fields
.field public static final CONFIG_PATH:Ljava/lang/String;

.field private static final TAG:Ljava/lang/String; = "XmlTagParser"


# instance fields
.field private mContext:Landroid/content/Context;

.field private xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 31
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, "/intercom/intercom_config.xml"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->CONFIG_PATH:Ljava/lang/String;

    return-void
.end method

.method private constructor <init>(Landroid/content/Context;)V
    .locals 0

    .line 35
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 36
    iput-object p1, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->mContext:Landroid/content/Context;

    .line 37
    invoke-static {}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getInstance()Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    return-void
.end method

.method synthetic constructor <init>(Landroid/content/Context;Lcom/pri/prizeinterphone/config/ConfigXmlPullParser-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;-><init>(Landroid/content/Context;)V

    return-void
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;
    .locals 1

    .line 45
    invoke-static {}, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser$SingletonHolder;->-$$Nest$sfgetINSTANCE()Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;

    move-result-object v0

    return-object v0
.end method

.method private parseChannel(Lorg/xmlpull/v1/XmlPullParser;Lcom/pri/prizeinterphone/config/data/InsertChannels;)V
    .locals 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/xmlpull/v1/XmlPullParserException;,
            Ljava/io/IOException;,
            Lcom/pri/prizeinterphone/config/data/InValidException;,
            Ljava/lang/NumberFormatException;
        }
    .end annotation

    .line 103
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->getEventType()I

    move-result v0

    const/4 v1, 0x0

    move-object v2, v1

    :goto_0
    const/4 v3, 0x1

    if-eq v0, v3, :cond_18

    .line 106
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->getName()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x2

    const-string v5, "XmlTagParser"

    if-eq v0, v4, :cond_2

    const/4 v4, 0x3

    if-eq v0, v4, :cond_0

    goto/16 :goto_3

    .line 237
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getChannelTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string v0, "==========END_TAG:channel=========="

    .line 238
    invoke-static {v5, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz v2, :cond_17

    .line 240
    invoke-virtual {p2}, Lcom/pri/prizeinterphone/config/data/InsertChannels;->getChannels()Ljava/util/ArrayList;

    move-result-object v0

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->build()Lcom/pri/prizeinterphone/config/data/InsertChannel;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto/16 :goto_3

    .line 242
    :cond_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getChannelsTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_17

    return-void

    .line 110
    :cond_2
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getChannelTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    const/4 v6, 0x0

    if-eqz v0, :cond_4

    .line 111
    new-instance v2, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    invoke-direct {v2}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;-><init>()V

    const-string v0, "==========START_TAG:channel=========="

    .line 112
    invoke-static {v5, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 115
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getChannelNameTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-interface {p1, v6}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeName(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 117
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getChannelNameTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v0

    invoke-interface {p1, v1, v0}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto :goto_1

    :cond_3
    const-string v0, ""

    .line 119
    :goto_1
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Channel Name: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 120
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getChannelTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 121
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withName(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 122
    :cond_4
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getSendfreqTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_5

    .line 123
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 124
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Send Frequency: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 125
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getSendfreqTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 126
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withSendfreq(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 127
    :cond_5
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getRecfreqTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 128
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 129
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Receive Frequency: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 130
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getRecfreqTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 131
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withRecfreq(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 132
    :cond_6
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getChanneltypeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_7

    .line 133
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 134
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Channel Type: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 135
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getChanneltypeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 136
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withChanneltype(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 137
    :cond_7
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getPowerTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_8

    .line 138
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 139
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "power: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 140
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getPowerTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 141
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withPower(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 144
    :cond_8
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getColorCodeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_9

    .line 145
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 146
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Color Mode: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 147
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getColorCodeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 148
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withColorcode(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 149
    :cond_9
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getSlotModeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_a

    .line 150
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 151
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Slot Mode: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 152
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getSlotModeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 153
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withSlotmode(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 154
    :cond_a
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getEncryptSwitchTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_b

    .line 155
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 156
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Encrypt Switch: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 157
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getEncryptSwitchTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 158
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withEncryptSwitch(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 159
    :cond_b
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getEncryptTextTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_c

    .line 160
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 161
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Encrypt Text: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 162
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getEncryptTextTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 163
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withEncryptText(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 164
    :cond_c
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getGroupValueTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_d

    .line 165
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 166
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Group Value: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 167
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getGroupValueTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 168
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withGroupvalue(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 169
    :cond_d
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getContacTypeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_f

    .line 171
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeCount()I

    move-result v0

    :goto_2
    if-ge v6, v0, :cond_17

    .line 173
    invoke-interface {p1, v6}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeName(I)Ljava/lang/String;

    move-result-object v3

    const-string/jumbo v4, "type"

    .line 174
    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_e

    .line 175
    invoke-interface {p1, v6}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(I)Ljava/lang/String;

    move-result-object v3

    .line 176
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "+++ contactType +++: "

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v5, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 177
    iget-object v4, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v4}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getContacTypeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v4

    invoke-virtual {v4}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 178
    invoke-virtual {v2, v3}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withContactype(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    :cond_e
    add-int/lit8 v6, v6, 0x1

    goto :goto_2

    .line 181
    :cond_f
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getNumber()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_10

    .line 182
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 183
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "number: "

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 185
    invoke-virtual {v2}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->build()Lcom/pri/prizeinterphone/config/data/InsertChannel;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getContactype()Ljava/lang/String;

    move-result-object v3

    .line 186
    invoke-static {v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v5

    if-eq v5, v4, :cond_17

    .line 188
    iget-object v4, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v4}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getNumber()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v4

    invoke-virtual {v4}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkDigitalTypeInvalid(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 189
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withNumber(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 191
    :cond_10
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getRecGroup()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_11

    .line 192
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 193
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "rec Group: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 194
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getRecGroup()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 195
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withRecGroup(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 199
    :cond_11
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getBandTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_12

    .line 200
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 201
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Band: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 202
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getBandTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 203
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withBand(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 204
    :cond_12
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getSquelchLevelTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_13

    .line 205
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 206
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Squelch Level: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 207
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getSquelchLevelTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 208
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withSquelchlevel(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 209
    :cond_13
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getRecvSubaudioTypeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_14

    .line 211
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 212
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Receive SubAudio Type: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 213
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getRecvSubaudioTypeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 214
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withRecvsubaudiotype(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 215
    :cond_14
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getSendSubaudioTypeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_15

    .line 216
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 217
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Send SubAudio Type: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 218
    iget-object v3, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getSendSubaudioTypeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 219
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withSendsubaudiotype(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto/16 :goto_3

    .line 220
    :cond_15
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getRecvsubaudiofreq()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_16

    .line 221
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 222
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Recv Subaudio Freq: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 224
    invoke-virtual {v2}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->build()Lcom/pri/prizeinterphone/config/data/InsertChannel;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getRecvsubaudiotype()Ljava/lang/String;

    move-result-object v3

    .line 225
    iget-object v4, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v4}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getNumber()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v4

    invoke-virtual {v4}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkAnalogTypeInvalid(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 226
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withRecvSubaudioFreq(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    goto :goto_3

    .line 227
    :cond_16
    iget-object v0, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getSendsubaudiofreq()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v0

    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_17

    .line 228
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v0

    .line 229
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Send Subaudio Freq: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 231
    invoke-virtual {v2}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->build()Lcom/pri/prizeinterphone/config/data/InsertChannel;

    move-result-object v3

    invoke-virtual {v3}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->getSendsubaudiotype()Ljava/lang/String;

    move-result-object v3

    .line 232
    iget-object v4, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v4}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getNumber()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v4

    invoke-virtual {v4}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4, v0}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkAnalogTypeInvalid(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 233
    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->withSendSubaudioFreq(Ljava/lang/String;)Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;

    .line 248
    :cond_17
    :goto_3
    invoke-interface {p1}, Lorg/xmlpull/v1/XmlPullParser;->next()I

    move-result v0

    goto/16 :goto_0

    :cond_18
    return-void
.end method


# virtual methods
.method public parse()Lcom/pri/prizeinterphone/config/data/ParseConfig;
    .locals 10

    const-string v0, "XmlTagParser"

    .line 49
    new-instance v1, Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;

    invoke-direct {v1}, Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;-><init>()V

    const/4 v2, 0x1

    .line 52
    :try_start_0
    invoke-static {}, Landroid/util/Xml;->newPullParser()Lorg/xmlpull/v1/XmlPullParser;

    move-result-object v3

    .line 53
    new-instance v4, Ljava/io/FileInputStream;

    sget-object v5, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->CONFIG_PATH:Ljava/lang/String;

    invoke-direct {v4, v5}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V

    .line 55
    sget-object v5, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v5}, Ljava/nio/charset/Charset;->name()Ljava/lang/String;

    move-result-object v5

    invoke-interface {v3, v4, v5}, Lorg/xmlpull/v1/XmlPullParser;->setInput(Ljava/io/InputStream;Ljava/lang/String;)V

    .line 57
    invoke-interface {v3}, Lorg/xmlpull/v1/XmlPullParser;->getEventType()I

    move-result v5

    .line 58
    new-instance v6, Lcom/pri/prizeinterphone/config/data/InsertConfig;

    invoke-direct {v6}, Lcom/pri/prizeinterphone/config/data/InsertConfig;-><init>()V

    :goto_0
    const/4 v7, 0x0

    if-eq v5, v2, :cond_5

    .line 60
    invoke-interface {v3}, Lorg/xmlpull/v1/XmlPullParser;->getName()Ljava/lang/String;

    move-result-object v8

    const/4 v9, 0x2

    if-eq v5, v9, :cond_1

    const/4 v7, 0x3

    if-eq v5, v7, :cond_0

    goto/16 :goto_1

    .line 85
    :cond_0
    iget-object v5, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v5}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getConfigTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v5

    invoke-virtual {v5, v8}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_4

    .line 86
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "config="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v0, v5}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 87
    invoke-virtual {v1, v6}, Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;->withInsertConfig(Lcom/pri/prizeinterphone/config/data/InsertConfig;)Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;

    goto/16 :goto_1

    .line 64
    :cond_1
    iget-object v5, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v5}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getLocalNumberTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v5

    invoke-virtual {v5, v8}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_2

    .line 66
    invoke-interface {v3}, Lorg/xmlpull/v1/XmlPullParser;->nextText()Ljava/lang/String;

    move-result-object v5

    .line 67
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "Local Number: "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v0, v7}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 68
    invoke-static {v5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v5

    invoke-virtual {v6, v5}, Lcom/pri/prizeinterphone/config/data/InsertConfig;->setLocalNumber(I)V

    goto :goto_1

    .line 69
    :cond_2
    iget-object v5, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v5}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getChannelsTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v5

    invoke-virtual {v5, v8}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_4

    const-string v5, ""

    .line 72
    iget-object v8, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v8}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getChannelsIdTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v8

    invoke-interface {v3, v7}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeName(I)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v8, v7}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->isAvailable(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_3

    const/4 v5, 0x0

    .line 73
    iget-object v7, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v7}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getChannelsIdTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v7

    invoke-virtual {v7}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v7

    invoke-interface {v3, v5, v7}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 75
    :cond_3
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "Channels id: "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v0, v7}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 76
    iget-object v7, p0, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->xmlTagManager:Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    invoke-virtual {v7}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->getChannelsIdTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;

    move-result-object v7

    invoke-virtual {v7}, Lcom/pri/prizeinterphone/config/tag/XmlTag;->getTag()Ljava/lang/String;

    move-result-object v7

    invoke-static {v7, v5}, Lcom/pri/prizeinterphone/config/tag/XmlTagValid;->checkInvalid(Ljava/lang/String;Ljava/lang/String;)V

    .line 77
    new-instance v7, Lcom/pri/prizeinterphone/config/data/InsertChannels;

    invoke-direct {v7}, Lcom/pri/prizeinterphone/config/data/InsertChannels;-><init>()V

    .line 78
    invoke-virtual {v6}, Lcom/pri/prizeinterphone/config/data/InsertConfig;->getInsertChannels()Landroid/util/SparseArray;

    move-result-object v8

    invoke-static {v5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v5

    invoke-virtual {v8, v5, v7}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 80
    invoke-direct {p0, v3, v7}, Lcom/pri/prizeinterphone/config/ConfigXmlPullParser;->parseChannel(Lorg/xmlpull/v1/XmlPullParser;Lcom/pri/prizeinterphone/config/data/InsertChannels;)V

    .line 91
    :cond_4
    :goto_1
    invoke-interface {v3}, Lorg/xmlpull/v1/XmlPullParser;->next()I

    move-result v5

    goto/16 :goto_0

    .line 93
    :cond_5
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V

    .line 94
    invoke-virtual {v1, v7}, Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;->withIsError(Z)Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    :catch_0
    move-exception p0

    const-string v3, "parse error"

    .line 96
    invoke-static {v0, v3, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 97
    invoke-virtual {v1, v2}, Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;->withIsError(Z)Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;

    .line 99
    :goto_2
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/config/data/ParseConfig$Builder;->build()Lcom/pri/prizeinterphone/config/data/ParseConfig;

    move-result-object p0

    return-object p0
.end method
