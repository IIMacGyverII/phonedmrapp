package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class RecvSubaudioTypeTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    public RecvSubaudioTypeTag(String str) {
        super(str);
    }

    public RecvSubaudioTypeTag() {
        super(XmlTagConst.TAG_RECV_SUB_AUDIO_TYPE);
    }
}
