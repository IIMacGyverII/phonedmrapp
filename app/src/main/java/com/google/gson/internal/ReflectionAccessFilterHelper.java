package com.google.gson.internal;

import com.google.gson.ReflectionAccessFilter;
import java.lang.reflect.AccessibleObject;
import java.util.List;

public class ReflectionAccessFilterHelper {
    private ReflectionAccessFilterHelper() {
    }

    public static boolean isJavaType(Class<?> cls) {
        return isJavaType(cls.getName());
    }

    private static boolean isJavaType(String str) {
        return str.startsWith("java.") || str.startsWith("javax.");
    }

    public static boolean isAndroidType(Class<?> cls) {
        return isAndroidType(cls.getName());
    }

    private static boolean isAndroidType(String str) {
        return str.startsWith("android.") || str.startsWith("androidx.") || isJavaType(str);
    }

    public static boolean isAnyPlatformType(Class<?> cls) {
        String name = cls.getName();
        return isAndroidType(name) || name.startsWith("kotlin.") || name.startsWith("kotlinx.") || name.startsWith("scala.");
    }

    public static ReflectionAccessFilter.FilterResult getFilterResult(List<ReflectionAccessFilter> list, Class<?> cls) {
        for (ReflectionAccessFilter check : list) {
            ReflectionAccessFilter.FilterResult check2 = check.check(cls);
            if (check2 != ReflectionAccessFilter.FilterResult.INDECISIVE) {
                return check2;
            }
        }
        return ReflectionAccessFilter.FilterResult.ALLOW;
    }

    public static boolean canAccess(AccessibleObject accessibleObject, Object obj) {
        return AccessChecker.INSTANCE.canAccess(accessibleObject, obj);
    }

    private static abstract class AccessChecker {
        public static final AccessChecker INSTANCE;

        public abstract boolean canAccess(AccessibleObject accessibleObject, Object obj);

        private AccessChecker() {
        }

        /* JADX WARNING: Removed duplicated region for block: B:8:0x001f  */
        static {
            /*
                boolean r0 = com.google.gson.internal.JavaVersion.isJava9OrLater()
                if (r0 == 0) goto L_0x001c
                java.lang.Class<java.lang.reflect.AccessibleObject> r0 = java.lang.reflect.AccessibleObject.class
                java.lang.String r1 = "canAccess"
                r2 = 1
                java.lang.Class[] r2 = new java.lang.Class[r2]     // Catch:{ NoSuchMethodException -> 0x001c }
                r3 = 0
                java.lang.Class<java.lang.Object> r4 = java.lang.Object.class
                r2[r3] = r4     // Catch:{ NoSuchMethodException -> 0x001c }
                java.lang.reflect.Method r0 = r0.getDeclaredMethod(r1, r2)     // Catch:{ NoSuchMethodException -> 0x001c }
                com.google.gson.internal.ReflectionAccessFilterHelper$AccessChecker$1 r1 = new com.google.gson.internal.ReflectionAccessFilterHelper$AccessChecker$1     // Catch:{ NoSuchMethodException -> 0x001c }
                r1.<init>(r0)     // Catch:{ NoSuchMethodException -> 0x001c }
                goto L_0x001d
            L_0x001c:
                r1 = 0
            L_0x001d:
                if (r1 != 0) goto L_0x0024
                com.google.gson.internal.ReflectionAccessFilterHelper$AccessChecker$2 r1 = new com.google.gson.internal.ReflectionAccessFilterHelper$AccessChecker$2
                r1.<init>()
            L_0x0024:
                INSTANCE = r1
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.google.gson.internal.ReflectionAccessFilterHelper.AccessChecker.<clinit>():void");
        }
    }
}
