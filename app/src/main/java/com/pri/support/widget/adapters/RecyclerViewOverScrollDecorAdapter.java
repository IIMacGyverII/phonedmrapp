package com.pri.support.widget.adapters;

import android.view.View;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.StaggeredGridLayoutManager;
import com.pri.support.common.adapters.IOverScrollDecoratorAdapter;
/* loaded from: classes4.dex */
public class RecyclerViewOverScrollDecorAdapter implements IOverScrollDecoratorAdapter {
    private final IOverScrollDecoratorAdapter.Impl mImpl;
    private boolean mIsItemTouchInEffect = false;
    private final RecyclerView mRecyclerView;

    public RecyclerViewOverScrollDecorAdapter(RecyclerView recyclerView) {
        int orientation;
        this.mRecyclerView = recyclerView;
        RecyclerView.LayoutManager layoutManager = recyclerView.getLayoutManager();
        boolean z = layoutManager instanceof LinearLayoutManager;
        if (!z && !(layoutManager instanceof StaggeredGridLayoutManager)) {
            throw new IllegalArgumentException("Only support LinearLayoutManager&StaggeredGridLayoutManager layout manager or their subclasses!");
        }
        if (z) {
            orientation = ((LinearLayoutManager) layoutManager).getOrientation();
        } else {
            orientation = ((StaggeredGridLayoutManager) layoutManager).getOrientation();
        }
        if (orientation == 0) {
            this.mImpl = new ImplHorizLayout();
        } else {
            this.mImpl = new ImplVerticalLayout();
        }
    }

    @Override // com.pri.support.common.adapters.IOverScrollDecoratorAdapter
    public View getView() {
        return this.mRecyclerView;
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
            return !RecyclerViewOverScrollDecorAdapter.this.mRecyclerView.canScrollHorizontally(-1);
        }

        @Override // com.pri.support.common.adapters.IOverScrollDecoratorAdapter.Impl
        public boolean isInAbsoluteEnd() {
            return !RecyclerViewOverScrollDecorAdapter.this.mRecyclerView.canScrollHorizontally(1);
        }
    }

    /* loaded from: classes4.dex */
    protected class ImplVerticalLayout implements IOverScrollDecoratorAdapter.Impl {
        protected ImplVerticalLayout() {
        }

        @Override // com.pri.support.common.adapters.IOverScrollDecoratorAdapter.Impl
        public boolean isInAbsoluteStart() {
            return !RecyclerViewOverScrollDecorAdapter.this.mRecyclerView.canScrollVertically(-1);
        }

        @Override // com.pri.support.common.adapters.IOverScrollDecoratorAdapter.Impl
        public boolean isInAbsoluteEnd() {
            return !RecyclerViewOverScrollDecorAdapter.this.mRecyclerView.canScrollVertically(1);
        }
    }
}
