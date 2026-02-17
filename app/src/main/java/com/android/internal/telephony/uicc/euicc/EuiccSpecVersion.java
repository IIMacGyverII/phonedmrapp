package com.android.internal.telephony.uicc.euicc;

import com.android.internal.telephony.uicc.asn1.Asn1Decoder;
import com.android.internal.telephony.uicc.asn1.Asn1Node;
import com.android.internal.telephony.uicc.asn1.InvalidAsn1DataException;
import com.android.internal.telephony.uicc.asn1.TagNotFoundException;
import com.android.telephony.Rlog;
import java.util.Arrays;
import kotlin.UByte;

public final class EuiccSpecVersion implements Comparable<EuiccSpecVersion> {
    private static final String LOG_TAG = "EuiccSpecVer";
    private static final int TAG_ISD_R_APP_TEMPLATE = 224;
    private static final int TAG_VERSION = 130;
    private final int[] mVersionValues;

    public static EuiccSpecVersion fromOpenChannelResponse(byte[] bArr) {
        byte[] bArr2;
        try {
            Asn1Decoder asn1Decoder = new Asn1Decoder(bArr);
            if (!asn1Decoder.hasNextNode()) {
                return null;
            }
            Asn1Node nextNode = asn1Decoder.nextNode();
            try {
                if (nextNode.getTag() == TAG_ISD_R_APP_TEMPLATE) {
                    bArr2 = nextNode.getChild(130, new int[0]).asBytes();
                } else {
                    bArr2 = nextNode.getChild(TAG_ISD_R_APP_TEMPLATE, new int[]{130}).asBytes();
                }
                if (bArr2.length == 3) {
                    return new EuiccSpecVersion(bArr2);
                }
                Rlog.e(LOG_TAG, "Cannot parse select response of ISD-R: " + nextNode.toHex());
                return null;
            } catch (InvalidAsn1DataException | TagNotFoundException unused) {
                Rlog.e(LOG_TAG, "Cannot parse select response of ISD-R: " + nextNode.toHex());
            }
        } catch (InvalidAsn1DataException e) {
            Rlog.e(LOG_TAG, "Cannot parse the select response of ISD-R.", e);
            return null;
        }
    }

    public EuiccSpecVersion(int i, int i2, int i3) {
        int[] iArr = new int[3];
        this.mVersionValues = iArr;
        iArr[0] = i;
        iArr[1] = i2;
        iArr[2] = i3;
    }

    public EuiccSpecVersion(byte[] bArr) {
        int[] iArr = new int[3];
        this.mVersionValues = iArr;
        iArr[0] = bArr[0] & UByte.MAX_VALUE;
        iArr[1] = bArr[1] & UByte.MAX_VALUE;
        iArr[2] = bArr[2] & UByte.MAX_VALUE;
    }

    public int getMajor() {
        return this.mVersionValues[0];
    }

    public int getMinor() {
        return this.mVersionValues[1];
    }

    public int getRevision() {
        return this.mVersionValues[2];
    }

    public int compareTo(EuiccSpecVersion euiccSpecVersion) {
        if (getMajor() > euiccSpecVersion.getMajor()) {
            return 1;
        }
        if (getMajor() < euiccSpecVersion.getMajor()) {
            return -1;
        }
        if (getMinor() > euiccSpecVersion.getMinor()) {
            return 1;
        }
        if (getMinor() < euiccSpecVersion.getMinor()) {
            return -1;
        }
        if (getRevision() > euiccSpecVersion.getRevision()) {
            return 1;
        }
        if (getRevision() < euiccSpecVersion.getRevision()) {
            return -1;
        }
        return 0;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || EuiccSpecVersion.class != obj.getClass()) {
            return false;
        }
        return Arrays.equals(this.mVersionValues, ((EuiccSpecVersion) obj).mVersionValues);
    }

    public int hashCode() {
        return Arrays.hashCode(this.mVersionValues);
    }

    public String toString() {
        return this.mVersionValues[0] + "." + this.mVersionValues[1] + "." + this.mVersionValues[2];
    }
}
