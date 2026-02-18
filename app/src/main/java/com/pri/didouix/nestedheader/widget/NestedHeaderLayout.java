package com.pri.didouix.nestedheader.widget;

import android.animation.ValueAnimator;
import android.content.Context;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.LinearInterpolator;
import androidx.annotation.RequiresApi;
import com.pri.R;
import com.pri.didouix.nestedheader.widget.NestedScrollingLayout;
import java.util.ArrayList;
import java.util.List;
/* loaded from: classes4.dex */
public class NestedHeaderLayout extends NestedScrollingLayout {
    private static final String TAG = "NestedHeaderLayout";
    public boolean isAniming;
    public boolean isTouch;
    public boolean mAutoAnim;
    private int mHeaderBottomMargin;
    private int mHeaderContentId;
    private float mHeaderContentMinHeight;
    private View mHeaderContentView;
    private int mHeaderInitTop;
    private int mHeaderMeasuredHeight;
    private int mHeaderTopmMargin;
    private View mHeaderView;
    private int mHeaderViewId;
    private int mLastScrollingProgress;
    private NestedHeaderChangedListener mNestedHeaderChangedListener;
    private NestedScrollingLayout.OnNestedChangedListener mOnNestedChangedListener;
    private float mRangeOffset;
    public int mScrollingFrom;
    public int mScrollingTo;
    private int mTriggerBottomMargin;
    private int mTriggerContentId;
    private float mTriggerContentMinHeight;
    private View mTriggerContentView;
    private int mTriggerMeasuredHeight;
    private int mTriggerTopmMargin;
    private View mTriggerView;
    private int mTriggerViewId;

    /* loaded from: classes4.dex */
    public interface NestedHeaderChangedListener {
        void onHeaderClosed(View view);

        void onHeaderOpened(View view);

        void onTriggerClosed(View view);

        void onTriggerOpened(View view);
    }

    public void setNestedHeaderChangedListener(NestedHeaderChangedListener nestedHeaderChangedListener) {
        this.mNestedHeaderChangedListener = nestedHeaderChangedListener;
    }

    public void removeNestedHeaderChangedListener() {
        this.mNestedHeaderChangedListener = null;
    }

    public NestedHeaderLayout(Context context) {
        this(context, null);
    }

    public NestedHeaderLayout(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public NestedHeaderLayout(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        this.mHeaderBottomMargin = 0;
        this.mHeaderTopmMargin = 0;
        this.mTriggerBottomMargin = 0;
        this.mTriggerTopmMargin = 0;
        this.mHeaderInitTop = 0;
        this.mHeaderMeasuredHeight = 0;
        this.mTriggerMeasuredHeight = 0;
        this.mLastScrollingProgress = 0;
        this.isAniming = false;
        this.isTouch = false;
        this.mAutoAnim = true;
        this.mOnNestedChangedListener = new NestedScrollingLayout.OnNestedChangedListener() { // from class: com.pri.didouix.nestedheader.widget.NestedHeaderLayout.1
            @Override // com.pri.didouix.nestedheader.widget.NestedScrollingLayout.OnNestedChangedListener
            public void onStartNestedScroll(int i2) {
                if (i2 == 0) {
                    NestedHeaderLayout.this.isTouch = true;
                }
            }

            /* JADX WARN: Code restructure failed: missing block: B:15:0x0040, code lost:
                if (r1.getScrollingProgress() < (r1 * 0.5f)) goto L15;
             */
            /* JADX WARN: Code restructure failed: missing block: B:16:0x0042, code lost:
                r5 = r1;
             */
            /* JADX WARN: Code restructure failed: missing block: B:28:0x008d, code lost:
                if (r0 < r1) goto L15;
             */
            @Override // com.pri.didouix.nestedheader.widget.NestedScrollingLayout.OnNestedChangedListener
            /*
                Code decompiled incorrectly, please refer to instructions dump.
                To view partially-correct add '--show-bad-code' argument
            */
            public void onStopNestedScrollAccepted(int r5) {
                /*
                    r4 = this;
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r5 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    boolean r0 = r5.mAutoAnim
                    if (r0 == 0) goto L95
                    boolean r0 = r5.isAniming
                    if (r0 != 0) goto L95
                    int r5 = r5.getScrollingProgress()
                    if (r5 == 0) goto L95
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r5 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    int r5 = r5.getScrollingProgress()
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r0 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    int r1 = r0.mScrollingTo
                    if (r5 >= r1) goto L95
                    int r5 = r0.getScrollingProgress()
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r0 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    int r1 = r0.mScrollingFrom
                    if (r5 <= r1) goto L95
                    r5 = 0
                    int r0 = r0.getScrollingProgress()
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r1 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    int r2 = r1.mScrollingFrom
                    r3 = 1056964608(0x3f000000, float:0.5)
                    if (r0 <= r2) goto L44
                    int r0 = r1.getScrollingProgress()
                    float r0 = (float) r0
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r1 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    int r1 = r1.mScrollingFrom
                    float r2 = (float) r1
                    float r2 = r2 * r3
                    int r0 = (r0 > r2 ? 1 : (r0 == r2 ? 0 : -1))
                    if (r0 >= 0) goto L44
                L42:
                    r5 = r1
                    goto L90
                L44:
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r0 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    int r0 = r0.getScrollingProgress()
                    float r0 = (float) r0
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r1 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    int r2 = r1.mScrollingFrom
                    float r2 = (float) r2
                    float r2 = r2 * r3
                    int r0 = (r0 > r2 ? 1 : (r0 == r2 ? 0 : -1))
                    if (r0 < 0) goto L5b
                    int r0 = r1.getScrollingProgress()
                    if (r0 < 0) goto L90
                L5b:
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r0 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    int r0 = r0.getScrollingProgress()
                    if (r0 <= 0) goto L74
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r0 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    int r0 = r0.getScrollingProgress()
                    float r0 = (float) r0
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r1 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    int r1 = r1.mScrollingTo
                    float r1 = (float) r1
                    float r1 = r1 * r3
                    int r0 = (r0 > r1 ? 1 : (r0 == r1 ? 0 : -1))
                    if (r0 < 0) goto L90
                L74:
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r0 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    int r0 = r0.getScrollingProgress()
                    float r0 = (float) r0
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r1 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    int r2 = r1.mScrollingTo
                    float r2 = (float) r2
                    float r2 = r2 * r3
                    int r0 = (r0 > r2 ? 1 : (r0 == r2 ? 0 : -1))
                    if (r0 < 0) goto L90
                    int r0 = r1.getScrollingProgress()
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r1 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    int r1 = r1.mScrollingTo
                    if (r0 >= r1) goto L90
                    goto L42
                L90:
                    com.pri.didouix.nestedheader.widget.NestedHeaderLayout r4 = com.pri.didouix.nestedheader.widget.NestedHeaderLayout.this
                    r4.autoAdsorption(r5)
                L95:
                    return
                */
                throw new UnsupportedOperationException("Method not decompiled: com.pri.didouix.nestedheader.widget.NestedHeaderLayout.AnonymousClass1.onStopNestedScrollAccepted(int):void");
            }

            @Override // com.pri.didouix.nestedheader.widget.NestedScrollingLayout.OnNestedChangedListener
            public void onStopNestedScroll(int i2) {
                if (i2 == 0) {
                    NestedHeaderLayout.this.isTouch = false;
                }
            }
        };
        TypedArray obtainStyledAttributes = context.obtainStyledAttributes(attributeSet, R.styleable.NestedHeaderLayout);
        this.mHeaderViewId = obtainStyledAttributes.getResourceId(R.styleable.NestedHeaderLayout_headerView, 0);
        this.mTriggerViewId = obtainStyledAttributes.getResourceId(R.styleable.NestedHeaderLayout_triggerView, 0);
        this.mHeaderContentId = obtainStyledAttributes.getResourceId(R.styleable.NestedHeaderLayout_headerContentId, 0);
        this.mTriggerContentId = obtainStyledAttributes.getResourceId(R.styleable.NestedHeaderLayout_triggerContentId, 0);
        int i2 = R.styleable.NestedHeaderLayout_headerContentMinHeight;
        Resources resources = context.getResources();
        int i3 = R.dimen.nested_header_layout_content_min_height;
        this.mHeaderContentMinHeight = obtainStyledAttributes.getDimension(i2, resources.getDimension(i3));
        this.mTriggerContentMinHeight = obtainStyledAttributes.getDimension(R.styleable.NestedHeaderLayout_triggerContentMinHeight, context.getResources().getDimension(i3));
        this.mRangeOffset = obtainStyledAttributes.getDimension(R.styleable.NestedHeaderLayout_rangeOffset, 0.0f);
        obtainStyledAttributes.recycle();
        addOnScrollListener(this.mOnNestedChangedListener);
    }

    @Override // com.pri.didouix.nestedheader.widget.NestedScrollingLayout, android.view.View
    @RequiresApi(api = 21)
    public void onFinishInflate() {
        super.onFinishInflate();
        this.mHeaderView = findViewById(this.mHeaderViewId);
        View findViewById = findViewById(this.mTriggerViewId);
        this.mTriggerView = findViewById;
        View view = this.mHeaderView;
        if (view == null && findViewById == null) {
            throw new IllegalArgumentException("The headerView or triggerView attribute is required and must refer to a valid child.");
        }
        if (view != null) {
            View findViewById2 = view.findViewById(this.mHeaderContentId);
            this.mHeaderContentView = findViewById2;
            if (findViewById2 == null) {
                this.mHeaderContentView = this.mHeaderView;
            }
        }
        View view2 = this.mTriggerView;
        if (view2 != null) {
            this.mTriggerContentView = view2.findViewById(this.mTriggerContentId);
        }
    }

    @Override // android.view.View
    public void onSizeChanged(int i, int i2, int i3, int i4) {
        super.onSizeChanged(i, i2, i3, i4);
        View view = this.mHeaderView;
        if (view != null) {
            this.mHeaderInitTop = view.getTop();
        }
    }

    @Override // com.pri.didouix.nestedheader.widget.NestedScrollingLayout, android.widget.FrameLayout, android.view.ViewGroup, android.view.View
    public void onLayout(boolean z, int i, int i2, int i3, int i4) {
        super.onLayout(z, i, i2, i3, i4);
        updateScrollingRange(true, false, false);
    }

    @Override // com.pri.didouix.nestedheader.widget.NestedScrollingLayout
    public void onScrollingProgressUpdated(int i) {
        int i2;
        int i3;
        super.onScrollingProgressUpdated(i);
        View view = this.mTriggerView;
        if (view == null || view.getVisibility() == 8) {
            i2 = i;
            i3 = 0;
        } else {
            i2 = i - Math.max(0, Math.min(this.mScrollingTo, i));
            int max = Math.max(this.mScrollingFrom, Math.min(this.mScrollingTo, i));
            int i4 = this.mTriggerTopmMargin;
            View view2 = this.mHeaderView;
            if (view2 == null || view2.getVisibility() == 8) {
                i3 = this.mTriggerTopmMargin + this.mTriggerBottomMargin + this.mTriggerMeasuredHeight;
                max += i3;
            } else {
                i4 = this.mHeaderTopmMargin + this.mHeaderMeasuredHeight + this.mHeaderBottomMargin + this.mTriggerTopmMargin;
                i3 = 0;
            }
            View view3 = this.mTriggerContentView;
            if (view3 == null) {
                view3 = this.mTriggerView;
            }
            relayoutContent(this.mTriggerView, view3, i4, ((max - this.mTriggerBottomMargin) - this.mTriggerTopmMargin) - this.mTriggerMeasuredHeight);
            float f = (max - this.mTriggerBottomMargin) / this.mTriggerContentMinHeight;
            this.mTriggerView.setAlpha(Math.max(0.0f, Math.min(1.0f, f)));
            applyContentAlpha(makeTriggerContentViewList(view3), f - 1.0f);
        }
        View view4 = this.mHeaderView;
        if (view4 != null && view4.getVisibility() != 8) {
            int i5 = this.mHeaderInitTop + this.mHeaderTopmMargin;
            View view5 = this.mHeaderContentView;
            if (view5 == null) {
                view5 = this.mHeaderView;
            }
            relayoutContent(this.mHeaderView, view5, i5, i2);
            float f2 = this.mHeaderContentMinHeight;
            float f3 = (i2 + f2) / f2;
            this.mHeaderView.setAlpha(Math.max(0.0f, Math.min(1.0f, f3 + 1.0f)));
            applyContentAlpha(makeHeaderContentViewList(view5), f3);
            i3 = this.mHeaderMeasuredHeight + this.mHeaderTopmMargin + this.mHeaderBottomMargin;
        }
        View view6 = this.mScrollableView;
        view6.offsetTopAndBottom((i3 + i) - view6.getTop());
        int i6 = this.mLastScrollingProgress;
        int i7 = i - i6;
        if (i7 > 0) {
            checkSendHeaderChangeListener(i6, i, true);
        } else if (i7 < 0) {
            checkSendHeaderChangeListener(i6, i, false);
        }
        this.mLastScrollingProgress = i;
        updateHeaderOpen(isHeaderOpen());
    }

    private void checkSendHeaderChangeListener(int i, int i2, boolean z) {
        if (this.mNestedHeaderChangedListener != null) {
            if (z) {
                if (i2 == 0 && getHeaderViewVisible()) {
                    this.mNestedHeaderChangedListener.onHeaderOpened(this.mHeaderView);
                } else if (i2 == this.mScrollingTo && getTriggerViewVisible()) {
                    this.mNestedHeaderChangedListener.onTriggerOpened(this.mTriggerView);
                }
                if (i >= 0 || i2 <= 0 || !getHeaderViewVisible()) {
                    return;
                }
                this.mNestedHeaderChangedListener.onHeaderOpened(this.mHeaderView);
                return;
            }
            if (i2 == 0 && getTriggerViewVisible()) {
                this.mNestedHeaderChangedListener.onTriggerClosed(this.mTriggerView);
            } else if (i2 == this.mScrollingFrom && getHeaderViewVisible()) {
                this.mNestedHeaderChangedListener.onHeaderClosed(this.mHeaderView);
            } else if (i2 == this.mScrollingFrom && !getHeaderViewVisible()) {
                this.mNestedHeaderChangedListener.onTriggerClosed(this.mTriggerView);
            }
            int i3 = getHeaderViewVisible() ? 0 : this.mScrollingFrom;
            if (i <= i3 || i2 >= i3 || !getTriggerViewVisible()) {
                return;
            }
            this.mNestedHeaderChangedListener.onTriggerClosed(this.mTriggerView);
        }
    }

    private void updateScrollingRange(boolean z, boolean z2, boolean z3) {
        int i;
        boolean z4;
        int i2;
        int i3;
        boolean z5;
        int measuredHeight = 0;
        View view = this.mHeaderView;
        if (view == null || view.getVisibility() == 8) {
            i = 0;
            z4 = false;
        } else {
            ViewGroup.MarginLayoutParams marginLayoutParams = (ViewGroup.MarginLayoutParams) this.mHeaderView.getLayoutParams();
            this.mHeaderBottomMargin = marginLayoutParams.bottomMargin;
            this.mHeaderTopmMargin = marginLayoutParams.topMargin;
            this.mHeaderMeasuredHeight = this.mHeaderView.getMeasuredHeight();
            i = ((int) ((((-measuredHeight) + this.mRangeOffset) - this.mHeaderTopmMargin) - this.mHeaderBottomMargin)) + 0;
            z4 = true;
        }
        View view2 = this.mTriggerView;
        if (view2 == null || view2.getVisibility() == 8) {
            i2 = i;
            i3 = 0;
            z5 = false;
        } else {
            ViewGroup.MarginLayoutParams marginLayoutParams2 = (ViewGroup.MarginLayoutParams) this.mTriggerView.getLayoutParams();
            this.mTriggerBottomMargin = marginLayoutParams2.bottomMargin;
            this.mTriggerTopmMargin = marginLayoutParams2.topMargin;
            int measuredHeight2 = this.mTriggerView.getMeasuredHeight();
            this.mTriggerMeasuredHeight = measuredHeight2;
            int i4 = measuredHeight2 + this.mTriggerTopmMargin + this.mTriggerBottomMargin + 0;
            if (z4) {
                i2 = i;
                i3 = i4;
                z5 = true;
            } else {
                i2 = -i4;
                z5 = true;
                i3 = 0;
            }
        }
        this.mScrollingFrom = i2;
        this.mScrollingTo = i3;
        setScrollingRange(i2, i3, z4, z5, z, z2, z3);
    }

    public void autoAdsorption(final int i) {
        ValueAnimator ofInt = ValueAnimator.ofInt(Integer.valueOf(getScrollingProgress()).intValue(), Integer.valueOf(i).intValue());
        ofInt.setTarget(this);
        ofInt.setDuration(300L).start();
        ofInt.setInterpolator(new LinearInterpolator());
        ofInt.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() { // from class: com.pri.didouix.nestedheader.widget.NestedHeaderLayout.2
            @Override // android.animation.ValueAnimator.AnimatorUpdateListener
            public void onAnimationUpdate(ValueAnimator valueAnimator) {
                if (!NestedHeaderLayout.this.isTouch && ((Integer) valueAnimator.getAnimatedValue()) != null) {
                    NestedHeaderLayout.this.syncScrollingProgress(((Integer) valueAnimator.getAnimatedValue()).intValue());
                }
                if (valueAnimator.getAnimatedValue() == null || ((Integer) valueAnimator.getAnimatedValue()).intValue() != i) {
                    return;
                }
                NestedHeaderLayout.this.isAniming = false;
            }
        });
    }

    public void syncScrollingProgress(int i) {
        updateScrollingProgress(i);
        onScrollingProgressUpdated(i);
    }

    private List<View> makeTriggerContentViewList(View view) {
        return makeContentViewList(view, this.mTriggerContentId == 0);
    }

    private List<View> makeHeaderContentViewList(View view) {
        return makeContentViewList(view, this.mHeaderContentId == 0);
    }

    private List<View> makeContentViewList(View view, boolean z) {
        if (view == null) {
            return null;
        }
        ArrayList arrayList = new ArrayList();
        if (z) {
            if (view instanceof ViewGroup) {
                ViewGroup viewGroup = (ViewGroup) view;
                for (int i = 0; i < viewGroup.getChildCount(); i++) {
                    arrayList.add(viewGroup.getChildAt(i));
                }
            } else {
                arrayList.add(view);
            }
            return arrayList;
        }
        arrayList.add(view);
        return arrayList;
    }

    private void applyContentAlpha(List<View> list, float f) {
        if (list != null) {
            float max = Math.max(0.0f, Math.min(1.0f, f));
            for (View view : list) {
                view.setAlpha(max);
            }
        }
    }

    private void relayoutContent(View view, View view2, int i, int i2) {
        view.layout(view.getLeft(), i, view.getRight(), Math.max(i, view.getMeasuredHeight() + i + i2));
        if (view != view2) {
            view2.layout(view2.getLeft(), view2.getTop(), view2.getRight(), Math.max(view2.getTop(), view2.getTop() + view2.getMeasuredHeight() + i2));
        }
    }

    public void setAutoAnim(boolean z) {
        this.mAutoAnim = z;
    }

    public boolean isAutoAnim() {
        return this.mAutoAnim;
    }

    public void setTriggerViewVisible(boolean z) {
        View view = this.mTriggerView;
        if (view != null) {
            view.setVisibility(z ? 0 : 8);
            updateScrollingRange(false, z, false);
        }
    }

    public boolean getTriggerViewVisible() {
        View view = this.mTriggerView;
        return view != null && view.getVisibility() == 0;
    }

    public void setHeaderViewVisible(boolean z) {
        View view = this.mHeaderView;
        if (view != null) {
            view.setVisibility(z ? 0 : 8);
            updateScrollingRange(false, false, z);
        }
    }

    public boolean getHeaderViewVisible() {
        View view = this.mHeaderView;
        return view != null && view.getVisibility() == 0;
    }

    public void setAutoTriggerClose(boolean z) {
        int i;
        if (getTriggerViewVisible() && getHeaderViewVisible() && getScrollingProgress() > 0) {
            i = 0;
        } else {
            if (getTriggerViewVisible()) {
                getHeaderViewVisible();
            }
            i = -1;
        }
        if (i != -1 && z) {
            autoAdsorption(i);
        } else if (i != -1) {
            syncScrollingProgress(i);
        }
    }

    public void setAutoHeaderClose(boolean z) {
        if (getHeaderViewVisible()) {
            int scrollingProgress = getScrollingProgress();
            int i = this.mScrollingFrom;
            if (scrollingProgress > i) {
                if (z) {
                    autoAdsorption(i);
                } else if (getHeaderViewVisible()) {
                    syncScrollingProgress(this.mScrollingFrom);
                }
            }
        }
    }

    public void setAutoAllClose(boolean z) {
        if (z) {
            int scrollingProgress = getScrollingProgress();
            int i = this.mScrollingFrom;
            if (scrollingProgress > i) {
                autoAdsorption(i);
                return;
            }
        }
        syncScrollingProgress(this.mScrollingFrom);
    }

    public void setAutoTriggerOpen(boolean z) {
        if (getTriggerViewVisible()) {
            int scrollingProgress = getScrollingProgress();
            int i = this.mScrollingTo;
            if (scrollingProgress < i) {
                if (z) {
                    autoAdsorption(i);
                } else {
                    syncScrollingProgress(i);
                }
            }
        }
    }

    public void setAutoHeaderOpen(boolean z) {
        if (!getHeaderViewVisible() || getScrollingProgress() >= 0) {
            return;
        }
        if (z) {
            autoAdsorption(0);
        } else {
            syncScrollingProgress(0);
        }
    }

    public void setAutoAllOpen(boolean z) {
        if (z) {
            int scrollingProgress = getScrollingProgress();
            int i = this.mScrollingTo;
            if (scrollingProgress < i) {
                autoAdsorption(i);
                return;
            }
        }
        syncScrollingProgress(this.mScrollingTo);
    }

    public boolean isHeaderOpen() {
        return getHeaderViewVisible() && getScrollingProgress() >= 0;
    }

    public boolean isTriggerOpen() {
        return getTriggerViewVisible() && ((getHeaderViewVisible() && getScrollingProgress() >= this.mScrollingTo) || (!getHeaderViewVisible() && getScrollingProgress() >= 0));
    }
}
