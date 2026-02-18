package com.pri.prizeinterphone.activity;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import com.pri.prizeinterphone.PrizeInterPhoneApp;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.Util.Clog;
import com.pri.prizeinterphone.activity.FragmentLocalSettingsActivity;
import com.pri.prizeinterphone.constant.Constants;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.BaseMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.serial.data.ChannelData;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import java.util.ArrayList;
/* loaded from: classes4.dex */
public class FragmentLocalSettingsActivity extends AppCompatActivity implements View.OnClickListener, DialogInterface.OnClickListener {
    private static final String TAG = "FragmentLocalSettingsActivity";
    private int[] arrayLimitSendTimeValues;
    private int[] arrayMicGainValues;
    private int currentLimitSendTime;
    private int currentMicGain;
    private boolean mCurrentBusyNoSend;
    private int mCurrentCheckItem;
    private boolean mCurrentEndTone;
    private boolean mCurrentRecord;
    private boolean mCurrentStartTone;
    private Dialog mDeviceIdDialog;
    private EditText mDeviceIdDialogEdit;
    private Dialog mLimitSendTimeDialog;
    private ArrayList<String> mLimitSendTimeList;
    private LimitSendTimeListAdapter mLimitSendTimeListAdapter;
    private ListView mLimitSendTimeListView;
    private int mMicCurrentCheckItem;
    private Dialog mMicGainDialog;
    private ArrayList<String> mMicGainList;
    private MicGainListAdapter mMicGainListAdapter;
    private ListView mMicGainListView;
    private View mMicGanValue;
    private View mRelDeviceId;
    private View mRelLimitSendTime;
    private RelativeLayout mReviveWalkietalkie;
    private Switch mSwitchBusyNoSend;
    private Switch mSwitchEndTone;
    private Switch mSwitchRecord;
    private Switch mSwitchStartTone;
    private TextView mTVMicGanValue;
    private Toast mToast;
    private TextView mTvDeviceId;
    private TextView mTvLimitSendTime;
    private DmrManager.MessageListener messageListener = new AnonymousClass1();
    private RelativeLayout mkillWalkieTalkie;

    @Override // android.content.DialogInterface.OnClickListener
    public void onClick(DialogInterface dialogInterface, int i) {
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, androidx.activity.ComponentActivity, androidx.core.app.ComponentActivity, android.app.Activity
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView(R.layout.fragment_local_settings_activity);
        initView();
        initData();
    }

    @Override // androidx.activity.ComponentActivity, android.app.Activity
    public void onBackPressed() {
        super.onBackPressed();
    }

    @SuppressLint({"WrongViewCast"})
    private void initView() {
        ChannelData channelData;
        View findViewById = findViewById(R.id.local_setting_device_id);
        this.mRelDeviceId = findViewById;
        findViewById.setOnClickListener(this);
        this.mTvDeviceId = (TextView) findViewById(R.id.local_setting_device_id_value);
        this.mTvDeviceId.setText(PersonSharePrefData.getIntData(this, "pref_person_device_id", 1) + "");
        View findViewById2 = findViewById(R.id.local_setting_limit_send_time);
        this.mRelLimitSendTime = findViewById2;
        findViewById2.setOnClickListener(this);
        this.mTvLimitSendTime = (TextView) findViewById(R.id.local_setting_limit_send_time_value);
        this.currentLimitSendTime = PersonSharePrefData.getIntData(this, "pref_person_limit_send_time", 30);
        Switch r0 = (Switch) findViewById(R.id.local_setting_ptt_start_tone_switch);
        this.mSwitchStartTone = r0;
        r0.setOnClickListener(this);
        Switch r02 = (Switch) findViewById(R.id.local_setting_ptt_end_tone_switch);
        this.mSwitchEndTone = r02;
        r02.setOnClickListener(this);
        Switch r03 = (Switch) findViewById(R.id.local_setting_ptt_record_switch);
        this.mSwitchRecord = r03;
        r03.setOnClickListener(this);
        Switch r04 = (Switch) findViewById(R.id.local_setting_busy_no_sending_switch);
        this.mSwitchBusyNoSend = r04;
        r04.setOnClickListener(this);
        View findViewById3 = findViewById(R.id.local_setting_channel_mic_gain);
        this.mMicGanValue = findViewById3;
        findViewById3.setOnClickListener(this);
        this.mTVMicGanValue = (TextView) findViewById(R.id.fragment_local_setting_mic_gain_value);
        this.currentMicGain = PersonSharePrefData.getIntData(this, PersonSharePrefData.PREF_PERSON_MiC_GAN_VALUE, 0);
        this.mkillWalkieTalkie = (RelativeLayout) findViewById(R.id.local_setting_kill_other_device);
        this.mReviveWalkietalkie = (RelativeLayout) findViewById(R.id.local_setting_revive_other_device);
        this.mkillWalkieTalkie.setOnClickListener(this);
        this.mReviveWalkietalkie.setOnClickListener(this);
        ArrayList<ChannelData> allChannels = DmrManager.getInstance().getInitChannelDataDB().getCurrentDb(Constants.getSelectedChannelArea(this)).getAllChannels();
        int i = 0;
        while (true) {
            if (i >= allChannels.size()) {
                channelData = null;
                break;
            } else if (allChannels.get(i).active == 1) {
                channelData = allChannels.get(i);
                break;
            } else {
                i++;
            }
        }
        if (channelData != null && channelData.type == 1) {
            this.mkillWalkieTalkie.setVisibility(8);
            this.mReviveWalkietalkie.setVisibility(8);
        }
        if (channelData != null && channelData.type == 0 && channelData.interrupt == 3) {
            this.mSwitchBusyNoSend.setEnabled(false);
            findViewById(R.id.tv_busy_no_send_descr).setVisibility(0);
        }
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, android.app.Activity
    public void onResume() {
        super.onResume();
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, android.app.Activity
    public void onPause() {
        super.onPause();
        DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_ENHANCE_FUNCTION_CMD), this.messageListener);
    }

    private void initData() {
        String[] stringArray = getResources().getStringArray(R.array.local_settings_limit_send_time);
        this.arrayLimitSendTimeValues = getResources().getIntArray(R.array.local_settings_limit_send_time_value);
        int i = 0;
        this.mCurrentCheckItem = 0;
        this.mLimitSendTimeList = new ArrayList<>();
        int i2 = 0;
        while (true) {
            int[] iArr = this.arrayLimitSendTimeValues;
            if (i2 >= iArr.length) {
                break;
            }
            if (iArr[i2] == this.currentLimitSendTime) {
                this.mCurrentCheckItem = i2;
            }
            this.mLimitSendTimeList.add(stringArray[i2]);
            i2++;
        }
        boolean booleanData = PersonSharePrefData.getBooleanData(this, "pref_person_ptt_start_tone", true);
        this.mCurrentStartTone = booleanData;
        this.mSwitchStartTone.setChecked(booleanData);
        boolean booleanData2 = PersonSharePrefData.getBooleanData(this, "pref_person_ptt_end_tone", true);
        this.mCurrentEndTone = booleanData2;
        this.mSwitchEndTone.setChecked(booleanData2);
        boolean booleanData3 = PersonSharePrefData.getBooleanData(this, "pref_person_ptt_record", false);
        this.mCurrentRecord = booleanData3;
        this.mSwitchRecord.setChecked(booleanData3);
        boolean booleanData4 = PersonSharePrefData.getBooleanData(this, "pref_person_busy_no_send", true);
        this.mCurrentBusyNoSend = booleanData4;
        this.mSwitchBusyNoSend.setChecked(booleanData4);
        this.mTvLimitSendTime.setText(this.mLimitSendTimeList.get(this.mCurrentCheckItem));
        String[] stringArray2 = getResources().getStringArray(R.array.local_settings_mic_gain);
        this.arrayMicGainValues = getResources().getIntArray(R.array.local_settings_mic_gain_value);
        this.mMicGainList = new ArrayList<>();
        while (true) {
            int[] iArr2 = this.arrayMicGainValues;
            if (i < iArr2.length) {
                if (iArr2[i] == this.currentMicGain) {
                    this.mMicCurrentCheckItem = i;
                }
                this.mMicGainList.add(stringArray2[i]);
                i++;
            } else {
                this.mTVMicGanValue.setText(this.mMicGainList.get(this.mMicCurrentCheckItem));
                return;
            }
        }
    }

    private void updateSwitchData(String str, boolean z) {
        PersonSharePrefData.putBooleanData(this, str, z);
    }

    /* JADX WARN: Can't fix incorrect switch cases order, some code will duplicate */
    @Override // android.view.View.OnClickListener
    public void onClick(View view) {
        if (R.id.back_button == view.getId()) {
            onBackPressed();
        } else if (isTalkSend()) {
            switch (view.getId()) {
                case R.id.local_device_id_cancle /* 2131296636 */:
                    Dialog dialog = this.mDeviceIdDialog;
                    if (dialog != null) {
                        dialog.dismiss();
                        return;
                    }
                    return;
                case R.id.local_setting_busy_no_sending_switch /* 2131296660 */:
                    this.mSwitchBusyNoSend.setChecked(this.mCurrentBusyNoSend);
                    break;
                case R.id.local_setting_ptt_end_tone_switch /* 2131296668 */:
                    this.mSwitchEndTone.setChecked(this.mCurrentEndTone);
                    break;
                case R.id.local_setting_ptt_record_switch /* 2131296670 */:
                    this.mSwitchRecord.setChecked(this.mCurrentRecord);
                    break;
                case R.id.local_setting_ptt_start_tone_switch /* 2131296672 */:
                    this.mSwitchStartTone.setChecked(this.mCurrentStartTone);
                    break;
            }
            showToast(R.string.interphone_talk_send_status_toast);
        } else {
            switch (view.getId()) {
                case R.id.bt_local_device_kill_revive_cancel /* 2131296347 */:
                    Dialog dialog2 = this.mDeviceIdDialog;
                    if (dialog2 != null) {
                        dialog2.dismiss();
                        return;
                    }
                    return;
                case R.id.bt_local_device_kill_revive_ok /* 2131296348 */:
                    EditText editText = this.mDeviceIdDialogEdit;
                    if (editText != null) {
                        String obj = editText.getText().toString();
                        if (obj.isEmpty()) {
                            showToast(R.string.fragment_local_setting_device_id_dialog_edit_toast);
                            return;
                        }
                        int intValue = Integer.valueOf(obj).intValue();
                        if (intValue < 1 || intValue > 16776415) {
                            showToast(R.string.fragment_local_setting_device_id_person_number_edit_limit_toast);
                            return;
                        }
                        DmrManager.getInstance().registerEventListener(Const.Command.SET_ENHANCE_FUNCTION_CMD, this.messageListener);
                        boolean booleanValue = ((Boolean) view.getTag()).booleanValue();
                        Clog.d(TAG, "isKill=" + booleanValue);
                        DmrManager.getInstance().enhanceFunction(booleanValue ? (byte) 4 : (byte) 5, intValue);
                    }
                    Dialog dialog3 = this.mDeviceIdDialog;
                    if (dialog3 != null) {
                        dialog3.dismiss();
                        return;
                    }
                    return;
                case R.id.local_device_id_cancle /* 2131296636 */:
                    break;
                case R.id.local_device_id_ok /* 2131296638 */:
                    EditText editText2 = this.mDeviceIdDialogEdit;
                    if (editText2 != null) {
                        String obj2 = editText2.getText().toString();
                        if (obj2.isEmpty()) {
                            showToast(R.string.fragment_local_setting_device_id_dialog_edit_toast);
                            return;
                        } else if (!obj2.matches("[0-9]+")) {
                            showToast(R.string.fragment_local_setting_device_id_illegal_char_toast);
                            return;
                        } else {
                            int intValue2 = Integer.valueOf(obj2).intValue();
                            if (intValue2 < 1 || intValue2 > 16776415) {
                                showToast(R.string.fragment_local_setting_device_id_person_number_edit_limit_toast);
                                return;
                            } else {
                                updateDeviceIdView(obj2);
                                DmrManager.getInstance().setLocalId(Integer.parseInt(obj2));
                            }
                        }
                    }
                    Dialog dialog4 = this.mDeviceIdDialog;
                    if (dialog4 != null) {
                        dialog4.dismiss();
                        return;
                    }
                    return;
                case R.id.local_setting_busy_no_sending_switch /* 2131296660 */:
                    if (PersonSharePrefData.getIntData(this, PersonSharePrefData.PREF_PERSON_INTERRUPT_TRANSMISSION, 1) != 3) {
                        boolean z = !this.mCurrentBusyNoSend;
                        this.mCurrentBusyNoSend = z;
                        this.mSwitchBusyNoSend.setChecked(z);
                        updateSwitchData("pref_person_busy_no_send", this.mCurrentBusyNoSend);
                        return;
                    }
                    this.mSwitchBusyNoSend.setChecked(false);
                    updateSwitchData("pref_person_busy_no_send", false);
                    return;
                case R.id.local_setting_channel_mic_gain /* 2131296661 */:
                    showMicGainValueDialog();
                    break;
                case R.id.local_setting_device_id /* 2131296662 */:
                    showDeviceIdeDialog();
                    return;
                case R.id.local_setting_kill_other_device /* 2131296664 */:
                    showKillOrReviveWalkieTalkies(true);
                    return;
                case R.id.local_setting_limit_send_time /* 2131296665 */:
                    showLimitSendTimeDialog();
                    return;
                case R.id.local_setting_ptt_end_tone_switch /* 2131296668 */:
                    boolean z2 = !this.mCurrentEndTone;
                    this.mCurrentEndTone = z2;
                    this.mSwitchEndTone.setChecked(z2);
                    updateSwitchData("pref_person_ptt_end_tone", this.mCurrentEndTone);
                    return;
                case R.id.local_setting_ptt_record_switch /* 2131296670 */:
                    boolean z3 = !this.mCurrentRecord;
                    this.mCurrentRecord = z3;
                    this.mSwitchRecord.setChecked(z3);
                    updateSwitchData("pref_person_ptt_record", this.mCurrentRecord);
                    return;
                case R.id.local_setting_ptt_start_tone_switch /* 2131296672 */:
                    boolean z4 = !this.mCurrentStartTone;
                    this.mCurrentStartTone = z4;
                    this.mSwitchStartTone.setChecked(z4);
                    updateSwitchData("pref_person_ptt_start_tone", this.mCurrentStartTone);
                    return;
                case R.id.local_setting_revive_other_device /* 2131296673 */:
                    showKillOrReviveWalkieTalkies(false);
                    return;
                default:
                    return;
            }
            Dialog dialog5 = this.mDeviceIdDialog;
            if (dialog5 != null) {
                dialog5.dismiss();
            }
        }
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    /* renamed from: com.pri.prizeinterphone.activity.FragmentLocalSettingsActivity$1  reason: invalid class name */
    /* loaded from: classes4.dex */
    public class AnonymousClass1 implements DmrManager.MessageListener {
        AnonymousClass1() {
        }

        @Override // com.pri.prizeinterphone.manager.DmrManager.MessageListener
        public void dealEvent(final BaseMessage baseMessage) {
            if (baseMessage.packet.cmd == 40) {
                FragmentLocalSettingsActivity.this.runOnUiThread(new Runnable() { // from class: com.pri.prizeinterphone.activity.FragmentLocalSettingsActivity$1$$ExternalSyntheticLambda0
                    @Override // java.lang.Runnable
                    public final void run() {
                        FragmentLocalSettingsActivity.AnonymousClass1.this.lambda$dealEvent$0(baseMessage);
                    }
                });
            }
        }

        /* JADX INFO: Access modifiers changed from: private */
        public /* synthetic */ void lambda$dealEvent$0(BaseMessage baseMessage) {
            Clog.d(FragmentLocalSettingsActivity.TAG, "baseMessage.packet.rw=" + ((int) baseMessage.packet.rw) + ",baseMessage.packet.sr=" + ((int) baseMessage.packet.sr));
            Packet packet = baseMessage.packet;
            if (packet.rw == 0) {
                if (packet.sr == 0) {
                    FragmentLocalSettingsActivity.this.showToast(R.string.interphone_set_succ);
                } else {
                    FragmentLocalSettingsActivity.this.showToast(R.string.interphone_set_failed);
                }
            }
        }
    }

    private void showDeviceIdeDialog() {
        View inflate = LayoutInflater.from(this).inflate(R.layout.local_device_id_dialog, (ViewGroup) null);
        Dialog dialog = new Dialog(this);
        this.mDeviceIdDialog = dialog;
        dialog.setContentView(inflate);
        int i = getResources().getDisplayMetrics().widthPixels;
        Window window = this.mDeviceIdDialog.getWindow();
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.gravity = 80;
        attributes.y = 60;
        attributes.width = (int) (i * 0.9f);
        window.setAttributes(attributes);
        window.setBackgroundDrawableResource(17170445);
        this.mDeviceIdDialog.show();
        this.mDeviceIdDialogEdit = (EditText) inflate.findViewById(R.id.local_device_id_edit);
        this.mDeviceIdDialogEdit.setText(PersonSharePrefData.getIntData(this, "pref_person_device_id", 1) + "");
        ((Button) inflate.findViewById(R.id.local_device_id_cancle)).setOnClickListener(this);
        ((Button) inflate.findViewById(R.id.local_device_id_ok)).setOnClickListener(this);
    }

    @Override // androidx.appcompat.app.AppCompatActivity, androidx.fragment.app.FragmentActivity, android.app.Activity, android.content.ComponentCallbacks
    public void onConfigurationChanged(@NonNull Configuration configuration) {
        super.onConfigurationChanged(configuration);
        Dialog dialog = this.mDeviceIdDialog;
        if (dialog != null && dialog.isShowing()) {
            this.mDeviceIdDialog.dismiss();
            this.mDeviceIdDialog = null;
        }
        Dialog dialog2 = this.mLimitSendTimeDialog;
        if (dialog2 != null && dialog2.isShowing()) {
            this.mLimitSendTimeDialog.dismiss();
            this.mLimitSendTimeDialog = null;
        }
        Dialog dialog3 = this.mMicGainDialog;
        if (dialog3 == null || !dialog3.isShowing()) {
            return;
        }
        this.mMicGainDialog.dismiss();
        this.mMicGainDialog = null;
    }

    private void showKillOrReviveWalkieTalkies(boolean z) {
        View inflate = LayoutInflater.from(this).inflate(R.layout.local_device_kill_revive_walkie_talkies, (ViewGroup) null);
        Dialog dialog = new Dialog(this);
        this.mDeviceIdDialog = dialog;
        dialog.setContentView(inflate);
        int i = getResources().getDisplayMetrics().widthPixels;
        Window window = this.mDeviceIdDialog.getWindow();
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.gravity = 80;
        attributes.y = 60;
        attributes.width = (int) (i * 0.9f);
        window.setAttributes(attributes);
        window.setBackgroundDrawableResource(17170445);
        this.mDeviceIdDialog.show();
        EditText editText = (EditText) inflate.findViewById(R.id.local_device_id_edit);
        this.mDeviceIdDialogEdit = editText;
        editText.setInputType(2);
        Button button = (Button) inflate.findViewById(R.id.bt_local_device_kill_revive_cancel);
        button.setOnClickListener(this);
        button.setTag(Boolean.valueOf(z));
        Button button2 = (Button) inflate.findViewById(R.id.bt_local_device_kill_revive_ok);
        button2.setTag(Boolean.valueOf(z));
        button2.setOnClickListener(this);
        ((TextView) inflate.findViewById(R.id.title)).setText(z ? R.string.interphone_kill : R.string.interphone_revive);
    }

    private void updateDeviceIdView(String str) {
        this.mTvDeviceId.setText(str);
        PersonSharePrefData.putIntData(this, "pref_person_device_id", Integer.parseInt(str));
    }

    private void showLimitSendTimeDialog() {
        View inflate = LayoutInflater.from(this).inflate(R.layout.local_limit_send_time_dialog, (ViewGroup) null);
        Dialog dialog = new Dialog(this);
        this.mLimitSendTimeDialog = dialog;
        dialog.setContentView(inflate);
        int i = getResources().getDisplayMetrics().widthPixels;
        Window window = this.mLimitSendTimeDialog.getWindow();
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.gravity = 80;
        attributes.y = 60;
        attributes.width = (int) (i * 0.9f);
        window.setAttributes(attributes);
        window.setBackgroundDrawableResource(17170445);
        this.mLimitSendTimeDialog.show();
        this.mLimitSendTimeListView = (ListView) inflate.findViewById(R.id.local_limit_send_time_list);
        LimitSendTimeListAdapter limitSendTimeListAdapter = new LimitSendTimeListAdapter(this);
        this.mLimitSendTimeListAdapter = limitSendTimeListAdapter;
        this.mLimitSendTimeListView.setAdapter((ListAdapter) limitSendTimeListAdapter);
        this.mLimitSendTimeListView.setDivider(null);
        this.mLimitSendTimeListView.setOnItemClickListener(new AdapterView.OnItemClickListener() { // from class: com.pri.prizeinterphone.activity.FragmentLocalSettingsActivity.2
            @Override // android.widget.AdapterView.OnItemClickListener
            public void onItemClick(AdapterView<?> adapterView, View view, int i2, long j) {
                if (FragmentLocalSettingsActivity.this.isTalkSend()) {
                    FragmentLocalSettingsActivity.this.showToast(R.string.interphone_talk_send_status_toast);
                } else {
                    FragmentLocalSettingsActivity fragmentLocalSettingsActivity = FragmentLocalSettingsActivity.this;
                    fragmentLocalSettingsActivity.updateLimitSendTimeView((String) fragmentLocalSettingsActivity.mLimitSendTimeList.get(i2));
                    PersonSharePrefData.putIntData(PrizeInterPhoneApp.getContext(), "pref_person_limit_send_time", FragmentLocalSettingsActivity.this.arrayLimitSendTimeValues[i2]);
                    FragmentLocalSettingsActivity.this.mCurrentCheckItem = i2;
                }
                if (FragmentLocalSettingsActivity.this.mLimitSendTimeDialog != null) {
                    FragmentLocalSettingsActivity.this.mLimitSendTimeDialog.dismiss();
                }
            }
        });
    }

    private void showMicGainValueDialog() {
        View inflate = LayoutInflater.from(this).inflate(R.layout.local_mic_gain_value_dialog, (ViewGroup) null);
        Dialog dialog = new Dialog(this);
        this.mMicGainDialog = dialog;
        dialog.setContentView(inflate);
        int i = getResources().getDisplayMetrics().widthPixels;
        Window window = this.mMicGainDialog.getWindow();
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.gravity = 80;
        attributes.y = 60;
        attributes.width = (int) (i * 0.9f);
        window.setAttributes(attributes);
        window.setBackgroundDrawableResource(17170445);
        this.mMicGainDialog.show();
        this.mMicGainListView = (ListView) inflate.findViewById(R.id.local_mic_gain_value_list);
        MicGainListAdapter micGainListAdapter = new MicGainListAdapter(this);
        this.mMicGainListAdapter = micGainListAdapter;
        this.mMicGainListView.setAdapter((ListAdapter) micGainListAdapter);
        this.mMicGainListView.setDivider(null);
        this.mMicGainListView.setOnItemClickListener(new AdapterView.OnItemClickListener() { // from class: com.pri.prizeinterphone.activity.FragmentLocalSettingsActivity.3
            @Override // android.widget.AdapterView.OnItemClickListener
            public void onItemClick(AdapterView<?> adapterView, View view, int i2, long j) {
                if (FragmentLocalSettingsActivity.this.isTalkSend()) {
                    FragmentLocalSettingsActivity.this.showToast(R.string.interphone_talk_send_status_toast);
                } else {
                    FragmentLocalSettingsActivity fragmentLocalSettingsActivity = FragmentLocalSettingsActivity.this;
                    fragmentLocalSettingsActivity.updatemicGainView((String) fragmentLocalSettingsActivity.mMicGainList.get(i2));
                    PersonSharePrefData.putIntData(PrizeInterPhoneApp.getContext(), PersonSharePrefData.PREF_PERSON_MiC_GAN_VALUE, FragmentLocalSettingsActivity.this.arrayMicGainValues[i2]);
                    FragmentLocalSettingsActivity.this.mMicCurrentCheckItem = i2;
                    DmrManager.getInstance().sendSetMicGainCmdToMdl();
                }
                if (FragmentLocalSettingsActivity.this.mMicGainDialog != null) {
                    FragmentLocalSettingsActivity.this.mMicGainDialog.dismiss();
                }
            }
        });
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void updateLimitSendTimeView(String str) {
        LimitSendTimeListAdapter limitSendTimeListAdapter = this.mLimitSendTimeListAdapter;
        if (limitSendTimeListAdapter != null) {
            limitSendTimeListAdapter.notifyDataSetChanged();
        }
        this.mTvLimitSendTime.setText(str);
    }

    /* JADX INFO: Access modifiers changed from: private */
    /* loaded from: classes4.dex */
    public class LimitSendTimeListAdapter extends BaseAdapter {
        private Context mContext;

        @Override // android.widget.Adapter
        public Object getItem(int i) {
            return null;
        }

        @Override // android.widget.Adapter
        public long getItemId(int i) {
            return 0L;
        }

        public LimitSendTimeListAdapter(Context context) {
            this.mContext = context;
        }

        @Override // android.widget.Adapter
        public int getCount() {
            return FragmentLocalSettingsActivity.this.mLimitSendTimeList.size();
        }

        @Override // android.widget.Adapter
        public View getView(int i, View view, ViewGroup viewGroup) {
            View view2;
            ViewHolder viewHolder;
            if (view == null) {
                viewHolder = new ViewHolder();
                view2 = LayoutInflater.from(this.mContext).inflate(R.layout.local_limit_send_time_dialog_list_item, (ViewGroup) null);
                viewHolder.mTvTile = (TextView) view2.findViewById(R.id.limit_send_time_title);
                viewHolder.mSeleted = (ImageView) view2.findViewById(R.id.limit_send_time_seleted);
                viewHolder.mLine = view2.findViewById(R.id.limit_send_time_line);
                view2.setTag(viewHolder);
            } else {
                view2 = view;
                viewHolder = (ViewHolder) view.getTag();
            }
            Log.e(FragmentLocalSettingsActivity.TAG, "getView  position = " + i);
            Log.e(FragmentLocalSettingsActivity.TAG, "getView  mDataList = " + FragmentLocalSettingsActivity.this.mLimitSendTimeList.size());
            viewHolder.mTvTile.setText((CharSequence) FragmentLocalSettingsActivity.this.mLimitSendTimeList.get(i));
            if (FragmentLocalSettingsActivity.this.mCurrentCheckItem == i) {
                viewHolder.mSeleted.setSelected(true);
            } else {
                viewHolder.mSeleted.setSelected(false);
            }
            if (FragmentLocalSettingsActivity.this.mLimitSendTimeList.size() - 1 == i) {
                viewHolder.mLine.setVisibility(8);
            } else {
                viewHolder.mLine.setVisibility(0);
            }
            return view2;
        }

        /* loaded from: classes4.dex */
        class ViewHolder {
            private View mLine;
            private ImageView mSeleted;
            private TextView mTvTile;

            ViewHolder() {
            }
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void updatemicGainView(String str) {
        MicGainListAdapter micGainListAdapter = this.mMicGainListAdapter;
        if (micGainListAdapter != null) {
            micGainListAdapter.notifyDataSetChanged();
        }
        this.mTVMicGanValue.setText(str);
    }

    /* JADX INFO: Access modifiers changed from: private */
    /* loaded from: classes4.dex */
    public class MicGainListAdapter extends BaseAdapter {
        private Context mContext;

        @Override // android.widget.Adapter
        public Object getItem(int i) {
            return null;
        }

        @Override // android.widget.Adapter
        public long getItemId(int i) {
            return 0L;
        }

        public MicGainListAdapter(Context context) {
            this.mContext = context;
        }

        @Override // android.widget.Adapter
        public int getCount() {
            return FragmentLocalSettingsActivity.this.mMicGainList.size();
        }

        @Override // android.widget.Adapter
        public View getView(int i, View view, ViewGroup viewGroup) {
            View view2;
            ViewHolder viewHolder;
            if (view == null) {
                viewHolder = new ViewHolder();
                view2 = LayoutInflater.from(this.mContext).inflate(R.layout.local_limit_send_time_dialog_list_item, (ViewGroup) null);
                viewHolder.mMicTvTile = (TextView) view2.findViewById(R.id.limit_send_time_title);
                viewHolder.mMicSeleted = (ImageView) view2.findViewById(R.id.limit_send_time_seleted);
                viewHolder.mMicLine = view2.findViewById(R.id.limit_send_time_line);
                view2.setTag(viewHolder);
            } else {
                view2 = view;
                viewHolder = (ViewHolder) view.getTag();
            }
            Log.e(FragmentLocalSettingsActivity.TAG, "getView  position = " + i);
            Log.e(FragmentLocalSettingsActivity.TAG, "getView  mDataList = " + FragmentLocalSettingsActivity.this.mMicGainList.size());
            viewHolder.mMicTvTile.setText((CharSequence) FragmentLocalSettingsActivity.this.mMicGainList.get(i));
            if (FragmentLocalSettingsActivity.this.mMicCurrentCheckItem == i) {
                viewHolder.mMicSeleted.setSelected(true);
            } else {
                viewHolder.mMicSeleted.setSelected(false);
            }
            if (FragmentLocalSettingsActivity.this.mMicGainList.size() - 1 == i) {
                viewHolder.mMicLine.setVisibility(8);
            } else {
                viewHolder.mMicLine.setVisibility(0);
            }
            return view2;
        }

        /* loaded from: classes4.dex */
        class ViewHolder {
            private View mMicLine;
            private ImageView mMicSeleted;
            private TextView mMicTvTile;

            ViewHolder() {
            }
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void showToast(int i) {
        Toast toast = this.mToast;
        if (toast != null) {
            toast.cancel();
        }
        Toast makeText = Toast.makeText(this, i, 0);
        this.mToast = makeText;
        makeText.show();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public boolean isTalkSend() {
        return PersonSharePrefData.getIntData(this, PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1;
    }
}
