package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class ChannelTypeTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    @Override // com.pri.prizeinterphone.config.tag.XmlTag
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
