package com.pri.support.widget.adapters;

import android.view.View;
import androidx.core.widget.NestedScrollView;
import com.pri.support.common.adapters.IOverScrollDecoratorAdapter;

public class NestedScrollViewOverScrollDecorAdapter implements IOverScrollDecoratorAdapter {
    private final IOverScrollDecoratorAdapter.Impl mImpl;
    private boolean mIsItemTouchInEffect = false;
    /* access modifiers changed from: private */
    public final NestedScrollView mScrollView;

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

    public View getView() {
        return this.mScrollView;
    }

    public boolean isInAbsoluteStart() {
        return !this.mIsItemTouchInEffect && this.mImpl.isInAbsoluteStart();
    }

    public boolean isInAbsoluteEnd() {
        return !this.mIsItemTouchInEffect && this.mImpl.isInAbsoluteEnd();
    }

    protected class ImplHorizLayout implements IOverScrollDecoratorAdapter.Impl {
        protected ImplHorizLayout() {
        }

        public boolean isInAbsoluteStart() {
            return !NestedScrollViewOverScrollDecorAdapter.this.mScrollView.canScrollHorizontally(-1);
        }

        public boolean isInAbsoluteEnd() {
            return !NestedScrollViewOverScrollDecorAdapter.this.mScrollView.canScrollHorizontally(1);
        }
    }

    protected class ImplVerticalLayout implements IOverScrollDecoratorAdapter.Impl {
        protected ImplVerticalLayout() {
        }

        public boolean isInAbsoluteStart() {
            return !NestedScrollViewOverScrollDecorAdapter.this.mScrollView.canScrollVertically(-1);
        }

        public boolean isInAbsoluteEnd() {
            return !NestedScrollViewOverScrollDecorAdapter.this.mScrollView.canScrollVertically(1);
        }
    }
}
