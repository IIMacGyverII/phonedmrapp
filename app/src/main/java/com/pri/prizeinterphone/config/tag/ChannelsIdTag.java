package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class ChannelsIdTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    @Override // com.pri.prizeinterphone.config.tag.XmlTag
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
