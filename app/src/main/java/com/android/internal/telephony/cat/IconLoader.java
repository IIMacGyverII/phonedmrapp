package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import androidx.core.view.ViewCompat;
import com.android.internal.telephony.TelephonyComponentFactory;
import com.android.internal.telephony.uicc.IccFileHandler;
import java.util.HashMap;
import kotlin.UByte;

public class IconLoader extends Handler {
    protected static final int CLUT_ENTRY_SIZE = 3;
    protected static final int CLUT_LOCATION_OFFSET = 4;
    protected static final int EVENT_READ_CLUT_DONE = 3;
    protected static final int EVENT_READ_EF_IMG_RECOED_DONE = 1;
    protected static final int EVENT_READ_ICON_DONE = 2;
    protected static final int STATE_MULTI_ICONS = 2;
    protected static final int STATE_SINGLE_ICON = 1;
    private static HashMap<Object, IconLoader> sLoader;
    private static HashMap<Object, HandlerThread> sThread;
    protected Bitmap mCurrentIcon = null;
    protected int mCurrentRecordIndex = 0;
    protected Message mEndMsg = null;
    protected byte[] mIconData = null;
    protected Bitmap[] mIcons = null;
    protected HashMap<Integer, Bitmap> mIconsCache = null;
    protected ImageDescriptor mId = null;
    protected int mRecordNumber;
    protected int[] mRecordNumbers = null;
    protected IccFileHandler mSimFH;
    protected int mState = 1;

    private static int bitToBnW(int i) {
        if (i == 1) {
            return -1;
        }
        return ViewCompat.MEASURED_STATE_MASK;
    }

    private static int getMask(int i) {
        switch (i) {
            case 1:
                return 1;
            case 2:
                return 3;
            case 3:
                return 7;
            case 4:
                return 15;
            case 5:
                return 31;
            case 6:
                return 63;
            case 7:
                return 127;
            case 8:
                return 255;
            default:
                return 0;
        }
    }

    public IconLoader(Looper looper, IccFileHandler iccFileHandler) {
        super(looper);
        this.mSimFH = iccFileHandler;
        this.mIconsCache = new HashMap<>(50);
    }

    static IconLoader getInstance(Handler handler, IccFileHandler iccFileHandler) {
        HashMap<Object, IconLoader> hashMap = sLoader;
        if (hashMap != null && hashMap.containsKey(iccFileHandler)) {
            return sLoader.get(iccFileHandler);
        }
        if (iccFileHandler == null) {
            return null;
        }
        if (sThread == null) {
            sThread = new HashMap<>(4);
        }
        HandlerThread handlerThread = new HandlerThread("Cat Icon Loader");
        sThread.put(iccFileHandler, handlerThread);
        handlerThread.start();
        if (sLoader == null) {
            sLoader = new HashMap<>(4);
        }
        IconLoader makeIconLoader = TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName()).makeIconLoader(handlerThread.getLooper(), iccFileHandler);
        sLoader.put(iccFileHandler, makeIconLoader);
        return makeIconLoader;
    }

    public void loadIcons(int[] iArr, Message message) {
        if (iArr != null && iArr.length != 0 && message != null) {
            this.mEndMsg = message;
            this.mIcons = new Bitmap[iArr.length];
            this.mRecordNumbers = iArr;
            this.mCurrentRecordIndex = 0;
            this.mState = 2;
            startLoadingIcon(iArr[0]);
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void loadIcon(int i, Message message) {
        if (message != null) {
            this.mEndMsg = message;
            this.mState = 1;
            startLoadingIcon(i);
        }
    }

    /* access modifiers changed from: protected */
    public void startLoadingIcon(int i) {
        this.mId = null;
        this.mIconData = null;
        this.mCurrentIcon = null;
        this.mRecordNumber = i;
        if (this.mIconsCache.containsKey(Integer.valueOf(i))) {
            this.mCurrentIcon = this.mIconsCache.get(Integer.valueOf(i));
            postIcon();
            return;
        }
        readId();
    }

    public void handleMessage(Message message) {
        try {
            int i = message.what;
            if (i != 1) {
                if (i == 2) {
                    CatLog.d((Object) this, "load icon done");
                    byte[] bArr = (byte[]) ((AsyncResult) message.obj).result;
                    int i2 = this.mId.mCodingScheme;
                    if (i2 == 17) {
                        this.mCurrentIcon = parseToBnW(bArr, bArr.length);
                        this.mIconsCache.put(Integer.valueOf(this.mRecordNumber), this.mCurrentIcon);
                        postIcon();
                    } else if (i2 == 33) {
                        this.mIconData = bArr;
                        readClut();
                    } else {
                        CatLog.d((Object) this, "else  /postIcon ");
                        postIcon();
                    }
                } else if (i == 3) {
                    byte[] bArr2 = this.mIconData;
                    this.mCurrentIcon = parseToRGB(bArr2, bArr2.length, false, (byte[]) ((AsyncResult) message.obj).result);
                    this.mIconsCache.put(Integer.valueOf(this.mRecordNumber), this.mCurrentIcon);
                    postIcon();
                }
            } else if (handleImageDescriptor((byte[]) ((AsyncResult) message.obj).result)) {
                readIconData();
            } else {
                throw new Exception("Unable to parse image descriptor");
            }
        } catch (Exception unused) {
            CatLog.d((Object) this, "Icon load failed");
            postIcon();
        }
    }

    /* access modifiers changed from: protected */
    public boolean handleImageDescriptor(byte[] bArr) {
        ImageDescriptor parse = ImageDescriptor.parse(bArr, 1);
        this.mId = parse;
        return parse != null;
    }

    /* access modifiers changed from: protected */
    public void readClut() {
        int i = this.mIconData[3] * 3;
        Message obtainMessage = obtainMessage(3);
        IccFileHandler iccFileHandler = this.mSimFH;
        int i2 = this.mId.mImageId;
        byte[] bArr = this.mIconData;
        iccFileHandler.loadEFImgTransparent(i2, bArr[4], bArr[5], i, obtainMessage);
    }

    /* access modifiers changed from: protected */
    public void readId() {
        if (this.mRecordNumber < 0) {
            this.mCurrentIcon = null;
            postIcon();
            return;
        }
        this.mSimFH.loadEFImgLinearFixed(this.mRecordNumber, obtainMessage(1));
    }

    /* access modifiers changed from: protected */
    public void readIconData() {
        Message obtainMessage = obtainMessage(2);
        IccFileHandler iccFileHandler = this.mSimFH;
        ImageDescriptor imageDescriptor = this.mId;
        iccFileHandler.loadEFImgTransparent(imageDescriptor.mImageId, 0, 0, imageDescriptor.mLength, obtainMessage);
    }

    /* access modifiers changed from: protected */
    public void postIcon() {
        int i = this.mState;
        if (i == 1) {
            Message message = this.mEndMsg;
            message.obj = this.mCurrentIcon;
            message.sendToTarget();
        } else if (i == 2) {
            Bitmap[] bitmapArr = this.mIcons;
            int i2 = this.mCurrentRecordIndex;
            int i3 = i2 + 1;
            this.mCurrentRecordIndex = i3;
            bitmapArr[i2] = this.mCurrentIcon;
            int[] iArr = this.mRecordNumbers;
            if (i3 < iArr.length) {
                startLoadingIcon(iArr[i3]);
                return;
            }
            Message message2 = this.mEndMsg;
            message2.obj = bitmapArr;
            message2.sendToTarget();
        }
    }

    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r8v6, resolved type: byte} */
    /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r8v7, resolved type: byte} */
    /* JADX WARNING: Multi-variable type inference failed */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public static android.graphics.Bitmap parseToBnW(byte[] r12, int r13) {
        /*
            r13 = 0
            byte r0 = r12[r13]
            r0 = r0 & 255(0xff, float:3.57E-43)
            r1 = 1
            byte r2 = r12[r1]
            r2 = r2 & 255(0xff, float:3.57E-43)
            int r3 = r0 * r2
            int[] r4 = new int[r3]
            r5 = 7
            r6 = 2
            r8 = r5
            r7 = r6
            r6 = r13
        L_0x0013:
            if (r13 >= r3) goto L_0x0031
            int r9 = r13 % 8
            if (r9 != 0) goto L_0x0021
            int r6 = r7 + 1
            byte r7 = r12[r7]
            r8 = r5
            r11 = r7
            r7 = r6
            r6 = r11
        L_0x0021:
            int r9 = r13 + 1
            int r10 = r8 + -1
            int r8 = r6 >> r8
            r8 = r8 & r1
            int r8 = bitToBnW(r8)
            r4[r13] = r8
            r13 = r9
            r8 = r10
            goto L_0x0013
        L_0x0031:
            if (r13 == r3) goto L_0x003a
            java.lang.String r12 = "IconLoader"
            java.lang.String r13 = "parseToBnW; size error"
            com.android.internal.telephony.cat.CatLog.d((java.lang.String) r12, (java.lang.String) r13)
        L_0x003a:
            android.graphics.Bitmap$Config r12 = android.graphics.Bitmap.Config.ARGB_8888
            android.graphics.Bitmap r12 = android.graphics.Bitmap.createBitmap(r4, r0, r2, r12)
            return r12
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.cat.IconLoader.parseToBnW(byte[], int):android.graphics.Bitmap");
    }

    public static Bitmap parseToRGB(byte[] bArr, int i, boolean z, byte[] bArr2) {
        int i2;
        int i3 = 0;
        byte b = bArr[0] & UByte.MAX_VALUE;
        boolean z2 = true;
        byte b2 = bArr[1] & UByte.MAX_VALUE;
        byte b3 = bArr[2] & UByte.MAX_VALUE;
        int i4 = 3;
        byte b4 = bArr[3] & UByte.MAX_VALUE;
        if (true == z) {
            bArr2[b4 - 1] = 0;
        }
        int i5 = b * b2;
        int[] iArr = new int[i5];
        int i6 = 8 - b3;
        int i7 = 7;
        byte b5 = bArr[6];
        int mask = getMask(b3);
        if (8 % b3 != 0) {
            z2 = false;
        }
        int i8 = i6;
        while (i3 < i5) {
            if (i2 < 0) {
                int i9 = i7 + 1;
                byte b6 = bArr[i7];
                i2 = z2 ? i6 : i2 * -1;
                byte b7 = b6;
                i7 = i9;
                b5 = b7;
            }
            int i10 = ((b5 >> i2) & mask) * i4;
            iArr[i3] = Color.rgb(bArr2[i10], bArr2[i10 + 1], bArr2[i10 + 2]);
            i8 = i2 - b3;
            z2 = z2;
            i3++;
            i4 = 3;
        }
        return Bitmap.createBitmap(iArr, b, b2, Bitmap.Config.ARGB_8888);
    }

    public void dispose() {
        HashMap<Object, HandlerThread> hashMap = sThread;
        if (hashMap != null && hashMap.containsKey(this.mSimFH)) {
            HandlerThread handlerThread = sThread.get(this.mSimFH);
            if (handlerThread != null) {
                handlerThread.quit();
            }
            sThread.remove(this.mSimFH);
        }
        this.mIconsCache = null;
        HashMap<Object, IconLoader> hashMap2 = sLoader;
        if (hashMap2 != null && hashMap2.containsKey(this.mSimFH)) {
            IconLoader iconLoader = sLoader.get(this.mSimFH);
            sLoader.remove(this.mSimFH);
        }
        this.mSimFH = null;
    }
}
