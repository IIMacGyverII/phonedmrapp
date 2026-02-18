package com.pri.prizeinterphone.ymodem;

import android.content.Context;
import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
/* JADX INFO: Access modifiers changed from: package-private */
/* loaded from: classes4.dex */
public class InputStreamSource {
    private static final int BUFFER_SIZE = YModem.mSize.intValue() * 32;

    /* JADX INFO: Access modifiers changed from: package-private */
    /* renamed from: com.pri.prizeinterphone.ymodem.InputStreamSource$1  reason: invalid class name */
    /* loaded from: classes4.dex */
    public static /* synthetic */ class AnonymousClass1 {
        static final /* synthetic */ int[] $SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme;

        static {
            int[] iArr = new int[SourceScheme.values().length];
            $SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme = iArr;
            try {
                iArr[SourceScheme.FILE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme[SourceScheme.ASSETS.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                $SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme[SourceScheme.UNKNOWN.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
        }
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public InputStream getStream(Context context, String str) throws IOException {
        int i = AnonymousClass1.$SwitchMap$com$pri$prizeinterphone$ymodem$SourceScheme[SourceScheme.ofUri(str).ordinal()];
        if (i != 1) {
            if (i == 2) {
                return getStreamFromAssets(context, str);
            }
            return getStreamFromOtherSource(str);
        }
        return getStreamFromFile(str);
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
