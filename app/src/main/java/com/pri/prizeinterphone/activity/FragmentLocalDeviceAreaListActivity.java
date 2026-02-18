package com.pri.prizeinterphone.activity;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.Util.Util;
import com.pri.prizeinterphone.constant.Constants;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.serial.data.ChannelData;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import com.pri.prizeinterphone.serial.data.UtilChannelData;
import java.util.ArrayList;
import java.util.List;
/* loaded from: classes4.dex */
public class FragmentLocalDeviceAreaListActivity extends AppCompatActivity implements AdapterView.OnItemClickListener, View.OnClickListener {
    public static final int REQUEST_EDIT_CHANNEL = 1005;
    private static final String TAG = "FragmentLocalDeviceAreaListActivity";
    private UtilChannelData dbChannelHelper;
    private AlertDialog deleteDialog;
    private Button mAdd;
    private int mCurrentClickPosition;
    private int mCurrentSelected;
    private ArrayList<String> mDeviceAreaDataList;
    private DeviceAreaListAdapter mDeviceAreaListAdapter;
    private Dialog mDialog;
    private ListView mListView;
    private TextView mTitle;
    private Toast mToast;
    private String mSeletedChannelIndex = Constants.KEY_DEF_AREA;
    public List<ChannelData> channels = new ArrayList();

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, androidx.activity.ComponentActivity, androidx.core.app.ComponentActivity, android.app.Activity
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView(R.layout.fragment_local_device_area_list_activity);
        initView();
        initData();
    }

    private void initView() {
        ListView listView = (ListView) findViewById(R.id.local_device_area_list);
        this.mListView = listView;
        listView.setOnItemClickListener(this);
        this.mTitle = (TextView) findViewById(R.id.fragment_local_device_area_list_title);
        Button button = (Button) findViewById(R.id.local_device_area_add);
        this.mAdd = button;
        button.setOnClickListener(this);
    }

    private void initData() {
        Intent intent = getIntent();
        this.mSeletedChannelIndex = intent.getStringExtra("selectedId");
        this.mTitle.setText(intent.getStringExtra("title"));
        UtilChannelData currentDb = DmrManager.getInstance().getInitChannelDataDB().getCurrentDb(this.mSeletedChannelIndex);
        this.dbChannelHelper = currentDb;
        this.channels = currentDb.getAllChannels();
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
        DeviceAreaListAdapter deviceAreaListAdapter = new DeviceAreaListAdapter(this);
        this.mDeviceAreaListAdapter = deviceAreaListAdapter;
        this.mListView.setAdapter((ListAdapter) deviceAreaListAdapter);
        this.mListView.setChoiceMode(1);
    }

    @Override // androidx.activity.ComponentActivity, android.app.Activity
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu, menu);
        return true;
    }

    private void showDialog(boolean z, int i) {
        View inflate = LayoutInflater.from(this).inflate(R.layout.local_device_area_dialog, (ViewGroup) null);
        TextView textView = (TextView) inflate.findViewById(R.id.local_device_area_dialog_use);
        textView.setOnClickListener(this);
        ((TextView) inflate.findViewById(R.id.local_device_area_dialog_edit)).setOnClickListener(this);
        TextView textView2 = (TextView) inflate.findViewById(R.id.local_device_area_dialog_delete);
        textView2.setOnClickListener(this);
        TextView textView3 = (TextView) inflate.findViewById(R.id.local_device_area_dialog_reset);
        textView3.setOnClickListener(this);
        if (z) {
            if (this.channels.get(i).active == 1) {
                textView2.setVisibility(8);
            }
            textView.setVisibility(8);
            textView3.setVisibility(8);
        } else {
            textView.setVisibility(0);
            textView2.setVisibility(0);
            textView3.setVisibility(0);
        }
        Dialog dialog = new Dialog(this);
        this.mDialog = dialog;
        dialog.setContentView(inflate);
        setDialogWindowLayoutParams(this.mDialog);
        this.mDialog.show();
    }

    @Override // androidx.appcompat.app.AppCompatActivity, androidx.fragment.app.FragmentActivity, android.app.Activity, android.content.ComponentCallbacks
    public void onConfigurationChanged(@NonNull Configuration configuration) {
        super.onConfigurationChanged(configuration);
        initData();
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, android.app.Activity
    public void onResume() {
        super.onResume();
        this.channels = this.dbChannelHelper.getAllChannels();
        this.mDeviceAreaListAdapter.notifyDataSetChanged();
    }

    private void setDialogWindowLayoutParams(Dialog dialog) {
        int i = getResources().getDisplayMetrics().widthPixels;
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

    private void updateListView() {
        this.mCurrentSelected = this.mCurrentClickPosition;
        this.mDeviceAreaListAdapter.notifyDataSetChanged();
    }

    @Override // android.widget.AdapterView.OnItemClickListener
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long j) {
        this.mCurrentClickPosition = i;
        showDialog(true, i);
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
            return FragmentLocalDeviceAreaListActivity.this.channels.size();
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
            if (FragmentLocalDeviceAreaListActivity.this.channels.get(i).name == null || FragmentLocalDeviceAreaListActivity.this.channels.get(i).name.equals("")) {
                if (FragmentLocalDeviceAreaListActivity.this.channels.get(i).type == 0) {
                    TextView textView = viewHolder.mTvListTitle;
                    textView.setText(FragmentLocalDeviceAreaListActivity.this.getString(R.string.interphone_channel_type_digital) + FragmentLocalDeviceAreaListActivity.this.channels.get(i).number);
                } else {
                    TextView textView2 = viewHolder.mTvListTitle;
                    textView2.setText(FragmentLocalDeviceAreaListActivity.this.getString(R.string.interphone_channel_type_analog) + FragmentLocalDeviceAreaListActivity.this.channels.get(i).number);
                }
            } else {
                viewHolder.mTvListTitle.setText(FragmentLocalDeviceAreaListActivity.this.channels.get(i).name);
            }
            TextView textView3 = viewHolder.mTvListTX;
            textView3.setText("tx: " + FragmentLocalDeviceAreaListActivity.this.channels.get(i).txFreq);
            TextView textView4 = viewHolder.mTvListRX;
            textView4.setText("rx: " + FragmentLocalDeviceAreaListActivity.this.channels.get(i).rxFreq);
            if (FragmentLocalDeviceAreaListActivity.this.mCurrentSelected == i) {
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

    @Override // androidx.activity.ComponentActivity, android.app.Activity
    public void onBackPressed() {
        super.onBackPressed();
    }

    @Override // android.view.View.OnClickListener
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.back_button /* 2131296340 */:
                onBackPressed();
                return;
            case R.id.local_device_area_add /* 2131296623 */:
                Intent intent = new Intent(this, InterPhoneChannelActivity.class);
                intent.putExtra("currentAreaId", this.mSeletedChannelIndex);
                startActivity(intent);
                return;
            case R.id.local_device_area_dialog_delete /* 2131296625 */:
                dismissDialog();
                if (Util.isMonkeyRunning()) {
                    Log.d(TAG, "monkey is running, not let delete channel");
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
                String string = getString(R.string.interphone_delete_channel_dialog_info, new Object[]{name});
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
                    Log.d(TAG, "monkey is running, not let edit channel");
                    return;
                }
                Intent intent2 = new Intent(this, InterPhoneChannelActivity.class);
                intent2.putExtra("edit", true);
                intent2.putExtra("channelId", this.channels.get(this.mCurrentClickPosition).getId());
                intent2.putExtra("currentAreaId", this.mSeletedChannelIndex);
                startActivityForResult(intent2, 1005);
                return;
            default:
                return;
        }
    }

    private void createDeleteDialog(String str) {
        this.deleteDialog = new AlertDialog.Builder(this).setTitle(getString(R.string.interphone_delete_channel_dialog_title)).setMessage(str).setNegativeButton(getString(17039360), new DialogInterface.OnClickListener() { // from class: com.pri.prizeinterphone.activity.FragmentLocalDeviceAreaListActivity.2
            @Override // android.content.DialogInterface.OnClickListener
            public void onClick(DialogInterface dialogInterface, int i) {
                FragmentLocalDeviceAreaListActivity.this.deleteDialog.dismiss();
            }
        }).setPositiveButton(getString(17039370), new DialogInterface.OnClickListener() { // from class: com.pri.prizeinterphone.activity.FragmentLocalDeviceAreaListActivity.1
            @Override // android.content.DialogInterface.OnClickListener
            public void onClick(DialogInterface dialogInterface, int i) {
                if (!FragmentLocalDeviceAreaListActivity.this.isTalkSend()) {
                    FragmentLocalDeviceAreaListActivity fragmentLocalDeviceAreaListActivity = FragmentLocalDeviceAreaListActivity.this;
                    if (fragmentLocalDeviceAreaListActivity.channels.get(fragmentLocalDeviceAreaListActivity.mCurrentClickPosition).getActive() == 0) {
                        DmrManager dmrManager = DmrManager.getInstance();
                        String str2 = FragmentLocalDeviceAreaListActivity.this.mSeletedChannelIndex;
                        FragmentLocalDeviceAreaListActivity fragmentLocalDeviceAreaListActivity2 = FragmentLocalDeviceAreaListActivity.this;
                        dmrManager.deleteChannel(str2, fragmentLocalDeviceAreaListActivity2.channels.get(fragmentLocalDeviceAreaListActivity2.mCurrentClickPosition));
                        FragmentLocalDeviceAreaListActivity.this.channels = DmrManager.getInstance().getChannelList(FragmentLocalDeviceAreaListActivity.this.mSeletedChannelIndex);
                        FragmentLocalDeviceAreaListActivity.this.mDeviceAreaListAdapter.notifyDataSetChanged();
                    } else {
                        FragmentLocalDeviceAreaListActivity.this.showToast(R.string.interphone_delete_channel_warning);
                    }
                }
                FragmentLocalDeviceAreaListActivity.this.deleteDialog.dismiss();
            }
        }).create();
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
        boolean z = PersonSharePrefData.getIntData(this, PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1;
        if (z) {
            showToast(R.string.interphone_talk_send_status_toast);
        }
        return z;
    }
}
