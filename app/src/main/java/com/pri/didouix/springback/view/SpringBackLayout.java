package com.pri.didouix.springback.view;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.WindowManager;
import android.widget.ListView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.NestedScrollingChild3;
import androidx.core.view.NestedScrollingChildHelper;
import androidx.core.view.NestedScrollingParent3;
import androidx.core.view.NestedScrollingParentHelper;
import androidx.core.widget.ListViewCompat;
import com.pri.R;
import com.pri.didouix.core.view.NestedCurrentFling;
import com.pri.didouix.util.PrizeNestedScrollLog;
import java.util.ArrayList;
import java.util.List;

public class SpringBackLayout extends ViewGroup implements NestedScrollingParent3, NestedScrollingChild3, NestedCurrentFling {
    public static final int ANGLE = 4;
    public static final int HORIZONTAL = 1;
    private static final int INVALID_ID = -1;
    private static final int INVALID_POINTER = -1;
    private static final int MAX_FLING_CONSUME_COUNTER = 4;
    public static final int SPRING_BACK_BOTTOM = 2;
    public static final int SPRING_BACK_TOP = 1;
    public static final int STATE_DRAGGING = 1;
    public static final int STATE_IDLE = 0;
    public static final int STATE_SETTLING = 2;
    private static final String TAG = "SpringBackLayout";
    public static final int UNCHECK_ORIENTATION = 0;
    private static final int VELOCITY_THRADHOLD = 2000;
    public static final int VERTICAL = 2;
    private int consumeNestFlingCounter;
    private int mActivePointerId;
    private SpringBackLayoutHelper mHelper;
    private float mInitialDownX;
    private float mInitialDownY;
    private float mInitialMotionX;
    private float mInitialMotionY;
    private boolean mIsBeingDragged;
    private boolean mNestedFlingInProgress;
    private int mNestedScrollAxes;
    private boolean mNestedScrollInProgress;
    private final NestedScrollingChildHelper mNestedScrollingChildHelper;
    private final NestedScrollingParentHelper mNestedScrollingParentHelper;
    private final int[] mNestedScrollingV2ConsumedCompat;
    private List<OnScrollListener> mOnScrollListeners;
    private OnSpringListener mOnSpringListener;
    private int mOriginScrollOrientation;
    private final int[] mParentOffsetInWindow;
    private final int[] mParentScrollConsumed;
    private final int mScreenHeight;
    private final int mScreenWith;
    private boolean mScrollByFling;
    private int mScrollOrientation;
    private int mScrollState;
    private boolean mSpringBackEnable;
    private int mSpringBackMode;
    private SpringScroller mSpringScroller;
    private View mTarget;
    private int mTargetId;
    private float mTotalFlingUnconsumed;
    private float mTotalScrollBottomUnconsumed;
    private float mTotalScrollTopUnconsumed;
    private int mTouchSlop;
    private float mVelocityX;
    private float mVelocityY;

    public interface OnScrollListener {
        void onScrolled(SpringBackLayout springBackLayout, int i, int i2);

        void onStateChanged(int i, int i2, boolean z);
    }

    public interface OnSpringListener {
        boolean onSpringBack();
    }

    public SpringBackLayout(Context context) {
        this(context, (AttributeSet) null);
    }

    public SpringBackLayout(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        this.mActivePointerId = -1;
        this.consumeNestFlingCounter = 0;
        this.mParentScrollConsumed = new int[2];
        this.mParentOffsetInWindow = new int[2];
        this.mNestedScrollingV2ConsumedCompat = new int[2];
        this.mSpringBackEnable = true;
        this.mOnScrollListeners = new ArrayList();
        this.mScrollState = 0;
        this.mNestedScrollingParentHelper = new NestedScrollingParentHelper(this);
        this.mNestedScrollingChildHelper = com.pri.didouix.core.view.NestedScrollingChildHelper.obtain(this);
        this.mTouchSlop = ViewConfiguration.get(context).getScaledTouchSlop();
        TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributeSet, R.styleable.SpringBackLayout);
        this.mTargetId = obtainStyledAttributes.getResourceId(R.styleable.SpringBackLayout_scrollableView, -1);
        this.mOriginScrollOrientation = obtainStyledAttributes.getInt(R.styleable.SpringBackLayout_scrollOrientation, 2);
        this.mSpringBackMode = obtainStyledAttributes.getInt(R.styleable.SpringBackLayout_springBackMode, 3);
        obtainStyledAttributes.recycle();
        this.mSpringScroller = new SpringScroller();
        this.mHelper = new SpringBackLayoutHelper(this, this.mOriginScrollOrientation);
        setNestedScrollingEnabled(true);
        DisplayMetrics displayMetrics = new DisplayMetrics();
        ((WindowManager) context.getSystemService("window")).getDefaultDisplay().getMetrics(displayMetrics);
        this.mScreenWith = displayMetrics.widthPixels;
        this.mScreenHeight = displayMetrics.heightPixels;
    }

    public void setSpringBackEnable(boolean z) {
        this.mSpringBackEnable = z;
    }

    public boolean springBackEnable() {
        return this.mSpringBackEnable;
    }

    public void setScrollOrientation(int i) {
        this.mOriginScrollOrientation = i;
        this.mHelper.mTargetScrollOrientation = i;
    }

    public void setSpringBackMode(int i) {
        this.mSpringBackMode = i;
    }

    public int getSpringBackMode() {
        return this.mSpringBackMode;
    }

    public void setEnabled(boolean z) {
        super.setEnabled(z);
        View view = this.mTarget;
        if (view != null && (view instanceof NestedScrollingChild3) && z != view.isNestedScrollingEnabled()) {
            this.mTarget.setNestedScrollingEnabled(z);
        }
    }

    private boolean supportTopSpringBackMode() {
        return (this.mSpringBackMode & 1) != 0;
    }

    private boolean supportBottomSpringBackMode() {
        return (this.mSpringBackMode & 2) != 0;
    }

    public void setTarget(@NonNull View view) {
        this.mTarget = view;
        if ((view instanceof NestedScrollingChild3) && !view.isNestedScrollingEnabled()) {
            this.mTarget.setNestedScrollingEnabled(true);
        }
    }

    private void ensureTarget() {
        if (this.mTarget == null) {
            int i = this.mTargetId;
            if (i != -1) {
                this.mTarget = findViewById(i);
            } else {
                throw new IllegalArgumentException("invalid target Id");
            }
        }
        if (this.mTarget != null) {
            if (isEnabled()) {
                View view = this.mTarget;
                if ((view instanceof NestedScrollingChild3) && !view.isNestedScrollingEnabled()) {
                    this.mTarget.setNestedScrollingEnabled(true);
                }
            }
            if (this.mTarget.getOverScrollMode() != 2) {
                this.mTarget.setOverScrollMode(2);
                return;
            }
            return;
        }
        throw new IllegalArgumentException("fail to get target");
    }

    public void onLayout(boolean z, int i, int i2, int i3, int i4) {
        int measuredWidth = getMeasuredWidth();
        int measuredHeight = getMeasuredHeight();
        int paddingLeft = getPaddingLeft();
        int paddingTop = getPaddingTop();
        this.mTarget.layout(paddingLeft, paddingTop, ((measuredWidth - getPaddingLeft()) - getPaddingRight()) + paddingLeft, ((measuredHeight - getPaddingTop()) - getPaddingBottom()) + paddingTop);
    }

    public void onMeasure(int i, int i2) {
        ensureTarget();
        int mode = View.MeasureSpec.getMode(i);
        int mode2 = View.MeasureSpec.getMode(i2);
        int size = View.MeasureSpec.getSize(i);
        int size2 = View.MeasureSpec.getSize(i2);
        measureChild(this.mTarget, i, i2);
        if (size > this.mTarget.getMeasuredWidth()) {
            size = this.mTarget.getMeasuredWidth();
        }
        if (size2 > this.mTarget.getMeasuredHeight()) {
            size2 = this.mTarget.getMeasuredHeight();
        }
        if (mode != Integer.MIN_VALUE) {
            size = this.mTarget.getMeasuredWidth();
        }
        if (mode2 != Integer.MIN_VALUE) {
            size2 = this.mTarget.getMeasuredHeight();
        }
        setMeasuredDimension(size, size2);
    }

    public void computeScroll() {
        super.computeScroll();
        if (this.mSpringScroller.computeScrollOffset()) {
            scrollTo(this.mSpringScroller.getCurrX(), this.mSpringScroller.getCurrY());
            if (!this.mSpringScroller.isFinished()) {
                postInvalidateOnAnimation();
            } else {
                dispatchScrollState(0);
            }
        }
    }

    public void onScrollChanged(int i, int i2, int i3, int i4) {
        super.onScrollChanged(i, i2, i3, i4);
        for (OnScrollListener onScrolled : this.mOnScrollListeners) {
            onScrolled.onScrolled(this, i - i3, i2 - i4);
        }
    }

    private boolean isVerticalTargetScrollToTop() {
        View view = this.mTarget;
        if (view instanceof ListView) {
            return !ListViewCompat.canScrollList((ListView) view, -1);
        }
        return !view.canScrollVertically(-1);
    }

    private boolean isHorizontalTargetScrollToTop() {
        return !this.mTarget.canScrollHorizontally(-1);
    }

    private boolean isTargetScrollOrientation(int i) {
        return this.mScrollOrientation == i;
    }

    private boolean isTargetScrollToTop(int i) {
        if (i != 2) {
            return !this.mTarget.canScrollHorizontally(-1);
        }
        View view = this.mTarget;
        if (view instanceof ListView) {
            return !ListViewCompat.canScrollList((ListView) view, -1);
        }
        boolean z = !view.canScrollVertically(-1);
        PrizeNestedScrollLog.d(TAG, "isTargetScrollToTop() " + z);
        return z;
    }

    private boolean isTargetScrollToBottom(int i) {
        if (i != 2) {
            return !this.mTarget.canScrollHorizontally(1);
        }
        View view = this.mTarget;
        if (view instanceof ListView) {
            return !ListViewCompat.canScrollList((ListView) view, 1);
        }
        boolean z = !view.canScrollVertically(1);
        PrizeNestedScrollLog.d(TAG, "isTargetScrollToBottom() " + z);
        return z;
    }

    public boolean dispatchTouchEvent(MotionEvent motionEvent) {
        if (motionEvent.getActionMasked() == 0 && this.mScrollState == 2 && this.mHelper.isTouchInTarget(motionEvent)) {
            dispatchScrollState(1);
        }
        boolean dispatchTouchEvent = super.dispatchTouchEvent(motionEvent);
        if (motionEvent.getActionMasked() == 1 && this.mScrollState != 2) {
            dispatchScrollState(0);
        }
        return dispatchTouchEvent;
    }

    public boolean onInterceptTouchEvent(MotionEvent motionEvent) {
        if (this.mSpringBackEnable && isEnabled() && !this.mNestedFlingInProgress && !this.mNestedScrollInProgress && !this.mTarget.isNestedScrollingEnabled()) {
            int actionMasked = motionEvent.getActionMasked();
            if (!this.mSpringScroller.isFinished() && actionMasked == 0) {
                this.mSpringScroller.forceStop();
            }
            if (!supportTopSpringBackMode() && !supportBottomSpringBackMode()) {
                return false;
            }
            int i = this.mOriginScrollOrientation;
            if ((i & 4) != 0) {
                checkOrientation(motionEvent);
                if (isTargetScrollOrientation(2) && (this.mOriginScrollOrientation & 1) != 0 && ((float) getScrollX()) == 0.0f) {
                    return false;
                }
                if (isTargetScrollOrientation(1) && (this.mOriginScrollOrientation & 2) != 0 && ((float) getScrollY()) == 0.0f) {
                    return false;
                }
                if (isTargetScrollOrientation(2) || isTargetScrollOrientation(1)) {
                    disallowParentInterceptTouchEvent(true);
                }
            } else {
                this.mScrollOrientation = i;
            }
            if (isTargetScrollOrientation(2)) {
                return onVerticalInterceptTouchEvent(motionEvent);
            }
            if (isTargetScrollOrientation(1)) {
                return onHorizontalInterceptTouchEvent(motionEvent);
            }
        }
        return false;
    }

    private void disallowParentInterceptTouchEvent(boolean z) {
        ViewParent parent = getParent();
        if (parent != null) {
            parent.requestDisallowInterceptTouchEvent(z);
        }
    }

    private void checkOrientation(MotionEvent motionEvent) {
        int i;
        this.mHelper.checkOrientation(motionEvent);
        int actionMasked = motionEvent.getActionMasked();
        if (actionMasked != 0) {
            if (actionMasked != 1) {
                if (actionMasked != 2) {
                    if (actionMasked != 3) {
                        if (actionMasked == 6) {
                            onSecondaryPointerUp(motionEvent);
                            return;
                        }
                        return;
                    }
                } else if (this.mScrollOrientation == 0 && (i = this.mHelper.mScrollOrientation) != 0) {
                    this.mScrollOrientation = i;
                    return;
                } else {
                    return;
                }
            }
            disallowParentInterceptTouchEvent(false);
            if ((this.mOriginScrollOrientation & 2) != 0) {
                springBack(2);
            } else {
                springBack(1);
            }
        } else {
            SpringBackLayoutHelper springBackLayoutHelper = this.mHelper;
            this.mInitialDownY = springBackLayoutHelper.mInitialDownY;
            this.mInitialDownX = springBackLayoutHelper.mInitialDownX;
            this.mActivePointerId = springBackLayoutHelper.mActivePointerId;
            if (getScrollY() != 0) {
                this.mScrollOrientation = 2;
                requestDisallowParentInterceptTouchEvent(true);
            } else if (getScrollX() != 0) {
                this.mScrollOrientation = 1;
                requestDisallowParentInterceptTouchEvent(true);
            } else {
                this.mScrollOrientation = 0;
            }
            if ((this.mOriginScrollOrientation & 2) != 0) {
                checkScrollStart(2);
            } else {
                checkScrollStart(1);
            }
        }
    }

    private boolean onVerticalInterceptTouchEvent(MotionEvent motionEvent) {
        if (!isTargetScrollToTop(2) && !isTargetScrollToBottom(2)) {
            return false;
        }
        if (isTargetScrollToTop(2) && !supportTopSpringBackMode()) {
            return false;
        }
        if (isTargetScrollToBottom(2) && !supportBottomSpringBackMode()) {
            return false;
        }
        int actionMasked = motionEvent.getActionMasked();
        if (actionMasked != 0) {
            if (actionMasked != 1) {
                if (actionMasked == 2) {
                    int i = this.mActivePointerId;
                    if (i == -1) {
                        Log.e(TAG, "Got ACTION_MOVE event but don't have an active pointer id.");
                        return false;
                    }
                    int findPointerIndex = motionEvent.findPointerIndex(i);
                    if (findPointerIndex < 0) {
                        Log.e(TAG, "Got ACTION_MOVE event but have an invalid active pointer id.");
                        return false;
                    }
                    float y = motionEvent.getY(findPointerIndex);
                    boolean z = isTargetScrollToBottom(2) && isTargetScrollToTop(2);
                    if ((z || !isTargetScrollToTop(2)) && (!z || y <= this.mInitialDownY)) {
                        if (this.mInitialDownY - y > ((float) this.mTouchSlop) && !this.mIsBeingDragged) {
                            this.mIsBeingDragged = true;
                            dispatchScrollState(1);
                            this.mInitialMotionY = y;
                        }
                    } else if (y - this.mInitialDownY > ((float) this.mTouchSlop) && !this.mIsBeingDragged) {
                        this.mIsBeingDragged = true;
                        dispatchScrollState(1);
                        this.mInitialMotionY = y;
                    }
                } else if (actionMasked != 3 && actionMasked == 6) {
                    onSecondaryPointerUp(motionEvent);
                }
            }
            this.mIsBeingDragged = false;
            this.mActivePointerId = -1;
        } else {
            int pointerId = motionEvent.getPointerId(0);
            this.mActivePointerId = pointerId;
            int findPointerIndex2 = motionEvent.findPointerIndex(pointerId);
            if (findPointerIndex2 < 0) {
                return false;
            }
            this.mInitialDownY = motionEvent.getY(findPointerIndex2);
            if (getScrollY() != 0) {
                this.mIsBeingDragged = true;
                this.mInitialMotionY = this.mInitialDownY;
            } else {
                this.mIsBeingDragged = false;
            }
        }
        return this.mIsBeingDragged;
    }

    private boolean onHorizontalInterceptTouchEvent(MotionEvent motionEvent) {
        if (!isTargetScrollToTop(1) && !isTargetScrollToBottom(1)) {
            return false;
        }
        if (isTargetScrollToTop(1) && !supportTopSpringBackMode()) {
            return false;
        }
        if (isTargetScrollToBottom(1) && !supportBottomSpringBackMode()) {
            return false;
        }
        int actionMasked = motionEvent.getActionMasked();
        if (actionMasked != 0) {
            if (actionMasked != 1) {
                if (actionMasked == 2) {
                    int i = this.mActivePointerId;
                    if (i == -1) {
                        Log.e(TAG, "Got ACTION_MOVE event but don't have an active pointer id.");
                        return false;
                    }
                    int findPointerIndex = motionEvent.findPointerIndex(i);
                    if (findPointerIndex < 0) {
                        Log.e(TAG, "Got ACTION_MOVE event but have an invalid active pointer id.");
                        return false;
                    }
                    float x = motionEvent.getX(findPointerIndex);
                    boolean z = isTargetScrollToBottom(1) && isTargetScrollToTop(1);
                    if ((z || !isTargetScrollToTop(1)) && (!z || x <= this.mInitialDownX)) {
                        if (this.mInitialDownX - x > ((float) this.mTouchSlop) && !this.mIsBeingDragged) {
                            this.mIsBeingDragged = true;
                            dispatchScrollState(1);
                            this.mInitialMotionX = x;
                        }
                    } else if (x - this.mInitialDownX > ((float) this.mTouchSlop) && !this.mIsBeingDragged) {
                        this.mIsBeingDragged = true;
                        dispatchScrollState(1);
                        this.mInitialMotionX = x;
                    }
                } else if (actionMasked != 3 && actionMasked == 6) {
                    onSecondaryPointerUp(motionEvent);
                }
            }
            this.mIsBeingDragged = false;
            this.mActivePointerId = -1;
        } else {
            int pointerId = motionEvent.getPointerId(0);
            this.mActivePointerId = pointerId;
            int findPointerIndex2 = motionEvent.findPointerIndex(pointerId);
            if (findPointerIndex2 < 0) {
                return false;
            }
            this.mInitialDownX = motionEvent.getX(findPointerIndex2);
            if (getScrollX() != 0) {
                this.mIsBeingDragged = true;
                this.mInitialMotionX = this.mInitialDownX;
            } else {
                this.mIsBeingDragged = false;
            }
        }
        return this.mIsBeingDragged;
    }

    public void requestDisallowInterceptTouchEvent(boolean z) {
        if (!isEnabled() || !this.mSpringBackEnable) {
            super.requestDisallowInterceptTouchEvent(z);
        }
    }

    public void internalRequestDisallowInterceptTouchEvent(boolean z) {
        super.requestDisallowInterceptTouchEvent(z);
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

    public boolean onTouchEvent(MotionEvent motionEvent) {
        int actionMasked = motionEvent.getActionMasked();
        if (isEnabled() && !this.mNestedFlingInProgress && !this.mNestedScrollInProgress && !this.mTarget.isNestedScrollingEnabled()) {
            if (!this.mSpringScroller.isFinished() && actionMasked == 0) {
                this.mSpringScroller.forceStop();
            }
            if (isTargetScrollOrientation(2)) {
                return onVerticalTouchEvent(motionEvent);
            }
            if (isTargetScrollOrientation(1)) {
                return onHorizontalTouchEvent(motionEvent);
            }
        }
        return false;
    }

    private boolean onHorizontalTouchEvent(MotionEvent motionEvent) {
        int actionMasked = motionEvent.getActionMasked();
        if (!isTargetScrollToTop(1) && !isTargetScrollToBottom(1)) {
            return false;
        }
        if (isTargetScrollToTop(1) && isTargetScrollToBottom(1)) {
            return onScrollEvent(motionEvent, actionMasked, 1);
        }
        if (isTargetScrollToBottom(1)) {
            return onScrollUpEvent(motionEvent, actionMasked, 1);
        }
        return onScrollDownEvent(motionEvent, actionMasked, 1);
    }

    private boolean onVerticalTouchEvent(MotionEvent motionEvent) {
        int actionMasked = motionEvent.getActionMasked();
        if (!isTargetScrollToTop(2) && !isTargetScrollToBottom(2)) {
            return false;
        }
        if (isTargetScrollToTop(2) && isTargetScrollToBottom(2)) {
            return onScrollEvent(motionEvent, actionMasked, 2);
        }
        if (isTargetScrollToBottom(2)) {
            return onScrollUpEvent(motionEvent, actionMasked, 2);
        }
        return onScrollDownEvent(motionEvent, actionMasked, 2);
    }

    private boolean onScrollEvent(MotionEvent motionEvent, int i, int i2) {
        int i3;
        float f;
        float f2;
        PrizeNestedScrollLog.d(TAG, "onScrollEvent() start ... ");
        if (i == 0) {
            this.mActivePointerId = motionEvent.getPointerId(0);
            checkScrollStart(i2);
        } else if (i != 1) {
            if (i == 2) {
                int findPointerIndex = motionEvent.findPointerIndex(this.mActivePointerId);
                if (findPointerIndex < 0) {
                    Log.e(TAG, "Got ACTION_MOVE event but have an invalid active pointer id.");
                    return false;
                } else if (this.mIsBeingDragged) {
                    if (i2 == 2) {
                        float y = motionEvent.getY(findPointerIndex);
                        f = Math.signum(y - this.mInitialMotionY);
                        f2 = obtainSpringBackDistance(y - this.mInitialMotionY, i2);
                    } else {
                        float x = motionEvent.getX(findPointerIndex);
                        f = Math.signum(x - this.mInitialMotionX);
                        f2 = obtainSpringBackDistance(x - this.mInitialMotionX, i2);
                    }
                    requestDisallowParentInterceptTouchEvent(true);
                    moveTarget(f * f2, i2);
                }
            } else if (i == 3) {
                return false;
            } else {
                if (i == 5) {
                    int findPointerIndex2 = motionEvent.findPointerIndex(this.mActivePointerId);
                    if (findPointerIndex2 < 0) {
                        Log.e(TAG, "Got ACTION_POINTER_DOWN event but have an invalid active pointer id.");
                        return false;
                    }
                    if (i2 == 2) {
                        float y2 = motionEvent.getY(findPointerIndex2) - this.mInitialDownY;
                        i3 = motionEvent.getActionIndex();
                        if (i3 < 0) {
                            Log.e(TAG, "Got ACTION_POINTER_DOWN event but have an invalid action index.");
                            return false;
                        }
                        float y3 = motionEvent.getY(i3) - y2;
                        this.mInitialDownY = y3;
                        this.mInitialMotionY = y3;
                    } else {
                        float x2 = motionEvent.getX(findPointerIndex2) - this.mInitialDownX;
                        i3 = motionEvent.getActionIndex();
                        if (i3 < 0) {
                            Log.e(TAG, "Got ACTION_POINTER_DOWN event but have an invalid action index.");
                            return false;
                        }
                        float x3 = motionEvent.getX(i3) - x2;
                        this.mInitialDownX = x3;
                        this.mInitialMotionX = x3;
                    }
                    this.mActivePointerId = motionEvent.getPointerId(i3);
                } else if (i == 6) {
                    onSecondaryPointerUp(motionEvent);
                }
            }
        } else if (motionEvent.findPointerIndex(this.mActivePointerId) < 0) {
            Log.e(TAG, "Got ACTION_UP event but don't have an active pointer id.");
            return false;
        } else {
            if (this.mIsBeingDragged) {
                this.mIsBeingDragged = false;
                PrizeNestedScrollLog.d(TAG, "onScrollEvent springBack ...");
                springBack(i2);
            }
            this.mActivePointerId = -1;
            return false;
        }
        return true;
    }

    private void checkVerticalScrollStart() {
        PrizeNestedScrollLog.d(TAG, "checkVerticalScrollStart() start ... ");
        if (getScrollY() != 0) {
            this.mIsBeingDragged = true;
            float obtainTouchDistance = obtainTouchDistance((float) Math.abs(getScrollY()), 2);
            if (getScrollY() < 0) {
                this.mInitialDownY -= obtainTouchDistance;
            } else {
                this.mInitialDownY += obtainTouchDistance;
            }
            this.mInitialMotionY = this.mInitialDownY;
            return;
        }
        this.mIsBeingDragged = false;
    }

    private void checkScrollStart(int i) {
        if (i == 2) {
            checkVerticalScrollStart();
        } else {
            checkHorizontalScrollStart();
        }
    }

    private void checkHorizontalScrollStart() {
        if (getScrollX() != 0) {
            this.mIsBeingDragged = true;
            float obtainTouchDistance = obtainTouchDistance((float) Math.abs(getScrollX()), 2);
            if (getScrollX() < 0) {
                this.mInitialDownX -= obtainTouchDistance;
            } else {
                this.mInitialDownX += obtainTouchDistance;
            }
            this.mInitialMotionX = this.mInitialDownX;
            return;
        }
        this.mIsBeingDragged = false;
    }

    private boolean onScrollDownEvent(MotionEvent motionEvent, int i, int i2) {
        int i3;
        float f;
        float f2;
        PrizeNestedScrollLog.d(TAG, "onScrollDownEvent() start ... ");
        if (i == 0) {
            this.mActivePointerId = motionEvent.getPointerId(0);
            checkScrollStart(i2);
        } else if (i != 1) {
            if (i == 2) {
                int findPointerIndex = motionEvent.findPointerIndex(this.mActivePointerId);
                if (findPointerIndex < 0) {
                    Log.e(TAG, "Got ACTION_MOVE event but have an invalid active pointer id.");
                    return false;
                } else if (this.mIsBeingDragged) {
                    if (i2 == 2) {
                        float y = motionEvent.getY(findPointerIndex);
                        f = Math.signum(y - this.mInitialMotionY);
                        f2 = obtainSpringBackDistance(y - this.mInitialMotionY, i2);
                    } else {
                        float x = motionEvent.getX(findPointerIndex);
                        f = Math.signum(x - this.mInitialMotionX);
                        f2 = obtainSpringBackDistance(x - this.mInitialMotionX, i2);
                    }
                    float f3 = f * f2;
                    if (f3 > 0.0f) {
                        requestDisallowParentInterceptTouchEvent(true);
                        moveTarget(f3, i2);
                    } else {
                        moveTarget(0.0f, i2);
                        return false;
                    }
                }
            } else if (i == 3) {
                return false;
            } else {
                if (i == 5) {
                    int findPointerIndex2 = motionEvent.findPointerIndex(this.mActivePointerId);
                    if (findPointerIndex2 < 0) {
                        Log.e(TAG, "Got ACTION_POINTER_DOWN event but have an invalid active pointer id.");
                        return false;
                    }
                    if (i2 == 2) {
                        float y2 = motionEvent.getY(findPointerIndex2) - this.mInitialDownY;
                        i3 = motionEvent.getActionIndex();
                        if (i3 < 0) {
                            Log.e(TAG, "Got ACTION_POINTER_DOWN event but have an invalid action index.");
                            return false;
                        }
                        float y3 = motionEvent.getY(i3) - y2;
                        this.mInitialDownY = y3;
                        this.mInitialMotionY = y3;
                    } else {
                        float x2 = motionEvent.getX(findPointerIndex2) - this.mInitialDownX;
                        i3 = motionEvent.getActionIndex();
                        if (i3 < 0) {
                            Log.e(TAG, "Got ACTION_POINTER_DOWN event but have an invalid action index.");
                            return false;
                        }
                        float x3 = motionEvent.getX(i3) - x2;
                        this.mInitialDownX = x3;
                        this.mInitialMotionX = x3;
                    }
                    this.mActivePointerId = motionEvent.getPointerId(i3);
                } else if (i == 6) {
                    onSecondaryPointerUp(motionEvent);
                }
            }
        } else if (motionEvent.findPointerIndex(this.mActivePointerId) < 0) {
            Log.e(TAG, "Got ACTION_UP event but don't have an active pointer id.");
            return false;
        } else {
            if (this.mIsBeingDragged) {
                this.mIsBeingDragged = false;
                PrizeNestedScrollLog.d(TAG, "onScrollDownEvent springBack ...");
                springBack(i2);
            }
            this.mActivePointerId = -1;
            return false;
        }
        return true;
    }

    private void moveTarget(float f, int i) {
        PrizeNestedScrollLog.d(TAG, "moveTarget() start ... distance: " + f);
        if (i == 2) {
            scrollTo(0, (int) (-f));
        } else {
            scrollTo((int) (-f), 0);
        }
    }

    private void springBack(int i) {
        springBack(0.0f, i, true);
    }

    private void springBack(float f, int i, boolean z) {
        OnSpringListener onSpringListener = this.mOnSpringListener;
        if (onSpringListener == null || !onSpringListener.onSpringBack()) {
            this.mSpringScroller.forceStop();
            this.mSpringScroller.scrollByFling((float) getScrollX(), 0.0f, (float) getScrollY(), 0.0f, f, i, false);
            dispatchScrollState(2);
            if (z) {
                postInvalidateOnAnimation();
            }
        }
    }

    private boolean onScrollUpEvent(MotionEvent motionEvent, int i, int i2) {
        int i3;
        float f;
        float f2;
        PrizeNestedScrollLog.d(TAG, "onScrollUpEvent() start ... ");
        if (i == 0) {
            this.mActivePointerId = motionEvent.getPointerId(0);
            checkScrollStart(i2);
        } else if (i != 1) {
            if (i == 2) {
                int findPointerIndex = motionEvent.findPointerIndex(this.mActivePointerId);
                if (findPointerIndex < 0) {
                    Log.e(TAG, "Got ACTION_MOVE event but have an invalid active pointer id.");
                    return false;
                } else if (this.mIsBeingDragged) {
                    if (i2 == 2) {
                        float y = motionEvent.getY(findPointerIndex);
                        f = Math.signum(this.mInitialMotionY - y);
                        f2 = obtainSpringBackDistance(this.mInitialMotionY - y, i2);
                    } else {
                        float x = motionEvent.getX(findPointerIndex);
                        f = Math.signum(this.mInitialMotionX - x);
                        f2 = obtainSpringBackDistance(this.mInitialMotionX - x, i2);
                    }
                    float f3 = f * f2;
                    if (f3 > 0.0f) {
                        requestDisallowParentInterceptTouchEvent(true);
                        moveTarget(-f3, i2);
                    } else {
                        moveTarget(0.0f, i2);
                        return false;
                    }
                }
            } else if (i == 3) {
                return false;
            } else {
                if (i == 5) {
                    int findPointerIndex2 = motionEvent.findPointerIndex(this.mActivePointerId);
                    if (findPointerIndex2 < 0) {
                        Log.e(TAG, "Got ACTION_POINTER_DOWN event but have an invalid active pointer id.");
                        return false;
                    }
                    if (i2 == 2) {
                        float y2 = motionEvent.getY(findPointerIndex2) - this.mInitialDownY;
                        i3 = motionEvent.getActionIndex();
                        if (i3 < 0) {
                            Log.e(TAG, "Got ACTION_POINTER_DOWN event but have an invalid action index.");
                            return false;
                        }
                        float y3 = motionEvent.getY(i3) - y2;
                        this.mInitialDownY = y3;
                        this.mInitialMotionY = y3;
                    } else {
                        float x2 = motionEvent.getX(findPointerIndex2) - this.mInitialDownX;
                        i3 = motionEvent.getActionIndex();
                        if (i3 < 0) {
                            Log.e(TAG, "Got ACTION_POINTER_DOWN event but have an invalid action index.");
                            return false;
                        }
                        float x3 = motionEvent.getX(i3) - x2;
                        this.mInitialDownX = x3;
                        this.mInitialMotionX = x3;
                    }
                    this.mActivePointerId = motionEvent.getPointerId(i3);
                } else if (i == 6) {
                    onSecondaryPointerUp(motionEvent);
                }
            }
        } else if (motionEvent.findPointerIndex(this.mActivePointerId) < 0) {
            Log.e(TAG, "Got ACTION_UP event but don't have an active pointer id.");
            return false;
        } else {
            if (this.mIsBeingDragged) {
                this.mIsBeingDragged = false;
                PrizeNestedScrollLog.d(TAG, "onScrollUpEvent springBack ...");
                springBack(i2);
            }
            this.mActivePointerId = -1;
            return false;
        }
        return true;
    }

    private void onSecondaryPointerUp(MotionEvent motionEvent) {
        int actionIndex = motionEvent.getActionIndex();
        if (motionEvent.getPointerId(actionIndex) == this.mActivePointerId) {
            this.mActivePointerId = motionEvent.getPointerId(actionIndex == 0 ? 1 : 0);
        }
    }

    private float obtainSpringBackDistance(float f, int i) {
        return obtainDampingDistance(Math.min(Math.abs(f) / ((float) (i == 2 ? this.mScreenHeight : this.mScreenWith)), 1.0f), i);
    }

    private float obtainMaxSpringBackDistance(int i) {
        return obtainDampingDistance(1.0f, i);
    }

    private float obtainDampingDistance(float f, int i) {
        int i2 = i == 2 ? this.mScreenHeight : this.mScreenWith;
        double min = (double) Math.min(f, 1.0f);
        return ((float) (((Math.pow(min, 3.0d) / 3.0d) - Math.pow(min, 2.0d)) + min)) * ((float) i2);
    }

    private float obtainTouchDistance(float f, int i) {
        int i2 = i == 2 ? this.mScreenHeight : this.mScreenWith;
        double d = (double) i2;
        return (float) (d - (Math.pow(d, 0.6666666666666666d) * Math.pow((double) (((float) i2) - (f * 3.0f)), 0.3333333333333333d)));
    }

    public void onNestedScroll(@NonNull View view, int i, int i2, int i3, int i4, int i5, @NonNull int[] iArr) {
        int i6 = i5;
        PrizeNestedScrollLog.d("onNesteddtUnConsumed", "onNestedScroll() start type ... " + i6);
        int i7 = 0;
        boolean z = this.mNestedScrollAxes == 2;
        int i8 = z ? i2 : i;
        int i9 = z ? iArr[1] : iArr[0];
        dispatchNestedScroll(i, i2, i3, i4, this.mParentOffsetInWindow, i5, iArr);
        if (this.mSpringBackEnable) {
            int i10 = (z ? iArr[1] : iArr[0]) - i9;
            int i11 = z ? i4 - i10 : i3 - i10;
            if (i11 != 0) {
                i7 = i11;
            }
            int i12 = z ? 2 : 1;
            PrizeNestedScrollLog.d("onNesteddtUnConsumed", "onNestedScroll() dtUnConsumed: " + i7 + " this.mTotalFlingUnconsumed: " + this.mTotalFlingUnconsumed + " this.mSpringScroller.isFinished(): " + this.mSpringScroller.isFinished() + " this.mVelocityY: " + this.mVelocityY + " this.mScrollByFling: " + this.mScrollByFling + " isTargetScrollToTop(axis): " + isTargetScrollToTop(i12) + " isTargetScrollToBottom(axis): " + isTargetScrollToBottom(i12));
            if (i7 >= 0 || !isTargetScrollToTop(i12) || !supportTopSpringBackMode()) {
                PrizeNestedScrollLog.d("onNesteddtUnConsumed", "onNestedScroll() 1 ");
                if (i7 > 0 && isTargetScrollToBottom(i12) && supportBottomSpringBackMode()) {
                    PrizeNestedScrollLog.d("onNesteddtUnConsumed", "onNestedScroll() 2 ");
                    if (i6 != 0) {
                        float obtainMaxSpringBackDistance = obtainMaxSpringBackDistance(i12);
                        if (this.mVelocityY != 0.0f || this.mVelocityX != 0.0f) {
                            this.mScrollByFling = true;
                            if (i8 != 0 && ((float) i7) <= obtainMaxSpringBackDistance) {
                                this.mSpringScroller.setFirstStep(i7);
                            }
                            dispatchScrollState(2);
                        } else if (this.mTotalScrollBottomUnconsumed == 0.0f) {
                            float f = obtainMaxSpringBackDistance - this.mTotalFlingUnconsumed;
                            if (this.consumeNestFlingCounter < 4) {
                                if (f <= ((float) Math.abs(i7))) {
                                    this.mTotalFlingUnconsumed += f;
                                    iArr[1] = (int) (((float) iArr[1]) + f);
                                } else {
                                    this.mTotalFlingUnconsumed += (float) Math.abs(i7);
                                    iArr[1] = iArr[1] + i11;
                                }
                                PrizeNestedScrollLog.d("onNesteddtUnConsumed", "onNestedScroll() 3 mTotalFlingUnconsumed: " + this.mTotalFlingUnconsumed);
                                dispatchScrollState(2);
                                moveTarget(-obtainSpringBackDistance(this.mTotalFlingUnconsumed, i12), i12);
                                this.consumeNestFlingCounter = this.consumeNestFlingCounter + 1;
                                return;
                            }
                            springBack(i12);
                        }
                    } else if (this.mSpringScroller.isFinished()) {
                        PrizeNestedScrollLog.d("onNesteddtUnConsumed", "onNestedScroll() 4 isFinished() this.mTotalScrollBottomUnconsumed: " + this.mTotalScrollBottomUnconsumed + " currentNestedScrollY: " + (z ? computeVerticalScrollOffset() : computeHorizontalScrollOffset()));
                        this.mTotalScrollBottomUnconsumed = this.mTotalScrollBottomUnconsumed + ((float) Math.abs(i7));
                        dispatchScrollState(1);
                        moveTarget(-obtainSpringBackDistance(this.mTotalScrollBottomUnconsumed, i12), i12);
                        iArr[1] = iArr[1] + i11;
                    }
                }
            } else if (i6 != 0) {
                float obtainMaxSpringBackDistance2 = obtainMaxSpringBackDistance(i12);
                PrizeNestedScrollLog.d("onNesteddtUnConsumed", "onNestedScroll() TYPE_NOT_TOUCH obtainMaxSpringBackDistance2: " + obtainMaxSpringBackDistance2 + " this.mTotalScrollTopUnconsumed: " + this.mTotalScrollTopUnconsumed + " mTotalFlingUnconsumed: " + this.mTotalFlingUnconsumed + " this.consumeNestFlingCounter: " + this.consumeNestFlingCounter);
                if (this.mVelocityY != 0.0f || this.mVelocityX != 0.0f) {
                    this.mScrollByFling = true;
                    if (i8 != 0 && ((float) (-i7)) <= obtainMaxSpringBackDistance2) {
                        this.mSpringScroller.setFirstStep(i7);
                    }
                    PrizeNestedScrollLog.d("onNesteddtUnConsumed", "onNestedScroll() TYPE_NOT_TOUCH 1 ");
                    dispatchScrollState(2);
                } else if (this.mTotalScrollTopUnconsumed == 0.0f) {
                    float f2 = obtainMaxSpringBackDistance2 - this.mTotalFlingUnconsumed;
                    PrizeNestedScrollLog.d("onNesteddtUnConsumed", "onNestedScroll() TYPE_NOT_TOUCH 2 ");
                    if (this.consumeNestFlingCounter < 4) {
                        if (f2 <= ((float) Math.abs(i7))) {
                            this.mTotalFlingUnconsumed += f2;
                            iArr[1] = (int) (((float) iArr[1]) + f2);
                        } else {
                            this.mTotalFlingUnconsumed += (float) Math.abs(i7);
                            iArr[1] = iArr[1] + i11;
                        }
                        PrizeNestedScrollLog.d("onNesteddtUnConsumed", "onNestedScroll() TYPE_NOT_TOUCH 3 mTotalFlingUnconsumed: " + this.mTotalFlingUnconsumed);
                        dispatchScrollState(2);
                        moveTarget(obtainSpringBackDistance(this.mTotalFlingUnconsumed, i12), i12);
                        this.consumeNestFlingCounter = this.consumeNestFlingCounter + 1;
                        return;
                    }
                    springBack(i12);
                }
            } else if (this.mSpringScroller.isFinished()) {
                PrizeNestedScrollLog.d("onNesteddtUnConsumed", "onNestedScroll() this.mSpringScroller.isFinished()  ");
                this.mTotalScrollTopUnconsumed += (float) Math.abs(i7);
                dispatchScrollState(1);
                moveTarget(obtainSpringBackDistance(this.mTotalScrollTopUnconsumed, i12), i12);
                iArr[1] = iArr[1] + i11;
            } else {
                PrizeNestedScrollLog.d("onNesteddtUnConsumed", "onNestedScroll() else .... ");
            }
        }
    }

    public void onNestedScroll(@NonNull View view, int i, int i2, int i3, int i4, int i5) {
        PrizeNestedScrollLog.d(TAG, "onNestedScroll() start2 ... ");
        onNestedScroll(view, i, i2, i3, i4, i5, this.mNestedScrollingV2ConsumedCompat);
    }

    public void onNestedScroll(View view, int i, int i2, int i3, int i4) {
        PrizeNestedScrollLog.d(TAG, "onNestedScroll() TYPE_TOUCH start ... ");
        onNestedScroll(view, i, i2, i3, i4, 0, this.mNestedScrollingV2ConsumedCompat);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:20:0x004a, code lost:
        if ((r4.mTarget instanceof androidx.core.widget.NestedScrollView) != false) goto L_0x004c;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean onStartNestedScroll(@androidx.annotation.NonNull android.view.View r5, @androidx.annotation.NonNull android.view.View r6, int r7, int r8) {
        /*
            r4 = this;
            java.lang.StringBuilder r6 = new java.lang.StringBuilder
            r6.<init>()
            java.lang.String r0 = "onStartNestedScroll() start ... type:  "
            r6.append(r0)
            r6.append(r8)
            java.lang.String r6 = r6.toString()
            java.lang.String r0 = "SpringBackLayout"
            com.pri.didouix.util.PrizeNestedScrollLog.d((java.lang.String) r0, (java.lang.String) r6)
            boolean r6 = r4.mSpringBackEnable
            r0 = 1
            if (r6 == 0) goto L_0x004d
            r4.mNestedScrollAxes = r7
            r6 = 2
            r1 = 0
            if (r7 != r6) goto L_0x0023
            r2 = r0
            goto L_0x0024
        L_0x0023:
            r2 = r1
        L_0x0024:
            if (r2 != 0) goto L_0x0027
            r6 = r0
        L_0x0027:
            int r3 = r4.mOriginScrollOrientation
            r6 = r6 & r3
            if (r6 == 0) goto L_0x004c
            boolean r5 = r4.onStartNestedScroll(r5, r5, r7)
            if (r5 != 0) goto L_0x0033
            goto L_0x004c
        L_0x0033:
            if (r2 == 0) goto L_0x003a
            int r5 = r4.getScrollY()
            goto L_0x003e
        L_0x003a:
            int r5 = r4.getScrollX()
        L_0x003e:
            float r5 = (float) r5
            if (r8 == 0) goto L_0x004d
            r6 = 0
            int r5 = (r5 > r6 ? 1 : (r5 == r6 ? 0 : -1))
            if (r5 == 0) goto L_0x004d
            android.view.View r5 = r4.mTarget
            boolean r5 = r5 instanceof androidx.core.widget.NestedScrollView
            if (r5 == 0) goto L_0x004d
        L_0x004c:
            return r1
        L_0x004d:
            androidx.core.view.NestedScrollingChildHelper r4 = r4.mNestedScrollingChildHelper
            r4.startNestedScroll(r7, r8)
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: com.pri.didouix.springback.view.SpringBackLayout.onStartNestedScroll(android.view.View, android.view.View, int, int):boolean");
    }

    public boolean onStartNestedScroll(View view, View view2, int i) {
        PrizeNestedScrollLog.d(TAG, "onStartNestedScroll() start ...  ");
        return isEnabled();
    }

    public void onNestedScrollAccepted(@NonNull View view, @NonNull View view2, int i, int i2) {
        PrizeNestedScrollLog.d(TAG, "onNestedScrollAccepted() start ... type: " + i2);
        if (this.mSpringBackEnable) {
            int i3 = 2;
            boolean z = this.mNestedScrollAxes == 2;
            if (!z) {
                i3 = 1;
            }
            float scrollY = (float) (z ? getScrollY() : getScrollX());
            PrizeNestedScrollLog.d(TAG, "onNestedScrollAccepted() scrollY: " + scrollY);
            if (i2 != 0) {
                if (scrollY == 0.0f) {
                    this.mTotalFlingUnconsumed = 0.0f;
                } else {
                    this.mTotalFlingUnconsumed = obtainTouchDistance(Math.abs(scrollY), i3);
                }
                this.mNestedFlingInProgress = true;
                this.consumeNestFlingCounter = 0;
            } else {
                if (scrollY == 0.0f) {
                    this.mTotalScrollTopUnconsumed = 0.0f;
                    this.mTotalScrollBottomUnconsumed = 0.0f;
                } else if (scrollY < 0.0f) {
                    this.mTotalScrollTopUnconsumed = obtainTouchDistance(Math.abs(scrollY), i3);
                    this.mTotalScrollBottomUnconsumed = 0.0f;
                } else {
                    this.mTotalScrollTopUnconsumed = 0.0f;
                    this.mTotalScrollBottomUnconsumed = obtainTouchDistance(Math.abs(scrollY), i3);
                }
                this.mNestedScrollInProgress = true;
            }
            this.mVelocityY = 0.0f;
            this.mVelocityX = 0.0f;
            this.mScrollByFling = false;
            this.mSpringScroller.forceStop();
        }
        onNestedScrollAccepted(view, view2, i);
    }

    public void onNestedScrollAccepted(View view, View view2, int i) {
        PrizeNestedScrollLog.d(TAG, "onNestedScrollAccepted() start ... ");
        this.mNestedScrollingParentHelper.onNestedScrollAccepted(view, view2, i);
        startNestedScroll(i & 2);
    }

    public void onNestedPreScroll(@NonNull View view, int i, int i2, @NonNull int[] iArr, int i3) {
        PrizeNestedScrollLog.d(TAG, "onNestedPreScroll() start ...type " + i3);
        if (this.mSpringBackEnable) {
            if (this.mNestedScrollAxes == 2) {
                onNestedPreScroll(i2, iArr, i3);
            } else {
                onNestedPreScroll(i, iArr, i3);
            }
        }
        int[] iArr2 = this.mParentScrollConsumed;
        if (dispatchNestedPreScroll(i - iArr[0], i2 - iArr[1], iArr2, (int[]) null, i3)) {
            iArr[0] = iArr[0] + iArr2[0];
            iArr[1] = iArr[1] + iArr2[1];
        }
    }

    private void onNestedPreScroll(int i, @NonNull int[] iArr, int i2) {
        boolean z = this.mNestedScrollAxes == 2;
        int i3 = z ? 2 : 1;
        int abs = Math.abs(z ? getScrollY() : getScrollX());
        PrizeNestedScrollLog.d(TAG, "onNestedPreScroll() start2 ...type " + i2 + " getScrollY: " + abs + " dy: " + i + " mTotalScrollTopUnconsumed: " + this.mTotalScrollTopUnconsumed + " mTotalScrollBottomUnconsumed: " + this.mTotalScrollBottomUnconsumed);
        float f = 0.0f;
        if (i2 == 0) {
            if (i > 0) {
                float f2 = this.mTotalScrollTopUnconsumed;
                if (f2 > 0.0f) {
                    float f3 = (float) i;
                    if (f3 > f2) {
                        consumeDelta((int) f2, iArr, i3);
                        this.mTotalScrollTopUnconsumed = 0.0f;
                    } else {
                        this.mTotalScrollTopUnconsumed = f2 - f3;
                        consumeDelta(i, iArr, i3);
                    }
                    dispatchScrollState(1);
                    moveTarget(obtainSpringBackDistance(this.mTotalScrollTopUnconsumed, i3), i3);
                    return;
                }
            }
            if (i < 0) {
                float f4 = this.mTotalScrollBottomUnconsumed;
                float f5 = -f4;
                if (f5 < 0.0f) {
                    float f6 = (float) i;
                    if (f6 < f5) {
                        consumeDelta((int) f4, iArr, i3);
                        this.mTotalScrollBottomUnconsumed = 0.0f;
                    } else {
                        this.mTotalScrollBottomUnconsumed = f4 + f6;
                        consumeDelta(i, iArr, i3);
                    }
                    dispatchScrollState(1);
                    moveTarget(-obtainSpringBackDistance(this.mTotalScrollBottomUnconsumed, i3), i3);
                    return;
                }
                return;
            }
            return;
        }
        float f7 = i3 == 2 ? this.mVelocityY : this.mVelocityX;
        PrizeNestedScrollLog.d(TAG, "onNestedPreScroll() f6 mVelocityY: " + this.mVelocityY + " this.mScrollByFling: " + this.mScrollByFling);
        if (i > 0) {
            float f8 = this.mTotalScrollTopUnconsumed;
            if (f8 > 0.0f) {
                if (f7 > 2000.0f) {
                    float obtainSpringBackDistance = obtainSpringBackDistance(f8, i3);
                    float f9 = (float) i;
                    if (f9 > obtainSpringBackDistance) {
                        consumeDelta((int) obtainSpringBackDistance, iArr, i3);
                        this.mTotalScrollTopUnconsumed = 0.0f;
                    } else {
                        consumeDelta(i, iArr, i3);
                        f = obtainSpringBackDistance - f9;
                        this.mTotalScrollTopUnconsumed = obtainTouchDistance(f, i3);
                    }
                    PrizeNestedScrollLog.d(TAG, "onNestedPreScroll() obtainSpringBackDistance: " + obtainSpringBackDistance);
                    moveTarget(f, i3);
                    dispatchScrollState(1);
                    return;
                }
                if (!this.mScrollByFling) {
                    this.mScrollByFling = true;
                    PrizeNestedScrollLog.d(TAG, "onNestedPreScroll springBack Slide up ...");
                    springBack(f7, i3, false);
                }
                if (this.mSpringScroller.computeScrollOffset()) {
                    scrollTo(this.mSpringScroller.getCurrX(), this.mSpringScroller.getCurrY());
                    this.mTotalScrollTopUnconsumed = obtainTouchDistance((float) abs, i3);
                } else {
                    this.mTotalScrollTopUnconsumed = 0.0f;
                }
                PrizeNestedScrollLog.d(TAG, "onNestedPreScroll() mTotalScrollTopUnconsumed: " + this.mTotalScrollTopUnconsumed);
                consumeDelta(i, iArr, i3);
                return;
            }
        }
        if (i < 0) {
            float f10 = this.mTotalScrollBottomUnconsumed;
            if ((-f10) < 0.0f) {
                if (f7 < -2000.0f) {
                    float obtainSpringBackDistance2 = obtainSpringBackDistance(f10, i3);
                    float f11 = (float) i;
                    if (f11 < (-obtainSpringBackDistance2)) {
                        consumeDelta((int) obtainSpringBackDistance2, iArr, i3);
                        this.mTotalScrollBottomUnconsumed = 0.0f;
                    } else {
                        consumeDelta(i, iArr, i3);
                        f = obtainSpringBackDistance2 + f11;
                        this.mTotalScrollBottomUnconsumed = obtainTouchDistance(f, i3);
                    }
                    PrizeNestedScrollLog.d(TAG, "onNestedPreScroll() obtainSpringBackDistance2: " + obtainSpringBackDistance2);
                    dispatchScrollState(1);
                    moveTarget(-f, i3);
                    return;
                }
                if (!this.mScrollByFling) {
                    this.mScrollByFling = true;
                    PrizeNestedScrollLog.d(TAG, "onNestedPreScroll springBack Slide down ...");
                    springBack(f7, i3, false);
                }
                if (this.mSpringScroller.computeScrollOffset()) {
                    scrollTo(this.mSpringScroller.getCurrX(), this.mSpringScroller.getCurrY());
                    this.mTotalScrollBottomUnconsumed = obtainTouchDistance((float) abs, i3);
                } else {
                    this.mTotalScrollBottomUnconsumed = 0.0f;
                }
                PrizeNestedScrollLog.d(TAG, "onNestedPreScroll() mTotalScrollTopUnconsumed2: " + this.mTotalScrollTopUnconsumed);
                consumeDelta(i, iArr, i3);
                return;
            }
        }
        if (i != 0) {
            if ((this.mTotalScrollBottomUnconsumed == 0.0f || this.mTotalScrollTopUnconsumed == 0.0f) && this.mScrollByFling && getScrollY() == 0) {
                consumeDelta(i, iArr, i3);
            }
        }
    }

    private void consumeDelta(int i, @NonNull int[] iArr, int i2) {
        if (i2 == 2) {
            iArr[1] = i;
        } else {
            iArr[0] = i;
        }
    }

    public void setNestedScrollingEnabled(boolean z) {
        this.mNestedScrollingChildHelper.setNestedScrollingEnabled(z);
    }

    public boolean isNestedScrollingEnabled() {
        PrizeNestedScrollLog.d(TAG, "isNestedScrollingEnabled() start ... ");
        return this.mNestedScrollingChildHelper.isNestedScrollingEnabled();
    }

    public void onStopNestedScroll(@NonNull View view, int i) {
        PrizeNestedScrollLog.d(TAG, "onStopNestedScroll springBack start .... " + i);
        this.mNestedScrollingParentHelper.onStopNestedScroll(view, i);
        stopNestedScroll(i);
        if (this.mSpringBackEnable) {
            int i2 = 1;
            boolean z = this.mNestedScrollAxes == 2;
            if (z) {
                i2 = 2;
            }
            if (this.mNestedScrollInProgress) {
                this.mNestedScrollInProgress = false;
                float scrollY = (float) (z ? getScrollY() : getScrollX());
                if (!this.mNestedFlingInProgress && scrollY != 0.0f) {
                    springBack(i2);
                } else if (scrollY != 0.0f) {
                    dispatchScrollState(2);
                }
                PrizeNestedScrollLog.d(TAG, "onStopNestedScroll springBack 1.");
            } else if (this.mNestedFlingInProgress) {
                this.mNestedFlingInProgress = false;
                if (this.mScrollByFling) {
                    if (this.mSpringScroller.isFinished()) {
                        PrizeNestedScrollLog.d(TAG, "onStopNestedScroll springBack 2.");
                        springBack(i2 == 2 ? this.mVelocityY : this.mVelocityX, i2, false);
                    }
                    postInvalidateOnAnimation();
                    return;
                }
                PrizeNestedScrollLog.d(TAG, "onStopNestedScroll springBack 3.");
                springBack(i2);
            } else {
                springBack(i2);
                PrizeNestedScrollLog.d(TAG, "onStopNestedScroll springBack 4.");
            }
            PrizeNestedScrollLog.d(TAG, "onStopNestedScroll springBack end ....");
        }
    }

    public void stopNestedScroll() {
        PrizeNestedScrollLog.d(TAG, "stopNestedScroll start ....");
        this.mNestedScrollingChildHelper.stopNestedScroll();
    }

    public boolean onNestedFling(@NonNull View view, float f, float f2, boolean z) {
        PrizeNestedScrollLog.d(TAG, "onNestedFling start ....");
        return dispatchNestedFling(f, f2, z);
    }

    public boolean onNestedPreFling(@NonNull View view, float f, float f2) {
        PrizeNestedScrollLog.d(TAG, "onNestedPreFling start ....");
        return dispatchNestedPreFling(f, f2);
    }

    public void dispatchNestedScroll(int i, int i2, int i3, int i4, @Nullable int[] iArr, int i5, @NonNull int[] iArr2) {
        PrizeNestedScrollLog.d(TAG, "dispatchNestedScroll start2 ....");
        this.mNestedScrollingChildHelper.dispatchNestedScroll(i, i2, i3, i4, iArr, i5, iArr2);
    }

    public boolean startNestedScroll(int i, int i2) {
        PrizeNestedScrollLog.d(TAG, "startNestedScroll start ....");
        return this.mNestedScrollingChildHelper.startNestedScroll(i, i2);
    }

    public boolean startNestedScroll(int i) {
        PrizeNestedScrollLog.d(TAG, "startNestedScroll start2 ....");
        return this.mNestedScrollingChildHelper.startNestedScroll(i);
    }

    public void stopNestedScroll(int i) {
        PrizeNestedScrollLog.d(TAG, "stopNestedScroll start ....");
        this.mNestedScrollingChildHelper.stopNestedScroll(i);
    }

    public boolean hasNestedScrollingParent(int i) {
        PrizeNestedScrollLog.d(TAG, "hasNestedScrollingParent start ....");
        return this.mNestedScrollingChildHelper.hasNestedScrollingParent(i);
    }

    public boolean dispatchNestedScroll(int i, int i2, int i3, int i4, int[] iArr, int i5) {
        PrizeNestedScrollLog.d(TAG, "dispatchNestedScroll start ....");
        return this.mNestedScrollingChildHelper.dispatchNestedScroll(i, i2, i3, i4, iArr, i5);
    }

    public boolean dispatchNestedPreScroll(int i, int i2, int[] iArr, int[] iArr2, int i3) {
        PrizeNestedScrollLog.d(TAG, "dispatchNestedPreScroll start ....");
        return this.mNestedScrollingChildHelper.dispatchNestedPreScroll(i, i2, iArr, iArr2, i3);
    }

    public boolean dispatchNestedPreFling(float f, float f2) {
        PrizeNestedScrollLog.d(TAG, "dispatchNestedPreFling start ....");
        return this.mNestedScrollingChildHelper.dispatchNestedPreFling(f, f2);
    }

    public boolean dispatchNestedFling(float f, float f2, boolean z) {
        PrizeNestedScrollLog.d(TAG, "dispatchNestedFling start ....");
        return this.mNestedScrollingChildHelper.dispatchNestedFling(f, f2, z);
    }

    public boolean dispatchNestedPreScroll(int i, int i2, int[] iArr, int[] iArr2) {
        PrizeNestedScrollLog.d(TAG, "dispatchNestedPreScroll start ....");
        return this.mNestedScrollingChildHelper.dispatchNestedPreScroll(i, i2, iArr, iArr2);
    }

    public void smoothScrollTo(int i, int i2) {
        if (i - getScrollX() != 0 || i2 - getScrollY() != 0) {
            this.mSpringScroller.forceStop();
            this.mSpringScroller.scrollByFling((float) getScrollX(), (float) i, (float) getScrollY(), (float) i2, 0.0f, 2, true);
            dispatchScrollState(2);
            postInvalidateOnAnimation();
        }
    }

    private void dispatchScrollState(int i) {
        int i2 = this.mScrollState;
        if (i2 != i) {
            this.mScrollState = i;
            for (OnScrollListener onStateChanged : this.mOnScrollListeners) {
                onStateChanged.onStateChanged(i2, i, this.mSpringScroller.isFinished());
            }
        }
    }

    public void addOnScrollListener(OnScrollListener onScrollListener) {
        this.mOnScrollListeners.add(onScrollListener);
    }

    public void removeOnScrollListener(OnScrollListener onScrollListener) {
        this.mOnScrollListeners.remove(onScrollListener);
    }

    public void setOnSpringListener(OnSpringListener onSpringListener) {
        this.mOnSpringListener = onSpringListener;
    }

    public boolean hasSpringListener() {
        return this.mOnSpringListener != null;
    }

    public boolean onNestedCurrentFling(float f, float f2) {
        this.mVelocityX = f;
        this.mVelocityY = f2;
        return true;
    }
}
