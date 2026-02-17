package androidx.core.view;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ValueAnimator;
import android.annotation.SuppressLint;
import android.view.View;
import android.view.ViewPropertyAnimator;
import android.view.animation.Interpolator;
import androidx.annotation.DoNotInline;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import java.lang.ref.WeakReference;

public final class ViewPropertyAnimatorCompat {
    static final int LISTENER_TAG_ID = 2113929216;
    Runnable mEndAction = null;
    int mOldLayerType = -1;
    Runnable mStartAction = null;
    private final WeakReference<View> mView;

    ViewPropertyAnimatorCompat(View view) {
        this.mView = new WeakReference<>(view);
    }

    static class ViewPropertyAnimatorListenerApi14 implements ViewPropertyAnimatorListener {
        boolean mAnimEndCalled;
        ViewPropertyAnimatorCompat mVpa;

        ViewPropertyAnimatorListenerApi14(ViewPropertyAnimatorCompat viewPropertyAnimatorCompat) {
            this.mVpa = viewPropertyAnimatorCompat;
        }

        /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r3v3, resolved type: java.lang.Object} */
        /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r1v2, resolved type: androidx.core.view.ViewPropertyAnimatorListener} */
        /* JADX WARNING: Multi-variable type inference failed */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public void onAnimationStart(@androidx.annotation.NonNull android.view.View r4) {
            /*
                r3 = this;
                r0 = 0
                r3.mAnimEndCalled = r0
                androidx.core.view.ViewPropertyAnimatorCompat r0 = r3.mVpa
                int r0 = r0.mOldLayerType
                r1 = 0
                r2 = -1
                if (r0 <= r2) goto L_0x000f
                r0 = 2
                r4.setLayerType(r0, r1)
            L_0x000f:
                androidx.core.view.ViewPropertyAnimatorCompat r3 = r3.mVpa
                java.lang.Runnable r0 = r3.mStartAction
                if (r0 == 0) goto L_0x001a
                r3.mStartAction = r1
                r0.run()
            L_0x001a:
                r3 = 2113929216(0x7e000000, float:4.2535296E37)
                java.lang.Object r3 = r4.getTag(r3)
                boolean r0 = r3 instanceof androidx.core.view.ViewPropertyAnimatorListener
                if (r0 == 0) goto L_0x0027
                r1 = r3
                androidx.core.view.ViewPropertyAnimatorListener r1 = (androidx.core.view.ViewPropertyAnimatorListener) r1
            L_0x0027:
                if (r1 == 0) goto L_0x002c
                r1.onAnimationStart(r4)
            L_0x002c:
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: androidx.core.view.ViewPropertyAnimatorCompat.ViewPropertyAnimatorListenerApi14.onAnimationStart(android.view.View):void");
        }

        /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r0v4, resolved type: java.lang.Object} */
        /* JADX DEBUG: Multi-variable search result rejected for TypeSearchVarInfo{r2v2, resolved type: androidx.core.view.ViewPropertyAnimatorListener} */
        /* JADX WARNING: Multi-variable type inference failed */
        @android.annotation.SuppressLint({"WrongConstant"})
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public void onAnimationEnd(@androidx.annotation.NonNull android.view.View r4) {
            /*
                r3 = this;
                androidx.core.view.ViewPropertyAnimatorCompat r0 = r3.mVpa
                int r0 = r0.mOldLayerType
                r1 = -1
                r2 = 0
                if (r0 <= r1) goto L_0x000f
                r4.setLayerType(r0, r2)
                androidx.core.view.ViewPropertyAnimatorCompat r0 = r3.mVpa
                r0.mOldLayerType = r1
            L_0x000f:
                androidx.core.view.ViewPropertyAnimatorCompat r0 = r3.mVpa
                java.lang.Runnable r1 = r0.mEndAction
                if (r1 == 0) goto L_0x001a
                r0.mEndAction = r2
                r1.run()
            L_0x001a:
                r0 = 2113929216(0x7e000000, float:4.2535296E37)
                java.lang.Object r0 = r4.getTag(r0)
                boolean r1 = r0 instanceof androidx.core.view.ViewPropertyAnimatorListener
                if (r1 == 0) goto L_0x0027
                r2 = r0
                androidx.core.view.ViewPropertyAnimatorListener r2 = (androidx.core.view.ViewPropertyAnimatorListener) r2
            L_0x0027:
                if (r2 == 0) goto L_0x002c
                r2.onAnimationEnd(r4)
            L_0x002c:
                r4 = 1
                r3.mAnimEndCalled = r4
                return
            */
            throw new UnsupportedOperationException("Method not decompiled: androidx.core.view.ViewPropertyAnimatorCompat.ViewPropertyAnimatorListenerApi14.onAnimationEnd(android.view.View):void");
        }

        public void onAnimationCancel(@NonNull View view) {
            Object tag = view.getTag(ViewPropertyAnimatorCompat.LISTENER_TAG_ID);
            ViewPropertyAnimatorListener viewPropertyAnimatorListener = tag instanceof ViewPropertyAnimatorListener ? (ViewPropertyAnimatorListener) tag : null;
            if (viewPropertyAnimatorListener != null) {
                viewPropertyAnimatorListener.onAnimationCancel(view);
            }
        }
    }

    @NonNull
    public ViewPropertyAnimatorCompat setDuration(long j) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().setDuration(j);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat alpha(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().alpha(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat alphaBy(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().alphaBy(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat translationX(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().translationX(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat translationY(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().translationY(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat withEndAction(@NonNull Runnable runnable) {
        View view = (View) this.mView.get();
        if (view != null) {
            Api16Impl.withEndAction(view.animate(), runnable);
        }
        return this;
    }

    public long getDuration() {
        View view = (View) this.mView.get();
        if (view != null) {
            return view.animate().getDuration();
        }
        return 0;
    }

    @NonNull
    public ViewPropertyAnimatorCompat setInterpolator(@Nullable Interpolator interpolator) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().setInterpolator(interpolator);
        }
        return this;
    }

    @Nullable
    public Interpolator getInterpolator() {
        View view = (View) this.mView.get();
        if (view != null) {
            return Api18Impl.getInterpolator(view.animate());
        }
        return null;
    }

    @NonNull
    public ViewPropertyAnimatorCompat setStartDelay(long j) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().setStartDelay(j);
        }
        return this;
    }

    public long getStartDelay() {
        View view = (View) this.mView.get();
        if (view != null) {
            return view.animate().getStartDelay();
        }
        return 0;
    }

    @NonNull
    public ViewPropertyAnimatorCompat rotation(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().rotation(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat rotationBy(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().rotationBy(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat rotationX(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().rotationX(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat rotationXBy(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().rotationXBy(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat rotationY(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().rotationY(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat rotationYBy(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().rotationYBy(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat scaleX(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().scaleX(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat scaleXBy(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().scaleXBy(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat scaleY(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().scaleY(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat scaleYBy(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().scaleYBy(f);
        }
        return this;
    }

    public void cancel() {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().cancel();
        }
    }

    @NonNull
    public ViewPropertyAnimatorCompat x(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().x(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat xBy(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().xBy(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat y(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().y(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat yBy(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().yBy(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat translationXBy(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().translationXBy(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat translationYBy(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().translationYBy(f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat translationZBy(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            Api21Impl.translationZBy(view.animate(), f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat translationZ(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            Api21Impl.translationZ(view.animate(), f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat z(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            Api21Impl.z(view.animate(), f);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat zBy(float f) {
        View view = (View) this.mView.get();
        if (view != null) {
            Api21Impl.zBy(view.animate(), f);
        }
        return this;
    }

    public void start() {
        View view = (View) this.mView.get();
        if (view != null) {
            view.animate().start();
        }
    }

    @SuppressLint({"WrongConstant"})
    @NonNull
    public ViewPropertyAnimatorCompat withLayer() {
        View view = (View) this.mView.get();
        if (view != null) {
            Api16Impl.withLayer(view.animate());
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat withStartAction(@NonNull Runnable runnable) {
        View view = (View) this.mView.get();
        if (view != null) {
            Api16Impl.withStartAction(view.animate(), runnable);
        }
        return this;
    }

    @NonNull
    public ViewPropertyAnimatorCompat setListener(@Nullable ViewPropertyAnimatorListener viewPropertyAnimatorListener) {
        View view = (View) this.mView.get();
        if (view != null) {
            setListenerInternal(view, viewPropertyAnimatorListener);
        }
        return this;
    }

    private void setListenerInternal(final View view, final ViewPropertyAnimatorListener viewPropertyAnimatorListener) {
        if (viewPropertyAnimatorListener != null) {
            view.animate().setListener(new AnimatorListenerAdapter() {
                public void onAnimationCancel(Animator animator) {
                    viewPropertyAnimatorListener.onAnimationCancel(view);
                }

                public void onAnimationEnd(Animator animator) {
                    viewPropertyAnimatorListener.onAnimationEnd(view);
                }

                public void onAnimationStart(Animator animator) {
                    viewPropertyAnimatorListener.onAnimationStart(view);
                }
            });
        } else {
            view.animate().setListener((Animator.AnimatorListener) null);
        }
    }

    @NonNull
    public ViewPropertyAnimatorCompat setUpdateListener(@Nullable ViewPropertyAnimatorUpdateListener viewPropertyAnimatorUpdateListener) {
        View view = (View) this.mView.get();
        if (view != null) {
            ViewPropertyAnimatorCompat$$ExternalSyntheticLambda0 viewPropertyAnimatorCompat$$ExternalSyntheticLambda0 = null;
            if (viewPropertyAnimatorUpdateListener != null) {
                viewPropertyAnimatorCompat$$ExternalSyntheticLambda0 = new ViewPropertyAnimatorCompat$$ExternalSyntheticLambda0(viewPropertyAnimatorUpdateListener, view);
            }
            Api19Impl.setUpdateListener(view.animate(), viewPropertyAnimatorCompat$$ExternalSyntheticLambda0);
        }
        return this;
    }

    @RequiresApi(16)
    static class Api16Impl {
        private Api16Impl() {
        }

        @DoNotInline
        static ViewPropertyAnimator withEndAction(ViewPropertyAnimator viewPropertyAnimator, Runnable runnable) {
            return viewPropertyAnimator.withEndAction(runnable);
        }

        @DoNotInline
        static ViewPropertyAnimator withLayer(ViewPropertyAnimator viewPropertyAnimator) {
            return viewPropertyAnimator.withLayer();
        }

        @DoNotInline
        static ViewPropertyAnimator withStartAction(ViewPropertyAnimator viewPropertyAnimator, Runnable runnable) {
            return viewPropertyAnimator.withStartAction(runnable);
        }
    }

    @RequiresApi(18)
    static class Api18Impl {
        private Api18Impl() {
        }

        @DoNotInline
        static Interpolator getInterpolator(ViewPropertyAnimator viewPropertyAnimator) {
            return (Interpolator) viewPropertyAnimator.getInterpolator();
        }
    }

    @RequiresApi(21)
    static class Api21Impl {
        private Api21Impl() {
        }

        @DoNotInline
        static ViewPropertyAnimator translationZBy(ViewPropertyAnimator viewPropertyAnimator, float f) {
            return viewPropertyAnimator.translationZBy(f);
        }

        @DoNotInline
        static ViewPropertyAnimator translationZ(ViewPropertyAnimator viewPropertyAnimator, float f) {
            return viewPropertyAnimator.translationZ(f);
        }

        @DoNotInline
        static ViewPropertyAnimator z(ViewPropertyAnimator viewPropertyAnimator, float f) {
            return viewPropertyAnimator.z(f);
        }

        @DoNotInline
        static ViewPropertyAnimator zBy(ViewPropertyAnimator viewPropertyAnimator, float f) {
            return viewPropertyAnimator.zBy(f);
        }
    }

    @RequiresApi(19)
    static class Api19Impl {
        private Api19Impl() {
        }

        @DoNotInline
        static ViewPropertyAnimator setUpdateListener(ViewPropertyAnimator viewPropertyAnimator, ValueAnimator.AnimatorUpdateListener animatorUpdateListener) {
            return viewPropertyAnimator.setUpdateListener(animatorUpdateListener);
        }
    }
}
