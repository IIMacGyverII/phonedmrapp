package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class SendSubaudioFreqTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    public SendSubaudioFreqTag(String str) {
        super(str);
    }

    public SendSubaudioFreqTag() {
        super(XmlTagConst.TAG_SEND_SUB_AUDIO_FREQ);
    }
}
