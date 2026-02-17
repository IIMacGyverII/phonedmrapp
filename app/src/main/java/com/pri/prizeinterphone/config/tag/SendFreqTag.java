package com.pri.prizeinterphone.config.tag;

public class SendFreqTag extends XmlTag {
    public boolean isFilter(String str) {
        return true;
    }

    public boolean isForceFilter() {
        return true;
    }

    public SendFreqTag(String str) {
        super(str);
    }

    public SendFreqTag() {
        super(XmlTagConst.TAG_SENDFREQ);
    }
}
