package com.mediatek.res;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;

public class ResOptExtImpl extends ResOptExt {
    private static Object lock = new Object();
    private static ResOptExtImpl sInstance;

    public static ResOptExtImpl getInstance() {
        if (sInstance == null) {
            synchronized (lock) {
                if (sInstance == null) {
                    sInstance = new ResOptExtImpl();
                }
            }
        }
        return sInstance;
    }

    public void preloadRes(Context context, Resources resources) {
        AsyncDrawableCache.getInstance().preloadRes(context, resources);
    }

    public Drawable getCachedDrawable(Resources resources, long j, int i) {
        return AsyncDrawableCache.getInstance().getCachedDrawable(resources, j, i);
    }

    public void putCacheList(long j, Drawable drawable, int i, Context context) {
        AsyncDrawableCache.getInstance().putCacheList(j, drawable, i, context);
    }
}
