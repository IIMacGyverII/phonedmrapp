package com.mediatek.search;

import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;
import com.mediatek.common.search.SearchEngine;
import java.util.List;

public interface ISearchEngineManagerService extends IInterface {
    public static final String DESCRIPTOR = "com.mediatek.search.ISearchEngineManagerService";

    public static class Default implements ISearchEngineManagerService {
        public IBinder asBinder() {
            return null;
        }

        public List<SearchEngine> getAvailables() throws RemoteException {
            return null;
        }

        public SearchEngine getBestMatch(String str, String str2) throws RemoteException {
            return null;
        }

        public SearchEngine getDefault() throws RemoteException {
            return null;
        }

        public SearchEngine getSearchEngine(int i, String str) throws RemoteException {
            return null;
        }

        public boolean setDefault(SearchEngine searchEngine) throws RemoteException {
            return false;
        }
    }

    List<SearchEngine> getAvailables() throws RemoteException;

    SearchEngine getBestMatch(String str, String str2) throws RemoteException;

    SearchEngine getDefault() throws RemoteException;

    SearchEngine getSearchEngine(int i, String str) throws RemoteException;

    boolean setDefault(SearchEngine searchEngine) throws RemoteException;

    public static abstract class Stub extends Binder implements ISearchEngineManagerService {
        static final int TRANSACTION_getAvailables = 1;
        static final int TRANSACTION_getBestMatch = 3;
        static final int TRANSACTION_getDefault = 2;
        static final int TRANSACTION_getSearchEngine = 4;
        static final int TRANSACTION_setDefault = 5;

        public IBinder asBinder() {
            return this;
        }

        public Stub() {
            attachInterface(this, ISearchEngineManagerService.DESCRIPTOR);
        }

        public static ISearchEngineManagerService asInterface(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface queryLocalInterface = iBinder.queryLocalInterface(ISearchEngineManagerService.DESCRIPTOR);
            if (queryLocalInterface == null || !(queryLocalInterface instanceof ISearchEngineManagerService)) {
                return new Proxy(iBinder);
            }
            return (ISearchEngineManagerService) queryLocalInterface;
        }

        public boolean onTransact(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
            if (i >= 1 && i <= 16777215) {
                parcel.enforceInterface(ISearchEngineManagerService.DESCRIPTOR);
            }
            if (i != 1598968902) {
                if (i == 1) {
                    List<SearchEngine> availables = getAvailables();
                    parcel2.writeNoException();
                    parcel2.writeTypedList(availables);
                } else if (i == 2) {
                    SearchEngine searchEngine = getDefault();
                    parcel2.writeNoException();
                    parcel2.writeTypedObject(searchEngine, 1);
                } else if (i == 3) {
                    String readString = parcel.readString();
                    String readString2 = parcel.readString();
                    parcel.enforceNoDataAvail();
                    SearchEngine bestMatch = getBestMatch(readString, readString2);
                    parcel2.writeNoException();
                    parcel2.writeTypedObject(bestMatch, 1);
                } else if (i == 4) {
                    int readInt = parcel.readInt();
                    String readString3 = parcel.readString();
                    parcel.enforceNoDataAvail();
                    SearchEngine searchEngine2 = getSearchEngine(readInt, readString3);
                    parcel2.writeNoException();
                    parcel2.writeTypedObject(searchEngine2, 1);
                } else if (i != 5) {
                    return super.onTransact(i, parcel, parcel2, i2);
                } else {
                    parcel.enforceNoDataAvail();
                    boolean z = setDefault((SearchEngine) parcel.readTypedObject(SearchEngine.CREATOR));
                    parcel2.writeNoException();
                    parcel2.writeBoolean(z);
                }
                return true;
            }
            parcel2.writeString(ISearchEngineManagerService.DESCRIPTOR);
            return true;
        }

        private static class Proxy implements ISearchEngineManagerService {
            private IBinder mRemote;

            public String getInterfaceDescriptor() {
                return ISearchEngineManagerService.DESCRIPTOR;
            }

            Proxy(IBinder iBinder) {
                this.mRemote = iBinder;
            }

            public IBinder asBinder() {
                return this.mRemote;
            }

            public List<SearchEngine> getAvailables() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(ISearchEngineManagerService.DESCRIPTOR);
                    this.mRemote.transact(1, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.createTypedArrayList(SearchEngine.CREATOR);
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public SearchEngine getDefault() throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(ISearchEngineManagerService.DESCRIPTOR);
                    this.mRemote.transact(2, obtain, obtain2, 0);
                    obtain2.readException();
                    return (SearchEngine) obtain2.readTypedObject(SearchEngine.CREATOR);
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public SearchEngine getBestMatch(String str, String str2) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(ISearchEngineManagerService.DESCRIPTOR);
                    obtain.writeString(str);
                    obtain.writeString(str2);
                    this.mRemote.transact(3, obtain, obtain2, 0);
                    obtain2.readException();
                    return (SearchEngine) obtain2.readTypedObject(SearchEngine.CREATOR);
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public SearchEngine getSearchEngine(int i, String str) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(ISearchEngineManagerService.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeString(str);
                    this.mRemote.transact(4, obtain, obtain2, 0);
                    obtain2.readException();
                    return (SearchEngine) obtain2.readTypedObject(SearchEngine.CREATOR);
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean setDefault(SearchEngine searchEngine) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(ISearchEngineManagerService.DESCRIPTOR);
                    obtain.writeTypedObject(searchEngine, 0);
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
