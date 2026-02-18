package com.pri.prizeinterphone.Util;

import android.util.Log;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.RejectedExecutionHandler;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
/* loaded from: classes4.dex */
public final class ExecutorManager {
    public static final String DISPATCH_THREAD_NAME = "serial-port-dispatch-t";
    public static final ExecutorManager INSTANCE = new ExecutorManager();
    public static final String READ_THREAD_NAME = "serial-port-read-t";
    public static final String START_THREAD_NAME = "serial-port-start-t";
    public static final String THREAD_NAME_PREFIX = "serial-port-";
    public static final String TIMER_THREAD_NAME = "serial-port-timer-t";
    public static final String WRITE_THREAD_NAME = "serial-port-write-t";
    private ThreadPoolExecutor dispatchThread;
    private ScheduledExecutorService timerThread;
    private ThreadPoolExecutor writeThread;

    public ThreadPoolExecutor getWriteThread() {
        ThreadPoolExecutor threadPoolExecutor = this.writeThread;
        if (threadPoolExecutor == null || threadPoolExecutor.isShutdown()) {
            this.writeThread = new ThreadPoolExecutor(1, 1, 0L, TimeUnit.MILLISECONDS, new LinkedBlockingQueue(100), new NamedThreadFactory(WRITE_THREAD_NAME), new RejectedHandler());
        }
        return this.writeThread;
    }

    public ThreadPoolExecutor getDispatchThread() {
        ThreadPoolExecutor threadPoolExecutor = this.dispatchThread;
        if (threadPoolExecutor == null || threadPoolExecutor.isShutdown()) {
            this.dispatchThread = new ThreadPoolExecutor(2, 4, 1L, TimeUnit.SECONDS, new LinkedBlockingQueue(100), new NamedThreadFactory(DISPATCH_THREAD_NAME), new RejectedHandler());
        }
        return this.dispatchThread;
    }

    public ScheduledExecutorService getTimerThread() {
        ScheduledExecutorService scheduledExecutorService = this.timerThread;
        if (scheduledExecutorService == null || scheduledExecutorService.isShutdown()) {
            this.timerThread = new ScheduledThreadPoolExecutor(1, new NamedThreadFactory(TIMER_THREAD_NAME), new RejectedHandler());
        }
        return this.timerThread;
    }

    public synchronized void shutdown() {
        ThreadPoolExecutor threadPoolExecutor = this.writeThread;
        if (threadPoolExecutor != null) {
            threadPoolExecutor.shutdownNow();
            this.writeThread = null;
        }
        ThreadPoolExecutor threadPoolExecutor2 = this.dispatchThread;
        if (threadPoolExecutor2 != null) {
            threadPoolExecutor2.shutdownNow();
            this.dispatchThread = null;
        }
        ScheduledExecutorService scheduledExecutorService = this.timerThread;
        if (scheduledExecutorService != null) {
            scheduledExecutorService.shutdownNow();
            this.timerThread = null;
        }
    }

    public static boolean isMPThread() {
        return Thread.currentThread().getName().startsWith(THREAD_NAME_PREFIX);
    }

    /* loaded from: classes4.dex */
    private static class RejectedHandler implements RejectedExecutionHandler {
        private RejectedHandler() {
        }

        @Override // java.util.concurrent.RejectedExecutionHandler
        public void rejectedExecution(Runnable runnable, ThreadPoolExecutor threadPoolExecutor) {
            Log.w("zyingyong", "a task was rejected r=%s" + runnable);
        }
    }
}
