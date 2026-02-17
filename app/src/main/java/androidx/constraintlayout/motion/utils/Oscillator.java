package androidx.constraintlayout.motion.utils;

import java.util.Arrays;

public class Oscillator {
    public static final int BOUNCE = 6;
    public static final int COS_WAVE = 5;
    public static final int REVERSE_SAW_WAVE = 4;
    public static final int SAW_WAVE = 3;
    public static final int SIN_WAVE = 0;
    public static final int SQUARE_WAVE = 1;
    public static String TAG = "Oscillator";
    public static final int TRIANGLE_WAVE = 2;
    double PI2 = 6.283185307179586d;
    double[] mArea;
    private boolean mNormalized = false;
    float[] mPeriod = new float[0];
    double[] mPosition = new double[0];
    int mType;

    public String toString() {
        return "pos =" + Arrays.toString(this.mPosition) + " period=" + Arrays.toString(this.mPeriod);
    }

    public void setType(int i) {
        this.mType = i;
    }

    public void addPoint(double d, float f) {
        int length = this.mPeriod.length + 1;
        int binarySearch = Arrays.binarySearch(this.mPosition, d);
        if (binarySearch < 0) {
            binarySearch = (-binarySearch) - 1;
        }
        this.mPosition = Arrays.copyOf(this.mPosition, length);
        this.mPeriod = Arrays.copyOf(this.mPeriod, length);
        this.mArea = new double[length];
        double[] dArr = this.mPosition;
        System.arraycopy(dArr, binarySearch, dArr, binarySearch + 1, (length - binarySearch) - 1);
        this.mPosition[binarySearch] = d;
        this.mPeriod[binarySearch] = f;
        this.mNormalized = false;
    }

    public void normalize() {
        int i = 0;
        double d = 0.0d;
        while (true) {
            float[] fArr = this.mPeriod;
            if (i >= fArr.length) {
                break;
            }
            d += (double) fArr[i];
            i++;
        }
        double d2 = 0.0d;
        int i2 = 1;
        while (true) {
            float[] fArr2 = this.mPeriod;
            if (i2 >= fArr2.length) {
                break;
            }
            int i3 = i2 - 1;
            double[] dArr = this.mPosition;
            d2 += (dArr[i2] - dArr[i3]) * ((double) ((fArr2[i3] + fArr2[i2]) / 2.0f));
            i2++;
        }
        int i4 = 0;
        while (true) {
            float[] fArr3 = this.mPeriod;
            if (i4 >= fArr3.length) {
                break;
            }
            fArr3[i4] = (float) (((double) fArr3[i4]) * (d / d2));
            i4++;
        }
        this.mArea[0] = 0.0d;
        int i5 = 1;
        while (true) {
            float[] fArr4 = this.mPeriod;
            if (i5 < fArr4.length) {
                int i6 = i5 - 1;
                double[] dArr2 = this.mPosition;
                double d3 = dArr2[i5] - dArr2[i6];
                double[] dArr3 = this.mArea;
                dArr3[i5] = dArr3[i6] + (d3 * ((double) ((fArr4[i6] + fArr4[i5]) / 2.0f)));
                i5++;
            } else {
                this.mNormalized = true;
                return;
            }
        }
    }

    /* access modifiers changed from: package-private */
    public double getP(double d) {
        if (d < 0.0d) {
            d = 0.0d;
        } else if (d > 1.0d) {
            d = 1.0d;
        }
        int binarySearch = Arrays.binarySearch(this.mPosition, d);
        if (binarySearch > 0) {
            return 1.0d;
        }
        if (binarySearch == 0) {
            return 0.0d;
        }
        int i = (-binarySearch) - 1;
        float[] fArr = this.mPeriod;
        float f = fArr[i];
        int i2 = i - 1;
        float f2 = fArr[i2];
        double d2 = (double) (f - f2);
        double[] dArr = this.mPosition;
        double d3 = dArr[i];
        double d4 = dArr[i2];
        double d5 = d2 / (d3 - d4);
        return this.mArea[i2] + ((((double) f2) - (d5 * d4)) * (d - d4)) + ((d5 * ((d * d) - (d4 * d4))) / 2.0d);
    }

    public double getValue(double d) {
        double abs;
        switch (this.mType) {
            case 1:
                return Math.signum(0.5d - (getP(d) % 1.0d));
            case 2:
                abs = Math.abs((((getP(d) * 4.0d) + 1.0d) % 4.0d) - 2.0d);
                break;
            case 3:
                return (((getP(d) * 2.0d) + 1.0d) % 2.0d) - 1.0d;
            case 4:
                abs = ((getP(d) * 2.0d) + 1.0d) % 2.0d;
                break;
            case 5:
                return Math.cos(this.PI2 * getP(d));
            case 6:
                double abs2 = 1.0d - Math.abs(((getP(d) * 4.0d) % 4.0d) - 2.0d);
                abs = abs2 * abs2;
                break;
            default:
                return Math.sin(this.PI2 * getP(d));
        }
        return 1.0d - abs;
    }

    /* access modifiers changed from: package-private */
    public double getDP(double d) {
        if (d <= 0.0d) {
            d = 1.0E-5d;
        } else if (d >= 1.0d) {
            d = 0.999999d;
        }
        int binarySearch = Arrays.binarySearch(this.mPosition, d);
        if (binarySearch > 0 || binarySearch == 0) {
            return 0.0d;
        }
        int i = (-binarySearch) - 1;
        float[] fArr = this.mPeriod;
        float f = fArr[i];
        int i2 = i - 1;
        float f2 = fArr[i2];
        double d2 = (double) (f - f2);
        double[] dArr = this.mPosition;
        double d3 = dArr[i];
        double d4 = dArr[i2];
        double d5 = d2 / (d3 - d4);
        return (((double) f2) - (d5 * d4)) + (d * d5);
    }

    /* JADX WARNING: Code restructure failed: missing block: B:11:0x0046, code lost:
        return r9 * 2.0d;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:4:0x001c, code lost:
        return r0 * r9;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:7:0x002b, code lost:
        return r5 * r9;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public double getSlope(double r10) {
        /*
            r9 = this;
            int r0 = r9.mType
            r1 = 4611686018427387904(0x4000000000000000, double:2.0)
            r3 = 4616189618054758400(0x4010000000000000, double:4.0)
            switch(r0) {
                case 1: goto L_0x0060;
                case 2: goto L_0x004c;
                case 3: goto L_0x0047;
                case 4: goto L_0x0040;
                case 5: goto L_0x002c;
                case 6: goto L_0x001d;
                default: goto L_0x0009;
            }
        L_0x0009:
            double r0 = r9.PI2
            double r2 = r9.getDP(r10)
            double r0 = r0 * r2
            double r2 = r9.PI2
            double r9 = r9.getP(r10)
            double r2 = r2 * r9
            double r9 = java.lang.Math.cos(r2)
        L_0x001b:
            double r0 = r0 * r9
            return r0
        L_0x001d:
            double r5 = r9.getDP(r10)
            double r5 = r5 * r3
            double r9 = r9.getP(r10)
            double r9 = r9 * r3
            double r9 = r9 + r1
            double r9 = r9 % r3
            double r9 = r9 - r1
        L_0x002a:
            double r5 = r5 * r9
            return r5
        L_0x002c:
            double r0 = r9.PI2
            double r0 = -r0
            double r2 = r9.getDP(r10)
            double r0 = r0 * r2
            double r2 = r9.PI2
            double r9 = r9.getP(r10)
            double r2 = r2 * r9
            double r9 = java.lang.Math.sin(r2)
            goto L_0x001b
        L_0x0040:
            double r9 = r9.getDP(r10)
            double r9 = -r9
        L_0x0045:
            double r9 = r9 * r1
            return r9
        L_0x0047:
            double r9 = r9.getDP(r10)
            goto L_0x0045
        L_0x004c:
            double r5 = r9.getDP(r10)
            double r5 = r5 * r3
            double r9 = r9.getP(r10)
            double r9 = r9 * r3
            r7 = 4613937818241073152(0x4008000000000000, double:3.0)
            double r9 = r9 + r7
            double r9 = r9 % r3
            double r9 = r9 - r1
            double r9 = java.lang.Math.signum(r9)
            goto L_0x002a
        L_0x0060:
            r9 = 0
            return r9
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.motion.utils.Oscillator.getSlope(double):double");
    }
}
