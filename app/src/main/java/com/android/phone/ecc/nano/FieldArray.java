package com.android.phone.ecc.nano;

public final class FieldArray implements Cloneable {
    private static final FieldData DELETED = new FieldData();
    private FieldData[] mData;
    private int[] mFieldNumbers;
    private boolean mGarbage;
    private int mSize;

    private int idealByteArraySize(int i) {
        for (int i2 = 4; i2 < 32; i2++) {
            int i3 = (1 << i2) - 12;
            if (i <= i3) {
                return i3;
            }
        }
        return i;
    }

    FieldArray() {
        this(10);
    }

    FieldArray(int i) {
        this.mGarbage = false;
        int idealIntArraySize = idealIntArraySize(i);
        this.mFieldNumbers = new int[idealIntArraySize];
        this.mData = new FieldData[idealIntArraySize];
        this.mSize = 0;
    }

    /* access modifiers changed from: package-private */
    public FieldData get(int i) {
        FieldData fieldData;
        int binarySearch = binarySearch(i);
        if (binarySearch < 0 || (fieldData = this.mData[binarySearch]) == DELETED) {
            return null;
        }
        return fieldData;
    }

    /* access modifiers changed from: package-private */
    /* JADX WARNING: Code restructure failed: missing block: B:2:0x0006, code lost:
        r0 = r3.mData;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void remove(int r4) {
        /*
            r3 = this;
            int r4 = r3.binarySearch(r4)
            if (r4 < 0) goto L_0x0013
            com.android.phone.ecc.nano.FieldData[] r0 = r3.mData
            r1 = r0[r4]
            com.android.phone.ecc.nano.FieldData r2 = DELETED
            if (r1 == r2) goto L_0x0013
            r0[r4] = r2
            r4 = 1
            r3.mGarbage = r4
        L_0x0013:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.phone.ecc.nano.FieldArray.remove(int):void");
    }

    private void gc() {
        int i = this.mSize;
        int[] iArr = this.mFieldNumbers;
        FieldData[] fieldDataArr = this.mData;
        int i2 = 0;
        for (int i3 = 0; i3 < i; i3++) {
            FieldData fieldData = fieldDataArr[i3];
            if (fieldData != DELETED) {
                if (i3 != i2) {
                    iArr[i2] = iArr[i3];
                    fieldDataArr[i2] = fieldData;
                    fieldDataArr[i3] = null;
                }
                i2++;
            }
        }
        this.mGarbage = false;
        this.mSize = i2;
    }

    /* access modifiers changed from: package-private */
    public void put(int i, FieldData fieldData) {
        int binarySearch = binarySearch(i);
        if (binarySearch >= 0) {
            this.mData[binarySearch] = fieldData;
            return;
        }
        int i2 = ~binarySearch;
        int i3 = this.mSize;
        if (i2 < i3) {
            FieldData[] fieldDataArr = this.mData;
            if (fieldDataArr[i2] == DELETED) {
                this.mFieldNumbers[i2] = i;
                fieldDataArr[i2] = fieldData;
                return;
            }
        }
        if (this.mGarbage && i3 >= this.mFieldNumbers.length) {
            gc();
            i2 = ~binarySearch(i);
        }
        int i4 = this.mSize;
        if (i4 >= this.mFieldNumbers.length) {
            int idealIntArraySize = idealIntArraySize(i4 + 1);
            int[] iArr = new int[idealIntArraySize];
            FieldData[] fieldDataArr2 = new FieldData[idealIntArraySize];
            int[] iArr2 = this.mFieldNumbers;
            System.arraycopy(iArr2, 0, iArr, 0, iArr2.length);
            FieldData[] fieldDataArr3 = this.mData;
            System.arraycopy(fieldDataArr3, 0, fieldDataArr2, 0, fieldDataArr3.length);
            this.mFieldNumbers = iArr;
            this.mData = fieldDataArr2;
        }
        int i5 = this.mSize;
        if (i5 - i2 != 0) {
            int[] iArr3 = this.mFieldNumbers;
            int i6 = i2 + 1;
            System.arraycopy(iArr3, i2, iArr3, i6, i5 - i2);
            FieldData[] fieldDataArr4 = this.mData;
            System.arraycopy(fieldDataArr4, i2, fieldDataArr4, i6, this.mSize - i2);
        }
        this.mFieldNumbers[i2] = i;
        this.mData[i2] = fieldData;
        this.mSize++;
    }

    /* access modifiers changed from: package-private */
    public int size() {
        if (this.mGarbage) {
            gc();
        }
        return this.mSize;
    }

    public boolean isEmpty() {
        return size() == 0;
    }

    /* access modifiers changed from: package-private */
    public FieldData dataAt(int i) {
        if (this.mGarbage) {
            gc();
        }
        return this.mData[i];
    }

    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (!(obj instanceof FieldArray)) {
            return false;
        }
        FieldArray fieldArray = (FieldArray) obj;
        if (size() != fieldArray.size()) {
            return false;
        }
        if (!arrayEquals(this.mFieldNumbers, fieldArray.mFieldNumbers, this.mSize) || !arrayEquals(this.mData, fieldArray.mData, this.mSize)) {
            return false;
        }
        return true;
    }

    public int hashCode() {
        if (this.mGarbage) {
            gc();
        }
        int i = 17;
        for (int i2 = 0; i2 < this.mSize; i2++) {
            i = (((i * 31) + this.mFieldNumbers[i2]) * 31) + this.mData[i2].hashCode();
        }
        return i;
    }

    private int idealIntArraySize(int i) {
        return idealByteArraySize(i * 4) / 4;
    }

    private int binarySearch(int i) {
        int i2 = this.mSize - 1;
        int i3 = 0;
        while (i3 <= i2) {
            int i4 = (i3 + i2) >>> 1;
            int i5 = this.mFieldNumbers[i4];
            if (i5 < i) {
                i3 = i4 + 1;
            } else if (i5 <= i) {
                return i4;
            } else {
                i2 = i4 - 1;
            }
        }
        return ~i3;
    }

    private boolean arrayEquals(int[] iArr, int[] iArr2, int i) {
        for (int i2 = 0; i2 < i; i2++) {
            if (iArr[i2] != iArr2[i2]) {
                return false;
            }
        }
        return true;
    }

    private boolean arrayEquals(FieldData[] fieldDataArr, FieldData[] fieldDataArr2, int i) {
        for (int i2 = 0; i2 < i; i2++) {
            if (!fieldDataArr[i2].equals(fieldDataArr2[i2])) {
                return false;
            }
        }
        return true;
    }

    public final FieldArray clone() {
        int size = size();
        FieldArray fieldArray = new FieldArray(size);
        System.arraycopy(this.mFieldNumbers, 0, fieldArray.mFieldNumbers, 0, size);
        for (int i = 0; i < size; i++) {
            FieldData fieldData = this.mData[i];
            if (fieldData != null) {
                fieldArray.mData[i] = fieldData.clone();
            }
        }
        fieldArray.mSize = size;
        return fieldArray;
    }
}
