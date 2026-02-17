package com.google.android.material.animation;

import android.graphics.Matrix;
import android.util.Property;
import android.widget.ImageView;
import androidx.annotation.NonNull;

public class ImageMatrixProperty extends Property<ImageView, Matrix> {
    private final Matrix matrix = new Matrix();

    public ImageMatrixProperty() {
        super(Matrix.class, "imageMatrixProperty");
    }

    public void set(@NonNull ImageView imageView, @NonNull Matrix matrix2) {
        imageView.setImageMatrix(matrix2);
    }

    @NonNull
    public Matrix get(@NonNull ImageView imageView) {
        this.matrix.set(imageView.getImageMatrix());
        return this.matrix;
    }
}
