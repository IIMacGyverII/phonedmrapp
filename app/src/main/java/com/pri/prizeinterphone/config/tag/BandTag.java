package com.pri.prizeinterphone.config.tag;

public class BandTag extends XmlTag {
    public boolean isFilter(String str) {
        return true;
    }

    public BandTag(String str) {
        super(str);
    }

    public BandTag() {
        super(XmlTagConst.TAG_BAND);
    }
}
