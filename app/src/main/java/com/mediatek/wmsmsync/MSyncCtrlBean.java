package com.mediatek.wmsmsync;

import java.util.ArrayList;
import java.util.List;

public class MSyncCtrlBean {
    private List<ActivityBean> mActivityBeans;
    private float mFps;
    private float mImeFps;
    private String mPackageName;
    private boolean mSlideResponse;
    private float mVoiceFps;

    public String getPackageName() {
        return this.mPackageName;
    }

    public void setPackageName(String str) {
        this.mPackageName = str;
    }

    public List<ActivityBean> getActivityBeans() {
        if (this.mActivityBeans == null) {
            this.mActivityBeans = new ArrayList();
        }
        return this.mActivityBeans;
    }

    public void setActivityBeans(List<ActivityBean> list) {
        this.mActivityBeans = list;
    }

    public float getImeFps() {
        return this.mImeFps;
    }

    public void setImeFps(float f) {
        this.mImeFps = f;
    }

    public boolean isSlideResponse() {
        return this.mSlideResponse;
    }

    public void setSlideResponse(boolean z) {
        this.mSlideResponse = z;
    }

    public float getFps() {
        return this.mFps;
    }

    public void setFps(float f) {
        this.mFps = f;
    }

    public float getVoiceFps() {
        return this.mVoiceFps;
    }

    public void setVoiceFps(float f) {
        this.mVoiceFps = f;
    }

    public static class ActivityBean {
        private float mFps;
        private float mImeFps;
        private String mName;
        private float mVoiceFps;

        public String toString() {
            return "ActivityBean{name='" + this.mName + '\'' + ", fps=" + this.mFps + ", imeFps=" + this.mImeFps + ", voiceFps=" + this.mVoiceFps + '}';
        }

        public float getImeFps() {
            return this.mImeFps;
        }

        public void setImeFps(float f) {
            this.mImeFps = f;
        }

        public String getName() {
            return this.mName;
        }

        public void setName(String str) {
            this.mName = str;
        }

        public float getFps() {
            return this.mFps;
        }

        public void setFps(float f) {
            this.mFps = f;
        }

        public float getVoiceFps() {
            return this.mVoiceFps;
        }

        public void setVoiceFps(float f) {
            this.mVoiceFps = f;
        }
    }

    public String toString() {
        return "MSyncCtrlTableBean{packageName='" + this.mPackageName + '\'' + ", activityBeans=" + this.mActivityBeans + ", slideResponse=" + this.mSlideResponse + ", defaultFps=" + this.mFps + ", imeFps=" + this.mImeFps + ", voiceFps=" + this.mVoiceFps + '}';
    }
}
