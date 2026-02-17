package androidx.constraintlayout.solver;

import androidx.constraintlayout.solver.Pools;
import androidx.constraintlayout.solver.PriorityGoalRow;

public class Cache {
    Pools.Pool<ArrayRow> arrayRowPool = new Pools.SimplePool(256);
    Pools.Pool<PriorityGoalRow.GoalVariable> goalVariablePool = new Pools.SimplePool(64);
    SolverVariable[] mIndexedVariables = new SolverVariable[32];
    Pools.Pool<SolverVariable> solverVariablePool = new Pools.SimplePool(256);
}
