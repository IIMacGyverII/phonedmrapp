package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class SendSubaudioTypeTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    public SendSubaudioTypeTag(String str) {
        super(str);
    }

    public SendSubaudioTypeTag() {
        super(XmlTagConst.TAG_SEND_SUB_AUDIO_TYPE);
    }
}
