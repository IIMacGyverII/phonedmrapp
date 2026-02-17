package com.google.gson.internal;

/* renamed from: com.google.gson.internal.$Gson$Preconditions  reason: invalid class name */
public final class C$Gson$Preconditions {
    private C$Gson$Preconditions() {
        throw new UnsupportedOperationException();
    }

    @Deprecated
    public static <T> T checkNotNull(T t) {
        t.getClass();
        return t;
    }

    public static void checkArgument(boolean z) {
        if (!z) {
            throw new IllegalArgumentException();
        }
    }
}
