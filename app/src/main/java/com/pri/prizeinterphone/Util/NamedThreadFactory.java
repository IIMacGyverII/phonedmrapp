package com.pri.prizeinterphone.Util;

import java.util.concurrent.ThreadFactory;
import java.util.concurrent.atomic.AtomicInteger;
/* loaded from: classes4.dex */
public final class NamedThreadFactory implements ThreadFactory {
    protected final String namePrefix;
    protected final AtomicInteger threadNumber = new AtomicInteger(1);
    protected final ThreadGroup group = Thread.currentThread().getThreadGroup();

    public NamedThreadFactory(String str) {
        this.namePrefix = str;
    }

    public Thread newThread(String str, Runnable runnable) {
        return new Thread(runnable, str);
    }

    @Override // java.util.concurrent.ThreadFactory
    public Thread newThread(Runnable runnable) {
        Thread newThread = newThread(this.namePrefix + this.threadNumber.getAndIncrement(), runnable);
        if (newThread.isDaemon()) {
            newThread.setDaemon(false);
        }
        return newThread;
    }
}
