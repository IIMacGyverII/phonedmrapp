package com.android.internal.telephony.phonenumbers;

import java.io.InputStream;

public interface MetadataLoader {
    InputStream loadMetadata(String str);
}
