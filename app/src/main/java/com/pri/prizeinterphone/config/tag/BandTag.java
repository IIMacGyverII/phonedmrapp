package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class BandTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    public BandTag(String str) {
        super(str);
    }

    public BandTag() {
        super(XmlTagConst.TAG_BAND);
    }
}
