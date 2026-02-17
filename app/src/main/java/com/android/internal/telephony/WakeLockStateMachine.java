package com.android.internal.telephony;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Message;
import android.os.PowerManager;
import com.android.internal.telephony.util.TelephonyUtils;
import com.android.telephony.Rlog;
import com.pri.prizeinterphone.config.tag.XmlTagConst;
import java.util.concurrent.atomic.AtomicInteger;

public abstract class WakeLockStateMachine extends StateMachine {
    protected static final boolean DBG = TelephonyUtils.IS_DEBUGGABLE;
    protected static final int EVENT_BROADCAST_COMPLETE = 2;
    static final int EVENT_BROADCAST_NOT_REQUIRED = 4;
    public static final int EVENT_NEW_SMS_MESSAGE = 1;
    static final int EVENT_RELEASE_WAKE_LOCK = 3;
    private static final int WAKE_LOCK_TIMEOUT = 3000;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected Context mContext;
    private final DefaultState mDefaultState;
    /* access modifiers changed from: private */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public final IdleState mIdleState;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected Phone mPhone;
    protected final BroadcastReceiver mReceiver;
    protected AtomicInteger mReceiverCount = new AtomicInteger(0);
    /* access modifiers changed from: private */
    public final WaitingState mWaitingState;
    /* access modifiers changed from: private */
    public final PowerManager.WakeLock mWakeLock;

    /* access modifiers changed from: protected */
    public abstract boolean handleSmsMessage(Message message);

    protected WakeLockStateMachine(String str, Context context, Phone phone) {
        super(str);
        DefaultState defaultState = new DefaultState();
        this.mDefaultState = defaultState;
        IdleState idleState = new IdleState();
        this.mIdleState = idleState;
        WaitingState waitingState = new WaitingState();
        this.mWaitingState = waitingState;
        this.mReceiver = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if (WakeLockStateMachine.this.mReceiverCount.decrementAndGet() == 0) {
                    WakeLockStateMachine.this.sendMessage(2);
                }
            }
        };
        this.mContext = context;
        this.mPhone = phone;
        PowerManager.WakeLock newWakeLock = ((PowerManager) context.getSystemService(XmlTagConst.TAG_POWER)).newWakeLock(1, str);
        this.mWakeLock = newWakeLock;
        newWakeLock.acquire();
        addState(defaultState);
        addState(idleState, defaultState);
        addState(waitingState, defaultState);
        setInitialState(idleState);
    }

    /* access modifiers changed from: private */
    public void releaseWakeLock() {
        if (this.mWakeLock.isHeld()) {
            this.mWakeLock.release();
        }
        if (this.mWakeLock.isHeld()) {
            loge("Wait lock is held after release.");
        }
    }

    public final void dispose() {
        quit();
    }

    /* access modifiers changed from: protected */
    public void onQuitting() {
        while (this.mWakeLock.isHeld()) {
            this.mWakeLock.release();
        }
    }

    public final void dispatchSmsMessage(Object obj) {
        sendMessage(1, obj);
    }

    class DefaultState extends State {
        DefaultState() {
        }

        public boolean processMessage(Message message) {
            int i = message.what;
            String str = "processMessage: unhandled message type " + message.what;
            if (!TelephonyUtils.IS_DEBUGGABLE) {
                WakeLockStateMachine.this.loge(str);
                return true;
            }
            throw new RuntimeException(str);
        }
    }

    class IdleState extends State {
        IdleState() {
        }

        public void enter() {
            WakeLockStateMachine.this.sendMessageDelayed(3, 3000);
        }

        public void exit() {
            WakeLockStateMachine.this.mWakeLock.acquire();
            if (WakeLockStateMachine.DBG) {
                WakeLockStateMachine.this.log("Idle: acquired wakelock, leaving Idle state");
            }
        }

        public boolean processMessage(Message message) {
            int i = message.what;
            if (i == 1) {
                WakeLockStateMachine.this.log("Idle: new cell broadcast message");
                if (WakeLockStateMachine.this.handleSmsMessage(message)) {
                    WakeLockStateMachine wakeLockStateMachine = WakeLockStateMachine.this;
                    wakeLockStateMachine.transitionTo(wakeLockStateMachine.mWaitingState);
                }
                return true;
            } else if (i == 3) {
                WakeLockStateMachine.this.log("Idle: release wakelock");
                WakeLockStateMachine.this.releaseWakeLock();
                return true;
            } else if (i != 4) {
                return false;
            } else {
                WakeLockStateMachine.this.log("Idle: broadcast not required");
                return true;
            }
        }
    }

    class WaitingState extends State {
        WaitingState() {
        }

        public boolean processMessage(Message message) {
            int i = message.what;
            if (i == 1) {
                WakeLockStateMachine.this.log("Waiting: deferring message until return to idle");
                WakeLockStateMachine.this.deferMessage(message);
                return true;
            } else if (i == 2) {
                WakeLockStateMachine.this.log("Waiting: broadcast complete, returning to idle");
                WakeLockStateMachine wakeLockStateMachine = WakeLockStateMachine.this;
                wakeLockStateMachine.transitionTo(wakeLockStateMachine.mIdleState);
                return true;
            } else if (i == 3) {
                WakeLockStateMachine.this.log("Waiting: release wakelock");
                WakeLockStateMachine.this.releaseWakeLock();
                return true;
            } else if (i != 4) {
                return false;
            } else {
                WakeLockStateMachine.this.log("Waiting: broadcast not required");
                if (WakeLockStateMachine.this.mReceiverCount.get() == 0) {
                    WakeLockStateMachine wakeLockStateMachine2 = WakeLockStateMachine.this;
                    wakeLockStateMachine2.transitionTo(wakeLockStateMachine2.mIdleState);
                }
                return true;
            }
        }
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void log(String str) {
        Rlog.d(getName(), str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str) {
        Rlog.e(getName(), str);
    }

    /* access modifiers changed from: protected */
    public void loge(String str, Throwable th) {
        Rlog.e(getName(), str, th);
    }
}
