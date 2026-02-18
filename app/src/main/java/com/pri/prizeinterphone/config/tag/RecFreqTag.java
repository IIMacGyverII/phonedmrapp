package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class RecFreqTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isForceFilter() {
        return true;
    }

    public RecFreqTag(String str) {
        super(str);
    }

    public RecFreqTag() {
        super(XmlTagConst.TAG_RECFREQ);
    }
}
