package com.pri.prizeinterphone.fragment;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Configuration;
import android.media.AudioAttributes;
import android.media.AudioFocusRequest;
import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import com.google.android.material.snackbar.Snackbar;
import com.pri.prizeinterphone.PrizeInterPhoneApp;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.Util.Clog;
import com.pri.prizeinterphone.Util.Util;
import com.pri.prizeinterphone.activity.RecordListActivity;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.manager.InterruptResultListener;
import com.pri.prizeinterphone.manager.LaunchListener;
import com.pri.prizeinterphone.manager.PCMReceiveManager;
import com.pri.prizeinterphone.manager.PrizePcmManager;
import com.pri.prizeinterphone.message.BaseMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.serial.data.AudioRecordData;
import com.pri.prizeinterphone.serial.data.ChannelData;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import com.pri.prizeinterphone.state.CmdStateMachine;
import com.pri.prizeinterphone.state.TalkBackStateMachine;
import com.pri.prizeinterphone.widget.CircleProgressDrawable;
import java.util.ArrayList;
import java.util.List;

public class InterPhoneTalkBackFragment extends BaseViewPagerFragment implements View.OnClickListener, View.OnTouchListener, LaunchListener, DmrManager.UpdateListener, InterruptResultListener {
    public static String PTTDOWNINTER = "com.interphone.ptt.down";
    public static String PTTUPINTER = "com.interphone.ptt.up";
    private static final String TAG = "InterPhoneTalkBackFragment";
    private AudioFocusRequest audioFocusRequest;
    private AudioManager audioManager;
    public List<ChannelData> channels = new ArrayList();
    private CountDownTimer countDownTimer;
    private AudioManager.OnAudioFocusChangeListener focusChangeListener = new AudioManager.OnAudioFocusChangeListener() {
        public void onAudioFocusChange(int i) {
            Log.d(InterPhoneTalkBackFragment.TAG, "onAudioFocusChange,focusChange=" + i);
        }
    };
    public boolean isButtonRecord = false;
    public boolean isPTTRecord = false;
    public boolean isReceiveStart = false;
    /* access modifiers changed from: private */
    public ChannelData mCurrentChannelData;
    /* access modifiers changed from: private */
    public int mCurrentChannelIndex = 0;
    private final Handler mHandler = new Handler();
    private ImageButton mImgTalkbackAdd;
    private ImageButton mImgTalkbackNumOne;
    private ImageButton mImgTalkbackNumTwo;
    /* access modifiers changed from: private */
    public CircleProgressDrawable mImgTalkbackProgress;
    private ImageButton mImgTalkbackRecord;
    private ImageButton mImgTalkbackSub;
    /* access modifiers changed from: private */
    public View mLocalView;
    private int mMaxChannelId;
    private PhoneStateListener mPhoneStateListener = new PhoneStateListener() {
        public void onCallStateChanged(int i, String str) {
            super.onCallStateChanged(i, str);
            if (i == 1 || i == 2) {
                if (InterPhoneTalkBackFragment.this.mTalkBackStateMachine != null) {
                    InterPhoneTalkBackFragment.this.mTalkBackStateMachine.sendMessage(InterPhoneTalkBackFragment.this.mTalkBackStateMachine.obtainMessage(2018));
                }
            } else if (InterPhoneTalkBackFragment.this.mTalkBackStateMachine != null) {
                InterPhoneTalkBackFragment.this.mTalkBackStateMachine.sendMessage(InterPhoneTalkBackFragment.this.mTalkBackStateMachine.obtainMessage(2019));
            }
        }
    };
    private PrizePcmManager mPrizePcmManager;
    /* access modifiers changed from: private */
    public TalkBackStateMachine mTalkBackStateMachine;
    private Toast mToast;
    private TextView mTvTalkbackCallName;
    private TextView mTvTalkbackColorOrNoise;
    private TextView mTvTalkbackPower;
    private TextView mTvTalkbackReceive;
    private TextView mTvTalkbackSend;
    private Runnable mUpdateUIRunnable = new Runnable() {
        public void run() {
            InterPhoneTalkBackFragment.this.updateUI();
        }
    };
    /* access modifiers changed from: private */
    public DmrManager.MessageListener messageListener;
    private SoundPool.OnLoadCompleteListener onLoadCompleteListener = new SoundPool.OnLoadCompleteListener() {
        public void onLoadComplete(SoundPool soundPool, int i, int i2) {
            soundPool.play(InterPhoneTalkBackFragment.this.soundId, 0.7f, 0.7f, 1, 0, 1.0f);
        }
    };
    public InterPhoneReceiver receiver;
    /* access modifiers changed from: private */
    public int soundId;
    private SoundPool soundPool;
    /* access modifiers changed from: private */
    public int tmpCurrentChannelIndex = this.mCurrentChannelIndex;

    public String getMyTag() {
        return TAG;
    }

    public void onSendStart() {
    }

    public void onSendStop() {
    }

    public void updateModuleInit() {
    }

    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        Clog.d(TAG, "onCreate");
        this.mPrizePcmManager = new PrizePcmManager();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("com.interphone.ptt.down");
        intentFilter.addAction("com.interphone.ptt.up");
        this.receiver = new InterPhoneReceiver();
        PrizeInterPhoneApp.getContext().registerReceiver(this.receiver, intentFilter);
        DmrManager.getInstance().addLaunchListener(this);
        ((TelephonyManager) getActivity().getSystemService("phone")).listen(this.mPhoneStateListener, 32);
        this.audioManager = (AudioManager) getActivity().getSystemService("audio");
    }

    public void initView(View view) {
        super.initView(view);
        View inflate = LayoutInflater.from(getActivity()).inflate(R.layout.fragment_talkback_view, (ViewGroup) null);
        this.mLocalView = inflate;
        this.mFragmentContainer.addView(inflate);
        this.mImgTalkbackNumOne = (ImageButton) this.mLocalView.findViewById(R.id.fragment_talkback_num_one);
        this.mImgTalkbackNumTwo = (ImageButton) this.mLocalView.findViewById(R.id.fragment_talkback_num_two);
        ImageButton imageButton = (ImageButton) this.mLocalView.findViewById(R.id.fragment_talkback_sub);
        this.mImgTalkbackSub = imageButton;
        imageButton.setOnClickListener(this);
        ImageButton imageButton2 = (ImageButton) this.mLocalView.findViewById(R.id.fragment_talkback_add);
        this.mImgTalkbackAdd = imageButton2;
        imageButton2.setOnClickListener(this);
        ImageButton imageButton3 = (ImageButton) this.mLocalView.findViewById(R.id.fragment_talkback_record);
        this.mImgTalkbackRecord = imageButton3;
        imageButton3.setOnTouchListener(this);
        this.mImgTalkbackRecord.setBackgroundResource(R.drawable.interphone_talkback_record_seletor);
        this.mImgTalkbackProgress = (CircleProgressDrawable) this.mLocalView.findViewById(R.id.fragment_talkback_progress);
        this.mTvTalkbackPower = (TextView) this.mLocalView.findViewById(R.id.fragment_talkback_power);
        this.mTvTalkbackColorOrNoise = (TextView) this.mLocalView.findViewById(R.id.fragment_talkback_color_or_noise);
        this.mTvTalkbackSend = (TextView) this.mLocalView.findViewById(R.id.fragment_talkback_send);
        this.mTvTalkbackReceive = (TextView) this.mLocalView.findViewById(R.id.fragment_talkback_recieve);
        this.mTvTalkbackCallName = (TextView) this.mLocalView.findViewById(R.id.fragment_talkback_call_name);
        setAddButton(R.drawable.interphone_record_list_selector);
        DmrManager.getInstance().registerUpdateListener(this);
        DmrManager.getInstance().addInterruptListener(this);
        this.mTalkBackStateMachine = TalkBackStateMachine.makePerson(this);
    }

    public void initData() {
        try {
            this.channels = DmrManager.getInstance().getChannelList();
            this.mCurrentChannelData = DmrManager.getInstance().getCurrentChannel();
            this.mCurrentChannelIndex = DmrManager.getInstance().getCurrentChannelIndex();
            this.mMaxChannelId = DmrManager.getInstance().getChannelList().size();
            updateChannelNumber();
        } catch (Exception e) {
            Log.d(TAG, "initData,not call DmrManager.initChannelData() or faster than call DmrManager.initChannelData(),so InitChannelDataDB is null", e);
        }
    }

    /* access modifiers changed from: private */
    public void updateUI() {
        int i;
        int i2;
        Log.d(TAG, "updateUI");
        initData();
        ChannelData channelData = this.mCurrentChannelData;
        if (channelData == null) {
            Log.d(TAG, "updateUI, mCurrentChannelData is null");
            return;
        }
        if (channelData.power == 1) {
            TextView textView = this.mTvTalkbackPower;
            textView.setText(getString(R.string.interphone_channel_power) + getString(R.string.interphone_channel_split) + getString(R.string.interphone_channel_power_high_value));
        } else {
            TextView textView2 = this.mTvTalkbackPower;
            textView2.setText(getString(R.string.interphone_channel_power) + getString(R.string.interphone_channel_split) + getString(R.string.interphone_channel_power_low_value));
        }
        if (this.mCurrentChannelData.type == 0) {
            TextView textView3 = this.mTvTalkbackColorOrNoise;
            textView3.setText(getString(R.string.interphone_channel_color) + getString(R.string.interphone_channel_split) + this.mCurrentChannelData.cc);
        } else {
            TextView textView4 = this.mTvTalkbackColorOrNoise;
            textView4.setText(getString(R.string.interphone_channel_sq) + getString(R.string.interphone_channel_split) + this.mCurrentChannelData.sq);
        }
        StringBuilder sb = new StringBuilder();
        String str = "";
        sb.append(str);
        sb.append(this.mCurrentChannelData.txFreq);
        String sb2 = sb.toString();
        TextView textView5 = this.mTvTalkbackSend;
        textView5.setText(getString(R.string.interphone_channel_frequency_s) + getString(R.string.interphone_channel_split) + sb2.substring(0, 3) + "." + sb2.substring(3, sb2.length()));
        StringBuilder sb3 = new StringBuilder();
        sb3.append(str);
        sb3.append(this.mCurrentChannelData.rxFreq);
        String sb4 = sb3.toString();
        TextView textView6 = this.mTvTalkbackReceive;
        textView6.setText(getString(R.string.interphone_channel_frequency_r) + getString(R.string.interphone_channel_split) + sb4.substring(0, 3) + "." + sb4.substring(3, sb4.length()));
        ChannelData channelData2 = this.mCurrentChannelData;
        if (channelData2.type == 0) {
            int i3 = channelData2.contactType;
            if (i3 == 0) {
                TextView textView7 = this.mTvTalkbackCallName;
                textView7.setText(getString(R.string.interphone_channel_contact_type) + " " + getString(R.string.interphone_channel_split) + getString(R.string.interphone_channel_contact_type_person) + " " + this.mCurrentChannelData.txContact);
            } else if (i3 == 1) {
                TextView textView8 = this.mTvTalkbackCallName;
                textView8.setText(getString(R.string.interphone_channel_contact_type) + getString(R.string.interphone_channel_split) + getString(R.string.interphone_channel_contact_type_group) + " " + this.mCurrentChannelData.txContact);
            } else {
                TextView textView9 = this.mTvTalkbackCallName;
                textView9.setText(getString(R.string.interphone_channel_contact_type) + getString(R.string.interphone_channel_split) + getString(R.string.interphone_channel_contact_type_all));
            }
            this.mTvTalkbackCallName.setVisibility(0);
        } else {
            this.mTvTalkbackCallName.setVisibility(4);
        }
        ChannelData channelData3 = this.mCurrentChannelData;
        int i4 = channelData3.txFreq;
        if (i4 >= 400000000 && i4 <= 480000000 && (i2 = channelData3.rxFreq) >= 400000000 && i2 <= 480000000) {
            str = "(UHF)";
        } else if (i4 >= 136000000 && i4 <= 174000000 && (i = channelData3.rxFreq) >= 136000000 && i <= 174000000) {
            str = "(VHF)";
        }
        if (!TextUtils.isEmpty(channelData3.getName())) {
            if (TextUtils.isEmpty(str)) {
                setTitle(this.mCurrentChannelData.getName());
                return;
            }
            setTitle(this.mCurrentChannelData.getName() + str);
        } else if (this.mCurrentChannelData.type == 0) {
            if (TextUtils.isEmpty(str)) {
                setTitle(getString(R.string.interphone_channel_type_digital) + " " + this.mCurrentChannelData.getNumber());
                return;
            }
            setTitle(getString(R.string.interphone_channel_type_digital) + " " + this.mCurrentChannelData.getNumber() + str);
        } else if (TextUtils.isEmpty(str)) {
            setTitle(getString(R.string.interphone_channel_type_analog) + " " + this.mCurrentChannelData.getNumber());
        } else {
            setTitle(getString(R.string.interphone_channel_type_analog) + " " + this.mCurrentChannelData.getNumber() + str);
        }
    }

    public void doAddAction() {
        super.doAddAction();
        startActivity(new Intent(getActivity(), RecordListActivity.class));
    }

    public void onConfigurationChanged(@NonNull Configuration configuration) {
        super.onConfigurationChanged(configuration);
        updateUI();
    }

    public void updateView() {
        super.updateView();
    }

    public void updateChannelId(boolean z) {
        if (CmdStateMachine.getInstance().getCurrentState() == CmdStateMachine.getInstance().getSetChannelState()) {
            Log.d(TAG, "updateChannelId is setting channel...");
        } else if (getActivity() != null) {
            getActivity().runOnUiThread(new InterPhoneTalkBackFragment$$ExternalSyntheticLambda3(this, z));
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$updateChannelId$0(boolean z) {
        if (this.channels.size() > 1) {
            this.mCurrentChannelData = this.channels.get(this.mCurrentChannelIndex);
            int i = this.mCurrentChannelIndex;
            this.tmpCurrentChannelIndex = i;
            if (z) {
                this.tmpCurrentChannelIndex = i + 1;
            } else {
                this.tmpCurrentChannelIndex = i - 1;
            }
            int i2 = this.tmpCurrentChannelIndex;
            if (i2 < 0) {
                this.mCurrentChannelIndex = 0;
                return;
            }
            int i3 = this.mMaxChannelId;
            if (i2 > i3 - 1) {
                this.mCurrentChannelIndex = i3 - 1;
                return;
            }
            if (this.messageListener == null) {
                this.messageListener = new DmrManager.MessageListener() {
                    public void errorEvent(Byte b) {
                        if (b.byteValue() == 34 || b.byteValue() == 35) {
                            Snackbar.make(InterPhoneTalkBackFragment.this.mLocalView, (int) R.string.operate_fail, 0).show();
                            DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_DIGITAL_INFO_CMD), InterPhoneTalkBackFragment.this.messageListener);
                            DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_ANALOG_INFO_CMD), InterPhoneTalkBackFragment.this.messageListener);
                        }
                    }

                    public void dealEvent(BaseMessage baseMessage) {
                        byte b = baseMessage.packet.cmd;
                        if (b == 34 || b == 35) {
                            InterPhoneTalkBackFragment.this.mCurrentChannelData.setActive(0);
                            DmrManager.getInstance().getCurrentDbHelper().updateChannel(InterPhoneTalkBackFragment.this.mCurrentChannelData);
                            InterPhoneTalkBackFragment interPhoneTalkBackFragment = InterPhoneTalkBackFragment.this;
                            interPhoneTalkBackFragment.mCurrentChannelIndex = interPhoneTalkBackFragment.tmpCurrentChannelIndex;
                            InterPhoneTalkBackFragment interPhoneTalkBackFragment2 = InterPhoneTalkBackFragment.this;
                            interPhoneTalkBackFragment2.mCurrentChannelData = interPhoneTalkBackFragment2.channels.get(interPhoneTalkBackFragment2.mCurrentChannelIndex);
                            InterPhoneTalkBackFragment.this.mCurrentChannelData.setActive(1);
                            DmrManager.getInstance().getCurrentDbHelper().updateChannel(InterPhoneTalkBackFragment.this.mCurrentChannelData);
                            DmrManager.getInstance().updateChannelList();
                            DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_DIGITAL_INFO_CMD), InterPhoneTalkBackFragment.this.messageListener);
                            DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_ANALOG_INFO_CMD), InterPhoneTalkBackFragment.this.messageListener);
                        }
                    }
                };
            }
            DmrManager.getInstance().registerEventListener(Const.Command.SET_DIGITAL_INFO_CMD, this.messageListener);
            DmrManager.getInstance().registerEventListener(Const.Command.SET_ANALOG_INFO_CMD, this.messageListener);
            try {
                DmrManager.getInstance().syncChannelInfoWithData(this.channels.get(this.tmpCurrentChannelIndex).clone());
            } catch (Exception e) {
                Log.d(TAG, "updateChannelId,error", e);
            }
            showProgressDialog(getString(R.string.interphone_channel_change_dialog_title));
            this.mHandler.postDelayed(this.mDismissRunnable, 3000);
        }
    }

    private void updateChannelNumber() {
        int number = this.mCurrentChannelData.getNumber();
        if (number < 10) {
            this.mImgTalkbackNumOne.setBackgroundResource(R.drawable.interphone_talkback_num_0);
            this.mImgTalkbackNumTwo.setBackgroundResource(Util.FRAGMENT_TALKBACK_NUM_RES[number]);
            return;
        }
        ImageButton imageButton = this.mImgTalkbackNumOne;
        int[] iArr = Util.FRAGMENT_TALKBACK_NUM_RES;
        imageButton.setBackgroundResource(iArr[number / 10]);
        this.mImgTalkbackNumTwo.setBackgroundResource(iArr[number % 10]);
    }

    public void onClick(View view) {
        TalkBackStateMachine talkBackStateMachine;
        int id = view.getId();
        if (id == R.id.fragment_talkback_add) {
            TalkBackStateMachine talkBackStateMachine2 = this.mTalkBackStateMachine;
            if (talkBackStateMachine2 != null) {
                talkBackStateMachine2.sendMessage(talkBackStateMachine2.obtainMessage(2021, (Object) Boolean.TRUE));
            }
        } else if (id == R.id.fragment_talkback_sub && (talkBackStateMachine = this.mTalkBackStateMachine) != null) {
            talkBackStateMachine.sendMessage(talkBackStateMachine.obtainMessage(2021, (Object) Boolean.FALSE));
        }
    }

    public boolean onTouch(View view, MotionEvent motionEvent) {
        if (view.getId() == R.id.fragment_talkback_record) {
            Log.d(TAG, "motionEvent=" + motionEvent);
            int action = motionEvent.getAction();
            if (action != 0) {
                if ((action == 1 || action == 3) && this.isButtonRecord) {
                    this.mTalkBackStateMachine.removeMessages(TalkBackStateMachine.MSG_RECORD_SOUND_START_NEED_DELAY);
                    TalkBackStateMachine talkBackStateMachine = this.mTalkBackStateMachine;
                    talkBackStateMachine.sendMessage(talkBackStateMachine.obtainMessage(2012));
                    this.isButtonRecord = false;
                }
            } else if (!this.isPTTRecord) {
                view.getParent().requestDisallowInterceptTouchEvent(true);
                this.isButtonRecord = true;
                this.mTalkBackStateMachine.removeMessages(TalkBackStateMachine.MSG_RECORD_SOUND_START_NEED_DELAY);
                TalkBackStateMachine talkBackStateMachine2 = this.mTalkBackStateMachine;
                talkBackStateMachine2.sendMessageDelayed(talkBackStateMachine2.obtainMessage(TalkBackStateMachine.MSG_RECORD_SOUND_START_NEED_DELAY), 200);
            }
        }
        return true;
    }

    private void saveSendRecord() {
        if (DmrManager.getInstance().needSaveRecordFile() && this.mPrizePcmManager.getSaveRecord()) {
            this.mPrizePcmManager.setSaveRecord(false);
            String recordFileName = this.mPrizePcmManager.getRecordFileName();
            String recordFilePath = this.mPrizePcmManager.getRecordFilePath();
            AudioRecordData audioRecordData = new AudioRecordData();
            audioRecordData.setName(recordFileName);
            audioRecordData.setChannelName(this.mCurrentChannelData.getNumber() + "");
            audioRecordData.setDirection(0);
            audioRecordData.setTimestamp(this.mPrizePcmManager.getTimestamp());
            audioRecordData.setFilePath(recordFilePath);
            DmrManager.getInstance().addRecordDb(audioRecordData);
        }
    }

    private void createSoundPool() {
        if (this.soundPool == null) {
            SoundPool build = new SoundPool.Builder().setMaxStreams(1).setAudioAttributes(new AudioAttributes.Builder().setUsage(1).setContentType(2).build()).build();
            this.soundPool = build;
            build.setOnLoadCompleteListener(this.onLoadCompleteListener);
        }
    }

    private void playSound() {
        if (isAdded()) {
            createSoundPool();
            this.soundId = this.soundPool.load(getActivity(), R.raw.start_send, 1);
        }
    }

    public void onStop() {
        super.onStop();
    }

    public void onDestroy() {
        super.onDestroy();
        TalkBackStateMachine talkBackStateMachine = this.mTalkBackStateMachine;
        if (talkBackStateMachine != null) {
            talkBackStateMachine.sendMessage(talkBackStateMachine.obtainMessage(2012));
            this.mTalkBackStateMachine.quit();
        }
        this.mHandler.removeCallbacksAndMessages((Object) null);
        PrizeInterPhoneApp.getContext().unregisterReceiver(this.receiver);
        DmrManager.getInstance().removeInterruptListener(this);
        DmrManager.getInstance().unregisterUpdateListener(this);
    }

    public void updateTalkBackChannelList() {
        this.mHandler.post(this.mUpdateUIRunnable);
    }

    public void showToast(int i) {
        Toast toast = this.mToast;
        if (toast != null) {
            toast.cancel();
        }
        if (isAdded()) {
            Toast makeText = Toast.makeText(getContext(), i, 0);
            this.mToast = makeText;
            makeText.show();
        }
    }

    public void onReceiveInterrupt(int i) {
        TalkBackStateMachine talkBackStateMachine = this.mTalkBackStateMachine;
        talkBackStateMachine.sendMessage(talkBackStateMachine.obtainMessage(2014, i));
    }

    public class InterPhoneReceiver extends BroadcastReceiver {
        public InterPhoneReceiver() {
        }

        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(InterPhoneTalkBackFragment.PTTDOWNINTER)) {
                InterPhoneTalkBackFragment interPhoneTalkBackFragment = InterPhoneTalkBackFragment.this;
                if (!interPhoneTalkBackFragment.isButtonRecord) {
                    interPhoneTalkBackFragment.isPTTRecord = true;
                    interPhoneTalkBackFragment.mTalkBackStateMachine.removeMessages(TalkBackStateMachine.MSG_RECORD_SOUND_START_NEED_DELAY);
                    InterPhoneTalkBackFragment.this.mTalkBackStateMachine.sendMessageDelayed(InterPhoneTalkBackFragment.this.mTalkBackStateMachine.obtainMessage(TalkBackStateMachine.MSG_RECORD_SOUND_START_NEED_DELAY), 200);
                }
            } else if (action.equals(InterPhoneTalkBackFragment.PTTUPINTER)) {
                InterPhoneTalkBackFragment interPhoneTalkBackFragment2 = InterPhoneTalkBackFragment.this;
                if (interPhoneTalkBackFragment2.isPTTRecord) {
                    interPhoneTalkBackFragment2.mTalkBackStateMachine.removeMessages(TalkBackStateMachine.MSG_RECORD_SOUND_START_NEED_DELAY);
                    InterPhoneTalkBackFragment.this.mTalkBackStateMachine.sendMessage(InterPhoneTalkBackFragment.this.mTalkBackStateMachine.obtainMessage(2012));
                    InterPhoneTalkBackFragment.this.isPTTRecord = false;
                }
            }
        }
    }

    public void getAudioFocus() {
        if (isAdded()) {
            try {
                if (this.audioManager == null) {
                    this.audioManager = (AudioManager) getContext().getSystemService("audio");
                }
                if (this.audioFocusRequest == null) {
                    this.audioFocusRequest = new AudioFocusRequest.Builder(3).setOnAudioFocusChangeListener(this.focusChangeListener).build();
                }
                int requestAudioFocus = this.audioManager.requestAudioFocus(this.audioFocusRequest);
                Log.d(TAG, "requestAudioFocus,result=" + requestAudioFocus);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void abandonAudioFocus() {
        AudioFocusRequest audioFocusRequest2;
        AudioManager audioManager2 = this.audioManager;
        if (audioManager2 != null && (audioFocusRequest2 = this.audioFocusRequest) != null) {
            int abandonAudioFocusRequest = audioManager2.abandonAudioFocusRequest(audioFocusRequest2);
            Log.d(TAG, "requestAudioFocus,result=" + abandonAudioFocusRequest);
        }
    }

    public void onResume() {
        super.onResume();
        Log.d(TAG, "onResume");
        updateUI();
    }

    public void onReceiveStart() {
        TalkBackStateMachine talkBackStateMachine = this.mTalkBackStateMachine;
        if (talkBackStateMachine != null) {
            talkBackStateMachine.sendMessage(2016);
        }
    }

    public void onReceiveStop() {
        TalkBackStateMachine talkBackStateMachine = this.mTalkBackStateMachine;
        if (talkBackStateMachine != null) {
            talkBackStateMachine.sendMessage(2017);
        }
    }

    public void onSendTimeout() {
        TalkBackStateMachine talkBackStateMachine = this.mTalkBackStateMachine;
        if (talkBackStateMachine != null) {
            talkBackStateMachine.sendMessage(talkBackStateMachine.obtainMessage(2020));
        }
    }

    public void sendInterrupt() {
        DmrManager.getInstance().sendTransmissionInterruptCmdToMdl(3);
    }

    public boolean isInterruptTransport() {
        ChannelData channelData = this.mCurrentChannelData;
        return channelData != null && channelData.getInterrupt() == 3;
    }

    public void setTalkbackRecordBg(int i) {
        if (getActivity() != null) {
            getActivity().runOnUiThread(new InterPhoneTalkBackFragment$$ExternalSyntheticLambda1(this, i));
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$setTalkbackRecordBg$1(int i) {
        if (i == 1) {
            this.mImgTalkbackRecord.setBackgroundResource(R.drawable.interphone_talkback_recording);
        } else if (i != 2) {
            this.mImgTalkbackRecord.setBackgroundResource(R.drawable.interphone_talkback_record);
        } else {
            this.mImgTalkbackRecord.setBackgroundResource(R.drawable.interphone_talkback_recv);
        }
    }

    public int startPcmRecord() {
        return this.mPrizePcmManager.startPcmRecord();
    }

    public void createRecordFile() {
        this.mPrizePcmManager.createRecordFile();
    }

    public void stopPcmRecord() {
        this.mPrizePcmManager.stopPcmRecord();
    }

    public void startPcmRead() {
        PCMReceiveManager.getInstance().startPcmRead();
    }

    public void stopPcmRead() {
        PCMReceiveManager.getInstance().stopPcmRead();
    }

    public void setStartRecordPrepare() {
        setTalkbackRecordBg(1);
        getAudioFocus();
        if (DmrManager.getInstance().playStartPromptTone()) {
            playSound();
        }
    }

    public void setStopRecordPrepare() {
        setTalkbackRecordBg(0);
        if (DmrManager.getInstance().playEndPromptTone()) {
            playSound();
        }
        saveSendRecord();
        cancelLimitRecordTime();
        abandonAudioFocus();
    }

    public void setStartReceivePrepare() {
        getAudioFocus();
        setTalkbackRecordBg(2);
    }

    public void setStopReceivePrepare() {
        if (DmrManager.getInstance().needSaveRecordFile()) {
            AudioRecordData audioRecordData = new AudioRecordData();
            audioRecordData.setName(PCMReceiveManager.getInstance().getRecordFileName());
            audioRecordData.setChannelName(this.mCurrentChannelData.getNumber() + "");
            audioRecordData.setDirection(1);
            audioRecordData.setTimestamp(PCMReceiveManager.getInstance().getTimestamp());
            audioRecordData.setFilePath(PCMReceiveManager.getInstance().getRecordFilePath());
            DmrManager.getInstance().addRecordDb(audioRecordData);
        }
        abandonAudioFocus();
        setTalkbackRecordBg(0);
    }

    public void launchCommand() {
        DmrManager.getInstance().launchCommand();
    }

    public void launchEnd() {
        DmrManager.getInstance().launchEnd();
    }

    public void showLimitRecordTime() {
        if (getActivity() != null) {
            getActivity().runOnUiThread(new InterPhoneTalkBackFragment$$ExternalSyntheticLambda2(this));
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$showLimitRecordTime$2() {
        this.mImgTalkbackProgress.setVisibility(0);
        int intData = PersonSharePrefData.getIntData(getActivity(), "pref_person_limit_send_time", 30);
        if (intData > 0) {
            final int i = intData * 1000;
            AnonymousClass6 r1 = new CountDownTimer((long) i, 1000) {
                public void onTick(long j) {
                    InterPhoneTalkBackFragment.this.mImgTalkbackProgress.setProgress(100 - ((((int) j) * 100) / i));
                }

                public void onFinish() {
                    InterPhoneTalkBackFragment.this.mTalkBackStateMachine.sendMessage(InterPhoneTalkBackFragment.this.mTalkBackStateMachine.obtainMessage(2012));
                }
            };
            this.countDownTimer = r1;
            r1.start();
        }
    }

    public void cancelLimitRecordTime() {
        if (getActivity() != null) {
            getActivity().runOnUiThread(new InterPhoneTalkBackFragment$$ExternalSyntheticLambda0(this));
        }
    }

    /* access modifiers changed from: private */
    public /* synthetic */ void lambda$cancelLimitRecordTime$3() {
        CountDownTimer countDownTimer2 = this.countDownTimer;
        if (countDownTimer2 != null) {
            countDownTimer2.cancel();
        }
        CircleProgressDrawable circleProgressDrawable = this.mImgTalkbackProgress;
        if (circleProgressDrawable != null) {
            circleProgressDrawable.setProgress(0);
            this.mImgTalkbackProgress.setVisibility(4);
        }
    }

    public void setSendStatus(int i) {
        DmrManager.getInstance().setSendStatus(i);
    }

    public boolean isSendStatus() {
        return DmrManager.getInstance().isSendStatus();
    }

    public boolean getBusyNoSend() {
        return DmrManager.getInstance().getBusyNoSend();
    }
}
