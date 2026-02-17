package com.mediatek.media;

import android.content.Context;
import android.util.Log;
import java.lang.reflect.Method;

public class MediaPlayerEx {
    private static final String CLASS_NAME = "android.media.MediaPlayer";
    private static final String METHOD_NAME = "setContext";
    private static final String TAG = "MediaPlayerEx";
    private static Method sSetContext;

    static {
        try {
            Method declaredMethod = Class.forName(CLASS_NAME).getDeclaredMethod(METHOD_NAME, new Class[]{Context.class});
            sSetContext = declaredMethod;
            if (declaredMethod != null) {
                declaredMethod.setAccessible(true);
            }
        } catch (NoSuchMethodException e) {
            Log.e("@M_MediaPlayerEx", "NoSuchMethodException: " + e);
        } catch (ClassNotFoundException e2) {
            Log.e("@M_MediaPlayerEx", "ClassNotFoundException: " + e2);
        }
    }
}
