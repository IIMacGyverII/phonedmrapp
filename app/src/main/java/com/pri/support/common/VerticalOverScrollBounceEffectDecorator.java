package com.pri.support.common;

import android.view.MotionEvent;
import android.view.View;
import com.pri.support.common.OverScrollBounceEffectDecoratorBase;
import com.pri.support.common.adapters.IOverScrollDecoratorAdapter;

public class VerticalOverScrollBounceEffectDecorator extends OverScrollBounceEffectDecoratorBase {
    private static final float DRAG_BACK_RATIO = 1.0f;
    private static final float DRAG_FWD_RATIO = 1.5f;

    public VerticalOverScrollBounceEffectDecorator(IOverScrollDecoratorAdapter iOverScrollDecoratorAdapter) {
        this(iOverScrollDecoratorAdapter, DRAG_FWD_RATIO, 1.0f, 0.0f);
    }

    public VerticalOverScrollBounceEffectDecorator(IOverScrollDecoratorAdapter iOverScrollDecoratorAdapter, float f, float f2, float f3) {
        super(iOverScrollDecoratorAdapter, f, f2, f3);
    }

    public OverScrollBounceEffectDecoratorBase.MotionAttributes createMotionAttributes() {
        return new MotionAttributesVertical();
    }

    /* access modifiers changed from: protected */
    public float getTranslateValue(View view) {
        return view.getTranslationY();
    }

    public OverScrollBounceEffectDecoratorBase.AnimationAttributes createAnimationAttributes() {
        return new AnimationAttributesVertical();
    }

    public void translateView(View view, float f) {
        view.setTranslationY(f);
    }

    public void translateViewAndEvent(View view, float f, MotionEvent motionEvent) {
        view.setTranslationY(f);
        motionEvent.offsetLocation(0.0f, f - motionEvent.getY(0));
    }

    protected static class MotionAttributesVertical extends OverScrollBounceEffectDecoratorBase.MotionAttributes {
        protected MotionAttributesVertical() {
        }

        public boolean init(View view, MotionEvent motionEvent) {
            boolean z = false;
            if (motionEvent.getHistorySize() == 0) {
                return false;
            }
            float x = motionEvent.getX(0) - motionEvent.getHistoricalX(0, 0);
            float y = motionEvent.getY(0) - motionEvent.getHistoricalY(0, 0);
            if (Math.abs(x) > Math.abs(y)) {
                return false;
            }
            this.mAbsOffset = view.getTranslationY();
            this.mDeltaOffset = y;
            if (y > 0.0f) {
                z = true;
            }
            this.mDir = z;
            return true;
        }
    }

    protected static class AnimationAttributesVertical extends OverScrollBounceEffectDecoratorBase.AnimationAttributes {
        AnimationAttributesVertical() {
            this.mProperty = View.TRANSLATION_Y;
        }

        public void init(View view) {
            this.mAbsOffset = view.getTranslationY();
            this.mMaxOffset = (float) view.getHeight();
        }
    }
}
