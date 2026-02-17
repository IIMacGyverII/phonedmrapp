package com.pri.prizeinterphone.config.tag;

public class RecvSubaudioTypeTag extends XmlTag {
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
