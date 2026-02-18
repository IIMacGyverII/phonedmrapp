package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class ConfigTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isForceFilter() {
        return true;
    }

    public ConfigTag(String str) {
        super(str);
    }

    public ConfigTag() {
        super(XmlTagConst.TAG_CONFIG);
    }
}
