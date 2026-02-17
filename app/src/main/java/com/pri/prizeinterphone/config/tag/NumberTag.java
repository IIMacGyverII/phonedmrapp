package com.pri.prizeinterphone.config.tag;

public class NumberTag extends XmlTag {
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
