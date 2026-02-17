package com.android.internal.telephony.phonenumbers;

import com.android.internal.telephony.phonenumbers.MetadataManager;
import com.android.internal.telephony.phonenumbers.Phonemetadata;
import java.util.concurrent.atomic.AtomicReference;

final class SingleFileMetadataSourceImpl implements MetadataSource {
    private final MetadataLoader metadataLoader;
    private final String phoneNumberMetadataFileName;
    private final AtomicReference<MetadataManager.SingleFileMetadataMaps> phoneNumberMetadataRef;

    SingleFileMetadataSourceImpl(String str, MetadataLoader metadataLoader2) {
        this.phoneNumberMetadataRef = new AtomicReference<>();
        this.phoneNumberMetadataFileName = str;
        this.metadataLoader = metadataLoader2;
    }

    SingleFileMetadataSourceImpl(MetadataLoader metadataLoader2) {
        this("/com/android/internal/telephony/phonenumbers/data/SingleFilePhoneNumberMetadataProto", metadataLoader2);
    }

    public Phonemetadata.PhoneMetadata getMetadataForRegion(String str) {
        return MetadataManager.getSingleFileMetadataMaps(this.phoneNumberMetadataRef, this.phoneNumberMetadataFileName, this.metadataLoader).get(str);
    }

    public Phonemetadata.PhoneMetadata getMetadataForNonGeographicalRegion(int i) {
        return MetadataManager.getSingleFileMetadataMaps(this.phoneNumberMetadataRef, this.phoneNumberMetadataFileName, this.metadataLoader).get(i);
    }
}
