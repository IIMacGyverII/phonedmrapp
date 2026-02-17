package com.pri.prizeinterphone.ymodem;

import android.content.Context;
import com.pri.prizeinterphone.ymodem.FileStreamThread;
import com.pri.prizeinterphone.ymodem.TimeOutHelper;
import java.io.IOException;

public class YModem implements FileStreamThread.DataRaderListener {
    private static final byte ACK = 6;
    private static final byte CAN = 24;
    private static int CURR_STEP = 1;
    private static final int MAX_PACKAGE_SEND_ERROR_TIMES = 6;
    private static final String MD5_ERR = "MD5_ERR";
    private static final String MD5_OK = "MD5_OK";
    private static final byte NAK = 21;
    private static final int PACKAGE_TIME_OUT = 15000;
    public static final int STEP_END = 32;
    public static final int STEP_EOT = 16;
    public static final int STEP_ERROR = 64;
    public static final int STEP_FILE_BODY = 8;
    public static final int STEP_FILE_NAME = 4;
    public static final int STEP_HELLO = 2;
    public static final int STEP_IDLE = 1;
    private static final byte ST_C = 67;
    static Integer mSize = 1024;
    private int bytesSent;
    /* access modifiers changed from: private */
    public byte[] currSending;
    private final String fileMd5String;
    private final String fileNameString;
    private final String filePath;
    private final YModemListener listener;
    private final Context mContext;
    private int packageErrorTimes;
    private FileStreamThread streamThread;
    private final TimeOutHelper.ITimeOut timeoutListener;
    private final TimeOutHelper timerHelper;

    private YModem(Context context, String str, String str2, String str3, Integer num, YModemListener yModemListener) {
        this.timerHelper = new TimeOutHelper();
        this.bytesSent = 0;
        this.currSending = null;
        this.packageErrorTimes = 0;
        this.timeoutListener = new TimeOutHelper.ITimeOut() {
            public void onTimeOut() {
                Lg.f("------ time out ------");
                if (YModem.this.currSending != null) {
                    YModem.this.handlePackageFail("package timeout...");
                }
            }
        };
        this.filePath = str;
        this.fileNameString = str2;
        this.fileMd5String = str3;
        if (num.intValue() == 0) {
            mSize = 1024;
        }
        mSize = num;
        this.mContext = context;
        this.listener = yModemListener;
    }

    public void start() {
        sendData();
    }

    public void stop() {
        this.bytesSent = 0;
        this.currSending = null;
        this.packageErrorTimes = 0;
        FileStreamThread fileStreamThread = this.streamThread;
        if (fileStreamThread != null) {
            fileStreamThread.release();
        }
        this.timerHelper.stopTimer();
        this.timerHelper.unRegisterListener();
    }

    public void onReceiveData(byte[] bArr) {
        this.timerHelper.stopTimer();
        if (bArr == null || bArr.length <= 0 || bArr.length >= 3) {
            Lg.f("The terminal do responsed something, but received nothing??");
            return;
        }
        Lg.f("YModem received " + bArr.length + " bytes.");
        int i = CURR_STEP;
        if (i == 2) {
            handleData(bArr);
        } else if (i == 4) {
            handleFileName(bArr);
        } else if (i == 8) {
            handleFileBody(bArr);
        } else if (i == 16) {
            handleEOT(bArr);
        } else if (i == 32) {
            handleEnd(bArr);
        }
    }

    private void sendData() {
        this.streamThread = new FileStreamThread(this.mContext, this.filePath, this);
        CURR_STEP = 2;
        Lg.f("StartData!!!");
        sendPackageData(YModemUtil.getYModelData());
    }

    private void sendFileName() {
        CURR_STEP = 4;
        Lg.f("sendFileName");
        try {
            sendPackageData(YModemUtil.getFileNamePackage(this.fileNameString, this.streamThread.getFileByteSize(), this.fileMd5String));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void startSendFileData() {
        CURR_STEP = 8;
        Lg.f("startSendFileData");
        this.streamThread.start();
    }

    public void onDataReady(byte[] bArr) {
        sendPackageData(bArr);
    }

    private void sendEOT() {
        CURR_STEP = 16;
        Lg.f("sendEOT");
        YModemListener yModemListener = this.listener;
        if (yModemListener != null) {
            yModemListener.onDataReady(YModemUtil.getEOT(), CURR_STEP);
        }
    }

    private void sendEND() {
        CURR_STEP = 32;
        Lg.f("sendEND");
        YModemListener yModemListener = this.listener;
        if (yModemListener != null) {
            try {
                yModemListener.onDataReady(YModemUtil.getEnd(), CURR_STEP);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void sendPackageData(byte[] bArr) {
        if (this.listener != null && bArr != null) {
            this.currSending = bArr;
            this.timerHelper.startTimer(this.timeoutListener, 15000);
            this.listener.onDataReady(bArr, CURR_STEP);
        }
    }

    private void handleData(byte[] bArr) {
        byte b = bArr[0];
        if (b == 67) {
            Lg.f("Received 'C'");
            this.packageErrorTimes = 0;
            sendFileName();
            return;
        }
        handleOthers(b);
    }

    private void handleFileName(byte[] bArr) {
        if (bArr.length == 2 && bArr[0] == 6 && bArr[1] == 67) {
            Lg.f("Received 'ACK C'");
            this.packageErrorTimes = 0;
            startSendFileData();
            return;
        }
        byte b = bArr[0];
        if (b == 67) {
            Lg.f("Received 'C'");
            handlePackageFail("Received 'C' without 'ACK' after sent file name");
            return;
        }
        handleOthers(b);
    }

    private void handleFileBody(byte[] bArr) {
        if (bArr.length == 1 && bArr[0] == 6) {
            Lg.f("Received 'ACK'");
            this.packageErrorTimes = 0;
            int length = this.bytesSent + this.currSending.length;
            this.bytesSent = length;
            try {
                YModemListener yModemListener = this.listener;
                if (yModemListener != null) {
                    yModemListener.onProgress(length, this.streamThread.getFileByteSize());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            this.streamThread.keepReading();
        } else if (bArr.length == 1 && bArr[0] == 67) {
            Lg.f("Received 'C'");
            handlePackageFail("Received 'C' after sent file data");
        } else {
            handleOthers(bArr[0]);
        }
    }

    private void handleEOT(byte[] bArr) {
        byte b = bArr[0];
        if (b == 6) {
            Lg.f("Received 'ACK'");
            this.packageErrorTimes = 0;
            sendEND();
        } else if (b == 67) {
            handlePackageFail("Received 'C' after sent EOT");
        } else if (b == 21) {
            sendEOT();
        } else {
            handleOthers(b);
        }
    }

    private void handleEnd(byte[] bArr) {
        if (bArr[0] == 6) {
            Lg.f("Received 'ACK'");
            this.packageErrorTimes = 0;
            YModemListener yModemListener = this.listener;
            if (yModemListener != null) {
                yModemListener.onSuccess();
            }
            stop();
        } else if (new String(bArr).equals(MD5_OK)) {
            Lg.f("Received 'MD5_OK'");
            stop();
            YModemListener yModemListener2 = this.listener;
            if (yModemListener2 != null) {
                yModemListener2.onSuccess();
            }
        } else if (new String(bArr).equals(MD5_ERR)) {
            Lg.f("Received 'MD5_ERR'");
            stop();
            YModemListener yModemListener3 = this.listener;
            if (yModemListener3 != null) {
                yModemListener3.onFailed("MD5 check failed!!!");
            }
        } else {
            handleOthers(bArr[0]);
        }
    }

    private void handleOthers(int i) {
        if (i == 21) {
            Lg.f("Received 'NAK'");
            handlePackageFail("Received NAK");
        } else if (i == 24) {
            Lg.f("Received 'CAN'");
            YModemListener yModemListener = this.listener;
            if (yModemListener != null) {
                yModemListener.onFailed("Received CAN");
            }
            stop();
        }
    }

    /* access modifiers changed from: private */
    public void handlePackageFail(String str) {
        this.packageErrorTimes++;
        Lg.f("Fail:" + str + " for " + this.packageErrorTimes + " times");
        if (this.packageErrorTimes < 6) {
            sendPackageData(this.currSending);
            return;
        }
        stop();
        YModemListener yModemListener = this.listener;
        if (yModemListener != null) {
            yModemListener.onFailed(str);
        }
    }

    public void onFinish() {
        sendEOT();
    }

    public static class Builder {
        private Context context;
        private String fileMd5String;
        private String fileNameString;
        private String filePath;
        private YModemListener listener;
        private Integer size;

        public Builder with(Context context2) {
            this.context = context2;
            return this;
        }

        public Builder filePath(String str) {
            this.filePath = str;
            return this;
        }

        public Builder fileName(String str) {
            this.fileNameString = str;
            return this;
        }

        public Builder sendSize(Integer num) {
            this.size = num;
            return this;
        }

        public Builder checkMd5(String str) {
            this.fileMd5String = str;
            return this;
        }

        public Builder callback(YModemListener yModemListener) {
            this.listener = yModemListener;
            return this;
        }

        public YModem build() {
            return new YModem(this.context, this.filePath, this.fileNameString, this.fileMd5String, this.size, this.listener);
        }
    }
}
