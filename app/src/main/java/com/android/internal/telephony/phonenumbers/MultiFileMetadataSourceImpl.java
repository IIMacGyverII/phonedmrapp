package com.android.internal.telephony.phonenumbers;

import com.android.internal.telephony.phonenumbers.Phonemetadata;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

final class MultiFileMetadataSourceImpl implements MetadataSource {
    private final ConcurrentHashMap<String, Phonemetadata.PhoneMetadata> geographicalRegions;
    private final MetadataLoader metadataLoader;
    private final ConcurrentHashMap<Integer, Phonemetadata.PhoneMetadata> nonGeographicalRegions;
    private final String phoneNumberMetadataFilePrefix;

    MultiFileMetadataSourceImpl(String str, MetadataLoader metadataLoader2) {
        this.geographicalRegions = new ConcurrentHashMap<>();
        this.nonGeographicalRegions = new ConcurrentHashMap<>();
        this.phoneNumberMetadataFilePrefix = str;
        this.metadataLoader = metadataLoader2;
    }

    MultiFileMetadataSourceImpl(MetadataLoader metadataLoader2) {
        this("/com/android/internal/telephony/phonenumbers/data/PhoneNumberMetadataProto", metadataLoader2);
    }

    public Phonemetadata.PhoneMetadata getMetadataForRegion(String str) {
        return MetadataManager.getMetadataFromMultiFilePrefix(str, this.geographicalRegions, this.phoneNumberMetadataFilePrefix, this.metadataLoader);
    }

    public Phonemetadata.PhoneMetadata getMetadataForNonGeographicalRegion(int i) {
        if (!isNonGeographical(i)) {
            return null;
        }
        return MetadataManager.getMetadataFromMultiFilePrefix(Integer.valueOf(i), this.nonGeographicalRegions, this.phoneNumberMetadataFilePrefix, this.metadataLoader);
    }

    private boolean isNonGeographical(int i) {
        List list = CountryCodeToRegionCodeMap.getCountryCodeToRegionCodeMap().get(Integer.valueOf(i));
        if (list.size() != 1 || !PhoneNumberUtil.REGION_CODE_FOR_NON_GEO_ENTITY.equals(list.get(0))) {
            return false;
        }
        return true;
    }
}
