package com.android.internal.telephony.nano;

import com.android.internal.telephony.protobuf.nano.CodedInputByteBufferNano;
import com.android.internal.telephony.protobuf.nano.CodedOutputByteBufferNano;
import com.android.internal.telephony.protobuf.nano.ExtendableMessageNano;
import com.android.internal.telephony.protobuf.nano.InternalNano;
import com.android.internal.telephony.protobuf.nano.InvalidProtocolBufferNanoException;
import com.android.internal.telephony.protobuf.nano.MessageNano;
import com.android.internal.telephony.protobuf.nano.WireFormatNano;
import java.io.IOException;
import java.util.Arrays;

public interface StoredPinProto {

    public static final class StoredPin extends ExtendableMessageNano<StoredPin> {
        private static volatile StoredPin[] _emptyArray;
        public int bootCount;
        public String iccid;
        public String pin;
        public int slotId;
        public int status;

        public interface PinStatus {
            public static final int AVAILABLE = 1;
            public static final int REBOOT_READY = 2;
            public static final int VERIFICATION_READY = 3;
        }

        public static StoredPin[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new StoredPin[0];
                    }
                }
            }
            return _emptyArray;
        }

        public StoredPin() {
            clear();
        }

        public StoredPin clear() {
            this.iccid = "";
            this.pin = "";
            this.slotId = 0;
            this.status = 1;
            this.bootCount = 0;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            if (!this.iccid.equals("")) {
                codedOutputByteBufferNano.writeString(1, this.iccid);
            }
            if (!this.pin.equals("")) {
                codedOutputByteBufferNano.writeString(2, this.pin);
            }
            int i = this.slotId;
            if (i != 0) {
                codedOutputByteBufferNano.writeInt32(3, i);
            }
            int i2 = this.status;
            if (i2 != 1) {
                codedOutputByteBufferNano.writeInt32(4, i2);
            }
            int i3 = this.bootCount;
            if (i3 != 0) {
                codedOutputByteBufferNano.writeInt32(5, i3);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            if (!this.iccid.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(1, this.iccid);
            }
            if (!this.pin.equals("")) {
                computeSerializedSize += CodedOutputByteBufferNano.computeStringSize(2, this.pin);
            }
            int i = this.slotId;
            if (i != 0) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(3, i);
            }
            int i2 = this.status;
            if (i2 != 1) {
                computeSerializedSize += CodedOutputByteBufferNano.computeInt32Size(4, i2);
            }
            int i3 = this.bootCount;
            return i3 != 0 ? computeSerializedSize + CodedOutputByteBufferNano.computeInt32Size(5, i3) : computeSerializedSize;
        }

        public StoredPin mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 10) {
                    this.iccid = codedInputByteBufferNano.readString();
                } else if (readTag == 18) {
                    this.pin = codedInputByteBufferNano.readString();
                } else if (readTag == 24) {
                    this.slotId = codedInputByteBufferNano.readInt32();
                } else if (readTag == 32) {
                    int readInt32 = codedInputByteBufferNano.readInt32();
                    if (readInt32 == 1 || readInt32 == 2 || readInt32 == 3) {
                        this.status = readInt32;
                    }
                } else if (readTag == 40) {
                    this.bootCount = codedInputByteBufferNano.readInt32();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static StoredPin parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (StoredPin) MessageNano.mergeFrom(new StoredPin(), bArr);
        }

        public static StoredPin parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new StoredPin().mergeFrom(codedInputByteBufferNano);
        }
    }

    public static final class EncryptedPin extends ExtendableMessageNano<EncryptedPin> {
        private static volatile EncryptedPin[] _emptyArray;
        public byte[] encryptedStoredPin;
        public byte[] iv;

        public static EncryptedPin[] emptyArray() {
            if (_emptyArray == null) {
                synchronized (InternalNano.LAZY_INIT_LOCK) {
                    if (_emptyArray == null) {
                        _emptyArray = new EncryptedPin[0];
                    }
                }
            }
            return _emptyArray;
        }

        public EncryptedPin() {
            clear();
        }

        public EncryptedPin clear() {
            byte[] bArr = WireFormatNano.EMPTY_BYTES;
            this.encryptedStoredPin = bArr;
            this.iv = bArr;
            this.unknownFieldData = null;
            this.cachedSize = -1;
            return this;
        }

        public void writeTo(CodedOutputByteBufferNano codedOutputByteBufferNano) throws IOException {
            byte[] bArr = this.encryptedStoredPin;
            byte[] bArr2 = WireFormatNano.EMPTY_BYTES;
            if (!Arrays.equals(bArr, bArr2)) {
                codedOutputByteBufferNano.writeBytes(1, this.encryptedStoredPin);
            }
            if (!Arrays.equals(this.iv, bArr2)) {
                codedOutputByteBufferNano.writeBytes(2, this.iv);
            }
            super.writeTo(codedOutputByteBufferNano);
        }

        /* access modifiers changed from: protected */
        public int computeSerializedSize() {
            int computeSerializedSize = super.computeSerializedSize();
            byte[] bArr = this.encryptedStoredPin;
            byte[] bArr2 = WireFormatNano.EMPTY_BYTES;
            if (!Arrays.equals(bArr, bArr2)) {
                computeSerializedSize += CodedOutputByteBufferNano.computeBytesSize(1, this.encryptedStoredPin);
            }
            return !Arrays.equals(this.iv, bArr2) ? computeSerializedSize + CodedOutputByteBufferNano.computeBytesSize(2, this.iv) : computeSerializedSize;
        }

        public EncryptedPin mergeFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            while (true) {
                int readTag = codedInputByteBufferNano.readTag();
                if (readTag == 0) {
                    return this;
                }
                if (readTag == 10) {
                    this.encryptedStoredPin = codedInputByteBufferNano.readBytes();
                } else if (readTag == 18) {
                    this.iv = codedInputByteBufferNano.readBytes();
                } else if (!storeUnknownField(codedInputByteBufferNano, readTag)) {
                    return this;
                }
            }
        }

        public static EncryptedPin parseFrom(byte[] bArr) throws InvalidProtocolBufferNanoException {
            return (EncryptedPin) MessageNano.mergeFrom(new EncryptedPin(), bArr);
        }

        public static EncryptedPin parseFrom(CodedInputByteBufferNano codedInputByteBufferNano) throws IOException {
            return new EncryptedPin().mergeFrom(codedInputByteBufferNano);
        }
    }
}
