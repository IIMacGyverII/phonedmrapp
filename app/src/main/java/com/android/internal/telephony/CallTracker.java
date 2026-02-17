package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.os.PersistableBundle;
import android.telephony.CarrierConfigManager;
import android.text.TextUtils;
import com.android.internal.telephony.Call;
import com.android.internal.telephony.CommandException;
import com.android.internal.telephony.PhoneConstants;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;

public abstract class CallTracker extends Handler {
    private static final boolean DBG_POLL = false;
    protected static final int EVENT_CALL_STATE_CHANGE = 2;
    protected static final int EVENT_CALL_WAITING_INFO_CDMA = 15;
    protected static final int EVENT_CONFERENCE_RESULT = 11;
    protected static final int EVENT_ECT_RESULT = 13;
    protected static final int EVENT_EXIT_ECM_RESPONSE_CDMA = 14;
    protected static final int EVENT_GET_LAST_CALL_FAIL_CAUSE = 5;
    protected static final int EVENT_OPERATION_COMPLETE = 4;
    protected static final int EVENT_POLL_CALLS_RESULT = 1;
    protected static final int EVENT_RADIO_AVAILABLE = 9;
    protected static final int EVENT_RADIO_NOT_AVAILABLE = 10;
    protected static final int EVENT_REPOLL_AFTER_DELAY = 3;
    protected static final int EVENT_SEPARATE_RESULT = 12;
    protected static final int EVENT_SWITCH_RESULT = 8;
    protected static final int EVENT_THREE_WAY_DIAL_BLANK_FLASH = 20;
    protected static final int EVENT_THREE_WAY_DIAL_L2_RESULT_CDMA = 16;
    static final int POLL_DELAY_MSEC = 250;
    private final int VALID_COMPARE_LENGTH = 3;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public CommandsInterface mCi;
    protected ArrayList<Connection> mHandoverConnections = new ArrayList<>();
    protected Message mLastRelevantPoll;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mNeedsPoll;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected boolean mNumberConverted = false;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected int mPendingOperations;

    public void cleanupCalls() {
    }

    /* access modifiers changed from: protected */
    public abstract Phone getPhone();

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public abstract PhoneConstants.State getState();

    public abstract void handleMessage(Message message);

    /* access modifiers changed from: protected */
    public abstract void handlePollCalls(AsyncResult asyncResult);

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public abstract void log(String str);

    /* access modifiers changed from: protected */
    public void onSrvccStarted() {
    }

    @UnsupportedAppUsage
    public abstract void registerForVoiceCallEnded(Handler handler, int i, Object obj);

    public abstract void registerForVoiceCallStarted(Handler handler, int i, Object obj);

    public abstract void unregisterForVoiceCallEnded(Handler handler);

    public abstract void unregisterForVoiceCallStarted(Handler handler);

    /* access modifiers changed from: protected */
    public void pollCallsWhenSafe() {
        this.mNeedsPoll = true;
        if (checkNoOperationsPending()) {
            Message obtainMessage = obtainMessage(1);
            this.mLastRelevantPoll = obtainMessage;
            this.mCi.getCurrentCalls(obtainMessage);
        }
    }

    /* access modifiers changed from: protected */
    public void pollCallsAfterDelay() {
        Message obtainMessage = obtainMessage();
        obtainMessage.what = 3;
        sendMessageDelayed(obtainMessage, 250);
    }

    /* access modifiers changed from: protected */
    public boolean isCommandExceptionRadioNotAvailable(Throwable th) {
        return th != null && (th instanceof CommandException) && ((CommandException) th).getCommandError() == CommandException.Error.RADIO_NOT_AVAILABLE;
    }

    /* access modifiers changed from: protected */
    public Connection getHoConnection(DriverCall driverCall) {
        Iterator<Connection> it = this.mHandoverConnections.iterator();
        while (it.hasNext()) {
            Connection next = it.next();
            log("getHoConnection - compare number: hoConn= " + next.toString());
            String str = driverCall.number;
            if (str == null || str.isEmpty()) {
                break;
            } else if (next.getAddress() != null && next.getAddress().contains(driverCall.number)) {
                log("getHoConnection: Handover connection match found = " + next.toString());
                return next;
            }
        }
        Iterator<Connection> it2 = this.mHandoverConnections.iterator();
        while (it2.hasNext()) {
            Connection next2 = it2.next();
            log("getHoConnection: compare state hoConn= " + next2.toString());
            if (next2.getStateBeforeHandover() == Call.stateFromDCState(driverCall.state)) {
                log("getHoConnection: Handover connection match found = " + next2.toString());
                return next2;
            }
        }
        return null;
    }

    /* access modifiers changed from: protected */
    public void notifySrvccState(Call.SrvccState srvccState, ArrayList<Connection> arrayList) {
        if (srvccState == Call.SrvccState.STARTED && arrayList != null) {
            this.mHandoverConnections.addAll(arrayList);
            onSrvccStarted();
        } else if (srvccState != Call.SrvccState.COMPLETED) {
            this.mHandoverConnections.clear();
        }
        log("notifySrvccState: state=" + srvccState.name() + ", mHandoverConnections= " + this.mHandoverConnections.toString());
    }

    /* access modifiers changed from: protected */
    public void handleRadioAvailable() {
        pollCallsWhenSafe();
    }

    /* access modifiers changed from: protected */
    public Message obtainNoPollCompleteMessage(int i) {
        this.mPendingOperations++;
        this.mLastRelevantPoll = null;
        return obtainMessage(i);
    }

    private boolean checkNoOperationsPending() {
        return this.mPendingOperations == 0;
    }

    /* access modifiers changed from: protected */
    public String convertNumberIfNecessary(Phone phone, String str) {
        if (str == null) {
            return str;
        }
        String[] strArr = null;
        PersistableBundle configForSubId = ((CarrierConfigManager) phone.getContext().getSystemService("carrier_config")).getConfigForSubId(phone.getSubId());
        if (configForSubId != null) {
            if (shouldPerformInternationalNumberRemapping(phone, configForSubId)) {
                strArr = configForSubId.getStringArray("international_roaming_dial_string_replace_string_array");
            } else {
                strArr = configForSubId.getStringArray("dial_string_replace_string_array");
            }
        }
        if (strArr == null) {
            log("convertNumberIfNecessary convertMaps is null");
            return str;
        }
        log("convertNumberIfNecessary Roaming convertMaps.length " + strArr.length + " dialNumber.length() " + str.length());
        if (strArr.length >= 1 && str.length() >= 3) {
            String str2 = "";
            int length = strArr.length;
            int i = 0;
            while (true) {
                if (i >= length) {
                    break;
                }
                String str3 = strArr[i];
                log("convertNumberIfNecessary: " + str3);
                String[] split = str3.split(":");
                if (split != null && split.length > 1) {
                    String str4 = split[0];
                    String str5 = split[1];
                    if (!TextUtils.isEmpty(str4) && str.equals(str4)) {
                        if (TextUtils.isEmpty(str5) || !str5.endsWith("MDN")) {
                            str2 = str5;
                        } else {
                            String line1Number = phone.getLine1Number();
                            if (!TextUtils.isEmpty(line1Number)) {
                                if (!line1Number.startsWith("+")) {
                                    line1Number = str5.substring(0, str5.length() - 3) + line1Number;
                                }
                                str2 = line1Number;
                            }
                        }
                    }
                }
                i++;
            }
            if (!TextUtils.isEmpty(str2)) {
                log("convertNumberIfNecessary: convert service number");
                this.mNumberConverted = true;
                return str2;
            }
        }
        return str;
    }

    private boolean shouldPerformInternationalNumberRemapping(Phone phone, PersistableBundle persistableBundle) {
        if (phone == null || phone.getDefaultPhone() == null) {
            log("shouldPerformInternationalNumberRemapping: phone was null");
            return false;
        } else if (persistableBundle.getStringArray("international_roaming_dial_string_replace_string_array") == null) {
            log("shouldPerformInternationalNumberRemapping: did not set the KEY_INTERNATIONAL_ROAMING_DIAL_STRING_REPLACE_STRING_ARRAY");
            return false;
        } else if (phone.getDefaultPhone().getServiceState().getVoiceRoamingType() == 3) {
            return true;
        } else {
            return false;
        }
    }

    private boolean compareGid1(Phone phone, String str) {
        String groupIdLevel1 = phone.getGroupIdLevel1();
        int length = str.length();
        boolean z = true;
        if (str.equals("")) {
            log("compareGid1 serviceGid is empty, return " + true);
            return true;
        }
        if (groupIdLevel1 == null || groupIdLevel1.length() < length || !groupIdLevel1.substring(0, length).equalsIgnoreCase(str)) {
            log(" gid1 " + groupIdLevel1 + " serviceGid1 " + str);
            z = false;
        }
        StringBuilder sb = new StringBuilder();
        sb.append("compareGid1 is ");
        sb.append(z ? "Same" : "Different");
        log(sb.toString());
        return z;
    }

    public Connection getRingingHandoverConnection() {
        Iterator<Connection> it = this.mHandoverConnections.iterator();
        while (it.hasNext()) {
            Connection next = it.next();
            if (next.getCall().isRinging()) {
                return next;
            }
        }
        return null;
    }

    public void dump(FileDescriptor fileDescriptor, PrintWriter printWriter, String[] strArr) {
        printWriter.println("CallTracker:");
        printWriter.println(" mPendingOperations=" + this.mPendingOperations);
        printWriter.println(" mNeedsPoll=" + this.mNeedsPoll);
        printWriter.println(" mLastRelevantPoll=" + this.mLastRelevantPoll);
    }
}
