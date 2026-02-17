package android.hardware.radio.config.V1_0;

import android.internal.hidl.base.V1_0.DebugInfo;
import android.internal.hidl.base.V1_0.IBase;
import android.os.HidlSupport;
import android.os.HwBinder;
import android.os.HwBlob;
import android.os.HwParcel;
import android.os.IHwBinder;
import android.os.IHwInterface;
import android.os.NativeHandle;
import android.os.RemoteException;
import com.pri.prizeinterphone.protocol.Const;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.Objects;
import kotlin.jvm.internal.ByteCompanionObject;

public interface IRadioConfig extends IBase {
    public static final String kInterfaceName = "android.hardware.radio.config@1.0::IRadioConfig";

    IHwBinder asBinder();

    void debug(NativeHandle nativeHandle, ArrayList<String> arrayList) throws RemoteException;

    DebugInfo getDebugInfo() throws RemoteException;

    ArrayList<byte[]> getHashChain() throws RemoteException;

    void getSimSlotsStatus(int i) throws RemoteException;

    ArrayList<String> interfaceChain() throws RemoteException;

    String interfaceDescriptor() throws RemoteException;

    boolean linkToDeath(IHwBinder.DeathRecipient deathRecipient, long j) throws RemoteException;

    void notifySyspropsChanged() throws RemoteException;

    void ping() throws RemoteException;

    void setHALInstrumentation() throws RemoteException;

    void setResponseFunctions(IRadioConfigResponse iRadioConfigResponse, IRadioConfigIndication iRadioConfigIndication) throws RemoteException;

    void setSimSlotsMapping(int i, ArrayList<Integer> arrayList) throws RemoteException;

    boolean unlinkToDeath(IHwBinder.DeathRecipient deathRecipient) throws RemoteException;

    static IRadioConfig asInterface(IHwBinder iHwBinder) {
        if (iHwBinder == null) {
            return null;
        }
        IRadioConfig queryLocalInterface = iHwBinder.queryLocalInterface(kInterfaceName);
        if (queryLocalInterface != null && (queryLocalInterface instanceof IRadioConfig)) {
            return queryLocalInterface;
        }
        Proxy proxy = new Proxy(iHwBinder);
        try {
            Iterator<String> it = proxy.interfaceChain().iterator();
            while (it.hasNext()) {
                if (it.next().equals(kInterfaceName)) {
                    return proxy;
                }
            }
        } catch (RemoteException unused) {
        }
        return null;
    }

    static IRadioConfig castFrom(IHwInterface iHwInterface) {
        if (iHwInterface == null) {
            return null;
        }
        return asInterface(iHwInterface.asBinder());
    }

    static IRadioConfig getService(String str, boolean z) throws RemoteException {
        return asInterface(HwBinder.getService(kInterfaceName, str, z));
    }

    static IRadioConfig getService(boolean z) throws RemoteException {
        return getService("default", z);
    }

    @Deprecated
    static IRadioConfig getService(String str) throws RemoteException {
        return asInterface(HwBinder.getService(kInterfaceName, str));
    }

    @Deprecated
    static IRadioConfig getService() throws RemoteException {
        return getService("default");
    }

    public static final class Proxy implements IRadioConfig {
        private IHwBinder mRemote;

        public Proxy(IHwBinder iHwBinder) {
            Objects.requireNonNull(iHwBinder);
            this.mRemote = iHwBinder;
        }

        public IHwBinder asBinder() {
            return this.mRemote;
        }

        public String toString() {
            try {
                return interfaceDescriptor() + "@Proxy";
            } catch (RemoteException unused) {
                return "[class or subclass of android.hardware.radio.config@1.0::IRadioConfig]@Proxy";
            }
        }

        public final boolean equals(Object obj) {
            return HidlSupport.interfacesEqual(this, obj);
        }

        public final int hashCode() {
            return asBinder().hashCode();
        }

        public void setResponseFunctions(IRadioConfigResponse iRadioConfigResponse, IRadioConfigIndication iRadioConfigIndication) throws RemoteException {
            IHwBinder iHwBinder;
            HwParcel hwParcel = new HwParcel();
            hwParcel.writeInterfaceToken(IRadioConfig.kInterfaceName);
            IHwBinder iHwBinder2 = null;
            if (iRadioConfigResponse == null) {
                iHwBinder = null;
            } else {
                iHwBinder = iRadioConfigResponse.asBinder();
            }
            hwParcel.writeStrongBinder(iHwBinder);
            if (iRadioConfigIndication != null) {
                iHwBinder2 = iRadioConfigIndication.asBinder();
            }
            hwParcel.writeStrongBinder(iHwBinder2);
            HwParcel hwParcel2 = new HwParcel();
            try {
                this.mRemote.transact(1, hwParcel, hwParcel2, 0);
                hwParcel2.verifySuccess();
                hwParcel.releaseTemporaryStorage();
            } finally {
                hwParcel2.release();
            }
        }

        public void getSimSlotsStatus(int i) throws RemoteException {
            HwParcel hwParcel = new HwParcel();
            hwParcel.writeInterfaceToken(IRadioConfig.kInterfaceName);
            hwParcel.writeInt32(i);
            HwParcel hwParcel2 = new HwParcel();
            try {
                this.mRemote.transact(2, hwParcel, hwParcel2, 1);
                hwParcel.releaseTemporaryStorage();
            } finally {
                hwParcel2.release();
            }
        }

        public void setSimSlotsMapping(int i, ArrayList<Integer> arrayList) throws RemoteException {
            HwParcel hwParcel = new HwParcel();
            hwParcel.writeInterfaceToken(IRadioConfig.kInterfaceName);
            hwParcel.writeInt32(i);
            hwParcel.writeInt32Vector(arrayList);
            HwParcel hwParcel2 = new HwParcel();
            try {
                this.mRemote.transact(3, hwParcel, hwParcel2, 1);
                hwParcel.releaseTemporaryStorage();
            } finally {
                hwParcel2.release();
            }
        }

        public ArrayList<String> interfaceChain() throws RemoteException {
            HwParcel hwParcel = new HwParcel();
            hwParcel.writeInterfaceToken("android.hidl.base@1.0::IBase");
            HwParcel hwParcel2 = new HwParcel();
            try {
                this.mRemote.transact(256067662, hwParcel, hwParcel2, 0);
                hwParcel2.verifySuccess();
                hwParcel.releaseTemporaryStorage();
                return hwParcel2.readStringVector();
            } finally {
                hwParcel2.release();
            }
        }

        public void debug(NativeHandle nativeHandle, ArrayList<String> arrayList) throws RemoteException {
            HwParcel hwParcel = new HwParcel();
            hwParcel.writeInterfaceToken("android.hidl.base@1.0::IBase");
            hwParcel.writeNativeHandle(nativeHandle);
            hwParcel.writeStringVector(arrayList);
            HwParcel hwParcel2 = new HwParcel();
            try {
                this.mRemote.transact(256131655, hwParcel, hwParcel2, 0);
                hwParcel2.verifySuccess();
                hwParcel.releaseTemporaryStorage();
            } finally {
                hwParcel2.release();
            }
        }

        public String interfaceDescriptor() throws RemoteException {
            HwParcel hwParcel = new HwParcel();
            hwParcel.writeInterfaceToken("android.hidl.base@1.0::IBase");
            HwParcel hwParcel2 = new HwParcel();
            try {
                this.mRemote.transact(256136003, hwParcel, hwParcel2, 0);
                hwParcel2.verifySuccess();
                hwParcel.releaseTemporaryStorage();
                return hwParcel2.readString();
            } finally {
                hwParcel2.release();
            }
        }

        public ArrayList<byte[]> getHashChain() throws RemoteException {
            HwParcel hwParcel = new HwParcel();
            hwParcel.writeInterfaceToken("android.hidl.base@1.0::IBase");
            HwParcel hwParcel2 = new HwParcel();
            try {
                this.mRemote.transact(256398152, hwParcel, hwParcel2, 0);
                hwParcel2.verifySuccess();
                hwParcel.releaseTemporaryStorage();
                ArrayList<byte[]> arrayList = new ArrayList<>();
                HwBlob readBuffer = hwParcel2.readBuffer(16);
                int int32 = readBuffer.getInt32(8);
                HwBlob readEmbeddedBuffer = hwParcel2.readEmbeddedBuffer((long) (int32 * 32), readBuffer.handle(), 0, true);
                arrayList.clear();
                for (int i = 0; i < int32; i++) {
                    byte[] bArr = new byte[32];
                    readEmbeddedBuffer.copyToInt8Array((long) (i * 32), bArr, 32);
                    arrayList.add(bArr);
                }
                return arrayList;
            } finally {
                hwParcel2.release();
            }
        }

        public void setHALInstrumentation() throws RemoteException {
            HwParcel hwParcel = new HwParcel();
            hwParcel.writeInterfaceToken("android.hidl.base@1.0::IBase");
            HwParcel hwParcel2 = new HwParcel();
            try {
                this.mRemote.transact(256462420, hwParcel, hwParcel2, 1);
                hwParcel.releaseTemporaryStorage();
            } finally {
                hwParcel2.release();
            }
        }

        public boolean linkToDeath(IHwBinder.DeathRecipient deathRecipient, long j) throws RemoteException {
            return this.mRemote.linkToDeath(deathRecipient, j);
        }

        public void ping() throws RemoteException {
            HwParcel hwParcel = new HwParcel();
            hwParcel.writeInterfaceToken("android.hidl.base@1.0::IBase");
            HwParcel hwParcel2 = new HwParcel();
            try {
                this.mRemote.transact(256921159, hwParcel, hwParcel2, 0);
                hwParcel2.verifySuccess();
                hwParcel.releaseTemporaryStorage();
            } finally {
                hwParcel2.release();
            }
        }

        public DebugInfo getDebugInfo() throws RemoteException {
            HwParcel hwParcel = new HwParcel();
            hwParcel.writeInterfaceToken("android.hidl.base@1.0::IBase");
            HwParcel hwParcel2 = new HwParcel();
            try {
                this.mRemote.transact(257049926, hwParcel, hwParcel2, 0);
                hwParcel2.verifySuccess();
                hwParcel.releaseTemporaryStorage();
                DebugInfo debugInfo = new DebugInfo();
                debugInfo.readFromParcel(hwParcel2);
                return debugInfo;
            } finally {
                hwParcel2.release();
            }
        }

        public void notifySyspropsChanged() throws RemoteException {
            HwParcel hwParcel = new HwParcel();
            hwParcel.writeInterfaceToken("android.hidl.base@1.0::IBase");
            HwParcel hwParcel2 = new HwParcel();
            try {
                this.mRemote.transact(257120595, hwParcel, hwParcel2, 1);
                hwParcel.releaseTemporaryStorage();
            } finally {
                hwParcel2.release();
            }
        }

        public boolean unlinkToDeath(IHwBinder.DeathRecipient deathRecipient) throws RemoteException {
            return this.mRemote.unlinkToDeath(deathRecipient);
        }
    }

    public static abstract class Stub extends HwBinder implements IRadioConfig {
        public IHwBinder asBinder() {
            return this;
        }

        public void debug(NativeHandle nativeHandle, ArrayList<String> arrayList) {
        }

        public final String interfaceDescriptor() {
            return IRadioConfig.kInterfaceName;
        }

        public final boolean linkToDeath(IHwBinder.DeathRecipient deathRecipient, long j) {
            return true;
        }

        public final void ping() {
        }

        public final void setHALInstrumentation() {
        }

        public final boolean unlinkToDeath(IHwBinder.DeathRecipient deathRecipient) {
            return true;
        }

        public final ArrayList<String> interfaceChain() {
            return new ArrayList<>(Arrays.asList(new String[]{IRadioConfig.kInterfaceName, "android.hidl.base@1.0::IBase"}));
        }

        public final ArrayList<byte[]> getHashChain() {
            return new ArrayList<>(Arrays.asList(new byte[][]{new byte[]{-121, Const.Command.SET_MIX_CHECK_INFO_CMD, 84, 105, -49, 68, 9, -16, -13, 59, 1, 80, -114, 122, 71, 124, -9, 31, Const.Command.SET_GAIN_MIC_CMD, 17, -28, 102, -35, 126, Const.Command.SET_SMS_PROTOCOL_TYPE_CMD, -75, -105, 26, 27, Const.Command.MODULE_INIT_CMD, -89, Const.Command.QUERY_DIGITAL_AUDIO_RECEIVE_INFO}, new byte[]{-20, ByteCompanionObject.MAX_VALUE, -41, -98, -48, Const.Command.RECEIVE_SMS_CMD, -6, -123, -68, 73, -108, Const.Command.SET_LAUNCH_INFO_CMD, -83, -82, 62, -66, Const.Command.SET_ANALOG_INFO_CMD, -17, 5, Const.Command.QUERY_DIGITAL_INFO_CMD, -13, -51, 105, 87, 19, -109, Const.Command.QUERY_DIGITAL_INFO_CMD, -72, 59, 24, -54, 76}}));
        }

        public final DebugInfo getDebugInfo() {
            DebugInfo debugInfo = new DebugInfo();
            debugInfo.pid = HidlSupport.getPidIfSharable();
            debugInfo.ptr = 0;
            debugInfo.arch = 0;
            return debugInfo;
        }

        public final void notifySyspropsChanged() {
            HwBinder.enableInstrumentation();
        }

        public IHwInterface queryLocalInterface(String str) {
            if (IRadioConfig.kInterfaceName.equals(str)) {
                return this;
            }
            return null;
        }

        public void registerAsService(String str) throws RemoteException {
            registerService(str);
        }

        public String toString() {
            return interfaceDescriptor() + "@Stub";
        }

        public void onTransact(int i, HwParcel hwParcel, HwParcel hwParcel2, int i2) throws RemoteException {
            if (i == 1) {
                hwParcel.enforceInterface(IRadioConfig.kInterfaceName);
                setResponseFunctions(IRadioConfigResponse.asInterface(hwParcel.readStrongBinder()), IRadioConfigIndication.asInterface(hwParcel.readStrongBinder()));
                hwParcel2.writeStatus(0);
                hwParcel2.send();
            } else if (i == 2) {
                hwParcel.enforceInterface(IRadioConfig.kInterfaceName);
                getSimSlotsStatus(hwParcel.readInt32());
            } else if (i != 3) {
                switch (i) {
                    case 256067662:
                        hwParcel.enforceInterface("android.hidl.base@1.0::IBase");
                        ArrayList<String> interfaceChain = interfaceChain();
                        hwParcel2.writeStatus(0);
                        hwParcel2.writeStringVector(interfaceChain);
                        hwParcel2.send();
                        return;
                    case 256131655:
                        hwParcel.enforceInterface("android.hidl.base@1.0::IBase");
                        debug(hwParcel.readNativeHandle(), hwParcel.readStringVector());
                        hwParcel2.writeStatus(0);
                        hwParcel2.send();
                        return;
                    case 256136003:
                        hwParcel.enforceInterface("android.hidl.base@1.0::IBase");
                        String interfaceDescriptor = interfaceDescriptor();
                        hwParcel2.writeStatus(0);
                        hwParcel2.writeString(interfaceDescriptor);
                        hwParcel2.send();
                        return;
                    case 256398152:
                        hwParcel.enforceInterface("android.hidl.base@1.0::IBase");
                        ArrayList<byte[]> hashChain = getHashChain();
                        hwParcel2.writeStatus(0);
                        HwBlob hwBlob = new HwBlob(16);
                        int size = hashChain.size();
                        hwBlob.putInt32(8, size);
                        hwBlob.putBool(12, false);
                        HwBlob hwBlob2 = new HwBlob(size * 32);
                        for (int i3 = 0; i3 < size; i3++) {
                            long j = (long) (i3 * 32);
                            byte[] bArr = hashChain.get(i3);
                            if (bArr == null || bArr.length != 32) {
                                throw new IllegalArgumentException("Array element is not of the expected length");
                            }
                            hwBlob2.putInt8Array(j, bArr);
                        }
                        hwBlob.putBlob(0, hwBlob2);
                        hwParcel2.writeBuffer(hwBlob);
                        hwParcel2.send();
                        return;
                    case 256462420:
                        hwParcel.enforceInterface("android.hidl.base@1.0::IBase");
                        setHALInstrumentation();
                        return;
                    case 256921159:
                        hwParcel.enforceInterface("android.hidl.base@1.0::IBase");
                        ping();
                        hwParcel2.writeStatus(0);
                        hwParcel2.send();
                        return;
                    case 257049926:
                        hwParcel.enforceInterface("android.hidl.base@1.0::IBase");
                        DebugInfo debugInfo = getDebugInfo();
                        hwParcel2.writeStatus(0);
                        debugInfo.writeToParcel(hwParcel2);
                        hwParcel2.send();
                        return;
                    case 257120595:
                        hwParcel.enforceInterface("android.hidl.base@1.0::IBase");
                        notifySyspropsChanged();
                        return;
                    default:
                        return;
                }
            } else {
                hwParcel.enforceInterface(IRadioConfig.kInterfaceName);
                setSimSlotsMapping(hwParcel.readInt32(), hwParcel.readInt32Vector());
            }
        }
    }
}
