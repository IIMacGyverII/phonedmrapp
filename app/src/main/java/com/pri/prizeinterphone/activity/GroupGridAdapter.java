package com.pri.prizeinterphone.activity;

import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import com.pri.prizeinterphone.R;
import java.util.Arrays;
/* loaded from: classes4.dex */
public class GroupGridAdapter extends BaseAdapter {
    private static final String TAG = "GroupGridAdapter";
    private InterPhoneChannelActivity activity;
    public int[] grouplist;
    private LayoutInflater inflater;

    public GroupGridAdapter(InterPhoneChannelActivity interPhoneChannelActivity, int[] iArr) {
        this.grouplist = new int[32];
        Log.d(TAG, "GroupGridAdapter()");
        this.activity = interPhoneChannelActivity;
        this.inflater = LayoutInflater.from(interPhoneChannelActivity);
        this.grouplist = iArr;
        Log.d(TAG, "GroupGridAdapter()");
    }

    @Override // android.widget.Adapter
    public int getCount() {
        if (this.grouplist == null) {
            int[] iArr = new int[32];
            this.grouplist = iArr;
            Arrays.fill(iArr, 0);
            this.grouplist[0] = 1;
        }
        Log.d(TAG, "getCount()");
        return this.grouplist.length;
    }

    @Override // android.widget.Adapter
    public Object getItem(int i) {
        Log.d(TAG, "getItem()");
        return Integer.valueOf(this.grouplist[i]);
    }

    @Override // android.widget.Adapter
    public long getItemId(int i) {
        Log.d(TAG, "getItemId()");
        return i;
    }

    @Override // android.widget.Adapter
    public View getView(final int i, View view, ViewGroup viewGroup) {
        View view2;
        ViewHolder viewHolder;
        Log.d(TAG, "getView()");
        if (view == null) {
            viewHolder = new ViewHolder();
            view2 = this.inflater.inflate(R.layout.interphone_channel_group_item, viewGroup, false);
            viewHolder.editText = (EditText) view2.findViewById(R.id.interphone_channel_group_number_set);
            view2.setTag(viewHolder);
        } else {
            view2 = view;
            viewHolder = (ViewHolder) view.getTag();
        }
        EditText editText = viewHolder.editText;
        editText.setText(this.grouplist[i] + "");
        viewHolder.editText.setInputType(2);
        viewHolder.editText.setOnFocusChangeListener(new View.OnFocusChangeListener() { // from class: com.pri.prizeinterphone.activity.GroupGridAdapter.1
            @Override // android.view.View.OnFocusChangeListener
            public void onFocusChange(View view3, boolean z) {
                if (z) {
                    GroupGridAdapter.this.activity.updateSelectedItem(R.id.interphone_channel_group_number_set);
                }
            }
        });
        viewHolder.editText.addTextChangedListener(new TextWatcher() { // from class: com.pri.prizeinterphone.activity.GroupGridAdapter.2
            @Override // android.text.TextWatcher
            public void beforeTextChanged(CharSequence charSequence, int i2, int i3, int i4) {
            }

            @Override // android.text.TextWatcher
            public void onTextChanged(CharSequence charSequence, int i2, int i3, int i4) {
            }

            @Override // android.text.TextWatcher
            public void afterTextChanged(Editable editable) {
                if (editable == null || editable.toString().equals("")) {
                    return;
                }
                GroupGridAdapter.this.updateData(i, Integer.parseInt(editable.toString()));
            }
        });
        return view2;
    }

    public void updateData(int i, int i2) {
        this.grouplist[i] = i2;
    }

    public int[] getGroupList() {
        return this.grouplist;
    }

    /* loaded from: classes4.dex */
    private class ViewHolder {
        private EditText editText;

        private ViewHolder() {
        }
    }
}
