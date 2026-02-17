package com.pri.support.common.adapters;

import android.view.View;

public interface IOverScrollDecoratorAdapter {

    public interface Impl {
        boolean isInAbsoluteEnd();

        boolean isInAbsoluteStart();
    }

    View getView();

    boolean isInAbsoluteEnd();

    boolean isInAbsoluteStart();
}
