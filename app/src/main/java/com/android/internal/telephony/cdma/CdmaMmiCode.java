package com.android.internal.telephony.cdma;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.os.ResultReceiver;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.GsmCdmaPhone;
import com.android.internal.telephony.MmiCode;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.UiccCardApplication;
import com.android.telephony.Rlog;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CdmaMmiCode extends Handler implements MmiCode {
    static final String ACTION_REGISTER = "**";
    static final int EVENT_SET_COMPLETE = 1;
    static final String LOG_TAG = "CdmaMmiCode";
    static final int MATCH_GROUP_ACTION = 2;
    static final int MATCH_GROUP_DIALING_NUMBER = 12;
    static final int MATCH_GROUP_POUND_STRING = 1;
    static final int MATCH_GROUP_PWD_CONFIRM = 11;
    static final int MATCH_GROUP_SERVICE_CODE = 3;
    static final int MATCH_GROUP_SIA = 5;
    static final int MATCH_GROUP_SIB = 7;
    static final int MATCH_GROUP_SIC = 9;
    static final String SC_PIN = "04";
    static final String SC_PIN2 = "042";
    static final String SC_PUK = "05";
    static final String SC_PUK2 = "052";
    static Pattern sPatternSuppService = Pattern.compile("((\\*|#|\\*#|\\*\\*|##)(\\d{2,3})(\\*([^*#]*)(\\*([^*#]*)(\\*([^*#]*)(\\*([^*#]*))?)?)?)?#)(.*)");
    String mAction;
    Context mContext;
    String mDialingNumber;
    CharSequence mMessage;
    GsmCdmaPhone mPhone;
    String mPoundString;
    String mPwd;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    String mSc;
    String mSia;
    String mSib;
    String mSic;
    MmiCode.State mState = MmiCode.State.PENDING;
    UiccCardApplication mUiccApplication;

    public static String getCallWaitingPrefix(boolean z) {
        return z ? "*74" : "*740";
    }

    public String getDialString() {
        return null;
    }

    public ResultReceiver getUssdCallbackReceiver() {
        return null;
    }

    public boolean isCancelable() {
        return false;
    }

    public static CdmaMmiCode newFromDialString(String str, GsmCdmaPhone gsmCdmaPhone, UiccCardApplication uiccCardApplication) {
        Matcher matcher = sPatternSuppService.matcher(str);
        if (!matcher.matches()) {
            return null;
        }
        CdmaMmiCode cdmaMmiCode = new CdmaMmiCode(gsmCdmaPhone, uiccCardApplication);
        cdmaMmiCode.mPoundString = makeEmptyNull(matcher.group(1));
        cdmaMmiCode.mAction = makeEmptyNull(matcher.group(2));
        cdmaMmiCode.mSc = makeEmptyNull(matcher.group(3));
        cdmaMmiCode.mSia = makeEmptyNull(matcher.group(5));
        cdmaMmiCode.mSib = makeEmptyNull(matcher.group(7));
        cdmaMmiCode.mSic = makeEmptyNull(matcher.group(9));
        cdmaMmiCode.mPwd = makeEmptyNull(matcher.group(11));
        cdmaMmiCode.mDialingNumber = makeEmptyNull(matcher.group(12));
        return cdmaMmiCode;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private static String makeEmptyNull(String str) {
        if (str == null || str.length() != 0) {
            return str;
        }
        return null;
    }

    protected CdmaMmiCode(GsmCdmaPhone gsmCdmaPhone, UiccCardApplication uiccCardApplication) {
        super(gsmCdmaPhone.getHandler().getLooper());
        this.mPhone = gsmCdmaPhone;
        this.mContext = gsmCdmaPhone.getContext();
        this.mUiccApplication = uiccCardApplication;
    }

    public MmiCode.State getState() {
        return this.mState;
    }

    public CharSequence getMessage() {
        return this.mMessage;
    }

    public Phone getPhone() {
        return this.mPhone;
    }

    public void cancel() {
        MmiCode.State state = this.mState;
        if (state != MmiCode.State.COMPLETE && state != MmiCode.State.FAILED) {
            this.mState = MmiCode.State.CANCELLED;
            this.mPhone.onMMIDone(this);
        }
    }

    public boolean isPinPukCommand() {
        String str = this.mSc;
        return str != null && (str.equals(SC_PIN) || this.mSc.equals(SC_PIN2) || this.mSc.equals(SC_PUK) || this.mSc.equals(SC_PUK2));
    }

    /* access modifiers changed from: package-private */
    public boolean isRegister() {
        String str = this.mAction;
        return str != null && str.equals(ACTION_REGISTER);
    }

    public boolean isUssdRequest() {
        Rlog.w(LOG_TAG, "isUssdRequest is not implemented in CdmaMmiCode");
        return false;
    }

    public void processCode() {
        UiccCardApplication uiccCardApplication;
        try {
            if (isPinPukCommand()) {
                String str = this.mSia;
                String str2 = this.mSib;
                int length = str2.length();
                if (!isRegister()) {
                    throw new RuntimeException("Ivalid register/action=" + this.mAction);
                } else if (!str2.equals(this.mSic)) {
                    handlePasswordError(17040825);
                } else {
                    if (length >= 4) {
                        if (length <= 8) {
                            if (this.mSc.equals(SC_PIN) && (uiccCardApplication = this.mUiccApplication) != null && uiccCardApplication.getState() == IccCardApplicationStatus.AppState.APPSTATE_PUK) {
                                handlePasswordError(17040853);
                                return;
                            } else if (this.mUiccApplication != null) {
                                Rlog.d(LOG_TAG, "process mmi service code using UiccApp sc=" + this.mSc);
                                if (this.mSc.equals(SC_PIN)) {
                                    this.mUiccApplication.changeIccLockPassword(str, str2, obtainMessage(1, this));
                                    return;
                                } else if (this.mSc.equals(SC_PIN2)) {
                                    this.mUiccApplication.changeIccFdnPassword(str, str2, obtainMessage(1, this));
                                    return;
                                } else if (this.mSc.equals(SC_PUK)) {
                                    this.mUiccApplication.supplyPuk(str, str2, obtainMessage(1, this));
                                    return;
                                } else if (this.mSc.equals(SC_PUK2)) {
                                    this.mUiccApplication.supplyPuk2(str, str2, obtainMessage(1, this));
                                    return;
                                } else {
                                    throw new RuntimeException("Unsupported service code=" + this.mSc);
                                }
                            } else {
                                throw new RuntimeException("No application mUiccApplicaiton is null");
                            }
                        }
                    }
                    handlePasswordError(17040507);
                }
            }
        } catch (RuntimeException unused) {
            this.mState = MmiCode.State.FAILED;
            this.mMessage = this.mContext.getText(17040835);
            this.mPhone.onMMIDone(this);
        }
    }

    private void handlePasswordError(int i) {
        this.mState = MmiCode.State.FAILED;
        StringBuilder sb = new StringBuilder(getScString());
        sb.append("\n");
        sb.append(this.mContext.getText(i));
        this.mMessage = sb;
        this.mPhone.onMMIDone(this);
    }

    public void handleMessage(Message message) {
        if (message.what == 1) {
            onSetComplete(message, (AsyncResult) message.obj);
        } else {
            Rlog.e(LOG_TAG, "Unexpected reply");
        }
    }

    private CharSequence getScString() {
        return (this.mSc == null || !isPinPukCommand()) ? "" : this.mContext.getText(17039558);
    }

    private void onSetComplete(Message message, AsyncResult asyncResult) {
        StringBuilder sb = new StringBuilder(getScString());
        sb.append("\n");
        Throwable th = asyncResult.exception;
        if (th != null) {
            this.mState = MmiCode.State.FAILED;
            if (th instanceof CommandException) {
                CommandException.Error commandError = ((CommandException) th).getCommandError();
                if (commandError == CommandException.Error.PASSWORD_INCORRECT) {
                    if (isPinPukCommand()) {
                        if (this.mSc.equals(SC_PUK) || this.mSc.equals(SC_PUK2)) {
                            sb.append(this.mContext.getText(17039795));
                        } else {
                            sb.append(this.mContext.getText(17039794));
                        }
                        int i = message.arg1;
                        if (i <= 0) {
                            Rlog.d(LOG_TAG, "onSetComplete: PUK locked, cancel as lock screen will handle this");
                            this.mState = MmiCode.State.CANCELLED;
                        } else if (i > 0) {
                            Rlog.d(LOG_TAG, "onSetComplete: attemptsRemaining=" + i);
                            sb.append(this.mContext.getResources().getQuantityString(18153472, i, new Object[]{Integer.valueOf(i)}));
                        }
                    } else {
                        sb.append(this.mContext.getText(17040960));
                    }
                } else if (commandError == CommandException.Error.SIM_PUK2) {
                    sb.append(this.mContext.getText(17039794));
                    sb.append("\n");
                    sb.append(this.mContext.getText(17040854));
                } else if (commandError != CommandException.Error.REQUEST_NOT_SUPPORTED) {
                    sb.append(this.mContext.getText(17040835));
                } else if (this.mSc.equals(SC_PIN)) {
                    sb.append(this.mContext.getText(17040209));
                }
            } else {
                sb.append(this.mContext.getText(17040835));
            }
        } else if (isRegister()) {
            this.mState = MmiCode.State.COMPLETE;
            sb.append(this.mContext.getText(17041529));
        } else {
            this.mState = MmiCode.State.FAILED;
            sb.append(this.mContext.getText(17040835));
        }
        this.mMessage = sb;
        this.mPhone.onMMIDone(this);
    }

    public static String getCallForwardingPrefixAndNumber(int i, int i2, String str) {
        if (i2 != 0) {
            if (i2 != 1) {
                if (i2 != 2) {
                    if (i2 != 3) {
                        Rlog.d(LOG_TAG, "getCallForwardingPrefix not match any prefix");
                    } else if (i == 3) {
                        return "*68" + str;
                    } else if (i == 0) {
                        return "*680";
                    }
                } else if (i == 3) {
                    return "*92" + str;
                } else if (i == 0) {
                    return "*920";
                }
            } else if (i == 3) {
                return "*90" + str;
            } else if (i == 0) {
                return "*900";
            }
        } else if (i == 3) {
            return "*72" + str;
        } else if (i == 0) {
            return "*720";
        }
        return "";
    }

    public boolean isNetworkInitiatedUssd() {
        Rlog.w(LOG_TAG, "isNetworkInitiated is not implemented in CdmaMmiCode");
        return false;
    }
}
