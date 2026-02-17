package com.pri.prizeinterphone.config.tag;

public class RecvSubaudioFreqTag extends XmlTag {
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
