package com.pri.prizeinterphone.config.tag;

public class ChannelsTag extends XmlTag {
    public boolean isFilter(String str) {
        return true;
    }

    public boolean isForceFilter() {
        return true;
    }

    public ChannelsTag(String str) {
        super(str);
    }

    public ChannelsTag() {
        super(XmlTagConst.TAG_CHANNELS);
    }
}
