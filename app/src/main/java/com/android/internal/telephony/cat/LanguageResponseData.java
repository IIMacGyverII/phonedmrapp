package com.android.internal.telephony.cat;

import com.android.internal.telephony.GsmAlphabet;
import java.io.ByteArrayOutputStream;

/* compiled from: ResponseData */
class LanguageResponseData extends ResponseData {
    private String mLang;

    public LanguageResponseData(String str) {
        this.mLang = str;
    }

    public void format(ByteArrayOutputStream byteArrayOutputStream) {
        if (byteArrayOutputStream != null) {
            byteArrayOutputStream.write(ComprehensionTlvTag.LANGUAGE.value() | 128);
            String str = this.mLang;
            byte[] stringToGsm8BitPacked = (str == null || str.length() <= 0) ? new byte[0] : GsmAlphabet.stringToGsm8BitPacked(this.mLang);
            byteArrayOutputStream.write(stringToGsm8BitPacked.length);
            for (byte write : stringToGsm8BitPacked) {
                byteArrayOutputStream.write(write);
            }
        }
    }
}
