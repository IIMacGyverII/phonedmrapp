package com.android.internal.telephony.cat;

import kotlin.UByte;

public class ImageDescriptor {
    public static final int CODING_SCHEME_BASIC = 17;
    public static final int CODING_SCHEME_COLOUR = 33;
    public int mCodingScheme = 0;
    public int mHeight = 0;
    public int mHighOffset = 0;
    public int mImageId = 0;
    public int mLength = 0;
    public int mLowOffset = 0;
    public int mWidth = 0;

    ImageDescriptor() {
    }

    public static ImageDescriptor parse(byte[] bArr, int i) {
        ImageDescriptor imageDescriptor = new ImageDescriptor();
        int i2 = i + 1;
        try {
            imageDescriptor.mWidth = bArr[i] & UByte.MAX_VALUE;
            int i3 = i2 + 1;
            imageDescriptor.mHeight = bArr[i2] & UByte.MAX_VALUE;
            int i4 = i3 + 1;
            imageDescriptor.mCodingScheme = bArr[i3] & UByte.MAX_VALUE;
            int i5 = i4 + 1;
            int i6 = i5 + 1;
            imageDescriptor.mImageId = (bArr[i5] & UByte.MAX_VALUE) | ((bArr[i4] & UByte.MAX_VALUE) << 8);
            int i7 = i6 + 1;
            imageDescriptor.mHighOffset = bArr[i6] & UByte.MAX_VALUE;
            int i8 = i7 + 1;
            imageDescriptor.mLowOffset = bArr[i7] & UByte.MAX_VALUE;
            imageDescriptor.mLength = (bArr[i8 + 1] & UByte.MAX_VALUE) | ((bArr[i8] & UByte.MAX_VALUE) << 8);
            CatLog.d("ImageDescriptor", "parse; Descriptor : " + imageDescriptor.mWidth + ", " + imageDescriptor.mHeight + ", " + imageDescriptor.mCodingScheme + ", 0x" + Integer.toHexString(imageDescriptor.mImageId) + ", " + imageDescriptor.mHighOffset + ", " + imageDescriptor.mLowOffset + ", " + imageDescriptor.mLength);
            return imageDescriptor;
        } catch (IndexOutOfBoundsException unused) {
            CatLog.d("ImageDescriptor", "parse; failed parsing image descriptor");
            return null;
        }
    }
}
