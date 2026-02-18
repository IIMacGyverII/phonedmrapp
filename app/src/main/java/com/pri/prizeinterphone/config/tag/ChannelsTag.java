package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class ChannelsTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    @Override // com.pri.prizeinterphone.config.tag.XmlTag
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
