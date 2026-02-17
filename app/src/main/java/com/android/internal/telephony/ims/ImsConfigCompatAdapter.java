package com.android.internal.telephony.ims;

import android.os.RemoteException;
import android.telephony.ims.stub.ImsConfigImplBase;
import android.util.Log;
import com.android.ims.internal.IImsConfig;

public class ImsConfigCompatAdapter extends ImsConfigImplBase {
    public static final int FAILED = 1;
    public static final int SUCCESS = 0;
    private static final String TAG = "ImsConfigCompatAdapter";
    public static final int UNKNOWN = -1;
    private final IImsConfig mOldConfigInterface;

    public ImsConfigCompatAdapter(IImsConfig iImsConfig) {
        this.mOldConfigInterface = iImsConfig;
    }

    public int setConfig(int i, int i2) {
        try {
            if (this.mOldConfigInterface.setProvisionedValue(i, i2) == 0) {
                return 0;
            }
            return 1;
        } catch (RemoteException e) {
            Log.w(TAG, "setConfig: item=" + i + " value=" + i2 + "failed: " + e.getMessage());
            return 1;
        }
    }

    public int setConfig(int i, String str) {
        try {
            if (this.mOldConfigInterface.setProvisionedStringValue(i, str) == 0) {
                return 0;
            }
            return 1;
        } catch (RemoteException e) {
            Log.w(TAG, "setConfig: item=" + i + " value=" + str + "failed: " + e.getMessage());
            return 1;
        }
    }

    public int getConfigInt(int i) {
        try {
            int provisionedValue = this.mOldConfigInterface.getProvisionedValue(i);
            if (provisionedValue != -1) {
                return provisionedValue;
            }
            return -1;
        } catch (RemoteException e) {
            Log.w(TAG, "getConfigInt: item=" + i + "failed: " + e.getMessage());
        }
    }

    public String getConfigString(int i) {
        try {
            return this.mOldConfigInterface.getProvisionedStringValue(i);
        } catch (RemoteException e) {
            Log.w(TAG, "getConfigInt: item=" + i + "failed: " + e.getMessage());
            return null;
        }
    }
}
