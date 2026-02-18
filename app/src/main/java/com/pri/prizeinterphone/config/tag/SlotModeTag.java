package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class SlotModeTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return false;
    }

    public SlotModeTag(String str) {
        super(str);
    }

    public SlotModeTag() {
        super(XmlTagConst.TAG_SLOT_MODE);
    }
}
