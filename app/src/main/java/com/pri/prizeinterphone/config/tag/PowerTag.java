package com.pri.prizeinterphone.config.tag;

public class PowerTag extends XmlTag {
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
