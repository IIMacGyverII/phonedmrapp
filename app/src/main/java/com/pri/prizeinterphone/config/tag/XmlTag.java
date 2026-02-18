package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public abstract class XmlTag {
    private String mTag;

    public abstract boolean isFilter(String str);

    public boolean isForceFilter() {
        return false;
    }

    public boolean isAvailable(String str) {
        if (isForceFilter()) {
            return this.mTag.equals(str);
        }
        return isFilter(str) && this.mTag.equals(str);
    }

    public XmlTag(String str) {
        this.mTag = str;
    }

    public String getTag() {
        return this.mTag;
    }
}
