package com.pri.prizeinterphone.config.tag;

public class SendSubaudioFreqTag extends XmlTag {
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
