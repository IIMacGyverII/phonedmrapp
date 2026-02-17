package androidx.constraintlayout.solver.widgets.analyzer;

import androidx.constraintlayout.solver.widgets.ConstraintWidgetContainer;
import java.util.ArrayList;

class RunGroup {
    public static final int BASELINE = 2;
    public static final int END = 1;
    public static final int START = 0;
    public static int index;
    int direction;
    public boolean dual = false;
    WidgetRun firstRun = null;
    int groupIndex;
    WidgetRun lastRun = null;
    public int position = 0;
    ArrayList<WidgetRun> runs = new ArrayList<>();

    public RunGroup(WidgetRun widgetRun, int i) {
        int i2 = index;
        this.groupIndex = i2;
        index = i2 + 1;
        this.firstRun = widgetRun;
        this.lastRun = widgetRun;
        this.direction = i;
    }

    public void add(WidgetRun widgetRun) {
        this.runs.add(widgetRun);
        this.lastRun = widgetRun;
    }

    private long traverseStart(DependencyNode dependencyNode, long j) {
        WidgetRun widgetRun = dependencyNode.run;
        if (widgetRun instanceof HelperReferences) {
            return j;
        }
        int size = dependencyNode.dependencies.size();
        long j2 = j;
        for (int i = 0; i < size; i++) {
            Dependency dependency = dependencyNode.dependencies.get(i);
            if (dependency instanceof DependencyNode) {
                DependencyNode dependencyNode2 = (DependencyNode) dependency;
                if (dependencyNode2.run != widgetRun) {
                    j2 = Math.max(j2, traverseStart(dependencyNode2, ((long) dependencyNode2.margin) + j));
                }
            }
        }
        if (dependencyNode != widgetRun.start) {
            return j2;
        }
        long wrapDimension = j + widgetRun.getWrapDimension();
        return Math.max(Math.max(j2, traverseStart(widgetRun.end, wrapDimension)), wrapDimension - ((long) widgetRun.end.margin));
    }

    private long traverseEnd(DependencyNode dependencyNode, long j) {
        WidgetRun widgetRun = dependencyNode.run;
        if (widgetRun instanceof HelperReferences) {
            return j;
        }
        int size = dependencyNode.dependencies.size();
        long j2 = j;
        for (int i = 0; i < size; i++) {
            Dependency dependency = dependencyNode.dependencies.get(i);
            if (dependency instanceof DependencyNode) {
                DependencyNode dependencyNode2 = (DependencyNode) dependency;
                if (dependencyNode2.run != widgetRun) {
                    j2 = Math.min(j2, traverseEnd(dependencyNode2, ((long) dependencyNode2.margin) + j));
                }
            }
        }
        if (dependencyNode != widgetRun.end) {
            return j2;
        }
        long wrapDimension = j - widgetRun.getWrapDimension();
        return Math.min(Math.min(j2, traverseEnd(widgetRun.start, wrapDimension)), wrapDimension - ((long) widgetRun.start.margin));
    }

    public long computeWrapSize(ConstraintWidgetContainer constraintWidgetContainer, int i) {
        WidgetRun widgetRun = this.firstRun;
        long j = 0;
        if (widgetRun instanceof ChainRun) {
            if (((ChainRun) widgetRun).orientation != i) {
                return 0;
            }
        } else if (i == 0) {
            if (!(widgetRun instanceof HorizontalWidgetRun)) {
                return 0;
            }
        } else if (!(widgetRun instanceof VerticalWidgetRun)) {
            return 0;
        }
        DependencyNode dependencyNode = (i == 0 ? constraintWidgetContainer.horizontalRun : constraintWidgetContainer.verticalRun).start;
        DependencyNode dependencyNode2 = (i == 0 ? constraintWidgetContainer.horizontalRun : constraintWidgetContainer.verticalRun).end;
        boolean contains = widgetRun.start.targets.contains(dependencyNode);
        boolean contains2 = this.firstRun.end.targets.contains(dependencyNode2);
        long wrapDimension = this.firstRun.getWrapDimension();
        if (contains && contains2) {
            long traverseStart = traverseStart(this.firstRun.start, 0);
            long traverseEnd = traverseEnd(this.firstRun.end, 0);
            long j2 = traverseStart - wrapDimension;
            WidgetRun widgetRun2 = this.firstRun;
            int i2 = widgetRun2.end.margin;
            if (j2 >= ((long) (-i2))) {
                j2 += (long) i2;
            }
            int i3 = widgetRun2.start.margin;
            long j3 = ((-traverseEnd) - wrapDimension) - ((long) i3);
            if (j3 >= ((long) i3)) {
                j3 -= (long) i3;
            }
            float biasPercent = widgetRun2.widget.getBiasPercent(i);
            if (biasPercent > 0.0f) {
                j = (long) ((((float) j3) / biasPercent) + (((float) j2) / (1.0f - biasPercent)));
            }
            float f = (float) j;
            long j4 = ((long) ((f * biasPercent) + 0.5f)) + wrapDimension + ((long) ((f * (1.0f - biasPercent)) + 0.5f));
            WidgetRun widgetRun3 = this.firstRun;
            return (((long) widgetRun3.start.margin) + j4) - ((long) widgetRun3.end.margin);
        } else if (contains) {
            DependencyNode dependencyNode3 = this.firstRun.start;
            return Math.max(traverseStart(dependencyNode3, (long) dependencyNode3.margin), ((long) this.firstRun.start.margin) + wrapDimension);
        } else if (contains2) {
            DependencyNode dependencyNode4 = this.firstRun.end;
            return Math.max(-traverseEnd(dependencyNode4, (long) dependencyNode4.margin), ((long) (-this.firstRun.end.margin)) + wrapDimension);
        } else {
            WidgetRun widgetRun4 = this.firstRun;
            return (((long) widgetRun4.start.margin) + widgetRun4.getWrapDimension()) - ((long) this.firstRun.end.margin);
        }
    }

    /* JADX WARNING: Code restructure failed: missing block: B:27:0x0072, code lost:
        r2 = (androidx.constraintlayout.solver.widgets.analyzer.DependencyNode) r2;
     */
    /* JADX WARNING: Code restructure failed: missing block: B:8:0x0022, code lost:
        r2 = (androidx.constraintlayout.solver.widgets.analyzer.DependencyNode) r2;
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private boolean defineTerminalWidget(androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r6, int r7) {
        /*
            r5 = this;
            androidx.constraintlayout.solver.widgets.ConstraintWidget r0 = r6.widget
            boolean[] r0 = r0.isTerminalWidget
            boolean r0 = r0[r7]
            r1 = 0
            if (r0 != 0) goto L_0x000a
            return r1
        L_0x000a:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r0 = r6.start
            java.util.List<androidx.constraintlayout.solver.widgets.analyzer.Dependency> r0 = r0.dependencies
            java.util.Iterator r0 = r0.iterator()
        L_0x0012:
            boolean r2 = r0.hasNext()
            if (r2 == 0) goto L_0x005a
            java.lang.Object r2 = r0.next()
            androidx.constraintlayout.solver.widgets.analyzer.Dependency r2 = (androidx.constraintlayout.solver.widgets.analyzer.Dependency) r2
            boolean r3 = r2 instanceof androidx.constraintlayout.solver.widgets.analyzer.DependencyNode
            if (r3 == 0) goto L_0x0012
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r2 = (androidx.constraintlayout.solver.widgets.analyzer.DependencyNode) r2
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r3 = r2.run
            if (r3 != r6) goto L_0x0029
            goto L_0x0012
        L_0x0029:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r3 = r3.start
            if (r2 != r3) goto L_0x0012
            boolean r3 = r6 instanceof androidx.constraintlayout.solver.widgets.analyzer.ChainRun
            if (r3 == 0) goto L_0x004a
            r3 = r6
            androidx.constraintlayout.solver.widgets.analyzer.ChainRun r3 = (androidx.constraintlayout.solver.widgets.analyzer.ChainRun) r3
            java.util.ArrayList<androidx.constraintlayout.solver.widgets.analyzer.WidgetRun> r3 = r3.widgets
            java.util.Iterator r3 = r3.iterator()
        L_0x003a:
            boolean r4 = r3.hasNext()
            if (r4 == 0) goto L_0x0054
            java.lang.Object r4 = r3.next()
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r4 = (androidx.constraintlayout.solver.widgets.analyzer.WidgetRun) r4
            r5.defineTerminalWidget(r4, r7)
            goto L_0x003a
        L_0x004a:
            boolean r3 = r6 instanceof androidx.constraintlayout.solver.widgets.analyzer.HelperReferences
            if (r3 != 0) goto L_0x0054
            androidx.constraintlayout.solver.widgets.ConstraintWidget r3 = r6.widget
            boolean[] r3 = r3.isTerminalWidget
            r3[r7] = r1
        L_0x0054:
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r2 = r2.run
            r5.defineTerminalWidget(r2, r7)
            goto L_0x0012
        L_0x005a:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r0 = r6.end
            java.util.List<androidx.constraintlayout.solver.widgets.analyzer.Dependency> r0 = r0.dependencies
            java.util.Iterator r0 = r0.iterator()
        L_0x0062:
            boolean r2 = r0.hasNext()
            if (r2 == 0) goto L_0x00aa
            java.lang.Object r2 = r0.next()
            androidx.constraintlayout.solver.widgets.analyzer.Dependency r2 = (androidx.constraintlayout.solver.widgets.analyzer.Dependency) r2
            boolean r3 = r2 instanceof androidx.constraintlayout.solver.widgets.analyzer.DependencyNode
            if (r3 == 0) goto L_0x0062
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r2 = (androidx.constraintlayout.solver.widgets.analyzer.DependencyNode) r2
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r3 = r2.run
            if (r3 != r6) goto L_0x0079
            goto L_0x0062
        L_0x0079:
            androidx.constraintlayout.solver.widgets.analyzer.DependencyNode r3 = r3.start
            if (r2 != r3) goto L_0x0062
            boolean r3 = r6 instanceof androidx.constraintlayout.solver.widgets.analyzer.ChainRun
            if (r3 == 0) goto L_0x009a
            r3 = r6
            androidx.constraintlayout.solver.widgets.analyzer.ChainRun r3 = (androidx.constraintlayout.solver.widgets.analyzer.ChainRun) r3
            java.util.ArrayList<androidx.constraintlayout.solver.widgets.analyzer.WidgetRun> r3 = r3.widgets
            java.util.Iterator r3 = r3.iterator()
        L_0x008a:
            boolean r4 = r3.hasNext()
            if (r4 == 0) goto L_0x00a4
            java.lang.Object r4 = r3.next()
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r4 = (androidx.constraintlayout.solver.widgets.analyzer.WidgetRun) r4
            r5.defineTerminalWidget(r4, r7)
            goto L_0x008a
        L_0x009a:
            boolean r3 = r6 instanceof androidx.constraintlayout.solver.widgets.analyzer.HelperReferences
            if (r3 != 0) goto L_0x00a4
            androidx.constraintlayout.solver.widgets.ConstraintWidget r3 = r6.widget
            boolean[] r3 = r3.isTerminalWidget
            r3[r7] = r1
        L_0x00a4:
            androidx.constraintlayout.solver.widgets.analyzer.WidgetRun r2 = r2.run
            r5.defineTerminalWidget(r2, r7)
            goto L_0x0062
        L_0x00aa:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: androidx.constraintlayout.solver.widgets.analyzer.RunGroup.defineTerminalWidget(androidx.constraintlayout.solver.widgets.analyzer.WidgetRun, int):boolean");
    }

    public void defineTerminalWidgets(boolean z, boolean z2) {
        if (z) {
            WidgetRun widgetRun = this.firstRun;
            if (widgetRun instanceof HorizontalWidgetRun) {
                defineTerminalWidget(widgetRun, 0);
            }
        }
        if (z2) {
            WidgetRun widgetRun2 = this.firstRun;
            if (widgetRun2 instanceof VerticalWidgetRun) {
                defineTerminalWidget(widgetRun2, 1);
            }
        }
    }
}
