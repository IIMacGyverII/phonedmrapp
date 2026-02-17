package com.pri.prizeinterphone.config.tag;

public class ContacTypeTag extends XmlTag {
    public boolean isFilter(String str) {
        return true;
    }

    public ContacTypeTag(String str) {
        super(str);
    }

    public ContacTypeTag() {
        super(XmlTagConst.TAG_CONTACT_TYPE);
    }
}
