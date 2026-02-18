package com.pri.support.common.adapters;

import android.view.View;
/* loaded from: classes4.dex */
public interface IOverScrollDecoratorAdapter {

    /* loaded from: classes4.dex */
    public interface Impl {
        boolean isInAbsoluteEnd();

        boolean isInAbsoluteStart();
    }

    View getView();

    boolean isInAbsoluteEnd();

    boolean isInAbsoluteStart();
}
