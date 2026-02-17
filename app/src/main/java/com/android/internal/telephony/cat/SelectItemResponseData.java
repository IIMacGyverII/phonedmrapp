package com.android.internal.telephony.cat;

import java.io.ByteArrayOutputStream;

/* compiled from: ResponseData */
class SelectItemResponseData extends ResponseData {
    private int mId;

    public SelectItemResponseData(int i) {
        this.mId = i;
    }

    public void format(ByteArrayOutputStream byteArrayOutputStream) {
        byteArrayOutputStream.write(ComprehensionTlvTag.ITEM_ID.value() | 128);
        byteArrayOutputStream.write(1);
        byteArrayOutputStream.write(this.mId);
    }
}
