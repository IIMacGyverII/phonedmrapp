package androidx.emoji2.text.flatbuffer;

import androidx.emoji2.text.flatbuffer.Utf8;
import com.android.internal.telephony.util.DnsPacket;
import java.nio.ByteBuffer;

public final class Utf8Safe extends Utf8 {
    private static int computeEncodedLength(CharSequence charSequence) {
        int length = charSequence.length();
        int i = 0;
        while (i < length && charSequence.charAt(i) < 128) {
            i++;
        }
        int i2 = length;
        while (true) {
            if (i < length) {
                char charAt = charSequence.charAt(i);
                if (charAt >= 2048) {
                    i2 += encodedLengthGeneral(charSequence, i);
                    break;
                }
                i2 += (127 - charAt) >>> 31;
                i++;
            } else {
                break;
            }
        }
        if (i2 >= length) {
            return i2;
        }
        throw new IllegalArgumentException("UTF-8 length does not fit in int: " + (((long) i2) + 4294967296L));
    }

    private static int encodedLengthGeneral(CharSequence charSequence, int i) {
        int length = charSequence.length();
        int i2 = 0;
        while (i < length) {
            char charAt = charSequence.charAt(i);
            if (charAt < 2048) {
                i2 += (127 - charAt) >>> 31;
            } else {
                i2 += 2;
                if (55296 <= charAt && charAt <= 57343) {
                    if (Character.codePointAt(charSequence, i) >= 65536) {
                        i++;
                    } else {
                        throw new UnpairedSurrogateException(i, length);
                    }
                }
            }
            i++;
        }
        return i2;
    }

    public static String decodeUtf8Array(byte[] bArr, int i, int i2) {
        if ((i | i2 | ((bArr.length - i) - i2)) >= 0) {
            int i3 = i + i2;
            char[] cArr = new char[i2];
            int i4 = 0;
            while (r12 < i3) {
                byte b = bArr[r12];
                if (!Utf8.DecodeUtil.isOneByte(b)) {
                    break;
                }
                i = r12 + 1;
                Utf8.DecodeUtil.handleOneByte(b, cArr, i4);
                i4++;
            }
            int i5 = i4;
            while (r12 < i3) {
                int i6 = r12 + 1;
                byte b2 = bArr[r12];
                if (Utf8.DecodeUtil.isOneByte(b2)) {
                    int i7 = i5 + 1;
                    Utf8.DecodeUtil.handleOneByte(b2, cArr, i5);
                    while (i6 < i3) {
                        byte b3 = bArr[i6];
                        if (!Utf8.DecodeUtil.isOneByte(b3)) {
                            break;
                        }
                        i6++;
                        Utf8.DecodeUtil.handleOneByte(b3, cArr, i7);
                        i7++;
                    }
                    r12 = i6;
                    i5 = i7;
                } else if (Utf8.DecodeUtil.isTwoBytes(b2)) {
                    if (i6 < i3) {
                        Utf8.DecodeUtil.handleTwoBytes(b2, bArr[i6], cArr, i5);
                        r12 = i6 + 1;
                        i5++;
                    } else {
                        throw new IllegalArgumentException("Invalid UTF-8");
                    }
                } else if (Utf8.DecodeUtil.isThreeBytes(b2)) {
                    if (i6 < i3 - 1) {
                        int i8 = i6 + 1;
                        Utf8.DecodeUtil.handleThreeBytes(b2, bArr[i6], bArr[i8], cArr, i5);
                        r12 = i8 + 1;
                        i5++;
                    } else {
                        throw new IllegalArgumentException("Invalid UTF-8");
                    }
                } else if (i6 < i3 - 2) {
                    int i9 = i6 + 1;
                    byte b4 = bArr[i6];
                    int i10 = i9 + 1;
                    Utf8.DecodeUtil.handleFourBytes(b2, b4, bArr[i9], bArr[i10], cArr, i5);
                    r12 = i10 + 1;
                    i5 = i5 + 1 + 1;
                } else {
                    throw new IllegalArgumentException("Invalid UTF-8");
                }
            }
            return new String(cArr, 0, i5);
        }
        throw new ArrayIndexOutOfBoundsException(String.format("buffer length=%d, index=%d, size=%d", new Object[]{Integer.valueOf(bArr.length), Integer.valueOf(i), Integer.valueOf(i2)}));
    }

    public static String decodeUtf8Buffer(ByteBuffer byteBuffer, int i, int i2) {
        if ((i | i2 | ((byteBuffer.limit() - i) - i2)) >= 0) {
            int i3 = i + i2;
            char[] cArr = new char[i2];
            int i4 = 0;
            while (r12 < i3) {
                byte b = byteBuffer.get(r12);
                if (!Utf8.DecodeUtil.isOneByte(b)) {
                    break;
                }
                i = r12 + 1;
                Utf8.DecodeUtil.handleOneByte(b, cArr, i4);
                i4++;
            }
            int i5 = i4;
            while (r12 < i3) {
                int i6 = r12 + 1;
                byte b2 = byteBuffer.get(r12);
                if (Utf8.DecodeUtil.isOneByte(b2)) {
                    int i7 = i5 + 1;
                    Utf8.DecodeUtil.handleOneByte(b2, cArr, i5);
                    while (i6 < i3) {
                        byte b3 = byteBuffer.get(i6);
                        if (!Utf8.DecodeUtil.isOneByte(b3)) {
                            break;
                        }
                        i6++;
                        Utf8.DecodeUtil.handleOneByte(b3, cArr, i7);
                        i7++;
                    }
                    r12 = i6;
                    i5 = i7;
                } else if (Utf8.DecodeUtil.isTwoBytes(b2)) {
                    if (i6 < i3) {
                        Utf8.DecodeUtil.handleTwoBytes(b2, byteBuffer.get(i6), cArr, i5);
                        r12 = i6 + 1;
                        i5++;
                    } else {
                        throw new IllegalArgumentException("Invalid UTF-8");
                    }
                } else if (Utf8.DecodeUtil.isThreeBytes(b2)) {
                    if (i6 < i3 - 1) {
                        int i8 = i6 + 1;
                        Utf8.DecodeUtil.handleThreeBytes(b2, byteBuffer.get(i6), byteBuffer.get(i8), cArr, i5);
                        r12 = i8 + 1;
                        i5++;
                    } else {
                        throw new IllegalArgumentException("Invalid UTF-8");
                    }
                } else if (i6 < i3 - 2) {
                    int i9 = i6 + 1;
                    byte b4 = byteBuffer.get(i6);
                    int i10 = i9 + 1;
                    Utf8.DecodeUtil.handleFourBytes(b2, b4, byteBuffer.get(i9), byteBuffer.get(i10), cArr, i5);
                    r12 = i10 + 1;
                    i5 = i5 + 1 + 1;
                } else {
                    throw new IllegalArgumentException("Invalid UTF-8");
                }
            }
            return new String(cArr, 0, i5);
        }
        throw new ArrayIndexOutOfBoundsException(String.format("buffer limit=%d, index=%d, limit=%d", new Object[]{Integer.valueOf(byteBuffer.limit()), Integer.valueOf(i), Integer.valueOf(i2)}));
    }

    public int encodedLength(CharSequence charSequence) {
        return computeEncodedLength(charSequence);
    }

    public String decodeUtf8(ByteBuffer byteBuffer, int i, int i2) throws IllegalArgumentException {
        if (byteBuffer.hasArray()) {
            return decodeUtf8Array(byteBuffer.array(), byteBuffer.arrayOffset() + i, i2);
        }
        return decodeUtf8Buffer(byteBuffer, i, i2);
    }

    private static void encodeUtf8Buffer(CharSequence charSequence, ByteBuffer byteBuffer) {
        int i;
        int length = charSequence.length();
        int position = byteBuffer.position();
        int i2 = 0;
        while (i2 < length) {
            try {
                char charAt = charSequence.charAt(i2);
                if (charAt >= 128) {
                    break;
                }
                byteBuffer.put(position + i2, (byte) charAt);
                i2++;
            } catch (IndexOutOfBoundsException unused) {
                throw new ArrayIndexOutOfBoundsException("Failed writing " + charSequence.charAt(i2) + " at index " + (byteBuffer.position() + Math.max(i2, (position - byteBuffer.position()) + 1)));
            }
        }
        if (i2 == length) {
            byteBuffer.position(position + i2);
            return;
        }
        position += i2;
        while (i2 < length) {
            char charAt2 = charSequence.charAt(i2);
            if (charAt2 < 128) {
                byteBuffer.put(position, (byte) charAt2);
            } else if (charAt2 < 2048) {
                i = position + 1;
                try {
                    byteBuffer.put(position, (byte) ((charAt2 >>> 6) | DnsPacket.DnsRecord.NAME_COMPRESSION));
                    byteBuffer.put(i, (byte) ((charAt2 & '?') | 128));
                    position = i;
                } catch (IndexOutOfBoundsException unused2) {
                    position = i;
                    throw new ArrayIndexOutOfBoundsException("Failed writing " + charSequence.charAt(i2) + " at index " + (byteBuffer.position() + Math.max(i2, (position - byteBuffer.position()) + 1)));
                }
            } else if (charAt2 < 55296 || 57343 < charAt2) {
                i = position + 1;
                byteBuffer.put(position, (byte) ((charAt2 >>> 12) | 224));
                position = i + 1;
                byteBuffer.put(i, (byte) (((charAt2 >>> 6) & 63) | 128));
                byteBuffer.put(position, (byte) ((charAt2 & '?') | 128));
            } else {
                int i3 = i2 + 1;
                if (i3 != length) {
                    try {
                        char charAt3 = charSequence.charAt(i3);
                        if (Character.isSurrogatePair(charAt2, charAt3)) {
                            int codePoint = Character.toCodePoint(charAt2, charAt3);
                            int i4 = position + 1;
                            try {
                                byteBuffer.put(position, (byte) ((codePoint >>> 18) | 240));
                                position = i4 + 1;
                                byteBuffer.put(i4, (byte) (((codePoint >>> 12) & 63) | 128));
                                i4 = position + 1;
                                byteBuffer.put(position, (byte) (((codePoint >>> 6) & 63) | 128));
                                byteBuffer.put(i4, (byte) ((codePoint & 63) | 128));
                                position = i4;
                                i2 = i3;
                            } catch (IndexOutOfBoundsException unused3) {
                                position = i4;
                                i2 = i3;
                                throw new ArrayIndexOutOfBoundsException("Failed writing " + charSequence.charAt(i2) + " at index " + (byteBuffer.position() + Math.max(i2, (position - byteBuffer.position()) + 1)));
                            }
                        } else {
                            i2 = i3;
                        }
                    } catch (IndexOutOfBoundsException unused4) {
                        i2 = i3;
                        throw new ArrayIndexOutOfBoundsException("Failed writing " + charSequence.charAt(i2) + " at index " + (byteBuffer.position() + Math.max(i2, (position - byteBuffer.position()) + 1)));
                    }
                }
                throw new UnpairedSurrogateException(i2, length);
            }
            i2++;
            position++;
        }
        byteBuffer.position(position);
    }

    private static int encodeUtf8Array(CharSequence charSequence, byte[] bArr, int i, int i2) {
        int i3;
        int i4;
        int i5;
        char charAt;
        int length = charSequence.length();
        int i6 = i2 + i;
        int i7 = 0;
        while (i7 < length && (i5 = i7 + i) < i6 && (charAt = charSequence.charAt(i7)) < 128) {
            bArr[i5] = (byte) charAt;
            i7++;
        }
        if (i7 == length) {
            return i + length;
        }
        int i8 = i + i7;
        while (i7 < length) {
            char charAt2 = charSequence.charAt(i7);
            if (charAt2 < 128 && i8 < i6) {
                i4 = i8 + 1;
                bArr[i8] = (byte) charAt2;
            } else if (charAt2 < 2048 && i8 <= i6 - 2) {
                int i9 = i8 + 1;
                bArr[i8] = (byte) ((charAt2 >>> 6) | 960);
                i8 = i9 + 1;
                bArr[i9] = (byte) ((charAt2 & '?') | 128);
                i7++;
            } else if ((charAt2 < 55296 || 57343 < charAt2) && i8 <= i6 - 3) {
                int i10 = i8 + 1;
                bArr[i8] = (byte) ((charAt2 >>> 12) | 480);
                int i11 = i10 + 1;
                bArr[i10] = (byte) (((charAt2 >>> 6) & 63) | 128);
                i4 = i11 + 1;
                bArr[i11] = (byte) ((charAt2 & '?') | 128);
            } else if (i8 <= i6 - 4) {
                int i12 = i7 + 1;
                if (i12 != charSequence.length()) {
                    char charAt3 = charSequence.charAt(i12);
                    if (Character.isSurrogatePair(charAt2, charAt3)) {
                        int codePoint = Character.toCodePoint(charAt2, charAt3);
                        int i13 = i8 + 1;
                        bArr[i8] = (byte) ((codePoint >>> 18) | 240);
                        int i14 = i13 + 1;
                        bArr[i13] = (byte) (((codePoint >>> 12) & 63) | 128);
                        int i15 = i14 + 1;
                        bArr[i14] = (byte) (((codePoint >>> 6) & 63) | 128);
                        i8 = i15 + 1;
                        bArr[i15] = (byte) ((codePoint & 63) | 128);
                        i7 = i12;
                        i7++;
                    } else {
                        i7 = i12;
                    }
                }
                throw new UnpairedSurrogateException(i7 - 1, length);
            } else if (55296 > charAt2 || charAt2 > 57343 || ((i3 = i7 + 1) != charSequence.length() && Character.isSurrogatePair(charAt2, charSequence.charAt(i3)))) {
                throw new ArrayIndexOutOfBoundsException("Failed writing " + charAt2 + " at index " + i8);
            } else {
                throw new UnpairedSurrogateException(i7, length);
            }
            i8 = i4;
            i7++;
        }
        return i8;
    }

    public void encodeUtf8(CharSequence charSequence, ByteBuffer byteBuffer) {
        if (byteBuffer.hasArray()) {
            int arrayOffset = byteBuffer.arrayOffset();
            byteBuffer.position(encodeUtf8Array(charSequence, byteBuffer.array(), byteBuffer.position() + arrayOffset, byteBuffer.remaining()) - arrayOffset);
            return;
        }
        encodeUtf8Buffer(charSequence, byteBuffer);
    }

    static class UnpairedSurrogateException extends IllegalArgumentException {
        UnpairedSurrogateException(int i, int i2) {
            super("Unpaired surrogate at index " + i + " of " + i2);
        }
    }
}
