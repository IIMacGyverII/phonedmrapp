package com.android.internal.telephony.phonenumbers;

import com.android.internal.telephony.phonenumbers.Phonemetadata;

interface MetadataSource {
    Phonemetadata.PhoneMetadata getMetadataForNonGeographicalRegion(int i);

    Phonemetadata.PhoneMetadata getMetadataForRegion(String str);
}
