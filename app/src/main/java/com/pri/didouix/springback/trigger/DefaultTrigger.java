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
/* loaded from: classes4.dex */
public class DefaultTrigger {
    private static final float OFFSET_RESET_STATE = 0.25f;
    private static final String TAG = "DefaultTrigger";
    public static int mIndeterminateDistance;
    public static int mIndeterminateTop;
    public static int mSimpleEnter;
    public static int mSimpleTrigger;
    public static int mUpIndeterminateDistance;
    public RelativeLayout mContainer;
    private Context mContext;
    public Action mCurrentAction;
    public ViewGroup mIndicatorContainer;
    public int mLastScrollDistance;
    public SpringBackLayout mLayout;
    public LayoutInflater mLayoutInflater;
    public ProgressBar mLoadingIndicator;
    public int mScrollDistance;
    public int mScrollState;
    public View mSimpleActionView;
    public View mTrackingIndicator;
    public TextView mTrackingIndicatorLabel;
    public Action mUpAction;
    public RelativeLayout mUpContainer;
    public ProgressBar mUpLoadingIndicator;
    public RelativeLayout mUpTrackingContainer;
    public View mUpTrackingIndicator;
    public TextView mUpTrackingIndicatorLabel;
    public final ActionComplete mActionComplete = new ActionComplete();
    public int mActionIndex = -1;
    public final ActionStart mActionStart = new ActionStart();
    public final ActionTriggered mActionTriggered = new ActionTriggered();
    public List<Action> mActions = new ArrayList();
    private IndeterminateAction.OnActionCompleteListener mCompleteListener = new IndeterminateAction.OnActionCompleteListener() { // from class: com.pri.didouix.springback.trigger.DefaultTrigger.1
        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateAction.OnActionCompleteListener
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

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateAction.OnActionCompleteListener
        public void onActionStart(IndeterminateAction indeterminateAction) {
            Action action;
            if (DefaultTrigger.this.mActions.size() <= 0 || (action = DefaultTrigger.this.mActions.get(0)) != indeterminateAction) {
                return;
            }
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

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateAction.OnActionCompleteListener
        public void onUpdateTriggerTextIndex(IndeterminateAction indeterminateAction, int i, String str) {
            indeterminateAction.mTriggerTexts[i] = str;
        }
    };
    public final Idle mIdle = new Idle();
    public TriggerState mCurrentState = this.mIdle;
    private View.OnLayoutChangeListener mLayoutChangeListener = new View.OnLayoutChangeListener() { // from class: com.pri.didouix.springback.trigger.DefaultTrigger.2
        @Override // android.view.View.OnLayoutChangeListener
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
            if (DefaultTrigger.this.mTrackingIndicator.getVisibility() == 0 && (action = (defaultTrigger = DefaultTrigger.this).mCurrentAction) != null && (action instanceof IndeterminateAction)) {
                if (defaultTrigger.mTrackingIndicatorBottom <= 0) {
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
    private SpringBackLayout.OnScrollListener mOnScrollListener = new SpringBackLayout.OnScrollListener() { // from class: com.pri.didouix.springback.trigger.DefaultTrigger.3
        @Override // com.pri.didouix.springback.view.SpringBackLayout.OnScrollListener
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

        /* JADX WARN: Removed duplicated region for block: B:70:0x028e  */
        /* JADX WARN: Removed duplicated region for block: B:89:0x02fe  */
        /* JADX WARN: Removed duplicated region for block: B:93:? A[RETURN, SYNTHETIC] */
        @Override // com.pri.didouix.springback.view.SpringBackLayout.OnScrollListener
        /*
            Code decompiled incorrectly, please refer to instructions dump.
            To view partially-correct add '--show-bad-code' argument
        */
        public void onScrolled(com.pri.didouix.springback.view.SpringBackLayout r10, int r11, int r12) {
            /*
                Method dump skipped, instructions count: 779
                To view this dump add '--comments-level debug' option
            */
            throw new UnsupportedOperationException("Method not decompiled: com.pri.didouix.springback.trigger.DefaultTrigger.AnonymousClass3.onScrolled(com.pri.didouix.springback.view.SpringBackLayout, int, int):void");
        }
    };
    private SpringBackLayout.OnSpringListener mOnSpringListener = new SpringBackLayout.OnSpringListener() { // from class: com.pri.didouix.springback.trigger.DefaultTrigger.4
        @Override // com.pri.didouix.springback.view.SpringBackLayout.OnSpringListener
        public boolean onSpringBack() {
            return DefaultTrigger.this.mCurrentState.handleSpringBack();
        }
    };
    public boolean mScrollerFinished = true;
    public final Tracking mTracking = new Tracking();
    public int mTrackingIndicatorBottom = 0;
    public int mTrackingIndicatorLabelBottom = 0;
    public int mTrackingIndicatorLabelTop = 0;
    public boolean mUpActionBegin = false;
    private IndeterminateUpAction.OnUpActionDataListener mUpActionDataListener = new IndeterminateUpAction.OnUpActionDataListener() { // from class: com.pri.didouix.springback.trigger.DefaultTrigger.5
        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateUpAction.OnUpActionDataListener
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

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateUpAction.OnUpActionDataListener
        public void onActionStart(IndeterminateUpAction indeterminateUpAction) {
            DefaultTrigger defaultTrigger = DefaultTrigger.this;
            Action action = defaultTrigger.mUpAction;
            if (action == null || action != indeterminateUpAction) {
                return;
            }
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

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateUpAction.OnUpActionDataListener
        public void onActionComplete(IndeterminateUpAction indeterminateUpAction) {
            DefaultTrigger defaultTrigger = DefaultTrigger.this;
            if (defaultTrigger.mCurrentState == defaultTrigger.mActionStart && defaultTrigger.mCurrentAction == indeterminateUpAction) {
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
        }

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateUpAction.OnUpActionDataListener
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

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.IndeterminateUpAction.OnUpActionDataListener
        public void onUpdateTriggerTextIndex(IndeterminateUpAction indeterminateUpAction, int i, String str) {
            indeterminateUpAction.mTriggerTexts[i] = str;
        }
    };
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
        return !(action instanceof IndeterminateUpAction) ? action != null && this.mActions.contains(action) : this.mUpAction != null;
    }

    public boolean isActionRunning() {
        TriggerState triggerState = this.mCurrentState;
        return (triggerState == null || triggerState == this.mIdle) ? false : true;
    }

    public boolean isActionRunning(Action action) {
        TriggerState triggerState = this.mCurrentState;
        return (triggerState == null || triggerState == this.mIdle || this.mCurrentAction != action) ? false : true;
    }

    /* loaded from: classes4.dex */
    public static abstract class IndeterminateAction extends Action {
        public static final int DEFAULT_OFFSET_POINT = 0;
        static final int[] DEFAULT_TRIGGER_TEXTIDS = {R.string.didouix_sbl_tracking_progress_labe_pull_to_refresh, R.string.didouix_sbl_tracking_progress_labe_release_to_refresh, R.string.didouix_sbl_tracking_progress_labe_refreshing, R.string.didouix_sbl_tracking_progress_labe_refreshed};
        public OnActionCompleteListener mCompleteListener;
        public int[] mTriggerTextIDs;
        public String[] mTriggerTexts;

        /* loaded from: classes4.dex */
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
            }
            if (iArr == null || iArr.length != iArr2.length) {
                throw new IllegalArgumentException("invalid text Ids");
            }
            this.mTriggerTextIDs = iArr;
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

    /* loaded from: classes4.dex */
    public static abstract class IndeterminateUpAction extends Action {
        public static final int DEFAULT_OFFSET_POINT = 0;
        static final int[] DEFAULT_TRIGGER_TEXTIDS = {R.string.didouix_sbl_tracking_progress_labe_up_refresh, R.string.didouix_sbl_tracking_progress_labe_up_refresh_fail, R.string.didouix_sbl_tracking_progress_labe_up_nodata, R.string.didouix_sbl_tracking_progress_labe_up_none};
        private int mCountNoData;
        public int[] mTriggerTextIDs;
        public String[] mTriggerTexts;
        public OnUpActionDataListener mUpDataListener;

        /* loaded from: classes4.dex */
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
            this.mCountNoData = 0;
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
            this.mCountNoData = 0;
            int[] iArr2 = DEFAULT_TRIGGER_TEXTIDS;
            this.mTriggerTexts = new String[iArr2.length];
            if (i < 0) {
                throw new IllegalArgumentException("invalid offsetPoint");
            }
            if (iArr == null || iArr.length != iArr2.length) {
                throw new IllegalArgumentException("invalid text Ids");
            }
            this.mTriggerTextIDs = iArr;
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

    /* loaded from: classes4.dex */
    public static abstract class SimpleAction extends Action {
        public View onCreateIndicator(LayoutInflater layoutInflater, ViewGroup viewGroup) {
            return null;
        }

        public SimpleAction() {
            super(DefaultTrigger.mSimpleEnter, DefaultTrigger.mSimpleTrigger);
        }
    }

    /* loaded from: classes4.dex */
    public static abstract class Action {
        static final Comparator<Action> DISTANCE_COMPARATOR = new Comparator<Action>() { // from class: com.pri.didouix.springback.trigger.DefaultTrigger.Action.1
            @Override // java.util.Comparator
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

    /* JADX INFO: Access modifiers changed from: private */
    /* loaded from: classes4.dex */
    public abstract class TriggerState {
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

    /* JADX INFO: Access modifiers changed from: private */
    /* loaded from: classes4.dex */
    public class Idle extends TriggerState {
        private Idle() {
            super();
        }

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.TriggerState
        public void handleScrollStateChange(int i, int i2) {
            if (i != 0) {
                return;
            }
            if (i2 == 1 || i2 == 2) {
                DefaultTrigger defaultTrigger = DefaultTrigger.this;
                defaultTrigger.transition(defaultTrigger.mTracking);
            }
        }
    }

    /* loaded from: classes4.dex */
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

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.TriggerState
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

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.TriggerState
        public boolean handleSpringBack() {
            DefaultTrigger defaultTrigger;
            Action action;
            if ((!this.mTriggerable || DefaultTrigger.this.mCurrentAction == null) && (action = (defaultTrigger = DefaultTrigger.this).mCurrentAction) != null && (action instanceof SimpleAction)) {
                defaultTrigger.mIndicatorContainer.removeAllViews();
                DefaultTrigger defaultTrigger2 = DefaultTrigger.this;
                defaultTrigger2.mSimpleActionView = null;
                defaultTrigger2.mIndicatorContainer.setVisibility(8);
            }
            DefaultTrigger defaultTrigger3 = DefaultTrigger.this;
            Action action2 = defaultTrigger3.mCurrentAction;
            if (action2 == null) {
                return false;
            }
            if ((action2 instanceof IndeterminateAction) && defaultTrigger3.mTrackingIndicator.getVisibility() != 8) {
                if (this.mTriggerable) {
                    DefaultTrigger defaultTrigger4 = DefaultTrigger.this;
                    defaultTrigger4.mLayout.smoothScrollTo(0, -defaultTrigger4.mCurrentAction.mTriggerPoint);
                    DefaultTrigger defaultTrigger5 = DefaultTrigger.this;
                    defaultTrigger5.transition(defaultTrigger5.mWaitForIndeterminate);
                } else {
                    if (Math.abs(DefaultTrigger.this.mLayout.getScaleY()) < Math.abs(DefaultTrigger.this.mCurrentAction.mTriggerPoint)) {
                        DefaultTrigger.this.mCurrentAction.onExit();
                    }
                    DefaultTrigger.this.mLayout.smoothScrollTo(0, 0);
                }
                return true;
            }
            DefaultTrigger defaultTrigger6 = DefaultTrigger.this;
            if (!(defaultTrigger6.mCurrentAction instanceof IndeterminateUpAction) || defaultTrigger6.mUpTrackingContainer.getVisibility() == 8) {
                DefaultTrigger defaultTrigger7 = DefaultTrigger.this;
                defaultTrigger7.transition(defaultTrigger7.mActionTriggered);
                if (this.mLockActivated) {
                    DefaultTrigger.this.mCurrentAction.notifyTriggered();
                } else {
                    DefaultTrigger.this.mCurrentAction.onExit();
                }
                DefaultTrigger.this.mIndicatorContainer.removeAllViews();
                DefaultTrigger defaultTrigger8 = DefaultTrigger.this;
                defaultTrigger8.mSimpleActionView = null;
                defaultTrigger8.mIndicatorContainer.setVisibility(8);
                return false;
            }
            DefaultTrigger defaultTrigger9 = DefaultTrigger.this;
            defaultTrigger9.mLayout.smoothScrollTo(0, defaultTrigger9.mCurrentAction.mTriggerPoint);
            DefaultTrigger defaultTrigger10 = DefaultTrigger.this;
            defaultTrigger10.transition(defaultTrigger10.mWaitForIndeterminate);
            return true;
        }

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.TriggerState
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
                        if (z == z2 || !z2) {
                            return;
                        }
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

    /* loaded from: classes4.dex */
    private class WaitForIndeterminate extends TriggerState {
        private WaitForIndeterminate() {
            super();
        }

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.TriggerState
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

    /* loaded from: classes4.dex */
    private class ActionTriggered extends TriggerState {
        private ActionTriggered() {
            super();
        }

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.TriggerState
        public void handleScrollStateChange(int i, int i2) {
            if (i2 == 0) {
                DefaultTrigger defaultTrigger = DefaultTrigger.this;
                defaultTrigger.transition(defaultTrigger.mIdle);
            }
        }

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.TriggerState
        public void handleScrolled(int i, int i2) {
            DefaultTrigger defaultTrigger = DefaultTrigger.this;
            Action action = defaultTrigger.mCurrentAction;
            if (action == null || !(action instanceof SimpleAction) || defaultTrigger.mScrollDistance >= action.mEnterPoint || defaultTrigger.mScrollState != 1) {
                return;
            }
            defaultTrigger.mActionIndex = -1;
            defaultTrigger.transition(defaultTrigger.mTracking);
        }
    }

    /* loaded from: classes4.dex */
    private class ActionStart extends TriggerState {
        private ActionStart() {
            super();
        }

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.TriggerState
        public void handleScrollStateChange(int i, int i2) {
            super.handleScrollStateChange(i, i2);
        }

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.TriggerState
        public void handleScrolled(int i, int i2) {
            super.handleScrolled(i, i2);
        }

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.TriggerState
        public boolean handleSpringBack() {
            return super.handleSpringBack();
        }
    }

    /* loaded from: classes4.dex */
    private class ActionComplete extends TriggerState {
        private ActionComplete() {
            super();
        }

        @Override // com.pri.didouix.springback.trigger.DefaultTrigger.TriggerState
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
