package com.android.internal.telephony.nitz;

import android.icu.util.TimeZone;
import android.text.TextUtils;
import android.timezone.CountryTimeZones;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.NitzData;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.List;
import java.util.Objects;

@VisibleForTesting
public final class TimeZoneLookupHelper {
    private CountryTimeZones mLastCountryTimeZones;

    @VisibleForTesting
    public static final class CountryResult {
        public static final int QUALITY_DEFAULT_BOOSTED = 2;
        public static final int QUALITY_MULTIPLE_ZONES_DIFFERENT_OFFSETS = 4;
        public static final int QUALITY_MULTIPLE_ZONES_SAME_OFFSET = 3;
        public static final int QUALITY_SINGLE_ZONE = 1;
        private final String mDebugInfo;
        public final int quality;
        public final String zoneId;

        @Retention(RetentionPolicy.SOURCE)
        public @interface Quality {
        }

        public CountryResult(String str, int i, String str2) {
            Objects.requireNonNull(str);
            this.zoneId = str;
            this.quality = i;
            this.mDebugInfo = str2;
        }

        public boolean equals(Object obj) {
            if (this == obj) {
                return true;
            }
            if (obj == null || CountryResult.class != obj.getClass()) {
                return false;
            }
            CountryResult countryResult = (CountryResult) obj;
            if (this.quality != countryResult.quality || !this.zoneId.equals(countryResult.zoneId)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return Objects.hash(new Object[]{this.zoneId, Integer.valueOf(this.quality)});
        }

        public String toString() {
            return "CountryResult{zoneId='" + this.zoneId + '\'' + ", quality=" + this.quality + ", mDebugInfo=" + this.mDebugInfo + '}';
        }
    }

    @VisibleForTesting
    public CountryTimeZones.OffsetResult lookupByNitzCountry(NitzData nitzData, String str) {
        CountryTimeZones countryTimeZones = getCountryTimeZones(str);
        if (countryTimeZones == null) {
            return null;
        }
        TimeZone timeZone = TimeZone.getDefault();
        Integer dstAdjustmentMillis = nitzData.getDstAdjustmentMillis();
        if (dstAdjustmentMillis == null) {
            return countryTimeZones.lookupByOffsetWithBias(nitzData.getCurrentTimeInMillis(), timeZone, nitzData.getLocalOffsetMillis());
        }
        return countryTimeZones.lookupByOffsetWithBias(nitzData.getCurrentTimeInMillis(), timeZone, nitzData.getLocalOffsetMillis(), dstAdjustmentMillis.intValue() != 0);
    }

    @VisibleForTesting
    public CountryTimeZones.OffsetResult lookupByNitz(NitzData nitzData) {
        Boolean bool;
        int localOffsetMillis = nitzData.getLocalOffsetMillis();
        long currentTimeInMillis = nitzData.getCurrentTimeInMillis();
        Integer dstAdjustmentMillis = nitzData.getDstAdjustmentMillis();
        if (dstAdjustmentMillis == null) {
            bool = null;
        } else {
            bool = Boolean.valueOf(dstAdjustmentMillis.intValue() != 0);
        }
        CountryTimeZones.OffsetResult lookupByInstantOffsetDst = lookupByInstantOffsetDst(currentTimeInMillis, localOffsetMillis, bool);
        return (lookupByInstantOffsetDst != null || bool == null) ? lookupByInstantOffsetDst : lookupByInstantOffsetDst(currentTimeInMillis, localOffsetMillis, (Boolean) null);
    }

    @VisibleForTesting
    public CountryResult lookupByCountry(String str, long j) {
        TimeZone defaultTimeZone;
        String str2;
        CountryTimeZones countryTimeZones = getCountryTimeZones(str);
        if (countryTimeZones == null || (defaultTimeZone = countryTimeZones.getDefaultTimeZone()) == null) {
            return null;
        }
        int i = 4;
        if (countryTimeZones.isDefaultTimeZoneBoosted()) {
            i = 2;
            str2 = "Country default is boosted";
        } else {
            List effectiveTimeZoneMappingsAt = countryTimeZones.getEffectiveTimeZoneMappingsAt(j);
            if (effectiveTimeZoneMappingsAt.isEmpty()) {
                str2 = "No effective time zones found at whenMillis=" + j;
            } else if (effectiveTimeZoneMappingsAt.size() == 1) {
                str2 = "One effective time zone found at whenMillis=" + j;
                i = 1;
            } else {
                boolean countryUsesDifferentOffsets = countryUsesDifferentOffsets(j, effectiveTimeZoneMappingsAt, defaultTimeZone);
                if (!countryUsesDifferentOffsets) {
                    i = 3;
                }
                str2 = "countryUsesDifferentOffsets=" + countryUsesDifferentOffsets + " at whenMillis=" + j;
            }
        }
        return new CountryResult(defaultTimeZone.getID(), i, str2);
    }

    private static boolean countryUsesDifferentOffsets(long j, List<CountryTimeZones.TimeZoneMapping> list, TimeZone timeZone) {
        String id = timeZone.getID();
        int offset = timeZone.getOffset(j);
        for (CountryTimeZones.TimeZoneMapping next : list) {
            if (!next.getTimeZoneId().equals(id) && offset != next.getTimeZone().getOffset(j)) {
                return true;
            }
        }
        return false;
    }

    private static CountryTimeZones.OffsetResult lookupByInstantOffsetDst(long j, int i, Boolean bool) {
        String[] availableIDs = java.util.TimeZone.getAvailableIDs();
        int length = availableIDs.length;
        boolean z = false;
        int i2 = 0;
        TimeZone timeZone = null;
        while (true) {
            if (i2 >= length) {
                z = true;
                break;
            }
            TimeZone frozenTimeZone = TimeZone.getFrozenTimeZone(availableIDs[i2]);
            if (offsetMatchesAtTime(frozenTimeZone, i, bool, j)) {
                if (timeZone != null) {
                    break;
                }
                timeZone = frozenTimeZone;
            }
            i2++;
        }
        if (timeZone == null) {
            return null;
        }
        return new CountryTimeZones.OffsetResult(timeZone, z);
    }

    private static boolean offsetMatchesAtTime(TimeZone timeZone, int i, Boolean bool, long j) {
        int[] iArr = new int[2];
        timeZone.getOffset(j, false, iArr);
        if (i != iArr[0] + iArr[1]) {
            return false;
        }
        if (bool != null) {
            if (bool.booleanValue() != (iArr[1] != 0)) {
                return false;
            }
        }
        return true;
    }

    @VisibleForTesting
    public boolean countryUsesUtc(String str, long j) {
        CountryTimeZones countryTimeZones;
        if (!TextUtils.isEmpty(str) && (countryTimeZones = getCountryTimeZones(str)) != null && countryTimeZones.hasUtcZone(j)) {
            return true;
        }
        return false;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:14:0x001f, code lost:
        return r2;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private android.timezone.CountryTimeZones getCountryTimeZones(java.lang.String r2) {
        /*
            r1 = this;
            java.util.Objects.requireNonNull(r2)
            monitor-enter(r1)
            android.timezone.CountryTimeZones r0 = r1.mLastCountryTimeZones     // Catch:{ all -> 0x0020 }
            if (r0 == 0) goto L_0x0012
            boolean r0 = r0.matchesCountryCode(r2)     // Catch:{ all -> 0x0020 }
            if (r0 == 0) goto L_0x0012
            android.timezone.CountryTimeZones r2 = r1.mLastCountryTimeZones     // Catch:{ all -> 0x0020 }
            monitor-exit(r1)     // Catch:{ all -> 0x0020 }
            return r2
        L_0x0012:
            android.timezone.TimeZoneFinder r0 = android.timezone.TimeZoneFinder.getInstance()     // Catch:{ all -> 0x0020 }
            android.timezone.CountryTimeZones r2 = r0.lookupCountryTimeZones(r2)     // Catch:{ all -> 0x0020 }
            if (r2 == 0) goto L_0x001e
            r1.mLastCountryTimeZones = r2     // Catch:{ all -> 0x0020 }
        L_0x001e:
            monitor-exit(r1)     // Catch:{ all -> 0x0020 }
            return r2
        L_0x0020:
            r2 = move-exception
            monitor-exit(r1)     // Catch:{ all -> 0x0020 }
            throw r2
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.nitz.TimeZoneLookupHelper.getCountryTimeZones(java.lang.String):android.timezone.CountryTimeZones");
    }
}
