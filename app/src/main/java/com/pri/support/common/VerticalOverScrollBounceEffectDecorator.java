package com.pri.support.common;

import android.view.MotionEvent;
import android.view.View;
import com.pri.support.common.OverScrollBounceEffectDecoratorBase;
import com.pri.support.common.adapters.IOverScrollDecoratorAdapter;
/* loaded from: classes4.dex */
public class VerticalOverScrollBounceEffectDecorator extends OverScrollBounceEffectDecoratorBase {
    private static final float DRAG_BACK_RATIO = 1.0f;
    private static final float DRAG_FWD_RATIO = 1.5f;

    public VerticalOverScrollBounceEffectDecorator(IOverScrollDecoratorAdapter iOverScrollDecoratorAdapter) {
        this(iOverScrollDecoratorAdapter, DRAG_FWD_RATIO, 1.0f, 0.0f);
    }

    public VerticalOverScrollBounceEffectDecorator(IOverScrollDecoratorAdapter iOverScrollDecoratorAdapter, float f, float f2, float f3) {
        super(iOverScrollDecoratorAdapter, f, f2, f3);
    }

    @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase
    public OverScrollBounceEffectDecoratorBase.MotionAttributes createMotionAttributes() {
        return new MotionAttributesVertical();
    }

    @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase
    protected float getTranslateValue(View view) {
        return view.getTranslationY();
    }

    @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase
    public OverScrollBounceEffectDecoratorBase.AnimationAttributes createAnimationAttributes() {
        return new AnimationAttributesVertical();
    }

    @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase
    public void translateView(View view, float f) {
        view.setTranslationY(f);
    }

    @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase
    public void translateViewAndEvent(View view, float f, MotionEvent motionEvent) {
        view.setTranslationY(f);
        motionEvent.offsetLocation(0.0f, f - motionEvent.getY(0));
    }

    /* loaded from: classes4.dex */
    protected static class MotionAttributesVertical extends OverScrollBounceEffectDecoratorBase.MotionAttributes {
        protected MotionAttributesVertical() {
        }

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.MotionAttributes
        public boolean init(View view, MotionEvent motionEvent) {
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
            this.mDir = y > 0.0f;
            return true;
        }
    }

    /* loaded from: classes4.dex */
    protected static class AnimationAttributesVertical extends OverScrollBounceEffectDecoratorBase.AnimationAttributes {
        AnimationAttributesVertical() {
            this.mProperty = View.TRANSLATION_Y;
        }

        @Override // com.pri.support.common.OverScrollBounceEffectDecoratorBase.AnimationAttributes
        public void init(View view) {
            this.mAbsOffset = view.getTranslationY();
            this.mMaxOffset = view.getHeight();
        }
    }
}
