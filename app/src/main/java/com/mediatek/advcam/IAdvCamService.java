package com.mediatek.advcam;

import android.hardware.camera2.CaptureRequest;
import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;

public interface IAdvCamService extends IInterface {
    public static final String DESCRIPTOR = "com.mediatek.advcam.IAdvCamService";

    public static class Default implements IAdvCamService {
        public IBinder asBinder() {
            return null;
        }

        public int setConfigureParam(int i, CaptureRequest captureRequest) throws RemoteException {
            return 0;
        }
    }

    int setConfigureParam(int i, CaptureRequest captureRequest) throws RemoteException;

    public static abstract class Stub extends Binder implements IAdvCamService {
        static final int TRANSACTION_setConfigureParam = 1;

        public IBinder asBinder() {
            return this;
        }

        public Stub() {
            attachInterface(this, IAdvCamService.DESCRIPTOR);
        }

        public static IAdvCamService asInterface(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface queryLocalInterface = iBinder.queryLocalInterface(IAdvCamService.DESCRIPTOR);
            if (queryLocalInterface == null || !(queryLocalInterface instanceof IAdvCamService)) {
                return new Proxy(iBinder);
            }
            return (IAdvCamService) queryLocalInterface;
        }

        public boolean onTransact(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
            if (i >= 1 && i <= 16777215) {
                parcel.enforceInterface(IAdvCamService.DESCRIPTOR);
            }
            if (i == 1598968902) {
                parcel2.writeString(IAdvCamService.DESCRIPTOR);
                return true;
            } else if (i != 1) {
                return super.onTransact(i, parcel, parcel2, i2);
            } else {
                parcel.enforceNoDataAvail();
                int configureParam = setConfigureParam(parcel.readInt(), (CaptureRequest) parcel.readTypedObject(CaptureRequest.CREATOR));
                parcel2.writeNoException();
                parcel2.writeInt(configureParam);
                return true;
            }
        }

        private static class Proxy implements IAdvCamService {
            private IBinder mRemote;

            public String getInterfaceDescriptor() {
                return IAdvCamService.DESCRIPTOR;
            }

            Proxy(IBinder iBinder) {
                this.mRemote = iBinder;
            }

            public IBinder asBinder() {
                return this.mRemote;
            }

            public int setConfigureParam(int i, CaptureRequest captureRequest) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IAdvCamService.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeTypedObject(captureRequest, 0);
                    this.mRemote.transact(1, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readInt();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }
        }
    }
}
