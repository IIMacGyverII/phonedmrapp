package com.pri.prizeinterphone.config.tag;

public class ChannelsIdTag extends XmlTag {
    public boolean isFilter(String str) {
        return true;
    }

    public boolean isForceFilter() {
        return true;
    }

    public ChannelsIdTag(String str) {
        super(str);
    }

    public ChannelsIdTag() {
        super(XmlTagConst.TAG_CHANNELS_ID);
    }
}
