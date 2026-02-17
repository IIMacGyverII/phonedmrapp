package androidx.dynamicanimation.animation;

import androidx.annotation.FloatRange;
import androidx.dynamicanimation.animation.DynamicAnimation;

public final class FlingAnimation extends DynamicAnimation<FlingAnimation> {
    private final DragForce mFlingForce;

    public FlingAnimation(FloatValueHolder floatValueHolder) {
        super(floatValueHolder);
        DragForce dragForce = new DragForce();
        this.mFlingForce = dragForce;
        dragForce.setValueThreshold(getValueThreshold());
    }

    public <K> FlingAnimation(K k, FloatPropertyCompat<K> floatPropertyCompat) {
        super(k, floatPropertyCompat);
        DragForce dragForce = new DragForce();
        this.mFlingForce = dragForce;
        dragForce.setValueThreshold(getValueThreshold());
    }

    public FlingAnimation setFriction(@FloatRange(from = 0.0d, fromInclusive = false) float f) {
        if (f > 0.0f) {
            this.mFlingForce.setFrictionScalar(f);
            return this;
        }
        throw new IllegalArgumentException("Friction must be positive");
    }

    public float getFriction() {
        return this.mFlingForce.getFrictionScalar();
    }

    public FlingAnimation setMinValue(float f) {
        super.setMinValue(f);
        return this;
    }

    public FlingAnimation setMaxValue(float f) {
        super.setMaxValue(f);
        return this;
    }

    public FlingAnimation setStartVelocity(float f) {
        super.setStartVelocity(f);
        return this;
    }

    /* access modifiers changed from: package-private */
    public boolean updateValueAndVelocity(long j) {
        DynamicAnimation.MassState updateValueAndVelocity = this.mFlingForce.updateValueAndVelocity(this.mValue, this.mVelocity, j);
        float f = updateValueAndVelocity.mValue;
        this.mValue = f;
        float f2 = updateValueAndVelocity.mVelocity;
        this.mVelocity = f2;
        float f3 = this.mMinValue;
        if (f < f3) {
            this.mValue = f3;
            return true;
        }
        float f4 = this.mMaxValue;
        if (f > f4) {
            this.mValue = f4;
            return true;
        } else if (isAtEquilibrium(f, f2)) {
            return true;
        } else {
            return false;
        }
    }

    /* access modifiers changed from: package-private */
    public float getAcceleration(float f, float f2) {
        return this.mFlingForce.getAcceleration(f, f2);
    }

    /* access modifiers changed from: package-private */
    public boolean isAtEquilibrium(float f, float f2) {
        return f >= this.mMaxValue || f <= this.mMinValue || this.mFlingForce.isAtEquilibrium(f, f2);
    }

    /* access modifiers changed from: package-private */
    public void setValueThreshold(float f) {
        this.mFlingForce.setValueThreshold(f);
    }

    static final class DragForce implements Force {
        private static final float DEFAULT_FRICTION = -4.2f;
        private static final float VELOCITY_THRESHOLD_MULTIPLIER = 62.5f;
        private float mFriction = DEFAULT_FRICTION;
        private final DynamicAnimation.MassState mMassState = new DynamicAnimation.MassState();
        private float mVelocityThreshold;

        DragForce() {
        }

        /* access modifiers changed from: package-private */
        public void setFrictionScalar(float f) {
            this.mFriction = f * DEFAULT_FRICTION;
        }

        /* access modifiers changed from: package-private */
        public float getFrictionScalar() {
            return this.mFriction / DEFAULT_FRICTION;
        }

        /* access modifiers changed from: package-private */
        public DynamicAnimation.MassState updateValueAndVelocity(float f, float f2, long j) {
            this.mMassState.mVelocity = (float) (((double) f2) * Math.exp((double) ((((float) j) / 1000.0f) * this.mFriction)));
            DynamicAnimation.MassState massState = this.mMassState;
            float f3 = massState.mVelocity;
            float f4 = f + ((f3 - f2) / this.mFriction);
            massState.mValue = f4;
            if (isAtEquilibrium(f4, f3)) {
                this.mMassState.mVelocity = 0.0f;
            }
            return this.mMassState;
        }

        public float getAcceleration(float f, float f2) {
            return f2 * this.mFriction;
        }

        public boolean isAtEquilibrium(float f, float f2) {
            return Math.abs(f2) < this.mVelocityThreshold;
        }

        /* access modifiers changed from: package-private */
        public void setValueThreshold(float f) {
            this.mVelocityThreshold = f * VELOCITY_THRESHOLD_MULTIPLIER;
        }
    }
}
