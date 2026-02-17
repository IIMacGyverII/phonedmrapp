package com.android.internal.telephony;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.BadParcelableException;
import android.os.Bundle;
import android.telephony.NetworkRegistrationInfo;
import android.telephony.ServiceState;
import android.telephony.ims.ImsCallProfile;
import android.telephony.ims.ImsConferenceState;
import android.telephony.ims.ImsExternalCallState;
import android.telephony.ims.ImsReasonInfo;
import com.android.ims.ImsCall;
import com.android.internal.telephony.PhoneInternalInterface;
import com.android.internal.telephony.gsm.SuppServiceNotification;
import com.android.internal.telephony.imsphone.ImsExternalCallTracker;
import com.android.internal.telephony.imsphone.ImsPhone;
import com.android.internal.telephony.imsphone.ImsPhoneCall;
import com.android.internal.telephony.imsphone.ImsPhoneCallTracker;
import com.android.internal.telephony.test.TestConferenceEventPackageParser;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class TelephonyTester {
    private static final String ACTION_RESET = "reset";
    private static final String ACTION_TEST_CHANGE_NUMBER = "com.android.internal.telephony.TestChangeNumber";
    private static final String ACTION_TEST_CONFERENCE_EVENT_PACKAGE = "com.android.internal.telephony.TestConferenceEventPackage";
    private static final String ACTION_TEST_DIALOG_EVENT_PACKAGE = "com.android.internal.telephony.TestDialogEventPackage";
    private static final String ACTION_TEST_HANDOVER_FAIL = "com.android.internal.telephony.TestHandoverFail";
    private static final String ACTION_TEST_IMS_E_CALL = "com.android.internal.telephony.TestImsECall";
    private static final String ACTION_TEST_RECEIVE_DTMF = "com.android.internal.telephony.TestReceiveDtmf";
    private static final String ACTION_TEST_SERVICE_STATE = "com.android.internal.telephony.TestServiceState";
    private static final String ACTION_TEST_SUPP_SRVC_FAIL = "com.android.internal.telephony.TestSuppSrvcFail";
    private static final String ACTION_TEST_SUPP_SRVC_NOTIFICATION = "com.android.internal.telephony.TestSuppSrvcNotification";
    private static final boolean DBG = true;
    private static final String EXTRA_ACTION = "action";
    private static final String EXTRA_BYPASS_IMSCALL = "bypassImsCall";
    private static final String EXTRA_CANPULL = "canPull";
    private static final String EXTRA_CODE = "code";
    private static final String EXTRA_DATA_RAT = "data_rat";
    private static final String EXTRA_DATA_REG_STATE = "data_reg_state";
    private static final String EXTRA_DATA_ROAMING_TYPE = "data_roaming_type";
    private static final String EXTRA_DIALOGID = "dialogId";
    private static final String EXTRA_DIGIT = "digit";
    private static final String EXTRA_FAILURE_CODE = "failureCode";
    private static final String EXTRA_FILENAME = "filename";
    private static final String EXTRA_NR_FREQUENCY_RANGE = "nr_frequency_range";
    private static final String EXTRA_NR_STATE = "nr_state";
    private static final String EXTRA_NUMBER = "number";
    private static final String EXTRA_OPERATOR = "operator";
    private static final String EXTRA_OPERATOR_RAW = "operator_raw";
    private static final String EXTRA_SENDPACKAGE = "sendPackage";
    private static final String EXTRA_STARTPACKAGE = "startPackage";
    private static final String EXTRA_STATE = "state";
    private static final String EXTRA_TYPE = "type";
    private static final String EXTRA_VOICE_RAT = "voice_rat";
    private static final String EXTRA_VOICE_REG_STATE = "voice_reg_state";
    private static final String EXTRA_VOICE_ROAMING_TYPE = "voice_roaming_type";
    private static final String LOG_TAG = "TelephonyTester";
    private static List<ImsExternalCallState> mImsExternalCallStates;
    protected BroadcastReceiver mIntentReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            try {
                TelephonyTester.log("sIntentReceiver.onReceive: action=" + action);
                if (action.equals(TelephonyTester.this.mPhone.getActionDetached())) {
                    TelephonyTester.log("simulate detaching");
                    TelephonyTester.this.mPhone.getServiceStateTracker().mDetachedRegistrants.get(1).notifyRegistrants();
                } else if (action.equals(TelephonyTester.this.mPhone.getActionAttached())) {
                    TelephonyTester.log("simulate attaching");
                    TelephonyTester.this.mPhone.getServiceStateTracker().mAttachedRegistrants.get(1).notifyRegistrants();
                } else if (action.equals(TelephonyTester.ACTION_TEST_CONFERENCE_EVENT_PACKAGE)) {
                    TelephonyTester.log("inject simulated conference event package");
                    TelephonyTester.this.handleTestConferenceEventPackage(context, intent.getStringExtra(TelephonyTester.EXTRA_FILENAME), intent.getBooleanExtra(TelephonyTester.EXTRA_BYPASS_IMSCALL, false));
                } else if (action.equals(TelephonyTester.ACTION_TEST_DIALOG_EVENT_PACKAGE)) {
                    TelephonyTester.log("handle test dialog event package intent");
                    TelephonyTester.this.handleTestDialogEventPackageIntent(intent);
                } else if (action.equals(TelephonyTester.ACTION_TEST_SUPP_SRVC_FAIL)) {
                    TelephonyTester.log("handle test supp svc failed intent");
                    TelephonyTester.this.handleSuppServiceFailedIntent(intent);
                } else if (action.equals(TelephonyTester.ACTION_TEST_HANDOVER_FAIL)) {
                    TelephonyTester.log("handle handover fail test intent");
                    TelephonyTester.this.handleHandoverFailedIntent();
                } else if (action.equals(TelephonyTester.ACTION_TEST_SUPP_SRVC_NOTIFICATION)) {
                    TelephonyTester.log("handle supp service notification test intent");
                    TelephonyTester.this.sendTestSuppServiceNotification(intent);
                } else if (action.equals(TelephonyTester.ACTION_TEST_SERVICE_STATE)) {
                    TelephonyTester.log("handle test service state changed intent");
                    TelephonyTester.this.mServiceStateTestIntent = intent;
                    TelephonyTester.this.mPhone.getServiceStateTracker().sendEmptyMessage(2);
                } else if (action.equals(TelephonyTester.ACTION_TEST_IMS_E_CALL)) {
                    TelephonyTester.log("handle test IMS ecall intent");
                    TelephonyTester.this.testImsECall();
                } else if (action.equals(TelephonyTester.ACTION_TEST_RECEIVE_DTMF)) {
                    TelephonyTester.log("handle test DTMF intent");
                    TelephonyTester.this.testImsReceiveDtmf(intent);
                } else if (action.equals(TelephonyTester.ACTION_TEST_CHANGE_NUMBER)) {
                    TelephonyTester.log("handle test change number intent");
                    TelephonyTester.this.testChangeNumber(intent);
                } else {
                    TelephonyTester.log("onReceive: unknown action=" + action);
                }
            } catch (BadParcelableException e) {
                Rlog.w(TelephonyTester.LOG_TAG, e);
            }
        }
    };
    /* access modifiers changed from: private */
    public Phone mPhone;
    /* access modifiers changed from: private */
    public Intent mServiceStateTestIntent;

    TelephonyTester(Phone phone) {
        this.mPhone = phone;
        if (TelephonyUtils.IS_DEBUGGABLE) {
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction(this.mPhone.getActionDetached());
            log("register for intent action=" + this.mPhone.getActionDetached());
            intentFilter.addAction(this.mPhone.getActionAttached());
            log("register for intent action=" + this.mPhone.getActionAttached());
            if (this.mPhone.getPhoneType() == 5) {
                log("register for intent action=com.android.internal.telephony.TestConferenceEventPackage");
                intentFilter.addAction(ACTION_TEST_CONFERENCE_EVENT_PACKAGE);
                intentFilter.addAction(ACTION_TEST_DIALOG_EVENT_PACKAGE);
                intentFilter.addAction(ACTION_TEST_SUPP_SRVC_FAIL);
                intentFilter.addAction(ACTION_TEST_HANDOVER_FAIL);
                intentFilter.addAction(ACTION_TEST_SUPP_SRVC_NOTIFICATION);
                intentFilter.addAction(ACTION_TEST_IMS_E_CALL);
                intentFilter.addAction(ACTION_TEST_RECEIVE_DTMF);
                mImsExternalCallStates = new ArrayList();
            }
            intentFilter.addAction(ACTION_TEST_SERVICE_STATE);
            log("register for intent action=com.android.internal.telephony.TestServiceState");
            intentFilter.addAction(ACTION_TEST_CHANGE_NUMBER);
            log("register for intent action=com.android.internal.telephony.TestChangeNumber");
            phone.getContext().registerReceiver(this.mIntentReceiver, intentFilter, (String) null, this.mPhone.getHandler(), 2);
        }
    }

    /* access modifiers changed from: package-private */
    public void dispose() {
        if (TelephonyUtils.IS_DEBUGGABLE) {
            this.mPhone.getContext().unregisterReceiver(this.mIntentReceiver);
        }
    }

    /* access modifiers changed from: private */
    public static void log(String str) {
        Rlog.d(LOG_TAG, str);
    }

    /* access modifiers changed from: private */
    public void handleSuppServiceFailedIntent(Intent intent) {
        ImsPhone imsPhone = (ImsPhone) this.mPhone;
        if (imsPhone != null) {
            imsPhone.notifySuppServiceFailed(PhoneInternalInterface.SuppService.values()[intent.getIntExtra(EXTRA_FAILURE_CODE, 0)]);
        }
    }

    /* access modifiers changed from: private */
    public void handleHandoverFailedIntent() {
        ImsCall imsCall = getImsCall();
        if (imsCall != null) {
            imsCall.getImsCallSessionListenerProxy().callSessionHandoverFailed(imsCall.getCallSession(), 13, 18, new ImsReasonInfo());
        }
    }

    /* access modifiers changed from: private */
    public void handleTestConferenceEventPackage(Context context, String str, boolean z) {
        ImsCall imsCall;
        ImsPhone imsPhone = (ImsPhone) this.mPhone;
        if (imsPhone != null) {
            ImsPhoneCallTracker imsPhoneCallTracker = (ImsPhoneCallTracker) imsPhone.getCallTracker();
            File file = new File(context.getFilesDir(), str);
            try {
                ImsConferenceState parse = new TestConferenceEventPackageParser(new FileInputStream(file)).parse();
                if (parse != null) {
                    if (z) {
                        imsPhoneCallTracker.injectTestConferenceState(parse);
                        return;
                    }
                    ImsPhoneCall foregroundCall = imsPhone.getForegroundCall();
                    if (foregroundCall != null && (imsCall = foregroundCall.getImsCall()) != null) {
                        imsCall.conferenceStateUpdated(parse);
                    }
                }
            } catch (FileNotFoundException unused) {
                log("Test conference event package file not found: " + file.getAbsolutePath());
            }
        }
    }

    /* access modifiers changed from: private */
    public void handleTestDialogEventPackageIntent(Intent intent) {
        ImsExternalCallTracker externalCallTracker;
        ImsPhone imsPhone = (ImsPhone) this.mPhone;
        if (imsPhone != null && (externalCallTracker = imsPhone.getExternalCallTracker()) != null) {
            if (intent.hasExtra(EXTRA_STARTPACKAGE)) {
                mImsExternalCallStates.clear();
            } else if (intent.hasExtra(EXTRA_SENDPACKAGE)) {
                externalCallTracker.refreshExternalCallState(mImsExternalCallStates);
                mImsExternalCallStates.clear();
            } else if (intent.hasExtra(EXTRA_DIALOGID)) {
                mImsExternalCallStates.add(new ImsExternalCallState(intent.getIntExtra(EXTRA_DIALOGID, 0), Uri.parse(intent.getStringExtra("number")), intent.getBooleanExtra(EXTRA_CANPULL, true), intent.getIntExtra(EXTRA_STATE, 1), 2, false));
            }
        }
    }

    /* access modifiers changed from: private */
    public void sendTestSuppServiceNotification(Intent intent) {
        if (intent.hasExtra(EXTRA_CODE) && intent.hasExtra("type")) {
            int intExtra = intent.getIntExtra(EXTRA_CODE, -1);
            int intExtra2 = intent.getIntExtra("type", -1);
            ImsPhone imsPhone = (ImsPhone) this.mPhone;
            if (imsPhone != null) {
                log("Test supp service notification:" + intExtra);
                SuppServiceNotification suppServiceNotification = new SuppServiceNotification();
                suppServiceNotification.code = intExtra;
                suppServiceNotification.notificationType = intExtra2;
                imsPhone.notifySuppSvcNotification(suppServiceNotification);
            }
        }
    }

    /* access modifiers changed from: package-private */
    public void overrideServiceState(ServiceState serviceState) {
        Intent intent = this.mServiceStateTestIntent;
        if (intent != null && serviceState != null) {
            if (!intent.hasExtra(EXTRA_ACTION) || !ACTION_RESET.equals(this.mServiceStateTestIntent.getStringExtra(EXTRA_ACTION))) {
                if (this.mServiceStateTestIntent.hasExtra(EXTRA_VOICE_REG_STATE)) {
                    serviceState.setVoiceRegState(this.mServiceStateTestIntent.getIntExtra(EXTRA_VOICE_REG_STATE, 1));
                    log("Override voice service state with " + serviceState.getState());
                }
                if (this.mServiceStateTestIntent.hasExtra(EXTRA_DATA_REG_STATE)) {
                    serviceState.setDataRegState(this.mServiceStateTestIntent.getIntExtra(EXTRA_DATA_REG_STATE, 1));
                    log("Override data service state with " + serviceState.getDataRegistrationState());
                }
                if (this.mServiceStateTestIntent.hasExtra(EXTRA_OPERATOR)) {
                    String[] split = this.mServiceStateTestIntent.getStringExtra(EXTRA_OPERATOR).split(",");
                    String str = "";
                    String str2 = split.length > 0 ? split[0] : str;
                    String str3 = split.length > 1 ? split[1] : str2;
                    if (split.length > 2) {
                        str = split[2];
                    }
                    serviceState.setOperatorName(str2, str3, str);
                    log("Override operator with " + Arrays.toString(split));
                }
                if (this.mServiceStateTestIntent.hasExtra(EXTRA_OPERATOR_RAW)) {
                    String stringExtra = this.mServiceStateTestIntent.getStringExtra(EXTRA_OPERATOR_RAW);
                    serviceState.setOperatorAlphaLongRaw(stringExtra);
                    serviceState.setOperatorAlphaShortRaw(stringExtra);
                    log("Override operator_raw with " + stringExtra);
                }
                if (this.mServiceStateTestIntent.hasExtra(EXTRA_NR_FREQUENCY_RANGE)) {
                    serviceState.setNrFrequencyRange(this.mServiceStateTestIntent.getIntExtra(EXTRA_NR_FREQUENCY_RANGE, 0));
                    log("Override NR frequency range with " + serviceState.getNrFrequencyRange());
                }
                if (this.mServiceStateTestIntent.hasExtra(EXTRA_NR_STATE)) {
                    NetworkRegistrationInfo networkRegistrationInfo = serviceState.getNetworkRegistrationInfo(2, 1);
                    if (networkRegistrationInfo == null) {
                        networkRegistrationInfo = new NetworkRegistrationInfo.Builder().setDomain(2).setTransportType(1).build();
                    }
                    networkRegistrationInfo.setNrState(this.mServiceStateTestIntent.getIntExtra(EXTRA_NR_STATE, 0));
                    serviceState.addNetworkRegistrationInfo(networkRegistrationInfo);
                    log("Override NR state with " + serviceState.getNrState());
                }
                if (this.mServiceStateTestIntent.hasExtra(EXTRA_VOICE_RAT)) {
                    NetworkRegistrationInfo networkRegistrationInfo2 = serviceState.getNetworkRegistrationInfo(1, 1);
                    if (networkRegistrationInfo2 == null) {
                        networkRegistrationInfo2 = new NetworkRegistrationInfo.Builder().setDomain(1).setTransportType(1).build();
                    }
                    networkRegistrationInfo2.setAccessNetworkTechnology(ServiceState.rilRadioTechnologyToNetworkType(this.mServiceStateTestIntent.getIntExtra(EXTRA_VOICE_RAT, 0)));
                    serviceState.addNetworkRegistrationInfo(networkRegistrationInfo2);
                    log("Override voice rat with " + serviceState.getRilVoiceRadioTechnology());
                }
                if (this.mServiceStateTestIntent.hasExtra(EXTRA_DATA_RAT)) {
                    NetworkRegistrationInfo networkRegistrationInfo3 = serviceState.getNetworkRegistrationInfo(2, 1);
                    if (networkRegistrationInfo3 == null) {
                        networkRegistrationInfo3 = new NetworkRegistrationInfo.Builder().setDomain(2).setTransportType(1).build();
                    }
                    networkRegistrationInfo3.setAccessNetworkTechnology(ServiceState.rilRadioTechnologyToNetworkType(this.mServiceStateTestIntent.getIntExtra(EXTRA_DATA_RAT, 0)));
                    serviceState.addNetworkRegistrationInfo(networkRegistrationInfo3);
                    log("Override data rat with " + serviceState.getRilDataRadioTechnology());
                }
                if (this.mServiceStateTestIntent.hasExtra(EXTRA_VOICE_ROAMING_TYPE)) {
                    NetworkRegistrationInfo networkRegistrationInfo4 = serviceState.getNetworkRegistrationInfo(1, 1);
                    if (networkRegistrationInfo4 == null) {
                        networkRegistrationInfo4 = new NetworkRegistrationInfo.Builder().setDomain(1).setTransportType(1).build();
                    }
                    networkRegistrationInfo4.setRoamingType(this.mServiceStateTestIntent.getIntExtra(EXTRA_VOICE_ROAMING_TYPE, 1));
                    serviceState.addNetworkRegistrationInfo(networkRegistrationInfo4);
                    log("Override voice roaming type with " + serviceState.getVoiceRoamingType());
                }
                if (this.mServiceStateTestIntent.hasExtra(EXTRA_DATA_ROAMING_TYPE)) {
                    NetworkRegistrationInfo networkRegistrationInfo5 = serviceState.getNetworkRegistrationInfo(2, 1);
                    if (networkRegistrationInfo5 == null) {
                        networkRegistrationInfo5 = new NetworkRegistrationInfo.Builder().setDomain(2).setTransportType(1).build();
                    }
                    networkRegistrationInfo5.setRoamingType(this.mServiceStateTestIntent.getIntExtra(EXTRA_DATA_ROAMING_TYPE, 1));
                    serviceState.addNetworkRegistrationInfo(networkRegistrationInfo5);
                    log("Override data roaming type with " + serviceState.getDataRoamingType());
                    return;
                }
                return;
            }
            log("Service state override reset");
        }
    }

    /* access modifiers changed from: package-private */
    public void testImsECall() {
        ImsCall imsCall = getImsCall();
        if (imsCall != null) {
            ImsCallProfile callProfile = imsCall.getCallProfile();
            Bundle callExtras = callProfile.getCallExtras();
            if (callExtras == null) {
                callExtras = new Bundle();
            }
            callExtras.putBoolean("e_call", true);
            callProfile.mCallExtras = callExtras;
            imsCall.getImsCallSessionListenerProxy().callSessionUpdated(imsCall.getSession(), callProfile);
        }
    }

    private ImsCall getImsCall() {
        ImsPhoneCall foregroundCall;
        ImsCall imsCall;
        ImsPhone imsPhone = (ImsPhone) this.mPhone;
        if (imsPhone == null || (foregroundCall = imsPhone.getForegroundCall()) == null || (imsCall = foregroundCall.getImsCall()) == null) {
            return null;
        }
        return imsCall;
    }

    /* access modifiers changed from: package-private */
    public void testImsReceiveDtmf(Intent intent) {
        if (intent.hasExtra(EXTRA_DIGIT)) {
            char charAt = intent.getStringExtra(EXTRA_DIGIT).charAt(0);
            ImsCall imsCall = getImsCall();
            if (imsCall != null) {
                imsCall.getImsCallSessionListenerProxy().callSessionDtmfReceived(charAt);
            }
        }
    }

    /* access modifiers changed from: package-private */
    public void testChangeNumber(Intent intent) {
        if (intent.hasExtra("number")) {
            this.mPhone.getForegroundCall().getConnections().stream().forEach(new TelephonyTester$$ExternalSyntheticLambda0(intent.getStringExtra("number")));
            Phone phone = this.mPhone;
            if (phone instanceof GsmCdmaPhone) {
                ((GsmCdmaPhone) phone).notifyPhoneStateChanged();
                ((GsmCdmaPhone) this.mPhone).notifyPreciseCallStateChanged();
            } else if (phone instanceof ImsPhone) {
                ((ImsPhone) phone).notifyPhoneStateChanged();
                ((ImsPhone) this.mPhone).notifyPreciseCallStateChanged();
            }
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ void lambda$testChangeNumber$0(String str, Connection connection) {
        connection.setAddress(str, 1);
        connection.setDialString(str);
    }
}
