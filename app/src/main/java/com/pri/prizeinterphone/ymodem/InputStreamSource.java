package com.pri.prizeinterphone.ymodem;

import android.content.Context;
import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

class InputStreamSource {
    private static final int BUFFER_SIZE = (YModem.mSize.intValue() * 32);

    InputStreamSource() {
    }

    /* renamed from: com.pri.prizeinterphone.ymodem.InputStreamSource$1  reason: invalid class name */
    static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme;

        /* JADX WARNING: Can't wrap try/catch for region: R(6:0|1|2|3|4|(3:5|6|8)) */
        /* JADX WARNING: Failed to process nested try/catch */
        /* JADX WARNING: Missing exception handler attribute for start block: B:3:0x0012 */
        /* JADX WARNING: Missing exception handler attribute for start block: B:5:0x001d */
        static {
            /*
                com.pri.prizeinterphone.ymodem.SourceScheme[] r0 = com.pri.prizeinterphone.ymodem.SourceScheme.values()
                int r0 = r0.length
                int[] r0 = new int[r0]
                $SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme = r0
                com.pri.prizeinterphone.ymodem.SourceScheme r1 = com.pri.prizeinterphone.ymodem.SourceScheme.FILE     // Catch:{ NoSuchFieldError -> 0x0012 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0012 }
                r2 = 1
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0012 }
            L_0x0012:
                int[] r0 = $SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme     // Catch:{ NoSuchFieldError -> 0x001d }
                com.pri.prizeinterphone.ymodem.SourceScheme r1 = com.pri.prizeinterphone.ymodem.SourceScheme.ASSETS     // Catch:{ NoSuchFieldError -> 0x001d }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x001d }
                r2 = 2
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x001d }
            L_0x001d:
                int[] r0 = $SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme     // Catch:{ NoSuchFieldError -> 0x0028 }
                com.pri.prizeinterphone.ymodem.SourceScheme r1 = com.pri.prizeinterphone.ymodem.SourceScheme.UNKNOWN     // Catch:{ NoSuchFieldError -> 0x0028 }
                int r1 = r1.ordinal()     // Catch:{ NoSuchFieldError -> 0x0028 }
                r2 = 3
                r0[r1] = r2     // Catch:{ NoSuchFieldError -> 0x0028 }
            L_0x0028:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.pri.prizeinterphone.ymodem.InputStreamSource.AnonymousClass1.<clinit>():void");
        }
    }

    /* access modifiers changed from: package-private */
    public InputStream getStream(Context context, String str) throws IOException {
        int i = AnonymousClass1.$SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme[SourceScheme.ofUri(str).ordinal()];
        if (i == 1) {
            return getStreamFromFile(str);
        }
        if (i != 2) {
            return getStreamFromOtherSource(str);
        }
        return getStreamFromAssets(context, str);
    }

    private InputStream getStreamFromFile(String str) throws IOException {
        return new BufferedInputStream(new FileInputStream(SourceScheme.FILE.crop(str)), BUFFER_SIZE);
    }

    private InputStream getStreamFromAssets(Context context, String str) throws IOException {
        return context.getAssets().open(SourceScheme.ASSETS.crop(str));
    }

    private InputStream getStreamFromOtherSource(String str) throws IOException {
        return new BufferedInputStream(new FileInputStream(str), BUFFER_SIZE);
    }
}
