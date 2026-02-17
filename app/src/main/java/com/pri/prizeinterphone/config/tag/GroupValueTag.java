package com.pri.prizeinterphone.config.tag;

public class GroupValueTag extends XmlTag {
    public boolean isFilter(String str) {
        return false;
    }

    public GroupValueTag(String str) {
        super(str);
    }

    public GroupValueTag() {
        super(XmlTagConst.TAG_GROUP_VALUE);
    }
}
