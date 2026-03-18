package com.example.dmrmodhooks.sstv;

/**
 * Efficient moving sum using binary tree structure
 * O(log N) update time instead of O(N)
 * Based on robot36-2 implementation by Ahmet Inan
 */
public class SSTVSimpleMovingSum {
    private final float[] tree;
    private int leaf;
    public final int length;

    public SSTVSimpleMovingSum(int length) {
        this.length = length;
        this.tree = new float[2 * length];
        this.leaf = length;
    }

    public void add(float input) {
        tree[leaf] = input;
        // Update tree from leaf to root
        for (int child = leaf, parent = leaf / 2; parent > 0; child = parent, parent /= 2) {
            tree[parent] = tree[child] + tree[child ^ 1];
        }
        if (++leaf >= tree.length) {
            leaf = length;
        }
    }

    public float sum() {
        return tree[1];
    }

    public float sum(float input) {
        add(input);
        return sum();
    }
}
