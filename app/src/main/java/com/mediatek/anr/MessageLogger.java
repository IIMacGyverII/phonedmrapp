package com.mediatek.anr;

import android.os.Looper;
import android.os.Message;
import android.os.MessageQueue;
import android.os.Process;
import android.util.Printer;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

public class MessageLogger implements Printer {
    static final int LONGER_TIME = 200;
    static final int LONGER_TIME_MESSAGE_COUNT = 20;
    static final int MESSAGE_COUNT = 20;
    private static final int MESSAGE_DUMP_SIZE_MAX = 20;
    private static final String TAG = "MessageLogger";
    public static boolean mEnableLooperLog = false;
    private static Method sGetCurrentTimeMicro = getSystemClockMethod("currentTimeMicro");
    private String MSL_Warn = "MSL Waraning:";
    private Method mGetMessageQueue = getLooperMethod("getQueue");
    private String mLastRecord = null;
    private long mLastRecordDateTime;
    private long mLastRecordKernelTime;
    private CircularMessageInfoArray mLongTimeMessageHistory;
    private Field mMessageField = getMessageField("next");
    private CircularMessageInfoArray mMessageHistory;
    private Field mMessageQueueField = getMessageQueueField("mMessages");
    private long mMsgCnt = 0;
    private String mName = null;
    private long mNonSleepLastRecordKernelTime;
    private long mProcessId;
    private int mState = 0;
    private StringBuilder messageInfo;
    public long nonSleepWallStart;
    public long nonSleepWallTime;
    private String sInstNotCreated = (this.MSL_Warn + "!!! MessageLoggerInstance might not be created !!!\n");
    public long wallStart;
    public long wallTime;

    private static Method getSystemClockMethod(String str) {
        try {
            return Class.forName("android.os.SystemClock").getDeclaredMethod(str, new Class[0]);
        } catch (Exception unused) {
            return null;
        }
    }

    private Method getLooperMethod(String str) {
        try {
            return Class.forName("android.os.Looper").getDeclaredMethod(str, new Class[0]);
        } catch (Exception unused) {
            return null;
        }
    }

    private Field getMessageQueueField(String str) {
        try {
            Field declaredField = Class.forName("android.os.MessageQueue").getDeclaredField(str);
            declaredField.setAccessible(true);
            return declaredField;
        } catch (Exception unused) {
            return null;
        }
    }

    private Field getMessageField(String str) {
        try {
            Field declaredField = Class.forName("android.os.Message").getDeclaredField(str);
            declaredField.setAccessible(true);
            return declaredField;
        } catch (Exception unused) {
            return null;
        }
    }

    public MessageLogger() {
        init();
    }

    public MessageLogger(boolean z) {
        mEnableLooperLog = z;
        init();
    }

    public MessageLogger(boolean z, String str) {
        this.mName = str;
        mEnableLooperLog = z;
        init();
    }

    private void init() {
        this.mMessageHistory = new CircularMessageInfoArray(20);
        this.mLongTimeMessageHistory = new CircularMessageInfoArray(20);
        this.messageInfo = new StringBuilder(20480);
        this.mProcessId = (long) Process.myPid();
    }

    /* JADX WARNING: Can't wrap try/catch for region: R(12:1|2|3|4|5|(1:7)|8|9|(1:11)(2:12|(1:14))|15|(2:17|(1:19)(1:20))|21) */
    /* JADX WARNING: Missing exception handler attribute for start block: B:8:0x002e */
    /* JADX WARNING: Removed duplicated region for block: B:11:0x0032  */
    /* JADX WARNING: Removed duplicated region for block: B:12:0x004a  */
    /* JADX WARNING: Removed duplicated region for block: B:17:0x007c  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void println(java.lang.String r9) {
        /*
            r8 = this;
            monitor-enter(r8)
            int r0 = r8.mState     // Catch:{ all -> 0x00c6 }
            r1 = 1
            int r0 = r0 + r1
            r8.mState = r0     // Catch:{ all -> 0x00c6 }
            long r2 = r8.mMsgCnt     // Catch:{ all -> 0x00c6 }
            r4 = 1
            long r2 = r2 + r4
            r8.mMsgCnt = r2     // Catch:{ all -> 0x00c6 }
            long r2 = android.os.SystemClock.elapsedRealtime()     // Catch:{ all -> 0x00c6 }
            r8.mLastRecordKernelTime = r2     // Catch:{ all -> 0x00c6 }
            long r2 = android.os.SystemClock.uptimeMillis()     // Catch:{ all -> 0x00c6 }
            r8.mNonSleepLastRecordKernelTime = r2     // Catch:{ all -> 0x00c6 }
            r0 = 0
            java.lang.reflect.Method r2 = sGetCurrentTimeMicro     // Catch:{ Exception -> 0x002e }
            if (r2 == 0) goto L_0x002e
            r3 = 0
            java.lang.Object[] r4 = new java.lang.Object[r0]     // Catch:{ Exception -> 0x002e }
            java.lang.Object r2 = r2.invoke(r3, r4)     // Catch:{ Exception -> 0x002e }
            java.lang.Long r2 = (java.lang.Long) r2     // Catch:{ Exception -> 0x002e }
            long r2 = r2.longValue()     // Catch:{ Exception -> 0x002e }
            r8.mLastRecordDateTime = r2     // Catch:{ Exception -> 0x002e }
        L_0x002e:
            int r2 = r8.mState     // Catch:{ all -> 0x00c6 }
            if (r2 != r1) goto L_0x004a
            com.mediatek.anr.MessageLogger$CircularMessageInfoArray r0 = r8.mMessageHistory     // Catch:{ all -> 0x00c6 }
            com.mediatek.anr.MessageLogger$MessageInfo r0 = r0.add()     // Catch:{ all -> 0x00c6 }
            r0.init()     // Catch:{ all -> 0x00c6 }
            r0.startDispatch = r9     // Catch:{ all -> 0x00c6 }
            long r2 = r8.mMsgCnt     // Catch:{ all -> 0x00c6 }
            r0.msgIdStart = r2     // Catch:{ all -> 0x00c6 }
            long r2 = r8.mLastRecordDateTime     // Catch:{ all -> 0x00c6 }
            r0.startTimeElapsed = r2     // Catch:{ all -> 0x00c6 }
            long r2 = r8.mNonSleepLastRecordKernelTime     // Catch:{ all -> 0x00c6 }
            r0.startTimeUp = r2     // Catch:{ all -> 0x00c6 }
            goto L_0x0078
        L_0x004a:
            r8.mState = r0     // Catch:{ all -> 0x00c6 }
            com.mediatek.anr.MessageLogger$CircularMessageInfoArray r0 = r8.mMessageHistory     // Catch:{ all -> 0x00c6 }
            com.mediatek.anr.MessageLogger$MessageInfo r0 = r0.getLast()     // Catch:{ all -> 0x00c6 }
            r0.finishDispatch = r9     // Catch:{ all -> 0x00c6 }
            long r2 = r8.mMsgCnt     // Catch:{ all -> 0x00c6 }
            r0.msgIdFinish = r2     // Catch:{ all -> 0x00c6 }
            long r2 = r8.mLastRecordDateTime     // Catch:{ all -> 0x00c6 }
            long r4 = r0.startTimeElapsed     // Catch:{ all -> 0x00c6 }
            long r2 = r2 - r4
            r0.durationElapsed = r2     // Catch:{ all -> 0x00c6 }
            long r4 = r8.mNonSleepLastRecordKernelTime     // Catch:{ all -> 0x00c6 }
            long r6 = r0.startTimeUp     // Catch:{ all -> 0x00c6 }
            long r4 = r4 - r6
            r0.durationUp = r4     // Catch:{ all -> 0x00c6 }
            r8.wallTime = r2     // Catch:{ all -> 0x00c6 }
            r4 = 200000(0x30d40, double:9.8813E-319)
            int r2 = (r2 > r4 ? 1 : (r2 == r4 ? 0 : -1))
            if (r2 < 0) goto L_0x0078
            com.mediatek.anr.MessageLogger$CircularMessageInfoArray r2 = r8.mLongTimeMessageHistory     // Catch:{ all -> 0x00c6 }
            com.mediatek.anr.MessageLogger$MessageInfo r2 = r2.add()     // Catch:{ all -> 0x00c6 }
            r2.copy(r0)     // Catch:{ all -> 0x00c6 }
        L_0x0078:
            boolean r0 = mEnableLooperLog     // Catch:{ all -> 0x00c6 }
            if (r0 == 0) goto L_0x00c4
            int r0 = r8.mState     // Catch:{ all -> 0x00c6 }
            if (r0 != r1) goto L_0x009c
            java.lang.String r0 = "MessageLogger"
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x00c6 }
            r1.<init>()     // Catch:{ all -> 0x00c6 }
            java.lang.String r2 = "Debugging_MessageLogger: "
            r1.append(r2)     // Catch:{ all -> 0x00c6 }
            r1.append(r9)     // Catch:{ all -> 0x00c6 }
            java.lang.String r9 = " start"
            r1.append(r9)     // Catch:{ all -> 0x00c6 }
            java.lang.String r9 = r1.toString()     // Catch:{ all -> 0x00c6 }
            android.util.Log.d(r0, r9)     // Catch:{ all -> 0x00c6 }
            goto L_0x00c4
        L_0x009c:
            java.lang.String r0 = "MessageLogger"
            java.lang.StringBuilder r1 = new java.lang.StringBuilder     // Catch:{ all -> 0x00c6 }
            r1.<init>()     // Catch:{ all -> 0x00c6 }
            java.lang.String r2 = "Debugging_MessageLogger: "
            r1.append(r2)     // Catch:{ all -> 0x00c6 }
            r1.append(r9)     // Catch:{ all -> 0x00c6 }
            java.lang.String r9 = " spent "
            r1.append(r9)     // Catch:{ all -> 0x00c6 }
            long r2 = r8.wallTime     // Catch:{ all -> 0x00c6 }
            r4 = 1000(0x3e8, double:4.94E-321)
            long r2 = r2 / r4
            r1.append(r2)     // Catch:{ all -> 0x00c6 }
            java.lang.String r9 = "ms"
            r1.append(r9)     // Catch:{ all -> 0x00c6 }
            java.lang.String r9 = r1.toString()     // Catch:{ all -> 0x00c6 }
            android.util.Log.d(r0, r9)     // Catch:{ all -> 0x00c6 }
        L_0x00c4:
            monitor-exit(r8)     // Catch:{ all -> 0x00c6 }
            return
        L_0x00c6:
            r9 = move-exception
            monitor-exit(r8)     // Catch:{ all -> 0x00c6 }
            throw r9
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.anr.MessageLogger.println(java.lang.String):void");
    }

    public void setInitStr(String str) {
        StringBuilder sb = this.messageInfo;
        sb.delete(0, sb.length());
        this.messageInfo.append(str);
    }

    private void log(String str) {
        StringBuilder sb = this.messageInfo;
        sb.append(str);
        sb.append("\n");
    }

    public void dumpMessageQueue() {
        try {
            Looper mainLooper = Looper.getMainLooper();
            if (mainLooper == null) {
                log(this.MSL_Warn + "!!! Current MainLooper is Null !!!");
            } else {
                MessageQueue messageQueue = (MessageQueue) this.mGetMessageQueue.invoke(mainLooper, new Object[0]);
                if (messageQueue == null) {
                    log(this.MSL_Warn + "!!! Current MainLooper's MsgQueue is Null !!!");
                } else {
                    dumpMessageQueueImpl(messageQueue);
                }
            }
        } catch (Exception unused) {
        }
        log(String.format(this.MSL_Warn + "!!! Calling thread from PID:%d's TID:%d(%s),Thread's type is %s!!!", new Object[]{Integer.valueOf(Process.myPid()), Long.valueOf(Thread.currentThread().getId()), Thread.currentThread().getName(), Thread.currentThread().getClass().getName()}));
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        log(String.format(this.MSL_Warn + "!!! get StackTrace: !!!", new Object[0]));
        for (int i = 0; i < stackTrace.length; i++) {
            log(String.format(this.MSL_Warn + "File:%s's Linenumber:%d, Class:%s, Method:%s", new Object[]{stackTrace[i].getFileName(), Integer.valueOf(stackTrace[i].getLineNumber()), stackTrace[i].getClassName(), stackTrace[i].getMethodName()}));
        }
    }

    public void dumpMessageQueueImpl(MessageQueue messageQueue) throws Exception {
        synchronized (messageQueue) {
            Message message = null;
            Field field = this.mMessageQueueField;
            if (field != null) {
                message = (Message) field.get(messageQueue);
            }
            if (message != null) {
                log("Dump first 20 messages in Queue: ");
                int i = 0;
                while (message != null) {
                    i++;
                    if (i <= 20) {
                        log("Dump Message in Queue (" + i + "): " + message);
                    }
                    message = (Message) this.mMessageField.get(message);
                }
                log("Total Message Count: " + i);
            } else {
                log("mMessages is null");
            }
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:12:0x00c8 A[Catch:{ RemoteException -> 0x01d8 }] */
    /* JADX WARNING: Removed duplicated region for block: B:17:0x0142 A[Catch:{ RemoteException -> 0x01d8 }] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void dumpMessageHistory() {
        /*
            r14 = this;
            monitor-enter(r14)
            java.lang.String r0 = ">>> Entering MessageLogger.dump. to Dump MSG HISTORY <<<"
            r14.log(r0)     // Catch:{ all -> 0x0224 }
            com.mediatek.anr.MessageLogger$CircularMessageInfoArray r0 = r14.mMessageHistory     // Catch:{ all -> 0x0224 }
            if (r0 == 0) goto L_0x01f1
            int r0 = r0.size()     // Catch:{ all -> 0x0224 }
            if (r0 != 0) goto L_0x0012
            goto L_0x01f1
        L_0x0012:
            java.lang.String r0 = "MSG HISTORY IN MAIN THREAD:"
            r14.log(r0)     // Catch:{ all -> 0x0224 }
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch:{ all -> 0x0224 }
            r0.<init>()     // Catch:{ all -> 0x0224 }
            java.lang.String r1 = "Current kernel time : "
            r0.append(r1)     // Catch:{ all -> 0x0224 }
            long r1 = android.os.SystemClock.uptimeMillis()     // Catch:{ all -> 0x0224 }
            r0.append(r1)     // Catch:{ all -> 0x0224 }
            java.lang.String r1 = "ms PID="
            r0.append(r1)     // Catch:{ all -> 0x0224 }
            long r1 = r14.mProcessId     // Catch:{ all -> 0x0224 }
            r0.append(r1)     // Catch:{ all -> 0x0224 }
            java.lang.String r0 = r0.toString()     // Catch:{ all -> 0x0224 }
            r14.log(r0)     // Catch:{ all -> 0x0224 }
            java.text.SimpleDateFormat r0 = new java.text.SimpleDateFormat     // Catch:{ all -> 0x0224 }
            java.lang.String r1 = "yyyy-MM-dd HH:mm:ss.SSS"
            r0.<init>(r1)     // Catch:{ all -> 0x0224 }
            com.mediatek.anr.MessageLogger$CircularMessageInfoArray r1 = r14.mMessageHistory     // Catch:{ all -> 0x0224 }
            int r1 = r1.size()     // Catch:{ all -> 0x0224 }
            r2 = 1
            int r1 = r1 - r2
            int r3 = r14.mState     // Catch:{ all -> 0x0224 }
            r4 = 1000(0x3e8, double:4.94E-321)
            if (r3 != r2) goto L_0x00c6
            java.util.Date r3 = new java.util.Date     // Catch:{ all -> 0x0224 }
            long r6 = r14.mLastRecordDateTime     // Catch:{ all -> 0x0224 }
            long r6 = r6 / r4
            r3.<init>(r6)     // Catch:{ all -> 0x0224 }
            long r6 = android.os.SystemClock.elapsedRealtime()     // Catch:{ all -> 0x0224 }
            long r8 = r14.mLastRecordKernelTime     // Catch:{ all -> 0x0224 }
            long r6 = r6 - r8
            long r8 = android.os.SystemClock.uptimeMillis()     // Catch:{ all -> 0x0224 }
            long r10 = r14.mNonSleepLastRecordKernelTime     // Catch:{ all -> 0x0224 }
            long r8 = r8 - r10
            com.mediatek.anr.MessageLogger$CircularMessageInfoArray r10 = r14.mMessageHistory     // Catch:{ all -> 0x0224 }
            com.mediatek.anr.MessageLogger$MessageInfo r10 = r10.getLast()     // Catch:{ all -> 0x0224 }
            java.lang.StringBuilder r11 = new java.lang.StringBuilder     // Catch:{ all -> 0x0224 }
            r11.<init>()     // Catch:{ all -> 0x0224 }
            java.lang.String r12 = "Last record : Msg#:"
            r11.append(r12)     // Catch:{ all -> 0x0224 }
            long r12 = r10.msgIdStart     // Catch:{ all -> 0x0224 }
            r11.append(r12)     // Catch:{ all -> 0x0224 }
            java.lang.String r12 = " "
            r11.append(r12)     // Catch:{ all -> 0x0224 }
            java.lang.String r10 = r10.startDispatch     // Catch:{ all -> 0x0224 }
            r11.append(r10)     // Catch:{ all -> 0x0224 }
            java.lang.String r10 = r11.toString()     // Catch:{ all -> 0x0224 }
            r14.log(r10)     // Catch:{ all -> 0x0224 }
            java.lang.StringBuilder r10 = new java.lang.StringBuilder     // Catch:{ all -> 0x0224 }
            r10.<init>()     // Catch:{ all -> 0x0224 }
            java.lang.String r11 = "Last record dispatching elapsedTime:"
            r10.append(r11)     // Catch:{ all -> 0x0224 }
            r10.append(r6)     // Catch:{ all -> 0x0224 }
            java.lang.String r6 = " ms/upTime:"
            r10.append(r6)     // Catch:{ all -> 0x0224 }
            r10.append(r8)     // Catch:{ all -> 0x0224 }
            java.lang.String r6 = " ms"
            r10.append(r6)     // Catch:{ all -> 0x0224 }
            java.lang.String r6 = r10.toString()     // Catch:{ all -> 0x0224 }
            r14.log(r6)     // Catch:{ all -> 0x0224 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0224 }
            r6.<init>()     // Catch:{ all -> 0x0224 }
            java.lang.String r7 = "Last record dispatching time : "
            r6.append(r7)     // Catch:{ all -> 0x0224 }
            java.lang.String r3 = r0.format(r3)     // Catch:{ all -> 0x0224 }
            r6.append(r3)     // Catch:{ all -> 0x0224 }
            java.lang.String r3 = r6.toString()     // Catch:{ all -> 0x0224 }
            r14.log(r3)     // Catch:{ all -> 0x0224 }
            goto L_0x013f
        L_0x00c6:
            if (r1 < 0) goto L_0x0142
            com.mediatek.anr.MessageLogger$CircularMessageInfoArray r3 = r14.mMessageHistory     // Catch:{ all -> 0x0224 }
            com.mediatek.anr.MessageLogger$MessageInfo r3 = r3.get(r1)     // Catch:{ all -> 0x0224 }
            if (r3 != 0) goto L_0x00d1
            goto L_0x013f
        L_0x00d1:
            java.util.Date r6 = new java.util.Date     // Catch:{ all -> 0x0224 }
            long r7 = r3.startTimeElapsed     // Catch:{ all -> 0x0224 }
            long r7 = r7 / r4
            r6.<init>(r7)     // Catch:{ all -> 0x0224 }
            java.lang.StringBuilder r7 = new java.lang.StringBuilder     // Catch:{ all -> 0x0224 }
            r7.<init>()     // Catch:{ all -> 0x0224 }
            java.lang.String r8 = "Msg#:"
            r7.append(r8)     // Catch:{ all -> 0x0224 }
            long r8 = r3.msgIdFinish     // Catch:{ all -> 0x0224 }
            r7.append(r8)     // Catch:{ all -> 0x0224 }
            java.lang.String r8 = " "
            r7.append(r8)     // Catch:{ all -> 0x0224 }
            java.lang.String r8 = r3.finishDispatch     // Catch:{ all -> 0x0224 }
            r7.append(r8)     // Catch:{ all -> 0x0224 }
            java.lang.String r8 = " elapsedTime:"
            r7.append(r8)     // Catch:{ all -> 0x0224 }
            long r8 = r3.durationElapsed     // Catch:{ all -> 0x0224 }
            long r8 = r8 / r4
            r7.append(r8)     // Catch:{ all -> 0x0224 }
            java.lang.String r8 = " ms/upTime:"
            r7.append(r8)     // Catch:{ all -> 0x0224 }
            long r8 = r3.durationUp     // Catch:{ all -> 0x0224 }
            r7.append(r8)     // Catch:{ all -> 0x0224 }
            java.lang.String r8 = " ms"
            r7.append(r8)     // Catch:{ all -> 0x0224 }
            java.lang.String r7 = r7.toString()     // Catch:{ all -> 0x0224 }
            r14.log(r7)     // Catch:{ all -> 0x0224 }
            java.lang.StringBuilder r7 = new java.lang.StringBuilder     // Catch:{ all -> 0x0224 }
            r7.<init>()     // Catch:{ all -> 0x0224 }
            java.lang.String r8 = "Msg#:"
            r7.append(r8)     // Catch:{ all -> 0x0224 }
            long r8 = r3.msgIdStart     // Catch:{ all -> 0x0224 }
            r7.append(r8)     // Catch:{ all -> 0x0224 }
            java.lang.String r8 = " "
            r7.append(r8)     // Catch:{ all -> 0x0224 }
            java.lang.String r3 = r3.startDispatch     // Catch:{ all -> 0x0224 }
            r7.append(r3)     // Catch:{ all -> 0x0224 }
            java.lang.String r3 = " from "
            r7.append(r3)     // Catch:{ all -> 0x0224 }
            java.lang.String r3 = r0.format(r6)     // Catch:{ all -> 0x0224 }
            r7.append(r3)     // Catch:{ all -> 0x0224 }
            java.lang.String r3 = r7.toString()     // Catch:{ all -> 0x0224 }
            r14.log(r3)     // Catch:{ all -> 0x0224 }
        L_0x013f:
            int r1 = r1 + -1
            goto L_0x00c6
        L_0x0142:
            java.lang.String r1 = "=== Finish Dumping MSG HISTORY==="
            r14.log(r1)     // Catch:{ all -> 0x0224 }
            java.lang.String r1 = "=== LONGER MSG HISTORY IN MAIN THREAD ==="
            r14.log(r1)     // Catch:{ all -> 0x0224 }
            com.mediatek.anr.MessageLogger$CircularMessageInfoArray r1 = r14.mLongTimeMessageHistory     // Catch:{ all -> 0x0224 }
            int r1 = r1.size()     // Catch:{ all -> 0x0224 }
            int r1 = r1 - r2
        L_0x0153:
            if (r1 < 0) goto L_0x01af
            com.mediatek.anr.MessageLogger$CircularMessageInfoArray r2 = r14.mLongTimeMessageHistory     // Catch:{ all -> 0x0224 }
            com.mediatek.anr.MessageLogger$MessageInfo r2 = r2.get(r1)     // Catch:{ all -> 0x0224 }
            if (r2 != 0) goto L_0x015e
            goto L_0x01ac
        L_0x015e:
            java.util.Date r3 = new java.util.Date     // Catch:{ all -> 0x0224 }
            long r6 = r2.startTimeElapsed     // Catch:{ all -> 0x0224 }
            long r6 = r6 / r4
            r3.<init>(r6)     // Catch:{ all -> 0x0224 }
            java.lang.StringBuilder r6 = new java.lang.StringBuilder     // Catch:{ all -> 0x0224 }
            r6.<init>()     // Catch:{ all -> 0x0224 }
            java.lang.String r7 = "Msg#:"
            r6.append(r7)     // Catch:{ all -> 0x0224 }
            long r7 = r2.msgIdStart     // Catch:{ all -> 0x0224 }
            r6.append(r7)     // Catch:{ all -> 0x0224 }
            java.lang.String r7 = " "
            r6.append(r7)     // Catch:{ all -> 0x0224 }
            java.lang.String r7 = r2.startDispatch     // Catch:{ all -> 0x0224 }
            r6.append(r7)     // Catch:{ all -> 0x0224 }
            java.lang.String r7 = " from "
            r6.append(r7)     // Catch:{ all -> 0x0224 }
            java.lang.String r3 = r0.format(r3)     // Catch:{ all -> 0x0224 }
            r6.append(r3)     // Catch:{ all -> 0x0224 }
            java.lang.String r3 = " elapsedTime:"
            r6.append(r3)     // Catch:{ all -> 0x0224 }
            long r7 = r2.durationElapsed     // Catch:{ all -> 0x0224 }
            long r7 = r7 / r4
            r6.append(r7)     // Catch:{ all -> 0x0224 }
            java.lang.String r3 = " ms/upTime:"
            r6.append(r3)     // Catch:{ all -> 0x0224 }
            long r2 = r2.durationUp     // Catch:{ all -> 0x0224 }
            r6.append(r2)     // Catch:{ all -> 0x0224 }
            java.lang.String r2 = "ms"
            r6.append(r2)     // Catch:{ all -> 0x0224 }
            java.lang.String r2 = r6.toString()     // Catch:{ all -> 0x0224 }
            r14.log(r2)     // Catch:{ all -> 0x0224 }
        L_0x01ac:
            int r1 = r1 + -1
            goto L_0x0153
        L_0x01af:
            java.lang.String r0 = "=== Finish Dumping LONGER MSG HISTORY==="
            r14.log(r0)     // Catch:{ all -> 0x0224 }
            r14.dumpMessageQueue()     // Catch:{ RemoteException -> 0x01d8 }
            com.mediatek.anr.IAnrManager r0 = com.mediatek.anr.AnrManagerNative.getDefault()     // Catch:{ RemoteException -> 0x01d8 }
            java.lang.String r1 = new java.lang.String     // Catch:{ RemoteException -> 0x01d8 }
            java.lang.StringBuilder r2 = r14.messageInfo     // Catch:{ RemoteException -> 0x01d8 }
            java.lang.String r2 = r2.toString()     // Catch:{ RemoteException -> 0x01d8 }
            r1.<init>(r2)     // Catch:{ RemoteException -> 0x01d8 }
            int r2 = android.os.Process.myPid()     // Catch:{ RemoteException -> 0x01d8 }
            r0.informMessageDump(r1, r2)     // Catch:{ RemoteException -> 0x01d8 }
            java.lang.StringBuilder r0 = r14.messageInfo     // Catch:{ RemoteException -> 0x01d8 }
            r1 = 0
            int r2 = r0.length()     // Catch:{ RemoteException -> 0x01d8 }
            r0.delete(r1, r2)     // Catch:{ RemoteException -> 0x01d8 }
            goto L_0x01ef
        L_0x01d8:
            r0 = move-exception
            java.lang.String r1 = "MessageLogger"
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x0224 }
            r2.<init>()     // Catch:{ all -> 0x0224 }
            java.lang.String r3 = "informMessageDump exception "
            r2.append(r3)     // Catch:{ all -> 0x0224 }
            r2.append(r0)     // Catch:{ all -> 0x0224 }
            java.lang.String r0 = r2.toString()     // Catch:{ all -> 0x0224 }
            android.util.Log.d(r1, r0)     // Catch:{ all -> 0x0224 }
        L_0x01ef:
            monitor-exit(r14)     // Catch:{ all -> 0x0224 }
            return
        L_0x01f1:
            java.lang.String r0 = r14.sInstNotCreated     // Catch:{ all -> 0x0224 }
            r14.log(r0)     // Catch:{ all -> 0x0224 }
            r14.dumpMessageQueue()     // Catch:{ all -> 0x0224 }
            com.mediatek.anr.IAnrManager r0 = com.mediatek.anr.AnrManagerNative.getDefault()     // Catch:{ RemoteException -> 0x020b }
            java.lang.StringBuilder r1 = r14.messageInfo     // Catch:{ RemoteException -> 0x020b }
            java.lang.String r1 = r1.toString()     // Catch:{ RemoteException -> 0x020b }
            int r2 = android.os.Process.myPid()     // Catch:{ RemoteException -> 0x020b }
            r0.informMessageDump(r1, r2)     // Catch:{ RemoteException -> 0x020b }
            goto L_0x0222
        L_0x020b:
            r0 = move-exception
            java.lang.String r1 = "MessageLogger"
            java.lang.StringBuilder r2 = new java.lang.StringBuilder     // Catch:{ all -> 0x0224 }
            r2.<init>()     // Catch:{ all -> 0x0224 }
            java.lang.String r3 = "informMessageDump exception "
            r2.append(r3)     // Catch:{ all -> 0x0224 }
            r2.append(r0)     // Catch:{ all -> 0x0224 }
            java.lang.String r0 = r2.toString()     // Catch:{ all -> 0x0224 }
            android.util.Log.d(r1, r0)     // Catch:{ all -> 0x0224 }
        L_0x0222:
            monitor-exit(r14)     // Catch:{ all -> 0x0224 }
            return
        L_0x0224:
            r0 = move-exception
            monitor-exit(r14)     // Catch:{ all -> 0x0224 }
            throw r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.mediatek.anr.MessageLogger.dumpMessageHistory():void");
    }

    public class MessageInfo {
        public long durationElapsed;
        public long durationUp;
        public String finishDispatch;
        public long msgIdFinish;
        public long msgIdStart;
        public String startDispatch;
        public long startTimeElapsed;
        public long startTimeUp;

        public MessageInfo() {
            init();
        }

        public void init() {
            this.startDispatch = null;
            this.finishDispatch = null;
            this.msgIdStart = -1;
            this.msgIdFinish = -1;
            this.startTimeUp = 0;
            this.durationUp = -1;
            this.startTimeElapsed = 0;
            this.durationElapsed = -1;
        }

        public void copy(MessageInfo messageInfo) {
            this.startDispatch = messageInfo.startDispatch;
            this.finishDispatch = messageInfo.finishDispatch;
            this.msgIdStart = messageInfo.msgIdStart;
            this.msgIdFinish = messageInfo.msgIdFinish;
            this.startTimeUp = messageInfo.startTimeUp;
            this.durationUp = messageInfo.durationUp;
            this.startTimeElapsed = messageInfo.startTimeElapsed;
            this.durationElapsed = messageInfo.durationElapsed;
        }
    }

    public class CircularMessageInfoArray {
        private MessageInfo[] mElem;
        private int mHead;
        private MessageInfo mLastElem;
        private int mSize;
        private int mTail;

        public CircularMessageInfoArray(int i) {
            int i2 = i + 1;
            this.mElem = new MessageInfo[i2];
            for (int i3 = 0; i3 < i2; i3++) {
                this.mElem[i3] = new MessageInfo();
            }
            this.mHead = 0;
            this.mTail = 0;
            this.mLastElem = null;
            this.mSize = i2;
        }

        public boolean empty() {
            return this.mHead == this.mTail || this.mElem == null;
        }

        public boolean full() {
            int i = this.mTail;
            int i2 = this.mHead;
            return i == i2 + -1 || i - i2 == this.mSize - 1;
        }

        public int size() {
            int i = this.mTail;
            int i2 = this.mHead;
            if (i - i2 >= 0) {
                return i - i2;
            }
            return (this.mSize + i) - i2;
        }

        private MessageInfo getLocked(int i) {
            int i2 = this.mHead;
            int i3 = i2 + i;
            int i4 = this.mSize;
            if (i3 <= i4 - 1) {
                return this.mElem[i2 + i];
            }
            return this.mElem[(i2 + i) - i4];
        }

        public synchronized MessageInfo get(int i) {
            if (i >= 0) {
                if (i < size()) {
                    return getLocked(i);
                }
            }
            return null;
        }

        public synchronized MessageInfo getLast() {
            return this.mLastElem;
        }

        public synchronized MessageInfo add() {
            MessageInfo messageInfo;
            if (full()) {
                int i = this.mHead + 1;
                this.mHead = i;
                if (i == this.mSize) {
                    this.mHead = 0;
                }
            }
            MessageInfo[] messageInfoArr = this.mElem;
            int i2 = this.mTail;
            messageInfo = messageInfoArr[i2];
            this.mLastElem = messageInfo;
            int i3 = i2 + 1;
            this.mTail = i3;
            if (i3 == this.mSize) {
                this.mTail = 0;
            }
            return messageInfo;
        }
    }
}
