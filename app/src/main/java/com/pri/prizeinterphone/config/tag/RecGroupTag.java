package com.pri.prizeinterphone.config.tag;

public class RecGroupTag extends XmlTag {
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
