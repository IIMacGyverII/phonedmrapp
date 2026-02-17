package androidx.interpolator.view.animation;

final class LookupTableInterpolator {
    private LookupTableInterpolator() {
    }

    static float interpolate(float[] fArr, float f, float f2) {
        if (f2 >= 1.0f) {
            return 1.0f;
        }
        if (f2 <= 0.0f) {
            return 0.0f;
        }
        int min = Math.min((int) (((float) (fArr.length - 1)) * f2), fArr.length - 2);
        float f3 = (f2 - (((float) min) * f)) / f;
        float f4 = fArr[min];
        return f4 + (f3 * (fArr[min + 1] - f4));
    }
}
