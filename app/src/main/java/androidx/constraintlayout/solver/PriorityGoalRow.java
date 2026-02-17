package androidx.constraintlayout.solver;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;

public class PriorityGoalRow extends ArrayRow {
    private static final boolean DEBUG = false;
    private static final float epsilon = 1.0E-4f;
    static Cache sCache;
    static RowVariable sRowVariable = new RowVariable();
    ArrayList<GoalVariable> goals = new ArrayList<>();
    HashMap<Integer, GoalVariable> keyedGoals = new HashMap<>();
    Cache mCache;

    static class GoalVariable implements Comparable {
        float[] strengths = new float[8];
        int variableId;

        GoalVariable() {
        }

        public void reset() {
            Arrays.fill(this.strengths, 0.0f);
            this.variableId = -1;
        }

        public String toString() {
            return toString(PriorityGoalRow.sCache);
        }

        public String toString(Cache cache) {
            String str = "[ ";
            for (int i = 0; i < 8; i++) {
                str = str + this.strengths[i] + " ";
            }
            return str + "] " + cache.mIndexedVariables[this.variableId];
        }

        public void add(GoalVariable goalVariable) {
            for (int i = 0; i < 8; i++) {
                float[] fArr = this.strengths;
                float f = fArr[i] + goalVariable.strengths[i];
                fArr[i] = f;
                if (Math.abs(f) < 1.0E-4f) {
                    this.strengths[i] = 0.0f;
                }
            }
        }

        public final boolean isNegative() {
            for (int i = 7; i >= 0; i--) {
                float f = this.strengths[i];
                if (f > 0.0f) {
                    return false;
                }
                if (f < 0.0f) {
                    return true;
                }
            }
            return false;
        }

        public final boolean isSmallerThan(GoalVariable goalVariable) {
            int i = 7;
            while (true) {
                if (i < 0) {
                    break;
                }
                float f = goalVariable.strengths[i];
                float f2 = this.strengths[i];
                if (f2 == f) {
                    i--;
                } else if (f2 < f) {
                    return true;
                }
            }
            return false;
        }

        public final boolean isNull() {
            for (int i = 0; i < 8; i++) {
                if (this.strengths[i] != 0.0f) {
                    return false;
                }
            }
            return true;
        }

        public int compareTo(Object obj) {
            return this.variableId - ((GoalVariable) obj).variableId;
        }
    }

    static class RowVariable {
        float value;
        int variableId;

        RowVariable() {
        }
    }

    public void clear() {
        int size = this.goals.size();
        if (size > 0) {
            for (int i = 0; i < size; i++) {
                this.mCache.goalVariablePool.release(this.goals.get(i));
            }
        }
        this.goals.clear();
        this.keyedGoals.clear();
        this.constantValue = 0.0f;
    }

    public PriorityGoalRow(Cache cache) {
        super(cache);
        this.mCache = cache;
    }

    public SolverVariable getPivotCandidate(LinearSystem linearSystem, boolean[] zArr) {
        sCache = this.mCache;
        int size = this.goals.size();
        GoalVariable goalVariable = null;
        for (int i = 0; i < size; i++) {
            GoalVariable goalVariable2 = this.goals.get(i);
            if (!zArr[goalVariable2.variableId]) {
                if (goalVariable == null) {
                    if (!goalVariable2.isNegative()) {
                    }
                } else if (!goalVariable2.isSmallerThan(goalVariable)) {
                }
                goalVariable = goalVariable2;
            }
        }
        if (goalVariable == null) {
            return null;
        }
        return this.mCache.mIndexedVariables[goalVariable.variableId];
    }

    public void addError(SolverVariable solverVariable) {
        GoalVariable acquire = this.mCache.goalVariablePool.acquire();
        if (acquire == null) {
            acquire = new GoalVariable();
        } else {
            acquire.reset();
        }
        acquire.strengths[solverVariable.strength] = 1.0f;
        acquire.variableId = solverVariable.id;
        this.goals.add(acquire);
        this.keyedGoals.put(Integer.valueOf(acquire.variableId), acquire);
        solverVariable.addToRow(this);
    }

    /* access modifiers changed from: package-private */
    public final GoalVariable create(GoalVariable goalVariable, SolverVariable solverVariable, float f) {
        GoalVariable goalVariable2 = new GoalVariable();
        for (int i = 0; i < 8; i++) {
            float f2 = goalVariable.strengths[i];
            float f3 = 0.0f;
            if (f2 != 0.0f) {
                float f4 = f2 * f;
                if (Math.abs(f4) >= 1.0E-4f) {
                    f3 = f4;
                }
                goalVariable2.strengths[i] = f3;
            }
        }
        goalVariable2.variableId = solverVariable.id;
        return goalVariable2;
    }

    public void updateFromRow(ArrayRow arrayRow, boolean z) {
        GoalVariable goalVariable = this.keyedGoals.get(Integer.valueOf(arrayRow.variable.id));
        if (goalVariable != null) {
            this.goals.remove(goalVariable);
            this.keyedGoals.remove(Integer.valueOf(goalVariable.variableId));
            this.mCache.goalVariablePool.release(goalVariable);
            int head = arrayRow.variables.getHead();
            int currentSize = arrayRow.variables.getCurrentSize();
            while (head != -1 && currentSize > 0) {
                head = arrayRow.variables.getVariable(sRowVariable, head);
                RowVariable rowVariable = sRowVariable;
                GoalVariable find = find(rowVariable.variableId);
                float f = rowVariable.value;
                SolverVariable solverVariable = this.mCache.mIndexedVariables[rowVariable.variableId];
                if (find == null) {
                    GoalVariable create = create(goalVariable, solverVariable, f);
                    this.goals.add(create);
                    this.keyedGoals.put(Integer.valueOf(create.variableId), create);
                    solverVariable.addToRow(this);
                } else {
                    find.add(create(goalVariable, solverVariable, f));
                    if (find.isNull()) {
                        this.goals.remove(find);
                        this.keyedGoals.remove(Integer.valueOf(find.variableId));
                        this.mCache.goalVariablePool.release(find);
                        solverVariable.removeFromRow(this);
                    }
                }
                this.constantValue += arrayRow.constantValue * f;
            }
        }
    }

    /* access modifiers changed from: package-private */
    public final GoalVariable find(int i) {
        return this.keyedGoals.get(Integer.valueOf(i));
    }

    public String toString() {
        Collections.sort(this.goals);
        String str = "" + " goal -> (" + this.constantValue + ") : ";
        Iterator<GoalVariable> it = this.goals.iterator();
        while (it.hasNext()) {
            str = str + it.next().toString(this.mCache) + " ";
        }
        return str;
    }
}
