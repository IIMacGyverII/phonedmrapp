package com.google.gson.internal.reflect;

import com.google.gson.JsonIOException;
import java.lang.reflect.AccessibleObject;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

public class ReflectionHelper {
    private static final RecordHelper RECORD_HELPER;

    static {
        RecordHelper recordHelper;
        try {
            recordHelper = new RecordSupportedHelper();
        } catch (NoSuchMethodException unused) {
            recordHelper = new RecordNotSupportedHelper();
        }
        RECORD_HELPER = recordHelper;
    }

    private ReflectionHelper() {
    }

    public static void makeAccessible(AccessibleObject accessibleObject) throws JsonIOException {
        try {
            accessibleObject.setAccessible(true);
        } catch (Exception e) {
            String accessibleObjectDescription = getAccessibleObjectDescription(accessibleObject, false);
            throw new JsonIOException("Failed making " + accessibleObjectDescription + " accessible; either increase its visibility or write a custom TypeAdapter for its declaring type.", e);
        }
    }

    public static String getAccessibleObjectDescription(AccessibleObject accessibleObject, boolean z) {
        String str;
        if (accessibleObject instanceof Field) {
            str = "field '" + fieldToString((Field) accessibleObject) + "'";
        } else if (accessibleObject instanceof Method) {
            Method method = (Method) accessibleObject;
            StringBuilder sb = new StringBuilder(method.getName());
            appendExecutableParameters(method, sb);
            str = "method '" + method.getDeclaringClass().getName() + "#" + sb.toString() + "'";
        } else if (accessibleObject instanceof Constructor) {
            str = "constructor '" + constructorToString((Constructor) accessibleObject) + "'";
        } else {
            str = "<unknown AccessibleObject> " + accessibleObject.toString();
        }
        if (!z || !Character.isLowerCase(str.charAt(0))) {
            return str;
        }
        return Character.toUpperCase(str.charAt(0)) + str.substring(1);
    }

    public static String fieldToString(Field field) {
        return field.getDeclaringClass().getName() + "#" + field.getName();
    }

    public static String constructorToString(Constructor<?> constructor) {
        StringBuilder sb = new StringBuilder(constructor.getDeclaringClass().getName());
        appendExecutableParameters(constructor, sb);
        return sb.toString();
    }

    private static void appendExecutableParameters(AccessibleObject accessibleObject, StringBuilder sb) {
        Class[] clsArr;
        sb.append('(');
        if (accessibleObject instanceof Method) {
            clsArr = ((Method) accessibleObject).getParameterTypes();
        } else {
            clsArr = ((Constructor) accessibleObject).getParameterTypes();
        }
        for (int i = 0; i < clsArr.length; i++) {
            if (i > 0) {
                sb.append(", ");
            }
            sb.append(clsArr[i].getSimpleName());
        }
        sb.append(')');
    }

    public static String tryMakeAccessible(Constructor<?> constructor) {
        try {
            constructor.setAccessible(true);
            return null;
        } catch (Exception e) {
            return "Failed making constructor '" + constructorToString(constructor) + "' accessible; either increase its visibility or write a custom InstanceCreator or TypeAdapter for its declaring type: " + e.getMessage();
        }
    }

    public static boolean isRecord(Class<?> cls) {
        return RECORD_HELPER.isRecord(cls);
    }

    public static String[] getRecordComponentNames(Class<?> cls) {
        return RECORD_HELPER.getRecordComponentNames(cls);
    }

    public static Method getAccessor(Class<?> cls, Field field) {
        return RECORD_HELPER.getAccessor(cls, field);
    }

    public static <T> Constructor<T> getCanonicalRecordConstructor(Class<T> cls) {
        return RECORD_HELPER.getCanonicalRecordConstructor(cls);
    }

    public static RuntimeException createExceptionForUnexpectedIllegalAccess(IllegalAccessException illegalAccessException) {
        throw new RuntimeException("Unexpected IllegalAccessException occurred (Gson 2.10.1). Certain ReflectionAccessFilter features require Java >= 9 to work correctly. If you are not using ReflectionAccessFilter, report this to the Gson maintainers.", illegalAccessException);
    }

    /* access modifiers changed from: private */
    public static RuntimeException createExceptionForRecordReflectionException(ReflectiveOperationException reflectiveOperationException) {
        throw new RuntimeException("Unexpected ReflectiveOperationException occurred (Gson 2.10.1). To support Java records, reflection is utilized to read out information about records. All these invocations happens after it is established that records exist in the JVM. This exception is unexpected behavior.", reflectiveOperationException);
    }

    private static abstract class RecordHelper {
        public abstract Method getAccessor(Class<?> cls, Field field);

        /* access modifiers changed from: package-private */
        public abstract <T> Constructor<T> getCanonicalRecordConstructor(Class<T> cls);

        /* access modifiers changed from: package-private */
        public abstract String[] getRecordComponentNames(Class<?> cls);

        /* access modifiers changed from: package-private */
        public abstract boolean isRecord(Class<?> cls);

        private RecordHelper() {
        }
    }

    private static class RecordSupportedHelper extends RecordHelper {
        private final Method getName;
        private final Method getRecordComponents;
        private final Method getType;
        private final Method isRecord;

        private RecordSupportedHelper() throws NoSuchMethodException {
            super();
            this.isRecord = Class.class.getMethod("isRecord", new Class[0]);
            Method method = Class.class.getMethod("getRecordComponents", new Class[0]);
            this.getRecordComponents = method;
            Class<?> componentType = method.getReturnType().getComponentType();
            this.getName = componentType.getMethod("getName", new Class[0]);
            this.getType = componentType.getMethod("getType", new Class[0]);
        }

        /* access modifiers changed from: package-private */
        public boolean isRecord(Class<?> cls) {
            try {
                return ((Boolean) this.isRecord.invoke(cls, new Object[0])).booleanValue();
            } catch (ReflectiveOperationException e) {
                throw ReflectionHelper.createExceptionForRecordReflectionException(e);
            }
        }

        /* access modifiers changed from: package-private */
        public String[] getRecordComponentNames(Class<?> cls) {
            try {
                Object[] objArr = (Object[]) this.getRecordComponents.invoke(cls, new Object[0]);
                String[] strArr = new String[objArr.length];
                for (int i = 0; i < objArr.length; i++) {
                    strArr[i] = (String) this.getName.invoke(objArr[i], new Object[0]);
                }
                return strArr;
            } catch (ReflectiveOperationException e) {
                throw ReflectionHelper.createExceptionForRecordReflectionException(e);
            }
        }

        public <T> Constructor<T> getCanonicalRecordConstructor(Class<T> cls) {
            try {
                Object[] objArr = (Object[]) this.getRecordComponents.invoke(cls, new Object[0]);
                Class[] clsArr = new Class[objArr.length];
                for (int i = 0; i < objArr.length; i++) {
                    clsArr[i] = (Class) this.getType.invoke(objArr[i], new Object[0]);
                }
                return cls.getDeclaredConstructor(clsArr);
            } catch (ReflectiveOperationException e) {
                throw ReflectionHelper.createExceptionForRecordReflectionException(e);
            }
        }

        public Method getAccessor(Class<?> cls, Field field) {
            try {
                return cls.getMethod(field.getName(), new Class[0]);
            } catch (ReflectiveOperationException e) {
                throw ReflectionHelper.createExceptionForRecordReflectionException(e);
            }
        }
    }

    private static class RecordNotSupportedHelper extends RecordHelper {
        /* access modifiers changed from: package-private */
        public boolean isRecord(Class<?> cls) {
            return false;
        }

        private RecordNotSupportedHelper() {
            super();
        }

        /* access modifiers changed from: package-private */
        public String[] getRecordComponentNames(Class<?> cls) {
            throw new UnsupportedOperationException("Records are not supported on this JVM, this method should not be called");
        }

        /* access modifiers changed from: package-private */
        public <T> Constructor<T> getCanonicalRecordConstructor(Class<T> cls) {
            throw new UnsupportedOperationException("Records are not supported on this JVM, this method should not be called");
        }

        public Method getAccessor(Class<?> cls, Field field) {
            throw new UnsupportedOperationException("Records are not supported on this JVM, this method should not be called");
        }
    }
}
