package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class EncryptSwitchTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
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
