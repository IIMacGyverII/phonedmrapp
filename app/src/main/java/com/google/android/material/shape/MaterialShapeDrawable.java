package com.google.android.material.shape;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Matrix;
import android.graphics.Outline;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffColorFilter;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Region;
import android.graphics.drawable.Drawable;
import android.os.Looper;
import android.util.AttributeSet;
import android.util.Log;
import androidx.annotation.AttrRes;
import androidx.annotation.ColorInt;
import androidx.annotation.IntRange;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;
import androidx.annotation.StyleRes;
import androidx.core.graphics.drawable.TintAwareDrawable;
import androidx.core.util.ObjectsCompat;
import com.google.android.material.R;
import com.google.android.material.color.MaterialColors;
import com.google.android.material.elevation.ElevationOverlayProvider;
import com.google.android.material.shadow.ShadowRenderer;
import com.google.android.material.shape.ShapeAppearanceModel;
import com.google.android.material.shape.ShapeAppearancePathProvider;
import com.google.android.material.shape.ShapePath;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.BitSet;

public class MaterialShapeDrawable extends Drawable implements TintAwareDrawable, Shapeable {
    public static final int SHADOW_COMPAT_MODE_ALWAYS = 2;
    public static final int SHADOW_COMPAT_MODE_DEFAULT = 0;
    public static final int SHADOW_COMPAT_MODE_NEVER = 1;
    private static final float SHADOW_OFFSET_MULTIPLIER = 0.25f;
    private static final float SHADOW_RADIUS_MULTIPLIER = 0.75f;
    private static final String TAG = MaterialShapeDrawable.class.getSimpleName();
    private static final Paint clearPaint;
    /* access modifiers changed from: private */
    public final BitSet containsIncompatibleShadowOp;
    /* access modifiers changed from: private */
    public final ShapePath.ShadowCompatOperation[] cornerShadowOperation;
    private MaterialShapeDrawableState drawableState;
    /* access modifiers changed from: private */
    public final ShapePath.ShadowCompatOperation[] edgeShadowOperation;
    private final Paint fillPaint;
    private final RectF insetRectF;
    private final Matrix matrix;
    private final Path path;
    @NonNull
    private final RectF pathBounds;
    /* access modifiers changed from: private */
    public boolean pathDirty;
    private final Path pathInsetByStroke;
    private final ShapeAppearancePathProvider pathProvider;
    @NonNull
    private final ShapeAppearancePathProvider.PathListener pathShadowListener;
    private final RectF rectF;
    private int resolvedTintColor;
    private final Region scratchRegion;
    private boolean shadowBitmapDrawingEnable;
    private final ShadowRenderer shadowRenderer;
    private final Paint strokePaint;
    private ShapeAppearanceModel strokeShapeAppearance;
    @Nullable
    private PorterDuffColorFilter strokeTintFilter;
    @Nullable
    private PorterDuffColorFilter tintFilter;
    private final Region transparentRegion;

    @Retention(RetentionPolicy.SOURCE)
    public @interface CompatibilityShadowMode {
    }

    private static int modulateAlpha(int i, int i2) {
        return (i * (i2 + (i2 >>> 7))) >>> 8;
    }

    public int getOpacity() {
        return -3;
    }

    static {
        Paint paint = new Paint(1);
        clearPaint = paint;
        paint.setColor(-1);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.DST_OUT));
    }

    @NonNull
    public static MaterialShapeDrawable createWithElevationOverlay(Context context) {
        return createWithElevationOverlay(context, 0.0f);
    }

    @NonNull
    public static MaterialShapeDrawable createWithElevationOverlay(Context context, float f) {
        int color = MaterialColors.getColor(context, R.attr.colorSurface, MaterialShapeDrawable.class.getSimpleName());
        MaterialShapeDrawable materialShapeDrawable = new MaterialShapeDrawable();
        materialShapeDrawable.initializeElevationOverlay(context);
        materialShapeDrawable.setFillColor(ColorStateList.valueOf(color));
        materialShapeDrawable.setElevation(f);
        return materialShapeDrawable;
    }

    public MaterialShapeDrawable() {
        this(new ShapeAppearanceModel());
    }

    public MaterialShapeDrawable(@NonNull Context context, @Nullable AttributeSet attributeSet, @AttrRes int i, @StyleRes int i2) {
        this(ShapeAppearanceModel.builder(context, attributeSet, i, i2).build());
    }

    @Deprecated
    public MaterialShapeDrawable(@NonNull ShapePathModel shapePathModel) {
        this((ShapeAppearanceModel) shapePathModel);
    }

    public MaterialShapeDrawable(@NonNull ShapeAppearanceModel shapeAppearanceModel) {
        this(new MaterialShapeDrawableState(shapeAppearanceModel, (ElevationOverlayProvider) null));
    }

    private MaterialShapeDrawable(@NonNull MaterialShapeDrawableState materialShapeDrawableState) {
        ShapeAppearancePathProvider shapeAppearancePathProvider;
        this.cornerShadowOperation = new ShapePath.ShadowCompatOperation[4];
        this.edgeShadowOperation = new ShapePath.ShadowCompatOperation[4];
        this.containsIncompatibleShadowOp = new BitSet(8);
        this.matrix = new Matrix();
        this.path = new Path();
        this.pathInsetByStroke = new Path();
        this.rectF = new RectF();
        this.insetRectF = new RectF();
        this.transparentRegion = new Region();
        this.scratchRegion = new Region();
        Paint paint = new Paint(1);
        this.fillPaint = paint;
        Paint paint2 = new Paint(1);
        this.strokePaint = paint2;
        this.shadowRenderer = new ShadowRenderer();
        if (Looper.getMainLooper().getThread() == Thread.currentThread()) {
            shapeAppearancePathProvider = ShapeAppearancePathProvider.getInstance();
        } else {
            shapeAppearancePathProvider = new ShapeAppearancePathProvider();
        }
        this.pathProvider = shapeAppearancePathProvider;
        this.pathBounds = new RectF();
        this.shadowBitmapDrawingEnable = true;
        this.drawableState = materialShapeDrawableState;
        paint2.setStyle(Paint.Style.STROKE);
        paint.setStyle(Paint.Style.FILL);
        updateTintFilter();
        updateColorsForState(getState());
        this.pathShadowListener = new ShapeAppearancePathProvider.PathListener() {
            public void onCornerPathCreated(@NonNull ShapePath shapePath, Matrix matrix, int i) {
                MaterialShapeDrawable.this.containsIncompatibleShadowOp.set(i, shapePath.containsIncompatibleShadowOp());
                MaterialShapeDrawable.this.cornerShadowOperation[i] = shapePath.createShadowCompatOperation(matrix);
            }

            public void onEdgePathCreated(@NonNull ShapePath shapePath, Matrix matrix, int i) {
                MaterialShapeDrawable.this.containsIncompatibleShadowOp.set(i + 4, shapePath.containsIncompatibleShadowOp());
                MaterialShapeDrawable.this.edgeShadowOperation[i] = shapePath.createShadowCompatOperation(matrix);
            }
        };
    }

    @Nullable
    public Drawable.ConstantState getConstantState() {
        return this.drawableState;
    }

    @NonNull
    public Drawable mutate() {
        this.drawableState = new MaterialShapeDrawableState(this.drawableState);
        return this;
    }

    public void setShapeAppearanceModel(@NonNull ShapeAppearanceModel shapeAppearanceModel) {
        this.drawableState.shapeAppearanceModel = shapeAppearanceModel;
        invalidateSelf();
    }

    @NonNull
    public ShapeAppearanceModel getShapeAppearanceModel() {
        return this.drawableState.shapeAppearanceModel;
    }

    @Deprecated
    public void setShapedViewModel(@NonNull ShapePathModel shapePathModel) {
        setShapeAppearanceModel(shapePathModel);
    }

    @Deprecated
    @Nullable
    public ShapePathModel getShapedViewModel() {
        ShapeAppearanceModel shapeAppearanceModel = getShapeAppearanceModel();
        if (shapeAppearanceModel instanceof ShapePathModel) {
            return (ShapePathModel) shapeAppearanceModel;
        }
        return null;
    }

    public void setFillColor(@Nullable ColorStateList colorStateList) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.fillColor != colorStateList) {
            materialShapeDrawableState.fillColor = colorStateList;
            onStateChange(getState());
        }
    }

    @Nullable
    public ColorStateList getFillColor() {
        return this.drawableState.fillColor;
    }

    public void setStrokeColor(@Nullable ColorStateList colorStateList) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.strokeColor != colorStateList) {
            materialShapeDrawableState.strokeColor = colorStateList;
            onStateChange(getState());
        }
    }

    @Nullable
    public ColorStateList getStrokeColor() {
        return this.drawableState.strokeColor;
    }

    public void setTintMode(@Nullable PorterDuff.Mode mode) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.tintMode != mode) {
            materialShapeDrawableState.tintMode = mode;
            updateTintFilter();
            invalidateSelfIgnoreShape();
        }
    }

    public void setTintList(@Nullable ColorStateList colorStateList) {
        this.drawableState.tintList = colorStateList;
        updateTintFilter();
        invalidateSelfIgnoreShape();
    }

    @Nullable
    public ColorStateList getTintList() {
        return this.drawableState.tintList;
    }

    @Nullable
    public ColorStateList getStrokeTintList() {
        return this.drawableState.strokeTintList;
    }

    public void setTint(@ColorInt int i) {
        setTintList(ColorStateList.valueOf(i));
    }

    public void setStrokeTint(ColorStateList colorStateList) {
        this.drawableState.strokeTintList = colorStateList;
        updateTintFilter();
        invalidateSelfIgnoreShape();
    }

    public void setStrokeTint(@ColorInt int i) {
        setStrokeTint(ColorStateList.valueOf(i));
    }

    public void setStroke(float f, @ColorInt int i) {
        setStrokeWidth(f);
        setStrokeColor(ColorStateList.valueOf(i));
    }

    public void setStroke(float f, @Nullable ColorStateList colorStateList) {
        setStrokeWidth(f);
        setStrokeColor(colorStateList);
    }

    public float getStrokeWidth() {
        return this.drawableState.strokeWidth;
    }

    public void setStrokeWidth(float f) {
        this.drawableState.strokeWidth = f;
        invalidateSelf();
    }

    @ColorInt
    public int getResolvedTintColor() {
        return this.resolvedTintColor;
    }

    public int getAlpha() {
        return this.drawableState.alpha;
    }

    public void setAlpha(@IntRange(from = 0, to = 255) int i) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.alpha != i) {
            materialShapeDrawableState.alpha = i;
            invalidateSelfIgnoreShape();
        }
    }

    public void setColorFilter(@Nullable ColorFilter colorFilter) {
        this.drawableState.colorFilter = colorFilter;
        invalidateSelfIgnoreShape();
    }

    public Region getTransparentRegion() {
        this.transparentRegion.set(getBounds());
        calculatePath(getBoundsAsRectF(), this.path);
        this.scratchRegion.setPath(this.path, this.transparentRegion);
        this.transparentRegion.op(this.scratchRegion, Region.Op.DIFFERENCE);
        return this.transparentRegion;
    }

    /* access modifiers changed from: protected */
    @NonNull
    public RectF getBoundsAsRectF() {
        this.rectF.set(getBounds());
        return this.rectF;
    }

    public void setCornerSize(float f) {
        setShapeAppearanceModel(this.drawableState.shapeAppearanceModel.withCornerSize(f));
    }

    public void setCornerSize(@NonNull CornerSize cornerSize) {
        setShapeAppearanceModel(this.drawableState.shapeAppearanceModel.withCornerSize(cornerSize));
    }

    public boolean isPointInTransparentRegion(int i, int i2) {
        return getTransparentRegion().contains(i, i2);
    }

    public int getShadowCompatibilityMode() {
        return this.drawableState.shadowCompatMode;
    }

    public boolean getPadding(@NonNull Rect rect) {
        Rect rect2 = this.drawableState.padding;
        if (rect2 == null) {
            return super.getPadding(rect);
        }
        rect.set(rect2);
        return true;
    }

    public void setPadding(int i, int i2, int i3, int i4) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.padding == null) {
            materialShapeDrawableState.padding = new Rect();
        }
        this.drawableState.padding.set(i, i2, i3, i4);
        invalidateSelf();
    }

    public void setShadowCompatibilityMode(int i) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.shadowCompatMode != i) {
            materialShapeDrawableState.shadowCompatMode = i;
            invalidateSelfIgnoreShape();
        }
    }

    @Deprecated
    public boolean isShadowEnabled() {
        int i = this.drawableState.shadowCompatMode;
        return i == 0 || i == 2;
    }

    @Deprecated
    public void setShadowEnabled(boolean z) {
        setShadowCompatibilityMode(z ^ true ? 1 : 0);
    }

    public boolean isElevationOverlayEnabled() {
        ElevationOverlayProvider elevationOverlayProvider = this.drawableState.elevationOverlayProvider;
        return elevationOverlayProvider != null && elevationOverlayProvider.isThemeElevationOverlayEnabled();
    }

    public boolean isElevationOverlayInitialized() {
        return this.drawableState.elevationOverlayProvider != null;
    }

    public void initializeElevationOverlay(Context context) {
        this.drawableState.elevationOverlayProvider = new ElevationOverlayProvider(context);
        updateZ();
    }

    /* access modifiers changed from: protected */
    @ColorInt
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public int compositeElevationOverlayIfNeeded(@ColorInt int i) {
        float z = getZ() + getParentAbsoluteElevation();
        ElevationOverlayProvider elevationOverlayProvider = this.drawableState.elevationOverlayProvider;
        return elevationOverlayProvider != null ? elevationOverlayProvider.compositeOverlayIfNeeded(i, z) : i;
    }

    public float getInterpolation() {
        return this.drawableState.interpolation;
    }

    public void setInterpolation(float f) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.interpolation != f) {
            materialShapeDrawableState.interpolation = f;
            this.pathDirty = true;
            invalidateSelf();
        }
    }

    public float getParentAbsoluteElevation() {
        return this.drawableState.parentAbsoluteElevation;
    }

    public void setParentAbsoluteElevation(float f) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.parentAbsoluteElevation != f) {
            materialShapeDrawableState.parentAbsoluteElevation = f;
            updateZ();
        }
    }

    public float getElevation() {
        return this.drawableState.elevation;
    }

    public void setElevation(float f) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.elevation != f) {
            materialShapeDrawableState.elevation = f;
            updateZ();
        }
    }

    public float getTranslationZ() {
        return this.drawableState.translationZ;
    }

    public void setTranslationZ(float f) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.translationZ != f) {
            materialShapeDrawableState.translationZ = f;
            updateZ();
        }
    }

    public float getZ() {
        return getElevation() + getTranslationZ();
    }

    public void setZ(float f) {
        setTranslationZ(f - getElevation());
    }

    private void updateZ() {
        float z = getZ();
        this.drawableState.shadowCompatRadius = (int) Math.ceil((double) (0.75f * z));
        this.drawableState.shadowCompatOffset = (int) Math.ceil((double) (z * SHADOW_OFFSET_MULTIPLIER));
        updateTintFilter();
        invalidateSelfIgnoreShape();
    }

    @Deprecated
    public int getShadowElevation() {
        return (int) getElevation();
    }

    @Deprecated
    public void setShadowElevation(int i) {
        setElevation((float) i);
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public int getShadowVerticalOffset() {
        return this.drawableState.shadowCompatOffset;
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public void setShadowBitmapDrawingEnable(boolean z) {
        this.shadowBitmapDrawingEnable = z;
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public void setEdgeIntersectionCheckEnable(boolean z) {
        this.pathProvider.setEdgeIntersectionCheckEnable(z);
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public void setShadowVerticalOffset(int i) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.shadowCompatOffset != i) {
            materialShapeDrawableState.shadowCompatOffset = i;
            invalidateSelfIgnoreShape();
        }
    }

    public int getShadowCompatRotation() {
        return this.drawableState.shadowCompatRotation;
    }

    public void setShadowCompatRotation(int i) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.shadowCompatRotation != i) {
            materialShapeDrawableState.shadowCompatRotation = i;
            invalidateSelfIgnoreShape();
        }
    }

    public int getShadowRadius() {
        return this.drawableState.shadowCompatRadius;
    }

    @Deprecated
    public void setShadowRadius(int i) {
        this.drawableState.shadowCompatRadius = i;
    }

    public boolean requiresCompatShadow() {
        if (isRoundRect()) {
            return false;
        }
        boolean isConvex = this.path.isConvex();
        return false;
    }

    public float getScale() {
        return this.drawableState.scale;
    }

    public void setScale(float f) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.scale != f) {
            materialShapeDrawableState.scale = f;
            invalidateSelf();
        }
    }

    public void invalidateSelf() {
        this.pathDirty = true;
        super.invalidateSelf();
    }

    private void invalidateSelfIgnoreShape() {
        super.invalidateSelf();
    }

    public void setUseTintColorForShadow(boolean z) {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        if (materialShapeDrawableState.useTintColorForShadow != z) {
            materialShapeDrawableState.useTintColorForShadow = z;
            invalidateSelf();
        }
    }

    public void setShadowColor(int i) {
        this.shadowRenderer.setShadowColor(i);
        this.drawableState.useTintColorForShadow = false;
        invalidateSelfIgnoreShape();
    }

    public Paint.Style getPaintStyle() {
        return this.drawableState.paintStyle;
    }

    public void setPaintStyle(Paint.Style style) {
        this.drawableState.paintStyle = style;
        invalidateSelfIgnoreShape();
    }

    private boolean hasCompatShadow() {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        int i = materialShapeDrawableState.shadowCompatMode;
        if (i == 1 || materialShapeDrawableState.shadowCompatRadius <= 0 || (i != 2 && !requiresCompatShadow())) {
            return false;
        }
        return true;
    }

    private boolean hasFill() {
        Paint.Style style = this.drawableState.paintStyle;
        return style == Paint.Style.FILL_AND_STROKE || style == Paint.Style.FILL;
    }

    private boolean hasStroke() {
        Paint.Style style = this.drawableState.paintStyle;
        return (style == Paint.Style.FILL_AND_STROKE || style == Paint.Style.STROKE) && this.strokePaint.getStrokeWidth() > 0.0f;
    }

    /* access modifiers changed from: protected */
    public void onBoundsChange(Rect rect) {
        this.pathDirty = true;
        super.onBoundsChange(rect);
    }

    public void draw(@NonNull Canvas canvas) {
        this.fillPaint.setColorFilter(this.tintFilter);
        int alpha = this.fillPaint.getAlpha();
        this.fillPaint.setAlpha(modulateAlpha(alpha, this.drawableState.alpha));
        this.strokePaint.setColorFilter(this.strokeTintFilter);
        this.strokePaint.setStrokeWidth(this.drawableState.strokeWidth);
        int alpha2 = this.strokePaint.getAlpha();
        this.strokePaint.setAlpha(modulateAlpha(alpha2, this.drawableState.alpha));
        if (this.pathDirty) {
            calculateStrokePath();
            calculatePath(getBoundsAsRectF(), this.path);
            this.pathDirty = false;
        }
        maybeDrawCompatShadow(canvas);
        if (hasFill()) {
            drawFillShape(canvas);
        }
        if (hasStroke()) {
            drawStrokeShape(canvas);
        }
        this.fillPaint.setAlpha(alpha);
        this.strokePaint.setAlpha(alpha2);
    }

    private void maybeDrawCompatShadow(@NonNull Canvas canvas) {
        if (hasCompatShadow()) {
            canvas.save();
            prepareCanvasForShadow(canvas);
            if (!this.shadowBitmapDrawingEnable) {
                drawCompatShadow(canvas);
                canvas.restore();
                return;
            }
            int width = (int) (this.pathBounds.width() - ((float) getBounds().width()));
            int height = (int) (this.pathBounds.height() - ((float) getBounds().height()));
            if (width < 0 || height < 0) {
                throw new IllegalStateException("Invalid shadow bounds. Check that the treatments result in a valid path.");
            }
            Bitmap createBitmap = Bitmap.createBitmap(((int) this.pathBounds.width()) + (this.drawableState.shadowCompatRadius * 2) + width, ((int) this.pathBounds.height()) + (this.drawableState.shadowCompatRadius * 2) + height, Bitmap.Config.ARGB_8888);
            Canvas canvas2 = new Canvas(createBitmap);
            float f = (float) ((getBounds().left - this.drawableState.shadowCompatRadius) - width);
            float f2 = (float) ((getBounds().top - this.drawableState.shadowCompatRadius) - height);
            canvas2.translate(-f, -f2);
            drawCompatShadow(canvas2);
            canvas.drawBitmap(createBitmap, f, f2, (Paint) null);
            createBitmap.recycle();
            canvas.restore();
        }
    }

    /* access modifiers changed from: protected */
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public void drawShape(@NonNull Canvas canvas, @NonNull Paint paint, @NonNull Path path2, @NonNull RectF rectF2) {
        drawShape(canvas, paint, path2, this.drawableState.shapeAppearanceModel, rectF2);
    }

    private void drawShape(@NonNull Canvas canvas, @NonNull Paint paint, @NonNull Path path2, @NonNull ShapeAppearanceModel shapeAppearanceModel, @NonNull RectF rectF2) {
        if (shapeAppearanceModel.isRoundRect(rectF2)) {
            float cornerSize = shapeAppearanceModel.getTopRightCornerSize().getCornerSize(rectF2) * this.drawableState.interpolation;
            canvas.drawRoundRect(rectF2, cornerSize, cornerSize, paint);
            return;
        }
        canvas.drawPath(path2, paint);
    }

    private void drawFillShape(@NonNull Canvas canvas) {
        drawShape(canvas, this.fillPaint, this.path, this.drawableState.shapeAppearanceModel, getBoundsAsRectF());
    }

    /* access modifiers changed from: protected */
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public void drawStrokeShape(@NonNull Canvas canvas) {
        drawShape(canvas, this.strokePaint, this.pathInsetByStroke, this.strokeShapeAppearance, getBoundsInsetByStroke());
    }

    private void prepareCanvasForShadow(@NonNull Canvas canvas) {
        canvas.translate((float) getShadowOffsetX(), (float) getShadowOffsetY());
    }

    private void drawCompatShadow(@NonNull Canvas canvas) {
        if (this.containsIncompatibleShadowOp.cardinality() > 0) {
            Log.w(TAG, "Compatibility shadow requested but can't be drawn for all operations in this shape.");
        }
        if (this.drawableState.shadowCompatOffset != 0) {
            canvas.drawPath(this.path, this.shadowRenderer.getShadowPaint());
        }
        for (int i = 0; i < 4; i++) {
            this.cornerShadowOperation[i].draw(this.shadowRenderer, this.drawableState.shadowCompatRadius, canvas);
            this.edgeShadowOperation[i].draw(this.shadowRenderer, this.drawableState.shadowCompatRadius, canvas);
        }
        if (this.shadowBitmapDrawingEnable) {
            int shadowOffsetX = getShadowOffsetX();
            int shadowOffsetY = getShadowOffsetY();
            canvas.translate((float) (-shadowOffsetX), (float) (-shadowOffsetY));
            canvas.drawPath(this.path, clearPaint);
            canvas.translate((float) shadowOffsetX, (float) shadowOffsetY);
        }
    }

    public int getShadowOffsetX() {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        return (int) (((double) materialShapeDrawableState.shadowCompatOffset) * Math.sin(Math.toRadians((double) materialShapeDrawableState.shadowCompatRotation)));
    }

    public int getShadowOffsetY() {
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        return (int) (((double) materialShapeDrawableState.shadowCompatOffset) * Math.cos(Math.toRadians((double) materialShapeDrawableState.shadowCompatRotation)));
    }

    @Deprecated
    public void getPathForSize(int i, int i2, @NonNull Path path2) {
        calculatePathForSize(new RectF(0.0f, 0.0f, (float) i, (float) i2), path2);
    }

    /* access modifiers changed from: protected */
    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public final void calculatePathForSize(@NonNull RectF rectF2, @NonNull Path path2) {
        ShapeAppearancePathProvider shapeAppearancePathProvider = this.pathProvider;
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        ShapeAppearanceModel shapeAppearanceModel = materialShapeDrawableState.shapeAppearanceModel;
        float f = materialShapeDrawableState.interpolation;
        shapeAppearancePathProvider.calculatePath(shapeAppearanceModel, f, rectF2, this.pathShadowListener, path2);
    }

    private void calculateStrokePath() {
        final float f = -getStrokeInsetLength();
        ShapeAppearanceModel withTransformedCornerSizes = getShapeAppearanceModel().withTransformedCornerSizes(new ShapeAppearanceModel.CornerSizeUnaryOperator() {
            @NonNull
            public CornerSize apply(@NonNull CornerSize cornerSize) {
                return cornerSize instanceof RelativeCornerSize ? cornerSize : new AdjustedCornerSize(f, cornerSize);
            }
        });
        this.strokeShapeAppearance = withTransformedCornerSizes;
        this.pathProvider.calculatePath(withTransformedCornerSizes, this.drawableState.interpolation, getBoundsInsetByStroke(), this.pathInsetByStroke);
    }

    @TargetApi(21)
    public void getOutline(@NonNull Outline outline) {
        if (this.drawableState.shadowCompatMode != 2) {
            if (isRoundRect()) {
                outline.setRoundRect(getBounds(), getTopLeftCornerResolvedSize() * this.drawableState.interpolation);
                return;
            }
            calculatePath(getBoundsAsRectF(), this.path);
            boolean isConvex = this.path.isConvex();
            try {
                outline.setConvexPath(this.path);
            } catch (IllegalArgumentException unused) {
            }
        }
    }

    private void calculatePath(@NonNull RectF rectF2, @NonNull Path path2) {
        calculatePathForSize(rectF2, path2);
        if (this.drawableState.scale != 1.0f) {
            this.matrix.reset();
            Matrix matrix2 = this.matrix;
            float f = this.drawableState.scale;
            matrix2.setScale(f, f, rectF2.width() / 2.0f, rectF2.height() / 2.0f);
            path2.transform(this.matrix);
        }
        path2.computeBounds(this.pathBounds, true);
    }

    private boolean updateTintFilter() {
        PorterDuffColorFilter porterDuffColorFilter = this.tintFilter;
        PorterDuffColorFilter porterDuffColorFilter2 = this.strokeTintFilter;
        MaterialShapeDrawableState materialShapeDrawableState = this.drawableState;
        this.tintFilter = calculateTintFilter(materialShapeDrawableState.tintList, materialShapeDrawableState.tintMode, this.fillPaint, true);
        MaterialShapeDrawableState materialShapeDrawableState2 = this.drawableState;
        this.strokeTintFilter = calculateTintFilter(materialShapeDrawableState2.strokeTintList, materialShapeDrawableState2.tintMode, this.strokePaint, false);
        MaterialShapeDrawableState materialShapeDrawableState3 = this.drawableState;
        if (materialShapeDrawableState3.useTintColorForShadow) {
            this.shadowRenderer.setShadowColor(materialShapeDrawableState3.tintList.getColorForState(getState(), 0));
        }
        if (!ObjectsCompat.equals(porterDuffColorFilter, this.tintFilter) || !ObjectsCompat.equals(porterDuffColorFilter2, this.strokeTintFilter)) {
            return true;
        }
        return false;
    }

    @NonNull
    private PorterDuffColorFilter calculateTintFilter(@Nullable ColorStateList colorStateList, @Nullable PorterDuff.Mode mode, @NonNull Paint paint, boolean z) {
        if (colorStateList == null || mode == null) {
            return calculatePaintColorTintFilter(paint, z);
        }
        return calculateTintColorTintFilter(colorStateList, mode, z);
    }

    @Nullable
    private PorterDuffColorFilter calculatePaintColorTintFilter(@NonNull Paint paint, boolean z) {
        if (!z) {
            return null;
        }
        int color = paint.getColor();
        int compositeElevationOverlayIfNeeded = compositeElevationOverlayIfNeeded(color);
        this.resolvedTintColor = compositeElevationOverlayIfNeeded;
        if (compositeElevationOverlayIfNeeded != color) {
            return new PorterDuffColorFilter(compositeElevationOverlayIfNeeded, PorterDuff.Mode.SRC_IN);
        }
        return null;
    }

    @NonNull
    private PorterDuffColorFilter calculateTintColorTintFilter(@NonNull ColorStateList colorStateList, @NonNull PorterDuff.Mode mode, boolean z) {
        int colorForState = colorStateList.getColorForState(getState(), 0);
        if (z) {
            colorForState = compositeElevationOverlayIfNeeded(colorForState);
        }
        this.resolvedTintColor = colorForState;
        return new PorterDuffColorFilter(colorForState, mode);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:10:0x001e, code lost:
        r0 = r1.drawableState.strokeColor;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:14:0x002a, code lost:
        r1 = r1.drawableState.fillColor;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:2:0x0006, code lost:
        r0 = r1.drawableState.tintList;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:6:0x0012, code lost:
        r0 = r1.drawableState.strokeTintList;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public boolean isStateful() {
        /*
            r1 = this;
            boolean r0 = super.isStateful()
            if (r0 != 0) goto L_0x0039
            com.google.android.material.shape.MaterialShapeDrawable$MaterialShapeDrawableState r0 = r1.drawableState
            android.content.res.ColorStateList r0 = r0.tintList
            if (r0 == 0) goto L_0x0012
            boolean r0 = r0.isStateful()
            if (r0 != 0) goto L_0x0039
        L_0x0012:
            com.google.android.material.shape.MaterialShapeDrawable$MaterialShapeDrawableState r0 = r1.drawableState
            android.content.res.ColorStateList r0 = r0.strokeTintList
            if (r0 == 0) goto L_0x001e
            boolean r0 = r0.isStateful()
            if (r0 != 0) goto L_0x0039
        L_0x001e:
            com.google.android.material.shape.MaterialShapeDrawable$MaterialShapeDrawableState r0 = r1.drawableState
            android.content.res.ColorStateList r0 = r0.strokeColor
            if (r0 == 0) goto L_0x002a
            boolean r0 = r0.isStateful()
            if (r0 != 0) goto L_0x0039
        L_0x002a:
            com.google.android.material.shape.MaterialShapeDrawable$MaterialShapeDrawableState r1 = r1.drawableState
            android.content.res.ColorStateList r1 = r1.fillColor
            if (r1 == 0) goto L_0x0037
            boolean r1 = r1.isStateful()
            if (r1 == 0) goto L_0x0037
            goto L_0x0039
        L_0x0037:
            r1 = 0
            goto L_0x003a
        L_0x0039:
            r1 = 1
        L_0x003a:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.android.material.shape.MaterialShapeDrawable.isStateful():boolean");
    }

    /* access modifiers changed from: protected */
    public boolean onStateChange(int[] iArr) {
        boolean z = updateColorsForState(iArr) || updateTintFilter();
        if (z) {
            invalidateSelf();
        }
        return z;
    }

    private boolean updateColorsForState(int[] iArr) {
        boolean z;
        int color;
        int colorForState;
        int color2;
        int colorForState2;
        if (this.drawableState.fillColor == null || (color2 = this.fillPaint.getColor()) == (colorForState2 = this.drawableState.fillColor.getColorForState(iArr, color2))) {
            z = false;
        } else {
            this.fillPaint.setColor(colorForState2);
            z = true;
        }
        if (this.drawableState.strokeColor == null || (color = this.strokePaint.getColor()) == (colorForState = this.drawableState.strokeColor.getColorForState(iArr, color))) {
            return z;
        }
        this.strokePaint.setColor(colorForState);
        return true;
    }

    private float getStrokeInsetLength() {
        if (hasStroke()) {
            return this.strokePaint.getStrokeWidth() / 2.0f;
        }
        return 0.0f;
    }

    @NonNull
    private RectF getBoundsInsetByStroke() {
        this.insetRectF.set(getBoundsAsRectF());
        float strokeInsetLength = getStrokeInsetLength();
        this.insetRectF.inset(strokeInsetLength, strokeInsetLength);
        return this.insetRectF;
    }

    public float getTopLeftCornerResolvedSize() {
        return this.drawableState.shapeAppearanceModel.getTopLeftCornerSize().getCornerSize(getBoundsAsRectF());
    }

    public float getTopRightCornerResolvedSize() {
        return this.drawableState.shapeAppearanceModel.getTopRightCornerSize().getCornerSize(getBoundsAsRectF());
    }

    public float getBottomLeftCornerResolvedSize() {
        return this.drawableState.shapeAppearanceModel.getBottomLeftCornerSize().getCornerSize(getBoundsAsRectF());
    }

    public float getBottomRightCornerResolvedSize() {
        return this.drawableState.shapeAppearanceModel.getBottomRightCornerSize().getCornerSize(getBoundsAsRectF());
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY_GROUP})
    public boolean isRoundRect() {
        return this.drawableState.shapeAppearanceModel.isRoundRect(getBoundsAsRectF());
    }

    static final class MaterialShapeDrawableState extends Drawable.ConstantState {
        public int alpha = 255;
        @Nullable
        public ColorFilter colorFilter;
        public float elevation = 0.0f;
        @Nullable
        public ElevationOverlayProvider elevationOverlayProvider;
        @Nullable
        public ColorStateList fillColor = null;
        public float interpolation = 1.0f;
        @Nullable
        public Rect padding = null;
        public Paint.Style paintStyle = Paint.Style.FILL_AND_STROKE;
        public float parentAbsoluteElevation = 0.0f;
        public float scale = 1.0f;
        public int shadowCompatMode = 0;
        public int shadowCompatOffset = 0;
        public int shadowCompatRadius = 0;
        public int shadowCompatRotation = 0;
        @NonNull
        public ShapeAppearanceModel shapeAppearanceModel;
        @Nullable
        public ColorStateList strokeColor = null;
        @Nullable
        public ColorStateList strokeTintList = null;
        public float strokeWidth;
        @Nullable
        public ColorStateList tintList = null;
        @Nullable
        public PorterDuff.Mode tintMode = PorterDuff.Mode.SRC_IN;
        public float translationZ = 0.0f;
        public boolean useTintColorForShadow = false;

        public int getChangingConfigurations() {
            return 0;
        }

        public MaterialShapeDrawableState(ShapeAppearanceModel shapeAppearanceModel2, ElevationOverlayProvider elevationOverlayProvider2) {
            this.shapeAppearanceModel = shapeAppearanceModel2;
            this.elevationOverlayProvider = elevationOverlayProvider2;
        }

        public MaterialShapeDrawableState(@NonNull MaterialShapeDrawableState materialShapeDrawableState) {
            this.shapeAppearanceModel = materialShapeDrawableState.shapeAppearanceModel;
            this.elevationOverlayProvider = materialShapeDrawableState.elevationOverlayProvider;
            this.strokeWidth = materialShapeDrawableState.strokeWidth;
            this.colorFilter = materialShapeDrawableState.colorFilter;
            this.fillColor = materialShapeDrawableState.fillColor;
            this.strokeColor = materialShapeDrawableState.strokeColor;
            this.tintMode = materialShapeDrawableState.tintMode;
            this.tintList = materialShapeDrawableState.tintList;
            this.alpha = materialShapeDrawableState.alpha;
            this.scale = materialShapeDrawableState.scale;
            this.shadowCompatOffset = materialShapeDrawableState.shadowCompatOffset;
            this.shadowCompatMode = materialShapeDrawableState.shadowCompatMode;
            this.useTintColorForShadow = materialShapeDrawableState.useTintColorForShadow;
            this.interpolation = materialShapeDrawableState.interpolation;
            this.parentAbsoluteElevation = materialShapeDrawableState.parentAbsoluteElevation;
            this.elevation = materialShapeDrawableState.elevation;
            this.translationZ = materialShapeDrawableState.translationZ;
            this.shadowCompatRadius = materialShapeDrawableState.shadowCompatRadius;
            this.shadowCompatRotation = materialShapeDrawableState.shadowCompatRotation;
            this.strokeTintList = materialShapeDrawableState.strokeTintList;
            this.paintStyle = materialShapeDrawableState.paintStyle;
            if (materialShapeDrawableState.padding != null) {
                this.padding = new Rect(materialShapeDrawableState.padding);
            }
        }

        @NonNull
        public Drawable newDrawable() {
            MaterialShapeDrawable materialShapeDrawable = new MaterialShapeDrawable(this);
            boolean unused = materialShapeDrawable.pathDirty = true;
            return materialShapeDrawable;
        }
    }
}
