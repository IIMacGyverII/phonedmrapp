package com.google.gson;

import com.google.gson.internal.C$Gson$Preconditions;
import com.google.gson.internal.Excluder;
import com.google.gson.internal.bind.TreeTypeAdapter;
import com.google.gson.internal.bind.TypeAdapters;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public final class GsonBuilder {
    private boolean complexMapKeySerialization;
    private String datePattern;
    private int dateStyle;
    private boolean escapeHtmlChars;
    private Excluder excluder;
    private final List<TypeAdapterFactory> factories;
    private FieldNamingStrategy fieldNamingPolicy;
    private boolean generateNonExecutableJson;
    private final List<TypeAdapterFactory> hierarchyFactories;
    private final Map<Type, InstanceCreator<?>> instanceCreators;
    private boolean lenient;
    private LongSerializationPolicy longSerializationPolicy;
    private ToNumberStrategy numberToNumberStrategy;
    private ToNumberStrategy objectToNumberStrategy;
    private boolean prettyPrinting;
    private final LinkedList<ReflectionAccessFilter> reflectionFilters;
    private boolean serializeNulls;
    private boolean serializeSpecialFloatingPointValues;
    private int timeStyle;
    private boolean useJdkUnsafe;

    public GsonBuilder() {
        this.excluder = Excluder.DEFAULT;
        this.longSerializationPolicy = LongSerializationPolicy.DEFAULT;
        this.fieldNamingPolicy = FieldNamingPolicy.IDENTITY;
        this.instanceCreators = new HashMap();
        this.factories = new ArrayList();
        this.hierarchyFactories = new ArrayList();
        this.serializeNulls = false;
        this.datePattern = Gson.DEFAULT_DATE_PATTERN;
        this.dateStyle = 2;
        this.timeStyle = 2;
        this.complexMapKeySerialization = false;
        this.serializeSpecialFloatingPointValues = false;
        this.escapeHtmlChars = true;
        this.prettyPrinting = false;
        this.generateNonExecutableJson = false;
        this.lenient = false;
        this.useJdkUnsafe = true;
        this.objectToNumberStrategy = Gson.DEFAULT_OBJECT_TO_NUMBER_STRATEGY;
        this.numberToNumberStrategy = Gson.DEFAULT_NUMBER_TO_NUMBER_STRATEGY;
        this.reflectionFilters = new LinkedList<>();
    }

    GsonBuilder(Gson gson) {
        this.excluder = Excluder.DEFAULT;
        this.longSerializationPolicy = LongSerializationPolicy.DEFAULT;
        this.fieldNamingPolicy = FieldNamingPolicy.IDENTITY;
        HashMap hashMap = new HashMap();
        this.instanceCreators = hashMap;
        ArrayList arrayList = new ArrayList();
        this.factories = arrayList;
        ArrayList arrayList2 = new ArrayList();
        this.hierarchyFactories = arrayList2;
        this.serializeNulls = false;
        this.datePattern = Gson.DEFAULT_DATE_PATTERN;
        this.dateStyle = 2;
        this.timeStyle = 2;
        this.complexMapKeySerialization = false;
        this.serializeSpecialFloatingPointValues = false;
        this.escapeHtmlChars = true;
        this.prettyPrinting = false;
        this.generateNonExecutableJson = false;
        this.lenient = false;
        this.useJdkUnsafe = true;
        this.objectToNumberStrategy = Gson.DEFAULT_OBJECT_TO_NUMBER_STRATEGY;
        this.numberToNumberStrategy = Gson.DEFAULT_NUMBER_TO_NUMBER_STRATEGY;
        LinkedList<ReflectionAccessFilter> linkedList = new LinkedList<>();
        this.reflectionFilters = linkedList;
        this.excluder = gson.excluder;
        this.fieldNamingPolicy = gson.fieldNamingStrategy;
        hashMap.putAll(gson.instanceCreators);
        this.serializeNulls = gson.serializeNulls;
        this.complexMapKeySerialization = gson.complexMapKeySerialization;
        this.generateNonExecutableJson = gson.generateNonExecutableJson;
        this.escapeHtmlChars = gson.htmlSafe;
        this.prettyPrinting = gson.prettyPrinting;
        this.lenient = gson.lenient;
        this.serializeSpecialFloatingPointValues = gson.serializeSpecialFloatingPointValues;
        this.longSerializationPolicy = gson.longSerializationPolicy;
        this.datePattern = gson.datePattern;
        this.dateStyle = gson.dateStyle;
        this.timeStyle = gson.timeStyle;
        arrayList.addAll(gson.builderFactories);
        arrayList2.addAll(gson.builderHierarchyFactories);
        this.useJdkUnsafe = gson.useJdkUnsafe;
        this.objectToNumberStrategy = gson.objectToNumberStrategy;
        this.numberToNumberStrategy = gson.numberToNumberStrategy;
        linkedList.addAll(gson.reflectionFilters);
    }

    public GsonBuilder setVersion(double d) {
        if (Double.isNaN(d) || d < 0.0d) {
            throw new IllegalArgumentException("Invalid version: " + d);
        }
        this.excluder = this.excluder.withVersion(d);
        return this;
    }

    public GsonBuilder excludeFieldsWithModifiers(int... iArr) {
        Objects.requireNonNull(iArr);
        this.excluder = this.excluder.withModifiers(iArr);
        return this;
    }

    public GsonBuilder generateNonExecutableJson() {
        this.generateNonExecutableJson = true;
        return this;
    }

    public GsonBuilder excludeFieldsWithoutExposeAnnotation() {
        this.excluder = this.excluder.excludeFieldsWithoutExposeAnnotation();
        return this;
    }

    public GsonBuilder serializeNulls() {
        this.serializeNulls = true;
        return this;
    }

    public GsonBuilder enableComplexMapKeySerialization() {
        this.complexMapKeySerialization = true;
        return this;
    }

    public GsonBuilder disableInnerClassSerialization() {
        this.excluder = this.excluder.disableInnerClassSerialization();
        return this;
    }

    public GsonBuilder setLongSerializationPolicy(LongSerializationPolicy longSerializationPolicy2) {
        Objects.requireNonNull(longSerializationPolicy2);
        this.longSerializationPolicy = longSerializationPolicy2;
        return this;
    }

    public GsonBuilder setFieldNamingPolicy(FieldNamingPolicy fieldNamingPolicy2) {
        return setFieldNamingStrategy(fieldNamingPolicy2);
    }

    public GsonBuilder setFieldNamingStrategy(FieldNamingStrategy fieldNamingStrategy) {
        Objects.requireNonNull(fieldNamingStrategy);
        this.fieldNamingPolicy = fieldNamingStrategy;
        return this;
    }

    public GsonBuilder setObjectToNumberStrategy(ToNumberStrategy toNumberStrategy) {
        Objects.requireNonNull(toNumberStrategy);
        this.objectToNumberStrategy = toNumberStrategy;
        return this;
    }

    public GsonBuilder setNumberToNumberStrategy(ToNumberStrategy toNumberStrategy) {
        Objects.requireNonNull(toNumberStrategy);
        this.numberToNumberStrategy = toNumberStrategy;
        return this;
    }

    public GsonBuilder setExclusionStrategies(ExclusionStrategy... exclusionStrategyArr) {
        Objects.requireNonNull(exclusionStrategyArr);
        for (ExclusionStrategy withExclusionStrategy : exclusionStrategyArr) {
            this.excluder = this.excluder.withExclusionStrategy(withExclusionStrategy, true, true);
        }
        return this;
    }

    public GsonBuilder addSerializationExclusionStrategy(ExclusionStrategy exclusionStrategy) {
        Objects.requireNonNull(exclusionStrategy);
        this.excluder = this.excluder.withExclusionStrategy(exclusionStrategy, true, false);
        return this;
    }

    public GsonBuilder addDeserializationExclusionStrategy(ExclusionStrategy exclusionStrategy) {
        Objects.requireNonNull(exclusionStrategy);
        this.excluder = this.excluder.withExclusionStrategy(exclusionStrategy, false, true);
        return this;
    }

    public GsonBuilder setPrettyPrinting() {
        this.prettyPrinting = true;
        return this;
    }

    public GsonBuilder setLenient() {
        this.lenient = true;
        return this;
    }

    public GsonBuilder disableHtmlEscaping() {
        this.escapeHtmlChars = false;
        return this;
    }

    public GsonBuilder setDateFormat(String str) {
        this.datePattern = str;
        return this;
    }

    public GsonBuilder setDateFormat(int i) {
        this.dateStyle = i;
        this.datePattern = null;
        return this;
    }

    public GsonBuilder setDateFormat(int i, int i2) {
        this.dateStyle = i;
        this.timeStyle = i2;
        this.datePattern = null;
        return this;
    }

    public GsonBuilder registerTypeAdapter(Type type, Object obj) {
        Objects.requireNonNull(type);
        boolean z = obj instanceof JsonSerializer;
        C$Gson$Preconditions.checkArgument(z || (obj instanceof JsonDeserializer) || (obj instanceof InstanceCreator) || (obj instanceof TypeAdapter));
        if (obj instanceof InstanceCreator) {
            this.instanceCreators.put(type, (InstanceCreator) obj);
        }
        if (z || (obj instanceof JsonDeserializer)) {
            this.factories.add(TreeTypeAdapter.newFactoryWithMatchRawType(TypeToken.get(type), obj));
        }
        if (obj instanceof TypeAdapter) {
            this.factories.add(TypeAdapters.newFactory(TypeToken.get(type), (TypeAdapter) obj));
        }
        return this;
    }

    public GsonBuilder registerTypeAdapterFactory(TypeAdapterFactory typeAdapterFactory) {
        Objects.requireNonNull(typeAdapterFactory);
        this.factories.add(typeAdapterFactory);
        return this;
    }

    public GsonBuilder registerTypeHierarchyAdapter(Class<?> cls, Object obj) {
        Objects.requireNonNull(cls);
        boolean z = obj instanceof JsonSerializer;
        C$Gson$Preconditions.checkArgument(z || (obj instanceof JsonDeserializer) || (obj instanceof TypeAdapter));
        if ((obj instanceof JsonDeserializer) || z) {
            this.hierarchyFactories.add(TreeTypeAdapter.newTypeHierarchyFactory(cls, obj));
        }
        if (obj instanceof TypeAdapter) {
            this.factories.add(TypeAdapters.newTypeHierarchyFactory(cls, (TypeAdapter) obj));
        }
        return this;
    }

    public GsonBuilder serializeSpecialFloatingPointValues() {
        this.serializeSpecialFloatingPointValues = true;
        return this;
    }

    public GsonBuilder disableJdkUnsafe() {
        this.useJdkUnsafe = false;
        return this;
    }

    public GsonBuilder addReflectionAccessFilter(ReflectionAccessFilter reflectionAccessFilter) {
        Objects.requireNonNull(reflectionAccessFilter);
        this.reflectionFilters.addFirst(reflectionAccessFilter);
        return this;
    }

    public Gson create() {
        ArrayList arrayList = r1;
        ArrayList arrayList2 = new ArrayList(this.factories.size() + this.hierarchyFactories.size() + 3);
        arrayList2.addAll(this.factories);
        Collections.reverse(arrayList2);
        ArrayList arrayList3 = new ArrayList(this.hierarchyFactories);
        Collections.reverse(arrayList3);
        arrayList2.addAll(arrayList3);
        addTypeAdaptersForDate(this.datePattern, this.dateStyle, this.timeStyle, arrayList2);
        Excluder excluder2 = this.excluder;
        FieldNamingStrategy fieldNamingStrategy = this.fieldNamingPolicy;
        HashMap hashMap = r5;
        HashMap hashMap2 = new HashMap(this.instanceCreators);
        boolean z = this.serializeNulls;
        boolean z2 = this.complexMapKeySerialization;
        boolean z3 = this.generateNonExecutableJson;
        boolean z4 = this.escapeHtmlChars;
        boolean z5 = this.prettyPrinting;
        boolean z6 = this.lenient;
        boolean z7 = this.serializeSpecialFloatingPointValues;
        boolean z8 = this.useJdkUnsafe;
        LongSerializationPolicy longSerializationPolicy2 = this.longSerializationPolicy;
        String str = this.datePattern;
        int i = this.dateStyle;
        int i2 = this.timeStyle;
        ArrayList arrayList4 = r1;
        Excluder excluder3 = excluder2;
        ArrayList arrayList5 = new ArrayList(this.factories);
        ArrayList arrayList6 = r1;
        ArrayList arrayList7 = new ArrayList(this.hierarchyFactories);
        ToNumberStrategy toNumberStrategy = this.objectToNumberStrategy;
        ToNumberStrategy toNumberStrategy2 = this.numberToNumberStrategy;
        ArrayList arrayList8 = r1;
        ArrayList arrayList9 = new ArrayList(this.reflectionFilters);
        return new Gson(excluder3, fieldNamingStrategy, hashMap, z, z2, z3, z4, z5, z6, z7, z8, longSerializationPolicy2, str, i, i2, arrayList4, arrayList6, arrayList, toNumberStrategy, toNumberStrategy2, arrayList8);
    }

    /* JADX WARNING: Removed duplicated region for block: B:17:0x004a  */
    /* JADX WARNING: Removed duplicated region for block: B:21:? A[RETURN, SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private void addTypeAdaptersForDate(java.lang.String r4, int r5, int r6, java.util.List<com.google.gson.TypeAdapterFactory> r7) {
        /*
            r3 = this;
            boolean r3 = com.google.gson.internal.sql.SqlTypesSupport.SUPPORTS_SQL_TYPES
            r0 = 0
            if (r4 == 0) goto L_0x0026
            java.lang.String r1 = r4.trim()
            boolean r1 = r1.isEmpty()
            if (r1 != 0) goto L_0x0026
            com.google.gson.internal.bind.DefaultDateTypeAdapter$DateType<java.util.Date> r5 = com.google.gson.internal.bind.DefaultDateTypeAdapter.DateType.DATE
            com.google.gson.TypeAdapterFactory r5 = r5.createAdapterFactory((java.lang.String) r4)
            if (r3 == 0) goto L_0x0024
            com.google.gson.internal.bind.DefaultDateTypeAdapter$DateType<? extends java.util.Date> r6 = com.google.gson.internal.sql.SqlTypesSupport.TIMESTAMP_DATE_TYPE
            com.google.gson.TypeAdapterFactory r0 = r6.createAdapterFactory((java.lang.String) r4)
            com.google.gson.internal.bind.DefaultDateTypeAdapter$DateType<? extends java.util.Date> r6 = com.google.gson.internal.sql.SqlTypesSupport.DATE_DATE_TYPE
            com.google.gson.TypeAdapterFactory r4 = r6.createAdapterFactory((java.lang.String) r4)
            goto L_0x0045
        L_0x0024:
            r4 = r0
            goto L_0x0045
        L_0x0026:
            r4 = 2
            if (r5 == r4) goto L_0x0050
            if (r6 == r4) goto L_0x0050
            com.google.gson.internal.bind.DefaultDateTypeAdapter$DateType<java.util.Date> r4 = com.google.gson.internal.bind.DefaultDateTypeAdapter.DateType.DATE
            com.google.gson.TypeAdapterFactory r4 = r4.createAdapterFactory(r5, r6)
            if (r3 == 0) goto L_0x0043
            com.google.gson.internal.bind.DefaultDateTypeAdapter$DateType<? extends java.util.Date> r0 = com.google.gson.internal.sql.SqlTypesSupport.TIMESTAMP_DATE_TYPE
            com.google.gson.TypeAdapterFactory r0 = r0.createAdapterFactory(r5, r6)
            com.google.gson.internal.bind.DefaultDateTypeAdapter$DateType<? extends java.util.Date> r1 = com.google.gson.internal.sql.SqlTypesSupport.DATE_DATE_TYPE
            com.google.gson.TypeAdapterFactory r5 = r1.createAdapterFactory(r5, r6)
            r2 = r5
            r5 = r4
            r4 = r2
            goto L_0x0045
        L_0x0043:
            r5 = r4
            goto L_0x0024
        L_0x0045:
            r7.add(r5)
            if (r3 == 0) goto L_0x0050
            r7.add(r0)
            r7.add(r4)
        L_0x0050:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.gson.GsonBuilder.addTypeAdaptersForDate(java.lang.String, int, int, java.util.List):void");
    }
}
