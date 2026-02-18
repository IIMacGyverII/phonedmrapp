package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class RecGroupTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    public RecGroupTag(String str) {
        super(str);
    }

    public RecGroupTag() {
        super(XmlTagConst.TAG_RECGROUP);
    }
}
