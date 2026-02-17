package com.mediatek.widget;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.mediatek.internal.R;
import com.mediatek.widget.AccountViewAdapter;

public class AccountItemView extends LinearLayout {
    private ImageView mAccountIcon;
    private TextView mAccountName;
    private TextView mAccountNumber;

    public AccountItemView(Context context) {
        this(context, (AttributeSet) null);
    }

    public AccountItemView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        View inflate = ((LayoutInflater) context.getSystemService("layout_inflater")).inflate(R.layout.simple_account_item, (ViewGroup) null);
        addView(inflate);
        initViewItem(inflate);
    }

    private void initViewItem(View view) {
        this.mAccountIcon = (ImageView) view.findViewById(16908294);
        this.mAccountName = (TextView) view.findViewById(16908310);
        this.mAccountNumber = (TextView) view.findViewById(16908304);
    }

    public void setViewItem(AccountViewAdapter.AccountElements accountElements) {
        Drawable drawable = accountElements.getDrawable();
        if (drawable != null) {
            setAccountIcon(drawable);
        } else {
            setAccountIcon(accountElements.getIcon());
        }
        setAccountName(accountElements.getName());
        setAccountNumber(accountElements.getNumber());
    }

    public void setAccountIcon(int i) {
        this.mAccountIcon.setImageResource(i);
    }

    public void setAccountIcon(Drawable drawable) {
        this.mAccountIcon.setBackgroundDrawable(drawable);
    }

    public void setAccountName(String str) {
        setText(this.mAccountName, str);
    }

    public void setAccountNumber(String str) {
        setText(this.mAccountNumber, str);
    }

    private void setText(TextView textView, String str) {
        if (TextUtils.isEmpty(str)) {
            textView.setVisibility(8);
            return;
        }
        textView.setText(str);
        textView.setVisibility(0);
    }
}
