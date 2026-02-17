package com.mediatek.anr;

import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;

class AnrManagerProxy implements IAnrManager {
    private IBinder mRemote;

    public AnrManagerProxy(IBinder iBinder) {
        this.mRemote = iBinder;
    }

    public IBinder asBinder() {
        return this.mRemote;
    }

    public void informMessageDump(String str, int i) throws RemoteException {
        Parcel obtain = Parcel.obtain();
        obtain.writeInterfaceToken(IAnrManager.descriptor);
        obtain.writeString(str);
        obtain.writeInt(i);
        this.mRemote.transact(2, obtain, (Parcel) null, 1);
        obtain.recycle();
    }
}
