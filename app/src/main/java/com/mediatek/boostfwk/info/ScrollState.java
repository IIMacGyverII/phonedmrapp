package com.mediatek.boostfwk.info;

import android.hardware.display.DisplayManager;
import android.hardware.display.DisplayManagerGlobal;
import android.os.Handler;
import com.mediatek.boostfwk.utils.LogUtil;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

public final class ScrollState {
    public static float REFRESHRATE_60 = 60.0f;
    private static boolean isScrolling = false;
    private static Object lock = new Object();
    private static DisplayManager.DisplayListener mDisplayListener = null;
    private static boolean mIsFling = false;
    private static boolean mIsScrolling = false;
    private static float mRefreshRate = -1.0f;
    private static ArrayList<RefreshRateChangedListener> mRefreshRateListeners = new ArrayList<>(8);
    private static ArrayList<ScrollStateListener> mScrollStateListeners = new ArrayList<>(4);
    private static HashMap<Object, State> scrollingState = new HashMap<>();

    public interface RefreshRateChangedListener {
        void onDisplayRefreshRateChanged(int i, float f, float f2);
    }

    public interface ScrollStateListener {
        void onScroll(boolean z);
    }

    public static class State {
        boolean scrolling = false;
        int velocityX = -1;
        int velocityY = -1;
    }

    public static void updateState(Object obj, boolean z) {
        if (obj != null) {
            State state = scrollingState.get(obj);
            if (state == null) {
                State state2 = new State();
                state2.scrolling = z;
                scrollingState.put(obj, state2);
            } else {
                state.scrolling = z;
            }
            if (z) {
                isScrolling = true;
            } else {
                isScrolling = computeScrollingState();
            }
            Iterator<ScrollStateListener> it = mScrollStateListeners.iterator();
            while (it.hasNext()) {
                it.next().onScroll(isScrolling);
            }
        }
    }

    public static void removeState(Object obj) {
        if (obj != null) {
            scrollingState.remove(obj);
        }
    }

    public static void clearAll() {
        scrollingState.clear();
    }

    private static boolean computeScrollingState() {
        for (Object obj : scrollingState.keySet()) {
            if (scrollingState.get(obj).scrolling) {
                return true;
            }
        }
        return false;
    }

    public static boolean isScrolling() {
        return isScrolling;
    }

    public static boolean isScrollerScrolling(Object obj) {
        State state;
        if (obj == null || (state = scrollingState.get(obj)) == null || !state.scrolling) {
            return false;
        }
        return true;
    }

    public static void registerScrollStateListener(ScrollStateListener scrollStateListener) {
        if (scrollStateListener != null) {
            mScrollStateListeners.add(scrollStateListener);
        }
    }

    public static void unregisterScrollStateListener(ScrollStateListener scrollStateListener) {
        if (scrollStateListener != null) {
            mScrollStateListeners.remove(scrollStateListener);
        }
    }

    public static boolean onScrolling() {
        return mIsScrolling;
    }

    public static void setScrolling(boolean z, String str) {
        mIsScrolling = z;
        Iterator<ScrollStateListener> it = mScrollStateListeners.iterator();
        while (it.hasNext()) {
            it.next().onScroll(mIsScrolling);
        }
        if (LogUtil.DEBUG) {
            LogUtil.trace("scroll state changed to " + z + " because:" + str);
        }
    }

    public static boolean getFling() {
        return mIsFling;
    }

    public static void setFling(boolean z) {
        mIsFling = z;
    }

    public static void registerRefreshRateChangedListener(RefreshRateChangedListener refreshRateChangedListener) {
        if (refreshRateChangedListener != null) {
            mRefreshRateListeners.add(refreshRateChangedListener);
        }
    }

    public static void unregisterRefreshRateChangedListener(RefreshRateChangedListener refreshRateChangedListener) {
        if (refreshRateChangedListener != null) {
            mRefreshRateListeners.remove(refreshRateChangedListener);
        }
    }

    /* access modifiers changed from: private */
    public static synchronized void notifyRefreshRateChangedIfNeeded() {
        synchronized (ScrollState.class) {
            float refreshRate = DisplayManagerGlobal.getInstance().getDisplayInfo(0).getRefreshRate();
            if (refreshRate != mRefreshRate) {
                mRefreshRate = refreshRate;
                float f = 1.0E9f / refreshRate;
                Iterator<RefreshRateChangedListener> it = mRefreshRateListeners.iterator();
                while (it.hasNext()) {
                    it.next().onDisplayRefreshRateChanged(0, refreshRate, f);
                }
            }
        }
    }

    private static void registerDisplyListenerIfNeeded() {
        synchronized (lock) {
            if (mDisplayListener == null) {
                mDisplayListener = new DisplayManager.DisplayListener() {
                    public void onDisplayAdded(int i) {
                    }

                    public void onDisplayRemoved(int i) {
                    }

                    public void onDisplayChanged(int i) {
                        if (i == 0) {
                            ScrollState.notifyRefreshRateChangedIfNeeded();
                        }
                    }
                };
                DisplayManagerGlobal.getInstance().registerDisplayListener(mDisplayListener, new Handler(), 4);
            }
        }
    }

    public static float getRefreshRate() {
        if (mRefreshRate == -1.0f) {
            mRefreshRate = DisplayManagerGlobal.getInstance().getDisplayInfo(0).getRefreshRate();
            registerDisplyListenerIfNeeded();
        }
        return mRefreshRate;
    }
}
