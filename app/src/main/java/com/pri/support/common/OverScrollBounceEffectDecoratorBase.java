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
/* loaded from: classes4.dex */
public abstract class OverScrollBounceEffectDecoratorBase implements IOverScrollDecor, View.OnTouchListener {
    private static final float MAX_OVER_SCROLL_OFFSET_FACTOR = 0.5f;
    private static final String TAG = "OSBounceEffectDeBase";
    private IDecoratorState mCurrentState;
    private final IdleState mIdleState;
    private final OverScrollingState mOverScrollingState;
    private final IOverScrollDecoratorAdapter mViewAdapter;
    private boolean mEnableOverScrollEffect = true;
    private final OverScrollStartAttributes mStartAttr = new OverScrollStartAttributes();
    private IOverScrollStateListener mStateListener = new ListenerStubs.OverScrollStateListenerStub();
    private IOverScrollUpdateListener mUpdateListener = new ListenerStubs.OverScrollUpdateListenerStub();
    private final BounceBackState mBounceBackState = new BounceBackState();

    /* JADX INFO: Access modifiers changed from: protected */
    /* loaded from: classes4.dex */
    public static abstract class AnimationAttributes {
        protected float mAbsOffset;
        protected float mMaxOffset;
        protected Property<View, Float> mProperty;

        protected abstract void init(View view);
    }

    /* JADX INFO: Access modifiers changed from: protected */
    /* loaded from: classes4.dex */
    public interface IDecoratorState {
        int getStateId();

        void handleEntryTransition(IDecoratorState iDecoratorState);

        boolean handleMoveTouchEvent(MotionEvent motionEvent);

        boolean handleUpOrCancelTouchEvent(MotionEvent motionEvent);
    }

    /* JADX INFO: Access modifiers changed from: protected */
    /* loaded from: classes4.dex */
    public static abstract class MotionAttributes {
        protected float mAbsOffset;
        protected float mDeltaOffset;
        protected boolean mDir;

        protected abstract boolean init(View view, MotionEvent motionEvent);
    }

    public static String stateToString(int i) {
        return i != 0 ? i != 1 ? i != 2 ? i != 3 ? i != 4 ? EnvironmentCompat.MEDIA_UNKNOWN : "bounceBack" : "dragStartEnd" : "dragStartSlide" : "drag" : "idle";
    }

    protected abstract AnimationAttributes createAnimationAttributes();

    protected abstract MotionAttributes createMotionAttributes();

    protected abstract float getTranslateValue(View view);

    protected abstract void translateView(View view, float f);

    protected abstract void translateViewAndEvent(View view, float f, MotionEvent motionEvent);

    /* JADX INFO: Access modifiers changed from: protected */
    public OverScrollBounceEffectDecoratorBase(IOverScrollDecoratorAdapter iOverScrollDecoratorAdapter, float f, float f2, float f3) {
        this.mViewAdapter = iOverScrollDecoratorAdapter;
        this.mOverScrollingState = new OverScrollingState(f, f2);
        IdleState idleState = new IdleState();
        this.mIdleState = idleState;
        this.mCurrentState = idleState;
        attach();
    }

    @Override // com.pri.support.common.IOverScrollDecor
    public void setEnableOverScrollEffect(boolean z) {
        if (z) {
            attach();
            return;
        }
        deAttach();
        this.mCurrentState = this.mIdleState;
    }

    @Override // android.view.View.OnTouchListener
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

    protected void transitToState(IDecoratorState iDecoratorState) {
        IDecoratorState iDecoratorState2 = this.mCurrentState;
        if (iDecoratorState != iDecoratorState2) {
            this.mCurrentState = iDecoratorState;
            iDecoratorState.handleEntryTransition(iDecoratorState2);
        }
    }

    protected void attach() {
        getView().setOnTouchListener(this);
        getView().setOverScrollMode(2);
    }

    protected void deAttach() {
        getView().setOnTouchListener(null);
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    /* loaded from: classes4.dex */
    public static class OverScrollStartAttributes {
        float mAbsOffset;
        boolean mDir;
        int mPointerId;

        OverScrollStartAttributes() {
        }
    }

    /* loaded from: classes4.dex */
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
                return f2 - (1.0f - ((float) Math.exp(-f2)));
            }
            return ((1.0f - ((float) Math.exp(1.0f - f2))) * 0.63212055f) + 0.36787945f;
        }

        @Override // android.animation.TimeInterpolator
        public float getInterpolation(float f) {
            float viscousFluid = VISCOUS_FLUID_NORMALIZE * viscousFluid(f);
            return viscousFluid > 0.0f ? viscousFluid + VISCOUS_FLUID_OFFSET : viscousFluid;
        }
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    /* loaded from: classes4.dex */
    public class IdleState implements IDecoratorState {
        final MotionAttributes mMoveAttr;
        private float originalOffset = Float.MAX_VALUE;

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.IDecoratorState
        public int getStateId() {
            return 0;
        }

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.IDecoratorState
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

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.IDecoratorState
        public boolean handleMoveTouchEvent(MotionEvent motionEvent) {
            if (this.mMoveAttr.init(OverScrollBounceEffectDecoratorBase.this.getView(), motionEvent)) {
                if (!(OverScrollBounceEffectDecoratorBase.this.mViewAdapter.isInAbsoluteStart() && this.mMoveAttr.mDir) && (!OverScrollBounceEffectDecoratorBase.this.mViewAdapter.isInAbsoluteEnd() || this.mMoveAttr.mDir)) {
                    return false;
                }
                OverScrollBounceEffectDecoratorBase.this.mStartAttr.mPointerId = motionEvent.getPointerId(0);
                OverScrollStartAttributes overScrollStartAttributes = OverScrollBounceEffectDecoratorBase.this.mStartAttr;
                float f = this.mMoveAttr.mAbsOffset;
                overScrollStartAttributes.mAbsOffset = f;
                if (this.originalOffset == Float.MAX_VALUE) {
                    this.originalOffset = f;
                }
                OverScrollBounceEffectDecoratorBase.this.mStartAttr.mDir = this.mMoveAttr.mDir;
                OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase = OverScrollBounceEffectDecoratorBase.this;
                overScrollBounceEffectDecoratorBase.transitToState(overScrollBounceEffectDecoratorBase.mOverScrollingState);
                return OverScrollBounceEffectDecoratorBase.this.mOverScrollingState.handleMoveTouchEvent(motionEvent);
            }
            return false;
        }

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.IDecoratorState
        public void handleEntryTransition(IDecoratorState iDecoratorState) {
            OverScrollBounceEffectDecoratorBase.this.mStateListener.onOverScrollStateChange(OverScrollBounceEffectDecoratorBase.this, iDecoratorState.getStateId(), getStateId());
        }
    }

    /* loaded from: classes4.dex */
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

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.IDecoratorState
        public int getStateId() {
            return this.mCurrDragState;
        }

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.IDecoratorState
        public boolean handleMoveTouchEvent(MotionEvent motionEvent) {
            float max;
            if (OverScrollBounceEffectDecoratorBase.this.mStartAttr.mPointerId != motionEvent.getPointerId(0)) {
                OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase = OverScrollBounceEffectDecoratorBase.this;
                overScrollBounceEffectDecoratorBase.transitToState(overScrollBounceEffectDecoratorBase.mBounceBackState);
                OverScrollBounceEffectDecoratorBase.this.mBounceBackState.mDisableCancelAnimOnMoveEvent = true;
                return true;
            }
            View view = OverScrollBounceEffectDecoratorBase.this.getView();
            if (this.mMoveAttr.init(view, motionEvent)) {
                float height = OverScrollBounceEffectDecoratorBase.this.getView().getHeight() * 0.5f;
                float f = this.mMoveAttr.mDir == OverScrollBounceEffectDecoratorBase.this.mStartAttr.mDir ? this.mTouchDragRatioFwd : this.mTouchDragRatioBck;
                MotionAttributes motionAttributes = this.mMoveAttr;
                float f2 = motionAttributes.mAbsOffset + (motionAttributes.mDeltaOffset / f);
                if (motionAttributes.mDir) {
                    max = Math.min(f2, height);
                } else {
                    max = Math.max(f2, -height);
                }
                if (max != OverScrollBounceEffectDecoratorBase.this.mStartAttr.mAbsOffset && (OverScrollBounceEffectDecoratorBase.this.mStartAttr.mDir == this.mMoveAttr.mDir || ((OverScrollBounceEffectDecoratorBase.this.mStartAttr.mDir && max > OverScrollBounceEffectDecoratorBase.this.mStartAttr.mAbsOffset) || (!OverScrollBounceEffectDecoratorBase.this.mStartAttr.mDir && max < OverScrollBounceEffectDecoratorBase.this.mStartAttr.mAbsOffset)))) {
                    if (view.getParent() != null) {
                        view.getParent().requestDisallowInterceptTouchEvent(true);
                    }
                    OverScrollBounceEffectDecoratorBase.this.translateView(view, max);
                    OverScrollBounceEffectDecoratorBase.this.mUpdateListener.onOverScrollUpdate(OverScrollBounceEffectDecoratorBase.this, this.mCurrDragState, max);
                    return true;
                }
                OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase2 = OverScrollBounceEffectDecoratorBase.this;
                overScrollBounceEffectDecoratorBase2.translateViewAndEvent(view, overScrollBounceEffectDecoratorBase2.mStartAttr.mAbsOffset, motionEvent);
                OverScrollBounceEffectDecoratorBase.this.mUpdateListener.onOverScrollUpdate(OverScrollBounceEffectDecoratorBase.this, this.mCurrDragState, 0.0f);
                OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase3 = OverScrollBounceEffectDecoratorBase.this;
                overScrollBounceEffectDecoratorBase3.transitToState(overScrollBounceEffectDecoratorBase3.mIdleState);
                return true;
            }
            return true;
        }

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.IDecoratorState
        public boolean handleUpOrCancelTouchEvent(MotionEvent motionEvent) {
            OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase = OverScrollBounceEffectDecoratorBase.this;
            overScrollBounceEffectDecoratorBase.transitToState(overScrollBounceEffectDecoratorBase.mBounceBackState);
            return false;
        }

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.IDecoratorState
        public void handleEntryTransition(IDecoratorState iDecoratorState) {
            this.mCurrDragState = OverScrollBounceEffectDecoratorBase.this.mStartAttr.mDir ? 2 : 3;
            OverScrollBounceEffectDecoratorBase.this.mStateListener.onOverScrollStateChange(OverScrollBounceEffectDecoratorBase.this, iDecoratorState.getStateId(), getStateId());
        }
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    /* loaded from: classes4.dex */
    public class BounceBackState extends SimpleSpringListener implements IDecoratorState {
        final AnimationAttributes mAnimAttributes;
        boolean mDisableCancelAnimOnMoveEvent;
        private final Spring mSpring;
        private final SpringSystem mSpringSystem;

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.IDecoratorState
        public int getStateId() {
            return 4;
        }

        BounceBackState() {
            this.mAnimAttributes = OverScrollBounceEffectDecoratorBase.this.createAnimationAttributes();
            SpringSystem create = SpringSystem.create();
            this.mSpringSystem = create;
            this.mSpring = create.createSpring().addListener(this);
        }

        boolean startSpringBack(boolean z) {
            this.mAnimAttributes.init(OverScrollBounceEffectDecoratorBase.this.getView());
            if (((int) this.mAnimAttributes.mAbsOffset) != ((int) OverScrollBounceEffectDecoratorBase.this.mIdleState.originalOffset)) {
                this.mSpring.setSpringConfig(SpringOverScroller.RUBBERBANDING_CONFIG);
                this.mSpring.setCurrentValue(this.mAnimAttributes.mAbsOffset, z);
                this.mSpring.setEndValue(OverScrollBounceEffectDecoratorBase.this.mIdleState.originalOffset);
                return true;
            }
            return false;
        }

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.IDecoratorState
        public void handleEntryTransition(IDecoratorState iDecoratorState) {
            OverScrollBounceEffectDecoratorBase.this.mStateListener.onOverScrollStateChange(OverScrollBounceEffectDecoratorBase.this, iDecoratorState.getStateId(), getStateId());
            if (startSpringBack(true)) {
                return;
            }
            OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase = OverScrollBounceEffectDecoratorBase.this;
            overScrollBounceEffectDecoratorBase.transitToState(overScrollBounceEffectDecoratorBase.mIdleState);
        }

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.IDecoratorState
        public boolean handleMoveTouchEvent(MotionEvent motionEvent) {
            if (this.mDisableCancelAnimOnMoveEvent || this.mSpring.isAtRest()) {
                return true;
            }
            this.mSpring.setAtRest();
            return true;
        }

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.IDecoratorState
        public boolean handleUpOrCancelTouchEvent(MotionEvent motionEvent) {
            this.mDisableCancelAnimOnMoveEvent = false;
            return true;
        }

        @Override // com.pri.anim.spring.SimpleSpringListener, com.pri.anim.spring.SpringListener
        public void onSpringUpdate(Spring spring) {
            float currentValue = (float) spring.getCurrentValue();
            OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase = OverScrollBounceEffectDecoratorBase.this;
            overScrollBounceEffectDecoratorBase.translateView(overScrollBounceEffectDecoratorBase.getView(), currentValue);
            OverScrollBounceEffectDecoratorBase.this.mUpdateListener.onOverScrollUpdate(OverScrollBounceEffectDecoratorBase.this, getStateId(), currentValue);
        }

        @Override // com.pri.anim.spring.SimpleSpringListener, com.pri.anim.spring.SpringListener
        public void onSpringAtRest(Spring spring) {
            OverScrollBounceEffectDecoratorBase overScrollBounceEffectDecoratorBase = OverScrollBounceEffectDecoratorBase.this;
            overScrollBounceEffectDecoratorBase.transitToState(overScrollBounceEffectDecoratorBase.mIdleState);
        }
    }
}
