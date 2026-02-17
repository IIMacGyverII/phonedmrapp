.class public Lcom/pri/prizeinterphone/config/tag/XmlTagManager;
.super Ljava/lang/Object;
.source "XmlTagManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/config/tag/XmlTagManager$SingletonHolder;
    }
.end annotation


# instance fields
.field private bandTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private channelNameTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private channelTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private channelsIdTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private channelsTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private channeltypeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private colorCodeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private configTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private contacTypeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private encryptSwitchTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private encryptTextTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private groupValueTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private localNumberTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private number:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private powerTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private recGroup:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private recfreqTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private recvSubaudioTypeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private recvsubaudiofreq:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private sendSubaudioTypeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private sendfreqTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private sendsubaudiofreq:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private slotModeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

.field private squelchLevelTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;


# direct methods
.method private constructor <init>()V
    .locals 1

    .line 135
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 136
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/ConfigTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/ConfigTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->configTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 137
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/LocalNumberTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/LocalNumberTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->localNumberTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 138
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/ChannelsTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/ChannelsTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->channelsTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 139
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/ChannelsIdTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/ChannelsIdTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->channelsIdTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 140
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/ChannelTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/ChannelTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->channelTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 141
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/ChannelNameTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/ChannelNameTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->channelNameTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 142
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/SendFreqTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/SendFreqTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->sendfreqTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 144
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/RecFreqTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/RecFreqTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->recfreqTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 145
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/ChannelTypeTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/ChannelTypeTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->channeltypeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 147
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/PowerTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/PowerTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->powerTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 149
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/ColorCodeTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/ColorCodeTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->colorCodeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 151
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/SlotModeTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/SlotModeTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->slotModeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 152
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/ContacTypeTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/ContacTypeTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->contacTypeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 154
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/EncryptSwitchTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/EncryptSwitchTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->encryptSwitchTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 155
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/EncryptTextTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/EncryptTextTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->encryptTextTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 157
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/GroupValueTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/GroupValueTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->groupValueTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 158
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/RecvSubaudioTypeTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/RecvSubaudioTypeTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->recvSubaudioTypeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 159
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/SendSubaudioTypeTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/SendSubaudioTypeTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->sendSubaudioTypeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 160
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/BandTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/BandTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->bandTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 161
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/SquelchLevelTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/SquelchLevelTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->squelchLevelTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 164
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/RecvSubaudioFreqTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/RecvSubaudioFreqTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->recvsubaudiofreq:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 165
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/SendSubaudioFreqTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/SendSubaudioFreqTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->sendsubaudiofreq:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 167
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/NumberTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/NumberTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->number:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    .line 168
    new-instance v0, Lcom/pri/prizeinterphone/config/tag/RecGroupTag;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/tag/RecGroupTag;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->recGroup:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/prizeinterphone/config/tag/XmlTagManager-IA;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;-><init>()V

    return-void
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/config/tag/XmlTagManager;
    .locals 1

    .line 176
    invoke-static {}, Lcom/pri/prizeinterphone/config/tag/XmlTagManager$SingletonHolder;->-$$Nest$sfgetINSTANCE()Lcom/pri/prizeinterphone/config/tag/XmlTagManager;

    move-result-object v0

    return-object v0
.end method


# virtual methods
.method public getBandTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 123
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->bandTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getChannelNameTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 71
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->channelNameTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getChannelTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 67
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->channelTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getChannelsIdTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 63
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->channelsIdTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getChannelsTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 59
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->channelsTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getChanneltypeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 83
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->channeltypeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getColorCodeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 91
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->colorCodeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getConfigTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 55
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->configTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getContacTypeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 99
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->contacTypeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getEncryptSwitchTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 103
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->encryptSwitchTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getEncryptTextTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 107
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->encryptTextTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getGroupValueTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 111
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->groupValueTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getLocalNumberTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 131
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->localNumberTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getNumber()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 47
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->number:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getPowerTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 87
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->powerTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getRecGroup()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 51
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->recGroup:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getRecfreqTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 79
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->recfreqTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getRecvSubaudioTypeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 115
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->recvSubaudioTypeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getRecvsubaudiofreq()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 39
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->recvsubaudiofreq:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getSendSubaudioTypeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 119
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->sendSubaudioTypeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getSendfreqTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 75
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->sendfreqTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getSendsubaudiofreq()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 43
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->sendsubaudiofreq:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getSlotModeTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 95
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->slotModeTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method

.method public getSquelchLevelTag()Lcom/pri/prizeinterphone/config/tag/XmlTag;
    .locals 0

    .line 127
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/tag/XmlTagManager;->squelchLevelTag:Lcom/pri/prizeinterphone/config/tag/XmlTag;

    return-object p0
.end method
