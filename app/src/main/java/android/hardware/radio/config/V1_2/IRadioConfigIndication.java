package android.hardware.radio.config.V1_2;

import android.hardware.radio.config.V1_0.SimSlotStatus;
import android.internal.hidl.base.V1_0.DebugInfo;
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

public interface IRadioConfigIndication extends android.hardware.radio.config.V1_1.IRadioConfigIndication {
    public static final String kInterfaceName = "android.hardware.radio.config@1.2::IRadioConfigIndication";

    IHwBinder asBinder();

    void debug(NativeHandle nativeHandle, ArrayList<String> arrayList) throws RemoteException;

    DebugInfo getDebugInfo() throws RemoteException;

    ArrayList<byte[]> getHashChain() throws RemoteException;

    ArrayList<String> interfaceChain() throws RemoteException;

    String interfaceDescriptor() throws RemoteException;

    boolean linkToDeath(IHwBinder.DeathRecipient deathRecipient, long j) throws RemoteException;

    void notifySyspropsChanged() throws RemoteException;

    void ping() throws RemoteException;

    void setHALInstrumentation() throws RemoteException;

    void simSlotsStatusChanged_1_2(int i, ArrayList<SimSlotStatus> arrayList) throws RemoteException;

    boolean unlinkToDeath(IHwBinder.DeathRecipient deathRecipient) throws RemoteException;

    static IRadioConfigIndication asInterface(IHwBinder iHwBinder) {
        if (iHwBinder == null) {
            return null;
        }
        IRadioConfigIndication queryLocalInterface = iHwBinder.queryLocalInterface(kInterfaceName);
        if (queryLocalInterface != null && (queryLocalInterface instanceof IRadioConfigIndication)) {
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

    static IRadioConfigIndication castFrom(IHwInterface iHwInterface) {
        if (iHwInterface == null) {
            return null;
        }
        return asInterface(iHwInterface.asBinder());
    }

    static IRadioConfigIndication getService(String str, boolean z) throws RemoteException {
        return asInterface(HwBinder.getService(kInterfaceName, str, z));
    }

    static IRadioConfigIndication getService(boolean z) throws RemoteException {
        return getService("default", z);
    }

    @Deprecated
    static IRadioConfigIndication getService(String str) throws RemoteException {
        return asInterface(HwBinder.getService(kInterfaceName, str));
    }

    @Deprecated
    static IRadioConfigIndication getService() throws RemoteException {
        return getService("default");
    }

    public static final class Proxy implements IRadioConfigIndication {
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
                return "[class or subclass of android.hardware.radio.config@1.2::IRadioConfigIndication]@Proxy";
            }
        }

        public final boolean equals(Object obj) {
            return HidlSupport.interfacesEqual(this, obj);
        }

        public final int hashCode() {
            return asBinder().hashCode();
        }

        public void simSlotsStatusChanged(int i, ArrayList<SimSlotStatus> arrayList) throws RemoteException {
            HwParcel hwParcel = new HwParcel();
            hwParcel.writeInterfaceToken(android.hardware.radio.config.V1_0.IRadioConfigIndication.kInterfaceName);
            hwParcel.writeInt32(i);
            SimSlotStatus.writeVectorToParcel(hwParcel, arrayList);
            HwParcel hwParcel2 = new HwParcel();
            try {
                this.mRemote.transact(1, hwParcel, hwParcel2, 1);
                hwParcel.releaseTemporaryStorage();
            } finally {
                hwParcel2.release();
            }
        }

        public void simSlotsStatusChanged_1_2(int i, ArrayList<SimSlotStatus> arrayList) throws RemoteException {
            HwParcel hwParcel = new HwParcel();
            hwParcel.writeInterfaceToken(IRadioConfigIndication.kInterfaceName);
            hwParcel.writeInt32(i);
            SimSlotStatus.writeVectorToParcel(hwParcel, arrayList);
            HwParcel hwParcel2 = new HwParcel();
            try {
                this.mRemote.transact(2, hwParcel, hwParcel2, 1);
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

    public static abstract class Stub extends HwBinder implements IRadioConfigIndication {
        public IHwBinder asBinder() {
            return this;
        }

        public void debug(NativeHandle nativeHandle, ArrayList<String> arrayList) {
        }

        public final String interfaceDescriptor() {
            return IRadioConfigIndication.kInterfaceName;
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
            return new ArrayList<>(Arrays.asList(new String[]{IRadioConfigIndication.kInterfaceName, android.hardware.radio.config.V1_1.IRadioConfigIndication.kInterfaceName, android.hardware.radio.config.V1_0.IRadioConfigIndication.kInterfaceName, "android.hidl.base@1.0::IBase"}));
        }

        public final ArrayList<byte[]> getHashChain() {
            return new ArrayList<>(Arrays.asList(new byte[][]{new byte[]{-80, -44, 82, -7, -94, -28, 95, Byte.MIN_VALUE, -67, -74, 114, -79, -28, -53, 100, -97, -1, 80, Const.Command.SET_ENCRYPT_FUNCTION_CMD, 59, -33, 32, Byte.MIN_VALUE, -103, -66, 65, 115, -113, 17, -51, Const.Command.SET_VOL_CMD, -83}, new byte[]{ByteCompanionObject.MAX_VALUE, -49, 22, ByteCompanionObject.MAX_VALUE, 89, 59, 16, -58, 123, 89, -85, 112, Const.Command.QUERY_SIGNAL_STRENGTH_CMD, 23, -127, -62, 106, 85, 117, -22, -74, 8, 3, -25, -53, -79, -63, 76, 113, 8, 90, 59}, new byte[]{Const.Command.SET_DIGITAL_INFO_CMD, -117, Const.Command.SET_VOL_CMD, -29, -56, -62, 118, -55, -16, -81, -83, Const.Command.RECEIVE_SMS_CMD, -61, 19, -54, 61, 107, -67, -98, 72, Const.Command.RECEIVE_SMS_CMD, -33, Const.Command.SET_POWER_SAVE_MODE_CMD, Const.Command.SET_SPK_EN_CMD, 114, 4, -58, 10, -39, -74, Const.Command.MODULE_PRINT_STATUS_INFO_CMD, -85}, new byte[]{-20, ByteCompanionObject.MAX_VALUE, -41, -98, -48, Const.Command.RECEIVE_SMS_CMD, -6, -123, -68, 73, -108, Const.Command.SET_LAUNCH_INFO_CMD, -83, -82, 62, -66, Const.Command.SET_ANALOG_INFO_CMD, -17, 5, Const.Command.QUERY_DIGITAL_INFO_CMD, -13, -51, 105, 87, 19, -109, Const.Command.QUERY_DIGITAL_INFO_CMD, -72, 59, 24, -54, 76}}));
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
            if (IRadioConfigIndication.kInterfaceName.equals(str)) {
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
                hwParcel.enforceInterface(android.hardware.radio.config.V1_0.IRadioConfigIndication.kInterfaceName);
                simSlotsStatusChanged(hwParcel.readInt32(), SimSlotStatus.readVectorFromParcel(hwParcel));
            } else if (i != 2) {
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
                hwParcel.enforceInterface(IRadioConfigIndication.kInterfaceName);
                simSlotsStatusChanged_1_2(hwParcel.readInt32(), SimSlotStatus.readVectorFromParcel(hwParcel));
            }
        }
    }
}
