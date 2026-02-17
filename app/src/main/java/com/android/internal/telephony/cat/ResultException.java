package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;

public class ResultException extends CatException {
    protected int mAdditionalInfo;
    protected String mExplanation;
    protected ResultCode mResult;

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public ResultException(ResultCode resultCode) {
        switch (AnonymousClass1.$SwitchMap$com$android$internal$telephony$cat$ResultCode[resultCode.ordinal()]) {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
                throw new AssertionError("For result code, " + resultCode + ", additional information must be given!");
            default:
                this.mResult = resultCode;
                this.mAdditionalInfo = -1;
                this.mExplanation = "";
                return;
        }
    }

    /* renamed from: com.android.internal.telephony.cat.ResultException$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$android$internal$telephony$cat$ResultCode;

        /* JADX WARNING: Can't wrap try/catch for region: R(18:0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|18) */
        /* JADX WARNING: Code restructure failed: missing block: B:19:?, code lost:
            return;
         */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:11:0x003e */
        /* JADX WARNING: Missing exception handler attribute for start block: B:13:0x0049 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:15:0x0054 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:9:0x0033 */
        static {
            /*
                com.android.internal.telephony.cat.ResultCode[] r0 = com.android.internal.telephony.cat.ResultCode.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$android$internal$telephony$cat$ResultCode = r0
                com.android.internal.telephony.cat.ResultCode r1 = com.android.internal.telephony.cat.ResultCode.TERMINAL_CRNTLY_UNABLE_TO_PROCESS     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x001d }
                com.android.internal.telephony.cat.ResultCode r1 = com.android.internal.telephony.cat.ResultCode.NETWORK_CRNTLY_UNABLE_TO_PROCESS     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.android.internal.telephony.cat.ResultCode r1 = com.android.internal.telephony.cat.ResultCode.LAUNCH_BROWSER_ERROR     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.android.internal.telephony.cat.ResultCode r1 = com.android.internal.telephony.cat.ResultCode.MULTI_CARDS_CMD_ERROR     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x003e }
                com.android.internal.telephony.cat.ResultCode r1 = com.android.internal.telephony.cat.ResultCode.USIM_CALL_CONTROL_PERMANENT     // Catch:{ NoSuchFieldError -> 0x003e }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x003e }
                r2 = 5
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x003e }
            L_0x003e:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x0049 }
                com.android.internal.telephony.cat.ResultCode r1 = com.android.internal.telephony.cat.ResultCode.BIP_ERROR     // Catch:{ NoSuchFieldError -> 0x0049 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0049 }
                r2 = 6
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0049 }
            L_0x0049:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x0054 }
                com.android.internal.telephony.cat.ResultCode r1 = com.android.internal.telephony.cat.ResultCode.FRAMES_ERROR     // Catch:{ NoSuchFieldError -> 0x0054 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0054 }
                r2 = 7
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0054 }
            L_0x0054:
                int[] r0 = $SwitchMap$com$android$internal$telephony$cat$ResultCode     // Catch:{ NoSuchFieldError -> 0x0060 }
                com.android.internal.telephony.cat.ResultCode r1 = com.android.internal.telephony.cat.ResultCode.MMS_ERROR     // Catch:{ NoSuchFieldError -> 0x0060 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0060 }
                r2 = 8
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0060 }
            L_0x0060:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.cat.ResultException.AnonymousClass1.<clinit>():void");
        }
    }

    public ResultException(ResultCode resultCode, String str) {
        this(resultCode);
        this.mExplanation = str;
    }

    public ResultException(ResultCode resultCode, int i) {
        this(resultCode);
        if (i >= 0) {
            this.mAdditionalInfo = i;
            return;
        }
        throw new AssertionError("Additional info must be greater than zero!");
    }

    public ResultException(ResultCode resultCode, int i, String str) {
        this(resultCode, i);
        this.mExplanation = str;
    }

    public ResultCode result() {
        return this.mResult;
    }

    public boolean hasAdditionalInfo() {
        return this.mAdditionalInfo >= 0;
    }

    public int additionalInfo() {
        return this.mAdditionalInfo;
    }

    public String explanation() {
        return this.mExplanation;
    }

    public String toString() {
        return "result=" + this.mResult + " additionalInfo=" + this.mAdditionalInfo + " explantion=" + this.mExplanation;
    }
}
