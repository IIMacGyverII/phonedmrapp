package com.mediatek.anr;

import android.os.Binder;
import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;
import java.lang.reflect.Method;

public abstract class AnrManagerNative extends Binder implements IAnrManager {
    private static final Singleton<IAnrManager> gDefault = new Singleton<IAnrManager>() {
        /* access modifiers changed from: protected */
        public IAnrManager create() {
            IBinder iBinder = null;
            try {
                iBinder = (IBinder) AnrManagerNative.sGetService.invoke((Object) null, new Object[]{"anrmanager"});
            } catch (Exception unused) {
            }
            return AnrManagerNative.asInterface(iBinder);
        }
    };
    /* access modifiers changed from: private */
    public static Method sGetService = getServiceManagerMethod("getService", new Class[]{String.class});

    public IBinder asBinder() {
        return this;
    }

    private static Method getServiceManagerMethod(String str, Class[] clsArr) {
        try {
            return Class.forName("android.os.ServiceManager").getDeclaredMethod(str, clsArr);
        } catch (Exception unused) {
            return null;
        }
    }

    public static IAnrManager asInterface(IBinder iBinder) {
        if (iBinder == null) {
            return null;
        }
        IAnrManager iAnrManager = (IAnrManager) iBinder.queryLocalInterface(IAnrManager.descriptor);
        if (iAnrManager != null) {
            return iAnrManager;
        }
        return new AnrManagerProxy(iBinder);
    }

    public static IAnrManager getDefault() {
        return gDefault.get();
    }

    public AnrManagerNative() {
        attachInterface(this, IAnrManager.descriptor);
    }

    public boolean onTransact(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
        if (i != 2) {
            return super.onTransact(i, parcel, parcel2, i2);
        }
        parcel.enforceInterface(IAnrManager.descriptor);
        informMessageDump(parcel.readString(), parcel.readInt());
        return true;
    }

    static abstract class Singleton<T> {
        private T mInstance;

        /* access modifiers changed from: protected */
        public abstract T create();

        Singleton() {
        }

        public final T get() {
            T t;
            synchronized (this) {
                if (this.mInstance == null) {
                    this.mInstance = create();
                }
                t = this.mInstance;
            }
            return t;
        }
    }
}
