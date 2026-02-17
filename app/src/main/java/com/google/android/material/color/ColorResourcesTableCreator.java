package com.google.android.material.color;

import android.content.Context;
import android.util.Pair;
import androidx.annotation.ColorInt;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

final class ColorResourcesTableCreator {
    private static final byte ANDROID_PACKAGE_ID = 1;
    private static final PackageInfo ANDROID_PACKAGE_INFO = new PackageInfo(1, "android");
    private static final byte APPLICATION_PACKAGE_ID = Byte.MAX_VALUE;
    /* access modifiers changed from: private */
    public static final Comparator<ColorResource> COLOR_RESOURCE_COMPARATOR = new Comparator<ColorResource>() {
        public int compare(ColorResource colorResource, ColorResource colorResource2) {
            return colorResource.entryId - colorResource2.entryId;
        }
    };
    private static final short HEADER_TYPE_PACKAGE = 512;
    private static final short HEADER_TYPE_RES_TABLE = 2;
    private static final short HEADER_TYPE_STRING_POOL = 1;
    private static final short HEADER_TYPE_TYPE = 513;
    private static final short HEADER_TYPE_TYPE_SPEC = 514;
    private static final byte TYPE_ID_COLOR = 6;

    /* access modifiers changed from: private */
    public static byte[] charToByteArray(char c) {
        return new byte[]{(byte) (c & 255), (byte) ((c >> 8) & 255)};
    }

    /* access modifiers changed from: private */
    public static byte[] intToByteArray(int i) {
        return new byte[]{(byte) (i & 255), (byte) ((i >> 8) & 255), (byte) ((i >> 16) & 255), (byte) ((i >> 24) & 255)};
    }

    /* access modifiers changed from: private */
    public static byte[] shortToByteArray(short s) {
        return new byte[]{(byte) (s & 255), (byte) ((s >> 8) & 255)};
    }

    private ColorResourcesTableCreator() {
    }

    static byte[] create(Context context, Map<Integer, Integer> map) throws IOException {
        PackageInfo packageInfo;
        PackageInfo packageInfo2 = new PackageInfo(127, context.getPackageName());
        HashMap hashMap = new HashMap();
        for (Map.Entry next : map.entrySet()) {
            ColorResource colorResource = new ColorResource(((Integer) next.getKey()).intValue(), context.getResources().getResourceName(((Integer) next.getKey()).intValue()), ((Integer) next.getValue()).intValue());
            if (colorResource.typeId == 6) {
                if (colorResource.packageId == 1) {
                    packageInfo = ANDROID_PACKAGE_INFO;
                } else if (colorResource.packageId == Byte.MAX_VALUE) {
                    packageInfo = packageInfo2;
                } else {
                    throw new IllegalArgumentException("Not supported with unknown package id: " + colorResource.packageId);
                }
                if (!hashMap.containsKey(packageInfo)) {
                    hashMap.put(packageInfo, new ArrayList());
                }
                ((List) hashMap.get(packageInfo)).add(colorResource);
            } else {
                throw new IllegalArgumentException("Non color resource found: " + colorResource.name);
            }
        }
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        new ResTable(hashMap).writeTo(byteArrayOutputStream);
        return byteArrayOutputStream.toByteArray();
    }

    private static class ResTable {
        private static final short HEADER_SIZE = 12;
        private final ResChunkHeader header;
        private final List<PackageChunk> packageChunks = new ArrayList();
        private final int packageCount;
        private final StringPoolChunk stringPool;

        ResTable(Map<PackageInfo, List<ColorResource>> map) {
            this.packageCount = map.size();
            this.stringPool = new StringPoolChunk(new String[0]);
            for (Map.Entry next : map.entrySet()) {
                List list = (List) next.getValue();
                Collections.sort(list, ColorResourcesTableCreator.COLOR_RESOURCE_COMPARATOR);
                this.packageChunks.add(new PackageChunk((PackageInfo) next.getKey(), list));
            }
            this.header = new ResChunkHeader(ColorResourcesTableCreator.HEADER_TYPE_RES_TABLE, HEADER_SIZE, getOverallSize());
        }

        /* access modifiers changed from: package-private */
        public void writeTo(ByteArrayOutputStream byteArrayOutputStream) throws IOException {
            this.header.writeTo(byteArrayOutputStream);
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.packageCount));
            this.stringPool.writeTo(byteArrayOutputStream);
            for (PackageChunk writeTo : this.packageChunks) {
                writeTo.writeTo(byteArrayOutputStream);
            }
        }

        private int getOverallSize() {
            int i = 0;
            for (PackageChunk chunkSize : this.packageChunks) {
                i += chunkSize.getChunkSize();
            }
            return this.stringPool.getChunkSize() + 12 + i;
        }
    }

    private static class ResChunkHeader {
        private final int chunkSize;
        private final short headerSize;
        private final short type;

        ResChunkHeader(short s, short s2, int i) {
            this.type = s;
            this.headerSize = s2;
            this.chunkSize = i;
        }

        /* access modifiers changed from: package-private */
        public void writeTo(ByteArrayOutputStream byteArrayOutputStream) throws IOException {
            byteArrayOutputStream.write(ColorResourcesTableCreator.shortToByteArray(this.type));
            byteArrayOutputStream.write(ColorResourcesTableCreator.shortToByteArray(this.headerSize));
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.chunkSize));
        }
    }

    private static class StringPoolChunk {
        private static final int FLAG_UTF8 = 256;
        private static final short HEADER_SIZE = 28;
        private static final int STYLED_SPAN_LIST_END = -1;
        private final int chunkSize;
        private final ResChunkHeader header;
        private final int stringCount;
        private final List<Integer> stringIndex;
        private final List<byte[]> strings;
        private final int stringsPaddingSize;
        private final int stringsStart;
        private final int styledSpanCount;
        private final List<Integer> styledSpanIndex;
        private final List<List<StringStyledSpan>> styledSpans;
        private final int styledSpansStart;
        private final boolean utf8Encode;

        StringPoolChunk(String... strArr) {
            this(false, strArr);
        }

        StringPoolChunk(boolean z, String... strArr) {
            this.stringIndex = new ArrayList();
            this.styledSpanIndex = new ArrayList();
            this.strings = new ArrayList();
            this.styledSpans = new ArrayList();
            this.utf8Encode = z;
            int i = 0;
            int i2 = 0;
            for (String processString : strArr) {
                Pair<byte[], List<StringStyledSpan>> processString2 = processString(processString);
                this.stringIndex.add(Integer.valueOf(i2));
                Object obj = processString2.first;
                i2 += ((byte[]) obj).length;
                this.strings.add(obj);
                this.styledSpans.add(processString2.second);
            }
            int i3 = 0;
            for (List<StringStyledSpan> next : this.styledSpans) {
                for (StringStyledSpan stringStyledSpan : next) {
                    this.stringIndex.add(Integer.valueOf(i2));
                    i2 += stringStyledSpan.styleString.length;
                    this.strings.add(stringStyledSpan.styleString);
                }
                this.styledSpanIndex.add(Integer.valueOf(i3));
                i3 += (next.size() * 12) + 4;
            }
            int i4 = i2 % 4;
            int i5 = i4 == 0 ? 0 : 4 - i4;
            this.stringsPaddingSize = i5;
            int size = this.strings.size();
            this.stringCount = size;
            this.styledSpanCount = this.strings.size() - strArr.length;
            boolean z2 = this.strings.size() - strArr.length > 0;
            if (!z2) {
                this.styledSpanIndex.clear();
                this.styledSpans.clear();
            }
            int size2 = (size * 4) + 28 + (this.styledSpanIndex.size() * 4);
            this.stringsStart = size2;
            int i6 = i2 + i5;
            this.styledSpansStart = z2 ? size2 + i6 : 0;
            int i7 = size2 + i6 + (z2 ? i3 : i);
            this.chunkSize = i7;
            this.header = new ResChunkHeader(ColorResourcesTableCreator.HEADER_TYPE_STRING_POOL, HEADER_SIZE, i7);
        }

        /* access modifiers changed from: package-private */
        public void writeTo(ByteArrayOutputStream byteArrayOutputStream) throws IOException {
            this.header.writeTo(byteArrayOutputStream);
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.stringCount));
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.styledSpanCount));
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.utf8Encode ? 256 : 0));
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.stringsStart));
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.styledSpansStart));
            for (Integer intValue : this.stringIndex) {
                byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(intValue.intValue()));
            }
            for (Integer intValue2 : this.styledSpanIndex) {
                byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(intValue2.intValue()));
            }
            for (byte[] write : this.strings) {
                byteArrayOutputStream.write(write);
            }
            int i = this.stringsPaddingSize;
            if (i > 0) {
                byteArrayOutputStream.write(new byte[i]);
            }
            for (List<StringStyledSpan> it : this.styledSpans) {
                for (StringStyledSpan writeTo : it) {
                    writeTo.writeTo(byteArrayOutputStream);
                }
                byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(-1));
            }
        }

        /* access modifiers changed from: package-private */
        public int getChunkSize() {
            return this.chunkSize;
        }

        private Pair<byte[], List<StringStyledSpan>> processString(String str) {
            return new Pair<>(this.utf8Encode ? ColorResourcesTableCreator.stringToByteArrayUtf8(str) : ColorResourcesTableCreator.stringToByteArray(str), Collections.emptyList());
        }
    }

    private static class StringStyledSpan {
        private int firstCharacterIndex;
        private int lastCharacterIndex;
        private int nameReference;
        /* access modifiers changed from: private */
        public byte[] styleString;

        private StringStyledSpan() {
        }

        /* access modifiers changed from: package-private */
        public void writeTo(ByteArrayOutputStream byteArrayOutputStream) throws IOException {
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.nameReference));
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.firstCharacterIndex));
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.lastCharacterIndex));
        }
    }

    private static class PackageChunk {
        private static final short HEADER_SIZE = 288;
        private static final int PACKAGE_NAME_MAX_LENGTH = 128;
        private final ResChunkHeader header;
        private final StringPoolChunk keyStrings;
        private final PackageInfo packageInfo;
        private final TypeSpecChunk typeSpecChunk;
        private final StringPoolChunk typeStrings = new StringPoolChunk(false, "?1", "?2", "?3", "?4", "?5", "color");

        PackageChunk(PackageInfo packageInfo2, List<ColorResource> list) {
            this.packageInfo = packageInfo2;
            String[] strArr = new String[list.size()];
            for (int i = 0; i < list.size(); i++) {
                strArr[i] = list.get(i).name;
            }
            this.keyStrings = new StringPoolChunk(true, strArr);
            this.typeSpecChunk = new TypeSpecChunk(list);
            this.header = new ResChunkHeader(ColorResourcesTableCreator.HEADER_TYPE_PACKAGE, HEADER_SIZE, getChunkSize());
        }

        /* access modifiers changed from: package-private */
        public void writeTo(ByteArrayOutputStream byteArrayOutputStream) throws IOException {
            this.header.writeTo(byteArrayOutputStream);
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.packageInfo.id));
            char[] charArray = this.packageInfo.name.toCharArray();
            for (int i = 0; i < 128; i++) {
                if (i < charArray.length) {
                    byteArrayOutputStream.write(ColorResourcesTableCreator.charToByteArray(charArray[i]));
                } else {
                    byteArrayOutputStream.write(ColorResourcesTableCreator.charToByteArray(0));
                }
            }
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(288));
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(0));
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.typeStrings.getChunkSize() + 288));
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(0));
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(0));
            this.typeStrings.writeTo(byteArrayOutputStream);
            this.keyStrings.writeTo(byteArrayOutputStream);
            this.typeSpecChunk.writeTo(byteArrayOutputStream);
        }

        /* access modifiers changed from: package-private */
        public int getChunkSize() {
            return this.typeStrings.getChunkSize() + 288 + this.keyStrings.getChunkSize() + this.typeSpecChunk.getChunkSizeWithTypeChunk();
        }
    }

    private static class TypeSpecChunk {
        private static final short HEADER_SIZE = 16;
        private static final int SPEC_PUBLIC = 1073741824;
        private final int entryCount;
        private final int[] entryFlags;
        private final ResChunkHeader header;
        private final TypeChunk typeChunk;

        TypeSpecChunk(List<ColorResource> list) {
            this.entryCount = list.get(list.size() - 1).entryId + ColorResourcesTableCreator.HEADER_TYPE_STRING_POOL;
            HashSet hashSet = new HashSet();
            for (ColorResource access$000 : list) {
                hashSet.add(Short.valueOf(access$000.entryId));
            }
            this.entryFlags = new int[this.entryCount];
            for (short s = 0; s < this.entryCount; s = (short) (s + ColorResourcesTableCreator.HEADER_TYPE_STRING_POOL)) {
                if (hashSet.contains(Short.valueOf(s))) {
                    this.entryFlags[s] = 1073741824;
                }
            }
            this.header = new ResChunkHeader(ColorResourcesTableCreator.HEADER_TYPE_TYPE_SPEC, HEADER_SIZE, getChunkSize());
            this.typeChunk = new TypeChunk(list, hashSet, this.entryCount);
        }

        /* access modifiers changed from: package-private */
        public void writeTo(ByteArrayOutputStream byteArrayOutputStream) throws IOException {
            this.header.writeTo(byteArrayOutputStream);
            byteArrayOutputStream.write(new byte[]{6, 0, 0, 0});
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.entryCount));
            for (int access$500 : this.entryFlags) {
                byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(access$500));
            }
            this.typeChunk.writeTo(byteArrayOutputStream);
        }

        /* access modifiers changed from: package-private */
        public int getChunkSizeWithTypeChunk() {
            return getChunkSize() + this.typeChunk.getChunkSize();
        }

        private int getChunkSize() {
            return (this.entryCount * 4) + 16;
        }
    }

    private static class TypeChunk {
        private static final byte CONFIG_SIZE = 64;
        private static final short HEADER_SIZE = 84;
        private static final int OFFSET_NO_ENTRY = -1;
        private final byte[] config;
        private final int entryCount;
        private final ResChunkHeader header;
        private final int[] offsetTable;
        private final ResEntry[] resEntries;

        TypeChunk(List<ColorResource> list, Set<Short> set, int i) {
            byte[] bArr = new byte[64];
            this.config = bArr;
            this.entryCount = i;
            bArr[0] = 64;
            this.resEntries = new ResEntry[list.size()];
            for (int i2 = 0; i2 < list.size(); i2++) {
                this.resEntries[i2] = new ResEntry(i2, list.get(i2).value);
            }
            this.offsetTable = new int[i];
            int i3 = 0;
            for (short s = 0; s < i; s = (short) (s + ColorResourcesTableCreator.HEADER_TYPE_STRING_POOL)) {
                if (set.contains(Short.valueOf(s))) {
                    this.offsetTable[s] = i3;
                    i3 += 16;
                } else {
                    this.offsetTable[s] = -1;
                }
            }
            this.header = new ResChunkHeader(ColorResourcesTableCreator.HEADER_TYPE_TYPE, HEADER_SIZE, getChunkSize());
        }

        /* access modifiers changed from: package-private */
        public void writeTo(ByteArrayOutputStream byteArrayOutputStream) throws IOException {
            this.header.writeTo(byteArrayOutputStream);
            byteArrayOutputStream.write(new byte[]{6, 0, 0, 0});
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.entryCount));
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(getEntryStart()));
            byteArrayOutputStream.write(this.config);
            for (int access$500 : this.offsetTable) {
                byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(access$500));
            }
            for (ResEntry writeTo : this.resEntries) {
                writeTo.writeTo(byteArrayOutputStream);
            }
        }

        /* access modifiers changed from: package-private */
        public int getChunkSize() {
            return getEntryStart() + (this.resEntries.length * 16);
        }

        private int getEntryStart() {
            return getOffsetTableSize() + 84;
        }

        private int getOffsetTableSize() {
            return this.offsetTable.length * 4;
        }
    }

    private static class ResEntry {
        private static final byte DATA_TYPE_AARRGGBB = 28;
        private static final short ENTRY_SIZE = 8;
        private static final short FLAG_PUBLIC = 2;
        private static final int SIZE = 16;
        private static final short VALUE_SIZE = 8;
        private final int data;
        private final int keyStringIndex;

        ResEntry(int i, @ColorInt int i2) {
            this.keyStringIndex = i;
            this.data = i2;
        }

        /* access modifiers changed from: package-private */
        public void writeTo(ByteArrayOutputStream byteArrayOutputStream) throws IOException {
            byteArrayOutputStream.write(ColorResourcesTableCreator.shortToByteArray(8));
            byteArrayOutputStream.write(ColorResourcesTableCreator.shortToByteArray(FLAG_PUBLIC));
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.keyStringIndex));
            byteArrayOutputStream.write(ColorResourcesTableCreator.shortToByteArray(8));
            byteArrayOutputStream.write(new byte[]{0, DATA_TYPE_AARRGGBB});
            byteArrayOutputStream.write(ColorResourcesTableCreator.intToByteArray(this.data));
        }
    }

    static class PackageInfo {
        /* access modifiers changed from: private */
        public final int id;
        /* access modifiers changed from: private */
        public final String name;

        PackageInfo(int i, String str) {
            this.id = i;
            this.name = str;
        }
    }

    static class ColorResource {
        /* access modifiers changed from: private */
        public final short entryId;
        /* access modifiers changed from: private */
        public final String name;
        /* access modifiers changed from: private */
        public final byte packageId;
        /* access modifiers changed from: private */
        public final byte typeId;
        /* access modifiers changed from: private */
        @ColorInt
        public final int value;

        ColorResource(int i, String str, int i2) {
            this.name = str;
            this.value = i2;
            this.entryId = (short) (65535 & i);
            this.typeId = (byte) ((i >> 16) & 255);
            this.packageId = (byte) ((i >> 24) & 255);
        }
    }

    /* access modifiers changed from: private */
    public static byte[] stringToByteArray(String str) {
        char[] charArray = str.toCharArray();
        int length = (charArray.length * 2) + 4;
        byte[] bArr = new byte[length];
        byte[] shortToByteArray = shortToByteArray((short) charArray.length);
        bArr[0] = shortToByteArray[0];
        bArr[1] = shortToByteArray[1];
        for (int i = 0; i < charArray.length; i++) {
            byte[] charToByteArray = charToByteArray(charArray[i]);
            int i2 = i * 2;
            bArr[i2 + 2] = charToByteArray[0];
            bArr[i2 + 3] = charToByteArray[1];
        }
        bArr[length - 2] = 0;
        bArr[length - 1] = 0;
        return bArr;
    }

    /* access modifiers changed from: private */
    public static byte[] stringToByteArrayUtf8(String str) {
        byte[] bytes = str.getBytes(Charset.forName("UTF-8"));
        byte length = (byte) bytes.length;
        int length2 = bytes.length + 3;
        byte[] bArr = new byte[length2];
        System.arraycopy(bytes, 0, bArr, 2, length);
        bArr[1] = length;
        bArr[0] = length;
        bArr[length2 - 1] = 0;
        return bArr;
    }
}
