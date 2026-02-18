package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class NumberTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    public NumberTag(String str) {
        super(str);
    }

    public NumberTag() {
        super("number");
    }
}
