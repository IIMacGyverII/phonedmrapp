package androidx.core.content.res;

import androidx.annotation.NonNull;

final class ViewingConditions {
    static final ViewingConditions DEFAULT = make(CamUtils.WHITE_POINT_D65, (float) ((((double) CamUtils.yFromLStar(50.0f)) * 63.66197723675813d) / 100.0d), 50.0f, 2.0f, false);
    private final float mAw;
    private final float mC;
    private final float mFl;
    private final float mFlRoot;
    private final float mN;
    private final float mNbb;
    private final float mNc;
    private final float mNcb;
    private final float[] mRgbD;
    private final float mZ;

    /* access modifiers changed from: package-private */
    public float getAw() {
        return this.mAw;
    }

    /* access modifiers changed from: package-private */
    public float getN() {
        return this.mN;
    }

    /* access modifiers changed from: package-private */
    public float getNbb() {
        return this.mNbb;
    }

    /* access modifiers changed from: package-private */
    public float getNcb() {
        return this.mNcb;
    }

    /* access modifiers changed from: package-private */
    public float getC() {
        return this.mC;
    }

    /* access modifiers changed from: package-private */
    public float getNc() {
        return this.mNc;
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public float[] getRgbD() {
        return this.mRgbD;
    }

    /* access modifiers changed from: package-private */
    public float getFl() {
        return this.mFl;
    }

    /* access modifiers changed from: package-private */
    public float getFlRoot() {
        return this.mFlRoot;
    }

    /* access modifiers changed from: package-private */
    public float getZ() {
        return this.mZ;
    }

    private ViewingConditions(float f, float f2, float f3, float f4, float f5, float f6, float[] fArr, float f7, float f8, float f9) {
        this.mN = f;
        this.mAw = f2;
        this.mNbb = f3;
        this.mNcb = f4;
        this.mC = f5;
        this.mNc = f6;
        this.mRgbD = fArr;
        this.mFl = f7;
        this.mFlRoot = f8;
        this.mZ = f9;
    }

    @NonNull
    static ViewingConditions make(@NonNull float[] fArr, float f, float f2, float f3, boolean z) {
        float f4;
        float f5 = f;
        float[][] fArr2 = CamUtils.XYZ_TO_CAM16RGB;
        float f6 = fArr[0];
        float[] fArr3 = fArr2[0];
        float f7 = fArr[1];
        float f8 = fArr[2];
        float f9 = (fArr3[0] * f6) + (fArr3[1] * f7) + (fArr3[2] * f8);
        float[] fArr4 = fArr2[1];
        float f10 = (fArr4[0] * f6) + (fArr4[1] * f7) + (fArr4[2] * f8);
        float[] fArr5 = fArr2[2];
        float f11 = (f6 * fArr5[0]) + (f7 * fArr5[1]) + (f8 * fArr5[2]);
        float f12 = (f3 / 10.0f) + 0.8f;
        float lerp = ((double) f12) >= 0.9d ? CamUtils.lerp(0.59f, 0.69f, (f12 - 0.9f) * 10.0f) : CamUtils.lerp(0.525f, 0.59f, (f12 - 0.8f) * 10.0f);
        if (z) {
            f4 = 1.0f;
        } else {
            f4 = (1.0f - (((float) Math.exp((double) (((-f5) - 42.0f) / 92.0f))) * 0.2777778f)) * f12;
        }
        double d = (double) f4;
        if (d > 1.0d) {
            f4 = 1.0f;
        } else if (d < 0.0d) {
            f4 = 0.0f;
        }
        float[] fArr6 = {(((100.0f / f9) * f4) + 1.0f) - f4, (((100.0f / f10) * f4) + 1.0f) - f4, (((100.0f / f11) * f4) + 1.0f) - f4};
        float f13 = 1.0f / ((5.0f * f5) + 1.0f);
        float f14 = f13 * f13 * f13 * f13;
        float f15 = 1.0f - f14;
        float cbrt = (f14 * f5) + (0.1f * f15 * f15 * ((float) Math.cbrt(((double) f5) * 5.0d)));
        float yFromLStar = CamUtils.yFromLStar(f2) / fArr[1];
        double d2 = (double) yFromLStar;
        float sqrt = ((float) Math.sqrt(d2)) + 1.48f;
        float pow = 0.725f / ((float) Math.pow(d2, 0.2d));
        float pow2 = (float) Math.pow(((double) ((fArr6[2] * cbrt) * f11)) / 100.0d, 0.42d);
        float[] fArr7 = {(float) Math.pow(((double) ((fArr6[0] * cbrt) * f9)) / 100.0d, 0.42d), (float) Math.pow(((double) ((fArr6[1] * cbrt) * f10)) / 100.0d, 0.42d), pow2};
        float f16 = fArr7[0];
        float f17 = (f16 * 400.0f) / (f16 + 27.13f);
        float f18 = fArr7[1];
        return new ViewingConditions(yFromLStar, ((f17 * 2.0f) + ((f18 * 400.0f) / (f18 + 27.13f)) + (((400.0f * pow2) / (pow2 + 27.13f)) * 0.05f)) * pow, pow, pow, lerp, f12, fArr6, cbrt, (float) Math.pow((double) cbrt, 0.25d), sqrt);
    }
}
