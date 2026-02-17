package com.pri.prizeinterphone.config.tag;

public class ChannelTag extends XmlTag {
    public boolean isFilter(String str) {
        return true;
    }

    public ChannelTag(String str) {
        super(str);
    }

    public ChannelTag() {
        super(XmlTagConst.TAG_CHANNEL);
    }
}
