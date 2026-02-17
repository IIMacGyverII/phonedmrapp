package com.mediatek.datashaping;

import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;

public interface IDataShapingManager extends IInterface {
    public static final String DESCRIPTOR = "com.mediatek.datashaping.IDataShapingManager";

    public static class Default implements IDataShapingManager {
        public IBinder asBinder() {
            return null;
        }

        public void disableDataShaping() throws RemoteException {
        }

        public void enableDataShaping() throws RemoteException {
        }

        public boolean isDataShapingWhitelistApp(String str) throws RemoteException {
            return false;
        }

        public boolean openLteDataUpLinkGate(boolean z) throws RemoteException {
            return false;
        }

        public void setDeviceIdleMode(boolean z) throws RemoteException {
        }
    }

    void disableDataShaping() throws RemoteException;

    void enableDataShaping() throws RemoteException;

    boolean isDataShapingWhitelistApp(String str) throws RemoteException;

    boolean openLteDataUpLinkGate(boolean z) throws RemoteException;

    void setDeviceIdleMode(boolean z) throws RemoteException;

    public static abstract class Stub extends Binder implements IDataShapingManager {
        static final int TRANSACTION_disableDataShaping = 2;
        static final int TRANSACTION_enableDataShaping = 1;
        static final int TRANSACTION_isDataShapingWhitelistApp = 5;
        static final int TRANSACTION_openLteDataUpLinkGate = 3;
        static final int TRANSACTION_setDeviceIdleMode = 4;

        public IBinder asBinder() {
            return this;
        }

        public Stub() {
            attachInterface(this, IDataShapingManager.DESCRIPTOR);
        }

        public static IDataShapingManager asInterface(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface queryLocalInterface = iBinder.queryLocalInterface(IDataShapingManager.DESCRIPTOR);
            if (queryLocalInterface == null || !(queryLocalInterface instanceof IDataShapingManager)) {
                return new Proxy(iBinder);
            }
            return (IDataShapingManager) queryLocalInterface;
        }

        public boolean onTransact(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
            if (i >= 1 && i <= 16777215) {
                parcel.enforceInterface(IDataShapingManager.DESCRIPTOR);
            }
            if (i != 1598968902) {
                if (i == 1) {
                    enableDataShaping();
                    parcel2.writeNoException();
                } else if (i == 2) {
                    disableDataShaping();
                    parcel2.writeNoException();
                } else if (i == 3) {
                    boolean readBoolean = parcel.readBoolean();
                    parcel.enforceNoDataAvail();
                    boolean openLteDataUpLinkGate = openLteDataUpLinkGate(readBoolean);
                    parcel2.writeNoException();
                    parcel2.writeBoolean(openLteDataUpLinkGate);
                } else if (i == 4) {
                    boolean readBoolean2 = parcel.readBoolean();
                    parcel.enforceNoDataAvail();
                    setDeviceIdleMode(readBoolean2);
                    parcel2.writeNoException();
                } else if (i != 5) {
                    return super.onTransact(i, parcel, parcel2, i2);
                } else {
                    String readString = parcel.readString();
                    parcel.enforceNoDataAvail();
                    boolean isDataShapingWhitelistApp = isDataShapingWhitelistApp(readString);
                    parcel2.writeNoException();
                    parcel2.writeBoolean(isDataShapingWhitelistApp);
                }
                return true;
            }
            parcel2.writeString(IDataShapingManager.DESCRIPTOR);
            return true;
        }

        private static class Proxy implements IDataShapingManager {
            private IBinder mRemote;

            public String getInterfaceDescriptor() {
                return IDataShapingManager.DESCRIPTOR;
            }

            Proxy(IBinder iBinder) {
                this.mRemote = iBinder;
            }

            public IBinder asBinder() {
                return this.mRemote;
            }

            public void enableDataShaping() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IDataShapingManager.DESCRIPTOR);
                    this.mRemote.transact(1, obtain, obtain2, 0);
                    obtain2.readException();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public void disableDataShaping() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IDataShapingManager.DESCRIPTOR);
                    this.mRemote.transact(2, obtain, obtain2, 0);
                    obtain2.readException();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean openLteDataUpLinkGate(boolean z) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IDataShapingManager.DESCRIPTOR);
                    obtain.writeBoolean(z);
                    this.mRemote.transact(3, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public void setDeviceIdleMode(boolean z) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IDataShapingManager.DESCRIPTOR);
                    obtain.writeBoolean(z);
                    this.mRemote.transact(4, obtain, obtain2, 0);
                    obtain2.readException();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean isDataShapingWhitelistApp(String str) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IDataShapingManager.DESCRIPTOR);
                    obtain.writeString(str);
                    this.mRemote.transact(5, obtain, obtain2, 0);
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
