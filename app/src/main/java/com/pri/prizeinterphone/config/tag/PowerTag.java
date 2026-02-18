package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class PowerTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    public PowerTag(String str) {
        super(str);
    }

    public PowerTag() {
        super(XmlTagConst.TAG_POWER);
    }
}
