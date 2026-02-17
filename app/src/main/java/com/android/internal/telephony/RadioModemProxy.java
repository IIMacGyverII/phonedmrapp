package com.android.internal.telephony;

import android.hardware.radio.modem.IRadioModem;
import android.hardware.radio.modem.NvWriteItem;
import android.hardware.radio.modem.RadioCapability;
import android.os.RemoteException;
import android.telephony.Rlog;

public class RadioModemProxy extends RadioServiceProxy {
    private static final String TAG = "RadioModemProxy";
    private volatile IRadioModem mModemProxy = null;

    public void setAidl(HalVersion halVersion, IRadioModem iRadioModem) {
        this.mHalVersion = halVersion;
        this.mModemProxy = iRadioModem;
        this.mIsAidl = true;
        Rlog.d(TAG, "AIDL initialized");
    }

    public IRadioModem getAidl() {
        return this.mModemProxy;
    }

    public void clear() {
        super.clear();
        this.mModemProxy = null;
    }

    public boolean isEmpty() {
        return this.mRadioProxy == null && this.mModemProxy == null;
    }

    public void enableModem(int i, boolean z) throws RemoteException {
        if (!isEmpty() && !this.mHalVersion.less(RIL.RADIO_HAL_VERSION_1_3)) {
            if (isAidl()) {
                this.mModemProxy.enableModem(i, z);
            } else {
                this.mRadioProxy.enableModem(i, z);
            }
        }
    }

    public void getBasebandVersion(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mModemProxy.getBasebandVersion(i);
            } else {
                this.mRadioProxy.getBasebandVersion(i);
            }
        }
    }

    public void getDeviceIdentity(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mModemProxy.getDeviceIdentity(i);
            } else {
                this.mRadioProxy.getDeviceIdentity(i);
            }
        }
    }

    public void getHardwareConfig(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mModemProxy.getHardwareConfig(i);
            } else {
                this.mRadioProxy.getHardwareConfig(i);
            }
        }
    }

    public void getModemActivityInfo(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mModemProxy.getModemActivityInfo(i);
            } else {
                this.mRadioProxy.getModemActivityInfo(i);
            }
        }
    }

    public void getModemStackStatus(int i) throws RemoteException {
        if (!isEmpty() && !this.mHalVersion.less(RIL.RADIO_HAL_VERSION_1_3)) {
            if (isAidl()) {
                this.mModemProxy.getModemStackStatus(i);
            } else {
                this.mRadioProxy.getModemStackStatus(i);
            }
        }
    }

    public void getRadioCapability(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mModemProxy.getRadioCapability(i);
            } else {
                this.mRadioProxy.getRadioCapability(i);
            }
        }
    }

    public void nvReadItem(int i, int i2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mModemProxy.nvReadItem(i, i2);
            } else {
                this.mRadioProxy.nvReadItem(i, i2);
            }
        }
    }

    public void nvResetConfig(int i, int i2) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mModemProxy.nvResetConfig(i, RILUtils.convertToHalResetNvTypeAidl(i2));
            } else {
                this.mRadioProxy.nvResetConfig(i, RILUtils.convertToHalResetNvType(i2));
            }
        }
    }

    public void nvWriteCdmaPrl(int i, byte[] bArr) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mModemProxy.nvWriteCdmaPrl(i, bArr);
            } else {
                this.mRadioProxy.nvWriteCdmaPrl(i, RILUtils.primitiveArrayToArrayList(bArr));
            }
        }
    }

    public void nvWriteItem(int i, int i2, String str) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                NvWriteItem nvWriteItem = new NvWriteItem();
                nvWriteItem.itemId = i2;
                nvWriteItem.value = str;
                this.mModemProxy.nvWriteItem(i, nvWriteItem);
                return;
            }
            android.hardware.radio.V1_0.NvWriteItem nvWriteItem2 = new android.hardware.radio.V1_0.NvWriteItem();
            nvWriteItem2.itemId = i2;
            nvWriteItem2.value = str;
            this.mRadioProxy.nvWriteItem(i, nvWriteItem2);
        }
    }

    public void requestShutdown(int i) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mModemProxy.requestShutdown(i);
            } else {
                this.mRadioProxy.requestShutdown(i);
            }
        }
    }

    public void responseAcknowledgement() throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mModemProxy.responseAcknowledgement();
            } else {
                this.mRadioProxy.responseAcknowledgement();
            }
        }
    }

    public void sendDeviceState(int i, int i2, boolean z) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mModemProxy.sendDeviceState(i, i2, z);
            } else {
                this.mRadioProxy.sendDeviceState(i, i2, z);
            }
        }
    }

    public void setRadioCapability(int i, RadioCapability radioCapability) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                RadioCapability radioCapability2 = new RadioCapability();
                radioCapability2.session = radioCapability.getSession();
                radioCapability2.phase = radioCapability.getPhase();
                radioCapability2.raf = RILUtils.convertToHalRadioAccessFamilyAidl(radioCapability.getRadioAccessFamily());
                radioCapability2.logicalModemUuid = RILUtils.convertNullToEmptyString(radioCapability.getLogicalModemUuid());
                radioCapability2.status = radioCapability.getStatus();
                this.mModemProxy.setRadioCapability(i, radioCapability2);
                return;
            }
            android.hardware.radio.V1_0.RadioCapability radioCapability3 = new android.hardware.radio.V1_0.RadioCapability();
            radioCapability3.session = radioCapability.getSession();
            radioCapability3.phase = radioCapability.getPhase();
            radioCapability3.raf = RILUtils.convertToHalRadioAccessFamily(radioCapability.getRadioAccessFamily());
            radioCapability3.logicalModemUuid = RILUtils.convertNullToEmptyString(radioCapability.getLogicalModemUuid());
            radioCapability3.status = radioCapability.getStatus();
            this.mRadioProxy.setRadioCapability(i, radioCapability3);
        }
    }

    public void setRadioPower(int i, boolean z, boolean z2, boolean z3) throws RemoteException {
        if (!isEmpty()) {
            if (isAidl()) {
                this.mModemProxy.setRadioPower(i, z, z2, z3);
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_6)) {
                this.mRadioProxy.setRadioPower_1_6(i, z, z2, z3);
            } else if (this.mHalVersion.greaterOrEqual(RIL.RADIO_HAL_VERSION_1_5)) {
                this.mRadioProxy.setRadioPower_1_5(i, z, z2, z3);
            } else {
                this.mRadioProxy.setRadioPower(i, z);
            }
        }
    }
}
