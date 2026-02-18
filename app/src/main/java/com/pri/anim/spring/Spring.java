package com.pri.anim.spring;

import java.util.Iterator;
import java.util.concurrent.CopyOnWriteArraySet;
/* loaded from: classes4.dex */
public class Spring {
    private static int ID = 0;
    private static final double MAX_DELTA_TIME_SEC = 0.064d;
    private static final double SOLVER_TIMESTEP_SEC = 0.001d;
    private double mEndValue;
    private final String mId;
    private boolean mOvershootClampingEnabled;
    private SpringConfig mSpringConfig;
    private final BaseSpringSystem mSpringSystem;
    private double mStartValue;
    private final PhysicsState mCurrentState = new PhysicsState();
    private final PhysicsState mPreviousState = new PhysicsState();
    private final PhysicsState mTempState = new PhysicsState();
    private boolean mWasAtRest = true;
    private double mRestSpeedThreshold = 0.005d;
    private double mDisplacementFromRestThreshold = 0.005d;
    private CopyOnWriteArraySet<SpringListener> mListeners = new CopyOnWriteArraySet<>();
    private double mTimeAccumulator = 0.0d;

    /* JADX INFO: Access modifiers changed from: private */
    /* loaded from: classes4.dex */
    public static class PhysicsState {
        double position;
        double velocity;

        private PhysicsState() {
        }
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public Spring(BaseSpringSystem baseSpringSystem) {
        if (baseSpringSystem == null) {
            throw new IllegalArgumentException("Spring cannot be created outside of a BaseSpringSystem");
        }
        this.mSpringSystem = baseSpringSystem;
        StringBuilder sb = new StringBuilder();
        sb.append("com.pri.anim.com.pri.anim.spring.com.pri.anim.spring:");
        int i = ID;
        ID = i + 1;
        sb.append(i);
        this.mId = sb.toString();
        setSpringConfig(SpringConfig.defaultConfig);
    }

    public void destroy() {
        this.mListeners.clear();
        this.mSpringSystem.deregisterSpring(this);
    }

    public String getId() {
        return this.mId;
    }

    public Spring setSpringConfig(SpringConfig springConfig) {
        if (springConfig == null) {
            throw new IllegalArgumentException("springConfig is required");
        }
        this.mSpringConfig = springConfig;
        return this;
    }

    public SpringConfig getSpringConfig() {
        return this.mSpringConfig;
    }

    public Spring setCurrentValue(double d) {
        return setCurrentValue(d, true);
    }

    public Spring setCurrentValue(double d, boolean z) {
        this.mStartValue = d;
        this.mCurrentState.position = d;
        this.mSpringSystem.activateSpring(getId());
        Iterator<SpringListener> it = this.mListeners.iterator();
        while (it.hasNext()) {
            it.next().onSpringUpdate(this);
        }
        if (z) {
            setAtRest();
        }
        return this;
    }

    public double getStartValue() {
        return this.mStartValue;
    }

    public double getCurrentValue() {
        return this.mCurrentState.position;
    }

    public double getCurrentDisplacementDistance() {
        return getDisplacementDistanceForState(this.mCurrentState);
    }

    private double getDisplacementDistanceForState(PhysicsState physicsState) {
        return Math.abs(this.mEndValue - physicsState.position);
    }

    public Spring setEndValue(double d) {
        if (this.mEndValue == d && isAtRest()) {
            return this;
        }
        this.mStartValue = getCurrentValue();
        this.mEndValue = d;
        this.mSpringSystem.activateSpring(getId());
        Iterator<SpringListener> it = this.mListeners.iterator();
        while (it.hasNext()) {
            it.next().onSpringEndStateChange(this);
        }
        return this;
    }

    public double getEndValue() {
        return this.mEndValue;
    }

    public Spring setVelocity(double d) {
        PhysicsState physicsState = this.mCurrentState;
        if (d == physicsState.velocity) {
            return this;
        }
        physicsState.velocity = d;
        this.mSpringSystem.activateSpring(getId());
        return this;
    }

    public double getVelocity() {
        return this.mCurrentState.velocity;
    }

    public Spring setRestSpeedThreshold(double d) {
        this.mRestSpeedThreshold = d;
        return this;
    }

    public double getRestSpeedThreshold() {
        return this.mRestSpeedThreshold;
    }

    public Spring setRestDisplacementThreshold(double d) {
        this.mDisplacementFromRestThreshold = d;
        return this;
    }

    public double getRestDisplacementThreshold() {
        return this.mDisplacementFromRestThreshold;
    }

    public Spring setOvershootClampingEnabled(boolean z) {
        this.mOvershootClampingEnabled = z;
        return this;
    }

    public boolean isOvershootClampingEnabled() {
        return this.mOvershootClampingEnabled;
    }

    public boolean isOvershooting() {
        return this.mSpringConfig.tension > 0.0d && ((this.mStartValue < this.mEndValue && getCurrentValue() > this.mEndValue) || (this.mStartValue > this.mEndValue && getCurrentValue() < this.mEndValue));
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public void advance(double d) {
        double d2;
        boolean z;
        boolean z2;
        boolean isAtRest = isAtRest();
        if (isAtRest && this.mWasAtRest) {
            return;
        }
        double d3 = MAX_DELTA_TIME_SEC;
        if (d <= MAX_DELTA_TIME_SEC) {
            d3 = d;
        }
        this.mTimeAccumulator += d3;
        SpringConfig springConfig = this.mSpringConfig;
        double d4 = springConfig.tension;
        double d5 = springConfig.friction;
        PhysicsState physicsState = this.mCurrentState;
        double d6 = physicsState.position;
        double d7 = physicsState.velocity;
        PhysicsState physicsState2 = this.mTempState;
        double d8 = physicsState2.position;
        double d9 = physicsState2.velocity;
        while (true) {
            d2 = this.mTimeAccumulator;
            if (d2 < SOLVER_TIMESTEP_SEC) {
                break;
            }
            double d10 = d2 - SOLVER_TIMESTEP_SEC;
            this.mTimeAccumulator = d10;
            if (d10 < SOLVER_TIMESTEP_SEC) {
                PhysicsState physicsState3 = this.mPreviousState;
                physicsState3.position = d6;
                physicsState3.velocity = d7;
            }
            double d11 = this.mEndValue;
            double d12 = ((d11 - d8) * d4) - (d5 * d7);
            double d13 = d7 + (d12 * SOLVER_TIMESTEP_SEC * 0.5d);
            double d14 = ((d11 - (((d7 * SOLVER_TIMESTEP_SEC) * 0.5d) + d6)) * d4) - (d5 * d13);
            double d15 = d7 + (d14 * SOLVER_TIMESTEP_SEC * 0.5d);
            double d16 = ((d11 - (d6 + ((d13 * SOLVER_TIMESTEP_SEC) * 0.5d))) * d4) - (d5 * d15);
            double d17 = d6 + (d15 * SOLVER_TIMESTEP_SEC);
            double d18 = d7 + (d16 * SOLVER_TIMESTEP_SEC);
            d6 += (d7 + ((d13 + d15) * 2.0d) + d18) * 0.16666666666666666d * SOLVER_TIMESTEP_SEC;
            d7 += (d12 + ((d14 + d16) * 2.0d) + (((d11 - d17) * d4) - (d5 * d18))) * 0.16666666666666666d * SOLVER_TIMESTEP_SEC;
            d8 = d17;
            d9 = d18;
        }
        PhysicsState physicsState4 = this.mTempState;
        physicsState4.position = d8;
        physicsState4.velocity = d9;
        PhysicsState physicsState5 = this.mCurrentState;
        physicsState5.position = d6;
        physicsState5.velocity = d7;
        if (d2 > 0.0d) {
            interpolate(d2 / SOLVER_TIMESTEP_SEC);
        }
        boolean z3 = true;
        if (isAtRest() || (this.mOvershootClampingEnabled && isOvershooting())) {
            if (d4 > 0.0d) {
                double d19 = this.mEndValue;
                this.mStartValue = d19;
                this.mCurrentState.position = d19;
            } else {
                double d20 = this.mCurrentState.position;
                this.mEndValue = d20;
                this.mStartValue = d20;
            }
            setVelocity(0.0d);
            z = true;
        } else {
            z = isAtRest;
        }
        if (this.mWasAtRest) {
            this.mWasAtRest = false;
            z2 = true;
        } else {
            z2 = false;
        }
        if (z) {
            this.mWasAtRest = true;
        } else {
            z3 = false;
        }
        Iterator<SpringListener> it = this.mListeners.iterator();
        while (it.hasNext()) {
            SpringListener next = it.next();
            if (z2) {
                next.onSpringActivate(this);
            }
            next.onSpringUpdate(this);
            if (z3) {
                next.onSpringAtRest(this);
            }
        }
    }

    public boolean systemShouldAdvance() {
        return (isAtRest() && wasAtRest()) ? false : true;
    }

    public boolean wasAtRest() {
        return this.mWasAtRest;
    }

    public boolean isAtRest() {
        return Math.abs(this.mCurrentState.velocity) <= this.mRestSpeedThreshold && (getDisplacementDistanceForState(this.mCurrentState) <= this.mDisplacementFromRestThreshold || this.mSpringConfig.tension == 0.0d);
    }

    public Spring setAtRest() {
        PhysicsState physicsState = this.mCurrentState;
        double d = physicsState.position;
        this.mEndValue = d;
        this.mTempState.position = d;
        physicsState.velocity = 0.0d;
        return this;
    }

    private void interpolate(double d) {
        PhysicsState physicsState = this.mCurrentState;
        PhysicsState physicsState2 = this.mPreviousState;
        double d2 = 1.0d - d;
        physicsState.position = (physicsState.position * d) + (physicsState2.position * d2);
        physicsState.velocity = (physicsState.velocity * d) + (physicsState2.velocity * d2);
    }

    public Spring addListener(SpringListener springListener) {
        if (springListener == null) {
            throw new IllegalArgumentException("newListener is required");
        }
        this.mListeners.add(springListener);
        return this;
    }

    public Spring removeListener(SpringListener springListener) {
        if (springListener == null) {
            throw new IllegalArgumentException("listenerToRemove is required");
        }
        this.mListeners.remove(springListener);
        return this;
    }

    public Spring removeAllListeners() {
        this.mListeners.clear();
        return this;
    }

    public boolean currentValueIsApproximately(double d) {
        return Math.abs(getCurrentValue() - d) <= getRestDisplacementThreshold();
    }
}
