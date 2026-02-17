package com.mediatek.vow;

import android.hardware.soundtrigger.IRecognitionStatusCallback;
import android.hardware.soundtrigger.SoundTrigger;
import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;

public interface IVoiceWakeupBridge extends IInterface {
    public static final String DESCRIPTOR = "com.mediatek.vow.IVoiceWakeupBridge";

    public static class Default implements IVoiceWakeupBridge {
        public IBinder asBinder() {
            return null;
        }

        public int startRecognition(int i, SoundTrigger.KeyphraseSoundModel keyphraseSoundModel, IRecognitionStatusCallback iRecognitionStatusCallback, SoundTrigger.RecognitionConfig recognitionConfig) throws RemoteException {
            return 0;
        }

        public int stopRecognition(int i, IRecognitionStatusCallback iRecognitionStatusCallback) throws RemoteException {
            return 0;
        }

        public int unloadKeyphraseModel(int i) throws RemoteException {
            return 0;
        }
    }

    int startRecognition(int i, SoundTrigger.KeyphraseSoundModel keyphraseSoundModel, IRecognitionStatusCallback iRecognitionStatusCallback, SoundTrigger.RecognitionConfig recognitionConfig) throws RemoteException;

    int stopRecognition(int i, IRecognitionStatusCallback iRecognitionStatusCallback) throws RemoteException;

    int unloadKeyphraseModel(int i) throws RemoteException;

    public static abstract class Stub extends Binder implements IVoiceWakeupBridge {
        static final int TRANSACTION_startRecognition = 1;
        static final int TRANSACTION_stopRecognition = 2;
        static final int TRANSACTION_unloadKeyphraseModel = 3;

        public IBinder asBinder() {
            return this;
        }

        public Stub() {
            attachInterface(this, IVoiceWakeupBridge.DESCRIPTOR);
        }

        public static IVoiceWakeupBridge asInterface(IBinder iBinder) {
            if (iBinder == null) {
                return null;
            }
            IInterface queryLocalInterface = iBinder.queryLocalInterface(IVoiceWakeupBridge.DESCRIPTOR);
            if (queryLocalInterface == null || !(queryLocalInterface instanceof IVoiceWakeupBridge)) {
                return new Proxy(iBinder);
            }
            return (IVoiceWakeupBridge) queryLocalInterface;
        }

        public boolean onTransact(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
            if (i >= 1 && i <= 16777215) {
                parcel.enforceInterface(IVoiceWakeupBridge.DESCRIPTOR);
            }
            if (i != 1598968902) {
                if (i == 1) {
                    parcel.enforceNoDataAvail();
                    int startRecognition = startRecognition(parcel.readInt(), (SoundTrigger.KeyphraseSoundModel) parcel.readTypedObject(SoundTrigger.KeyphraseSoundModel.CREATOR), IRecognitionStatusCallback.Stub.asInterface(parcel.readStrongBinder()), (SoundTrigger.RecognitionConfig) parcel.readTypedObject(SoundTrigger.RecognitionConfig.CREATOR));
                    parcel2.writeNoException();
                    parcel2.writeInt(startRecognition);
                } else if (i == 2) {
                    int readInt = parcel.readInt();
                    IRecognitionStatusCallback asInterface = IRecognitionStatusCallback.Stub.asInterface(parcel.readStrongBinder());
                    parcel.enforceNoDataAvail();
                    int stopRecognition = stopRecognition(readInt, asInterface);
                    parcel2.writeNoException();
                    parcel2.writeInt(stopRecognition);
                } else if (i != 3) {
                    return super.onTransact(i, parcel, parcel2, i2);
                } else {
                    int readInt2 = parcel.readInt();
                    parcel.enforceNoDataAvail();
                    int unloadKeyphraseModel = unloadKeyphraseModel(readInt2);
                    parcel2.writeNoException();
                    parcel2.writeInt(unloadKeyphraseModel);
                }
                return true;
            }
            parcel2.writeString(IVoiceWakeupBridge.DESCRIPTOR);
            return true;
        }

        private static class Proxy implements IVoiceWakeupBridge {
            private IBinder mRemote;

            public String getInterfaceDescriptor() {
                return IVoiceWakeupBridge.DESCRIPTOR;
            }

            Proxy(IBinder iBinder) {
                this.mRemote = iBinder;
            }

            public IBinder asBinder() {
                return this.mRemote;
            }

            public int startRecognition(int i, SoundTrigger.KeyphraseSoundModel keyphraseSoundModel, IRecognitionStatusCallback iRecognitionStatusCallback, SoundTrigger.RecognitionConfig recognitionConfig) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IVoiceWakeupBridge.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeTypedObject(keyphraseSoundModel, 0);
                    obtain.writeStrongInterface(iRecognitionStatusCallback);
                    obtain.writeTypedObject(recognitionConfig, 0);
                    this.mRemote.transact(1, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readInt();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public int stopRecognition(int i, IRecognitionStatusCallback iRecognitionStatusCallback) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IVoiceWakeupBridge.DESCRIPTOR);
                    obtain.writeInt(i);
                    obtain.writeStrongInterface(iRecognitionStatusCallback);
                    this.mRemote.transact(2, obtain, obtain2, 0);
                    obtain2.readException();
                    return obtain2.readInt();
                } finally {
                    obtain2.recycle();
                    obtain.recycle();
                }
            }

            public int unloadKeyphraseModel(int i) throws RemoteException {
                Parcel obtain = Parcel.obtain();
                Parcel obtain2 = Parcel.obtain();
                try {
                    obtain.writeInterfaceToken(IVoiceWakeupBridge.DESCRIPTOR);
                    obtain.writeInt(i);
                    this.mRemote.transact(3, obtain, obtain2, 0);
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
