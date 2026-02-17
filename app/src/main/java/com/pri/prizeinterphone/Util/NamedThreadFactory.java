package com.pri.prizeinterphone.Util;

import java.util.concurrent.ThreadFactory;
import java.util.concurrent.atomic.AtomicInteger;

public final class NamedThreadFactory implements ThreadFactory {
    protected final ThreadGroup group;
    protected final String namePrefix;
    protected final AtomicInteger threadNumber = new AtomicInteger(1);

    public NamedThreadFactory(String str) {
        this.namePrefix = str;
        this.group = Thread.currentThread().getThreadGroup();
    }

    public Thread newThread(String str, Runnable runnable) {
        return new Thread(runnable, str);
    }

    public Thread newThread(Runnable runnable) {
        Thread newThread = newThread(this.namePrefix + this.threadNumber.getAndIncrement(), runnable);
        if (newThread.isDaemon()) {
            newThread.setDaemon(false);
        }
        return newThread;
    }
}
