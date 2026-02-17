package com.pri.prizeinterphone.config.tag;

public class ChannelTypeTag extends XmlTag {
    public boolean isFilter(String str) {
        return true;
    }

    public boolean isForceFilter() {
        return true;
    }

    public ChannelTypeTag(String str) {
        super(str);
    }

    public ChannelTypeTag() {
        super(XmlTagConst.TAG_CHANNEL_TYPE);
    }
}
