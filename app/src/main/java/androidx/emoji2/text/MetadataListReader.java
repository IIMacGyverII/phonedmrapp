package androidx.emoji2.text;

import android.content.res.AssetManager;
import androidx.annotation.AnyThread;
import androidx.annotation.IntRange;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.annotation.RestrictTo;
import androidx.emoji2.text.flatbuffer.MetadataList;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import kotlin.UShort;

@RequiresApi(19)
@AnyThread
@RestrictTo({RestrictTo.Scope.LIBRARY})
class MetadataListReader {
    private static final int EMJI_TAG = 1164798569;
    private static final int EMJI_TAG_DEPRECATED = 1701669481;
    private static final int META_TABLE_NAME = 1835365473;

    private interface OpenTypeReader {
        public static final int UINT16_BYTE_COUNT = 2;
        public static final int UINT32_BYTE_COUNT = 4;

        long getPosition();

        int readTag() throws IOException;

        long readUnsignedInt() throws IOException;

        int readUnsignedShort() throws IOException;

        void skip(int i) throws IOException;
    }

    static long toUnsignedInt(int i) {
        return ((long) i) & 4294967295L;
    }

    static int toUnsignedShort(short s) {
        return s & UShort.MAX_VALUE;
    }

    static MetadataList read(InputStream inputStream) throws IOException {
        InputStreamOpenTypeReader inputStreamOpenTypeReader = new InputStreamOpenTypeReader(inputStream);
        OffsetInfo findOffsetInfo = findOffsetInfo(inputStreamOpenTypeReader);
        inputStreamOpenTypeReader.skip((int) (findOffsetInfo.getStartOffset() - inputStreamOpenTypeReader.getPosition()));
        ByteBuffer allocate = ByteBuffer.allocate((int) findOffsetInfo.getLength());
        int read = inputStream.read(allocate.array());
        if (((long) read) == findOffsetInfo.getLength()) {
            return MetadataList.getRootAsMetadataList(allocate);
        }
        throw new IOException("Needed " + findOffsetInfo.getLength() + " bytes, got " + read);
    }

    static MetadataList read(ByteBuffer byteBuffer) throws IOException {
        ByteBuffer duplicate = byteBuffer.duplicate();
        duplicate.position((int) findOffsetInfo(new ByteBufferReader(duplicate)).getStartOffset());
        return MetadataList.getRootAsMetadataList(duplicate);
    }

    static MetadataList read(AssetManager assetManager, String str) throws IOException {
        InputStream open = assetManager.open(str);
        try {
            MetadataList read = read(open);
            if (open != null) {
                open.close();
            }
            return read;
        } catch (Throwable th) {
            th.addSuppressed(th);
        }
        throw th;
    }

    private static OffsetInfo findOffsetInfo(OpenTypeReader openTypeReader) throws IOException {
        long j;
        openTypeReader.skip(4);
        int readUnsignedShort = openTypeReader.readUnsignedShort();
        if (readUnsignedShort <= 100) {
            openTypeReader.skip(6);
            int i = 0;
            while (true) {
                if (i >= readUnsignedShort) {
                    j = -1;
                    break;
                }
                int readTag = openTypeReader.readTag();
                openTypeReader.skip(4);
                j = openTypeReader.readUnsignedInt();
                openTypeReader.skip(4);
                if (META_TABLE_NAME == readTag) {
                    break;
                }
                i++;
            }
            if (j != -1) {
                openTypeReader.skip((int) (j - openTypeReader.getPosition()));
                openTypeReader.skip(12);
                long readUnsignedInt = openTypeReader.readUnsignedInt();
                for (int i2 = 0; ((long) i2) < readUnsignedInt; i2++) {
                    int readTag2 = openTypeReader.readTag();
                    long readUnsignedInt2 = openTypeReader.readUnsignedInt();
                    long readUnsignedInt3 = openTypeReader.readUnsignedInt();
                    if (EMJI_TAG == readTag2 || EMJI_TAG_DEPRECATED == readTag2) {
                        return new OffsetInfo(readUnsignedInt2 + j, readUnsignedInt3);
                    }
                }
            }
            throw new IOException("Cannot read metadata.");
        }
        throw new IOException("Cannot read metadata.");
    }

    private static class OffsetInfo {
        private final long mLength;
        private final long mStartOffset;

        OffsetInfo(long j, long j2) {
            this.mStartOffset = j;
            this.mLength = j2;
        }

        /* access modifiers changed from: package-private */
        public long getStartOffset() {
            return this.mStartOffset;
        }

        /* access modifiers changed from: package-private */
        public long getLength() {
            return this.mLength;
        }
    }

    private static class InputStreamOpenTypeReader implements OpenTypeReader {
        @NonNull
        private final byte[] mByteArray;
        @NonNull
        private final ByteBuffer mByteBuffer;
        @NonNull
        private final InputStream mInputStream;
        private long mPosition = 0;

        InputStreamOpenTypeReader(@NonNull InputStream inputStream) {
            this.mInputStream = inputStream;
            byte[] bArr = new byte[4];
            this.mByteArray = bArr;
            ByteBuffer wrap = ByteBuffer.wrap(bArr);
            this.mByteBuffer = wrap;
            wrap.order(ByteOrder.BIG_ENDIAN);
        }

        public int readUnsignedShort() throws IOException {
            this.mByteBuffer.position(0);
            read(2);
            return MetadataListReader.toUnsignedShort(this.mByteBuffer.getShort());
        }

        public long readUnsignedInt() throws IOException {
            this.mByteBuffer.position(0);
            read(4);
            return MetadataListReader.toUnsignedInt(this.mByteBuffer.getInt());
        }

        public int readTag() throws IOException {
            this.mByteBuffer.position(0);
            read(4);
            return this.mByteBuffer.getInt();
        }

        public void skip(int i) throws IOException {
            while (i > 0) {
                int skip = (int) this.mInputStream.skip((long) i);
                if (skip >= 1) {
                    i -= skip;
                    this.mPosition += (long) skip;
                } else {
                    throw new IOException("Skip didn't move at least 1 byte forward");
                }
            }
        }

        public long getPosition() {
            return this.mPosition;
        }

        private void read(@IntRange(from = 0, to = 4) int i) throws IOException {
            if (this.mInputStream.read(this.mByteArray, 0, i) == i) {
                this.mPosition += (long) i;
                return;
            }
            throw new IOException("read failed");
        }
    }

    private static class ByteBufferReader implements OpenTypeReader {
        @NonNull
        private final ByteBuffer mByteBuffer;

        ByteBufferReader(@NonNull ByteBuffer byteBuffer) {
            this.mByteBuffer = byteBuffer;
            byteBuffer.order(ByteOrder.BIG_ENDIAN);
        }

        public int readUnsignedShort() throws IOException {
            return MetadataListReader.toUnsignedShort(this.mByteBuffer.getShort());
        }

        public long readUnsignedInt() throws IOException {
            return MetadataListReader.toUnsignedInt(this.mByteBuffer.getInt());
        }

        public int readTag() throws IOException {
            return this.mByteBuffer.getInt();
        }

        public void skip(int i) throws IOException {
            ByteBuffer byteBuffer = this.mByteBuffer;
            byteBuffer.position(byteBuffer.position() + i);
        }

        public long getPosition() {
            return (long) this.mByteBuffer.position();
        }
    }

    private MetadataListReader() {
    }
}
