package com.pri.prizeinterphone.config.tag;

public class ColorCodeTag extends XmlTag {
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
