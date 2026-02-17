package com.pri.prizeinterphone.config.tag;

public class EncryptSwitchTag extends XmlTag {
    public boolean isFilter(String str) {
        return false;
    }

    public EncryptSwitchTag(String str) {
        super(str);
    }

    public EncryptSwitchTag() {
        super(XmlTagConst.TAG_ENCRYPT_SWITCH);
    }
}
