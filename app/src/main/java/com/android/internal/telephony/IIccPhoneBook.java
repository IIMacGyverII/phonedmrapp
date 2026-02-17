package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.ContentValues;
import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;
import com.android.internal.telephony.uicc.AdnCapacity;
import com.android.internal.telephony.uicc.AdnRecord;
import java.util.List;

public interface IIccPhoneBook extends IInterface {
    public static final String DESCRIPTOR = "com.android.internal.telephony.IIccPhoneBook";

    public static class Default implements IIccPhoneBook {
        public IBinder asBinder() {
            return null;
        }

        public AdnCapacity getAdnRecordsCapacityForSubscriber(int i) throws RemoteException {
            return null;
        }

        public List<AdnRecord> getAdnRecordsInEf(int i) throws RemoteException {
            return null;
        }

        public List<AdnRecord> getAdnRecordsInEfForSubscriber(int i, int i2) throws RemoteException {
            return null;
        }

        public int[] getAdnRecordsSize(int i) throws RemoteException {
            return null;
        }

        public int[] getAdnRecordsSizeForSubscriber(int i, int i2) throws RemoteException {
            return null;
        }

        public boolean updateAdnRecordsInEfByIndexForSubscriber(int i, int i2, ContentValues contentValues, int i3, String str) throws RemoteException {
            return false;
        }

        public boolean updateAdnRecordsInEfBySearch(int i, String str, String str2, String str3, String str4, String str5) throws RemoteException {
            return false;
        }

        public boolean updateAdnRecordsInEfBySearchForSubscriber(int i, int i2, ContentValues contentValues, String str) throws RemoteException {
            return false;
        }
    }

    AdnCapacity getAdnRecordsCapacityForSubscriber(int i) throws RemoteException;

    @UnsupportedAppUsage(overrideSourcePosition = "frameworks/opt/telephony/src/java/com/android/internal/telephony/IIccPhoneBook.aidl:36:1:36:25")
    List<AdnRecord> getAdnRecordsInEf(int i) throws RemoteException;

    @UnsupportedAppUsage(overrideSourcePosition = "frameworks/opt/telephony/src/java/com/android/internal/telephony/IIccPhoneBook.aidl:47:1:47:25")
    List<AdnRecord> getAdnRecordsInEfForSubscriber(int i, int i2) throws RemoteException;

    @UnsupportedAppUsage(overrideSourcePosition = "frameworks/opt/telephony/src/java/com/android/internal/telephony/IIccPhoneBook.aidl:114:1:114:25")
    int[] getAdnRecordsSize(int i) throws RemoteException;

    @UnsupportedAppUsage(overrideSourcePosition = "frameworks/opt/telephony/src/java/com/android/internal/telephony/IIccPhoneBook.aidl:127:1:127:25")
    int[] getAdnRecordsSizeForSubscriber(int i, int i2) throws RemoteException;

    boolean updateAdnRecordsInEfByIndexForSubscriber(int i, int i2, ContentValues contentValues, int i3, String str) throws RemoteException;

    @UnsupportedAppUsage(overrideSourcePosition = "frameworks/opt/telephony/src/java/com/android/internal/telephony/IIccPhoneBook.aidl:68:1:68:25")
    boolean updateAdnRecordsInEfBySearch(int i, String str, String str2, String str3, String str4, String str5) throws RemoteException;

    boolean updateAdnRecordsInEfBySearchForSubscriber(int i, int i2, ContentValues contentValues, String str) throws RemoteException;

    public static abstract class Stub extends Binder implements IIccPhoneBook {
        static final int TRANSACTION_getAdnRecordsCapacityForSubscriber = 8;
        static final int TRANSACTION_getAdnRecordsInEf = 1;
        static final int TRANSACTION_getAdnRecordsInEfForSubscriber = 2;
        static final int TRANSACTION_getAdnRecordsSize = 6;
        static final int TRANSACTION_getAdnRecordsSizeForSubscriber = 7;
        static final int TRANSACTION_updateAdnRecordsInEfByIndexForSubscriber = 5;
        static final int TRANSACTION_updateAdnRecordsInEfBySearch = 3;
        static final int TRANSACTION_updateAdnRecordsInEfBySearchForSubscriber = 4;

        public IBinder asBinder() {
            return this;
        }

        public Stub() {
            attachInterface(this, IIccPhoneBook.DESCRIPTOR);
        }

        public static IIccPhoneBook asInterface(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface queryLocalInterface = iBinder.queryLocalInterface(IIccPhoneBook.DESCRIPTOR);
            if (queryLocalInterface == null || !(queryLocalInterface instanceof IIccPhoneBook)) {
                return new Proxy(iBinder);
            }
            return (IIccPhoneBook) queryLocalInterface;
        }

        public boolean onTransact(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
            if (i >= 1 && i <= 16777215) {
                parcel.enforceInterface(IIccPhoneBook.DESCRIPTOR);
            }
            if (i != 1598968902) {
                switch (i) {
                    case 1:
                        int readInt = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        List<AdnRecord> adnRecordsInEf = getAdnRecordsInEf(readInt);
                        parcel2.writeNoException();
                        parcel2.writeTypedList(adnRecordsInEf);
                        break;
                    case 2:
                        int readInt2 = parcel.readInt();
                        int readInt3 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        List<AdnRecord> adnRecordsInEfForSubscriber = getAdnRecordsInEfForSubscriber(readInt2, readInt3);
                        parcel2.writeNoException();
                        parcel2.writeTypedList(adnRecordsInEfForSubscriber);
                        break;
                    case 3:
                        int readInt4 = parcel.readInt();
                        String readString = parcel.readString();
                        String readString2 = parcel.readString();
                        String readString3 = parcel.readString();
                        String readString4 = parcel.readString();
                        String readString5 = parcel.readString();
                        parcel.enforceNoDataAvail();
                        boolean updateAdnRecordsInEfBySearch = updateAdnRecordsInEfBySearch(readInt4, readString, readString2, readString3, readString4, readString5);
                        parcel2.writeNoException();
                        parcel2.writeBoolean(updateAdnRecordsInEfBySearch);
                        break;
                    case 4:
                        String readString6 = parcel.readString();
                        parcel.enforceNoDataAvail();
                        boolean updateAdnRecordsInEfBySearchForSubscriber = updateAdnRecordsInEfBySearchForSubscriber(parcel.readInt(), parcel.readInt(), (ContentValues) parcel.readTypedObject(ContentValues.CREATOR), readString6);
                        parcel2.writeNoException();
                        parcel2.writeBoolean(updateAdnRecordsInEfBySearchForSubscriber);
                        break;
                    case 5:
                        int readInt5 = parcel.readInt();
                        String readString7 = parcel.readString();
                        parcel.enforceNoDataAvail();
                        boolean updateAdnRecordsInEfByIndexForSubscriber = updateAdnRecordsInEfByIndexForSubscriber(parcel.readInt(), parcel.readInt(), (ContentValues) parcel.readTypedObject(ContentValues.CREATOR), readInt5, readString7);
                        parcel2.writeNoException();
                        parcel2.writeBoolean(updateAdnRecordsInEfByIndexForSubscriber);
                        break;
                    case 6:
                        int readInt6 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        int[] adnRecordsSize = getAdnRecordsSize(readInt6);
                        parcel2.writeNoException();
                        parcel2.writeIntArray(adnRecordsSize);
                        break;
                    case 7:
                        int readInt7 = parcel.readInt();
                        int readInt8 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        int[] adnRecordsSizeForSubscriber = getAdnRecordsSizeForSubscriber(readInt7, readInt8);
                        parcel2.writeNoException();
                        parcel2.writeIntArray(adnRecordsSizeForSubscriber);
                        break;
                    case 8:
                        int readInt9 = parcel.readInt();
                        parcel.enforceNoDataAvail();
                        AdnCapacity adnRecordsCapacityForSubscriber = getAdnRecordsCapacityForSubscriber(readInt9);
                        parcel2.writeNoException();
                        parcel2.writeTypedObject(adnRecordsCapacityForSubscriber, 1);
                        break;
                    default:
                        return super.onTransact(i, parcel, parcel2, i2);
                }
                return true;
            }
            parcel2.writeString(IIccPhoneBook.DESCRIPTOR);
            return true;
        }

        private static class Proxy implements IIccPhoneBook {
            private IBinder mRemote;

            public String getInterfaceDescriptor() {
                return IIccPhoneBook.DESCRIPTOR;
            }

            Proxy(IBinder iBinder) {
                this.mRemote = iBinder;
            }

            public IBinder asBinder() {
                return this.mRemote;
            }

            public List<AdnRecord> getAdnRecordsInEf(int i) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IIccPhoneBook.DESCRIPTOR);
                    obtain.writeInt(i);
                    this.mRemote.transact(1, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.createTypedArrayList(AdnRecord.CREATOR);
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public List<AdnRecord> getAdnRecordsInEfForSubscriber(int i, int i2) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IIccPhoneBook.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    this.mRemote.transact(2, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.createTypedArrayList(AdnRecord.CREATOR);
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean updateAdnRecordsInEfBySearch(int i, String str, String str2, String str3, String str4, String str5) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IIccPhoneBook.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeString(str);
                    obtain.writeString(str2);
                    obtain.writeString(str3);
                    obtain.writeString(str4);
                    obtain.writeString(str5);
                    this.mRemote.transact(3, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean updateAdnRecordsInEfBySearchForSubscriber(int i, int i2, ContentValues contentValues, String str) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IIccPhoneBook.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    obtain.writeTypedObject(contentValues, 0);
                    obtain.writeString(str);
                    this.mRemote.transact(4, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public boolean updateAdnRecordsInEfByIndexForSubscriber(int i, int i2, ContentValues contentValues, int i3, String str) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IIccPhoneBook.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    obtain.writeTypedObject(contentValues, 0);
                    obtain.writeInt(i3);
                    obtain.writeString(str);
                    this.mRemote.transact(5, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readBoolean();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public int[] getAdnRecordsSize(int i) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IIccPhoneBook.DESCRIPTOR);
                    obtain.writeInt(i);
                    this.mRemote.transact(6, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.createIntArray();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public int[] getAdnRecordsSizeForSubscriber(int i, int i2) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IIccPhoneBook.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeInt(i2);
                    this.mRemote.transact(7, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.createIntArray();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public AdnCapacity getAdnRecordsCapacityForSubscriber(int i) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IIccPhoneBook.DESCRIPTOR);
                    obtain.writeInt(i);
                    this.mRemote.transact(8, obtain, obtain2, 0);
                    obtain2.readException();
                    return (AdnCapacity) obtain2.readTypedObject(AdnCapacity.CREATOR);
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }
        }
    }
}
