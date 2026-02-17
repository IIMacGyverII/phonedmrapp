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
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.message.BaseMessage;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.serial.data.ChannelData;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import com.pri.prizeinterphone.serial.data.UtilChannelData;
import com.pri.prizeinterphone.state.CmdStateMachine;
import java.util.ArrayList;
import java.util.List;

public class InterPhoneChannelFragment extends BaseViewPagerFragment implements AdapterView.OnItemClickListener, View.OnClickListener, DmrManager.UpdateListener {
    public static final int REQUEST_EDIT_CHANNEL = 1005;
    private static final String TAG = "InterPhoneChannelFragment";
    public List<ChannelData> channels = new ArrayList();
    /* access modifiers changed from: private */
    public UtilChannelData dbChannelHelper;
    /* access modifiers changed from: private */
    public AlertDialog deleteDialog;
    /* access modifiers changed from: private */
    public int mCurrentClickPosition;
    /* access modifiers changed from: private */
    public int mCurrentSelected;
    private DeviceAreaListAdapter mDeviceAreaListAdapter;
    private Dialog mDialog;
    private FragmentManager mFragmentManager;
    private ListView mListView;
    /* access modifiers changed from: private */
    public View mLocalView;
    private Toast mToast;
    private Runnable mUpdateChannelListRunnable = new Runnable() {
        public void run() {
            InterPhoneChannelFragment.this.initData();
        }
    };
    /* access modifiers changed from: private */
    public DmrManager.MessageListener messageListener;

    public String getMyTag() {
        return TAG;
    }

    public void initView(View view) {
        super.initView(view);
        View inflate = LayoutInflater.from(getContext()).inflate(R.layout.fragment_channel_view, (ViewGroup) null);
        this.mLocalView = inflate;
        this.mFragmentContainer.addView(inflate);
        this.mListView = (ListView) this.mLocalView.findViewById(R.id.fragment_channel_device_area_list);
        setAddButton(R.drawable.interphone_add_seletor);
        DmrManager.getInstance().registerUpdateListener(this);
    }

    /* access modifiers changed from: private */
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
            this.mListView.setAdapter(deviceAreaListAdapter);
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

    public void doAddAction() {
        super.doAddAction();
        if (!isTalkSend()) {
            Intent intent = new Intent(getActivity(), InterPhoneChannelActivity.class);
            intent.putExtra("currentAreaId", PersonSharePrefData.getStringData(PrizeInterPhoneApp.getContext(), "pref_person_channel_area_selected_index", Constants.KEY_DEF_AREA));
            getActivity().startActivity(intent);
        }
    }

    public void updateView() {
        super.updateView();
        this.channels = DmrManager.getInstance().getChannelList();
    }

    public void onItemClick(AdapterView<?> adapterView, View view, int i, long j) {
        if (!isTalkSend()) {
            this.mCurrentClickPosition = i;
            if (i == this.mCurrentSelected) {
                showDialog(true, i);
            } else {
                showDialog(false, i);
            }
        }
    }

    public void onConfigurationChanged(@NonNull Configuration configuration) {
        super.onConfigurationChanged(configuration);
        Dialog dialog = this.mDialog;
        if (dialog != null && dialog.isShowing()) {
            this.mDialog.dismiss();
            this.mDialog = null;
            int i = this.mCurrentClickPosition;
            showDialog(i == this.mCurrentSelected, i);
        }
    }

    public void updateTalkBackChannelList() {
        this.mHandler.post(this.mUpdateChannelListRunnable);
    }

    public void updateModuleInit() {
        Log.i(TAG, "updateModuleInit: ");
    }

    private class DeviceAreaListAdapter extends BaseAdapter {
        private Context mContext;

        public Object getItem(int i) {
            return null;
        }

        public long getItemId(int i) {
            return 0;
        }

        public DeviceAreaListAdapter(Context context) {
            this.mContext = context;
        }

        public int getCount() {
            return InterPhoneChannelFragment.this.channels.size();
        }

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
            if (InterPhoneChannelFragment.this.channels.get(i).name != null && !InterPhoneChannelFragment.this.channels.get(i).name.equals("")) {
                viewHolder.mTvListTitle.setText(InterPhoneChannelFragment.this.channels.get(i).name);
            } else if (InterPhoneChannelFragment.this.channels.get(i).type == 0) {
                TextView r0 = viewHolder.mTvListTitle;
                r0.setText(PrizeInterPhoneApp.getContext().getString(R.string.interphone_channel_type_digital) + InterPhoneChannelFragment.this.channels.get(i).number);
            } else {
                TextView r02 = viewHolder.mTvListTitle;
                r02.setText(PrizeInterPhoneApp.getContext().getString(R.string.interphone_channel_type_analog) + InterPhoneChannelFragment.this.channels.get(i).number);
            }
            TextView r03 = viewHolder.mTvListTX;
            r03.setText("tx: " + InterPhoneChannelFragment.this.channels.get(i).txFreq);
            TextView r04 = viewHolder.mTvListRX;
            r04.setText("rx: " + InterPhoneChannelFragment.this.channels.get(i).rxFreq);
            if (InterPhoneChannelFragment.this.mCurrentSelected == i) {
                viewHolder.mImgListSelect.setVisibility(0);
            } else {
                viewHolder.mImgListSelect.setVisibility(8);
            }
            return view2;
        }

        class ViewHolder {
            /* access modifiers changed from: private */
            public ImageView mImgListSelect;
            /* access modifiers changed from: private */
            public TextView mTvListRX;
            /* access modifiers changed from: private */
            public TextView mTvListTX;
            /* access modifiers changed from: private */
            public TextView mTvListTitle;

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
        attributes.width = (int) (((float) i) * 0.9f);
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

    public void onClick(View view) {
        if (!isTalkSend()) {
            switch (view.getId()) {
                case R.id.local_device_area_dialog_delete:
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
                case R.id.local_device_area_dialog_edit:
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
                case R.id.local_device_area_dialog_use:
                    dismissDialog();
                    if (Util.isMonkeyRunning()) {
                        Log.d(TAG, "monkey is running, not let use the channel");
                        return;
                    } else {
                        saveData();
                        return;
                    }
                default:
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
            this.messageListener = new DmrManager.MessageListener() {
                public void errorEvent(Byte b) {
                    if (b.byteValue() == 34 || b.byteValue() == 35) {
                        InterPhoneChannelFragment interPhoneChannelFragment = InterPhoneChannelFragment.this;
                        interPhoneChannelFragment.mHandler.post(interPhoneChannelFragment.mDismissRunnable);
                        Snackbar.make(InterPhoneChannelFragment.this.mLocalView, (int) R.string.operate_fail, 0).show();
                        DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_DIGITAL_INFO_CMD), InterPhoneChannelFragment.this.messageListener);
                        DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_ANALOG_INFO_CMD), InterPhoneChannelFragment.this.messageListener);
                    }
                }

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
                        DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_DIGITAL_INFO_CMD), InterPhoneChannelFragment.this.messageListener);
                        DmrManager.getInstance().unregisterEventListener(Byte.valueOf(Const.Command.SET_ANALOG_INFO_CMD), InterPhoneChannelFragment.this.messageListener);
                        InterPhoneChannelFragment interPhoneChannelFragment4 = InterPhoneChannelFragment.this;
                        interPhoneChannelFragment4.mHandler.post(interPhoneChannelFragment4.mDismissRunnable);
                        InterPhoneChannelFragment.this.mHandler.post(new InterPhoneChannelFragment$2$$ExternalSyntheticLambda0(this));
                    }
                }

                /* access modifiers changed from: private */
                public /* synthetic */ void lambda$dealEvent$0() {
                    InterPhoneChannelFragment.this.updateAdapter();
                }
            };
        }
        DmrManager.getInstance().registerEventListener(Const.Command.SET_DIGITAL_INFO_CMD, this.messageListener);
        DmrManager.getInstance().registerEventListener(Const.Command.SET_ANALOG_INFO_CMD, this.messageListener);
        DmrManager.getInstance().syncChannelInfoWithData(this.channels.get(this.mCurrentClickPosition));
        this.mHandler.postDelayed(this.mDismissRunnable, LaunchConfig.ACTIVITY_CONSIDERED_RESUME);
    }

    public void updateAdapter() {
        DeviceAreaListAdapter deviceAreaListAdapter = this.mDeviceAreaListAdapter;
        if (deviceAreaListAdapter != null) {
            deviceAreaListAdapter.notifyDataSetChanged();
        }
    }

    public void onResume() {
        super.onResume();
        Clog.d(TAG, "onResume");
        initData();
    }

    public void onDestroy() {
        super.onDestroy();
        DmrManager.getInstance().unregisterUpdateListener(this);
    }

    private void createDeleteDialog(String str) {
        this.deleteDialog = new AlertDialog.Builder(getActivity()).setTitle(getString(R.string.interphone_delete_channel_dialog_title)).setMessage(str).setNegativeButton(getString(17039360), new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogInterface, int i) {
                InterPhoneChannelFragment.this.deleteDialog.dismiss();
            }
        }).setPositiveButton(getString(17039370), new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogInterface, int i) {
                if (!InterPhoneChannelFragment.this.isTalkSend()) {
                    DmrManager instance = DmrManager.getInstance();
                    InterPhoneChannelFragment interPhoneChannelFragment = InterPhoneChannelFragment.this;
                    instance.deleteChannel(interPhoneChannelFragment.channels.get(interPhoneChannelFragment.mCurrentClickPosition));
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

    /* access modifiers changed from: private */
    public boolean isTalkSend() {
        boolean z = false;
        if (PersonSharePrefData.getIntData(getActivity(), PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1) {
            z = true;
        }
        if (z) {
            showToast(R.string.interphone_talk_send_status_toast);
        }
        return z;
    }
}
