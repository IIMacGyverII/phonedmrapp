package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class ColorCodeTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return false;
    }

    public ColorCodeTag(String str) {
        super(str);
    }

    public ColorCodeTag() {
        super(XmlTagConst.TAG_COLOR_CODE);
    }
}
