package androidx.constraintlayout.motion.widget;

import android.util.Log;
import android.util.SparseArray;
import android.view.View;
import androidx.constraintlayout.motion.utils.CurveFit;
import androidx.constraintlayout.widget.ConstraintAttribute;
import androidx.core.app.NotificationCompat;
import java.lang.reflect.Array;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.DecimalFormat;
import java.util.Arrays;

public abstract class SplineSet {
    private static final String TAG = "SplineSet";
    private int count;
    protected CurveFit mCurveFit;
    protected int[] mTimePoints = new int[10];
    private String mType;
    protected float[] mValues = new float[10];

    public abstract void setProperty(View view, float f);

    public String toString() {
        String str = this.mType;
        DecimalFormat decimalFormat = new DecimalFormat("##.##");
        for (int i = 0; i < this.count; i++) {
            str = str + "[" + this.mTimePoints[i] + " , " + decimalFormat.format((double) this.mValues[i]) + "] ";
        }
        return str;
    }

    public void setType(String str) {
        this.mType = str;
    }

    public float get(float f) {
        return (float) this.mCurveFit.getPos((double) f, 0);
    }

    public float getSlope(float f) {
        return (float) this.mCurveFit.getSlope((double) f, 0);
    }

    public CurveFit getCurveFit() {
        return this.mCurveFit;
    }

    static SplineSet makeCustomSpline(String str, SparseArray<ConstraintAttribute> sparseArray) {
        return new CustomSet(str, sparseArray);
    }

    static SplineSet makeSpline(String str) {
        str.hashCode();
        char c = 65535;
        switch (str.hashCode()) {
            case -1249320806:
                if (str.equals("rotationX")) {
                    c = 0;
                    break;
                }
                break;
            case -1249320805:
                if (str.equals("rotationY")) {
                    c = 1;
                    break;
                }
                break;
            case -1225497657:
                if (str.equals("translationX")) {
                    c = 2;
                    break;
                }
                break;
            case -1225497656:
                if (str.equals("translationY")) {
                    c = 3;
                    break;
                }
                break;
            case -1225497655:
                if (str.equals("translationZ")) {
                    c = 4;
                    break;
                }
                break;
            case -1001078227:
                if (str.equals(NotificationCompat.CATEGORY_PROGRESS)) {
                    c = 5;
                    break;
                }
                break;
            case -908189618:
                if (str.equals("scaleX")) {
                    c = 6;
                    break;
                }
                break;
            case -908189617:
                if (str.equals("scaleY")) {
                    c = 7;
                    break;
                }
                break;
            case -797520672:
                if (str.equals("waveVariesBy")) {
                    c = 8;
                    break;
                }
                break;
            case -40300674:
                if (str.equals("rotation")) {
                    c = 9;
                    break;
                }
                break;
            case -4379043:
                if (str.equals("elevation")) {
                    c = 10;
                    break;
                }
                break;
            case 37232917:
                if (str.equals("transitionPathRotate")) {
                    c = 11;
                    break;
                }
                break;
            case 92909918:
                if (str.equals("alpha")) {
                    c = 12;
                    break;
                }
                break;
            case 156108012:
                if (str.equals("waveOffset")) {
                    c = 13;
                    break;
                }
                break;
        }
        switch (c) {
            case 0:
                return new RotationXset();
            case 1:
                return new RotationYset();
            case 2:
                return new TranslationXset();
            case 3:
                return new TranslationYset();
            case 4:
                return new TranslationZset();
            case 5:
                return new ProgressSet();
            case 6:
                return new ScaleXset();
            case 7:
                return new ScaleYset();
            case 8:
                return new AlphaSet();
            case 9:
                return new RotationSet();
            case 10:
                return new ElevationSet();
            case 11:
                return new PathRotate();
            case 12:
                return new AlphaSet();
            case 13:
                return new AlphaSet();
            default:
                return null;
        }
    }

    public void setPoint(int i, float f) {
        int[] iArr = this.mTimePoints;
        if (iArr.length < this.count + 1) {
            this.mTimePoints = Arrays.copyOf(iArr, iArr.length * 2);
            float[] fArr = this.mValues;
            this.mValues = Arrays.copyOf(fArr, fArr.length * 2);
        }
        int[] iArr2 = this.mTimePoints;
        int i2 = this.count;
        iArr2[i2] = i;
        this.mValues[i2] = f;
        this.count = i2 + 1;
    }

    public void setup(int i) {
        int i2 = this.count;
        if (i2 != 0) {
            Sort.doubleQuickSort(this.mTimePoints, this.mValues, 0, i2 - 1);
            int i3 = 1;
            for (int i4 = 1; i4 < this.count; i4++) {
                int[] iArr = this.mTimePoints;
                if (iArr[i4 - 1] != iArr[i4]) {
                    i3++;
                }
            }
            double[] dArr = new double[i3];
            int[] iArr2 = new int[2];
            iArr2[1] = 1;
            iArr2[0] = i3;
            double[][] dArr2 = (double[][]) Array.newInstance(double.class, iArr2);
            int i5 = 0;
            for (int i6 = 0; i6 < this.count; i6++) {
                if (i6 > 0) {
                    int[] iArr3 = this.mTimePoints;
                    if (iArr3[i6] == iArr3[i6 - 1]) {
                    }
                }
                dArr[i5] = ((double) this.mTimePoints[i6]) * 0.01d;
                dArr2[i5][0] = (double) this.mValues[i6];
                i5++;
            }
            this.mCurveFit = CurveFit.get(i, dArr, dArr2);
        }
    }

    static class ElevationSet extends SplineSet {
        ElevationSet() {
        }

        public void setProperty(View view, float f) {
            view.setElevation(get(f));
        }
    }

    static class AlphaSet extends SplineSet {
        AlphaSet() {
        }

        public void setProperty(View view, float f) {
            view.setAlpha(get(f));
        }
    }

    static class RotationSet extends SplineSet {
        RotationSet() {
        }

        public void setProperty(View view, float f) {
            view.setRotation(get(f));
        }
    }

    static class RotationXset extends SplineSet {
        RotationXset() {
        }

        public void setProperty(View view, float f) {
            view.setRotationX(get(f));
        }
    }

    static class RotationYset extends SplineSet {
        RotationYset() {
        }

        public void setProperty(View view, float f) {
            view.setRotationY(get(f));
        }
    }

    static class PathRotate extends SplineSet {
        public void setProperty(View view, float f) {
        }

        PathRotate() {
        }

        public void setPathRotate(View view, float f, double d, double d2) {
            view.setRotation(get(f) + ((float) Math.toDegrees(Math.atan2(d2, d))));
        }
    }

    static class ScaleXset extends SplineSet {
        ScaleXset() {
        }

        public void setProperty(View view, float f) {
            view.setScaleX(get(f));
        }
    }

    static class ScaleYset extends SplineSet {
        ScaleYset() {
        }

        public void setProperty(View view, float f) {
            view.setScaleY(get(f));
        }
    }

    static class TranslationXset extends SplineSet {
        TranslationXset() {
        }

        public void setProperty(View view, float f) {
            view.setTranslationX(get(f));
        }
    }

    static class TranslationYset extends SplineSet {
        TranslationYset() {
        }

        public void setProperty(View view, float f) {
            view.setTranslationY(get(f));
        }
    }

    static class TranslationZset extends SplineSet {
        TranslationZset() {
        }

        public void setProperty(View view, float f) {
            view.setTranslationZ(get(f));
        }
    }

    static class CustomSet extends SplineSet {
        String mAttributeName;
        SparseArray<ConstraintAttribute> mConstraintAttributeList;
        float[] mTempValues;

        public CustomSet(String str, SparseArray<ConstraintAttribute> sparseArray) {
            this.mAttributeName = str.split(",")[1];
            this.mConstraintAttributeList = sparseArray;
        }

        public void setup(int i) {
            int size = this.mConstraintAttributeList.size();
            int noOfInterpValues = this.mConstraintAttributeList.valueAt(0).noOfInterpValues();
            double[] dArr = new double[size];
            this.mTempValues = new float[noOfInterpValues];
            int[] iArr = new int[2];
            iArr[1] = noOfInterpValues;
            iArr[0] = size;
            double[][] dArr2 = (double[][]) Array.newInstance(double.class, iArr);
            for (int i2 = 0; i2 < size; i2++) {
                dArr[i2] = ((double) this.mConstraintAttributeList.keyAt(i2)) * 0.01d;
                this.mConstraintAttributeList.valueAt(i2).getValuesToInterpolate(this.mTempValues);
                int i3 = 0;
                while (true) {
                    float[] fArr = this.mTempValues;
                    if (i3 >= fArr.length) {
                        break;
                    }
                    dArr2[i2][i3] = (double) fArr[i3];
                    i3++;
                }
            }
            this.mCurveFit = CurveFit.get(i, dArr, dArr2);
        }

        public void setPoint(int i, float f) {
            throw new RuntimeException("don't call for custom attribute call setPoint(pos, ConstraintAttribute)");
        }

        public void setPoint(int i, ConstraintAttribute constraintAttribute) {
            this.mConstraintAttributeList.append(i, constraintAttribute);
        }

        public void setProperty(View view, float f) {
            this.mCurveFit.getPos((double) f, this.mTempValues);
            this.mConstraintAttributeList.valueAt(0).setInterpolatedValue(view, this.mTempValues);
        }
    }

    static class ProgressSet extends SplineSet {
        boolean mNoMethod = false;

        ProgressSet() {
        }

        public void setProperty(View view, float f) {
            if (view instanceof MotionLayout) {
                ((MotionLayout) view).setProgress(get(f));
            } else if (!this.mNoMethod) {
                Method method = null;
                try {
                    method = view.getClass().getMethod("setProgress", new Class[]{Float.TYPE});
                } catch (NoSuchMethodException unused) {
                    this.mNoMethod = true;
                }
                if (method != null) {
                    try {
                        method.invoke(view, new Object[]{Float.valueOf(get(f))});
                    } catch (IllegalAccessException e) {
                        Log.e(SplineSet.TAG, "unable to setProgress", e);
                    } catch (InvocationTargetException e2) {
                        Log.e(SplineSet.TAG, "unable to setProgress", e2);
                    }
                }
            }
        }
    }

    private static class Sort {
        private Sort() {
        }

        static void doubleQuickSort(int[] iArr, float[] fArr, int i, int i2) {
            int[] iArr2 = new int[(iArr.length + 10)];
            iArr2[0] = i2;
            iArr2[1] = i;
            int i3 = 2;
            while (i3 > 0) {
                int i4 = i3 - 1;
                int i5 = iArr2[i4];
                i3 = i4 - 1;
                int i6 = iArr2[i3];
                if (i5 < i6) {
                    int partition = partition(iArr, fArr, i5, i6);
                    int i7 = i3 + 1;
                    iArr2[i3] = partition - 1;
                    int i8 = i7 + 1;
                    iArr2[i7] = i5;
                    int i9 = i8 + 1;
                    iArr2[i8] = i6;
                    i3 = i9 + 1;
                    iArr2[i9] = partition + 1;
                }
            }
        }

        private static int partition(int[] iArr, float[] fArr, int i, int i2) {
            int i3 = iArr[i2];
            int i4 = i;
            while (i < i2) {
                if (iArr[i] <= i3) {
                    swap(iArr, fArr, i4, i);
                    i4++;
                }
                i++;
            }
            swap(iArr, fArr, i4, i2);
            return i4;
        }

        private static void swap(int[] iArr, float[] fArr, int i, int i2) {
            int i3 = iArr[i];
            iArr[i] = iArr[i2];
            iArr[i2] = i3;
            float f = fArr[i];
            fArr[i] = fArr[i2];
            fArr[i2] = f;
        }
    }
}
