package com.mediatek.widget;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import java.util.List;

public class AccountViewAdapter extends BaseAdapter {
    private Context mContext;
    private List<AccountElements> mData;

    public long getItemId(int i) {
        return (long) i;
    }

    public AccountViewAdapter(Context context, List<AccountElements> list) {
        this.mContext = context;
        this.mData = list;
    }

    public int getCount() {
        return this.mData.size();
    }

    public Object getItem(int i) {
        return this.mData.get(i);
    }

    public void updateData(List<AccountElements> list) {
        this.mData = list;
        notifyDataSetChanged();
    }

    public View getView(int i, View view, ViewGroup viewGroup) {
        AccountItemView accountItemView;
        if (view == null) {
            accountItemView = new AccountItemView(this.mContext);
        } else {
            accountItemView = (AccountItemView) view;
        }
        accountItemView.setViewItem((AccountElements) getItem(i));
        return accountItemView;
    }

    public static class AccountElements {
        private Drawable mDrawable;
        private int mIcon;
        private String mName;
        private String mNumber;

        public AccountElements(int i, String str, String str2) {
            this(i, (Drawable) null, str, str2);
        }

        public AccountElements(Drawable drawable, String str, String str2) {
            this(0, drawable, str, str2);
        }

        private AccountElements(int i, Drawable drawable, String str, String str2) {
            this.mIcon = i;
            this.mDrawable = drawable;
            this.mName = str;
            this.mNumber = str2;
        }

        public int getIcon() {
            return this.mIcon;
        }

        public String getName() {
            return this.mName;
        }

        public String getNumber() {
            return this.mNumber;
        }

        public Drawable getDrawable() {
            return this.mDrawable;
        }
    }
}
