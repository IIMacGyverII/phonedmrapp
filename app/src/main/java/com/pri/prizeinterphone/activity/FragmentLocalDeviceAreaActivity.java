package com.pri.prizeinterphone.activity;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
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
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import com.pri.prizeinterphone.R;
import com.pri.prizeinterphone.Util.Clog;
import com.pri.prizeinterphone.Util.Util;
import com.pri.prizeinterphone.constant.Constants;
import com.pri.prizeinterphone.manager.DmrManager;
import com.pri.prizeinterphone.serial.data.PersonSharePrefData;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.regex.Pattern;

public class FragmentLocalDeviceAreaActivity extends AppCompatActivity implements AdapterView.OnItemClickListener, View.OnClickListener {
    private static final String TAG = "FragmentLocalDeviceAreaActivity";
    /* access modifiers changed from: private */
    public AlertDialog deleteDialog;
    private Button mAdd;
    private Dialog mAddDialog;
    /* access modifiers changed from: private */
    public EditText mAddEdit;
    /* access modifiers changed from: private */
    public String mCurrentClickPosition;
    /* access modifiers changed from: private */
    public String mCurrentSelected;
    /* access modifiers changed from: private */
    public LinkedHashMap<String, String> mDeviceAreaDataList;
    private DeviceAreaListAdapter mDeviceAreaListAdapter;
    private Dialog mDialog;
    private ListView mListView;
    private Toast mToast;

    /* access modifiers changed from: protected */
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView((int) R.layout.fragment_local_device_area_activity);
        initView();
        initData();
    }

    private void initView() {
        ListView listView = (ListView) findViewById(R.id.local_device_area_list);
        this.mListView = listView;
        listView.setOnItemClickListener(this);
        Button button = (Button) findViewById(R.id.local_device_area_add);
        this.mAdd = button;
        button.setOnClickListener(this);
    }

    private void initData() {
        this.mDeviceAreaDataList = Constants.getSavedChannelAreas(this);
        this.mCurrentSelected = Constants.getSelectedChannelArea(this);
        Clog.d(TAG, "mCurrentSelected=" + this.mCurrentSelected);
        DeviceAreaListAdapter deviceAreaListAdapter = new DeviceAreaListAdapter(this, this.mDeviceAreaDataList);
        this.mDeviceAreaListAdapter = deviceAreaListAdapter;
        this.mListView.setAdapter(deviceAreaListAdapter);
        this.mListView.setChoiceMode(1);
        this.mListView.smoothScrollToPosition(getSelectedChannelAreaIndex(this.mCurrentSelected));
    }

    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu, menu);
        return true;
    }

    private int getSelectedChannelAreaIndex(String str) {
        return new ArrayList(this.mDeviceAreaDataList.keySet()).indexOf(str);
    }

    private void showAddDialog() {
        View inflate = LayoutInflater.from(this).inflate(R.layout.local_device_area_add_dialog, (ViewGroup) null);
        Dialog dialog = new Dialog(this);
        this.mAddDialog = dialog;
        dialog.setContentView(inflate);
        setDialogWindowLayoutParams(this.mAddDialog);
        this.mAddDialog.show();
        ((Button) inflate.findViewById(R.id.local_device_area_cancle)).setOnClickListener(this);
        ((Button) inflate.findViewById(R.id.local_device_area_ok)).setOnClickListener(this);
        EditText editText = (EditText) inflate.findViewById(R.id.local_device_area_edit);
        this.mAddEdit = editText;
        editText.addTextChangedListener(new TextWatcher() {
            public void beforeTextChanged(CharSequence charSequence, int i, int i2, int i3) {
            }

            public void onTextChanged(CharSequence charSequence, int i, int i2, int i3) {
            }

            public void afterTextChanged(Editable editable) {
                String obj = FragmentLocalDeviceAreaActivity.this.mAddEdit.getText().toString();
                String trim = Pattern.compile("[^a-zA-Z0-9一-龥]").matcher(obj).replaceAll("").trim();
                if (!obj.equals(trim)) {
                    FragmentLocalDeviceAreaActivity.this.mAddEdit.setText(trim);
                    EditText r2 = FragmentLocalDeviceAreaActivity.this.mAddEdit;
                    int i = 13;
                    if (trim.length() <= 13) {
                        i = trim.length();
                    }
                    r2.setSelection(i);
                }
            }
        });
    }

    public void onItemClick(AdapterView<?> adapterView, View view, int i, long j) {
        if (!isTalkSend()) {
            this.mCurrentClickPosition = this.mDeviceAreaListAdapter.getItem(i);
            Clog.d(TAG, "onItemClick,mCurrentClickPosition=" + this.mCurrentClickPosition);
            if (this.mCurrentSelected.equals(this.mCurrentClickPosition)) {
                showDialog(true, this.mCurrentClickPosition);
            } else {
                showDialog(false, this.mCurrentClickPosition);
            }
        }
    }

    private void showDialog(boolean z, String str) {
        View inflate = LayoutInflater.from(this).inflate(R.layout.local_device_area_dialog, (ViewGroup) null);
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
            if (Constants.DEF_CHANNEL_AREAS.containsKey(str)) {
                textView3.setVisibility(0);
            } else {
                textView3.setVisibility(8);
                if (DmrManager.getInstance().getInitChannelDataDB().getCurrentDb(str).getAllChannels().size() == 0) {
                    textView.setVisibility(8);
                }
            }
        }
        Dialog dialog = new Dialog(this);
        this.mDialog = dialog;
        dialog.setContentView(inflate);
        setDialogWindowLayoutParams(this.mDialog);
        this.mDialog.show();
    }

    private void setDialogWindowLayoutParams(Dialog dialog) {
        int i = getResources().getDisplayMetrics().widthPixels;
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

    /* access modifiers changed from: private */
    public void updateListView() {
        this.mDeviceAreaListAdapter.notifyDataSetChanged();
        this.mListView.smoothScrollToPosition(getSelectedChannelAreaIndex(this.mCurrentSelected));
    }

    private class DeviceAreaListAdapter extends BaseAdapter {
        private Context mContext;

        public long getItemId(int i) {
            return (long) i;
        }

        public DeviceAreaListAdapter(Context context, LinkedHashMap<String, String> linkedHashMap) {
            this.mContext = context;
        }

        public int getCount() {
            return FragmentLocalDeviceAreaActivity.this.mDeviceAreaDataList.size();
        }

        public String getItem(int i) {
            return (String) FragmentLocalDeviceAreaActivity.this.mDeviceAreaDataList.keySet().stream().toArray()[i];
        }

        public View getView(int i, View view, ViewGroup viewGroup) {
            View view2;
            ViewHolder viewHolder;
            if (view == null) {
                viewHolder = new ViewHolder();
                view2 = LayoutInflater.from(this.mContext).inflate(R.layout.fragment_local_device_area_list_item, (ViewGroup) null);
                viewHolder.mTvListTitle = (TextView) view2.findViewById(R.id.local_device_area_list_item_title);
                viewHolder.mImgListSelect = (ImageView) view2.findViewById(R.id.local_device_area_list_item_select);
                view2.setTag(viewHolder);
            } else {
                view2 = view;
                viewHolder = (ViewHolder) view.getTag();
            }
            viewHolder.mTvListTitle.setText(Constants.getChannelAreaName(this.mContext, FragmentLocalDeviceAreaActivity.this.mDeviceAreaDataList, getItem(i)));
            if (FragmentLocalDeviceAreaActivity.this.mCurrentSelected.equals(getItem(i))) {
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
            public TextView mTvListTitle;

            ViewHolder() {
            }
        }
    }

    public void onConfigurationChanged(@NonNull Configuration configuration) {
        super.onConfigurationChanged(configuration);
        Dialog dialog = this.mDialog;
        if (dialog != null && dialog.isShowing()) {
            this.mDialog.dismiss();
            this.mDialog = null;
            showDialog(this.mCurrentSelected.equals(this.mCurrentClickPosition), this.mCurrentClickPosition);
        }
        Dialog dialog2 = this.mAddDialog;
        if (dialog2 != null && dialog2.isShowing()) {
            this.mAddDialog.dismiss();
            this.mAddDialog = null;
            showAddDialog();
        }
    }

    public void onBackPressed() {
        super.onBackPressed();
    }

    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.back_button) {
            onBackPressed();
        } else if (id != R.id.local_device_area_ok) {
            switch (id) {
                case R.id.local_device_area_add /*2131296623*/:
                    if (!isTalkSend()) {
                        showAddDialog();
                        return;
                    }
                    return;
                case R.id.local_device_area_cancle /*2131296624*/:
                    Dialog dialog = this.mAddDialog;
                    if (dialog != null) {
                        dialog.dismiss();
                        this.mAddDialog = null;
                        return;
                    }
                    return;
                case R.id.local_device_area_dialog_delete /*2131296625*/:
                    dismissDialog();
                    if (!isTalkSend()) {
                        if (Util.isMonkeyRunning()) {
                            Log.d(TAG, "monkey is running, not let delete area");
                            return;
                        }
                        String string = getString(R.string.interphone_delete_channel_dialog_info, new Object[]{Constants.getChannelAreaName(this, this.mDeviceAreaDataList, this.mCurrentClickPosition)});
                        AlertDialog alertDialog = this.deleteDialog;
                        if (alertDialog == null) {
                            createDeleteDialog(string);
                        } else {
                            alertDialog.setMessage(string);
                        }
                        this.deleteDialog.show();
                        return;
                    }
                    return;
                case R.id.local_device_area_dialog_edit /*2131296626*/:
                    dismissDialog();
                    if (!isTalkSend()) {
                        if (Util.isMonkeyRunning()) {
                            Log.d(TAG, "monkey is running, not let edit area");
                            return;
                        }
                        Intent intent = new Intent(this, FragmentLocalDeviceAreaListActivity.class);
                        intent.putExtra("title", Constants.getChannelAreaName(getApplicationContext(), this.mCurrentClickPosition));
                        intent.putExtra("selectedId", this.mCurrentClickPosition);
                        startActivity(intent);
                        return;
                    }
                    return;
                case R.id.local_device_area_dialog_reset /*2131296627*/:
                    if (Util.isMonkeyRunning()) {
                        Log.d(TAG, "monkey is running, not let reset area");
                        return;
                    }
                    if (!isTalkSend()) {
                        DmrManager.getInstance().getInitChannelDataDB().resetChannelDataList(this.mCurrentClickPosition);
                    }
                    dismissDialog();
                    return;
                case R.id.local_device_area_dialog_use /*2131296628*/:
                    dismissDialog();
                    if (!isTalkSend()) {
                        if (Util.isMonkeyRunning()) {
                            Log.d(TAG, "monkey is running, not let use area");
                            return;
                        }
                        String str = this.mCurrentClickPosition;
                        this.mCurrentSelected = str;
                        Constants.saveSelectedChannelArea(this, str);
                        DmrManager.getInstance().updateChannelList();
                        DmrManager.getInstance().syncChannelInfo();
                        updateListView();
                        return;
                    }
                    return;
                default:
                    return;
            }
        } else {
            if (!isTalkSend()) {
                EditText editText = this.mAddEdit;
                if (editText == null || editText.getText().toString().isEmpty()) {
                    showToast(R.string.fragment_local_setting_device_id_dialog_edit_toast);
                } else {
                    String trim = Pattern.compile("[^a-zA-Z0-9一-龥]").matcher(this.mAddEdit.getText().toString()).replaceAll("").trim();
                    if (!this.mDeviceAreaDataList.values().stream().anyMatch(new FragmentLocalDeviceAreaActivity$$ExternalSyntheticLambda0(trim))) {
                        String randExtraChannelAreaName = Constants.randExtraChannelAreaName();
                        if (!DmrManager.getInstance().getInitChannelDataDB().isCheckDbName(randExtraChannelAreaName)) {
                            this.mDeviceAreaDataList.put(randExtraChannelAreaName, trim);
                            DmrManager.getInstance().getInitChannelDataDB().addChannelDataList(randExtraChannelAreaName, this.mDeviceAreaDataList);
                            updateListView();
                        } else {
                            showToast(R.string.fragment_local_setting_device_id_dialog_edit_reset_toast);
                        }
                    } else {
                        showToast(R.string.fragment_local_setting_device_id_dialog_edit_reset_toast);
                    }
                }
            }
            Dialog dialog2 = this.mAddDialog;
            if (dialog2 != null) {
                dialog2.dismiss();
                this.mAddDialog = null;
            }
        }
    }

    private void createDeleteDialog(String str) {
        this.deleteDialog = new AlertDialog.Builder(this).setTitle(getString(R.string.interphone_delete_area_dialog_title)).setMessage(str).setNegativeButton(getString(17039360), new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogInterface, int i) {
                FragmentLocalDeviceAreaActivity.this.deleteDialog.dismiss();
            }
        }).setPositiveButton(getString(17039370), new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialogInterface, int i) {
                if (!FragmentLocalDeviceAreaActivity.this.isTalkSend()) {
                    DmrManager.getInstance().getInitChannelDataDB().removeChannelDataList(FragmentLocalDeviceAreaActivity.this.mCurrentClickPosition);
                    FragmentLocalDeviceAreaActivity.this.mDeviceAreaDataList.remove(FragmentLocalDeviceAreaActivity.this.mCurrentClickPosition);
                    FragmentLocalDeviceAreaActivity.this.updateListView();
                }
                FragmentLocalDeviceAreaActivity.this.deleteDialog.dismiss();
            }
        }).create();
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

    /* access modifiers changed from: private */
    public boolean isTalkSend() {
        boolean z = false;
        if (PersonSharePrefData.getIntData(this, PersonSharePrefData.PREF_PERSON_SEND_STATUS, 0) == 1) {
            z = true;
        }
        if (z) {
            showToast(R.string.interphone_talk_send_status_toast);
        }
        return z;
    }
}
