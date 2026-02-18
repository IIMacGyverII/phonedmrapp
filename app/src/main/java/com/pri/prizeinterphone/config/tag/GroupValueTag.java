package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class GroupValueTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
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
