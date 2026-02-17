package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.os.AsyncResult;
import android.os.Message;
import android.os.SystemClock;
import android.os.WorkSource;
import com.android.telephony.Rlog;
import java.util.List;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

public class RILRequest {
    static final String LOG_TAG = "RilRequest";
    private static final int MAX_POOL_SIZE = 4;
    static AtomicInteger sNextSerial = new AtomicInteger(0);
    private static RILRequest sPool = null;
    private static int sPoolSize = 0;
    private static Object sPoolSync = new Object();
    static Random sRandom = new Random();
    Object[] mArguments;
    String mClientId;
    RILRequest mNext;
    @UnsupportedAppUsage
    public int mRequest;
    @UnsupportedAppUsage
    public Message mResult;
    @UnsupportedAppUsage
    public int mSerial;
    long mStartTimeMs;
    int mWakeLockType;
    WorkSource mWorkSource;

    public int getSerial() {
        return this.mSerial;
    }

    public int getRequest() {
        return this.mRequest;
    }

    public Message getResult() {
        return this.mResult;
    }

    @UnsupportedAppUsage
    private static RILRequest obtain(int i, Message message) {
        RILRequest rILRequest;
        synchronized (sPoolSync) {
            rILRequest = sPool;
            if (rILRequest != null) {
                sPool = rILRequest.mNext;
                rILRequest.mNext = null;
                sPoolSize--;
            } else {
                rILRequest = null;
            }
        }
        if (rILRequest == null) {
            rILRequest = new RILRequest();
        }
        rILRequest.mSerial = sNextSerial.getAndUpdate(new RILRequest$$ExternalSyntheticLambda0());
        rILRequest.mRequest = i;
        rILRequest.mResult = message;
        rILRequest.mWakeLockType = -1;
        rILRequest.mWorkSource = null;
        rILRequest.mStartTimeMs = SystemClock.elapsedRealtime();
        if (message == null || message.getTarget() != null) {
            return rILRequest;
        }
        throw new NullPointerException("Message target must not be null");
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ int lambda$obtain$0(int i) {
        return (i + 1) % Integer.MAX_VALUE;
    }

    public static RILRequest obtain(int i, Message message, WorkSource workSource) {
        RILRequest obtain = obtain(i, message);
        if (workSource != null) {
            obtain.mWorkSource = workSource;
            obtain.mClientId = obtain.getWorkSourceClientId();
        } else {
            Rlog.e(LOG_TAG, "null workSource " + i);
        }
        return obtain;
    }

    public static RILRequest obtain(int i, Message message, WorkSource workSource, Object... objArr) {
        RILRequest obtain = obtain(i, message, workSource);
        obtain.mArguments = objArr;
        return obtain;
    }

    public String getWorkSourceClientId() {
        WorkSource workSource = this.mWorkSource;
        if (workSource != null && !workSource.isEmpty()) {
            if (this.mWorkSource.size() > 0) {
                return this.mWorkSource.getUid(0) + ":" + this.mWorkSource.getPackageName(0);
            }
            List workChains = this.mWorkSource.getWorkChains();
            if (workChains != null && !workChains.isEmpty()) {
                return ((WorkSource.WorkChain) workChains.get(0)).toString();
            }
        }
        return null;
    }

    /* access modifiers changed from: package-private */
    @UnsupportedAppUsage
    public void release() {
        synchronized (sPoolSync) {
            int i = sPoolSize;
            if (i < 4) {
                this.mNext = sPool;
                sPool = this;
                sPoolSize = i + 1;
                this.mResult = null;
                int i2 = this.mWakeLockType;
                if (i2 != -1 && i2 == 0) {
                    Rlog.e(LOG_TAG, "RILRequest releasing with held wake lock: " + serialString());
                }
                this.mArguments = null;
            }
        }
    }

    private RILRequest() {
    }

    static void resetSerial() {
        sNextSerial.set(sRandom.nextInt(Integer.MAX_VALUE));
    }

    @UnsupportedAppUsage
    public String serialString() {
        StringBuilder sb = new StringBuilder(8);
        String num = Integer.toString(this.mSerial % 10000);
        sb.append('[');
        int length = num.length();
        for (int i = 0; i < 4 - length; i++) {
            sb.append('0');
        }
        sb.append(num);
        sb.append(']');
        return sb.toString();
    }

    /* access modifiers changed from: package-private */
    @UnsupportedAppUsage
    public void onError(int i, Object obj) {
        CommandException fromRilErrno = CommandException.fromRilErrno(i);
        Message message = this.mResult;
        Rlog.d(LOG_TAG, serialString() + "< " + RILUtils.requestToString(this.mRequest) + " error: " + fromRilErrno + " ret=" + RIL.retToString(this.mRequest, obj) + " result=" + message);
        if (message != null && message.getTarget() != null) {
            AsyncResult.forMessage(message, obj, fromRilErrno);
            message.sendToTarget();
        }
    }

    public String toString() {
        return serialString() + ": " + RILUtils.requestToString(this.mRequest);
    }
}
