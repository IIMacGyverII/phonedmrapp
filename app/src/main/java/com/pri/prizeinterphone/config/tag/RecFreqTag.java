package com.pri.prizeinterphone.config.tag;

public class RecFreqTag extends XmlTag {
    public boolean isFilter(String str) {
        return true;
    }

    public boolean isForceFilter() {
        return true;
    }

    public RecFreqTag(String str) {
        super(str);
    }

    public RecFreqTag() {
        super(XmlTagConst.TAG_RECFREQ);
    }
}
