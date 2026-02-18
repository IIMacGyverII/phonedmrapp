package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class ContacTypeTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    public ContacTypeTag(String str) {
        super(str);
    }

    public ContacTypeTag() {
        super(XmlTagConst.TAG_CONTACT_TYPE);
    }
}
