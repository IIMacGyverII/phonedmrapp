package com.pri.prizeinterphone.widget;

import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;
import com.pri.prizeinterphone.R;
import java.util.ArrayList;

public class SpinerPopWindow extends PopupWindow implements AdapterView.OnItemClickListener {
    private PrizeSpinerAdapter mAdapter;
    /* access modifiers changed from: private */
    public Context mContext;
    /* access modifiers changed from: private */
    public String mCurrentSeleted;
    /* access modifiers changed from: private */
    public ArrayList<String> mDataList;
    private ListView mListView;
    private PrizeOnItemClickListener mPrizeOnItemClickListener;
    public boolean notShowSelect = false;

    public interface PrizeOnItemClickListener {
        void setOnItemClick(String str);
    }

    public static class ViewHolder {
        public ImageView mImgSeleted;
        public View mLine;
        public TextView mTvValue;
    }

    public SpinerPopWindow(Context context) {
        super(context);
        this.mContext = context;
        init();
    }

    private void init() {
        View inflate = LayoutInflater.from(this.mContext).inflate(R.layout.interphone_channel_spiner_window, (ViewGroup) null);
        setContentView(inflate);
        setWidth(-2);
        setHeight(-2);
        setFocusable(true);
        setBackgroundDrawable(new ColorDrawable(0));
        this.mListView = (ListView) inflate.findViewById(R.id.interphone_channel_listview);
        this.mDataList = new ArrayList<>();
        PrizeSpinerAdapter prizeSpinerAdapter = new PrizeSpinerAdapter(this.mContext);
        this.mAdapter = prizeSpinerAdapter;
        this.mListView.setAdapter(prizeSpinerAdapter);
        this.mListView.setOnItemClickListener(this);
    }

    public void setPrizeOnItemClickListener(PrizeOnItemClickListener prizeOnItemClickListener) {
        this.mPrizeOnItemClickListener = prizeOnItemClickListener;
    }

    public void refreshData(ArrayList<String> arrayList, String str) {
        this.mDataList = arrayList;
        this.mCurrentSeleted = str;
        this.mAdapter.notifyDataSetChanged();
    }

    public void onItemClick(AdapterView<?> adapterView, View view, int i, long j) {
        this.mPrizeOnItemClickListener.setOnItemClick(this.mDataList.get(i));
    }

    public boolean isNotShowSelect() {
        return this.notShowSelect;
    }

    public void setNotShowSelect(boolean z) {
        this.notShowSelect = z;
    }

    private class PrizeSpinerAdapter extends BaseAdapter {
        private LayoutInflater mInflater;

        public long getItemId(int i) {
            return (long) i;
        }

        public PrizeSpinerAdapter(Context context) {
            this.mInflater = (LayoutInflater) context.getSystemService("layout_inflater");
        }

        public int getCount() {
            return SpinerPopWindow.this.mDataList.size();
        }

        public Object getItem(int i) {
            return SpinerPopWindow.this.mDataList.get(i);
        }

        public View getView(int i, View view, ViewGroup viewGroup) {
            ViewHolder viewHolder;
            if (view == null) {
                view = this.mInflater.inflate(R.layout.interphone_channel_spiner_window_item, (ViewGroup) null);
                viewHolder = new ViewHolder();
                viewHolder.mTvValue = (TextView) view.findViewById(R.id.interphone_channel_spinner_value);
                viewHolder.mImgSeleted = (ImageView) view.findViewById(R.id.interphone_channel_spinner_selete);
                viewHolder.mLine = view.findViewById(R.id.interphone_channel_spinner_split);
                view.setTag(viewHolder);
            } else {
                viewHolder = (ViewHolder) view.getTag();
            }
            String str = (String) SpinerPopWindow.this.mDataList.get(i);
            viewHolder.mTvValue.setText(str);
            if (SpinerPopWindow.this.mCurrentSeleted == null || !SpinerPopWindow.this.mCurrentSeleted.equals(str)) {
                viewHolder.mImgSeleted.setSelected(false);
            } else {
                viewHolder.mImgSeleted.setSelected(true);
            }
            if (SpinerPopWindow.this.isNotShowSelect()) {
                viewHolder.mImgSeleted.setBackground(SpinerPopWindow.this.mContext.getDrawable(R.drawable.interphone_record_list_delete));
            }
            return view;
        }
    }
}
