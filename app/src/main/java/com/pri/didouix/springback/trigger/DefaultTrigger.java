package com.pri.didouix.springback.trigger;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.pri.R;
import com.pri.didouix.springback.view.SpringBackLayout;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class DefaultTrigger {
    private static final float OFFSET_RESET_STATE = 0.25f;
    private static final String TAG = "DefaultTrigger";
    public static int mIndeterminateDistance;
    public static int mIndeterminateTop;
    public static int mSimpleEnter;
    public static int mSimpleTrigger;
    public static int mUpIndeterminateDistance;
    public final ActionComplete mActionComplete = new ActionComplete();
    public int mActionIndex = -1;
    public final ActionStart mActionStart = new ActionStart();
    public final ActionTriggered mActionTriggered = new ActionTriggered();
    public List<Action> mActions = new ArrayList();
    private IndeterminateAction.OnActionCompleteListener mCompleteListener = new IndeterminateAction.OnActionCompleteListener() {
        public void onActionComplete(IndeterminateAction indeterminateAction) {
            DefaultTrigger defaultTrigger = DefaultTrigger.this;
            if (defaultTrigger.mCurrentState == defaultTrigger.mActionStart && defaultTrigger.mCurrentAction == indeterminateAction) {
                if (defaultTrigger.mLayout.getScrollY() != 0) {
                    DefaultTrigger defaultTrigger2 = DefaultTrigger.this;
                    defaultTrigger2.transition(defaultTrigger2.mActionComplete);
                    DefaultTrigger defaultTrigger3 = DefaultTrigger.this;
                    if (defaultTrigger3.mScrollState == 0) {
                        defaultTrigger3.mLayout.smoothScrollTo(0, 0);
                    }
                } else {
                    DefaultTrigger defaultTrigger4 = DefaultTrigger.this;
                    defaultTrigger4.transition(defaultTrigger4.mIdle);
                }
                DefaultTrigger.this.mLoadingIndicator.setVisibility(8);
                DefaultTrigger.this.mTrackingIndicatorLabel.setText(indeterminateAction.mTriggerTexts[3]);
            }
        }

        public void onActionStart(IndeterminateAction indeterminateAction) {
            Action action;
            if (DefaultTrigger.this.mActions.size() > 0 && (action = DefaultTrigger.this.mActions.get(0)) == indeterminateAction) {
                DefaultTrigger defaultTrigger = DefaultTrigger.this;
                if (defaultTrigger.mCurrentAction == null && defaultTrigger.mCurrentState == defaultTrigger.mIdle) {
                    defaultTrigger.transition(defaultTrigger.mTracking);
                    DefaultTrigger defaultTrigger2 = DefaultTrigger.this;
                    defaultTrigger2.mCurrentAction = action;
                    defaultTrigger2.mLoadingIndicator.setVisibility(0);
                    DefaultTrigger.this.mTrackingIndicator.setVisibility(0);
                    DefaultTrigger.this.mTrackingIndicatorLabel.setVisibility(0);
                    DefaultTrigger.this.mTrackingIndicatorLabel.setText(indeterminateAction.mTriggerTexts[2]);
                    DefaultTrigger defaultTrigger3 = DefaultTrigger.this;
                    defaultTrigger3.mLayout.smoothScrollTo(0, -defaultTrigger3.mCurrentAction.mTriggerPoint);
                    DefaultTrigger defaultTrigger4 = DefaultTrigger.this;
                    RelativeLayout relativeLayout = defaultTrigger4.mContainer;
                    relativeLayout.layout(0, -defaultTrigger4.mCurrentAction.mTriggerPoint, relativeLayout.getWidth(), 0);
                    DefaultTrigger defaultTrigger5 = DefaultTrigger.this;
                    defaultTrigger5.transition(defaultTrigger5.mWaitForIndeterminate);
                }
            }
        }

        public void onUpdateTriggerTextIndex(IndeterminateAction indeterminateAction, int i, String str) {
            indeterminateAction.mTriggerTexts[i] = str;
        }
    };
    public RelativeLayout mContainer;
    private Context mContext;
    public Action mCurrentAction;
    public TriggerState mCurrentState = this.mIdle;
    public final Idle mIdle = new Idle();
    public ViewGroup mIndicatorContainer;
    public int mLastScrollDistance;
    public SpringBackLayout mLayout;
    private View.OnLayoutChangeListener mLayoutChangeListener = new View.OnLayoutChangeListener() {
        public void onLayoutChange(View view, int i, int i2, int i3, int i4, int i5, int i6, int i7, int i8) {
            DefaultTrigger defaultTrigger;
            Action action;
            int makeMeasureSpec = View.MeasureSpec.makeMeasureSpec(view.getWidth(), 1073741824);
            int makeMeasureSpec2 = View.MeasureSpec.makeMeasureSpec(-view.getScrollY(), 1073741824);
            DefaultTrigger.this.mContainer.measure(makeMeasureSpec, makeMeasureSpec2);
            DefaultTrigger.this.mUpContainer.measure(makeMeasureSpec, makeMeasureSpec2);
            DefaultTrigger.this.mContainer.layout(0, view.getScrollY(), view.getWidth(), 0);
            DefaultTrigger defaultTrigger2 = DefaultTrigger.this;
            defaultTrigger2.mUpContainer.layout(0, defaultTrigger2.mLayout.getBottom(), view.getWidth(), DefaultTrigger.this.mLayout.getBottom() + view.getScrollY());
            for (int i9 = 0; i9 < DefaultTrigger.this.mActions.size(); i9++) {
                Action action2 = DefaultTrigger.this.mActions.get(i9);
                if (action2 instanceof IndeterminateAction) {
                    IndeterminateAction indeterminateAction = (IndeterminateAction) action2;
                    if (DefaultTrigger.mIndeterminateTop >= DefaultTrigger.this.mTrackingIndicator.getTop()) {
                        DefaultTrigger.this.mLoadingIndicator.offsetTopAndBottom(indeterminateAction.mEnterPoint - 0);
                        DefaultTrigger.this.mTrackingIndicator.offsetTopAndBottom(indeterminateAction.mEnterPoint - 0);
                        DefaultTrigger.this.mTrackingIndicatorLabel.offsetTopAndBottom(indeterminateAction.mEnterPoint - 0);
                    }
                }
            }
            if (DefaultTrigger.this.mTrackingIndicator.getVisibility() == 0 && (action = defaultTrigger.mCurrentAction) != null && (action instanceof IndeterminateAction)) {
                if ((defaultTrigger = DefaultTrigger.this).mTrackingIndicatorBottom <= 0) {
                    defaultTrigger.mTrackingIndicatorBottom = defaultTrigger.mTrackingIndicator.getBottom();
                }
                DefaultTrigger defaultTrigger3 = DefaultTrigger.this;
                if (defaultTrigger3.mTrackingIndicatorLabelTop <= 0 || defaultTrigger3.mTrackingIndicatorLabelBottom <= 0) {
                    defaultTrigger3.mTrackingIndicatorLabelTop = defaultTrigger3.mTrackingIndicatorLabel.getTop();
                    DefaultTrigger defaultTrigger4 = DefaultTrigger.this;
                    defaultTrigger4.mTrackingIndicatorLabelBottom = defaultTrigger4.mTrackingIndicatorLabel.getBottom();
                }
                if (DefaultTrigger.this.mLoadingIndicator.getVisibility() == 8 || DefaultTrigger.this.mLoadingIndicator.getVisibility() == 4) {
                    DefaultTrigger defaultTrigger5 = DefaultTrigger.this;
                    if (defaultTrigger5.mCurrentState != defaultTrigger5.mActionComplete) {
                        int height = defaultTrigger5.mContainer.getHeight();
                        DefaultTrigger defaultTrigger6 = DefaultTrigger.this;
                        if (height > defaultTrigger6.mCurrentAction.mTriggerPoint) {
                            defaultTrigger6.mTrackingIndicator.setBottom(defaultTrigger6.mTrackingIndicatorBottom + (defaultTrigger6.mContainer.getHeight() - DefaultTrigger.this.mCurrentAction.mTriggerPoint));
                        }
                    }
                }
            }
            if (DefaultTrigger.this.mIndicatorContainer.getVisibility() == 0) {
                DefaultTrigger defaultTrigger7 = DefaultTrigger.this;
                ViewGroup viewGroup = defaultTrigger7.mIndicatorContainer;
                viewGroup.offsetTopAndBottom(defaultTrigger7.mScrollDistance - viewGroup.getMeasuredHeight());
            }
        }
    };
    public LayoutInflater mLayoutInflater;
    public ProgressBar mLoadingIndicator;
    private SpringBackLayout.OnScrollListener mOnScrollListener = new SpringBackLayout.OnScrollListener() {
        public void onStateChanged(int i, int i2, boolean z) {
            DefaultTrigger defaultTrigger = DefaultTrigger.this;
            defaultTrigger.mScrollState = i2;
            defaultTrigger.mScrollerFinished = z;
            defaultTrigger.mCurrentState.handleScrollStateChange(i, i2);
            DefaultTrigger defaultTrigger2 = DefaultTrigger.this;
            TriggerState triggerState = defaultTrigger2.mCurrentState;
            if (triggerState != defaultTrigger2.mIdle) {
                defaultTrigger2.mContainer.setVisibility(0);
                DefaultTrigger defaultTrigger3 = DefaultTrigger.this;
                if (defaultTrigger3.mUpAction != null) {
                    defaultTrigger3.mUpTrackingContainer.setVisibility(0);
                }
            } else if (triggerState != defaultTrigger2.mWaitForIndeterminate) {
                defaultTrigger2.mContainer.setVisibility(8);
                DefaultTrigger defaultTrigger4 = DefaultTrigger.this;
                if (defaultTrigger4.mUpAction != null) {
                    defaultTrigger4.mUpTrackingContainer.setVisibility(8);
                }
            }
        }

        /* JADX WARNING: Removed duplicated region for block: B:67:0x028e  */
        /* JADX WARNING: Removed duplicated region for block: B:86:0x02fe  */
        /* JADX WARNING: Removed duplicated region for block: B:90:? A[RETURN, SYNTHETIC] */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public void onScrolled(com.pri.didouix.springback.view.SpringBackLayout r10, int r11, int r12) {
            /*
                r9 = this;
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                int r0 = r11.mScrollDistance
                r11.mLastScrollDistance = r0
                int r0 = r10.getScrollY()
                int r0 = -r0
                r11.mScrollDistance = r0
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.RelativeLayout r11 = r11.mContainer
                int r0 = r10.getScrollY()
                r11.setTop(r0)
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.RelativeLayout r0 = r11.mUpContainer
                com.pri.didouix.springback.view.SpringBackLayout r11 = r11.mLayout
                int r11 = r11.getBottom()
                int r1 = r10.getScrollY()
                int r11 = r11 + r1
                r0.setBottom(r11)
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                int r0 = r11.mScrollDistance
                r1 = 1048576000(0x3e800000, float:0.25)
                r2 = 1
                r3 = 0
                if (r0 >= 0) goto L_0x0089
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r0 = r11.mCurrentAction
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r4 = r11.mUpAction
                if (r0 != r4) goto L_0x0089
                if (r4 == 0) goto L_0x0089
                int r5 = r4.mTriggerPoint
                int r4 = r4.mEnterPoint
                int r5 = r5 - r4
                float r4 = (float) r5
                float r4 = r4 * r1
                int r0 = r0.mEnterPoint
                float r0 = (float) r0
                float r4 = r4 + r0
                int r0 = r11.mScrollState
                if (r0 != r2) goto L_0x0070
                int r11 = r11.mLastScrollDistance
                int r11 = java.lang.Math.abs(r11)
                float r11 = (float) r11
                int r11 = (r11 > r4 ? 1 : (r11 == r4 ? 0 : -1))
                if (r11 < 0) goto L_0x0063
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                int r11 = r11.mScrollDistance
                int r11 = java.lang.Math.abs(r11)
                float r11 = (float) r11
                int r11 = (r11 > r4 ? 1 : (r11 == r4 ? 0 : -1))
                if (r11 >= 0) goto L_0x0070
            L_0x0063:
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$TriggerState r0 = r11.mCurrentState
                com.pri.didouix.springback.trigger.DefaultTrigger$ActionComplete r4 = r11.mActionComplete
                if (r0 != r4) goto L_0x0070
                com.pri.didouix.springback.trigger.DefaultTrigger$Tracking r0 = r11.mTracking
                r11.transition(r0)
            L_0x0070:
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.RelativeLayout r0 = r11.mUpTrackingContainer
                android.widget.RelativeLayout r11 = r11.mUpContainer
                int r11 = r11.getHeight()
                com.pri.didouix.springback.trigger.DefaultTrigger r4 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r4 = r4.mUpAction
                int r4 = r4.mTriggerPoint
                int r11 = r11 - r4
                int r11 = java.lang.Math.max(r11, r3)
                float r11 = (float) r11
                r0.setTranslationY(r11)
            L_0x0089:
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r0 = r11.mCurrentAction
                r4 = 8
                if (r0 == 0) goto L_0x029b
                boolean r5 = r0 instanceof com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateAction
                if (r5 == 0) goto L_0x029b
                int r5 = r0.mTriggerPoint
                int r0 = r0.mEnterPoint
                int r5 = r5 - r0
                float r5 = (float) r5
                float r5 = r5 * r1
                float r0 = (float) r0
                float r5 = r5 + r0
                int r0 = r11.mScrollState
                if (r0 != r2) goto L_0x00eb
                int r11 = r11.mLastScrollDistance
                int r11 = java.lang.Math.abs(r11)
                float r11 = (float) r11
                int r11 = (r11 > r5 ? 1 : (r11 == r5 ? 0 : -1))
                if (r11 < 0) goto L_0x00ba
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                int r11 = r11.mScrollDistance
                int r11 = java.lang.Math.abs(r11)
                float r11 = (float) r11
                int r11 = (r11 > r5 ? 1 : (r11 == r5 ? 0 : -1))
                if (r11 >= 0) goto L_0x00eb
            L_0x00ba:
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$TriggerState r0 = r11.mCurrentState
                com.pri.didouix.springback.trigger.DefaultTrigger$ActionComplete r1 = r11.mActionComplete
                if (r0 != r1) goto L_0x00eb
                com.pri.didouix.springback.trigger.DefaultTrigger$Tracking r0 = r11.mTracking
                r11.transition(r0)
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.ViewGroup r11 = r11.mIndicatorContainer
                r11.setVisibility(r3)
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.ProgressBar r11 = r11.mLoadingIndicator
                r11.setVisibility(r4)
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.View r11 = r11.mTrackingIndicator
                r11.setVisibility(r3)
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.TextView r0 = r11.mTrackingIndicatorLabel
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r11 = r11.mCurrentAction
                com.pri.didouix.springback.trigger.DefaultTrigger$IndeterminateAction r11 = (com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateAction) r11
                java.lang.String[] r11 = r11.mTriggerTexts
                r11 = r11[r3]
                r0.setText(r11)
            L_0x00eb:
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                int r0 = r11.mScrollState
                if (r0 != r2) goto L_0x010a
                com.pri.didouix.springback.trigger.DefaultTrigger$TriggerState r0 = r11.mCurrentState
                com.pri.didouix.springback.trigger.DefaultTrigger$WaitForIndeterminate r1 = r11.mWaitForIndeterminate
                if (r0 != r1) goto L_0x010a
                int r11 = r11.mLastScrollDistance
                int r11 = java.lang.Math.abs(r11)
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r1 = r0.mCurrentAction
                int r1 = r1.mEnterPoint
                if (r11 <= r1) goto L_0x010a
                com.pri.didouix.springback.trigger.DefaultTrigger$Tracking r11 = r0.mTracking
                r0.transition(r11)
            L_0x010a:
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.View r11 = r11.mTrackingIndicator
                int r11 = r11.getVisibility()
                if (r11 != 0) goto L_0x029b
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.View r0 = r11.mTrackingIndicator
                int r0 = r0.getTop()
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.View r1 = r1.mTrackingIndicator
                int r1 = r1.getWidth()
                int r0 = r0 + r1
                r11.mTrackingIndicatorBottom = r0
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.TextView r0 = r11.mTrackingIndicatorLabel
                int r0 = r0.getTop()
                r11.mTrackingIndicatorLabelTop = r0
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.TextView r0 = r11.mTrackingIndicatorLabel
                int r0 = r0.getBottom()
                r11.mTrackingIndicatorLabelBottom = r0
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r0 = r11.mCurrentAction
                int r0 = r0.mTriggerPoint
                float r0 = (float) r0
                android.widget.RelativeLayout r11 = r11.mContainer
                int r11 = r11.getHeight()
                float r11 = (float) r11
                float r11 = r11 / r0
                r1 = 1065353216(0x3f800000, float:1.0)
                float r11 = java.lang.Math.min(r11, r1)
                r5 = 0
                float r11 = java.lang.Math.max(r5, r11)
                r6 = 1056964608(0x3f000000, float:0.5)
                float r6 = r6 * r0
                com.pri.didouix.springback.trigger.DefaultTrigger r7 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.RelativeLayout r7 = r7.mContainer
                int r7 = r7.getHeight()
                float r7 = (float) r7
                int r7 = (r7 > r6 ? 1 : (r7 == r6 ? 0 : -1))
                if (r7 >= 0) goto L_0x0167
                r7 = r5
                goto L_0x0176
            L_0x0167:
                com.pri.didouix.springback.trigger.DefaultTrigger r7 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.RelativeLayout r7 = r7.mContainer
                int r7 = r7.getHeight()
                float r7 = (float) r7
                float r7 = r7 - r6
                float r7 = r7 / r6
                float r7 = java.lang.Math.min(r7, r1)
            L_0x0176:
                float r7 = java.lang.Math.max(r5, r7)
                com.pri.didouix.springback.trigger.DefaultTrigger r8 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.RelativeLayout r8 = r8.mContainer
                int r8 = r8.getHeight()
                float r8 = (float) r8
                int r6 = (r8 > r6 ? 1 : (r8 == r6 ? 0 : -1))
                if (r6 >= 0) goto L_0x0189
                r0 = r5
                goto L_0x01a0
            L_0x0189:
                com.pri.didouix.springback.trigger.DefaultTrigger r6 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.RelativeLayout r6 = r6.mContainer
                int r6 = r6.getHeight()
                float r6 = (float) r6
                r8 = 1060320051(0x3f333333, float:0.7)
                float r8 = r8 * r0
                float r6 = r6 - r8
                r8 = 1050253722(0x3e99999a, float:0.3)
                float r0 = r0 * r8
                float r6 = r6 / r0
                float r0 = java.lang.Math.min(r6, r1)
            L_0x01a0:
                float r0 = java.lang.Math.max(r5, r0)
                com.pri.didouix.springback.trigger.DefaultTrigger r6 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.View r6 = r6.mTrackingIndicator
                int r6 = r6.getWidth()
                int r6 = -r6
                float r6 = (float) r6
                float r1 = r1 - r11
                float r6 = r6 * r1
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.View r1 = r1.mTrackingIndicator
                r1.setAlpha(r7)
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.View r1 = r1.mTrackingIndicator
                r1.setScaleX(r11)
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.View r1 = r1.mTrackingIndicator
                r1.setScaleY(r11)
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.TextView r1 = r1.mTrackingIndicatorLabel
                r1.setAlpha(r0)
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.TextView r8 = r1.mTrackingIndicatorLabel
                int r1 = r1.mTrackingIndicatorLabelTop
                r8.setTop(r1)
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.TextView r8 = r1.mTrackingIndicatorLabel
                int r1 = r1.mTrackingIndicatorLabelBottom
                r8.setBottom(r1)
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.ProgressBar r1 = r1.mLoadingIndicator
                int r1 = r1.getVisibility()
                if (r1 != 0) goto L_0x01fd
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.ProgressBar r1 = r1.mLoadingIndicator
                r1.setAlpha(r7)
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.ProgressBar r1 = r1.mLoadingIndicator
                r1.setScaleX(r11)
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.ProgressBar r1 = r1.mLoadingIndicator
                r1.setScaleY(r11)
            L_0x01fd:
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.RelativeLayout r11 = r11.mContainer
                int r11 = r11.getHeight()
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r7 = r1.mCurrentAction
                int r7 = r7.mTriggerPoint
                if (r11 >= r7) goto L_0x0235
                int r11 = (r0 > r5 ? 1 : (r0 == r5 ? 0 : -1))
                if (r11 <= 0) goto L_0x0216
                android.widget.TextView r11 = r1.mTrackingIndicatorLabel
                r11.setTranslationY(r6)
            L_0x0216:
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$TriggerState r0 = r11.mCurrentState
                com.pri.didouix.springback.trigger.DefaultTrigger$Tracking r1 = r11.mTracking
                if (r0 != r1) goto L_0x022b
                android.widget.TextView r0 = r11.mTrackingIndicatorLabel
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r11 = r11.mCurrentAction
                com.pri.didouix.springback.trigger.DefaultTrigger$IndeterminateAction r11 = (com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateAction) r11
                java.lang.String[] r11 = r11.mTriggerTexts
                r11 = r11[r3]
                r0.setText(r11)
            L_0x022b:
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.View r0 = r11.mTrackingIndicator
                int r11 = r11.mTrackingIndicatorBottom
                r0.setBottom(r11)
                goto L_0x029b
            L_0x0235:
                android.widget.RelativeLayout r11 = r1.mContainer
                int r11 = r11.getHeight()
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r1 = r0.mCurrentAction
                int r1 = r1.mTriggerPoint
                if (r11 < r1) goto L_0x029b
                int r11 = r0.mTrackingIndicatorBottom
                android.widget.RelativeLayout r0 = r0.mContainer
                int r0 = r0.getHeight()
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r6 = r1.mCurrentAction
                int r6 = r6.mTriggerPoint
                int r0 = r0 - r6
                int r11 = r11 + r0
                android.widget.ProgressBar r0 = r1.mLoadingIndicator
                int r0 = r0.getVisibility()
                if (r0 == 0) goto L_0x027f
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$TriggerState r1 = r0.mCurrentState
                com.pri.didouix.springback.trigger.DefaultTrigger$ActionComplete r6 = r0.mActionComplete
                if (r1 != r6) goto L_0x0264
                goto L_0x027f
            L_0x0264:
                android.view.View r0 = r0.mTrackingIndicator
                r0.setBottom(r11)
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.TextView r0 = r11.mTrackingIndicatorLabel
                android.widget.RelativeLayout r11 = r11.mContainer
                int r11 = r11.getHeight()
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r1 = r1.mCurrentAction
                int r1 = r1.mTriggerPoint
                int r11 = r11 - r1
                float r11 = (float) r11
                r0.setTranslationY(r11)
                goto L_0x0286
            L_0x027f:
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.widget.TextView r11 = r11.mTrackingIndicatorLabel
                r11.setTranslationY(r5)
            L_0x0286:
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$TriggerState r0 = r11.mCurrentState
                com.pri.didouix.springback.trigger.DefaultTrigger$Tracking r1 = r11.mTracking
                if (r0 != r1) goto L_0x029b
                android.widget.TextView r0 = r11.mTrackingIndicatorLabel
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r11 = r11.mCurrentAction
                com.pri.didouix.springback.trigger.DefaultTrigger$IndeterminateAction r11 = (com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateAction) r11
                java.lang.String[] r11 = r11.mTriggerTexts
                r11 = r11[r2]
                r0.setText(r11)
            L_0x029b:
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$TriggerState r11 = r11.mCurrentState
                int r10 = r10.getScrollY()
                r11.handleScrolled(r12, r10)
                com.pri.didouix.springback.trigger.DefaultTrigger r10 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r11 = r10.mCurrentAction
                if (r11 == 0) goto L_0x02c4
                boolean r11 = r11 instanceof com.pri.didouix.springback.trigger.DefaultTrigger.SimpleAction
                if (r11 == 0) goto L_0x02c4
                android.widget.RelativeLayout r10 = r10.mContainer
                int r10 = r10.getHeight()
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r0 = r11.mCurrentAction
                int r0 = r0.mEnterPoint
                if (r10 >= r0) goto L_0x02c4
                android.view.ViewGroup r10 = r11.mIndicatorContainer
                r10.setVisibility(r4)
                goto L_0x02f4
            L_0x02c4:
                com.pri.didouix.springback.trigger.DefaultTrigger r10 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r11 = r10.mCurrentAction
                if (r11 == 0) goto L_0x02f4
                boolean r11 = r11 instanceof com.pri.didouix.springback.trigger.DefaultTrigger.SimpleAction
                if (r11 == 0) goto L_0x02f4
                android.widget.RelativeLayout r10 = r10.mContainer
                int r10 = r10.getHeight()
                com.pri.didouix.springback.trigger.DefaultTrigger r11 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r0 = r11.mCurrentAction
                int r0 = r0.mEnterPoint
                if (r10 < r0) goto L_0x02f4
                android.view.ViewGroup r10 = r11.mIndicatorContainer
                int r10 = r10.getVisibility()
                if (r10 != r4) goto L_0x02f4
                com.pri.didouix.springback.trigger.DefaultTrigger r10 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.ViewGroup r10 = r10.mIndicatorContainer
                r10.setVisibility(r3)
                com.pri.didouix.springback.trigger.DefaultTrigger r10 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.ViewGroup r11 = r10.mIndicatorContainer
                android.view.View r0 = r10.mSimpleActionView
                r10.viewShow(r11, r0)
            L_0x02f4:
                com.pri.didouix.springback.trigger.DefaultTrigger r10 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.ViewGroup r10 = r10.mIndicatorContainer
                int r10 = r10.getVisibility()
                if (r10 != 0) goto L_0x030a
                com.pri.didouix.springback.trigger.DefaultTrigger r9 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r10 = r9.mCurrentAction
                if (r10 == 0) goto L_0x030a
                android.view.ViewGroup r9 = r9.mIndicatorContainer
                int r10 = -r12
                r9.offsetTopAndBottom(r10)
            L_0x030a:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: com.pri.didouix.springback.trigger.DefaultTrigger.AnonymousClass3.onScrolled(com.pri.didouix.springback.view.SpringBackLayout, int, int):void");
        }
    };
    private SpringBackLayout.OnSpringListener mOnSpringListener = new SpringBackLayout.OnSpringListener() {
        public boolean onSpringBack() {
            return DefaultTrigger.this.mCurrentState.handleSpringBack();
        }
    };
    public int mScrollDistance;
    public int mScrollState;
    public boolean mScrollerFinished = true;
    public View mSimpleActionView;
    public final Tracking mTracking = new Tracking();
    public View mTrackingIndicator;
    public int mTrackingIndicatorBottom = 0;
    public TextView mTrackingIndicatorLabel;
    public int mTrackingIndicatorLabelBottom = 0;
    public int mTrackingIndicatorLabelTop = 0;
    public Action mUpAction;
    public boolean mUpActionBegin = false;
    private IndeterminateUpAction.OnUpActionDataListener mUpActionDataListener = new IndeterminateUpAction.OnUpActionDataListener() {
        public void onActionNoData(IndeterminateUpAction indeterminateUpAction, int i) {
            DefaultTrigger defaultTrigger = DefaultTrigger.this;
            if (defaultTrigger.mCurrentState == defaultTrigger.mActionStart && defaultTrigger.mCurrentAction == indeterminateUpAction) {
                if (i < 3) {
                    defaultTrigger.mUpTrackingIndicatorLabel.setText(indeterminateUpAction.mTriggerTexts[2]);
                } else {
                    defaultTrigger.mUpTrackingIndicatorLabel.setText(indeterminateUpAction.mTriggerTexts[3]);
                }
                DefaultTrigger.this.mUpLoadingIndicator.setVisibility(8);
                DefaultTrigger.this.mUpTrackingIndicator.setVisibility(8);
                if (DefaultTrigger.this.mLayout.getScrollY() != 0) {
                    DefaultTrigger defaultTrigger2 = DefaultTrigger.this;
                    defaultTrigger2.transition(defaultTrigger2.mActionComplete);
                    DefaultTrigger defaultTrigger3 = DefaultTrigger.this;
                    if (defaultTrigger3.mScrollState == 0) {
                        defaultTrigger3.mLayout.smoothScrollTo(0, 0);
                        return;
                    }
                    return;
                }
                DefaultTrigger defaultTrigger4 = DefaultTrigger.this;
                defaultTrigger4.transition(defaultTrigger4.mIdle);
            }
        }

        public void onActionStart(IndeterminateUpAction indeterminateUpAction) {
            DefaultTrigger defaultTrigger = DefaultTrigger.this;
            Action action = defaultTrigger.mUpAction;
            if (action != null && action == indeterminateUpAction) {
                defaultTrigger.transition(defaultTrigger.mTracking);
                DefaultTrigger defaultTrigger2 = DefaultTrigger.this;
                defaultTrigger2.mCurrentAction = defaultTrigger2.mUpAction;
                defaultTrigger2.mUpContainer.setVisibility(0);
                DefaultTrigger.this.mUpTrackingContainer.setVisibility(0);
                DefaultTrigger.this.mUpLoadingIndicator.setVisibility(0);
                DefaultTrigger.this.mUpTrackingIndicatorLabel.setVisibility(0);
                DefaultTrigger.this.mUpTrackingIndicatorLabel.setText(indeterminateUpAction.mTriggerTexts[0]);
                DefaultTrigger defaultTrigger3 = DefaultTrigger.this;
                defaultTrigger3.mLayout.smoothScrollTo(0, defaultTrigger3.mCurrentAction.mTriggerPoint);
                DefaultTrigger defaultTrigger4 = DefaultTrigger.this;
                defaultTrigger4.mUpContainer.layout(0, defaultTrigger4.mLayout.getBottom(), DefaultTrigger.this.mLayout.getWidth(), DefaultTrigger.this.mLayout.getBottom() - DefaultTrigger.this.mCurrentAction.mTriggerPoint);
                DefaultTrigger defaultTrigger5 = DefaultTrigger.this;
                defaultTrigger5.transition(defaultTrigger5.mWaitForIndeterminate);
            }
        }

        public void onActionComplete(IndeterminateUpAction indeterminateUpAction) {
            DefaultTrigger defaultTrigger = DefaultTrigger.this;
            if (defaultTrigger.mCurrentState != defaultTrigger.mActionStart || defaultTrigger.mCurrentAction != indeterminateUpAction) {
                return;
            }
            if (defaultTrigger.mLayout.getScrollY() != 0) {
                DefaultTrigger defaultTrigger2 = DefaultTrigger.this;
                defaultTrigger2.transition(defaultTrigger2.mActionComplete);
                DefaultTrigger defaultTrigger3 = DefaultTrigger.this;
                if (defaultTrigger3.mScrollState == 0) {
                    defaultTrigger3.mLayout.smoothScrollTo(0, 0);
                    return;
                }
                return;
            }
            DefaultTrigger defaultTrigger4 = DefaultTrigger.this;
            defaultTrigger4.transition(defaultTrigger4.mIdle);
        }

        public void onActionLoadFail(IndeterminateUpAction indeterminateUpAction) {
            DefaultTrigger defaultTrigger = DefaultTrigger.this;
            if (defaultTrigger.mCurrentState == defaultTrigger.mActionStart && defaultTrigger.mCurrentAction == indeterminateUpAction) {
                defaultTrigger.mUpLoadingIndicator.setVisibility(8);
                DefaultTrigger.this.mUpTrackingIndicator.setVisibility(8);
                DefaultTrigger.this.mUpTrackingIndicatorLabel.setText(indeterminateUpAction.mTriggerTexts[1]);
                if (DefaultTrigger.this.mLayout.getScrollY() != 0) {
                    DefaultTrigger defaultTrigger2 = DefaultTrigger.this;
                    defaultTrigger2.transition(defaultTrigger2.mActionComplete);
                    DefaultTrigger defaultTrigger3 = DefaultTrigger.this;
                    if (defaultTrigger3.mScrollState == 0) {
                        defaultTrigger3.mLayout.smoothScrollTo(0, 0);
                        return;
                    }
                    return;
                }
                DefaultTrigger defaultTrigger4 = DefaultTrigger.this;
                defaultTrigger4.transition(defaultTrigger4.mIdle);
            }
        }

        public void onUpdateTriggerTextIndex(IndeterminateUpAction indeterminateUpAction, int i, String str) {
            indeterminateUpAction.mTriggerTexts[i] = str;
        }
    };
    public RelativeLayout mUpContainer;
    public ProgressBar mUpLoadingIndicator;
    public RelativeLayout mUpTrackingContainer;
    public View mUpTrackingIndicator;
    public TextView mUpTrackingIndicatorLabel;
    public final WaitForIndeterminate mWaitForIndeterminate = new WaitForIndeterminate();

    public DefaultTrigger(Context context) {
        init(context);
    }

    private void init(Context context) {
        this.mContext = context;
        LayoutInflater from = LayoutInflater.from(context);
        this.mLayoutInflater = from;
        this.mContainer = (RelativeLayout) from.inflate(R.layout.didouix_sbl_trigger_layout, (ViewGroup) null);
        this.mUpContainer = (RelativeLayout) this.mLayoutInflater.inflate(R.layout.didouix_sbl_trigger_up_layout, (ViewGroup) null);
        this.mIndicatorContainer = (ViewGroup) this.mContainer.findViewById(R.id.indicator_container);
        this.mTrackingIndicator = this.mContainer.findViewById(R.id.tracking_progress);
        this.mTrackingIndicatorLabel = (TextView) this.mContainer.findViewById(R.id.tracking_progress_label);
        this.mLoadingIndicator = (ProgressBar) this.mContainer.findViewById(R.id.loading_progress);
        this.mUpTrackingContainer = (RelativeLayout) this.mUpContainer.findViewById(R.id.tracking_progress_up_container);
        this.mUpTrackingIndicator = this.mUpContainer.findViewById(R.id.tracking_progress_up);
        this.mUpTrackingIndicatorLabel = (TextView) this.mUpContainer.findViewById(R.id.tracking_progress_up_label);
        this.mUpLoadingIndicator = (ProgressBar) this.mUpContainer.findViewById(R.id.loading_progress_up);
        mIndeterminateDistance = context.getResources().getDimensionPixelSize(R.dimen.didouix_sbl_action_indeterminate_distance);
        mUpIndeterminateDistance = context.getResources().getDimensionPixelSize(R.dimen.didouix_sbl_action_upindeterminate_distance);
        int dimensionPixelSize = context.getResources().getDimensionPixelSize(R.dimen.didouix_sbl_action_simple_enter);
        mSimpleEnter = dimensionPixelSize;
        mSimpleTrigger = dimensionPixelSize;
        mIndeterminateTop = context.getResources().getDimensionPixelSize(R.dimen.didouix_sbl_tracking_progress_bg_margintop);
    }

    public void attach(SpringBackLayout springBackLayout) {
        if (!springBackLayout.springBackEnable()) {
            springBackLayout.setSpringBackEnable(true);
        }
        this.mLayout = springBackLayout;
        springBackLayout.addView(this.mContainer);
        springBackLayout.addView(this.mUpContainer);
        springBackLayout.addOnLayoutChangeListener(this.mLayoutChangeListener);
        springBackLayout.setOnSpringListener(this.mOnSpringListener);
        springBackLayout.addOnScrollListener(this.mOnScrollListener);
    }

    public void addAction(Action action) {
        if (action instanceof IndeterminateUpAction) {
            this.mUpAction = action;
            IndeterminateUpAction indeterminateUpAction = (IndeterminateUpAction) action;
            indeterminateUpAction.mUpDataListener = this.mUpActionDataListener;
            updateTextIdToString(this.mContext, indeterminateUpAction.mTriggerTextIDs, indeterminateUpAction.mTriggerTexts);
            this.mUpTrackingIndicatorLabel.setText(indeterminateUpAction.mTriggerTexts[0]);
            return;
        }
        int binarySearch = Collections.binarySearch(this.mActions, action, Action.DISTANCE_COMPARATOR);
        if (binarySearch < 0) {
            this.mActions.add((-binarySearch) - 1, action);
            if (action instanceof IndeterminateAction) {
                IndeterminateAction indeterminateAction = (IndeterminateAction) action;
                indeterminateAction.mCompleteListener = this.mCompleteListener;
                updateTextIdToString(this.mContext, indeterminateAction.mTriggerTextIDs, indeterminateAction.mTriggerTexts);
                return;
            }
            return;
        }
        throw new IllegalArgumentException("action conflict.");
    }

    public boolean removeAction(Action action) {
        if (isActionRunning()) {
            return false;
        }
        if (action instanceof IndeterminateUpAction) {
            ((IndeterminateUpAction) action).mUpDataListener = null;
            this.mUpAction = null;
            return true;
        }
        if (action != null && this.mActions.contains(action)) {
            if (action instanceof IndeterminateAction) {
                ((IndeterminateAction) action).mCompleteListener = null;
            }
            this.mActions.remove(action);
        }
        return true;
    }

    public boolean containAction(Action action) {
        if (action instanceof IndeterminateUpAction) {
            return this.mUpAction != null;
        }
        if (action == null || !this.mActions.contains(action)) {
            return false;
        }
        return true;
    }

    public boolean isActionRunning() {
        TriggerState triggerState = this.mCurrentState;
        return (triggerState == null || triggerState == this.mIdle) ? false : true;
    }

    public boolean isActionRunning(Action action) {
        TriggerState triggerState = this.mCurrentState;
        return (triggerState == null || triggerState == this.mIdle || this.mCurrentAction != action) ? false : true;
    }

    public static abstract class IndeterminateAction extends Action {
        public static final int DEFAULT_OFFSET_POINT = 0;
        static final int[] DEFAULT_TRIGGER_TEXTIDS = {R.string.didouix_sbl_tracking_progress_labe_pull_to_refresh, R.string.didouix_sbl_tracking_progress_labe_release_to_refresh, R.string.didouix_sbl_tracking_progress_labe_refreshing, R.string.didouix_sbl_tracking_progress_labe_refreshed};
        public OnActionCompleteListener mCompleteListener;
        public int[] mTriggerTextIDs;
        public String[] mTriggerTexts;

        interface OnActionCompleteListener {
            void onActionComplete(IndeterminateAction indeterminateAction);

            void onActionStart(IndeterminateAction indeterminateAction);

            void onUpdateTriggerTextIndex(IndeterminateAction indeterminateAction, int i, String str);
        }

        public IndeterminateAction(int i) {
            super(i, DefaultTrigger.mIndeterminateDistance + i);
            int[] iArr = DEFAULT_TRIGGER_TEXTIDS;
            this.mTriggerTexts = new String[iArr.length];
            if (i >= 0) {
                this.mTriggerTextIDs = iArr;
                return;
            }
            throw new IllegalArgumentException("invalid offsetPoint");
        }

        public IndeterminateAction(int i, int[] iArr) {
            super(i, DefaultTrigger.mIndeterminateDistance + i);
            int[] iArr2 = DEFAULT_TRIGGER_TEXTIDS;
            this.mTriggerTexts = new String[iArr2.length];
            if (i < 0) {
                throw new IllegalArgumentException("invalid offsetPoint");
            } else if (iArr == null || iArr.length != iArr2.length) {
                throw new IllegalArgumentException("invalid text Ids");
            } else {
                this.mTriggerTextIDs = iArr;
            }
        }

        public void notifyLoadComplete() {
            OnActionCompleteListener onActionCompleteListener = this.mCompleteListener;
            if (onActionCompleteListener != null) {
                onActionCompleteListener.onActionComplete(this);
            }
        }

        public void startIndeterminateAction() {
            OnActionCompleteListener onActionCompleteListener = this.mCompleteListener;
            if (onActionCompleteListener != null) {
                onActionCompleteListener.onActionStart(this);
            }
        }

        public void notifyTriggerTextIndex(int i, String str) {
            if (i < DEFAULT_TRIGGER_TEXTIDS.length) {
                OnActionCompleteListener onActionCompleteListener = this.mCompleteListener;
                if (onActionCompleteListener != null) {
                    onActionCompleteListener.onUpdateTriggerTextIndex(this, i, str);
                    return;
                }
                return;
            }
            throw new IllegalArgumentException("invalid index");
        }
    }

    public static abstract class IndeterminateUpAction extends Action {
        public static final int DEFAULT_OFFSET_POINT = 0;
        static final int[] DEFAULT_TRIGGER_TEXTIDS = {R.string.didouix_sbl_tracking_progress_labe_up_refresh, R.string.didouix_sbl_tracking_progress_labe_up_refresh_fail, R.string.didouix_sbl_tracking_progress_labe_up_nodata, R.string.didouix_sbl_tracking_progress_labe_up_none};
        private int mCountNoData = 0;
        public int[] mTriggerTextIDs;
        public String[] mTriggerTexts;
        public OnUpActionDataListener mUpDataListener;

        interface OnUpActionDataListener {
            void onActionComplete(IndeterminateUpAction indeterminateUpAction);

            void onActionLoadFail(IndeterminateUpAction indeterminateUpAction);

            void onActionNoData(IndeterminateUpAction indeterminateUpAction, int i);

            void onActionStart(IndeterminateUpAction indeterminateUpAction);

            void onUpdateTriggerTextIndex(IndeterminateUpAction indeterminateUpAction, int i, String str);
        }

        public boolean isNoData() {
            return this.mCountNoData > 0;
        }

        public int getCountNoData() {
            return this.mCountNoData;
        }

        public IndeterminateUpAction(int i) {
            super(i, DefaultTrigger.mUpIndeterminateDistance + i);
            int[] iArr = DEFAULT_TRIGGER_TEXTIDS;
            this.mTriggerTexts = new String[iArr.length];
            if (i >= 0) {
                this.mTriggerTextIDs = iArr;
                return;
            }
            throw new IllegalArgumentException("invalid offsetPoint");
        }

        public IndeterminateUpAction(int i, int[] iArr) {
            super(i, DefaultTrigger.mUpIndeterminateDistance + i);
            int[] iArr2 = DEFAULT_TRIGGER_TEXTIDS;
            this.mTriggerTexts = new String[iArr2.length];
            if (i < 0) {
                throw new IllegalArgumentException("invalid offsetPoint");
            } else if (iArr == null || iArr.length != iArr2.length) {
                throw new IllegalArgumentException("invalid text Ids");
            } else {
                this.mTriggerTextIDs = iArr;
            }
        }

        public void notifyActionNoData() {
            OnUpActionDataListener onUpActionDataListener = this.mUpDataListener;
            if (onUpActionDataListener != null) {
                int i = this.mCountNoData + 1;
                this.mCountNoData = i;
                onUpActionDataListener.onActionNoData(this, i);
            }
        }

        public void notifyLoadComplete() {
            OnUpActionDataListener onUpActionDataListener = this.mUpDataListener;
            if (onUpActionDataListener != null) {
                this.mCountNoData = 0;
                onUpActionDataListener.onActionComplete(this);
            }
        }

        public void notifyTriggerTextIndex(int i, String str) {
            if (i < DEFAULT_TRIGGER_TEXTIDS.length) {
                OnUpActionDataListener onUpActionDataListener = this.mUpDataListener;
                if (onUpActionDataListener != null) {
                    onUpActionDataListener.onUpdateTriggerTextIndex(this, i, str);
                    return;
                }
                return;
            }
            throw new IllegalArgumentException("invalid index");
        }

        public void notifyLoadFail() {
            OnUpActionDataListener onUpActionDataListener = this.mUpDataListener;
            if (onUpActionDataListener != null) {
                onUpActionDataListener.onActionLoadFail(this);
            }
        }

        public void startIndeterminateUpAction() {
            OnUpActionDataListener onUpActionDataListener = this.mUpDataListener;
            if (onUpActionDataListener != null) {
                this.mCountNoData = 0;
                onUpActionDataListener.onActionStart(this);
            }
        }
    }

    private void updateTextIdToString(Context context, int[] iArr, String[] strArr) {
        if (iArr != null) {
            for (int i = 0; i < iArr.length; i++) {
                strArr[i] = context.getResources().getString(iArr[i]);
            }
        }
    }

    public static abstract class SimpleAction extends Action {
        public View onCreateIndicator(LayoutInflater layoutInflater, ViewGroup viewGroup) {
            return null;
        }

        public SimpleAction() {
            super(DefaultTrigger.mSimpleEnter, DefaultTrigger.mSimpleTrigger);
        }
    }

    public static abstract class Action {
        static final Comparator<Action> DISTANCE_COMPARATOR = new Comparator<Action>() {
            public int compare(Action action, Action action2) {
                return Integer.compare(action.mEnterPoint, action2.mEnterPoint);
            }
        };
        int mEnterPoint;
        int mTriggerPoint;

        public abstract void onActivated();

        public abstract void onEntered();

        public abstract void onExit();

        public abstract void onFinished();

        public abstract void onTriggered();

        Action(int i, int i2) {
            this.mEnterPoint = i;
            this.mTriggerPoint = i2;
        }

        public void notifyTriggered() {
            onTriggered();
        }

        public void notifyEntered() {
            onEntered();
        }

        public void notifyExit() {
            onExit();
        }

        public void notifyActivated() {
            onActivated();
        }
    }

    private abstract class TriggerState {
        public void handleScrollStateChange(int i, int i2) {
        }

        public void handleScrolled(int i, int i2) {
        }

        public boolean handleSpringBack() {
            return false;
        }

        private TriggerState() {
        }
    }

    private class Idle extends TriggerState {
        private Idle() {
            super();
        }

        public void handleScrollStateChange(int i, int i2) {
            if (i == 0) {
                if (i2 == 1 || i2 == 2) {
                    DefaultTrigger defaultTrigger = DefaultTrigger.this;
                    defaultTrigger.transition(defaultTrigger.mTracking);
                }
            }
        }
    }

    private class Tracking extends TriggerState {
        private boolean mLockActivated;
        private boolean mTriggerable;
        private boolean mUpTriggerable;

        private Tracking() {
            super();
            this.mTriggerable = false;
            this.mUpTriggerable = false;
            this.mLockActivated = false;
        }

        public void handleScrollStateChange(int i, int i2) {
            if (i2 == 0) {
                DefaultTrigger defaultTrigger = DefaultTrigger.this;
                defaultTrigger.transition(defaultTrigger.mIdle);
                if (!this.mTriggerable) {
                    DefaultTrigger.this.mIndicatorContainer.removeAllViews();
                    DefaultTrigger defaultTrigger2 = DefaultTrigger.this;
                    defaultTrigger2.mSimpleActionView = null;
                    defaultTrigger2.mIndicatorContainer.setVisibility(8);
                    DefaultTrigger.this.mTrackingIndicator.setVisibility(8);
                    DefaultTrigger.this.mTrackingIndicatorLabel.setVisibility(8);
                }
                this.mUpTriggerable = false;
                this.mLockActivated = false;
            }
        }

        /* JADX WARNING: Code restructure failed: missing block: B:4:0x000d, code lost:
            r0 = r6.this$0;
         */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public boolean handleSpringBack() {
            /*
                r6 = this;
                boolean r0 = r6.mTriggerable
                r1 = 0
                r2 = 8
                if (r0 == 0) goto L_0x000d
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r0 = r0.mCurrentAction
                if (r0 != 0) goto L_0x0025
            L_0x000d:
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r3 = r0.mCurrentAction
                if (r3 == 0) goto L_0x0025
                boolean r3 = r3 instanceof com.pri.didouix.springback.trigger.DefaultTrigger.SimpleAction
                if (r3 == 0) goto L_0x0025
                android.view.ViewGroup r0 = r0.mIndicatorContainer
                r0.removeAllViews()
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                r0.mSimpleActionView = r1
                android.view.ViewGroup r0 = r0.mIndicatorContainer
                r0.setVisibility(r2)
            L_0x0025:
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r3 = r0.mCurrentAction
                r4 = 0
                if (r3 != 0) goto L_0x002d
                return r4
            L_0x002d:
                boolean r3 = r3 instanceof com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateAction
                r5 = 1
                if (r3 == 0) goto L_0x007c
                android.view.View r0 = r0.mTrackingIndicator
                int r0 = r0.getVisibility()
                if (r0 == r2) goto L_0x007c
                boolean r0 = r6.mTriggerable
                if (r0 == 0) goto L_0x0052
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.view.SpringBackLayout r1 = r0.mLayout
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r0 = r0.mCurrentAction
                int r0 = r0.mTriggerPoint
                int r0 = -r0
                r1.smoothScrollTo(r4, r0)
                com.pri.didouix.springback.trigger.DefaultTrigger r6 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$WaitForIndeterminate r0 = r6.mWaitForIndeterminate
                r6.transition(r0)
                goto L_0x007b
            L_0x0052:
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.view.SpringBackLayout r0 = r0.mLayout
                float r0 = r0.getScaleY()
                float r0 = java.lang.Math.abs(r0)
                com.pri.didouix.springback.trigger.DefaultTrigger r1 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r1 = r1.mCurrentAction
                int r1 = r1.mTriggerPoint
                int r1 = java.lang.Math.abs(r1)
                float r1 = (float) r1
                int r0 = (r0 > r1 ? 1 : (r0 == r1 ? 0 : -1))
                if (r0 >= 0) goto L_0x0074
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r0 = r0.mCurrentAction
                r0.onExit()
            L_0x0074:
                com.pri.didouix.springback.trigger.DefaultTrigger r6 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.view.SpringBackLayout r6 = r6.mLayout
                r6.smoothScrollTo(r4, r4)
            L_0x007b:
                return r5
            L_0x007c:
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r3 = r0.mCurrentAction
                boolean r3 = r3 instanceof com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateUpAction
                if (r3 == 0) goto L_0x00a0
                android.widget.RelativeLayout r0 = r0.mUpTrackingContainer
                int r0 = r0.getVisibility()
                if (r0 != r2) goto L_0x008d
                goto L_0x00a0
            L_0x008d:
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.view.SpringBackLayout r1 = r0.mLayout
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r0 = r0.mCurrentAction
                int r0 = r0.mTriggerPoint
                r1.smoothScrollTo(r4, r0)
                com.pri.didouix.springback.trigger.DefaultTrigger r6 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$WaitForIndeterminate r0 = r6.mWaitForIndeterminate
                r6.transition(r0)
                return r5
            L_0x00a0:
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$ActionTriggered r3 = r0.mActionTriggered
                r0.transition(r3)
                boolean r0 = r6.mLockActivated
                if (r0 == 0) goto L_0x00b3
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r0 = r0.mCurrentAction
                r0.notifyTriggered()
                goto L_0x00ba
            L_0x00b3:
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                com.pri.didouix.springback.trigger.DefaultTrigger$Action r0 = r0.mCurrentAction
                r0.onExit()
            L_0x00ba:
                com.pri.didouix.springback.trigger.DefaultTrigger r0 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                android.view.ViewGroup r0 = r0.mIndicatorContainer
                r0.removeAllViews()
                com.pri.didouix.springback.trigger.DefaultTrigger r6 = com.pri.didouix.springback.trigger.DefaultTrigger.this
                r6.mSimpleActionView = r1
                android.view.ViewGroup r6 = r6.mIndicatorContainer
                r6.setVisibility(r2)
                return r4
            */
            throw new UnsupportedOperationException("Method not decompiled: com.pri.didouix.springback.trigger.DefaultTrigger.Tracking.handleSpringBack():boolean");
        }

        public void handleScrolled(int i, int i2) {
            DefaultTrigger defaultTrigger = DefaultTrigger.this;
            int i3 = defaultTrigger.mScrollState;
            if (i3 == 1 || i3 == 2) {
                int i4 = defaultTrigger.mScrollDistance;
                if (i4 < 0) {
                    if (!defaultTrigger.mUpActionBegin) {
                        this.mUpTriggerable = false;
                    }
                    boolean z = this.mUpTriggerable;
                    Action action = defaultTrigger.mUpAction;
                    if (action != null) {
                        defaultTrigger.mCurrentAction = action;
                        int abs = Math.abs(i4);
                        DefaultTrigger defaultTrigger2 = DefaultTrigger.this;
                        if (abs > defaultTrigger2.mUpAction.mEnterPoint && !defaultTrigger2.mUpActionBegin) {
                            defaultTrigger2.mUpActionBegin = true;
                            this.mUpTriggerable = true;
                            defaultTrigger2.mUpContainer.setVisibility(0);
                            DefaultTrigger.this.mUpTrackingContainer.setVisibility(0);
                            if (((IndeterminateUpAction) DefaultTrigger.this.mUpAction).isNoData()) {
                                DefaultTrigger.this.mUpTrackingIndicator.setVisibility(8);
                                DefaultTrigger.this.mUpLoadingIndicator.setVisibility(8);
                                if (((IndeterminateUpAction) DefaultTrigger.this.mUpAction).getCountNoData() < 3) {
                                    DefaultTrigger defaultTrigger3 = DefaultTrigger.this;
                                    defaultTrigger3.mUpTrackingIndicatorLabel.setText(((IndeterminateUpAction) defaultTrigger3.mUpAction).mTriggerTexts[2]);
                                } else {
                                    DefaultTrigger defaultTrigger4 = DefaultTrigger.this;
                                    defaultTrigger4.mUpTrackingIndicatorLabel.setText(((IndeterminateUpAction) defaultTrigger4.mUpAction).mTriggerTexts[3]);
                                }
                            } else {
                                DefaultTrigger.this.mUpTrackingIndicator.setVisibility(0);
                                DefaultTrigger.this.mUpLoadingIndicator.setVisibility(0);
                                DefaultTrigger.this.mUpTrackingIndicatorLabel.setVisibility(0);
                                DefaultTrigger defaultTrigger5 = DefaultTrigger.this;
                                defaultTrigger5.mUpTrackingIndicatorLabel.setText(((IndeterminateUpAction) defaultTrigger5.mUpAction).mTriggerTexts[0]);
                            }
                            DefaultTrigger.this.mUpAction.onEntered();
                        }
                        boolean z2 = this.mUpTriggerable;
                        if (z != z2 && z2) {
                            DefaultTrigger.this.mUpAction.notifyActivated();
                            DefaultTrigger defaultTrigger6 = DefaultTrigger.this;
                            if (defaultTrigger6.mScrollState == 2) {
                                defaultTrigger6.mLayout.smoothScrollTo(0, defaultTrigger6.mUpAction.mTriggerPoint);
                                DefaultTrigger defaultTrigger7 = DefaultTrigger.this;
                                defaultTrigger7.transition(defaultTrigger7.mWaitForIndeterminate);
                                return;
                            }
                            return;
                        }
                        return;
                    }
                    return;
                }
                this.mUpTriggerable = false;
                int i5 = defaultTrigger.mActionIndex;
                boolean z3 = this.mTriggerable;
                Action action2 = defaultTrigger.mCurrentAction;
                for (int i6 = 0; i6 < DefaultTrigger.this.mActions.size(); i6++) {
                    DefaultTrigger defaultTrigger8 = DefaultTrigger.this;
                    if (defaultTrigger8.mScrollDistance <= defaultTrigger8.mActions.get(i6).mEnterPoint) {
                        break;
                    }
                    DefaultTrigger.this.mActionIndex = i6;
                }
                DefaultTrigger defaultTrigger9 = DefaultTrigger.this;
                int i7 = defaultTrigger9.mActionIndex;
                if (i7 >= 0) {
                    defaultTrigger9.mCurrentAction = defaultTrigger9.mActions.get(i7);
                    DefaultTrigger defaultTrigger10 = DefaultTrigger.this;
                    this.mTriggerable = defaultTrigger10.mScrollDistance >= defaultTrigger10.mCurrentAction.mTriggerPoint;
                } else {
                    defaultTrigger9.mCurrentAction = null;
                    this.mTriggerable = false;
                }
                DefaultTrigger defaultTrigger11 = DefaultTrigger.this;
                if (i5 != defaultTrigger11.mActionIndex) {
                    if (action2 != null) {
                        action2.onExit();
                        DefaultTrigger.this.mIndicatorContainer.removeAllViews();
                        DefaultTrigger.this.mSimpleActionView = null;
                    }
                    DefaultTrigger defaultTrigger12 = DefaultTrigger.this;
                    Action action3 = defaultTrigger12.mCurrentAction;
                    if (action3 != null) {
                        if (action3 instanceof SimpleAction) {
                            SimpleAction simpleAction = (SimpleAction) action3;
                            if (defaultTrigger12.mIndicatorContainer.getChildCount() == 0) {
                                DefaultTrigger defaultTrigger13 = DefaultTrigger.this;
                                defaultTrigger13.mSimpleActionView = simpleAction.onCreateIndicator(defaultTrigger13.mLayoutInflater, defaultTrigger13.mIndicatorContainer);
                            }
                            DefaultTrigger defaultTrigger14 = DefaultTrigger.this;
                            defaultTrigger14.viewShow(defaultTrigger14.mIndicatorContainer, defaultTrigger14.mSimpleActionView);
                            DefaultTrigger.this.mTrackingIndicator.setVisibility(8);
                            DefaultTrigger.this.mTrackingIndicatorLabel.setVisibility(8);
                        } else {
                            defaultTrigger12.mTrackingIndicator.setVisibility(0);
                            DefaultTrigger.this.mTrackingIndicatorLabel.setVisibility(0);
                            DefaultTrigger.this.mIndicatorContainer.removeAllViews();
                            DefaultTrigger defaultTrigger15 = DefaultTrigger.this;
                            defaultTrigger15.mSimpleActionView = null;
                            defaultTrigger15.mIndicatorContainer.setVisibility(8);
                        }
                        DefaultTrigger.this.mCurrentAction.onEntered();
                        this.mLockActivated = false;
                        if (this.mTriggerable) {
                            Action action4 = DefaultTrigger.this.mCurrentAction;
                            if (action4 instanceof SimpleAction) {
                                this.mLockActivated = true;
                            }
                            action4.onActivated();
                            return;
                        }
                        return;
                    }
                    defaultTrigger12.mIndicatorContainer.setVisibility(8);
                } else if (action2 != null && z3 != this.mTriggerable) {
                    if (z3) {
                        action2.onEntered();
                        this.mLockActivated = false;
                        return;
                    }
                    if (defaultTrigger11.mCurrentAction instanceof SimpleAction) {
                        this.mLockActivated = true;
                    }
                    action2.onActivated();
                    DefaultTrigger defaultTrigger16 = DefaultTrigger.this;
                    if (defaultTrigger16.mCurrentAction instanceof IndeterminateAction) {
                        defaultTrigger16.mLoadingIndicator.setVisibility(4);
                    }
                }
            }
        }
    }

    private class WaitForIndeterminate extends TriggerState {
        private WaitForIndeterminate() {
            super();
        }

        public void handleScrollStateChange(int i, int i2) {
            if (i2 == 0) {
                DefaultTrigger defaultTrigger = DefaultTrigger.this;
                defaultTrigger.transition(defaultTrigger.mActionStart);
                DefaultTrigger defaultTrigger2 = DefaultTrigger.this;
                Action action = defaultTrigger2.mCurrentAction;
                if (action instanceof IndeterminateAction) {
                    action.notifyTriggered();
                    DefaultTrigger.this.mLoadingIndicator.setVisibility(0);
                    DefaultTrigger.this.mTrackingIndicator.setVisibility(0);
                    DefaultTrigger.this.mTrackingIndicatorLabel.setVisibility(0);
                    DefaultTrigger defaultTrigger3 = DefaultTrigger.this;
                    defaultTrigger3.mTrackingIndicatorLabel.setText(((IndeterminateAction) defaultTrigger3.mCurrentAction).mTriggerTexts[2]);
                    if (DefaultTrigger.this.mLoadingIndicator.getVisibility() == 0) {
                        DefaultTrigger.this.mLoadingIndicator.setAlpha(1.0f);
                        DefaultTrigger.this.mLoadingIndicator.setScaleX(1.0f);
                        DefaultTrigger.this.mLoadingIndicator.setScaleY(1.0f);
                    }
                } else if (action instanceof IndeterminateUpAction) {
                    defaultTrigger2.mUpAction.notifyTriggered();
                    if (((IndeterminateUpAction) DefaultTrigger.this.mUpAction).isNoData()) {
                        DefaultTrigger.this.mUpTrackingIndicator.setVisibility(8);
                        DefaultTrigger.this.mUpLoadingIndicator.setVisibility(8);
                        if (((IndeterminateUpAction) DefaultTrigger.this.mUpAction).getCountNoData() < 3) {
                            DefaultTrigger defaultTrigger4 = DefaultTrigger.this;
                            defaultTrigger4.mUpTrackingIndicatorLabel.setText(((IndeterminateUpAction) defaultTrigger4.mUpAction).mTriggerTexts[2]);
                            return;
                        }
                        DefaultTrigger defaultTrigger5 = DefaultTrigger.this;
                        defaultTrigger5.mUpTrackingIndicatorLabel.setText(((IndeterminateUpAction) defaultTrigger5.mUpAction).mTriggerTexts[3]);
                        return;
                    }
                    DefaultTrigger.this.mUpTrackingIndicator.setVisibility(0);
                    DefaultTrigger.this.mUpLoadingIndicator.setVisibility(0);
                    DefaultTrigger defaultTrigger6 = DefaultTrigger.this;
                    defaultTrigger6.mUpTrackingIndicatorLabel.setText(((IndeterminateUpAction) defaultTrigger6.mUpAction).mTriggerTexts[0]);
                }
            }
        }
    }

    private class ActionTriggered extends TriggerState {
        private ActionTriggered() {
            super();
        }

        public void handleScrollStateChange(int i, int i2) {
            if (i2 == 0) {
                DefaultTrigger defaultTrigger = DefaultTrigger.this;
                defaultTrigger.transition(defaultTrigger.mIdle);
            }
        }

        public void handleScrolled(int i, int i2) {
            DefaultTrigger defaultTrigger = DefaultTrigger.this;
            Action action = defaultTrigger.mCurrentAction;
            if (action != null && (action instanceof SimpleAction) && defaultTrigger.mScrollDistance < action.mEnterPoint && defaultTrigger.mScrollState == 1) {
                defaultTrigger.mActionIndex = -1;
                defaultTrigger.transition(defaultTrigger.mTracking);
            }
        }
    }

    private class ActionStart extends TriggerState {
        private ActionStart() {
            super();
        }

        public void handleScrollStateChange(int i, int i2) {
            super.handleScrollStateChange(i, i2);
        }

        public void handleScrolled(int i, int i2) {
            super.handleScrolled(i, i2);
        }

        public boolean handleSpringBack() {
            return super.handleSpringBack();
        }
    }

    private class ActionComplete extends TriggerState {
        private ActionComplete() {
            super();
        }

        public void handleScrollStateChange(int i, int i2) {
            super.handleScrollStateChange(i, i2);
            if (i2 == 0) {
                DefaultTrigger defaultTrigger = DefaultTrigger.this;
                defaultTrigger.transition(defaultTrigger.mIdle);
            }
        }
    }

    public void viewShow(ViewGroup viewGroup, View view) {
        if (view != null) {
            if (viewGroup.getChildCount() == 0) {
                viewGroup.addView(view);
            }
            viewGroup.setVisibility(0);
        }
    }

    public void transition(TriggerState triggerState) {
        Action action;
        this.mCurrentState = triggerState;
        if (triggerState == this.mIdle) {
            if (this.mScrollerFinished && (action = this.mCurrentAction) != null) {
                action.onFinished();
            }
            this.mCurrentAction = null;
            this.mActionIndex = -1;
            this.mUpActionBegin = false;
        }
    }
}
