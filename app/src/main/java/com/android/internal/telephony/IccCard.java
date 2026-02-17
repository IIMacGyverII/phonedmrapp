package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;
import com.android.internal.telephony.IccCardConstants;
import com.android.internal.telephony.uicc.IccCardApplicationStatus;
import com.android.internal.telephony.uicc.IccRecords;

public class IccCard {
    private IccCardConstants.State mIccCardState;

    public String getIccCardType() {
        return null;
    }

    public boolean getIccFdnAvailable() {
        return false;
    }

    public boolean getIccFdnEnabled() {
        return false;
    }

    public boolean getIccLockEnabled() {
        return false;
    }

    public boolean getIccPin2Blocked() {
        return false;
    }

    public boolean getIccPuk2Blocked() {
        return false;
    }

    public IccRecords getIccRecords() {
        return null;
    }

    public String getServiceProviderName() {
        return null;
    }

    public boolean hasIccCard() {
        return false;
    }

    public void iccExchangeSimIOEx(int i, int i2, int i3, int i4, int i5, String str, String str2, String str3, Message message) {
    }

    public void iccGetAtr(Message message) {
    }

    public boolean isApplicationOnIcc(IccCardApplicationStatus.AppType appType) {
        return false;
    }

    public boolean isEmptyProfile() {
        return false;
    }

    public void registerForFdnChanged(Handler handler, int i, Object obj) {
    }

    @UnsupportedAppUsage
    public void registerForNetworkLocked(Handler handler, int i, Object obj) {
    }

    public void repollIccStateForModemSmlChangeFeatrue(boolean z) {
    }

    public void unregisterForFdnChanged(Handler handler) {
    }

    public void unregisterForNetworkLocked(Handler handler) {
    }

    public IccCard() {
        this.mIccCardState = IccCardConstants.State.UNKNOWN;
    }

    public IccCard(IccCardConstants.State state) {
        IccCardConstants.State state2 = IccCardConstants.State.UNKNOWN;
        this.mIccCardState = state;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public IccCardConstants.State getState() {
        return this.mIccCardState;
    }

    @UnsupportedAppUsage
    public void supplyPin(String str, Message message) {
        sendMessageWithCardAbsentException(message);
    }

    @UnsupportedAppUsage
    public void supplyPuk(String str, String str2, Message message) {
        sendMessageWithCardAbsentException(message);
    }

    public void supplyPin2(String str, Message message) {
        sendMessageWithCardAbsentException(message);
    }

    public void supplyPuk2(String str, String str2, Message message) {
        sendMessageWithCardAbsentException(message);
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void supplyNetworkDepersonalization(String str, Message message) {
        sendMessageWithCardAbsentException(message);
    }

    public void supplySimDepersonalization(IccCardApplicationStatus.PersoSubState persoSubState, String str, Message message) {
        sendMessageWithCardAbsentException(message);
    }

    public void setIccLockEnabled(boolean z, String str, Message message) {
        sendMessageWithCardAbsentException(message);
    }

    public void setIccFdnEnabled(boolean z, String str, Message message) {
        sendMessageWithCardAbsentException(message);
    }

    public void changeIccLockPassword(String str, String str2, Message message) {
        sendMessageWithCardAbsentException(message);
    }

    public void changeIccFdnPassword(String str, String str2, Message message) {
        sendMessageWithCardAbsentException(message);
    }

    private void sendMessageWithCardAbsentException(Message message) {
        AsyncResult.forMessage(message).exception = new RuntimeException("No valid IccCard");
        message.sendToTarget();
    }
}
