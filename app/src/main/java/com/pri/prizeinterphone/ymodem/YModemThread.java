package com.pri.prizeinterphone.ymodem;

import android.util.Log;
import com.pri.prizeinterphone.Util.ExecutorManager;
import com.pri.prizeinterphone.Util.NamedThreadFactory;
import com.pri.prizeinterphone.serial.port.SerialPort;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import kotlin.UByte;
/* loaded from: classes4.dex */
public class YModemThread implements Runnable {
    public static final String TAG = "YModemThread";
    private boolean isStop;
    private YModem mYModem;
    private InputStream mmInStream;
    private OutputStream mmOutStream;
    private OnSendReceiveDataListener onSendReceiveDataListener;
    private SerialPort serial;
    private Thread thread;
    private final NamedThreadFactory threadFactory = new NamedThreadFactory(ExecutorManager.READ_THREAD_NAME);

    /* loaded from: classes4.dex */
    public interface OnSendReceiveDataListener {
        void onReceiveDataError(String str);

        void onReceiveDataSuccess(byte[] bArr);

        void onSendDataError(byte[] bArr, String str);

        void onSendDataSuccess(byte[] bArr);
    }

    public YModemThread(SerialPort serialPort) {
        this.isStop = false;
        setSerial(serialPort);
        this.isStop = true;
    }

    public void setSerial(SerialPort serialPort) {
        this.serial = serialPort;
    }

    public boolean isStop() {
        return this.isStop;
    }

    private void initStream() {
        this.mmInStream = this.serial.getInputStream();
        this.mmOutStream = this.serial.getOutputStream();
    }

    public void startRead() {
        initStream();
        this.isStop = false;
        Thread newThread = this.threadFactory.newThread(this);
        this.thread = newThread;
        newThread.start();
    }

    public void setYModem(YModem yModem) {
        this.mYModem = yModem;
    }

    public void stopRead() {
        Thread thread = this.thread;
        if (thread != null) {
            thread.interrupt();
            this.thread = null;
        }
        this.isStop = true;
    }

    /* JADX WARN: Code restructure failed: missing block: B:7:0x000e, code lost:
        android.util.Log.e(com.pri.prizeinterphone.ymodem.YModemThread.TAG, "YModemThread:run-->输入流mmInStream == null");
     */
    @Override // java.lang.Runnable
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct add '--show-bad-code' argument
    */
    public void run() {
        /*
            r5 = this;
            r0 = 2048(0x800, float:2.87E-42)
            byte[] r0 = new byte[r0]
        L4:
            boolean r1 = r5.isStop
            java.lang.String r2 = "YModemThread"
            if (r1 != 0) goto L97
            java.io.InputStream r1 = r5.mmInStream     // Catch: java.io.IOException -> L56
            if (r1 != 0) goto L15
            java.lang.String r0 = "YModemThread:run-->输入流mmInStream == null"
            android.util.Log.e(r2, r0)     // Catch: java.io.IOException -> L56
            goto L97
        L15:
            int r1 = r1.available()     // Catch: java.io.IOException -> L56
            if (r1 == 0) goto L4
            java.io.InputStream r1 = r5.mmInStream     // Catch: java.io.IOException -> L56
            int r1 = r1.read(r0)     // Catch: java.io.IOException -> L56
            byte[] r1 = java.util.Arrays.copyOf(r0, r1)     // Catch: java.io.IOException -> L56
            java.lang.StringBuilder r3 = new java.lang.StringBuilder     // Catch: java.io.IOException -> L56
            r3.<init>()     // Catch: java.io.IOException -> L56
            java.lang.String r4 = "YModemThread:run-->收到消息,长度"
            r3.append(r4)     // Catch: java.io.IOException -> L56
            int r4 = r1.length     // Catch: java.io.IOException -> L56
            r3.append(r4)     // Catch: java.io.IOException -> L56
            java.lang.String r4 = "->"
            r3.append(r4)     // Catch: java.io.IOException -> L56
            int r4 = r1.length     // Catch: java.io.IOException -> L56
            java.lang.String r4 = bytes2HexString(r1, r4)     // Catch: java.io.IOException -> L56
            r3.append(r4)     // Catch: java.io.IOException -> L56
            java.lang.String r3 = r3.toString()     // Catch: java.io.IOException -> L56
            android.util.Log.w(r2, r3)     // Catch: java.io.IOException -> L56
            com.pri.prizeinterphone.ymodem.YModemThread$OnSendReceiveDataListener r3 = r5.onSendReceiveDataListener     // Catch: java.io.IOException -> L56
            if (r3 == 0) goto L4e
            r3.onReceiveDataSuccess(r1)     // Catch: java.io.IOException -> L56
        L4e:
            com.pri.prizeinterphone.ymodem.YModem r3 = r5.mYModem     // Catch: java.io.IOException -> L56
            if (r3 == 0) goto L4
            r3.onReceiveData(r1)     // Catch: java.io.IOException -> L56
            goto L4
        L56:
            r0 = move-exception
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            java.lang.String r3 = "YModemThread:run-->接收消息异常！"
            r1.append(r3)
            java.lang.String r3 = r0.getMessage()
            r1.append(r3)
            java.lang.String r1 = r1.toString()
            android.util.Log.e(r2, r1)
            com.pri.prizeinterphone.ymodem.YModemThread$OnSendReceiveDataListener r1 = r5.onSendReceiveDataListener
            if (r1 == 0) goto L8c
            java.lang.StringBuilder r3 = new java.lang.StringBuilder
            r3.<init>()
            java.lang.String r4 = "接收消息异常:"
            r3.append(r4)
            java.lang.String r0 = r0.getMessage()
            r3.append(r0)
            java.lang.String r0 = r3.toString()
            r1.onReceiveDataError(r0)
        L8c:
            boolean r0 = r5.cancel()
            if (r0 == 0) goto L97
            java.lang.String r0 = "YModemThread:run-->接收消息异常,成功断开连接！"
            android.util.Log.e(r2, r0)
        L97:
            boolean r5 = r5.cancel()
            if (r5 == 0) goto La2
            java.lang.String r5 = "YModemThread:run-->接收消息结束,断开连接！"
            android.util.Log.d(r2, r5)
        La2:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: com.pri.prizeinterphone.ymodem.YModemThread.run():void");
    }

    public boolean write(byte[] bArr) {
        try {
            OutputStream outputStream = this.mmOutStream;
            if (outputStream == null) {
                Log.e(TAG, "mmOutStream == null");
                return false;
            }
            outputStream.write(bArr);
            Log.d(TAG, "写入成功：" + bytes2HexString(bArr, bArr.length));
            OnSendReceiveDataListener onSendReceiveDataListener = this.onSendReceiveDataListener;
            if (onSendReceiveDataListener != null) {
                onSendReceiveDataListener.onSendDataSuccess(bArr);
                return true;
            }
            return true;
        } catch (IOException unused) {
            Log.e(TAG, "写入失败：" + bytes2HexString(bArr, bArr.length));
            OnSendReceiveDataListener onSendReceiveDataListener2 = this.onSendReceiveDataListener;
            if (onSendReceiveDataListener2 != null) {
                onSendReceiveDataListener2.onSendDataError(bArr, "写入失败");
            }
            return false;
        }
    }

    public boolean cancel() {
        try {
            this.mmInStream = null;
            this.mmOutStream = null;
            Log.w(TAG, "YModemThread:cancel-->成功断开连接");
            return true;
        } catch (Exception e) {
            this.mmInStream = null;
            this.mmOutStream = null;
            Log.e(TAG, "YModemThread:cancel-->断开连接异常！" + e.getMessage());
            return false;
        }
    }

    public static String bytes2HexString(byte[] bArr, int i) {
        StringBuffer stringBuffer = new StringBuffer();
        for (int i2 = 0; i2 < i; i2++) {
            String hexString = Integer.toHexString(bArr[i2] & UByte.MAX_VALUE);
            if (hexString.length() == 1) {
                hexString = '0' + hexString;
            }
            stringBuffer.append(hexString.toUpperCase());
            stringBuffer.append(" ");
        }
        return stringBuffer.toString();
    }

    public void setOnSendReceiveDataListener(OnSendReceiveDataListener onSendReceiveDataListener) {
        this.onSendReceiveDataListener = onSendReceiveDataListener;
    }
}
