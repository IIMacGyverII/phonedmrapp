package com.pri.prizeinterphone.config.tag;

public class SquelchLevelTag extends XmlTag {
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
