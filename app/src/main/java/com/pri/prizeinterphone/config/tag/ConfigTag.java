package com.pri.prizeinterphone.config.tag;

public class ConfigTag extends XmlTag {
    public boolean isFilter(String str) {
        return true;
    }

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
