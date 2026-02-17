package com.android.internal.telephony;

import android.hardware.radio.sim.IRadioSimIndication;
import android.hardware.radio.sim.PhonebookRecordInfo;
import android.hardware.radio.sim.SimRefreshResult;
import android.os.AsyncResult;
import androidx.core.view.PointerIconCompat;
import com.android.internal.telephony.uicc.IccRefreshResponse;
import com.android.internal.telephony.uicc.ReceivedPhonebookRecords;
import java.util.ArrayList;

public class SimIndication extends IRadioSimIndication.Stub {
    private final RIL mRil;

    public String getInterfaceHash() {
        return "01cea196fdf8f5e41fda8dc41125f1cc2b96f757";
    }

    public int getInterfaceVersion() {
        return 1;
    }

    public SimIndication(RIL ril) {
        this.mRil = ril;
    }

    public void carrierInfoForImsiEncryption(int i) {
        this.mRil.processIndication(5, i);
        this.mRil.unsljLogRet(1048, (Object) null);
        this.mRil.mCarrierInfoForImsiEncryptionRegistrants.notifyRegistrants(new AsyncResult((Object) null, (Object) null, (Throwable) null));
    }

    public void cdmaSubscriptionSourceChanged(int i, int i2) {
        this.mRil.processIndication(5, i);
        int[] iArr = {i2};
        this.mRil.unsljLogRet(1031, iArr);
        this.mRil.mCdmaSubscriptionChangedRegistrants.notifyRegistrants(new AsyncResult((Object) null, iArr, (Throwable) null));
    }

    public void simPhonebookChanged(int i) {
        this.mRil.processIndication(5, i);
        this.mRil.unsljLog(1053);
        this.mRil.mSimPhonebookChangedRegistrants.notifyRegistrants();
    }

    public void simPhonebookRecordsReceived(int i, byte b, PhonebookRecordInfo[] phonebookRecordInfoArr) {
        this.mRil.processIndication(5, i);
        ArrayList arrayList = new ArrayList();
        for (PhonebookRecordInfo convertHalPhonebookRecordInfo : phonebookRecordInfoArr) {
            arrayList.add(RILUtils.convertHalPhonebookRecordInfo(convertHalPhonebookRecordInfo));
        }
        this.mRil.unsljLogRet(1054, "status = " + b + " received " + phonebookRecordInfoArr.length + " records");
        this.mRil.mSimPhonebookRecordsReceivedRegistrants.notifyRegistrants(new AsyncResult((Object) null, new ReceivedPhonebookRecords(b, arrayList), (Throwable) null));
    }

    public void simRefresh(int i, SimRefreshResult simRefreshResult) {
        this.mRil.processIndication(5, i);
        IccRefreshResponse iccRefreshResponse = new IccRefreshResponse();
        iccRefreshResponse.refreshResult = simRefreshResult.type;
        iccRefreshResponse.efId = simRefreshResult.efId;
        iccRefreshResponse.aid = simRefreshResult.aid;
        this.mRil.unsljLogRet(PointerIconCompat.TYPE_TOP_LEFT_DIAGONAL_DOUBLE_ARROW, iccRefreshResponse);
        this.mRil.mIccRefreshRegistrants.notifyRegistrants(new AsyncResult((Object) null, iccRefreshResponse, (Throwable) null));
    }

    public void simStatusChanged(int i) {
        this.mRil.processIndication(5, i);
        this.mRil.unsljLog(PointerIconCompat.TYPE_ZOOM_OUT);
        this.mRil.mIccStatusChangedRegistrants.notifyRegistrants();
    }

    public void stkEventNotify(int i, String str) {
        this.mRil.processIndication(5, i);
        this.mRil.unsljLog(PointerIconCompat.TYPE_HORIZONTAL_DOUBLE_ARROW);
        Registrant registrant = this.mRil.mCatEventRegistrant;
        if (registrant != null) {
            registrant.notifyRegistrant(new AsyncResult((Object) null, str, (Throwable) null));
        }
    }

    public void stkProactiveCommand(int i, String str) {
        this.mRil.processIndication(5, i);
        this.mRil.unsljLog(PointerIconCompat.TYPE_ALL_SCROLL);
        Registrant registrant = this.mRil.mCatProCmdRegistrant;
        if (registrant != null) {
            registrant.notifyRegistrant(new AsyncResult((Object) null, str, (Throwable) null));
        }
    }

    public void stkSessionEnd(int i) {
        this.mRil.processIndication(5, i);
        this.mRil.unsljLog(PointerIconCompat.TYPE_NO_DROP);
        Registrant registrant = this.mRil.mCatSessionEndRegistrant;
        if (registrant != null) {
            registrant.notifyRegistrant(new AsyncResult((Object) null, (Object) null, (Throwable) null));
        }
    }

    public void subscriptionStatusChanged(int i, boolean z) {
        this.mRil.processIndication(5, i);
        int[] iArr = {z};
        this.mRil.unsljLogRet(1038, iArr);
        this.mRil.mSubscriptionStatusRegistrants.notifyRegistrants(new AsyncResult((Object) null, iArr, (Throwable) null));
    }

    public void uiccApplicationsEnablementChanged(int i, boolean z) {
        this.mRil.processIndication(5, i);
        this.mRil.unsljLogRet(1103, Boolean.valueOf(z));
        this.mRil.mUiccApplicationsEnablementRegistrants.notifyResult(Boolean.valueOf(z));
    }
}
