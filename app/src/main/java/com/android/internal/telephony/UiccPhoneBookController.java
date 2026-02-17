package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.ContentValues;
import android.os.RemoteException;
import android.os.TelephonyServiceManager;
import android.telephony.TelephonyFrameworkInitializer;
import com.android.internal.telephony.IIccPhoneBook;
import com.android.internal.telephony.uicc.AdnCapacity;
import com.android.internal.telephony.uicc.AdnRecord;
import com.android.telephony.Rlog;
import java.util.List;

public class UiccPhoneBookController extends IIccPhoneBook.Stub {
    private static final String TAG = "UiccPhoneBookController";

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public UiccPhoneBookController() {
        TelephonyServiceManager.ServiceRegisterer iccPhoneBookServiceRegisterer = TelephonyFrameworkInitializer.getTelephonyServiceManager().getIccPhoneBookServiceRegisterer();
        if (iccPhoneBookServiceRegisterer.get() == null) {
            iccPhoneBookServiceRegisterer.register(this);
        }
    }

    public boolean updateAdnRecordsInEfBySearch(int i, String str, String str2, String str3, String str4, String str5) throws RemoteException {
        ContentValues contentValues = new ContentValues();
        contentValues.put(IccProvider.STR_TAG, str);
        contentValues.put("number", str2);
        contentValues.put(IccProvider.STR_NEW_TAG, str3);
        contentValues.put(IccProvider.STR_NEW_NUMBER, str4);
        return updateAdnRecordsInEfBySearchForSubscriber(getDefaultSubscription(), i, contentValues, str5);
    }

    public boolean updateAdnRecordsInEfByIndexForSubscriber(int i, int i2, ContentValues contentValues, int i3, String str) throws RemoteException {
        IccPhoneBookInterfaceManager iccPhoneBookInterfaceManager = getIccPhoneBookInterfaceManager(i);
        if (iccPhoneBookInterfaceManager != null) {
            return iccPhoneBookInterfaceManager.updateAdnRecordsInEfByIndex(i2, contentValues, i3, str);
        }
        Rlog.e(TAG, "updateAdnRecordsInEfByIndex iccPbkIntMgr is null for Subscription:" + i);
        return false;
    }

    public int[] getAdnRecordsSize(int i) throws RemoteException {
        return getAdnRecordsSizeForSubscriber(getDefaultSubscription(), i);
    }

    public int[] getAdnRecordsSizeForSubscriber(int i, int i2) throws RemoteException {
        IccPhoneBookInterfaceManager iccPhoneBookInterfaceManager = getIccPhoneBookInterfaceManager(i);
        if (iccPhoneBookInterfaceManager != null) {
            return iccPhoneBookInterfaceManager.getAdnRecordsSize(i2);
        }
        Rlog.e(TAG, "getAdnRecordsSize iccPbkIntMgr is null for Subscription:" + i);
        return null;
    }

    public List<AdnRecord> getAdnRecordsInEf(int i) throws RemoteException {
        return getAdnRecordsInEfForSubscriber(getDefaultSubscription(), i);
    }

    public List<AdnRecord> getAdnRecordsInEfForSubscriber(int i, int i2) throws RemoteException {
        IccPhoneBookInterfaceManager iccPhoneBookInterfaceManager = getIccPhoneBookInterfaceManager(i);
        if (iccPhoneBookInterfaceManager != null) {
            return iccPhoneBookInterfaceManager.getAdnRecordsInEf(i2);
        }
        Rlog.e(TAG, "getAdnRecordsInEf iccPbkIntMgr isnull for Subscription:" + i);
        return null;
    }

    public AdnCapacity getAdnRecordsCapacityForSubscriber(int i) throws RemoteException {
        IccPhoneBookInterfaceManager iccPhoneBookInterfaceManager = getIccPhoneBookInterfaceManager(i);
        if (iccPhoneBookInterfaceManager != null) {
            return iccPhoneBookInterfaceManager.getAdnRecordsCapacity();
        }
        Rlog.e(TAG, "getAdnRecordsCapacity iccPbkIntMgr is null for Subscription:" + i);
        return null;
    }

    public boolean updateAdnRecordsInEfBySearchForSubscriber(int i, int i2, ContentValues contentValues, String str) throws RemoteException {
        IccPhoneBookInterfaceManager iccPhoneBookInterfaceManager = getIccPhoneBookInterfaceManager(i);
        if (iccPhoneBookInterfaceManager != null) {
            return iccPhoneBookInterfaceManager.updateAdnRecordsInEfBySearchForSubscriber(i2, contentValues, str);
        }
        Rlog.e(TAG, "updateAdnRecordsInEfBySearchForSubscriber iccPbkIntMgr is null for Subscription:" + i);
        return false;
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private IccPhoneBookInterfaceManager getIccPhoneBookInterfaceManager(int i) {
        try {
            return PhoneFactory.getPhone(SubscriptionController.getInstance().getPhoneId(i)).getIccPhoneBookInterfaceManager();
        } catch (NullPointerException e) {
            Rlog.e(TAG, "Exception is :" + e.toString() + " For subscription :" + i);
            e.printStackTrace();
            return null;
        } catch (ArrayIndexOutOfBoundsException e2) {
            Rlog.e(TAG, "Exception is :" + e2.toString() + " For subscription :" + i);
            e2.printStackTrace();
            return null;
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    private int getDefaultSubscription() {
        return PhoneFactory.getDefaultSubscription();
    }
}
