package androidx.constraintlayout.solver.widgets.analyzer;

import androidx.constraintlayout.solver.widgets.ConstraintAnchor;
import androidx.constraintlayout.solver.widgets.ConstraintWidget;
import androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer;
import java.util.ArrayList;
import java.util.Iterator;

public class ChainRun extends WidgetRun {
    private int chainStyle;
    ArrayList<WidgetRun> widgets = new ArrayList<>();

    public ChainRun(ConstraintWidget constraintWidget, int i) {
        super(constraintWidget);
        this.orientation = i;
        build();
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("ChainRun ");
        sb.append(this.orientation == 0 ? "horizontal : " : "vertical : ");
        String sb2 = sb.toString();
        Iterator<WidgetRun> it = this.widgets.iterator();
        while (it.hasNext()) {
            sb2 = ((sb2 + "<") + it.next()) + "> ";
        }
        return sb2;
    }

    /* access modifiers changed from: package-private */
    public boolean supportsWrapComputation() {
        int size = this.widgets.size();
        for (int i = 0; i < size; i++) {
            if (!this.widgets.get(i).supportsWrapComputation()) {
                return false;
            }
        }
        return true;
    }

    public long getWrapDimension() {
        int size = this.widgets.size();
        long j = 0;
        for (int i = 0; i < size; i++) {
            WidgetRun widgetRun = this.widgets.get(i);
            j = j + ((long) widgetRun.start.margin) + widgetRun.getWrapDimension() + ((long) widgetRun.end.margin);
        }
        return j;
    }

    private void build() {
        ConstraintWidget constraintWidget;
        ConstraintWidget constraintWidget2 = this.widget;
        ConstraintWidget previousChainMember = constraintWidget2.getPreviousChainMember(this.orientation);
        while (true) {
            ConstraintWidget constraintWidget3 = previousChainMember;
            constraintWidget = constraintWidget2;
            constraintWidget2 = constraintWidget3;
            if (constraintWidget2 == null) {
                break;
            }
            previousChainMember = constraintWidget2.getPreviousChainMember(this.orientation);
        }
        this.widget = constraintWidget;
        this.widgets.add(constraintWidget.getRun(this.orientation));
        ConstraintWidget nextChainMember = constraintWidget.getNextChainMember(this.orientation);
        while (nextChainMember != null) {
            this.widgets.add(nextChainMember.getRun(this.orientation));
            nextChainMember = nextChainMember.getNextChainMember(this.orientation);
        }
        Iterator<WidgetRun> it = this.widgets.iterator();
        while (it.hasNext()) {
            WidgetRun next = it.next();
            int i = this.orientation;
            if (i == 0) {
                next.widget.horizontalChainRun = this;
            } else if (i == 1) {
                next.widget.verticalChainRun = this;
            }
        }
        if ((this.orientation == 0 && ((ConstraintWidgetContainer) this.widget.getParent()).isRtl()) && this.widgets.size() > 1) {
            ArrayList<WidgetRun> arrayList = this.widgets;
            this.widget = arrayList.get(arrayList.size() - 1).widget;
        }
        this.chainStyle = this.orientation == 0 ? this.widget.getHorizontalChainStyle() : this.widget.getVerticalChainStyle();
    }

    /* access modifiers changed from: package-private */
    public void clear() {
        this.runGroup = null;
        Iterator<WidgetRun> it = this.widgets.iterator();
        while (it.hasNext()) {
            it.next().clear();
        }
    }

    /* access modifiers changed from: package-private */
    public void reset() {
        this.start.resolved = false;
        this.end.resolved = false;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:104:0x01a5, code lost:
        if (r1 != r7) goto L_0x01cd;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:112:0x01cb, code lost:
        if (r1 != r7) goto L_0x01cd;
     */
    /* JADX WARNING: Removed duplicated region for block: B:60:0x00d9  */
    /* JADX WARNING: Removed duplicated region for block: B:63:0x00eb  */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    public void update(androidx.constraintlayout.solver.widgets.analyzer.Dependency r26) {
        /*
            r25 = this;
            r0 = r25
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r0.start
            boolean r1 = r1.resolved
            if (r1 == 0) goto L_0x043f
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r0.end
            boolean r1 = r1.resolved
            if (r1 != 0) goto L_0x0010
            goto L_0x043f
        L_0x0010:
            androidx.constraintlayout.solver.widgets.ConstraintWidget r1 = r0.widget
            androidx.constraintlayout.solver.widgets.ConstraintWidget r1 = r1.getParent()
            if (r1 == 0) goto L_0x0023
            boolean r3 = r1 instanceof androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer
            if (r3 == 0) goto L_0x0023
            androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer r1 = (androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer) r1
            boolean r1 = r1.isRtl()
            goto L_0x0024
        L_0x0023:
            r1 = 0
        L_0x0024:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r3 = r0.end
            int r3 = r3.value
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r4 = r0.start
            int r4 = r4.value
            int r3 = r3 - r4
            java.util.ArrayList<androidx.constraintlayout.solver.widgets.analyzer.WidgetRun> r4 = r0.widgets
            int r4 = r4.size()
            r5 = 0
        L_0x0034:
            r6 = -1
            r7 = 8
            if (r5 >= r4) goto L_0x004c
            java.util.ArrayList<androidx.constraintlayout.solver.widgets.analyzer.WidgetRun> r8 = r0.widgets
            java.lang.Object r8 = r8.get(r5)
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r8 = (androidx.constraintlayout.solver.widgets.analyzer.WidgetRun) r8
            androidx.constraintlayout.solver.widgets.ConstraintWidget r8 = r8.widget
            int r8 = r8.getVisibility()
            if (r8 != r7) goto L_0x004d
            int r5 = r5 + 1
            goto L_0x0034
        L_0x004c:
            r5 = r6
        L_0x004d:
            int r8 = r4 + -1
            r9 = r8
        L_0x0050:
            if (r9 < 0) goto L_0x0066
            java.util.ArrayList<androidx.constraintlayout.solver.widgets.analyzer.WidgetRun> r10 = r0.widgets
            java.lang.Object r10 = r10.get(r9)
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r10 = (androidx.constraintlayout.solver.widgets.analyzer.WidgetRun) r10
            androidx.constraintlayout.solver.widgets.ConstraintWidget r10 = r10.widget
            int r10 = r10.getVisibility()
            if (r10 != r7) goto L_0x0065
            int r9 = r9 + -1
            goto L_0x0050
        L_0x0065:
            r6 = r9
        L_0x0066:
            r9 = 0
        L_0x0067:
            r11 = 2
            if (r9 >= r11) goto L_0x010b
            r13 = 0
            r14 = 0
            r15 = 0
            r16 = 0
            r17 = 0
        L_0x0071:
            if (r13 >= r4) goto L_0x00fd
            java.util.ArrayList<androidx.constraintlayout.solver.widgets.analyzer.WidgetRun> r2 = r0.widgets
            java.lang.Object r2 = r2.get(r13)
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r2 = (androidx.constraintlayout.solver.widgets.analyzer.WidgetRun) r2
            androidx.constraintlayout.solver.widgets.ConstraintWidget r11 = r2.widget
            int r11 = r11.getVisibility()
            if (r11 != r7) goto L_0x0085
            goto L_0x00f6
        L_0x0085:
            int r16 = r16 + 1
            if (r13 <= 0) goto L_0x0090
            if (r13 < r5) goto L_0x0090
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r11 = r2.start
            int r11 = r11.margin
            int r14 = r14 + r11
        L_0x0090:
            androidx.constraintlayout.solver.widgets.analyzer.DimensionDependency r11 = r2.dimension
            int r7 = r11.value
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r10 = r2.dimensionBehavior
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r12 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT
            if (r10 == r12) goto L_0x009c
            r10 = 1
            goto L_0x009d
        L_0x009c:
            r10 = 0
        L_0x009d:
            if (r10 == 0) goto L_0x00bf
            int r11 = r0.orientation
            if (r11 != 0) goto L_0x00ae
            androidx.constraintlayout.solver.widgets.ConstraintWidget r12 = r2.widget
            androidx.constraintlayout.solver.widgets.analyzer.HorizontalWidgetRun r12 = r12.horizontalRun
            androidx.constraintlayout.solver.widgets.analyzer.DimensionDependency r12 = r12.dimension
            boolean r12 = r12.resolved
            if (r12 != 0) goto L_0x00ae
            return
        L_0x00ae:
            r12 = 1
            if (r11 != r12) goto L_0x00bc
            androidx.constraintlayout.solver.widgets.ConstraintWidget r11 = r2.widget
            androidx.constraintlayout.solver.widgets.analyzer.VerticalWidgetRun r11 = r11.verticalRun
            androidx.constraintlayout.solver.widgets.analyzer.DimensionDependency r11 = r11.dimension
            boolean r11 = r11.resolved
            if (r11 != 0) goto L_0x00bc
            return
        L_0x00bc:
            r19 = r7
            goto L_0x00d5
        L_0x00bf:
            r19 = r7
            r12 = 1
            int r7 = r2.matchConstraintsType
            if (r7 != r12) goto L_0x00cd
            if (r9 != 0) goto L_0x00cd
            int r7 = r11.wrapValue
            int r15 = r15 + 1
            goto L_0x00d3
        L_0x00cd:
            boolean r7 = r11.resolved
            if (r7 == 0) goto L_0x00d5
            r7 = r19
        L_0x00d3:
            r10 = 1
            goto L_0x00d7
        L_0x00d5:
            r7 = r19
        L_0x00d7:
            if (r10 != 0) goto L_0x00eb
            int r15 = r15 + 1
            androidx.constraintlayout.solver.widgets.ConstraintWidget r7 = r2.widget
            float[] r7 = r7.mWeight
            int r10 = r0.orientation
            r7 = r7[r10]
            r10 = 0
            int r11 = (r7 > r10 ? 1 : (r7 == r10 ? 0 : -1))
            if (r11 < 0) goto L_0x00ec
            float r17 = r17 + r7
            goto L_0x00ec
        L_0x00eb:
            int r14 = r14 + r7
        L_0x00ec:
            if (r13 >= r8) goto L_0x00f6
            if (r13 >= r6) goto L_0x00f6
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r2 = r2.end
            int r2 = r2.margin
            int r2 = -r2
            int r14 = r14 + r2
        L_0x00f6:
            int r13 = r13 + 1
            r7 = 8
            r11 = 2
            goto L_0x0071
        L_0x00fd:
            if (r14 < r3) goto L_0x0108
            if (r15 != 0) goto L_0x0102
            goto L_0x0108
        L_0x0102:
            int r9 = r9 + 1
            r7 = 8
            goto L_0x0067
        L_0x0108:
            r2 = r16
            goto L_0x0110
        L_0x010b:
            r2 = 0
            r14 = 0
            r15 = 0
            r17 = 0
        L_0x0110:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r7 = r0.start
            int r7 = r7.value
            if (r1 == 0) goto L_0x011a
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r7 = r0.end
            int r7 = r7.value
        L_0x011a:
            r9 = 1056964608(0x3f000000, float:0.5)
            if (r14 <= r3) goto L_0x0131
            r10 = 1073741824(0x40000000, float:2.0)
            if (r1 == 0) goto L_0x012a
            int r11 = r14 - r3
            float r11 = (float) r11
            float r11 = r11 / r10
            float r11 = r11 + r9
            int r10 = (int) r11
            int r7 = r7 + r10
            goto L_0x0131
        L_0x012a:
            int r11 = r14 - r3
            float r11 = (float) r11
            float r11 = r11 / r10
            float r11 = r11 + r9
            int r10 = (int) r11
            int r7 = r7 - r10
        L_0x0131:
            if (r15 <= 0) goto L_0x023e
            int r10 = r3 - r14
            float r10 = (float) r10
            float r11 = (float) r15
            float r11 = r10 / r11
            float r11 = r11 + r9
            int r11 = (int) r11
            r12 = 0
            r13 = 0
        L_0x013d:
            if (r12 >= r4) goto L_0x01f0
            java.util.ArrayList<androidx.constraintlayout.solver.widgets.analyzer.WidgetRun> r9 = r0.widgets
            java.lang.Object r9 = r9.get(r12)
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r9 = (androidx.constraintlayout.solver.widgets.analyzer.WidgetRun) r9
            r19 = r11
            androidx.constraintlayout.solver.widgets.ConstraintWidget r11 = r9.widget
            int r11 = r11.getVisibility()
            r20 = r14
            r14 = 8
            if (r11 != r14) goto L_0x0157
            goto L_0x01d6
        L_0x0157:
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r11 = r9.dimensionBehavior
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r14 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT
            if (r11 != r14) goto L_0x01d6
            androidx.constraintlayout.solver.widgets.analyzer.DimensionDependency r11 = r9.dimension
            boolean r14 = r11.resolved
            if (r14 != 0) goto L_0x01d6
            r14 = 0
            int r18 = (r17 > r14 ? 1 : (r17 == r14 ? 0 : -1))
            if (r18 <= 0) goto L_0x017a
            androidx.constraintlayout.solver.widgets.ConstraintWidget r14 = r9.widget
            float[] r14 = r14.mWeight
            r21 = r7
            int r7 = r0.orientation
            r7 = r14[r7]
            float r7 = r7 * r10
            float r7 = r7 / r17
            r14 = 1056964608(0x3f000000, float:0.5)
            float r7 = r7 + r14
            int r7 = (int) r7
            goto L_0x017e
        L_0x017a:
            r21 = r7
            r7 = r19
        L_0x017e:
            int r14 = r0.orientation
            if (r14 != 0) goto L_0x01a8
            androidx.constraintlayout.solver.widgets.ConstraintWidget r14 = r9.widget
            r22 = r10
            int r10 = r14.mMatchConstraintMaxWidth
            int r14 = r14.mMatchConstraintMinWidth
            r23 = r1
            int r1 = r9.matchConstraintsType
            r24 = r2
            r2 = 1
            if (r1 != r2) goto L_0x019a
            int r1 = r11.wrapValue
            int r1 = java.lang.Math.min(r7, r1)
            goto L_0x019b
        L_0x019a:
            r1 = r7
        L_0x019b:
            int r1 = java.lang.Math.max(r14, r1)
            if (r10 <= 0) goto L_0x01a5
            int r1 = java.lang.Math.min(r10, r1)
        L_0x01a5:
            if (r1 == r7) goto L_0x01d0
            goto L_0x01cd
        L_0x01a8:
            r23 = r1
            r24 = r2
            r22 = r10
            androidx.constraintlayout.solver.widgets.ConstraintWidget r1 = r9.widget
            int r2 = r1.mMatchConstraintMaxHeight
            int r1 = r1.mMatchConstraintMinHeight
            int r10 = r9.matchConstraintsType
            r14 = 1
            if (r10 != r14) goto L_0x01c0
            int r10 = r11.wrapValue
            int r10 = java.lang.Math.min(r7, r10)
            goto L_0x01c1
        L_0x01c0:
            r10 = r7
        L_0x01c1:
            int r1 = java.lang.Math.max(r1, r10)
            if (r2 <= 0) goto L_0x01cb
            int r1 = java.lang.Math.min(r2, r1)
        L_0x01cb:
            if (r1 == r7) goto L_0x01d0
        L_0x01cd:
            int r13 = r13 + 1
            r7 = r1
        L_0x01d0:
            androidx.constraintlayout.solver.widgets.analyzer.DimensionDependency r1 = r9.dimension
            r1.resolve(r7)
            goto L_0x01de
        L_0x01d6:
            r23 = r1
            r24 = r2
            r21 = r7
            r22 = r10
        L_0x01de:
            int r12 = r12 + 1
            r11 = r19
            r14 = r20
            r7 = r21
            r10 = r22
            r1 = r23
            r2 = r24
            r9 = 1056964608(0x3f000000, float:0.5)
            goto L_0x013d
        L_0x01f0:
            r23 = r1
            r24 = r2
            r21 = r7
            r20 = r14
            if (r13 <= 0) goto L_0x022f
            int r15 = r15 - r13
            r1 = 0
            r2 = 0
        L_0x01fd:
            if (r1 >= r4) goto L_0x022d
            java.util.ArrayList<androidx.constraintlayout.solver.widgets.analyzer.WidgetRun> r7 = r0.widgets
            java.lang.Object r7 = r7.get(r1)
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r7 = (androidx.constraintlayout.solver.widgets.analyzer.WidgetRun) r7
            androidx.constraintlayout.solver.widgets.ConstraintWidget r9 = r7.widget
            int r9 = r9.getVisibility()
            r10 = 8
            if (r9 != r10) goto L_0x0212
            goto L_0x022a
        L_0x0212:
            if (r1 <= 0) goto L_0x021b
            if (r1 < r5) goto L_0x021b
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r7.start
            int r9 = r9.margin
            int r2 = r2 + r9
        L_0x021b:
            androidx.constraintlayout.solver.widgets.analyzer.DimensionDependency r9 = r7.dimension
            int r9 = r9.value
            int r2 = r2 + r9
            if (r1 >= r8) goto L_0x022a
            if (r1 >= r6) goto L_0x022a
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r7 = r7.end
            int r7 = r7.margin
            int r7 = -r7
            int r2 = r2 + r7
        L_0x022a:
            int r1 = r1 + 1
            goto L_0x01fd
        L_0x022d:
            r14 = r2
            goto L_0x0231
        L_0x022f:
            r14 = r20
        L_0x0231:
            int r1 = r0.chainStyle
            r2 = 2
            if (r1 != r2) goto L_0x023c
            if (r13 != 0) goto L_0x023c
            r1 = 0
            r0.chainStyle = r1
            goto L_0x0248
        L_0x023c:
            r1 = 0
            goto L_0x0248
        L_0x023e:
            r23 = r1
            r24 = r2
            r21 = r7
            r20 = r14
            r1 = 0
            r2 = 2
        L_0x0248:
            if (r14 <= r3) goto L_0x024c
            r0.chainStyle = r2
        L_0x024c:
            if (r24 <= 0) goto L_0x0254
            if (r15 != 0) goto L_0x0254
            if (r5 != r6) goto L_0x0254
            r0.chainStyle = r2
        L_0x0254:
            int r2 = r0.chainStyle
            r7 = 1
            if (r2 != r7) goto L_0x02f8
            r9 = r24
            if (r9 <= r7) goto L_0x0262
            int r3 = r3 - r14
            int r2 = r9 + -1
            int r3 = r3 / r2
            goto L_0x0269
        L_0x0262:
            if (r9 != r7) goto L_0x0268
            int r3 = r3 - r14
            r2 = 2
            int r3 = r3 / r2
            goto L_0x0269
        L_0x0268:
            r3 = r1
        L_0x0269:
            if (r15 <= 0) goto L_0x026c
            r3 = r1
        L_0x026c:
            r2 = r1
            r7 = r21
        L_0x026f:
            if (r2 >= r4) goto L_0x043f
            if (r23 == 0) goto L_0x0278
            int r1 = r2 + 1
            int r1 = r4 - r1
            goto L_0x0279
        L_0x0278:
            r1 = r2
        L_0x0279:
            java.util.ArrayList<androidx.constraintlayout.solver.widgets.analyzer.WidgetRun> r9 = r0.widgets
            java.lang.Object r1 = r9.get(r1)
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r1 = (androidx.constraintlayout.solver.widgets.analyzer.WidgetRun) r1
            androidx.constraintlayout.solver.widgets.ConstraintWidget r9 = r1.widget
            int r9 = r9.getVisibility()
            r10 = 8
            if (r9 != r10) goto L_0x0296
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.start
            r9.resolve(r7)
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r1.end
            r1.resolve(r7)
            goto L_0x02f4
        L_0x0296:
            if (r2 <= 0) goto L_0x029d
            if (r23 == 0) goto L_0x029c
            int r7 = r7 - r3
            goto L_0x029d
        L_0x029c:
            int r7 = r7 + r3
        L_0x029d:
            if (r2 <= 0) goto L_0x02ae
            if (r2 < r5) goto L_0x02ae
            if (r23 == 0) goto L_0x02a9
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.start
            int r9 = r9.margin
            int r7 = r7 - r9
            goto L_0x02ae
        L_0x02a9:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.start
            int r9 = r9.margin
            int r7 = r7 + r9
        L_0x02ae:
            if (r23 == 0) goto L_0x02b6
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.end
            r9.resolve(r7)
            goto L_0x02bb
        L_0x02b6:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.start
            r9.resolve(r7)
        L_0x02bb:
            androidx.constraintlayout.solver.widgets.analyzer.DimensionDependency r9 = r1.dimension
            int r10 = r9.value
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r11 = r1.dimensionBehavior
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r12 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT
            if (r11 != r12) goto L_0x02cc
            int r11 = r1.matchConstraintsType
            r12 = 1
            if (r11 != r12) goto L_0x02cc
            int r10 = r9.wrapValue
        L_0x02cc:
            if (r23 == 0) goto L_0x02d0
            int r7 = r7 - r10
            goto L_0x02d1
        L_0x02d0:
            int r7 = r7 + r10
        L_0x02d1:
            if (r23 == 0) goto L_0x02d9
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.start
            r9.resolve(r7)
            goto L_0x02de
        L_0x02d9:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.end
            r9.resolve(r7)
        L_0x02de:
            r9 = 1
            r1.resolved = r9
            if (r2 >= r8) goto L_0x02f4
            if (r2 >= r6) goto L_0x02f4
            if (r23 == 0) goto L_0x02ee
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r1.end
            int r1 = r1.margin
            int r1 = -r1
            int r7 = r7 - r1
            goto L_0x02f4
        L_0x02ee:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r1.end
            int r1 = r1.margin
            int r1 = -r1
            int r7 = r7 + r1
        L_0x02f4:
            int r2 = r2 + 1
            goto L_0x026f
        L_0x02f8:
            r9 = r24
            if (r2 != 0) goto L_0x038f
            int r3 = r3 - r14
            r2 = 1
            int r7 = r9 + 1
            int r3 = r3 / r7
            if (r15 <= 0) goto L_0x0304
            r3 = r1
        L_0x0304:
            r2 = r1
            r7 = r21
        L_0x0307:
            if (r2 >= r4) goto L_0x043f
            if (r23 == 0) goto L_0x0310
            int r1 = r2 + 1
            int r1 = r4 - r1
            goto L_0x0311
        L_0x0310:
            r1 = r2
        L_0x0311:
            java.util.ArrayList<androidx.constraintlayout.solver.widgets.analyzer.WidgetRun> r9 = r0.widgets
            java.lang.Object r1 = r9.get(r1)
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r1 = (androidx.constraintlayout.solver.widgets.analyzer.WidgetRun) r1
            androidx.constraintlayout.solver.widgets.ConstraintWidget r9 = r1.widget
            int r9 = r9.getVisibility()
            r10 = 8
            if (r9 != r10) goto L_0x032e
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.start
            r9.resolve(r7)
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r1.end
            r1.resolve(r7)
            goto L_0x038b
        L_0x032e:
            if (r23 == 0) goto L_0x0332
            int r7 = r7 - r3
            goto L_0x0333
        L_0x0332:
            int r7 = r7 + r3
        L_0x0333:
            if (r2 <= 0) goto L_0x0344
            if (r2 < r5) goto L_0x0344
            if (r23 == 0) goto L_0x033f
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.start
            int r9 = r9.margin
            int r7 = r7 - r9
            goto L_0x0344
        L_0x033f:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.start
            int r9 = r9.margin
            int r7 = r7 + r9
        L_0x0344:
            if (r23 == 0) goto L_0x034c
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.end
            r9.resolve(r7)
            goto L_0x0351
        L_0x034c:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.start
            r9.resolve(r7)
        L_0x0351:
            androidx.constraintlayout.solver.widgets.analyzer.DimensionDependency r9 = r1.dimension
            int r10 = r9.value
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r11 = r1.dimensionBehavior
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r12 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT
            if (r11 != r12) goto L_0x0366
            int r11 = r1.matchConstraintsType
            r12 = 1
            if (r11 != r12) goto L_0x0366
            int r9 = r9.wrapValue
            int r10 = java.lang.Math.min(r10, r9)
        L_0x0366:
            if (r23 == 0) goto L_0x036a
            int r7 = r7 - r10
            goto L_0x036b
        L_0x036a:
            int r7 = r7 + r10
        L_0x036b:
            if (r23 == 0) goto L_0x0373
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.start
            r9.resolve(r7)
            goto L_0x0378
        L_0x0373:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r9 = r1.end
            r9.resolve(r7)
        L_0x0378:
            if (r2 >= r8) goto L_0x038b
            if (r2 >= r6) goto L_0x038b
            if (r23 == 0) goto L_0x0385
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r1.end
            int r1 = r1.margin
            int r1 = -r1
            int r7 = r7 - r1
            goto L_0x038b
        L_0x0385:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r1.end
            int r1 = r1.margin
            int r1 = -r1
            int r7 = r7 + r1
        L_0x038b:
            int r2 = r2 + 1
            goto L_0x0307
        L_0x038f:
            r7 = 2
            if (r2 != r7) goto L_0x043f
            int r2 = r0.orientation
            if (r2 != 0) goto L_0x039d
            androidx.constraintlayout.solver.widgets.ConstraintWidget r2 = r0.widget
            float r2 = r2.getHorizontalBiasPercent()
            goto L_0x03a3
        L_0x039d:
            androidx.constraintlayout.solver.widgets.ConstraintWidget r2 = r0.widget
            float r2 = r2.getVerticalBiasPercent()
        L_0x03a3:
            if (r23 == 0) goto L_0x03a9
            r7 = 1065353216(0x3f800000, float:1.0)
            float r2 = r7 - r2
        L_0x03a9:
            int r3 = r3 - r14
            float r3 = (float) r3
            float r3 = r3 * r2
            r2 = 1056964608(0x3f000000, float:0.5)
            float r3 = r3 + r2
            int r2 = (int) r3
            if (r2 < 0) goto L_0x03b4
            if (r15 <= 0) goto L_0x03b5
        L_0x03b4:
            r2 = r1
        L_0x03b5:
            if (r23 == 0) goto L_0x03ba
            int r7 = r21 - r2
            goto L_0x03bc
        L_0x03ba:
            int r7 = r21 + r2
        L_0x03bc:
            r2 = r1
        L_0x03bd:
            if (r2 >= r4) goto L_0x043f
            if (r23 == 0) goto L_0x03c6
            int r1 = r2 + 1
            int r1 = r4 - r1
            goto L_0x03c7
        L_0x03c6:
            r1 = r2
        L_0x03c7:
            java.util.ArrayList<androidx.constraintlayout.solver.widgets.analyzer.WidgetRun> r3 = r0.widgets
            java.lang.Object r1 = r3.get(r1)
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r1 = (androidx.constraintlayout.solver.widgets.analyzer.WidgetRun) r1
            androidx.constraintlayout.solver.widgets.ConstraintWidget r3 = r1.widget
            int r3 = r3.getVisibility()
            r9 = 8
            if (r3 != r9) goto L_0x03e5
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r3 = r1.start
            r3.resolve(r7)
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r1.end
            r1.resolve(r7)
            r12 = 1
            goto L_0x043b
        L_0x03e5:
            if (r2 <= 0) goto L_0x03f6
            if (r2 < r5) goto L_0x03f6
            if (r23 == 0) goto L_0x03f1
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r3 = r1.start
            int r3 = r3.margin
            int r7 = r7 - r3
            goto L_0x03f6
        L_0x03f1:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r3 = r1.start
            int r3 = r3.margin
            int r7 = r7 + r3
        L_0x03f6:
            if (r23 == 0) goto L_0x03fe
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r3 = r1.end
            r3.resolve(r7)
            goto L_0x0403
        L_0x03fe:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r3 = r1.start
            r3.resolve(r7)
        L_0x0403:
            androidx.constraintlayout.solver.widgets.analyzer.DimensionDependency r3 = r1.dimension
            int r10 = r3.value
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r11 = r1.dimensionBehavior
            androidx.constraintlayout.solver.widgets.ConstraintWidget$DimensionBehaviour r12 = androidx.constraintlayout.solver.widgets.ConstraintWidget.DimensionBehaviour.MATCH_CONSTRAINT
            if (r11 != r12) goto L_0x0415
            int r11 = r1.matchConstraintsType
            r12 = 1
            if (r11 != r12) goto L_0x0416
            int r10 = r3.wrapValue
            goto L_0x0416
        L_0x0415:
            r12 = 1
        L_0x0416:
            if (r23 == 0) goto L_0x041a
            int r7 = r7 - r10
            goto L_0x041b
        L_0x041a:
            int r7 = r7 + r10
        L_0x041b:
            if (r23 == 0) goto L_0x0423
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r3 = r1.start
            r3.resolve(r7)
            goto L_0x0428
        L_0x0423:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r3 = r1.end
            r3.resolve(r7)
        L_0x0428:
            if (r2 >= r8) goto L_0x043b
            if (r2 >= r6) goto L_0x043b
            if (r23 == 0) goto L_0x0435
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r1.end
            int r1 = r1.margin
            int r1 = -r1
            int r7 = r7 - r1
            goto L_0x043b
        L_0x0435:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r1 = r1.end
            int r1 = r1.margin
            int r1 = -r1
            int r7 = r7 + r1
        L_0x043b:
            int r2 = r2 + 1
            goto L_0x03bd
        L_0x043f:
            return
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.solver.widgets.analyzer.ChainRun.update(androidx.constraintlayout.solver.widgets.analyzer.Dependency):void");
    }

    public void applyToWidget() {
        for (int i = 0; i < this.widgets.size(); i++) {
            this.widgets.get(i).applyToWidget();
        }
    }

    private ConstraintWidget getFirstVisibleWidget() {
        for (int i = 0; i < this.widgets.size(); i++) {
            WidgetRun widgetRun = this.widgets.get(i);
            if (widgetRun.widget.getVisibility() != 8) {
                return widgetRun.widget;
            }
        }
        return null;
    }

    private ConstraintWidget getLastVisibleWidget() {
        for (int size = this.widgets.size() - 1; size >= 0; size--) {
            WidgetRun widgetRun = this.widgets.get(size);
            if (widgetRun.widget.getVisibility() != 8) {
                return widgetRun.widget;
            }
        }
        return null;
    }

    /* access modifiers changed from: package-private */
    public void apply() {
        Iterator<WidgetRun> it = this.widgets.iterator();
        while (it.hasNext()) {
            it.next().apply();
        }
        int size = this.widgets.size();
        if (size >= 1) {
            ConstraintWidget constraintWidget = this.widgets.get(0).widget;
            ConstraintWidget constraintWidget2 = this.widgets.get(size - 1).widget;
            if (this.orientation == 0) {
                ConstraintAnchor constraintAnchor = constraintWidget.mLeft;
                ConstraintAnchor constraintAnchor2 = constraintWidget2.mRight;
                DependencyNode target = getTarget(constraintAnchor, 0);
                int margin = constraintAnchor.getMargin();
                ConstraintWidget firstVisibleWidget = getFirstVisibleWidget();
                if (firstVisibleWidget != null) {
                    margin = firstVisibleWidget.mLeft.getMargin();
                }
                if (target != null) {
                    addTarget(this.start, target, margin);
                }
                DependencyNode target2 = getTarget(constraintAnchor2, 0);
                int margin2 = constraintAnchor2.getMargin();
                ConstraintWidget lastVisibleWidget = getLastVisibleWidget();
                if (lastVisibleWidget != null) {
                    margin2 = lastVisibleWidget.mRight.getMargin();
                }
                if (target2 != null) {
                    addTarget(this.end, target2, -margin2);
                }
            } else {
                ConstraintAnchor constraintAnchor3 = constraintWidget.mTop;
                ConstraintAnchor constraintAnchor4 = constraintWidget2.mBottom;
                DependencyNode target3 = getTarget(constraintAnchor3, 1);
                int margin3 = constraintAnchor3.getMargin();
                ConstraintWidget firstVisibleWidget2 = getFirstVisibleWidget();
                if (firstVisibleWidget2 != null) {
                    margin3 = firstVisibleWidget2.mTop.getMargin();
                }
                if (target3 != null) {
                    addTarget(this.start, target3, margin3);
                }
                DependencyNode target4 = getTarget(constraintAnchor4, 1);
                int margin4 = constraintAnchor4.getMargin();
                ConstraintWidget lastVisibleWidget2 = getLastVisibleWidget();
                if (lastVisibleWidget2 != null) {
                    margin4 = lastVisibleWidget2.mBottom.getMargin();
                }
                if (target4 != null) {
                    addTarget(this.end, target4, -margin4);
                }
            }
            this.start.updateDelegate = this;
            this.end.updateDelegate = this;
        }
    }
}
