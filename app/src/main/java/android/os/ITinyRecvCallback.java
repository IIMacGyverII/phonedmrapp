package android.os;

/**
 * Stub interface for Prize ROM callback
 */
public interface ITinyRecvCallback {
    void onRecv(byte[] data, int length);
    
    /**
     * Stub class for binder implementation
     */
    abstract class Stub implements ITinyRecvCallback {
        public Stub() {
        }
    }
}
