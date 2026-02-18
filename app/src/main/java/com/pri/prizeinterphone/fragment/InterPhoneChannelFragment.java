package com.pri.prizeinterphone.fragment;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Configuration;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentManager;
import com.google.android.material.snackbar.Snackbar;
import com.mediatek.boostfwk.identify.launch.LaunchConfig;
import com.pri.prizeinterphone.PrizeInterPhoneApp;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.Util.Clog;
import com.pri.prizeinterphone.Util.Util;
import com.pri.prizeinterphone.activity.InterPhoneChannelActivity;
import com.pri.prizeinterphone.constant.Constants;
import com.pri.prizeinterphone.fragment.InterPhoneChannelFragment;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.BaseMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.serial.data.ChannelData;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import com.pri.prizeinterphone.serial.data.UtilChannelData;
import com.pri.prizeinterphone.state.CmdStateMachine;
import java.util.ArrayList;
import java.util.List;
/* loaded from: classes4.dex */
public class InterPhoneChannelFragment extends BaseViewPagerFragment implements AdapterView.OnItemClickListener, View.OnClickListener, DmrManager.UpdateListener {
    public static final int REQUEST_EDIT_CHANNEL = 1005;
    private static final String TAG = "InterPhoneChannelFragment";
    private UtilChannelData dbChannelHelper;
    private AlertDialog deleteDialog;
    private int mCurrentClickPosition;
    private int mCurrentSelected;
    private DeviceAreaListAdapter mDeviceAreaListAdapter;
    private Dialog mDialog;
    private FragmentManager mFragmentManager;
    private ListView mListView;
    private View mLocalView;
    private Toast mToast;
    private DmrManager.MessageListener messageListener;
    public List<ChannelData> channels = new ArrayList();
    private Runnable mUpdateChannelListRunnable = new Runnable() { // from class: com.pri.prizeinterphone.fragment.InterPhoneChannelFragment.1
        @Override // java.lang.Runnable
        public void run() {
            InterPhoneChannelFragment.this.initData();
        }
    };

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
    public String getMyTag() {
        return TAG;
    }

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
    public void initView(View view) {
        super.initView(view);
        View inflate = LayoutInflater.from(getContext()).inflate(R.layout.fragment_channel_view, (ViewGroup) null);
        this.mLocalView = inflate;
        this.mFragmentContainer.addView(inflate);
        this.mListView = (ListView) this.mLocalView.findViewById(R.id.fragment_channel_device_area_list);
        setAddButton(R.drawable.interphone_add_seletor);
        DmrManager.getInstance().registerUpdateListener(this);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void initData() {
        String stringData = PersonSharePrefData.getStringData(PrizeInterPhoneApp.getContext(), "pref_person_channel_area_selected_index", Constants.KEY_DEF_AREA);
        try {
            this.dbChannelHelper = DmrManager.getInstance().getInitChannelDataDB().getCurrentDb(stringData);
            this.channels = DmrManager.getInstance().getChannelList(stringData);
            updateLanguageArea();
            int i = 0;
            while (true) {
                if (i >= this.channels.size()) {
                    break;
                } else if (this.channels.get(i).active == 1) {
                    this.mCurrentSelected = i;
                    break;
                } else {
                    i++;
                }
            }
            DeviceAreaListAdapter deviceAreaListAdapter = new DeviceAreaListAdapter(getActivity());
            this.mDeviceAreaListAdapter = deviceAreaListAdapter;
            this.mListView.setAdapter((ListAdapter) deviceAreaListAdapter);
            this.mListView.setChoiceMode(1);
            this.mListView.setOnItemClickListener(this);
            updateAdapter();
        } catch (Exception e) {
            Log.d(TAG, "initData,not call DmrManager.initChannelData() or faster than call DmrManager.initChannelData(),so InitChannelDataDB is null", e);
        }
    }

    private void updateLanguageArea() {
        setTitle(Constants.getChannelAreaName(getActivity()));
    }

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
    public void doAddAction() {
        super.doAddAction();
        if (isTalkSend()) {
            return;
        }
        Intent intent = new Intent(getActivity(), InterPhoneChannelActivity.class);
        intent.putExtra("currentAreaId", PersonSharePrefData.getStringData(PrizeInterPhoneApp.getContext(), "pref_person_channel_area_selected_index", Constants.KEY_DEF_AREA));
        getActivity().startActivity(intent);
    }

    @Override // com.pri.prizeinterphone.fragment.BaseViewPagerFragment
    public void updateView() {
        super.updateView();
        this.channels = DmrManager.getInstance().getChannelList();
    }

    @Override // android.widget.AdapterView.OnItemClickListener
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long j) {
        if (isTalkSend()) {
            return;
        }
        this.mCurrentClickPosition = i;
        if (i == this.mCurrentSelected) {
            showDialog(true, i);
        } else {
            showDialog(false, i);
        }
    }

    @Override // androidx.fragment.app.Fragment, android.content.ComponentCallbacks
    public void onConfigurationChanged(@NonNull Configuration configuration) {
        super.onConfigurationChanged(configuration);
        Dialog dialog = this.mDialog;
        if (dialog == null || !dialog.isShowing()) {
            return;
        }
        this.mDialog.dismiss();
        this.mDialog = null;
        int i = this.mCurrentClickPosition;
        showDialog(i == this.mCurrentSelected, i);
    }

    @Override // com.pri.prizeinterphone.manager.DmrManager.UpdateListener
    public void updateTalkBackChannelList() {
        this.mHandler.post(this.mUpdateChannelListRunnable);
    }

    @Override // com.pri.prizeinterphone.manager.DmrManager.UpdateListener
    public void updateModuleInit() {
        Log.i(TAG, "updateModuleInit: ");
    }

    /* JADX INFO: Access modifiers changed from: private */
    /* loaded from: classes4.dex */
    public class DeviceAreaListAdapter extends BaseAdapter {
        private Context mContext;

        @Override // android.widget.Adapter
        public Object getItem(int i) {
            return null;
        }

        @Override // android.widget.Adapter
        public long getItemId(int i) {
            return 0L;
        }

        public DeviceAreaListAdapter(Context context) {
            this.mContext = context;
        }

        @Override // android.widget.Adapter
        public int getCount() {
            return InterPhoneChannelFragment.this.channels.size();
        }

        @Override // android.widget.Adapter
        public View getView(int i, View view, ViewGroup viewGroup) {
            View view2;
            ViewHolder viewHolder;
            if (view == null) {
                viewHolder = new ViewHolder();
                view2 = LayoutInflater.from(this.mContext).inflate(R.layout.fragment_local_device_area_channel_list_item, (ViewGroup) null);
                viewHolder.mTvListTitle = (TextView) view2.findViewById(R.id.device_area_list_item_title);
                viewHolder.mTvListTX = (TextView) view2.findViewById(R.id.device_area_list_item_tx);
                viewHolder.mTvListRX = (TextView) view2.findViewById(R.id.device_area_list_item_rx);
                viewHolder.mImgListSelect = (ImageView) view2.findViewById(R.id.local_device_area_list_item_select);
                view2.setTag(viewHolder);
            } else {
                view2 = view;
                viewHolder = (ViewHolder) view.getTag();
            }
            if (InterPhoneChannelFragment.this.channels.get(i).name == null || InterPhoneChannelFragment.this.channels.get(i).name.equals("")) {
                if (InterPhoneChannelFragment.this.channels.get(i).type == 0) {
                    TextView textView = viewHolder.mTvListTitle;
                    textView.setText(PrizeInterPhoneApp.getContext().getString(R.string.interphone_channel_type_digital) + InterPhoneChannelFragment.this.channels.get(i).number);
                } else {
                    TextView textView2 = viewHolder.mTvListTitle;
                    textView2.setText(PrizeInterPhoneApp.getContext().getString(R.string.interphone_channel_type_analog) + InterPhoneChannelFragment.this.channels.get(i).number);
                }
            } else {
                viewHolder.mTvListTitle.setText(InterPhoneChannelFragment.this.channels.get(i).name);
            }
            TextView textView3 = viewHolder.mTvListTX;
            textView3.setText("tx: " + InterPhoneChannelFragment.this.channels.get(i).txFreq);
            TextView textView4 = viewHolder.mTvListRX;
            textView4.setText("rx: " + InterPhoneChannelFragment.this.channels.get(i).rxFreq);
            if (InterPhoneChannelFragment.this.mCurrentSelected == i) {
                viewHolder.mImgListSelect.setVisibility(0);
            } else {
                viewHolder.mImgListSelect.setVisibility(8);
            }
            return view2;
        }

        /* loaded from: classes4.dex */
        class ViewHolder {
            private ImageView mImgListSelect;
            private TextView mTvListRX;
            private TextView mTvListTX;
            private TextView mTvListTitle;

            ViewHolder() {
            }
        }
    }

    private void showDialog(boolean z, int i) {
        View inflate = LayoutInflater.from(getActivity()).inflate(R.layout.local_device_area_dialog, (ViewGroup) null);
        TextView textView = (TextView) inflate.findViewById(R.id.local_device_area_dialog_use);
        textView.setOnClickListener(this);
        ((TextView) inflate.findViewById(R.id.local_device_area_dialog_edit)).setOnClickListener(this);
        TextView textView2 = (TextView) inflate.findViewById(R.id.local_device_area_dialog_delete);
        textView2.setOnClickListener(this);
        TextView textView3 = (TextView) inflate.findViewById(R.id.local_device_area_dialog_reset);
        textView3.setOnClickListener(this);
        if (z) {
            textView.setVisibility(8);
            textView2.setVisibility(8);
            textView3.setVisibility(8);
        } else {
            textView.setVisibility(0);
            textView2.setVisibility(0);
            textView3.setVisibility(8);
        }
        Dialog dialog = new Dialog(getActivity());
        this.mDialog = dialog;
        dialog.setContentView(inflate);
        setDialogWindowLayoutParams(this.mDialog);
        this.mDialog.show();
    }

    private void setDialogWindowLayoutParams(Dialog dialog) {
        int i = PrizeInterPhoneApp.getContext().getResources().getDisplayMetrics().widthPixels;
        Window window = dialog.getWindow();
        WindowManager.LayoutParams attributes = window.getAttributes();
        attributes.gravity = 80;
        attributes.y = 60;
        attributes.width = (int) (i * 0.9f);
        window.setAttributes(attributes);
        window.setBackgroundDrawableResource(17170445);
    }

    private void dismissDialog() {
        Dialog dialog = this.mDialog;
        if (dialog != null) {
            dialog.dismiss();
            this.mDialog = null;
        }
    }

    @Override // android.view.View.OnClickListener
    public void onClick(View view) {
        if (isTalkSend()) {
            return;
        }
        switch (view.getId()) {
            case R.id.local_device_area_dialog_delete /* 2131296625 */:
                dismissDialog();
                if (Util.isMonkeyRunning()) {
                    Log.d(TAG, "monkey is running, not let delete the channel");
                    return;
                }
                String name = this.channels.get(this.mCurrentClickPosition).getName();
                if (name == null || "".equals(name)) {
                    if (this.channels.get(this.mCurrentClickPosition).type == 0) {
                        name = getString(R.string.interphone_channel_type_digital) + this.channels.get(this.mCurrentClickPosition).number;
                    } else {
                        name = getString(R.string.interphone_channel_type_analog) + this.channels.get(this.mCurrentClickPosition).number;
                    }
                }
                String string = getString(R.string.interphone_delete_channel_dialog_info, name);
                AlertDialog alertDialog = this.deleteDialog;
                if (alertDialog == null) {
                    createDeleteDialog(string);
                } else {
                    alertDialog.setMessage(string);
                }
                this.deleteDialog.show();
                return;
            case R.id.local_device_area_dialog_edit /* 2131296626 */:
                dismissDialog();
                if (Util.isMonkeyRunning()) {
                    Log.d(TAG, "monkey is running, not let edit the channel");
                    return;
                }
                Intent intent = new Intent(getActivity(), InterPhoneChannelActivity.class);
                intent.putExtra("edit", true);
                intent.putExtra("channelId", this.channels.get(this.mCurrentClickPosition).getId());
                intent.putExtra("currentAreaId", PersonSharePrefData.getStringData(PrizeInterPhoneApp.getContext(), "pref_person_channel_area_selected_index", Constants.KEY_DEF_AREA));
                startActivityForResult(intent, 1005);
                return;
            case R.id.local_device_area_dialog_reset /* 2131296627 */:
            default:
                return;
            case R.id.local_device_area_dialog_use /* 2131296628 */:
                dismissDialog();
                if (Util.isMonkeyRunning()) {
                    Log.d(TAG, "monkey is running, not let use the channel");
                    return;
                } else {
                    saveData();
                    return;
                }
        }
    }

    private void saveData() {
        if (CmdStateMachine.getInstance().getCurrentState() == CmdStateMachine.getInstance().getSetChannelState()) {
            Log.d(TAG, "saveData is setting channel...");
            return;
        }
        showProgressDialog(getString(R.string.interphone_channel_change_dialog_title));
        if (this.messageListener == null) {
            this.messageListener = new AnonymousClass2();
        }
        DmrManager.getInstance().registerEventListener(Const.Command.SET_DIGITAL_INFO_CMD, this.messageListener);
        DmrManager.getInstance().registerEventListener(Const.Command.SET_ANALOG_INFO_CMD, this.messageListener);
        DmrManager.getInstance().syncChannelInfoWithData(this.channels.get(this.mCurrentClickPosition));
        this.mHandler.postDelayed(this.mDismissRunnable, LaunchConfig.ACTIVITY_CONSIDERED_RESUME);
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    /* renamed from: com.pri.prizeinterphone.fragment.InterPhoneChannelFragment$2  reason: invalid class name */
    /* loaded from: classes4.dex */
    public class AnonymousClass2 implements DmrManager.MessageListener {
        AnonymousClass2() {
        }

        @Override // com.pri.prizeinterphone.manager.DmrManager.MessageListener
        public void errorEvent(Byte b) {
            if (b.byteValue() == 34 || b.byteValue() == 35) {
                InterPhoneChannelFragment interPhoneChannelFragment = InterPhoneChannelFragment.this;
                interPhoneChannelFragment.mHandler.post(interPhoneChannelFragment.mDismissRunnable);
                Snackbar.make(InterPhoneChannelFragment.this.mLocalView, (int) R.string.operate_fail, 0).show();
                DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_DIGITAL_INFO_CMD), InterPhoneChannelFragment.this.messageListener);
                DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_ANALOG_INFO_CMD), InterPhoneChannelFragment.this.messageListener);
            }
        }

        @Override // com.pri.prizeinterphone.manager.DmrManager.MessageListener
        public void dealEvent(BaseMessage baseMessage) {
            byte b = baseMessage.packet.cmd;
            if (b == 34 || b == 35) {
                InterPhoneChannelFragment interPhoneChannelFragment = InterPhoneChannelFragment.this;
                ChannelData channelData = interPhoneChannelFragment.channels.get(interPhoneChannelFragment.mCurrentSelected);
                channelData.setActive(0);
                InterPhoneChannelFragment.this.dbChannelHelper.updateChannel(channelData);
                InterPhoneChannelFragment interPhoneChannelFragment2 = InterPhoneChannelFragment.this;
                interPhoneChannelFragment2.mCurrentSelected = interPhoneChannelFragment2.mCurrentClickPosition;
                InterPhoneChannelFragment interPhoneChannelFragment3 = InterPhoneChannelFragment.this;
                ChannelData channelData2 = interPhoneChannelFragment3.channels.get(interPhoneChannelFragment3.mCurrentClickPosition);
                channelData2.setActive(1);
                InterPhoneChannelFragment.this.dbChannelHelper.updateChannel(channelData2);
                DmrManager.getInstance().updateChannelList();
                InterPhoneChannelFragment.this.channels = DmrManager.getInstance().getChannelList();
                DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_DIGITAL_INFO_CMD), InterPhoneChannelFragment.this.messageListener);
                DmrManager.getInstance().unregisterEventListener(Byte.valueOf((byte) Const.Command.SET_ANALOG_INFO_CMD), InterPhoneChannelFragment.this.messageListener);
                InterPhoneChannelFragment interPhoneChannelFragment4 = InterPhoneChannelFragment.this;
                interPhoneChannelFragment4.mHandler.post(interPhoneChannelFragment4.mDismissRunnable);
                InterPhoneChannelFragment.this.mHandler.post(new Runnable() { // from class: com.pri.prizeinterphone.fragment.InterPhoneChannelFragment$2$$ExternalSyntheticLambda0
                    @Override // java.lang.Runnable
                    public final void run() {
                        InterPhoneChannelFragment.AnonymousClass2.this.lambda$dealEvent$0();
                    }
                });
            }
        }

        /* JADX INFO: Access modifiers changed from: private */
        public /* synthetic */ void lambda$dealEvent$0() {
            InterPhoneChannelFragment.this.updateAdapter();
        }
    }

    public void updateAdapter() {
        DeviceAreaListAdapter deviceAreaListAdapter = this.mDeviceAreaListAdapter;
        if (deviceAreaListAdapter != null) {
            deviceAreaListAdapter.notifyDataSetChanged();
        }
    }

    @Override // androidx.fragment.app.Fragment
    public void onResume() {
        super.onResume();
        Clog.d(TAG, "onResume");
        initData();
    }

    @Override // androidx.fragment.app.Fragment
    public void onDestroy() {
        super.onDestroy();
        DmrManager.getInstance().unregisterUpdateListener(this);
    }

    private void createDeleteDialog(String str) {
        this.deleteDialog = new AlertDialog.Builder(getActivity()).setTitle(getString(R.string.interphone_delete_channel_dialog_title)).setMessage(str).setNegativeButton(getString(17039360), new DialogInterface.OnClickListener() { // from class: com.pri.prizeinterphone.fragment.InterPhoneChannelFragment.4
            @Override // android.content.DialogInterface.OnClickListener
            public void onClick(DialogInterface dialogInterface, int i) {
                InterPhoneChannelFragment.this.deleteDialog.dismiss();
            }
        }).setPositiveButton(getString(17039370), new DialogInterface.OnClickListener() { // from class: com.pri.prizeinterphone.fragment.InterPhoneChannelFragment.3
            @Override // android.content.DialogInterface.OnClickListener
            public void onClick(DialogInterface dialogInterface, int i) {
                if (!InterPhoneChannelFragment.this.isTalkSend()) {
                    DmrManager dmrManager = DmrManager.getInstance();
                    InterPhoneChannelFragment interPhoneChannelFragment = InterPhoneChannelFragment.this;
                    dmrManager.deleteChannel(interPhoneChannelFragment.channels.get(interPhoneChannelFragment.mCurrentClickPosition));
                    InterPhoneChannelFragment.this.channels = DmrManager.getInstance().getChannelList();
                    InterPhoneChannelFragment.this.updateAdapter();
                }
                InterPhoneChannelFragment.this.deleteDialog.dismiss();
            }
        }).create();
    }

    private void showToast(int i) {
        Toast toast = this.mToast;
        if (toast != null) {
            toast.cancel();
        }
        Toast makeText = Toast.makeText(getActivity(), i, 0);
        this.mToast = makeText;
        makeText.show();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public boolean isTalkSend() {
        boolean z = PersonSharePrefData.getIntData(getActivity(), PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1;
        if (z) {
            showToast(R.string.interphone_talk_send_status_toast);
        }
        return z;
    }
}
