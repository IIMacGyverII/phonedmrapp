package androidx.constraintlayout.motion.widget;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.DashPathEffect;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Rect;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.util.Log;
import android.util.SparseArray;
import android.util.SparseIntArray;
import android.view.MotionEvent;
import android.view.VelocityTracker;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Interpolator;
import android.widget.TextView;
import androidx.constraintlayout.motion.utils.StopLogic;
import androidx.constraintlayout.motion.widget.MotionScene;
import androidx.constraintlayout.solver.widgets.Barrier;
import androidx.constraintlayout.solver.widgets.ConstraintAnchor;
import androidx.constraintlayout.solver.widgets.ConstraintWidget;
import androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer;
import androidx.constraintlayout.solver.widgets.Flow;
import androidx.constraintlayout.solver.widgets.Guideline;
import androidx.constraintlayout.solver.widgets.Helper;
import androidx.constraintlayout.solver.widgets.HelperWidget;
import androidx.constraintlayout.solver.widgets.VirtualLayout;
import androidx.constraintlayout.widget.ConstraintHelper;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.constraintlayout.widget.ConstraintLayoutStates;
import androidx.constraintlayout.widget.ConstraintSet;
import androidx.constraintlayout.widget.Constraints;
import androidx.constraintlayout.widget.R;
import androidx.constraintlayout.widget.StateSet;
import androidx.core.internal.view.SupportMenu;
import androidx.core.view.NestedScrollingParent3;
import androidx.core.view.ViewCompat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

public class MotionLayout extends ConstraintLayout implements NestedScrollingParent3 {
    private static final boolean DEBUG = false;
    public static final int DEBUG_SHOW_NONE = 0;
    public static final int DEBUG_SHOW_PATH = 2;
    public static final int DEBUG_SHOW_PROGRESS = 1;
    public static boolean IS_IN_EDIT_MODE = false;
    static final int MAX_KEY_FRAMES = 50;
    static final String TAG = "MotionLayout";
    public static final int TOUCH_UP_COMPLETE = 0;
    public static final int TOUCH_UP_COMPLETE_TO_END = 2;
    public static final int TOUCH_UP_COMPLETE_TO_START = 1;
    public static final int TOUCH_UP_DECELERATE = 4;
    public static final int TOUCH_UP_DECELERATE_AND_COMPLETE = 5;
    public static final int TOUCH_UP_STOP = 3;
    public static final int VELOCITY_LAYOUT = 1;
    public static final int VELOCITY_POST_LAYOUT = 0;
    public static final int VELOCITY_STATIC_LAYOUT = 3;
    public static final int VELOCITY_STATIC_POST_LAYOUT = 2;
    boolean firstDown = true;
    private float lastPos;
    private float lastY;
    private long mAnimationStartTime = 0;
    private int mBeginState = -1;
    private RectF mBoundsCheck = new RectF();
    int mCurrentState = -1;
    int mDebugPath = 0;
    private DecelerateInterpolator mDecelerateLogic = new DecelerateInterpolator();
    private DesignTool mDesignTool;
    DevModeDraw mDevModeDraw;
    /* access modifiers changed from: private */
    public int mEndState = -1;
    int mEndWrapHeight;
    int mEndWrapWidth;
    HashMap<View, MotionController> mFrameArrayList = new HashMap<>();
    private int mFrames = 0;
    int mHeightMeasureMode;
    boolean mInTransition = false;
    boolean mIndirectTransition = false;
    private boolean mInteractionEnabled = true;
    Interpolator mInterpolator;
    boolean mIsAnimating = false;
    private boolean mKeepAnimating = false;
    private KeyCache mKeyCache = new KeyCache();
    private long mLastDrawTime = -1;
    private float mLastFps = 0.0f;
    /* access modifiers changed from: private */
    public int mLastHeightMeasureSpec = 0;
    int mLastLayoutHeight;
    int mLastLayoutWidth;
    float mLastVelocity = 0.0f;
    /* access modifiers changed from: private */
    public int mLastWidthMeasureSpec = 0;
    private float mListenerPosition = 0.0f;
    private int mListenerState = 0;
    protected boolean mMeasureDuringTransition = false;
    Model mModel = new Model();
    private boolean mNeedsFireTransitionCompleted = false;
    int mOldHeight;
    int mOldWidth;
    private ArrayList<MotionHelper> mOnHideHelpers = null;
    private ArrayList<MotionHelper> mOnShowHelpers = null;
    float mPostInterpolationPosition;
    private View mRegionView = null;
    MotionScene mScene;
    View mScrollTarget;
    float mScrollTargetDT;
    float mScrollTargetDX;
    float mScrollTargetDY;
    long mScrollTargetTime;
    int mStartWrapHeight;
    int mStartWrapWidth;
    private StopLogic mStopLogic = new StopLogic();
    private boolean mTemporalInterpolator = false;
    ArrayList<Integer> mTransitionCompleted = new ArrayList<>();
    private float mTransitionDuration = 1.0f;
    float mTransitionGoalPosition = 0.0f;
    private boolean mTransitionInstantly;
    float mTransitionLastPosition = 0.0f;
    private long mTransitionLastTime;
    private TransitionListener mTransitionListener;
    private ArrayList<TransitionListener> mTransitionListeners = null;
    float mTransitionPosition = 0.0f;
    boolean mUndergoingMotion = false;
    int mWidthMeasureMode;

    protected interface MotionTracker {
        void addMovement(MotionEvent motionEvent);

        void clear();

        void computeCurrentVelocity(int i);

        void computeCurrentVelocity(int i, float f);

        float getXVelocity();

        float getXVelocity(int i);

        float getYVelocity();

        float getYVelocity(int i);

        void recycle();
    }

    public interface TransitionListener {
        void onTransitionChange(MotionLayout motionLayout, int i, int i2, float f);

        void onTransitionCompleted(MotionLayout motionLayout, int i);

        void onTransitionStarted(MotionLayout motionLayout, int i, int i2);

        void onTransitionTrigger(MotionLayout motionLayout, int i, boolean z, float f);
    }

    private static boolean willJump(float f, float f2, float f3) {
        if (f > 0.0f) {
            float f4 = f / f3;
            return f2 + ((f * f4) - (((f3 * f4) * f4) / 2.0f)) > 1.0f;
        }
        float f5 = (-f) / f3;
        return f2 + ((f * f5) + (((f3 * f5) * f5) / 2.0f)) < 0.0f;
    }

    public boolean onNestedFling(View view, float f, float f2, boolean z) {
        return false;
    }

    public boolean onNestedPreFling(View view, float f, float f2) {
        return false;
    }

    public void onNestedScroll(View view, int i, int i2, int i3, int i4, int i5) {
    }

    public void onNestedScrollAccepted(View view, View view2, int i, int i2) {
    }

    public MotionLayout(Context context) {
        super(context);
        init((AttributeSet) null);
    }

    public MotionLayout(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        init(attributeSet);
    }

    public MotionLayout(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        init(attributeSet);
    }

    /* access modifiers changed from: protected */
    public long getNanoTime() {
        return System.nanoTime();
    }

    /* access modifiers changed from: protected */
    public MotionTracker obtainVelocityTracker() {
        return MyTracker.obtain();
    }

    public void enableTransition(int i, boolean z) {
        MotionScene.Transition transition = getTransition(i);
        if (z) {
            transition.setEnable(true);
            return;
        }
        MotionScene motionScene = this.mScene;
        if (transition == motionScene.mCurrentTransition) {
            Iterator<MotionScene.Transition> it = motionScene.getTransitionsWithState(this.mCurrentState).iterator();
            while (true) {
                if (!it.hasNext()) {
                    break;
                }
                MotionScene.Transition next = it.next();
                if (next.isEnabled()) {
                    this.mScene.mCurrentTransition = next;
                    break;
                }
            }
        }
        transition.setEnable(false);
    }

    private static class MyTracker implements MotionTracker {
        private static MyTracker me = new MyTracker();
        VelocityTracker tracker;

        private MyTracker() {
        }

        public static MyTracker obtain() {
            me.tracker = VelocityTracker.obtain();
            return me;
        }

        public void recycle() {
            this.tracker.recycle();
            this.tracker = null;
        }

        public void clear() {
            this.tracker.clear();
        }

        public void addMovement(MotionEvent motionEvent) {
            VelocityTracker velocityTracker = this.tracker;
            if (velocityTracker != null) {
                velocityTracker.addMovement(motionEvent);
            }
        }

        public void computeCurrentVelocity(int i) {
            this.tracker.computeCurrentVelocity(i);
        }

        public void computeCurrentVelocity(int i, float f) {
            this.tracker.computeCurrentVelocity(i, f);
        }

        public float getXVelocity() {
            return this.tracker.getXVelocity();
        }

        public float getYVelocity() {
            return this.tracker.getYVelocity();
        }

        public float getXVelocity(int i) {
            return this.tracker.getXVelocity(i);
        }

        public float getYVelocity(int i) {
            return getYVelocity(i);
        }
    }

    public void setTransition(int i, int i2) {
        MotionScene motionScene = this.mScene;
        if (motionScene != null) {
            this.mBeginState = i;
            this.mEndState = i2;
            motionScene.setTransition(i, i2);
            this.mModel.initFrom(this.mLayoutWidget, this.mScene.getConstraintSet(i), this.mScene.getConstraintSet(i2));
            rebuildScene();
            this.mTransitionLastPosition = 0.0f;
            transitionToStart();
        }
    }

    public void setTransition(int i) {
        if (this.mScene != null) {
            MotionScene.Transition transition = getTransition(i);
            this.mBeginState = transition.getStartConstraintSetId();
            int endConstraintSetId = transition.getEndConstraintSetId();
            this.mEndState = endConstraintSetId;
            float f = Float.NaN;
            int i2 = this.mCurrentState;
            float f2 = 0.0f;
            if (i2 == this.mBeginState) {
                f = 0.0f;
            } else if (i2 == endConstraintSetId) {
                f = 1.0f;
            }
            this.mScene.setTransition(transition);
            this.mModel.initFrom(this.mLayoutWidget, this.mScene.getConstraintSet(this.mBeginState), this.mScene.getConstraintSet(this.mEndState));
            rebuildScene();
            if (!Float.isNaN(f)) {
                f2 = f;
            }
            this.mTransitionLastPosition = f2;
            if (Float.isNaN(f)) {
                Log.v(TAG, Debug.getLocation() + " transitionToStart ");
                transitionToStart();
                return;
            }
            setProgress(f);
        }
    }

    /* access modifiers changed from: protected */
    public void setTransition(MotionScene.Transition transition) {
        this.mScene.setTransition(transition);
        if (this.mCurrentState == this.mScene.getEndId()) {
            this.mTransitionLastPosition = 1.0f;
            this.mTransitionPosition = 1.0f;
            this.mTransitionGoalPosition = 1.0f;
        } else {
            this.mTransitionLastPosition = 0.0f;
            this.mTransitionPosition = 0.0f;
            this.mTransitionGoalPosition = 0.0f;
        }
        this.mTransitionLastTime = -1;
        int startId = this.mScene.getStartId();
        int endId = this.mScene.getEndId();
        if (startId != this.mBeginState || endId != this.mEndState) {
            this.mBeginState = startId;
            this.mEndState = endId;
            this.mScene.setTransition(startId, endId);
            this.mModel.initFrom(this.mLayoutWidget, this.mScene.getConstraintSet(this.mBeginState), this.mScene.getConstraintSet(this.mEndState));
            this.mModel.setMeasuredId(this.mBeginState, this.mEndState);
            this.mModel.reEvaluateState();
            rebuildScene();
            fireTransitionStarted(this, this.mBeginState, this.mEndState);
        }
    }

    public void loadLayoutDescription(int i) {
        if (i != 0) {
            try {
                this.mScene = new MotionScene(getContext(), this, i);
                if (isAttachedToWindow()) {
                    this.mScene.readFallback(this);
                    this.mModel.initFrom(this.mLayoutWidget, this.mScene.getConstraintSet(this.mBeginState), this.mScene.getConstraintSet(this.mEndState));
                    rebuildScene();
                    this.mScene.setRtl(isRtl());
                }
            } catch (Exception e) {
                throw new IllegalArgumentException("unable to parse MotionScene file", e);
            }
        } else {
            this.mScene = null;
        }
    }

    public void setState(int i, int i2, int i3) {
        this.mCurrentState = i;
        this.mBeginState = -1;
        this.mEndState = -1;
        ConstraintLayoutStates constraintLayoutStates = this.mConstraintLayoutSpec;
        if (constraintLayoutStates != null) {
            constraintLayoutStates.updateConstraints(i, (float) i2, (float) i3);
            return;
        }
        MotionScene motionScene = this.mScene;
        if (motionScene != null) {
            motionScene.getConstraintSet(i).applyTo(this);
        }
    }

    public void setInterpolatedProgress(float f) {
        Interpolator interpolator;
        MotionScene motionScene = this.mScene;
        if (motionScene == null || (interpolator = motionScene.getInterpolator()) == null) {
            setProgress(f);
        } else {
            setProgress(interpolator.getInterpolation(f));
        }
    }

    public void setProgress(float f, float f2) {
        setProgress(f);
        this.mLastVelocity = f2;
        animateTo(1.0f);
    }

    public void setProgress(float f) {
        if (f <= 0.0f) {
            this.mCurrentState = this.mBeginState;
        } else if (f >= 1.0f) {
            this.mCurrentState = this.mEndState;
        } else {
            this.mCurrentState = -1;
        }
        if (this.mScene != null) {
            this.mTransitionInstantly = true;
            this.mTransitionGoalPosition = f;
            this.mTransitionPosition = f;
            this.mTransitionLastTime = -1;
            this.mAnimationStartTime = -1;
            this.mInterpolator = null;
            this.mInTransition = true;
            invalidate();
        }
    }

    /* access modifiers changed from: private */
    public void setupMotionViews() {
        int childCount = getChildCount();
        this.mModel.build();
        boolean z = true;
        this.mInTransition = true;
        int width = getWidth();
        int height = getHeight();
        int gatPathMotionArc = this.mScene.gatPathMotionArc();
        int i = 0;
        if (gatPathMotionArc != -1) {
            for (int i2 = 0; i2 < childCount; i2++) {
                MotionController motionController = this.mFrameArrayList.get(getChildAt(i2));
                if (motionController != null) {
                    motionController.setPathMotionArc(gatPathMotionArc);
                }
            }
        }
        for (int i3 = 0; i3 < childCount; i3++) {
            MotionController motionController2 = this.mFrameArrayList.get(getChildAt(i3));
            if (motionController2 != null) {
                this.mScene.getKeyFrames(motionController2);
                motionController2.setup(width, height, this.mTransitionDuration, getNanoTime());
            }
        }
        float staggered = this.mScene.getStaggered();
        if (staggered != 0.0f) {
            boolean z2 = ((double) staggered) < 0.0d;
            float abs = Math.abs(staggered);
            float f = -3.4028235E38f;
            float f2 = Float.MAX_VALUE;
            float f3 = -3.4028235E38f;
            float f4 = Float.MAX_VALUE;
            int i4 = 0;
            while (true) {
                if (i4 >= childCount) {
                    z = false;
                    break;
                }
                MotionController motionController3 = this.mFrameArrayList.get(getChildAt(i4));
                if (!Float.isNaN(motionController3.mMotionStagger)) {
                    break;
                }
                float finalX = motionController3.getFinalX();
                float finalY = motionController3.getFinalY();
                float f5 = z2 ? finalY - finalX : finalY + finalX;
                f4 = Math.min(f4, f5);
                f3 = Math.max(f3, f5);
                i4++;
            }
            if (z) {
                for (int i5 = 0; i5 < childCount; i5++) {
                    MotionController motionController4 = this.mFrameArrayList.get(getChildAt(i5));
                    if (!Float.isNaN(motionController4.mMotionStagger)) {
                        f2 = Math.min(f2, motionController4.mMotionStagger);
                        f = Math.max(f, motionController4.mMotionStagger);
                    }
                }
                while (i < childCount) {
                    MotionController motionController5 = this.mFrameArrayList.get(getChildAt(i));
                    if (!Float.isNaN(motionController5.mMotionStagger)) {
                        motionController5.mStaggerScale = 1.0f / (1.0f - abs);
                        if (z2) {
                            motionController5.mStaggerOffset = abs - (((f - motionController5.mMotionStagger) / (f - f2)) * abs);
                        } else {
                            motionController5.mStaggerOffset = abs - (((motionController5.mMotionStagger - f2) * abs) / (f - f2));
                        }
                    }
                    i++;
                }
                return;
            }
            while (i < childCount) {
                MotionController motionController6 = this.mFrameArrayList.get(getChildAt(i));
                float finalX2 = motionController6.getFinalX();
                float finalY2 = motionController6.getFinalY();
                float f6 = z2 ? finalY2 - finalX2 : finalY2 + finalX2;
                motionController6.mStaggerScale = 1.0f / (1.0f - abs);
                motionController6.mStaggerOffset = abs - (((f6 - f4) * abs) / (f3 - f4));
                i++;
            }
        }
    }

    public void touchAnimateTo(int i, float f, float f2) {
        if (this.mScene != null && this.mTransitionLastPosition != f) {
            this.mTemporalInterpolator = true;
            this.mAnimationStartTime = getNanoTime();
            float duration = ((float) this.mScene.getDuration()) / 1000.0f;
            this.mTransitionDuration = duration;
            this.mTransitionGoalPosition = f;
            this.mInTransition = true;
            float f3 = 1.0f;
            if (i == 0 || i == 1 || i == 2) {
                if (i == 1) {
                    f = 0.0f;
                } else if (i == 2) {
                    f = 1.0f;
                }
                this.mStopLogic.config(this.mTransitionLastPosition, f, f2, duration, this.mScene.getMaxAcceleration(), this.mScene.getMaxVelocity());
                int i2 = this.mCurrentState;
                if (f != 0.0f) {
                    f3 = 0.0f;
                }
                setProgress(f3);
                this.mCurrentState = i2;
                this.mInterpolator = this.mStopLogic;
            } else if (i == 4) {
                this.mDecelerateLogic.config(f2, this.mTransitionLastPosition, this.mScene.getMaxAcceleration());
                this.mInterpolator = this.mDecelerateLogic;
            } else if (i == 5) {
                if (willJump(f2, this.mTransitionLastPosition, this.mScene.getMaxAcceleration())) {
                    this.mDecelerateLogic.config(f2, this.mTransitionLastPosition, this.mScene.getMaxAcceleration());
                    this.mInterpolator = this.mDecelerateLogic;
                } else {
                    this.mStopLogic.config(this.mTransitionLastPosition, f, f2, this.mTransitionDuration, this.mScene.getMaxAcceleration(), this.mScene.getMaxVelocity());
                    this.mLastVelocity = 0.0f;
                    int i3 = this.mCurrentState;
                    if (f != 0.0f) {
                        f3 = 0.0f;
                    }
                    setProgress(f3);
                    this.mCurrentState = i3;
                    this.mInterpolator = this.mStopLogic;
                }
            }
            this.mTransitionInstantly = false;
            this.mAnimationStartTime = getNanoTime();
            invalidate();
        }
    }

    class DecelerateInterpolator extends MotionInterpolator {
        float currentP = 0.0f;
        float initalV = 0.0f;
        float maxA;

        DecelerateInterpolator() {
        }

        public void config(float f, float f2, float f3) {
            this.initalV = f;
            this.currentP = f2;
            this.maxA = f3;
        }

        public float getInterpolation(float f) {
            float f2;
            float f3;
            float f4 = this.initalV;
            if (f4 > 0.0f) {
                float f5 = this.maxA;
                if (f4 / f5 < f) {
                    f = f4 / f5;
                }
                MotionLayout.this.mLastVelocity = f4 - (f5 * f);
                f2 = (f4 * f) - (((f5 * f) * f) / 2.0f);
                f3 = this.currentP;
            } else {
                float f6 = this.maxA;
                if ((-f4) / f6 < f) {
                    f = (-f4) / f6;
                }
                MotionLayout.this.mLastVelocity = (f6 * f) + f4;
                f2 = (f4 * f) + (((f6 * f) * f) / 2.0f);
                f3 = this.currentP;
            }
            return f2 + f3;
        }

        public float getVelocity() {
            return MotionLayout.this.mLastVelocity;
        }
    }

    /* access modifiers changed from: package-private */
    public void animateTo(float f) {
        MotionScene motionScene = this.mScene;
        if (motionScene != null) {
            float f2 = this.mTransitionLastPosition;
            float f3 = this.mTransitionPosition;
            if (f2 != f3 && this.mTransitionInstantly) {
                this.mTransitionLastPosition = f3;
            }
            float f4 = this.mTransitionLastPosition;
            if (f4 != f) {
                this.mTemporalInterpolator = false;
                this.mTransitionGoalPosition = f;
                this.mTransitionDuration = ((float) motionScene.getDuration()) / 1000.0f;
                setProgress(this.mTransitionGoalPosition);
                this.mInterpolator = this.mScene.getInterpolator();
                this.mTransitionInstantly = false;
                this.mAnimationStartTime = getNanoTime();
                this.mInTransition = true;
                this.mTransitionPosition = f4;
                this.mTransitionLastPosition = f4;
                invalidate();
            }
        }
    }

    private void computeCurrentPositions() {
        int childCount = getChildCount();
        for (int i = 0; i < childCount; i++) {
            View childAt = getChildAt(i);
            MotionController motionController = this.mFrameArrayList.get(childAt);
            if (motionController != null) {
                motionController.setStartCurrentState(childAt);
            }
        }
    }

    public void transitionToStart() {
        animateTo(0.0f);
    }

    public void transitionToEnd() {
        animateTo(1.0f);
    }

    public void transitionToState(int i) {
        transitionToState(i, -1, -1);
    }

    public void transitionToState(int i, int i2, int i3) {
        StateSet stateSet;
        int convertToConstraintSet;
        MotionScene motionScene = this.mScene;
        if (!(motionScene == null || (stateSet = motionScene.mStateSet) == null || (convertToConstraintSet = stateSet.convertToConstraintSet(this.mCurrentState, i, (float) i2, (float) i3)) == -1)) {
            i = convertToConstraintSet;
        }
        int i4 = this.mCurrentState;
        if (i4 != i) {
            if (this.mBeginState == i) {
                animateTo(0.0f);
            } else if (this.mEndState == i) {
                animateTo(1.0f);
            } else {
                this.mEndState = i;
                if (i4 != -1) {
                    setTransition(i4, i);
                    animateTo(1.0f);
                    this.mTransitionLastPosition = 0.0f;
                    transitionToEnd();
                    return;
                }
                this.mTemporalInterpolator = false;
                this.mTransitionGoalPosition = 1.0f;
                this.mTransitionPosition = 0.0f;
                this.mTransitionLastPosition = 0.0f;
                this.mTransitionLastTime = getNanoTime();
                this.mAnimationStartTime = getNanoTime();
                this.mTransitionInstantly = false;
                this.mInterpolator = null;
                this.mTransitionDuration = ((float) this.mScene.getDuration()) / 1000.0f;
                this.mBeginState = -1;
                this.mScene.setTransition(-1, this.mEndState);
                this.mScene.getStartId();
                int childCount = getChildCount();
                this.mFrameArrayList.clear();
                for (int i5 = 0; i5 < childCount; i5++) {
                    View childAt = getChildAt(i5);
                    this.mFrameArrayList.put(childAt, new MotionController(childAt));
                }
                this.mInTransition = true;
                this.mModel.initFrom(this.mLayoutWidget, (ConstraintSet) null, this.mScene.getConstraintSet(i));
                rebuildScene();
                this.mModel.build();
                computeCurrentPositions();
                int width = getWidth();
                int height = getHeight();
                for (int i6 = 0; i6 < childCount; i6++) {
                    MotionController motionController = this.mFrameArrayList.get(getChildAt(i6));
                    this.mScene.getKeyFrames(motionController);
                    motionController.setup(width, height, this.mTransitionDuration, getNanoTime());
                }
                float staggered = this.mScene.getStaggered();
                if (staggered != 0.0f) {
                    float f = Float.MAX_VALUE;
                    float f2 = -3.4028235E38f;
                    for (int i7 = 0; i7 < childCount; i7++) {
                        MotionController motionController2 = this.mFrameArrayList.get(getChildAt(i7));
                        float finalY = motionController2.getFinalY() + motionController2.getFinalX();
                        f = Math.min(f, finalY);
                        f2 = Math.max(f2, finalY);
                    }
                    for (int i8 = 0; i8 < childCount; i8++) {
                        MotionController motionController3 = this.mFrameArrayList.get(getChildAt(i8));
                        float finalX = motionController3.getFinalX();
                        float finalY2 = motionController3.getFinalY();
                        motionController3.mStaggerScale = 1.0f / (1.0f - staggered);
                        motionController3.mStaggerOffset = staggered - ((((finalX + finalY2) - f) * staggered) / (f2 - f));
                    }
                }
                this.mTransitionPosition = 0.0f;
                this.mTransitionLastPosition = 0.0f;
                this.mInTransition = true;
                invalidate();
            }
        }
    }

    public float getVelocity() {
        Interpolator interpolator = this.mInterpolator;
        if (interpolator == null) {
            return this.mLastVelocity;
        }
        if (interpolator instanceof MotionInterpolator) {
            return ((MotionInterpolator) interpolator).getVelocity();
        }
        return 0.0f;
    }

    public void getViewVelocity(View view, float f, float f2, float[] fArr, int i) {
        float f3;
        float f4 = this.mLastVelocity;
        float f5 = this.mTransitionLastPosition;
        if (this.mInterpolator != null) {
            float signum = Math.signum(this.mTransitionGoalPosition - f5);
            float interpolation = this.mInterpolator.getInterpolation(this.mTransitionLastPosition + 1.0E-5f);
            float interpolation2 = this.mInterpolator.getInterpolation(this.mTransitionLastPosition);
            f4 = (signum * ((interpolation - interpolation2) / 1.0E-5f)) / this.mTransitionDuration;
            f3 = interpolation2;
        } else {
            f3 = f5;
        }
        Interpolator interpolator = this.mInterpolator;
        if (interpolator instanceof MotionInterpolator) {
            f4 = ((MotionInterpolator) interpolator).getVelocity();
        }
        MotionController motionController = this.mFrameArrayList.get(view);
        if ((i & 1) == 0) {
            motionController.getPostLayoutDvDp(f3, view.getWidth(), view.getHeight(), f, f2, fArr);
        } else {
            motionController.getDpDt(f3, f, f2, fArr);
        }
        if (i < 2) {
            fArr[0] = fArr[0] * f4;
            fArr[1] = fArr[1] * f4;
        }
    }

    class Model {
        ConstraintSet mEnd = null;
        int mEndId;
        ConstraintWidgetContainer mLayoutEnd = new ConstraintWidgetContainer();
        ConstraintWidgetContainer mLayoutStart = new ConstraintWidgetContainer();
        ConstraintSet mStart = null;
        int mStartId;

        Model() {
        }

        /* access modifiers changed from: package-private */
        public void copy(ConstraintWidgetContainer constraintWidgetContainer, ConstraintWidgetContainer constraintWidgetContainer2) {
            ConstraintWidget constraintWidget;
            ArrayList<ConstraintWidget> children = constraintWidgetContainer.getChildren();
            HashMap hashMap = new HashMap();
            hashMap.put(constraintWidgetContainer, constraintWidgetContainer2);
            constraintWidgetContainer2.getChildren().clear();
            constraintWidgetContainer2.copy(constraintWidgetContainer, hashMap);
            Iterator<ConstraintWidget> it = children.iterator();
            while (it.hasNext()) {
                ConstraintWidget next = it.next();
                if (next instanceof Barrier) {
                    constraintWidget = new Barrier();
                } else if (next instanceof Guideline) {
                    constraintWidget = new Guideline();
                } else if (next instanceof Flow) {
                    constraintWidget = new Flow();
                } else if (next instanceof Helper) {
                    constraintWidget = new HelperWidget();
                } else {
                    constraintWidget = new ConstraintWidget();
                }
                constraintWidgetContainer2.add(constraintWidget);
                hashMap.put(next, constraintWidget);
            }
            Iterator<ConstraintWidget> it2 = children.iterator();
            while (it2.hasNext()) {
                ConstraintWidget next2 = it2.next();
                ((ConstraintWidget) hashMap.get(next2)).copy(next2, hashMap);
            }
        }

        /* access modifiers changed from: package-private */
        public void initFrom(ConstraintWidgetContainer constraintWidgetContainer, ConstraintSet constraintSet, ConstraintSet constraintSet2) {
            this.mStart = constraintSet;
            this.mEnd = constraintSet2;
            this.mLayoutStart.setMeasurer(MotionLayout.this.mLayoutWidget.getMeasurer());
            this.mLayoutEnd.setMeasurer(MotionLayout.this.mLayoutWidget.getMeasurer());
            this.mLayoutStart.removeAllChildren();
            this.mLayoutEnd.removeAllChildren();
            copy(MotionLayout.this.mLayoutWidget, this.mLayoutStart);
            copy(MotionLayout.this.mLayoutWidget, this.mLayoutEnd);
            if (constraintSet != null) {
                setupConstraintWidget(this.mLayoutStart, constraintSet);
            }
            setupConstraintWidget(this.mLayoutEnd, constraintSet2);
            this.mLayoutStart.setRtl(MotionLayout.this.isRtl());
            this.mLayoutStart.updateHierarchy();
            this.mLayoutEnd.setRtl(MotionLayout.this.isRtl());
            this.mLayoutEnd.updateHierarchy();
            ViewGroup.LayoutParams layoutParams = MotionLayout.this.getLayoutParams();
            if (layoutParams != null) {
                if (layoutParams.width == -2) {
                    ConstraintWidgetContainer constraintWidgetContainer2 = this.mLayoutStart;
                    ConstraintWidget.DimensionBehaviour dimensionBehaviour = ConstraintWidget.DimensionBehaviour.WRAP_CONTENT;
                    constraintWidgetContainer2.setHorizontalDimensionBehaviour(dimensionBehaviour);
                    this.mLayoutEnd.setHorizontalDimensionBehaviour(dimensionBehaviour);
                }
                if (layoutParams.height == -2) {
                    ConstraintWidgetContainer constraintWidgetContainer3 = this.mLayoutStart;
                    ConstraintWidget.DimensionBehaviour dimensionBehaviour2 = ConstraintWidget.DimensionBehaviour.WRAP_CONTENT;
                    constraintWidgetContainer3.setVerticalDimensionBehaviour(dimensionBehaviour2);
                    this.mLayoutEnd.setVerticalDimensionBehaviour(dimensionBehaviour2);
                }
            }
        }

        private void setupConstraintWidget(ConstraintWidgetContainer constraintWidgetContainer, ConstraintSet constraintSet) {
            SparseArray sparseArray = new SparseArray();
            Constraints.LayoutParams layoutParams = new Constraints.LayoutParams(-2, -2);
            sparseArray.clear();
            sparseArray.put(0, constraintWidgetContainer);
            sparseArray.put(MotionLayout.this.getId(), constraintWidgetContainer);
            Iterator<ConstraintWidget> it = constraintWidgetContainer.getChildren().iterator();
            while (it.hasNext()) {
                ConstraintWidget next = it.next();
                sparseArray.put(((View) next.getCompanionWidget()).getId(), next);
            }
            Iterator<ConstraintWidget> it2 = constraintWidgetContainer.getChildren().iterator();
            while (it2.hasNext()) {
                ConstraintWidget next2 = it2.next();
                View view = (View) next2.getCompanionWidget();
                constraintSet.applyToLayoutParams(view.getId(), layoutParams);
                next2.setWidth(constraintSet.getWidth(view.getId()));
                next2.setHeight(constraintSet.getHeight(view.getId()));
                if (view instanceof ConstraintHelper) {
                    constraintSet.applyToHelper((ConstraintHelper) view, next2, layoutParams, sparseArray);
                    if (view instanceof androidx.constraintlayout.widget.Barrier) {
                        ((androidx.constraintlayout.widget.Barrier) view).validateParams();
                    }
                }
                layoutParams.resolveLayoutDirection(MotionLayout.this.getLayoutDirection());
                MotionLayout.this.applyConstraintsFromLayoutParams(false, view, next2, layoutParams, sparseArray);
                if (constraintSet.getVisibilityMode(view.getId()) == 1) {
                    next2.setVisibility(view.getVisibility());
                } else {
                    next2.setVisibility(constraintSet.getVisibility(view.getId()));
                }
            }
            Iterator<ConstraintWidget> it3 = constraintWidgetContainer.getChildren().iterator();
            while (it3.hasNext()) {
                ConstraintWidget next3 = it3.next();
                if (next3 instanceof Helper) {
                    Helper helper = (Helper) next3;
                    helper.removeAllIds();
                    ((ConstraintHelper) next3.getCompanionWidget()).updatePreLayout(constraintWidgetContainer, helper, sparseArray);
                    if (helper instanceof VirtualLayout) {
                        ((VirtualLayout) helper).captureWidgets();
                    }
                }
            }
        }

        /* access modifiers changed from: package-private */
        public ConstraintWidget getWidget(ConstraintWidgetContainer constraintWidgetContainer, View view) {
            if (constraintWidgetContainer.getCompanionWidget() == view) {
                return constraintWidgetContainer;
            }
            ArrayList<ConstraintWidget> children = constraintWidgetContainer.getChildren();
            int size = children.size();
            for (int i = 0; i < size; i++) {
                ConstraintWidget constraintWidget = children.get(i);
                if (constraintWidget.getCompanionWidget() == view) {
                    return constraintWidget;
                }
            }
            return null;
        }

        private void debugLayoutParam(String str, ConstraintLayout.LayoutParams layoutParams) {
            StringBuilder sb = new StringBuilder();
            sb.append(" ");
            sb.append(layoutParams.startToStart != -1 ? "SS" : "__");
            String sb2 = sb.toString();
            StringBuilder sb3 = new StringBuilder();
            sb3.append(sb2);
            String str2 = "|__";
            sb3.append(layoutParams.startToEnd != -1 ? "|SE" : str2);
            String sb4 = sb3.toString();
            StringBuilder sb5 = new StringBuilder();
            sb5.append(sb4);
            sb5.append(layoutParams.endToStart != -1 ? "|ES" : str2);
            String sb6 = sb5.toString();
            StringBuilder sb7 = new StringBuilder();
            sb7.append(sb6);
            sb7.append(layoutParams.endToEnd != -1 ? "|EE" : str2);
            String sb8 = sb7.toString();
            StringBuilder sb9 = new StringBuilder();
            sb9.append(sb8);
            sb9.append(layoutParams.leftToLeft != -1 ? "|LL" : str2);
            String sb10 = sb9.toString();
            StringBuilder sb11 = new StringBuilder();
            sb11.append(sb10);
            sb11.append(layoutParams.leftToRight != -1 ? "|LR" : str2);
            String sb12 = sb11.toString();
            StringBuilder sb13 = new StringBuilder();
            sb13.append(sb12);
            sb13.append(layoutParams.rightToLeft != -1 ? "|RL" : str2);
            String sb14 = sb13.toString();
            StringBuilder sb15 = new StringBuilder();
            sb15.append(sb14);
            sb15.append(layoutParams.rightToRight != -1 ? "|RR" : str2);
            String sb16 = sb15.toString();
            StringBuilder sb17 = new StringBuilder();
            sb17.append(sb16);
            sb17.append(layoutParams.topToTop != -1 ? "|TT" : str2);
            String sb18 = sb17.toString();
            StringBuilder sb19 = new StringBuilder();
            sb19.append(sb18);
            sb19.append(layoutParams.topToBottom != -1 ? "|TB" : str2);
            String sb20 = sb19.toString();
            StringBuilder sb21 = new StringBuilder();
            sb21.append(sb20);
            sb21.append(layoutParams.bottomToTop != -1 ? "|BT" : str2);
            String sb22 = sb21.toString();
            StringBuilder sb23 = new StringBuilder();
            sb23.append(sb22);
            if (layoutParams.bottomToBottom != -1) {
                str2 = "|BB";
            }
            sb23.append(str2);
            String sb24 = sb23.toString();
            Log.v(MotionLayout.TAG, str + sb24);
        }

        private void debugWidget(String str, ConstraintWidget constraintWidget) {
            String str2;
            String str3;
            String str4;
            StringBuilder sb = new StringBuilder();
            sb.append(" ");
            String str5 = "B";
            String str6 = "__";
            if (constraintWidget.mTop.mTarget != null) {
                StringBuilder sb2 = new StringBuilder();
                sb2.append("T");
                sb2.append(constraintWidget.mTop.mTarget.mType == ConstraintAnchor.Type.TOP ? "T" : str5);
                str2 = sb2.toString();
            } else {
                str2 = str6;
            }
            sb.append(str2);
            String sb3 = sb.toString();
            StringBuilder sb4 = new StringBuilder();
            sb4.append(sb3);
            if (constraintWidget.mBottom.mTarget != null) {
                StringBuilder sb5 = new StringBuilder();
                sb5.append(str5);
                if (constraintWidget.mBottom.mTarget.mType == ConstraintAnchor.Type.TOP) {
                    str5 = "T";
                }
                sb5.append(str5);
                str3 = sb5.toString();
            } else {
                str3 = str6;
            }
            sb4.append(str3);
            String sb6 = sb4.toString();
            StringBuilder sb7 = new StringBuilder();
            sb7.append(sb6);
            String str7 = "R";
            if (constraintWidget.mLeft.mTarget != null) {
                StringBuilder sb8 = new StringBuilder();
                sb8.append("L");
                sb8.append(constraintWidget.mLeft.mTarget.mType == ConstraintAnchor.Type.LEFT ? "L" : str7);
                str4 = sb8.toString();
            } else {
                str4 = str6;
            }
            sb7.append(str4);
            String sb9 = sb7.toString();
            StringBuilder sb10 = new StringBuilder();
            sb10.append(sb9);
            if (constraintWidget.mRight.mTarget != null) {
                StringBuilder sb11 = new StringBuilder();
                sb11.append(str7);
                if (constraintWidget.mRight.mTarget.mType == ConstraintAnchor.Type.LEFT) {
                    str7 = "L";
                }
                sb11.append(str7);
                str6 = sb11.toString();
            }
            sb10.append(str6);
            String sb12 = sb10.toString();
            Log.v(MotionLayout.TAG, str + sb12 + " ---  " + constraintWidget);
        }

        private void debugLayout(String str, ConstraintWidgetContainer constraintWidgetContainer) {
            String str2 = str + " " + Debug.getName((View) constraintWidgetContainer.getCompanionWidget());
            Log.v(MotionLayout.TAG, str2 + "  ========= " + constraintWidgetContainer);
            int size = constraintWidgetContainer.getChildren().size();
            for (int i = 0; i < size; i++) {
                String str3 = str2 + "[" + i + "] ";
                ConstraintWidget constraintWidget = constraintWidgetContainer.getChildren().get(i);
                StringBuilder sb = new StringBuilder();
                sb.append("");
                String str4 = "_";
                sb.append(constraintWidget.mTop.mTarget != null ? "T" : str4);
                String sb2 = sb.toString();
                StringBuilder sb3 = new StringBuilder();
                sb3.append(sb2);
                sb3.append(constraintWidget.mBottom.mTarget != null ? "B" : str4);
                String sb4 = sb3.toString();
                StringBuilder sb5 = new StringBuilder();
                sb5.append(sb4);
                sb5.append(constraintWidget.mLeft.mTarget != null ? "L" : str4);
                String sb6 = sb5.toString();
                StringBuilder sb7 = new StringBuilder();
                sb7.append(sb6);
                if (constraintWidget.mRight.mTarget != null) {
                    str4 = "R";
                }
                sb7.append(str4);
                String sb8 = sb7.toString();
                View view = (View) constraintWidget.getCompanionWidget();
                String name = Debug.getName(view);
                if (view instanceof TextView) {
                    name = name + "(" + ((TextView) view).getText() + ")";
                }
                Log.v(MotionLayout.TAG, str3 + "  " + name + " " + constraintWidget + " " + sb8);
            }
            Log.v(MotionLayout.TAG, str2 + " done. ");
        }

        public void reEvaluateState() {
            measure(MotionLayout.this.mLastWidthMeasureSpec, MotionLayout.this.mLastHeightMeasureSpec);
            MotionLayout.this.setupMotionViews();
        }

        public void measure(int i, int i2) {
            int mode = View.MeasureSpec.getMode(i);
            int mode2 = View.MeasureSpec.getMode(i2);
            MotionLayout motionLayout = MotionLayout.this;
            motionLayout.mWidthMeasureMode = mode;
            motionLayout.mHeightMeasureMode = mode2;
            int optimizationLevel = motionLayout.getOptimizationLevel();
            MotionLayout motionLayout2 = MotionLayout.this;
            if (motionLayout2.mCurrentState == motionLayout2.getStartState()) {
                MotionLayout.this.resolveSystem(this.mLayoutEnd, optimizationLevel, i, i2);
                if (this.mStart != null) {
                    MotionLayout.this.resolveSystem(this.mLayoutStart, optimizationLevel, i, i2);
                }
            } else {
                if (this.mStart != null) {
                    MotionLayout.this.resolveSystem(this.mLayoutStart, optimizationLevel, i, i2);
                }
                MotionLayout.this.resolveSystem(this.mLayoutEnd, optimizationLevel, i, i2);
            }
            MotionLayout.this.mStartWrapWidth = this.mLayoutStart.getWidth();
            MotionLayout.this.mStartWrapHeight = this.mLayoutStart.getHeight();
            MotionLayout.this.mEndWrapWidth = this.mLayoutEnd.getWidth();
            MotionLayout.this.mEndWrapHeight = this.mLayoutEnd.getHeight();
            MotionLayout motionLayout3 = MotionLayout.this;
            int i3 = motionLayout3.mStartWrapWidth;
            int i4 = motionLayout3.mEndWrapWidth;
            boolean z = false;
            motionLayout3.mMeasureDuringTransition = (i3 == i4 && motionLayout3.mStartWrapHeight == motionLayout3.mEndWrapHeight) ? false : true;
            int i5 = motionLayout3.mStartWrapHeight;
            if (motionLayout3.mWidthMeasureMode == Integer.MIN_VALUE) {
                i3 = (int) (((float) i3) + (motionLayout3.mPostInterpolationPosition * ((float) (i4 - i3))));
            }
            if (motionLayout3.mHeightMeasureMode == Integer.MIN_VALUE) {
                i5 = (int) (((float) i5) + (motionLayout3.mPostInterpolationPosition * ((float) (motionLayout3.mEndWrapHeight - i5))));
            }
            boolean z2 = this.mLayoutStart.isWidthMeasuredTooSmall() || this.mLayoutEnd.isWidthMeasuredTooSmall();
            if (this.mLayoutStart.isHeightMeasuredTooSmall() || this.mLayoutEnd.isHeightMeasuredTooSmall()) {
                z = true;
            }
            MotionLayout.this.resolveMeasuredDimension(i, i2, i3, i5, z2, z);
        }

        public void build() {
            int childCount = MotionLayout.this.getChildCount();
            MotionLayout.this.mFrameArrayList.clear();
            for (int i = 0; i < childCount; i++) {
                View childAt = MotionLayout.this.getChildAt(i);
                MotionLayout.this.mFrameArrayList.put(childAt, new MotionController(childAt));
            }
            for (int i2 = 0; i2 < childCount; i2++) {
                View childAt2 = MotionLayout.this.getChildAt(i2);
                MotionController motionController = MotionLayout.this.mFrameArrayList.get(childAt2);
                if (motionController != null) {
                    if (this.mStart != null) {
                        ConstraintWidget widget = getWidget(this.mLayoutStart, childAt2);
                        if (widget != null) {
                            motionController.setStartState(widget, this.mStart);
                        } else {
                            Log.e(MotionLayout.TAG, Debug.getLocation() + "no widget for  " + Debug.getName(childAt2) + " (" + childAt2.getClass().getName() + ")");
                        }
                    }
                    if (this.mEnd != null) {
                        ConstraintWidget widget2 = getWidget(this.mLayoutEnd, childAt2);
                        if (widget2 != null) {
                            motionController.setEndState(widget2, this.mEnd);
                        } else {
                            Log.e(MotionLayout.TAG, Debug.getLocation() + "no widget for  " + Debug.getName(childAt2) + " (" + childAt2.getClass().getName() + ")");
                        }
                    }
                }
            }
        }

        public void setMeasuredId(int i, int i2) {
            this.mStartId = i;
            this.mEndId = i2;
        }

        public boolean isNotConfiguredWith(int i, int i2) {
            return (i == this.mStartId && i2 == this.mEndId) ? false : true;
        }
    }

    public void requestLayout() {
        MotionScene motionScene;
        MotionScene.Transition transition;
        if (this.mMeasureDuringTransition || this.mCurrentState != -1 || (motionScene = this.mScene) == null || (transition = motionScene.mCurrentTransition) == null || transition.getLayoutDuringTransition() != 0) {
            super.requestLayout();
        }
    }

    /* access modifiers changed from: protected */
    public void onMeasure(int i, int i2) {
        if (this.mScene == null) {
            super.onMeasure(i, i2);
            return;
        }
        boolean z = true;
        boolean z2 = (this.mLastWidthMeasureSpec == i && this.mLastHeightMeasureSpec == i2) ? false : true;
        if (this.mNeedsFireTransitionCompleted) {
            this.mNeedsFireTransitionCompleted = false;
            onNewStateAttachHandlers();
            if (this.mIsAnimating) {
                processTransitionCompleted();
            }
            z2 = true;
        }
        if (!this.mDirtyHierarchy) {
            z = z2;
        }
        this.mLastWidthMeasureSpec = i;
        this.mLastHeightMeasureSpec = i2;
        int startId = this.mScene.getStartId();
        int endId = this.mScene.getEndId();
        if ((z || this.mModel.isNotConfiguredWith(startId, endId)) && this.mBeginState != -1) {
            super.onMeasure(i, i2);
            this.mModel.initFrom(this.mLayoutWidget, this.mScene.getConstraintSet(startId), this.mScene.getConstraintSet(endId));
            this.mModel.reEvaluateState();
            this.mModel.setMeasuredId(startId, endId);
        } else {
            int paddingTop = getPaddingTop() + getPaddingBottom();
            int width = this.mLayoutWidget.getWidth() + getPaddingLeft() + getPaddingRight();
            int height = this.mLayoutWidget.getHeight() + paddingTop;
            if (this.mWidthMeasureMode == Integer.MIN_VALUE) {
                int i3 = this.mStartWrapWidth;
                width = (int) (((float) i3) + (this.mPostInterpolationPosition * ((float) (this.mEndWrapWidth - i3))));
                requestLayout();
            }
            if (this.mHeightMeasureMode == Integer.MIN_VALUE) {
                int i4 = this.mStartWrapHeight;
                height = (int) (((float) i4) + (this.mPostInterpolationPosition * ((float) (this.mEndWrapHeight - i4))));
                requestLayout();
            }
            setMeasuredDimension(width, height);
        }
        evaluateLayout();
    }

    /* JADX WARNING: Code restructure failed: missing block: B:2:0x0006, code lost:
        r1 = r1.mCurrentTransition;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean onStartNestedScroll(android.view.View r1, android.view.View r2, int r3, int r4) {
        /*
            r0 = this;
            r0.mScrollTarget = r2
            androidx.constraintlayout.motion.widget.MotionScene r1 = r0.mScene
            if (r1 == 0) goto L_0x0023
            androidx.constraintlayout.motion.widget.MotionScene$Transition r1 = r1.mCurrentTransition
            if (r1 == 0) goto L_0x0023
            androidx.constraintlayout.motion.widget.TouchResponse r1 = r1.getTouchResponse()
            if (r1 == 0) goto L_0x0023
            androidx.constraintlayout.motion.widget.MotionScene r0 = r0.mScene
            androidx.constraintlayout.motion.widget.MotionScene$Transition r0 = r0.mCurrentTransition
            androidx.constraintlayout.motion.widget.TouchResponse r0 = r0.getTouchResponse()
            int r0 = r0.getFlags()
            r0 = r0 & 2
            if (r0 == 0) goto L_0x0021
            goto L_0x0023
        L_0x0021:
            r0 = 1
            return r0
        L_0x0023:
            r0 = 0
            return r0
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.motion.widget.MotionLayout.onStartNestedScroll(android.view.View, android.view.View, int, int):boolean");
    }

    public void onStopNestedScroll(View view, int i) {
        this.mScrollTarget = null;
        MotionScene motionScene = this.mScene;
        if (motionScene != null) {
            float f = this.mScrollTargetDX;
            float f2 = this.mScrollTargetDT;
            motionScene.processScrollUp(f / f2, this.mScrollTargetDY / f2);
        }
    }

    public void onNestedScroll(View view, int i, int i2, int i3, int i4, int i5, int[] iArr) {
        if (!(!this.mUndergoingMotion && i == 0 && i2 == 0)) {
            iArr[0] = iArr[0] + i3;
            iArr[1] = iArr[1] + i4;
        }
        this.mUndergoingMotion = false;
    }

    public void onNestedPreScroll(View view, int i, int i2, int[] iArr, int i3) {
        MotionScene.Transition transition;
        TouchResponse touchResponse;
        int touchRegionId;
        MotionScene motionScene = this.mScene;
        if (motionScene != null && (transition = motionScene.mCurrentTransition) != null && transition.isEnabled()) {
            MotionScene.Transition transition2 = this.mScene.mCurrentTransition;
            if (transition2 == null || !transition2.isEnabled() || (touchResponse = transition2.getTouchResponse()) == null || (touchRegionId = touchResponse.getTouchRegionId()) == -1 || this.mScrollTarget.getId() == touchRegionId) {
                MotionScene motionScene2 = this.mScene;
                if (motionScene2 != null && motionScene2.getMoveWhenScrollAtTop()) {
                    float f = this.mTransitionPosition;
                    if ((f == 1.0f || f == 0.0f) && view.canScrollVertically(-1)) {
                        return;
                    }
                }
                if (!(transition2.getTouchResponse() == null || (this.mScene.mCurrentTransition.getTouchResponse().getFlags() & 1) == 0)) {
                    float progressDirection = this.mScene.getProgressDirection((float) i, (float) i2);
                    float f2 = this.mTransitionLastPosition;
                    if ((f2 <= 0.0f && progressDirection < 0.0f) || (f2 >= 1.0f && progressDirection > 0.0f)) {
                        this.mScrollTarget.setNestedScrollingEnabled(false);
                        this.mScrollTarget.post(new Runnable() {
                            public void run() {
                                MotionLayout.this.mScrollTarget.setNestedScrollingEnabled(true);
                            }
                        });
                        return;
                    }
                }
                float f3 = this.mTransitionPosition;
                long nanoTime = getNanoTime();
                float f4 = (float) i;
                this.mScrollTargetDX = f4;
                float f5 = (float) i2;
                this.mScrollTargetDY = f5;
                this.mScrollTargetDT = (float) (((double) (nanoTime - this.mScrollTargetTime)) * 1.0E-9d);
                this.mScrollTargetTime = nanoTime;
                this.mScene.processScrollMove(f4, f5);
                if (f3 != this.mTransitionPosition) {
                    iArr[0] = i;
                    iArr[1] = i2;
                }
                evaluate(false);
                if (iArr[0] != 0 || iArr[1] != 0) {
                    this.mUndergoingMotion = true;
                }
            }
        }
    }

    private class DevModeDraw {
        private static final int DEBUG_PATH_TICKS_PER_MS = 16;
        final int DIAMOND_SIZE = 10;
        final int GRAPH_COLOR = -13391360;
        final int KEYFRAME_COLOR = -2067046;
        final int RED_COLOR = -21965;
        final int SHADOW_COLOR = 1996488704;
        Rect mBounds = new Rect();
        DashPathEffect mDashPathEffect;
        Paint mFillPaint;
        int mKeyFrameCount;
        float[] mKeyFramePoints;
        Paint mPaint;
        Paint mPaintGraph;
        Paint mPaintKeyframes;
        Path mPath;
        int[] mPathMode;
        float[] mPoints;
        boolean mPresentationMode = false;
        private float[] mRectangle;
        int mShadowTranslate = 1;
        Paint mTextPaint;

        public DevModeDraw() {
            Paint paint = new Paint();
            this.mPaint = paint;
            paint.setAntiAlias(true);
            this.mPaint.setColor(-21965);
            this.mPaint.setStrokeWidth(2.0f);
            this.mPaint.setStyle(Paint.Style.STROKE);
            Paint paint2 = new Paint();
            this.mPaintKeyframes = paint2;
            paint2.setAntiAlias(true);
            this.mPaintKeyframes.setColor(-2067046);
            this.mPaintKeyframes.setStrokeWidth(2.0f);
            this.mPaintKeyframes.setStyle(Paint.Style.STROKE);
            Paint paint3 = new Paint();
            this.mPaintGraph = paint3;
            paint3.setAntiAlias(true);
            this.mPaintGraph.setColor(-13391360);
            this.mPaintGraph.setStrokeWidth(2.0f);
            this.mPaintGraph.setStyle(Paint.Style.STROKE);
            Paint paint4 = new Paint();
            this.mTextPaint = paint4;
            paint4.setAntiAlias(true);
            this.mTextPaint.setColor(-13391360);
            this.mTextPaint.setTextSize(MotionLayout.this.getContext().getResources().getDisplayMetrics().density * 12.0f);
            this.mRectangle = new float[8];
            Paint paint5 = new Paint();
            this.mFillPaint = paint5;
            paint5.setAntiAlias(true);
            DashPathEffect dashPathEffect = new DashPathEffect(new float[]{4.0f, 8.0f}, 0.0f);
            this.mDashPathEffect = dashPathEffect;
            this.mPaintGraph.setPathEffect(dashPathEffect);
            this.mKeyFramePoints = new float[100];
            this.mPathMode = new int[50];
            if (this.mPresentationMode) {
                this.mPaint.setStrokeWidth(8.0f);
                this.mFillPaint.setStrokeWidth(8.0f);
                this.mPaintKeyframes.setStrokeWidth(8.0f);
                this.mShadowTranslate = 4;
            }
        }

        public void draw(Canvas canvas, HashMap<View, MotionController> hashMap, int i, int i2) {
            if (hashMap != null && hashMap.size() != 0) {
                canvas.save();
                if (!MotionLayout.this.isInEditMode() && (i2 & 1) == 2) {
                    String str = MotionLayout.this.getContext().getResources().getResourceName(MotionLayout.this.mEndState) + ":" + MotionLayout.this.getProgress();
                    canvas.drawText(str, 10.0f, (float) (MotionLayout.this.getHeight() - 30), this.mTextPaint);
                    canvas.drawText(str, 11.0f, (float) (MotionLayout.this.getHeight() - 29), this.mPaint);
                }
                for (MotionController next : hashMap.values()) {
                    int drawPath = next.getDrawPath();
                    if (i2 > 0 && drawPath == 0) {
                        drawPath = 1;
                    }
                    if (drawPath != 0) {
                        this.mKeyFrameCount = next.buildKeyFrames(this.mKeyFramePoints, this.mPathMode);
                        if (drawPath >= 1) {
                            int i3 = i / 16;
                            float[] fArr = this.mPoints;
                            if (fArr == null || fArr.length != i3 * 2) {
                                this.mPoints = new float[(i3 * 2)];
                                this.mPath = new Path();
                            }
                            int i4 = this.mShadowTranslate;
                            canvas.translate((float) i4, (float) i4);
                            this.mPaint.setColor(1996488704);
                            this.mFillPaint.setColor(1996488704);
                            this.mPaintKeyframes.setColor(1996488704);
                            this.mPaintGraph.setColor(1996488704);
                            next.buildPath(this.mPoints, i3);
                            drawAll(canvas, drawPath, this.mKeyFrameCount, next);
                            this.mPaint.setColor(-21965);
                            this.mPaintKeyframes.setColor(-2067046);
                            this.mFillPaint.setColor(-2067046);
                            this.mPaintGraph.setColor(-13391360);
                            int i5 = this.mShadowTranslate;
                            canvas.translate((float) (-i5), (float) (-i5));
                            drawAll(canvas, drawPath, this.mKeyFrameCount, next);
                            if (drawPath == 5) {
                                drawRectangle(canvas, next);
                            }
                        }
                    }
                }
                canvas.restore();
            }
        }

        public void drawAll(Canvas canvas, int i, int i2, MotionController motionController) {
            if (i == 4) {
                drawPathAsConfigured(canvas);
            }
            if (i == 2) {
                drawPathRelative(canvas);
            }
            if (i == 3) {
                drawPathCartesian(canvas);
            }
            drawBasicPath(canvas);
            drawTicks(canvas, i, i2, motionController);
        }

        private void drawBasicPath(Canvas canvas) {
            canvas.drawLines(this.mPoints, this.mPaint);
        }

        private void drawTicks(Canvas canvas, int i, int i2, MotionController motionController) {
            int i3;
            int i4;
            float f;
            float f2;
            int i5;
            Canvas canvas2 = canvas;
            int i6 = i;
            MotionController motionController2 = motionController;
            View view = motionController2.mView;
            if (view != null) {
                i4 = view.getWidth();
                i3 = motionController2.mView.getHeight();
            } else {
                i4 = 0;
                i3 = 0;
            }
            for (int i7 = 1; i7 < i2 - 1; i7++) {
                if (i6 != 4 || this.mPathMode[i7 - 1] != 0) {
                    float[] fArr = this.mKeyFramePoints;
                    int i8 = i7 * 2;
                    float f3 = fArr[i8];
                    float f4 = fArr[i8 + 1];
                    this.mPath.reset();
                    this.mPath.moveTo(f3, f4 + 10.0f);
                    this.mPath.lineTo(f3 + 10.0f, f4);
                    this.mPath.lineTo(f3, f4 - 10.0f);
                    this.mPath.lineTo(f3 - 10.0f, f4);
                    this.mPath.close();
                    int i9 = i7 - 1;
                    motionController2.getKeyFrame(i9);
                    if (i6 == 4) {
                        int i10 = this.mPathMode[i9];
                        if (i10 == 1) {
                            drawPathRelativeTicks(canvas2, f3 - 0.0f, f4 - 0.0f);
                        } else if (i10 == 2) {
                            drawPathCartesianTicks(canvas2, f3 - 0.0f, f4 - 0.0f);
                        } else if (i10 == 3) {
                            i5 = 3;
                            f2 = f4;
                            f = f3;
                            drawPathScreenTicks(canvas, f3 - 0.0f, f4 - 0.0f, i4, i3);
                            canvas2.drawPath(this.mPath, this.mFillPaint);
                        }
                        i5 = 3;
                        f2 = f4;
                        f = f3;
                        canvas2.drawPath(this.mPath, this.mFillPaint);
                    } else {
                        i5 = 3;
                        f2 = f4;
                        f = f3;
                    }
                    if (i6 == 2) {
                        drawPathRelativeTicks(canvas2, f - 0.0f, f2 - 0.0f);
                    }
                    if (i6 == i5) {
                        drawPathCartesianTicks(canvas2, f - 0.0f, f2 - 0.0f);
                    }
                    if (i6 == 6) {
                        drawPathScreenTicks(canvas, f - 0.0f, f2 - 0.0f, i4, i3);
                    }
                    canvas2.drawPath(this.mPath, this.mFillPaint);
                }
            }
            float[] fArr2 = this.mPoints;
            if (fArr2.length > 1) {
                canvas2.drawCircle(fArr2[0], fArr2[1], 8.0f, this.mPaintKeyframes);
                float[] fArr3 = this.mPoints;
                canvas2.drawCircle(fArr3[fArr3.length - 2], fArr3[fArr3.length - 1], 8.0f, this.mPaintKeyframes);
            }
        }

        private void drawTranslation(Canvas canvas, float f, float f2, float f3, float f4) {
            canvas.drawRect(f, f2, f3, f4, this.mPaintGraph);
            canvas.drawLine(f, f2, f3, f4, this.mPaintGraph);
        }

        private void drawPathRelative(Canvas canvas) {
            float[] fArr = this.mPoints;
            canvas.drawLine(fArr[0], fArr[1], fArr[fArr.length - 2], fArr[fArr.length - 1], this.mPaintGraph);
        }

        private void drawPathAsConfigured(Canvas canvas) {
            boolean z = false;
            boolean z2 = false;
            for (int i = 0; i < this.mKeyFrameCount; i++) {
                int i2 = this.mPathMode[i];
                if (i2 == 1) {
                    z = true;
                }
                if (i2 == 2) {
                    z2 = true;
                }
            }
            if (z) {
                drawPathRelative(canvas);
            }
            if (z2) {
                drawPathCartesian(canvas);
            }
        }

        private void drawPathRelativeTicks(Canvas canvas, float f, float f2) {
            float[] fArr = this.mPoints;
            float f3 = fArr[0];
            float f4 = fArr[1];
            float f5 = fArr[fArr.length - 2];
            float f6 = fArr[fArr.length - 1];
            float hypot = (float) Math.hypot((double) (f3 - f5), (double) (f4 - f6));
            float f7 = f5 - f3;
            float f8 = f6 - f4;
            float f9 = (((f - f3) * f7) + ((f2 - f4) * f8)) / (hypot * hypot);
            float f10 = f3 + (f7 * f9);
            float f11 = f4 + (f9 * f8);
            Path path = new Path();
            path.moveTo(f, f2);
            path.lineTo(f10, f11);
            float hypot2 = (float) Math.hypot((double) (f10 - f), (double) (f11 - f2));
            String str = "" + (((float) ((int) ((hypot2 * 100.0f) / hypot))) / 100.0f);
            getTextBounds(str, this.mTextPaint);
            canvas.drawTextOnPath(str, path, (hypot2 / 2.0f) - ((float) (this.mBounds.width() / 2)), -20.0f, this.mTextPaint);
            canvas.drawLine(f, f2, f10, f11, this.mPaintGraph);
        }

        /* access modifiers changed from: package-private */
        public void getTextBounds(String str, Paint paint) {
            paint.getTextBounds(str, 0, str.length(), this.mBounds);
        }

        private void drawPathCartesian(Canvas canvas) {
            float[] fArr = this.mPoints;
            float f = fArr[0];
            float f2 = fArr[1];
            float f3 = fArr[fArr.length - 2];
            float f4 = fArr[fArr.length - 1];
            canvas.drawLine(Math.min(f, f3), Math.max(f2, f4), Math.max(f, f3), Math.max(f2, f4), this.mPaintGraph);
            canvas.drawLine(Math.min(f, f3), Math.min(f2, f4), Math.min(f, f3), Math.max(f2, f4), this.mPaintGraph);
        }

        private void drawPathCartesianTicks(Canvas canvas, float f, float f2) {
            Canvas canvas2 = canvas;
            float[] fArr = this.mPoints;
            float f3 = fArr[0];
            float f4 = fArr[1];
            float f5 = fArr[fArr.length - 2];
            float f6 = fArr[fArr.length - 1];
            float min = Math.min(f3, f5);
            float max = Math.max(f4, f6);
            float min2 = f - Math.min(f3, f5);
            float max2 = Math.max(f4, f6) - f2;
            String str = "" + (((float) ((int) (((double) ((min2 * 100.0f) / Math.abs(f5 - f3))) + 0.5d))) / 100.0f);
            getTextBounds(str, this.mTextPaint);
            canvas2.drawText(str, ((min2 / 2.0f) - ((float) (this.mBounds.width() / 2))) + min, f2 - 20.0f, this.mTextPaint);
            canvas.drawLine(f, f2, Math.min(f3, f5), f2, this.mPaintGraph);
            String str2 = "" + (((float) ((int) (((double) ((max2 * 100.0f) / Math.abs(f6 - f4))) + 0.5d))) / 100.0f);
            getTextBounds(str2, this.mTextPaint);
            canvas2.drawText(str2, f + 5.0f, max - ((max2 / 2.0f) - ((float) (this.mBounds.height() / 2))), this.mTextPaint);
            canvas.drawLine(f, f2, f, Math.max(f4, f6), this.mPaintGraph);
        }

        private void drawPathScreenTicks(Canvas canvas, float f, float f2, int i, int i2) {
            Canvas canvas2 = canvas;
            String str = "" + (((float) ((int) (((double) (((f - ((float) (i / 2))) * 100.0f) / ((float) (MotionLayout.this.getWidth() - i)))) + 0.5d))) / 100.0f);
            getTextBounds(str, this.mTextPaint);
            canvas2.drawText(str, ((f / 2.0f) - ((float) (this.mBounds.width() / 2))) + 0.0f, f2 - 20.0f, this.mTextPaint);
            canvas.drawLine(f, f2, Math.min(0.0f, 1.0f), f2, this.mPaintGraph);
            String str2 = "" + (((float) ((int) (((double) (((f2 - ((float) (i2 / 2))) * 100.0f) / ((float) (MotionLayout.this.getHeight() - i2)))) + 0.5d))) / 100.0f);
            getTextBounds(str2, this.mTextPaint);
            canvas2.drawText(str2, f + 5.0f, 0.0f - ((f2 / 2.0f) - ((float) (this.mBounds.height() / 2))), this.mTextPaint);
            canvas.drawLine(f, f2, f, Math.max(0.0f, 1.0f), this.mPaintGraph);
        }

        private void drawRectangle(Canvas canvas, MotionController motionController) {
            this.mPath.reset();
            for (int i = 0; i <= 50; i++) {
                motionController.buildRect(((float) i) / ((float) 50), this.mRectangle, 0);
                Path path = this.mPath;
                float[] fArr = this.mRectangle;
                path.moveTo(fArr[0], fArr[1]);
                Path path2 = this.mPath;
                float[] fArr2 = this.mRectangle;
                path2.lineTo(fArr2[2], fArr2[3]);
                Path path3 = this.mPath;
                float[] fArr3 = this.mRectangle;
                path3.lineTo(fArr3[4], fArr3[5]);
                Path path4 = this.mPath;
                float[] fArr4 = this.mRectangle;
                path4.lineTo(fArr4[6], fArr4[7]);
                this.mPath.close();
            }
            this.mPaint.setColor(1140850688);
            canvas.translate(2.0f, 2.0f);
            canvas.drawPath(this.mPath, this.mPaint);
            canvas.translate(-2.0f, -2.0f);
            this.mPaint.setColor(SupportMenu.CATEGORY_MASK);
            canvas.drawPath(this.mPath, this.mPaint);
        }
    }

    private void debugPos() {
        for (int i = 0; i < getChildCount(); i++) {
            View childAt = getChildAt(i);
            Log.v(TAG, " " + Debug.getLocation() + " " + Debug.getName(this) + " " + Debug.getName(getContext(), this.mCurrentState) + " " + Debug.getName(childAt) + childAt.getLeft() + " " + childAt.getTop());
        }
    }

    /* access modifiers changed from: protected */
    public void dispatchDraw(Canvas canvas) {
        String str;
        evaluate(false);
        super.dispatchDraw(canvas);
        if (this.mScene != null) {
            if ((this.mDebugPath & 1) == 1 && !isInEditMode()) {
                this.mFrames++;
                long nanoTime = getNanoTime();
                long j = this.mLastDrawTime;
                if (j != -1) {
                    long j2 = nanoTime - j;
                    if (j2 > 200000000) {
                        this.mLastFps = ((float) ((int) ((((float) this.mFrames) / (((float) j2) * 1.0E-9f)) * 100.0f))) / 100.0f;
                        this.mFrames = 0;
                        this.mLastDrawTime = nanoTime;
                    }
                } else {
                    this.mLastDrawTime = nanoTime;
                }
                Paint paint = new Paint();
                paint.setTextSize(42.0f);
                StringBuilder sb = new StringBuilder();
                sb.append(this.mLastFps + " fps " + Debug.getState(this, this.mBeginState) + " -> ");
                sb.append(Debug.getState(this, this.mEndState));
                sb.append(" (progress: ");
                sb.append(((float) ((int) (getProgress() * 1000.0f))) / 10.0f);
                sb.append(" ) state=");
                int i = this.mCurrentState;
                if (i == -1) {
                    str = "undefined";
                } else {
                    str = Debug.getState(this, i);
                }
                sb.append(str);
                String sb2 = sb.toString();
                paint.setColor(ViewCompat.MEASURED_STATE_MASK);
                canvas.drawText(sb2, 11.0f, (float) (getHeight() - 29), paint);
                paint.setColor(-7864184);
                canvas.drawText(sb2, 10.0f, (float) (getHeight() - 30), paint);
            }
            if (this.mDebugPath > 1) {
                if (this.mDevModeDraw == null) {
                    this.mDevModeDraw = new DevModeDraw();
                }
                this.mDevModeDraw.draw(canvas, this.mFrameArrayList, this.mScene.getDuration(), this.mDebugPath);
            }
        }
    }

    private void evaluateLayout() {
        boolean z;
        float signum = Math.signum(this.mTransitionGoalPosition - this.mTransitionLastPosition);
        long nanoTime = getNanoTime();
        Interpolator interpolator = this.mInterpolator;
        float f = this.mTransitionLastPosition + (!(interpolator instanceof StopLogic) ? ((((float) (nanoTime - this.mTransitionLastTime)) * signum) * 1.0E-9f) / this.mTransitionDuration : 0.0f);
        if (this.mTransitionInstantly) {
            f = this.mTransitionGoalPosition;
        }
        int i = (signum > 0.0f ? 1 : (signum == 0.0f ? 0 : -1));
        if ((i <= 0 || f < this.mTransitionGoalPosition) && (signum > 0.0f || f > this.mTransitionGoalPosition)) {
            z = false;
        } else {
            f = this.mTransitionGoalPosition;
            z = true;
        }
        if (interpolator != null && !z) {
            if (this.mTemporalInterpolator) {
                f = interpolator.getInterpolation(((float) (nanoTime - this.mAnimationStartTime)) * 1.0E-9f);
            } else {
                f = interpolator.getInterpolation(f);
            }
        }
        if ((i > 0 && f >= this.mTransitionGoalPosition) || (signum <= 0.0f && f <= this.mTransitionGoalPosition)) {
            f = this.mTransitionGoalPosition;
        }
        this.mPostInterpolationPosition = f;
        int childCount = getChildCount();
        long nanoTime2 = getNanoTime();
        for (int i2 = 0; i2 < childCount; i2++) {
            View childAt = getChildAt(i2);
            MotionController motionController = this.mFrameArrayList.get(childAt);
            if (motionController != null) {
                motionController.interpolate(childAt, f, nanoTime2, this.mKeyCache);
            }
        }
        if (this.mMeasureDuringTransition) {
            requestLayout();
        }
    }

    /* access modifiers changed from: package-private */
    /* JADX WARNING: Removed duplicated region for block: B:139:0x01d6  */
    /* JADX WARNING: Removed duplicated region for block: B:146:? A[RETURN, SYNTHETIC] */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void evaluate(boolean r21) {
        /*
            r20 = this;
            r0 = r20
            long r1 = r0.mTransitionLastTime
            r3 = -1
            int r1 = (r1 > r3 ? 1 : (r1 == r3 ? 0 : -1))
            if (r1 != 0) goto L_0x0010
            long r1 = r20.getNanoTime()
            r0.mTransitionLastTime = r1
        L_0x0010:
            float r1 = r0.mTransitionLastPosition
            r2 = 0
            int r3 = (r1 > r2 ? 1 : (r1 == r2 ? 0 : -1))
            r4 = -1
            r5 = 1065353216(0x3f800000, float:1.0)
            if (r3 <= 0) goto L_0x0020
            int r3 = (r1 > r5 ? 1 : (r1 == r5 ? 0 : -1))
            if (r3 >= 0) goto L_0x0020
            r0.mCurrentState = r4
        L_0x0020:
            boolean r3 = r0.mKeepAnimating
            r6 = 4607182418800017408(0x3ff0000000000000, double:1.0)
            r8 = 1
            r9 = 0
            if (r3 != 0) goto L_0x0034
            boolean r3 = r0.mInTransition
            if (r3 == 0) goto L_0x017f
            if (r21 != 0) goto L_0x0034
            float r3 = r0.mTransitionGoalPosition
            int r3 = (r3 > r1 ? 1 : (r3 == r1 ? 0 : -1))
            if (r3 == 0) goto L_0x017f
        L_0x0034:
            float r3 = r0.mTransitionGoalPosition
            float r3 = r3 - r1
            float r1 = java.lang.Math.signum(r3)
            long r10 = r20.getNanoTime()
            android.view.animation.Interpolator r3 = r0.mInterpolator
            boolean r3 = r3 instanceof androidx.constraintlayout.motion.widget.MotionInterpolator
            r12 = 814313567(0x3089705f, float:1.0E-9)
            if (r3 != 0) goto L_0x0053
            long r13 = r0.mTransitionLastTime
            long r13 = r10 - r13
            float r3 = (float) r13
            float r3 = r3 * r1
            float r3 = r3 * r12
            float r13 = r0.mTransitionDuration
            float r3 = r3 / r13
            goto L_0x0054
        L_0x0053:
            r3 = r2
        L_0x0054:
            float r13 = r0.mTransitionLastPosition
            float r13 = r13 + r3
            boolean r3 = r0.mTransitionInstantly
            if (r3 == 0) goto L_0x005d
            float r13 = r0.mTransitionGoalPosition
        L_0x005d:
            int r3 = (r1 > r2 ? 1 : (r1 == r2 ? 0 : -1))
            if (r3 <= 0) goto L_0x0067
            float r14 = r0.mTransitionGoalPosition
            int r14 = (r13 > r14 ? 1 : (r13 == r14 ? 0 : -1))
            if (r14 >= 0) goto L_0x0071
        L_0x0067:
            int r14 = (r1 > r2 ? 1 : (r1 == r2 ? 0 : -1))
            if (r14 > 0) goto L_0x0077
            float r14 = r0.mTransitionGoalPosition
            int r14 = (r13 > r14 ? 1 : (r13 == r14 ? 0 : -1))
            if (r14 > 0) goto L_0x0077
        L_0x0071:
            float r13 = r0.mTransitionGoalPosition
            r0.mInTransition = r9
            r14 = r8
            goto L_0x0078
        L_0x0077:
            r14 = r9
        L_0x0078:
            r0.mTransitionLastPosition = r13
            r0.mTransitionPosition = r13
            r0.mTransitionLastTime = r10
            androidx.constraintlayout.motion.widget.MotionLayout$TransitionListener r15 = r0.mTransitionListener
            if (r15 != 0) goto L_0x008c
            java.util.ArrayList<androidx.constraintlayout.motion.widget.MotionLayout$TransitionListener> r15 = r0.mTransitionListeners
            if (r15 == 0) goto L_0x0096
            boolean r15 = r15.isEmpty()
            if (r15 != 0) goto L_0x0096
        L_0x008c:
            r20.fireTransitionChange()
            r0.mIsAnimating = r8
            if (r14 == 0) goto L_0x0096
            r20.fireTransitionCompleted()
        L_0x0096:
            android.view.animation.Interpolator r15 = r0.mInterpolator
            if (r15 == 0) goto L_0x00e8
            if (r14 != 0) goto L_0x00e8
            boolean r14 = r0.mTemporalInterpolator
            if (r14 == 0) goto L_0x00e4
            long r13 = r0.mAnimationStartTime
            long r13 = r10 - r13
            float r13 = (float) r13
            float r13 = r13 * r12
            float r12 = r15.getInterpolation(r13)
            r0.mTransitionLastPosition = r12
            r0.mTransitionLastTime = r10
            android.view.animation.Interpolator r10 = r0.mInterpolator
            boolean r11 = r10 instanceof androidx.constraintlayout.motion.widget.MotionInterpolator
            if (r11 == 0) goto L_0x00e2
            androidx.constraintlayout.motion.widget.MotionInterpolator r10 = (androidx.constraintlayout.motion.widget.MotionInterpolator) r10
            float r10 = r10.getVelocity()
            float r11 = java.lang.Math.abs(r10)
            r13 = 953267991(0x38d1b717, float:1.0E-4)
            int r11 = (r11 > r13 ? 1 : (r11 == r13 ? 0 : -1))
            if (r11 > 0) goto L_0x00c7
            r0.mInTransition = r9
        L_0x00c7:
            int r11 = (r10 > r2 ? 1 : (r10 == r2 ? 0 : -1))
            if (r11 <= 0) goto L_0x00d4
            int r11 = (r12 > r5 ? 1 : (r12 == r5 ? 0 : -1))
            if (r11 < 0) goto L_0x00d4
            r0.mTransitionLastPosition = r5
            r0.mInTransition = r9
            r12 = r5
        L_0x00d4:
            int r10 = (r10 > r2 ? 1 : (r10 == r2 ? 0 : -1))
            if (r10 >= 0) goto L_0x00e2
            int r10 = (r12 > r2 ? 1 : (r12 == r2 ? 0 : -1))
            if (r10 > 0) goto L_0x00e2
            r0.mTransitionLastPosition = r2
            r0.mInTransition = r9
            r13 = r2
            goto L_0x00e8
        L_0x00e2:
            r13 = r12
            goto L_0x00e8
        L_0x00e4:
            float r13 = r15.getInterpolation(r13)
        L_0x00e8:
            if (r3 <= 0) goto L_0x00f0
            float r3 = r0.mTransitionGoalPosition
            int r3 = (r13 > r3 ? 1 : (r13 == r3 ? 0 : -1))
            if (r3 >= 0) goto L_0x00fa
        L_0x00f0:
            int r1 = (r1 > r2 ? 1 : (r1 == r2 ? 0 : -1))
            if (r1 > 0) goto L_0x00fe
            float r1 = r0.mTransitionGoalPosition
            int r1 = (r13 > r1 ? 1 : (r13 == r1 ? 0 : -1))
            if (r1 > 0) goto L_0x00fe
        L_0x00fa:
            float r13 = r0.mTransitionGoalPosition
            r0.mInTransition = r9
        L_0x00fe:
            int r1 = (r13 > r5 ? 1 : (r13 == r5 ? 0 : -1))
            if (r1 >= 0) goto L_0x0106
            int r1 = (r13 > r2 ? 1 : (r13 == r2 ? 0 : -1))
            if (r1 > 0) goto L_0x0108
        L_0x0106:
            r0.mInTransition = r9
        L_0x0108:
            int r1 = r20.getChildCount()
            r0.mKeepAnimating = r9
            long r10 = r20.getNanoTime()
            r0.mPostInterpolationPosition = r13
            r3 = r9
        L_0x0115:
            if (r3 >= r1) goto L_0x013b
            android.view.View r15 = r0.getChildAt(r3)
            java.util.HashMap<android.view.View, androidx.constraintlayout.motion.widget.MotionController> r12 = r0.mFrameArrayList
            java.lang.Object r12 = r12.get(r15)
            r14 = r12
            androidx.constraintlayout.motion.widget.MotionController r14 = (androidx.constraintlayout.motion.widget.MotionController) r14
            if (r14 == 0) goto L_0x0137
            boolean r12 = r0.mKeepAnimating
            androidx.constraintlayout.motion.widget.KeyCache r8 = r0.mKeyCache
            r16 = r13
            r17 = r10
            r19 = r8
            boolean r8 = r14.interpolate(r15, r16, r17, r19)
            r8 = r8 | r12
            r0.mKeepAnimating = r8
        L_0x0137:
            int r3 = r3 + 1
            r8 = 1
            goto L_0x0115
        L_0x013b:
            boolean r1 = r0.mMeasureDuringTransition
            if (r1 == 0) goto L_0x0142
            r20.requestLayout()
        L_0x0142:
            boolean r1 = r0.mKeepAnimating
            if (r1 == 0) goto L_0x0149
            r20.invalidate()
        L_0x0149:
            boolean r1 = r0.mInTransition
            if (r1 == 0) goto L_0x0150
            r20.invalidate()
        L_0x0150:
            int r1 = (r13 > r2 ? 1 : (r13 == r2 ? 0 : -1))
            if (r1 > 0) goto L_0x0168
            int r1 = r0.mBeginState
            if (r1 == r4) goto L_0x0168
            int r3 = r0.mCurrentState
            if (r3 == r1) goto L_0x015d
            r9 = 1
        L_0x015d:
            r0.mCurrentState = r1
            androidx.constraintlayout.motion.widget.MotionScene r3 = r0.mScene
            androidx.constraintlayout.widget.ConstraintSet r1 = r3.getConstraintSet(r1)
            r1.applyCustomAttributes(r0)
        L_0x0168:
            double r3 = (double) r13
            int r1 = (r3 > r6 ? 1 : (r3 == r6 ? 0 : -1))
            if (r1 < 0) goto L_0x017f
            int r1 = r0.mCurrentState
            int r3 = r0.mEndState
            if (r1 == r3) goto L_0x0174
            r9 = 1
        L_0x0174:
            r0.mCurrentState = r3
            androidx.constraintlayout.motion.widget.MotionScene r1 = r0.mScene
            androidx.constraintlayout.widget.ConstraintSet r1 = r1.getConstraintSet(r3)
            r1.applyCustomAttributes(r0)
        L_0x017f:
            float r1 = r0.mTransitionLastPosition
            int r3 = (r1 > r5 ? 1 : (r1 == r5 ? 0 : -1))
            if (r3 < 0) goto L_0x018f
            int r2 = r0.mCurrentState
            int r3 = r0.mEndState
            if (r2 == r3) goto L_0x018c
            r9 = 1
        L_0x018c:
            r0.mCurrentState = r3
            goto L_0x019c
        L_0x018f:
            int r2 = (r1 > r2 ? 1 : (r1 == r2 ? 0 : -1))
            if (r2 > 0) goto L_0x019c
            int r2 = r0.mCurrentState
            int r3 = r0.mBeginState
            if (r2 == r3) goto L_0x019a
            r9 = 1
        L_0x019a:
            r0.mCurrentState = r3
        L_0x019c:
            boolean r2 = r0.mIsAnimating
            if (r2 == 0) goto L_0x01bb
            double r2 = (double) r1
            r4 = 0
            int r2 = (r2 > r4 ? 1 : (r2 == r4 ? 0 : -1))
            if (r2 > 0) goto L_0x01ae
            int r2 = r0.mListenerState
            int r3 = r0.mBeginState
            if (r2 != r3) goto L_0x01ae
            r9 = 1
        L_0x01ae:
            double r1 = (double) r1
            int r1 = (r1 > r6 ? 1 : (r1 == r6 ? 0 : -1))
            if (r1 < 0) goto L_0x01bb
            int r1 = r0.mListenerState
            int r2 = r0.mEndState
            if (r1 != r2) goto L_0x01bb
            r8 = 1
            goto L_0x01bc
        L_0x01bb:
            r8 = r9
        L_0x01bc:
            boolean r1 = r0.mNeedsFireTransitionCompleted
            r1 = r1 | r8
            r0.mNeedsFireTransitionCompleted = r1
            if (r8 == 0) goto L_0x01cc
            boolean r1 = r20.isInLayout()
            if (r1 != 0) goto L_0x01cc
            r20.requestLayout()
        L_0x01cc:
            float r1 = r0.mTransitionLastPosition
            r0.mTransitionPosition = r1
            if (r8 != 0) goto L_0x01d6
            boolean r1 = r0.mIsAnimating
            if (r1 == 0) goto L_0x01de
        L_0x01d6:
            r20.fireTransitionChange()
            if (r8 == 0) goto L_0x01de
            r20.fireTransitionCompleted()
        L_0x01de:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.motion.widget.MotionLayout.evaluate(boolean):void");
    }

    /* access modifiers changed from: protected */
    public void onLayout(boolean z, int i, int i2, int i3, int i4) {
        if (this.mScene == null) {
            super.onLayout(z, i, i2, i3, i4);
            return;
        }
        int i5 = i3 - i;
        int i6 = i4 - i2;
        if (!(this.mLastLayoutWidth == i5 && this.mLastLayoutHeight == i6)) {
            rebuildScene();
            evaluate(true);
        }
        this.mLastLayoutWidth = i5;
        this.mLastLayoutHeight = i6;
        this.mOldWidth = i5;
        this.mOldHeight = i6;
    }

    /* access modifiers changed from: protected */
    public void parseLayoutDescription(int i) {
        this.mConstraintLayoutSpec = null;
    }

    private void init(AttributeSet attributeSet) {
        MotionScene motionScene;
        IS_IN_EDIT_MODE = isInEditMode();
        if (attributeSet != null) {
            TypedArray obtainStyledAttributes = getContext().obtainStyledAttributes(attributeSet, R.styleable.MotionLayout);
            int indexCount = obtainStyledAttributes.getIndexCount();
            boolean z = true;
            for (int i = 0; i < indexCount; i++) {
                int index = obtainStyledAttributes.getIndex(i);
                if (index == R.styleable.MotionLayout_layoutDescription) {
                    this.mScene = new MotionScene(getContext(), this, obtainStyledAttributes.getResourceId(index, -1));
                } else if (index == R.styleable.MotionLayout_currentState) {
                    this.mCurrentState = obtainStyledAttributes.getResourceId(index, -1);
                } else if (index == R.styleable.MotionLayout_motionProgress) {
                    this.mTransitionGoalPosition = obtainStyledAttributes.getFloat(index, 0.0f);
                    this.mInTransition = true;
                } else if (index == R.styleable.MotionLayout_applyMotionScene) {
                    z = obtainStyledAttributes.getBoolean(index, z);
                } else if (index == R.styleable.MotionLayout_showPaths) {
                    if (this.mDebugPath == 0) {
                        this.mDebugPath = obtainStyledAttributes.getBoolean(index, false) ? 2 : 0;
                    }
                } else if (index == R.styleable.MotionLayout_motionDebug) {
                    this.mDebugPath = obtainStyledAttributes.getInt(index, 0);
                }
            }
            obtainStyledAttributes.recycle();
            if (this.mScene == null) {
                Log.e(TAG, "WARNING NO app:layoutDescription tag");
            }
            if (!z) {
                this.mScene = null;
            }
        }
        if (this.mDebugPath != 0) {
            checkStructure();
        }
        if (this.mCurrentState == -1 && (motionScene = this.mScene) != null) {
            this.mCurrentState = motionScene.getStartId();
            this.mBeginState = this.mScene.getStartId();
            this.mEndState = this.mScene.getEndId();
        }
    }

    public void setScene(MotionScene motionScene) {
        this.mScene = motionScene;
        motionScene.setRtl(isRtl());
        rebuildScene();
    }

    private void checkStructure() {
        MotionScene motionScene = this.mScene;
        if (motionScene == null) {
            Log.e(TAG, "CHECK: motion scene not set! set \"app:layoutDescription=\"@xml/file\"");
            return;
        }
        int startId = motionScene.getStartId();
        MotionScene motionScene2 = this.mScene;
        checkStructure(startId, motionScene2.getConstraintSet(motionScene2.getStartId()));
        SparseIntArray sparseIntArray = new SparseIntArray();
        SparseIntArray sparseIntArray2 = new SparseIntArray();
        Iterator<MotionScene.Transition> it = this.mScene.getDefinedTransitions().iterator();
        while (it.hasNext()) {
            MotionScene.Transition next = it.next();
            if (next == this.mScene.mCurrentTransition) {
                Log.v(TAG, "CHECK: CURRENT");
            }
            checkStructure(next);
            int startConstraintSetId = next.getStartConstraintSetId();
            int endConstraintSetId = next.getEndConstraintSetId();
            String name = Debug.getName(getContext(), startConstraintSetId);
            String name2 = Debug.getName(getContext(), endConstraintSetId);
            if (sparseIntArray.get(startConstraintSetId) == endConstraintSetId) {
                Log.e(TAG, "CHECK: two transitions with the same start and end " + name + "->" + name2);
            }
            if (sparseIntArray2.get(endConstraintSetId) == startConstraintSetId) {
                Log.e(TAG, "CHECK: you can't have reverse transitions" + name + "->" + name2);
            }
            sparseIntArray.put(startConstraintSetId, endConstraintSetId);
            sparseIntArray2.put(endConstraintSetId, startConstraintSetId);
            if (this.mScene.getConstraintSet(startConstraintSetId) == null) {
                Log.e(TAG, " no such constraintSetStart " + name);
            }
            if (this.mScene.getConstraintSet(endConstraintSetId) == null) {
                Log.e(TAG, " no such constraintSetEnd " + name);
            }
        }
    }

    private void checkStructure(int i, ConstraintSet constraintSet) {
        String name = Debug.getName(getContext(), i);
        int childCount = getChildCount();
        for (int i2 = 0; i2 < childCount; i2++) {
            View childAt = getChildAt(i2);
            int id = childAt.getId();
            if (id == -1) {
                Log.w(TAG, "CHECK: " + name + " ALL VIEWS SHOULD HAVE ID's " + childAt.getClass().getName() + " does not!");
            }
            if (constraintSet.getConstraint(id) == null) {
                Log.w(TAG, "CHECK: " + name + " NO CONSTRAINTS for " + Debug.getName(childAt));
            }
        }
        int[] knownIds = constraintSet.getKnownIds();
        for (int i3 = 0; i3 < knownIds.length; i3++) {
            int i4 = knownIds[i3];
            String name2 = Debug.getName(getContext(), i4);
            if (findViewById(knownIds[i3]) == null) {
                Log.w(TAG, "CHECK: " + name + " NO View matches id " + name2);
            }
            if (constraintSet.getHeight(i4) == -1) {
                Log.w(TAG, "CHECK: " + name + "(" + name2 + ") no LAYOUT_HEIGHT");
            }
            if (constraintSet.getWidth(i4) == -1) {
                Log.w(TAG, "CHECK: " + name + "(" + name2 + ") no LAYOUT_HEIGHT");
            }
        }
    }

    private void checkStructure(MotionScene.Transition transition) {
        Log.v(TAG, "CHECK: transition = " + transition.debugString(getContext()));
        Log.v(TAG, "CHECK: transition.setDuration = " + transition.getDuration());
        if (transition.getStartConstraintSetId() == transition.getEndConstraintSetId()) {
            Log.e(TAG, "CHECK: start and end constraint set should not be the same!");
        }
    }

    public void setDebugMode(int i) {
        this.mDebugPath = i;
        invalidate();
    }

    public void getDebugMode(boolean z) {
        this.mDebugPath = z ? 2 : 1;
        invalidate();
    }

    private boolean handlesTouchEvent(float f, float f2, View view, MotionEvent motionEvent) {
        if (view instanceof ViewGroup) {
            ViewGroup viewGroup = (ViewGroup) view;
            int childCount = viewGroup.getChildCount();
            for (int i = 0; i < childCount; i++) {
                if (handlesTouchEvent(((float) view.getLeft()) + f, ((float) view.getTop()) + f2, viewGroup.getChildAt(i), motionEvent)) {
                    return true;
                }
            }
        }
        this.mBoundsCheck.set(((float) view.getLeft()) + f, ((float) view.getTop()) + f2, f + ((float) view.getRight()), f2 + ((float) view.getBottom()));
        if (motionEvent.getAction() == 0) {
            return this.mBoundsCheck.contains(motionEvent.getX(), motionEvent.getY()) && view.onTouchEvent(motionEvent);
        }
        if (view.onTouchEvent(motionEvent)) {
            return true;
        }
    }

    public boolean onInterceptTouchEvent(MotionEvent motionEvent) {
        MotionScene.Transition transition;
        TouchResponse touchResponse;
        int touchRegionId;
        RectF touchRegion;
        MotionScene motionScene = this.mScene;
        if (motionScene != null && this.mInteractionEnabled && (transition = motionScene.mCurrentTransition) != null && transition.isEnabled() && (touchResponse = transition.getTouchResponse()) != null && ((motionEvent.getAction() != 0 || (touchRegion = touchResponse.getTouchRegion(this, new RectF())) == null || touchRegion.contains(motionEvent.getX(), motionEvent.getY())) && (touchRegionId = touchResponse.getTouchRegionId()) != -1)) {
            View view = this.mRegionView;
            if (view == null || view.getId() != touchRegionId) {
                this.mRegionView = findViewById(touchRegionId);
            }
            View view2 = this.mRegionView;
            if (view2 != null) {
                this.mBoundsCheck.set((float) view2.getLeft(), (float) this.mRegionView.getTop(), (float) this.mRegionView.getRight(), (float) this.mRegionView.getBottom());
                if (this.mBoundsCheck.contains(motionEvent.getX(), motionEvent.getY()) && !handlesTouchEvent(0.0f, 0.0f, this.mRegionView, motionEvent)) {
                    return onTouchEvent(motionEvent);
                }
            }
        }
        return false;
    }

    public boolean onTouchEvent(MotionEvent motionEvent) {
        MotionScene motionScene = this.mScene;
        if (motionScene == null || !this.mInteractionEnabled || !motionScene.supportTouch()) {
            return super.onTouchEvent(motionEvent);
        }
        MotionScene.Transition transition = this.mScene.mCurrentTransition;
        if (transition != null && !transition.isEnabled()) {
            return super.onTouchEvent(motionEvent);
        }
        this.mScene.processTouchEvent(motionEvent, getCurrentState(), this);
        return true;
    }

    /* access modifiers changed from: protected */
    public void onAttachedToWindow() {
        int i;
        super.onAttachedToWindow();
        MotionScene motionScene = this.mScene;
        if (!(motionScene == null || (i = this.mCurrentState) == -1)) {
            ConstraintSet constraintSet = motionScene.getConstraintSet(i);
            this.mScene.readFallback(this);
            if (constraintSet != null) {
                constraintSet.applyTo(this);
            }
            this.mBeginState = this.mCurrentState;
        }
        onNewStateAttachHandlers();
    }

    public void onRtlPropertiesChanged(int i) {
        MotionScene motionScene = this.mScene;
        if (motionScene != null) {
            motionScene.setRtl(isRtl());
        }
    }

    private void onNewStateAttachHandlers() {
        MotionScene motionScene = this.mScene;
        if (motionScene != null && !motionScene.autoTransition(this, this.mCurrentState)) {
            int i = this.mCurrentState;
            if (i != -1) {
                this.mScene.addOnClickListeners(this, i);
            }
            if (this.mScene.supportTouch()) {
                this.mScene.setupTouch();
            }
        }
    }

    public int getCurrentState() {
        return this.mCurrentState;
    }

    public float getProgress() {
        return this.mTransitionLastPosition;
    }

    /* access modifiers changed from: package-private */
    public void getAnchorDpDt(int i, float f, float f2, float f3, float[] fArr) {
        String str;
        HashMap<View, MotionController> hashMap = this.mFrameArrayList;
        View viewById = getViewById(i);
        MotionController motionController = hashMap.get(viewById);
        if (motionController != null) {
            motionController.getDpDt(f, f2, f3, fArr);
            float y = viewById.getY();
            this.lastPos = f;
            this.lastY = y;
            return;
        }
        if (viewById == null) {
            str = "" + i;
        } else {
            str = viewById.getContext().getResources().getResourceName(i);
        }
        Log.w(TAG, "WARNING could not find view id " + str);
    }

    public long getTransitionTimeMs() {
        MotionScene motionScene = this.mScene;
        if (motionScene != null) {
            this.mTransitionDuration = ((float) motionScene.getDuration()) / 1000.0f;
        }
        return (long) (this.mTransitionDuration * 1000.0f);
    }

    public void setTransitionListener(TransitionListener transitionListener) {
        this.mTransitionListener = transitionListener;
    }

    public void addTransitionListener(TransitionListener transitionListener) {
        this.mTransitionListeners.add(transitionListener);
    }

    public boolean removeTransitionListener(TransitionListener transitionListener) {
        return this.mTransitionListeners.remove(transitionListener);
    }

    public void fireTrigger(int i, boolean z, float f) {
        TransitionListener transitionListener = this.mTransitionListener;
        if (transitionListener != null) {
            transitionListener.onTransitionTrigger(this, i, z, f);
        }
        ArrayList<TransitionListener> arrayList = this.mTransitionListeners;
        if (arrayList != null) {
            Iterator<TransitionListener> it = arrayList.iterator();
            while (it.hasNext()) {
                it.next().onTransitionTrigger(this, i, z, f);
            }
        }
    }

    private void fireTransitionChange() {
        ArrayList<TransitionListener> arrayList;
        if ((this.mTransitionListener != null || ((arrayList = this.mTransitionListeners) != null && !arrayList.isEmpty())) && this.mListenerPosition != this.mTransitionPosition) {
            if (this.mListenerState != -1) {
                TransitionListener transitionListener = this.mTransitionListener;
                if (transitionListener != null) {
                    transitionListener.onTransitionStarted(this, this.mBeginState, this.mEndState);
                }
                ArrayList<TransitionListener> arrayList2 = this.mTransitionListeners;
                if (arrayList2 != null) {
                    Iterator<TransitionListener> it = arrayList2.iterator();
                    while (it.hasNext()) {
                        it.next().onTransitionStarted(this, this.mBeginState, this.mEndState);
                    }
                }
                this.mIsAnimating = true;
            }
            this.mListenerState = -1;
            float f = this.mTransitionPosition;
            this.mListenerPosition = f;
            TransitionListener transitionListener2 = this.mTransitionListener;
            if (transitionListener2 != null) {
                transitionListener2.onTransitionChange(this, this.mBeginState, this.mEndState, f);
            }
            ArrayList<TransitionListener> arrayList3 = this.mTransitionListeners;
            if (arrayList3 != null) {
                Iterator<TransitionListener> it2 = arrayList3.iterator();
                while (it2.hasNext()) {
                    it2.next().onTransitionChange(this, this.mBeginState, this.mEndState, this.mTransitionPosition);
                }
            }
            this.mIsAnimating = true;
        }
    }

    /* access modifiers changed from: protected */
    public void fireTransitionCompleted() {
        int i;
        ArrayList<TransitionListener> arrayList;
        if ((this.mTransitionListener != null || ((arrayList = this.mTransitionListeners) != null && !arrayList.isEmpty())) && this.mListenerState == -1) {
            this.mListenerState = this.mCurrentState;
            if (!this.mTransitionCompleted.isEmpty()) {
                ArrayList<Integer> arrayList2 = this.mTransitionCompleted;
                i = arrayList2.get(arrayList2.size() - 1).intValue();
            } else {
                i = -1;
            }
            int i2 = this.mCurrentState;
            if (i != i2 && i2 != -1) {
                this.mTransitionCompleted.add(Integer.valueOf(i2));
            }
        }
    }

    private void processTransitionCompleted() {
        ArrayList<TransitionListener> arrayList;
        if (this.mTransitionListener != null || ((arrayList = this.mTransitionListeners) != null && !arrayList.isEmpty())) {
            this.mIsAnimating = false;
            Iterator<Integer> it = this.mTransitionCompleted.iterator();
            while (it.hasNext()) {
                Integer next = it.next();
                TransitionListener transitionListener = this.mTransitionListener;
                if (transitionListener != null) {
                    transitionListener.onTransitionCompleted(this, next.intValue());
                }
                ArrayList<TransitionListener> arrayList2 = this.mTransitionListeners;
                if (arrayList2 != null) {
                    Iterator<TransitionListener> it2 = arrayList2.iterator();
                    while (it2.hasNext()) {
                        it2.next().onTransitionCompleted(this, next.intValue());
                    }
                }
            }
            this.mTransitionCompleted.clear();
        }
    }

    public DesignTool getDesignTool() {
        if (this.mDesignTool == null) {
            this.mDesignTool = new DesignTool(this);
        }
        return this.mDesignTool;
    }

    public void onViewAdded(View view) {
        super.onViewAdded(view);
        if (view instanceof MotionHelper) {
            MotionHelper motionHelper = (MotionHelper) view;
            if (this.mTransitionListeners == null) {
                this.mTransitionListeners = new ArrayList<>();
            }
            this.mTransitionListeners.add(motionHelper);
            if (motionHelper.isUsedOnShow()) {
                if (this.mOnShowHelpers == null) {
                    this.mOnShowHelpers = new ArrayList<>();
                }
                this.mOnShowHelpers.add(motionHelper);
            }
            if (motionHelper.isUseOnHide()) {
                if (this.mOnHideHelpers == null) {
                    this.mOnHideHelpers = new ArrayList<>();
                }
                this.mOnHideHelpers.add(motionHelper);
            }
        }
    }

    public void onViewRemoved(View view) {
        super.onViewRemoved(view);
        ArrayList<MotionHelper> arrayList = this.mOnShowHelpers;
        if (arrayList != null) {
            arrayList.remove(view);
        }
        ArrayList<MotionHelper> arrayList2 = this.mOnHideHelpers;
        if (arrayList2 != null) {
            arrayList2.remove(view);
        }
        if (this.mScrollTarget == view) {
            this.mScrollTarget = null;
        }
    }

    public void setOnShow(float f) {
        ArrayList<MotionHelper> arrayList = this.mOnShowHelpers;
        if (arrayList != null) {
            int size = arrayList.size();
            for (int i = 0; i < size; i++) {
                this.mOnShowHelpers.get(i).setProgress(f);
            }
        }
    }

    public void setOnHide(float f) {
        ArrayList<MotionHelper> arrayList = this.mOnHideHelpers;
        if (arrayList != null) {
            int size = arrayList.size();
            for (int i = 0; i < size; i++) {
                this.mOnHideHelpers.get(i).setProgress(f);
            }
        }
    }

    public int[] getConstraintSetIds() {
        MotionScene motionScene = this.mScene;
        if (motionScene == null) {
            return null;
        }
        return motionScene.getConstraintSetIds();
    }

    public ConstraintSet getConstraintSet(int i) {
        MotionScene motionScene = this.mScene;
        if (motionScene == null) {
            return null;
        }
        return motionScene.getConstraintSet(i);
    }

    @Deprecated
    public void rebuildMotion() {
        Log.e(TAG, "This method is deprecated. Please call rebuildScene() instead.");
        rebuildScene();
    }

    public void rebuildScene() {
        this.mModel.reEvaluateState();
        invalidate();
    }

    public void updateState(int i, ConstraintSet constraintSet) {
        MotionScene motionScene = this.mScene;
        if (motionScene != null) {
            motionScene.setConstraintSet(i, constraintSet);
        }
        updateState();
        if (this.mCurrentState == i) {
            constraintSet.applyTo(this);
        }
    }

    public void updateState() {
        this.mModel.initFrom(this.mLayoutWidget, this.mScene.getConstraintSet(this.mBeginState), this.mScene.getConstraintSet(this.mEndState));
        rebuildScene();
    }

    public ArrayList<MotionScene.Transition> getDefinedTransitions() {
        MotionScene motionScene = this.mScene;
        if (motionScene == null) {
            return null;
        }
        return motionScene.getDefinedTransitions();
    }

    public int getStartState() {
        return this.mBeginState;
    }

    public int getEndState() {
        return this.mEndState;
    }

    public float getTargetPosition() {
        return this.mTransitionGoalPosition;
    }

    public void setTransitionDuration(int i) {
        MotionScene motionScene = this.mScene;
        if (motionScene == null) {
            Log.e(TAG, "MotionScene not defined");
        } else {
            motionScene.setDuration(i);
        }
    }

    public MotionScene.Transition getTransition(int i) {
        return this.mScene.getTransitionById(i);
    }

    /* access modifiers changed from: package-private */
    public int lookUpConstraintId(String str) {
        MotionScene motionScene = this.mScene;
        if (motionScene == null) {
            return 0;
        }
        return motionScene.lookUpConstraintId(str);
    }

    /* access modifiers changed from: package-private */
    public String getConstraintSetNames(int i) {
        MotionScene motionScene = this.mScene;
        if (motionScene == null) {
            return null;
        }
        return motionScene.lookUpConstraintName(i);
    }

    /* access modifiers changed from: package-private */
    public void disableAutoTransition(boolean z) {
        MotionScene motionScene = this.mScene;
        if (motionScene != null) {
            motionScene.disableAutoTransition(z);
        }
    }

    public void setInteractionEnabled(boolean z) {
        this.mInteractionEnabled = z;
    }

    public boolean isInteractionEnabled() {
        return this.mInteractionEnabled;
    }

    private void fireTransitionStarted(MotionLayout motionLayout, int i, int i2) {
        TransitionListener transitionListener = this.mTransitionListener;
        if (transitionListener != null) {
            transitionListener.onTransitionStarted(this, i, i2);
        }
        ArrayList<TransitionListener> arrayList = this.mTransitionListeners;
        if (arrayList != null) {
            Iterator<TransitionListener> it = arrayList.iterator();
            while (it.hasNext()) {
                it.next().onTransitionStarted(motionLayout, i, i2);
            }
        }
    }
}
