package androidx.core.content.res;

import androidx.annotation.ColorInt;
import androidx.annotation.FloatRange;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.graphics.ColorUtils;

class CamColor {
    private static final float CHROMA_SEARCH_ENDPOINT = 0.4f;
    private static final float DE_MAX = 1.0f;
    private static final float DL_MAX = 0.2f;
    private static final float LIGHTNESS_SEARCH_ENDPOINT = 0.01f;
    private final float mAstar;
    private final float mBstar;
    private final float mChroma;
    private final float mHue;
    private final float mJ;
    private final float mJstar;
    private final float mM;
    private final float mQ;
    private final float mS;

    /* access modifiers changed from: package-private */
    @FloatRange(from = 0.0d, to = 360.0d, toInclusive = false)
    public float getHue() {
        return this.mHue;
    }

    /* access modifiers changed from: package-private */
    @FloatRange(from = 0.0d, to = Double.POSITIVE_INFINITY, toInclusive = false)
    public float getChroma() {
        return this.mChroma;
    }

    /* access modifiers changed from: package-private */
    @FloatRange(from = 0.0d, to = 100.0d)
    public float getJ() {
        return this.mJ;
    }

    /* access modifiers changed from: package-private */
    @FloatRange(from = 0.0d, to = Double.POSITIVE_INFINITY, toInclusive = false)
    public float getQ() {
        return this.mQ;
    }

    /* access modifiers changed from: package-private */
    @FloatRange(from = 0.0d, to = Double.POSITIVE_INFINITY, toInclusive = false)
    public float getM() {
        return this.mM;
    }

    /* access modifiers changed from: package-private */
    @FloatRange(from = 0.0d, to = Double.POSITIVE_INFINITY, toInclusive = false)
    public float getS() {
        return this.mS;
    }

    /* access modifiers changed from: package-private */
    @FloatRange(from = 0.0d, to = 100.0d)
    public float getJStar() {
        return this.mJstar;
    }

    /* access modifiers changed from: package-private */
    @FloatRange(from = Double.NEGATIVE_INFINITY, fromInclusive = false, to = Double.POSITIVE_INFINITY, toInclusive = false)
    public float getAStar() {
        return this.mAstar;
    }

    /* access modifiers changed from: package-private */
    @FloatRange(from = Double.NEGATIVE_INFINITY, fromInclusive = false, to = Double.POSITIVE_INFINITY, toInclusive = false)
    public float getBStar() {
        return this.mBstar;
    }

    CamColor(float f, float f2, float f3, float f4, float f5, float f6, float f7, float f8, float f9) {
        this.mHue = f;
        this.mChroma = f2;
        this.mJ = f3;
        this.mQ = f4;
        this.mM = f5;
        this.mS = f6;
        this.mJstar = f7;
        this.mAstar = f8;
        this.mBstar = f9;
    }

    static int toColor(@FloatRange(from = 0.0d, to = 360.0d) float f, @FloatRange(from = 0.0d, to = Double.POSITIVE_INFINITY, toInclusive = false) float f2, @FloatRange(from = 0.0d, to = 100.0d) float f3) {
        return toColor(f, f2, f3, ViewingConditions.DEFAULT);
    }

    @NonNull
    static CamColor fromColor(@ColorInt int i) {
        return fromColorInViewingConditions(i, ViewingConditions.DEFAULT);
    }

    @NonNull
    static CamColor fromColorInViewingConditions(@ColorInt int i, @NonNull ViewingConditions viewingConditions) {
        float[] xyzFromInt = CamUtils.xyzFromInt(i);
        float[][] fArr = CamUtils.XYZ_TO_CAM16RGB;
        float f = xyzFromInt[0];
        float[] fArr2 = fArr[0];
        float f2 = xyzFromInt[1];
        float f3 = xyzFromInt[2];
        float f4 = (fArr2[0] * f) + (fArr2[1] * f2) + (fArr2[2] * f3);
        float[] fArr3 = fArr[1];
        float f5 = (fArr3[0] * f) + (fArr3[1] * f2) + (fArr3[2] * f3);
        float[] fArr4 = fArr[2];
        float f6 = (f * fArr4[0]) + (f2 * fArr4[1]) + (f3 * fArr4[2]);
        float f7 = viewingConditions.getRgbD()[0] * f4;
        float f8 = viewingConditions.getRgbD()[1] * f5;
        float f9 = viewingConditions.getRgbD()[2] * f6;
        float pow = (float) Math.pow(((double) (viewingConditions.getFl() * Math.abs(f7))) / 100.0d, 0.42d);
        float pow2 = (float) Math.pow(((double) (viewingConditions.getFl() * Math.abs(f8))) / 100.0d, 0.42d);
        float pow3 = (float) Math.pow(((double) (viewingConditions.getFl() * Math.abs(f9))) / 100.0d, 0.42d);
        float signum = ((Math.signum(f7) * 400.0f) * pow) / (pow + 27.13f);
        float signum2 = ((Math.signum(f8) * 400.0f) * pow2) / (pow2 + 27.13f);
        float signum3 = ((Math.signum(f9) * 400.0f) * pow3) / (pow3 + 27.13f);
        double d = (double) signum3;
        float f10 = ((float) (((((double) signum) * 11.0d) + (((double) signum2) * -12.0d)) + d)) / 11.0f;
        float f11 = ((float) (((double) (signum + signum2)) - (d * 2.0d))) / 9.0f;
        float f12 = signum2 * 20.0f;
        float f13 = (((signum * 20.0f) + f12) + (21.0f * signum3)) / 20.0f;
        float f14 = (((signum * 40.0f) + f12) + signum3) / 20.0f;
        float atan2 = (((float) Math.atan2((double) f11, (double) f10)) * 180.0f) / 3.1415927f;
        if (atan2 < 0.0f) {
            atan2 += 360.0f;
        } else if (atan2 >= 360.0f) {
            atan2 -= 360.0f;
        }
        float f15 = atan2;
        float f16 = (3.1415927f * f15) / 180.0f;
        float pow4 = ((float) Math.pow((double) ((f14 * viewingConditions.getNbb()) / viewingConditions.getAw()), (double) (viewingConditions.getC() * viewingConditions.getZ()))) * 100.0f;
        float flRoot = viewingConditions.getFlRoot() * (4.0f / viewingConditions.getC()) * ((float) Math.sqrt((double) (pow4 / 100.0f))) * (viewingConditions.getAw() + 4.0f);
        float pow5 = ((float) Math.pow(1.64d - Math.pow(0.29d, (double) viewingConditions.getN()), 0.73d)) * ((float) Math.pow((double) ((((((((float) (Math.cos(((((double) (((double) f15) < 20.14d ? 360.0f + f15 : f15)) * 3.141592653589793d) / 180.0d) + 2.0d) + 3.8d)) * 0.25f) * 3846.1538f) * viewingConditions.getNc()) * viewingConditions.getNcb()) * ((float) Math.sqrt((double) ((f10 * f10) + (f11 * f11))))) / (f13 + 0.305f)), 0.9d));
        float sqrt = pow5 * ((float) Math.sqrt(((double) pow4) / 100.0d));
        float flRoot2 = sqrt * viewingConditions.getFlRoot();
        float sqrt2 = ((float) Math.sqrt((double) ((pow5 * viewingConditions.getC()) / (viewingConditions.getAw() + 4.0f)))) * 50.0f;
        float f17 = (1.7f * pow4) / ((0.007f * pow4) + 1.0f);
        float log = ((float) Math.log((double) ((0.0228f * flRoot2) + 1.0f))) * 43.85965f;
        double d2 = (double) f16;
        return new CamColor(f15, sqrt, pow4, flRoot, flRoot2, sqrt2, f17, log * ((float) Math.cos(d2)), log * ((float) Math.sin(d2)));
    }

    @NonNull
    private static CamColor fromJch(@FloatRange(from = 0.0d, to = 100.0d) float f, @FloatRange(from = 0.0d, to = Double.POSITIVE_INFINITY, toInclusive = false) float f2, @FloatRange(from = 0.0d, to = 360.0d) float f3) {
        return fromJchInFrame(f, f2, f3, ViewingConditions.DEFAULT);
    }

    @NonNull
    private static CamColor fromJchInFrame(@FloatRange(from = 0.0d, to = 100.0d) float f, @FloatRange(from = 0.0d, to = Double.POSITIVE_INFINITY, toInclusive = false) float f2, @FloatRange(from = 0.0d, to = 360.0d) float f3, ViewingConditions viewingConditions) {
        float f4 = f;
        double d = ((double) f4) / 100.0d;
        float c = (4.0f / viewingConditions.getC()) * ((float) Math.sqrt(d)) * (viewingConditions.getAw() + 4.0f) * viewingConditions.getFlRoot();
        float flRoot = f2 * viewingConditions.getFlRoot();
        float sqrt = ((float) Math.sqrt((double) (((f2 / ((float) Math.sqrt(d))) * viewingConditions.getC()) / (viewingConditions.getAw() + 4.0f)))) * 50.0f;
        float f5 = (1.7f * f4) / ((0.007f * f4) + 1.0f);
        float log = ((float) Math.log((((double) flRoot) * 0.0228d) + 1.0d)) * 43.85965f;
        double d2 = (double) ((3.1415927f * f3) / 180.0f);
        return new CamColor(f3, f2, f4, c, flRoot, sqrt, f5, log * ((float) Math.cos(d2)), log * ((float) Math.sin(d2)));
    }

    /* access modifiers changed from: package-private */
    public float distance(@NonNull CamColor camColor) {
        float jStar = getJStar() - camColor.getJStar();
        float aStar = getAStar() - camColor.getAStar();
        float bStar = getBStar() - camColor.getBStar();
        return (float) (Math.pow(Math.sqrt((double) ((jStar * jStar) + (aStar * aStar) + (bStar * bStar))), 0.63d) * 1.41d);
    }

    /* access modifiers changed from: package-private */
    @ColorInt
    public int viewedInSrgb() {
        return viewed(ViewingConditions.DEFAULT);
    }

    /* access modifiers changed from: package-private */
    @ColorInt
    public int viewed(@NonNull ViewingConditions viewingConditions) {
        float pow = (float) Math.pow(((double) ((((double) getChroma()) == 0.0d || ((double) getJ()) == 0.0d) ? 0.0f : getChroma() / ((float) Math.sqrt(((double) getJ()) / 100.0d)))) / Math.pow(1.64d - Math.pow(0.29d, (double) viewingConditions.getN()), 0.73d), 1.1111111111111112d);
        double hue = (double) ((getHue() * 3.1415927f) / 180.0f);
        float aw = viewingConditions.getAw() * ((float) Math.pow(((double) getJ()) / 100.0d, (1.0d / ((double) viewingConditions.getC())) / ((double) viewingConditions.getZ())));
        float cos = ((float) (Math.cos(2.0d + hue) + 3.8d)) * 0.25f * 3846.1538f * viewingConditions.getNc() * viewingConditions.getNcb();
        float nbb = aw / viewingConditions.getNbb();
        float sin = (float) Math.sin(hue);
        float cos2 = (float) Math.cos(hue);
        float f = (((0.305f + nbb) * 23.0f) * pow) / (((cos * 23.0f) + ((11.0f * pow) * cos2)) + ((pow * 108.0f) * sin));
        float f2 = cos2 * f;
        float f3 = f * sin;
        float f4 = nbb * 460.0f;
        float f5 = (((451.0f * f2) + f4) + (288.0f * f3)) / 1403.0f;
        float f6 = ((f4 - (891.0f * f2)) - (261.0f * f3)) / 1403.0f;
        float f7 = ((f4 - (f2 * 220.0f)) - (f3 * 6300.0f)) / 1403.0f;
        float signum = Math.signum(f5) * (100.0f / viewingConditions.getFl()) * ((float) Math.pow((double) ((float) Math.max(0.0d, (((double) Math.abs(f5)) * 27.13d) / (400.0d - ((double) Math.abs(f5))))), 2.380952380952381d));
        float signum2 = Math.signum(f6) * (100.0f / viewingConditions.getFl()) * ((float) Math.pow((double) ((float) Math.max(0.0d, (((double) Math.abs(f6)) * 27.13d) / (400.0d - ((double) Math.abs(f6))))), 2.380952380952381d));
        float signum3 = Math.signum(f7) * (100.0f / viewingConditions.getFl()) * ((float) Math.pow((double) ((float) Math.max(0.0d, (((double) Math.abs(f7)) * 27.13d) / (400.0d - ((double) Math.abs(f7))))), 2.380952380952381d));
        float f8 = signum / viewingConditions.getRgbD()[0];
        float f9 = signum2 / viewingConditions.getRgbD()[1];
        float f10 = signum3 / viewingConditions.getRgbD()[2];
        float[][] fArr = CamUtils.CAM16RGB_TO_XYZ;
        float[] fArr2 = fArr[0];
        float f11 = (fArr2[0] * f8) + (fArr2[1] * f9) + (fArr2[2] * f10);
        float[] fArr3 = fArr[1];
        float[] fArr4 = fArr[2];
        return ColorUtils.XYZToColor((double) f11, (double) ((fArr3[0] * f8) + (fArr3[1] * f9) + (fArr3[2] * f10)), (double) ((f8 * fArr4[0]) + (f9 * fArr4[1]) + (f10 * fArr4[2])));
    }

    @ColorInt
    static int toColor(@FloatRange(from = 0.0d, to = 360.0d) float f, @FloatRange(from = 0.0d, to = Double.POSITIVE_INFINITY, toInclusive = false) float f2, @FloatRange(from = 0.0d, to = 100.0d) float f3, @NonNull ViewingConditions viewingConditions) {
        float f4;
        if (((double) f2) < 1.0d || ((double) Math.round(f3)) <= 0.0d || ((double) Math.round(f3)) >= 100.0d) {
            return CamUtils.intFromLStar(f3);
        }
        if (f < 0.0f) {
            f4 = 0.0f;
        } else {
            f4 = Math.min(360.0f, f);
        }
        CamColor camColor = null;
        boolean z = true;
        float f5 = 0.0f;
        float f6 = f2;
        while (Math.abs(f5 - f2) >= CHROMA_SEARCH_ENDPOINT) {
            CamColor findCamByJ = findCamByJ(f4, f6, f3);
            if (z) {
                if (findCamByJ != null) {
                    return findCamByJ.viewed(viewingConditions);
                }
                z = false;
            } else if (findCamByJ == null) {
                f2 = f6;
            } else {
                f5 = f6;
                camColor = findCamByJ;
            }
            f6 = ((f2 - f5) / 2.0f) + f5;
        }
        if (camColor == null) {
            return CamUtils.intFromLStar(f3);
        }
        return camColor.viewed(viewingConditions);
    }

    @Nullable
    private static CamColor findCamByJ(@FloatRange(from = 0.0d, to = 360.0d) float f, @FloatRange(from = 0.0d, to = Double.POSITIVE_INFINITY, toInclusive = false) float f2, @FloatRange(from = 0.0d, to = 100.0d) float f3) {
        float f4 = 1000.0f;
        float f5 = 0.0f;
        CamColor camColor = null;
        float f6 = 100.0f;
        float f7 = 1000.0f;
        while (Math.abs(f5 - f6) > 0.01f) {
            float f8 = ((f6 - f5) / 2.0f) + f5;
            int viewedInSrgb = fromJch(f8, f2, f).viewedInSrgb();
            float lStarFromInt = CamUtils.lStarFromInt(viewedInSrgb);
            float abs = Math.abs(f3 - lStarFromInt);
            if (abs < 0.2f) {
                CamColor fromColor = fromColor(viewedInSrgb);
                float distance = fromColor.distance(fromJch(fromColor.getJ(), fromColor.getChroma(), f));
                if (distance <= 1.0f) {
                    camColor = fromColor;
                    f4 = abs;
                    f7 = distance;
                }
            }
            if (f4 == 0.0f && f7 == 0.0f) {
                break;
            } else if (lStarFromInt < f3) {
                f5 = f8;
            } else {
                f6 = f8;
            }
        }
        return camColor;
    }
}
