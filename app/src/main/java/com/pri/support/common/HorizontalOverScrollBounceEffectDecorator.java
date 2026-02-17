package com.pri.support.common;

import android.view.MotionEvent;
import android.view.View;
import com.pri.support.common.OverScrollBounceEffectDecoratorBase;
import com.pri.support.common.adapters.IOverScrollDecoratorAdapter;

public class HorizontalOverScrollBounceEffectDecorator extends OverScrollBounceEffectDecoratorBase {
    private static final float DRAG_BACK_RATIO = 1.0f;
    private static final float DRAG_FWD_RATIO = 2.85f;

    public HorizontalOverScrollBounceEffectDecorator(IOverScrollDecoratorAdapter iOverScrollDecoratorAdapter) {
        this(iOverScrollDecoratorAdapter, DRAG_FWD_RATIO, 1.0f, 0.0f);
    }

    public HorizontalOverScrollBounceEffectDecorator(IOverScrollDecoratorAdapter iOverScrollDecoratorAdapter, float f, float f2, float f3) {
        super(iOverScrollDecoratorAdapter, f, f2, f3);
    }

    public OverScrollBounceEffectDecoratorBase.MotionAttributes createMotionAttributes() {
        return new MotionAttributesHorizontal();
    }

    /* access modifiers changed from: protected */
    public float getTranslateValue(View view) {
        return view.getTranslationX();
    }

    public OverScrollBounceEffectDecoratorBase.AnimationAttributes createAnimationAttributes() {
        return new AnimationAttributesHorizontal();
    }

    public void translateView(View view, float f) {
        view.setTranslationX(f);
    }

    public void translateViewAndEvent(View view, float f, MotionEvent motionEvent) {
        view.setTranslationX(f);
        motionEvent.offsetLocation(f - motionEvent.getX(0), 0.0f);
    }

    protected static class MotionAttributesHorizontal extends OverScrollBounceEffectDecoratorBase.MotionAttributes {
        MotionAttributesHorizontal() {
        }

        public boolean init(View view, MotionEvent motionEvent) {
            boolean z = false;
            if (motionEvent.getHistorySize() == 0) {
                return false;
            }
            float x = motionEvent.getX(0) - motionEvent.getHistoricalX(0, 0);
            if (Math.abs(x) < Math.abs(motionEvent.getY(0) - motionEvent.getHistoricalY(0, 0))) {
                return false;
            }
            this.mAbsOffset = view.getTranslationX();
            this.mDeltaOffset = x;
            if (x > 0.0f) {
                z = true;
            }
            this.mDir = z;
            return true;
        }
    }

    protected static class AnimationAttributesHorizontal extends OverScrollBounceEffectDecoratorBase.AnimationAttributes {
        AnimationAttributesHorizontal() {
            this.mProperty = View.TRANSLATION_X;
        }

        public void init(View view) {
            this.mAbsOffset = view.getTranslationX();
            this.mMaxOffset = (float) view.getWidth();
        }
    }
}
