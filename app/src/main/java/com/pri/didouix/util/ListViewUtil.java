package com.pri.didouix.util;

import android.widget.ListView;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
/* loaded from: classes4.dex */
public class ListViewUtil {
    public static void setListViewEnhanceNestedScrolling(ListView listView, boolean z) {
        try {
            Method declaredMethod = Class.forName("android.widget.AbsListView").getDeclaredMethod("setEnhanceNestedScrolling", Boolean.TYPE);
            declaredMethod.setAccessible(true);
            declaredMethod.invoke(listView, Boolean.valueOf(z));
        } catch (ClassNotFoundException | IllegalAccessException | NoSuchMethodException | NullPointerException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }
}
