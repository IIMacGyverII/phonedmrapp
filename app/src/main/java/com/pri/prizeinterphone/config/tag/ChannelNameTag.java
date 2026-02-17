package com.pri.prizeinterphone.config.tag;

public class ChannelNameTag extends XmlTag {
    public boolean isFilter(String str) {
        return true;
    }

    public boolean isForceFilter() {
        return true;
    }

    public ChannelNameTag(String str) {
        super(str);
    }

    public ChannelNameTag() {
        super(XmlTagConst.TAG_CHANNEL_NAME);
    }
}
