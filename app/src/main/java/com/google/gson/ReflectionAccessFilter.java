package com.google.gson;

import com.google.gson.internal.ReflectionAccessFilterHelper;

public interface ReflectionAccessFilter {
    public static final ReflectionAccessFilter BLOCK_ALL_ANDROID = new ReflectionAccessFilter() {
        public FilterResult check(Class<?> cls) {
            if (ReflectionAccessFilterHelper.isAndroidType(cls)) {
                return FilterResult.BLOCK_ALL;
            }
            return FilterResult.INDECISIVE;
        }
    };
    public static final ReflectionAccessFilter BLOCK_ALL_JAVA = new ReflectionAccessFilter() {
        public FilterResult check(Class<?> cls) {
            if (ReflectionAccessFilterHelper.isJavaType(cls)) {
                return FilterResult.BLOCK_ALL;
            }
            return FilterResult.INDECISIVE;
        }
    };
    public static final ReflectionAccessFilter BLOCK_ALL_PLATFORM = new ReflectionAccessFilter() {
        public FilterResult check(Class<?> cls) {
            if (ReflectionAccessFilterHelper.isAnyPlatformType(cls)) {
                return FilterResult.BLOCK_ALL;
            }
            return FilterResult.INDECISIVE;
        }
    };
    public static final ReflectionAccessFilter BLOCK_INACCESSIBLE_JAVA = new ReflectionAccessFilter() {
        public FilterResult check(Class<?> cls) {
            if (ReflectionAccessFilterHelper.isJavaType(cls)) {
                return FilterResult.BLOCK_INACCESSIBLE;
            }
            return FilterResult.INDECISIVE;
        }
    };

    public enum FilterResult {
        ALLOW,
        INDECISIVE,
        BLOCK_INACCESSIBLE,
        BLOCK_ALL
    }

    FilterResult check(Class<?> cls);
}
