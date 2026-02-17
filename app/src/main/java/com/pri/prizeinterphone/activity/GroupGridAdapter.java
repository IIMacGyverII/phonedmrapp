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

public class GroupGridAdapter extends BaseAdapter {
    private static final String TAG = "GroupGridAdapter";
    /* access modifiers changed from: private */
    public InterPhoneChannelActivity activity;
    public int[] grouplist = new int[32];
    private LayoutInflater inflater;

    public GroupGridAdapter(InterPhoneChannelActivity interPhoneChannelActivity, int[] iArr) {
        Log.d(TAG, "GroupGridAdapter()");
        this.activity = interPhoneChannelActivity;
        this.inflater = LayoutInflater.from(interPhoneChannelActivity);
        this.grouplist = iArr;
        Log.d(TAG, "GroupGridAdapter()");
    }

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

    public Object getItem(int i) {
        Log.d(TAG, "getItem()");
        return Integer.valueOf(this.grouplist[i]);
    }

    public long getItemId(int i) {
        Log.d(TAG, "getItemId()");
        return (long) i;
    }

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
        EditText r0 = viewHolder.editText;
        r0.setText(this.grouplist[i] + "");
        viewHolder.editText.setInputType(2);
        viewHolder.editText.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            public void onFocusChange(View view, boolean z) {
                if (z) {
                    GroupGridAdapter.this.activity.updateSelectedItem(R.id.interphone_channel_group_number_set);
                }
            }
        });
        viewHolder.editText.addTextChangedListener(new TextWatcher() {
            public void beforeTextChanged(CharSequence charSequence, int i, int i2, int i3) {
            }

            public void onTextChanged(CharSequence charSequence, int i, int i2, int i3) {
            }

            public void afterTextChanged(Editable editable) {
                if (editable != null && !editable.toString().equals("")) {
                    GroupGridAdapter.this.updateData(i, Integer.parseInt(editable.toString()));
                }
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

    private class ViewHolder {
        /* access modifiers changed from: private */
        public EditText editText;

        private ViewHolder() {
        }
    }
}
