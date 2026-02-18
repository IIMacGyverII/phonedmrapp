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
/* loaded from: classes4.dex */
public class InterPhoneTalkBackFragment extends BaseViewPagerFragment implements View.OnClickListener, View.OnTouchListener, LaunchListener, DmrManager.UpdateListener, InterruptResultListener {
    public static String PTTDOWNINTER = "com.interphone.ptt.down";
    public static String PTTUPINTER = "com.interphone.ptt.up";
    private static final String TAG = "InterPhoneTalkBackFragment";
    private AudioFocusRequest audioFocusRequest;
    private AudioManager audioManager;
    private CountDownTimer countDownTimer;
    private ChannelData mCurrentChannelData;
    private ImageButton mImgTalkbackAdd;
    private ImageButton mImgTalkbackNumOne;
    private ImageButton mImgTalkbackNumTwo;
    private CircleProgressDrawable mImgTalkbackProgress;
    private ImageButton mImgTalkbackRecord;
    private ImageButton mImgTalkbackSub;
    private View mLocalView;
    private int mMaxChannelId;
    private PrizePcmManager mPrizePcmManager;
    private TalkBackStateMachine mTalkBackStateMachine;
    private Toast mToast;
    private TextView mTvTalkbackCallName;
    private TextView mTvTalkbackColorOrNoise;
    private TextView mTvTalkbackPower;
    private TextView mTvTalkbackReceive;
    private TextView mTvTalkbackSend;
    private DmrManager.MessageListener messageListener;
    public InterPhoneReceiver receiver;
    private int soundId;
    private SoundPool soundPool;
    private int mCurrentChannelIndex = 0;
    public List<ChannelData> channels = new ArrayList();
    private final Handler mHandler = new Handler();
    private Runnable mUpdateUIRunnable = new Runnable() { // from class: com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment.1
        @Override // java.lang.Runnable
        public void run() {
            InterPhoneTalkBackFragment.this.updateUI();
        }
    };
    private int tmpCurrentChannelIndex = this.mCurrentChannelIndex;
    private SoundPool.OnLoadCompleteListener onLoadCompleteListener = new SoundPool.OnLoadCompleteListener() { // from class: com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment.3
        @Override // android.media.SoundPool.OnLoadCompleteListener
        public void onLoadComplete(SoundPool soundPool, int i, int i2) {
            soundPool.play(InterPhoneTalkBackFragment.this.soundId, 0.7f, 0.7f, 1, 0, 1.0f);
        }
    };
    public boolean isPTTRecord = false;
    public boolean isButtonRecord = false;
    public boolean isReceiveStart = false;
    private PhoneStateListener mPhoneStateListener = new PhoneStateListener() { // from class: com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment.4
        @Override // android.telephony.PhoneStateListener
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
    private AudioManager.OnAudioFocusChangeListener focusChangeListener = new AudioManager.OnAudioFocusChangeListener() { // from class: com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment.5
        @Override // android.media.AudioManager.OnAudioFocusChangeListener
        public void onAudioFocusChange(int i) {
            Log.d(InterPhoneTalkBackFragment.TAG, "onAudioFocusChange,focusChange=" + i);
        }
    };

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
    public String getMyTag() {
        return TAG;
    }

    @Override // com.pri.prizeinterphone.manager.LaunchListener
    public void onSendStart() {
    }

    @Override // com.pri.prizeinterphone.manager.LaunchListener
    public void onSendStop() {
    }

    @Override // com.pri.prizeinterphone.manager.DmrManager.UpdateListener
    public void updateModuleInit() {
    }

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment, androidx.fragment.app.Fragment
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

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
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

    /* JADX INFO: Access modifiers changed from: private */
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
        sb.append("");
        sb.append(this.mCurrentChannelData.txFreq);
        String sb2 = sb.toString();
        TextView textView5 = this.mTvTalkbackSend;
        textView5.setText(getString(R.string.interphone_channel_frequency_s) + getString(R.string.interphone_channel_split) + sb2.substring(0, 3) + "." + sb2.substring(3, sb2.length()));
        StringBuilder sb3 = new StringBuilder();
        sb3.append("");
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

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
    public void doAddAction() {
        super.doAddAction();
        startActivity(new Intent(getActivity(), RecordListActivity.class));
    }

    @Override // androidx.fragment.app.Fragment, android.content.ComponentCallbacks
    public void onConfigurationChanged(@NonNull Configuration configuration) {
        super.onConfigurationChanged(configuration);
        updateUI();
    }

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
    public void updateView() {
        super.updateView();
    }

    public void updateChannelId(final boolean z) {
        if (CmdStateMachine.getInstance().getCurrentState() == CmdStateMachine.getInstance().getSetChannelState()) {
            Log.d(TAG, "updateChannelId is setting channel...");
        } else if (getActivity() != null) {
            getActivity().runOnUiThread(new Runnable() { // from class: com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment$$ExternalSyntheticLambda3
                @Override // java.lang.Runnable
                public final void run() {
                    InterPhoneTalkBackFragment.this.lambda$updateChannelId$0(z);
                }
            });
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public /* synthetic */ void lambda$updateChannelId$0(boolean z) {
        if (this.channels.size() <= 1) {
            return;
        }
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
            this.messageListener = new DmrManager.MessageListener() { // from class: com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment.2
                @Override // com.pri.prizeinterphone.manager.DmrManager.MessageListener
                public void errorEvent(Byte b) {
                    if (b.byteValue() == 34 || b.byteValue() == 35) {
                        Snackbar.make(InterPhoneTalkBackFragment.this.mLocalView, (int) R.string.operate_fail, 0).show();
                        DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_DIGITAL_INFO_CMD), InterPhoneTalkBackFragment.this.messageListener);
                        DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_ANALOG_INFO_CMD), InterPhoneTalkBackFragment.this.messageListener);
                    }
                }

                @Override // com.pri.prizeinterphone.manager.DmrManager.MessageListener
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
                        DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_DIGITAL_INFO_CMD), InterPhoneTalkBackFragment.this.messageListener);
                        DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_ANALOG_INFO_CMD), InterPhoneTalkBackFragment.this.messageListener);
                    }
                }
            };
        }
        DmrManager.getInstance().registerEventListener(Const.Command.SET_DIGITAL_INFO_CMD, this.messageListener);
        DmrManager.getInstance().registerEventListener(Const.Command.SET_ANALOG_INFO_CMD, this.messageListener);
        try {
            DmrManager.getInstance().syncChannelInfoWithData(this.channels.get(this.tmpCurrentChannelIndex).m1325clone());
        } catch (Exception e) {
            Log.d(TAG, "updateChannelId,error", e);
        }
        showProgressDialog(getString(R.string.interphone_channel_change_dialog_title));
        this.mHandler.postDelayed(this.mDismissRunnable, 3000L);
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

    @Override // android.view.View.OnClickListener
    public void onClick(View view) {
        TalkBackStateMachine talkBackStateMachine;
        int id = view.getId();
        if (id != R.id.fragment_talkback_add) {
            if (id == R.id.fragment_talkback_sub && (talkBackStateMachine = this.mTalkBackStateMachine) != null) {
                talkBackStateMachine.sendMessage(talkBackStateMachine.obtainMessage(2021, Boolean.FALSE));
                return;
            }
            return;
        }
        TalkBackStateMachine talkBackStateMachine2 = this.mTalkBackStateMachine;
        if (talkBackStateMachine2 != null) {
            talkBackStateMachine2.sendMessage(talkBackStateMachine2.obtainMessage(2021, Boolean.TRUE));
        }
    }

    @Override // android.view.View.OnTouchListener
    public boolean onTouch(View view, MotionEvent motionEvent) {
        if (view.getId() == R.id.fragment_talkback_record) {
            Log.d(TAG, "motionEvent=" + motionEvent);
            int action = motionEvent.getAction();
            if (action == 0) {
                if (!this.isPTTRecord) {
                    view.getParent().requestDisallowInterceptTouchEvent(true);
                    this.isButtonRecord = true;
                    this.mTalkBackStateMachine.removeMessages(TalkBackStateMachine.MSG_RECORD_SOUND_START_NEED_DELAY);
                    TalkBackStateMachine talkBackStateMachine = this.mTalkBackStateMachine;
                    talkBackStateMachine.sendMessageDelayed(talkBackStateMachine.obtainMessage(TalkBackStateMachine.MSG_RECORD_SOUND_START_NEED_DELAY), 200L);
                }
            } else if ((action == 1 || action == 3) && this.isButtonRecord) {
                this.mTalkBackStateMachine.removeMessages(TalkBackStateMachine.MSG_RECORD_SOUND_START_NEED_DELAY);
                TalkBackStateMachine talkBackStateMachine2 = this.mTalkBackStateMachine;
                talkBackStateMachine2.sendMessage(talkBackStateMachine2.obtainMessage(2012));
                this.isButtonRecord = false;
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

    @Override // androidx.fragment.app.Fragment
    public void onStop() {
        super.onStop();
    }

    @Override // androidx.fragment.app.Fragment
    public void onDestroy() {
        super.onDestroy();
        TalkBackStateMachine talkBackStateMachine = this.mTalkBackStateMachine;
        if (talkBackStateMachine != null) {
            talkBackStateMachine.sendMessage(talkBackStateMachine.obtainMessage(2012));
            this.mTalkBackStateMachine.quit();
        }
        this.mHandler.removeCallbacksAndMessages(null);
        PrizeInterPhoneApp.getContext().unregisterReceiver(this.receiver);
        DmrManager.getInstance().removeInterruptListener(this);
        DmrManager.getInstance().unregisterUpdateListener(this);
    }

    @Override // com.pri.prizeinterphone.manager.DmrManager.UpdateListener
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

    @Override // com.pri.prizeinterphone.manager.InterruptResultListener
    public void onReceiveInterrupt(int i) {
        TalkBackStateMachine talkBackStateMachine = this.mTalkBackStateMachine;
        talkBackStateMachine.sendMessage(talkBackStateMachine.obtainMessage(2014, i));
    }

    /* loaded from: classes4.dex */
    public class InterPhoneReceiver extends BroadcastReceiver {
        public InterPhoneReceiver() {
        }

        @Override // android.content.BroadcastReceiver
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(InterPhoneTalkBackFragment.PTTDOWNINTER)) {
                InterPhoneTalkBackFragment interPhoneTalkBackFragment = InterPhoneTalkBackFragment.this;
                if (interPhoneTalkBackFragment.isButtonRecord) {
                    return;
                }
                interPhoneTalkBackFragment.isPTTRecord = true;
                interPhoneTalkBackFragment.mTalkBackStateMachine.removeMessages(TalkBackStateMachine.MSG_RECORD_SOUND_START_NEED_DELAY);
                InterPhoneTalkBackFragment.this.mTalkBackStateMachine.sendMessageDelayed(InterPhoneTalkBackFragment.this.mTalkBackStateMachine.obtainMessage(TalkBackStateMachine.MSG_RECORD_SOUND_START_NEED_DELAY), 200L);
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
        AudioFocusRequest audioFocusRequest;
        AudioManager audioManager = this.audioManager;
        if (audioManager == null || (audioFocusRequest = this.audioFocusRequest) == null) {
            return;
        }
        int abandonAudioFocusRequest = audioManager.abandonAudioFocusRequest(audioFocusRequest);
        Log.d(TAG, "requestAudioFocus,result=" + abandonAudioFocusRequest);
    }

    @Override // androidx.fragment.app.Fragment
    public void onResume() {
        super.onResume();
        Log.d(TAG, "onResume");
        updateUI();
    }

    @Override // com.pri.prizeinterphone.manager.LaunchListener
    public void onReceiveStart() {
        TalkBackStateMachine talkBackStateMachine = this.mTalkBackStateMachine;
        if (talkBackStateMachine != null) {
            talkBackStateMachine.sendMessage(2016);
        }
    }

    @Override // com.pri.prizeinterphone.manager.LaunchListener
    public void onReceiveStop() {
        TalkBackStateMachine talkBackStateMachine = this.mTalkBackStateMachine;
        if (talkBackStateMachine != null) {
            talkBackStateMachine.sendMessage(2017);
        }
    }

    @Override // com.pri.prizeinterphone.manager.LaunchListener
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

    public void setTalkbackRecordBg(final int i) {
        if (getActivity() != null) {
            getActivity().runOnUiThread(new Runnable() { // from class: com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment$$ExternalSyntheticLambda1
                @Override // java.lang.Runnable
                public final void run() {
                    InterPhoneTalkBackFragment.this.lambda$setTalkbackRecordBg$1(i);
                }
            });
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public /* synthetic */ void lambda$setTalkbackRecordBg$1(int i) {
        if (i == 1) {
            this.mImgTalkbackRecord.setBackgroundResource(R.drawable.interphone_talkback_recording);
        } else if (i == 2) {
            this.mImgTalkbackRecord.setBackgroundResource(R.drawable.interphone_talkback_recv);
        } else {
            this.mImgTalkbackRecord.setBackgroundResource(R.drawable.interphone_talkback_record);
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
            getActivity().runOnUiThread(new Runnable() { // from class: com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment$$ExternalSyntheticLambda2
                @Override // java.lang.Runnable
                public final void run() {
                    InterPhoneTalkBackFragment.this.lambda$showLimitRecordTime$2();
                }
            });
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public /* synthetic */ void lambda$showLimitRecordTime$2() {
        this.mImgTalkbackProgress.setVisibility(0);
        int intData = PersonSharePrefData.getIntData(getActivity(), "pref_person_limit_send_time", 30);
        if (intData > 0) {
            final int i = intData * 1000;
            CountDownTimer countDownTimer = new CountDownTimer(i, 1000L) { // from class: com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment.6
                @Override // android.os.CountDownTimer
                public void onTick(long j) {
                    InterPhoneTalkBackFragment.this.mImgTalkbackProgress.setProgress(100 - ((((int) j) * 100) / i));
                }

                @Override // android.os.CountDownTimer
                public void onFinish() {
                    InterPhoneTalkBackFragment.this.mTalkBackStateMachine.sendMessage(InterPhoneTalkBackFragment.this.mTalkBackStateMachine.obtainMessage(2012));
                }
            };
            this.countDownTimer = countDownTimer;
            countDownTimer.start();
        }
    }

    public void cancelLimitRecordTime() {
        if (getActivity() != null) {
            getActivity().runOnUiThread(new Runnable() { // from class: com.pri.prizeinterphone.fragment.InterPhoneTalkBackFragment$$ExternalSyntheticLambda0
                @Override // java.lang.Runnable
                public final void run() {
                    InterPhoneTalkBackFragment.this.lambda$cancelLimitRecordTime$3();
                }
            });
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public /* synthetic */ void lambda$cancelLimitRecordTime$3() {
        CountDownTimer countDownTimer = this.countDownTimer;
        if (countDownTimer != null) {
            countDownTimer.cancel();
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
