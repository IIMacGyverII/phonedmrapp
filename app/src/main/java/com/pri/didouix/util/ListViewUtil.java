package com.pri.didouix.util;

import android.widget.ListView;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class ListViewUtil {
    public static void setListViewEnhanceNestedScrolling(ListView listView, boolean z) {
        try {
            Method declaredMethod = Class.forName("android.widget.AbsListView").getDeclaredMethod("setEnhanceNestedScrolling", new Class[]{Boolean.TYPE});
            declaredMethod.setAccessible(true);
            declaredMethod.invoke(listView, new Object[]{Boolean.valueOf(z)});
        } catch (ClassNotFoundException | IllegalAccessException | NoSuchMethodException | NullPointerException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }
}
