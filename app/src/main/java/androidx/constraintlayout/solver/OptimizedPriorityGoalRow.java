package androidx.constraintlayout.solver;

import java.util.Arrays;
import java.util.Comparator;

public class OptimizedPriorityGoalRow extends ArrayRow {
    private static final boolean DEBUG = false;
    static final int NOT_FOUND = -1;
    private static final float epsilon = 1.0E-4f;
    private int TABLE_SIZE = 128;
    GoalVariableAccessor accessor = new GoalVariableAccessor(this);
    /* access modifiers changed from: private */
    public SolverVariable[] arrayGoals = new SolverVariable[128];
    Cache mCache;
    /* access modifiers changed from: private */
    public int numGoals = 0;
    private SolverVariable[] sortArray = new SolverVariable[128];

    class GoalVariableAccessor implements Comparable {
        OptimizedPriorityGoalRow row;
        SolverVariable variable;

        public GoalVariableAccessor(OptimizedPriorityGoalRow optimizedPriorityGoalRow) {
            this.row = optimizedPriorityGoalRow;
        }

        public void init(SolverVariable solverVariable) {
            this.variable = solverVariable;
        }

        private final boolean alreadyInGoal() {
            for (int i = 0; i < OptimizedPriorityGoalRow.this.numGoals; i++) {
                if (OptimizedPriorityGoalRow.this.arrayGoals[i] == this.variable) {
                    return true;
                }
            }
            return false;
        }

        public boolean addToGoal(SolverVariable solverVariable, float f) {
            boolean z = true;
            if (this.variable.inGoal) {
                for (int i = 0; i < 8; i++) {
                    float[] fArr = this.variable.goalStrengthVector;
                    float f2 = fArr[i] + (solverVariable.goalStrengthVector[i] * f);
                    fArr[i] = f2;
                    if (Math.abs(f2) < 1.0E-4f) {
                        this.variable.goalStrengthVector[i] = 0.0f;
                    } else {
                        z = false;
                    }
                }
                if (z) {
                    OptimizedPriorityGoalRow.this.removeGoal(this.variable);
                }
                return false;
            }
            for (int i2 = 0; i2 < 8; i2++) {
                float f3 = solverVariable.goalStrengthVector[i2];
                if (f3 != 0.0f) {
                    float f4 = f3 * f;
                    if (Math.abs(f4) < 1.0E-4f) {
                        f4 = 0.0f;
                    }
                    this.variable.goalStrengthVector[i2] = f4;
                } else {
                    this.variable.goalStrengthVector[i2] = 0.0f;
                }
            }
            return true;
        }

        public void add(SolverVariable solverVariable) {
            for (int i = 0; i < 8; i++) {
                float[] fArr = this.variable.goalStrengthVector;
                float f = fArr[i] + solverVariable.goalStrengthVector[i];
                fArr[i] = f;
                if (Math.abs(f) < 1.0E-4f) {
                    this.variable.goalStrengthVector[i] = 0.0f;
                }
            }
        }

        public final boolean isNegative() {
            for (int i = 7; i >= 0; i--) {
                float f = this.variable.goalStrengthVector[i];
                if (f > 0.0f) {
                    return false;
                }
                if (f < 0.0f) {
                    return true;
                }
            }
            return false;
        }

        public final boolean isSmallerThan(SolverVariable solverVariable) {
            int i = 7;
            while (true) {
                if (i < 0) {
                    break;
                }
                float f = solverVariable.goalStrengthVector[i];
                float f2 = this.variable.goalStrengthVector[i];
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
                if (this.variable.goalStrengthVector[i] != 0.0f) {
                    return false;
                }
            }
            return true;
        }

        public int compareTo(Object obj) {
            return this.variable.id - ((SolverVariable) obj).id;
        }

        public void reset() {
            Arrays.fill(this.variable.goalStrengthVector, 0.0f);
        }

        public String toString() {
            String str = "[ ";
            if (this.variable != null) {
                for (int i = 0; i < 8; i++) {
                    str = str + this.variable.goalStrengthVector[i] + " ";
                }
            }
            return str + "] " + this.variable;
        }
    }

    public void clear() {
        this.numGoals = 0;
        this.constantValue = 0.0f;
    }

    public OptimizedPriorityGoalRow(Cache cache) {
        super(cache);
        this.mCache = cache;
    }

    public SolverVariable getPivotCandidate(LinearSystem linearSystem, boolean[] zArr) {
        int i = -1;
        for (int i2 = 0; i2 < this.numGoals; i2++) {
            SolverVariable solverVariable = this.arrayGoals[i2];
            if (!zArr[solverVariable.id]) {
                this.accessor.init(solverVariable);
                if (i == -1) {
                    if (!this.accessor.isNegative()) {
                    }
                } else if (!this.accessor.isSmallerThan(this.arrayGoals[i])) {
                }
                i = i2;
            }
        }
        if (i == -1) {
            return null;
        }
        return this.arrayGoals[i];
    }

    public void addError(SolverVariable solverVariable) {
        this.accessor.init(solverVariable);
        this.accessor.reset();
        solverVariable.goalStrengthVector[solverVariable.strength] = 1.0f;
        addToGoal(solverVariable);
    }

    private final void addToGoal(SolverVariable solverVariable) {
        int i;
        int i2 = this.numGoals + 1;
        SolverVariable[] solverVariableArr = this.arrayGoals;
        if (i2 > solverVariableArr.length) {
            SolverVariable[] solverVariableArr2 = (SolverVariable[]) Arrays.copyOf(solverVariableArr, solverVariableArr.length * 2);
            this.arrayGoals = solverVariableArr2;
            this.sortArray = (SolverVariable[]) Arrays.copyOf(solverVariableArr2, solverVariableArr2.length * 2);
        }
        SolverVariable[] solverVariableArr3 = this.arrayGoals;
        int i3 = this.numGoals;
        solverVariableArr3[i3] = solverVariable;
        int i4 = i3 + 1;
        this.numGoals = i4;
        if (i4 > 1 && solverVariableArr3[i4 - 1].id > solverVariable.id) {
            int i5 = 0;
            while (true) {
                i = this.numGoals;
                if (i5 >= i) {
                    break;
                }
                this.sortArray[i5] = this.arrayGoals[i5];
                i5++;
            }
            Arrays.sort(this.sortArray, 0, i, new Comparator<SolverVariable>() {
                public int compare(SolverVariable solverVariable, SolverVariable solverVariable2) {
                    return solverVariable.id - solverVariable2.id;
                }
            });
            for (int i6 = 0; i6 < this.numGoals; i6++) {
                this.arrayGoals[i6] = this.sortArray[i6];
            }
        }
        solverVariable.inGoal = true;
        solverVariable.addToRow(this);
    }

    /* access modifiers changed from: private */
    public final void removeGoal(SolverVariable solverVariable) {
        int i = 0;
        while (i < this.numGoals) {
            if (this.arrayGoals[i] == solverVariable) {
                while (true) {
                    int i2 = this.numGoals;
                    if (i < i2 - 1) {
                        SolverVariable[] solverVariableArr = this.arrayGoals;
                        int i3 = i + 1;
                        solverVariableArr[i] = solverVariableArr[i3];
                        i = i3;
                    } else {
                        this.numGoals = i2 - 1;
                        solverVariable.inGoal = false;
                        return;
                    }
                }
            } else {
                i++;
            }
        }
    }

    public void updateFromRow(ArrayRow arrayRow, boolean z) {
        SolverVariable solverVariable = arrayRow.variable;
        if (solverVariable != null) {
            int head = arrayRow.variables.getHead();
            int currentSize = arrayRow.variables.getCurrentSize();
            while (head != -1 && currentSize > 0) {
                int id = arrayRow.variables.getId(head);
                float value = arrayRow.variables.getValue(head);
                SolverVariable solverVariable2 = this.mCache.mIndexedVariables[id];
                this.accessor.init(solverVariable2);
                if (this.accessor.addToGoal(solverVariable, value)) {
                    addToGoal(solverVariable2);
                }
                this.constantValue += arrayRow.constantValue * value;
                head = arrayRow.variables.getNextIndice(head);
            }
            removeGoal(solverVariable);
        }
    }

    public String toString() {
        String str = "" + " goal -> (" + this.constantValue + ") : ";
        for (int i = 0; i < this.numGoals; i++) {
            this.accessor.init(this.arrayGoals[i]);
            str = str + this.accessor + " ";
        }
        return str;
    }
}
