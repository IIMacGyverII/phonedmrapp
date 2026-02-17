package com.google.gson.internal.bind;

import com.google.gson.Gson;
import com.google.gson.TypeAdapter;
import com.google.gson.TypeAdapterFactory;
import com.google.gson.annotations.JsonAdapter;
import com.google.gson.internal.ConstructorConstructor;
import com.google.gson.reflect.TypeToken;

public final class JsonAdapterAnnotationTypeAdapterFactory implements TypeAdapterFactory {
    private final ConstructorConstructor constructorConstructor;

    public JsonAdapterAnnotationTypeAdapterFactory(ConstructorConstructor constructorConstructor2) {
        this.constructorConstructor = constructorConstructor2;
    }

    public <T> TypeAdapter<T> create(Gson gson, TypeToken<T> typeToken) {
        JsonAdapter jsonAdapter = (JsonAdapter) typeToken.getRawType().getAnnotation(JsonAdapter.class);
        if (jsonAdapter == null) {
            return null;
        }
        return getTypeAdapter(this.constructorConstructor, gson, typeToken, jsonAdapter);
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r7v5, resolved type: com.google.gson.internal.bind.TreeTypeAdapter} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r7v16, resolved type: com.google.gson.TypeAdapter<?>} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r7v17, resolved type: com.google.gson.TypeAdapter} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r0v1, resolved type: com.google.gson.internal.bind.TreeTypeAdapter} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r7v18, resolved type: com.google.gson.internal.bind.TreeTypeAdapter} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r7v19, resolved type: com.google.gson.internal.bind.TreeTypeAdapter} */
    /* access modifiers changed from: package-private */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public com.google.gson.TypeAdapter<?> getTypeAdapter(com.google.gson.internal.ConstructorConstructor r8, com.google.gson.Gson r9, com.google.gson.reflect.TypeToken<?> r10, com.google.gson.annotations.JsonAdapter r11) {
        /*
            r7 = this;
            java.lang.Class r7 = r11.value()
            com.google.gson.reflect.TypeToken r7 = com.google.gson.reflect.TypeToken.get(r7)
            com.google.gson.internal.ObjectConstructor r7 = r8.get(r7)
            java.lang.Object r7 = r7.construct()
            boolean r6 = r11.nullSafe()
            boolean r8 = r7 instanceof com.google.gson.TypeAdapter
            if (r8 == 0) goto L_0x001b
            com.google.gson.TypeAdapter r7 = (com.google.gson.TypeAdapter) r7
            goto L_0x007b
        L_0x001b:
            boolean r8 = r7 instanceof com.google.gson.TypeAdapterFactory
            if (r8 == 0) goto L_0x0026
            com.google.gson.TypeAdapterFactory r7 = (com.google.gson.TypeAdapterFactory) r7
            com.google.gson.TypeAdapter r7 = r7.create(r9, r10)
            goto L_0x007b
        L_0x0026:
            boolean r8 = r7 instanceof com.google.gson.JsonSerializer
            if (r8 != 0) goto L_0x005f
            boolean r11 = r7 instanceof com.google.gson.JsonDeserializer
            if (r11 == 0) goto L_0x002f
            goto L_0x005f
        L_0x002f:
            java.lang.IllegalArgumentException r8 = new java.lang.IllegalArgumentException
            java.lang.StringBuilder r9 = new java.lang.StringBuilder
            r9.<init>()
            java.lang.String r11 = "Invalid attempt to bind an instance of "
            r9.append(r11)
            java.lang.Class r7 = r7.getClass()
            java.lang.String r7 = r7.getName()
            r9.append(r7)
            java.lang.String r7 = " as a @JsonAdapter for "
            r9.append(r7)
            java.lang.String r7 = r10.toString()
            r9.append(r7)
            java.lang.String r7 = ". @JsonAdapter value must be a TypeAdapter, TypeAdapterFactory, JsonSerializer or JsonDeserializer."
            r9.append(r7)
            java.lang.String r7 = r9.toString()
            r8.<init>(r7)
            throw r8
        L_0x005f:
            r11 = 0
            if (r8 == 0) goto L_0x0067
            r8 = r7
            com.google.gson.JsonSerializer r8 = (com.google.gson.JsonSerializer) r8
            r1 = r8
            goto L_0x0068
        L_0x0067:
            r1 = r11
        L_0x0068:
            boolean r8 = r7 instanceof com.google.gson.JsonDeserializer
            if (r8 == 0) goto L_0x0070
            com.google.gson.JsonDeserializer r7 = (com.google.gson.JsonDeserializer) r7
            r2 = r7
            goto L_0x0071
        L_0x0070:
            r2 = r11
        L_0x0071:
            com.google.gson.internal.bind.TreeTypeAdapter r7 = new com.google.gson.internal.bind.TreeTypeAdapter
            r5 = 0
            r0 = r7
            r3 = r9
            r4 = r10
            r0.<init>(r1, r2, r3, r4, r5, r6)
            r6 = 0
        L_0x007b:
            if (r7 == 0) goto L_0x0083
            if (r6 == 0) goto L_0x0083
            com.google.gson.TypeAdapter r7 = r7.nullSafe()
        L_0x0083:
            return r7
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.gson.internal.bind.JsonAdapterAnnotationTypeAdapterFactory.getTypeAdapter(com.google.gson.internal.ConstructorConstructor, com.google.gson.Gson, com.google.gson.reflect.TypeToken, com.google.gson.annotations.JsonAdapter):com.google.gson.TypeAdapter");
    }
}
