package com.android.internal.telephony;

import java.util.Objects;

public class HalVersion implements Comparable<HalVersion> {
    public static final HalVersion UNKNOWN = new HalVersion(-1, -1);
    public final int major;
    public final int minor;

    public HalVersion(int i, int i2) {
        this.major = i;
        this.minor = i2;
    }

    public int compareTo(HalVersion halVersion) {
        int i;
        int i2;
        if (halVersion == null || (i = this.major) > (i2 = halVersion.major)) {
            return 1;
        }
        if (i < i2) {
            return -1;
        }
        int i3 = this.minor;
        int i4 = halVersion.minor;
        if (i3 > i4) {
            return 1;
        }
        if (i3 < i4) {
            return -1;
        }
        return 0;
    }

    public int hashCode() {
        return Objects.hash(new Object[]{Integer.valueOf(this.major), Integer.valueOf(this.minor)});
    }

    public boolean equals(Object obj) {
        return (obj instanceof HalVersion) && (obj == this || compareTo((HalVersion) obj) == 0);
    }

    public boolean greater(HalVersion halVersion) {
        return compareTo(halVersion) > 0;
    }

    public boolean less(HalVersion halVersion) {
        return compareTo(halVersion) < 0;
    }

    public boolean greaterOrEqual(HalVersion halVersion) {
        return greater(halVersion) || equals(halVersion);
    }

    public boolean lessOrEqual(HalVersion halVersion) {
        return less(halVersion) || equals(halVersion);
    }

    public String toString() {
        return this.major + "." + this.minor;
    }
}
