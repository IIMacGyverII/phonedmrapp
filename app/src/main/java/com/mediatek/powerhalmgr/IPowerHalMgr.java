package com.mediatek.powerhalmgr;

import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.IRemoteCallback;
import android.os.Parcel;
import android.os.RemoteException;

public interface IPowerHalMgr extends IInterface {
    public static final String DESCRIPTOR = "com.mediatek.powerhalmgr.IPowerHalMgr";

    public static class Default implements IPowerHalMgr {
        public void UpdateManagementPkt(int i, String str) throws RemoteException {
        }

        public IBinder asBinder() {
            return null;
        }

        public boolean configBoosterInfo(BoosterInfo boosterInfo) throws RemoteException {
            return false;
        }

        public boolean flushPriorityRules(int i) throws RemoteException {
            return false;
        }

        public void getCpuCap() throws RemoteException {
        }

        public void getCpuRTInfo() throws RemoteException {
        }

        public void getGpuCap() throws RemoteException {
        }

        public void getGpuRTInfo() throws RemoteException {
        }

        public boolean isDupPacketPredictionStarted() throws RemoteException {
            return false;
        }

        public void mtkCusPowerHint(int i, int i2) throws RemoteException {
        }

        public void mtkPowerHint(int i, int i2) throws RemoteException {
        }

        public int perfCusLockHint(int i, int i2) throws RemoteException {
            return 0;
        }

        public int perfLockAcquire(int i, int i2, int[] iArr) throws RemoteException {
            return 0;
        }

        public void perfLockRelease(int i) throws RemoteException {
        }

        public int querySysInfo(int i, int i2) throws RemoteException {
            return 0;
        }

        public boolean registerDuplicatePacketPredictionEvent(IRemoteCallback iRemoteCallback) throws RemoteException {
            return false;
        }

        public void scnConfig(int i, int i2, int i3, int i4, int i5, int i6) throws RemoteException {
        }

        public void scnDisable(int i) throws RemoteException {
        }

        public void scnEnable(int i, int i2) throws RemoteException {
        }

        public int scnReg() throws RemoteException {
            return 0;
        }

        public void scnUltraCfg(int i, int i2, int i3, int i4, int i5, int i6) throws RemoteException {
        }

        public void scnUnreg(int i) throws RemoteException {
        }

        public void setForegroundSports() throws RemoteException {
        }

        public void setPredictInfo(String str, int i) throws RemoteException {
        }

        public boolean setPriorityByLinkinfo(int i, DupLinkInfo dupLinkInfo) throws RemoteException {
            return false;
        }

        public boolean setPriorityByUid(int i, int i2) throws RemoteException {
            return false;
        }

        public void setSysInfo(int i, String str) throws RemoteException {
        }

        public int setSysInfoSync(int i, String str) throws RemoteException {
            return 0;
        }

        public boolean startDuplicatePacketPrediction() throws RemoteException {
            return false;
        }

        public boolean stopDuplicatePacketPrediction() throws RemoteException {
            return false;
        }

        public boolean unregisterDuplicatePacketPredictionEvent(IRemoteCallback iRemoteCallback) throws RemoteException {
            return false;
        }

        public boolean updateMultiDuplicatePacketLink(DupLinkInfo[] dupLinkInfoArr) throws RemoteException {
            return false;
        }
    }

    void UpdateManagementPkt(int i, String str) throws RemoteException;

    boolean configBoosterInfo(BoosterInfo boosterInfo) throws RemoteException;

    boolean flushPriorityRules(int i) throws RemoteException;

    void getCpuCap() throws RemoteException;

    void getCpuRTInfo() throws RemoteException;

    void getGpuCap() throws RemoteException;

    void getGpuRTInfo() throws RemoteException;

    boolean isDupPacketPredictionStarted() throws RemoteException;

    void mtkCusPowerHint(int i, int i2) throws RemoteException;

    void mtkPowerHint(int i, int i2) throws RemoteException;

    int perfCusLockHint(int i, int i2) throws RemoteException;

    int perfLockAcquire(int i, int i2, int[] iArr) throws RemoteException;

    void perfLockRelease(int i) throws RemoteException;

    int querySysInfo(int i, int i2) throws RemoteException;

    boolean registerDuplicatePacketPredictionEvent(IRemoteCallback iRemoteCallback) throws RemoteException;

    void scnConfig(int i, int i2, int i3, int i4, int i5, int i6) throws RemoteException;

    void scnDisable(int i) throws RemoteException;

    void scnEnable(int i, int i2) throws RemoteException;

    int scnReg() throws RemoteException;

    void scnUltraCfg(int i, int i2, int i3, int i4, int i5, int i6) throws RemoteException;

    void scnUnreg(int i) throws RemoteException;

    void setForegroundSports() throws RemoteException;

    void setPredictInfo(String str, int i) throws RemoteException;

    boolean setPriorityByLinkinfo(int i, DupLinkInfo dupLinkInfo) throws RemoteException;

    boolean setPriorityByUid(int i, int i2) throws RemoteException;

    void setSysInfo(int i, String str) throws RemoteException;

    int setSysInfoSync(int i, String str) throws RemoteException;

    boolean startDuplicatePacketPrediction() throws RemoteException;

    boolean stopDuplicatePacketPrediction() throws RemoteException;

    boolean unregisterDuplicatePacketPredictionEvent(IRemoteCallback iRemoteCallback) throws RemoteException;

    boolean updateMultiDuplicatePacketLink(DupLinkInfo[] dupLinkInfoArr) throws RemoteException;

    public static abstract class Stub extends Binder implements IPowerHalMgr {
        static final int TRANSACTION_UpdateManagementPkt = 12;
        static final int TRANSACTION_configBoosterInfo = 31;
        static final int TRANSACTION_flushPriorityRules = 30;
        static final int TRANSACTION_getCpuCap = 8;
        static final int TRANSACTION_getCpuRTInfo = 11;
        static final int TRANSACTION_getGpuCap = 9;
        static final int TRANSACTION_getGpuRTInfo = 10;
        static final int TRANSACTION_isDupPacketPredictionStarted = 17;
        static final int TRANSACTION_mtkCusPowerHint = 7;
        static final int TRANSACTION_mtkPowerHint = 25;
        static final int TRANSACTION_perfCusLockHint = 26;
        static final int TRANSACTION_perfLockAcquire = 22;
        static final int TRANSACTION_perfLockRelease = 23;
        static final int TRANSACTION_querySysInfo = 24;
        static final int TRANSACTION_registerDuplicatePacketPredictionEvent = 18;
        static final int TRANSACTION_scnConfig = 2;
        static final int TRANSACTION_scnDisable = 5;
        static final int TRANSACTION_scnEnable = 4;
        static final int TRANSACTION_scnReg = 1;
        static final int TRANSACTION_scnUltraCfg = 6;
        static final int TRANSACTION_scnUnreg = 3;
        static final int TRANSACTION_setForegroundSports = 13;
        static final int TRANSACTION_setPredictInfo = 21;
        static final int TRANSACTION_setPriorityByLinkinfo = 29;
        static final int TRANSACTION_setPriorityByUid = 28;
        static final int TRANSACTION_setSysInfo = 14;
        static final int TRANSACTION_setSysInfoSync = 27;
        static final int TRANSACTION_startDuplicatePacketPrediction = 15;
        static final int TRANSACTION_stopDuplicatePacketPrediction = 16;
        static final int TRANSACTION_unregisterDuplicatePacketPredictionEvent = 19;
        static final int TRANSACTION_updateMultiDuplicatePacketLink = 20;

        public IBinder asBinder() {
            return this;
        }

        public Stub() {
            attachInterface(this, IPowerHalMgr.DESCRIPTOR);
        }

        public static IPowerHalMgr asInterface(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface queryLocalInterface = iBinder.queryLocalInterface(IPowerHalMgr.DESCRIPTOR);
            if (queryLocalInterface == null || !(queryLocalInterface instanceof IPowerHalMgr)) {
                return new Proxy(iBinder);
            }
            return (IPowerHalMgr) queryLocalInterface;
        }

        public boolean onTransact(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
            if (i >= 1 && i <= 16777215) {
                parcel.enforceInterface(IPowerHalMgr.DESCRIPTOR);
            }
            if (i != 1598968902) {
                switch (i) {
                    case 1:
                        int scnReg = scnReg();
                        parcel2.writeNoException();
                        parcel2.writeInt(scnReg);
                        break;
                    case 2:
                        int readInt = parcel.readInt();
                        int readInt2 = parcel.readInt();
                        int readInt3 = parcel.readInt();
                        int readInt4 = parcel.readInt();
                        int readInt5 = parcel.readInt();
                        int readInt6 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        scnConfig(readInt, readInt2, readInt3, readInt4, readInt5, readInt6);
                        break;
                    case 3:
                        int readInt7 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        scnUnreg(readInt7);
                        break;
                    case 4:
                        int readInt8 = parcel.readInt();
                        int readInt9 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        scnEnable(readInt8, readInt9);
                        break;
                    case 5:
                        int readInt10 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        scnDisable(readInt10);
                        break;
                    case 6:
                        int readInt11 = parcel.readInt();
                        int readInt12 = parcel.readInt();
                        int readInt13 = parcel.readInt();
                        int readInt14 = parcel.readInt();
                        int readInt15 = parcel.readInt();
                        int readInt16 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        scnUltraCfg(readInt11, readInt12, readInt13, readInt14, readInt15, readInt16);
                        break;
                    case 7:
                        int readInt17 = parcel.readInt();
                        int readInt18 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        mtkCusPowerHint(readInt17, readInt18);
                        break;
                    case 8:
                        getCpuCap();
                        break;
                    case 9:
                        getGpuCap();
                        break;
                    case 10:
                        getGpuRTInfo();
                        break;
                    case 11:
                        getCpuRTInfo();
                        break;
                    case 12:
                        int readInt19 = parcel.readInt();
                        String readString = parcel.readString();
                        parcel.enforceNoDataAvail();
                        UpdateManagementPkt(readInt19, readString);
                        break;
                    case 13:
                        setForegroundSports();
                        break;
                    case 14:
                        int readInt20 = parcel.readInt();
                        String readString2 = parcel.readString();
                        parcel.enforceNoDataAvail();
                        setSysInfo(readInt20, readString2);
                        break;
                    case 15:
                        boolean startDuplicatePacketPrediction = startDuplicatePacketPrediction();
                        parcel2.writeNoException();
                        parcel2.writeBoolean(startDuplicatePacketPrediction);
                        break;
                    case 16:
                        boolean stopDuplicatePacketPrediction = stopDuplicatePacketPrediction();
                        parcel2.writeNoException();
                        parcel2.writeBoolean(stopDuplicatePacketPrediction);
                        break;
                    case 17:
                        boolean isDupPacketPredictionStarted = isDupPacketPredictionStarted();
                        parcel2.writeNoException();
                        parcel2.writeBoolean(isDupPacketPredictionStarted);
                        break;
                    case 18:
                        IRemoteCallback asInterface = IRemoteCallback.Stub.asInterface(parcel.readStrongBinder());
                        parcel.enforceNoDataAvail();
                        boolean registerDuplicatePacketPredictionEvent = registerDuplicatePacketPredictionEvent(asInterface);
                        parcel2.writeNoException();
                        parcel2.writeBoolean(registerDuplicatePacketPredictionEvent);
                        break;
                    case 19:
                        IRemoteCallback asInterface2 = IRemoteCallback.Stub.asInterface(parcel.readStrongBinder());
                        parcel.enforceNoDataAvail();
                        boolean unregisterDuplicatePacketPredictionEvent = unregisterDuplicatePacketPredictionEvent(asInterface2);
                        parcel2.writeNoException();
                        parcel2.writeBoolean(unregisterDuplicatePacketPredictionEvent);
                        break;
                    case 20:
                        parcel.enforceNoDataAvail();
                        boolean updateMultiDuplicatePacketLink = updateMultiDuplicatePacketLink((DupLinkInfo[]) parcel.createTypedArray(DupLinkInfo.CREATOR));
                        parcel2.writeNoException();
                        parcel2.writeBoolean(updateMultiDuplicatePacketLink);
                        break;
                    case 21:
                        String readString3 = parcel.readString();
                        int readInt21 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        setPredictInfo(readString3, readInt21);
                        break;
                    case 22:
                        int readInt22 = parcel.readInt();
                        int readInt23 = parcel.readInt();
                        int[] createIntArray = parcel.createIntArray();
                        parcel.enforceNoDataAvail();
                        int perfLockAcquire = perfLockAcquire(readInt22, readInt23, createIntArray);
                        parcel2.writeNoException();
                        parcel2.writeInt(perfLockAcquire);
                        break;
                    case 23:
                        int readInt24 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        perfLockRelease(readInt24);
                        break;
                    case 24:
                        int readInt25 = parcel.readInt();
                        int readInt26 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        int querySysInfo = querySysInfo(readInt25, readInt26);
                        parcel2.writeNoException();
                        parcel2.writeInt(querySysInfo);
                        break;
                    case 25:
                        int readInt27 = parcel.readInt();
                        int readInt28 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        mtkPowerHint(readInt27, readInt28);
                        break;
                    case 26:
                        int readInt29 = parcel.readInt();
                        int readInt30 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        int perfCusLockHint = perfCusLockHint(readInt29, readInt30);
                        parcel2.writeNoException();
                        parcel2.writeInt(perfCusLockHint);
                        break;
                    case 27:
                        int readInt31 = parcel.readInt();
                        String readString4 = parcel.readString();
                        parcel.enforceNoDataAvail();
                        int sysInfoSync = setSysInfoSync(readInt31, readString4);
                        parcel2.writeNoException();
                        parcel2.writeInt(sysInfoSync);
                        break;
                    case 28:
                        int readInt32 = parcel.readInt();
                        int readInt33 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        boolean priorityByUid = setPriorityByUid(readInt32, readInt33);
                        parcel2.writeNoException();
                        parcel2.writeBoolean(priorityByUid);
                        break;
                    case 29:
                        parcel.enforceNoDataAvail();
                        boolean priorityByLinkinfo = setPriorityByLinkinfo(parcel.readInt(), (DupLinkInfo) parcel.readTypedObject(DupLinkInfo.CREATOR));
                        parcel2.writeNoException();
                        parcel2.writeBoolean(priorityByLinkinfo);
                        break;
                    case 30:
                        int readInt34 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        boolean flushPriorityRules = flushPriorityRules(readInt34);
                        parcel2.writeNoException();
                        parcel2.writeBoolean(flushPriorityRules);
                        break;
                    case 31:
                        parcel.enforceNoDataAvail();
                        boolean configBoosterInfo = configBoosterInfo((BoosterInfo) parcel.readTypedObject(BoosterInfo.CREATOR));
                        parcel2.writeNoException();
                        parcel2.writeBoolean(configBoosterInfo);
                        break;
                    default:
                        return super.onTransact(i, parcel, parcel2, i2);
                }
                return true;
            }
            parcel2.writeString(IPowerHalMgr.DESCRIPTOR);
            return true;
        }

        private static class Proxy implements IPowerHalMgr {
            private IBinder mRemote;

            public String getInterfaceDescriptor() {
                return IPowerHalMgr.DESCRIPTOR;
            }

            Proxy(IBinder iBinder) {
                this.mRemote = iBinder;
            }

            public IBinder asBinder() {
                return this.mRemote;
            }

            public int scnReg() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    this.mRemote.transact(1, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readInt();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public void scnConfig(int i, int i2, int i3, int i4, int i5, int i6) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    obtain.writeInt(i3);
                    obtain.writeInt(i4);
                    obtain.writeInt(i5);
                    obtain.writeInt(i6);
                    this.mRemote.transact(2, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public void scnUnreg(int i) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    this.mRemote.transact(3, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public void scnEnable(int i, int i2) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    this.mRemote.transact(4, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public void scnDisable(int i) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    this.mRemote.transact(5, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public void scnUltraCfg(int i, int i2, int i3, int i4, int i5, int i6) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    obtain.writeInt(i3);
                    obtain.writeInt(i4);
                    obtain.writeInt(i5);
                    obtain.writeInt(i6);
                    this.mRemote.transact(6, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public void mtkCusPowerHint(int i, int i2) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    this.mRemote.transact(7, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public void getCpuCap() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    this.mRemote.transact(8, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public void getGpuCap() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    this.mRemote.transact(9, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public void getGpuRTInfo() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    this.mRemote.transact(10, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public void getCpuRTInfo() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    this.mRemote.transact(11, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public void UpdateManagementPkt(int i, String str) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeString(str);
                    this.mRemote.transact(12, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public void setForegroundSports() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    this.mRemote.transact(13, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public void setSysInfo(int i, String str) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeString(str);
                    this.mRemote.transact(14, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public boolean startDuplicatePacketPrediction() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    this.mRemote.transact(15, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean stopDuplicatePacketPrediction() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    this.mRemote.transact(16, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean isDupPacketPredictionStarted() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    this.mRemote.transact(17, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean registerDuplicatePacketPredictionEvent(IRemoteCallback iRemoteCallback) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeStrongInterface(iRemoteCallback);
                    this.mRemote.transact(18, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean unregisterDuplicatePacketPredictionEvent(IRemoteCallback iRemoteCallback) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeStrongInterface(iRemoteCallback);
                    this.mRemote.transact(19, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean updateMultiDuplicatePacketLink(DupLinkInfo[] dupLinkInfoArr) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeTypedArray(dupLinkInfoArr, 0);
                    this.mRemote.transact(20, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public void setPredictInfo(String str, int i) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeString(str);
                    obtain.writeInt(i);
                    this.mRemote.transact(21, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public int perfLockAcquire(int i, int i2, int[] iArr) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    obtain.writeIntArray(iArr);
                    this.mRemote.transact(22, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readInt();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public void perfLockRelease(int i) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    this.mRemote.transact(23, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public int querySysInfo(int i, int i2) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    this.mRemote.transact(24, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readInt();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public void mtkPowerHint(int i, int i2) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    this.mRemote.transact(25, obtain, (Parcel) null, 1);
                } finally {
                    obtain.recycle();
                }
            }

            public int perfCusLockHint(int i, int i2) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    this.mRemote.transact(26, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readInt();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public int setSysInfoSync(int i, String str) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeString(str);
                    this.mRemote.transact(27, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readInt();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean setPriorityByUid(int i, int i2) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    this.mRemote.transact(28, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean setPriorityByLinkinfo(int i, DupLinkInfo dupLinkInfo) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeTypedObject(dupLinkInfo, 0);
                    this.mRemote.transact(29, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean flushPriorityRules(int i) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeInt(i);
                    this.mRemote.transact(30, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean configBoosterInfo(BoosterInfo boosterInfo) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IPowerHalMgr.DESCRIPTOR);
                    obtain.writeTypedObject(boosterInfo, 0);
                    this.mRemote.transact(31, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }
        }
    }
}
