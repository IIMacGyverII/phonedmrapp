package com.android.internal.telephony.uicc;

import android.hardware.radio.V1_6.PhonebookRecordInfo;
import android.text.TextUtils;
import com.android.internal.telephony.util.ArrayUtils;
import java.util.ArrayList;
import java.util.Arrays;

public class SimPhonebookRecord {
    /* access modifiers changed from: private */
    public String[] mAdditionalNumbers;
    /* access modifiers changed from: private */
    public String mAlphaTag;
    /* access modifiers changed from: private */
    public String[] mEmails;
    /* access modifiers changed from: private */
    public String mNumber;
    /* access modifiers changed from: private */
    public int mRecordId;

    private String convertNullToEmptyString(String str) {
        return str != null ? str : "";
    }

    public SimPhonebookRecord(int i, String str, String str2, String[] strArr, String[] strArr2) {
        this.mRecordId = i;
        this.mAlphaTag = str;
        this.mNumber = convertRecordFormatToNumber(str2);
        this.mEmails = strArr;
        if (strArr2 != null) {
            this.mAdditionalNumbers = new String[strArr2.length];
            for (int i2 = 0; i2 < strArr2.length; i2++) {
                this.mAdditionalNumbers[i2] = convertRecordFormatToNumber(strArr2[i2]);
            }
        }
    }

    /* JADX WARNING: type inference failed for: r4v2, types: [java.lang.Object[]] */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public SimPhonebookRecord(android.hardware.radio.V1_6.PhonebookRecordInfo r4) {
        /*
            r3 = this;
            r3.<init>()
            r0 = 0
            r3.mRecordId = r0
            if (r4 == 0) goto L_0x003d
            int r0 = r4.recordId
            r3.mRecordId = r0
            java.lang.String r0 = r4.name
            r3.mAlphaTag = r0
            java.lang.String r0 = r4.number
            r3.mNumber = r0
            java.util.ArrayList r0 = r4.emails
            r1 = 0
            if (r0 != 0) goto L_0x001b
            r0 = r1
            goto L_0x0027
        L_0x001b:
            int r2 = r0.size()
            java.lang.String[] r2 = new java.lang.String[r2]
            java.lang.Object[] r0 = r0.toArray(r2)
            java.lang.String[] r0 = (java.lang.String[]) r0
        L_0x0027:
            r3.mEmails = r0
            java.util.ArrayList r4 = r4.additionalNumbers
            if (r4 != 0) goto L_0x002e
            goto L_0x003b
        L_0x002e:
            int r0 = r4.size()
            java.lang.String[] r0 = new java.lang.String[r0]
            java.lang.Object[] r4 = r4.toArray(r0)
            r1 = r4
            java.lang.String[] r1 = (java.lang.String[]) r1
        L_0x003b:
            r3.mAdditionalNumbers = r1
        L_0x003d:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.SimPhonebookRecord.<init>(android.hardware.radio.V1_6.PhonebookRecordInfo):void");
    }

    public SimPhonebookRecord() {
        this.mRecordId = 0;
    }

    public PhonebookRecordInfo toPhonebookRecordInfo() {
        PhonebookRecordInfo phonebookRecordInfo = new PhonebookRecordInfo();
        phonebookRecordInfo.recordId = this.mRecordId;
        phonebookRecordInfo.name = convertNullToEmptyString(this.mAlphaTag);
        phonebookRecordInfo.number = convertNullToEmptyString(convertNumberToRecordFormat(this.mNumber));
        if (this.mEmails != null) {
            phonebookRecordInfo.emails = new ArrayList(Arrays.asList(this.mEmails));
        }
        String[] strArr = this.mAdditionalNumbers;
        if (strArr != null) {
            for (String convertNumberToRecordFormat : strArr) {
                phonebookRecordInfo.additionalNumbers.add(convertNumberToRecordFormat(convertNumberToRecordFormat));
            }
        }
        return phonebookRecordInfo;
    }

    public android.hardware.radio.sim.PhonebookRecordInfo toPhonebookRecordInfoAidl() {
        android.hardware.radio.sim.PhonebookRecordInfo phonebookRecordInfo = new android.hardware.radio.sim.PhonebookRecordInfo();
        phonebookRecordInfo.recordId = this.mRecordId;
        phonebookRecordInfo.name = convertNullToEmptyString(this.mAlphaTag);
        phonebookRecordInfo.number = convertNullToEmptyString(convertNumberToRecordFormat(this.mNumber));
        String[] strArr = this.mEmails;
        if (strArr != null) {
            phonebookRecordInfo.emails = strArr;
        } else {
            phonebookRecordInfo.emails = new String[0];
        }
        String[] strArr2 = this.mAdditionalNumbers;
        if (strArr2 != null) {
            int length = strArr2.length;
            String[] strArr3 = new String[length];
            for (int i = 0; i < length; i++) {
                strArr3[i] = convertNumberToRecordFormat(this.mAdditionalNumbers[i]);
            }
            phonebookRecordInfo.additionalNumbers = strArr3;
        } else {
            phonebookRecordInfo.additionalNumbers = new String[0];
        }
        return phonebookRecordInfo;
    }

    public int getRecordId() {
        return this.mRecordId;
    }

    public String getAlphaTag() {
        return this.mAlphaTag;
    }

    public String getNumber() {
        return this.mNumber;
    }

    public String[] getEmails() {
        return this.mEmails;
    }

    public String[] getAdditionalNumbers() {
        return this.mAdditionalNumbers;
    }

    private String convertRecordFormatToNumber(String str) {
        if (str == null) {
            return null;
        }
        return str.replace('e', ';').replace('T', ',').replace('?', 'N');
    }

    private String convertNumberToRecordFormat(String str) {
        if (str == null) {
            return null;
        }
        return str.replace(';', 'e').replace(',', 'T').replace('N', '?');
    }

    public boolean isEmpty() {
        return TextUtils.isEmpty(this.mAlphaTag) && TextUtils.isEmpty(this.mNumber) && ArrayUtils.isEmpty(this.mEmails) && ArrayUtils.isEmpty(this.mAdditionalNumbers);
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("SimPhoneBookRecord{");
        sb.append("ID =");
        sb.append(this.mRecordId);
        sb.append(", name = ");
        String str = this.mAlphaTag;
        String str2 = "null";
        if (str == null) {
            str = str2;
        }
        sb.append(str);
        sb.append(", number = ");
        String str3 = this.mNumber;
        if (str3 != null) {
            str2 = str3;
        }
        sb.append(str2);
        sb.append(", email count = ");
        String[] strArr = this.mEmails;
        int i = 0;
        sb.append(strArr == null ? 0 : strArr.length);
        sb.append(", email = ");
        sb.append(Arrays.toString(this.mEmails));
        sb.append(", ad number count = ");
        String[] strArr2 = this.mAdditionalNumbers;
        if (strArr2 != null) {
            i = strArr2.length;
        }
        sb.append(i);
        sb.append(", ad number = ");
        sb.append(Arrays.toString(this.mAdditionalNumbers));
        sb.append("}");
        return sb.toString();
    }

    public static final class Builder {
        private String[] mAdditionalNumbers;
        private String mAlphaTag = null;
        private String[] mEmails;
        private String mNumber = null;
        private int mRecordId = 0;

        public SimPhonebookRecord build() {
            SimPhonebookRecord simPhonebookRecord = new SimPhonebookRecord();
            simPhonebookRecord.mAlphaTag = this.mAlphaTag;
            simPhonebookRecord.mRecordId = this.mRecordId;
            simPhonebookRecord.mNumber = this.mNumber;
            String[] strArr = this.mEmails;
            if (strArr != null) {
                simPhonebookRecord.mEmails = strArr;
            }
            String[] strArr2 = this.mAdditionalNumbers;
            if (strArr2 != null) {
                simPhonebookRecord.mAdditionalNumbers = strArr2;
            }
            return simPhonebookRecord;
        }

        public Builder setRecordId(int i) {
            this.mRecordId = i;
            return this;
        }

        public Builder setAlphaTag(String str) {
            this.mAlphaTag = str;
            return this;
        }

        public Builder setNumber(String str) {
            this.mNumber = str;
            return this;
        }

        public Builder setEmails(String[] strArr) {
            this.mEmails = strArr;
            return this;
        }

        public Builder setAdditionalNumbers(String[] strArr) {
            this.mAdditionalNumbers = strArr;
            return this;
        }
    }
}
