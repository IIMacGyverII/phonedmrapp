package com.android.internal.telephony.protobuf.nano.android;

import android.os.Parcel;
import android.os.Parcelable;
import android.util.Log;
import com.android.internal.telephony.protobuf.nano.InvalidProtocolBufferNanoException;
import com.android.internal.telephony.protobuf.nano.MessageNano;
import java.lang.reflect.Array;
import java.lang.reflect.InvocationTargetException;

public final class ParcelableMessageNanoCreator<T extends MessageNano> implements Parcelable.Creator<T> {
    private static final String TAG = "PMNCreator";
    private final Class<T> mClazz;

    public ParcelableMessageNanoCreator(Class<T> cls) {
        this.mClazz = cls;
    }

    public T createFromParcel(Parcel parcel) {
        String readString = parcel.readString();
        byte[] createByteArray = parcel.createByteArray();
        T t = null;
        try {
            T t2 = (MessageNano) Class.forName(readString, false, ParcelableMessageNanoCreator.class.getClassLoader()).asSubclass(MessageNano.class).getConstructor(new Class[0]).newInstance(new Object[0]);
            try {
                MessageNano.mergeFrom(t2, createByteArray);
                return t2;
            } catch (ClassNotFoundException e) {
                e = e;
                t = t2;
            } catch (NoSuchMethodException e2) {
                e = e2;
                t = t2;
                Log.e(TAG, "Exception trying to create proto from parcel", e);
                return t;
            } catch (InvocationTargetException e3) {
                e = e3;
                t = t2;
                Log.e(TAG, "Exception trying to create proto from parcel", e);
                return t;
            } catch (IllegalAccessException e4) {
                e = e4;
                t = t2;
                Log.e(TAG, "Exception trying to create proto from parcel", e);
                return t;
            } catch (InstantiationException e5) {
                e = e5;
                t = t2;
                Log.e(TAG, "Exception trying to create proto from parcel", e);
                return t;
            } catch (InvalidProtocolBufferNanoException e6) {
                e = e6;
                t = t2;
                Log.e(TAG, "Exception trying to create proto from parcel", e);
                return t;
            }
        } catch (ClassNotFoundException e7) {
            e = e7;
            Log.e(TAG, "Exception trying to create proto from parcel", e);
            return t;
        } catch (NoSuchMethodException e8) {
            e = e8;
            Log.e(TAG, "Exception trying to create proto from parcel", e);
            return t;
        } catch (InvocationTargetException e9) {
            e = e9;
            Log.e(TAG, "Exception trying to create proto from parcel", e);
            return t;
        } catch (IllegalAccessException e10) {
            e = e10;
            Log.e(TAG, "Exception trying to create proto from parcel", e);
            return t;
        } catch (InstantiationException e11) {
            e = e11;
            Log.e(TAG, "Exception trying to create proto from parcel", e);
            return t;
        } catch (InvalidProtocolBufferNanoException e12) {
            e = e12;
            Log.e(TAG, "Exception trying to create proto from parcel", e);
            return t;
        }
    }

    public T[] newArray(int i) {
        return (MessageNano[]) Array.newInstance(this.mClazz, i);
    }

    static <T extends MessageNano> void writeToParcel(Class<T> cls, MessageNano messageNano, Parcel parcel) {
        parcel.writeString(cls.getName());
        parcel.writeByteArray(MessageNano.toByteArray(messageNano));
    }
}
