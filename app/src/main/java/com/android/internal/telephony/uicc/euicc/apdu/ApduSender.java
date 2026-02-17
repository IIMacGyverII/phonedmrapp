package com.android.internal.telephony.uicc.euicc.apdu;

import android.os.Handler;
import com.android.internal.telephony.CommandsInterface;
import com.android.internal.telephony.uicc.IccIoResult;
import com.android.internal.telephony.uicc.euicc.async.AsyncResultCallback;
import com.android.telephony.Rlog;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

public class ApduSender {
    private static final int INS_GET_MORE_RESPONSE = 192;
    private static final String LOG_TAG = "ApduSender";
    private static final int STATUS_NO_ERROR = 36864;
    private static final int SW1_MORE_RESPONSE = 97;
    private static final int SW1_NO_ERROR = 145;
    private static final int WAIT_TIME_MS = 2000;
    /* access modifiers changed from: private */
    public final String mAid;
    /* access modifiers changed from: private */
    public final Object mChannelLock = new Object();
    /* access modifiers changed from: private */
    public boolean mChannelOpened;
    private final CloseLogicalChannelInvocation mCloseChannel;
    private final OpenLogicalChannelInvocation mOpenChannel;
    /* access modifiers changed from: private */
    public final boolean mSupportExtendedApdu;
    private final TransmitApduLogicalChannelInvocation mTransmitApdu;

    /* access modifiers changed from: private */
    public static void logv(String str) {
        Rlog.v(LOG_TAG, str);
    }

    private static void logd(String str) {
        Rlog.d(LOG_TAG, str);
    }

    public ApduSender(CommandsInterface commandsInterface, String str, boolean z) {
        this.mAid = str;
        this.mSupportExtendedApdu = z;
        this.mOpenChannel = new OpenLogicalChannelInvocation(commandsInterface);
        this.mCloseChannel = new CloseLogicalChannelInvocation(commandsInterface);
        this.mTransmitApdu = new TransmitApduLogicalChannelInvocation(commandsInterface);
    }

    /* JADX WARNING: Can't wrap try/catch for region: R(6:7|8|9|10|11|(3:13|14|15)) */
    /* JADX WARNING: Missing exception handler attribute for start block: B:10:0x0021 */
    /* JADX WARNING: Removed duplicated region for block: B:13:0x0025  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void send(final com.android.internal.telephony.uicc.euicc.apdu.RequestProvider r5, final com.android.internal.telephony.uicc.euicc.apdu.ApduSenderResultCallback r6, final android.os.Handler r7) {
        /*
            r4 = this;
            java.lang.Object r0 = r4.mChannelLock
            monitor-enter(r0)
            boolean r1 = r4.mChannelOpened     // Catch:{ all -> 0x004e }
            if (r1 == 0) goto L_0x003d
            android.os.Looper r1 = android.os.Looper.getMainLooper()     // Catch:{ all -> 0x004e }
            android.os.Looper r2 = android.os.Looper.myLooper()     // Catch:{ all -> 0x004e }
            boolean r1 = r1.equals(r2)     // Catch:{ all -> 0x004e }
            if (r1 != 0) goto L_0x0031
            java.lang.String r1 = "Logical channel has already been opened. Wait."
            logd(r1)     // Catch:{ all -> 0x004e }
            java.lang.Object r1 = r4.mChannelLock     // Catch:{ InterruptedException -> 0x0021 }
            r2 = 2000(0x7d0, double:9.88E-321)
            r1.wait(r2)     // Catch:{ InterruptedException -> 0x0021 }
        L_0x0021:
            boolean r1 = r4.mChannelOpened     // Catch:{ all -> 0x004e }
            if (r1 == 0) goto L_0x003d
            com.android.internal.telephony.uicc.euicc.apdu.ApduException r4 = new com.android.internal.telephony.uicc.euicc.apdu.ApduException     // Catch:{ all -> 0x004e }
            java.lang.String r5 = "The logical channel is still in use."
            r4.<init>((java.lang.String) r5)     // Catch:{ all -> 0x004e }
            com.android.internal.telephony.uicc.euicc.async.AsyncResultHelper.throwException(r4, r6, r7)     // Catch:{ all -> 0x004e }
            monitor-exit(r0)     // Catch:{ all -> 0x004e }
            return
        L_0x0031:
            com.android.internal.telephony.uicc.euicc.apdu.ApduException r4 = new com.android.internal.telephony.uicc.euicc.apdu.ApduException     // Catch:{ all -> 0x004e }
            java.lang.String r5 = "The logical channel is in use."
            r4.<init>((java.lang.String) r5)     // Catch:{ all -> 0x004e }
            com.android.internal.telephony.uicc.euicc.async.AsyncResultHelper.throwException(r4, r6, r7)     // Catch:{ all -> 0x004e }
            monitor-exit(r0)     // Catch:{ all -> 0x004e }
            return
        L_0x003d:
            r1 = 1
            r4.mChannelOpened = r1     // Catch:{ all -> 0x004e }
            monitor-exit(r0)     // Catch:{ all -> 0x004e }
            com.android.internal.telephony.uicc.euicc.apdu.OpenLogicalChannelInvocation r0 = r4.mOpenChannel
            java.lang.String r1 = r4.mAid
            com.android.internal.telephony.uicc.euicc.apdu.ApduSender$1 r2 = new com.android.internal.telephony.uicc.euicc.apdu.ApduSender$1
            r2.<init>(r6, r5, r7)
            r0.invoke(r1, r2, r7)
            return
        L_0x004e:
            r4 = move-exception
            monitor-exit(r0)     // Catch:{ all -> 0x004e }
            throw r4
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.uicc.euicc.apdu.ApduSender.send(com.android.internal.telephony.uicc.euicc.apdu.RequestProvider, com.android.internal.telephony.uicc.euicc.apdu.ApduSenderResultCallback, android.os.Handler):void");
    }

    /* access modifiers changed from: private */
    public void sendCommand(List<ApduCommand> list, int i, ApduSenderResultCallback apduSenderResultCallback, Handler handler) {
        ApduCommand apduCommand = list.get(i);
        final ApduCommand apduCommand2 = apduCommand;
        final ApduSenderResultCallback apduSenderResultCallback2 = apduSenderResultCallback;
        final Handler handler2 = handler;
        final int i2 = i;
        final List<ApduCommand> list2 = list;
        this.mTransmitApdu.invoke(apduCommand, new AsyncResultCallback<IccIoResult>() {
            public void onResult(IccIoResult iccIoResult) {
                ApduSender.this.getCompleteResponse(apduCommand2.channel, iccIoResult, (ByteArrayOutputStream) null, new AsyncResultCallback<IccIoResult>() {
                    public void onResult(IccIoResult iccIoResult) {
                        ApduSender.logv("Full APDU response: " + iccIoResult);
                        int i = iccIoResult.sw1;
                        int i2 = (i << 8) | iccIoResult.sw2;
                        if (i2 == ApduSender.STATUS_NO_ERROR || i == ApduSender.SW1_NO_ERROR) {
                            AnonymousClass2 r0 = AnonymousClass2.this;
                            if (i2 < list2.size() - 1 && apduSenderResultCallback2.shouldContinueOnIntermediateResult(iccIoResult)) {
                                AnonymousClass2 r8 = AnonymousClass2.this;
                                ApduSender.this.sendCommand(list2, i2 + 1, apduSenderResultCallback2, handler2);
                                return;
                            }
                            AnonymousClass2 r82 = AnonymousClass2.this;
                            ApduSender.this.closeAndReturn(apduCommand2.channel, iccIoResult.payload, (Throwable) null, apduSenderResultCallback2, handler2);
                            return;
                        }
                        AnonymousClass2 r9 = AnonymousClass2.this;
                        ApduSender apduSender = ApduSender.this;
                        int i3 = apduCommand2.channel;
                        ApduException apduException = new ApduException(i2);
                        AnonymousClass2 r83 = AnonymousClass2.this;
                        apduSender.closeAndReturn(i3, (byte[]) null, apduException, apduSenderResultCallback2, handler2);
                    }
                }, handler2);
            }
        }, handler);
    }

    /* access modifiers changed from: private */
    public void getCompleteResponse(int i, IccIoResult iccIoResult, ByteArrayOutputStream byteArrayOutputStream, AsyncResultCallback<IccIoResult> asyncResultCallback, Handler handler) {
        IccIoResult iccIoResult2 = iccIoResult;
        final ByteArrayOutputStream byteArrayOutputStream2 = byteArrayOutputStream == null ? new ByteArrayOutputStream() : byteArrayOutputStream;
        byte[] bArr = iccIoResult2.payload;
        if (bArr != null) {
            try {
                byteArrayOutputStream2.write(bArr);
            } catch (IOException unused) {
            }
        }
        if (iccIoResult2.sw1 != 97) {
            iccIoResult2.payload = byteArrayOutputStream2.toByteArray();
            asyncResultCallback.onResult(iccIoResult2);
            return;
        }
        AsyncResultCallback<IccIoResult> asyncResultCallback2 = asyncResultCallback;
        final int i2 = i;
        final AsyncResultCallback<IccIoResult> asyncResultCallback3 = asyncResultCallback;
        final Handler handler2 = handler;
        this.mTransmitApdu.invoke(new ApduCommand(i, 0, 192, 0, 0, iccIoResult2.sw2, ""), new AsyncResultCallback<IccIoResult>() {
            public void onResult(IccIoResult iccIoResult) {
                ApduSender.this.getCompleteResponse(i2, iccIoResult, byteArrayOutputStream2, asyncResultCallback3, handler2);
            }
        }, handler);
    }

    /* access modifiers changed from: private */
    public void closeAndReturn(int i, final byte[] bArr, final Throwable th, final ApduSenderResultCallback apduSenderResultCallback, Handler handler) {
        this.mCloseChannel.invoke(Integer.valueOf(i), new AsyncResultCallback<Boolean>() {
            public void onResult(Boolean bool) {
                synchronized (ApduSender.this.mChannelLock) {
                    ApduSender.this.mChannelOpened = false;
                    ApduSender.this.mChannelLock.notify();
                }
                Throwable th = th;
                if (th == null) {
                    apduSenderResultCallback.onResult(bArr);
                } else {
                    apduSenderResultCallback.onException(th);
                }
            }
        }, handler);
    }
}
