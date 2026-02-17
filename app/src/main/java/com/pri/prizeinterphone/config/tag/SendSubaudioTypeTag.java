package com.pri.prizeinterphone.config.tag;

public class SendSubaudioTypeTag extends XmlTag {
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
