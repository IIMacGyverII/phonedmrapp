package com.pri.prizeinterphone.config.tag;
/* loaded from: classes4.dex */
public class RecvSubaudioFreqTag extends XmlTag {
    @Override // com.pri.prizeinterphone.config.tag.XmlTag
    public boolean isFilter(String str) {
        return true;
    }

    public RecvSubaudioFreqTag(String str) {
        super(str);
    }

    public RecvSubaudioFreqTag() {
        super(XmlTagConst.TAG_RECV_SUB_AUDIO_Freq);
    }
}
