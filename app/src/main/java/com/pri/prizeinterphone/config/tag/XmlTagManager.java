package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class XmlTagManager {
    private XmlTag bandTag;
    private XmlTag channelNameTag;
    private XmlTag channelTag;
    private XmlTag channelsIdTag;
    private XmlTag channelsTag;
    private XmlTag channeltypeTag;
    private XmlTag colorCodeTag;
    private XmlTag configTag;
    private XmlTag contacTypeTag;
    private XmlTag encryptSwitchTag;
    private XmlTag encryptTextTag;
    private XmlTag groupValueTag;
    private XmlTag localNumberTag;
    private XmlTag number;
    private XmlTag powerTag;
    private XmlTag recGroup;
    private XmlTag recfreqTag;
    private XmlTag recvSubaudioTypeTag;
    private XmlTag recvsubaudiofreq;
    private XmlTag sendSubaudioTypeTag;
    private XmlTag sendfreqTag;
    private XmlTag sendsubaudiofreq;
    private XmlTag slotModeTag;
    private XmlTag squelchLevelTag;

    public XmlTag getRecvsubaudiofreq() {
        return this.recvsubaudiofreq;
    }

    public XmlTag getSendsubaudiofreq() {
        return this.sendsubaudiofreq;
    }

    public XmlTag getNumber() {
        return this.number;
    }

    public XmlTag getRecGroup() {
        return this.recGroup;
    }

    public XmlTag getConfigTag() {
        return this.configTag;
    }

    public XmlTag getChannelsTag() {
        return this.channelsTag;
    }

    public XmlTag getChannelsIdTag() {
        return this.channelsIdTag;
    }

    public XmlTag getChannelTag() {
        return this.channelTag;
    }

    public XmlTag getChannelNameTag() {
        return this.channelNameTag;
    }

    public XmlTag getSendfreqTag() {
        return this.sendfreqTag;
    }

    public XmlTag getRecfreqTag() {
        return this.recfreqTag;
    }

    public XmlTag getChanneltypeTag() {
        return this.channeltypeTag;
    }

    public XmlTag getPowerTag() {
        return this.powerTag;
    }

    public XmlTag getColorCodeTag() {
        return this.colorCodeTag;
    }

    public XmlTag getSlotModeTag() {
        return this.slotModeTag;
    }

    public XmlTag getContacTypeTag() {
        return this.contacTypeTag;
    }

    public XmlTag getEncryptSwitchTag() {
        return this.encryptSwitchTag;
    }

    public XmlTag getEncryptTextTag() {
        return this.encryptTextTag;
    }

    public XmlTag getGroupValueTag() {
        return this.groupValueTag;
    }

    public XmlTag getRecvSubaudioTypeTag() {
        return this.recvSubaudioTypeTag;
    }

    public XmlTag getSendSubaudioTypeTag() {
        return this.sendSubaudioTypeTag;
    }

    public XmlTag getBandTag() {
        return this.bandTag;
    }

    public XmlTag getSquelchLevelTag() {
        return this.squelchLevelTag;
    }

    public XmlTag getLocalNumberTag() {
        return this.localNumberTag;
    }

    private XmlTagManager() {
        this.configTag = new ConfigTag();
        this.localNumberTag = new LocalNumberTag();
        this.channelsTag = new ChannelsTag();
        this.channelsIdTag = new ChannelsIdTag();
        this.channelTag = new ChannelTag();
        this.channelNameTag = new ChannelNameTag();
        this.sendfreqTag = new SendFreqTag();
        this.recfreqTag = new RecFreqTag();
        this.channeltypeTag = new ChannelTypeTag();
        this.powerTag = new PowerTag();
        this.colorCodeTag = new ColorCodeTag();
        this.slotModeTag = new SlotModeTag();
        this.contacTypeTag = new ContacTypeTag();
        this.encryptSwitchTag = new EncryptSwitchTag();
        this.encryptTextTag = new EncryptTextTag();
        this.groupValueTag = new GroupValueTag();
        this.recvSubaudioTypeTag = new RecvSubaudioTypeTag();
        this.sendSubaudioTypeTag = new SendSubaudioTypeTag();
        this.bandTag = new BandTag();
        this.squelchLevelTag = new SquelchLevelTag();
        this.recvsubaudiofreq = new RecvSubaudioFreqTag();
        this.sendsubaudiofreq = new SendSubaudioFreqTag();
        this.number = new NumberTag();
        this.recGroup = new RecGroupTag();
    }

    /* loaded from: classes4.dex */
    private static class SingletonHolder {
        private static final XmlTagManager INSTANCE = new XmlTagManager();

        private SingletonHolder() {
        }
    }

    public static XmlTagManager getInstance() {
        return SingletonHolder.INSTANCE;
    }
}
