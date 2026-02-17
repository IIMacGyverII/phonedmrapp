package com.google.gson.internal.bind;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonToken;
import com.google.gson.stream.MalformedJsonException;
import java.io.IOException;
import java.io.Reader;
import java.util.Arrays;
import java.util.Iterator;
import java.util.Map;
import kotlin.text.Typography;

public final class JsonTreeReader extends JsonReader {
    private static final Object SENTINEL_CLOSED = new Object();
    private static final Reader UNREADABLE_READER = new Reader() {
        public int read(char[] cArr, int i, int i2) {
            throw new AssertionError();
        }

        public void close() {
            throw new AssertionError();
        }
    };
    private int[] pathIndices = new int[32];
    private String[] pathNames = new String[32];
    private Object[] stack = new Object[32];
    private int stackSize = 0;

    public JsonTreeReader(JsonElement jsonElement) {
        super(UNREADABLE_READER);
        push(jsonElement);
    }

    public void beginArray() throws IOException {
        expect(JsonToken.BEGIN_ARRAY);
        push(((JsonArray) peekStack()).iterator());
        this.pathIndices[this.stackSize - 1] = 0;
    }

    public void endArray() throws IOException {
        expect(JsonToken.END_ARRAY);
        popStack();
        popStack();
        int i = this.stackSize;
        if (i > 0) {
            int[] iArr = this.pathIndices;
            int i2 = i - 1;
            iArr[i2] = iArr[i2] + 1;
        }
    }

    public void beginObject() throws IOException {
        expect(JsonToken.BEGIN_OBJECT);
        push(((JsonObject) peekStack()).entrySet().iterator());
    }

    public void endObject() throws IOException {
        expect(JsonToken.END_OBJECT);
        this.pathNames[this.stackSize - 1] = null;
        popStack();
        popStack();
        int i = this.stackSize;
        if (i > 0) {
            int[] iArr = this.pathIndices;
            int i2 = i - 1;
            iArr[i2] = iArr[i2] + 1;
        }
    }

    public boolean hasNext() throws IOException {
        JsonToken peek = peek();
        return (peek == JsonToken.END_OBJECT || peek == JsonToken.END_ARRAY || peek == JsonToken.END_DOCUMENT) ? false : true;
    }

    public JsonToken peek() throws IOException {
        if (this.stackSize == 0) {
            return JsonToken.END_DOCUMENT;
        }
        Object peekStack = peekStack();
        if (peekStack instanceof Iterator) {
            boolean z = this.stack[this.stackSize - 2] instanceof JsonObject;
            Iterator it = (Iterator) peekStack;
            if (!it.hasNext()) {
                return z ? JsonToken.END_OBJECT : JsonToken.END_ARRAY;
            }
            if (z) {
                return JsonToken.NAME;
            }
            push(it.next());
            return peek();
        } else if (peekStack instanceof JsonObject) {
            return JsonToken.BEGIN_OBJECT;
        } else {
            if (peekStack instanceof JsonArray) {
                return JsonToken.BEGIN_ARRAY;
            }
            if (peekStack instanceof JsonPrimitive) {
                JsonPrimitive jsonPrimitive = (JsonPrimitive) peekStack;
                if (jsonPrimitive.isString()) {
                    return JsonToken.STRING;
                }
                if (jsonPrimitive.isBoolean()) {
                    return JsonToken.BOOLEAN;
                }
                if (jsonPrimitive.isNumber()) {
                    return JsonToken.NUMBER;
                }
                throw new AssertionError();
            } else if (peekStack instanceof JsonNull) {
                return JsonToken.NULL;
            } else {
                if (peekStack == SENTINEL_CLOSED) {
                    throw new IllegalStateException("JsonReader is closed");
                }
                throw new MalformedJsonException("Custom JsonElement subclass " + peekStack.getClass().getName() + " is not supported");
            }
        }
    }

    private Object peekStack() {
        return this.stack[this.stackSize - 1];
    }

    private Object popStack() {
        Object[] objArr = this.stack;
        int i = this.stackSize - 1;
        this.stackSize = i;
        Object obj = objArr[i];
        objArr[i] = null;
        return obj;
    }

    private void expect(JsonToken jsonToken) throws IOException {
        if (peek() != jsonToken) {
            throw new IllegalStateException("Expected " + jsonToken + " but was " + peek() + locationString());
        }
    }

    private String nextName(boolean z) throws IOException {
        expect(JsonToken.NAME);
        Map.Entry entry = (Map.Entry) ((Iterator) peekStack()).next();
        String str = (String) entry.getKey();
        this.pathNames[this.stackSize - 1] = z ? "<skipped>" : str;
        push(entry.getValue());
        return str;
    }

    public String nextName() throws IOException {
        return nextName(false);
    }

    public String nextString() throws IOException {
        JsonToken peek = peek();
        JsonToken jsonToken = JsonToken.STRING;
        if (peek == jsonToken || peek == JsonToken.NUMBER) {
            String asString = ((JsonPrimitive) popStack()).getAsString();
            int i = this.stackSize;
            if (i > 0) {
                int[] iArr = this.pathIndices;
                int i2 = i - 1;
                iArr[i2] = iArr[i2] + 1;
            }
            return asString;
        }
        throw new IllegalStateException("Expected " + jsonToken + " but was " + peek + locationString());
    }

    public boolean nextBoolean() throws IOException {
        expect(JsonToken.BOOLEAN);
        boolean asBoolean = ((JsonPrimitive) popStack()).getAsBoolean();
        int i = this.stackSize;
        if (i > 0) {
            int[] iArr = this.pathIndices;
            int i2 = i - 1;
            iArr[i2] = iArr[i2] + 1;
        }
        return asBoolean;
    }

    public void nextNull() throws IOException {
        expect(JsonToken.NULL);
        popStack();
        int i = this.stackSize;
        if (i > 0) {
            int[] iArr = this.pathIndices;
            int i2 = i - 1;
            iArr[i2] = iArr[i2] + 1;
        }
    }

    public double nextDouble() throws IOException {
        JsonToken peek = peek();
        JsonToken jsonToken = JsonToken.NUMBER;
        if (peek == jsonToken || peek == JsonToken.STRING) {
            double asDouble = ((JsonPrimitive) peekStack()).getAsDouble();
            if (isLenient() || (!Double.isNaN(asDouble) && !Double.isInfinite(asDouble))) {
                popStack();
                int i = this.stackSize;
                if (i > 0) {
                    int[] iArr = this.pathIndices;
                    int i2 = i - 1;
                    iArr[i2] = iArr[i2] + 1;
                }
                return asDouble;
            }
            throw new MalformedJsonException("JSON forbids NaN and infinities: " + asDouble);
        }
        throw new IllegalStateException("Expected " + jsonToken + " but was " + peek + locationString());
    }

    public long nextLong() throws IOException {
        JsonToken peek = peek();
        JsonToken jsonToken = JsonToken.NUMBER;
        if (peek == jsonToken || peek == JsonToken.STRING) {
            long asLong = ((JsonPrimitive) peekStack()).getAsLong();
            popStack();
            int i = this.stackSize;
            if (i > 0) {
                int[] iArr = this.pathIndices;
                int i2 = i - 1;
                iArr[i2] = iArr[i2] + 1;
            }
            return asLong;
        }
        throw new IllegalStateException("Expected " + jsonToken + " but was " + peek + locationString());
    }

    public int nextInt() throws IOException {
        JsonToken peek = peek();
        JsonToken jsonToken = JsonToken.NUMBER;
        if (peek == jsonToken || peek == JsonToken.STRING) {
            int asInt = ((JsonPrimitive) peekStack()).getAsInt();
            popStack();
            int i = this.stackSize;
            if (i > 0) {
                int[] iArr = this.pathIndices;
                int i2 = i - 1;
                iArr[i2] = iArr[i2] + 1;
            }
            return asInt;
        }
        throw new IllegalStateException("Expected " + jsonToken + " but was " + peek + locationString());
    }

    /* access modifiers changed from: package-private */
    public JsonElement nextJsonElement() throws IOException {
        JsonToken peek = peek();
        if (peek == JsonToken.NAME || peek == JsonToken.END_ARRAY || peek == JsonToken.END_OBJECT || peek == JsonToken.END_DOCUMENT) {
            throw new IllegalStateException("Unexpected " + peek + " when reading a JsonElement.");
        }
        JsonElement jsonElement = (JsonElement) peekStack();
        skipValue();
        return jsonElement;
    }

    public void close() throws IOException {
        this.stack = new Object[]{SENTINEL_CLOSED};
        this.stackSize = 1;
    }

    /* renamed from: com.google.gson.internal.bind.JsonTreeReader$2  reason: invalid class name */
    static /* synthetic */ class AnonymousClass2 {
        static final /* synthetic */ int[] $SwitchMap$com$google$gson$stream$JsonToken;

        /* JADX WARNING: Can't wrap try/catch for region: R(8:0|1|2|3|4|5|6|(3:7|8|10)) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        /* JADX WARNING: Missing exception handler attribute for start block: B:7:0x0028 */
        static {
            /*
                com.google.gson.stream.JsonToken[] r0 = com.google.gson.stream.JsonToken.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$google$gson$stream$JsonToken = r0
                com.google.gson.stream.JsonToken r1 = com.google.gson.stream.JsonToken.NAME     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$google$gson$stream$JsonToken     // Catch:{ NoSuchFieldError -> 0x001d }
                com.google.gson.stream.JsonToken r1 = com.google.gson.stream.JsonToken.END_ARRAY     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$google$gson$stream$JsonToken     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.google.gson.stream.JsonToken r1 = com.google.gson.stream.JsonToken.END_OBJECT     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                int[] r0 = $SwitchMap$com$google$gson$stream$JsonToken     // Catch:{ NoSuchFieldError -> 0x0033 }
                com.google.gson.stream.JsonToken r1 = com.google.gson.stream.JsonToken.END_DOCUMENT     // Catch:{ NoSuchFieldError -> 0x0033 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0033 }
                r2 = 4
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0033 }
            L_0x0033:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.google.gson.internal.bind.JsonTreeReader.AnonymousClass2.<clinit>():void");
        }
    }

    public void skipValue() throws IOException {
        int i = AnonymousClass2.$SwitchMap$com$google$gson$stream$JsonToken[peek().ordinal()];
        if (i == 1) {
            nextName(true);
        } else if (i == 2) {
            endArray();
        } else if (i == 3) {
            endObject();
        } else if (i != 4) {
            popStack();
            int i2 = this.stackSize;
            if (i2 > 0) {
                int[] iArr = this.pathIndices;
                int i3 = i2 - 1;
                iArr[i3] = iArr[i3] + 1;
            }
        }
    }

    public String toString() {
        return JsonTreeReader.class.getSimpleName() + locationString();
    }

    public void promoteNameToValue() throws IOException {
        expect(JsonToken.NAME);
        Map.Entry entry = (Map.Entry) ((Iterator) peekStack()).next();
        push(entry.getValue());
        push(new JsonPrimitive((String) entry.getKey()));
    }

    private void push(Object obj) {
        int i = this.stackSize;
        Object[] objArr = this.stack;
        if (i == objArr.length) {
            int i2 = i * 2;
            this.stack = Arrays.copyOf(objArr, i2);
            this.pathIndices = Arrays.copyOf(this.pathIndices, i2);
            this.pathNames = (String[]) Arrays.copyOf(this.pathNames, i2);
        }
        Object[] objArr2 = this.stack;
        int i3 = this.stackSize;
        this.stackSize = i3 + 1;
        objArr2[i3] = obj;
    }

    private String getPath(boolean z) {
        StringBuilder sb = new StringBuilder();
        sb.append(Typography.dollar);
        int i = 0;
        while (true) {
            int i2 = this.stackSize;
            if (i >= i2) {
                return sb.toString();
            }
            Object[] objArr = this.stack;
            Object obj = objArr[i];
            if (obj instanceof JsonArray) {
                i++;
                if (i < i2 && (objArr[i] instanceof Iterator)) {
                    int i3 = this.pathIndices[i];
                    if (z && i3 > 0 && (i == i2 - 1 || i == i2 - 2)) {
                        i3--;
                    }
                    sb.append('[');
                    sb.append(i3);
                    sb.append(']');
                }
            } else if ((obj instanceof JsonObject) && (i = i + 1) < i2 && (objArr[i] instanceof Iterator)) {
                sb.append('.');
                String str = this.pathNames[i];
                if (str != null) {
                    sb.append(str);
                }
            }
            i++;
        }
    }

    public String getPreviousPath() {
        return getPath(true);
    }

    public String getPath() {
        return getPath(false);
    }

    private String locationString() {
        return " at path " + getPath();
    }
}
