package androidx.constraintlayout.motion.widget;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.util.Log;
import android.util.SparseIntArray;
import android.view.View;
import androidx.constraintlayout.widget.R;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.HashSet;

public class KeyTrigger extends Key {
    public static final int KEY_TYPE = 5;
    static final String NAME = "KeyTrigger";
    private static final String TAG = "KeyTrigger";
    RectF mCollisionRect;
    /* access modifiers changed from: private */
    public String mCross = null;
    private int mCurveFit = -1;
    private Method mFireCross;
    private boolean mFireCrossReset;
    private float mFireLastPos;
    private Method mFireNegativeCross;
    private boolean mFireNegativeReset;
    private Method mFirePositiveCross;
    private boolean mFirePositiveReset;
    /* access modifiers changed from: private */
    public float mFireThreshold;
    /* access modifiers changed from: private */
    public String mNegativeCross;
    /* access modifiers changed from: private */
    public String mPositiveCross;
    /* access modifiers changed from: private */
    public boolean mPostLayout;
    RectF mTargetRect;
    /* access modifiers changed from: private */
    public int mTriggerCollisionId;
    private View mTriggerCollisionView;
    /* access modifiers changed from: private */
    public int mTriggerID;
    /* access modifiers changed from: private */
    public int mTriggerReceiver;
    float mTriggerSlack;

    public void addValues(HashMap<String, SplineSet> hashMap) {
    }

    public void getAttributeNames(HashSet<String> hashSet) {
    }

    public void setValue(String str, Object obj) {
    }

    public KeyTrigger() {
        int i = Key.UNSET;
        this.mTriggerReceiver = i;
        this.mNegativeCross = null;
        this.mPositiveCross = null;
        this.mTriggerID = i;
        this.mTriggerCollisionId = i;
        this.mTriggerCollisionView = null;
        this.mTriggerSlack = 0.1f;
        this.mFireCrossReset = true;
        this.mFireNegativeReset = true;
        this.mFirePositiveReset = true;
        this.mFireThreshold = Float.NaN;
        this.mPostLayout = false;
        this.mCollisionRect = new RectF();
        this.mTargetRect = new RectF();
        this.mType = 5;
        this.mCustomConstraints = new HashMap<>();
    }

    public void load(Context context, AttributeSet attributeSet) {
        Loader.read(this, context.obtainStyledAttributes(attributeSet, R.styleable.KeyTrigger), context);
    }

    /* access modifiers changed from: package-private */
    public int getCurveFit() {
        return this.mCurveFit;
    }

    private void setUpRect(RectF rectF, View view, boolean z) {
        rectF.top = (float) view.getTop();
        rectF.bottom = (float) view.getBottom();
        rectF.left = (float) view.getLeft();
        rectF.right = (float) view.getRight();
        if (z) {
            view.getMatrix().mapRect(rectF);
        }
    }

    /* JADX WARNING: Removed duplicated region for block: B:36:0x008d  */
    /* JADX WARNING: Removed duplicated region for block: B:41:0x00a1  */
    /* JADX WARNING: Removed duplicated region for block: B:47:0x00b6  */
    /* JADX WARNING: Removed duplicated region for block: B:52:0x00c9  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void conditionallyFire(float r11, android.view.View r12) {
        /*
            r10 = this;
            int r0 = r10.mTriggerCollisionId
            int r1 = androidx.constraintlayout.motion.widget.Key.UNSET
            r2 = 1
            r3 = 0
            if (r0 == r1) goto L_0x0063
            android.view.View r0 = r10.mTriggerCollisionView
            if (r0 != 0) goto L_0x001a
            android.view.ViewParent r0 = r12.getParent()
            android.view.ViewGroup r0 = (android.view.ViewGroup) r0
            int r1 = r10.mTriggerCollisionId
            android.view.View r0 = r0.findViewById(r1)
            r10.mTriggerCollisionView = r0
        L_0x001a:
            android.graphics.RectF r0 = r10.mCollisionRect
            android.view.View r1 = r10.mTriggerCollisionView
            boolean r4 = r10.mPostLayout
            r10.setUpRect(r0, r1, r4)
            android.graphics.RectF r0 = r10.mTargetRect
            boolean r1 = r10.mPostLayout
            r10.setUpRect(r0, r12, r1)
            android.graphics.RectF r0 = r10.mCollisionRect
            android.graphics.RectF r1 = r10.mTargetRect
            boolean r0 = r0.intersect(r1)
            if (r0 == 0) goto L_0x004c
            boolean r0 = r10.mFireCrossReset
            if (r0 == 0) goto L_0x003c
            r10.mFireCrossReset = r3
            r0 = r2
            goto L_0x003d
        L_0x003c:
            r0 = r3
        L_0x003d:
            boolean r1 = r10.mFirePositiveReset
            if (r1 == 0) goto L_0x0045
            r10.mFirePositiveReset = r3
            r1 = r2
            goto L_0x0046
        L_0x0045:
            r1 = r3
        L_0x0046:
            r10.mFireNegativeReset = r2
            r2 = r1
            r1 = r3
            goto L_0x00db
        L_0x004c:
            boolean r0 = r10.mFireCrossReset
            if (r0 != 0) goto L_0x0054
            r10.mFireCrossReset = r2
            r0 = r2
            goto L_0x0055
        L_0x0054:
            r0 = r3
        L_0x0055:
            boolean r1 = r10.mFireNegativeReset
            if (r1 == 0) goto L_0x005d
            r10.mFireNegativeReset = r3
            r1 = r2
            goto L_0x005e
        L_0x005d:
            r1 = r3
        L_0x005e:
            r10.mFirePositiveReset = r2
            r2 = r3
            goto L_0x00db
        L_0x0063:
            boolean r0 = r10.mFireCrossReset
            r1 = 0
            if (r0 == 0) goto L_0x0078
            float r0 = r10.mFireThreshold
            float r4 = r11 - r0
            float r5 = r10.mFireLastPos
            float r5 = r5 - r0
            float r4 = r4 * r5
            int r0 = (r4 > r1 ? 1 : (r4 == r1 ? 0 : -1))
            if (r0 >= 0) goto L_0x0088
            r10.mFireCrossReset = r3
            r0 = r2
            goto L_0x0089
        L_0x0078:
            float r0 = r10.mFireThreshold
            float r0 = r11 - r0
            float r0 = java.lang.Math.abs(r0)
            float r4 = r10.mTriggerSlack
            int r0 = (r0 > r4 ? 1 : (r0 == r4 ? 0 : -1))
            if (r0 <= 0) goto L_0x0088
            r10.mFireCrossReset = r2
        L_0x0088:
            r0 = r3
        L_0x0089:
            boolean r4 = r10.mFireNegativeReset
            if (r4 == 0) goto L_0x00a1
            float r4 = r10.mFireThreshold
            float r5 = r11 - r4
            float r6 = r10.mFireLastPos
            float r6 = r6 - r4
            float r6 = r6 * r5
            int r4 = (r6 > r1 ? 1 : (r6 == r1 ? 0 : -1))
            if (r4 >= 0) goto L_0x00b1
            int r4 = (r5 > r1 ? 1 : (r5 == r1 ? 0 : -1))
            if (r4 >= 0) goto L_0x00b1
            r10.mFireNegativeReset = r3
            r4 = r2
            goto L_0x00b2
        L_0x00a1:
            float r4 = r10.mFireThreshold
            float r4 = r11 - r4
            float r4 = java.lang.Math.abs(r4)
            float r5 = r10.mTriggerSlack
            int r4 = (r4 > r5 ? 1 : (r4 == r5 ? 0 : -1))
            if (r4 <= 0) goto L_0x00b1
            r10.mFireNegativeReset = r2
        L_0x00b1:
            r4 = r3
        L_0x00b2:
            boolean r5 = r10.mFirePositiveReset
            if (r5 == 0) goto L_0x00c9
            float r5 = r10.mFireThreshold
            float r6 = r11 - r5
            float r7 = r10.mFireLastPos
            float r7 = r7 - r5
            float r7 = r7 * r6
            int r5 = (r7 > r1 ? 1 : (r7 == r1 ? 0 : -1))
            if (r5 >= 0) goto L_0x00d9
            int r1 = (r6 > r1 ? 1 : (r6 == r1 ? 0 : -1))
            if (r1 <= 0) goto L_0x00d9
            r10.mFirePositiveReset = r3
            goto L_0x00da
        L_0x00c9:
            float r1 = r10.mFireThreshold
            float r1 = r11 - r1
            float r1 = java.lang.Math.abs(r1)
            float r5 = r10.mTriggerSlack
            int r1 = (r1 > r5 ? 1 : (r1 == r5 ? 0 : -1))
            if (r1 <= 0) goto L_0x00d9
            r10.mFirePositiveReset = r2
        L_0x00d9:
            r2 = r3
        L_0x00da:
            r1 = r4
        L_0x00db:
            r10.mFireLastPos = r11
            if (r1 != 0) goto L_0x00e3
            if (r0 != 0) goto L_0x00e3
            if (r2 == 0) goto L_0x00ee
        L_0x00e3:
            android.view.ViewParent r4 = r12.getParent()
            androidx.constraintlayout.motion.widget.MotionLayout r4 = (androidx.constraintlayout.motion.widget.MotionLayout) r4
            int r5 = r10.mTriggerID
            r4.fireTrigger(r5, r2, r11)
        L_0x00ee:
            int r11 = r10.mTriggerReceiver
            int r4 = androidx.constraintlayout.motion.widget.Key.UNSET
            if (r11 != r4) goto L_0x00f5
            goto L_0x0101
        L_0x00f5:
            android.view.ViewParent r11 = r12.getParent()
            androidx.constraintlayout.motion.widget.MotionLayout r11 = (androidx.constraintlayout.motion.widget.MotionLayout) r11
            int r12 = r10.mTriggerReceiver
            android.view.View r12 = r11.findViewById(r12)
        L_0x0101:
            java.lang.String r11 = "Could not find method \""
            java.lang.String r4 = "Exception in call \""
            java.lang.String r5 = " "
            java.lang.String r6 = "\"on class "
            java.lang.String r7 = "KeyTrigger"
            if (r1 == 0) goto L_0x0184
            java.lang.String r1 = r10.mNegativeCross
            if (r1 == 0) goto L_0x0184
            java.lang.reflect.Method r1 = r10.mFireNegativeCross
            if (r1 != 0) goto L_0x0150
            java.lang.Class r1 = r12.getClass()     // Catch:{ NoSuchMethodException -> 0x0124 }
            java.lang.String r8 = r10.mNegativeCross     // Catch:{ NoSuchMethodException -> 0x0124 }
            java.lang.Class[] r9 = new java.lang.Class[r3]     // Catch:{ NoSuchMethodException -> 0x0124 }
            java.lang.reflect.Method r1 = r1.getMethod(r8, r9)     // Catch:{ NoSuchMethodException -> 0x0124 }
            r10.mFireNegativeCross = r1     // Catch:{ NoSuchMethodException -> 0x0124 }
            goto L_0x0150
        L_0x0124:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            r1.append(r11)
            java.lang.String r8 = r10.mNegativeCross
            r1.append(r8)
            r1.append(r6)
            java.lang.Class r8 = r12.getClass()
            java.lang.String r8 = r8.getSimpleName()
            r1.append(r8)
            r1.append(r5)
            java.lang.String r8 = androidx.constraintlayout.motion.widget.Debug.getName(r12)
            r1.append(r8)
            java.lang.String r1 = r1.toString()
            android.util.Log.e(r7, r1)
        L_0x0150:
            java.lang.reflect.Method r1 = r10.mFireNegativeCross     // Catch:{ Exception -> 0x0158 }
            java.lang.Object[] r8 = new java.lang.Object[r3]     // Catch:{ Exception -> 0x0158 }
            r1.invoke(r12, r8)     // Catch:{ Exception -> 0x0158 }
            goto L_0x0184
        L_0x0158:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            r1.append(r4)
            java.lang.String r8 = r10.mNegativeCross
            r1.append(r8)
            r1.append(r6)
            java.lang.Class r8 = r12.getClass()
            java.lang.String r8 = r8.getSimpleName()
            r1.append(r8)
            r1.append(r5)
            java.lang.String r8 = androidx.constraintlayout.motion.widget.Debug.getName(r12)
            r1.append(r8)
            java.lang.String r1 = r1.toString()
            android.util.Log.e(r7, r1)
        L_0x0184:
            if (r2 == 0) goto L_0x01fd
            java.lang.String r1 = r10.mPositiveCross
            if (r1 == 0) goto L_0x01fd
            java.lang.reflect.Method r1 = r10.mFirePositiveCross
            if (r1 != 0) goto L_0x01c9
            java.lang.Class r1 = r12.getClass()     // Catch:{ NoSuchMethodException -> 0x019d }
            java.lang.String r2 = r10.mPositiveCross     // Catch:{ NoSuchMethodException -> 0x019d }
            java.lang.Class[] r8 = new java.lang.Class[r3]     // Catch:{ NoSuchMethodException -> 0x019d }
            java.lang.reflect.Method r1 = r1.getMethod(r2, r8)     // Catch:{ NoSuchMethodException -> 0x019d }
            r10.mFirePositiveCross = r1     // Catch:{ NoSuchMethodException -> 0x019d }
            goto L_0x01c9
        L_0x019d:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            r1.append(r11)
            java.lang.String r2 = r10.mPositiveCross
            r1.append(r2)
            r1.append(r6)
            java.lang.Class r2 = r12.getClass()
            java.lang.String r2 = r2.getSimpleName()
            r1.append(r2)
            r1.append(r5)
            java.lang.String r2 = androidx.constraintlayout.motion.widget.Debug.getName(r12)
            r1.append(r2)
            java.lang.String r1 = r1.toString()
            android.util.Log.e(r7, r1)
        L_0x01c9:
            java.lang.reflect.Method r1 = r10.mFirePositiveCross     // Catch:{ Exception -> 0x01d1 }
            java.lang.Object[] r2 = new java.lang.Object[r3]     // Catch:{ Exception -> 0x01d1 }
            r1.invoke(r12, r2)     // Catch:{ Exception -> 0x01d1 }
            goto L_0x01fd
        L_0x01d1:
            java.lang.StringBuilder r1 = new java.lang.StringBuilder
            r1.<init>()
            r1.append(r4)
            java.lang.String r2 = r10.mPositiveCross
            r1.append(r2)
            r1.append(r6)
            java.lang.Class r2 = r12.getClass()
            java.lang.String r2 = r2.getSimpleName()
            r1.append(r2)
            r1.append(r5)
            java.lang.String r2 = androidx.constraintlayout.motion.widget.Debug.getName(r12)
            r1.append(r2)
            java.lang.String r1 = r1.toString()
            android.util.Log.e(r7, r1)
        L_0x01fd:
            if (r0 == 0) goto L_0x0276
            java.lang.String r0 = r10.mCross
            if (r0 == 0) goto L_0x0276
            java.lang.reflect.Method r0 = r10.mFireCross
            if (r0 != 0) goto L_0x0242
            java.lang.Class r0 = r12.getClass()     // Catch:{ NoSuchMethodException -> 0x0216 }
            java.lang.String r1 = r10.mCross     // Catch:{ NoSuchMethodException -> 0x0216 }
            java.lang.Class[] r2 = new java.lang.Class[r3]     // Catch:{ NoSuchMethodException -> 0x0216 }
            java.lang.reflect.Method r0 = r0.getMethod(r1, r2)     // Catch:{ NoSuchMethodException -> 0x0216 }
            r10.mFireCross = r0     // Catch:{ NoSuchMethodException -> 0x0216 }
            goto L_0x0242
        L_0x0216:
            java.lang.StringBuilder r0 = new java.lang.StringBuilder
            r0.<init>()
            r0.append(r11)
            java.lang.String r11 = r10.mCross
            r0.append(r11)
            r0.append(r6)
            java.lang.Class r11 = r12.getClass()
            java.lang.String r11 = r11.getSimpleName()
            r0.append(r11)
            r0.append(r5)
            java.lang.String r11 = androidx.constraintlayout.motion.widget.Debug.getName(r12)
            r0.append(r11)
            java.lang.String r11 = r0.toString()
            android.util.Log.e(r7, r11)
        L_0x0242:
            java.lang.reflect.Method r11 = r10.mFireCross     // Catch:{ Exception -> 0x024a }
            java.lang.Object[] r0 = new java.lang.Object[r3]     // Catch:{ Exception -> 0x024a }
            r11.invoke(r12, r0)     // Catch:{ Exception -> 0x024a }
            goto L_0x0276
        L_0x024a:
            java.lang.StringBuilder r11 = new java.lang.StringBuilder
            r11.<init>()
            r11.append(r4)
            java.lang.String r10 = r10.mCross
            r11.append(r10)
            r11.append(r6)
            java.lang.Class r10 = r12.getClass()
            java.lang.String r10 = r10.getSimpleName()
            r11.append(r10)
            r11.append(r5)
            java.lang.String r10 = androidx.constraintlayout.motion.widget.Debug.getName(r12)
            r11.append(r10)
            java.lang.String r10 = r11.toString()
            android.util.Log.e(r7, r10)
        L_0x0276:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.motion.widget.KeyTrigger.conditionallyFire(float, android.view.View):void");
    }

    private static class Loader {
        private static final int COLLISION = 9;
        private static final int CROSS = 4;
        private static final int FRAME_POS = 8;
        private static final int NEGATIVE_CROSS = 1;
        private static final int POSITIVE_CROSS = 2;
        private static final int POST_LAYOUT = 10;
        private static final int TARGET_ID = 7;
        private static final int TRIGGER_ID = 6;
        private static final int TRIGGER_RECEIVER = 11;
        private static final int TRIGGER_SLACK = 5;
        private static SparseIntArray mAttrMap;

        private Loader() {
        }

        static {
            SparseIntArray sparseIntArray = new SparseIntArray();
            mAttrMap = sparseIntArray;
            sparseIntArray.append(R.styleable.KeyTrigger_framePosition, 8);
            mAttrMap.append(R.styleable.KeyTrigger_onCross, 4);
            mAttrMap.append(R.styleable.KeyTrigger_onNegativeCross, 1);
            mAttrMap.append(R.styleable.KeyTrigger_onPositiveCross, 2);
            mAttrMap.append(R.styleable.KeyTrigger_motionTarget, 7);
            mAttrMap.append(R.styleable.KeyTrigger_triggerId, 6);
            mAttrMap.append(R.styleable.KeyTrigger_triggerSlack, 5);
            mAttrMap.append(R.styleable.KeyTrigger_motion_triggerOnCollision, 9);
            mAttrMap.append(R.styleable.KeyTrigger_motion_postLayoutCollision, 10);
            mAttrMap.append(R.styleable.KeyTrigger_triggerReceiver, 11);
        }

        public static void read(KeyTrigger keyTrigger, TypedArray typedArray, Context context) {
            int indexCount = typedArray.getIndexCount();
            for (int i = 0; i < indexCount; i++) {
                int index = typedArray.getIndex(i);
                switch (mAttrMap.get(index)) {
                    case 1:
                        String unused = keyTrigger.mNegativeCross = typedArray.getString(index);
                        continue;
                    case 2:
                        String unused2 = keyTrigger.mPositiveCross = typedArray.getString(index);
                        continue;
                    case 4:
                        String unused3 = keyTrigger.mCross = typedArray.getString(index);
                        continue;
                    case 5:
                        keyTrigger.mTriggerSlack = typedArray.getFloat(index, keyTrigger.mTriggerSlack);
                        continue;
                    case 6:
                        int unused4 = keyTrigger.mTriggerID = typedArray.getResourceId(index, keyTrigger.mTriggerID);
                        continue;
                    case 7:
                        if (!MotionLayout.IS_IN_EDIT_MODE) {
                            if (typedArray.peekValue(index).type != 3) {
                                keyTrigger.mTargetId = typedArray.getResourceId(index, keyTrigger.mTargetId);
                                break;
                            } else {
                                keyTrigger.mTargetString = typedArray.getString(index);
                                break;
                            }
                        } else {
                            int resourceId = typedArray.getResourceId(index, keyTrigger.mTargetId);
                            keyTrigger.mTargetId = resourceId;
                            if (resourceId == -1) {
                                keyTrigger.mTargetString = typedArray.getString(index);
                                break;
                            } else {
                                continue;
                            }
                        }
                    case 8:
                        int integer = typedArray.getInteger(index, keyTrigger.mFramePosition);
                        keyTrigger.mFramePosition = integer;
                        float unused5 = keyTrigger.mFireThreshold = (((float) integer) + 0.5f) / 100.0f;
                        continue;
                    case 9:
                        int unused6 = keyTrigger.mTriggerCollisionId = typedArray.getResourceId(index, keyTrigger.mTriggerCollisionId);
                        continue;
                    case 10:
                        boolean unused7 = keyTrigger.mPostLayout = typedArray.getBoolean(index, keyTrigger.mPostLayout);
                        continue;
                    case 11:
                        int unused8 = keyTrigger.mTriggerReceiver = typedArray.getResourceId(index, keyTrigger.mTriggerReceiver);
                        break;
                }
                Log.e("KeyTrigger", "unused attribute 0x" + Integer.toHexString(index) + "   " + mAttrMap.get(index));
            }
        }
    }
}
