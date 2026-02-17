package com.pri.didouix.custview;

import android.content.Context;
import android.graphics.Point;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.ViewConfiguration;
import android.view.ViewParent;
import androidx.recyclerview.widget.RecyclerView;
import com.pri.didouix.springback.view.SpringBackLayout;

public class PrizeRecyclerView extends RecyclerView {
    private int mDownX;
    private int mDownY;
    protected int mScaleTouchSlop;
    private Point touchPoint;

    public PrizeRecyclerView(Context context) {
        this(context, (AttributeSet) null);
    }

    public PrizeRecyclerView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public PrizeRecyclerView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        this.touchPoint = new Point();
        this.mScaleTouchSlop = ViewConfiguration.get(context).getScaledTouchSlop();
    }

    public boolean onTouchEvent(MotionEvent motionEvent) {
        this.touchPoint.set((int) motionEvent.getX(), (int) motionEvent.getY());
        return super.onTouchEvent(motionEvent);
    }

    public boolean onInterceptTouchEvent(MotionEvent motionEvent) {
        int x = (int) motionEvent.getX();
        int y = (int) motionEvent.getY();
        boolean onInterceptTouchEvent = super.onInterceptTouchEvent(motionEvent);
        int action = motionEvent.getAction();
        if (action == 0) {
            this.mDownX = x;
            this.mDownY = y;
        } else if (action == 2) {
            int i = this.mDownX - x;
            int i2 = this.mDownY - y;
            if ((Math.abs(i2) > this.mScaleTouchSlop || Math.abs(i) > this.mScaleTouchSlop) && Math.abs(i) < Math.abs(i2)) {
                requestDisallowParentInterceptTouchEvent(true);
                return true;
            }
        }
        return onInterceptTouchEvent;
    }

    public void requestDisallowParentInterceptTouchEvent(boolean z) {
        ViewParent parent = getParent();
        parent.requestDisallowInterceptTouchEvent(z);
        while (parent != null) {
            if (parent instanceof SpringBackLayout) {
                ((SpringBackLayout) parent).internalRequestDisallowInterceptTouchEvent(z);
            }
            parent = parent.getParent();
        }
    }

    public Point getTouchPoint() {
        return this.touchPoint;
    }
}
