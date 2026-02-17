package androidx.constraintlayout.motion.utils;

import java.util.Arrays;

class ArcCurveFit extends CurveFit {
    public static final int ARC_START_FLIP = 3;
    public static final int ARC_START_HORIZONTAL = 2;
    public static final int ARC_START_LINEAR = 0;
    public static final int ARC_START_VERTICAL = 1;
    private static final int START_HORIZONTAL = 2;
    private static final int START_LINEAR = 3;
    private static final int START_VERTICAL = 1;
    Arc[] mArcs;
    private final double[] mTime;

    public void getPos(double d, double[] dArr) {
        Arc[] arcArr = this.mArcs;
        double d2 = arcArr[0].mTime1;
        if (d < d2) {
            d = d2;
        }
        if (d > arcArr[arcArr.length - 1].mTime2) {
            d = arcArr[arcArr.length - 1].mTime2;
        }
        int i = 0;
        while (true) {
            Arc[] arcArr2 = this.mArcs;
            if (i < arcArr2.length) {
                Arc arc = arcArr2[i];
                if (d > arc.mTime2) {
                    i++;
                } else if (arc.linear) {
                    dArr[0] = arc.getLinearX(d);
                    dArr[1] = this.mArcs[i].getLinearY(d);
                    return;
                } else {
                    arc.setPoint(d);
                    dArr[0] = this.mArcs[i].getX();
                    dArr[1] = this.mArcs[i].getY();
                    return;
                }
            } else {
                return;
            }
        }
    }

    public void getPos(double d, float[] fArr) {
        Arc[] arcArr = this.mArcs;
        double d2 = arcArr[0].mTime1;
        if (d < d2) {
            d = d2;
        } else if (d > arcArr[arcArr.length - 1].mTime2) {
            d = arcArr[arcArr.length - 1].mTime2;
        }
        int i = 0;
        while (true) {
            Arc[] arcArr2 = this.mArcs;
            if (i < arcArr2.length) {
                Arc arc = arcArr2[i];
                if (d > arc.mTime2) {
                    i++;
                } else if (arc.linear) {
                    fArr[0] = (float) arc.getLinearX(d);
                    fArr[1] = (float) this.mArcs[i].getLinearY(d);
                    return;
                } else {
                    arc.setPoint(d);
                    fArr[0] = (float) this.mArcs[i].getX();
                    fArr[1] = (float) this.mArcs[i].getY();
                    return;
                }
            } else {
                return;
            }
        }
    }

    public void getSlope(double d, double[] dArr) {
        Arc[] arcArr = this.mArcs;
        double d2 = arcArr[0].mTime1;
        if (d < d2) {
            d = d2;
        } else if (d > arcArr[arcArr.length - 1].mTime2) {
            d = arcArr[arcArr.length - 1].mTime2;
        }
        int i = 0;
        while (true) {
            Arc[] arcArr2 = this.mArcs;
            if (i < arcArr2.length) {
                Arc arc = arcArr2[i];
                if (d > arc.mTime2) {
                    i++;
                } else if (arc.linear) {
                    dArr[0] = arc.getLinearDX(d);
                    dArr[1] = this.mArcs[i].getLinearDY(d);
                    return;
                } else {
                    arc.setPoint(d);
                    dArr[0] = this.mArcs[i].getDX();
                    dArr[1] = this.mArcs[i].getDY();
                    return;
                }
            } else {
                return;
            }
        }
    }

    public double getPos(double d, int i) {
        Arc[] arcArr = this.mArcs;
        int i2 = 0;
        double d2 = arcArr[0].mTime1;
        if (d < d2) {
            d = d2;
        } else if (d > arcArr[arcArr.length - 1].mTime2) {
            d = arcArr[arcArr.length - 1].mTime2;
        }
        while (true) {
            Arc[] arcArr2 = this.mArcs;
            if (i2 >= arcArr2.length) {
                return Double.NaN;
            }
            Arc arc = arcArr2[i2];
            if (d > arc.mTime2) {
                i2++;
            } else if (!arc.linear) {
                arc.setPoint(d);
                if (i == 0) {
                    return this.mArcs[i2].getX();
                }
                return this.mArcs[i2].getY();
            } else if (i == 0) {
                return arc.getLinearX(d);
            } else {
                return arc.getLinearY(d);
            }
        }
    }

    public double getSlope(double d, int i) {
        Arc[] arcArr = this.mArcs;
        int i2 = 0;
        double d2 = arcArr[0].mTime1;
        if (d < d2) {
            d = d2;
        }
        if (d > arcArr[arcArr.length - 1].mTime2) {
            d = arcArr[arcArr.length - 1].mTime2;
        }
        while (true) {
            Arc[] arcArr2 = this.mArcs;
            if (i2 >= arcArr2.length) {
                return Double.NaN;
            }
            Arc arc = arcArr2[i2];
            if (d > arc.mTime2) {
                i2++;
            } else if (!arc.linear) {
                arc.setPoint(d);
                if (i == 0) {
                    return this.mArcs[i2].getDX();
                }
                return this.mArcs[i2].getDY();
            } else if (i == 0) {
                return arc.getLinearDX(d);
            } else {
                return arc.getLinearDY(d);
            }
        }
    }

    public double[] getTimePoints() {
        return this.mTime;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:8:0x0026, code lost:
        if (r5 == 1) goto L_0x0028;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public ArcCurveFit(int[] r25, double[] r26, double[][] r27) {
        /*
            r24 = this;
            r0 = r24
            r1 = r26
            r24.<init>()
            r0.mTime = r1
            int r2 = r1.length
            r3 = 1
            int r2 = r2 - r3
            androidx.constraintlayout.motion.utils.ArcCurveFit$Arc[] r2 = new androidx.constraintlayout.motion.utils.ArcCurveFit.Arc[r2]
            r0.mArcs = r2
            r2 = 0
            r4 = r2
            r5 = r3
            r6 = r5
        L_0x0014:
            androidx.constraintlayout.motion.utils.ArcCurveFit$Arc[] r7 = r0.mArcs
            int r8 = r7.length
            if (r4 >= r8) goto L_0x004d
            r8 = r25[r4]
            r9 = 3
            r10 = 2
            if (r8 == 0) goto L_0x002d
            if (r8 == r3) goto L_0x002a
            if (r8 == r10) goto L_0x0028
            if (r8 == r9) goto L_0x0026
            goto L_0x002e
        L_0x0026:
            if (r5 != r3) goto L_0x002a
        L_0x0028:
            r5 = r10
            goto L_0x002b
        L_0x002a:
            r5 = r3
        L_0x002b:
            r6 = r5
            goto L_0x002e
        L_0x002d:
            r6 = r9
        L_0x002e:
            androidx.constraintlayout.motion.utils.ArcCurveFit$Arc r22 = new androidx.constraintlayout.motion.utils.ArcCurveFit$Arc
            r10 = r1[r4]
            int r23 = r4 + 1
            r12 = r1[r23]
            r8 = r27[r4]
            r14 = r8[r2]
            r16 = r8[r3]
            r8 = r27[r23]
            r18 = r8[r2]
            r20 = r8[r3]
            r8 = r22
            r9 = r6
            r8.<init>(r9, r10, r12, r14, r16, r18, r20)
            r7[r4] = r22
            r4 = r23
            goto L_0x0014
        L_0x004d:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.motion.utils.ArcCurveFit.<init>(int[], double[], double[][]):void");
    }

    private static class Arc {
        private static final double EPSILON = 0.001d;
        private static final String TAG = "Arc";
        private static double[] ourPercent = new double[91];
        boolean linear = false;
        double mArcDistance;
        double mArcVelocity;
        double mEllipseA;
        double mEllipseB;
        double mEllipseCenterX;
        double mEllipseCenterY;
        double[] mLut;
        double mOneOverDeltaTime;
        double mTime1;
        double mTime2;
        double mTmpCosAngle;
        double mTmpSinAngle;
        boolean mVertical;
        double mX1;
        double mX2;
        double mY1;
        double mY2;

        Arc(int i, double d, double d2, double d3, double d4, double d5, double d6) {
            int i2 = i;
            double d7 = d;
            double d8 = d2;
            double d9 = d3;
            double d10 = d4;
            double d11 = d5;
            double d12 = d6;
            boolean z = false;
            int i3 = 1;
            this.mVertical = i2 == 1 ? true : z;
            this.mTime1 = d7;
            this.mTime2 = d8;
            this.mOneOverDeltaTime = 1.0d / (d8 - d7);
            if (3 == i2) {
                this.linear = true;
            }
            double d13 = d11 - d9;
            double d14 = d12 - d10;
            if (this.linear || Math.abs(d13) < EPSILON || Math.abs(d14) < EPSILON) {
                this.linear = true;
                this.mX1 = d9;
                this.mX2 = d11;
                this.mY1 = d10;
                this.mY2 = d6;
                double hypot = Math.hypot(d14, d13);
                this.mArcDistance = hypot;
                this.mArcVelocity = hypot * this.mOneOverDeltaTime;
                double d15 = this.mTime2;
                double d16 = this.mTime1;
                this.mEllipseCenterX = d13 / (d15 - d16);
                this.mEllipseCenterY = d14 / (d15 - d16);
                return;
            }
            this.mLut = new double[101];
            boolean z2 = this.mVertical;
            this.mEllipseA = d13 * ((double) (z2 ? -1 : 1));
            this.mEllipseB = d14 * ((double) (!z2 ? -1 : i3));
            this.mEllipseCenterX = z2 ? d11 : d9;
            this.mEllipseCenterY = z2 ? d10 : d6;
            buildTable(d3, d4, d5, d6);
            this.mArcVelocity = this.mArcDistance * this.mOneOverDeltaTime;
        }

        /* access modifiers changed from: package-private */
        public void setPoint(double d) {
            double lookup = lookup((this.mVertical ? this.mTime2 - d : d - this.mTime1) * this.mOneOverDeltaTime) * 1.5707963267948966d;
            this.mTmpSinAngle = Math.sin(lookup);
            this.mTmpCosAngle = Math.cos(lookup);
        }

        /* access modifiers changed from: package-private */
        public double getX() {
            return this.mEllipseCenterX + (this.mEllipseA * this.mTmpSinAngle);
        }

        /* access modifiers changed from: package-private */
        public double getY() {
            return this.mEllipseCenterY + (this.mEllipseB * this.mTmpCosAngle);
        }

        /* access modifiers changed from: package-private */
        public double getDX() {
            double d = this.mEllipseA * this.mTmpCosAngle;
            double hypot = this.mArcVelocity / Math.hypot(d, (-this.mEllipseB) * this.mTmpSinAngle);
            if (this.mVertical) {
                d = -d;
            }
            return d * hypot;
        }

        /* access modifiers changed from: package-private */
        public double getDY() {
            double d = this.mEllipseA * this.mTmpCosAngle;
            double d2 = (-this.mEllipseB) * this.mTmpSinAngle;
            double hypot = this.mArcVelocity / Math.hypot(d, d2);
            return this.mVertical ? (-d2) * hypot : d2 * hypot;
        }

        public double getLinearX(double d) {
            double d2 = (d - this.mTime1) * this.mOneOverDeltaTime;
            double d3 = this.mX1;
            return d3 + (d2 * (this.mX2 - d3));
        }

        public double getLinearY(double d) {
            double d2 = (d - this.mTime1) * this.mOneOverDeltaTime;
            double d3 = this.mY1;
            return d3 + (d2 * (this.mY2 - d3));
        }

        public double getLinearDX(double d) {
            return this.mEllipseCenterX;
        }

        public double getLinearDY(double d) {
            return this.mEllipseCenterY;
        }

        /* access modifiers changed from: package-private */
        public double lookup(double d) {
            if (d <= 0.0d) {
                return 0.0d;
            }
            if (d >= 1.0d) {
                return 1.0d;
            }
            double[] dArr = this.mLut;
            double length = d * ((double) (dArr.length - 1));
            int i = (int) length;
            double d2 = length - ((double) i);
            double d3 = dArr[i];
            return d3 + (d2 * (dArr[i + 1] - d3));
        }

        private void buildTable(double d, double d2, double d3, double d4) {
            double d5;
            double d6 = d3 - d;
            double d7 = d2 - d4;
            int i = 0;
            double d8 = 0.0d;
            double d9 = 0.0d;
            double d10 = 0.0d;
            while (true) {
                double[] dArr = ourPercent;
                if (i >= dArr.length) {
                    break;
                }
                double d11 = d8;
                double radians = Math.toRadians((((double) i) * 90.0d) / ((double) (dArr.length - 1)));
                double sin = Math.sin(radians) * d6;
                double cos = Math.cos(radians) * d7;
                if (i > 0) {
                    d5 = Math.hypot(sin - d9, cos - d10) + d11;
                    ourPercent[i] = d5;
                } else {
                    d5 = d11;
                }
                i++;
                d10 = cos;
                double d12 = sin;
                d8 = d5;
                d9 = d12;
            }
            double d13 = d8;
            this.mArcDistance = d13;
            int i2 = 0;
            while (true) {
                double[] dArr2 = ourPercent;
                if (i2 >= dArr2.length) {
                    break;
                }
                dArr2[i2] = dArr2[i2] / d13;
                i2++;
            }
            int i3 = 0;
            while (true) {
                double[] dArr3 = this.mLut;
                if (i3 < dArr3.length) {
                    double length = ((double) i3) / ((double) (dArr3.length - 1));
                    int binarySearch = Arrays.binarySearch(ourPercent, length);
                    if (binarySearch >= 0) {
                        this.mLut[i3] = (double) (binarySearch / (ourPercent.length - 1));
                    } else if (binarySearch == -1) {
                        this.mLut[i3] = 0.0d;
                    } else {
                        int i4 = -binarySearch;
                        int i5 = i4 - 2;
                        double[] dArr4 = ourPercent;
                        double d14 = dArr4[i5];
                        this.mLut[i3] = (((double) i5) + ((length - d14) / (dArr4[i4 - 1] - d14))) / ((double) (dArr4.length - 1));
                    }
                    i3++;
                } else {
                    return;
                }
            }
        }
    }
}
