package com.pri.support.widget.adapters;

import android.view.View;
import androidx.core.widget.NestedScrollView;
import com.pri.support.common.adapters.IOverScrollDecoratorAdapter;
/* loaded from: classes4.dex */
public class NestedScrollViewOverScrollDecorAdapter implements IOverScrollDecoratorAdapter {
    private final IOverScrollDecoratorAdapter.Impl mImpl;
    private boolean mIsItemTouchInEffect = false;
    private final NestedScrollView mScrollView;

    public NestedScrollViewOverScrollDecorAdapter(NestedScrollView nestedScrollView, int i) {
        this.mScrollView = nestedScrollView;
        if (i == 0) {
            this.mImpl = new ImplHorizLayout();
        } else if (i == 1) {
            this.mImpl = new ImplVerticalLayout();
        } else {
            throw new IllegalArgumentException("Unknown orientation!");
        }
    }

    @Override // com.pri.support.common.adapters.IOverScrollDecoratorAdapter
    public View getView() {
        return this.mScrollView;
    }

    @Override // com.pri.support.common.adapters.IOverScrollDecoratorAdapter
    public boolean isInAbsoluteStart() {
        return !this.mIsItemTouchInEffect && this.mImpl.isInAbsoluteStart();
    }

    @Override // com.pri.support.common.adapters.IOverScrollDecoratorAdapter
    public boolean isInAbsoluteEnd() {
        return !this.mIsItemTouchInEffect && this.mImpl.isInAbsoluteEnd();
    }

    /* loaded from: classes4.dex */
    protected class ImplHorizLayout implements IOverScrollDecoratorAdapter.Impl {
        protected ImplHorizLayout() {
        }

        @Override // com.pri.support.common.adapters.IOverScrollDecoratorAdapter.Impl
        public boolean isInAbsoluteStart() {
            return !NestedScrollViewOverScrollDecorAdapter.this.mScrollView.canScrollHorizontally(-1);
        }

        @Override // com.pri.support.common.adapters.IOverScrollDecoratorAdapter.Impl
        public boolean isInAbsoluteEnd() {
            return !NestedScrollViewOverScrollDecorAdapter.this.mScrollView.canScrollHorizontally(1);
        }
    }

    /* loaded from: classes4.dex */
    protected class ImplVerticalLayout implements IOverScrollDecoratorAdapter.Impl {
        protected ImplVerticalLayout() {
        }

        @Override // com.pri.support.common.adapters.IOverScrollDecoratorAdapter.Impl
        public boolean isInAbsoluteStart() {
            return !NestedScrollViewOverScrollDecorAdapter.this.mScrollView.canScrollVertically(-1);
        }

        @Override // com.pri.support.common.adapters.IOverScrollDecoratorAdapter.Impl
        public boolean isInAbsoluteEnd() {
            return !NestedScrollViewOverScrollDecorAdapter.this.mScrollView.canScrollVertically(1);
        }
    }
}
