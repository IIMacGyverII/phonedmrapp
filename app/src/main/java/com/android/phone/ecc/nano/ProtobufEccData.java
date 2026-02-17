package com.android.phone.ecc.nano;

import java.io.IOException;

public interface ProtobufEccData {

    public static final class EccInfo extends ExtendableMessageNano<EccInfo> {
        private static volatile EccInfo[] _emptyArray;
        public String phoneNumber;
        public int[] types;

        public interface Type {
            public static final int AIEC = 7;
            public static final int AMBULANCE = 2;
            public static final int FIRE = 3;
            public static final int MARINE_GUARD = 4;
            public static final int MIEC = 6;
            public static final int MOUNTAIN_RESCUE = 5;
            public static final int POLICE = 1;
            public static final int TYPE_UNSPECIFIED = 0;
        }

        public static EccInfo[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new EccInfo[0];
                    }
                }
            }
            return _emptyArray;
        }

        public EccInfo() {
            clear();
        }

        public EccInfo clear() {
            this.phoneNumber = "";
            this.types = WireFormatNano.EMPTY_INT_ARRAY;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            if (!this.phoneNumber.equals("")) {
                codedOutputByteBufferNano.writeString(1, this.phoneNumber);
            }
            int[] iArr = this.types;
            if (iArr != null && iArr.length > 0) {
                int i = 0;
                int i2 = 0;
                int i3 = 0;
                while (true) {
                    int[] iArr2 = this.types;
                    if (i2 >= iArr2.length) {
                        break;
                    }
                    i3 += CodedOutputByteBufferNano.computeInt32SizeNoTag(iArr2[i2]);
                    i2++;
                }
                codedOutputByteBufferNano.writeRawVarint32(18);
                codedOutputByteBufferNano.writeRawVarint32(i3);
                while (true) {
                    int[] iArr3 = this.types;
                    if (i >= iArr3.length) {
                        break;
                    }
                    codedOutputByteBufferNano.writeRawVarint32(iArr3[i]);
                    i++;
                }
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            if (!this.phoneNumber.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(1, this.phoneNumber);
            }
            int[] iArr = this.types;
            if (iArr == null || iArr.length <= 0) {
                return computeSerializedSize;
            }
            int i = 0;
            int i2 = 0;
            while (true) {
                int[] iArr2 = this.types;
                if (i >= iArr2.length) {
                    return computeSerializedSize + i2 + 1 + CodedOutputByteBufferNano.computeRawVarint32Size(i2);
                }
                i2 += CodedOutputByteBufferNano.computeInt32SizeNoTag(iArr2[i]);
                i++;
            }
        }

        public EccInfo mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 10) {
                    this.phoneNumber = codedInputByteBufferNano.readString();
                } else if (readTag == 16) {
                    int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 16);
                    int[] iArr = new int[repeatedFieldArrayLength];
                    int i = 0;
                    for (int i2 = 0; i2 < repeatedFieldArrayLength; i2++) {
                        if (i2 != 0) {
                            codedInputByteBufferNano.readTag();
                        }
                        int readInt32 = codedInputByteBufferNano.readInt32();
                        switch (readInt32) {
                            case 0:
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                            case 6:
                            case 7:
                                iArr[i] = readInt32;
                                i++;
                                break;
                        }
                    }
                    if (i != 0) {
                        int[] iArr2 = this.types;
                        int length = iArr2 == null ? 0 : iArr2.length;
                        if (length == 0 && i == repeatedFieldArrayLength) {
                            this.types = iArr;
                        } else {
                            int[] iArr3 = new int[(length + i)];
                            if (length != 0) {
                                System.arraycopy(iArr2, 0, iArr3, 0, length);
                            }
                            System.arraycopy(iArr, 0, iArr3, length, i);
                            this.types = iArr3;
                        }
                    }
                } else if (readTag == 18) {
                    int pushLimit = codedInputByteBufferNano.pushLimit(codedInputByteBufferNano.readRawVarint32());
                    int position = codedInputByteBufferNano.getPosition();
                    int i3 = 0;
                    while (codedInputByteBufferNano.getBytesUntilLimit() > 0) {
                        switch (codedInputByteBufferNano.readInt32()) {
                            case 0:
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                            case 6:
                            case 7:
                                i3++;
                                break;
                        }
                    }
                    if (i3 != 0) {
                        codedInputByteBufferNano.rewindToPosition(position);
                        int[] iArr4 = this.types;
                        int length2 = iArr4 == null ? 0 : iArr4.length;
                        int[] iArr5 = new int[(i3 + length2)];
                        if (length2 != 0) {
                            System.arraycopy(iArr4, 0, iArr5, 0, length2);
                        }
                        while (codedInputByteBufferNano.getBytesUntilLimit() > 0) {
                            int readInt322 = codedInputByteBufferNano.readInt32();
                            switch (readInt322) {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                    iArr5[length2] = readInt322;
                                    length2++;
                                    break;
                            }
                        }
                        this.types = iArr5;
                    }
                    codedInputByteBufferNano.popLimit(pushLimit);
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static EccInfo parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (EccInfo) MessageNano.mergeFrom(new EccInfo(), bArr);
        }

        public static EccInfo parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new EccInfo().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class CountryInfo extends ExtendableMessageNano<CountryInfo> {
        private static volatile CountryInfo[] _emptyArray;
        public String eccFallback;
        public EccInfo[] eccs;
        public String isoCode;

        public static CountryInfo[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new CountryInfo[0];
                    }
                }
            }
            return _emptyArray;
        }

        public CountryInfo() {
            clear();
        }

        public CountryInfo clear() {
            this.isoCode = "";
            this.eccs = EccInfo.emptyArray();
            this.eccFallback = "";
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            if (!this.isoCode.equals("")) {
                codedOutputByteBufferNano.writeString(1, this.isoCode);
            }
            EccInfo[] eccInfoArr = this.eccs;
            if (eccInfoArr != null && eccInfoArr.length > 0) {
                int i = 0;
                while (true) {
                    EccInfo[] eccInfoArr2 = this.eccs;
                    if (i >= eccInfoArr2.length) {
                        break;
                    }
                    EccInfo eccInfo = eccInfoArr2[i];
                    if (eccInfo != null) {
                        codedOutputByteBufferNano.writeMessage(2, eccInfo);
                    }
                    i++;
                }
            }
            if (!this.eccFallback.equals("")) {
                codedOutputByteBufferNano.writeString(3, this.eccFallback);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            if (!this.isoCode.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(1, this.isoCode);
            }
            EccInfo[] eccInfoArr = this.eccs;
            if (eccInfoArr != null && eccInfoArr.length > 0) {
                int i = 0;
                while (true) {
                    EccInfo[] eccInfoArr2 = this.eccs;
                    if (i >= eccInfoArr2.length) {
                        break;
                    }
                    EccInfo eccInfo = eccInfoArr2[i];
                    if (eccInfo != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(2, eccInfo);
                    }
                    i++;
                }
            }
            return !this.eccFallback.equals("") ? computeSerializedSize + CodedOutputByteBufferNano.computeStringSize(3, this.eccFallback) : computeSerializedSize;
        }

        public CountryInfo mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 10) {
                    this.isoCode = codedInputByteBufferNano.readString();
                } else if (readTag == 18) {
                    int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 18);
                    EccInfo[] eccInfoArr = this.eccs;
                    int length = eccInfoArr == null ? 0 : eccInfoArr.length;
                    int i = repeatedFieldArrayLength + length;
                    EccInfo[] eccInfoArr2 = new EccInfo[i];
                    if (length != 0) {
                        System.arraycopy(eccInfoArr, 0, eccInfoArr2, 0, length);
                    }
                    while (length < i - 1) {
                        EccInfo eccInfo = new EccInfo();
                        eccInfoArr2[length] = eccInfo;
                        codedInputByteBufferNano.readMessage(eccInfo);
                        codedInputByteBufferNano.readTag();
                        length++;
                    }
                    EccInfo eccInfo2 = new EccInfo();
                    eccInfoArr2[length] = eccInfo2;
                    codedInputByteBufferNano.readMessage(eccInfo2);
                    this.eccs = eccInfoArr2;
                } else if (readTag == 26) {
                    this.eccFallback = codedInputByteBufferNano.readString();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static CountryInfo parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (CountryInfo) MessageNano.mergeFrom(new CountryInfo(), bArr);
        }

        public static CountryInfo parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new CountryInfo().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class AllInfo extends ExtendableMessageNano<AllInfo> {
        private static volatile AllInfo[] _emptyArray;
        public CountryInfo[] countries;
        public int revision;

        public static AllInfo[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new AllInfo[0];
                    }
                }
            }
            return _emptyArray;
        }

        public AllInfo() {
            clear();
        }

        public AllInfo clear() {
            this.revision = 0;
            this.countries = CountryInfo.emptyArray();
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            int i = this.revision;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(1, i);
            }
            CountryInfo[] countryInfoArr = this.countries;
            if (countryInfoArr != null && countryInfoArr.length > 0) {
                int i2 = 0;
                while (true) {
                    CountryInfo[] countryInfoArr2 = this.countries;
                    if (i2 >= countryInfoArr2.length) {
                        break;
                    }
                    CountryInfo countryInfo = countryInfoArr2[i2];
                    if (countryInfo != null) {
                        codedOutputByteBufferNano.writeMessage(2, countryInfo);
                    }
                    i2++;
                }
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            int i = this.revision;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(1, i);
            }
            CountryInfo[] countryInfoArr = this.countries;
            if (countryInfoArr != null && countryInfoArr.length > 0) {
                int i2 = 0;
                while (true) {
                    CountryInfo[] countryInfoArr2 = this.countries;
                    if (i2 >= countryInfoArr2.length) {
                        break;
                    }
                    CountryInfo countryInfo = countryInfoArr2[i2];
                    if (countryInfo != null) {
                        computeSerializedSize += CodedOutputByteBufferNano.computeMessageSize(2, countryInfo);
                    }
                    i2++;
                }
            }
            return computeSerializedSize;
        }

        public AllInfo mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 8) {
                    this.revision = codedInputByteBufferNano.readInt32();
                } else if (readTag == 18) {
                    int repeatedFieldArrayLength = WireFormatNano.getRepeatedFieldArrayLength(codedInputByteBufferNano, 18);
                    CountryInfo[] countryInfoArr = this.countries;
                    int length = countryInfoArr == null ? 0 : countryInfoArr.length;
                    int i = repeatedFieldArrayLength + length;
                    CountryInfo[] countryInfoArr2 = new CountryInfo[i];
                    if (length != 0) {
                        System.arraycopy(countryInfoArr, 0, countryInfoArr2, 0, length);
                    }
                    while (length < i - 1) {
                        CountryInfo countryInfo = new CountryInfo();
                        countryInfoArr2[length] = countryInfo;
                        codedInputByteBufferNano.readMessage(countryInfo);
                        codedInputByteBufferNano.readTag();
                        length++;
                    }
                    CountryInfo countryInfo2 = new CountryInfo();
                    countryInfoArr2[length] = countryInfo2;
                    codedInputByteBufferNano.readMessage(countryInfo2);
                    this.countries = countryInfoArr2;
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static AllInfo parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (AllInfo) MessageNano.mergeFrom(new AllInfo(), bArr);
        }

        public static AllInfo parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new AllInfo().mergeFrom(codedInputByteBufferNano);
        }
    }
}
