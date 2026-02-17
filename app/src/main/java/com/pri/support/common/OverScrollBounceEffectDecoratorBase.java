package com.pri.support.common;

import android.util.Property;
import android.view.MotionEvent;
import android.view.View;
import android.view.animation.Interpolator;
import androidx.core.os.EnvironmentCompat;
import com.pri.anim.spring.SimpleSpringListener;
import com.pri.anim.spring.Spring;
import com.pri.anim.spring.SpringOverScroller;
import com.pri.anim.spring.SpringSystem;
import com.pri.support.common.ListenerStubs;
import com.pri.support.common.adapters.IOverScrollDecoratorAdapter;

public abstract class OverScrollBounceEffectDecoratorBase implements IOverScrollDecor, View.OnTouchListener {
    private static final float MAX_OVER_SCROLL_OFFSET_FACTOR = 0.5f;
    private static final String TAG = "OSBounceEffectDeBase";
    /* access modifiers changed from: private */
    public final BounceBackState mBounceBackState;
    private IDecoratorState mCurrentState;
    private boolean mEnableOverScrollEffect = true;
    /* access modifiers changed from: private */
    public final IdleState mIdleState;
    /* access modifiers changed from: private */
    public final OverScrollingState mOverScrollingState;
    /* access modifiers changed from: private */
    public final OverScrollStartAttributes mStartAttr = new OverScrollStartAttributes();
    /* access modifiers changed from: private */
    public IOverScrollStateListener mStateListener = new ListenerStubs.OverScrollStateListenerStub();
    /* access modifiers changed from: private */
    public IOverScrollUpdateListener mUpdateListener = new ListenerStubs.OverScrollUpdateListenerStub();
    /* access modifiers changed from: private */
    public final IOverScrollDecoratorAdapter mViewAdapter;

    protected interface IDecoratorState {
        int getStateId();

        void handleEntryTransition(IDecoratorState iDecoratorState);

        boolean handleMoveTouchEvent(MotionEvent motionEvent);

        boolean handleUpOrCancelTouchEvent(MotionEvent motionEvent);
    }

    public static String stateToString(int i) {
        return i != 0 ? i != 1 ? i != 2 ? i != 3 ? i != 4 ? EnvironmentCompat.MEDIA_UNKNOWN : "bounceBack" : "dragStartEnd" : "dragStartSlide" : "drag" : "idle";
    }

    /* access modifiers changed from: protected */
    public abstract AnimationAttributes createAnimationAttributes();

    /* access modifiers changed from: protected */
    public abstract MotionAttributes createMotionAttributes();

    /* access modifiers changed from: protected */
    public abstract float getTranslateValue(View view);

    /* access modifiers changed from: protected */
    public abstract void translateView(View view, float f);

    /* access modifiers changed from: protected */
    public abstract void translateViewAndEvent(View view, float f, MotionEvent motionEvent);

    protected OverScrollBounceEffectDecoratorBase(IOverScrollDecoratorAdapter iOverScrollDecoratorAdapter, float f, float f2, float f3) {
        this.mViewAdapter = iOverScrollDecoratorAdapter;
        this.mBounceBackState = new BounceBackState();
        this.mOverScrollingState = new OverScrollingState(f, f2);
        IdleState idleState = new IdleState();
        this.mIdleState = idleState;
        this.mCurrentState = idleState;
        attach();
    }

    public void setEnableOverScrollEffect(boolean z) {
        if (z) {
            attach();
            return;
        }
        deAttach();
        this.mCurrentState = this.mIdleState;
    }

    public boolean onTouch(View view, MotionEvent motionEvent) {
        int actionMasked = motionEvent.getActionMasked();
        IDecoratorState iDecoratorState = this.mCurrentState;
        if (actionMasked != 1) {
            if (actionMasked == 2) {
                return iDecoratorState.handleMoveTouchEvent(motionEvent);
            }
            if (actionMasked != 3) {
                return false;
            }
        }
        boolean handleUpOrCancelTouchEvent = iDecoratorState.handleUpOrCancelTouchEvent(motionEvent);
        IDecoratorState iDecoratorState2 = this.mCurrentState;
        IdleState idleState = this.mIdleState;
        if (iDecoratorState2 == idleState && idleState.isNonOriginalOffset(getTranslateValue(getView()))) {
            transitToState(this.mBounceBackState);
        }
        return handleUpOrCancelTouchEvent;
    }

    public View getView() {
        return this.mViewAdapter.getView();
    }

    /* access modifiers changed from: protected */
    public void transitToState(IDecoratorState iDecoratorState) {
        IDecoratorState iDecoratorState2 = this.mCurrentState;
        if (iDecoratorState != iDecoratorState2) {
            this.mCurrentState = iDecoratorState;
            iDecoratorState.handleEntryTransition(iDecoratorState2);
        }
    }

    /* access modifiers changed from: protected */
    public void attach() {
        getView().setOnTouchListener(this);
        getView().setOverScrollMode(2);
    }

    /* access modifiers changed from: protected */
    public void deAttach() {
        getView().setOnTouchListener((View.OnTouchListener) null);
    }

    protected static abstract class MotionAttributes {
        protected float mAbsOffset;
        protected float mDeltaOffset;
        protected boolean mDir;

        /* access modifiers changed from: protected */
        public abstract boolean init(View view, MotionEvent motionEvent);

        protected MotionAttributes() {
        }
    }

    static class OverScrollStartAttributes {
        float mAbsOffset;
        boolean mDir;
        int mPointerId;

        OverScrollStartAttributes() {
        }
    }

    protected static abstract class AnimationAttributes {
        protected float mAbsOffset;
        protected float mMaxOffset;
        protected Property<View, Float> mProperty;

        /* access modifiers changed from: protected */
        public abstract void init(View view);

        protected AnimationAttributes() {
        }
    }

    static class ViscousFluidInterpolator implements Interpolator {
        private static final float VISCOUS_FLUID_NORMALIZE;
        private static final float VISCOUS_FLUID_OFFSET;

        static {
            float viscousFluid = 1.0f / viscousFluid(1.0f);
            VISCOUS_FLUID_NORMALIZE = viscousFluid;
            VISCOUS_FLUID_OFFSET = 1.0f - (viscousFluid * viscousFluid(1.0f));
        }

        ViscousFluidInterpolator() {
        }

        private static float viscousFluid(float f) {
            float f2 = f * 8.0f;
            if (f2 < 1.0f) {
                return f2 - (1.0f - ((float) Math.exp((double) (-f2))));
            }
            return ((1.0f - ((float) Math.exp((double) (1.0f - f2)))) * 0.63212055f) + 0.36787945f;
        }

        public float getInterpolation(float f) {
            float viscousFluid = VISCOUS_FLUID_NORMALIZE * viscousFluid(f);
            return viscousFluid > 0.0f ? viscousFluid + VISCOUS_FLUID_OFFSET : viscousFluid;
        }
    }

    class IdleState implements IDecoratorState {
        final MotionAttributes mMoveAttr;
        /* access modifiers changed from: private */
        public float originalOffset = Float.MAX_VALUE;

        public int getStateId() {
            return 0;
        }

        public boolean handleUpOrCancelTouchEvent(MotionEvent motionEvent) {
            return false;
        }

        IdleState() {
            this.mMoveAttr = OverScrollBounceEffectDecoratorBase.this.createMotionAttributes();
        }

        public boolean hasValidOriginalOffset() {
            return this.originalOffset != Float.MAX_VALUE;
        }

        public boolean isNonOriginalOffset(float f) {
            return hasValidOriginalOffset() && this.originalOffset != f;
        }

        public boolean handleMoveTouchEvent(MotionEvent motionEvent) {
            if (!this.mMoveAttr.init(OverScrollBounceEffectDecoratorBase.this.getView(), motionEvent)) {
                return false;
            }
            if ((!OverScrollBounceEffectDecoratorBase.this.mViewAdapter.isInAbsoluteStart() || !this.mMoveAttr.mDir) && (!OverScrollBounceEffectDecoratorBase.this.mViewAdapter.isInAbsoluteEnd() || this.mMoveAttr.mDir)) {
                return false;
            }
            OverScrollBounceEffectDecoratorBase.this.mStartAttr.mPointerId = motionEvent.getPointerId(0);
            OverScrollStartAttributes access$100 = OverScrollBounceEffectDecoratorBase.this.mStartAttr;
            float f = this.mMoveAttr.mAbsOffset;
            access$100.mAbsOffset = f;
            if (this.originalOffset == Float.MAX_VALUE) {
                this.originalOffset = f;
            }
            OverScrollBounceEffectDecoratorBase.this.mStartAttr.mDir = this.mMoveAttr.mDir;
            OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase = OverScrollBounceEffectDecoratorBase.this;
            overScrollBounceEffectDecoratorBase.transitToState(overScrollBounceEffectDecoratorBase.mOverScrollingState);
            return OverScrollBounceEffectDecoratorBase.this.mOverScrollingState.handleMoveTouchEvent(motionEvent);
        }

        public void handleEntryTransition(IDecoratorState iDecoratorState) {
            OverScrollBounceEffectDecoratorBase.this.mStateListener.onOverScrollStateChange(OverScrollBounceEffectDecoratorBase.this, iDecoratorState.getStateId(), getStateId());
        }
    }

    class OverScrollingState implements IDecoratorState {
        int mCurrDragState = 1;
        final MotionAttributes mMoveAttr;
        final float mTouchDragRatioBck;
        final float mTouchDragRatioFwd;

        OverScrollingState(float f, float f2) {
            this.mMoveAttr = OverScrollBounceEffectDecoratorBase.this.createMotionAttributes();
            this.mTouchDragRatioFwd = f;
            this.mTouchDragRatioBck = f2;
        }

        public int getStateId() {
            return this.mCurrDragState;
        }

        public boolean handleMoveTouchEvent(MotionEvent motionEvent) {
            float f;
            if (OverScrollBounceEffectDecoratorBase.this.mStartAttr.mPointerId != motionEvent.getPointerId(0)) {
                OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase = OverScrollBounceEffectDecoratorBase.this;
                overScrollBounceEffectDecoratorBase.transitToState(overScrollBounceEffectDecoratorBase.mBounceBackState);
                OverScrollBounceEffectDecoratorBase.this.mBounceBackState.mDisableCancelAnimOnMoveEvent = true;
                return true;
            }
            View view = OverScrollBounceEffectDecoratorBase.this.getView();
            if (!this.mMoveAttr.init(view, motionEvent)) {
                return true;
            }
            float height = ((float) OverScrollBounceEffectDecoratorBase.this.getView().getHeight()) * 0.5f;
            float f2 = this.mMoveAttr.mDir == OverScrollBounceEffectDecoratorBase.this.mStartAttr.mDir ? this.mTouchDragRatioFwd : this.mTouchDragRatioBck;
            MotionAttributes motionAttributes = this.mMoveAttr;
            float f3 = motionAttributes.mAbsOffset + (motionAttributes.mDeltaOffset / f2);
            if (motionAttributes.mDir) {
                f = Math.min(f3, height);
            } else {
                f = Math.max(f3, -height);
            }
            if (f == OverScrollBounceEffectDecoratorBase.this.mStartAttr.mAbsOffset || (OverScrollBounceEffectDecoratorBase.this.mStartAttr.mDir != this.mMoveAttr.mDir && ((!OverScrollBounceEffectDecoratorBase.this.mStartAttr.mDir || f <= OverScrollBounceEffectDecoratorBase.this.mStartAttr.mAbsOffset) && (OverScrollBounceEffectDecoratorBase.this.mStartAttr.mDir || f >= OverScrollBounceEffectDecoratorBase.this.mStartAttr.mAbsOffset)))) {
                OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase2 = OverScrollBounceEffectDecoratorBase.this;
                overScrollBounceEffectDecoratorBase2.translateViewAndEvent(view, overScrollBounceEffectDecoratorBase2.mStartAttr.mAbsOffset, motionEvent);
                OverScrollBounceEffectDecoratorBase.this.mUpdateListener.onOverScrollUpdate(OverScrollBounceEffectDecoratorBase.this, this.mCurrDragState, 0.0f);
                OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase3 = OverScrollBounceEffectDecoratorBase.this;
                overScrollBounceEffectDecoratorBase3.transitToState(overScrollBounceEffectDecoratorBase3.mIdleState);
                return true;
            }
            if (view.getParent() != null) {
                view.getParent().requestDisallowInterceptTouchEvent(true);
            }
            OverScrollBounceEffectDecoratorBase.this.translateView(view, f);
            OverScrollBounceEffectDecoratorBase.this.mUpdateListener.onOverScrollUpdate(OverScrollBounceEffectDecoratorBase.this, this.mCurrDragState, f);
            return true;
        }

        public boolean handleUpOrCancelTouchEvent(MotionEvent motionEvent) {
            OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase = OverScrollBounceEffectDecoratorBase.this;
            overScrollBounceEffectDecoratorBase.transitToState(overScrollBounceEffectDecoratorBase.mBounceBackState);
            return false;
        }

        public void handleEntryTransition(IDecoratorState iDecoratorState) {
            this.mCurrDragState = OverScrollBounceEffectDecoratorBase.this.mStartAttr.mDir ? 2 : 3;
            OverScrollBounceEffectDecoratorBase.this.mStateListener.onOverScrollStateChange(OverScrollBounceEffectDecoratorBase.this, iDecoratorState.getStateId(), getStateId());
        }
    }

    class BounceBackState extends SimpleSpringListener implements IDecoratorState {
        final AnimationAttributes mAnimAttributes;
        boolean mDisableCancelAnimOnMoveEvent;
        private final Spring mSpring;
        private final SpringSystem mSpringSystem;

        public int getStateId() {
            return 4;
        }

        BounceBackState() {
            this.mAnimAttributes = OverScrollBounceEffectDecoratorBase.this.createAnimationAttributes();
            SpringSystem create = SpringSystem.create();
            this.mSpringSystem = create;
            this.mSpring = create.createSpring().addListener(this);
        }

        /* access modifiers changed from: package-private */
        public boolean startSpringBack(boolean z) {
            this.mAnimAttributes.init(OverScrollBounceEffectDecoratorBase.this.getView());
            if (((int) this.mAnimAttributes.mAbsOffset) == ((int) OverScrollBounceEffectDecoratorBase.this.mIdleState.originalOffset)) {
                return false;
            }
            this.mSpring.setSpringConfig(SpringOverScroller.RUBBERBANDING_CONFIG);
            this.mSpring.setCurrentValue((double) this.mAnimAttributes.mAbsOffset, z);
            this.mSpring.setEndValue((double) OverScrollBounceEffectDecoratorBase.this.mIdleState.originalOffset);
            return true;
        }

        public void handleEntryTransition(IDecoratorState iDecoratorState) {
            OverScrollBounceEffectDecoratorBase.this.mStateListener.onOverScrollStateChange(OverScrollBounceEffectDecoratorBase.this, iDecoratorState.getStateId(), getStateId());
            if (!startSpringBack(true)) {
                OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase = OverScrollBounceEffectDecoratorBase.this;
                overScrollBounceEffectDecoratorBase.transitToState(overScrollBounceEffectDecoratorBase.mIdleState);
            }
        }

        public boolean handleMoveTouchEvent(MotionEvent motionEvent) {
            if (this.mDisableCancelAnimOnMoveEvent || this.mSpring.isAtRest()) {
                return true;
            }
            this.mSpring.setAtRest();
            return true;
        }

        public boolean handleUpOrCancelTouchEvent(MotionEvent motionEvent) {
            this.mDisableCancelAnimOnMoveEvent = false;
            return true;
        }

        public void onSpringUpdate(Spring spring) {
            float currentValue = (float) spring.getCurrentValue();
            OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase = OverScrollBounceEffectDecoratorBase.this;
            overScrollBounceEffectDecoratorBase.translateView(overScrollBounceEffectDecoratorBase.getView(), currentValue);
            OverScrollBounceEffectDecoratorBase.this.mUpdateListener.onOverScrollUpdate(OverScrollBounceEffectDecoratorBase.this, getStateId(), currentValue);
        }

        public void onSpringAtRest(Spring spring) {
            OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase = OverScrollBounceEffectDecoratorBase.this;
            overScrollBounceEffectDecoratorBase.transitToState(overScrollBounceEffectDecoratorBase.mIdleState);
        }
    }
}
