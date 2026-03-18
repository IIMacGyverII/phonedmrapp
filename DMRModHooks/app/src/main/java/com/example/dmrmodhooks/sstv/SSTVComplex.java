package com.example.dmrmodhooks.sstv;

/**
 * Complex number arithmetic for IQ demodulation
 * Based on robot36-2 implementation by Ahmet Inan
 */
public class SSTVComplex {
    public float real;
    public float imag;

    public SSTVComplex() {
        this.real = 0;
        this.imag = 0;
    }

    public SSTVComplex(float real, float imag) {
        this.real = real;
        this.imag = imag;
    }

    public SSTVComplex set(float real, float imag) {
        this.real = real;
        this.imag = imag;
        return this;
    }

    public SSTVComplex set(float real) {
        return set(real, 0);
    }

    public SSTVComplex set(SSTVComplex other) {
        this.real = other.real;
        this.imag = other.imag;
        return this;
    }

    public float norm() {
        return real * real + imag * imag;
    }

    public float abs() {
        return (float) Math.sqrt(norm());
    }

    public float arg() {
        return (float) Math.atan2(imag, real);
    }

    public SSTVComplex polar(float magnitude, float angle) {
        real = magnitude * (float) Math.cos(angle);
        imag = magnitude * (float) Math.sin(angle);
        return this;
    }

    public SSTVComplex conj() {
        imag = -imag;
        return this;
    }

    public SSTVComplex add(SSTVComplex other) {
        real += other.real;
        imag += other.imag;
        return this;
    }

    public SSTVComplex sub(SSTVComplex other) {
        real -= other.real;
        imag -= other.imag;
        return this;
    }

    public SSTVComplex mul(float value) {
        real *= value;
        imag *= value;
        return this;
    }

    public SSTVComplex mul(SSTVComplex other) {
        float tmp = real * other.real - imag * other.imag;
        imag = real * other.imag + imag * other.real;
        real = tmp;
        return this;
    }

    public SSTVComplex div(float value) {
        real /= value;
        imag /= value;
        return this;
    }

    public SSTVComplex div(SSTVComplex other) {
        float den = other.norm();
        float tmp = (real * other.real + imag * other.imag) / den;
        imag = (imag * other.real - real * other.imag) / den;
        real = tmp;
        return this;
    }
}
