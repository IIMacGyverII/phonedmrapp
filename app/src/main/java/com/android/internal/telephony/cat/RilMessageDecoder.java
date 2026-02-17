package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.telephony.TelephonyManager;
import com.android.internal.telephony.State;
import com.android.internal.telephony.StateMachine;
import com.android.internal.telephony.TelephonyComponentFactory;
import com.android.internal.telephony.uicc.IccFileHandler;

public class RilMessageDecoder extends StateMachine {
    protected static final int CMD_PARAMS_READY = 2;
    protected static final int CMD_START = 1;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected static RilMessageDecoder[] mInstance;
    protected static int mSimCount;
    public Handler mCaller = null;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected CommandParamsFactory mCmdParamsFactory = null;
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    protected RilMessage mCurrentRilMessage = null;
    protected StateCmdParamsReady mStateCmdParamsReady = new StateCmdParamsReady();
    @UnsupportedAppUsage
    protected StateStart mStateStart = new StateStart();

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public static synchronized RilMessageDecoder getInstance(Handler handler, IccFileHandler iccFileHandler, Context context, int i) {
        synchronized (RilMessageDecoder.class) {
            if (mInstance == null) {
                int supportedModemCount = TelephonyManager.getDefault().getSupportedModemCount();
                mSimCount = supportedModemCount;
                mInstance = new RilMessageDecoder[supportedModemCount];
                for (int i2 = 0; i2 < mSimCount; i2++) {
                    mInstance[i2] = null;
                }
            }
            if (i == -1 || i >= mSimCount) {
                CatLog.d("RilMessageDecoder", "invaild slot id: " + i);
                return null;
            }
            RilMessageDecoder[] rilMessageDecoderArr = mInstance;
            if (rilMessageDecoderArr[i] == null) {
                rilMessageDecoderArr[i] = TelephonyComponentFactory.getInstance().inject(TelephonyComponentFactory.class.getName()).makeRilMessageDecoder(handler, iccFileHandler, context, i);
            }
            RilMessageDecoder rilMessageDecoder = mInstance[i];
            return rilMessageDecoder;
        }
    }

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void sendStartDecodingMessageParams(RilMessage rilMessage) {
        Message obtainMessage = obtainMessage(1);
        obtainMessage.obj = rilMessage;
        sendMessage(obtainMessage);
    }

    public void sendMsgParamsDecoded(ResultCode resultCode, CommandParams commandParams) {
        Message obtainMessage = obtainMessage(2);
        obtainMessage.arg1 = resultCode.value();
        obtainMessage.obj = commandParams;
        sendMessage(obtainMessage);
    }

    /* access modifiers changed from: protected */
    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public void sendCmdForExecution(RilMessage rilMessage) {
        this.mCaller.obtainMessage(10, new RilMessage(rilMessage)).sendToTarget();
    }

    public RilMessageDecoder(Handler handler, IccFileHandler iccFileHandler, Context context) {
        super("RilMessageDecoder");
        addState(this.mStateStart);
        addState(this.mStateCmdParamsReady);
        setInitialState(this.mStateStart);
        this.mCaller = handler;
        this.mCmdParamsFactory = CommandParamsFactory.getInstance(this, iccFileHandler, context);
    }

    public RilMessageDecoder() {
        super("RilMessageDecoder");
    }

    private class StateStart extends State {
        private StateStart() {
        }

        public boolean processMessage(Message message) {
            if (message.what != 1) {
                CatLog.d((Object) this, "StateStart unexpected expecting START=1 got " + message.what);
            } else if (RilMessageDecoder.this.decodeMessageParams((RilMessage) message.obj)) {
                RilMessageDecoder rilMessageDecoder = RilMessageDecoder.this;
                rilMessageDecoder.transitionTo(rilMessageDecoder.mStateCmdParamsReady);
            }
            return true;
        }
    }

    private class StateCmdParamsReady extends State {
        private StateCmdParamsReady() {
        }

        public boolean processMessage(Message message) {
            if (message.what == 2) {
                RilMessageDecoder.this.mCurrentRilMessage.mResCode = ResultCode.fromInt(message.arg1);
                RilMessageDecoder rilMessageDecoder = RilMessageDecoder.this;
                RilMessage rilMessage = rilMessageDecoder.mCurrentRilMessage;
                rilMessage.mData = message.obj;
                rilMessageDecoder.sendCmdForExecution(rilMessage);
                RilMessageDecoder rilMessageDecoder2 = RilMessageDecoder.this;
                rilMessageDecoder2.transitionTo(rilMessageDecoder2.mStateStart);
                return true;
            }
            CatLog.d((Object) this, "StateCmdParamsReady expecting CMD_PARAMS_READY=2 got " + message.what);
            RilMessageDecoder.this.deferMessage(message);
            return true;
        }
    }

    /* access modifiers changed from: protected */
    /* JADX WARNING: Code restructure failed: missing block: B:9:0x0012, code lost:
        if (r0 != 5) goto L_0x0057;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean decodeMessageParams(com.android.internal.telephony.cat.RilMessage r5) {
        /*
            r4 = this;
            r4.mCurrentRilMessage = r5
            int r0 = r5.mId
            r1 = 1
            r2 = 0
            if (r0 == r1) goto L_0x0050
            r3 = 2
            if (r0 == r3) goto L_0x0015
            r3 = 3
            if (r0 == r3) goto L_0x0015
            r3 = 4
            if (r0 == r3) goto L_0x0050
            r3 = 5
            if (r0 == r3) goto L_0x0015
            goto L_0x0057
        L_0x0015:
            java.lang.Object r5 = r5.mData     // Catch:{ Exception -> 0x004a }
            java.lang.String r5 = (java.lang.String) r5     // Catch:{ Exception -> 0x004a }
            byte[] r5 = com.android.internal.telephony.uicc.IccUtils.hexStringToBytes(r5)     // Catch:{ Exception -> 0x004a }
            com.android.internal.telephony.cat.CommandParamsFactory r0 = r4.mCmdParamsFactory     // Catch:{ ResultException -> 0x0027 }
            com.android.internal.telephony.cat.BerTlv r5 = com.android.internal.telephony.cat.BerTlv.decode(r5)     // Catch:{ ResultException -> 0x0027 }
            r0.make(r5)     // Catch:{ ResultException -> 0x0027 }
            goto L_0x0058
        L_0x0027:
            r5 = move-exception
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            java.lang.String r1 = "decodeMessageParams: caught ResultException e="
            r0.append(r1)
            r0.append(r5)
            java.lang.String r0 = r0.toString()
            com.android.internal.telephony.cat.CatLog.d((java.lang.Object) r4, (java.lang.String) r0)
            com.android.internal.telephony.cat.RilMessage r0 = r4.mCurrentRilMessage
            com.android.internal.telephony.cat.ResultCode r5 = r5.result()
            r0.mResCode = r5
            com.android.internal.telephony.cat.RilMessage r5 = r4.mCurrentRilMessage
            r4.sendCmdForExecution(r5)
            goto L_0x0057
        L_0x004a:
            java.lang.String r5 = "decodeMessageParams dropping zombie messages"
            com.android.internal.telephony.cat.CatLog.d((java.lang.Object) r4, (java.lang.String) r5)
            goto L_0x0057
        L_0x0050:
            com.android.internal.telephony.cat.ResultCode r0 = com.android.internal.telephony.cat.ResultCode.OK
            r5.mResCode = r0
            r4.sendCmdForExecution(r5)
        L_0x0057:
            r1 = r2
        L_0x0058:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.android.internal.telephony.cat.RilMessageDecoder.decodeMessageParams(com.android.internal.telephony.cat.RilMessage):boolean");
    }

    public void dispose() {
        quitNow();
        this.mStateStart = null;
        this.mStateCmdParamsReady = null;
        this.mCmdParamsFactory.dispose();
        this.mCmdParamsFactory = null;
        this.mCurrentRilMessage = null;
        this.mCaller = null;
        mInstance = null;
    }
}
