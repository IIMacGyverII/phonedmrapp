package com.mediatek.res;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.SystemProperties;
import android.os.UserManager;
import android.util.ArrayMap;
import android.util.Log;
import com.mediatek.custom.CustomProperties;
import com.pri.prizeinterphone.Util.Util;
import java.util.ArrayList;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

class AsyncDrawableCache {
    private static final String TAG = "AsyncDrawableCache";
    private static boolean isDEBUG = false;
    /* access modifiers changed from: private */
    public static boolean isPreloaded = false;
    private static Object lock = new Object();
    private static AsyncDrawableCache mAsyncDrawableCache = null;
    private static final long sClearCacheTime = 10000;
    private static final String sDefResolution = "720";
    private static final ArrayMap<Long, Drawable.ConstantState> sDrawableCache = new ArrayMap<>();
    private static String sFeatureConfig = SystemProperties.get(sResolutionEnableProp, "1");
    private static final String sPerfName = "perf_img_scale";
    private static ArrayList<String> sPreloadList = new ArrayList<String>() {
        {
            add("com.bbl.mobilebanking");
            add("air.tv.douyu.android");
        }
    };
    private static String sResolution = sDefResolution;
    private static final String sResolutionEnableProp = "ro.vendor.pref_scale_enable_cfg";
    private static ArrayMap<String, Integer> sResolutionList = new ArrayMap<>();

    AsyncDrawableCache() {
        sResolutionList.put("480", 307200);
        sResolutionList.put(sDefResolution, 921600);
        sResolutionList.put("1080", 2073600);
    }

    static AsyncDrawableCache getInstance() {
        if (mAsyncDrawableCache == null) {
            synchronized (AsyncDrawableCache.class) {
                if (mAsyncDrawableCache == null) {
                    mAsyncDrawableCache = new AsyncDrawableCache();
                }
            }
        }
        return mAsyncDrawableCache;
    }

    /* access modifiers changed from: package-private */
    public boolean skipPreload(Context context) {
        String packageName;
        if (context == null || (packageName = context.getPackageName()) == null || sPreloadList.contains(packageName)) {
            return true;
        }
        return false;
    }

    /* access modifiers changed from: package-private */
    public void preloadRes(Context context, Resources resources) {
        SharedPreferences sharedPreferences;
        if (isEnableFeature() && !skipPreload(context) && isUserUnlocked(context) && (sharedPreferences = context.getSharedPreferences(sPerfName, 0)) != null && sharedPreferences.getAll().size() != 0) {
            isPreloaded = true;
            AsyncTask.execute(new AsyncDrawableCache$$ExternalSyntheticLambda0(sharedPreferences, context));
            clearCacheAfterPreload();
        }
    }

    /* access modifiers changed from: private */
    public static /* synthetic */ void lambda$preloadRes$0(SharedPreferences sharedPreferences, Context context) {
        for (Map.Entry next : sharedPreferences.getAll().entrySet()) {
            String str = (String) next.getKey();
            int intValue = ((Integer) next.getValue()).intValue();
            if (isDEBUG) {
                Log.d(TAG, "resource=" + intValue + ", res obj=" + context.getResources().getImpl());
            }
            try {
                context.getDrawable(intValue);
            } catch (Resources.NotFoundException unused) {
                Log.w(TAG, "can not found res: " + intValue + ", maybe dynamic res id.");
            }
        }
        if (isDEBUG) {
            Log.d(TAG, "preloadRes, end of preloadRes");
        }
    }

    /* access modifiers changed from: package-private */
    public Drawable getCachedDrawable(Resources resources, long j, int i) {
        Drawable.ConstantState constantState;
        if (!isEnableFeature()) {
            return null;
        }
        synchronized (lock) {
            constantState = sDrawableCache.get(Long.valueOf(j));
        }
        if (constantState != null) {
            return constantState.newDrawable(resources);
        }
        return null;
    }

    /* access modifiers changed from: package-private */
    public void putCacheList(long j, Drawable drawable, int i, Context context) {
        ArrayMap<Long, Drawable.ConstantState> arrayMap;
        Drawable.ConstantState constantState;
        if (isEnableFeature() && !skipPreload(context) && !context.getApplicationInfo().processName.equals(CustomProperties.MODULE_SYSTEM) && !context.getApplicationInfo().isSystemApp()) {
            synchronized (lock) {
                arrayMap = sDrawableCache;
                constantState = arrayMap.get(Long.valueOf(j));
            }
            if (constantState == null && needCacheDrawable(drawable)) {
                if (isPreloaded) {
                    synchronized (lock) {
                        arrayMap.put(Long.valueOf(j), drawable.getConstantState());
                    }
                    if (isDEBUG) {
                        Log.d(TAG, "putCacheList, put cache, size:" + arrayMap.size());
                    }
                }
                if (isDEBUG) {
                    Log.d(TAG, "putCacheList, key:" + j + ", origResId:" + i);
                }
                storeDrawableId(i, context);
            }
        }
    }

    private boolean needCacheDrawable(Drawable drawable) {
        Integer num = sResolutionList.get(sResolution);
        int minimumWidth = drawable.getMinimumWidth() * drawable.getMinimumHeight();
        if (minimumWidth < num.intValue()) {
            return false;
        }
        if (isDEBUG) {
            Log.d(TAG, "computeResolution, drResolution:" + minimumWidth + ", scaleResolution:" + num);
        }
        return true;
    }

    private void storeDrawableId(int i, Context context) {
        SharedPreferences sharedPreferences;
        if (context == null) {
            Log.w(TAG, "storeDrawableId got the context is null, id:" + i + " cannot save");
        } else if (isUserUnlocked(context) && (sharedPreferences = context.getSharedPreferences(sPerfName, 0)) != null && !sharedPreferences.contains(String.valueOf(i))) {
            SharedPreferences.Editor edit = sharedPreferences.edit();
            edit.putInt(String.valueOf(i), i);
            edit.commit();
            if (isDEBUG) {
                Log.d(TAG, "storeDrawableId, id:" + i);
            }
        }
    }

    private boolean isEnableFeature() {
        if (sFeatureConfig.equals("0")) {
            isDEBUG = false;
        } else if (sFeatureConfig.equals("1")) {
            isDEBUG = false;
            return true;
        } else if (sFeatureConfig.equals(Util.DMR_UPDATE_STATUS_UPDATING)) {
            isDEBUG = true;
            return true;
        }
        return false;
    }

    private boolean isUserUnlocked(Context context) {
        return ((UserManager) context.getSystemService("user")).isUserUnlocked();
    }

    /* access modifiers changed from: private */
    public void clearCache() {
        ArrayMap<Long, Drawable.ConstantState> arrayMap = sDrawableCache;
        if (!(arrayMap == null || arrayMap.size() == 0)) {
            synchronized (lock) {
                arrayMap.clear();
            }
        }
        if (isDEBUG) {
            Log.d(TAG, "clearCache, cache size:" + arrayMap.size());
        }
    }

    private void clearCacheAfterPreload() {
        if (isPreloaded) {
            new Timer().schedule(new TimerTask() {
                public void run() {
                    AsyncDrawableCache.this.clearCache();
                    AsyncDrawableCache.isPreloaded = false;
                }
            }, sClearCacheTime);
        }
    }
}
