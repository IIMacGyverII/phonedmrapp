package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class LocalNumberTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    public LocalNumberTag(String str) {
        super(str);
    }

    public LocalNumberTag() {
        super(XmlTagConst.TAG_LOCAL_NUMBER);
    }
}
