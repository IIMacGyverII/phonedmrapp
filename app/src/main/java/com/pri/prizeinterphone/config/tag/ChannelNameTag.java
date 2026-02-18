package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class ChannelNameTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    @Override // com.pri.prizeinterphone.config.tag.XmlTag
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
