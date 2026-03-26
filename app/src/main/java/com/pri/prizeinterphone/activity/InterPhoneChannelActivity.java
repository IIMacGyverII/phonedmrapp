package com.pri.prizeinterphone.activity;

import android.app.ProgressDialog;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.text.TextUtils;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageButton;
import android.widget.ListAdapter;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import com.google.android.material.snackbar.Snackbar;
import com.mediatek.boostfwk.identify.launch.LaunchConfig;
import com.pri.prizeinterphone.PrizeInterPhoneApp;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.Util.UtilDensity;
import com.pri.prizeinterphone.constant.Constants;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.BaseMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.serial.data.ChannelData;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import com.pri.prizeinterphone.state.CmdStateMachine;
import com.pri.prizeinterphone.widget.SpinerPopWindow;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
/* loaded from: classes4.dex */
public class InterPhoneChannelActivity extends AppCompatActivity implements View.OnClickListener, View.OnTouchListener, SpinerPopWindow.PrizeOnItemClickListener {
    private static final LinkedHashMap<Integer, Integer> LIN_RES_ID;
    private static final String TAG = "InterPhoneChannelActivity";
    private ImageButton btnCancel;
    private ImageButton btnSave;
    private GroupGridAdapter gridAdapter;
    private GridView groupGridview;
    private boolean isEdit;
    private String mCurrentChannelBand;
    private String mCurrentChannelCallName;
    private String mCurrentChannelColor;
    private String mCurrentChannelContactType;
    private String mCurrentChannelEncryption;
    private String mCurrentChannelEncryptionkey;
    private String mCurrentChannelFrqBand;
    private String mCurrentChannelId;
    private String mCurrentChannelInputMode;
    private String mCurrentChannelInterruptTransmission;
    private String mCurrentChannelPower;
    private String mCurrentChannelRelayDisconnet;
    private String mCurrentChannelRxSub;
    private String mCurrentChannelRxtype;
    private String mCurrentChannelSlot;
    private String mCurrentChannelSq;
    private String mCurrentChannelTxSub;
    private String mCurrentChannelTxtype;
    private String mCurrentChannelType;
    private int mCurrentFrequency;
    private float mCurrentTouchX;
    private float mCurrentTouchY;
    private int mCurrentViewId;
    private ArrayList<String> mDataChannelBand;
    private ArrayList<String> mDataChannelCallName;
    private ArrayList<String> mDataChannelColor;
    private ArrayList<String> mDataChannelContactType;
    private ArrayList<String> mDataChannelEncryption;
    private ArrayList<String> mDataChannelFrqBand;
    private ArrayList<String> mDataChannelId;
    private ArrayList<String> mDataChannelInputMode;
    private ArrayList<String> mDataChannelInterruptTransmission;
    private ArrayList<String> mDataChannelPower;
    private ArrayList<String> mDataChannelRelayDisconnet;
    private ArrayList<String> mDataChannelRxSubBDcs;
    private ArrayList<String> mDataChannelRxSubCtc;
    private ArrayList<String> mDataChannelRxSubFDcs;
    private ArrayList<String> mDataChannelRxtype;
    private ArrayList<String> mDataChannelSlot;
    private ArrayList<String> mDataChannelSq;
    private ArrayList<String> mDataChannelTxSubBDcs;
    private ArrayList<String> mDataChannelTxSubCtc;
    private ArrayList<String> mDataChannelTxSubFDcs;
    private ArrayList<String> mDataChannelTxtype;
    private ArrayList<String> mDataChannelType;
    private EditText mEditChannelName;
    private EditText mEditFrequncyRecieve;
    private EditText mEditFrequncySend;
    private SpinerPopWindow mPopWindow;
    private ProgressDialog mProgressDialog;
    private Toast mToast;
    private TextView mTvChannelBand;
    private EditText mTvChannelCallNumber;
    private TextView mTvChannelColor;
    private TextView mTvChannelContactType;
    private TextView mTvChannelEncryption;
    private EditText mTvChannelEncryptionKey;
    private TextView mTvChannelFrqBand;
    private TextView mTvChannelInputMode;
    private TextView mTvChannelInterruptTransmission;
    private TextView mTvChannelPower;
    private TextView mTvChannelRelayDisconnet;
    private TextView mTvChannelRxSub;
    private TextView mTvChannelRxtype;
    private TextView mTvChannelSlot;
    private TextView mTvChannelSq;
    private TextView mTvChannelTxSub;
    private TextView mTvChannelTxtype;
    private TextView mTvChannelType;
    private DmrManager.MessageListener messageListener;
    private View rootView;
    private TextView tvTitle;
    private ChannelData channelData = null;
    private List<Integer> groupNumbers = new ArrayList(32);
    private String currentAreaId = Constants.KEY_DEF_AREA;
    public Handler mHandler = new Handler();
    public Runnable mDismissRunnable = new Runnable() { // from class: com.pri.prizeinterphone.activity.InterPhoneChannelActivity.6
        @Override // java.lang.Runnable
        public void run() {
            InterPhoneChannelActivity.this.dismissProgressDialog();
        }
    };
    public Runnable mDismissRunnableAndroidFinish = new Runnable() { // from class: com.pri.prizeinterphone.activity.InterPhoneChannelActivity.7
        @Override // java.lang.Runnable
        public void run() {
            InterPhoneChannelActivity.this.dismissProgressDialog();
            InterPhoneChannelActivity.this.finish();
        }
    };

    @Override // android.view.View.OnTouchListener
    public boolean onTouch(View view, MotionEvent motionEvent) {
        return false;
    }

    static {
        LinkedHashMap<Integer, Integer> linkedHashMap = new LinkedHashMap<>();
        LIN_RES_ID = linkedHashMap;
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_name_edit), Integer.valueOf((int) R.id.interphone_channel_name));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_type_set), Integer.valueOf((int) R.id.interphone_channel_type));
        Integer valueOf = Integer.valueOf((int) R.id.interphone_channel_frequency_band_set);
        Integer valueOf2 = Integer.valueOf((int) R.id.interphone_channel_frequency);
        linkedHashMap.put(valueOf, valueOf2);
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_frequency_send_edit), valueOf2);
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_frequency_recieve_edit), valueOf2);
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_band_set), Integer.valueOf((int) R.id.interphone_channel_band));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_power_set), Integer.valueOf((int) R.id.interphone_channel_power));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_color_set), Integer.valueOf((int) R.id.interphone_channel_color));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_mode_set), Integer.valueOf((int) R.id.interphone_channel_mode_type));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_slot_set), Integer.valueOf((int) R.id.interphone_channel_slot_type));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_contact_type_set), Integer.valueOf((int) R.id.interphone_channel_contact_type));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_call_name_set), Integer.valueOf((int) R.id.interphone_channel_call_name));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_encryption_set), Integer.valueOf((int) R.id.interphone_channel_encryption));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_relay_disconnecte_set), Integer.valueOf((int) R.id.interphone_channel_relay_disconnecte));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_interrupt_transmission_set), Integer.valueOf((int) R.id.interphone_channel_interrupt_transmission));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_encryption_key_set), Integer.valueOf((int) R.id.interphone_channel_encryption_key));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_group_number_set), Integer.valueOf((int) R.id.interphone_channel_group_list));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_sq_set), Integer.valueOf((int) R.id.interphone_channel_sq));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_txtype_set), Integer.valueOf((int) R.id.interphone_channel_txtype));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_txsubcode_set), Integer.valueOf((int) R.id.interphone_channel_txsubcode));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_rxtype_set), Integer.valueOf((int) R.id.interphone_channel_rxtype));
        linkedHashMap.put(Integer.valueOf((int) R.id.interphone_channel_rxsubcode_set), Integer.valueOf((int) R.id.interphone_channel_rxsubcode));
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, androidx.activity.ComponentActivity, androidx.core.app.ComponentActivity, android.app.Activity
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView(R.layout.interphone_channel_activity);
        Log.i(TAG, "onCreate: ");
        initView();
        initData();
    }

    private void initView() {
        this.rootView = findViewById(R.id.root);
        this.btnCancel = (ImageButton) findViewById(R.id.interphone_channel_back_button);
        this.btnSave = (ImageButton) findViewById(R.id.interphone_channel_save);
        this.btnCancel.setOnClickListener(new View.OnClickListener() { // from class: com.pri.prizeinterphone.activity.InterPhoneChannelActivity$$ExternalSyntheticLambda0
            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                InterPhoneChannelActivity.this.onClick(view);
            }
        });
        this.btnSave.setOnClickListener(new View.OnClickListener() { // from class: com.pri.prizeinterphone.activity.InterPhoneChannelActivity$$ExternalSyntheticLambda0
            @Override // android.view.View.OnClickListener
            public final void onClick(View view) {
                InterPhoneChannelActivity.this.onClick(view);
            }
        });
        this.tvTitle = (TextView) findViewById(R.id.interphone_channel_title);
        EditText editText = (EditText) findViewById(R.id.interphone_channel_name_edit);
        this.mEditChannelName = editText;
        editText.setOnFocusChangeListener(new View.OnFocusChangeListener() { // from class: com.pri.prizeinterphone.activity.InterPhoneChannelActivity.1
            @Override // android.view.View.OnFocusChangeListener
            public void onFocusChange(View view, boolean z) {
                if (z) {
                    InterPhoneChannelActivity interPhoneChannelActivity = InterPhoneChannelActivity.this;
                    interPhoneChannelActivity.updateSelectedItem(interPhoneChannelActivity.mEditChannelName.getId());
                }
            }
        });
        EditText editText2 = (EditText) findViewById(R.id.interphone_channel_frequency_send_edit);
        this.mEditFrequncySend = editText2;
        editText2.setOnFocusChangeListener(new View.OnFocusChangeListener() { // from class: com.pri.prizeinterphone.activity.InterPhoneChannelActivity.2
            @Override // android.view.View.OnFocusChangeListener
            public void onFocusChange(View view, boolean z) {
                if (z) {
                    InterPhoneChannelActivity.this.mCurrentFrequency = 0;
                    InterPhoneChannelActivity interPhoneChannelActivity = InterPhoneChannelActivity.this;
                    interPhoneChannelActivity.updateSelectedItem(interPhoneChannelActivity.mEditFrequncySend.getId());
                }
            }
        });
        this.mEditFrequncySend.setInputType(2);
        EditText editText3 = (EditText) findViewById(R.id.interphone_channel_frequency_recieve_edit);
        this.mEditFrequncyRecieve = editText3;
        editText3.setOnFocusChangeListener(new View.OnFocusChangeListener() { // from class: com.pri.prizeinterphone.activity.InterPhoneChannelActivity.3
            @Override // android.view.View.OnFocusChangeListener
            public void onFocusChange(View view, boolean z) {
                if (z) {
                    InterPhoneChannelActivity.this.mCurrentFrequency = 1;
                    InterPhoneChannelActivity interPhoneChannelActivity = InterPhoneChannelActivity.this;
                    interPhoneChannelActivity.updateSelectedItem(interPhoneChannelActivity.mEditFrequncyRecieve.getId());
                }
            }
        });
        this.mEditFrequncyRecieve.setInputType(2);
        if (DmrManager.getInstance().isSupportUVFrequencyBand()) {
            findViewById(R.id.interphone_channel_frequency_band).setVisibility(0);
        }
        this.mTvChannelFrqBand = (TextView) findViewById(R.id.interphone_channel_frequency_band_set);
        this.mTvChannelType = (TextView) findViewById(R.id.interphone_channel_type_set);
        this.mTvChannelPower = (TextView) findViewById(R.id.interphone_channel_power_set);
        this.mTvChannelColor = (TextView) findViewById(R.id.interphone_channel_color_set);
        this.mTvChannelInputMode = (TextView) findViewById(R.id.interphone_channel_mode_set);
        this.mTvChannelSlot = (TextView) findViewById(R.id.interphone_channel_slot_set);
        this.mTvChannelContactType = (TextView) findViewById(R.id.interphone_channel_contact_type_set);
        EditText editText4 = (EditText) findViewById(R.id.interphone_channel_call_name_set);
        this.mTvChannelCallNumber = editText4;
        editText4.setOnFocusChangeListener(new View.OnFocusChangeListener() { // from class: com.pri.prizeinterphone.activity.InterPhoneChannelActivity.4
            @Override // android.view.View.OnFocusChangeListener
            public void onFocusChange(View view, boolean z) {
                if (z) {
                    InterPhoneChannelActivity interPhoneChannelActivity = InterPhoneChannelActivity.this;
                    interPhoneChannelActivity.updateSelectedItem(interPhoneChannelActivity.mTvChannelCallNumber.getId());
                }
            }
        });
        this.mTvChannelCallNumber.setInputType(2);
        this.mTvChannelEncryption = (TextView) findViewById(R.id.interphone_channel_encryption_set);
        EditText editText5 = (EditText) findViewById(R.id.interphone_channel_encryption_key_set);
        this.mTvChannelEncryptionKey = editText5;
        editText5.setOnFocusChangeListener(new View.OnFocusChangeListener() { // from class: com.pri.prizeinterphone.activity.InterPhoneChannelActivity.5
            @Override // android.view.View.OnFocusChangeListener
            public void onFocusChange(View view, boolean z) {
                if (z) {
                    InterPhoneChannelActivity interPhoneChannelActivity = InterPhoneChannelActivity.this;
                    interPhoneChannelActivity.updateSelectedItem(interPhoneChannelActivity.mTvChannelEncryptionKey.getId());
                }
            }
        });
        this.mTvChannelEncryptionKey.setInputType(2);
        SpinerPopWindow spinerPopWindow = new SpinerPopWindow(this);
        this.mPopWindow = spinerPopWindow;
        spinerPopWindow.setPrizeOnItemClickListener(this);
        this.mTvChannelRelayDisconnet = (TextView) findViewById(R.id.interphone_channel_relay_disconnecte_set);
        this.mTvChannelInterruptTransmission = (TextView) findViewById(R.id.interphone_channel_interrupt_transmission_set);
        this.mTvChannelBand = (TextView) findViewById(R.id.interphone_channel_band_set);
        this.mTvChannelSq = (TextView) findViewById(R.id.interphone_channel_sq_set);
        this.mTvChannelRxtype = (TextView) findViewById(R.id.interphone_channel_rxtype_set);
        this.mTvChannelTxtype = (TextView) findViewById(R.id.interphone_channel_txtype_set);
        this.mTvChannelTxSub = (TextView) findViewById(R.id.interphone_channel_txsubcode_set);
        this.mTvChannelRxSub = (TextView) findViewById(R.id.interphone_channel_rxsubcode_set);
        this.groupGridview = (GridView) findViewById(R.id.interphone_channel_group_grid);
    }

    private void initData() {
        String name;
        this.mDataChannelId = strToArray(getResources().getStringArray(R.array.interphone_channel_id_values));
        this.mCurrentChannelId = getString(R.string.interphone_channel_id_default);
        this.mDataChannelType = strToArray(getResources().getStringArray(R.array.interphone_channel_type_values));
        this.mCurrentChannelType = getString(R.string.interphone_channel_type_default);
        this.mDataChannelFrqBand = strToArray(getResources().getStringArray(R.array.interphone_channel_frequency_values));
        this.mCurrentChannelFrqBand = getString(R.string.interphone_channel_frequency_uhf);
        this.mDataChannelPower = strToArray(getResources().getStringArray(R.array.interphone_channel_power_values));
        this.mCurrentChannelPower = getString(R.string.interphone_channel_power_high_value);
        this.mDataChannelColor = strToArray(getResources().getStringArray(R.array.interphone_channel_color_values));
        this.mCurrentChannelColor = getString(R.string.interphone_channel_color_default);
        this.mDataChannelInputMode = strToArray(getResources().getStringArray(R.array.interphone_channel_input_mode_values));
        this.mCurrentChannelInputMode = getString(R.string.interphone_channel_mode_default);
        this.mDataChannelSlot = strToArray(getResources().getStringArray(R.array.interphone_channel_slot_mode_values));
        this.mCurrentChannelSlot = getString(R.string.interphone_channel_double_slot_slot_default);
        this.mDataChannelContactType = strToArray(getResources().getStringArray(R.array.interphone_channel_contact_type_values));
        this.mCurrentChannelContactType = getString(R.string.interphone_channel_contact_type_default);
        this.mDataChannelCallName = strToArray(getResources().getStringArray(R.array.interphone_channel_call_name_values));
        this.mCurrentChannelCallName = getString(R.string.interphone_channel_call_name_default);
        this.mDataChannelEncryption = strToArray(getResources().getStringArray(R.array.interphone_channel_encryption_values));
        this.mCurrentChannelEncryption = getString(R.string.interphone_channel_encryption_default);
        this.mDataChannelRelayDisconnet = strToArray(getResources().getStringArray(R.array.interphone_channel_relay_disconnet));
        this.mCurrentChannelRelayDisconnet = getString(R.string.interphone_channel_relay_disconnecte_default);
        this.mDataChannelInterruptTransmission = strToArray(getResources().getStringArray(R.array.interphone_channel_interrupt_transmission_array));
        this.mCurrentChannelInterruptTransmission = getString(R.string.interphone_channel_interrupt_transmission_default);
        this.mDataChannelBand = strToArray(getResources().getStringArray(R.array.interphone_channel_band_values));
        this.mCurrentChannelBand = getString(R.string.interphone_channel_band_wide);
        this.mDataChannelSq = strToArray(getResources().getStringArray(R.array.interphone_channel_sq_values));
        this.mCurrentChannelSq = getString(R.string.interphone_channel_sq_default);
        this.mDataChannelTxtype = strToArray(getResources().getStringArray(R.array.interphone_channel_txtype_values));
        this.mCurrentChannelTxtype = getString(R.string.interphone_channel_txtype_wave);
        this.mDataChannelRxtype = strToArray(getResources().getStringArray(R.array.interphone_channel_txtype_values));
        this.mCurrentChannelRxtype = getString(R.string.interphone_channel_txtype_wave);
        String[] stringArray = getResources().getStringArray(R.array.interphone_channel_subcode_ctcsss_values);
        String[] stringArray2 = getResources().getStringArray(R.array.interphone_channel_subcode_fdcs_values);
        String[] stringArray3 = getResources().getStringArray(R.array.interphone_channel_subcode_bdcs_values);
        String[] stringArray4 = getResources().getStringArray(R.array.interphone_channel_subcode_ctcsss_values);
        String[] stringArray5 = getResources().getStringArray(R.array.interphone_channel_subcode_fdcs_values);
        String[] stringArray6 = getResources().getStringArray(R.array.interphone_channel_subcode_bdcs_values);
        this.mDataChannelTxSubCtc = strToArray(stringArray);
        this.mDataChannelTxSubFDcs = strToArray(stringArray2);
        this.mDataChannelTxSubBDcs = strToArray(stringArray3);
        this.mDataChannelRxSubCtc = strToArray(stringArray4);
        this.mDataChannelRxSubFDcs = strToArray(stringArray5);
        this.mDataChannelRxSubBDcs = strToArray(stringArray6);
        Intent intent = getIntent();
        this.isEdit = intent.getBooleanExtra("edit", false);
        this.currentAreaId = intent.getStringExtra("currentAreaId");
        Log.d(TAG, "isEdit=" + this.isEdit);
        Log.d(TAG, "currentAreaId=" + this.currentAreaId);
        if (this.isEdit) {
            int intExtra = intent.getIntExtra("channelId", 0);
            Log.d(TAG, "channelIndex=" + intExtra);
            this.channelData = DmrManager.getInstance().getInitChannelDataDB().getCurrentDb(this.currentAreaId).getChannel(intExtra);
            Log.d(TAG, "channelData=" + this.channelData);
            ChannelData channelData = this.channelData;
            if (channelData != null) {
                if (channelData.type == 0) {
                    GroupGridAdapter groupGridAdapter = new GroupGridAdapter(this, this.channelData.groups);
                    this.gridAdapter = groupGridAdapter;
                    this.groupGridview.setAdapter((ListAdapter) groupGridAdapter);
                }
                if (TextUtils.isEmpty(this.channelData.getName())) {
                    if (this.channelData.getType() == 0) {
                        name = PrizeInterPhoneApp.getContext().getString(R.string.interphone_channel_type_digital) + this.channelData.number;
                    } else {
                        name = PrizeInterPhoneApp.getContext().getString(R.string.interphone_channel_type_analog) + this.channelData.number;
                    }
                } else {
                    name = this.channelData.getName();
                }
                this.mEditChannelName.setText(name);
                this.mEditFrequncySend.setText(this.channelData.getTxFreq() + "");
                this.mEditFrequncyRecieve.setText(this.channelData.getRxFreq() + "");
                if (DmrManager.getInstance().isSupportUVFrequencyBand()) {
                    if (this.channelData.getTxFreq() <= 480000000 && this.channelData.getTxFreq() >= 400000000) {
                        this.mTvChannelFrqBand.setText(R.string.interphone_channel_frequency_uhf);
                    } else if (this.channelData.getTxFreq() <= 174000000 && this.channelData.getTxFreq() >= 136000000) {
                        this.mTvChannelFrqBand.setText(R.string.interphone_channel_frequency_vhf);
                    }
                } else if (DmrManager.getInstance().isSupportOnlyUFrequencyBand()) {
                    this.mTvChannelFrqBand.setText(R.string.interphone_channel_frequency_uhf);
                } else if (DmrManager.getInstance().isSupportOnlyVFrequencyBand()) {
                    this.mTvChannelFrqBand.setText(R.string.interphone_channel_frequency_vhf);
                } else {
                    this.mTvChannelFrqBand.setText(R.string.interphone_channel_frequency_uhf);
                }
                this.mCurrentChannelFrqBand = this.mTvChannelFrqBand.getText().toString();
                if (this.channelData.getPower() == 1) {
                    this.mTvChannelPower.setText(R.string.interphone_channel_power_high_value);
                } else {
                    this.mTvChannelPower.setText(R.string.interphone_channel_power_low_value);
                }
                this.mCurrentChannelPower = this.mTvChannelPower.getText().toString();
                if (this.channelData.getRelay() == 2) {
                    this.mTvChannelRelayDisconnet.setText(R.string.interphone_channel_relay_disconnecte_disable_value);
                } else {
                    this.mTvChannelRelayDisconnet.setText(R.string.interphone_channel_relay_disconnecte_enable_value);
                }
                this.mCurrentChannelRelayDisconnet = this.mTvChannelRelayDisconnet.getText().toString();
                if (this.channelData.getInterrupt() == 1) {
                    this.mTvChannelInterruptTransmission.setText(R.string.interphone_channel_interrupt_transmission_on);
                } else if (this.channelData.getInterrupt() == 2) {
                    this.mTvChannelInterruptTransmission.setText(R.string.interphone_channel_interrupt_transmission_off);
                } else if (this.channelData.getInterrupt() == 3) {
                    this.mTvChannelInterruptTransmission.setText(R.string.interphone_channel_interrupt_transmission_transmit);
                }
                this.mCurrentChannelInterruptTransmission = this.mTvChannelInterruptTransmission.getText().toString();
                findViewById(R.id.interphone_channel_type).setVisibility(8);
                if (this.channelData.getType() == 0) {
                    this.mTvChannelType.setText(R.string.interphone_channel_type_default);
                    hideAnalogMenu();
                    this.mTvChannelColor.setText(this.channelData.getCc() + "");
                    this.mCurrentChannelColor = this.channelData.getCc() + "";
                    if (this.channelData.getContactType() == 0) {
                        this.mTvChannelContactType.setText(R.string.interphone_channel_contact_type_person);
                        this.mTvChannelCallNumber.setText(this.channelData.getTxContact() + "");
                        ((TextView) findViewById(R.id.interphone_channel_call_name_title)).setText(R.string.interphone_channel_call_name);
                    } else if (this.channelData.getContactType() == 1) {
                        this.mTvChannelContactType.setText(R.string.interphone_channel_contact_type_group);
                        this.mTvChannelCallNumber.setText(this.channelData.getTxContact() + "");
                        ((TextView) findViewById(R.id.interphone_channel_call_name_title)).setText(R.string.interphone_channel_call_name_group);
                    } else {
                        this.mTvChannelContactType.setText(R.string.interphone_channel_contact_type_all);
                        findViewById(R.id.interphone_channel_call_name).setVisibility(8);
                    }
                    this.mCurrentChannelContactType = this.mTvChannelContactType.getText().toString();
                    if (this.channelData.getEncryptSw() == 2) {
                        this.mTvChannelEncryption.setText(R.string.interphone_channel_encryption_disable);
                        findViewById(R.id.interphone_channel_encryption_key).setVisibility(8);
                    } else {
                        this.mTvChannelEncryption.setText(R.string.interphone_channel_encryption_enable);
                        findViewById(R.id.interphone_channel_encryption_key).setVisibility(0);
                    }
                    if (this.channelData.getEncryptSw() == 1) {
                        this.mCurrentChannelEncryption = getString(R.string.interphone_channel_encryption_enable);
                    }
                    this.mTvChannelEncryptionKey.setText(this.channelData.getEncryptKey());
                    if (this.channelData.getChannelMode() == 0) {
                        this.mTvChannelInputMode.setText(R.string.interphone_channel_mode_direct_mode);
                    } else if (this.channelData.getChannelMode() == 4) {
                        this.mTvChannelInputMode.setText(R.string.interphone_channel_mode_double_slot_mode);
                    }
                    this.mCurrentChannelInputMode = this.mTvChannelInputMode.getText().toString();
                    if (this.channelData.getInBoundSlot() == 0 && this.channelData.getOutBoundSlot() == 0) {
                        this.mTvChannelSlot.setText(R.string.interphone_channel_double_slot_slot1);
                    } else if (this.channelData.getInBoundSlot() == 1 && this.channelData.getOutBoundSlot() == 1) {
                        this.mTvChannelSlot.setText(R.string.interphone_channel_double_slot_slot2);
                    }
                    this.mCurrentChannelSlot = this.mTvChannelSlot.getText().toString();
                    return;
                }
                this.mTvChannelType.setText(R.string.interphone_channel_type_analog);
                hideDigitalMenu();
                if (this.channelData.getBand() == 0) {
                    this.mTvChannelBand.setText(R.string.interphone_channel_band_narrow);
                } else {
                    this.mTvChannelBand.setText(R.string.interphone_channel_band_wide);
                }
                this.mCurrentChannelBand = this.mTvChannelBand.getText().toString();
                this.mTvChannelSq.setText(this.channelData.getSq() + "");
                this.mCurrentChannelSq = this.channelData.getSq() + "";
                if (this.channelData.getRxType() == 0) {
                    findViewById(R.id.interphone_channel_rxsubcode).setVisibility(8);
                } else {
                    findViewById(R.id.interphone_channel_rxsubcode).setVisibility(0);
                }
                if (this.channelData.getTxType() == 0) {
                    findViewById(R.id.interphone_channel_txsubcode).setVisibility(8);
                } else {
                    findViewById(R.id.interphone_channel_txsubcode).setVisibility(0);
                }
                if (this.channelData.getTxType() == 0) {
                    this.mTvChannelTxtype.setText(R.string.interphone_channel_txtype_wave);
                    this.mCurrentChannelTxSub = "0";
                } else if (this.channelData.getTxType() == 1) {
                    this.mTvChannelTxtype.setText(R.string.interphone_channel_txtype_ctc);
                    this.mCurrentChannelTxSub = this.mDataChannelTxSubCtc.get(this.channelData.getTxSubCode());
                } else if (this.channelData.getTxType() == 2) {
                    this.mTvChannelTxtype.setText(R.string.interphone_channel_txtype_pdcs);
                    this.mCurrentChannelTxSub = this.mDataChannelTxSubFDcs.get(this.channelData.getTxSubCode());
                } else if (this.channelData.getTxType() == 3) {
                    this.mTvChannelTxtype.setText(R.string.interphone_channel_txtype_ndcs);
                    this.mCurrentChannelTxSub = this.mDataChannelTxSubBDcs.get(this.channelData.getTxSubCode());
                }
                this.mTvChannelTxSub.setText(this.mCurrentChannelTxSub);
                this.mCurrentChannelTxtype = this.mTvChannelTxtype.getText().toString();
                if (this.channelData.getRxType() == 0) {
                    this.mTvChannelRxtype.setText(R.string.interphone_channel_rxtype_wave);
                    this.mCurrentChannelRxSub = "0";
                } else if (this.channelData.getRxType() == 1) {
                    this.mTvChannelRxtype.setText(R.string.interphone_channel_rxtype_ctc);
                    this.mCurrentChannelRxSub = this.mDataChannelRxSubCtc.get(this.channelData.getRxSubCode());
                } else if (this.channelData.getRxType() == 2) {
                    this.mTvChannelRxtype.setText(R.string.interphone_channel_rxtype_pdcs);
                    this.mCurrentChannelRxSub = this.mDataChannelRxSubFDcs.get(this.channelData.getRxSubCode());
                } else if (this.channelData.getRxType() == 3) {
                    this.mTvChannelRxtype.setText(R.string.interphone_channel_rxtype_ndcs);
                    this.mCurrentChannelRxSub = this.mDataChannelRxSubBDcs.get(this.channelData.getRxSubCode());
                }
                this.mTvChannelRxSub.setText(this.mCurrentChannelRxSub);
                this.mCurrentChannelRxtype = this.mTvChannelRxtype.getText().toString();
                return;
            }
            return;
        }
        this.mTvChannelType.setText(R.string.interphone_channel_type_default);
        hideAnalogMenu();
        this.groupGridview = (GridView) findViewById(R.id.interphone_channel_group_grid);
        int[] iArr = new int[32];
        Arrays.fill(iArr, 0);
        iArr[0] = 1;
        GroupGridAdapter groupGridAdapter2 = new GroupGridAdapter(this, iArr);
        this.gridAdapter = groupGridAdapter2;
        this.groupGridview.setAdapter((ListAdapter) groupGridAdapter2);
    }

    @Override // androidx.appcompat.app.AppCompatActivity, androidx.fragment.app.FragmentActivity, android.app.Activity, android.content.ComponentCallbacks
    public void onConfigurationChanged(@NonNull Configuration configuration) {
        super.onConfigurationChanged(configuration);
        finish();
    }

    public void hideDigitalMenu() {
        findViewById(R.id.interphone_channel_color).setVisibility(8);
        findViewById(R.id.interphone_channel_mode_type).setVisibility(8);
        findViewById(R.id.interphone_channel_slot_type).setVisibility(8);
        findViewById(R.id.interphone_channel_contact_type).setVisibility(8);
        findViewById(R.id.interphone_channel_call_name).setVisibility(8);
        findViewById(R.id.interphone_channel_encryption).setVisibility(8);
        findViewById(R.id.interphone_channel_encryption_key).setVisibility(8);
        findViewById(R.id.interphone_channel_band).setVisibility(0);
        findViewById(R.id.interphone_channel_sq).setVisibility(0);
        findViewById(R.id.interphone_channel_txtype).setVisibility(0);
        findViewById(R.id.interphone_channel_rxtype).setVisibility(0);
        findViewById(R.id.interphone_channel_relay_disconnecte).setVisibility(0);
        findViewById(R.id.interphone_channel_interrupt_transmission).setVisibility(8);
        findViewById(R.id.interphone_channel_group_list).setVisibility(8);
    }

    public void hideAnalogMenu() {
        findViewById(R.id.interphone_channel_color).setVisibility(0);
        findViewById(R.id.interphone_channel_mode_type).setVisibility(0);
        findViewById(R.id.interphone_channel_slot_type).setVisibility(0);
        findViewById(R.id.interphone_channel_contact_type).setVisibility(0);
        findViewById(R.id.interphone_channel_call_name).setVisibility(0);
        findViewById(R.id.interphone_channel_encryption).setVisibility(0);
        if (getString(R.string.interphone_channel_encryption_enable).equals(this.mTvChannelEncryption.getText().toString())) {
            findViewById(R.id.interphone_channel_encryption_key).setVisibility(0);
        } else {
            findViewById(R.id.interphone_channel_encryption_key).setVisibility(8);
        }
        findViewById(R.id.interphone_channel_band).setVisibility(8);
        findViewById(R.id.interphone_channel_sq).setVisibility(8);
        findViewById(R.id.interphone_channel_txtype).setVisibility(8);
        findViewById(R.id.interphone_channel_rxtype).setVisibility(8);
        findViewById(R.id.interphone_channel_relay_disconnecte).setVisibility(0);
        findViewById(R.id.interphone_channel_interrupt_transmission).setVisibility(0);
        findViewById(R.id.interphone_channel_group_list).setVisibility(0);
    }

    private ArrayList<String> strToArray(String[] strArr) {
        ArrayList<String> arrayList = new ArrayList<>();
        for (String str : strArr) {
            arrayList.add(str);
        }
        return arrayList;
    }

    @Override // androidx.activity.ComponentActivity, android.app.Activity
    public void onBackPressed() {
        super.onBackPressed();
    }

    public boolean isParamsCorrect() {
        int parseInt;
        if (this.mEditChannelName.getText().toString().trim().isEmpty()) {
            showToast(R.string.interphone_channel_name_hint);
            return false;
        } else if (this.mEditFrequncySend.getText().toString().isEmpty()) {
            showToast(R.string.interphone_channel_frequency_send_warning);
            return false;
        } else if (this.mEditFrequncyRecieve.getText().toString().isEmpty()) {
            showToast(R.string.interphone_channel_frequency_recieve_warning);
            return false;
        } else {
            boolean isSupportUVFrequencyBand = DmrManager.getInstance().isSupportUVFrequencyBand();
            int i = Constants.CHANNEL_FRQC_BAND_V_LIMIT_MIN;
            int i2 = Constants.CHANNEL_FRQC_BAND_V_LIMIT_MAX;
            if (isSupportUVFrequencyBand) {
                boolean equals = getString(R.string.interphone_channel_frequency_uhf).equals(this.mTvChannelFrqBand.getText().toString());
                if (equals) {
                    i2 = 480000000;
                }
                if (equals) {
                    i = 400000000;
                }
            } else if (DmrManager.getInstance().isSupportOnlyUFrequencyBand() || !DmrManager.getInstance().isSupportOnlyVFrequencyBand()) {
                i = 400000000;
                i2 = 480000000;
            }
            if (Integer.parseInt(this.mEditFrequncyRecieve.getText().toString()) < i || Integer.parseInt(this.mEditFrequncyRecieve.getText().toString()) > i2 || Integer.parseInt(this.mEditFrequncySend.getText().toString()) < i || Integer.parseInt(this.mEditFrequncySend.getText().toString()) > i2) {
                showToast(getString(R.string.interphone_channel_frequency_len_warning, new Object[]{Integer.valueOf(i), Integer.valueOf(i2)}));
                return false;
            }
            if (this.mTvChannelType.getText().toString().equals(getString(R.string.interphone_channel_type_digital))) {
                if (this.mTvChannelCallNumber.getText().toString().isEmpty() && !this.mCurrentChannelContactType.equals(getString(R.string.interphone_channel_contact_type_all))) {
                    showToast(R.string.interphone_channel_call_name_warning);
                    return false;
                }
                if (!this.mTvChannelCallNumber.getText().toString().isEmpty() && !this.mCurrentChannelContactType.equals(getString(R.string.interphone_channel_contact_type_all))) {
                    if (this.mCurrentChannelContactType.equals(getString(R.string.interphone_channel_contact_type_person))) {
                        int parseInt2 = Integer.parseInt(this.mTvChannelCallNumber.getText().toString());
                        if (parseInt2 < 1 || parseInt2 > 16776415) {
                            showToast(R.string.interphone_channel_people_number_edit_limit_toast);
                            return false;
                        }
                    } else if (this.mCurrentChannelContactType.equals(getString(R.string.interphone_channel_contact_type_group)) && ((parseInt = Integer.parseInt(this.mTvChannelCallNumber.getText().toString())) < 1 || parseInt > 16776415)) {
                        showToast(R.string.interphone_channel_group_number_edit_limit_toast);
                        return false;
                    }
                }
                for (int i3 : this.gridAdapter.getGroupList()) {
                    if (i3 > 16776415) {
                        showToast(R.string.interphone_channel_group_list_edit_limit_toast);
                        return false;
                    }
                }
            }
            return true;
        }
    }

    public void showProgressDialog(String str) {
        if (this.mProgressDialog == null) {
            this.mProgressDialog = new ProgressDialog(this);
        }
        this.mProgressDialog.setMessage(str);
        this.mProgressDialog.setCancelable(false);
        this.mProgressDialog.show();
    }

    public void dismissProgressDialog() {
        ProgressDialog progressDialog = this.mProgressDialog;
        if (progressDialog != null) {
            progressDialog.dismiss();
        }
    }

    public void saveChannelData() {
        String str;
        if (isParamsCorrect()) {
            if (!this.isEdit) {
                ChannelData channelData = new ChannelData();
                this.channelData = channelData;
                channelData.setName(this.mEditChannelName.getText().toString().trim());
            } else {
                if (!TextUtils.isEmpty(this.channelData.getName())) {
                    str = "";
                } else if (this.channelData.getType() == 0) {
                    str = PrizeInterPhoneApp.getContext().getString(R.string.interphone_channel_type_digital) + this.channelData.number;
                } else {
                    str = PrizeInterPhoneApp.getContext().getString(R.string.interphone_channel_type_analog) + this.channelData.number;
                }
                if (!this.mEditChannelName.getText().toString().trim().equals(str)) {
                    this.channelData.setName(this.mEditChannelName.getText().toString().trim());
                }
            }
            this.channelData.setTxFreq(Integer.parseInt(this.mEditFrequncySend.getText().toString()));
            this.channelData.setRxFreq(Integer.parseInt(this.mEditFrequncyRecieve.getText().toString()));
            if (getString(R.string.interphone_channel_power_high_value).equals(this.mTvChannelPower.getText().toString())) {
                this.channelData.setPower(1);
            } else {
                this.channelData.setPower(0);
            }
            if (getString(R.string.interphone_channel_relay_disconnecte_disable_value).equals(this.mTvChannelRelayDisconnet.getText().toString())) {
                this.channelData.setRelay(2);
                DmrManager.getInstance().relayCommand();
            } else if (getString(R.string.interphone_channel_relay_disconnecte_enable_value).equals(this.mTvChannelRelayDisconnet.getText().toString())) {
                this.channelData.setRelay(1);
                DmrManager.getInstance().relayCommand();
            }
            if (this.mTvChannelType.getText().toString().equals(getString(R.string.interphone_channel_type_digital))) {
                this.channelData.setType(0);
                if (getString(R.string.interphone_channel_contact_type_person).equals(this.mTvChannelContactType.getText().toString())) {
                    this.channelData.setContactType(0);
                    this.channelData.setTxContact(Integer.parseInt(this.mTvChannelCallNumber.getText().toString()));
                } else if (getString(R.string.interphone_channel_contact_type_group).equals(this.mTvChannelContactType.getText().toString())) {
                    this.channelData.setTxContact(Integer.parseInt(this.mTvChannelCallNumber.getText().toString()));
                    this.channelData.setContactType(1);
                } else if (getString(R.string.interphone_channel_contact_type_all).equals(this.mTvChannelContactType.getText().toString())) {
                    this.channelData.setContactType(2);
                    this.channelData.setTxContact(16777215);
                }
                this.channelData.setGroups(this.gridAdapter.getGroupList());
                this.channelData.setCc(Integer.parseInt(this.mTvChannelColor.getText().toString()));
                if (getString(R.string.interphone_channel_encryption_enable).equals(this.mTvChannelEncryption.getText().toString())) {
                    this.channelData.setEncryptSw(1);
                    String obj = this.mTvChannelEncryptionKey.getText().toString();
                    if (obj.length() < 8 && obj.length() > 1) {
                        StringBuilder sb = new StringBuilder();
                        for (int i = 0; i < 8 - obj.length(); i++) {
                            sb.append("0");
                        }
                        sb.append(obj);
                        this.mTvChannelEncryptionKey.setText(sb.toString());
                        this.mTvChannelEncryptionKey.setSelection(0);
                        Log.d(TAG, " mTvChannelEncryptionKey.getText().toString() = " + this.mTvChannelEncryptionKey.getText().toString());
                    }
                    this.channelData.setEncryptKey(this.mTvChannelEncryptionKey.getText().toString());
                } else {
                    this.channelData.setEncryptSw(2);
                    this.channelData.setEncryptKey("");
                }
                if (getString(R.string.interphone_channel_interrupt_transmission_on).equals(this.mTvChannelInterruptTransmission.getText().toString())) {
                    this.channelData.setInterrupt(1);
                } else if (getString(R.string.interphone_channel_interrupt_transmission_off).equals(this.mTvChannelInterruptTransmission.getText().toString())) {
                    this.channelData.setInterrupt(2);
                } else if (getString(R.string.interphone_channel_interrupt_transmission_transmit).equals(this.mTvChannelInterruptTransmission.getText().toString())) {
                    this.channelData.setInterrupt(3);
                    PersonSharePrefData.putBooleanData(PrizeInterPhoneApp.getContext(), "pref_person_busy_no_send", false);
                }
                if (getString(R.string.interphone_channel_mode_direct_mode).equals(this.mTvChannelInputMode.getText().toString())) {
                    this.channelData.setChannelMode(0);
                } else if (getString(R.string.interphone_channel_mode_double_slot_mode).equals(this.mTvChannelInputMode.getText().toString())) {
                    this.channelData.setChannelMode(4);
                }
                if (getString(R.string.interphone_channel_double_slot_slot1).equals(this.mTvChannelSlot.getText().toString())) {
                    this.channelData.setInBoundSlot(0);
                    this.channelData.setOutBoundSlot(0);
                } else if (getString(R.string.interphone_channel_double_slot_slot2).equals(this.mTvChannelSlot.getText().toString())) {
                    this.channelData.setInBoundSlot(1);
                    this.channelData.setOutBoundSlot(1);
                }
            } else {
                this.channelData.setType(1);
                if (getString(R.string.interphone_channel_band_narrow).equals(this.mTvChannelBand.getText().toString())) {
                    this.channelData.setBand(0);
                } else {
                    this.channelData.setBand(1);
                }
                this.channelData.setSq(Integer.parseInt(this.mTvChannelSq.getText().toString()));
                if (getString(R.string.interphone_channel_txtype_wave).equals(this.mTvChannelTxtype.getText().toString())) {
                    this.channelData.setTxType(0);
                    this.channelData.setTxSubCode(0);
                } else if (getString(R.string.interphone_channel_txtype_ctc).equals(this.mTvChannelTxtype.getText().toString())) {
                    this.channelData.setTxType(1);
                    this.channelData.setTxSubCode(this.mDataChannelTxSubCtc.indexOf(this.mTvChannelTxSub.getText().toString()));
                } else if (getString(R.string.interphone_channel_txtype_pdcs).equals(this.mTvChannelTxtype.getText().toString())) {
                    this.channelData.setTxType(2);
                    this.channelData.setTxSubCode(this.mDataChannelTxSubFDcs.indexOf(this.mTvChannelTxSub.getText().toString()));
                } else if (getString(R.string.interphone_channel_txtype_ndcs).equals(this.mTvChannelTxtype.getText().toString())) {
                    this.channelData.setTxType(3);
                    this.channelData.setTxSubCode(this.mDataChannelTxSubBDcs.indexOf(this.mTvChannelTxSub.getText().toString()));
                }
                if (getString(R.string.interphone_channel_rxtype_wave).equals(this.mTvChannelRxtype.getText().toString())) {
                    this.channelData.setRxType(0);
                    this.channelData.setRxSubCode(0);
                } else if (getString(R.string.interphone_channel_rxtype_ctc).equals(this.mTvChannelRxtype.getText().toString())) {
                    this.channelData.setRxType(1);
                    this.channelData.setRxSubCode(this.mDataChannelRxSubCtc.indexOf(this.mTvChannelRxSub.getText().toString()));
                } else if (getString(R.string.interphone_channel_rxtype_pdcs).equals(this.mTvChannelRxtype.getText().toString())) {
                    this.channelData.setRxType(2);
                    this.channelData.setRxSubCode(this.mDataChannelRxSubFDcs.indexOf(this.mTvChannelRxSub.getText().toString()));
                } else if (getString(R.string.interphone_channel_rxtype_ndcs).equals(this.mTvChannelRxtype.getText().toString())) {
                    this.channelData.setRxType(3);
                    this.channelData.setRxSubCode(this.mDataChannelRxSubBDcs.indexOf(this.mTvChannelRxSub.getText().toString()));
                }
            }
            if (this.isEdit) {
                if (this.messageListener == null) {
                    this.messageListener = new DmrManager.MessageListener() { // from class: com.pri.prizeinterphone.activity.InterPhoneChannelActivity.8
                        @Override // com.pri.prizeinterphone.manager.DmrManager.MessageListener
                        public void errorEvent(Byte b) {
                            if (b.byteValue() == 34 || b.byteValue() == 35) {
                                InterPhoneChannelActivity interPhoneChannelActivity = InterPhoneChannelActivity.this;
                                interPhoneChannelActivity.mHandler.post(interPhoneChannelActivity.mDismissRunnable);
                                DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_DIGITAL_INFO_CMD), InterPhoneChannelActivity.this.messageListener);
                                DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_ANALOG_INFO_CMD), InterPhoneChannelActivity.this.messageListener);
                                Snackbar.make(InterPhoneChannelActivity.this.rootView, (int) R.string.operate_fail, 0).show();
                            }
                        }

                        @Override // com.pri.prizeinterphone.manager.DmrManager.MessageListener
                        public void dealEvent(BaseMessage baseMessage) {
                            byte b = baseMessage.packet.cmd;
                            if (b == 34 || b == 35) {
                                DmrManager.getInstance().getCurrentDbHelper().updateChannel(InterPhoneChannelActivity.this.channelData);
                                DmrManager.getInstance().updateChannelList();
                                DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_DIGITAL_INFO_CMD), InterPhoneChannelActivity.this.messageListener);
                                DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_ANALOG_INFO_CMD), InterPhoneChannelActivity.this.messageListener);
                                InterPhoneChannelActivity interPhoneChannelActivity = InterPhoneChannelActivity.this;
                                interPhoneChannelActivity.mHandler.postDelayed(interPhoneChannelActivity.mDismissRunnableAndroidFinish, LaunchConfig.ACTIVITY_CONSIDERED_RESUME);
                            }
                        }
                    };
                }
                if (this.channelData.active == 1) {
                    if (CmdStateMachine.getInstance().getCurrentState() == CmdStateMachine.getInstance().getSetChannelState()) {
                        Log.d(TAG, "saveChannelData is setting channel...");
                        Snackbar.make(this.rootView, (int) R.string.operate_fail, 0).show();
                        return;
                    }
                    showProgressDialog(getString(R.string.channel_saving));
                    DmrManager.getInstance().registerEventListener(Const.Command.SET_DIGITAL_INFO_CMD, this.messageListener);
                    DmrManager.getInstance().registerEventListener(Const.Command.SET_ANALOG_INFO_CMD, this.messageListener);
                    DmrManager.getInstance().syncChannelInfoWithData(this.channelData);
                    this.mHandler.postDelayed(this.mDismissRunnable, 5000L);
                    return;
                }
                DmrManager.getInstance().updateChannel(this.currentAreaId, this.channelData);
                finish();
                return;
            }
            DmrManager.getInstance().createChannel(this.currentAreaId, this.channelData);
            finish();
        }
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.appcompat.app.AppCompatActivity, androidx.fragment.app.FragmentActivity, android.app.Activity
    public void onDestroy() {
        super.onDestroy();
        this.mHandler.removeCallbacksAndMessages(null);
    }

    @Override // android.view.View.OnClickListener
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.interphone_channel_back_button /* 2131296517 */:
                onBackPressed();
                return;
            case R.id.interphone_channel_band_set /* 2131296519 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelBand, 2, R.id.interphone_channel_band_set, this.mCurrentChannelBand);
                return;
            case R.id.interphone_channel_call_name_set /* 2131296521 */:
                updateSelectedItem(view.getId());
                return;
            case R.id.interphone_channel_color_set /* 2131296524 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelColor, 4, R.id.interphone_channel_color_set, this.mCurrentChannelColor);
                return;
            case R.id.interphone_channel_contact_type_set /* 2131296526 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelContactType, 3, R.id.interphone_channel_contact_type_set, this.mCurrentChannelContactType);
                return;
            case R.id.interphone_channel_encryption_set /* 2131296530 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelEncryption, 2, R.id.interphone_channel_encryption_set, this.mCurrentChannelEncryption);
                return;
            case R.id.interphone_channel_frequency /* 2131296531 */:
                updateSelectedItem(view.getId());
                return;
            case R.id.interphone_channel_frequency_band_set /* 2131296533 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelFrqBand, 2, R.id.interphone_channel_frequency_band_set, this.mCurrentChannelFrqBand);
                return;
            case R.id.interphone_channel_interrupt_transmission_set /* 2131296540 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelInterruptTransmission, 3, R.id.interphone_channel_interrupt_transmission_set, this.mCurrentChannelInterruptTransmission);
                return;
            case R.id.interphone_channel_mode_set /* 2131296542 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelInputMode, 2, R.id.interphone_channel_mode_set, this.mCurrentChannelInputMode);
                return;
            case R.id.interphone_channel_power_set /* 2131296547 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelPower, 2, R.id.interphone_channel_power_set, this.mCurrentChannelPower);
                return;
            case R.id.interphone_channel_relay_disconnecte_label:
                // Show help dialog explaining relay disconnect
                new androidx.appcompat.app.AlertDialog.Builder(this)
                    .setTitle(R.string.interphone_channel_relay_help_title)
                    .setMessage(R.string.interphone_channel_relay_help_message)
                    .setPositiveButton(android.R.string.ok, null)
                    .show();
                return;
            case R.id.interphone_channel_relay_disconnecte_set /* 2131296549 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelRelayDisconnet, 2, R.id.interphone_channel_relay_disconnecte_set, this.mCurrentChannelRelayDisconnet);
                return;
            case R.id.interphone_channel_rxsubcode_set /* 2131296551 */:
                updateSelectedItem(view.getId());
                if (this.mCurrentChannelRxtype.equals(getString(R.string.interphone_channel_rxtype_ctc))) {
                    showPopupWindow(this.mDataChannelRxSubCtc, 8, R.id.interphone_channel_rxsubcode_set, this.mCurrentChannelRxSub);
                    return;
                } else if (this.mCurrentChannelRxtype.equals(getString(R.string.interphone_channel_rxtype_pdcs))) {
                    showPopupWindow(this.mDataChannelRxSubFDcs, 8, R.id.interphone_channel_rxsubcode_set, this.mCurrentChannelRxSub);
                    return;
                } else if (this.mCurrentChannelRxtype.equals(getString(R.string.interphone_channel_rxtype_ndcs))) {
                    showPopupWindow(this.mDataChannelRxSubBDcs, 8, R.id.interphone_channel_rxsubcode_set, this.mCurrentChannelRxSub);
                    return;
                } else {
                    return;
                }
            case R.id.interphone_channel_rxtype_set /* 2131296553 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelRxtype, 4, R.id.interphone_channel_rxtype_set, this.mCurrentChannelRxtype);
                return;
            case R.id.interphone_channel_save /* 2131296554 */:
                if (isTalkSend()) {
                    return;
                }
                saveChannelData();
                return;
            case R.id.interphone_channel_slot_set /* 2131296555 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelSlot, 2, R.id.interphone_channel_slot_set, this.mCurrentChannelSlot);
                return;
            case R.id.interphone_channel_sq_set /* 2131296561 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelSq, 8, R.id.interphone_channel_sq_set, this.mCurrentChannelSq);
                return;
            case R.id.interphone_channel_txsubcode_set /* 2131296564 */:
                updateSelectedItem(view.getId());
                if (this.mCurrentChannelTxtype.equals(getString(R.string.interphone_channel_txtype_ctc))) {
                    showPopupWindow(this.mDataChannelTxSubCtc, 8, R.id.interphone_channel_txsubcode_set, this.mCurrentChannelTxSub);
                    return;
                } else if (this.mCurrentChannelTxtype.equals(getString(R.string.interphone_channel_txtype_pdcs))) {
                    showPopupWindow(this.mDataChannelTxSubFDcs, 8, R.id.interphone_channel_txsubcode_set, this.mCurrentChannelTxSub);
                    return;
                } else if (this.mCurrentChannelTxtype.equals(getString(R.string.interphone_channel_txtype_ndcs))) {
                    showPopupWindow(this.mDataChannelTxSubBDcs, 8, R.id.interphone_channel_txsubcode_set, this.mCurrentChannelTxSub);
                    return;
                } else {
                    return;
                }
            case R.id.interphone_channel_txtype_set /* 2131296566 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelTxtype, 4, R.id.interphone_channel_txtype_set, this.mCurrentChannelTxtype);
                return;
            case R.id.interphone_channel_type_set /* 2131296568 */:
                updateSelectedItem(view.getId());
                showPopupWindow(this.mDataChannelType, 2, R.id.interphone_channel_type_set, this.mCurrentChannelType);
                return;
            default:
                return;
        }
    }

    private void showPopupWindow(ArrayList arrayList, int i, int i2, String str) {
        int dip2px = UtilDensity.dip2px(this, 50.0f);
        Log.e(TAG, "itemHeight = " + dip2px);
        this.mPopWindow.refreshData(arrayList, str);
        this.mPopWindow.setWidth((int) (((double) dip2px) * 3.3d));
        this.mPopWindow.setHeight(i * dip2px);
        this.mPopWindow.showAsDropDown(findViewById(i2));
    }

    @Override // com.pri.prizeinterphone.widget.SpinerPopWindow.PrizeOnItemClickListener
    public void setOnItemClick(String str) {
        int i = this.mCurrentViewId;
        if (i == R.id.interphone_channel_type_set) {
            this.mCurrentChannelType = str;
            this.mTvChannelType.setText(str);
            if (str.equals(getString(R.string.interphone_channel_type_digital))) {
                hideAnalogMenu();
            } else {
                hideDigitalMenu();
            }
        } else if (i == R.id.interphone_channel_frequency_band_set || i == R.id.interphone_channel_frequency_send_edit || i == R.id.interphone_channel_frequency_recieve_edit) {
            this.mCurrentChannelFrqBand = str;
            this.mTvChannelFrqBand.setText(str);
            if (getString(R.string.interphone_channel_frequency_uhf).equals(this.mCurrentChannelFrqBand)) {
                this.mEditFrequncySend.setHint(R.string.interphone_channel_frequency_hint_u);
                this.mEditFrequncyRecieve.setHint(R.string.interphone_channel_frequency_hint_u);
            } else if (getString(R.string.interphone_channel_frequency_vhf).equals(this.mCurrentChannelFrqBand)) {
                this.mEditFrequncySend.setHint(R.string.interphone_channel_frequency_hint_v);
                this.mEditFrequncyRecieve.setHint(R.string.interphone_channel_frequency_hint_v);
            } else {
                Log.d(TAG, "channel frequency band error");
            }
        } else if (i == R.id.interphone_channel_power_set) {
            this.mCurrentChannelPower = str;
            this.mTvChannelPower.setText(str);
        } else if (i == R.id.interphone_channel_color_set) {
            this.mCurrentChannelColor = str;
            this.mTvChannelColor.setText(str);
        } else if (i == R.id.interphone_channel_mode_set) {
            this.mCurrentChannelInputMode = str;
            this.mTvChannelInputMode.setText(str);
        } else if (i == R.id.interphone_channel_slot_set) {
            this.mCurrentChannelSlot = str;
            this.mTvChannelSlot.setText(str);
        } else if (i == R.id.interphone_channel_contact_type_set) {
            this.mCurrentChannelContactType = str;
            this.mTvChannelContactType.setText(str);
            if (str.equals(getString(R.string.interphone_channel_contact_type_all))) {
                findViewById(R.id.interphone_channel_call_name).setVisibility(8);
            } else {
                if (str.equals(getString(R.string.interphone_channel_contact_type_person))) {
                    ((TextView) findViewById(R.id.interphone_channel_call_name_title)).setText(R.string.interphone_channel_call_name);
                } else if (str.equals(getString(R.string.interphone_channel_contact_type_group))) {
                    ((TextView) findViewById(R.id.interphone_channel_call_name_title)).setText(R.string.interphone_channel_call_name_group);
                }
                findViewById(R.id.interphone_channel_call_name).setVisibility(0);
            }
        } else if (i == R.id.interphone_channel_call_name_set) {
            this.mCurrentChannelCallName = str;
            this.mTvChannelCallNumber.setText(str);
        } else if (i == R.id.interphone_channel_encryption_set) {
            this.mCurrentChannelEncryption = str;
            this.mTvChannelEncryption.setText(str);
            if (str.equals(getString(R.string.interphone_channel_encryption_disable))) {
                findViewById(R.id.interphone_channel_encryption_key).setVisibility(8);
            } else {
                findViewById(R.id.interphone_channel_encryption_key).setVisibility(0);
            }
        } else if (i == R.id.interphone_channel_relay_disconnecte_set) {
            this.mCurrentChannelRelayDisconnet = str;
            this.mTvChannelRelayDisconnet.setText(str);
        } else if (i == R.id.interphone_channel_interrupt_transmission_set) {
            this.mCurrentChannelInterruptTransmission = str;
            this.mTvChannelInterruptTransmission.setText(str);
            Log.i(TAG, "mCurrentChannelInterruptTransmission = " + this.mCurrentChannelInterruptTransmission);
            if (str.equals(getString(R.string.interphone_channel_interrupt_transmission_transmit))) {
                showToast(R.string.interphone_is_transmit_prohibit_sending_when_busy_toast);
            }
        } else if (i == R.id.interphone_channel_band_set) {
            this.mCurrentChannelBand = str;
            this.mTvChannelBand.setText(str);
        } else if (i == R.id.interphone_channel_sq_set) {
            this.mCurrentChannelSq = str;
            this.mTvChannelSq.setText(str);
        } else if (i == R.id.interphone_channel_rxtype_set) {
            this.mCurrentChannelRxtype = str;
            this.mTvChannelRxtype.setText(str);
            if (str.equals(getString(R.string.interphone_channel_rxtype_wave))) {
                findViewById(R.id.interphone_channel_rxsubcode).setVisibility(8);
            } else {
                findViewById(R.id.interphone_channel_rxsubcode).setVisibility(0);
            }
            if (str.equals(getString(R.string.interphone_channel_rxtype_wave))) {
                this.mCurrentChannelRxSub = "0";
            } else if (str.equals(getString(R.string.interphone_channel_rxtype_ctc))) {
                this.mCurrentChannelRxSub = this.mDataChannelRxSubCtc.get(0);
            } else if (str.equals(getString(R.string.interphone_channel_rxtype_pdcs))) {
                this.mCurrentChannelRxSub = this.mDataChannelRxSubFDcs.get(0);
            } else if (str.equals(getString(R.string.interphone_channel_rxtype_ndcs))) {
                this.mCurrentChannelRxSub = this.mDataChannelRxSubBDcs.get(0);
            }
            this.mTvChannelRxSub.setText(this.mCurrentChannelRxSub);
        } else if (i == R.id.interphone_channel_txtype_set) {
            this.mCurrentChannelTxtype = str;
            this.mTvChannelTxtype.setText(str);
            if (str.equals(getString(R.string.interphone_channel_txtype_wave))) {
                findViewById(R.id.interphone_channel_txsubcode).setVisibility(8);
            } else {
                findViewById(R.id.interphone_channel_txsubcode).setVisibility(0);
            }
            if (str.equals(getString(R.string.interphone_channel_txtype_wave))) {
                this.mCurrentChannelTxSub = "0";
            } else if (str.equals(getString(R.string.interphone_channel_txtype_ctc))) {
                this.mCurrentChannelTxSub = this.mDataChannelTxSubCtc.get(0);
            } else if (str.equals(getString(R.string.interphone_channel_txtype_pdcs))) {
                this.mCurrentChannelTxSub = this.mDataChannelTxSubFDcs.get(0);
            } else if (str.equals(getString(R.string.interphone_channel_txtype_ndcs))) {
                this.mCurrentChannelTxSub = this.mDataChannelTxSubBDcs.get(0);
            }
            this.mTvChannelTxSub.setText(this.mCurrentChannelTxSub);
        } else if (i == R.id.interphone_channel_txsubcode_set) {
            this.mCurrentChannelTxSub = str;
            this.mTvChannelTxSub.setText(str);
        } else if (i == R.id.interphone_channel_rxsubcode_set) {
            this.mCurrentChannelRxSub = str;
            this.mTvChannelRxSub.setText(str);
        }
        this.mPopWindow.dismiss();
    }

    public void updateSelectedItem(int i) {
        this.mCurrentViewId = i;
        Iterator<Map.Entry<Integer, Integer>> it = LIN_RES_ID.entrySet().iterator();
        while (true) {
            if (!it.hasNext()) {
                break;
            }
            Map.Entry<Integer, Integer> next = it.next();
            if ((i == R.id.interphone_channel_frequency_band_set || i == R.id.interphone_channel_frequency_recieve_edit || i == R.id.interphone_channel_frequency_send_edit) && (next.getKey().intValue() == R.id.interphone_channel_frequency_band_set || next.getKey().intValue() == R.id.interphone_channel_frequency_recieve_edit || next.getKey().intValue() == R.id.interphone_channel_frequency_send_edit)) {
                findViewById(next.getValue().intValue()).setSelected(true);
            } else {
                findViewById(next.getValue().intValue()).setSelected(i == next.getKey().intValue());
            }
        }
        if (this.mCurrentViewId != R.id.interphone_channel_name_edit) {
            this.mEditChannelName.clearFocus();
            hideKeyboard(this.mEditChannelName.getWindowToken());
        } else {
            this.mEditChannelName.requestFocus();
        }
        int i2 = this.mCurrentViewId;
        if (i2 != R.id.interphone_channel_frequency_band_set && i2 != R.id.interphone_channel_frequency_recieve_edit && i2 != R.id.interphone_channel_frequency_send_edit) {
            int i3 = this.mCurrentFrequency;
            if (i3 == 0) {
                this.mEditFrequncySend.clearFocus();
                hideKeyboard(this.mEditFrequncySend.getWindowToken());
            } else if (i3 == 1) {
                this.mEditFrequncyRecieve.clearFocus();
                hideKeyboard(this.mEditFrequncySend.getWindowToken());
            }
        } else {
            int i4 = this.mCurrentFrequency;
            if (i4 == 0) {
                this.mEditFrequncySend.requestFocus();
            } else if (i4 == 1) {
                this.mEditFrequncyRecieve.requestFocus();
            }
        }
        if (this.mCurrentViewId != R.id.interphone_channel_call_name_set) {
            this.mTvChannelCallNumber.clearFocus();
            hideKeyboard(this.mTvChannelCallNumber.getWindowToken());
            return;
        }
        this.mTvChannelCallNumber.requestFocus();
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public boolean dispatchTouchEvent(MotionEvent motionEvent) {
        if (motionEvent.getAction() == 0) {
            this.mCurrentTouchX = motionEvent.getX();
            this.mCurrentTouchY = motionEvent.getY();
        }
        return super.dispatchTouchEvent(motionEvent);
    }

    private boolean isShouldHideKeyboard(View view, MotionEvent motionEvent) {
        if (view == null || !(view instanceof EditText)) {
            return false;
        }
        int[] iArr = {0, 0};
        view.getLocationInWindow(iArr);
        int i = iArr[0];
        int i2 = iArr[1];
        return motionEvent.getX() <= ((float) i) || motionEvent.getX() >= ((float) (view.getWidth() + i)) || motionEvent.getY() <= ((float) i2) || motionEvent.getY() >= ((float) (view.getHeight() + i2));
    }

    private void hideKeyboard(IBinder iBinder) {
        if (iBinder != null) {
            ((InputMethodManager) getSystemService("input_method")).hideSoftInputFromWindow(iBinder, 2);
        }
    }

    private void showKeyboard(View view) {
        if (view != null) {
            view.requestFocus();
            ((InputMethodManager) getSystemService("input_method")).showSoftInput(view, 0);
        }
    }

    private void showToast(int i) {
        Toast toast = this.mToast;
        if (toast != null) {
            toast.cancel();
        }
        Toast makeText = Toast.makeText(this, i, 0);
        this.mToast = makeText;
        makeText.show();
    }

    private void showToast(String str) {
        Toast toast = this.mToast;
        if (toast != null) {
            toast.cancel();
        }
        Toast makeText = Toast.makeText(this, str, 0);
        this.mToast = makeText;
        makeText.show();
    }

    private boolean isTalkSend() {
        boolean z = PersonSharePrefData.getIntData(this, PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1;
        if (z) {
            showToast(R.string.interphone_talk_send_status_toast);
        }
        return z;
    }
}
