package com.pri.support.widget;

import androidx.core.widget.NestedScrollView;
import androidx.recyclerview.widget.RecyclerView;
import com.pri.support.common.HorizontalOverScrollBounceEffectDecorator;
import com.pri.support.common.IOverScrollDecor;
import com.pri.support.common.VerticalOverScrollBounceEffectDecorator;
import com.pri.support.widget.adapters.NestedScrollViewOverScrollDecorAdapter;
import com.pri.support.widget.adapters.RecyclerViewOverScrollDecorAdapter;

public class OverScrollHelper {
    public static final int HORIZONTAL = 0;
    public static final int VERTICAL = 1;

    public static IOverScrollDecor setupOverScroll(RecyclerView recyclerView, int i) {
        if (i == 0) {
            return new HorizontalOverScrollBounceEffectDecorator(new RecyclerViewOverScrollDecorAdapter(recyclerView));
        }
        if (i == 1) {
            return new VerticalOverScrollBounceEffectDecorator(new RecyclerViewOverScrollDecorAdapter(recyclerView));
        }
        throw new IllegalArgumentException("unknown orientation! Only accept HORIZONTAL & VERTICAL orientation");
    }

    public static IOverScrollDecor setupOverScroll(NestedScrollView nestedScrollView, int i) {
        if (i == 0) {
            return new HorizontalOverScrollBounceEffectDecorator(new NestedScrollViewOverScrollDecorAdapter(nestedScrollView, i));
        }
        if (i == 1) {
            return new VerticalOverScrollBounceEffectDecorator(new NestedScrollViewOverScrollDecorAdapter(nestedScrollView, i));
        }
        throw new IllegalArgumentException("unknown orientation! Only accept HORIZONTAL & VERTICAL orientation");
    }
}
