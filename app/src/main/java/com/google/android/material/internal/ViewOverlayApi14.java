package com.google.android.material.internal;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;
import androidx.core.view.ViewCompat;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;

class ViewOverlayApi14 implements ViewOverlayImpl {
    protected OverlayViewGroup overlayViewGroup;

    ViewOverlayApi14(Context context, ViewGroup viewGroup, View view) {
        this.overlayViewGroup = new OverlayViewGroup(context, viewGroup, view, this);
    }

    static ViewOverlayApi14 createFrom(View view) {
        ViewGroup contentView = ViewUtils.getContentView(view);
        if (contentView == null) {
            return null;
        }
        int childCount = contentView.getChildCount();
        for (int i = 0; i < childCount; i++) {
            View childAt = contentView.getChildAt(i);
            if (childAt instanceof OverlayViewGroup) {
                return ((OverlayViewGroup) childAt).viewOverlay;
            }
        }
        return new ViewGroupOverlayApi14(contentView.getContext(), contentView, view);
    }

    public void add(@NonNull Drawable drawable) {
        this.overlayViewGroup.add(drawable);
    }

    public void remove(@NonNull Drawable drawable) {
        this.overlayViewGroup.remove(drawable);
    }

    @SuppressLint({"ViewConstructor", "PrivateApi"})
    static class OverlayViewGroup extends ViewGroup {
        static Method invalidateChildInParentFastMethod;
        private boolean disposed;
        ArrayList<Drawable> drawables = null;
        ViewGroup hostView;
        View requestingView;
        ViewOverlayApi14 viewOverlay;

        public boolean dispatchTouchEvent(MotionEvent motionEvent) {
            return false;
        }

        /* access modifiers changed from: protected */
        public void onLayout(boolean z, int i, int i2, int i3, int i4) {
        }

        static {
            Class<ViewGroup> cls = ViewGroup.class;
            try {
                Class cls2 = Integer.TYPE;
                invalidateChildInParentFastMethod = cls.getDeclaredMethod("invalidateChildInParentFast", new Class[]{cls2, cls2, Rect.class});
            } catch (NoSuchMethodException unused) {
            }
        }

        OverlayViewGroup(Context context, ViewGroup viewGroup, View view, ViewOverlayApi14 viewOverlayApi14) {
            super(context);
            this.hostView = viewGroup;
            this.requestingView = view;
            setRight(viewGroup.getWidth());
            setBottom(viewGroup.getHeight());
            viewGroup.addView(this);
            this.viewOverlay = viewOverlayApi14;
        }

        public void add(Drawable drawable) {
            assertNotDisposed();
            if (this.drawables == null) {
                this.drawables = new ArrayList<>();
            }
            if (!this.drawables.contains(drawable)) {
                this.drawables.add(drawable);
                invalidate(drawable.getBounds());
                drawable.setCallback(this);
            }
        }

        public void remove(Drawable drawable) {
            ArrayList<Drawable> arrayList = this.drawables;
            if (arrayList != null) {
                arrayList.remove(drawable);
                invalidate(drawable.getBounds());
                drawable.setCallback((Drawable.Callback) null);
                disposeIfEmpty();
            }
        }

        /* access modifiers changed from: protected */
        /* JADX WARNING: Code restructure failed: missing block: B:2:0x0006, code lost:
            r1 = r1.drawables;
         */
        /* Code decompiled incorrectly, please refer to instructions dump. */
        public boolean verifyDrawable(@androidx.annotation.NonNull android.graphics.drawable.Drawable r2) {
            /*
                r1 = this;
                boolean r0 = super.verifyDrawable(r2)
                if (r0 != 0) goto L_0x0013
                java.util.ArrayList<android.graphics.drawable.Drawable> r1 = r1.drawables
                if (r1 == 0) goto L_0x0011
                boolean r1 = r1.contains(r2)
                if (r1 == 0) goto L_0x0011
                goto L_0x0013
            L_0x0011:
                r1 = 0
                goto L_0x0014
            L_0x0013:
                r1 = 1
            L_0x0014:
                return r1
            */
            throw new UnsupportedOperationException("Method not decompiled: com.google.android.material.internal.ViewOverlayApi14.OverlayViewGroup.verifyDrawable(android.graphics.drawable.Drawable):boolean");
        }

        public void add(View view) {
            assertNotDisposed();
            if (view.getParent() instanceof ViewGroup) {
                ViewGroup viewGroup = (ViewGroup) view.getParent();
                if (!(viewGroup == this.hostView || viewGroup.getParent() == null || !ViewCompat.isAttachedToWindow(viewGroup))) {
                    int[] iArr = new int[2];
                    int[] iArr2 = new int[2];
                    viewGroup.getLocationOnScreen(iArr);
                    this.hostView.getLocationOnScreen(iArr2);
                    ViewCompat.offsetLeftAndRight(view, iArr[0] - iArr2[0]);
                    ViewCompat.offsetTopAndBottom(view, iArr[1] - iArr2[1]);
                }
                viewGroup.removeView(view);
                if (view.getParent() != null) {
                    viewGroup.removeView(view);
                }
            }
            super.addView(view);
        }

        public void remove(View view) {
            super.removeView(view);
            disposeIfEmpty();
        }

        private void assertNotDisposed() {
            if (this.disposed) {
                throw new IllegalStateException("This overlay was disposed already. Please use a new one via ViewGroupUtils.getOverlay()");
            }
        }

        private void disposeIfEmpty() {
            if (getChildCount() == 0) {
                ArrayList<Drawable> arrayList = this.drawables;
                if (arrayList == null || arrayList.size() == 0) {
                    this.disposed = true;
                    this.hostView.removeView(this);
                }
            }
        }

        public void invalidateDrawable(@NonNull Drawable drawable) {
            invalidate(drawable.getBounds());
        }

        /* access modifiers changed from: protected */
        public void dispatchDraw(Canvas canvas) {
            int[] iArr = new int[2];
            int[] iArr2 = new int[2];
            this.hostView.getLocationOnScreen(iArr);
            this.requestingView.getLocationOnScreen(iArr2);
            canvas.translate((float) (iArr2[0] - iArr[0]), (float) (iArr2[1] - iArr[1]));
            canvas.clipRect(new Rect(0, 0, this.requestingView.getWidth(), this.requestingView.getHeight()));
            super.dispatchDraw(canvas);
            ArrayList<Drawable> arrayList = this.drawables;
            int size = arrayList == null ? 0 : arrayList.size();
            for (int i = 0; i < size; i++) {
                this.drawables.get(i).draw(canvas);
            }
        }

        private void getOffset(int[] iArr) {
            int[] iArr2 = new int[2];
            int[] iArr3 = new int[2];
            this.hostView.getLocationOnScreen(iArr2);
            this.requestingView.getLocationOnScreen(iArr3);
            iArr[0] = iArr3[0] - iArr2[0];
            iArr[1] = iArr3[1] - iArr2[1];
        }

        /* access modifiers changed from: protected */
        @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
        public ViewParent invalidateChildInParentFast(int i, int i2, Rect rect) {
            if (this.hostView == null || invalidateChildInParentFastMethod == null) {
                return null;
            }
            try {
                getOffset(new int[2]);
                invalidateChildInParentFastMethod.invoke(this.hostView, new Object[]{Integer.valueOf(i), Integer.valueOf(i2), rect});
                return null;
            } catch (IllegalAccessException e) {
                e.printStackTrace();
                return null;
            } catch (InvocationTargetException e2) {
                e2.printStackTrace();
                return null;
            }
        }

        public ViewParent invalidateChildInParent(int[] iArr, Rect rect) {
            if (this.hostView == null) {
                return null;
            }
            rect.offset(iArr[0], iArr[1]);
            if (this.hostView != null) {
                iArr[0] = 0;
                iArr[1] = 0;
                int[] iArr2 = new int[2];
                getOffset(iArr2);
                rect.offset(iArr2[0], iArr2[1]);
                return super.invalidateChildInParent(iArr, rect);
            }
            invalidate(rect);
            return null;
        }
    }
}
