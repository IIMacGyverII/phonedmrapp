package com.pri.didouix.custview;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.ViewConfiguration;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;
import com.pri.didouix.springback.view.SpringBackLayout;

public class PrizeSpringBackLayout extends SpringBackLayout {
    private boolean mCurrentTabSelected;
    private int mDownX;
    private int mDownY;
    @Nullable
    private RecyclerView mRecyclerView;
    private int mScaledTouchSlop;
    private ParentStateListener mStateListener;

    public PrizeSpringBackLayout(Context context) {
        this(context, (AttributeSet) null);
    }

    public PrizeSpringBackLayout(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        this.mScaledTouchSlop = ViewConfiguration.get(getContext()).getScaledTouchSlop();
    }

    public void setCurrentTab(boolean z) {
        this.mCurrentTabSelected = z;
    }

    public void setRecyclerView(RecyclerView recyclerView) {
        this.mRecyclerView = recyclerView;
    }

    public void setStateListener(ParentStateListener parentStateListener) {
        this.mStateListener = parentStateListener;
    }

    public boolean onInterceptTouchEvent(MotionEvent motionEvent) {
        RecyclerView recyclerView;
        int action = motionEvent.getAction();
        int x = (int) motionEvent.getX();
        int y = (int) motionEvent.getY();
        boolean onInterceptTouchEvent = super.onInterceptTouchEvent(motionEvent);
        if (action == 0) {
            this.mDownX = x;
            this.mDownY = y;
            return onInterceptTouchEvent;
        } else if (action == 2 && (recyclerView = this.mRecyclerView) != null && this.mCurrentTabSelected && recyclerView.getChildAdapterPosition(recyclerView.findChildViewUnder((float) x, (float) y)) >= 0) {
            return false;
        } else {
            return onInterceptTouchEvent;
        }
    }
}
