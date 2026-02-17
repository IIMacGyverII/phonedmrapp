package com.pri.support.widget.adapters;

import android.view.View;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.StaggeredGridLayoutManager;
import com.pri.support.common.adapters.IOverScrollDecoratorAdapter;

public class RecyclerViewOverScrollDecorAdapter implements IOverScrollDecoratorAdapter {
    private final IOverScrollDecoratorAdapter.Impl mImpl;
    private boolean mIsItemTouchInEffect = false;
    /* access modifiers changed from: private */
    public final RecyclerView mRecyclerView;

    public RecyclerViewOverScrollDecorAdapter(RecyclerView recyclerView) {
        int i;
        this.mRecyclerView = recyclerView;
        RecyclerView.LayoutManager layoutManager = recyclerView.getLayoutManager();
        boolean z = layoutManager instanceof LinearLayoutManager;
        if (z || (layoutManager instanceof StaggeredGridLayoutManager)) {
            if (z) {
                i = ((LinearLayoutManager) layoutManager).getOrientation();
            } else {
                i = ((StaggeredGridLayoutManager) layoutManager).getOrientation();
            }
            if (i == 0) {
                this.mImpl = new ImplHorizLayout();
            } else {
                this.mImpl = new ImplVerticalLayout();
            }
        } else {
            throw new IllegalArgumentException("Only support LinearLayoutManager&StaggeredGridLayoutManager layout manager or their subclasses!");
        }
    }

    public View getView() {
        return this.mRecyclerView;
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
            return !RecyclerViewOverScrollDecorAdapter.this.mRecyclerView.canScrollHorizontally(-1);
        }

        public boolean isInAbsoluteEnd() {
            return !RecyclerViewOverScrollDecorAdapter.this.mRecyclerView.canScrollHorizontally(1);
        }
    }

    protected class ImplVerticalLayout implements IOverScrollDecoratorAdapter.Impl {
        protected ImplVerticalLayout() {
        }

        public boolean isInAbsoluteStart() {
            return !RecyclerViewOverScrollDecorAdapter.this.mRecyclerView.canScrollVertically(-1);
        }

        public boolean isInAbsoluteEnd() {
            return !RecyclerViewOverScrollDecorAdapter.this.mRecyclerView.canScrollVertically(1);
        }
    }
}
