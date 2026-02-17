package com.mediatek.gnssdebugreport;

import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;
import com.mediatek.gnssdebugreport.IDebugReportCallback;

public interface IGnssDebugReportService extends IInterface {
    public static final String DESCRIPTOR = "com.mediatek.gnssdebugreport.IGnssDebugReportService";

    public static class Default implements IGnssDebugReportService {
        public void addListener(IDebugReportCallback iDebugReportCallback) throws RemoteException {
        }

        public IBinder asBinder() {
            return null;
        }

        public void removeListener(IDebugReportCallback iDebugReportCallback) throws RemoteException {
        }

        public boolean startDebug(IDebugReportCallback iDebugReportCallback) throws RemoteException {
            return false;
        }

        public boolean stopDebug(IDebugReportCallback iDebugReportCallback) throws RemoteException {
            return false;
        }
    }

    void addListener(IDebugReportCallback iDebugReportCallback) throws RemoteException;

    void removeListener(IDebugReportCallback iDebugReportCallback) throws RemoteException;

    boolean startDebug(IDebugReportCallback iDebugReportCallback) throws RemoteException;

    boolean stopDebug(IDebugReportCallback iDebugReportCallback) throws RemoteException;

    public static abstract class Stub extends Binder implements IGnssDebugReportService {
        static final int TRANSACTION_addListener = 3;
        static final int TRANSACTION_removeListener = 4;
        static final int TRANSACTION_startDebug = 1;
        static final int TRANSACTION_stopDebug = 2;

        public IBinder asBinder() {
            return this;
        }

        public Stub() {
            attachInterface(this, IGnssDebugReportService.DESCRIPTOR);
        }

        public static IGnssDebugReportService asInterface(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface queryLocalInterface = iBinder.queryLocalInterface(IGnssDebugReportService.DESCRIPTOR);
            if (queryLocalInterface == null || !(queryLocalInterface instanceof IGnssDebugReportService)) {
                return new Proxy(iBinder);
            }
            return (IGnssDebugReportService) queryLocalInterface;
        }

        public boolean onTransact(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
            if (i >= 1 && i <= 16777215) {
                parcel.enforceInterface(IGnssDebugReportService.DESCRIPTOR);
            }
            if (i != 1598968902) {
                if (i == 1) {
                    IDebugReportCallback asInterface = IDebugReportCallback.Stub.asInterface(parcel.readStrongBinder());
                    parcel.enforceNoDataAvail();
                    boolean startDebug = startDebug(asInterface);
                    parcel2.writeNoException();
                    parcel2.writeBoolean(startDebug);
                } else if (i == 2) {
                    IDebugReportCallback asInterface2 = IDebugReportCallback.Stub.asInterface(parcel.readStrongBinder());
                    parcel.enforceNoDataAvail();
                    boolean stopDebug = stopDebug(asInterface2);
                    parcel2.writeNoException();
                    parcel2.writeBoolean(stopDebug);
                } else if (i == 3) {
                    IDebugReportCallback asInterface3 = IDebugReportCallback.Stub.asInterface(parcel.readStrongBinder());
                    parcel.enforceNoDataAvail();
                    addListener(asInterface3);
                    parcel2.writeNoException();
                } else if (i != 4) {
                    return super.onTransact(i, parcel, parcel2, i2);
                } else {
                    IDebugReportCallback asInterface4 = IDebugReportCallback.Stub.asInterface(parcel.readStrongBinder());
                    parcel.enforceNoDataAvail();
                    removeListener(asInterface4);
                    parcel2.writeNoException();
                }
                return true;
            }
            parcel2.writeString(IGnssDebugReportService.DESCRIPTOR);
            return true;
        }

        private static class Proxy implements IGnssDebugReportService {
            private IBinder mRemote;

            public String getInterfaceDescriptor() {
                return IGnssDebugReportService.DESCRIPTOR;
            }

            Proxy(IBinder iBinder) {
                this.mRemote = iBinder;
            }

            public IBinder asBinder() {
                return this.mRemote;
            }

            public boolean startDebug(IDebugReportCallback iDebugReportCallback) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IGnssDebugReportService.DESCRIPTOR);
                    obtain.writeStrongInterface(iDebugReportCallback);
                    this.mRemote.transact(1, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean stopDebug(IDebugReportCallback iDebugReportCallback) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IGnssDebugReportService.DESCRIPTOR);
                    obtain.writeStrongInterface(iDebugReportCallback);
                    this.mRemote.transact(2, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public void addListener(IDebugReportCallback iDebugReportCallback) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IGnssDebugReportService.DESCRIPTOR);
                    obtain.writeStrongInterface(iDebugReportCallback);
                    this.mRemote.transact(3, obtain, obtain2, 0);
                    obtain2.readException();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public void removeListener(IDebugReportCallback iDebugReportCallback) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IGnssDebugReportService.DESCRIPTOR);
                    obtain.writeStrongInterface(iDebugReportCallback);
                    this.mRemote.transact(4, obtain, obtain2, 0);
                    obtain2.readException();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }
        }
    }
}
