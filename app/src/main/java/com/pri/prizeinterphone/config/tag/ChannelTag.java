package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class ChannelTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
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
