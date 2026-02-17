package com.android.internal.telephony.phonenumbers;

import com.android.internal.telephony.phonenumbers.Phonemetadata;
import java.io.InputStream;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicReference;
import java.util.logging.Level;
import java.util.logging.Logger;

final class MetadataManager {
    private static final String ALTERNATE_FORMATS_FILE_PREFIX = "/com/android/internal/telephony/phonenumbers/data/PhoneNumberAlternateFormatsProto";
    static final MetadataLoader DEFAULT_METADATA_LOADER = new MetadataLoader() {
        public InputStream loadMetadata(String str) {
            return MetadataManager.class.getResourceAsStream(str);
        }
    };
    static final String MULTI_FILE_PHONE_NUMBER_METADATA_FILE_PREFIX = "/com/android/internal/telephony/phonenumbers/data/PhoneNumberMetadataProto";
    private static final String SHORT_NUMBER_METADATA_FILE_PREFIX = "/com/android/internal/telephony/phonenumbers/data/ShortNumberMetadataProto";
    static final String SINGLE_FILE_PHONE_NUMBER_METADATA_FILE_NAME = "/com/android/internal/telephony/phonenumbers/data/SingleFilePhoneNumberMetadataProto";
    private static final Set<Integer> alternateFormatsCountryCodes = AlternateFormatsCountryCodeSet.getCountryCodeSet();
    private static final ConcurrentHashMap<Integer, Phonemetadata.PhoneMetadata> alternateFormatsMap = new ConcurrentHashMap<>();
    private static final Logger logger = Logger.getLogger(MetadataManager.class.getName());
    private static final ConcurrentHashMap<String, Phonemetadata.PhoneMetadata> shortNumberMetadataMap = new ConcurrentHashMap<>();
    private static final Set<String> shortNumberMetadataRegionCodes = ShortNumbersRegionCodeSet.getRegionCodeSet();

    private MetadataManager() {
    }

    static Phonemetadata.PhoneMetadata getAlternateFormatsForCountry(int i) {
        if (!alternateFormatsCountryCodes.contains(Integer.valueOf(i))) {
            return null;
        }
        return getMetadataFromMultiFilePrefix(Integer.valueOf(i), alternateFormatsMap, ALTERNATE_FORMATS_FILE_PREFIX, DEFAULT_METADATA_LOADER);
    }

    static Phonemetadata.PhoneMetadata getShortNumberMetadataForRegion(String str) {
        if (!shortNumberMetadataRegionCodes.contains(str)) {
            return null;
        }
        return getMetadataFromMultiFilePrefix(str, shortNumberMetadataMap, SHORT_NUMBER_METADATA_FILE_PREFIX, DEFAULT_METADATA_LOADER);
    }

    static Set<String> getSupportedShortNumberRegions() {
        return Collections.unmodifiableSet(shortNumberMetadataRegionCodes);
    }

    static <T> Phonemetadata.PhoneMetadata getMetadataFromMultiFilePrefix(T t, ConcurrentHashMap<T, Phonemetadata.PhoneMetadata> concurrentHashMap, String str, MetadataLoader metadataLoader) {
        Phonemetadata.PhoneMetadata phoneMetadata = concurrentHashMap.get(t);
        if (phoneMetadata != null) {
            return phoneMetadata;
        }
        String str2 = str + "_" + t;
        List<Phonemetadata.PhoneMetadata> metadataFromSingleFileName = getMetadataFromSingleFileName(str2, metadataLoader);
        if (metadataFromSingleFileName.size() > 1) {
            logger.log(Level.WARNING, "more than one metadata in file " + str2);
        }
        Phonemetadata.PhoneMetadata phoneMetadata2 = metadataFromSingleFileName.get(0);
        Phonemetadata.PhoneMetadata putIfAbsent = concurrentHashMap.putIfAbsent(t, phoneMetadata2);
        return putIfAbsent != null ? putIfAbsent : phoneMetadata2;
    }

    static class SingleFileMetadataMaps {
        private final Map<Integer, Phonemetadata.PhoneMetadata> countryCallingCodeToMetadata;
        private final Map<String, Phonemetadata.PhoneMetadata> regionCodeToMetadata;

        static SingleFileMetadataMaps load(String str, MetadataLoader metadataLoader) {
            List<Phonemetadata.PhoneMetadata> access$000 = MetadataManager.getMetadataFromSingleFileName(str, metadataLoader);
            HashMap hashMap = new HashMap();
            HashMap hashMap2 = new HashMap();
            for (Phonemetadata.PhoneMetadata phoneMetadata : access$000) {
                String id = phoneMetadata.getId();
                if (PhoneNumberUtil.REGION_CODE_FOR_NON_GEO_ENTITY.equals(id)) {
                    hashMap2.put(Integer.valueOf(phoneMetadata.getCountryCode()), phoneMetadata);
                } else {
                    hashMap.put(id, phoneMetadata);
                }
            }
            return new SingleFileMetadataMaps(hashMap, hashMap2);
        }

        private SingleFileMetadataMaps(Map<String, Phonemetadata.PhoneMetadata> map, Map<Integer, Phonemetadata.PhoneMetadata> map2) {
            this.regionCodeToMetadata = Collections.unmodifiableMap(map);
            this.countryCallingCodeToMetadata = Collections.unmodifiableMap(map2);
        }

        /* access modifiers changed from: package-private */
        public Phonemetadata.PhoneMetadata get(String str) {
            return this.regionCodeToMetadata.get(str);
        }

        /* access modifiers changed from: package-private */
        public Phonemetadata.PhoneMetadata get(int i) {
            return this.countryCallingCodeToMetadata.get(Integer.valueOf(i));
        }
    }

    static SingleFileMetadataMaps getSingleFileMetadataMaps(AtomicReference<SingleFileMetadataMaps> atomicReference, String str, MetadataLoader metadataLoader) {
        SingleFileMetadataMaps singleFileMetadataMaps = atomicReference.get();
        if (singleFileMetadataMaps != null) {
            return singleFileMetadataMaps;
        }
        atomicReference.compareAndSet((Object) null, SingleFileMetadataMaps.load(str, metadataLoader));
        return atomicReference.get();
    }

    /* access modifiers changed from: private */
    public static List<Phonemetadata.PhoneMetadata> getMetadataFromSingleFileName(String str, MetadataLoader metadataLoader) {
        InputStream loadMetadata = metadataLoader.loadMetadata(str);
        if (loadMetadata != null) {
            List<Phonemetadata.PhoneMetadata> metadataList = loadMetadataAndCloseInput(loadMetadata).getMetadataList();
            if (metadataList.size() != 0) {
                return metadataList;
            }
            throw new IllegalStateException("empty metadata: " + str);
        }
        throw new IllegalStateException("missing metadata: " + str);
    }

    /* JADX WARNING: Removed duplicated region for block: B:24:0x0034 A[SYNTHETIC, Splitter:B:24:0x0034] */
    /* JADX WARNING: Removed duplicated region for block: B:26:0x0038 A[Catch:{ IOException -> 0x003c }] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private static com.android.internal.telephony.phonenumbers.Phonemetadata.PhoneMetadataCollection loadMetadataAndCloseInput(java.io.InputStream r5) {
        /*
            java.lang.String r0 = "error closing input stream (ignored)"
            java.lang.String r1 = "cannot load/parse metadata"
            r2 = 0
            java.io.ObjectInputStream r3 = new java.io.ObjectInputStream     // Catch:{ IOException -> 0x002b }
            r3.<init>(r5)     // Catch:{ IOException -> 0x002b }
            com.android.internal.telephony.phonenumbers.Phonemetadata$PhoneMetadataCollection r2 = new com.android.internal.telephony.phonenumbers.Phonemetadata$PhoneMetadataCollection     // Catch:{ all -> 0x0026 }
            r2.<init>()     // Catch:{ all -> 0x0026 }
            r2.readExternal(r3)     // Catch:{ IOException -> 0x001f }
            r3.close()     // Catch:{ IOException -> 0x0016 }
            goto L_0x001e
        L_0x0016:
            r5 = move-exception
            java.util.logging.Logger r1 = logger
            java.util.logging.Level r3 = java.util.logging.Level.WARNING
            r1.log(r3, r0, r5)
        L_0x001e:
            return r2
        L_0x001f:
            r2 = move-exception
            java.lang.RuntimeException r4 = new java.lang.RuntimeException     // Catch:{ all -> 0x0026 }
            r4.<init>(r1, r2)     // Catch:{ all -> 0x0026 }
            throw r4     // Catch:{ all -> 0x0026 }
        L_0x0026:
            r1 = move-exception
            r2 = r3
            goto L_0x0032
        L_0x0029:
            r1 = move-exception
            goto L_0x0032
        L_0x002b:
            r3 = move-exception
            java.lang.RuntimeException r4 = new java.lang.RuntimeException     // Catch:{ all -> 0x0029 }
            r4.<init>(r1, r3)     // Catch:{ all -> 0x0029 }
            throw r4     // Catch:{ all -> 0x0029 }
        L_0x0032:
            if (r2 == 0) goto L_0x0038
            r2.close()     // Catch:{ IOException -> 0x003c }
            goto L_0x0044
        L_0x0038:
            r5.close()     // Catch:{ IOException -> 0x003c }
            goto L_0x0044
        L_0x003c:
            r5 = move-exception
            java.util.logging.Logger r2 = logger
            java.util.logging.Level r3 = java.util.logging.Level.WARNING
            r2.log(r3, r0, r5)
        L_0x0044:
            throw r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.phonenumbers.MetadataManager.loadMetadataAndCloseInput(java.io.InputStream):com.android.internal.telephony.phonenumbers.Phonemetadata$PhoneMetadataCollection");
    }
}
