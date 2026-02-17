package com.android.internal.telephony.cat;

import android.compat.annotation.UnsupportedAppUsage;
import android.graphics.Bitmap;

public class SelectItemParams extends CommandParams {
    boolean mLoadTitleIcon;
    Menu mMenu;

    @UnsupportedAppUsage(maxTargetSdk = 30, trackingBug = 170729553)
    public SelectItemParams(CommandDetails commandDetails, Menu menu, boolean z) {
        super(commandDetails);
        this.mMenu = menu;
        this.mLoadTitleIcon = z;
    }

    /* access modifiers changed from: package-private */
    public boolean setIcon(Bitmap bitmap) {
        Menu menu;
        if (bitmap == null || (menu = this.mMenu) == null) {
            return false;
        }
        if (!this.mLoadTitleIcon || menu.titleIcon != null) {
            for (Item next : menu.items) {
                if (next.icon == null) {
                    next.icon = bitmap;
                    return true;
                }
            }
            return true;
        }
        menu.titleIcon = bitmap;
        return true;
    }
}
