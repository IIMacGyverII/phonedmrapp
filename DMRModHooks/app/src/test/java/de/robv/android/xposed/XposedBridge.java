package de.robv.android.xposed;

/**
 * Host-test stand-in for the Xposed API (the real one is compileOnly and not on the JUnit
 * classpath). Only {@link #log} is needed by the pure-Java classes under test.
 */
public final class XposedBridge {
    private XposedBridge() {}

    public static void log(String text) {
        System.out.println(text);
    }

    public static void log(Throwable t) {
        t.printStackTrace();
    }
}
