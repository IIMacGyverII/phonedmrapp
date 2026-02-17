package com.android.internal.telephony.nano;

import com.android.internal.telephony.protobuf.nano.CodedInputByteBufferNano;
import com.android.internal.telephony.protobuf.nano.CodedOutputByteBufferNano;
import com.android.internal.telephony.protobuf.nano.ExtendableMessageNano;
import com.android.internal.telephony.protobuf.nano.InternalNano;
import com.android.internal.telephony.protobuf.nano.InvalidProtocolBufferNanoException;
import com.android.internal.telephony.protobuf.nano.MessageNano;
import com.android.internal.telephony.protobuf.nano.WireFormatNano;
import java.io.IOException;

public interface CarrierIdProto {

    public static final class CarrierList extends ExtendableMessageNano<CarrierList> {
        private static volatile CarrierList[] _emptyArray;
        public CarrierId[] carrierId;
        public int version;

        public static CarrierList[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new CarrierList[0];
                    }
                }
            }
            return _emptyArray;
        }

        public CarrierList() {
            clear();
        }

        public CarrierList clear() {
            this.carrierId = CarrierId.emptyArray();
            this.version = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            CarrierId[] carrierIdArr = this.carrierId;
            if (carrierIdArr != null && carrierIdArr.length > 0) {
                int i = 0;
                while (true) {
                    CarrierId[] carrierIdArr2 = this.carrierId;
                    if (i >= carrierIdArr2.length) {
                        break;
                    }
                    CarrierId carrierId2 = carrierIdArr2[i];
                    if (carrierId2 != null) {
                        codedOutputByteBufferNano.writeMessage(1, carrierId2);
                    }
                    i++;
                }
            }
            int i2 = this.version;
            if (i2 != 0) {
                codedOutputByteBufferNano.writeInt32(2, i2);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            CarrierId[] carrierIdArr = this.carrierId;
            if (carrierIdArr != null && carrierIdArr.length > 0) {
                int i = 0;
                while (true) {
                    CarrierId[] carrierIdArr2 = this.carrierId;
                    if (i >= carrierIdArr2.length) {
                        break;
                    }
                    CarrierId carrierId2 = carrierIdArr2[i];
                    if (carrierId2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(1, carrierId2);
                    }
                    i++;
                }
            }
            int i2 = this.version;
            return i2 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(2, i2) : computeSerializedSize;
        }

        public CarrierList mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 10) {
                    int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 10);
                    CarrierId[] carrierIdArr = this.carrierId;
                    int length = carrierIdArr == null ? 0 : carrierIdArr.length;
                    int i = repeatedFieldArrayLength + length;
                    CarrierId[] carrierIdArr2 = new CarrierId[i];
                    if (length != 0) {
                        System.arraycopy(carrierIdArr, 0, carrierIdArr2, 0, length);
                    }
                    while (length < i - 1) {
                        CarrierId carrierId2 = new CarrierId();
                        carrierIdArr2[length] = carrierId2;
                        codedInputByteBufferNano.readMessage(carrierId2);
                        codedInputByteBufferNano.readTag();
                        length++;
                    }
                    CarrierId carrierId3 = new CarrierId();
                    carrierIdArr2[length] = carrierId3;
                    codedInputByteBufferNano.readMessage(carrierId3);
                    this.carrierId = carrierIdArr2;
                } else if (readTag == 16) {
                    this.version = codedInputByteBufferNano.readInt32();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static CarrierList parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (CarrierList) MessageNano.mergeFrom(new CarrierList(), bArr);
        }

        public static CarrierList parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new CarrierList().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class CarrierId extends ExtendableMessageNano<CarrierId> {
        private static volatile CarrierId[] _emptyArray;
        public int canonicalId;
        public CarrierAttribute[] carrierAttribute;
        public String carrierName;
        public int parentCanonicalId;

        public static CarrierId[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new CarrierId[0];
                    }
                }
            }
            return _emptyArray;
        }

        public CarrierId() {
            clear();
        }

        public CarrierId clear() {
            this.canonicalId = 0;
            this.carrierName = "";
            this.carrierAttribute = CarrierAttribute.emptyArray();
            this.parentCanonicalId = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.canonicalId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            if (!this.carrierName.equals("")) {
                codedOutputByteBufferNano.writeString(2, this.carrierName);
            }
            CarrierAttribute[] carrierAttributeArr = this.carrierAttribute;
            if (carrierAttributeArr != null && carrierAttributeArr.length > 0) {
                int i2 = 0;
                while (true) {
                    CarrierAttribute[] carrierAttributeArr2 = this.carrierAttribute;
                    if (i2 >= carrierAttributeArr2.length) {
                        break;
                    }
                    CarrierAttribute carrierAttribute2 = carrierAttributeArr2[i2];
                    if (carrierAttribute2 != null) {
                        codedOutputByteBufferNano.writeMessage(3, carrierAttribute2);
                    }
                    i2++;
                }
            }
            int i3 = this.parentCanonicalId;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(4, i3);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.canonicalId;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            if (!this.carrierName.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(2, this.carrierName);
            }
            CarrierAttribute[] carrierAttributeArr = this.carrierAttribute;
            if (carrierAttributeArr != null && carrierAttributeArr.length > 0) {
                int i2 = 0;
                while (true) {
                    CarrierAttribute[] carrierAttributeArr2 = this.carrierAttribute;
                    if (i2 >= carrierAttributeArr2.length) {
                        break;
                    }
                    CarrierAttribute carrierAttribute2 = carrierAttributeArr2[i2];
                    if (carrierAttribute2 != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(3, carrierAttribute2);
                    }
                    i2++;
                }
            }
            int i3 = this.parentCanonicalId;
            return i3 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(4, i3) : computeSerializedSize;
        }

        public CarrierId mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.canonicalId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 18) {
                    this.carrierName = codedInputByteBufferNano.readString();
                } else if (readTag == 26) {
                    int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 26);
                    CarrierAttribute[] carrierAttributeArr = this.carrierAttribute;
                    int length = carrierAttributeArr == null ? 0 : carrierAttributeArr.length;
                    int i = repeatedFieldArrayLength + length;
                    CarrierAttribute[] carrierAttributeArr2 = new CarrierAttribute[i];
                    if (length != 0) {
                        System.arraycopy(carrierAttributeArr, 0, carrierAttributeArr2, 0, length);
                    }
                    while (length < i - 1) {
                        CarrierAttribute carrierAttribute2 = new CarrierAttribute();
                        carrierAttributeArr2[length] = carrierAttribute2;
                        codedInputByteBufferNano.readMessage(carrierAttribute2);
                        codedInputByteBufferNano.readTag();
                        length++;
                    }
                    CarrierAttribute carrierAttribute3 = new CarrierAttribute();
                    carrierAttributeArr2[length] = carrierAttribute3;
                    codedInputByteBufferNano.readMessage(carrierAttribute3);
                    this.carrierAttribute = carrierAttributeArr2;
                } else if (readTag == 32) {
                    this.parentCanonicalId = codedInputByteBufferNano.readInt32();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static CarrierId parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (CarrierId) MessageNano.mergeFrom(new CarrierId(), bArr);
        }

        public static CarrierId parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new CarrierId().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class CarrierAttribute extends ExtendableMessageNano<CarrierAttribute> {
        private static volatile CarrierAttribute[] _emptyArray;
        public String[] gid1;
        public String[] gid2;
        public String[] iccidPrefix;
        public String[] imsiPrefixXpattern;
        public String[] mccmncTuple;
        public String[] plmn;
        public String[] preferredApn;
        public String[] privilegeAccessRule;
        public String[] spn;

        public static CarrierAttribute[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new CarrierAttribute[0];
                    }
                }
            }
            return _emptyArray;
        }

        public CarrierAttribute() {
            clear();
        }

        public CarrierAttribute clear() {
            String[] strArr = WireFormatNano.EMPTY_STRING_ARRAY;
            this.mccmncTuple = strArr;
            this.imsiPrefixXpattern = strArr;
            this.spn = strArr;
            this.plmn = strArr;
            this.gid1 = strArr;
            this.gid2 = strArr;
            this.preferredApn = strArr;
            this.iccidPrefix = strArr;
            this.privilegeAccessRule = strArr;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            String[] strArr = this.mccmncTuple;
            int i = 0;
            if (strArr != null && strArr.length > 0) {
                int i2 = 0;
                while (true) {
                    String[] strArr2 = this.mccmncTuple;
                    if (i2 >= strArr2.length) {
                        break;
                    }
                    String str = strArr2[i2];
                    if (str != null) {
                        codedOutputByteBufferNano.writeString(1, str);
                    }
                    i2++;
                }
            }
            String[] strArr3 = this.imsiPrefixXpattern;
            if (strArr3 != null && strArr3.length > 0) {
                int i3 = 0;
                while (true) {
                    String[] strArr4 = this.imsiPrefixXpattern;
                    if (i3 >= strArr4.length) {
                        break;
                    }
                    String str2 = strArr4[i3];
                    if (str2 != null) {
                        codedOutputByteBufferNano.writeString(2, str2);
                    }
                    i3++;
                }
            }
            String[] strArr5 = this.spn;
            if (strArr5 != null && strArr5.length > 0) {
                int i4 = 0;
                while (true) {
                    String[] strArr6 = this.spn;
                    if (i4 >= strArr6.length) {
                        break;
                    }
                    String str3 = strArr6[i4];
                    if (str3 != null) {
                        codedOutputByteBufferNano.writeString(3, str3);
                    }
                    i4++;
                }
            }
            String[] strArr7 = this.plmn;
            if (strArr7 != null && strArr7.length > 0) {
                int i5 = 0;
                while (true) {
                    String[] strArr8 = this.plmn;
                    if (i5 >= strArr8.length) {
                        break;
                    }
                    String str4 = strArr8[i5];
                    if (str4 != null) {
                        codedOutputByteBufferNano.writeString(4, str4);
                    }
                    i5++;
                }
            }
            String[] strArr9 = this.gid1;
            if (strArr9 != null && strArr9.length > 0) {
                int i6 = 0;
                while (true) {
                    String[] strArr10 = this.gid1;
                    if (i6 >= strArr10.length) {
                        break;
                    }
                    String str5 = strArr10[i6];
                    if (str5 != null) {
                        codedOutputByteBufferNano.writeString(5, str5);
                    }
                    i6++;
                }
            }
            String[] strArr11 = this.gid2;
            if (strArr11 != null && strArr11.length > 0) {
                int i7 = 0;
                while (true) {
                    String[] strArr12 = this.gid2;
                    if (i7 >= strArr12.length) {
                        break;
                    }
                    String str6 = strArr12[i7];
                    if (str6 != null) {
                        codedOutputByteBufferNano.writeString(6, str6);
                    }
                    i7++;
                }
            }
            String[] strArr13 = this.preferredApn;
            if (strArr13 != null && strArr13.length > 0) {
                int i8 = 0;
                while (true) {
                    String[] strArr14 = this.preferredApn;
                    if (i8 >= strArr14.length) {
                        break;
                    }
                    String str7 = strArr14[i8];
                    if (str7 != null) {
                        codedOutputByteBufferNano.writeString(7, str7);
                    }
                    i8++;
                }
            }
            String[] strArr15 = this.iccidPrefix;
            if (strArr15 != null && strArr15.length > 0) {
                int i9 = 0;
                while (true) {
                    String[] strArr16 = this.iccidPrefix;
                    if (i9 >= strArr16.length) {
                        break;
                    }
                    String str8 = strArr16[i9];
                    if (str8 != null) {
                        codedOutputByteBufferNano.writeString(8, str8);
                    }
                    i9++;
                }
            }
            String[] strArr17 = this.privilegeAccessRule;
            if (strArr17 != null && strArr17.length > 0) {
                while (true) {
                    String[] strArr18 = this.privilegeAccessRule;
                    if (i >= strArr18.length) {
                        break;
                    }
                    String str9 = strArr18[i];
                    if (str9 != null) {
                        codedOutputByteBufferNano.writeString(9, str9);
                    }
                    i++;
                }
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            String[] strArr = this.mccmncTuple;
            int i = 0;
            if (strArr != null && strArr.length > 0) {
                int i2 = 0;
                int i3 = 0;
                int i4 = 0;
                while (true) {
                    String[] strArr2 = this.mccmncTuple;
                    if (i2 >= strArr2.length) {
                        break;
                    }
                    String str = strArr2[i2];
                    if (str != null) {
                        i4++;
                        i3 += CodedOutputByteBufferNano.computeStringSizeNoTag(str);
                    }
                    i2++;
                }
                computeSerializedSize = computeSerializedSize + i3 + (i4 * 1);
            }
            String[] strArr3 = this.imsiPrefixXpattern;
            if (strArr3 != null && strArr3.length > 0) {
                int i5 = 0;
                int i6 = 0;
                int i7 = 0;
                while (true) {
                    String[] strArr4 = this.imsiPrefixXpattern;
                    if (i5 >= strArr4.length) {
                        break;
                    }
                    String str2 = strArr4[i5];
                    if (str2 != null) {
                        i7++;
                        i6 += CodedOutputByteBufferNano.computeStringSizeNoTag(str2);
                    }
                    i5++;
                }
                computeSerializedSize = computeSerializedSize + i6 + (i7 * 1);
            }
            String[] strArr5 = this.spn;
            if (strArr5 != null && strArr5.length > 0) {
                int i8 = 0;
                int i9 = 0;
                int i10 = 0;
                while (true) {
                    String[] strArr6 = this.spn;
                    if (i8 >= strArr6.length) {
                        break;
                    }
                    String str3 = strArr6[i8];
                    if (str3 != null) {
                        i10++;
                        i9 += CodedOutputByteBufferNano.computeStringSizeNoTag(str3);
                    }
                    i8++;
                }
                computeSerializedSize = computeSerializedSize + i9 + (i10 * 1);
            }
            String[] strArr7 = this.plmn;
            if (strArr7 != null && strArr7.length > 0) {
                int i11 = 0;
                int i12 = 0;
                int i13 = 0;
                while (true) {
                    String[] strArr8 = this.plmn;
                    if (i11 >= strArr8.length) {
                        break;
                    }
                    String str4 = strArr8[i11];
                    if (str4 != null) {
                        i13++;
                        i12 += CodedOutputByteBufferNano.computeStringSizeNoTag(str4);
                    }
                    i11++;
                }
                computeSerializedSize = computeSerializedSize + i12 + (i13 * 1);
            }
            String[] strArr9 = this.gid1;
            if (strArr9 != null && strArr9.length > 0) {
                int i14 = 0;
                int i15 = 0;
                int i16 = 0;
                while (true) {
                    String[] strArr10 = this.gid1;
                    if (i14 >= strArr10.length) {
                        break;
                    }
                    String str5 = strArr10[i14];
                    if (str5 != null) {
                        i16++;
                        i15 += CodedOutputByteBufferNano.computeStringSizeNoTag(str5);
                    }
                    i14++;
                }
                computeSerializedSize = computeSerializedSize + i15 + (i16 * 1);
            }
            String[] strArr11 = this.gid2;
            if (strArr11 != null && strArr11.length > 0) {
                int i17 = 0;
                int i18 = 0;
                int i19 = 0;
                while (true) {
                    String[] strArr12 = this.gid2;
                    if (i17 >= strArr12.length) {
                        break;
                    }
                    String str6 = strArr12[i17];
                    if (str6 != null) {
                        i19++;
                        i18 += CodedOutputByteBufferNano.computeStringSizeNoTag(str6);
                    }
                    i17++;
                }
                computeSerializedSize = computeSerializedSize + i18 + (i19 * 1);
            }
            String[] strArr13 = this.preferredApn;
            if (strArr13 != null && strArr13.length > 0) {
                int i20 = 0;
                int i21 = 0;
                int i22 = 0;
                while (true) {
                    String[] strArr14 = this.preferredApn;
                    if (i20 >= strArr14.length) {
                        break;
                    }
                    String str7 = strArr14[i20];
                    if (str7 != null) {
                        i22++;
                        i21 += CodedOutputByteBufferNano.computeStringSizeNoTag(str7);
                    }
                    i20++;
                }
                computeSerializedSize = computeSerializedSize + i21 + (i22 * 1);
            }
            String[] strArr15 = this.iccidPrefix;
            if (strArr15 != null && strArr15.length > 0) {
                int i23 = 0;
                int i24 = 0;
                int i25 = 0;
                while (true) {
                    String[] strArr16 = this.iccidPrefix;
                    if (i23 >= strArr16.length) {
                        break;
                    }
                    String str8 = strArr16[i23];
                    if (str8 != null) {
                        i25++;
                        i24 += CodedOutputByteBufferNano.computeStringSizeNoTag(str8);
                    }
                    i23++;
                }
                computeSerializedSize = computeSerializedSize + i24 + (i25 * 1);
            }
            String[] strArr17 = this.privilegeAccessRule;
            if (strArr17 == null || strArr17.length <= 0) {
                return computeSerializedSize;
            }
            int i26 = 0;
            int i27 = 0;
            while (true) {
                String[] strArr18 = this.privilegeAccessRule;
                if (i >= strArr18.length) {
                    return computeSerializedSize + i26 + (i27 * 1);
                }
                String str9 = strArr18[i];
                if (str9 != null) {
                    i27++;
                    i26 += CodedOutputByteBufferNano.computeStringSizeNoTag(str9);
                }
                i++;
            }
        }

        public CarrierAttribute mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 10) {
                    int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 10);
                    String[] strArr = this.mccmncTuple;
                    int length = strArr == null ? 0 : strArr.length;
                    int i = repeatedFieldArrayLength + length;
                    String[] strArr2 = new String[i];
                    if (length != 0) {
                        System.arraycopy(strArr, 0, strArr2, 0, length);
                    }
                    while (length < i - 1) {
                        strArr2[length] = codedInputByteBufferNano.readString();
                        codedInputByteBufferNano.readTag();
                        length++;
                    }
                    strArr2[length] = codedInputByteBufferNano.readString();
                    this.mccmncTuple = strArr2;
                } else if (readTag == 18) {
                    int repeatedFieldArrayLength2 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 18);
                    String[] strArr3 = this.imsiPrefixXpattern;
                    int length2 = strArr3 == null ? 0 : strArr3.length;
                    int i2 = repeatedFieldArrayLength2 + length2;
                    String[] strArr4 = new String[i2];
                    if (length2 != 0) {
                        System.arraycopy(strArr3, 0, strArr4, 0, length2);
                    }
                    while (length2 < i2 - 1) {
                        strArr4[length2] = codedInputByteBufferNano.readString();
                        codedInputByteBufferNano.readTag();
                        length2++;
                    }
                    strArr4[length2] = codedInputByteBufferNano.readString();
                    this.imsiPrefixXpattern = strArr4;
                } else if (readTag == 26) {
                    int repeatedFieldArrayLength3 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 26);
                    String[] strArr5 = this.spn;
                    int length3 = strArr5 == null ? 0 : strArr5.length;
                    int i3 = repeatedFieldArrayLength3 + length3;
                    String[] strArr6 = new String[i3];
                    if (length3 != 0) {
                        System.arraycopy(strArr5, 0, strArr6, 0, length3);
                    }
                    while (length3 < i3 - 1) {
                        strArr6[length3] = codedInputByteBufferNano.readString();
                        codedInputByteBufferNano.readTag();
                        length3++;
                    }
                    strArr6[length3] = codedInputByteBufferNano.readString();
                    this.spn = strArr6;
                } else if (readTag == 34) {
                    int repeatedFieldArrayLength4 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 34);
                    String[] strArr7 = this.plmn;
                    int length4 = strArr7 == null ? 0 : strArr7.length;
                    int i4 = repeatedFieldArrayLength4 + length4;
                    String[] strArr8 = new String[i4];
                    if (length4 != 0) {
                        System.arraycopy(strArr7, 0, strArr8, 0, length4);
                    }
                    while (length4 < i4 - 1) {
                        strArr8[length4] = codedInputByteBufferNano.readString();
                        codedInputByteBufferNano.readTag();
                        length4++;
                    }
                    strArr8[length4] = codedInputByteBufferNano.readString();
                    this.plmn = strArr8;
                } else if (readTag == 42) {
                    int repeatedFieldArrayLength5 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 42);
                    String[] strArr9 = this.gid1;
                    int length5 = strArr9 == null ? 0 : strArr9.length;
                    int i5 = repeatedFieldArrayLength5 + length5;
                    String[] strArr10 = new String[i5];
                    if (length5 != 0) {
                        System.arraycopy(strArr9, 0, strArr10, 0, length5);
                    }
                    while (length5 < i5 - 1) {
                        strArr10[length5] = codedInputByteBufferNano.readString();
                        codedInputByteBufferNano.readTag();
                        length5++;
                    }
                    strArr10[length5] = codedInputByteBufferNano.readString();
                    this.gid1 = strArr10;
                } else if (readTag == 50) {
                    int repeatedFieldArrayLength6 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 50);
                    String[] strArr11 = this.gid2;
                    int length6 = strArr11 == null ? 0 : strArr11.length;
                    int i6 = repeatedFieldArrayLength6 + length6;
                    String[] strArr12 = new String[i6];
                    if (length6 != 0) {
                        System.arraycopy(strArr11, 0, strArr12, 0, length6);
                    }
                    while (length6 < i6 - 1) {
                        strArr12[length6] = codedInputByteBufferNano.readString();
                        codedInputByteBufferNano.readTag();
                        length6++;
                    }
                    strArr12[length6] = codedInputByteBufferNano.readString();
                    this.gid2 = strArr12;
                } else if (readTag == 58) {
                    int repeatedFieldArrayLength7 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 58);
                    String[] strArr13 = this.preferredApn;
                    int length7 = strArr13 == null ? 0 : strArr13.length;
                    int i7 = repeatedFieldArrayLength7 + length7;
                    String[] strArr14 = new String[i7];
                    if (length7 != 0) {
                        System.arraycopy(strArr13, 0, strArr14, 0, length7);
                    }
                    while (length7 < i7 - 1) {
                        strArr14[length7] = codedInputByteBufferNano.readString();
                        codedInputByteBufferNano.readTag();
                        length7++;
                    }
                    strArr14[length7] = codedInputByteBufferNano.readString();
                    this.preferredApn = strArr14;
                } else if (readTag == 66) {
                    int repeatedFieldArrayLength8 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 66);
                    String[] strArr15 = this.iccidPrefix;
                    int length8 = strArr15 == null ? 0 : strArr15.length;
                    int i8 = repeatedFieldArrayLength8 + length8;
                    String[] strArr16 = new String[i8];
                    if (length8 != 0) {
                        System.arraycopy(strArr15, 0, strArr16, 0, length8);
                    }
                    while (length8 < i8 - 1) {
                        strArr16[length8] = codedInputByteBufferNano.readString();
                        codedInputByteBufferNano.readTag();
                        length8++;
                    }
                    strArr16[length8] = codedInputByteBufferNano.readString();
                    this.iccidPrefix = strArr16;
                } else if (readTag == 74) {
                    int repeatedFieldArrayLength9 = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 74);
                    String[] strArr17 = this.privilegeAccessRule;
                    int length9 = strArr17 == null ? 0 : strArr17.length;
                    int i9 = repeatedFieldArrayLength9 + length9;
                    String[] strArr18 = new String[i9];
                    if (length9 != 0) {
                        System.arraycopy(strArr17, 0, strArr18, 0, length9);
                    }
                    while (length9 < i9 - 1) {
                        strArr18[length9] = codedInputByteBufferNano.readString();
                        codedInputByteBufferNano.readTag();
                        length9++;
                    }
                    strArr18[length9] = codedInputByteBufferNano.readString();
                    this.privilegeAccessRule = strArr18;
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static CarrierAttribute parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (CarrierAttribute) MessageNano.mergeFrom(new CarrierAttribute(), bArr);
        }

        public static CarrierAttribute parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new CarrierAttribute().mergeFrom(codedInputByteBufferNano);
        }
    }
}
