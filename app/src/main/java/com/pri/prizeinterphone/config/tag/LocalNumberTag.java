package com.pri.prizeinterphone.config.tag;

public class LocalNumberTag extends XmlTag {
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
