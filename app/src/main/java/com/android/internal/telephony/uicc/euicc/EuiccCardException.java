package com.android.internal.telephony.uicc.euicc;

public class EuiccCardException extends Exception {
    public EuiccCardException() {
    }

    public EuiccCardException(String str) {
        super(str);
    }

    public EuiccCardException(String str, Throwable th) {
        super(str, th);
    }
}
