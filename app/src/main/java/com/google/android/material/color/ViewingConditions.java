package com.google.android.material.color;

final class ViewingConditions {
    public static final ViewingConditions DEFAULT = make(ColorUtils.whitePointD65(), (float) ((((double) ColorUtils.yFromLstar(50.0f)) * 63.66197723675813d) / 100.0d), 50.0f, 2.0f, false);
    private final float aw;
    private final float c;
    private final float fl;
    private final float flRoot;
    private final float n;
    private final float nbb;
    private final float nc;
    private final float ncb;
    private final float[] rgbD;
    private final float z;

    public float getAw() {
        return this.aw;
    }

    public float getN() {
        return this.n;
    }

    public float getNbb() {
        return this.nbb;
    }

    /* access modifiers changed from: package-private */
    public float getNcb() {
        return this.ncb;
    }

    /* access modifiers changed from: package-private */
    public float getC() {
        return this.c;
    }

    /* access modifiers changed from: package-private */
    public float getNc() {
        return this.nc;
    }

    public float[] getRgbD() {
        return this.rgbD;
    }

    /* access modifiers changed from: package-private */
    public float getFl() {
        return this.fl;
    }

    public float getFlRoot() {
        return this.flRoot;
    }

    /* access modifiers changed from: package-private */
    public float getZ() {
        return this.z;
    }

    static ViewingConditions make(float[] fArr, float f, float f2, float f3, boolean z2) {
        float f4;
        float f5;
        float f6 = f;
        float[][] fArr2 = Cam16.XYZ_TO_CAM16RGB;
        float f7 = fArr[0];
        float[] fArr3 = fArr2[0];
        float f8 = fArr[1];
        float f9 = fArr[2];
        float f10 = (fArr3[0] * f7) + (fArr3[1] * f8) + (fArr3[2] * f9);
        float[] fArr4 = fArr2[1];
        float f11 = (fArr4[0] * f7) + (fArr4[1] * f8) + (fArr4[2] * f9);
        float[] fArr5 = fArr2[2];
        float f12 = (f7 * fArr5[0]) + (f8 * fArr5[1]) + (f9 * fArr5[2]);
        float f13 = (f3 / 10.0f) + 0.8f;
        if (((double) f13) >= 0.9d) {
            f4 = MathUtils.lerp(0.59f, 0.69f, (f13 - 0.9f) * 10.0f);
        } else {
            f4 = MathUtils.lerp(0.525f, 0.59f, (f13 - 0.8f) * 10.0f);
        }
        float f14 = f4;
        if (z2) {
            f5 = 1.0f;
        } else {
            f5 = (1.0f - (((float) Math.exp((double) (((-f6) - 42.0f) / 92.0f))) * 0.2777778f)) * f13;
        }
        double d = (double) f5;
        if (d > 1.0d) {
            f5 = 1.0f;
        } else if (d < 0.0d) {
            f5 = 0.0f;
        }
        float[] fArr6 = {(((100.0f / f10) * f5) + 1.0f) - f5, (((100.0f / f11) * f5) + 1.0f) - f5, (((100.0f / f12) * f5) + 1.0f) - f5};
        float f15 = 1.0f / ((5.0f * f6) + 1.0f);
        float f16 = f15 * f15 * f15 * f15;
        float f17 = 1.0f - f16;
        float cbrt = (f16 * f6) + (0.1f * f17 * f17 * ((float) Math.cbrt(((double) f6) * 5.0d)));
        float yFromLstar = ColorUtils.yFromLstar(f2) / fArr[1];
        double d2 = (double) yFromLstar;
        float sqrt = ((float) Math.sqrt(d2)) + 1.48f;
        float pow = 0.725f / ((float) Math.pow(d2, 0.2d));
        float pow2 = (float) Math.pow(((double) ((fArr6[2] * cbrt) * f12)) / 100.0d, 0.42d);
        float[] fArr7 = {(float) Math.pow(((double) ((fArr6[0] * cbrt) * f10)) / 100.0d, 0.42d), (float) Math.pow(((double) ((fArr6[1] * cbrt) * f11)) / 100.0d, 0.42d), pow2};
        float f18 = fArr7[0];
        float f19 = (f18 * 400.0f) / (f18 + 27.13f);
        float f20 = fArr7[1];
        return new ViewingConditions(yFromLstar, ((f19 * 2.0f) + ((f20 * 400.0f) / (f20 + 27.13f)) + (((400.0f * pow2) / (pow2 + 27.13f)) * 0.05f)) * pow, pow, pow, f14, f13, fArr6, cbrt, (float) Math.pow((double) cbrt, 0.25d), sqrt);
    }

    private ViewingConditions(float f, float f2, float f3, float f4, float f5, float f6, float[] fArr, float f7, float f8, float f9) {
        this.n = f;
        this.aw = f2;
        this.nbb = f3;
        this.ncb = f4;
        this.c = f5;
        this.nc = f6;
        this.rgbD = fArr;
        this.fl = f7;
        this.flRoot = f8;
        this.z = f9;
    }
}
