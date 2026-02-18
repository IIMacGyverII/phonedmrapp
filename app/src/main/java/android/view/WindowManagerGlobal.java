package android.view;

import android.os.RemoteException;

/**
 * Stub class for internal WindowManagerGlobal
 */
public class WindowManagerGlobal {
    public static IWindowManager getWindowManagerService() {
        return new IWindowManager() {
            @Override
            public int getInitialDisplayDensity(int displayId) throws RemoteException {
                return 160; // Default DPI
            }
        };
    }
    
    public interface IWindowManager {
        int getInitialDisplayDensity(int displayId) throws RemoteException;
    }
}
