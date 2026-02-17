package com.android.internal.telephony.cat;

import java.util.List;

public class BerTlv {
    public static final int BER_EVENT_DOWNLOAD_TAG = 214;
    public static final int BER_MENU_SELECTION_TAG = 211;
    public static final int BER_PROACTIVE_COMMAND_TAG = 208;
    public static final int BER_UNKNOWN_TAG = 0;
    private List<ComprehensionTlv> mCompTlvs;
    private boolean mLengthValid;
    private int mTag;

    private BerTlv(int i, List<ComprehensionTlv> list, boolean z) {
        this.mTag = i;
        this.mCompTlvs = list;
        this.mLengthValid = z;
    }

    public List<ComprehensionTlv> getComprehensionTlvs() {
        return this.mCompTlvs;
    }

    public int getTag() {
        return this.mTag;
    }

    public boolean isLengthValid() {
        return this.mLengthValid;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:21:0x0079, code lost:
        r2 = 2;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:51:0x00eb, code lost:
        r13 = move-exception;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:53:0x00f7, code lost:
        throw new com.android.internal.telephony.cat.ResultException(com.android.internal.telephony.cat.ResultCode.CMD_DATA_NOT_UNDERSTOOD, r13.explanation());
     */
    /* JADX WARNING: Failed to process nested try/catch */
    /* JADX WARNING: Removed duplicated region for block: B:51:0x00eb A[ExcHandler: ResultException (r13v2 'e' com.android.internal.telephony.cat.ResultException A[CUSTOM_DECLARE]), Splitter:B:1:0x0007] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static com.android.internal.telephony.cat.BerTlv decode(byte[] r13) throws com.android.internal.telephony.cat.ResultException {
        /*
            java.lang.String r0 = " endIndex="
            int r1 = r13.length
            r2 = 3
            r3 = 2
            r4 = 1
            r5 = 0
            byte r6 = r13[r5]     // Catch:{ IndexOutOfBoundsException -> 0x00f8, ResultException -> 0x00eb }
            r7 = 255(0xff, float:3.57E-43)
            r6 = r6 & r7
            r8 = 208(0xd0, float:2.91E-43)
            java.lang.String r9 = " curIndex="
            r10 = 128(0x80, float:1.794E-43)
            if (r6 != r8) goto L_0x007c
            byte r11 = r13[r4]     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            r11 = r11 & r7
            if (r11 >= r10) goto L_0x001c
            r2 = r3
            goto L_0x008c
        L_0x001c:
            r12 = 129(0x81, float:1.81E-43)
            if (r11 != r12) goto L_0x0050
            byte r3 = r13[r3]     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            r11 = r3 & 255(0xff, float:3.57E-43)
            if (r11 < r10) goto L_0x0027
            goto L_0x008c
        L_0x0027:
            com.android.internal.telephony.cat.ResultException r13 = new com.android.internal.telephony.cat.ResultException     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            com.android.internal.telephony.cat.ResultCode r3 = com.android.internal.telephony.cat.ResultCode.CMD_DATA_NOT_UNDERSTOOD     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            r4.<init>()     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            java.lang.String r6 = "length < 0x80 length="
            r4.append(r6)     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            java.lang.String r5 = java.lang.Integer.toHexString(r5)     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            r4.append(r5)     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            r4.append(r9)     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            r4.append(r2)     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            r4.append(r0)     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            r4.append(r1)     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            java.lang.String r4 = r4.toString()     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            r13.<init>((com.android.internal.telephony.cat.ResultCode) r3, (java.lang.String) r4)     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
            throw r13     // Catch:{ IndexOutOfBoundsException -> 0x00f9, ResultException -> 0x00eb }
        L_0x0050:
            com.android.internal.telephony.cat.ResultException r13 = new com.android.internal.telephony.cat.ResultException     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            com.android.internal.telephony.cat.ResultCode r2 = com.android.internal.telephony.cat.ResultCode.CMD_DATA_NOT_UNDERSTOOD     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            java.lang.StringBuilder r4 = new java.lang.StringBuilder     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            r4.<init>()     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            java.lang.String r5 = "Expected first byte to be length or a length tag and < 0x81 byte= "
            r4.append(r5)     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            java.lang.String r5 = java.lang.Integer.toHexString(r11)     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            r4.append(r5)     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            r4.append(r9)     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            r4.append(r3)     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            r4.append(r0)     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            r4.append(r1)     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            java.lang.String r4 = r4.toString()     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            r13.<init>((com.android.internal.telephony.cat.ResultCode) r2, (java.lang.String) r4)     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
            throw r13     // Catch:{ IndexOutOfBoundsException -> 0x0079, ResultException -> 0x00eb }
        L_0x0079:
            r2 = r3
            goto L_0x00f9
        L_0x007c:
            com.android.internal.telephony.cat.ComprehensionTlvTag r2 = com.android.internal.telephony.cat.ComprehensionTlvTag.COMMAND_DETAILS     // Catch:{ IndexOutOfBoundsException -> 0x00f8, ResultException -> 0x00eb }
            int r0 = r2.value()     // Catch:{ IndexOutOfBoundsException -> 0x00f8, ResultException -> 0x00eb }
            r2 = r6 & -129(0xffffffffffffff7f, float:NaN)
            if (r0 != r2) goto L_0x008a
            r2 = r5
            r6 = r2
            r11 = r6
            goto L_0x008c
        L_0x008a:
            r2 = r4
            r11 = r5
        L_0x008c:
            int r0 = r1 - r2
            if (r0 < r11) goto L_0x00c4
            java.util.List r13 = com.android.internal.telephony.cat.ComprehensionTlv.decodeMany(r13, r2)
            if (r6 != r8) goto L_0x00be
            java.util.Iterator r0 = r13.iterator()
            r1 = r5
        L_0x009b:
            boolean r2 = r0.hasNext()
            if (r2 == 0) goto L_0x00bb
            java.lang.Object r2 = r0.next()
            com.android.internal.telephony.cat.ComprehensionTlv r2 = (com.android.internal.telephony.cat.ComprehensionTlv) r2
            int r2 = r2.getLength()
            if (r2 < r10) goto L_0x00b3
            if (r2 > r7) goto L_0x00b3
            int r2 = r2 + 3
        L_0x00b1:
            int r1 = r1 + r2
            goto L_0x009b
        L_0x00b3:
            if (r2 < 0) goto L_0x00ba
            if (r2 >= r10) goto L_0x00ba
            int r2 = r2 + 2
            goto L_0x00b1
        L_0x00ba:
            r4 = r5
        L_0x00bb:
            if (r11 == r1) goto L_0x00be
            r4 = r5
        L_0x00be:
            com.android.internal.telephony.cat.BerTlv r0 = new com.android.internal.telephony.cat.BerTlv
            r0.<init>(r6, r13, r4)
            return r0
        L_0x00c4:
            com.android.internal.telephony.cat.ResultException r13 = new com.android.internal.telephony.cat.ResultException
            com.android.internal.telephony.cat.ResultCode r0 = com.android.internal.telephony.cat.ResultCode.CMD_DATA_NOT_UNDERSTOOD
            java.lang.StringBuilder r3 = new java.lang.StringBuilder
            r3.<init>()
            java.lang.String r4 = "Command had extra data endIndex="
            r3.append(r4)
            r3.append(r1)
            r3.append(r9)
            r3.append(r2)
            java.lang.String r1 = " length="
            r3.append(r1)
            r3.append(r11)
            java.lang.String r1 = r3.toString()
            r13.<init>((com.android.internal.telephony.cat.ResultCode) r0, (java.lang.String) r1)
            throw r13
        L_0x00eb:
            r13 = move-exception
            com.android.internal.telephony.cat.ResultException r0 = new com.android.internal.telephony.cat.ResultException
            com.android.internal.telephony.cat.ResultCode r1 = com.android.internal.telephony.cat.ResultCode.CMD_DATA_NOT_UNDERSTOOD
            java.lang.String r13 = r13.explanation()
            r0.<init>((com.android.internal.telephony.cat.ResultCode) r1, (java.lang.String) r13)
            throw r0
        L_0x00f8:
            r2 = r4
        L_0x00f9:
            com.android.internal.telephony.cat.ResultException r13 = new com.android.internal.telephony.cat.ResultException
            com.android.internal.telephony.cat.ResultCode r3 = com.android.internal.telephony.cat.ResultCode.REQUIRED_VALUES_MISSING
            java.lang.StringBuilder r4 = new java.lang.StringBuilder
            r4.<init>()
            java.lang.String r5 = "IndexOutOfBoundsException  curIndex="
            r4.append(r5)
            r4.append(r2)
            r4.append(r0)
            r4.append(r1)
            java.lang.String r0 = r4.toString()
            r13.<init>((com.android.internal.telephony.cat.ResultCode) r3, (java.lang.String) r0)
            throw r13
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.cat.BerTlv.decode(byte[]):com.android.internal.telephony.cat.BerTlv");
    }
}
