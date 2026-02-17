package com.mediatek.gnssdebugreport;

import android.os.Binder;
import android.os.Bundle;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;

public interface IDebugReportCallback extends IInterface {
    public static final String DESCRIPTOR = "com.mediatek.gnssdebugreport.IDebugReportCallback";

    public static class Default implements IDebugReportCallback {
        public IBinder asBinder() {
            return null;
        }

        public void onDebugReportAvailable(Bundle bundle) throws RemoteException {
        }
    }

    void onDebugReportAvailable(Bundle bundle) throws RemoteException;

    public static abstract class Stub extends Binder implements IDebugReportCallback {
        static final int TRANSACTION_onDebugReportAvailable = 1;

        public IBinder asBinder() {
            return this;
        }

        public Stub() {
            attachInterface(this, IDebugReportCallback.DESCRIPTOR);
        }

        public static IDebugReportCallback asInterface(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface queryLocalInterface = iBinder.queryLocalInterface(IDebugReportCallback.DESCRIPTOR);
            if (queryLocalInterface == null || !(queryLocalInterface instanceof IDebugReportCallback)) {
                return new Proxy(iBinder);
            }
            return (IDebugReportCallback) queryLocalInterface;
        }

        public boolean onTransact(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
            if (i >= 1 && i <= 16777215) {
                parcel.enforceInterface(IDebugReportCallback.DESCRIPTOR);
            }
            if (i == 1598968902) {
                parcel2.writeString(IDebugReportCallback.DESCRIPTOR);
                return true;
            } else if (i != 1) {
                return super.onTransact(i, parcel, parcel2, i2);
            } else {
                parcel.enforceNoDataAvail();
                onDebugReportAvailable((Bundle) parcel.readTypedObject(Bundle.CREATOR));
                parcel2.writeNoException();
                return true;
            }
        }

        private static class Proxy implements IDebugReportCallback {
            private IBinder mRemote;

            public String getInterfaceDescriptor() {
                return IDebugReportCallback.DESCRIPTOR;
            }

            Proxy(IBinder iBinder) {
                this.mRemote = iBinder;
            }

            public IBinder asBinder() {
                return this.mRemote;
            }

            public void onDebugReportAvailable(Bundle bundle) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IDebugReportCallback.DESCRIPTOR);
                    obtain.writeTypedObject(bundle, 0);
                    this.mRemote.transact(1, obtain, obtain2, 0);
                    obtain2.readException();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }
        }
    }
}
