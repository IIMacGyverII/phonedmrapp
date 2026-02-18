package android.os;

/**
 * Stub class for internal Android SystemProperties
 * Real implementation exists in android.os but is hidden from SDK
 */
public class SystemProperties {
    public static int getInt(String key, int def) {
        // Return default value since we don't have access to real system properties
        return def;
    }
    
    public static String get(String key, String def) {
        return def;
    }
    
    public static boolean getBoolean(String key, boolean def) {
        return def;
    }
}
