package com.android.internal.telephony.imsphone;

import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.telecom.Connection;
import com.android.internal.annotations.VisibleForTesting;
import com.android.telephony.Rlog;
import java.io.IOException;
import java.nio.channels.ClosedByInterruptException;
import java.util.concurrent.CountDownLatch;

public class ImsRttTextHandler extends Handler {
    private static final int APPEND_TO_NETWORK_BUFFER = 2;
    private static final int ATTEMPT_SEND_TO_NETWORK = 4;
    private static final int EXPIRE_SENT_CODEPOINT_COUNT = 5;
    private static final int INITIALIZE = 1;
    private static final String LOG_TAG = "ImsRttTextHandler";
    public static final int MAX_BUFFERED_CHARACTER_COUNT = 5;
    public static final int MAX_BUFFERING_DELAY_MILLIS = 200;
    public static final int MAX_CODEPOINTS_PER_SECOND = 30;
    private static final int MILLIS_PER_SECOND = 1000;
    private static final int SEND_TO_INCALL = 3;
    private static final int TEARDOWN = 9999;
    private StringBuffer mBufferedTextToIncall = new StringBuffer();
    private StringBuffer mBufferedTextToNetwork = new StringBuffer();
    private int mCodepointsAvailableForTransmission = 30;
    private final NetworkWriter mNetworkWriter;
    /* access modifiers changed from: private */
    public CountDownLatch mReadNotifier;
    private InCallReaderThread mReaderThread;
    private Connection.RttTextStream mRttTextStream;

    public interface NetworkWriter {
        void write(String str);
    }

    @VisibleForTesting
    public int getSendToIncall() {
        return 3;
    }

    private class InCallReaderThread extends Thread {
        private final Connection.RttTextStream mReaderThreadRttTextStream;

        public InCallReaderThread(Connection.RttTextStream rttTextStream) {
            this.mReaderThreadRttTextStream = rttTextStream;
        }

        public void run() {
            while (true) {
                try {
                    String read = this.mReaderThreadRttTextStream.read();
                    if (read == null) {
                        Rlog.e(ImsRttTextHandler.LOG_TAG, "RttReaderThread - Stream closed unexpectedly. Attempt to reinitialize.");
                        ImsRttTextHandler.this.obtainMessage(ImsRttTextHandler.TEARDOWN).sendToTarget();
                        return;
                    } else if (read.length() != 0) {
                        ImsRttTextHandler.this.obtainMessage(2, read).sendToTarget();
                        if (ImsRttTextHandler.this.mReadNotifier != null) {
                            ImsRttTextHandler.this.mReadNotifier.countDown();
                        }
                    }
                } catch (ClosedByInterruptException unused) {
                    Rlog.i(ImsRttTextHandler.LOG_TAG, "RttReaderThread - Thread interrupted. Finishing.");
                    return;
                } catch (IOException e) {
                    Rlog.e(ImsRttTextHandler.LOG_TAG, "RttReaderThread - IOException encountered reading from in-call: ", e);
                    ImsRttTextHandler.this.obtainMessage(ImsRttTextHandler.TEARDOWN).sendToTarget();
                    return;
                }
            }
        }
    }

    public void handleMessage(Message message) {
        int i = message.what;
        if (i != 1) {
            if (i == 2) {
                this.mBufferedTextToNetwork.append((String) message.obj);
                StringBuffer stringBuffer = this.mBufferedTextToNetwork;
                if (stringBuffer.codePointCount(0, stringBuffer.length()) >= 5) {
                    sendMessage(obtainMessage(4));
                } else {
                    sendEmptyMessageDelayed(4, 200);
                }
            } else if (i == 3) {
                Object obj = message.obj;
                if (obj == null) {
                    Rlog.e(LOG_TAG, "RTT msg.obj is null. Ignoring.");
                    return;
                }
                String str = (String) obj;
                Connection.RttTextStream rttTextStream = this.mRttTextStream;
                if (rttTextStream == null) {
                    Rlog.e(LOG_TAG, "RTT text stream is null. Writing to in-call buffer.");
                    this.mBufferedTextToIncall.append(str);
                    return;
                }
                try {
                    rttTextStream.write(str);
                } catch (IOException e) {
                    Rlog.e(LOG_TAG, "IOException encountered writing to in-call: %s", e);
                    obtainMessage(TEARDOWN).sendToTarget();
                    this.mBufferedTextToIncall.append(str);
                }
            } else if (i == 4) {
                StringBuffer stringBuffer2 = this.mBufferedTextToNetwork;
                int min = Math.min(stringBuffer2.codePointCount(0, stringBuffer2.length()), this.mCodepointsAvailableForTransmission);
                if (min != 0) {
                    int offsetByCodePoints = this.mBufferedTextToNetwork.offsetByCodePoints(0, min);
                    String substring = this.mBufferedTextToNetwork.substring(0, offsetByCodePoints);
                    this.mBufferedTextToNetwork.delete(0, offsetByCodePoints);
                    this.mNetworkWriter.write(substring);
                    this.mCodepointsAvailableForTransmission -= min;
                    sendMessageDelayed(obtainMessage(5, min, 0), 1000);
                }
            } else if (i == 5) {
                int i2 = this.mCodepointsAvailableForTransmission + message.arg1;
                this.mCodepointsAvailableForTransmission = i2;
                if (i2 > 0) {
                    sendMessage(obtainMessage(4));
                }
            } else if (i == TEARDOWN) {
                try {
                    InCallReaderThread inCallReaderThread = this.mReaderThread;
                    if (inCallReaderThread != null) {
                        inCallReaderThread.interrupt();
                        this.mReaderThread.join(1000);
                    }
                } catch (InterruptedException unused) {
                }
                this.mReaderThread = null;
                this.mRttTextStream = null;
            }
        } else if (this.mRttTextStream == null && this.mReaderThread == null) {
            this.mRttTextStream = (Connection.RttTextStream) message.obj;
            InCallReaderThread inCallReaderThread2 = new InCallReaderThread(this.mRttTextStream);
            this.mReaderThread = inCallReaderThread2;
            inCallReaderThread2.start();
        } else {
            Rlog.e(LOG_TAG, "RTT text stream already initialized. Ignoring.");
        }
    }

    public ImsRttTextHandler(Looper looper, NetworkWriter networkWriter) {
        super(looper);
        this.mNetworkWriter = networkWriter;
    }

    public void sendToInCall(String str) {
        obtainMessage(3, str).sendToTarget();
    }

    public void initialize(Connection.RttTextStream rttTextStream) {
        Rlog.i(LOG_TAG, "Initializing: " + this);
        obtainMessage(1, rttTextStream).sendToTarget();
    }

    public void tearDown() {
        obtainMessage(TEARDOWN).sendToTarget();
    }

    @VisibleForTesting
    public void setReadNotifier(CountDownLatch countDownLatch) {
        this.mReadNotifier = countDownLatch;
    }

    @VisibleForTesting
    public StringBuffer getBufferedTextToIncall() {
        return this.mBufferedTextToIncall;
    }

    @VisibleForTesting
    public void setRttTextStream(Connection.RttTextStream rttTextStream) {
        this.mRttTextStream = rttTextStream;
    }

    public String getNetworkBufferText() {
        return this.mBufferedTextToNetwork.toString();
    }
}
