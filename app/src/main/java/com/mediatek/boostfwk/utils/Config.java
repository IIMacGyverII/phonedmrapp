package com.mediatek.boostfwk.utils;

import android.os.SystemProperties;
import java.util.ArrayList;

public final class Config {
    private static final boolean BOOLEAN_BOOST_FWK_PRE_ANIMATION = (!"0".equals(SystemProperties.get(DISABLE_BOOST_FWK_PRE_ANIMATION_NAME)));
    private static final boolean BOOLEAN_DISABLE_BOOST_FWK = "0".equals(SystemProperties.get(DISABLE_BOOST_FWK_PROPERTY_NAME));
    private static final boolean BOOLEAN_DISABLE_BOOST_FWK_FRAME_PREFETCHER = (!"0".equals(SystemProperties.get(DISABLE_BOOST_FWK_FRAME_PREFETCHER_NAME)));
    private static final boolean BOOLEAN_DISABLE_FRAME_DECISION_WHEN_SCROLL = "0".equals(SystemProperties.get(BOOST_FWK_FRAME_DECISION_PROPERTY_NAME));
    private static final boolean BOOLEAN_DISABLE_FRAME_IDENTIFY = "0".equals(SystemProperties.get(DISABLE_FRAME_IDENTIFY_PROPERTY_NAME));
    private static final boolean BOOLEAN_DISABLE_SCROLL_IDENTIFY = (!"0".equals(SystemProperties.get(DISABLE_SCROLL_IDENTIFY_PROPERTY_NAME)));
    private static final boolean BOOLEAN_ENABLE_BOOST_DISPLAY_60 = (!"0".equals(SystemProperties.get(ENABLE_BOOST_DISPLAY_60_PROPERTY_NAME)));
    private static final boolean BOOLEAN_ENABLE_BOOST_FWK_TOUCH = (!"0".equals(SystemProperties.get(BOOST_FWK_TOUCH_PROPERTY_NAME)));
    private static final boolean BOOLEAN_ENABLE_FRAME_RESCUE = (!"0".equals(SystemProperties.get(FRAME_RESCUE_PROPERTY_NAME)));
    private static final boolean BOOLEAN_ENABLE_LOG = "1".equals(SystemProperties.get(ENHANCE_LOG_PROPERTY_NAME));
    private static final boolean BOOLEAN_ENABLE_MSYNC_MSYNC3 = "1".equals(SystemProperties.get(ENABLE_MSYNC3_NAME, USER_CONFIG_DEFAULT_VALUE));
    private static final boolean BOOLEAN_ENABLE_MSYNC_SMOOTHFLING_MSYNC3 = "1".equals(SystemProperties.get(ENABLE_MSYNC3_SMOOTHFLING_NAME, USER_CONFIG_DEFAULT_VALUE));
    private static final boolean BOOLEAN_ENABLE_SCROLL_COMMON_POLICY = (!"0".equals(SystemProperties.get(SCROLL_COMMON_POLICY_PROPERTY_NAME)));
    private static final String BOOST_FWK_FRAME_DECISION_PROPERTY_NAME = "vendor.boostfwk.frame.decision";
    private static final String BOOST_FWK_TOUCH_PROPERTY_NAME = "vendor.boostfwk.touch";
    private static final String BOOST_FWK_VERSION = "vendor.boostfwk.version";
    public static final int BOOST_FWK_VERSION_1 = 1;
    public static final int BOOST_FWK_VERSION_2 = 2;
    public static final int BOOST_FWK_VERSION_3 = 3;
    public static final String CONFIG_FPSGO_RELEASE_TIME = "vendor.scroll.fpsgo.release";
    private static final String DISABLE_BOOST_FWK = "0";
    private static final String DISABLE_BOOST_FWK_FRAME_PREFETCHER = "0";
    private static final String DISABLE_BOOST_FWK_FRAME_PREFETCHER_NAME = "vendor.boostfwk.frameprefetcher";
    private static final String DISABLE_BOOST_FWK_PRE_ANIMATION = "0";
    private static final String DISABLE_BOOST_FWK_PRE_ANIMATION_NAME = "vendor.boostfwk.preanimation";
    private static final String DISABLE_BOOST_FWK_PROPERTY_NAME = "vendor.boostfwk.option";
    private static final String DISABLE_BOOST_FWK_TOUCH = "0";
    private static final String DISABLE_FRAME_IDENTIFY = "0";
    private static final String DISABLE_FRAME_IDENTIFY_PROPERTY_NAME = "vendor.boostfwk.frameidentify.option";
    private static final String DISABLE_FRAME_RESCUE = "0";
    private static final String DISABLE_SCROLL_COMMON_POLICY = "0";
    private static final String DISABLE_SCROLL_IDENTIFY = "0";
    private static final String DISABLE_SCROLL_IDENTIFY_PROPERTY_NAME = "vendor.boostfwk.scrollidentify.option";
    private static final String ENABLE_BOOST_DISPLAY_60 = "0";
    private static final String ENABLE_BOOST_DISPLAY_60_PROPERTY_NAME = "vendor.boostfwk.display60";
    private static final String ENABLE_ENHANCE_LOG = "1";
    private static final String ENABLE_MSYNC3 = "1";
    private static final String ENABLE_MSYNC3_NAME = "vendor.msync3.enable";
    private static final String ENABLE_MSYNC3_SMOOTHFLING = "1";
    private static final String ENABLE_MSYNC3_SMOOTHFLING_NAME = "vendor.msync3.smoothfling";
    private static final String ENHANCE_LOG_PROPERTY_NAME = "vendor.boostfwk.log.enable";
    public static final int FEATURE_OPTION_NON_CHECK = -100;
    public static final int FEATURE_OPTION_OFF = 0;
    public static final int FEATURE_OPTION_ON = 1;
    public static final float FLING_DEFAULT_GAP_CHANGE_REFRESHRATE = 1.83f;
    public static final int FRAME_DECISION_MODE_DISABLE = 0;
    public static final int FRAME_DECISION_MODE_FOR_ALL = 1;
    public static final int FRAME_DECISION_MODE_FOR_SCROLLING = 2;
    public static final int FRAME_HINT_RESCUE_CHECK_POINT = 50;
    public static final int FRAME_HINT_RESCUE_STRENGTH = 50;
    private static final String FRAME_RESCUE_CHECK_POINT_PROPERTY_NAME = "vendor.boostfwk.rescue.checkpoint";
    private static final String FRAME_RESCUE_PROPERTY_NAME = "vendor.boostfwk.rescue";
    private static final String FRAME_SBE_HORIZONTAL_SCROLL_DURATION = "vendor.boostfwk.scroll.duration.h";
    private static final String FRAME_SBE_SBB_ENABLE_LATER = "vendor.boostfwk.sbb.touch.duration";
    private static final String FRAME_SBE_SCROLL_FREQ_FLOOR = "vendor.boostfwk.scroll.floor";
    private static final String FRAME_SBE_VERTICAL_SCROLL_DURATION = "vendor.boostfwk.scroll.duration.v";
    public static final ArrayList<String> FRAME_TRACKING_LIST = new ArrayList<String>() {
        {
            add("com.android.systemui");
        }
    };
    public static final String MSYNC3_FLING_REFRESHRATE_CHANGE_GAP = SystemProperties.get(MSYNC3_FLING_REFRESHRATE_GAT_NAME, USER_CONFIG_DEFAULT_VALUE);
    private static final String MSYNC3_FLING_REFRESHRATE_GAT_NAME = "vendor.msync3.flingrefreshrategap";
    public static final String MSYNC3_FLING_SUPPORT_REFRESHRATE = SystemProperties.get(MSYNC3_FLING_SUPPORT_REFRESHRATE_NAME, USER_CONFIG_DEFAULT_VALUE);
    private static final String MSYNC3_FLING_SUPPORT_REFRESHRATE_NAME = "vendor.msync3.flingrefreshrate";
    public static final String MSYNC3_TOUCHSCROLL_REFRESHRATE_SPEED_LOW = SystemProperties.get(MSYNC3_TOUCHSCROLL_REFRESHRATE_SPEED_LOW_NAME, USER_CONFIG_DEFAULT_VALUE);
    public static final String MSYNC3_TOUCHSCROLL_REFRESHRATE_SPEED_LOW_NAME = "vendor.msync3.touchscrolllow";
    public static final String MSYNC3_TOUCH_SCROLL_VELOCITY = SystemProperties.get(MSYNC3_TOUCH_SCROLL_VELOCITY_NAME, USER_CONFIG_DEFAULT_VALUE);
    public static final String MSYNC3_TOUCH_SCROLL_VELOCITY_NAME = "vendor.msync3.touchscrollvelocity";
    public static final String MSYNC3_VIDEO_FLOOR_FPS = SystemProperties.get(MSYNC3_VIDEO_FLOOR_FPS_NAME, USER_CONFIG_DEFAULT_VALUE);
    public static final String MSYNC3_VIDEO_FLOOR_FPS_NAME = "vendor.msync3.videofloor";
    public static final int SCROLLING_FING_HORIZONTAL_HINT_DURATION = 500;
    public static final int SCROLLING_FING_VERTICAL_HINT_DURATION = 3000;
    private static final String SCROLL_COMMON_POLICY_PROPERTY_NAME = "vendor.boostfwk.scroll.common.policy";
    public static final ArrayList<String> SYSTEM_PACKAGE_ARRAY = new ArrayList<String>() {
        {
            add("android");
            add("com.android.systemui");
        }
    };
    public static final int TOUCH_HINT_DURATION_DEFAULT = 1000;
    public static final String USER_CONFIG_DEFAULT_TYPE = "1";
    public static final String USER_CONFIG_DEFAULT_VALUE = "-1";
    public static boolean checkCommonPolicyForALL = true;
    public static boolean dealyReleaseFPSGO = false;
    public static boolean enableScrollFloor = false;
    private static int mBoostFwkVersion = 0;
    private static float mCheckPoint = -100.0f;
    private static int mFrameDecisionMode = -100;
    private static int mFreqFloorStatus = -100;
    private static int mHorizontalScrollDuration = -100;
    public static boolean mIncreaseBuffer = true;
    private static int mTouchHintDuration = -100;
    private static int mVerticalScrollDuration = -100;

    static {
        generateDefalutFeatureForDiffVersion();
    }

    public static void resetFeatureOption() {
        if (getBoostFwkVersion() > 2) {
            mFrameDecisionMode = -100;
            mTouchHintDuration = -100;
            mHorizontalScrollDuration = -100;
            mVerticalScrollDuration = -100;
            mCheckPoint = -100.0f;
            mFreqFloorStatus = -100;
        }
    }

    public static int getIntFromPropWithCheck(String str, int i, int i2, int i3) {
        int i4 = SystemProperties.getInt(str, i);
        return (i4 < i2 || i4 > i3) ? i : i4;
    }

    public static boolean isBoostFwkLogEnable() {
        return BOOLEAN_ENABLE_LOG;
    }

    public static boolean isBoostFwkScrollIdentify() {
        return BOOLEAN_DISABLE_SCROLL_IDENTIFY;
    }

    public static boolean disableFrameIdentify() {
        return BOOLEAN_DISABLE_FRAME_IDENTIFY;
    }

    public static boolean disableSBE() {
        return BOOLEAN_DISABLE_BOOST_FWK;
    }

    public static boolean isBoostFwkScrollIdentifyOn60hz() {
        return BOOLEAN_ENABLE_BOOST_DISPLAY_60;
    }

    public static int getBoostFwkVersion() {
        if (mBoostFwkVersion == 0) {
            mBoostFwkVersion = getIntFromPropWithCheck(BOOST_FWK_VERSION, 1, 1, 3);
        }
        return mBoostFwkVersion;
    }

    private static void generateDefalutFeatureForDiffVersion() {
        boolean z = false;
        if (getBoostFwkVersion() != 3) {
            enableScrollFloor = true;
            mFrameDecisionMode = 0;
            dealyReleaseFPSGO = false;
            mIncreaseBuffer = false;
            checkCommonPolicyForALL = false;
            mTouchHintDuration = 1000;
            mCheckPoint = 50.0f;
            mHorizontalScrollDuration = SCROLLING_FING_HORIZONTAL_HINT_DURATION;
            mVerticalScrollDuration = 3000;
            return;
        }
        dealyReleaseFPSGO = true;
        mFrameDecisionMode = 2;
        checkCommonPolicyForALL = true;
        if (1 == getSrcollFreqFloorStatus()) {
            z = true;
        }
        enableScrollFloor = z;
    }

    public static int getTouchDuration() {
        if (mTouchHintDuration <= 0) {
            mTouchHintDuration = getIntFromPropWithCheck(FRAME_SBE_SBB_ENABLE_LATER, 1000, 0, 100000);
        }
        return mTouchHintDuration;
    }

    public static float getRescueCheckPoint() {
        if (mCheckPoint <= 0.0f) {
            mCheckPoint = ((float) getIntFromPropWithCheck(FRAME_RESCUE_CHECK_POINT_PROPERTY_NAME, 50, 10, 100)) / 100.0f;
        }
        return mCheckPoint;
    }

    public static int getHorizontalScrollDuration() {
        if (mHorizontalScrollDuration <= 0) {
            mHorizontalScrollDuration = getIntFromPropWithCheck(FRAME_SBE_HORIZONTAL_SCROLL_DURATION, SCROLLING_FING_HORIZONTAL_HINT_DURATION, 0, 100000);
        }
        return mHorizontalScrollDuration;
    }

    public static int getVerticalScrollDuration() {
        if (mVerticalScrollDuration <= 0) {
            mVerticalScrollDuration = getIntFromPropWithCheck(FRAME_SBE_VERTICAL_SCROLL_DURATION, 3000, 0, 100000);
        }
        return mVerticalScrollDuration;
    }

    private static int getSrcollFreqFloorStatus() {
        if (mFreqFloorStatus < 0) {
            mFreqFloorStatus = getIntFromPropWithCheck(FRAME_SBE_SCROLL_FREQ_FLOOR, 0, 0, 1);
        }
        return mFreqFloorStatus;
    }

    public static int getFrameDecisionMode() {
        if (mFrameDecisionMode < 0) {
            mFrameDecisionMode = getIntFromPropWithCheck(BOOST_FWK_FRAME_DECISION_PROPERTY_NAME, 2, 0, 2);
        }
        return mFrameDecisionMode;
    }

    public static int getFpsgoReleaseTime() {
        return SystemProperties.getInt(CONFIG_FPSGO_RELEASE_TIME, 50);
    }

    public static boolean isVariableRefreshRateSupported() {
        return BOOLEAN_ENABLE_MSYNC_MSYNC3;
    }

    public static boolean isMSync3SmoothFlingEnabled() {
        return BOOLEAN_ENABLE_MSYNC_SMOOTHFLING_MSYNC3;
    }

    public static boolean isEnableFramePrefetcher() {
        return BOOLEAN_DISABLE_BOOST_FWK_FRAME_PREFETCHER;
    }

    public static boolean isEnablePreAnimation() {
        return BOOLEAN_BOOST_FWK_PRE_ANIMATION;
    }

    public static boolean isEnableFrameRescue() {
        return BOOLEAN_ENABLE_FRAME_RESCUE;
    }

    public static boolean isEnableScrollCommonPolicy() {
        return BOOLEAN_ENABLE_SCROLL_COMMON_POLICY;
    }

    public static boolean isEnableTouchPolicy() {
        return BOOLEAN_ENABLE_BOOST_FWK_TOUCH;
    }

    public static boolean isDisableFrameDecision() {
        getFrameDecisionMode();
        return mFrameDecisionMode == 0;
    }

    public static boolean isFrameDecisionForScrolling() {
        getFrameDecisionMode();
        return 2 == mFrameDecisionMode;
    }

    public static boolean isFrameDecisionForAll() {
        getFrameDecisionMode();
        return 1 == mFrameDecisionMode;
    }
}
