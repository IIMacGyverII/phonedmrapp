package android.os;

/**
 * Stub class for Prize ROM custom service
 * This is a custom class from the Prize ROM implementation
 */
public class PrizeTinyService {
    public PrizeTinyService() {
    }
    
    public void registerCallback(ITinyRecvCallback callback) {
        // Stub implementation
    }
    
    public void registerRecvCallback(ITinyRecvCallback callback) {
        // Stub implementation
    }
    
    public void unregisterCallback(ITinyRecvCallback callback) {
        // Stub implementation
    }
    
    public int sendData(byte[] data, int length) {
        // Stub implementation
        return 0;
    }
    
    public void openRecvPcm() {
        // Stub implementation
    }
    
    public void closeRecvPcm() {
        // Stub implementation
    }
    
    public int writeFrame(byte[] data, int length) {
        // Stub implementation
        return length;
    }
    
    public boolean openWritePcm() {
        // Stub implementation
        return true;
    }
    
    public void closeWritePcm() {
        // Stub implementation
    }
    
    public int getFrameSize() {
        // Stub implementation
        return 1024;
    }
}
