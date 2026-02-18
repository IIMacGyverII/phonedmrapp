package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class SendFreqTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isForceFilter() {
        return true;
    }

    public SendFreqTag(String str) {
        super(str);
    }

    public SendFreqTag() {
        super(XmlTagConst.TAG_SENDFREQ);
    }
}
