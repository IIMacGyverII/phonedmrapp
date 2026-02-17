package com.android.internal.telephony.imsphone;

import android.content.Context;
import android.internal.telephony.sysprop.TelephonyProperties;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import android.telephony.CallQuality;
import android.telephony.NetworkScanRequest;
import android.telephony.ServiceState;
import android.telephony.SignalStrength;
import android.telephony.ims.ImsReasonInfo;
import android.util.Pair;
import com.android.internal.annotations.VisibleForTesting;
import com.android.internal.telephony.Connection;
import com.android.internal.telephony.IccCard;
import com.android.internal.telephony.IccPhoneBookInterfaceManager;
import com.android.internal.telephony.MmiCode;
import com.android.internal.telephony.OperatorInfo;
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneConstants;
import com.android.internal.telephony.PhoneInternalInterface;
import com.android.internal.telephony.PhoneNotifier;
import com.android.internal.telephony.RegistrantList;
import com.android.internal.telephony.dataconnection.DataConnection;
import com.android.internal.telephony.uicc.IccFileHandler;
import com.android.telephony.Rlog;
import java.util.ArrayList;
import java.util.List;

abstract class ImsPhoneBase extends Phone {
    private static final String LOG_TAG = "ImsPhoneBase";
    private RegistrantList mOnHoldRegistrants = new RegistrantList();
    private RegistrantList mRingbackRegistrants = new RegistrantList();
    private PhoneConstants.State mState = PhoneConstants.State.IDLE;
    private RegistrantList mTtyModeReceivedRegistrants = new RegistrantList();

    public boolean disableDataConnectivity() {
        return false;
    }

    public void disableLocationUpdates() {
    }

    public boolean enableDataConnectivity() {
        return false;
    }

    public void enableLocationUpdates() {
    }

    public void getAvailableNetworks(Message message) {
    }

    public void getCallBarring(String str, String str2, Message message, int i) {
    }

    public void getCallForwardingOption(int i, int i2, Message message) {
    }

    public void getCallForwardingOption(int i, Message message) {
    }

    public List<DataConnection> getCurrentDataConnectionList() {
        return null;
    }

    public int getDataActivityState() {
        return 0;
    }

    public boolean getDataRoamingEnabled() {
        return false;
    }

    public String getDeviceId() {
        return null;
    }

    public String getDeviceSvn() {
        return null;
    }

    public String getGroupIdLevel1() {
        return null;
    }

    public String getGroupIdLevel2() {
        return null;
    }

    public IccCard getIccCard() {
        return null;
    }

    public IccFileHandler getIccFileHandler() {
        return null;
    }

    public IccPhoneBookInterfaceManager getIccPhoneBookInterfaceManager() {
        return null;
    }

    public boolean getIccRecordsLoaded() {
        return false;
    }

    public String getIccSerialNumber() {
        return null;
    }

    public String getImei() {
        return null;
    }

    public String getLine1AlphaTag() {
        return null;
    }

    public boolean getMessageWaitingIndicator() {
        return false;
    }

    public int getPhoneType() {
        return 5;
    }

    public String getSubscriberId() {
        return null;
    }

    public String getVoiceMailAlphaTag() {
        return null;
    }

    public String getVoiceMailNumber() {
        return null;
    }

    public boolean handleInCallMmiCommands(String str) {
        return false;
    }

    public boolean handlePinMmi(String str) {
        return false;
    }

    public boolean isDataAllowed() {
        return false;
    }

    public boolean isUserDataEnabled() {
        return false;
    }

    public boolean needsOtaServiceProvisioning() {
        return false;
    }

    /* access modifiers changed from: protected */
    public void onUpdateIccAvailability() {
    }

    public void registerForSuppServiceNotification(Handler handler, int i, Object obj) {
    }

    public void selectNetworkManually(OperatorInfo operatorInfo, boolean z, Message message) {
    }

    public void sendUssdResponse(String str) {
    }

    public void setCallBarring(String str, boolean z, String str2, Message message, int i) {
    }

    public void setCallForwardingOption(int i, int i2, String str, int i3, int i4, Message message) {
    }

    public void setCallForwardingOption(int i, int i2, String str, int i3, Message message) {
    }

    public void setDataRoamingEnabled(boolean z) {
    }

    public boolean setLine1Number(String str, String str2, Message message) {
        return false;
    }

    public void setNetworkSelectionModeAutomatic(Message message) {
    }

    public void setRadioPower(boolean z) {
    }

    public void startNetworkScan(NetworkScanRequest networkScanRequest, Message message) {
    }

    public void stopNetworkScan(Message message) {
    }

    public void unregisterForSuppServiceNotification(Handler handler) {
    }

    public void updateServiceLocation() {
    }

    public ImsPhoneBase(String str, Context context, PhoneNotifier phoneNotifier, boolean z) {
        super(str, phoneNotifier, context, new ImsPhoneCommandInterface(context), z);
    }

    public void migrateFrom(Phone phone) {
        super.migrateFrom(phone);
        migrate(this.mRingbackRegistrants, ((ImsPhoneBase) phone).mRingbackRegistrants);
    }

    public void registerForRingbackTone(Handler handler, int i, Object obj) {
        this.mRingbackRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForRingbackTone(Handler handler) {
        this.mRingbackRegistrants.remove(handler);
    }

    public void startRingbackTone() {
        this.mRingbackRegistrants.notifyRegistrants(new AsyncResult((Object) null, Boolean.TRUE, (Throwable) null));
    }

    public void stopRingbackTone() {
        this.mRingbackRegistrants.notifyRegistrants(new AsyncResult((Object) null, Boolean.FALSE, (Throwable) null));
    }

    public void registerForOnHoldTone(Handler handler, int i, Object obj) {
        this.mOnHoldRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForOnHoldTone(Handler handler) {
        this.mOnHoldRegistrants.remove(handler);
    }

    @VisibleForTesting
    public void startOnHoldTone(Connection connection) {
        this.mOnHoldRegistrants.notifyRegistrants(new AsyncResult((Object) null, new Pair(connection, Boolean.TRUE), (Throwable) null));
    }

    public void stopOnHoldTone(Connection connection) {
        this.mOnHoldRegistrants.notifyRegistrants(new AsyncResult((Object) null, new Pair(connection, Boolean.FALSE), (Throwable) null));
    }

    public void registerForTtyModeReceived(Handler handler, int i, Object obj) {
        this.mTtyModeReceivedRegistrants.addUnique(handler, i, obj);
    }

    public void unregisterForTtyModeReceived(Handler handler) {
        this.mTtyModeReceivedRegistrants.remove(handler);
    }

    public void onTtyModeReceived(int i) {
        this.mTtyModeReceivedRegistrants.notifyRegistrants(new AsyncResult((Object) null, Integer.valueOf(i), (Throwable) null));
    }

    public void onCallQualityChanged(CallQuality callQuality, int i) {
        this.mNotifier.notifyCallQualityChanged(this, callQuality, i);
    }

    public ServiceState getServiceState() {
        ServiceState serviceState = new ServiceState();
        serviceState.setVoiceRegState(0);
        return serviceState;
    }

    public PhoneConstants.State getState() {
        return this.mState;
    }

    public SignalStrength getSignalStrength() {
        return new SignalStrength();
    }

    public List<? extends MmiCode> getPendingMmiCodes() {
        return new ArrayList(0);
    }

    public PhoneConstants.DataState getDataConnectionState() {
        return PhoneConstants.DataState.DISCONNECTED;
    }

    public void notifyPhoneStateChanged() {
        this.mNotifier.notifyPhoneState(this);
    }

    public void notifyPreciseCallStateChanged() {
        super.notifyPreciseCallStateChangedP();
    }

    public void notifyDisconnect(Connection connection) {
        this.mDisconnectRegistrants.notifyResult(connection);
    }

    public void notifyImsReason(ImsReasonInfo imsReasonInfo) {
        this.mNotifier.notifyImsDisconnectCause(this, imsReasonInfo);
    }

    /* access modifiers changed from: package-private */
    public void notifyUnknownConnection() {
        this.mUnknownConnectionRegistrants.notifyResult(this);
    }

    public void notifySuppServiceFailed(PhoneInternalInterface.SuppService suppService) {
        this.mSuppServiceFailedRegistrants.notifyResult(suppService);
    }

    /* access modifiers changed from: package-private */
    public void notifyServiceStateChanged(ServiceState serviceState) {
        super.notifyServiceStateChangedP(serviceState);
    }

    public void notifyCallForwardingIndicator() {
        this.mNotifier.notifyCallForwardingChanged(this);
    }

    public boolean canDial() {
        int state = getServiceState().getState();
        Rlog.v(LOG_TAG, "canDial(): serviceState = " + state);
        if (state == 3) {
            return false;
        }
        boolean booleanValue = TelephonyProperties.disable_call().orElse(Boolean.FALSE).booleanValue();
        Rlog.v(LOG_TAG, "canDial(): disableCall = " + booleanValue);
        if (booleanValue) {
            return false;
        }
        Rlog.v(LOG_TAG, "canDial(): ringingCall: " + getRingingCall().getState());
        Rlog.v(LOG_TAG, "canDial(): foregndCall: " + getForegroundCall().getState());
        Rlog.v(LOG_TAG, "canDial(): backgndCall: " + getBackgroundCall().getState());
        if (getRingingCall().isRinging()) {
            return false;
        }
        if (!getForegroundCall().getState().isAlive() || !getBackgroundCall().getState().isAlive()) {
            return true;
        }
        return false;
    }

    /* access modifiers changed from: package-private */
    public boolean isInCall() {
        return getForegroundCall().getState().isAlive() || getBackgroundCall().getState().isAlive() || getRingingCall().getState().isAlive();
    }

    public String getEsn() {
        Rlog.e(LOG_TAG, "[VoltePhone] getEsn() is a CDMA method");
        return "0";
    }

    public String getMeid() {
        Rlog.e(LOG_TAG, "[VoltePhone] getMeid() is a CDMA method");
        return "0";
    }

    public void setVoiceMailNumber(String str, String str2, Message message) {
        AsyncResult.forMessage(message, (Object) null, (Throwable) null);
        message.sendToTarget();
    }

    public void getOutgoingCallerIdDisplay(Message message) {
        AsyncResult.forMessage(message, (Object) null, (Throwable) null);
        message.sendToTarget();
    }

    public void setOutgoingCallerIdDisplay(int i, Message message) {
        AsyncResult.forMessage(message, (Object) null, (Throwable) null);
        message.sendToTarget();
    }

    public void getCallWaiting(Message message) {
        AsyncResult.forMessage(message, (Object) null, (Throwable) null);
        message.sendToTarget();
    }

    public void setCallWaiting(boolean z, Message message) {
        Rlog.e(LOG_TAG, "call waiting not supported");
    }

    public void activateCellBroadcastSms(int i, Message message) {
        Rlog.e(LOG_TAG, "Error! This functionality is not implemented for Volte.");
    }

    public void getCellBroadcastSmsConfig(Message message) {
        Rlog.e(LOG_TAG, "Error! This functionality is not implemented for Volte.");
    }

    public void setCellBroadcastSmsConfig(int[] iArr, Message message) {
        Rlog.e(LOG_TAG, "Error! This functionality is not implemented for Volte.");
    }

    /* access modifiers changed from: package-private */
    public void updatePhoneState() {
        PhoneConstants.State state = this.mState;
        if (getRingingCall().isRinging()) {
            this.mState = PhoneConstants.State.RINGING;
        } else if (!getForegroundCall().isIdle() || !getBackgroundCall().isIdle()) {
            this.mState = PhoneConstants.State.OFFHOOK;
        } else {
            this.mState = PhoneConstants.State.IDLE;
        }
        if (this.mState != state) {
            Rlog.d(LOG_TAG, " ^^^ new phone state: " + this.mState);
            notifyPhoneStateChanged();
        }
    }
}
