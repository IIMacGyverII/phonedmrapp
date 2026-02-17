package com.android.internal.telephony.util;

import com.android.internal.telephony.util.DnsPacketUtils;
import java.nio.BufferUnderflowException;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.List;

public abstract class DnsPacket {
    public static final int ANSECTION = 1;
    public static final int ARSECTION = 3;
    public static final int NSSECTION = 2;
    private static final int NUM_SECTIONS = 4;
    public static final int QDSECTION = 0;
    private static final String TAG = "DnsPacket";
    protected final DnsHeader mHeader;
    protected final List<DnsRecord>[] mRecords;

    public static class ParseException extends RuntimeException {
        public String reason;

        public ParseException(String str) {
            super(str);
            this.reason = str;
        }

        public ParseException(String str, Throwable th) {
            super(str, th);
            this.reason = str;
        }
    }

    public class DnsHeader {
        private static final int FLAGS_SECTION_QR_BIT = 15;
        private static final String TAG = "DnsHeader";
        public final int flags;
        public final int id;
        private final int[] mRecordCount = new int[4];
        public final int rcode;

        DnsHeader(ByteBuffer byteBuffer) throws BufferUnderflowException {
            this.id = Short.toUnsignedInt(byteBuffer.getShort());
            int unsignedInt = Short.toUnsignedInt(byteBuffer.getShort());
            this.flags = unsignedInt;
            this.rcode = unsignedInt & 15;
            for (int i = 0; i < 4; i++) {
                this.mRecordCount[i] = Short.toUnsignedInt(byteBuffer.getShort());
            }
        }

        public boolean isResponse() {
            return (this.flags & 32768) != 0;
        }

        public int getRecordCount(int i) {
            return this.mRecordCount[i];
        }
    }

    public class DnsRecord {
        private static final int MAXNAMESIZE = 255;
        public static final int NAME_COMPRESSION = 192;
        public static final int NAME_NORMAL = 0;
        private static final String TAG = "DnsRecord";
        public final String dName;
        private final byte[] mRdata;
        public final int nsClass;
        public final int nsType;
        public final long ttl;

        DnsRecord(int i, ByteBuffer byteBuffer) throws BufferUnderflowException, ParseException {
            String parseName = DnsPacketUtils.DnsRecordParser.parseName(byteBuffer, 0, true);
            this.dName = parseName;
            if (parseName.length() <= 255) {
                this.nsType = Short.toUnsignedInt(byteBuffer.getShort());
                this.nsClass = Short.toUnsignedInt(byteBuffer.getShort());
                if (i != 0) {
                    this.ttl = Integer.toUnsignedLong(byteBuffer.getInt());
                    byte[] bArr = new byte[Short.toUnsignedInt(byteBuffer.getShort())];
                    this.mRdata = bArr;
                    byteBuffer.get(bArr);
                    return;
                }
                this.ttl = 0;
                this.mRdata = null;
                return;
            }
            throw new ParseException("Parse name fail, name size is too long: " + parseName.length());
        }

        public byte[] getRR() {
            byte[] bArr = this.mRdata;
            if (bArr == null) {
                return null;
            }
            return (byte[]) bArr.clone();
        }
    }

    protected DnsPacket(byte[] bArr) throws ParseException {
        if (bArr != null) {
            try {
                ByteBuffer wrap = ByteBuffer.wrap(bArr);
                this.mHeader = new DnsHeader(wrap);
                this.mRecords = new ArrayList[4];
                for (int i = 0; i < 4; i++) {
                    int recordCount = this.mHeader.getRecordCount(i);
                    if (recordCount > 0) {
                        this.mRecords[i] = new ArrayList(recordCount);
                    }
                    int i2 = 0;
                    while (i2 < recordCount) {
                        try {
                            this.mRecords[i].add(new DnsRecord(i, wrap));
                            i2++;
                        } catch (BufferUnderflowException e) {
                            throw new ParseException("Parse record fail", e);
                        }
                    }
                }
            } catch (BufferUnderflowException e2) {
                throw new ParseException("Parse Header fail, bad input data", e2);
            }
        } else {
            throw new ParseException("Parse header failed, null input data");
        }
    }
}
