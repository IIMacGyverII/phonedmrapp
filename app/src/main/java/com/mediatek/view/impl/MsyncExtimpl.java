package com.mediatek.view.impl;

import com.mediatek.appresolutiontuner.OpenMsyncAppList;
import com.mediatek.view.MsyncExt;

public class MsyncExtimpl extends MsyncExt {
    private static final String TAG = "MsyncExt";
    private boolean mIsContainPackageName = false;
    private String mPackageName;

    public MsyncExtimpl() {
        if (!OpenMsyncAppList.getInstance().isRead()) {
            openNewTread();
        }
    }

    private void openNewTread() {
        new Thread() {
            public void run() {
                OpenMsyncAppList.getInstance().loadOpenMsyncAppList();
            }
        }.start();
    }

    public boolean isOpenMsyncPackage(String str) {
        boolean isScaledBySurfaceView = OpenMsyncAppList.getInstance().isScaledBySurfaceView(str);
        this.mIsContainPackageName = isScaledBySurfaceView;
        return isScaledBySurfaceView;
    }
}
