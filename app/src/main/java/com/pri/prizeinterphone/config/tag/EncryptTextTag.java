package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class EncryptTextTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
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
