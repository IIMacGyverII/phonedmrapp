.class public Lcom/pri/prizeinterphone/manager/DmrManager;
.super Ljava/lang/Object;
.source "DmrManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/manager/DmrManager$UpdateChannelDataNotificationListener;,
        Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;,
        Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;
    }
.end annotation


# static fields
.field private static final DEBUG_IS_SUPPORT_FRQC_BAND_U:Z = false

.field private static final DEBUG_IS_SUPPORT_FRQC_BAND_UV:Z = false

.field private static final DEBUG_IS_SUPPORT_FRQC_BAND_V:Z = false

.field private static final DEBUG_RELATED_MODULE_VER:Z = false

.field public static final TAG:Ljava/lang/String; = "DmrManager"

.field private static frqcBandName:Ljava/lang/String; = ""

.field private static moduleVersion:Ljava/lang/String; = ""

.field private static presenter:Lcom/pri/prizeinterphone/manager/DmrManager;


# instance fields
.field private background:Z

.field private channelListeners:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/manager/ChannelListener;",
            ">;"
        }
    .end annotation
.end field

.field private channels:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/serial/data/ChannelData;",
            ">;"
        }
    .end annotation
.end field

.field private chatId:I

.field private chatType:I

.field private contactListeners:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/manager/ContactLisenter;",
            ">;"
        }
    .end annotation
.end field

.field private currentChannel:Lcom/pri/prizeinterphone/serial/data/ChannelData;

.field private currentContact:Lcom/pri/prizeinterphone/serial/data/ContactData;

.field private dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

.field private dbConversationHelper:Lcom/pri/prizeinterphone/serial/data/UtilConversationData;

.field private dbMessageTool:Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

.field private dbRecordHelper:Lcom/pri/prizeinterphone/serial/data/UtilRecordData;

.field private interruptResultListeners:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/manager/InterruptResultListener;",
            ">;"
        }
    .end annotation
.end field

.field private isLauncher:Z

.field private isTestBitErrorRate:Z

.field private launchListeners:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/manager/LaunchListener;",
            ">;"
        }
    .end annotation
.end field

.field private localId:I

.field private mChannelIndex:I

.field private mHandler:Landroid/os/Handler;

.field private mInitChannelDataDB:Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

.field private mLastMsg:Lcom/pri/prizeinterphone/serial/data/MessageData;

.field private mMessageListenerLists:Landroid/util/ArrayMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/ArrayMap<",
            "Ljava/lang/Byte;",
            "Ljava/util/concurrent/CopyOnWriteArrayList<",
            "Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;",
            ">;>;"
        }
    .end annotation
.end field

.field private mUpdateChannelDataNotificationListener:Lcom/pri/prizeinterphone/manager/DmrManager$UpdateChannelDataNotificationListener;

.field private mUpdateChannelListListeners:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;",
            ">;"
        }
    .end annotation
.end field

.field private messageListeners:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/manager/MessageLisenter;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$_RvfhDvk8D8j-ny2jgBpT_ZwMOM(BLcom/pri/prizeinterphone/manager/InterruptResultListener;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->lambda$notifyInterruptReceive$0(BLcom/pri/prizeinterphone/manager/InterruptResultListener;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method private constructor <init>()V
    .locals 4

    .line 88
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 64
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->contactListeners:Ljava/util/List;

    .line 65
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->channelListeners:Ljava/util/List;

    .line 66
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->messageListeners:Ljava/util/List;

    .line 67
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->launchListeners:Ljava/util/List;

    .line 68
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->interruptResultListeners:Ljava/util/List;

    .line 72
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->channels:Ljava/util/List;

    const/4 v0, 0x1

    .line 75
    iput v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->localId:I

    .line 76
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "pref_person_contacts_selected_id"

    invoke-static {v1, v2, v0}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->chatId:I

    .line 77
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "pref_person_contacts_selected_type"

    const/4 v3, 0x0

    invoke-static {v1, v2, v3}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v1

    iput v1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->chatType:I

    .line 78
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->background:Z

    .line 79
    iput-boolean v3, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->isLauncher:Z

    .line 86
    iput-boolean v3, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->isTestBitErrorRate:Z

    .line 171
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mHandler:Landroid/os/Handler;

    .line 275
    iput v3, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mChannelIndex:I

    const/4 v0, 0x0

    .line 478
    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mLastMsg:Lcom/pri/prizeinterphone/serial/data/MessageData;

    .line 852
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mUpdateChannelListListeners:Ljava/util/ArrayList;

    .line 869
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mMessageListenerLists:Landroid/util/ArrayMap;

    return-void
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;
    .locals 1

    .line 91
    sget-object v0, Lcom/pri/prizeinterphone/manager/DmrManager;->presenter:Lcom/pri/prizeinterphone/manager/DmrManager;

    if-nez v0, :cond_0

    .line 92
    new-instance v0, Lcom/pri/prizeinterphone/manager/DmrManager;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/manager/DmrManager;->presenter:Lcom/pri/prizeinterphone/manager/DmrManager;

    .line 94
    :cond_0
    sget-object v0, Lcom/pri/prizeinterphone/manager/DmrManager;->presenter:Lcom/pri/prizeinterphone/manager/DmrManager;

    return-object v0
.end method

.method private getUVBandFromVersion(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    :try_start_0
    const-string p0, "\\."

    .line 1094
    invoke-virtual {p1, p0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1104
    array-length p1, p0

    const/4 v0, 0x4

    if-ne p1, v0, :cond_0

    const/4 p1, 0x2

    .line 1105
    aget-object p0, p0, p1

    return-object p0

    :cond_0
    const/4 p1, 0x1

    .line 1107
    aget-object p0, p0, p1

    return-object p0

    :catch_0
    move-exception p0

    const-string p1, "DmrManager"

    const-string v0, "getUVBandFromVersion,error"

    .line 1096
    invoke-static {p1, v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    const-string p0, "U"

    return-object p0
.end method

.method private initRelatedModuleVer()V
    .locals 3

    .line 1035
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "pref_person_device_dmr_version"

    const-string v2, "DMR003.UV4T.V022"

    invoke-static {v0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/pri/prizeinterphone/manager/DmrManager;->moduleVersion:Ljava/lang/String;

    .line 1036
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "initRelatedModuleVer,moduleVersion="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/pri/prizeinterphone/manager/DmrManager;->moduleVersion:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "DmrManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1037
    sget-object v0, Lcom/pri/prizeinterphone/manager/DmrManager;->moduleVersion:Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getUVBandFromVersion(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    sput-object p0, Lcom/pri/prizeinterphone/manager/DmrManager;->frqcBandName:Ljava/lang/String;

    .line 1038
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "initRelatedModuleVer,frqcBandName="

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v0, Lcom/pri/prizeinterphone/manager/DmrManager;->frqcBandName:Ljava/lang/String;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static synthetic lambda$notifyInterruptReceive$0(BLcom/pri/prizeinterphone/manager/InterruptResultListener;)V
    .locals 0

    .line 699
    invoke-static {p0}, Ljava/lang/Byte;->toUnsignedInt(B)I

    move-result p0

    invoke-interface {p1, p0}, Lcom/pri/prizeinterphone/manager/InterruptResultListener;->onReceiveInterrupt(I)V

    return-void
.end method

.method private playRingtoneDefault()V
    .locals 1

    const/4 p0, 0x2

    .line 737
    invoke-static {p0}, Landroid/media/RingtoneManager;->getDefaultUri(I)Landroid/net/Uri;

    move-result-object p0

    .line 738
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0, p0}, Landroid/media/RingtoneManager;->getRingtone(Landroid/content/Context;Landroid/net/Uri;)Landroid/media/Ringtone;

    move-result-object p0

    .line 739
    invoke-virtual {p0}, Landroid/media/Ringtone;->play()V

    return-void
.end method

.method private sendAnalogMessage(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 1

    .line 356
    new-instance p0, Lcom/pri/prizeinterphone/message/AnalogMessage;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/message/AnalogMessage;-><init>()V

    .line 357
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getBand()I

    move-result v0

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/message/AnalogMessage;->setBand(B)V

    .line 358
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getPower()I

    move-result v0

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/message/AnalogMessage;->setPower(B)V

    .line 359
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxFreq()I

    move-result v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/message/AnalogMessage;->setTxFreq(I)V

    .line 360
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRxFreq()I

    move-result v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/message/AnalogMessage;->setRxFreq(I)V

    .line 361
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getSq()I

    move-result v0

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/message/AnalogMessage;->setSq(B)V

    .line 362
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRxType()I

    move-result v0

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/message/AnalogMessage;->setRxType(B)V

    .line 363
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRxSubCode()I

    move-result v0

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/message/AnalogMessage;->setRxSubCode(B)V

    .line 364
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxType()I

    move-result v0

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/message/AnalogMessage;->setTxType(B)V

    .line 365
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxSubCode()I

    move-result v0

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/message/AnalogMessage;->setTxSubCode(B)V

    .line 366
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRelay()I

    move-result p1

    int-to-byte p1, p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/message/AnalogMessage;->setRelay(B)V

    .line 367
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method private sendDigitalMessage(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 3

    .line 330
    new-instance v0, Lcom/pri/prizeinterphone/message/DigitalMessage;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/message/DigitalMessage;-><init>()V

    .line 331
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getLocalId()I

    move-result v1

    iput v1, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->localId:I

    .line 332
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRxFreq()I

    move-result v1

    iput v1, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->rxFreq:I

    .line 333
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxFreq()I

    move-result v1

    iput v1, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txFreq:I

    .line 334
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getPower()I

    move-result v1

    int-to-byte v1, v1

    iput-byte v1, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->power:B

    .line 335
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getContactType()I

    move-result v1

    int-to-byte v1, v1

    iput-byte v1, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->contactType:B

    .line 336
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxContact()I

    move-result v1

    iput v1, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->txContact:I

    .line 337
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getCc()I

    move-result v1

    int-to-byte v1, v1

    iput-byte v1, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->cc:B

    .line 338
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getInBoundSlot()I

    move-result v1

    int-to-byte v1, v1

    iput-byte v1, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->inboundSlot:B

    .line 339
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getOutBoundSlot()I

    move-result v1

    int-to-byte v1, v1

    iput-byte v1, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->outboundSlot:B

    .line 340
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getChannelMode()I

    move-result v1

    int-to-byte v1, v1

    iput-byte v1, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->channelMode:B

    .line 341
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getEncryptSw()I

    move-result v1

    int-to-byte v1, v1

    iput-byte v1, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->encryptSw:B

    .line 342
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getEncryptKey()Ljava/lang/String;

    move-result-object v1

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getEncryptKey()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->getBytes()[B

    move-result-object p0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getByteDefault()[B

    move-result-object p0

    :goto_0
    iput-object p0, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->encryptKey:[B

    .line 343
    iget p0, p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->contactType:I

    const/4 v1, 0x1

    if-ne p0, v1, :cond_1

    .line 344
    iget-object p0, p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->groups:[I

    iput-object p0, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->groupList:[I

    .line 346
    :cond_1
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    const/4 v1, 0x0

    const-string v2, "pref_person_mic_gan_value"

    invoke-static {p0, v2, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result p0

    int-to-byte p0, p0

    iput-byte p0, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->mic:B

    .line 347
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRelay()I

    move-result p0

    int-to-byte p0, p0

    iput-byte p0, v0, Lcom/pri/prizeinterphone/message/DigitalMessage;->relay:B

    .line 348
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method private updateConversationTimestamp(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
    .locals 6

    .line 532
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/ConversationData;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/serial/data/ConversationData;-><init>()V

    .line 533
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getTimestamp()J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->setTimestamp(Ljava/lang/Long;)V

    .line 534
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getConvType()I

    move-result v1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->setConvType(I)V

    .line 537
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getDirection()I

    move-result v1

    const-string v2, ""

    const/4 v3, 0x1

    if-eqz v1, :cond_1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getConvType()I

    move-result v1

    if-ne v1, v3, :cond_0

    goto :goto_0

    .line 542
    :cond_0
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getFrom()I

    move-result v1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->setConvTarget(I)V

    .line 543
    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getConvType()I

    move-result v4

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getFrom()I

    move-result v5

    invoke-virtual {v1, v4, v5}, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;->getContact(II)Lcom/pri/prizeinterphone/serial/data/ContactData;

    move-result-object v1

    .line 544
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getFrom()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    goto :goto_1

    .line 538
    :cond_1
    :goto_0
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getTo()I

    move-result v1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->setConvTarget(I)V

    .line 539
    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getConvType()I

    move-result v4

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getTo()I

    move-result v5

    invoke-virtual {v1, v4, v5}, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;->getContact(II)Lcom/pri/prizeinterphone/serial/data/ContactData;

    move-result-object v1

    .line 540
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getTo()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    :goto_1
    if-eqz v1, :cond_2

    .line 548
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getNumber()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :cond_2

    .line 549
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ContactData;->getName()Ljava/lang/String;

    move-result-object v2

    .line 552
    :cond_2
    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->setName(Ljava/lang/String;)V

    .line 553
    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbConversationHelper:Lcom/pri/prizeinterphone/serial/data/UtilConversationData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getConvType()I

    move-result v2

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getConvTarget()I

    move-result v4

    invoke-virtual {v1, v2, v4}, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->getConversation(II)Lcom/pri/prizeinterphone/serial/data/ConversationData;

    move-result-object v1

    if-eqz v1, :cond_4

    .line 555
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getDirection()I

    move-result p1

    if-ne p1, v3, :cond_3

    .line 556
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->getUnReadCount()I

    move-result p1

    add-int/2addr p1, v3

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->setUnReadCount(I)V

    .line 558
    :cond_3
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbConversationHelper:Lcom/pri/prizeinterphone/serial/data/UtilConversationData;

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->updateConverstion(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V

    goto :goto_2

    .line 560
    :cond_4
    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbConversationHelper:Lcom/pri/prizeinterphone/serial/data/UtilConversationData;

    invoke-virtual {v1, v0}, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->addConversation(Lcom/pri/prizeinterphone/serial/data/ConversationData;)J

    move-result-wide v1

    long-to-int v1, v1

    .line 561
    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->setId(I)V

    .line 562
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getDirection()I

    move-result p1

    if-ne p1, v3, :cond_5

    .line 563
    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/serial/data/ConversationData;->setUnReadCount(I)V

    .line 565
    :cond_5
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbConversationHelper:Lcom/pri/prizeinterphone/serial/data/UtilConversationData;

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->updateConverstion(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V

    :goto_2
    return-void
.end method


# virtual methods
.method public addChannelListener(Lcom/pri/prizeinterphone/manager/ChannelListener;)V
    .locals 0

    .line 711
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->channelListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public addContactListener(Lcom/pri/prizeinterphone/manager/ContactLisenter;)V
    .locals 0

    .line 703
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->contactListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public addInterruptListener(Lcom/pri/prizeinterphone/manager/InterruptResultListener;)V
    .locals 0

    .line 691
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->interruptResultListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public addLaunchListener(Lcom/pri/prizeinterphone/manager/LaunchListener;)V
    .locals 0

    .line 687
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->launchListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public addMessageListener(Lcom/pri/prizeinterphone/manager/MessageLisenter;)V
    .locals 0

    .line 719
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->messageListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public addRecordDb(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)V
    .locals 2

    .line 136
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbRecordHelper:Lcom/pri/prizeinterphone/serial/data/UtilRecordData;

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->addRecordData(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)J

    move-result-wide v0

    .line 137
    invoke-virtual {p1, v0, v1}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->setId(J)V

    .line 138
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbRecordHelper:Lcom/pri/prizeinterphone/serial/data/UtilRecordData;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->updateRecordData(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)I

    move-result p0

    const/4 p1, 0x1

    if-ne p0, p1, :cond_0

    const-string p0, "DmrManager"

    const-string p1, "addRecordDb: success"

    .line 140
    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    return-void
.end method

.method public createChannel(Ljava/lang/String;Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 1

    .line 248
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mInitChannelDataDB:Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object p1

    invoke-virtual {p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->addChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 249
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateChannelList()V

    return-void
.end method

.method public declared-synchronized dealEvent(BLcom/pri/prizeinterphone/message/BaseMessage;)V
    .locals 1

    monitor-enter p0

    .line 890
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mMessageListenerLists:Landroid/util/ArrayMap;

    invoke-virtual {v0}, Landroid/util/ArrayMap;->isEmpty()Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    .line 891
    monitor-exit p0

    return-void

    .line 893
    :cond_0
    :try_start_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mMessageListenerLists:Landroid/util/ArrayMap;

    invoke-static {p1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroid/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/concurrent/CopyOnWriteArrayList;

    if-eqz p1, :cond_3

    .line 894
    invoke-virtual {p1}, Ljava/util/concurrent/CopyOnWriteArrayList;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_1

    .line 897
    :cond_1
    invoke-virtual {p1}, Ljava/util/concurrent/CopyOnWriteArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p1

    .line 898
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 899
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 901
    :try_start_2
    invoke-interface {v0, p2}, Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;->dealEvent(Lcom/pri/prizeinterphone/message/BaseMessage;)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 903
    :try_start_3
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    goto :goto_0

    .line 906
    :cond_2
    monitor-exit p0

    return-void

    .line 895
    :cond_3
    :goto_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public deleteAllSms(II)Z
    .locals 1

    .line 521
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbMessageTool:Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

    invoke-virtual {v0, p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->deleteAllSms(II)V

    const/4 p1, 0x0

    .line 522
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->notifyMessageDelete(Lcom/pri/prizeinterphone/serial/data/MessageData;)V

    const/4 p0, 0x1

    return p0
.end method

.method public deleteChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 1

    .line 253
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentDbHelper()Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->deleteChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 254
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateChannelList()V

    return-void
.end method

.method public deleteChannel(Ljava/lang/String;Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 1

    .line 258
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mInitChannelDataDB:Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object p1

    invoke-virtual {p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->deleteChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 259
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateChannelList()V

    return-void
.end method

.method public deleteContact(Lcom/pri/prizeinterphone/serial/data/ContactData;)Z
    .locals 1

    .line 631
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;->deleteContact(Lcom/pri/prizeinterphone/serial/data/ContactData;)V

    .line 632
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->notifyContactDelete(Lcom/pri/prizeinterphone/serial/data/ContactData;)V

    const/4 p0, 0x1

    return p0
.end method

.method public deleteConverList(Lcom/pri/prizeinterphone/serial/data/ConversationData;)Z
    .locals 0

    .line 527
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbConversationHelper:Lcom/pri/prizeinterphone/serial/data/UtilConversationData;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->deleteConverstion(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V

    const/4 p0, 0x1

    return p0
.end method

.method public deleteRecordFile(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)V
    .locals 0

    .line 132
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbRecordHelper:Lcom/pri/prizeinterphone/serial/data/UtilRecordData;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->removeRecordFile(Lcom/pri/prizeinterphone/serial/data/AudioRecordData;)I

    return-void
.end method

.method public deleteSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)Z
    .locals 1

    .line 515
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbMessageTool:Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->deleteSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)V

    .line 516
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->notifyMessageDelete(Lcom/pri/prizeinterphone/serial/data/MessageData;)V

    const/4 p0, 0x1

    return p0
.end method

.method public enhanceFunction(BI)V
    .locals 0

    .line 762
    new-instance p0, Lcom/pri/prizeinterphone/message/EnhanceMessage;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/message/EnhanceMessage;-><init>()V

    .line 763
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/EnhanceMessage;->fun:B

    .line 764
    iput p2, p0, Lcom/pri/prizeinterphone/message/EnhanceMessage;->callNum:I

    .line 765
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method public declared-synchronized errorEvent(B)V
    .locals 3

    monitor-enter p0

    .line 909
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mMessageListenerLists:Landroid/util/ArrayMap;

    invoke-virtual {v0}, Landroid/util/ArrayMap;->isEmpty()Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    .line 910
    monitor-exit p0

    return-void

    .line 912
    :cond_0
    :try_start_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mMessageListenerLists:Landroid/util/ArrayMap;

    invoke-static {p1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/concurrent/CopyOnWriteArrayList;

    if-eqz v0, :cond_3

    .line 913
    invoke-virtual {v0}, Ljava/util/concurrent/CopyOnWriteArrayList;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1

    goto :goto_1

    .line 916
    :cond_1
    invoke-virtual {v0}, Ljava/util/concurrent/CopyOnWriteArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    .line 917
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 918
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 920
    :try_start_2
    invoke-static {p1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v2

    invoke-interface {v1, v2}, Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;->errorEvent(Ljava/lang/Byte;)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_0

    :catch_0
    move-exception v1

    .line 922
    :try_start_3
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    goto :goto_0

    .line 925
    :cond_2
    monitor-exit p0

    return-void

    .line 914
    :cond_3
    :goto_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public getAllContacts()Ljava/util/ArrayList;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/ContactData;",
            ">;"
        }
    .end annotation

    .line 578
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;->getAllContacts()Ljava/util/ArrayList;

    move-result-object p0

    return-object p0
.end method

.method public getAllContacts(I)Ljava/util/ArrayList;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/ContactData;",
            ">;"
        }
    .end annotation

    .line 582
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;->getAllContacts(I)Ljava/util/ArrayList;

    move-result-object p0

    return-object p0
.end method

.method public getAllConversations()Ljava/util/ArrayList;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/ConversationData;",
            ">;"
        }
    .end annotation

    .line 638
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbConversationHelper:Lcom/pri/prizeinterphone/serial/data/UtilConversationData;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->getAllConversations()Ljava/util/ArrayList;

    move-result-object p0

    return-object p0
.end method

.method public getAllRecordList()Ljava/util/ArrayList;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/AudioRecordData;",
            ">;"
        }
    .end annotation

    .line 128
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbRecordHelper:Lcom/pri/prizeinterphone/serial/data/UtilRecordData;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;->getAllRecordFiles()Ljava/util/ArrayList;

    move-result-object p0

    return-object p0
.end method

.method public getAllSms(I)Ljava/util/ArrayList;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/MessageData;",
            ">;"
        }
    .end annotation

    .line 590
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbMessageTool:Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->getAllSms(I)Ljava/util/ArrayList;

    move-result-object p0

    return-object p0
.end method

.method public getAllSms(II)Ljava/util/ArrayList;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(II)",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/MessageData;",
            ">;"
        }
    .end annotation

    .line 594
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbMessageTool:Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->getAllSms(II)Ljava/util/ArrayList;

    move-result-object p0

    return-object p0
.end method

.method public getAllSms(Ljava/lang/String;)Ljava/util/ArrayList;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/ArrayList<",
            "Lcom/pri/prizeinterphone/serial/data/MessageData;",
            ">;"
        }
    .end annotation

    .line 586
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbMessageTool:Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->getAllSms(Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object p0

    return-object p0
.end method

.method public getBusyNoSend()Z
    .locals 2

    .line 1002
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "pref_person_busy_no_send"

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getBooleanData(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method public getByteDefault()[B
    .locals 3

    const/16 p0, 0x8

    new-array v0, p0, [B

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ge v2, p0, :cond_0

    .line 373
    aput-byte v1, v0, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public getChannelList()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/serial/data/ChannelData;",
            ">;"
        }
    .end annotation

    .line 220
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentDbHelper()Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->getAllChannels()Ljava/util/ArrayList;

    move-result-object p0

    return-object p0
.end method

.method public getChannelList(Ljava/lang/String;)Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Lcom/pri/prizeinterphone/serial/data/ChannelData;",
            ">;"
        }
    .end annotation

    .line 224
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mInitChannelDataDB:Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->getAllChannels()Ljava/util/ArrayList;

    move-result-object p0

    return-object p0
.end method

.method public getChatId()I
    .locals 0

    .line 296
    iget p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->chatId:I

    return p0
.end method

.method public getChatType()I
    .locals 0

    .line 304
    iget p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->chatType:I

    return p0
.end method

.method public getContact(I)Lcom/pri/prizeinterphone/serial/data/ContactData;
    .locals 0

    .line 602
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;->getContact(I)Lcom/pri/prizeinterphone/serial/data/ContactData;

    move-result-object p0

    return-object p0
.end method

.method public getContact(II)Lcom/pri/prizeinterphone/serial/data/ContactData;
    .locals 0

    .line 606
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;->getContact(II)Lcom/pri/prizeinterphone/serial/data/ContactData;

    move-result-object p0

    return-object p0
.end method

.method public getConversationData(II)Lcom/pri/prizeinterphone/serial/data/ConversationData;
    .locals 0

    .line 570
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbConversationHelper:Lcom/pri/prizeinterphone/serial/data/UtilConversationData;

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->getConversation(II)Lcom/pri/prizeinterphone/serial/data/ConversationData;

    move-result-object p0

    return-object p0
.end method

.method public getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;
    .locals 4

    const/4 v0, 0x0

    move v1, v0

    .line 263
    :goto_0
    iget-object v2, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->channels:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    const/4 v3, 0x1

    if-ge v1, v2, :cond_1

    .line 264
    iget-object v2, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->channels:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    iget v2, v2, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    if-ne v2, v3, :cond_0

    .line 265
    iput v1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mChannelIndex:I

    .line 266
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->channels:Ljava/util/List;

    invoke-interface {p0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    return-object p0

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 269
    :cond_1
    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->channels:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-ge v1, v3, :cond_2

    .line 270
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentDbHelper()Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->getAllChannels()Ljava/util/ArrayList;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->channels:Ljava/util/List;

    .line 272
    :cond_2
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->channels:Ljava/util/List;

    invoke-interface {p0, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/pri/prizeinterphone/serial/data/ChannelData;

    return-object p0
.end method

.method public getCurrentChannelIndex()I
    .locals 0

    .line 278
    iget p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mChannelIndex:I

    return p0
.end method

.method public getCurrentContact()Lcom/pri/prizeinterphone/serial/data/ContactData;
    .locals 0

    .line 321
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;->getActiveContact()Lcom/pri/prizeinterphone/serial/data/ContactData;

    move-result-object p0

    return-object p0
.end method

.method public getCurrentDbHelper()Lcom/pri/prizeinterphone/serial/data/UtilChannelData;
    .locals 1

    .line 228
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mInitChannelDataDB:Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/pri/prizeinterphone/constant/Constants;->getSelectedChannelArea(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object p0

    return-object p0
.end method

.method public getDefaultDbHelper()Lcom/pri/prizeinterphone/serial/data/UtilChannelData;
    .locals 1

    .line 232
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mInitChannelDataDB:Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->KEY_DEF_AREA:Ljava/lang/String;

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object p0

    return-object p0
.end method

.method public getInitChannelDataDB()Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;
    .locals 0

    .line 156
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mInitChannelDataDB:Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    return-object p0
.end method

.method public getLastSms(II)Lcom/pri/prizeinterphone/serial/data/MessageData;
    .locals 0

    .line 598
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbMessageTool:Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->getLastSms(II)Lcom/pri/prizeinterphone/serial/data/MessageData;

    move-result-object p0

    return-object p0
.end method

.method public getLaunchTime()I
    .locals 0

    const/16 p0, 0x3c

    return p0
.end method

.method public getLocalId()I
    .locals 0

    .line 284
    iget p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->localId:I

    return p0
.end method

.method public getVersionFromRes()Ljava/lang/String;
    .locals 9

    const-string p0, ""

    .line 1184
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v0

    .line 1187
    :try_start_0
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 1188
    invoke-virtual {v0, p0}, Landroid/content/res/AssetManager;->list(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    .line 1189
    array-length v2, v0

    const/4 v3, 0x0

    move v4, v3

    :goto_0
    if-ge v4, v2, :cond_1

    aget-object v5, v0, v4

    const-string v6, "DmrManager"

    .line 1190
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "getVersionNumberFromRes,"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v6, v7}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const-string v6, "DMR"

    .line 1191
    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_0

    const-string v6, "bin"

    invoke-virtual {v5, v6}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_0

    .line 1192
    invoke-virtual {v1, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_1

    :cond_0
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 1196
    :cond_1
    :goto_1
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_2

    .line 1199
    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    move-object p0, v0

    goto :goto_2

    .line 1197
    :cond_2
    new-instance v0, Ljava/lang/RuntimeException;

    const-string v1, "asset dir dmr firmware must only one"

    invoke-direct {v0, v1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    move-exception v0

    .line 1201
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    :goto_2
    return-object p0
.end method

.method public getVersionNumberFromModule()I
    .locals 3

    .line 1112
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "pref_person_device_dmr_version"

    const-string v1, "DMR003.UV4T.V022"

    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    const/4 v0, 0x0

    :try_start_0
    const-string v1, "\\."

    .line 1117
    invoke-virtual {p0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 1119
    array-length v1, p0

    const/4 v2, 0x4

    if-ne v1, v2, :cond_0

    const/4 v1, 0x3

    .line 1120
    aget-object p0, p0, v1

    goto :goto_0

    :cond_0
    const/4 v1, 0x2

    .line 1122
    aget-object p0, p0, v1

    :goto_0
    const-string v1, "\\d+"

    .line 1124
    invoke-static {v1}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v1

    .line 1125
    invoke-virtual {v1, p0}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object p0

    .line 1126
    invoke-virtual {p0}, Ljava/util/regex/Matcher;->find()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 1127
    invoke-virtual {p0}, Ljava/util/regex/Matcher;->group()Ljava/lang/String;

    move-result-object p0

    .line 1128
    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move v0, p0

    goto :goto_1

    :catch_0
    move-exception p0

    const-string v1, "DmrManager"

    const-string v2, "getUVBandFromVersion,error"

    .line 1133
    invoke-static {v1, v2, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_1
    :goto_1
    return v0
.end method

.method public getVersionNumberFromRes()I
    .locals 8

    .line 1145
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object p0

    const/4 v0, 0x0

    .line 1148
    :try_start_0
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    const-string v2, ""

    .line 1149
    invoke-virtual {p0, v2}, Landroid/content/res/AssetManager;->list(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 1150
    array-length v2, p0

    move v3, v0

    :goto_0
    if-ge v3, v2, :cond_1

    aget-object v4, p0, v3

    const-string v5, "DmrManager"

    .line 1151
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "getVersionNumberFromRes,"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const-string v5, "DMR"

    .line 1152
    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_0

    const-string v5, "bin"

    invoke-virtual {v4, v5}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_0

    .line 1153
    invoke-virtual {v1, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_1

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 1157
    :cond_1
    :goto_1
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result p0

    const/4 v2, 0x1

    if-ne p0, v2, :cond_3

    .line 1160
    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    const-string v1, "\\."

    .line 1163
    invoke-virtual {p0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 1164
    array-length v1, p0

    const/4 v2, 0x4

    if-ne v1, v2, :cond_2

    const/4 v1, 0x2

    .line 1165
    aget-object p0, p0, v1

    goto :goto_2

    :cond_2
    const/4 v1, 0x3

    .line 1167
    aget-object p0, p0, v1

    :goto_2
    const-string v1, "\\d+"

    .line 1169
    invoke-static {v1}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v1

    .line 1170
    invoke-virtual {v1, p0}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object p0

    .line 1171
    invoke-virtual {p0}, Ljava/util/regex/Matcher;->find()Z

    move-result v1

    if-eqz v1, :cond_4

    .line 1172
    invoke-virtual {p0}, Ljava/util/regex/Matcher;->group()Ljava/lang/String;

    move-result-object p0

    .line 1173
    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0

    move v0, p0

    goto :goto_3

    .line 1158
    :cond_3
    new-instance p0, Ljava/lang/RuntimeException;

    const-string v1, "asset dir dmr firmware must only one"

    invoke-direct {p0, v1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    move-exception p0

    .line 1178
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    :cond_4
    :goto_3
    return v0
.end method

.method public init()Z
    .locals 2

    .line 107
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbMessageTool:Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

    .line 108
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    .line 109
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbConversationHelper:Lcom/pri/prizeinterphone/serial/data/UtilConversationData;

    .line 110
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilRecordData;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbRecordHelper:Lcom/pri/prizeinterphone/serial/data/UtilRecordData;

    const/4 p0, 0x1

    return p0
.end method

.method public initChannelData()V
    .locals 3

    .line 146
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "pref_person_device_id"

    const/4 v2, 0x1

    invoke-static {v0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->localId:I

    .line 147
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mInitChannelDataDB:Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    .line 148
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/pri/prizeinterphone/constant/Constants;->getSelectedChannelArea(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->mCurrentChannelSelectIndex:Ljava/lang/String;

    .line 149
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mInitChannelDataDB:Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->isDBEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getDefaultDbHelper()Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->getAllChannels()Ljava/util/ArrayList;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-nez v0, :cond_1

    .line 150
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mInitChannelDataDB:Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->initChannelDb()V

    .line 152
    :cond_1
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateChannelList()V

    return-void
.end method

.method public initSerialPort()V
    .locals 0

    .line 160
    invoke-static {}, Lcom/pri/prizeinterphone/serial/SerialManager;->getInstance()Lcom/pri/prizeinterphone/serial/SerialManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/SerialManager;->init()Z

    return-void
.end method

.method public isLauncher()Z
    .locals 0

    .line 743
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->isLauncher:Z

    return p0
.end method

.method public isSendStatus()Z
    .locals 2

    .line 1014
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "pref_person_send_status"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result p0

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    move v1, v0

    :cond_0
    return v1
.end method

.method public isSupportOnlyUFrequencyBand()Z
    .locals 1

    .line 1059
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->initRelatedModuleVer()V

    .line 1063
    sget-object p0, Lcom/pri/prizeinterphone/manager/DmrManager;->frqcBandName:Ljava/lang/String;

    const-string v0, "UV"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-nez p0, :cond_0

    .line 1064
    sget-object p0, Lcom/pri/prizeinterphone/manager/DmrManager;->frqcBandName:Ljava/lang/String;

    const-string v0, "U"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public isSupportOnlyVFrequencyBand()Z
    .locals 1

    .line 1075
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->initRelatedModuleVer()V

    .line 1079
    sget-object p0, Lcom/pri/prizeinterphone/manager/DmrManager;->frqcBandName:Ljava/lang/String;

    const-string v0, "V"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public isSupportUVFrequencyBand()Z
    .locals 1

    .line 1044
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->initRelatedModuleVer()V

    .line 1048
    sget-object p0, Lcom/pri/prizeinterphone/manager/DmrManager;->frqcBandName:Ljava/lang/String;

    const-string v0, "UV"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public isTestBitErrorRate()Z
    .locals 0

    .line 124
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->isTestBitErrorRate:Z

    return p0
.end method

.method public launchCommand()V
    .locals 1

    .line 747
    new-instance p0, Lcom/pri/prizeinterphone/message/LaunchMessage;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/message/LaunchMessage;-><init>()V

    const/4 v0, 0x1

    .line 748
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/LaunchMessage;->launch:B

    .line 749
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method public launchEnd()V
    .locals 1

    .line 769
    new-instance p0, Lcom/pri/prizeinterphone/message/LaunchMessage;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/message/LaunchMessage;-><init>()V

    const/4 v0, 0x2

    .line 770
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/LaunchMessage;->launch:B

    .line 771
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method public needSaveRecordFile()Z
    .locals 2

    .line 986
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "pref_person_ptt_record"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getBooleanData(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method public notifyContactAdded(Lcom/pri/prizeinterphone/serial/data/ContactData;)V
    .locals 1

    .line 668
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->contactListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/manager/ContactLisenter;

    .line 669
    invoke-interface {v0, p1}, Lcom/pri/prizeinterphone/manager/ContactLisenter;->onContactAdded(Lcom/pri/prizeinterphone/serial/data/ContactData;)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public notifyContactDelete(Lcom/pri/prizeinterphone/serial/data/ContactData;)V
    .locals 1

    .line 674
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->contactListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/manager/ContactLisenter;

    .line 675
    invoke-interface {v0, p1}, Lcom/pri/prizeinterphone/manager/ContactLisenter;->onContactRemoved(Lcom/pri/prizeinterphone/serial/data/ContactData;)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public notifyContactUpdate(Lcom/pri/prizeinterphone/serial/data/ContactData;)V
    .locals 3

    .line 680
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->contactListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/manager/ContactLisenter;

    .line 681
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "listener="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "fzc"

    invoke-static {v2, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 682
    invoke-interface {v0, p1}, Lcom/pri/prizeinterphone/manager/ContactLisenter;->onContactUpdated(Lcom/pri/prizeinterphone/serial/data/ContactData;)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public notifyInterruptReceive(B)V
    .locals 1

    .line 699
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->interruptResultListeners:Ljava/util/List;

    new-instance v0, Lcom/pri/prizeinterphone/manager/DmrManager$$ExternalSyntheticLambda0;

    invoke-direct {v0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager$$ExternalSyntheticLambda0;-><init>(B)V

    invoke-interface {p0, v0}, Ljava/util/List;->forEach(Ljava/util/function/Consumer;)V

    return-void
.end method

.method public notifyMessageDelete(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
    .locals 1

    .line 661
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->messageListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/manager/MessageLisenter;

    .line 662
    invoke-interface {v0, p1}, Lcom/pri/prizeinterphone/manager/MessageLisenter;->onMessageDelete(Lcom/pri/prizeinterphone/serial/data/MessageData;)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public notifyMessageReceive()V
    .locals 1

    .line 649
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->messageListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/manager/MessageLisenter;

    .line 650
    invoke-interface {v0}, Lcom/pri/prizeinterphone/manager/MessageLisenter;->onMessageReceived()V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public notifyMessageSend(Lcom/pri/prizeinterphone/serial/data/MessageData;)V
    .locals 1

    .line 642
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->messageListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/manager/MessageLisenter;

    .line 643
    invoke-interface {v0, p1}, Lcom/pri/prizeinterphone/manager/MessageLisenter;->onMessageSend(Lcom/pri/prizeinterphone/serial/data/MessageData;)V

    .line 644
    invoke-interface {v0}, Lcom/pri/prizeinterphone/manager/MessageLisenter;->onUnreadStatusUpdated()V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public notifyUnreadChange()V
    .locals 1

    .line 655
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->messageListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/manager/MessageLisenter;

    .line 656
    invoke-interface {v0}, Lcom/pri/prizeinterphone/manager/MessageLisenter;->onUnreadStatusUpdated()V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public onChannelBusy()V
    .locals 0

    return-void
.end method

.method public onModuleInited()V
    .locals 0

    .line 168
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateModuleInit()V

    return-void
.end method

.method public onModuleStatusReceived(B)V
    .locals 1

    const/4 v0, 0x1

    if-ne p1, v0, :cond_0

    .line 380
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->onReceiveStart()V

    goto :goto_0

    :cond_0
    const/4 v0, 0x2

    if-ne p1, v0, :cond_1

    .line 382
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->onReceiveStop()V

    goto :goto_0

    :cond_1
    const/4 v0, 0x3

    if-ne p1, v0, :cond_2

    .line 384
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->onSendStart()V

    goto :goto_0

    :cond_2
    const/4 v0, 0x4

    if-ne p1, v0, :cond_3

    .line 386
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->onSendStop()V

    goto :goto_0

    :cond_3
    const/4 v0, 0x6

    if-ne p1, v0, :cond_4

    .line 388
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->onSendTimeout()V

    goto :goto_0

    :cond_4
    const/4 v0, 0x5

    if-ne p1, v0, :cond_5

    .line 390
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->onNewSmsNotify()V

    goto :goto_0

    :cond_5
    const/16 v0, 0x8

    if-ne p1, v0, :cond_6

    .line 392
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->onSmsSendSuccess()V

    goto :goto_0

    :cond_6
    const/16 v0, 0x9

    if-ne p1, v0, :cond_7

    .line 394
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->onSmsSendFail()V

    goto :goto_0

    :cond_7
    const/4 v0, 0x7

    if-ne p1, v0, :cond_8

    .line 396
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->onChannelBusy()V

    :cond_8
    :goto_0
    return-void
.end method

.method public onNewSmsNotify()V
    .locals 0

    .line 439
    new-instance p0, Lcom/pri/prizeinterphone/message/FetchSmsMessage;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/message/FetchSmsMessage;-><init>()V

    .line 440
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method public onReceiveStart()V
    .locals 1

    .line 401
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->launchListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/manager/LaunchListener;

    .line 402
    invoke-interface {v0}, Lcom/pri/prizeinterphone/manager/LaunchListener;->onReceiveStart()V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public onReceiveStop()V
    .locals 1

    .line 407
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->launchListeners:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/manager/LaunchListener;

    .line 408
    invoke-interface {v0}, Lcom/pri/prizeinterphone/manager/LaunchListener;->onReceiveStop()V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public onSendStart()V
    .locals 2

    .line 413
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->launchListeners:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/manager/LaunchListener;

    .line 414
    invoke-interface {v1}, Lcom/pri/prizeinterphone/manager/LaunchListener;->onSendStart()V

    goto :goto_0

    :cond_0
    const/4 v0, 0x1

    .line 416
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->isLauncher:Z

    return-void
.end method

.method public onSendStop()V
    .locals 2

    .line 420
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->launchListeners:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/manager/LaunchListener;

    .line 421
    invoke-interface {v1}, Lcom/pri/prizeinterphone/manager/LaunchListener;->onSendStop()V

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 423
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->isLauncher:Z

    return-void
.end method

.method public onSendTimeout()V
    .locals 2

    .line 427
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->launchListeners:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/pri/prizeinterphone/manager/LaunchListener;

    .line 428
    invoke-interface {v1}, Lcom/pri/prizeinterphone/manager/LaunchListener;->onSendTimeout()V

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 430
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->isLauncher:Z

    return-void
.end method

.method public onSmsReceived(Lcom/pri/prizeinterphone/message/FetchSmsMessage;)V
    .locals 4

    .line 444
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onSmsReceived: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/message/FetchSmsMessage;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "DmrManager"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 445
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/serial/data/MessageData;-><init>()V

    const/4 v1, 0x1

    .line 446
    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setDirection(I)V

    const/4 v2, 0x0

    .line 447
    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setStatus(I)V

    .line 448
    iget-byte v2, p1, Lcom/pri/prizeinterphone/message/FetchSmsMessage;->type:B

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setConvType(I)V

    .line 449
    iget v2, p1, Lcom/pri/prizeinterphone/message/FetchSmsMessage;->callID:I

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setFrom(I)V

    .line 450
    iget-byte v2, p1, Lcom/pri/prizeinterphone/message/FetchSmsMessage;->type:B

    if-ne v2, v1, :cond_0

    .line 451
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v1

    .line 452
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxContact()I

    move-result v1

    .line 453
    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setTo(I)V

    .line 454
    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setConv_target(I)V

    goto :goto_0

    .line 456
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v2

    const-string v3, "pref_person_device_id"

    invoke-static {v2, v3, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setTo(I)V

    .line 457
    iget v1, p1, Lcom/pri/prizeinterphone/message/FetchSmsMessage;->callID:I

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setConv_target(I)V

    .line 459
    :goto_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setTimestamp(J)V

    .line 460
    iget-object p1, p1, Lcom/pri/prizeinterphone/message/FetchSmsMessage;->msgContent:Ljava/lang/String;

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setContent(Ljava/lang/String;)V

    .line 462
    iget-object p1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbMessageTool:Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->addSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)Ljava/lang/Long;

    .line 463
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->background:Z

    if-eqz p1, :cond_1

    .line 464
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->playRingtoneDefault()V

    .line 466
    :cond_1
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateConversationTimestamp(Lcom/pri/prizeinterphone/serial/data/MessageData;)V

    .line 467
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->notifyMessageReceive()V

    return-void
.end method

.method public onSmsSendFail()V
    .locals 3

    .line 508
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mLastMsg:Lcom/pri/prizeinterphone/serial/data/MessageData;

    const/4 v1, 0x3

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setStatus(I)V

    .line 509
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbMessageTool:Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mLastMsg:Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->updateSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)I

    move-result v0

    .line 510
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onSmsSendFail saveSms: result ="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "DmrManager"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 511
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mLastMsg:Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->notifyMessageSend(Lcom/pri/prizeinterphone/serial/data/MessageData;)V

    return-void
.end method

.method public onSmsSendSuccess()V
    .locals 2

    .line 501
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mLastMsg:Lcom/pri/prizeinterphone/serial/data/MessageData;

    const/4 v1, 0x2

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->setStatus(I)V

    .line 502
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbMessageTool:Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mLastMsg:Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->updateSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)I

    .line 504
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mLastMsg:Lcom/pri/prizeinterphone/serial/data/MessageData;

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->notifyMessageSend(Lcom/pri/prizeinterphone/serial/data/MessageData;)V

    return-void
.end method

.method public onVersionReceived(Lcom/pri/prizeinterphone/message/VersionMessage;)V
    .locals 3

    const-string v0, "DmrManager"

    const-string v1, "onVersionReceived start"

    .line 939
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz p1, :cond_0

    .line 941
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    iget-object p1, p1, Lcom/pri/prizeinterphone/message/VersionMessage;->versionName:Ljava/lang/String;

    const-string v2, "pref_person_device_dmr_version"

    invoke-static {v1, v2, p1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 946
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/constant/Constants;->initDefChannelAreas()V

    .line 948
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->initChannelData()V

    const-string p0, "onVersionReceived end"

    .line 949
    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public playEndPromptTone()Z
    .locals 2

    .line 994
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "pref_person_ptt_end_tone"

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getBooleanData(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method public playStartPromptTone()Z
    .locals 2

    .line 990
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "pref_person_ptt_start_tone"

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getBooleanData(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method public queryInitStatus()V
    .locals 0

    .line 727
    new-instance p0, Lcom/pri/prizeinterphone/message/InitMessage;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/message/InitMessage;-><init>()V

    .line 728
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method public declared-synchronized registerEventListener(BLcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V
    .locals 2

    monitor-enter p0

    .line 880
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mMessageListenerLists:Landroid/util/ArrayMap;

    invoke-static {p1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/util/ArrayMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 881
    new-instance v0, Ljava/util/concurrent/CopyOnWriteArrayList;

    invoke-direct {v0}, Ljava/util/concurrent/CopyOnWriteArrayList;-><init>()V

    .line 882
    invoke-virtual {v0, p2}, Ljava/util/concurrent/CopyOnWriteArrayList;->add(Ljava/lang/Object;)Z

    .line 883
    iget-object p2, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mMessageListenerLists:Landroid/util/ArrayMap;

    invoke-static {p1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object p1

    invoke-virtual {p2, p1, v0}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    .line 885
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mMessageListenerLists:Landroid/util/ArrayMap;

    invoke-static {p1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroid/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/concurrent/CopyOnWriteArrayList;

    invoke-virtual {p1, p2}, Ljava/util/concurrent/CopyOnWriteArrayList;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 887
    :goto_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public registerUpdateListener(Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;)V
    .locals 0

    .line 855
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mUpdateChannelListListeners:Ljava/util/ArrayList;

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public relayCommand()V
    .locals 1

    .line 753
    new-instance v0, Lcom/pri/prizeinterphone/message/RelayMessage;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/message/RelayMessage;-><init>()V

    .line 754
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object p0

    .line 755
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getRelay()I

    move-result p0

    int-to-byte p0, p0

    iput-byte p0, v0, Lcom/pri/prizeinterphone/message/RelayMessage;->relay:B

    .line 756
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method public releaseSerialPort()V
    .locals 0

    .line 164
    invoke-static {}, Lcom/pri/prizeinterphone/serial/SerialManager;->getInstance()Lcom/pri/prizeinterphone/serial/SerialManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/SerialManager;->release()V

    return-void
.end method

.method public removeContactListener(Lcom/pri/prizeinterphone/manager/ContactLisenter;)V
    .locals 0

    .line 707
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->contactListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    return-void
.end method

.method public removeInterruptListener(Lcom/pri/prizeinterphone/manager/InterruptResultListener;)V
    .locals 0

    .line 695
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->interruptResultListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    return-void
.end method

.method public removeMessageListener(Lcom/pri/prizeinterphone/manager/ChannelListener;)V
    .locals 0

    .line 715
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->channelListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    return-void
.end method

.method public removeMessageListener(Lcom/pri/prizeinterphone/manager/MessageLisenter;)V
    .locals 0

    .line 723
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->messageListeners:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    return-void
.end method

.method public resetData()V
    .locals 1

    const/4 v0, 0x1

    .line 953
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->resetData(Z)V

    return-void
.end method

.method public resetData(Z)V
    .locals 5

    const/4 v0, 0x1

    .line 957
    iput v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->localId:I

    .line 958
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "pref_person_device_id"

    invoke-static {v1, v2, v0}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putIntData(Landroid/content/Context;Ljava/lang/String;I)V

    .line 959
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "pref_person_limit_send_time"

    const/16 v3, 0x1e

    invoke-static {v1, v2, v3}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putIntData(Landroid/content/Context;Ljava/lang/String;I)V

    .line 960
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "pref_person_ptt_start_tone"

    invoke-static {v1, v2, v0}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putBooleanData(Landroid/content/Context;Ljava/lang/String;Z)V

    .line 961
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "pref_person_ptt_end_tone"

    invoke-static {v1, v2, v0}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putBooleanData(Landroid/content/Context;Ljava/lang/String;Z)V

    .line 962
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "pref_person_ptt_record"

    const/4 v3, 0x0

    invoke-static {v1, v2, v3}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putBooleanData(Landroid/content/Context;Ljava/lang/String;Z)V

    .line 963
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    sget-object v2, Lcom/pri/prizeinterphone/constant/Constants;->KEY_DEF_AREA:Ljava/lang/String;

    const-string v4, "pref_person_channel_area_selected_index"

    invoke-static {v1, v4, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 964
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    const-string v2, "pref_person_busy_no_send"

    invoke-static {v1, v2, v0}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putBooleanData(Landroid/content/Context;Ljava/lang/String;Z)V

    .line 965
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "pref_person_mic_gan_value"

    invoke-static {v0, v1, v3}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putIntData(Landroid/content/Context;Ljava/lang/String;I)V

    .line 966
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mInitChannelDataDB:Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->resetData(Z)V

    .line 967
    iget-object p1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;->resetData()V

    .line 968
    iget-object p1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbConversationHelper:Lcom/pri/prizeinterphone/serial/data/UtilConversationData;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->resetData()V

    .line 969
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->notifyUnreadChange()V

    .line 970
    iget-object p1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbMessageTool:Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->resetData()V

    .line 971
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateChannelList()V

    .line 972
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->syncChannelInfo()V

    return-void
.end method

.method public restartApp()V
    .locals 6

    .line 1208
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    new-instance v0, Landroid/content/Intent;

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v1

    const-class v2, Lcom/pri/prizeinterphone/InterPhoneService;

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Landroid/content/Context;->stopService(Landroid/content/Intent;)Z

    .line 1209
    invoke-static {}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->getInstance()Lcom/pri/prizeinterphone/ymodem/YModemManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->releaseYModem()V

    .line 1210
    invoke-static {}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->getInstance()Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->pullDownPwdFoot()V

    .line 1211
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->releaseSerialPort()V

    .line 1214
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p0

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;

    move-result-object p0

    .line 1215
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    const/high16 v2, 0x4000000

    invoke-static {v0, v1, p0, v2}, Landroid/app/PendingIntent;->getActivity(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object p0

    .line 1216
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v2, "alarm"

    invoke-virtual {v0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/AlarmManager;

    .line 1217
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    const-wide/16 v4, 0x3e8

    add-long/2addr v2, v4

    const/4 v4, 0x1

    invoke-virtual {v0, v4, v2, v3, p0}, Landroid/app/AlarmManager;->set(IJLandroid/app/PendingIntent;)V

    .line 1218
    invoke-static {v1}, Ljava/lang/System;->exit(I)V

    return-void
.end method

.method public saveContact(Lcom/pri/prizeinterphone/serial/data/ContactData;)Z
    .locals 4

    .line 620
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;->addContact()J

    move-result-wide v0

    long-to-int v2, v0

    .line 622
    invoke-virtual {p1, v2}, Lcom/pri/prizeinterphone/serial/data/ContactData;->setId(I)V

    .line 623
    iget-object v2, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    invoke-virtual {v2, p1}, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;->updateContact(Lcom/pri/prizeinterphone/serial/data/ContactData;)Z

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-lez v0, :cond_0

    .line 625
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->notifyContactAdded(Lcom/pri/prizeinterphone/serial/data/ContactData;)V

    :cond_0
    if-lez v0, :cond_1

    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public saveSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)Z
    .locals 1

    .line 471
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbMessageTool:Lcom/pri/prizeinterphone/serial/data/UtilMessageData;

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilMessageData;->addSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)Ljava/lang/Long;

    .line 472
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateConversationTimestamp(Lcom/pri/prizeinterphone/serial/data/MessageData;)V

    .line 474
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)Z

    move-result p0

    return p0
.end method

.method public sendQueryInitializedCmdToMdl()V
    .locals 0

    .line 786
    new-instance p0, Lcom/pri/prizeinterphone/message/QueryInitMessage;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/message/QueryInitMessage;-><init>()V

    .line 787
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method public sendQueryVersionCmdToMdl()V
    .locals 0

    .line 778
    new-instance p0, Lcom/pri/prizeinterphone/message/VersionMessage;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/message/VersionMessage;-><init>()V

    .line 779
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method public sendSetChannelCmdToMdl()V
    .locals 1

    .line 821
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 823
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getType()I

    move-result v0

    if-nez v0, :cond_0

    .line 824
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendDigitalMessage(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    goto :goto_0

    .line 826
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendAnalogMessage(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public sendSetChannelCmdToMdl(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 0

    if-eqz p1, :cond_1

    .line 833
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getType()I

    move-result p0

    if-nez p0, :cond_0

    .line 834
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendDigitalMessage(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    goto :goto_0

    .line 836
    :cond_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendAnalogMessage(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    goto :goto_0

    .line 839
    :cond_1
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendSetChannelCmdToMdl()V

    :goto_0
    return-void
.end method

.method public sendSetMicGainCmdToMdl()V
    .locals 3

    .line 847
    new-instance p0, Lcom/pri/prizeinterphone/message/MicMessage;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/message/MicMessage;-><init>()V

    .line 848
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "pref_person_mic_gan_value"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    int-to-byte v0, v0

    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/MicMessage;->gain:B

    .line 849
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method public sendSetTotCmdToMdl()V
    .locals 1

    .line 794
    new-instance p0, Lcom/pri/prizeinterphone/message/TotMessage;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/message/TotMessage;-><init>()V

    const/4 v0, 0x0

    .line 795
    iput-byte v0, p0, Lcom/pri/prizeinterphone/message/TotMessage;->tot:B

    .line 796
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method public sendSms(Lcom/pri/prizeinterphone/serial/data/MessageData;)Z
    .locals 5

    .line 481
    new-instance v0, Lcom/pri/prizeinterphone/message/SendSmsMessage;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/message/SendSmsMessage;-><init>()V

    .line 482
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v1

    .line 484
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getContactType()I

    move-result v2

    const/4 v3, 0x1

    if-nez v2, :cond_0

    .line 485
    invoke-virtual {v0, v3}, Lcom/pri/prizeinterphone/message/SendSmsMessage;->setMsgType(B)V

    goto :goto_0

    .line 486
    :cond_0
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getContactType()I

    move-result v2

    if-ne v2, v3, :cond_1

    const/4 v2, 0x3

    .line 487
    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/message/SendSmsMessage;->setMsgType(B)V

    goto :goto_0

    .line 489
    :cond_1
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getContactType()I

    move-result v2

    const/4 v4, 0x2

    if-ne v2, v4, :cond_2

    .line 490
    invoke-virtual {v0, v4}, Lcom/pri/prizeinterphone/message/SendSmsMessage;->setMsgType(B)V

    .line 492
    :cond_2
    :goto_0
    invoke-virtual {v1}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getTxContact()I

    move-result v1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/message/SendSmsMessage;->setCallNumber(I)V

    .line 493
    invoke-virtual {p1}, Lcom/pri/prizeinterphone/serial/data/MessageData;->getContent()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/message/SendSmsMessage;->setMsgContent(Ljava/lang/String;)V

    .line 494
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    .line 495
    iput-object p1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mLastMsg:Lcom/pri/prizeinterphone/serial/data/MessageData;

    .line 496
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->notifyMessageSend(Lcom/pri/prizeinterphone/serial/data/MessageData;)V

    return v3
.end method

.method public sendTransmissionInterruptCmdToMdl()V
    .locals 1

    .line 803
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentChannel()Lcom/pri/prizeinterphone/serial/data/ChannelData;

    move-result-object v0

    .line 804
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/ChannelData;->getInterrupt()I

    move-result v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->sendTransmissionInterruptCmdToMdl(I)V

    return-void
.end method

.method public sendTransmissionInterruptCmdToMdl(I)V
    .locals 0

    .line 812
    new-instance p0, Lcom/pri/prizeinterphone/message/InterruptMessage;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/message/InterruptMessage;-><init>()V

    int-to-byte p1, p1

    .line 813
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/InterruptMessage;->interrupt:B

    .line 814
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method public setChatId(I)V
    .locals 0

    .line 300
    iput p1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->chatId:I

    return-void
.end method

.method public setChatType(I)V
    .locals 0

    .line 308
    iput p1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->chatType:I

    return-void
.end method

.method public setLaunchTime(I)V
    .locals 0

    return-void
.end method

.method public setLocalId(I)V
    .locals 2

    .line 288
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "pref_person_device_id"

    invoke-static {v0, v1, p1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putIntData(Landroid/content/Context;Ljava/lang/String;I)V

    .line 289
    iget v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->localId:I

    if-eq v0, p1, :cond_0

    .line 290
    iput p1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->localId:I

    .line 291
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->syncChannelInfo()V

    :cond_0
    return-void
.end method

.method public setSendStatus(I)V
    .locals 1

    .line 1010
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "pref_person_send_status"

    invoke-static {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putIntData(Landroid/content/Context;Ljava/lang/String;I)V

    return-void
.end method

.method public setSmsProtocol()V
    .locals 0

    .line 732
    new-instance p0, Lcom/pri/prizeinterphone/message/SmsProtocolMessage;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/message/SmsProtocolMessage;-><init>()V

    .line 733
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method public setTestBitErrorRate(Z)V
    .locals 0

    .line 120
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->isTestBitErrorRate:Z

    return-void
.end method

.method public setUpdateChannelDataNotificationListener(Lcom/pri/prizeinterphone/manager/DmrManager$UpdateChannelDataNotificationListener;)V
    .locals 0

    .line 978
    iput-object p1, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mUpdateChannelDataNotificationListener:Lcom/pri/prizeinterphone/manager/DmrManager$UpdateChannelDataNotificationListener;

    return-void
.end method

.method public syncChannelInfo()V
    .locals 2

    const-string p0, "DmrManager"

    const-string/jumbo v0, "syncChannelInfo"

    .line 182
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 183
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object p0

    .line 184
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->startCmdMachine()V

    .line 185
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->transitionToSetChannelStateState()V

    const/4 v0, 0x0

    .line 186
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->setChannelData(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    const/16 v0, 0xa

    .line 187
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/pri/prizeinterphone/state/StateMachine;->deferMessage(Landroid/os/Message;)V

    .line 188
    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    return-void
.end method

.method public syncChannelInfo(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 1

    .line 175
    iget p1, p1, Lcom/pri/prizeinterphone/serial/data/ChannelData;->active:I

    const/4 v0, 0x1

    if-ne p1, v0, :cond_0

    .line 176
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->syncChannelInfo()V

    goto :goto_0

    :cond_0
    const-string p0, "DmrManager"

    const-string p1, "only active channel can syncChannelInfo"

    .line 178
    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method public syncChannelInfoWithData(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 1

    const-string p0, "DmrManager"

    const-string/jumbo v0, "syncChannelInfoWithData"

    .line 192
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 193
    invoke-static {}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->getInstance()Lcom/pri/prizeinterphone/state/CmdStateMachine;

    move-result-object p0

    .line 194
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->startCmdMachine()V

    .line 195
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->transitionToSetChannelStateState()V

    .line 196
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/CmdStateMachine;->setChannelData(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    const/16 p1, 0xa

    .line 197
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/state/StateMachine;->deferMessage(Landroid/os/Message;)V

    .line 198
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/state/StateMachine;->sendMessage(Landroid/os/Message;)V

    return-void
.end method

.method public declared-synchronized unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V
    .locals 1

    monitor-enter p0

    .line 928
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mMessageListenerLists:Landroid/util/ArrayMap;

    invoke-virtual {v0, p1}, Landroid/util/ArrayMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 929
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mMessageListenerLists:Landroid/util/ArrayMap;

    invoke-virtual {v0, p1}, Landroid/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/concurrent/CopyOnWriteArrayList;

    invoke-virtual {v0, p2}, Ljava/util/concurrent/CopyOnWriteArrayList;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 930
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mMessageListenerLists:Landroid/util/ArrayMap;

    invoke-virtual {v0, p1}, Landroid/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/concurrent/CopyOnWriteArrayList;

    invoke-virtual {v0, p2}, Ljava/util/concurrent/CopyOnWriteArrayList;->remove(Ljava/lang/Object;)Z

    .line 932
    :cond_0
    iget-object p2, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mMessageListenerLists:Landroid/util/ArrayMap;

    invoke-virtual {p2, p1}, Landroid/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/util/concurrent/CopyOnWriteArrayList;

    invoke-virtual {p2}, Ljava/util/concurrent/CopyOnWriteArrayList;->isEmpty()Z

    move-result p2

    if-eqz p2, :cond_1

    .line 933
    iget-object p2, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mMessageListenerLists:Landroid/util/ArrayMap;

    invoke-virtual {p2, p1}, Landroid/util/ArrayMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 936
    :cond_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public unregisterUpdateListener(Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;)V
    .locals 0

    .line 860
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mUpdateChannelListListeners:Ljava/util/ArrayList;

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    return-void
.end method

.method public updateChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 1

    .line 236
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentDbHelper()Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->updateChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 237
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateChannelList()V

    .line 238
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->syncChannelInfo(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    return-void
.end method

.method public updateChannel(Ljava/lang/String;Lcom/pri/prizeinterphone/serial/data/ChannelData;)V
    .locals 1

    .line 242
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mInitChannelDataDB:Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilInitChannelData;->getCurrentDb(Ljava/lang/String;)Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object p1

    invoke-virtual {p1, p2}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->updateChannel(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    .line 243
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->updateChannelList()V

    .line 244
    invoke-virtual {p0, p2}, Lcom/pri/prizeinterphone/manager/DmrManager;->syncChannelInfo(Lcom/pri/prizeinterphone/serial/data/ChannelData;)V

    return-void
.end method

.method public updateChannelList()V
    .locals 1

    .line 202
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentDbHelper()Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->getAllChannels()Ljava/util/ArrayList;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->channels:Ljava/util/List;

    .line 203
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mUpdateChannelListListeners:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-lez v0, :cond_0

    .line 204
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mUpdateChannelListListeners:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;

    .line 205
    invoke-interface {v0}, Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;->updateTalkBackChannelList()V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public updateContact(Lcom/pri/prizeinterphone/serial/data/ContactData;)Z
    .locals 1

    .line 612
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbContactHelper:Lcom/pri/prizeinterphone/serial/data/UtilContactsData;

    invoke-virtual {v0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilContactsData;->updateContact(Lcom/pri/prizeinterphone/serial/data/ContactData;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 614
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/manager/DmrManager;->notifyContactUpdate(Lcom/pri/prizeinterphone/serial/data/ContactData;)V

    :cond_0
    return v0
.end method

.method public updateConversation(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V
    .locals 0

    .line 574
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->dbConversationHelper:Lcom/pri/prizeinterphone/serial/data/UtilConversationData;

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/UtilConversationData;->updateConverstion(Lcom/pri/prizeinterphone/serial/data/ConversationData;)V

    return-void
.end method

.method public updateModuleInit()V
    .locals 1

    .line 211
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getCurrentDbHelper()Lcom/pri/prizeinterphone/serial/data/UtilChannelData;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/data/UtilChannelData;->getAllChannels()Ljava/util/ArrayList;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->channels:Ljava/util/List;

    .line 212
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mUpdateChannelListListeners:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-lez v0, :cond_0

    .line 213
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/DmrManager;->mUpdateChannelListListeners:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;

    .line 214
    invoke-interface {v0}, Lcom/pri/prizeinterphone/manager/DmrManager$UpdateListener;->updateModuleInit()V

    goto :goto_0

    :cond_0
    return-void
.end method
