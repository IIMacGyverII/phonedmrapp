package com.pri.prizeinterphone.config.tag;

public class SlotModeTag extends XmlTag {
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
