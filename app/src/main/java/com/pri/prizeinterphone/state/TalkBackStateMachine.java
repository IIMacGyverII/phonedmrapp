package com.pri.prizeinterphone.state;

import android.os.Message;
import android.util.Log;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment;

public class TalkBackStateMachine extends StateMachine {
    public static final int MSG_CHANNEL_CHANGE = 2021;
    public static final int MSG_INTERRUPT_GET_NO_RESULT = 2015;
    public static final int MSG_INTERRUPT_GET_RESULT = 2014;
    public static final int MSG_INTERRUPT_START = 2013;
    public static final int MSG_PHONE_CALLING = 2018;
    public static final int MSG_PHONE_END = 2019;
    public static final int MSG_RECEIVE_SOUND_END = 2017;
    public static final int MSG_RECEIVE_SOUND_START = 2016;
    public static final int MSG_RECORD_SOUND_END = 2012;
    public static final int MSG_RECORD_SOUND_END_FEEDBACK_FROM_MODULE = 2023;
    public static final int MSG_RECORD_SOUND_START = 2011;
    public static final int MSG_RECORD_SOUND_START_FEEDBACK_FROM_MODULE = 2022;
    public static final int MSG_RECORD_SOUND_START_NEED_DELAY = 20111;
    public static final int MSG_RECORD_SOUND_START_REFRESH_UI = 20112;
    public static final int MSG_RELAY_CONNECTION_FAILED = 2020;
    public static final int STATE_IDLE = 0;
    public static final int STATE_RECEIVE = 2;
    public static final int STATE_RECORD = 1;
    private static final String TAG = "TalkBackStateMachine";
    /* access modifiers changed from: private */
    public InterPhoneTalkBackFragment fragment;
    /* access modifiers changed from: private */
    public State mBusyNoSendState = new BusyNoSendState();
    /* access modifiers changed from: private */
    public IdleState mIdleState = new IdleState();
    /* access modifiers changed from: private */
    public State mPhoneCallingState = new PhoneCallingState();
    /* access modifiers changed from: private */
    public State mReceiveSoundState = new ReceiveSoundState();
    /* access modifiers changed from: private */
    public State mRecordSoundState = new RecordSoundState();
    /* access modifiers changed from: private */
    public State mRelayConnectionFailedState = new RelayConnectionFailedState();
    /* access modifiers changed from: private */
    public State mSendExceptionState = new SendExceptionState();
    /* access modifiers changed from: private */
    public State mWaitIngInterruptResultState = new WaitIngInterruptResultState();

    public static String msg2Str(int i) {
        if (i == 20111) {
            return "MSG_RECORD_SOUND_START_NEED_DELAY(20111)";
        }
        if (i == 20112) {
            return "MSG_RECORD_SOUND_START_REFRESH_UI(20112)";
        }
        switch (i) {
            case 2011:
                return "MSG_RECORD_SOUND_START(2011)";
            case 2012:
                return "MSG_RECORD_SOUND_END(2012)";
            case 2013:
                return "MSG_INTERRUPT_START(2013)";
            case 2014:
                return "MSG_INTERRUPT_GET_RESULT(2014)";
            case 2015:
                return "MSG_INTERRUPT_GET_NO_RESULT(2015)";
            case 2016:
                return "MSG_RECEIVE_SOUND_START(2016)";
            case 2017:
                return "MSG_RECEIVE_SOUND_END(2017)";
            case 2018:
                return "MSG_PHONE_CALLING(2018)";
            case 2019:
                return "MSG_PHONE_END(2019)";
            case 2020:
                return "MSG_RELAY_CONNECTION_FAILED(2020)";
            case 2021:
                return "MSG_CHANNEL_CHANGE(2021)";
            case 2022:
                return "MSG_RECORD_SOUND_START_FEEDBACK_FROM_MODULE(2022)";
            case 2023:
                return "MSG_RECORD_SOUND_END_FEEDBACK_FROM_MODULE(2023)";
            default:
                return "MSG_UNKNOWN";
        }
    }

    protected TalkBackStateMachine(String str, InterPhoneTalkBackFragment interPhoneTalkBackFragment) {
        super(str);
        this.fragment = interPhoneTalkBackFragment;
        addState(this.mIdleState);
        addState(this.mSendExceptionState, this.mIdleState);
        addState(this.mRecordSoundState, this.mSendExceptionState);
        addState(this.mBusyNoSendState, this.mIdleState);
        addState(this.mReceiveSoundState, this.mBusyNoSendState);
        addState(this.mWaitIngInterruptResultState, this.mIdleState);
        addState(this.mRelayConnectionFailedState);
        addState(this.mPhoneCallingState);
        setInitialState(this.mIdleState);
    }

    public static TalkBackStateMachine makePerson(InterPhoneTalkBackFragment interPhoneTalkBackFragment) {
        TalkBackStateMachine talkBackStateMachine = new TalkBackStateMachine("TalkBack", interPhoneTalkBackFragment);
        talkBackStateMachine.start();
        return talkBackStateMachine;
    }

    /* access modifiers changed from: protected */
    public void onHalting() {
        synchronized (this) {
            notifyAll();
        }
    }

    class IdleState extends State {
        private boolean isInterruptSendAgain = false;

        IdleState() {
        }

        public void enter() {
            Log.e(TalkBackStateMachine.TAG, "############ enter IdleState ############");
        }

        public void exit() {
            Log.e(TalkBackStateMachine.TAG, "############ exit IdleState ############");
        }

        public void setInterruptSendAgain(boolean z) {
            this.isInterruptSendAgain = z;
        }

        public boolean isInterruptSendAgain() {
            return this.isInterruptSendAgain;
        }

        public boolean processMessage(Message message) {
            Log.e(TalkBackStateMachine.TAG, "IdleState  processMessage.....,msg.what=" + TalkBackStateMachine.msg2Str(message.what));
            int i = message.what;
            if (i != 2011) {
                if (i == 2013) {
                    if (TalkBackStateMachine.this.getCurrentState() != TalkBackStateMachine.this.mWaitIngInterruptResultState) {
                        TalkBackStateMachine talkBackStateMachine = TalkBackStateMachine.this;
                        talkBackStateMachine.transitionTo(talkBackStateMachine.mWaitIngInterruptResultState);
                    }
                    Log.d(TalkBackStateMachine.TAG, "IdleState --- start sendInterrupt,isInterruptSendAgain=" + this.isInterruptSendAgain);
                    TalkBackStateMachine.this.fragment.sendInterrupt();
                    TalkBackStateMachine talkBackStateMachine2 = TalkBackStateMachine.this;
                    talkBackStateMachine2.sendMessageDelayed(talkBackStateMachine2.obtainMessage(2015), 600);
                    if (!this.isInterruptSendAgain) {
                        return true;
                    }
                    TalkBackStateMachine.this.removeMessages(2013);
                    TalkBackStateMachine talkBackStateMachine3 = TalkBackStateMachine.this;
                    talkBackStateMachine3.sendMessageDelayed(talkBackStateMachine3.obtainMessage(2013), 500);
                    return true;
                } else if (i == 2016) {
                    TalkBackStateMachine talkBackStateMachine4 = TalkBackStateMachine.this;
                    talkBackStateMachine4.transitionTo(talkBackStateMachine4.mReceiveSoundState);
                    TalkBackStateMachine.this.sendMessage(2016);
                    return true;
                } else if (i != 20111) {
                    switch (i) {
                        case 2018:
                            TalkBackStateMachine talkBackStateMachine5 = TalkBackStateMachine.this;
                            talkBackStateMachine5.transitionTo(talkBackStateMachine5.mPhoneCallingState);
                            TalkBackStateMachine talkBackStateMachine6 = TalkBackStateMachine.this;
                            talkBackStateMachine6.sendMessage(talkBackStateMachine6.obtainMessage(2018));
                            return true;
                        case 2019:
                            TalkBackStateMachine talkBackStateMachine7 = TalkBackStateMachine.this;
                            talkBackStateMachine7.transitionTo(talkBackStateMachine7.mIdleState);
                            return true;
                        case 2020:
                            TalkBackStateMachine talkBackStateMachine8 = TalkBackStateMachine.this;
                            talkBackStateMachine8.transitionTo(talkBackStateMachine8.mRelayConnectionFailedState);
                            TalkBackStateMachine talkBackStateMachine9 = TalkBackStateMachine.this;
                            talkBackStateMachine9.deferMessage(talkBackStateMachine9.obtainMessage(2020));
                            return true;
                        case 2021:
                            TalkBackStateMachine.this.fragment.updateChannelId(((Boolean) message.obj).booleanValue());
                            return true;
                        default:
                            return true;
                    }
                } else if (TalkBackStateMachine.this.fragment.isInterruptTransport()) {
                    TalkBackStateMachine.this.sendMessage(2013);
                    return true;
                } else {
                    TalkBackStateMachine talkBackStateMachine10 = TalkBackStateMachine.this;
                    talkBackStateMachine10.transitionTo(talkBackStateMachine10.mRecordSoundState);
                    TalkBackStateMachine.this.sendMessage((int) TalkBackStateMachine.MSG_RECORD_SOUND_START_NEED_DELAY);
                    return true;
                }
            } else if (TalkBackStateMachine.this.fragment.isInterruptTransport()) {
                TalkBackStateMachine.this.sendMessage(2013);
                return true;
            } else {
                TalkBackStateMachine talkBackStateMachine11 = TalkBackStateMachine.this;
                talkBackStateMachine11.transitionTo(talkBackStateMachine11.mRecordSoundState);
                TalkBackStateMachine.this.sendMessage(2011);
                return true;
            }
        }
    }

    class RecordSoundState extends State {
        public static final int NEED_SEND_RECEIVE_SOUND_START = 4;
        public static final int NEED_SEND_RELAY_CONNECTION_FAILED = 3;

        RecordSoundState() {
        }

        public void enter() {
            Log.e(TalkBackStateMachine.TAG, "############ enter RecordSoundState ############");
        }

        public void exit() {
            Log.e(TalkBackStateMachine.TAG, "############ exit RecordSoundState ############");
        }

        public boolean processMessage(Message message) {
            Log.e(TalkBackStateMachine.TAG, "RecordSoundState  processMessage.....,msg.what=" + TalkBackStateMachine.msg2Str(message.what));
            int i = message.what;
            if (i != 2011) {
                if (i == 2012) {
                    TalkBackStateMachine.this.removeMessages(TalkBackStateMachine.MSG_RECORD_SOUND_START_REFRESH_UI);
                    if (!TalkBackStateMachine.this.fragment.isSendStatus()) {
                        return true;
                    }
                    TalkBackStateMachine.this.fragment.launchEnd();
                    TalkBackStateMachine.this.fragment.stopPcmRecord();
                    TalkBackStateMachine.this.fragment.setStopRecordPrepare();
                    TalkBackStateMachine.this.fragment.setSendStatus(0);
                    TalkBackStateMachine talkBackStateMachine = TalkBackStateMachine.this;
                    talkBackStateMachine.transitionTo(talkBackStateMachine.mIdleState);
                    int i2 = message.arg1;
                    if (i2 == 2) {
                        TalkBackStateMachine talkBackStateMachine2 = TalkBackStateMachine.this;
                        talkBackStateMachine2.sendMessage(talkBackStateMachine2.obtainMessage(2018));
                    } else if (i2 == 3) {
                        TalkBackStateMachine talkBackStateMachine3 = TalkBackStateMachine.this;
                        talkBackStateMachine3.transitionTo(talkBackStateMachine3.mRelayConnectionFailedState);
                        TalkBackStateMachine.this.sendMessage(2020);
                    } else if (i2 == 4) {
                        TalkBackStateMachine talkBackStateMachine4 = TalkBackStateMachine.this;
                        talkBackStateMachine4.transitionTo(talkBackStateMachine4.mReceiveSoundState);
                        TalkBackStateMachine talkBackStateMachine5 = TalkBackStateMachine.this;
                        talkBackStateMachine5.sendMessage(talkBackStateMachine5.obtainMessage(2016));
                    }
                } else if (i == 2016) {
                    TalkBackStateMachine talkBackStateMachine6 = TalkBackStateMachine.this;
                    talkBackStateMachine6.sendMessage(talkBackStateMachine6.obtainMessage(2012, 4));
                } else if (i == 2018) {
                    TalkBackStateMachine talkBackStateMachine7 = TalkBackStateMachine.this;
                    talkBackStateMachine7.sendMessage(talkBackStateMachine7.obtainMessage(2012, 2));
                } else if (i != 20111) {
                    if (i != 20112) {
                        switch (i) {
                            case 2020:
                                TalkBackStateMachine talkBackStateMachine8 = TalkBackStateMachine.this;
                                talkBackStateMachine8.sendMessage(talkBackStateMachine8.obtainMessage(2012, 3));
                                break;
                            case 2021:
                                TalkBackStateMachine.this.fragment.showToast(R.string.interphone_talk_send_status_toast);
                                break;
                            case 2022:
                                TalkBackStateMachine.this.fragment.createRecordFile();
                                if (TalkBackStateMachine.this.fragment.startPcmRecord() >= 0) {
                                    TalkBackStateMachine.this.fragment.setStartRecordPrepare();
                                    TalkBackStateMachine.this.fragment.showLimitRecordTime();
                                    TalkBackStateMachine.this.fragment.setSendStatus(1);
                                    break;
                                } else {
                                    TalkBackStateMachine.this.fragment.showToast(R.string.interphone_send_timeout_toast);
                                    TalkBackStateMachine.this.fragment.setTalkbackRecordBg(0);
                                    TalkBackStateMachine.this.fragment.stopPcmRecord();
                                    TalkBackStateMachine talkBackStateMachine9 = TalkBackStateMachine.this;
                                    talkBackStateMachine9.transitionTo(talkBackStateMachine9.mSendExceptionState);
                                    return true;
                                }
                            case 2023:
                                TalkBackStateMachine.this.fragment.stopPcmRecord();
                                TalkBackStateMachine.this.fragment.setStopRecordPrepare();
                                TalkBackStateMachine.this.fragment.setSendStatus(0);
                                TalkBackStateMachine talkBackStateMachine10 = TalkBackStateMachine.this;
                                talkBackStateMachine10.transitionTo(talkBackStateMachine10.mIdleState);
                                int i3 = message.arg1;
                                if (i3 != 2) {
                                    if (i3 != 3) {
                                        if (i3 == 4) {
                                            TalkBackStateMachine talkBackStateMachine11 = TalkBackStateMachine.this;
                                            talkBackStateMachine11.transitionTo(talkBackStateMachine11.mReceiveSoundState);
                                            TalkBackStateMachine talkBackStateMachine12 = TalkBackStateMachine.this;
                                            talkBackStateMachine12.sendMessage(talkBackStateMachine12.obtainMessage(2016));
                                            break;
                                        }
                                    } else {
                                        TalkBackStateMachine talkBackStateMachine13 = TalkBackStateMachine.this;
                                        talkBackStateMachine13.transitionTo(talkBackStateMachine13.mRelayConnectionFailedState);
                                        TalkBackStateMachine talkBackStateMachine14 = TalkBackStateMachine.this;
                                        talkBackStateMachine14.sendMessage(talkBackStateMachine14.obtainMessage(2020));
                                        break;
                                    }
                                } else {
                                    TalkBackStateMachine talkBackStateMachine15 = TalkBackStateMachine.this;
                                    talkBackStateMachine15.sendMessage(talkBackStateMachine15.obtainMessage(2018));
                                    break;
                                }
                                break;
                        }
                    } else {
                        TalkBackStateMachine.this.fragment.setStartRecordPrepare();
                        TalkBackStateMachine.this.fragment.showLimitRecordTime();
                    }
                } else if (TalkBackStateMachine.this.fragment.isSendStatus()) {
                    return true;
                } else {
                    TalkBackStateMachine.this.fragment.launchCommand();
                    TalkBackStateMachine.this.fragment.createRecordFile();
                    if (TalkBackStateMachine.this.fragment.startPcmRecord() < 0) {
                        TalkBackStateMachine.this.fragment.showToast(R.string.interphone_send_timeout_toast);
                        TalkBackStateMachine.this.fragment.setTalkbackRecordBg(0);
                        TalkBackStateMachine.this.fragment.stopPcmRecord();
                        TalkBackStateMachine talkBackStateMachine16 = TalkBackStateMachine.this;
                        talkBackStateMachine16.transitionTo(talkBackStateMachine16.mSendExceptionState);
                        return true;
                    }
                    TalkBackStateMachine.this.fragment.setSendStatus(1);
                    TalkBackStateMachine.this.fragment.setTalkbackRecordBg(1);
                    TalkBackStateMachine talkBackStateMachine17 = TalkBackStateMachine.this;
                    talkBackStateMachine17.sendMessageDelayed(talkBackStateMachine17.obtainMessage(TalkBackStateMachine.MSG_RECORD_SOUND_START_REFRESH_UI), 500);
                }
            } else if (TalkBackStateMachine.this.fragment.isSendStatus()) {
                return true;
            } else {
                TalkBackStateMachine.this.fragment.launchCommand();
                TalkBackStateMachine.this.fragment.createRecordFile();
                if (TalkBackStateMachine.this.fragment.startPcmRecord() < 0) {
                    TalkBackStateMachine.this.fragment.showToast(R.string.interphone_send_timeout_toast);
                    TalkBackStateMachine.this.fragment.setTalkbackRecordBg(0);
                    TalkBackStateMachine.this.fragment.stopPcmRecord();
                    TalkBackStateMachine talkBackStateMachine18 = TalkBackStateMachine.this;
                    talkBackStateMachine18.transitionTo(talkBackStateMachine18.mSendExceptionState);
                    return true;
                }
                TalkBackStateMachine.this.fragment.setStartRecordPrepare();
                TalkBackStateMachine.this.fragment.showLimitRecordTime();
                TalkBackStateMachine.this.fragment.setSendStatus(1);
            }
            return true;
        }
    }

    class ReceiveSoundState extends State {
        private static final int STATE_IDLE = 0;
        private static final int STATE_RECORD_AGAIN = 1;

        ReceiveSoundState() {
        }

        public void enter() {
            Log.e(TalkBackStateMachine.TAG, "############ enter ReceiveSoundState ############");
        }

        public void exit() {
            Log.e(TalkBackStateMachine.TAG, "############ exit ReceiveSoundState ############");
        }

        public boolean processMessage(Message message) {
            Log.e(TalkBackStateMachine.TAG, "ReceiveSoundState  processMessage.....,msg.what=" + TalkBackStateMachine.msg2Str(message.what));
            int i = message.what;
            if (i != 2011 && i != 20111) {
                switch (i) {
                    case 2016:
                        TalkBackStateMachine.this.fragment.setStartReceivePrepare();
                        TalkBackStateMachine.this.fragment.startPcmRead();
                        break;
                    case 2017:
                        TalkBackStateMachine.this.fragment.stopPcmRead();
                        TalkBackStateMachine.this.fragment.setStopReceivePrepare();
                        TalkBackStateMachine talkBackStateMachine = TalkBackStateMachine.this;
                        talkBackStateMachine.transitionTo(talkBackStateMachine.mIdleState);
                        int i2 = message.arg1;
                        if (i2 != 1) {
                            if (i2 == 2) {
                                TalkBackStateMachine talkBackStateMachine2 = TalkBackStateMachine.this;
                                talkBackStateMachine2.sendMessage(talkBackStateMachine2.obtainMessage(2018));
                                break;
                            }
                        } else {
                            Log.e(TalkBackStateMachine.TAG, "ReceiveSoundState  record again--------------");
                            TalkBackStateMachine talkBackStateMachine3 = TalkBackStateMachine.this;
                            talkBackStateMachine3.sendMessage(talkBackStateMachine3.obtainMessage(2011));
                            break;
                        }
                        break;
                    case 2018:
                        TalkBackStateMachine talkBackStateMachine4 = TalkBackStateMachine.this;
                        talkBackStateMachine4.sendMessage(talkBackStateMachine4.obtainMessage(2017, 2));
                        break;
                }
            } else if (TalkBackStateMachine.this.fragment.getBusyNoSend()) {
                TalkBackStateMachine talkBackStateMachine5 = TalkBackStateMachine.this;
                talkBackStateMachine5.transitionTo(talkBackStateMachine5.mBusyNoSendState);
                TalkBackStateMachine talkBackStateMachine6 = TalkBackStateMachine.this;
                talkBackStateMachine6.sendMessage(talkBackStateMachine6.obtainMessage(2011));
            } else {
                TalkBackStateMachine talkBackStateMachine7 = TalkBackStateMachine.this;
                talkBackStateMachine7.sendMessage(talkBackStateMachine7.obtainMessage(2017, 1));
            }
            return true;
        }
    }

    class PhoneCallingState extends State {
        public static final int NEED_SEND_PHONE_CALLING_AGAIN = 2;

        PhoneCallingState() {
        }

        public void enter() {
            Log.e(TalkBackStateMachine.TAG, "############ enter PhoneCallingState ############");
        }

        public void exit() {
            Log.e(TalkBackStateMachine.TAG, "############ exit PhoneCallingState ############");
        }

        public boolean processMessage(Message message) {
            Log.e(TalkBackStateMachine.TAG, "PhoneCallingState  processMessage.....,msg.what=" + TalkBackStateMachine.msg2Str(message.what));
            int i = message.what;
            if (i == 2018) {
                TalkBackStateMachine.this.fragment.showToast(R.string.interphone_call_state_toast);
                return true;
            } else if (i != 2019) {
                return true;
            } else {
                TalkBackStateMachine talkBackStateMachine = TalkBackStateMachine.this;
                talkBackStateMachine.transitionTo(talkBackStateMachine.mIdleState);
                return true;
            }
        }
    }

    class WaitIngInterruptResultState extends State {
        WaitIngInterruptResultState() {
        }

        public void enter() {
            Log.e(TalkBackStateMachine.TAG, "############ enter WaitIngInterruptResultState ############");
        }

        public void exit() {
            Log.e(TalkBackStateMachine.TAG, "############ exit WaitIngInterruptResultState ############");
        }

        public boolean processMessage(Message message) {
            Log.e(TalkBackStateMachine.TAG, "WaitIngInterruptResultState  processMessage.....,msg.what=" + TalkBackStateMachine.msg2Str(message.what));
            switch (message.what) {
                case 2013:
                    return false;
                case 2014:
                    TalkBackStateMachine.this.removeMessages(2015);
                    if (message.arg1 != 0) {
                        Log.d(TalkBackStateMachine.TAG, "WaitIngInterruptResultState setInterrupt failed");
                        if (TalkBackStateMachine.this.mIdleState.isInterruptSendAgain()) {
                            TalkBackStateMachine.this.mIdleState.setInterruptSendAgain(false);
                            TalkBackStateMachine talkBackStateMachine = TalkBackStateMachine.this;
                            talkBackStateMachine.transitionTo(talkBackStateMachine.mRecordSoundState);
                            TalkBackStateMachine talkBackStateMachine2 = TalkBackStateMachine.this;
                            talkBackStateMachine2.sendMessage(talkBackStateMachine2.obtainMessage(2011));
                            break;
                        } else {
                            TalkBackStateMachine.this.mIdleState.setInterruptSendAgain(true);
                            TalkBackStateMachine talkBackStateMachine3 = TalkBackStateMachine.this;
                            talkBackStateMachine3.sendMessage(talkBackStateMachine3.obtainMessage(2013));
                            Log.d(TalkBackStateMachine.TAG, "WaitIngInterruptResultState setInterrupt again");
                            break;
                        }
                    } else {
                        Log.d(TalkBackStateMachine.TAG, "WaitIngInterruptResultState setInterrupt successfully");
                        TalkBackStateMachine.this.mIdleState.setInterruptSendAgain(false);
                        TalkBackStateMachine.this.removeMessages(2013);
                        TalkBackStateMachine talkBackStateMachine4 = TalkBackStateMachine.this;
                        talkBackStateMachine4.transitionTo(talkBackStateMachine4.mRecordSoundState);
                        TalkBackStateMachine talkBackStateMachine5 = TalkBackStateMachine.this;
                        talkBackStateMachine5.sendMessage(talkBackStateMachine5.obtainMessage(2011));
                        break;
                    }
                case 2015:
                    Log.d(TalkBackStateMachine.TAG, "WaitIngInterruptResultState setInterrupt no result");
                    TalkBackStateMachine talkBackStateMachine6 = TalkBackStateMachine.this;
                    talkBackStateMachine6.transitionTo(talkBackStateMachine6.mRecordSoundState);
                    TalkBackStateMachine talkBackStateMachine7 = TalkBackStateMachine.this;
                    talkBackStateMachine7.sendMessage(talkBackStateMachine7.obtainMessage(2011));
                    break;
            }
            return true;
        }
    }

    class SendExceptionState extends State {
        SendExceptionState() {
        }

        public void enter() {
            Log.e(TalkBackStateMachine.TAG, "############ enter SendExceptionState ############");
        }

        public void exit() {
            Log.e(TalkBackStateMachine.TAG, "############ exit SendExceptionState ############");
        }

        public boolean processMessage(Message message) {
            Log.e(TalkBackStateMachine.TAG, "SendExceptionState  processMessage.....,msg.what=" + TalkBackStateMachine.msg2Str(message.what));
            return false;
        }
    }

    class BusyNoSendState extends State {
        BusyNoSendState() {
        }

        public void enter() {
            Log.e(TalkBackStateMachine.TAG, "############ enter BusyNoSendState ############");
        }

        public void exit() {
            Log.e(TalkBackStateMachine.TAG, "############ exit BusyNoSendState ############");
        }

        public boolean processMessage(Message message) {
            Log.e(TalkBackStateMachine.TAG, "BusyNoSendState  processMessage.....,msg.what=" + TalkBackStateMachine.msg2Str(message.what));
            int i = message.what;
            if (i != 2011) {
                if (i == 2017) {
                    TalkBackStateMachine talkBackStateMachine = TalkBackStateMachine.this;
                    talkBackStateMachine.transitionTo(talkBackStateMachine.mReceiveSoundState);
                    TalkBackStateMachine talkBackStateMachine2 = TalkBackStateMachine.this;
                    talkBackStateMachine2.sendMessage(talkBackStateMachine2.obtainMessage(2017));
                    return true;
                } else if (i != 20111) {
                    return true;
                }
            }
            TalkBackStateMachine.this.fragment.showToast(R.string.interphone_recevice_no_send_toast);
            return true;
        }
    }

    class RelayConnectionFailedState extends State {
        RelayConnectionFailedState() {
        }

        public void enter() {
            Log.e(TalkBackStateMachine.TAG, "############ enter RelayConnectionFailedState ############");
        }

        public void exit() {
            Log.e(TalkBackStateMachine.TAG, "############ exit RelayConnectionFailedState ############");
        }

        public boolean processMessage(Message message) {
            Log.e(TalkBackStateMachine.TAG, "RelayConnectionFailedState  processMessage.....,msg.what=" + TalkBackStateMachine.msg2Str(message.what));
            if (message.what != 2020) {
                return true;
            }
            TalkBackStateMachine.this.fragment.showToast(R.string.relay_connection_failed);
            TalkBackStateMachine talkBackStateMachine = TalkBackStateMachine.this;
            talkBackStateMachine.transitionTo(talkBackStateMachine.mIdleState);
            return true;
        }
    }
}
