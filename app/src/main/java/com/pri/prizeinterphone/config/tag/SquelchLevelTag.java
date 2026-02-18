package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class SquelchLevelTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    public SquelchLevelTag(String str) {
        super(str);
    }

    public SquelchLevelTag() {
        super(XmlTagConst.TAG_SQUELCH_LEVEL);
    }
}
