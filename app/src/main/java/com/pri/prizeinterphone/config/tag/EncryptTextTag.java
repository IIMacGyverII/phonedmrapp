package com.pri.prizeinterphone.config.tag;

public class EncryptTextTag extends XmlTag {
    public boolean isFilter(String str) {
        return false;
    }

    public EncryptTextTag(String str) {
        super(str);
    }

    public EncryptTextTag() {
        super(XmlTagConst.TAG_ENCRYPT_TEXT);
    }
}
