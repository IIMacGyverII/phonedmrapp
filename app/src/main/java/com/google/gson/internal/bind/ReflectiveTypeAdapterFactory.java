package com.google.gson.internal.bind;

import com.google.gson.FieldNamingStrategy;
import com.google.gson.Gson;
import com.google.gson.JsonIOException;
import com.google.gson.JsonParseException;
import com.google.gson.JsonSyntaxException;
import com.google.gson.ReflectionAccessFilter;
import com.google.gson.TypeAdapter;
import com.google.gson.TypeAdapterFactory;
import com.google.gson.annotations.JsonAdapter;
import com.google.gson.annotations.SerializedName;
import com.google.gson.internal.C$Gson$Types;
import com.google.gson.internal.ConstructorConstructor;
import com.google.gson.internal.Excluder;
import com.google.gson.internal.ObjectConstructor;
import com.google.gson.internal.Primitives;
import com.google.gson.internal.ReflectionAccessFilterHelper;
import com.google.gson.internal.reflect.ReflectionHelper;
import com.google.gson.reflect.TypeToken;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonToken;
import com.google.gson.stream.JsonWriter;
import java.io.IOException;
import java.lang.reflect.AccessibleObject;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Member;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public final class ReflectiveTypeAdapterFactory implements TypeAdapterFactory {
    private final ConstructorConstructor constructorConstructor;
    private final Excluder excluder;
    private final FieldNamingStrategy fieldNamingPolicy;
    private final JsonAdapterAnnotationTypeAdapterFactory jsonAdapterFactory;
    private final List<ReflectionAccessFilter> reflectionFilters;

    public ReflectiveTypeAdapterFactory(ConstructorConstructor constructorConstructor2, FieldNamingStrategy fieldNamingStrategy, Excluder excluder2, JsonAdapterAnnotationTypeAdapterFactory jsonAdapterAnnotationTypeAdapterFactory, List<ReflectionAccessFilter> list) {
        this.constructorConstructor = constructorConstructor2;
        this.fieldNamingPolicy = fieldNamingStrategy;
        this.excluder = excluder2;
        this.jsonAdapterFactory = jsonAdapterAnnotationTypeAdapterFactory;
        this.reflectionFilters = list;
    }

    private boolean includeField(Field field, boolean z) {
        return !this.excluder.excludeClass(field.getType(), z) && !this.excluder.excludeField(field, z);
    }

    private List<String> getFieldNames(Field field) {
        SerializedName serializedName = (SerializedName) field.getAnnotation(SerializedName.class);
        if (serializedName == null) {
            return Collections.singletonList(this.fieldNamingPolicy.translateName(field));
        }
        String value = serializedName.value();
        String[] alternate = serializedName.alternate();
        if (alternate.length == 0) {
            return Collections.singletonList(value);
        }
        ArrayList arrayList = new ArrayList(alternate.length + 1);
        arrayList.add(value);
        Collections.addAll(arrayList, alternate);
        return arrayList;
    }

    public <T> TypeAdapter<T> create(Gson gson, TypeToken<T> typeToken) {
        Class<? super T> rawType = typeToken.getRawType();
        if (!Object.class.isAssignableFrom(rawType)) {
            return null;
        }
        ReflectionAccessFilter.FilterResult filterResult = ReflectionAccessFilterHelper.getFilterResult(this.reflectionFilters, rawType);
        if (filterResult != ReflectionAccessFilter.FilterResult.BLOCK_ALL) {
            boolean z = filterResult == ReflectionAccessFilter.FilterResult.BLOCK_INACCESSIBLE;
            if (ReflectionHelper.isRecord(rawType)) {
                return new RecordAdapter(rawType, getBoundFields(gson, typeToken, rawType, z, true), z);
            }
            return new FieldReflectionAdapter(this.constructorConstructor.get(typeToken), getBoundFields(gson, typeToken, rawType, z, false));
        }
        throw new JsonIOException("ReflectionAccessFilter does not permit using reflection for " + rawType + ". Register a TypeAdapter for this type or adjust the access filter.");
    }

    /* access modifiers changed from: private */
    public static <M extends AccessibleObject & Member> void checkAccessible(Object obj, M m) {
        if (Modifier.isStatic(((Member) m).getModifiers())) {
            obj = null;
        }
        if (!ReflectionAccessFilterHelper.canAccess(m, obj)) {
            String accessibleObjectDescription = ReflectionHelper.getAccessibleObjectDescription(m, true);
            throw new JsonIOException(accessibleObjectDescription + " is not accessible and ReflectionAccessFilter does not permit making it accessible. Register a TypeAdapter for the declaring type, adjust the access filter or increase the visibility of the element and its declaring type.");
        }
    }

    private BoundField createBoundField(Gson gson, Field field, Method method, String str, TypeToken<?> typeToken, boolean z, boolean z2, boolean z3) {
        Gson gson2 = gson;
        TypeToken<?> typeToken2 = typeToken;
        final boolean isPrimitive = Primitives.isPrimitive(typeToken.getRawType());
        int modifiers = field.getModifiers();
        final boolean z4 = Modifier.isStatic(modifiers) && Modifier.isFinal(modifiers);
        JsonAdapter jsonAdapter = (JsonAdapter) field.getAnnotation(JsonAdapter.class);
        TypeAdapter<?> typeAdapter = null;
        if (jsonAdapter != null) {
            typeAdapter = this.jsonAdapterFactory.getTypeAdapter(this.constructorConstructor, gson2, typeToken2, jsonAdapter);
        }
        final boolean z5 = typeAdapter != null;
        final TypeAdapter<?> adapter = typeAdapter == null ? gson2.getAdapter(typeToken2) : typeAdapter;
        final boolean z6 = z3;
        final Method method2 = method;
        final Gson gson3 = gson;
        final TypeToken<?> typeToken3 = typeToken;
        return new BoundField(str, field, z, z2) {
            /* access modifiers changed from: package-private */
            public void write(JsonWriter jsonWriter, Object obj) throws IOException, IllegalAccessException {
                Object obj2;
                TypeAdapter typeAdapter;
                if (this.serialized) {
                    if (z6) {
                        Method method = method2;
                        if (method == null) {
                            ReflectiveTypeAdapterFactory.checkAccessible(obj, this.field);
                        } else {
                            ReflectiveTypeAdapterFactory.checkAccessible(obj, method);
                        }
                    }
                    Method method2 = method2;
                    if (method2 != null) {
                        try {
                            obj2 = method2.invoke(obj, new Object[0]);
                        } catch (InvocationTargetException e) {
                            String accessibleObjectDescription = ReflectionHelper.getAccessibleObjectDescription(method2, false);
                            throw new JsonIOException("Accessor " + accessibleObjectDescription + " threw exception", e.getCause());
                        }
                    } else {
                        obj2 = this.field.get(obj);
                    }
                    if (obj2 != obj) {
                        jsonWriter.name(this.name);
                        if (z5) {
                            typeAdapter = adapter;
                        } else {
                            typeAdapter = new TypeAdapterRuntimeTypeWrapper(gson3, adapter, typeToken3.getType());
                        }
                        typeAdapter.write(jsonWriter, obj2);
                    }
                }
            }

            /* access modifiers changed from: package-private */
            public void readIntoArray(JsonReader jsonReader, int i, Object[] objArr) throws IOException, JsonParseException {
                Object read = adapter.read(jsonReader);
                if (read != null || !isPrimitive) {
                    objArr[i] = read;
                    return;
                }
                throw new JsonParseException("null is not allowed as value for record component '" + this.fieldName + "' of primitive type; at path " + jsonReader.getPath());
            }

            /* access modifiers changed from: package-private */
            public void readIntoField(JsonReader jsonReader, Object obj) throws IOException, IllegalAccessException {
                Object read = adapter.read(jsonReader);
                if (read != null || !isPrimitive) {
                    if (z6) {
                        ReflectiveTypeAdapterFactory.checkAccessible(obj, this.field);
                    } else if (z4) {
                        String accessibleObjectDescription = ReflectionHelper.getAccessibleObjectDescription(this.field, false);
                        throw new JsonIOException("Cannot set value of 'static final' " + accessibleObjectDescription);
                    }
                    this.field.set(obj, read);
                }
            }
        };
    }

    private Map<String, BoundField> getBoundFields(Gson gson, TypeToken<?> typeToken, Class<?> cls, boolean z, boolean z2) {
        boolean z3;
        int i;
        int i2;
        Method method;
        boolean z4;
        ReflectiveTypeAdapterFactory reflectiveTypeAdapterFactory = this;
        Class<?> cls2 = cls;
        LinkedHashMap linkedHashMap = new LinkedHashMap();
        if (cls.isInterface()) {
            return linkedHashMap;
        }
        TypeToken<?> typeToken2 = typeToken;
        boolean z5 = z;
        Class<? super Object> cls3 = cls2;
        while (cls3 != Object.class) {
            Field[] declaredFields = cls3.getDeclaredFields();
            boolean z6 = true;
            boolean z7 = false;
            if (cls3 != cls2 && declaredFields.length > 0) {
                ReflectionAccessFilter.FilterResult filterResult = ReflectionAccessFilterHelper.getFilterResult(reflectiveTypeAdapterFactory.reflectionFilters, cls3);
                if (filterResult != ReflectionAccessFilter.FilterResult.BLOCK_ALL) {
                    z5 = filterResult == ReflectionAccessFilter.FilterResult.BLOCK_INACCESSIBLE;
                } else {
                    throw new JsonIOException("ReflectionAccessFilter does not permit using reflection for " + cls3 + " (supertype of " + cls2 + "). Register a TypeAdapter for this type or adjust the access filter.");
                }
            }
            boolean z8 = z5;
            int length = declaredFields.length;
            int i3 = 0;
            while (i3 < length) {
                Field field = declaredFields[i3];
                boolean includeField = reflectiveTypeAdapterFactory.includeField(field, z6);
                boolean includeField2 = reflectiveTypeAdapterFactory.includeField(field, z7);
                if (includeField || includeField2) {
                    BoundField boundField = null;
                    if (!z2) {
                        z4 = includeField2;
                        method = null;
                    } else if (Modifier.isStatic(field.getModifiers())) {
                        method = null;
                        z4 = z7;
                    } else {
                        Method accessor = ReflectionHelper.getAccessor(cls3, field);
                        if (!z8) {
                            ReflectionHelper.makeAccessible(accessor);
                        }
                        if (accessor.getAnnotation(SerializedName.class) == null || field.getAnnotation(SerializedName.class) != null) {
                            z4 = includeField2;
                            method = accessor;
                        } else {
                            throw new JsonIOException("@SerializedName on " + ReflectionHelper.getAccessibleObjectDescription(accessor, z7) + " is not supported");
                        }
                    }
                    if (!z8 && method == null) {
                        ReflectionHelper.makeAccessible(field);
                    }
                    Type resolve = C$Gson$Types.resolve(typeToken2.getType(), cls3, field.getGenericType());
                    List<String> fieldNames = reflectiveTypeAdapterFactory.getFieldNames(field);
                    int size = fieldNames.size();
                    int i4 = z7;
                    while (i4 < size) {
                        String str = fieldNames.get(i4);
                        boolean z9 = i4 != 0 ? z7 : includeField;
                        int i5 = i4;
                        BoundField boundField2 = boundField;
                        int i6 = size;
                        List<String> list = fieldNames;
                        Field field2 = field;
                        int i7 = i3;
                        int i8 = length;
                        boolean z10 = z7;
                        boundField = boundField2 == null ? (BoundField) linkedHashMap.put(str, createBoundField(gson, field, method, str, TypeToken.get(resolve), z9, z4, z8)) : boundField2;
                        i4 = i5 + 1;
                        includeField = z9;
                        i3 = i7;
                        size = i6;
                        fieldNames = list;
                        field = field2;
                        length = i8;
                        z7 = z10;
                    }
                    BoundField boundField3 = boundField;
                    Field field3 = field;
                    i2 = i3;
                    i = length;
                    z3 = z7;
                    if (boundField3 != null) {
                        throw new IllegalArgumentException("Class " + cls.getName() + " declares multiple JSON fields named '" + boundField3.name + "'; conflict is caused by fields " + ReflectionHelper.fieldToString(boundField3.field) + " and " + ReflectionHelper.fieldToString(field3));
                    }
                } else {
                    i2 = i3;
                    i = length;
                    z3 = z7;
                }
                i3 = i2 + 1;
                z6 = true;
                reflectiveTypeAdapterFactory = this;
                length = i;
                z7 = z3;
            }
            typeToken2 = TypeToken.get(C$Gson$Types.resolve(typeToken2.getType(), cls3, cls3.getGenericSuperclass()));
            cls3 = typeToken2.getRawType();
            reflectiveTypeAdapterFactory = this;
            z5 = z8;
        }
        return linkedHashMap;
    }

    static abstract class BoundField {
        final boolean deserialized;
        final Field field;
        final String fieldName;
        final String name;
        final boolean serialized;

        /* access modifiers changed from: package-private */
        public abstract void readIntoArray(JsonReader jsonReader, int i, Object[] objArr) throws IOException, JsonParseException;

        /* access modifiers changed from: package-private */
        public abstract void readIntoField(JsonReader jsonReader, Object obj) throws IOException, IllegalAccessException;

        /* access modifiers changed from: package-private */
        public abstract void write(JsonWriter jsonWriter, Object obj) throws IOException, IllegalAccessException;

        protected BoundField(String str, Field field2, boolean z, boolean z2) {
            this.name = str;
            this.field = field2;
            this.fieldName = field2.getName();
            this.serialized = z;
            this.deserialized = z2;
        }
    }

    public static abstract class Adapter<T, A> extends TypeAdapter<T> {
        final Map<String, BoundField> boundFields;

        /* access modifiers changed from: package-private */
        public abstract A createAccumulator();

        /* access modifiers changed from: package-private */
        public abstract T finalize(A a);

        /* access modifiers changed from: package-private */
        public abstract void readField(A a, JsonReader jsonReader, BoundField boundField) throws IllegalAccessException, IOException;

        Adapter(Map<String, BoundField> map) {
            this.boundFields = map;
        }

        public void write(JsonWriter jsonWriter, T t) throws IOException {
            if (t == null) {
                jsonWriter.nullValue();
                return;
            }
            jsonWriter.beginObject();
            try {
                for (BoundField write : this.boundFields.values()) {
                    write.write(jsonWriter, t);
                }
                jsonWriter.endObject();
            } catch (IllegalAccessException e) {
                throw ReflectionHelper.createExceptionForUnexpectedIllegalAccess(e);
            }
        }

        public T read(JsonReader jsonReader) throws IOException {
            if (jsonReader.peek() == JsonToken.NULL) {
                jsonReader.nextNull();
                return null;
            }
            Object createAccumulator = createAccumulator();
            try {
                jsonReader.beginObject();
                while (jsonReader.hasNext()) {
                    BoundField boundField = this.boundFields.get(jsonReader.nextName());
                    if (boundField != null) {
                        if (boundField.deserialized) {
                            readField(createAccumulator, jsonReader, boundField);
                        }
                    }
                    jsonReader.skipValue();
                }
                jsonReader.endObject();
                return finalize(createAccumulator);
            } catch (IllegalStateException e) {
                throw new JsonSyntaxException((Throwable) e);
            } catch (IllegalAccessException e2) {
                throw ReflectionHelper.createExceptionForUnexpectedIllegalAccess(e2);
            }
        }
    }

    private static final class FieldReflectionAdapter<T> extends Adapter<T, T> {
        private final ObjectConstructor<T> constructor;

        /* access modifiers changed from: package-private */
        public T finalize(T t) {
            return t;
        }

        FieldReflectionAdapter(ObjectConstructor<T> objectConstructor, Map<String, BoundField> map) {
            super(map);
            this.constructor = objectConstructor;
        }

        /* access modifiers changed from: package-private */
        public T createAccumulator() {
            return this.constructor.construct();
        }

        /* access modifiers changed from: package-private */
        public void readField(T t, JsonReader jsonReader, BoundField boundField) throws IllegalAccessException, IOException {
            boundField.readIntoField(jsonReader, t);
        }
    }

    private static final class RecordAdapter<T> extends Adapter<T, Object[]> {
        static final Map<Class<?>, Object> PRIMITIVE_DEFAULTS = primitiveDefaults();
        private final Map<String, Integer> componentIndices = new HashMap();
        private final Constructor<T> constructor;
        private final Object[] constructorArgsDefaults;

        RecordAdapter(Class<T> cls, Map<String, BoundField> map, boolean z) {
            super(map);
            Constructor<T> canonicalRecordConstructor = ReflectionHelper.getCanonicalRecordConstructor(cls);
            this.constructor = canonicalRecordConstructor;
            if (z) {
                ReflectiveTypeAdapterFactory.checkAccessible((Object) null, canonicalRecordConstructor);
            } else {
                ReflectionHelper.makeAccessible(canonicalRecordConstructor);
            }
            String[] recordComponentNames = ReflectionHelper.getRecordComponentNames(cls);
            for (int i = 0; i < recordComponentNames.length; i++) {
                this.componentIndices.put(recordComponentNames[i], Integer.valueOf(i));
            }
            Class[] parameterTypes = this.constructor.getParameterTypes();
            this.constructorArgsDefaults = new Object[parameterTypes.length];
            for (int i2 = 0; i2 < parameterTypes.length; i2++) {
                this.constructorArgsDefaults[i2] = PRIMITIVE_DEFAULTS.get(parameterTypes[i2]);
            }
        }

        private static Map<Class<?>, Object> primitiveDefaults() {
            HashMap hashMap = new HashMap();
            hashMap.put(Byte.TYPE, (byte) 0);
            hashMap.put(Short.TYPE, (short) 0);
            hashMap.put(Integer.TYPE, 0);
            hashMap.put(Long.TYPE, 0L);
            hashMap.put(Float.TYPE, Float.valueOf(0.0f));
            hashMap.put(Double.TYPE, Double.valueOf(0.0d));
            hashMap.put(Character.TYPE, 0);
            hashMap.put(Boolean.TYPE, Boolean.FALSE);
            return hashMap;
        }

        /* access modifiers changed from: package-private */
        public Object[] createAccumulator() {
            return (Object[]) this.constructorArgsDefaults.clone();
        }

        /* access modifiers changed from: package-private */
        public void readField(Object[] objArr, JsonReader jsonReader, BoundField boundField) throws IOException {
            Integer num = this.componentIndices.get(boundField.fieldName);
            if (num != null) {
                boundField.readIntoArray(jsonReader, num.intValue(), objArr);
                return;
            }
            throw new IllegalStateException("Could not find the index in the constructor '" + ReflectionHelper.constructorToString(this.constructor) + "' for field with name '" + boundField.fieldName + "', unable to determine which argument in the constructor the field corresponds to. This is unexpected behavior, as we expect the RecordComponents to have the same names as the fields in the Java class, and that the order of the RecordComponents is the same as the order of the canonical constructor parameters.");
        }

        /* access modifiers changed from: package-private */
        public T finalize(Object[] objArr) {
            try {
                return this.constructor.newInstance(objArr);
            } catch (IllegalAccessException e) {
                throw ReflectionHelper.createExceptionForUnexpectedIllegalAccess(e);
            } catch (IllegalArgumentException | InstantiationException e2) {
                throw new RuntimeException("Failed to invoke constructor '" + ReflectionHelper.constructorToString(this.constructor) + "' with args " + Arrays.toString(objArr), e2);
            } catch (InvocationTargetException e3) {
                throw new RuntimeException("Failed to invoke constructor '" + ReflectionHelper.constructorToString(this.constructor) + "' with args " + Arrays.toString(objArr), e3.getCause());
            }
        }
    }
}
