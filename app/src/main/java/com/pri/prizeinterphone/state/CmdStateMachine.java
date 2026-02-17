package com.pri.prizeinterphone.state;

import android.os.Message;
import android.util.ArraySet;
import android.util.Log;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.BaseMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.serial.data.ChannelData;

public class CmdStateMachine extends StateMachine {
    public static final int MSG_INITIALIZED_FEEDBACK_FROM_MODEL = 3;
    public static final int MSG_INITIALIZED_FEEDBACK_FROM_MODEL_ACTIVE = 2;
    public static final int MSG_NOTHING_DO = 0;
    public static final int MSG_QUERY_WHETHER_INITIALIZED = 1;
    public static final int MSG_SET_ANALOG_STATUS_FEEDBACK_FROM_MODEL = 6;
    public static final int MSG_SET_CHANNEL = 10;
    public static final int MSG_SET_CHANNEL_AGAIN_FOR_FAIL = 11;
    public static final int MSG_SET_CHANNEL_AGAIN_FOR_NO_REPLY = 12;
    public static final int MSG_SET_CHANNEL_ERROR = 13;
    public static final int MSG_SET_DIGITAL_STATUS_FEEDBACK_FROM_MODEL = 5;
    public static final int MSG_SET_MIC_GAIN_STATUS_FEEDBACK_FROM_MODEL = 8;
    public static final int MSG_SET_TOT_STATUS_FEEDBACK_FROM_MODEL = 9;
    public static final int MSG_TRANSMISSION_INTERRUPT_STATUS_FEEDBACK_FROM_MODEL = 7;
    public static final int MSG_VERSION_FEEDBACK_FROM_MODEL = 4;
    private static final String TAG = "CmdStateMachine";
    private static volatile CmdStateMachine instance;
    private AppFirstEnterState mAppFirstEnterState = new AppFirstEnterState();
    private ArraySet<IState> mDealStateList = new ArraySet<>();
    /* access modifiers changed from: private */
    public InitializedFeedBack mInitializedFeedBack;
    /* access modifiers changed from: private */
    public NoDealState mNoDealState = new NoDealState();
    private SetChannelState mSetChannelState = new SetChannelState();
    /* access modifiers changed from: private */
    public boolean setChannelAgainAlreadyForFail = false;

    public interface InitializedFeedBack {
        void initializedNotify();
    }

    public static String msg2Str(int i) {
        switch (i) {
            case 0:
                return "MSG_NOTHING_DO(0)";
            case 1:
                return "MSG_QUERY_WHETHER_INITIALIZED(1)";
            case 2:
                return "MSG_INITIALIZED_FEEDBACK_FROM_MODEL_ACTIVE(2)";
            case 3:
                return "MSG_INITIALIZED_FEEDBACK_FROM_MODEL(3)";
            case 4:
                return "MSG_VERSION_FEEDBACK_FROM_MODEL(4)";
            case 5:
                return "MSG_SET_DIGITAL_STATUS_FEEDBACK_FROM_MODEL(5)";
            case 6:
                return "MSG_SET_ANALOG_STATUS_FEEDBACK_FROM_MODEL(6)";
            case 7:
                return "MSG_TRANSMISSION_INTERRUPT_STATUS_FEEDBACK_FROM_MODEL(7)";
            case 8:
                return "MSG_SET_MIC_GAIN_STATUS_FEEDBACK_FROM_MODEL(8)";
            case 9:
                return "MSG_SET_TOT_STATUS_FEEDBACK_FROM_MODEL(9)";
            case 10:
                return "MSG_SET_CHANNEL(10)";
            case 11:
                return "MSG_SET_CHANNEL_AGAIN_FOR_FAIL(11)";
            case 12:
                return "MSG_SET_CHANNEL_AGAIN_FOR_NO_REPLY(12)";
            case 13:
                return "MSG_SET_CHANNEL_ERROR(13)";
            default:
                return "MSG_UNKNOWN";
        }
    }

    protected CmdStateMachine(String str) {
        super(str);
        addState(this.mNoDealState);
        addState(this.mAppFirstEnterState);
        addState(this.mSetChannelState);
        setInitialState(this.mAppFirstEnterState);
        this.mDealStateList.clear();
        this.mDealStateList.add(this.mAppFirstEnterState);
        this.mDealStateList.add(this.mSetChannelState);
    }

    public static CmdStateMachine getInstance() {
        if (instance == null) {
            synchronized (CmdStateMachine.class) {
                if (instance == null) {
                    instance = new CmdStateMachine("CmdState");
                }
            }
        }
        return instance;
    }

    public void startCmdMachine() {
        if (!getInstance().isStart()) {
            getInstance().start();
        }
    }

    public void quitCmdMachine() {
        getInstance().quit();
        instance = null;
    }

    public void getCmdResultFromModule(BaseMessage baseMessage) {
        if (baseMessage == null) {
            Log.d(TAG, "message is null");
        } else if (!isStart()) {
            Log.d(TAG, "no call start()");
        } else if (!this.mDealStateList.contains(getCurrentState())) {
            Log.d(TAG, "no On DealStateList, not deal");
        } else {
            Log.d(TAG, "getCmdResultFromModule,cmd=" + String.format("%02x", new Object[]{Byte.valueOf(baseMessage.packet.cmd)}));
            Packet packet = baseMessage.packet;
            byte b = packet.cmd;
            if (b == -86) {
                sendMessage(obtainMessage(2));
            } else if (b == 39) {
                if (packet.sr == 0) {
                    sendMessage(obtainMessage(3));
                }
            } else if (b == 52) {
                if (packet.sr == 0) {
                    sendMessage(obtainMessage(4));
                }
            } else if (b == 34) {
                removeMessages(12);
                removeMessages(13);
                if (baseMessage.packet.sr == 0) {
                    this.setChannelAgainAlreadyForFail = false;
                    sendMessage(obtainMessage(5));
                    DmrManager.getInstance().dealEvent(Const.Command.SET_DIGITAL_INFO_CMD, baseMessage);
                } else if (!this.setChannelAgainAlreadyForFail) {
                    Log.d(TAG, "set digital channel fail,send again");
                    sendMessage(obtainMessage(11));
                    this.setChannelAgainAlreadyForFail = true;
                } else {
                    Log.d(TAG, "set digital channel fail");
                    sendMessage(obtainMessage(13, 34));
                }
            } else if (b == 35) {
                removeMessages(12);
                removeMessages(13);
                if (baseMessage.packet.sr == 0) {
                    this.setChannelAgainAlreadyForFail = false;
                    sendMessage(obtainMessage(6));
                    DmrManager.getInstance().dealEvent(Const.Command.SET_ANALOG_INFO_CMD, baseMessage);
                } else if (!this.setChannelAgainAlreadyForFail) {
                    Log.d(TAG, "set analog channel fail,send again");
                    sendMessage(obtainMessage(11));
                    this.setChannelAgainAlreadyForFail = true;
                } else {
                    Log.d(TAG, "set analog channel fail");
                    sendMessage(obtainMessage(13, 35));
                }
            } else if (b == 53) {
                if (packet.sr == 0) {
                    removeMessages(13);
                    sendMessage(obtainMessage(7));
                }
            } else if (b == 42) {
                if (packet.sr == 0) {
                    removeMessages(13);
                    sendMessage(obtainMessage(8));
                }
            } else if (b != 59) {
                sendMessage(obtainMessage(0));
            } else if (packet.sr == 0) {
                sendMessage(obtainMessage(9));
            }
        }
    }

    class NoDealState extends State {
        NoDealState() {
        }

        public void enter() {
            Log.e(CmdStateMachine.TAG, "############ enter NoDealState ############");
        }

        public void exit() {
            Log.e(CmdStateMachine.TAG, "############ exit NoDealState ############");
        }

        public boolean processMessage(Message message) {
            int i = message.what;
            return true;
        }
    }

    class AppFirstEnterState extends State {
        AppFirstEnterState() {
        }

        public void enter() {
            Log.e(CmdStateMachine.TAG, "############ enter AppEnterState ############");
        }

        public void exit() {
            Log.e(CmdStateMachine.TAG, "############ exit AppEnterState ############");
        }

        public boolean processMessage(Message message) {
            Log.e(CmdStateMachine.TAG, "AppFirstEnterState  processMessage.....,msg.what=" + CmdStateMachine.msg2Str(message.what));
            switch (message.what) {
                case 1:
                    DmrManager.getInstance().sendQueryInitializedCmdToMdl();
                    return true;
                case 2:
                    if (CmdStateMachine.this.mInitializedFeedBack != null) {
                        CmdStateMachine.this.mInitializedFeedBack.initializedNotify();
                    }
                    DmrManager.getInstance().sendQueryVersionCmdToMdl();
                    return true;
                case 3:
                    DmrManager.getInstance().sendQueryVersionCmdToMdl();
                    return true;
                case 4:
                    DmrManager.getInstance().sendSetChannelCmdToMdl();
                    return true;
                case 5:
                    DmrManager.getInstance().sendTransmissionInterruptCmdToMdl();
                    return true;
                case 6:
                    DmrManager.getInstance().sendSetMicGainCmdToMdl();
                    return true;
                case 7:
                case 8:
                    DmrManager.getInstance().sendSetTotCmdToMdl();
                    return true;
                case 9:
                    DmrManager.getInstance().onModuleInited();
                    CmdStateMachine cmdStateMachine = CmdStateMachine.this;
                    cmdStateMachine.transitionTo(cmdStateMachine.mNoDealState);
                    return true;
                default:
                    return true;
            }
        }
    }

    class SetChannelState extends State {
        private ChannelData tmpChannelData = null;

        SetChannelState() {
        }

        public void setChannelData(ChannelData channelData) {
            this.tmpChannelData = channelData;
        }

        public void enter() {
            Log.e(CmdStateMachine.TAG, "############ enter SetChannelState ############");
        }

        public void exit() {
            Log.e(CmdStateMachine.TAG, "############ exit SetChannelState ############");
        }

        public boolean processMessage(Message message) {
            Log.e(CmdStateMachine.TAG, "SetChannelState  processMessage.....,msg.what=" + CmdStateMachine.msg2Str(message.what));
            int i = 34;
            switch (message.what) {
                case 5:
                    Log.d(CmdStateMachine.TAG, "MSG_SET_DIGITAL_STATUS_FEEDBACK_FROM_MODEL,tmpChannelData=" + this.tmpChannelData);
                    ChannelData channelData = this.tmpChannelData;
                    if (channelData == null) {
                        channelData = DmrManager.getInstance().getCurrentChannel();
                    }
                    if (channelData.interrupt == 3) {
                        CmdStateMachine cmdStateMachine = CmdStateMachine.this;
                        cmdStateMachine.transitionTo(cmdStateMachine.mNoDealState);
                        return true;
                    }
                    CmdStateMachine cmdStateMachine2 = CmdStateMachine.this;
                    if (channelData.type != 0) {
                        i = 35;
                    }
                    cmdStateMachine2.sendMessageDelayed(13, i, 1000);
                    DmrManager.getInstance().sendTransmissionInterruptCmdToMdl(channelData.interrupt);
                    return true;
                case 6:
                    ChannelData channelData2 = this.tmpChannelData;
                    if (channelData2 == null) {
                        channelData2 = DmrManager.getInstance().getCurrentChannel();
                    }
                    CmdStateMachine cmdStateMachine3 = CmdStateMachine.this;
                    if (channelData2.type != 0) {
                        i = 35;
                    }
                    cmdStateMachine3.sendMessageDelayed(13, i, 1000);
                    DmrManager.getInstance().sendSetMicGainCmdToMdl();
                    return true;
                case 7:
                case 8:
                    CmdStateMachine cmdStateMachine4 = CmdStateMachine.this;
                    cmdStateMachine4.transitionTo(cmdStateMachine4.mNoDealState);
                    return true;
                case 10:
                    CmdStateMachine.this.setChannelAgainAlreadyForFail = false;
                    Log.d(CmdStateMachine.TAG, "MSG_SET_CHANNEL,channelData=" + this.tmpChannelData);
                    DmrManager.getInstance().sendSetChannelCmdToMdl(this.tmpChannelData);
                    CmdStateMachine.this.sendMessageDelayed(12, 1000);
                    return true;
                case 11:
                    DmrManager.getInstance().sendSetChannelCmdToMdl(this.tmpChannelData);
                    CmdStateMachine.this.sendMessageDelayed(12, 1000);
                    return true;
                case 12:
                    Log.e(CmdStateMachine.TAG, "set channel no reply,send again,tmpChannelData=" + this.tmpChannelData);
                    DmrManager.getInstance().sendSetChannelCmdToMdl(this.tmpChannelData);
                    ChannelData channelData3 = this.tmpChannelData;
                    if (channelData3 == null) {
                        ChannelData currentChannel = DmrManager.getInstance().getCurrentChannel();
                        if (currentChannel != null) {
                            CmdStateMachine cmdStateMachine5 = CmdStateMachine.this;
                            if (currentChannel.type != 0) {
                                i = 35;
                            }
                            cmdStateMachine5.sendMessageDelayed(13, i, 1000);
                            return true;
                        }
                        Log.e(CmdStateMachine.TAG, "set currentChannel is null");
                        CmdStateMachine cmdStateMachine6 = CmdStateMachine.this;
                        cmdStateMachine6.transitionTo(cmdStateMachine6.mNoDealState);
                        return true;
                    }
                    CmdStateMachine cmdStateMachine7 = CmdStateMachine.this;
                    if (channelData3.type != 0) {
                        i = 35;
                    }
                    cmdStateMachine7.sendMessageDelayed(13, i, 1000);
                    return true;
                case 13:
                    byte b = (byte) message.arg1;
                    Log.d(CmdStateMachine.TAG, "MSG_SET_CHANNEL_ERROR,cmd" + b);
                    DmrManager.getInstance().errorEvent(b);
                    CmdStateMachine cmdStateMachine8 = CmdStateMachine.this;
                    cmdStateMachine8.transitionTo(cmdStateMachine8.mNoDealState);
                    return true;
                default:
                    return true;
            }
        }
    }

    public void transitionToAppFirstEnterState() {
        transitionTo(this.mAppFirstEnterState);
    }

    public void transitionToSetChannelStateState() {
        transitionTo(this.mSetChannelState);
    }

    public IState getSetChannelState() {
        return this.mSetChannelState;
    }

    public void setChannelData(ChannelData channelData) {
        if (channelData != null) {
            try {
                this.mSetChannelState.setChannelData(channelData.clone());
            } catch (CloneNotSupportedException e) {
                Log.d(TAG, "setChannelData error", e);
                this.mSetChannelState.setChannelData((ChannelData) null);
            }
        } else {
            this.mSetChannelState.setChannelData((ChannelData) null);
        }
    }

    public void setInitializedFeedBack(InitializedFeedBack initializedFeedBack) {
        this.mInitializedFeedBack = initializedFeedBack;
    }
}
