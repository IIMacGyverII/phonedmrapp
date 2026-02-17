package com.pri.prizeinterphone.ymodem;

import android.util.Log;
import com.pri.prizeinterphone.Util.ExecutorManager;
import com.pri.prizeinterphone.Util.NamedThreadFactory;
import com.pri.prizeinterphone.serial.port.SerialPort;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Arrays;
import kotlin.UByte;

public class YModemThread implements Runnable {
    public static final String TAG = "YModemThread";
    private boolean isStop = false;
    private YModem mYModem;
    private InputStream mmInStream;
    private OutputStream mmOutStream;
    private OnSendReceiveDataListener onSendReceiveDataListener;
    private SerialPort serial;
    private Thread thread;
    private final NamedThreadFactory threadFactory = new NamedThreadFactory(ExecutorManager.READ_THREAD_NAME);

    public interface OnSendReceiveDataListener {
        void onReceiveDataError(String str);

        void onReceiveDataSuccess(byte[] bArr);

        void onSendDataError(byte[] bArr, String str);

        void onSendDataSuccess(byte[] bArr);
    }

    public YModemThread(SerialPort serialPort) {
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
        Thread thread2 = this.thread;
        if (thread2 != null) {
            thread2.interrupt();
            this.thread = null;
        }
        this.isStop = true;
    }

    public void run() {
        byte[] bArr = new byte[2048];
        while (true) {
            if (this.isStop) {
                break;
            }
            try {
                InputStream inputStream = this.mmInStream;
                if (inputStream == null) {
                    Log.e(TAG, "YModemThread:run-->输入流mmInStream == null");
                    break;
                } else if (inputStream.available() != 0) {
                    byte[] copyOf = Arrays.copyOf(bArr, this.mmInStream.read(bArr));
                    Log.w(TAG, "YModemThread:run-->收到消息,长度" + copyOf.length + "->" + bytes2HexString(copyOf, copyOf.length));
                    OnSendReceiveDataListener onSendReceiveDataListener2 = this.onSendReceiveDataListener;
                    if (onSendReceiveDataListener2 != null) {
                        onSendReceiveDataListener2.onReceiveDataSuccess(copyOf);
                    }
                    YModem yModem = this.mYModem;
                    if (yModem != null) {
                        yModem.onReceiveData(copyOf);
                    }
                }
            } catch (IOException e) {
                Log.e(TAG, "YModemThread:run-->接收消息异常！" + e.getMessage());
                OnSendReceiveDataListener onSendReceiveDataListener3 = this.onSendReceiveDataListener;
                if (onSendReceiveDataListener3 != null) {
                    onSendReceiveDataListener3.onReceiveDataError("接收消息异常:" + e.getMessage());
                }
                if (cancel()) {
                    Log.e(TAG, "YModemThread:run-->接收消息异常,成功断开连接！");
                }
            }
        }
        if (cancel()) {
            Log.d(TAG, "YModemThread:run-->接收消息结束,断开连接！");
        }
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
            OnSendReceiveDataListener onSendReceiveDataListener2 = this.onSendReceiveDataListener;
            if (onSendReceiveDataListener2 == null) {
                return true;
            }
            onSendReceiveDataListener2.onSendDataSuccess(bArr);
            return true;
        } catch (IOException unused) {
            Log.e(TAG, "写入失败：" + bytes2HexString(bArr, bArr.length));
            OnSendReceiveDataListener onSendReceiveDataListener3 = this.onSendReceiveDataListener;
            if (onSendReceiveDataListener3 != null) {
                onSendReceiveDataListener3.onSendDataError(bArr, "写入失败");
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

    public void setOnSendReceiveDataListener(OnSendReceiveDataListener onSendReceiveDataListener2) {
        this.onSendReceiveDataListener = onSendReceiveDataListener2;
    }
}
