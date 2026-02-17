package com.google.android.material.bottomnavigation;

import android.content.Context;
import androidx.annotation.DimenRes;
import androidx.annotation.LayoutRes;
import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;
import com.google.android.material.R;
import com.google.android.material.navigation.NavigationBarItemView;

@RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
public class BottomNavigationItemView extends NavigationBarItemView {
    public BottomNavigationItemView(@NonNull Context context) {
        super(context);
    }

    /* access modifiers changed from: protected */
    @LayoutRes
    public int getItemLayoutResId() {
        return R.layout.design_bottom_navigation_item;
    }

    /* access modifiers changed from: protected */
    @DimenRes
    public int getItemDefaultMarginResId() {
        return R.dimen.design_bottom_navigation_margin;
    }
}
