package android.os;

/**
 * Stub of the vendor AIDL callback used by {@code android.os.PrizeTinyService.registerRecvCallback}.
 * Signature taken from framework.jar (classes2.dex) of the Armor 26 Ultra: {@code onRecv([BI)V}.
 * Compile-only; the framework's own Stub (with the real onTransact) is used at runtime.
 */
public interface ITinyRecvCallback extends IInterface {
    void onRecv(byte[] data, int len) throws RemoteException;

    abstract class Stub extends Binder implements ITinyRecvCallback {
        public Stub() { }
        @Override public IBinder asBinder() { return this; }
    }
}
